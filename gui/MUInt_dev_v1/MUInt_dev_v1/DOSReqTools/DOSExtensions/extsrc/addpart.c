#include <string.h>
#include <stdio.h>

main (int argc, char **argv)
{
  int retval = 0;

  if (argc == 3)
    {
      char buf[256];

      strcpy (buf, argv[1]);

      if (AddPart (buf, argv[2], 256))
	{
	  fprintf (stdout, "%s\000", buf);

	  retval = 0;
	}
      else
	{
	  retval = 10;
	}
    }
  else
    {
      fprintf (stderr, "usage: %s path filename\n", argv[0]);

      retval = 10;
    }

  return (retval);
     
}
