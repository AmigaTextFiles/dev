#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>

struct sym {
  struct sym *next;
  char *name;
  long offset;
};

struct sym *head = NULL;

char *texthunk;
char *datahunk;
long texthunksize;
long datahunksize;
long *textrelocs;
long *datarelocs;
long textrelocsinhunk;
long datarelocsinhunk;

long reloc_table_size = 0;
char transfer_buf[10240];
int pad = 0;
int is_lib = 0;
int is_baserel = 0;

static unsigned long hash(char *s)
{
  unsigned long h = 0, g;

  while (*s)
  {
    h = (h << 4) + *s++;
    if (g = h & 0xf0000000)
      h ^= g >> 24;
      h &= ~g;
  }
  return h;
}

static void insert_sym(char *name, long offset)
{
  struct sym *s = malloc(sizeof(struct sym) + strlen(name) + 1), *t;
  struct sym *cur, *prev;

  s->name = (char *)&s[1];
  s->offset = offset;
  s->next = 0;
  if (head == NULL)
    head = s;
  else if (head->offset > offset)
  {
    s->next = head;
    head = s;
  }
  else
  {
    for (prev = head, t = head->next; t && t->offset < offset; prev = t, t = t->next);
    prev->next = s;
    s->next = t;
  }
  memcpy(s->name, name, strlen(name) + 1);
}

static unsigned long get_num(int fd)
{
  unsigned long t;
  
  read(fd, &t, 4);
  return t;
}

static unsigned long put_num(int fd, unsigned long l)
{
  write(fd, &l, 4);
  return l;
}

static unsigned long rw_num(int in, int out)
{
  unsigned long t;
  
  read(in, &t, 4);
  write(out, &t, 4);
  return t;
}

static void rw_num3(int in, int out, int cnt)
{
  while (cnt--)
    rw_num(in, out);
}

static void skip(int fd, unsigned long t)
{
  lseek(fd, t * 4, SEEK_CUR);
}

static char *amiga_buf;
static int amiga_bufsize, amiga_bufptr, amiga_desc, amiga_read;

static void amiga_buf_init(int desc)
{
  amiga_desc = desc;
  if (amiga_buf == NULL)
  {
    amiga_bufsize = 10240;
    amiga_buf = (char *)malloc(amiga_bufsize);
  }
  amiga_read = read(amiga_desc, amiga_buf, amiga_bufsize);
  amiga_bufptr = 0;
}

static unsigned long fget_num(void)
{
  if (amiga_bufptr == amiga_bufsize)
  {
    amiga_read = read(amiga_desc, amiga_buf, amiga_bufsize);
    amiga_bufptr = 0;
  }
  amiga_bufptr += 4;
  return *((long *)(amiga_buf + amiga_bufptr - 4));
}

static void fread_string(char *buf, int size)
{
  while (amiga_bufptr + size > amiga_bufsize)
  {
    int diff = amiga_bufsize - amiga_bufptr;

    memcpy(buf, amiga_buf + amiga_bufptr, diff);
    buf += diff;
    size -= diff;
    amiga_read = read(amiga_desc, amiga_buf, amiga_bufsize);
    amiga_bufptr = 0;
  }
  memcpy(buf, amiga_buf + amiga_bufptr, size);
  amiga_bufptr += size;
}

static void amiga_buf_term(void)
{
  lseek(amiga_desc, amiga_bufptr - amiga_read, SEEK_CUR);
}

