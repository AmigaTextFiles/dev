#include <stdio.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <exec/types.h>
#include <libraries/dos.h>			/* contains RETURN_OK, RETURN_WARN #def's */
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <graphics/gfxbase.h>

#include "ToolBox.h"
#include "AmiSlate.h"
#include "drawlang.h"
#include "drawrexx.h"
#include "drawrexx_aux.h"
#include "tools.h"
#include "flood.h"
#include "remote.h"
#include "palette.h"

__chip extern unsigned short toolbox_h_image[];  /* hires version */
__chip extern unsigned short toolbox_hs_image[]; /* selected */
extern int XPos, YPos;
extern struct Screen *Scr;
extern struct PaintInfo PState;
extern struct Window *DrawWindow;
extern int nSynchPaletteMode;

int nPaletteColumns;
struct BitMap ToolBoxHBitMap,ToolBoxHSBitMap;

/* palette.c -- routines for displaying and manipulating the toolbox
   and the palette */

BOOL ChangeDepth(int nNewDepth)
{	
	if ((nNewDepth > Scr->RastPort.BitMap->Depth)||(nNewDepth < 1)) return(FALSE);
			
	PState.ubDepth = nNewDepth;

	/* This will adjust the palette to the proper # of colors */
	EraseToolBox(DrawWindow->Width,DrawWindow->Height);
	DrawToolBox();

	return(TRUE);
}



void InitToolBox(void)
{
	int i;
	
	InitBitMap(&ToolBoxHBitMap, TOOLBOXH_DEPTH, TOOLBOXH_WIDTH, TOOLBOXH_HEIGHT);
	InitBitMap(&ToolBoxHSBitMap, TOOLBOXH_DEPTH, TOOLBOXH_WIDTH, TOOLBOXH_HEIGHT);
	
	for (i=0;i<ToolBoxHBitMap.Depth;i++)
	{
		ToolBoxHBitMap.Planes[i]   = 
				(PLANEPTR) &toolbox_h_image[i*(TOOLBOXH_BYTESPERROW*TOOLBOXH_ROWS)/2];
		ToolBoxHSBitMap.Planes[i]  =
				(PLANEPTR) &toolbox_hs_image[i*(TOOLBOXH_BYTESPERROW*TOOLBOXH_ROWS)/2];

	}
	return;
}





/* Draws a palette square with the given specifications.  If nRev is TRUE,
   it will make it selected */
static void DrawPaletteSquare(int nX, int nY, int nHeight, int nWidth, int nColor, BOOL BRev)
{
	int nBlack=1, nWhite=2;

	SetAPen(DrawWindow->RPort,nColor);
	RectFill(DrawWindow->RPort,nX+1,nY, nX + nWidth-1, nY + nHeight);
		
	if (BRev == TRUE) {nBlack = 2; nWhite = 1;}
		
	/* Draw outline for colorsquare */
	if ((nGetPaletteSquareWidth() > 3) && (nGetPaletteSquareHeight() > 3))
	{	
		SetAPen(DrawWindow->RPort, nBlack);	/* black */
		Move(DrawWindow->RPort, nX + nWidth - 1, nY + nHeight);
		Draw(DrawWindow->RPort, nX + nWidth - 1, nY);
		Move(DrawWindow->RPort, nX + nWidth - 1, nY + nHeight);
		Draw(DrawWindow->RPort, nX,              nY + nHeight);
	}
	
	if ((nGetPaletteSquareWidth() > 7)	&& (nGetPaletteSquareHeight() > 7))
	{
		Move(DrawWindow->RPort, nX + nWidth - 2, nY + nHeight - 1);
		Draw(DrawWindow->RPort, nX + nWidth - 2, nY + 1);
		Move(DrawWindow->RPort, nX + nWidth - 2, nY + nHeight - 1);
		Draw(DrawWindow->RPort, nX + 1,          nY + nHeight - 1);

	}	

	if ((nGetPaletteSquareWidth() > 3) && (nGetPaletteSquareHeight() > 3))
	{				
		SetAPen(DrawWindow->RPort, nWhite);
		Move(DrawWindow->RPort, nX,              nY);
		Draw(DrawWindow->RPort, nX + nWidth - 1, nY);
		Move(DrawWindow->RPort, nX,              nY);
		Draw(DrawWindow->RPort, nX,              nY + nHeight);
	}
	
	if ((nGetPaletteSquareWidth() > 7)	&& (nGetPaletteSquareHeight() > 7))
	{
		Move(DrawWindow->RPort, nX + 1,          nY + 1);
		Draw(DrawWindow->RPort, nX + nWidth - 2, nY + 1);
		Move(DrawWindow->RPort, nX + 1,          nY + 1);
		Draw(DrawWindow->RPort, nX + 1,          nY + nHeight - 1);
	}
	
	return;
}




	


