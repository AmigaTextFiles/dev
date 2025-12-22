/*
 * docsplit : split 1.3 autodoc files into individual subroutine files
 *            by Joel Swank January 8 1989
 *           Version 1.0
 */

#include <stdio.h>
#include <fcntl.h>
#include <exec/types.h>
#define MAXBUF 100     /* size of string buffer */
#define STDIN 0   /* file descriptor for stdin */

char buffer[MAXBUF];
char name[200];
char path[MAXBUF] = "";
char buff[MAXBUF] = "";
int overrite = FALSE;
int verbose = FALSE;
FILE *fdopen();

int fileflag = FALSE;    /* detect no files - use stdin */

main(argc,argv)
int argc;
char *argv[];
{
	register FILE	*filep ;
	register cnt ;

		/* get command line options */
	getcmd(argc, argv);

		/* get command line filenames */
	for (cnt=1; cnt < argc; cnt++)
	{	if (*argv[cnt] != '-')
		{
			if ((filep = fopen(argv[cnt], "r")) == NULL)
				fatal("can't open %s", argv[cnt]) ;

			printf("FILE: %s\n",argv[cnt]);
			dofile(filep);
			fclose(filep);
			fileflag = TRUE;
		}
	}

	if (!fileflag)  /* if no files given, use stdin */
	{
		filep = fdopen(STDIN, "r");
		dofile(filep);
		fclose(filep);
	}
	exit(0);
}

/*
 * process open file via stream pointer
 */

dofile(filep)
FILE *filep;
{
	FILE *outfile;
	struct FileLock *lock, *Lock();

	skipl(filep);

	while ((fgets(buff,MAXBUF,filep)) != NULL)
		{
		char *p, *t, *rindex();;
		p = rindex(buff,'/');
		if (p != NULL) /* if delimiter is found */
			{
			p++;
			t = rindex(p,'\n');       /* wipe newline */
			if (t != NULL) *t = '\0';
			if (path[0] != '\0') /* if a path is specified */
				{
				strcpy (name,path);      /* build name */
				strcat(name,p);
				}
			else strcpy(name,p);
			strcat(name,".doc");
			lock = Lock(name,ACCESS_READ);
			if (lock != NULL && !overrite) /* file exists, skip */
				{
				fprintf(stdout,"docsplit: FILE: %s - Already Exists\n",name);
				skipl(filep);
				UnLock(lock);
				continue;
				}
			if (lock) UnLock(lock);
			outfile = fopen(name,"w");
			if (outfile == NULL)
				{
				fprintf(stdout,"docsplit: FILE: %s - Open Failed\n",name);
				skipl(filep);
				continue;
				}
			while ((fgets(buff,MAXBUF,filep)) != NULL)
				{
				if (buff[0] == '\f') break;
				fputs(buff,outfile);
				}
			fclose(outfile);
			if (verbose) fprintf(stderr,"File: %s - Created\n",name);
			} else skipl(filep);
		}
}

skipl(filep)
FILE *filep;
{
	while ((fgets(buff,MAXBUF,filep)) != NULL)
		if (buff[0] == '\f') break;
}

/*
 *  fatal - print standard error msg and halt process
 */
fatal(ptrn, data1, data2)
register char	*ptrn, *data1, *data2 ;
{
	printf("ERROR: ");
	printf(ptrn, data1, data2) ;
	putchar('\n');
	exit(1);
}

	


/*
 *  getcmd - get arguments from command line 
 */
getcmd(argc, argv)
register argc ;
register char	*argv[] ;
{
	register cnt ;
	int end;
					/* get command options */
	for (cnt=1; cnt < argc; cnt++)
	{	if (*argv[cnt] == '-')
		{	switch(argv[cnt][1])
			{
			   case 'p':
				strncpy(path,&argv[cnt][2],MAXBUF);
				end = strlen(path)-1;
				if (path[end] != '/' && path[end] != '\0' && path[end] != ':' )
					strcat(path,"/") ;
				break ;

			   case 'v':
			    verbose = TRUE;
				break ;

			   case 'o':
			    overrite = TRUE;
				break ;

			   case '?':					/* help option */
				 usage();
				 printf(" DocSplit Ver 1.0 - Split 1.3 autodoc files.\n");
				 printf(" Options:\n");
				 printf(" pstr - Path to output directory. Default current.\n");
				 printf(" v    - verbose - display all file names.\n");
				 printf(" o    - overwrite existing files.\n");
				 printf(" ?    - display this list.\n");
				exit(0);

			   default:
				 usage();
				 exit(0);
			}
		}
	}

}



usage()
{
printf("usage:docsplit [-pstr] [-v] [-o] [-?] [file ...]\n");
}


