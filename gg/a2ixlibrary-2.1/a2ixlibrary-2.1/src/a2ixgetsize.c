#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>

static unsigned long get_num(int fd)
{
  unsigned long t;
  
  read(fd, &t, 4);
  return t;
}

static void skip(int fd, unsigned long t)
{
  lseek(fd, t * 4, SEEK_CUR);
}

static void
amiga_read_file_symbols (desc)
register int desc;
{
  int t, f, l, size;

  if (get_num(desc) != 0x03f3)
    exit(20);
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
        size = get_num(desc);
        printf("%x\n", 4 * size);
        return;
      case 0x03ea:      /* data */
        size = get_num(desc);
        skip(desc, 4 * size);
        break;
      case 0x03eb:      /* bss */
        get_num(desc) * 4;
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
          get_num(desc);
          skip(desc, t);
        }
        break;
      case 0x03ef:      /* ext */
        while (t = get_num(desc))
          skip(desc, (t & 0xffffff) + 1);
        break;
      case 0x03f0:      /* symbols */
        while (t = get_num(desc))
        {
          skip(desc, t * 4);
          get_num(desc);
        }
        break;
      case 0x03f2:      /* end */
        l--;
        break;
    }
  }
}

main(int argc, char **argv)
{
  int fd;

  if (argv[1])
  {
    fd = open(argv[1], O_RDONLY);
    amiga_read_file_symbols(fd);
    close(fd);
  }
}