static void
amiga_read_file_symbols (desc)
register int desc;
{
  int t, f, l;
  int start, type, sdata, sbss;
  int name_size = 500;
  int cur_hunk = 0;
  char *name;

  if (get_num(desc) != 0x03f3)
    exit(20);
  name = (char *)malloc(name_size);
  while (t = get_num(desc))
    skip(desc, t);
  get_num(desc);
  f = get_num(desc);
  l = get_num(desc);
  skip(desc, l - f + 1);
  while (l >= 0)
  {
    switch (get_num(desc) & 0xffff)
    {
      case 0x03e9:      /* text */
        cur_hunk = 0;
        texthunksize = get_num(desc);
        texthunk = malloc(4 * texthunksize);
        read(desc, texthunk, 4 * texthunksize);
        break;
      case 0x03ea:      /* data */
        cur_hunk = 1;
        datahunksize = get_num(desc);
        datahunk = malloc(4 * datahunksize);
        read(desc, datahunk, 4 * datahunksize);
        break;
      case 0x03eb:      /* bss */
        cur_hunk = 2;
        sbss = get_num(desc) * 4;
        break;
      case 0x03e8:      /* name  */
      case 0x03e7:      /* unit  */
      case 0x03f1:      /* debug */
        skip(desc, get_num(desc));
        break;
      case 0x03ee:      /* reloc8  */
      case 0x03ed:      /* reloc16 */
      case 0x03ec:      /* reloc32 */
        while (t = get_num(desc))
        {
          int hunk = get_num(desc);

	  if ((!is_lib && cur_hunk < 2 && hunk == 2) ||
	      (is_lib && hunk == 1))
          {
            if (cur_hunk == 0)
            {
              textrelocsinhunk = t;
              textrelocs = malloc(t * 4);
              read(desc, textrelocs, 4 * t);
            }
            else
            {
              datarelocsinhunk = t;
              datarelocs = malloc(t * 4);
              read(desc, datarelocs, 4 * t);
            }
          }
          else
          {
            skip(desc, t);
          }
        }
        break;
      case 0x03ef:      /* ext */
        while (t = get_num(desc))
          skip(desc, (t & 0xffffff) + 1);
        break;
      case 0x03f0:      /* symbols */
        amiga_buf_init(desc);
        while (t = fget_num())
        {
          int offset;

          while (t >= name_size)
          {
            char *buf = (char *)malloc(name_size * 2);
            
            free(name);
            name = buf;
            name_size *= 2;
          }
          fread_string(name, t * 4);
          name[t * 4] = 0;
          offset = fget_num();
          if (cur_hunk == (is_lib ? 1 : 2))
            insert_sym(name, offset);
        }
        amiga_buf_term();
        break;
      case 0x03f2:      /* end */
        l--;
        break;
    }
  }
  free(name);
  if (amiga_buf)
    free(amiga_buf);
  amiga_buf = NULL;
}

struct reloc_sym {
  struct reloc_sym *next;
  char *name;
  int bufsize, offsets;
  long *bufaddrs;
  long *bufoffsets;
};

struct lib {
  struct lib *next;
  char name[108];
  long start_funcs, end_funcs;
  long start_data, end_data;
  long start_reloc[4];
  long cnt[4];
  struct reloc_sym *relocs[4];
};

struct lib *libs = NULL;

#define START_TFUNCS 0
#define START_DFUNCS 1
#define END_TFUNCS   2
#define END_DFUNCS   3
#define START_TDATA  4
#define START_DDATA  5
#define END_TDATA    6
#define END_DDATA    7

#define TFUNCS 0
#define DFUNCS 1
#define TDATA  2
#define DDATA  3

long check_label(char *label, long offset)
{
  int i;

  for (i = 0; i < textrelocsinhunk; i++)
    if (*((long *)(texthunk + textrelocs[i])) == offset)
      return textrelocs[i];

  fprintf(stderr, "Cannot find reference to %s\n", label);
  exit(2);
}

void set_lib(struct lib *l, char *name, int type, long offset)
{
  int i;

  switch (type)
  {
    case START_TFUNCS:
      l->start_funcs = offset + 4;
      l->start_reloc[TFUNCS] = check_label(name, offset);
      break;
    case START_DFUNCS:
      l->start_funcs = offset + 2;
      l->start_reloc[DFUNCS] = check_label(name, offset);
      break;
    case END_TFUNCS:
    case END_DFUNCS:
      l->end_funcs = offset;
      return;
    case START_TDATA:
      l->start_data = offset + 4;
      l->start_reloc[TDATA] = check_label(name, offset);
      break;
    case START_DDATA:
      l->start_data = offset + 2;
      l->start_reloc[DDATA] = check_label(name, offset);
      break;
    case END_TDATA:
    case END_DDATA:
      l->end_data = offset;
      return;
  }
}

