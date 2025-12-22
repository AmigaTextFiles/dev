#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>

main(int argc, char **argv)
{
  char *p = argv[1];

  if (*p)
  {
    if (isalpha(*p))
      putchar(*p);
    else
      putchar('_');
    p++;
    while (*p)
    {
      if (isalnum(*p))
        putchar(*p);
      else
        putchar('_');
      p++;
    }
  }
}
