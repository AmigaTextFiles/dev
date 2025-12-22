#include <stdio.h>

main (int argc, char **argv)
{
  char buf [256];

  if (argc > 1)
    {
      char *ptr;

      while (ptr = *++argv)
	fprintf (stderr, "%s ", ptr);
    }

  fprintf (stdout, "%s\000", gets(buf));

  return (0);   
}
