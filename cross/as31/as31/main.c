/* ----------------------------------------------------------------------
 * FILE: main.c
 * PACKAGE: as31 - 8031/8051 Assembler.
 *
 * DESCRIPTION:
 *	The file contains main(). It handles the arguments and makes
 *	sure that pass 1 is done before pass 2 etc...
 *
 * REVISION HISTORY:
 *	Jan. 19, 1990 - Created. (Ken Stauffer)
 *
 * AUTHOR:
 *	All code in this file written by Ken Stauffer (University of Calgary).
 *	January, 1990. */ static char
 *	id_id= "Written by: Ken Stauffer"; /*
 *      Amiga version string: */ static char 
 *       version_id= "$VER: as31 1.1 (30.01.90)"; /*
 *
 */

#include <stdio.h>
#include <setjmp.h>

extern int lineno;
extern int pass,fatal;
extern unsigned long lc;

jmp_buf main_env;
char *asmfile;
int dashl=0;
FILE *listing;

/* ----------------------------------------------------------------------
 * checkext:
 *	Check the string s, for the presence of an extenstion e.
 *	Return the position of the start of e in s.
 *	or return NULL.
 */

char *checkext(s,e)
char *s,*e;
{
	register char *ps = s, *pe = e;

	while( *ps ) ps++;
	while( *pe ) pe++;

	for( ; ps>=s && pe>=e && *ps == *pe; ps--, pe-- )
		if( pe == e ) return(ps);
	return(NULL);
}

main(argc,argv)
char *argv[];
{
	FILE *fin;
	char *p,*dashF=NULL, *dashA=NULL;
	char objfile[100];
	char lstfile[100];
	int i;

	if( argc < 2 ) {
		fprintf(stderr,"Usage: %s [-l] [-Ffmt] [-Aarg] infile.asm\n",
						argv[0]);
		emitusage();
		exit(1);
	}

	for(i=1; i<argc; i++ ) {
		if( argv[i][0] != '-' ) break;
		if( argv[i][1] == 'l' ) dashl = 1;
		else if( dashF == NULL && argv[i][1] == 'F' )
			dashF = argv[i]+2;
		else if( dashA == NULL && argv[i][1] == 'A' )
			dashA = argv[i]+2;
		else {
			fprintf(stderr,"Duplicate or unknown flag.\n");
			exit(1);
		}
	}
	if( i == argc ) {
		fprintf(stderr,"Missing input file.\n");
		exit(1);
	}

	if( (p=checkext(argv[i],".asm")) == NULL ) {
		fprintf(stderr,"Input file \"%s\" must end with .asm\n",
				argv[i]);
		exit(1);
	}
	asmfile = argv[i];

	if( (fin = freopen(argv[i],"r",stdin)) == NULL ) {
		fprintf(stderr,"Cannot open input file: %s\n",argv[i]);
		exit(1);
	}

	if( dashl ) {
		strcpy(lstfile,argv[i]);
		strcpy(lstfile+(p-argv[i]),".lst");
		listing = fopen(lstfile,"w");
		if( listing == NULL ) {
			fprintf(stderr,"Cannot open file: %s for writting.\n",
				lstfile);
			exit(1);
		}
	}
	strcpy(objfile,argv[i]);
	strcpy(objfile+(p-argv[i]),".obj");

	emitopen(objfile,dashF,dashA);

	syminit();
	fatal = 0;
	lineno = 1;
	pass=0;
	lc = 0x0000;

	if( setjmp(main_env) ) {
		fclose(fin);
		emitclose();
		unlink(objfile);
		exit(1);
	}

	/*
	** P A S S    1
	*/
	yyparse();
	if( fatal ) longjmp(main_env,1);

	rewind(fin);
	lineno = 1;
	pass++;
	lc = 0x0000;
	emitaddr(lc);

	/*
	** P A S S    2
	*/
	yyparse();

	emitclose();
	fclose(fin);
	if( dashl )
		fclose(listing);
	exit(0);

}
