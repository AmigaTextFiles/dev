#include <stdio.h>
#include <stdlib.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <exec/types.h>
#include <libraries/dos.h>			/* contains RETURN_OK, RETURN_WARN #def's */
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/dos_protos.h>
#include <string.h>
#include <graphics/gfxbase.h>

#include "AmiSlate.h"
#include "DrawRexx_aux.h"
#include "drawrexx.h"
#include "Remote.h"
#include "DrawLang.h"
#include "tools.h"
#include "palette.h"
#include "flood.h"

#define INTUI_V36_NAMES_ONLY

#define INVALID_POS    -1
#define DELETE 127
#define BACKSPACE 8

#define POLYBOXTOP	55
#define POLYBOXLEFT	32
#define POLYBOXWIDTH	 4
#define POLYBOXHEIGHT	 4

extern struct Library *IntuitionBase = NULL;
extern struct GfxBase *GraphicsBase  = NULL;
extern struct Window *DrawWindow;
extern struct BitMap ToolBoxBitMap, ToolBoxHBitMap;
extern struct Screen *Scr;
extern __chip UWORD waitPointer[];
extern FILE *fpIn;

extern struct PaintInfo PState;

extern int Not[2] = {TRUE, FALSE};             /* NOT lookup array */
extern int XPos, YPos;
extern int nWinOldHeight, nWinOldWidth;
extern BOOL BSafeFloods;
extern BOOL BNetConnect;
extern BOOL BIgnoreResizeEvent;

/* Private local variables */
static int XBeginLine = -1, YBeginLine = -1, XEraseTo = -1, YEraseTo = -1;
static int XCircleCenter = -1, YCircleCenter = -1, XCircleRadius = -1, YCircleRadius = -1;
static int XBeginSquare = -1, YBeginSquare = -1, XEraseSquareTo = -1, YEraseSquareTo = -1;
static int XBeginPoly = -1, YBeginPoly = -1, XLastPoly = -1, YLastPoly = -1, XErasePoly = -1, YErasePoly = -1;
static int XPen = -1, YPen = -1;
static BOOL BPenLastIn = FALSE;

/* Enable/disable drawing based on BCanDraw */
void EnableDraw(BOOL BCanDraw)
{
	if (BCanDraw == FALSE)
	{
		if (PState.BPenDown == TRUE) 
		{
			BreakAction(PState.uwMode);
			PState.BPenDown = FALSE;
		}
	}
	else
    	{
		/* Reset polygon tool */
            	XLastPoly = -1; YLastPoly = -1;
		XBeginPoly = -1;  YBeginPoly = -1;
            	XErasePoly = -1; YErasePoly = -1;
            
		/* UnMark toolbox gadget to show we're out of the polygon "mode" */
		if (PState.uwMode == MODE_POLY) 
    		SetAPen(DrawWindow->RPort, 3);
	        else
	        SetAPen(DrawWindow->RPort, 0);
	            
		Rectangle(nGetToolBoxLeft()+POLYBOXLEFT, nGetToolBoxTop()+POLYBOXTOP, nGetToolBoxLeft()+POLYBOXLEFT+POLYBOXWIDTH, nGetToolBoxTop()+POLYBOXTOP+POLYBOXHEIGHT, TRUE);
	}									
	PState.BDrawEnabled = BCanDraw;
	return;
}

int nGetDrawWindowBottom(void)
{
	return(DrawWindow->Height - DrawWindow->BorderBottom - 26);
}

/* Fixes Co-ordinates so that 0,0 is actually the left top corner of the
   drawing area instead of the left top corner of the window */
void FixCoords(int *X, int *Y)
{
	*X += DrawWindow->BorderLeft+1;
	*Y += DrawWindow->BorderTop+1;
}

/* Undoes FixCoords */
void UnFixCoords(int *X, int *Y)
{
	*X -= DrawWindow->BorderLeft+1;
	*Y -= DrawWindow->BorderTop+1;
}



BOOL FixPos(int *X, int *Y)
{
  int nReturnVal = TRUE;
  
  if (*X <= DrawWindow->BorderLeft)
  {
     *X = DrawWindow->BorderLeft + 1;
     nReturnVal = FALSE;
  }
  if (*Y <= DrawWindow->BorderTop)    
  {
  	  *Y = DrawWindow->BorderTop + 1;
  	  nReturnVal = FALSE;
  }
   							
  if (*X >= (DrawWindow->Width-DrawWindow->BorderRight-PState.nToolBoxWidth-2))   
  {
     *X = DrawWindow->Width-DrawWindow->BorderRight-PState.nToolBoxWidth - 3;
     nReturnVal = FALSE;
  }
  if (*Y >= (DrawWindow->Height - DrawWindow->BorderBottom-25))	
  {
     *Y = (DrawWindow->Height - DrawWindow->BorderBottom-26);
     nReturnVal = FALSE;
  }
  return(nReturnVal);
}



/* Attempts to resize the window.  Calls DrawResizedWindow to handle the
   actual graphics redraw; this function is here mostly to handle synchronization
   between two clients.  */
BOOL ReSizeWindow(int nWidth, int nHeight, BOOL BCausedLocally)
{
	/* Only do this semaphore-stuff if we're connected, of course! */
	if (BNetConnect == FALSE)
	{
		PState.uwWidth = nWidth;		/* 2 lines test code! */
		PState.uwHeight = nHeight;
		DrawResizedWindow(nWidth, nHeight, BCausedLocally);
		return(TRUE);
	}
	
	if (BCausedLocally == TRUE)
	{
		switch(PState.nSizeState)
		{
			/* Passive:  We're waiting for a remote resize.  Don't do anything now. */
			case SIZEMODE_PASSIVE: 
				return(FALSE);	
				break;

			/* Normal:  Tell the other guy to prepare for a resize.  Don't do anything til he's ready */					
			case SIZEMODE_NORMAL:
				PState.nSizeState = SIZEMODE_ACTIVE;	/* We'll do our best! */
				/* Get the other guy's attention */
				OutputAction(FROM_IDCMP, COMMAND, COMMAND_SIZELOCK, NOP_PAD, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);    
				PState.uwWidth = nWidth;	/* test - record co-ordinates to use */
				PState.uwHeight = nHeight;
				return(TRUE);		/* Wait for the okay */
			
			/* We're already waiting for an okay, so don't do anything; it'll be overwritten any-hway! */
			case SIZEMODE_ACTIVE:
				return(TRUE);	
				break;
				
			default:
				Printf("ReSizeWindow:  Bad nSizeState (1)\n");
				break;
		}
	}
	else
	{
		switch(PState.nSizeState)
		{
			/* This is what we were waiting for.  Resize to their specifications. */
			case SIZEMODE_PASSIVE:
				PState.nSizeState = SIZEMODE_NORMAL;	/* we should be ok now */
				DrawResizedWindow(nWidth, nHeight, BCausedLocally);
				return(TRUE);
				break;
			
			/* We weren't warned!  This shouldn't ever happen.  Go with it, but give a warning message. */	
			case SIZEMODE_NORMAL:
				SetWindowTitle("Warning--Unlocked resizing!!!!");
				DrawResizedWindow(nWidth, nHeight, BCausedLocally);
				return(TRUE);
				break;
				
			/* In this case, we got pre-empted while waiting to send our size data.
			   The easiest way to deal with this is to knuckle under, and go with what
			   the other guy wants, forgetting our original resize.  */
			case SIZEMODE_ACTIVE:
				PState.nSizeState = SIZEMODE_NORMAL;
				OutputAction(FROM_IDCMP, COMMAND, COMMAND_SIZEUNLOCK, NOP_PAD, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);    
				DrawResizedWindow(nWidth, nHeight, BCausedLocally);
				return(TRUE);
				break;
				
			default:
				Printf("ReSizeWindow: Bad nSizeState (2)\n");
				break;
		}
	}
	return(FALSE);
}	
	





