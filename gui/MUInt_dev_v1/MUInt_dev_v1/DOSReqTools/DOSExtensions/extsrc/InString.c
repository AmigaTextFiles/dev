#include <string.h>
#include <stdio.h>

main (int argc, char **argv)
{
  int retval = 0;

      char buf1[256], buf2[256];

      if ((argc == 4) && (stricmp (argv[3], "CASE") == 0))
	{

	  char *ptr;

	  strcpy (buf1, argv[1]), strcpy (buf2, argv[2]);

	  if (ptr = strstr (buf2, buf1))
	    {
	      fprintf (stdout, "%d:%d\000", (ptr - buf2) + 1, (ptr - buf2) + strlen (buf1));
	      retval = 5;
	    }
	  else
	    {
	      fprintf (stdout, "0:0\000");
	      retval = 0;
	    }
	}
      else if (argc == 3)
	{
	  char *ptr;

	  for (ptr = strcpy (buf1, argv[1]); *ptr; ptr++)
	    *ptr = toupper (*ptr);

	  for (ptr = strcpy (buf2, argv[2]); *ptr; ptr++)
	    *ptr = toupper (*ptr);

	  if (ptr = strstr (buf2, buf1))
	    {
	      fprintf (stdout, "%d:%d\000", (ptr - buf2) + 1, (ptr - buf2) + strlen (buf1));
	      retval = 5;
	    }
	  else
	    {
	      fprintf (stdout, "0:0\000");
	      retval = 0;
	    }

	}
      else
	{
	  fprintf (stderr, "usage: %s string1 string2 [CASE]\n", argv[0]);

	  retval = 10;
	}

  return (retval);

}
