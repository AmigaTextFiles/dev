#include <string.h>
#include <stdio.h>

int
main (int argc, char **argv)
{
  int retval = 0;

  char buf[256];
  char *ptr;

  if (argc == 3)
    {
      strcpy (buf, argv[1]);

      if (ptr = strrchr (buf, '.'))
	{
	  strcpy (ptr, argv[2]);
	  fprintf (stdout, "%s\n", buf);
	}
      else
	{
	  fprintf (stderr, "%s: no extension changed\n", argv[0]);
	  retval = 10;
	}
    }
  else
    {
      fprintf (stderr, "usage: %s <filename> <.newext>\n", argv[0]);
      retval = 10;
    }

  return (retval);
}