BOOL DrawResizedWindow(int nWidth, int nHeight, BOOL BCausedLocally)
{
	int nCWidth= DrawWindow->Width, nCHeight= DrawWindow->Height;
	static LONG lsizeX, lsizeY, lCode1FromWhom;
	static const lType = REXX_REPLY_RESIZE;
	static const char szResizeMessage[30];	

	if ((nCWidth != nWidth)||(nCHeight != nHeight))
	{
		BIgnoreResizeEvent = TRUE;	/* Keep us from responding to our own resize as if the user had done it */
		ChangeWindowBox(DrawWindow, DrawWindow->LeftEdge, DrawWindow->TopEdge, nWidth, nHeight);
		Delay(15);	/* This is apparently necessary to make the functions below redraw to the NEW values */
	}
	
	EraseToolBox(nWinOldWidth,nWinOldHeight);
	EraseChatLines(nWinOldWidth, nWinOldHeight);
      	nWinOldWidth = DrawWindow->Width;
       	nWinOldHeight = DrawWindow->Height;
	DrawToolBox();
	DrawChatLines();

	sprintf(szResizeMessage,"Resize: X=%i Y=%i",DrawWindow->Width, DrawWindow->Height);
	SetWindowTitle(szResizeMessage);
	
       	/* If Rexx was waiting on this, tell it that a resize happened */
    	if (PState.uwRexxWaitMask & REXX_REPLY_RESIZE)
    	{
    	    lsizeX = DrawWindow->Width;
     	    lsizeY = DrawWindow->Height;
	    
	    if (BCausedLocally == TRUE) lCode1FromWhom = 0L; else lCode1FromWhom = 1L;
	    
	    ((struct rxd_waitevent *) *(&RexxState.array))->res.code1= &lCode1FromWhom;
   	    ((struct rxd_waitevent *) *(&RexxState.array))->res.type = &lType;
   	    ((struct rxd_waitevent *) *(&RexxState.array))->res.x    = &lsizeX;
   	    ((struct rxd_waitevent *) *(&RexxState.array))->res.y    = &lsizeY;
	
	    SetStandardRexxReturns();
        }
    
 
 	/* If we didn't resize to what we wanted to, simulate another resize on
	   back to adjust! */
	if ((DrawWindow->Width != nWidth)||(DrawWindow->Height != nHeight))
		ReSizeWindow(DrawWindow->Width, DrawWindow->Height, TRUE);

	return(TRUE);
}





/* ---------------- FUNCTIONS FOR CHAT LINES ---------------- */
void EraseChatLines(int nWidth, int nHeight)
{
	int nToolBoxLeft;
	int nBottomOfWindow;
	int nChatLineHeight = 10;
	
	if (nWidth < 0)
   {
   	nWidth = PState.nDefaultWidth;
   	nHeight = PState.nDefaultHeight;
   }
   /* nToolBoxLeft, nBottomOfWindow are SPECIALLY CALCULATED here because
      they are based on the PREVIOUS values of the window size... nWidth
      and nHeight.  */
   nToolBoxLeft = nWidth - DrawWindow->BorderRight - PState.nToolBoxWidth + 1;  
	nBottomOfWindow = nHeight - DrawWindow->BorderBottom - 1;

	/* These two if's keep us from drawing lines off the border of the win */
	if ((DrawWindow->Height - DrawWindow->BorderBottom - 1) < nBottomOfWindow)
			 nBottomOfWindow = DrawWindow->Height - DrawWindow->BorderBottom - 1;
	if (nGetToolBoxLeft() < nToolBoxLeft) nToolBoxLeft = nGetToolBoxLeft();
	
	SetAPen(DrawWindow->RPort,0);
	
	/* Erase lines */
	Rectangle(DrawWindow->BorderLeft+1,
				 nBottomOfWindow-(nChatLineHeight*2)-4,
				 nToolBoxLeft-2, 
				 nBottomOfWindow, TRUE);	 
	return;
}



void DrawChatLines(void)
{
	int nToolBoxLeft = nGetToolBoxLeft();
	int nBottomOfWindow = DrawWindow->Height-DrawWindow->BorderBottom-1;
	int nChatLineHeight = 10;

	/* Clear the area */
	SetAPen(DrawWindow->RPort,0);
	Rectangle(DrawWindow->BorderLeft+1, nBottomOfWindow-(nChatLineHeight*2)-3,
				 nToolBoxLeft-3, nBottomOfWindow-1, TRUE);
		
	SetAPen(DrawWindow->RPort,1);
	
	/* Draw lower, "local" window */
	Rectangle(DrawWindow->BorderLeft+1, nBottomOfWindow-1,
				 nToolBoxLeft-3, nBottomOfWindow-nChatLineHeight-1, FALSE);
				 
	/* Draw upper, "remote" window */
	Rectangle(DrawWindow->BorderLeft+1, nBottomOfWindow-nChatLineHeight-3,
				 nToolBoxLeft-3, nBottomOfWindow-(nChatLineHeight*2)-3, FALSE);
				 
	return;
}
	


void DisplayKeyPress(char nChar, BOOL BEchoToRemote)
{
	int nToolBoxLeft = nGetToolBoxLeft();
	int nTextHeight = 12;
	int nBotOfGad = DrawWindow->Height - DrawWindow->BorderBottom - 4;
	LONG DestCode = DEST_FILE;
	
	/* If caused locally, echo--only if we're not already echoing everything,
	   because we're reading from a file  */
	if ((BEchoToRemote == TRUE)&&(fpIn == NULL))
		OutputAction(FROM_IDCMP, MODE_DTEXT, nChar, NOP_PAD, NOP_PAD, NOP_PAD, (DestCode|DEST_PEER));
		
 	if ((nChar != DELETE)&&(nChar != BACKSPACE))
	{
		if ((nChar < ' ')||(nChar > '|')) nChar = ' ';
		/* StuffNewChar(nChar,sLocalBuffer); */
		SetAPen(DrawWindow->RPort,1);
		Move(DrawWindow->RPort,nGetToolBoxLeft()-nTextHeight-2, nBotOfGad-((BEchoToRemote==FALSE)*nTextHeight));
		ScrollRaster(DrawWindow->RPort,8,0,DrawWindow->BorderLeft+4,
							nBotOfGad-nTextHeight+5-((BEchoToRemote==FALSE)*nTextHeight), 
							nGetToolBoxLeft()-4,
							nBotOfGad+1-((BEchoToRemote==FALSE)*nTextHeight));
		Text(DrawWindow->RPort,&nChar,1);	
	}
	else
	{
		SetAPen(DrawWindow->RPort,0);
		RectFill(DrawWindow->RPort,nGetToolBoxLeft()-13, 
								nBotOfGad-nTextHeight+5-((BEchoToRemote==FALSE)*nTextHeight), 
								nGetToolBoxLeft()-4, 
								nBotOfGad+1-((BEchoToRemote==FALSE)*nTextHeight));
		SetAPen(DrawWindow->RPort,PState.uwFColor);
		ScrollRaster(DrawWindow->RPort,-8,0,DrawWindow->BorderLeft+4,
								nBotOfGad-nTextHeight+5-((BEchoToRemote==FALSE)*nTextHeight), 
								nGetToolBoxLeft()-4,
								nBotOfGad+1-((BEchoToRemote==FALSE)*nTextHeight));
	}		
	return;
}



