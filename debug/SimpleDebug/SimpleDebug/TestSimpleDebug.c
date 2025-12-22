/***************************************************************************
**
** SimpleDebug - A debugging/tracing tool
** print tracing messages when needed
** Copyright (C) 2009- by Mikko Koivunalho
**
** This software is free software; you can redistribute it and/or
** modify it under the terms of the GNU Lesser General Public
** License as published by the Free Software Foundation; either
** version 2.1 of the License, or (at your option) any later version.
**
** This library is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
** Lesser General Public License for more details.
**
** $Id: TestSimpleDebug.c 41 2009-04-01 19:32:29Z svn.username $
**
***************************************************************************/

/*
** Program Version
*/
static char VersionTag[] = "\0$VER: TestSimpleDebug 1.0 (29.03.09)";

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <SimpleDebug/SimpleDebug.h>
SD_SETUP

#include "TestSimpleDebug_more.h"

/*
** SimpleDebug helper routines and datastructures defined
*/
SD_DO(
	char filename[80];
	FILE *debugfile;
	int print_cool_debug(char *str);
)

/*
** Subroutines defined
*/
int MainProgram(int argc,char **argv);
int subroutine(void);
int sillyrecur(int r);
int cool_debug_routine(void);


/* Main entry point */

int main(int argc,char *argv[]) {
	SD_ON();
	exit(MainProgram(argc, argv));
}

/*
** Routines
*/
int MainProgram(int argc, char *argv[])
{
	SD_BEGIN("MainProgram", 0);
	subroutine();

	SD_DO(
		printf("Print the next debug to a different file!\n");
		printf("Or, if using AmigaOS, you can use \"CON:////My Title/WAIT\".\n");
		printf("Enter filename (or empty for stdio), max. 80 chars.: ");
		/*scanf("%s", filename);*/
		gets(filename);
		if(debugfile = fopen(filename, "a")) {
			printf("Opened file \'%s\' for debug output.\n", filename);
			SD_SET_GLOBALS(debugfile, NULL, 2, NULL);
		}
		else {
			printf("Could not open file \'%s\'. Using stdout\n", filename);
		}
	);
	sillyrecur(8);
	SD_DO(
		if(debugfile) {
			SD_SET_GLOBALS(stdout, NULL, 1, NULL);
			printf("Closing debug output file \'%s\'.\n", filename);
			fclose(debugfile);
		}
	);


	testerroutine1(2);
	testerroutine2(2);
	testerroutine3(2);
	cool_debug_routine();
	SD_END();
	return(0);
}

int subroutine(void) {
	SD_BEGIN("subroutine", 0);
	SD_PRINT("inside subroutine\n");
	SD_END();
	return 1;
}

int sillyrecur(int r) {
	SD_BEGIN("sillyrecur", 80);

	SD_DO(
		if (r < 3 || r > 6) {
			SD_APPEND("r = %d\n", r);
			SD_PRINTBUFFER();
		}
	);

	r -= 1;
	if (r > 0) {
		sillyrecur(r);
	}
	else {
		SD_PRINT("r = 0\n");
	}

	SD_END();
	return r;
}

int cool_debug_routine(void) {
	SD_BEGIN("cool_debug_routine", 256);
	SD_SET_LOCALS(NULL, print_cool_debug, "Cool Up!");
	
	SD_PRINT("This is cool debugging!");
	SD_PRINT("Cool debugging ends with the routine! Sorry.");
	SD_END();
	return 1;
}

/*
** SimpleDebug helper routines
*/
SD_DO(
	int print_cool_debug(char *str) {
		printf("SD_GLOBAL_PREFS.SD_Indentation=%s!\n", SD_GLOBAL_PREFS.SD_Indentation);
		/*printf("strlen(SD_LOCAL_PREFS.SD_IndentationBuffer)=%d!\n", strlen(SD_LOCAL_PREFS.SD_IndentationBuffer));*/

		printf("%s!!!COOL, and preserve indent.\n", str);
		return 1;
	}
)

