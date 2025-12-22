#include <string.h>
#include <stdio.h>

main (int argc, char **argv)
{
  int retval = 0;

  if (argc == 3)
    {
      int start;
      int end;

      char buf[256], *ptr;

      strcpy (buf, argv[1]);

      if (ptr = strchr (argv[2], ':'))
	{
	  *ptr++ = '\000';

	  start = atoi (argv[2]);
	  end = atoi (ptr);
	}
      else
	{
	  start = 1;
	  end = atoi (argv[2]);
	}

      if ((start > end) || (start > strlen(argv[1])))
	{
	  fprintf (stderr, "%s: error: specification out of range.\n", argv[0]);

	  retval = 10;
	}
      else 
	{
	  if (end > strlen(argv[1]))
	    {
	      end = strlen(argv[1]);
	    }
	  
	  {
	      int i;

	      for (i = start - 1; i < end ; i++ )
		fputc (buf[i], stdout);

	      fputc ('\000', stdout);
	  }
	}
    }
  else
    {
      fprintf (stderr, "usage: %s string [start:]end\n", argv[0]);

      retval = 10;
    }

  return (retval);
}
