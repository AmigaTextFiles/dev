/*************************************************************************
* An example showing the use of getopt.
*************************************************************************/

#include <stdio.h>
#include <string.h>
#include "getopt.h"


main(int argc, char *argv[])
{
	int c;
	int code = 0;		/* Error code for exiting. */
	char filename[BUFSIZ];

/*	opterr = 0; */		/* Uncomment to suppress error messages. */

   /* Process the options. */

	while ((c = getopt(argc, argv, "aeko:")) != EOF)
	{
		switch (c)
		{
			case 'a':
				puts("Found -a");
				break;
			case 'k':
				puts("Found -k");
				break;
			case 'e':
				puts("Found -e");
				break;

			case 'o':
			   /* Here we use optarg. */
				printf("Found -o with %s\n", optarg);
			   /* Save a private copy. */
				strcpy(filename, optarg);
				break;

			case '?':
			   /* Note the use of optopt. */
				printf("Option %c is an ERROR!\n", optopt);
				code = 1;
				break;

			default:
				printf("THIS SHOULD NEVER HAPPEN!!!!\n");
				printf("There must be a bug in getopt().\n");
				exit(1);
		}
	}
	
	
   /* Now process the remaining arguments using optind. */

	if (optind <= argc-1)
	{
		int i;

		printf("The remaining arguments are:\n");
		for (i=optind; i<argc; i++)
			puts(argv[i]);
	}
	else
		printf("There are no arguments.\n");
	
	exit(code);
}