/* ---------------- FUNCTIONS FOR MODE_DOT ------------------ */
/* What to do in MODE_DOT when the user pushes the left mouse button */
/* returns true if cursor is in window, else false */
static BOOL Mode_Dot_MouseDown(void)
{
	Mode_Dot_MouseMove();		/* That's it, really */
}

/* What to do in MODE_DOT when the user moves the mouse */
/* returns true if cursor is in window, else false */
static BOOL Mode_Dot_MouseMove(void)
{
	BOOL BInWindow = FixPos(&XPos, &YPos);

	SetAPen(DrawWindow->RPort,PState.uwFColor); 
	
	if (BInWindow == TRUE) 
	{
			WritePixel(DrawWindow->RPort,XPos,YPos);
			OutputAction(FROM_IDCMP, MODE_DOT, XPos, YPos, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);
	}
	return(TRUE);
}

/* What to do in MODE_DOT when the user releases the mouse button */
/* returns true if cursor is in window, else false */
static BOOL Mode_Dot_MouseUp(void)
{
	return(TRUE);
}


static BOOL Mode_Dot_Break(BOOL BResume)
{
	/* nothing needs to be done here */
	return(TRUE);
}



/* ---------------- FUNCTIONS FOR MODE_PEN ------------------ */

/* What to do in MODE_PEN when the user pushes the left mouse button */
/* returns true if cursor is in window, else false */
static BOOL Mode_Pen_MouseDown(void)
{
	if ((BPenLastIn = FixPos(&XPos, &YPos)) == TRUE) 
	{
		Move(DrawWindow->RPort, XPos, YPos);
		XPen = XPos;
		YPen = YPos;
		OutputAction(FROM_IDCMP, MODE_PEN, XPos, YPos, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);
		SetAPen(DrawWindow->RPort,PState.uwFColor); 
		WritePixel(DrawWindow->RPort, XPos, YPos);
		return(TRUE);
	}
	return(FALSE);
}

/* What to do in MODE_PEN when the user moves the mouse */
/* returns true if cursor is in window, else false */
static BOOL Mode_Pen_MouseMove(void)
{
	BOOL BInWindow = FixPos(&XPos, &YPos);

	SetAPen(DrawWindow->RPort,PState.uwFColor); 
	
	if (BInWindow == TRUE) 
	{
		if (BPenLastIn == TRUE) 
		{
			Move(DrawWindow->RPort,XPen, YPen);
			Draw(DrawWindow->RPort,XPos, YPos);
			OutputAction(FROM_IDCMP, MODE_PEN, XPos, YPos, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);
		}		
		else
		{
			FixPos(&XPen, &YPen);
			Move(DrawWindow->RPort,XPen,YPen);
			Draw(DrawWindow->RPort,XPos,YPos);
			OutputAction(FROM_IDCMP, MODE_PEN, XPen, YPen, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);
			OutputAction(FROM_IDCMP, MODE_PEN, XPos, YPos, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);
		}		
		BPenLastIn = TRUE;
	}
	else
	{
	   if (BPenLastIn == TRUE)
	   {
	   	Move(DrawWindow->RPort,XPen, YPen);
			Draw(DrawWindow->RPort,XPos, YPos);	
			OutputAction(FROM_IDCMP, MODE_PEN, XPos,        YPos,    NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);   
			OutputAction(FROM_IDCMP, MODE_PEN, STOP_STRING, NOP_PAD, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);
		}
	   BPenLastIn = FALSE;
	}
	
	XPen = XPos;
	YPen = YPos;
	return(TRUE);
}





/* What to do in MODE_PEN when the user releases the mouse button */
/* returns true if cursor is in window, else false */
static BOOL Mode_Pen_MouseUp(void)
{
	OutputAction(FROM_IDCMP, MODE_PEN, STOP_STRING, STOP_STRING, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);
	XPos = INVALID_POS;
	YPos = INVALID_POS;
 	return(TRUE);
}




/* When interrupted, we need to save the current draw position in order
   to to start from there again when we continue */
static BOOL Mode_Pen_Break(BOOL BResume)
{
	if (BResume == TRUE) Move(DrawWindow->RPort, XPen, YPen);
	return(TRUE);
}





/* ---------------- FUNCTIONS FOR MODE_LINE ------------------ */

/* What to do in MODE_LINE when the user pushes the left mouse button */
/* returns true if cursor is in window, else false */
static BOOL Mode_Line_MouseDown(void)
{
	FixPos(&XPos, &YPos);
	XBeginLine = XPos;
	YBeginLine = YPos;
	XEraseTo = XPos;
	YEraseTo = YPos;
	
	/* Set Color, XOR drawing so as not to destroy underlying pic */
	SetAPen(DrawWindow->RPort,PState.uwFColor); 	
	SetDrMd(DrawWindow->RPort, COMPLEMENT);
	
	WritePixel(DrawWindow->RPort,XPos,YPos);

	SetDrMd(DrawWindow->RPort, JAM1);

	return(TRUE);
}



/* What to do in MODE_LINE when the user moves the mouse */
/* returns true if cursor is in window, else false */
static BOOL Mode_Line_MouseMove(void)
{
	FixPos(&XPos, &YPos);
	
	/* Set Color, XOR drawing so as not to destroy underlying pic */
	SetAPen(DrawWindow->RPort,PState.uwFColor); 	
	SetDrMd(DrawWindow->RPort, COMPLEMENT);
	
	/* Erase old line */
	Move(DrawWindow->RPort, XBeginLine, YBeginLine);
	Draw(DrawWindow->RPort, XEraseTo, YEraseTo);
	
	/* Draw new one */
	Move(DrawWindow->RPort, XBeginLine, YBeginLine);
   	Draw(DrawWindow->RPort, XPos, YPos);
   
   	/* Prepare for next erase */
   	XEraseTo = XPos;
   	YEraseTo = YPos;
   	
	SetDrMd(DrawWindow->RPort, JAM1);
	return(TRUE);
}