static int nGetPaletteHeight(void)
{
	return(DrawWindow->Height - DrawWindow->BorderBottom - 
			   (PState.nToolBoxHeight - Scr->WBorTop + Scr->RastPort.TxHeight) - 6);
}

static int nGetNumberOfColors(void)
{
   int nNumberOfColors = 1, nCount = PState.ubDepth;
   
   /* Count number of colors in palette */
	nCount = PState.ubDepth;
	while (nCount > 0)
	{
		nNumberOfColors *= 2;
		nCount--;
	}		
	return(nNumberOfColors);
}
	
int nGetGadgetHeight(void)
{
	return(PState.nToolBoxHeight/4);
}

int nGetGadgetWidth(void)
{
	return(PState.nToolBoxWidth/2);
}

static int nGetPaletteSquareHeight(void)
{
	int nTemp = nGetNumberOfColors();
	
	/* Do we have an even number of rows? */
	while (nTemp > 0) nTemp -= nPaletteColumns;
	
	if (nTemp == 0) return(nGetPaletteHeight() / (nGetNumberOfColors()/nPaletteColumns));	
		
	nTemp = (nGetNumberOfColors()+nPaletteColumns);
	if (nTemp < 0) nTemp = nGetNumberOfColors();
	
	/* If not, make sure we are one row shorter. */
	return(nGetPaletteHeight() / (nTemp/nPaletteColumns));	
}
	
static int nGetPaletteSquareWidth(void)
{
	return(PState.nToolBoxWidth / nPaletteColumns); 
}

void DrawToolBox(void)
{
	int nToolBoxLeft = nGetToolBoxLeft(); 
	int nCount, nCurrentX, nCurrentY = DrawWindow->BorderTop;
    	int nNumberOfColors = nGetNumberOfColors(); 

	/* default:  try... */
	nPaletteColumns = 1;

	/* Try to get a good fit on palette columns */
	if (nGetPaletteSquareHeight() < 25) nPaletteColumns++;
	while ((nGetPaletteSquareHeight() < 10)&&(nPaletteColumns < 16)) nPaletteColumns++;		
	while ((nGetPaletteSquareWidth()  <  5)&&(nPaletteColumns >  1)) nPaletteColumns--;
		
	/* Draw ToolBox */
	nCurrentX = nToolBoxLeft;
	
	BltBitMapRastPort(&ToolBoxHBitMap,0,0,DrawWindow->RPort,
   		nToolBoxLeft,	DrawWindow->BorderTop,
   		TOOLBOXH_WIDTH,TOOLBOXH_HEIGHT,0xC0);

	SetAPen(DrawWindow->RPort,1); 
	Move(DrawWindow->RPort,nToolBoxLeft-1,DrawWindow->BorderTop+1);
	Draw(DrawWindow->RPort,nToolBoxLeft-1,DrawWindow->Height - DrawWindow->BorderBottom - 1);

 	/* DeSelect Current Mode */
	nCount = (PState.uwMode & ~(MODE_FILLED)) - 1;
	
	while (nCount >= 2)
	{
		nCount -= 2;	
		nCurrentY += nGetGadgetHeight();
	}
	if (nCount == 1) nCurrentX += nGetGadgetWidth();
	
	/* Select Selected Tool Square */
	BltBitMapRastPort(&ToolBoxHSBitMap,nCurrentX-nToolBoxLeft, 
							nCurrentY-DrawWindow->BorderTop, 
							DrawWindow->RPort, nCurrentX, nCurrentY, 
							nGetGadgetWidth()-1, 
							nGetGadgetHeight()-1, 0xC0);	

	SetDrMd(DrawWindow->RPort,JAM1);

	/* If we selected circle or square, figure out whether or not
	   they wanted it filled in */
	if (PState.uwMode == (MODE_SQUARE|MODE_FILLED)) Rectangle(nCurrentX+5,nCurrentY+5, nCurrentX+17, nCurrentY+17, TRUE);
	if (PState.uwMode == (MODE_CIRCLE|MODE_FILLED)) Rectangle(nCurrentX+5,nCurrentY+5, nCurrentX+17, nCurrentY+17, TRUE);

	/* Don't try to draw Palette if there's no room for it */
	if (nGetPaletteHeight() <= 0) return;
	
	/* ---Now draw Palette--- */
	nCurrentY = DrawWindow->BorderTop + PState.nToolBoxHeight;

	for (nCount = 0; nCount < nNumberOfColors; nCount++)
		DrawPaletteEntry(nCount, (PState.uwFColor == nCount));

  return;
}




