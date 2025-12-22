/*
    This program can extract autodocs, prototypes and FD files from a
    series of source files.

    When generating autodocs, it looks for lines beginning with the word
    "AUTODOCS". The rest of the line will be used as the name of a new
    autodocs section. The following lines are extracted from the source
    and written to stdout until a line is found that terminates a C comment
    at the beginning of the line.

    For generating prototypes this will look for lines beginning with the
    word "Prototype". (Hey, Dice owners, you know? :-) The line is extracted
    and written to stdout by replacing the word "Prototype" with the word
    "extern". (This allows to create prototypes of variables.)

    Generating FD files works quite the same, except that the word
    "FDPrototype" is searched and nothing is replaced.

    This is public domain, use it as you want, but WITHOUT ANY WARRANTY!

    Computer:	Amiga 1200		    Compiler: Any ANSI compiler

    Author:	Jochen Wiedmann
		Am Eisteich 9
		72555 Metzingen (Germany)
		Phone: 07123 / 14881
		Internet: wiedmann@mailserv.zdv.uni-tuebingen.de

    V1.1,   31.03.94
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE (!FALSE)
#endif


char VERSION[] = "$VER: Xtract 1.1 (31.03.94)    by Jochen Wiedmann";





void Usage(void)

{
  fprintf(stderr, "Usage: Xtract files/M,FD/S,PROTOS/S\n\n");
  fprintf(stderr, "Extracts autodocs, FD files or prototype files ");
  fprintf(stderr, "from the given\n");
  fprintf(stderr, "source files.\n\n%s\n", VERSION+6);
}




/*
AUTODOCS Xtract/ScanFiles()

    NAME
	ScanFiles

    SYNOPSIS
	Success = ScanFiles(argc, argv, autodocs, fd, protos)

	int ScanFiles(int, char **, int, int, int);

    FUNCTION
	Called from main to visit each file in the list given
	by argc and argv. Extracts the wished portions from
	the source and writes them to stdout.

    INPUTS
	argc, argv  - the arguments of main()
	autodocs    - 1 or 2 (depending on the pass number) when
		      creating autodocs, 0 otherwise
	fd	    - 1 when creating FD files, 0 otherwise
	protos	    - 1 when creating prototype files, 0 otherwise

    RESULT
	TRUE, if successful, FALSE otherwise

    NOTE
	Be sure, that only one of autodocs, fd and protos is
	nonzero!

    SEE ALSO
	main()

*/
/*
Prototype int ScanFiles(int, char **, int, int, int);
*/
int ScanFiles(int argc, char *argv[], int autodocs, int fd, int protos)

{ int i;

  if (fd)
  { if (fputs("*\n*\tMACHINE GENERATED\t\t\n*\n", stdout) < 0)
    { return(FALSE);
    }
  }
  else if (protos)
  { if (fputs("\n/*\tMACHINE GENERATED\t\t*/\n\n", stdout) < 0)
    { return(FALSE);
    }
  }
  else if (autodocs == 1)
  { if (fputs("TABLE OF CONTENTS\n\n", stdout) < 0)
    { return(FALSE);
    }
  }

  for (i = 1;  i < argc;  i++)
  { FILE *fp;
    int write_autodocs = FALSE;
    char line[2048];
    int linenum;

    if (stricmp(argv[i], "fd") == 0  ||
	stricmp(argv[i], "protos") == 0)
    { continue;
    }

    if (!(fp = fopen(argv[i], "r")))
    { fprintf(stderr, "Cannot open %s for output.\n");
      exit(10);
    }

    if (protos)
    { if (printf("\n/*\t%s\t\t*/\n\n", argv[i])  <  0)
      { return(FALSE);
      }
    }

    linenum = 0;
    while (fgets(line, sizeof(line), fp))
    { int len;

      ++linenum;
      len = strlen(line);
      if (line[len-1] != '\n')
      { fprintf(stderr, "Error: Line %d too long.\n", linenum);
      }

      if (protos)
      { if (strncmp("Prototype", line, 9) == 0)
	{ if (printf("extern %s", line+9) < 0)
	  { return(FALSE);
	  }
	}
      }
      else if (fd)
      { if (strncmp("FDPrototype", line, 11) == 0)
	{ char *ptr;

	  ptr = line+11;
	  while (*ptr == ' '  ||  *ptr == '\t')
	  { ptr++;
	  }

	  if (printf("%s", ptr) < 0)
	  { return(FALSE);
	  }
	}
      }
      else
      { if (strncmp("AUTODOCS", line, 8) == 0)
	{ char *ptr;

	  ptr = line+8;
	  while (*ptr == ' '  ||  *ptr == '\t')
	  { ptr++;
	  }

	  write_autodocs = TRUE;
	  if (autodocs == 1)
	  { if (printf("%s", ptr) < 0)
	    { return(FALSE);
	    }
	  }
	  else
	  { if (printf("\014%s", ptr) < 0)
	    { return(FALSE);
	    }
	  }
	}
	else if (line[0] == '*'  &&  line[1] == '/')
	{ write_autodocs = FALSE;
	}
	else if (autodocs == 2  &&  write_autodocs)
	{ if (printf("%s", line) < 0)
	  { return(FALSE);
	  }
	}
      }
    }

    fclose(fp);
  }

  if (fd)
  { if (printf("##end\n") < 0)
    { return(FALSE);
    }
  }

  return(TRUE);
}





/*
AUTODOCS Xtract/main()

    NAME
	main	--  we all know what it is.

    SYNOPSIS
	main(argc, argv)

	void main(int, char **);

    FUNCTION
	Called by the startup code; checks the arguments and calls
	ScanFiles() for the first pass. A second pass is needed
	when generating autodocs, hence will call ScanFiles() again
	in that case.

    INPUTS
	argc	- number of arguments (including the programs name),
		  0, when called from the workbench. This should
		  *never* happen.
	argv

    RESULT
	what do you expect from a void function?

    SEE ALSO
	ScanFiles()
*/
/*
Prototype void main(int, char **);
FDPrototype *
FDPrototype * Sorry, guys, but this is no shared library.
FDPrototype *
FDPrototype * But you could expect that the FD prototypes would
FDPrototype * follow here.
*/
void main(int argc, char *argv[])

{ int i;
  int autodocs = TRUE;
  int protos = FALSE;
  int fd = FALSE;

  if (argc == 0)    /*  Prevent start from workbench.   */
  { exit(-1);
  }

  if (argc == 1  ||
      strcmp(argv[1], "?") == 0  ||
      strcmp(argv[1], "-h") == 0)
  { Usage();
    exit(5);
  }

  /*
      Lets see, if we should generate autodocs, prototypes or FD files.
  */
  for (i = 1;  i < argc;  ++i)
  { if (stricmp(argv[i], "fd") == 0)
    { fd = TRUE;
      autodocs = FALSE;
    }
    else if (stricmp(argv[i], "protos") == 0)
    { protos = TRUE;
      autodocs = FALSE;
    }
  }
  if (fd  &&  protos)
  { fprintf(stderr, "Can not generate both FD and prototype files.\n");
    exit(10);
  }


  if (!ScanFiles(argc, argv, autodocs, fd, protos)  ||
      (autodocs  &&  !ScanFiles(argc, argv, 2, fd, protos)))
  { fprintf(stderr, "Error while writing.\n");
    exit(10);
  }
  exit(0);
}
