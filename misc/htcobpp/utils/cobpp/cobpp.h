#ifndef _COBPP_H
#define _COBPP_H

#include <stdlib.h>
#include <stdio.h>

#if 0
#include "list_util.h"
#endif

typedef short bool;

struct s_Env {
	bool fixedFormat;
	bool freeFormat;
	bool format; /* 1 is free , 0 is fixed */
	bool debug;
	int errFlag;
	int tab2space;
	char *progName;
	char *filename;
/*	List fnList; */
	};

typedef struct s_Env Env;

#ifdef GLOBAL_DEF
Env globalEnv;
Env *globalEnvPtr;
#ifdef __AMIGADATE__
char *VERsion = "$VER: htcobpp 0.84ß "__AMIGADATE__" $";
#endif
char *cobppVersion = "0.84 (beta).";
char *cobppVersion0 = "COBOL format convert utility version";
char *cobppVersion1 = "Copyright (C) 1999-2000  David Essex, 1998-1999  Laura Tweedy.";
#else
extern Env globalEnv;
extern Env *globalEnvPtr;
extern char *cobppVersion;
extern char *cobppVersion0;
extern char *cobppVersion1;
#endif


int yylex(void);
int yywrap(void);
int setOptions( Env*, int, char** );
int setDefaults( Env* );
void printVersion( char* );
void printHelp( int );
void CleanUp( void );

#endif