/* What to do in MODE_LINE when the user releases the mouse button */
/* returns true if cursor is in window, else false */
static BOOL Mode_Line_MouseUp(void)
{
	/* Set Color */
	SetAPen(DrawWindow->RPort,PState.uwFColor); 	

	FixPos(&XPos, &YPos);
		
	/* Draw final line */
	Move(DrawWindow->RPort, XBeginLine, YBeginLine);
   Draw(DrawWindow->RPort, XPos, YPos);

	OutputAction(FROM_IDCMP, MODE_LINE, XBeginLine, YBeginLine, XPos, YPos, DEST_PEER|DEST_FILE);
   
 	return(TRUE);
}


/* When interrupted, we need to save the current draw position in order
   to to start from there again when we continue */
static BOOL Mode_Line_Break(BOOL BResume)
{	

	/* In both cases here, the action is the same.  XOR will erase
	   the line when it's there, and restore it when it's not. */
		   
	/* Set Color, XOR drawing so as not to destroy underlying pic */
	SetAPen(DrawWindow->RPort,PState.uwFColor); 	
	SetDrMd(DrawWindow->RPort, COMPLEMENT);

	/* Erase/Restore line */
	Move(DrawWindow->RPort, XBeginLine, YBeginLine);
	Draw(DrawWindow->RPort, XEraseTo, YEraseTo);

	SetDrMd(DrawWindow->RPort, JAM1);	

	return(TRUE);
}







/* ---------------- FUNCTIONS FOR MODE_CIRCLE ------------------ */

/* What to do in MODE_CIRCLE when the user pushes the left mouse button */
/* returns true if cursor is in window, else false */
static BOOL Mode_Circle_MouseDown(void)
{
	FixPos(&XPos, &YPos);
	XCircleCenter = XPos;
	YCircleCenter = YPos;
	XCircleRadius = 0;
	YCircleRadius = 0;
	
	/* Set Color, XOR drawing so as not to destroy underlying pic */
	SetAPen(DrawWindow->RPort,PState.uwFColor); 	
	SetDrMd(DrawWindow->RPort, COMPLEMENT);
	WritePixel(DrawWindow->RPort,XPos,YPos);	
	SetDrMd(DrawWindow->RPort, JAM1);	

	/* Experimental--shorten mousemove queue! */
	SetMouseQueue(DrawWindow,2);
	return(TRUE);
}



/* What to do in MODE_CIRCLE when the user moves the mouse */
/* returns true if cursor is in window, else false */
static BOOL Mode_Circle_MouseMove(void)
{	
	int XMin, XMax, YMin, YMax, XTestRadius, YTestRadius;
	
	FixPos(&XPos, &YPos);

	XTestRadius = abs(XPos - XCircleCenter);
	YTestRadius = abs(YPos - YCircleCenter);

	/* Make sure no part of circle extends past canvas */
	
	XMin = XCircleCenter - XTestRadius;
	if (FixPos(&XMin, &YPos) == FALSE) XTestRadius = XCircleCenter - XMin;
	
	YMin = YCircleCenter - YTestRadius;
	if (FixPos(&XPos, &YMin) == FALSE) YTestRadius = YCircleCenter - YMin;
	
	XMax = XCircleCenter + XTestRadius;
	if ((FixPos(&XMax, &YPos) == FALSE)&&((XMax - XCircleCenter) < XTestRadius)) 
				XTestRadius = (XMax - XCircleCenter);
				
	YMax = YCircleCenter + YTestRadius;
	if ((FixPos(&XPos, &YMax) == FALSE)&&((YMax - YCircleCenter) < YTestRadius))
				YTestRadius = (YMax - YCircleCenter);
	
	/* Set Color, XOR drawing so as not to destroy underlying pic */
	SetAPen(DrawWindow->RPort,PState.uwFColor); 	
	SetDrMd(DrawWindow->RPort, COMPLEMENT);
	
	/* Erase old circle */
	Ellipse(XCircleCenter, YCircleCenter, XCircleRadius, YCircleRadius, ((PState.uwMode & MODE_FILLED) != FALSE));
	
	XCircleRadius = XTestRadius;
	YCircleRadius = YTestRadius;
	
	/* Draw new one */
	Ellipse(XCircleCenter, YCircleCenter, XCircleRadius, YCircleRadius, ((PState.uwMode & MODE_FILLED) != FALSE));
     
	SetDrMd(DrawWindow->RPort, JAM1);
	return(TRUE);
}



/* What to do in MODE_CIRCLE when the user releases the mouse button */
/* returns true if cursor is in window, else false */
static BOOL Mode_Circle_MouseUp(void)
{
	/* Set Color */
	SetAPen(DrawWindow->RPort,PState.uwFColor);
	
	/* Draw final circle */
	Ellipse(XCircleCenter, YCircleCenter, XCircleRadius, YCircleRadius, ((PState.uwMode & MODE_FILLED) != FALSE));

	OutputAction(FROM_IDCMP, PState.uwMode, XCircleCenter, YCircleCenter, XCircleRadius, YCircleRadius, DEST_PEER|DEST_FILE);

	/* Experimental - restore queue to normal length */
	SetMouseQueue(DrawWindow,5);
	
 	return(TRUE);
}






static BOOL Mode_Circle_Break(BOOL BResume)
{
	/* Again both actions are the same.  XOR will erase and then
	   redraw. */

	/* Set Color, XOR drawing so as not to destroy underlying pic */
	SetAPen(DrawWindow->RPort,PState.uwFColor); 	
	SetDrMd(DrawWindow->RPort, COMPLEMENT);

	/* Erase old circle */
	Ellipse(XCircleCenter, YCircleCenter, XCircleRadius, YCircleRadius, ((PState.uwMode & MODE_FILLED) != FALSE));

	SetDrMd(DrawWindow->RPort, JAM1);	

	return(TRUE);
}




/* ---------------- FUNCTIONS FOR MODE_POLY ------------------ */
/* Resets Polygon tool to original state.  */
void ResetPolygonTool(void)
{
	XBeginPoly = -1;
	YBeginPoly = -1;
}

/* What to do in MODE_POLY when the user pushes the left mouse button */
/* returns true if cursor is in window, else false */
static BOOL Mode_Poly_MouseDown(void)
{
	if (FixPos(&XPos, &YPos) == FALSE) return(FALSE);	

	if ((XBeginPoly == -1)&&(YBeginPoly == -1))
	{	
		/* Begin Polygon! */
		XBeginPoly = XPos;	/* First point in polygon */
		YBeginPoly = YPos;
		XLastPoly  = XPos;  /* Last point drawn to */
		YLastPoly  = YPos;
		XErasePoly = XPos;
		YErasePoly = YPos;

		/* Set Color, XOR drawing so as not to destroy underlying pic */
		SetAPen(DrawWindow->RPort,PState.uwFColor); 	
		SetDrMd(DrawWindow->RPort, COMPLEMENT);
		WritePixel(DrawWindow->RPort,XBeginPoly,YBeginPoly);
		SetDrMd(DrawWindow->RPort, JAM1);
	}
	else
	{
		/* Set Color, XOR drawing so as not to destroy underlying pic */
		SetAPen(DrawWindow->RPort,PState.uwFColor); 	
		SetDrMd(DrawWindow->RPort, COMPLEMENT);
		Move(DrawWindow->RPort, XLastPoly, YLastPoly);
		Draw(DrawWindow->RPort, XPos,      YPos);
		XErasePoly = XPos;
		YErasePoly = YPos;
		SetDrMd(DrawWindow->RPort, JAM1);
	}
	
	/* Mark toolbox gadget to show we're in the polygon "mode" */
	SetAPen(DrawWindow->RPort, 1);
	Rectangle(nGetToolBoxLeft()+POLYBOXLEFT, nGetToolBoxTop()+POLYBOXTOP, nGetToolBoxLeft()+POLYBOXLEFT+POLYBOXWIDTH, nGetToolBoxTop()+POLYBOXTOP+POLYBOXHEIGHT, TRUE);
	
	return(TRUE);
}