void add_lib(char *name, int len, int type, long offset)
{
  struct lib *l;
  
  for (l = libs; l; l = l->next)
    if (!strcmp(name + len, l->name))
    {
      set_lib(l, name, type, offset);
      return;
    }
  l = malloc(sizeof(struct lib));
  memset(l, 0, sizeof(struct lib));
  strcpy(l->name, name + len);
  set_lib(l, name, type, offset);
  l->next = libs;
  libs = l;
}

struct reloc_sym *new_reloc_sym(struct lib *l, char *name, int type)
{
   struct reloc_sym *rs = malloc(sizeof(struct reloc_sym)), *prev, *t;
   struct reloc_sym **prs;

   l->cnt[type]++;
   rs->name = name;
   rs->next = NULL;
   rs->bufsize = 10;
   rs->bufaddrs = malloc(40);
   rs->bufoffsets = malloc(40);
   rs->offsets = 0;
   prs = &l->relocs[type];
   if (!*prs)
   {
     *prs = rs;
     return rs;
   }
   if (strcmp(name, (*prs)->name) < 0)
   {
     rs->next = *prs;
     *prs = rs;
     return rs;
   }
   for (prev = *prs, t = (*prs)->next; t && strcmp(name, t->name) > 0; prev = t, t = t->next);
   prev->next = rs;
   rs->next = t;
   return rs;
}

void add_reloc_sym(struct reloc_sym *rs, long addr, long offset)
{
  if (rs->offsets == rs->bufsize)
  {
    rs->bufsize *= 2;
    rs->bufoffsets = realloc(rs->bufoffsets, rs->bufsize * 4);
    rs->bufaddrs = realloc(rs->bufaddrs, rs->bufsize * 4);
  }
  rs->bufoffsets[rs->offsets] = offset;
  rs->bufaddrs[rs->offsets++] = addr;
}

void scan_relocs(struct lib *l, struct sym *s, int type)
{
  long x1, x2, i;
  struct reloc_sym *rs;

  x1 = s->offset;
  x2 = s->next->offset;

  for (rs = NULL, i = 0; i < textrelocsinhunk; i++)
  {
    int offset = *((long *)(texthunk + textrelocs[i]));

    if (offset >= x1 && offset < x2)
    {
      if (!rs)
        rs = new_reloc_sym(l, s->name, type);
      add_reloc_sym(rs, textrelocs[i], offset - x1);
    }
  }
  type++;
  for (rs = NULL, i = 0; i < datarelocsinhunk; i++)
  {
    int offset = *((long *)(datahunk + datarelocs[i]));

    if (offset >= x1 && offset < x2)
    {
      if (!rs)
        rs = new_reloc_sym(l, s->name, type);
      add_reloc_sym(rs, datarelocs[i], offset - x1);
    }
  }
}

void find_relocs(struct lib *l)
{
  struct sym *s;

  for (s = head; s; s = s->next)
  {
    if (s->offset >= l->start_funcs && s->offset < l->end_funcs)
      scan_relocs(l, s, TFUNCS);
    else if (s->offset >= l->start_data && s->offset < l->end_data)
      scan_relocs(l, s, TDATA);
  }
}

int determine_size(struct lib *l, int type)
{
  struct reloc_sym *rs = l->relocs[type];

  *((long *)(texthunk + l->start_reloc[type])) = reloc_table_size;
  reloc_table_size += 4; /* entries in this table */
  if (rs && is_lib && type == TDATA)
  {
    fprintf(stderr, "References to data in lib%s.ixlibrary in your text hunk are\n"
		    "not supported! It concerns the following symbols:\n\n", l->name);
    while (rs)
    {
      fprintf(stderr, "%s\n", rs->name);
      rs = rs->next;
    }
    fprintf(stderr, "\n");
    return 1;
  }
  while (rs)
  {
    reloc_table_size += 6 + 8 * rs->offsets; /* hash + #entries + addrs + offsets */
    rs = rs->next;
  }
  return 0;
}

