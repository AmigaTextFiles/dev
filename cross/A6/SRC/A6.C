/* ------------------------------------------------------------------
    A6.C -- main file for the A6 cross assembler
     This is free software, please see the file
     "COPYING" for copyright and licence details
   ------------------------------------------------------------------ */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "asmfile.h"
#include "assemble.h"
#include "error.h"
#include "ustring.h"
#include "global.h"
#include "label.h"
#include "outf.h"
#include "psop.h"
#include "pstext.h"

/* This is to cope with non-100% ANSI stdlib.h/stdio.h (e.g. L*tt*ce) */
#ifndef EXIT_FAILURE
#define EXIT_FAILURE (999)
#define EXIT_SUCCESS (0)
#endif

#ifndef size_t
#define size_t int
#endif

/* Text lines for opening message */

/* OUTF_EXTENSION */
/* Must be here because GCC chokes on extern char** */
char *outf_extension[] = {
        "OBJ", "PRG", "P00"
};

/* USAGE */
void usage(void)
{
        printf( \
		"A6 v0.4.3: a 6502 cross-assembler program.  (C) 1998 Simon Collis\n\n" \
		"usage: A6 [switches] infile\n\nSwitches:\n" \
		" -d           : make dots on pseudo-ops optional\n" \
		" -f[bp0]      : set output format (binary/.PRG/.P00)\n" \
		" -l           : show listing on pass 2\n" \
		" -s#          : set syntax 0=Genius, 1=Genius+Turbo Asm, 2=Full syntax\n" \
		" -t           : print symbol table after assembly\n" \
		" -o [outfile] : specify output file name\n\n" \
	        "This program is free software; you can redistribute it and/or modify\n" \
		"it under the terms of the GNU General Public License as published by\n" \
		"the Free Software Foundation; either version 2 of the License, or\n" \
		"(at your option) any later version.\n\n" \
		"This program is distributed in the hope that it will be useful,\n" \
		"but WITHOUT ANY WARRANTY; without even the implied warranty of\n" \
		"MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n" \
		"GNU General Public License for more details.\n\n" \
		" You should have received a copy of the GNU General Public License\n" \
		"along with this program; if not, write to the Free Software\n" \
		"Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.\n" \
		);
} /* usage */

/*-----------------------------------------------------------------*/
/* MAIN */
int main(int argc,char **argv)
{
	char *inname=0;
	char *s; size_t i; int symflag=0,endswitches=0,freeoutname=0;

	/* Defaults before command line */
	g_syntax=2;	/* Genius+TASM+A6 by default */

	/* Parse command line input */
	while(argc>1) {
		if(argv[1][0]=='-') {
			if(endswitches!=0 || argv[1][1]=='\0') {
				endswitches=1;
			} else {
				switch(argv[1][1]) {
					case 'd':
						g_dotflag=1;
						break;

					case 'f':
						if(argv[1][2]!='\0') {
							switch(argv[1][2]) {
								case 'b': case 'B': g_outf_format=OUTF_BIN; break;
								case 'p': case 'P': g_outf_format=OUTF_PRG; break;
								case '0': g_outf_format=OUTF_P00; break;
							}
						} else {
							fprintf(stderr,"error: no output format supplied.\nStopped\n");
							exit(EXIT_FAILURE);
						}
						break;

					case 'l':
						g_listflag++;
						break;

					case 'o':
						if(argv[1][2]=='\0') {
							if(argc<3) {
								fprintf(stderr,"error: no output name supplied.\nStopped\n");
								exit(EXIT_FAILURE);
							} else {
								g_outname=argv[2];
								argc--; argv++;
								s="\0";
							}
						} else {
							g_outname=trim(argv[1]+2);
						}
						break;

					case 's':
						if(argv[1][2]=='\0')
							g_syntax=0;
						else
							g_syntax=(int)(argv[1][2]-'0');
						break;

					case 't':
						symflag++;
						break;

					case '?':
						usage();
						exit(0);
				} /*switch */
			} /* if */
		} /* command-line switches */

		else {
			/* input name?? */
			if(inname==0)
				inname=argv[1];
			else
				if(g_outname==0)
					g_outname=argv[1];
				else {
					printf("don't understand `%s'\nStopped.",argv[1]);
					exit(EXIT_FAILURE);
				}
		} /* else */
		argc--; argv++;
	} /* while */

	/* If no input name, throw a wobbly. */
	if(inname==0) {
		fprintf(stderr,"error: no input file.\nStopped\n");
		exit(EXIT_FAILURE);
	}

	/* If no output name, generate it */
	if(g_outname==0) {
		g_outname=malloc(strlen(inname)+5);
		freeoutname=1;

		strcpy(g_outname,inname);

		i=strlen(g_outname);
		while(i>0 && g_outname[i]!='.') i--;

		if(i==0)
			i=strlen(g_outname);

		g_outname[i++]='.';
		g_outname[i++]=outf_extension[g_outf_format][0];
		g_outname[i++]=outf_extension[g_outf_format][1];
		g_outname[i++]=outf_extension[g_outf_format][2];
		g_outname[i]='\0';
	}

	/* CALL ALL ASSEMBLY ROUTINES HERE */

	/* ------------------------------------------------------- */
	/* Pass 1 */
	printf("\npass 1\n\n");
	g_pass=0;
	g_undocopsflag=NOUNDOCOPS;	/* Undoc. ops OFF by default */
	pstext_setcset(CSET_PETSCII);	/* Default = PET ASCII */
	lbl_init();			/* Set up label indexing */

	/* Actual pass */
	af_open(inname,0);
	while(parseline());

	/* Cleanup input files */
	while(af_close()!=0);

	/* ------------------------------------------------------- */
	/* Pass 2 */
	printf("\npass 2\n\n");
	g_pass++;
	g_undocopsflag=NOUNDOCOPS;	/* Undoc. ops OFF by default */
	lbl_reset();			/* Reset local labels */
	pstext_setcset(CSET_PETSCII);	/* Default = PET ASCII */

	outf_setpc(0);			/* Reset PC counter */

	outf_open(g_outname);		/* Open output file */

	/* Actual pass */
	af_open(inname,0);
	while(parseline());

	/* Cleanup input files */
	while(af_close()!=0);

	/* List symbol table if required */
	if(symflag!=0) {
		printf("\n\n");
		lbl_dumpsym();
	}

	/* Tidy everything up */
	af_cleanup();		/* Clean up assembly files */
	lbl_destroy();		/* Delete all allocated labels */
	outf_close();

	if(freeoutname)
	        free(g_outname);

	/* ------------------------------------------------------- */

	/* Final message */
	if(g_errorcount>0)
		printf("\n %u errors; assembly failed.\n",g_errorcount);
	else
		printf("\n assembly successful; no errors.\n");

	return((int)g_errorcount);
} /* main */