/* What to do in MODE_POLY when the user moves the mouse */
/* returns true if cursor is in window, else false */
static BOOL Mode_Poly_MouseMove(void)
{
	FixPos(&XPos, &YPos);
	
	/* Set Color, XOR drawing so as not to destroy underlying pic */
	SetAPen(DrawWindow->RPort,PState.uwFColor); 	
	SetDrMd(DrawWindow->RPort, COMPLEMENT);
	
	/* Erase old line */
	Move(DrawWindow->RPort, XLastPoly, YLastPoly);
	Draw(DrawWindow->RPort, XErasePoly, YErasePoly);

	/* Draw new one */
	Move(DrawWindow->RPort, XLastPoly, YLastPoly);
    Draw(DrawWindow->RPort, XPos, YPos);

    /* Prepare for next erase */
    XErasePoly = XPos;
    YErasePoly = YPos;
   
	SetDrMd(DrawWindow->RPort, JAM1);
	return(TRUE);
}



/* What to do in MODE_POLY when the user releases the mouse button */
/* returns true if cursor is in window, else false */
static BOOL Mode_Poly_MouseUp(void)
{	
	FixPos(&XPos, &YPos);

	/* Erase temporary line */
	SetDrMd(DrawWindow->RPort, COMPLEMENT);
	Move(DrawWindow->RPort, XLastPoly, YLastPoly);
    Draw(DrawWindow->RPort, XPos, YPos);
	SetDrMd(DrawWindow->RPort, JAM1);
		
    /* End polygon if we are on the last point or the first point */
 	if ((XBeginPoly != XLastPoly)&&(YBeginPoly != YLastPoly))
 	{
 	    if ((abs(XPos-XLastPoly) <= 2)&&(abs(YPos-YLastPoly) <= 2))
		{
			/* Reset polygon */
			XPos = XLastPoly;  YPos = YLastPoly;
			XBeginPoly = -1;  YBeginPoly = -1;

			/* UnMark toolbox gadget to show we're out of the polygon "mode" */
			SetAPen(DrawWindow->RPort, 3);
			Rectangle(nGetToolBoxLeft()+POLYBOXLEFT, nGetToolBoxTop()+POLYBOXTOP, nGetToolBoxLeft()+POLYBOXLEFT+POLYBOXWIDTH, nGetToolBoxTop()+POLYBOXTOP+POLYBOXHEIGHT, TRUE);
		}
		else
	 	if ((abs(XPos-XBeginPoly) <= 2)&&(abs(YPos-YBeginPoly) <= 2))
		{
			/* Reset polygon */
			XPos = XBeginPoly;  YPos = YBeginPoly;
			XBeginPoly = -1;  YBeginPoly = -1;

			/* UnMark toolbox gadget to show we're out of the polygon "mode" */
			SetAPen(DrawWindow->RPort, 3);
			Rectangle(nGetToolBoxLeft()+POLYBOXLEFT, nGetToolBoxTop()+POLYBOXTOP, nGetToolBoxLeft()+POLYBOXLEFT+POLYBOXWIDTH, nGetToolBoxTop()+POLYBOXTOP+POLYBOXHEIGHT, TRUE);
		}
	}

	/* Set Color */
	SetAPen(DrawWindow->RPort,PState.uwFColor); 	
	
	/* Draw final line */
	Move(DrawWindow->RPort, XLastPoly, YLastPoly);
	Draw(DrawWindow->RPort, XPos, YPos);
	OutputAction(FROM_IDCMP, MODE_LINE, XLastPoly, YLastPoly, XPos, YPos, DEST_PEER|DEST_FILE);      

	/* Update last vertex drawn to */
	XLastPoly = XPos;
	YLastPoly = YPos;
 	return(TRUE);
}




/* When interrupted, we need to save the current draw position in order
   to to start from there again when we continue */
static BOOL Mode_Poly_Break(BOOL BResume)
{	

	/* In both cases here, the action is the same.  XOR will erase
	   the line when it's there, and restore it when it's not. */
		   
	/* Set Color, XOR drawing so as not to destroy underlying pic */
	SetAPen(DrawWindow->RPort,PState.uwFColor); 	
	SetDrMd(DrawWindow->RPort, COMPLEMENT);

	/* Erase/Restore line */
	Move(DrawWindow->RPort, XLastPoly, YLastPoly);
	Draw(DrawWindow->RPort, XErasePoly, YErasePoly);

	SetDrMd(DrawWindow->RPort, JAM1);	

	return(TRUE);
}








/* ---------------- FUNCTIONS FOR MODE_SQUARE ------------------ */
/* What to do in MODE_SQUARE when the user pushes the left mouse button */
/* returns true if cursor is in window, else false */
static BOOL Mode_Square_MouseDown(void)
{
	FixPos(&XPos, &YPos);
	XBeginSquare = XPos;
	YBeginSquare = YPos;
	XEraseSquareTo = XPos;
	YEraseSquareTo = YPos;
	
	/* Set Color, XOR drawing so as not to destroy underlying pic */
	SetAPen(DrawWindow->RPort,PState.uwFColor); 	
	SetDrMd(DrawWindow->RPort, COMPLEMENT);
	
	WritePixel(DrawWindow->RPort,XPos,YPos);
	SetDrMd(DrawWindow->RPort, JAM1);

	return(TRUE);
}

