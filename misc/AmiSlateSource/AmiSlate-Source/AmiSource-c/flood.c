/* Flood fill routine for use by palette.c.  Generate with a */
/*   dcc -c -gs flood.c  Since this function can eat lots of */
/* stack space!   This doesn't seem to work, though... :(    */

#include <stdio.h>
#include <exec/types.h>
#include <clib/graphics_protos.h>
#include <intuition/intuition.h>
#include <libraries/dos.h>

#include "palette.h"
#include "amislate.h"
#include "DrawLang.h"
#include "remote.h"
#include "tools.h"
#include "flood.h"

extern struct Window * DrawWindow;
extern BOOL BSafeFloods;
extern char * pcWhatToAbort;

extern struct PaintInfo PState;

BYTE bFloodFromCode = FROM_IDCMP;

static BOOL BFloodAbort;

/* Recursively flood fills.  Returns the position of the rightmost
   pixel in the current line */
   
/* nLast shows where this instances parent was:
		0 = no parent instance
		1 = parent instance was below us
		-1= parent instance was above us

	nOldL, and nOldR give the boundaries of our parent.
*/
int FloodFill(int X, int Y, ULONG ulFillThisColor, int nLast, int nOldL, int nOldR, LONG DestCode)
{
	int nReturn;
	pcWhatToAbort = "Flood Fill";
	BFloodAbort = FALSE;
	nReturn = FloodFillAux(X, Y, ulFillThisColor, nLast, nOldL, nOldR, DestCode);
	PState.BPenDown = FALSE;
}	
int FloodFillAux(int X, int Y, ULONG ulFillThisColor, int nLast, int nOldL, int nOldR, LONG DestCode)
{
	int nTemp=X, XLeft=X, XRight=X;

	if (BFloodAbort == TRUE) return(0);
	if (CheckForUserAbort() == TRUE) {BFloodAbort = TRUE; return(0); }

	/* First we need to see how far left and right the FillThisColor extend */	
	/* keep stepping until we reach side of the screen or end of line */	
	while ((XLeft > DrawWindow->BorderLeft) && 
	 		 (ReadPixel(DrawWindow->RPort,XLeft,Y) == ulFillThisColor))
					XLeft--;
	XLeft++;

	/* keep stepping until we reach side of the screen or end of line */	
	while ((XRight < nGetToolBoxLeft()-2) &&
			 (ReadPixel(DrawWindow->RPort,XRight,Y) == ulFillThisColor))
					XRight++;
	XRight--;

	/* Send this line to our peer if we're doing floods with lines */
	if (BSafeFloods == TRUE) OutputAction(bFloodFromCode, MODE_LINE, XLeft, Y, XRight, Y, DestCode);

	/* Now draw the line for OUR function! */
	Move(DrawWindow->RPort, XLeft,  Y);
	Draw(DrawWindow->RPort, XRight, Y);
	
	/* Now we go along the line from left to right, issuing FloodFillAuxs for
	   every adacent line of the same color we find */
	/* First fill upwards--if we're not at the top!  */
	/* ... and if we didn't just come down from a line that is wider than us! */
	if ((Y >= DrawWindow->BorderTop +2) &&
	    ((nLast != -1) || (nOldL > XLeft) || (nOldR < XRight)))
	{
		nTemp = XLeft;
		while (nTemp <= XRight)
		{
			if (ReadPixel(DrawWindow->RPort, nTemp, Y-1) == ulFillThisColor)
				nTemp = FloodFillAux(nTemp, Y-1, ulFillThisColor, 1, XLeft, XRight, DestCode) + 1;
			else
				nTemp++;
			if (BFloodAbort == TRUE) return(0);
		}
	}
	
	/* Now fill downwards -- if we're not at the bottom! */
	/* ... and if we didn't just come up from a line that is wider than us! */
	if ((Y >= nGetDrawWindowBottom()) ||
		 ((nLast == 1) && (nOldL <= XLeft) && (nOldR >= XRight)))
			return(XRight);
			
	nTemp = XLeft;
	while (nTemp <= XRight)
	{
		if (ReadPixel(DrawWindow->RPort, nTemp, Y+1) == ulFillThisColor)
			nTemp = FloodFillAux(nTemp, Y+1, ulFillThisColor, -1, XLeft, XRight, DestCode) + 1;
		else
			nTemp++;
		if (BFloodAbort == TRUE) return(0);
	}
						
	return(XRight);
}
		 		

/* Memory panic! */
void stack_abort(void)
{
	CleanExit(RETURN_ERROR);
}