void EraseToolBox(int nWidth, int nHeight)
{
	int nOldToolBoxLeft;
	int nWindowBottom;
	
	if (nWidth < 0) 
	{
   		nWidth = PState.nDefaultWidth;
   		nHeight = PState.nDefaultHeight;
	}
	if (DrawWindow->Width < nWidth) nWidth = DrawWindow->Width;
    nOldToolBoxLeft  = nWidth - DrawWindow->BorderRight - PState.nToolBoxWidth -1;  
	if (DrawWindow->Height < nHeight) nHeight = DrawWindow->Height;
	nWindowBottom = nHeight - DrawWindow->BorderBottom - 1;
	
	/* Erase ToolBox */
	SetAPen(DrawWindow->RPort,PState.uwBColor);
	Rectangle(nOldToolBoxLeft, DrawWindow->BorderTop, 
				nWidth-DrawWindow->BorderRight, nWindowBottom, TRUE);	
	return;
}


int nGetToolBoxLeft(void)
{
	return(DrawWindow->Width - DrawWindow->BorderRight - PState.nToolBoxWidth); 
}

int nGetToolBoxTop(void)
{
	return(DrawWindow->BorderTop);
}



BOOL DrawPaletteEntry(int nColor, BOOL BRev)
{
	int nCount = nColor, nX, nY, nPaletteSquareHeight, nPaletteSquareWidth;
	int nToolBoxLeft = nGetToolBoxLeft();
	
	if ((nColor<0)||(nColor >= nGetNumberOfColors())) return(FALSE);
			
	nPaletteSquareHeight = nGetPaletteSquareHeight();
	if (nPaletteSquareHeight < 0) return(FALSE);
	nPaletteSquareWidth  = nGetPaletteSquareWidth();
	if (nPaletteSquareWidth < 0 ) return(FALSE);
	
	/* Now regenerate the co-ordinates for the color */
	nY = DrawWindow->BorderTop + PState.nToolBoxHeight;
	nX = nToolBoxLeft + 1;
	while (nCount >= nPaletteColumns)
	{
		nCount -= nPaletteColumns;
		nY += nPaletteSquareHeight;
	}
	nX += nCount * nPaletteSquareWidth;	
	
	DrawPaletteSquare(nX,nY, nPaletteSquareHeight, nPaletteSquareWidth, nColor, BRev);
	return(TRUE);
}		




/* Given a tool index nIndex, set (nX, nY) to appropriate co-ordinates
   (relative to the top left of the ToolBox to click that tool */