/* What to do in MODE_SQUARE when the user moves the mouse */
/* returns true if cursor is in window, else false */
static BOOL Mode_Square_MouseMove(void)
{
	int *X1, *X2, *X3, *Y1, *Y2, *Y3;

	FixPos(&XPos, &YPos);
	
	X1 = &XBeginSquare; 		/* X Co-ordinate of top left corner */
	X2 = &XEraseSquareTo;   /* Y Co-ordinate of top left corner */
	X3 = &XPos;
	
	Y1 = &YBeginSquare; 		/* X Co-ordinate of bottom right corner */
	Y2 = &YEraseSquareTo;   /* Y Co-ordinate of bottom right corner */
	Y3 = &YPos;
	
	/* Make sure those are right */
	if (*X1 > *X2) SwapPointers(&X1, &X2);
	if (*Y1 > *Y2) SwapPointers(&Y1, &Y2);
	
	/* Set Color, XOR drawing so as not to destroy underlying pic */
	SetAPen(DrawWindow->RPort,PState.uwFColor); 	
	SetDrMd(DrawWindow->RPort, COMPLEMENT);
		
	/* Erase old square */
	Rectangle(*X1, *Y1, *X2, *Y2, ((PState.uwMode & MODE_FILLED) != FALSE));

	/* Reset ?1 */
	X1 = &XBeginSquare; 		/* X Co-ordinate of top left corner */
	Y1 = &YBeginSquare; 		/* X Co-ordinate of bottom right corner */

	/* Make sure the others are right */
	if (*X1 > *X3) SwapPointers(&X1, &X3);
	if (*Y1 > *Y3) SwapPointers(&Y1, &Y3);
		
	/* Draw new one */
	Rectangle(*X1, *Y1, *X3, *Y3, ((PState.uwMode & MODE_FILLED) != FALSE));
   
   	/* Prepare for next erase */
   	XEraseSquareTo = XPos;
   	YEraseSquareTo = YPos;
   
	SetDrMd(DrawWindow->RPort, JAM1);
	return(TRUE);
}




/* What to do in MODE_SQUARE when the user releases the mouse button */
/* returns true if cursor is in window, else false */
static BOOL Mode_Square_MouseUp(void)
{
	int *X1, *X2, *Y1, *Y2;
	
	FixPos(&XPos, &YPos);
	
	X1 = &XBeginSquare; 		/* X Co-ordinate of top left corner */
	X2 = &XPos;   				/* Y Co-ordinate of top left corner */
	
	Y1 = &YBeginSquare; 		/* X Co-ordinate of bottom right corner */
	Y2 = &YPos;      			/* Y Co-ordinate of bottom right corner */
	
	/* Make sure those are right */
	if (*X1 > *X2) SwapPointers(&X1, &X2);
	if (*Y1 > *Y2) SwapPointers(&Y1, &Y2);
		
	/* Set Color */
	SetAPen(DrawWindow->RPort,PState.uwFColor); 	

	/* Draw final square */
	Rectangle(*X1, *Y1, *X2, *Y2, ((PState.uwMode & MODE_FILLED) != FALSE));

	OutputAction(FROM_IDCMP, PState.uwMode, *X1, *Y1, *X2, *Y2, DEST_PEER|DEST_FILE);
 	return(TRUE);
}



static BOOL Mode_Square_Break(BOOL BResume)
{
	int *X1, *X2, *Y1, *Y2;

	/* Another case of XOR doing the work for us */
		
	X1 = &XBeginSquare; 		/* X Co-ordinate of top left corner */
	X2 = &XEraseSquareTo;   /* Y Co-ordinate of top left corner */
	
	Y1 = &YBeginSquare; 		/* X Co-ordinate of bottom right corner */
	Y2 = &YEraseSquareTo;   /* Y Co-ordinate of bottom right corner */
	
	/* Make sure those are right */
	if (*X1 > *X2) SwapPointers(&X1, &X2);
	if (*Y1 > *Y2) SwapPointers(&Y1, &Y2);
	
	/* Set Color, XOR drawing so as not to destroy underlying pic */
	SetAPen(DrawWindow->RPort,PState.uwFColor); 	
	SetDrMd(DrawWindow->RPort, COMPLEMENT);
		
	/* Erase old square */
	Rectangle(*X1, *Y1, *X2, *Y2, ((PState.uwMode & MODE_FILLED) != FALSE));

	SetDrMd(DrawWindow->RPort, JAM1);

	return(TRUE);
}



/* Make a filled or empty ellipse based on BFilled */
void Ellipse(int x, int y, int rx, int ry, BOOL BFilled)
{
	if (BFilled == FALSE)
	{
		DrawEllipse(DrawWindow->RPort, x, y, rx, ry);
	}
	else
	{
		AreaEllipse(DrawWindow->RPort, x, y, rx, ry);
		AreaEnd(DrawWindow->RPort);
	}
	return;
}


/* Draw the next uwPixels pixels of a raster bitmap in the 
   RGB color uwColorCode.  If the MSB of uwColorCode is set,
   use XOR mode instead. */
