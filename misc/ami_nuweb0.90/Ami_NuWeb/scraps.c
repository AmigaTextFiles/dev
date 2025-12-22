#include "global.h"
#define SLAB_SIZE 500

typedef struct slab {
  struct slab *next;
  char chars[SLAB_SIZE];
} Slab;
typedef struct {
  char *file_name;
  int file_line;
  int page;
  char letter;
  Slab *slab;
} ScrapEntry;
static ScrapEntry *SCRAP[256];

#define scrap_array(i) SCRAP[(i) >> 8][(i) & 255]

static int scraps;
void init_scraps(void)
{
  scraps = 1;
  SCRAP[0] = (ScrapEntry *) arena_getmem(256 * sizeof(ScrapEntry));
}
void write_scrap_ref(FILE *file, int num, int first, int *page)
{
  if (scrap_array(num).page >= 0) {
    if (first)
      fprintf(file, "%d", scrap_array(num).page);
    else if (scrap_array(num).page != *page)
      fprintf(file, ", %d", scrap_array(num).page);
    if (scrap_array(num).letter > 0)
      fputc(scrap_array(num).letter, file);
  }
  else {
    if (first)
      putc('?', file);
    else
      fputs(", ?", file);
    {
  if (!already_warned) {
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_WARNING_45C),
#else
    fprintf(stderr, "%s: you'll need to rerun nuweb after running latex\n",
#endif
            command_name);
    already_warned = TRUE;
  }
}
  }
  *page = scrap_array(num).page;
}
void write_single_scrap_ref(FILE *file, int num)
{
  int page;
  write_scrap_ref(file, num, TRUE, &page);
}
typedef struct {
  Slab *scrap;
  Slab *prev;
  int index;
} Manager;
static void push(char c, Manager *manager)
{
  Slab *scrap = manager->scrap;
  int index = manager->index;
  scrap->chars[index++] = c;
  if (index == SLAB_SIZE) {
    Slab *new = (Slab *) arena_getmem(sizeof(Slab));
    scrap->next = new;
    manager->scrap = new;
    index = 0;
  }
  manager->index = index;
}
static void pushs(char *s, Manager *manager)
{
  while (*s)
    push(*s++, manager);
}
int collect_scrap(void)
{
  Manager writer;
  {
  Slab *scrap = (Slab *) arena_getmem(sizeof(Slab));
  if ((scraps & 255) == 0)
    SCRAP[scraps >> 8] = (ScrapEntry *) arena_getmem(256 * sizeof(ScrapEntry));
  scrap_array(scraps).slab = scrap;
  scrap_array(scraps).file_name = save_string(source_name);
  scrap_array(scraps).file_line = source_line;
  scrap_array(scraps).page = -1;
  scrap_array(scraps).letter = 0;
  writer.scrap = scrap;
  writer.index = 0;
}
  {
  int c = source_get();
  while (1) {
    switch (c) {
#ifdef _AMIGA
      case EOF: fprintf(stderr, get_string(MSG_ERROR_47B),
                        command_name, scrap_array(scraps).file_name,
                        scrap_array(scraps).file_line);
#else
      case EOF: fprintf(stderr, "%s: unexpect EOF in scrap (%s, %d)\n",
                        command_name, scrap_array(scraps).file_name,
                        scrap_array(scraps).file_line);
#endif
                exit(EXIT_FAILURE);
      case '@': {
  c = source_get();
  switch (c) {
    case '@': pushs("@@", &writer);
              c = source_get();
              break;
    case '|': {
  do {
    char new_name[100];
    char *p = new_name;
    do
      c = source_get();
    while (isspace(c));
    if (c != '@') {
      Name *name;
      do {
        *p++ = c;
        c = source_get();
      } while (c != '@' && !isspace(c));
      *p = '\0';
      name = name_add(&user_names, new_name);
      if (!name->defs || name->defs->scrap != scraps) {
        Scrap_Node *def = (Scrap_Node *) arena_getmem(sizeof(Scrap_Node));
        def->scrap = scraps;
        def->next = name->defs;
        name->defs = def;
      }
    }
  } while (c != '@');
  c = source_get();
  if (c != '}' && c != ']' && c != ')' ) {
    fprintf(stderr, "%s: unexpected @%c in scrap (%s, %d)\n",
            command_name, c, source_name, source_line);
    exit(EXIT_FAILURE);
  }
}
    case ')':
    case ']':
    case '}': push('\0', &writer);
              return scraps++;
    case '<': {
  Name *name = collect_scrap_name();
  {
  char *s = name->spelling;
  int len = strlen(s) - 1;
  pushs("@<", &writer);
  while (len > 0) {
    push(*s++, &writer);
    len--;
  }
  if (*s == ' ')
    pushs("...", &writer);
  else
    push(*s, &writer);
  pushs("@>", &writer);
}
  {
  if (!name->uses || name->uses->scrap != scraps) {
    Scrap_Node *use = (Scrap_Node *) arena_getmem(sizeof(Scrap_Node));
    use->scrap = scraps;
    use->next = name->uses;
    name->uses = use;
  }
}
  c = source_get();
}
              break;
#ifdef _AMIGA
    default : fprintf(stderr, get_string(MSG_ERROR_47C),
                      command_name, c, source_name, source_line);
#else
    default : fprintf(stderr, "%s: unexpected @%c in scrap (%s, %d)\n",
                      command_name, c, source_name, source_line);
#endif
              exit(EXIT_FAILURE);
  }
}
                break;
      default:  push(c, &writer);
                c = source_get();
                break;
    }
  }
}
}
static char pop(Manager *manager)
{
  Slab *scrap = manager->scrap;
  int index = manager->index;
  char c = scrap->chars[index++];
  if (index == SLAB_SIZE) {
    manager->prev = scrap;
    manager->scrap = scrap->next;
    index = 0;
  }
  manager->index = index;
  return c;
}
static Name *pop_scrap_name(Manager *manager)
{
  char name[100];
  char *p = name;
  int c = pop(manager);
  while (TRUE) {
    if (c == '@')
      {
  c = pop(manager);
  if (c == '@') {
    *p++ = c;
    c = pop(manager);
  }
  else if (c == '>') {
    if (p - name > 3 && p[-1] == '.' && p[-2] == '.' && p[-3] == '.') {
      p[-3] = ' ';
      p -= 2;
    }
    *p = '\0';
    return prefix_add(&macro_names, name);
  }
  else {
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_ERROR_50A), command_name);
#else
    fprintf(stderr, "%s: found an internal problem (1)\n", command_name);
#endif
    exit(EXIT_FAILURE);
  }
}
    else {
      *p++ = c;
      c = pop(manager);
    }
  }
}
int write_scraps(FILE *file, Scrap_Node *defs, int global_indent,
  char *indent_chars, char debug_flag, char tab_flag, char indent_flag)
{
  int indent = 0;
  while (defs) {
    {
  char c;
  Manager reader;
  int line_number = scrap_array(defs->scrap).file_line;
  if (debug_flag) {
  fprintf(file, "\n#line %d \"%s\"\n",
          line_number, scrap_array(defs->scrap).file_name);
  {
  if (indent_flag) {
    if (tab_flag)
      for (indent=0; indent<global_indent; indent++)
        putc(' ', file);
    else
      for (indent=0; indent<global_indent; indent++)
        putc(indent_chars[indent], file);
  }
  indent = 0;
}
}
  reader.scrap = scrap_array(defs->scrap).slab;
  reader.index = 0;
  c = pop(&reader);
  while (c) {
    switch (c) {
      case '@':  {
  c = pop(&reader);
  switch (c) {
    case '@': putc(c, file);
              indent_chars[global_indent + indent] = ' ';
              indent++;
              break;
    case '<': {
  Name *name = pop_scrap_name(&reader);
  if (name->mark) {
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_ERROR_52C1),
            command_name, name->spelling);
#else
    fprintf(stderr, "%s: recursive macro discovered involving <%s>\n",
            command_name, name->spelling);
#endif
    exit(EXIT_FAILURE);
  }
  if (name->defs) {
    name->mark = TRUE;
    indent = write_scraps(file, name->defs, global_indent + indent,
                          indent_chars, debug_flag, tab_flag, indent_flag);
    indent -= global_indent;
    name->mark = FALSE;
  }
  else if (!tex_flag)
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_WARNING_52C2),
#else
    fprintf(stderr, "%s: macro never defined <%s>\n",
#endif
            command_name, name->spelling);
}
              if (debug_flag) {
  fprintf(file, "\n#line %d \"%s\"\n",
          line_number, scrap_array(defs->scrap).file_name);
  {
  if (indent_flag) {
    if (tab_flag)
      for (indent=0; indent<global_indent; indent++)
        putc(' ', file);
    else
      for (indent=0; indent<global_indent; indent++)
        putc(indent_chars[indent], file);
  }
  indent = 0;
}
}
              break;
    default:  /* ignore, since we should already have a warning */
              break;
  }
}
                 break;
      case '\n': putc(c, file);
                 line_number++;
                 {
  if (indent_flag) {
    if (tab_flag)
      for (indent=0; indent<global_indent; indent++)
        putc(' ', file);
    else
      for (indent=0; indent<global_indent; indent++)
        putc(indent_chars[indent], file);
  }
  indent = 0;
}
                 break;
      case '\t': {
  if (tab_flag)
    {
  int delta = 8 - (indent % 8);
  indent += delta;
  while (delta > 0) {
    putc(' ', file);
    delta--;
  }
}
  else {
    putc('\t', file);
    indent_chars[global_indent + indent] = '\t';
    indent++;
  }
}
                 break;
      default:   putc(c, file);
                 indent_chars[global_indent + indent] = ' ';
                 indent++;
                 break;
    }
    c = pop(&reader);
  }
}
    defs = defs->next;
  }
  return indent + global_indent;
}
void collect_numbers(char *aux_name)
{
  if (number_flag) {
    int i;
    for (i=1; i<scraps; i++)
      scrap_array(i).page = i;
  }
  else {
    FILE *aux_file = fopen(aux_name, "r");
    already_warned = FALSE;
    if (aux_file) {
      char aux_line[500];
      while (fgets(aux_line, 500, aux_file)) {
        int scrap_number;
        int page_number;
        char dummy[50];
        if (3 == sscanf(aux_line, "\\newlabel{scrap%d}{%[^}]}{%d}",
                        &scrap_number, dummy, &page_number)) {
          if (scrap_number < scraps)
            scrap_array(scrap_number).page = page_number;
          else
            {
  if (!already_warned) {
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_WARNING_45C),
#else
    fprintf(stderr, "%s: you'll need to rerun nuweb after running latex\n",
#endif
            command_name);
    already_warned = TRUE;
  }
}
        }
      }
      fclose(aux_file);
      {
  int scrap;
  for (scrap=2; scrap<scraps; scrap++) {
    if (scrap_array(scrap-1).page == scrap_array(scrap).page) {
      if (!scrap_array(scrap-1).letter)
        scrap_array(scrap-1).letter = 'a';
      scrap_array(scrap).letter = scrap_array(scrap-1).letter + 1;
    }
  }
}
    }
  }
}
typedef struct name_node {
  struct name_node *next;
  Name *name;
} Name_Node;
typedef struct goto_node {
  Name_Node *output;            /* list of words ending in this state */
  struct move_node *moves;      /* list of possible moves */
  struct goto_node *fail;       /* and where to go when no move fits */
  struct goto_node *next;       /* next goto node with same depth */
} Goto_Node;
typedef struct move_node {
  struct move_node *next;
  Goto_Node *state;
  char c;
} Move_Node;
static Goto_Node *root[128];
static int max_depth;
static Goto_Node **depths;
static Goto_Node *goto_lookup(char c, Goto_Node *g)
{
  Move_Node *m = g->moves;
  while (m && m->c != c)
    m = m->next;
  if (m)
    return m->state;
  else
    return NULL;
}
static void build_gotos(Name *);
static int reject_match(Name *, char, Manager *);

