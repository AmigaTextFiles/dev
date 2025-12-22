/***********************************************************************
* Screen control routines, Uses ANSI control sequences.
***********************************************************************/
 
#include <stdio.h>

#if defined(OPENEDITION) || defined(OS390)
#define ESCAPE  0x27
#else
#define ESCAPE  0x1B
#endif
 
/***********************************************************************
* clearscreen - clear the screen
***********************************************************************/
 
void
clearscreen (void)
{
   fprintf (stdout,
	    "%c[2J",
	    ESCAPE);
}
 
/***********************************************************************
* clearline - clear the line
***********************************************************************/
 
void
clearline (void)
{
   fprintf (stdout,
	    "%c[2K",
	    ESCAPE);
}
 
/***********************************************************************
* screen position - position on the screen
***********************************************************************/
 
void
screenposition (char *row,
		char *col)
{
   fprintf (stdout,
	    "%c[%s;%sH",
	    ESCAPE,
	    row,
	    col);
}