void DrawRasterChunk(UWORD uwPixels, UWORD uwColorCode, struct SlateRaster *srast, int *nOptPen)
{
	/* Static to speed up function? */
	static int nPen,nLeft,nRight,nTop,nBottom,nCurrentY,nCurrentX,nLines,nTemp,nTopLines,nTempTop,nTempBot;

	if (uwPixels <= 0) return;	/* no need to do anything here! */	

	/* Set initial values */
	nPen = 1;	/* lame default */
	nLeft = srast->nRX;
	nRight  = srast->nRX + srast->nRWidth  - 1;
	nTop  = srast->nRY;
	nBottom = srast->nRY + srast->nRHeight - 1;
	nCurrentY = (srast->nRCurrentOffset / srast->nRWidth) + srast->nRY;
	nCurrentX = (srast->nRCurrentOffset % srast->nRWidth) + srast->nRX;
	nTopLines = 0;
	
	/* Figure out which color to use */
	if (srast == &PState.RexxRaster)   
		OutputAction(FROM_REXX, MODE_RASTER, uwPixels, uwColorCode, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);
	else if (srast == &PState.LocalRaster)  
		OutputAction(FROM_IDCMP, MODE_RASTER, uwPixels, uwColorCode, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);

	/* local XOR requested? */
	if (uwColorCode & 0x4000) 
	{
		uwColorCode &= ~(0x4000);	/* strip XOR bit */
		SetDrMd(DrawWindow->RPort, COMPLEMENT);
	}
	else
	{
		if (nOptPen == NULL)
		{
			SetAPen(DrawWindow->RPort,
				MatchPalette(((uwColorCode >> 8) & 0x000F), 
				     ((uwColorCode >> 4) & 0x000F), 
				      (uwColorCode       & 0x000F), FALSE, NULL, NULL));
		}
		else
		{
			SetAPen(DrawWindow->RPort,*nOptPen);
		}
	}
	
	/* Make sure drawn raster area is on canvas!*/
	FixPos(&nLeft,  &nTop);
	FixPos(&nRight, &nBottom);

	/* No need to do more than one rasterful? */
	if (uwPixels >= (srast->nRWidth * srast->nRHeight))
	{
		/* Blot out the whole raster! */
		Rectangle(nLeft, nTop, nRight, nBottom, TRUE);
				
		/* Then add the remainder to nRCurrentOffset */
		srast->nRCurrentOffset += (uwPixels % (srast->nRWidth * srast->nRHeight));
	}
	else if ((uwPixels+nCurrentX-1) <= (srast->nRX + srast->nRWidth))  /* Does the line of pixels not extend past the end of this row? */
	{
		nTemp = nCurrentX + uwPixels - 1;
		if (nTemp > nRight) nTemp = nRight; /* clip! */
		/* Draw a line from current pos to end of pixel row */
		if ((nCurrentY <= nBottom)&&(nCurrentX <= nRight))
		{
			Move(DrawWindow->RPort, nCurrentX,  nCurrentY);
			Draw(DrawWindow->RPort, nTemp, nCurrentY);
		}	
		srast->nRCurrentOffset += uwPixels;
	}
	else
	{
		/* Draw a line from current pos to the end of the current raster line */
		if ((nCurrentX <= nRight)&&(nCurrentY <= nBottom)&&(nCurrentY >= nTop))
		{
			Move(DrawWindow->RPort, nCurrentX,  nCurrentY);
			Draw(DrawWindow->RPort, nRight, nCurrentY);
		}
		nTemp = (srast->nRX + srast->nRWidth) - nCurrentX;
		if (uwPixels >= nTemp) uwPixels -= nTemp; else uwPixels = 0;
		srast->nRCurrentOffset += nTemp;
		
		nCurrentY++;		/* sort of a carriage return ;) */
		if (nCurrentY >= (srast->nRY + srast->nRHeight)) nCurrentY = srast->nRY;
		nCurrentX = srast->nRX;
		
		/* any middle lines can be drawn as a rectangle (or possibly, two rectangles) */
		nLines = (uwPixels / srast->nRWidth);

		if (nLines > 0)
		{
			nTopLines = (nCurrentY + nLines) - (srast->nRY + srast->nRHeight);
			if (nTopLines > 0) nLines -= nTopLines; 
			
			if ((nLeft < nRight)&&(nCurrentY <= nBottom)&&(nLines > 0))
			{
				nTemp = nCurrentY + nLines - 1;
				if (nTemp > nBottom) nTemp = nBottom;
				if (nTemp < nTop)    nTemp = nTop;
				Rectangle(nLeft, nCurrentY, nRight, nTemp, TRUE);
			}
			uwPixels -= (nLines * srast->nRWidth);
			srast->nRCurrentOffset += (nLines * srast->nRWidth);
			nCurrentY += nLines;
			
			if (nTopLines > 0)
			{
				/* Start at top again */
				nTempTop = srast->nRY;
				nTempBot = nTempTop + nTopLines - 1;
			
				if (nTempTop < nTop)  nTempTop = nTop;
				if (nTempBot > nBottom) nTempBot = nBottom;
				if (nTempBot >= nTop) Rectangle(nLeft, nTempTop, nRight, nTempBot, TRUE);
					
				nTemp = (nTopLines * srast->nRWidth);
				uwPixels -= nTemp;
				srast->nRCurrentOffset += nTemp;
				nCurrentY = srast->nRY + nTopLines;
			}
		}
		
		/* Now we should just have the remainder left over--draw one more line */
		if ((uwPixels > 0)&&(nCurrentY <= nBottom)&&(nCurrentY >= nTop))
		{
			nTemp = (nCurrentX + uwPixels - 1);	/* the leftovers! */
			Move(DrawWindow->RPort, nCurrentX, nCurrentY);
			FixPos(&nTemp, &nCurrentY);
			Draw(DrawWindow->RPort, nTemp, nCurrentY);
		}
		srast->nRCurrentOffset += uwPixels;
	}
	srast->nRCurrentOffset = srast->nRCurrentOffset % (srast->nRWidth * srast->nRHeight);

	SetDrMd(DrawWindow->RPort, JAM1);

	return;
}


/* Transmit the whole drawing canvas via Rasters */
void TransmitDrawCanvas(void)
{
	int x1=0, y1=0, x2=65535, y2=65535;
	int nCurrentPen, nTemp, nCount = 0;

	SetWindowTitle("Transmitting Canvas Bitmap, please wait.");
   	SetPointer(DrawWindow, waitPointer, 16, 16, -6, 0);
				
	/* Get drawing canvas boundaries */
	FixPos(&x1, &y1);
	FixPos(&x2, &y2);
		
	/* Set up our raster appropriately */
	PState.LocalRaster.nRX = x1;
	PState.LocalRaster.nRY = y1;
	PState.LocalRaster.nRWidth = x2 - x1 + 1;
	PState.LocalRaster.nRHeight = y2 - y1 + 1;
	PState.LocalRaster.nRCurrentOffset = 0;
	
	/* Send the info to our remote pal */
	OutputAction(FROM_IDCMP, COMMAND, COMMAND_SETRASTER, NOP_PAD, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);

	/* Get initial color */
	nCurrentPen = ReadPixel(DrawWindow->RPort, PState.LocalRaster.nRX, PState.LocalRaster.nRY);

	/* Scan through picture, sending on every color change */
	for (y1=PState.LocalRaster.nRY; y1<=y2; y1++)
	  for (x1=PState.LocalRaster.nRX; x1<=x2; x1++)
	  {
		nTemp = ReadPixel(DrawWindow->RPort, x1, y1);

		if (nTemp != nCurrentPen)
		{
			DrawRasterChunk(nCount, RGBComponents(nCurrentPen), &PState.LocalRaster, &nCurrentPen);
			nCurrentPen = nTemp;
			nCount = 1;
		}
		else
			nCount++;
	  }	

	/* One final chunk */
	DrawRasterChunk(nCount, RGBComponents(nCurrentPen), &PState.LocalRaster,&nCurrentPen);

	SetWindowTitle("Transmission complete.");
	ClearPointer(DrawWindow);

	/* Restore the RexxRaster in case it was in use */
	OutputAction(FROM_REXX, COMMAND, COMMAND_SETRASTER, NOP_PAD, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);


	return;
}
	

/* Makes a filled or empty Rectangle based on BFilled */
void Rectangle(int x1, int y1, int x2, int y2, BOOL BFilled)
{
	int *X1, *X2, *Y1, *Y2;

   if (BFilled == TRUE)
	{
		X1 = &x1; 	
		X2 = &x2;   
		Y1 = &y1;
		Y2 = &y2;
	
		/* Make sure those are right */
		if (*X1 > *X2) SwapPointers(&X1, &X2);
		if (*Y1 > *Y2) SwapPointers(&Y1, &Y2);

   	RectFill(DrawWindow->RPort, *X1, *Y1, *X2, *Y2);
	}
   else
   {
   	Move(DrawWindow->RPort, x1, y1);
   	Draw(DrawWindow->RPort, x2, y1);
   	Draw(DrawWindow->RPort, x2, y2);
   	Draw(DrawWindow->RPort, x1, y2);
   	Draw(DrawWindow->RPort, x1, y1);
   }
   return;
}




/* ---------------- FUNCTIONS FOR MODE_FLOOD ------------------ */