void search(void)
{
  int i;
  for (i=0; i<128; i++)
    root[i] = NULL;
  max_depth = 10;
  depths = (Goto_Node **) arena_getmem(max_depth * sizeof(Goto_Node *));
  for (i=0; i<max_depth; i++)
    depths[i] = NULL;
  build_gotos(user_names);
  {
  int depth;
  for (depth=1; depth<max_depth; depth++) {
    Goto_Node *r = depths[depth];
    while (r) {
      Move_Node *m = r->moves;
      while (m) {
        char a = m->c;
        Goto_Node *s = m->state;
        Goto_Node *state = r->fail;
        while (state && !goto_lookup(a, state))
          state = state->fail;
        if (state)
          s->fail = goto_lookup(a, state);
        else
          s->fail = root[a];
        if (s->fail) {
          Name_Node *p = s->fail->output;
          while (p) {
            Name_Node *q = (Name_Node *) arena_getmem(sizeof(Name_Node));
            q->name = p->name;
            q->next = s->output;
            s->output = q;
            p = p->next;
          }
        }
        m = m->next;
      }
      r = r->next;
    }
  }
}
  {
  for (i=1; i<scraps; i++) {
    char c;
    Manager reader;
    Goto_Node *state = NULL;
    reader.prev = NULL;
    reader.scrap = scrap_array(i).slab;
    reader.index = 0;
    c = pop(&reader);
    while (c) {
      while (state && !goto_lookup(c, state))
        state = state->fail;
      if (state)
        state = goto_lookup(c, state);
      else
        state = root[c];
      c = pop(&reader);
      if (state && state->output) {
        Name_Node *p = state->output;
        do {
          Name *name = p->name;
          if (!reject_match(name, c, &reader) &&
              (!name->uses || name->uses->scrap != i)) {
            Scrap_Node *new_use =
                (Scrap_Node *) arena_getmem(sizeof(Scrap_Node));
            new_use->scrap = i;
            new_use->next = name->uses;
            name->uses = new_use;
          }
          p = p->next;
        } while (p);
      }
    }
  }
}
}
static void build_gotos(Name *tree)
{
  while (tree) {
    {
  int depth = 2;
  char *p = tree->spelling;
  char c = *p++;
  Goto_Node *q = root[c];
  if (!q) {
    q = (Goto_Node *) arena_getmem(sizeof(Goto_Node));
    root[c] = q;
    q->moves = NULL;
    q->fail = NULL;
    q->moves = NULL;
    q->output = NULL;
    q->next = depths[1];
    depths[1] = q;
  }
  while (c = *p++) {
    Goto_Node *new = goto_lookup(c, q);
    if (!new) {
      Move_Node *new_move = (Move_Node *) arena_getmem(sizeof(Move_Node));
      new = (Goto_Node *) arena_getmem(sizeof(Goto_Node));
      new->moves = NULL;
      new->fail = NULL;
      new->moves = NULL;
      new->output = NULL;
      new_move->state = new;
      new_move->c = c;
      new_move->next = q->moves;
      q->moves = new_move;
      if (depth == max_depth) {
        int i;
        Goto_Node **new_depths =
            (Goto_Node **) arena_getmem(2*depth*sizeof(Goto_Node *));
        max_depth = 2 * depth;
        for (i=0; i<depth; i++)
          new_depths[i] = depths[i];
        depths = new_depths;
        for (i=depth; i<max_depth; i++)
          depths[i] = NULL;
      }
      new->next = depths[depth];
      depths[depth] = new;
    }
    q = new;
    depth++;
  }
  q->output = (Name_Node *) arena_getmem(sizeof(Name_Node));
  q->output->next = NULL;
  q->output->name = tree;
}
    build_gotos(tree->rlink);
    tree = tree->llink;
  }
}
#define sym_char(c) (isalnum(c) || (c) == '_')

static int op_char(char c)
{
  switch (c) {
    case '!': case '@': case '#': case '%': case '$': case '^':
    case '&': case '*': case '-': case '+': case '=': case '/':
    case '|': case '~': case '<': case '>':
      return TRUE;
    default:
      return FALSE;
  }
}
static int reject_match(Name *name, char post, Manager *reader)
{
  int len = strlen(name->spelling);
  char first = name->spelling[0];
  char last = name->spelling[len - 1];
  char prev = '\0';
  len = reader->index - len - 2;
  if (len >= 0)
    prev = reader->scrap->chars[len];
  else if (reader->prev)
    prev = reader->scrap->chars[SLAB_SIZE - len];
  if (sym_char(last) && sym_char(post)) return TRUE;
  if (sym_char(first) && sym_char(prev)) return TRUE;
  if (op_char(last) && op_char(post)) return TRUE;
  if (op_char(first) && op_char(prev)) return TRUE;
  return FALSE;
}