void SetFakeToolBoxClick(int nIndex, int * nX, int * nY)
{
	int nTx = 5, nTy = 5, nHeight = nGetGadgetHeight();

	/* For selection of tools */	
	if (nIndex < 20)
	{
		/* Filled circle = mode 13 */
		if (nIndex == 13) 
		{
			nIndex = 3;	/* Circle */
			nTx += 10;
			nTy += 10;	/* Lower right side */
		}
		/* Filled circle = mode 14 */
		if (nIndex == 14) 
		{
			nIndex = 4;	/* Square */
			nTx += 10;
			nTy += 10;	/* Lower right side */
		}
		
		while (nIndex > 1)
		{
			nTy += nHeight;
			nIndex -= 2;
		}
		
		if (nIndex == 1) nTx += nGetGadgetWidth();

		*nX = nTx;
		*nY = nTy;
	}
	else
	{
		/* For selection of palette; dummy result in palette */
		*nX = 5;
		*nY = nHeight * 4 + 3;
	}
	
	return;
}
	
	
	
/* If called with nOptForceToolIndex < 0, get the tool to press from
   mouse position.  Otherwise, uses nOptForceToolIndex as index */
void HandleToolBox(int nOptForceToolIndex)
{
	int nGadgetHeight = nGetGadgetHeight();
	int nGadgetWidth  = nGetGadgetWidth();
	int XSelectIndex = -2;
	int nToolBoxLeft = nGetToolBoxLeft(); 
	int nX = XPos - nToolBoxLeft, nY = YPos-DrawWindow->BorderTop;
	int nHiLiteX = nToolBoxLeft, nHiLiteY = DrawWindow->BorderTop - nGadgetHeight;
	int nOldX = nToolBoxLeft, nOldY = DrawWindow->BorderTop;
	int nCount, nPaletteSquareHeight, nPaletteSquareWidth;
	static LONG lToolIndex;
	const static LONG lToolType = REXX_REPLY_TOOLSELECT, lColorType = REXX_REPLY_COLORSELECT;

	if (nOptForceToolIndex >= 0) SetFakeToolBoxClick(nOptForceToolIndex, &nX, &nY); 
	
	/* Figure out which Gadget was selected, if any.
	
		0	1
		2	3
		4	5
		6	7
	*/

  	while (nY > 0)
  	{
  		XSelectIndex += 2;
  		nY -= nGadgetHeight;
  		nHiLiteY += nGadgetHeight;
  	} 	
 	if (nX > nGadgetWidth) {XSelectIndex++;  nHiLiteX += nGadgetWidth;}

 	
 	if (XSelectIndex < 7)
 	{
 		/* DeSelect Current Mode */
		nCount = (PState.uwMode & ~(MODE_FILLED)) - 1;
		while (nCount >= 2)
		{
			nCount -= 2;	
			nOldY += nGadgetHeight;
		}
		if (nCount == 1) nOldX += nGadgetWidth;
		
		/* DeSelect Old Tool Square */
		BltBitMapRastPort(&ToolBoxHBitMap,nOldX - nToolBoxLeft, 
							nOldY - DrawWindow->BorderTop, 
							DrawWindow->RPort, nOldX, nOldY, 
							nGetGadgetWidth()-1, 
							nGetGadgetHeight()-1, 0xC0);	
			
		/* Now draw new selection */
		BltBitMapRastPort(&ToolBoxHSBitMap,nHiLiteX - nToolBoxLeft, 
							nHiLiteY - DrawWindow->BorderTop, 
							DrawWindow->RPort, nHiLiteX, nHiLiteY, 
							nGetGadgetWidth()-1, 
							nGetGadgetHeight()-1, 0xC0);	

		PState.uwMode = XSelectIndex + 1;
	
		/* If we selected circle or square, figure out whether or not
		   they wanted it filled in */
		if ((PState.uwMode == MODE_SQUARE)&&(nX > (-nY)))
		{
			/* Set Filled */
			PState.uwMode |= MODE_FILLED;
			SetAPen(DrawWindow->RPort, 1);
			Rectangle(nHiLiteX+5,nHiLiteY+5, nHiLiteX+17, nHiLiteY+17, TRUE);
		}
		if ((PState.uwMode == MODE_CIRCLE)&&((nX - nGetGadgetWidth()) > (-nY)))
		{
			/* Set Filled */
			PState.uwMode |= MODE_FILLED;
			SetAPen(DrawWindow->RPort, 1);
			Rectangle(nHiLiteX+5,nHiLiteY+5, nHiLiteX+17, nHiLiteY+17, TRUE);
		}			
			
		/* get out of any polygons we were in */
		ResetPolygonTool();
		
		/* Tell ARexx about if he wants to know */
		if (PState.uwRexxWaitMask & REXX_REPLY_TOOLSELECT)
		{
			lToolIndex = XSelectIndex + (((PState.uwMode & MODE_FILLED) != 0) * 10);
			((struct rxd_waitevent *) *(&RexxState.array))->res.type    = &lToolType; 
			((struct rxd_waitevent *) *(&RexxState.array))->res.code1   = &lToolIndex;
			SetStandardRexxReturns();
		}
		return;
	}
	
	/* If we get here, we either have a clear command or a palette change! */
	if (XSelectIndex == 7)
	{		
		if (PState.BDrawEnabled == TRUE)
		{
			SetAPen(DrawWindow->RPort,PState.uwBColor); 	
		
			/* Select Square */
			BltBitMapRastPort(&ToolBoxHSBitMap,nHiLiteX - nToolBoxLeft, 
								nHiLiteY - DrawWindow->BorderTop, 
								DrawWindow->RPort, nHiLiteX, nHiLiteY, 
								nGetGadgetWidth()-1, 
								nGetGadgetHeight()-1, 0xC0);	
								
			ClearWindow();
	
			/* DeSelect Square */
			BltBitMapRastPort(&ToolBoxHBitMap,nHiLiteX - nToolBoxLeft, 
								nHiLiteY - DrawWindow->BorderTop, 
								DrawWindow->RPort, nHiLiteX, nHiLiteY, 
								nGetGadgetWidth()-1, 
								nGetGadgetHeight()-1, 0xC0);	
	
			OutputAction(FROM_IDCMP, COMMAND, COMMAND_CLEAR, NOP_PAD, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);
		}

		/* Tell ARexx about if he wants to know */
		if (PState.uwRexxWaitMask & REXX_REPLY_TOOLSELECT)
		{
			lToolIndex = XSelectIndex + (((PState.uwMode & MODE_FILLED) != 0) * 10);
			((struct rxd_waitevent *) *(&RexxState.array))->res.type    = &lToolType; 
			((struct rxd_waitevent *) *(&RexxState.array))->res.code1   = &lToolIndex;
			SetStandardRexxReturns();
		}
		return;
	}			

	/* If we get here, then we have a palette change */
    	nY = YPos - (DrawWindow->BorderTop + PState.nToolBoxHeight);
	nX = XPos - nToolBoxLeft;
	XSelectIndex = -nPaletteColumns-1;  /* no, really! */

	nPaletteSquareHeight = nGetPaletteSquareHeight();
	if (nPaletteSquareHeight < 0) return;
	nPaletteSquareWidth = nGetPaletteSquareWidth();
	if (nPaletteSquareWidth < 0) return;

	while (nY > 0)
	{
	 	nY -= nPaletteSquareHeight;
	 	XSelectIndex += nPaletteColumns;
	}
	while (nX > 0)
	{
		nX -= nPaletteSquareWidth;
		XSelectIndex++;
	}
	
	DrawPaletteEntry(PState.uwFColor, FALSE);
	PState.uwFColor = XSelectIndex;

	if (nOptForceToolIndex >= 100)
	{
		nOptForceToolIndex -= 100;
		if (nOptForceToolIndex < (1<<PState.ubDepth))
				PState.uwFColor = nOptForceToolIndex;
	}
	
	DrawPaletteEntry(PState.uwFColor, TRUE);
	
	/* Tell ARexx about if he wants to know */
	if (PState.uwRexxWaitMask & REXX_REPLY_COLORSELECT)
	{
		lToolIndex = XSelectIndex + (((PState.uwMode & MODE_FILLED) != 0) * 10);
		((struct rxd_waitevent *) *(&RexxState.array))->res.type    = &lColorType; 
		((struct rxd_waitevent *) *(&RexxState.array))->res.code1   = &lToolIndex;
		SetStandardRexxReturns();
	}
	return;
}