/* What to do in MODE_FLOOD when the user pushes the left mouse button */
/* returns true if cursor is in window, else false */
static BOOL Mode_Flood_MouseDown(void)
{
   ULONG ulFillThisColor = 0;
   		
	if (FixPos(&XPos, &YPos) == TRUE) 
	{
		ulFillThisColor = ReadPixel(DrawWindow->RPort,XPos,YPos);
		
		if (ulFillThisColor != PState.uwFColor)
		{
			SetAPen(DrawWindow->RPort,PState.uwFColor);

		   	SetPointer(DrawWindow, waitPointer, 16, 16, -6, 0);
		   
			if (BSafeFloods == TRUE)
		    	{
		   		/* Send flood info as a series of horizontal lines */
				FloodFill(XPos, YPos, ulFillThisColor, 0, 0, 0, DEST_PEER|DEST_FILE);
			}
			else
			{
				/* Send flood info as simple co-ordinates */
				OutputAction(FROM_IDCMP, MODE_FLOOD, XPos, YPos, ulFillThisColor, NOP_PAD, DEST_PEER|DEST_FILE);
				FloodFill(XPos, YPos, ulFillThisColor, 0, 0, 0, 0L);
			}		
			ClearPointer(DrawWindow);
			return(TRUE);
		}
	}
	return(FALSE);
}






/* What to do in MODE_FLOOD when the user moves the mouse */
/* --basically, nothing--we're not that sort of tool! */
static BOOL Mode_Flood_MouseMove(void)
{
	return(FALSE);
}





/* What to do in MODE_PEN when the user releases the mouse button */
/* do nothing */
static BOOL Mode_Flood_MouseUp(void)
{
 	return(FALSE);
}




/* When interrupted, we need to save the current draw position in order
   to to start from there again when we continue */
static BOOL Mode_Flood_Break(BOOL BResume)
{
	/* Nothing--flood fills are discrete operations! */
	return(TRUE);
}






/* ---------MOUSE ACTION DISTRIBUTION FUNCTIONS-------- */
BOOL MouseDownAction(int nMode)
{
	static LONG downX, downY;
	int ndownX, ndownY;
	const static LONG lType = REXX_REPLY_MOUSEDOWN;
	
	if (PState.uwRexxWaitMask & REXX_REPLY_MOUSEDOWN)
	{
		ndownX = XPos;		/* Record beginning co-ordinates for ARexx client */
		ndownY = YPos;
		if (FixPos(&ndownX, &ndownY) == TRUE)
		{
			UnFixCoords(&ndownX, &ndownY);
			downX = ndownX;
			downY = ndownY;
			((struct rxd_waitevent *) *(&RexxState.array))->res.type = &lType;
			((struct rxd_waitevent *) *(&RexxState.array))->res.x = &downX;
			((struct rxd_waitevent *) *(&RexxState.array))->res.y = &downY;
			SetStandardRexxReturns();
		}
	}

	if (PState.BDrawEnabled == FALSE) return(FALSE);
 	PState.BPenDown = TRUE;
	switch(nMode & ~(MODE_FILLED))
	{
		case MODE_DOT:    Mode_Dot_MouseDown();      break;
		case MODE_PEN:    Mode_Pen_MouseDown();      break;
		case MODE_LINE:   Mode_Line_MouseDown();     break;
		case MODE_CIRCLE: Mode_Circle_MouseDown();   break;				
		case MODE_SQUARE: Mode_Square_MouseDown();   break;
		case MODE_POLY:   Mode_Poly_MouseDown();     break;
		case MODE_FLOOD:  Mode_Flood_MouseDown();    break;
		default: Printf("MouseDownAction:  Bad mode!\n"); break;
	}
	return(TRUE);
}





BOOL MouseMoveAction(int nMode)
{
	if (PState.BDrawEnabled == FALSE) return(FALSE);
	switch(nMode & ~(MODE_FILLED))
	{
		case MODE_DOT:    Mode_Dot_MouseMove();     break;
		case MODE_PEN:    Mode_Pen_MouseMove();     break;
		case MODE_LINE:   Mode_Line_MouseMove();    break;
		case MODE_CIRCLE: Mode_Circle_MouseMove();  break;
 	    case MODE_SQUARE: Mode_Square_MouseMove();  break;
		case MODE_POLY:   Mode_Poly_MouseMove();    break;
		case MODE_FLOOD:  Mode_Flood_MouseMove();   break;	   
		default: Printf("MouseMoveAction:  Bad mode!\n");  break;
	}
	return(TRUE);
}			




BOOL MouseUpAction(int nMode)
{
	static LONG upX, upY;
	const static LONG lType = REXX_REPLY_MOUSEUP;
	int nupX, nupY;
	
	if (PState.uwRexxWaitMask & REXX_REPLY_MOUSEUP)
	{
		nupX = XPos;		/* Record ending co-ordinates for ARexx client */
		nupY = YPos;
		if (FixPos(&nupX, &nupY) == TRUE)
		{
			UnFixCoords(&nupX, &nupY);
			upX = nupX;
			upY = nupY;
			((struct rxd_waitevent *) *(&RexxState.array))->res.type = &lType;
			((struct rxd_waitevent *) *(&RexxState.array))->res.x = &upX;
			((struct rxd_waitevent *) *(&RexxState.array))->res.y = &upY;
			SetStandardRexxReturns();
		}
	}

	if (PState.BDrawEnabled == FALSE) return(FALSE);
 	PState.BPenDown = FALSE;

	switch(nMode & ~(MODE_FILLED))
	{
		case MODE_DOT:	  Mode_Dot_MouseUp();     break;
		case MODE_PEN:    Mode_Pen_MouseUp();     break;
		case MODE_LINE:   Mode_Line_MouseUp();    break;
		case MODE_CIRCLE: Mode_Circle_MouseUp();  break; 				
		case MODE_SQUARE: Mode_Square_MouseUp();  break;
		case MODE_POLY:   Mode_Poly_MouseUp();    break;
		case MODE_FLOOD:  Mode_Flood_MouseUp();   break;		
		default: Printf("MouseUpAction:  Bad mode!\n"); break;
	}
	return(TRUE);
}



BOOL BreakAction(int nMode)
{
	switch(nMode & ~(MODE_FILLED))
	{
		case MODE_DOT:	  Mode_Dot_Break(FALSE);     break;
		case MODE_PEN:    Mode_Pen_Break(FALSE);     break;
		case MODE_LINE:   Mode_Line_Break(FALSE);    break;
		case MODE_CIRCLE: Mode_Circle_Break(FALSE);  break; 				
		case MODE_SQUARE: Mode_Square_Break(FALSE);  break;
		case MODE_POLY:   Mode_Poly_Break(FALSE);    break;
		case MODE_FLOOD:  Mode_Flood_Break(FALSE);   break;		
		default: Printf("BreakAction:  Bad mode! [%i]\n",nMode); break;
	}
	return(TRUE);
}


BOOL ResumeAction(int nMode)
{
	switch(nMode & ~(MODE_FILLED))
	{
		case MODE_DOT:	  Mode_Dot_Break(TRUE);       break;
		case MODE_PEN:    Mode_Pen_Break(TRUE);       break;
		case MODE_LINE:   Mode_Line_Break(TRUE);      break;
		case MODE_CIRCLE: Mode_Circle_Break(TRUE);    break; 				
		case MODE_SQUARE: Mode_Square_Break(TRUE);    break;
		case MODE_POLY:   Mode_Poly_Break(TRUE);      break;
		case MODE_FLOOD:  Mode_Flood_Break(TRUE);     break;		
		default: Printf("BreakAction:  Bad mode!\n"); break;
	}
	return(TRUE);
}