struct {
  char *name;
  int len, type;
} funclist[] = {
  { "__shared_textfunctions_start_lib", 32, START_TFUNCS },
  { "__shared_textfunctions_end_lib", 30, END_TFUNCS },
  { "__shared_datafunctions_start_lib", 32, START_DFUNCS },
  { "__shared_datafunctions_end_lib", 30, END_DFUNCS },
  { "__shared_datadata_start_lib", 27, START_DDATA },
  { "__shared_datadata_end_lib", 25, END_DDATA },
  { "__shared_textdata_start_lib", 27, START_TDATA },
  { "__shared_textdata_end_lib", 25, END_TDATA }
};  

void process(void)
{
  struct sym *s;
  struct lib *l;
  long min, max, i, error = 0;

  for (s = head; s; s = s->next)
  {
    for (i = 0; i < (is_lib ? 6 : 8); i++)
      if (!memcmp(s->name, funclist[i].name, funclist[i].len))
      {
        add_lib(s->name, funclist[i].len, funclist[i].type, s->offset);
        break;
      }
  }

  for (l = libs; l; l = l->next)
    find_relocs(l);
  for (l = libs; l; l = l->next)
  {
    error += determine_size(l, TFUNCS);
    error += determine_size(l, DFUNCS);
    error += determine_size(l, TDATA);
    error += determine_size(l, DDATA);
  }
  if (error)
    exit(2);
  pad = (reloc_table_size & 3);
}

void write_table(int out, struct lib *l, int type)
{
  struct reloc_sym *rs = l->relocs[type];

  put_num(out, l->cnt[type]);

  while (rs)
  {
    short num = rs->offsets;

    put_num(out, hash(rs->name + 1));
    write(out, &num, 2);
    write(out, rs->bufaddrs, num * 4);
    write(out, rs->bufoffsets, num * 4);
    rs = rs->next;
  }
}

void fixup(int in, int out)
{
  int t, lh;
  struct lib *l;

  rw_num(in, out);
  while (t = rw_num(in, out)) ;
  rw_num(in, out);
  rw_num(in, out);
  lh = rw_num(in, out);
  put_num(out, get_num(in) + (reloc_table_size + pad) / 4);
  while (lh--)
    rw_num(in, out);

  if ((rw_num(in, out) & 0xffff) != 0x03e9) /* text */
  {
    fprintf(stderr, "exe didn't start with text hunk!\n");
    exit(2);
  }
  put_num(out, texthunksize + (reloc_table_size + pad) / 4);
  write(out, texthunk, 4 * texthunksize);
  for (l = libs; l; l = l->next)
  {
    write_table(out, l, TFUNCS);
    write_table(out, l, DFUNCS);
    write_table(out, l, TDATA);
    write_table(out, l, DDATA);
  }
  if (pad)
    write(out, &l, 2);
  skip(in, texthunksize + 1);
  while (t = read(in, transfer_buf, sizeof(transfer_buf)))
    write(out, transfer_buf, t);
}

main(int argc, char **argv)
{
  int fd, fnew;

  while (argv[1])
  {
    if (!strcmp(argv[1], "-library"))
    {
      argv++;
      is_lib = 1;
      continue;
    }
    if (!strcmp(argv[1], "-baserel"))
    {
      argv++;
      is_baserel = 1;
      fprintf(stderr, "postlink does not support base-relative programs!\n");
      exit(1);
    }
    break;
  }
  if (argv[1])
  {
    fd = open(argv[1], O_RDONLY);
    amiga_read_file_symbols(fd);
    process();
    close(fd);
    if (libs)
    {
      char buf[strlen(argv[1]) + 5];	/* uses gcc extension */

      sprintf(buf, "%s.tmp", argv[1]);
      fd = open(argv[1], O_RDONLY);
      fnew = open(buf, O_WRONLY|O_CREAT|O_TRUNC, 0777);
      fixup(fd, fnew);
      close(fnew);
      close(fd);
      unlink(argv[1]);
      if (rename(buf, argv[1]))
      {
        fprintf(stderr, "couldn't rename %s to %s\n", buf, argv[1]);
        exit(2);
      }
    }
  }
}
