#include <dos/dos.h>
#include <string.h>
#include <stdio.h>

main (int argc, char **argv)
{
  int retval = 0;

  if (argc == 2)
    {
      char buf[256], *bufptr;

      strcpy (buf, argv[1]);

      if (bufptr = strrchr (buf, '/'))
	*bufptr++;
      else if  (bufptr = strrchr (buf, ':'))
	*bufptr++ = '\000';
      else
	bufptr = buf;

      fprintf (stdout, "%s\000", bufptr);

      retval = 0;
    }
  else
    {
      fprintf (stderr, "usage: %s path/filename\n", argv[0]);

      retval = 10;
    }

  return (retval);
     
}
