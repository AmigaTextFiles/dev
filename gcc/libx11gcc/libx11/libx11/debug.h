/* Copyright (c) 1996 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     debug
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Nov 11, 1996: Created.
***/

#ifndef DEBUG_H
#define DEBUG_H

#if (X11DEBUG!=0)
#define DEBUG 1

#ifdef DEBUG

extern int show;

void
showbitmap( struct BitMap *bm,
	    int width,
	    int height,
	    int xpos,
	    int ypos );

#include "funcount.h"

#endif
#endif

#if 0
/* These defines can produce some trace output for debugging purposes  */
/* I prefer to add these in the file(s) I want to inspect instead of a */
/* full recompile..*/

/* Print a string on entry of any (ok most..) functions */
#define DEBUGXEMUL_ENTRY 1
/* Print a string on exit of functions (fairly unused) */
#define DEBUGXEMUL_EXIT 1
/* Print a string on entry of any stub functions */
#define DEBUGXEMUL_WARNING 1
#endif

#endif /* DEBUG_H */
