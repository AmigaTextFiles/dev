#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "nodeman.h"
#define ALLOC
#include "misc.h"
#include "tokens.h"
#include "action.h"
#include "value.h"
#include "codegen.h"
#include "nodeproc.h"
#include "actionlexer.h"

extern FILE *yyin;


main(int argc, char *argv[])
{
	int i;
	FILE *infile = NULL;
	int c;
	char *arg;
	char *Oname;

	fprintf(stderr,"ACTION! Ver 0.07 cross compiler for the 6502\n");
	fprintf(stderr,"Copyright (c) 2010 by Jim Patchell\n");
	fprintf(stderr,"This program is free for any use\n");
	//---------------------------------------
	// parse command line
	//---------------------------------------
	i = 1;
	while(i < argc)
	{
		arg = argv[i];
		c = arg[0];
		if(c == '-')
		{
			c = arg[1];
			switch(c)
			{
				case 'D':
					//debug mode
					LexDebugMode(1);
					NodeSetDebug(1);
					break;
			}
		}
		else
		{
			if((infile = fopen(arg,"r")) == NULL)
			{
				fprintf(stderr,"Unable to Open %s\n",arg);
				exit(1);
			}
			//----------------------------------
			// generate outfile from infile
			//----------------------------------
			Oname = malloc(256);
			strcpy(Oname,arg);
			printf("%s\n",Oname);
			arg = strchr(Oname,'.');
			if(arg)
			{
				++arg;
				*arg = 0;
				strcat(Oname,"ASM");
			}
			else
				strcat(Oname,".ASM");
			OutFile = fopen(Oname,"w");
			if(OutFile == NULL)
			{
				fprintf(stderr,"Could not open %s\n",Oname);
				exit(1);
			}
		}
		i++;	//next argument
	}	//end of while loop

	if(infile == NULL)
	{
		printf("Get Input From Consol\n");
		yyin = stdin;
		OutFile = stdout;
	}
	else
		yyin = infile;
	//--------------------------------------
	// prepare compiler
	//---------------------------------------
	InitLexer(1000);
	//make table to keep symbol definitions in
	Symbol_tab = maketab( 97, hash_pjw, strcmp );
	//make table to keep TYPE definitions in
	Struct_tab = maketab(19,hash_pjw,strcmp);
	ExitStack = newStack(64);	//64 levels of DO-OD loops
	DoLoopStack = newStack(64);
	IfStack = newStack(64);	//64 levels of if statements
	Regs = newREGS();							//next loops more
	//than 64 deap?
	//parse source code
//	NodeSetDebug(1);

	OutputInternalStuff(OutFile);
	yyparse();
	//debug....print out symbol table
	print_syms(stdout);
	if(infile) fclose(infile);
}
