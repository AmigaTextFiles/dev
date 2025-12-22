#ifndef ILBM_C
#define ILBM_C

#define PIXELBUFFERSIZE 256	/* 256 bytes = 2048 pixels across */

#define MASK_NOMASK  0
#define MASK_HASMASK 1
#define MASK_TRANSP  2
#define MASK_LASSO   3

#define COMP_NONE    0
#define COMP_BYTERUN 1

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <exec/types.h>
#include <exec/memory.h>
#include <libraries/dos.h>
#include <libraries/iffparse.h>
#include <clib/dos_protos.h>
#include <clib/iffparse_protos.h>
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/exec_protos.h>
#include <datatypes/pictureclass.h>	/* for struct BitMapHeader... */

#include "amislate.h"
#include "ilbm.h"
#include "drawlang.h"
#include "remote.h"
#include "tools.h"
#include "byterun.h"
#include "drawrexx_aux.h"

#define ID_ILBM MAKE_ID('I','L','B','M')
#define ID_BMHD MAKE_ID('B','M','H','D')
#define ID_CMAP MAKE_ID('C','M','A','P')
#define ID_BODY MAKE_ID('B','O','D','Y')

struct ThreeUnsignedBytes {
	UBYTE ubRed;
	UBYTE ubGreen;
	UBYTE ubBlue;
};

extern struct PaintInfo PState;
extern BOOL BLoadIFFPalettes, BExpandIFFWindow, BProtectInter, BNetConnect;
extern struct Screen * Scr;
extern struct Window * DrawWindow;
extern char szWinTitle[];
extern char * pcWhatToAbort;

/* Our own flag!  If TRUE, we are waiting for a resize to complete
   before we draw the picture.  */
BOOL BIFFLoadPending = FALSE;

/* These are all the local variables for LoadIFF.  But to resize with
   a partner, we need to leave LoadIFF and return to it later.  This is
   implemented by splitting LoadIFF into LoadIFF1() and LoadIFF2(), and 
   setting the flag BIFFLoadPending, which will trigger a call to LoadIFF2()
   when the window has been resized. */
static struct IFFHandle * SlateIFF = NULL;
static BOOL BCompression;
static BOOL BPenMarked[MAXCOLORS];	
static UBYTE *CMAPdata = NULL;
static struct StoredProperty *BMHDProp = NULL;
static struct BitMapHeader   *BMHDhead = NULL;
static struct StoredProperty *CMAPProp = NULL;
static struct StoredProperty *BODYProp = NULL;	
static UBYTE ubPenArray[MAXCOLORS];	/* Yes, we do a max of 256 colors! */
static UBYTE *ubPixelArray=NULL;	/* holds up to one row of delicious IFF pixels! */
static UBYTE *ubByteArray=NULL;		/* holds up to 8 interbyteleaved rows */
static int i,nBytesRead,nPlane,nBytesPerRow;
static int x1,x2,y1,y2,nOutputWidth,nOutputHeight;
static int nNewWidth, nNewHeight;



/* Used for the TempRaster of ReadArrayPixel8 */
static struct RastPort tempRaster;
static struct BitMap   rMsBitMap;
	

/* Used to read proper settings */
BOOL * BOurProtectInter, * BOurExpand, * BOurLoadPalette;

/* ARexx temp settings */
BOOL BRexxProtectInter, BRexxExpand, BRexxLoadPalette;

BOOL LoadIFF1(int nFromCode, char *szFileName)
{
	pcWhatToAbort = "IFF Load";
	
	/* Choose the correct set of options */
	if (nFromCode == FROM_REXX)
	{
		BOurProtectInter = &BRexxProtectInter;
		BOurExpand       = &BRexxExpand;
		BOurLoadPalette  = &BRexxLoadPalette;
	}
	else
	{
		BOurProtectInter = &BProtectInter;
		BOurExpand       = &BExpandIFFWindow;
		BOurLoadPalette  = &BLoadIFFPalettes;
	}
	
	/* Make sure a load isn't already in progress; if it is, flush it! */
	if (SlateIFF != NULL)
	{
		 CleanUpIFF(SlateIFF);
	}
	
	/* All pens default to not-changed. */
	for (i=0;i<MAXCOLORS;i++) BPenMarked[i]=FALSE;
	
	/* protect the interface colors */
	BPenMarked[0] = TRUE + *BOurProtectInter;	/* 1=minimal protect if no */
	BPenMarked[1] = TRUE + *BOurProtectInter;	/* 2=absolute protect if yes */
	BPenMarked[2] = TRUE + *BOurProtectInter;
	BPenMarked[3] = TRUE + *BOurProtectInter;
	
	SlateIFF = AllocIFF();
	if (SlateIFF == NULL) return(FALSE);

	SlateIFF->iff_Stream = (ULONG) Open(szFileName, MODE_OLDFILE);
	if (SlateIFF->iff_Stream == 0) 
	{
		CleanUpIFF(SlateIFF);
		return(FALSE);
	}
	
	InitIFFasDOS(SlateIFF);
	if (OpenIFF(SlateIFF, IFFF_READ) != 0L)
	{
		CleanUpIFF(SlateIFF);
		return(FALSE);
	}
	
	/* Specify which chunks we want stored */
	PropChunk(SlateIFF,ID_ILBM,ID_BMHD);
	PropChunk(SlateIFF,ID_ILBM,ID_CMAP);
	StopChunk(SlateIFF,ID_ILBM,ID_BODY);

	/* Scan that bad boy! */
	ParseIFF(SlateIFF, IFFPARSE_SCAN);
	
	/* First get info from BitMap Header */
	BMHDProp = FindProp(SlateIFF, ID_ILBM, ID_BMHD);
	if (BMHDProp == NULL) 
	{
		CleanUpIFF(SlateIFF);
		return(FALSE);
	}
	
	BMHDhead = (struct BitMapHeader *) BMHDProp->sp_Data;

#ifdef DEBUG_ILBM	
	printf("BitMapHeaderInfo:\n");
	printf("Width = %u, Height = %u\n",BMHDhead->bmh_Width, BMHDhead->bmh_Height);
	printf("Depth = %u, Compre = %u\n",BMHDhead->bmh_Depth, BMHDhead->bmh_Compression);
	printf("Mask  = %u\n",BMHDhead->bmh_Masking);
#endif

	BCompression = BMHDhead->bmh_Compression;
	
	if (BMHDhead->bmh_Depth > 8)
	{
		MakeReq("AmiSlate Error","Sorry, AmiSlate only supports ILBMs of 256 colors or less","Rats");
		CleanUpIFF(SlateIFF);
		return(FALSE);
	}
	
	/* Resize if requested */
	if (*BOurExpand == TRUE) 
	{
		nNewWidth = (BMHDhead->bmh_Width + 57);
		nNewHeight= (BMHDhead->bmh_Height + ScreenTitleHeight() + 36);

		if (nNewWidth  < DrawWindow->Width)  nNewWidth  = DrawWindow->Width;
		if (nNewHeight < DrawWindow->Height) nNewHeight = DrawWindow->Height; 
		
		if ((nNewWidth != DrawWindow->Width)||(nNewHeight != DrawWindow->Height))
		{
			ReSizeWindow(nNewWidth, nNewHeight, TRUE);
			if (BNetConnect == TRUE) 
			{
				BIFFLoadPending	= TRUE;		/* flag for a return to IFF2() later */
				return(TRUE);
			}
		}
	}
	
	/* if we got here, we either didn't need to expand the window 
	   or we aren't connected to anybody, so it's already been
	   expanded.  In any case, proceed immediately to the next bit. */
	return(LoadIFF2());
}





/* This is the continuation of LoadIFF1().  It will be called immediately
   if no resizing was necessary, or when the resize is complete if resize
   was necessary and we are connected to a partner. */
BOOL LoadIFF2(void)
{	
	/* remove flag if set */
	BIFFLoadPending = FALSE;

	/* Redisplay "displaying blah" message */
	SetWindowTitle(szWinTitle);
	
	/* Now load in the ColorMap info */
	CMAPProp = FindProp(SlateIFF, ID_ILBM, ID_CMAP);
	if (CMAPProp == NULL)
	{
		if (MakeReq("AmiSlate Warning","Couldn't find ColorMap info, Continue anyway using false color?","Okay|Cancel") == 0)
		{
			CleanUpIFF(SlateIFF);
			ReplyRexxIFF(FALSE);
			return(FALSE);
		}
		/* Crappy default case:  Map each color to its pen */
		for (i=0;i<(1<<BMHDhead->bmh_Depth);i++)
			ubPenArray[i] = i % (1<<PState.ubDepth);
	}
	else
	{
		/* fill out our array of pens with the pen number
		   of the closest equivalent pen to each of the 
		   R,G,B values */
		
		/* Eventually, when we have an option to load the
		   picture's palette on to our palette, we will do
		   that here instead. */
		CMAPdata = (UBYTE *) CMAPProp->sp_Data;

		/* Load in palette if set to do so */
		if (*BOurLoadPalette == TRUE) 
		  for (i=0;i<((1<<BMHDhead->bmh_Depth)*3);i+=3)	   
		    AdaptNewColor(CMAPdata[i]>>4, CMAPdata[i+1]>>4, CMAPdata[i+2]>>4, BPenMarked, TRUE);

		/* Correlate IFF's pens with our palette */
		for (i=0;i<((1<<BMHDhead->bmh_Depth)*3);i+=3)	   
		  ubPenArray[i/3] = MatchPalette(CMAPdata[i]>>4, CMAPdata[i+1]>>4,CMAPdata[i+2]>>4,FALSE,NULL, NULL);

	}

	/* Get canvas width and height */
	x2 = 65000;	/* way off the right edge */
	y2 = 65000;	/* way off the bottom edge */
	FixPos(&x2, &y2);	/* fit them to the corner */
	x1 = 0;		/* off left edge */
	y1 = 0;		/* off top edge */
	FixPos(&x1, &y1);	/* fit them to the corner */
	
	if (BMHDhead->bmh_Width < (x2-x1+1))
		nOutputWidth = BMHDhead->bmh_Width;
	else    nOutputWidth = (x2-x1+1);

	if (BMHDhead->bmh_Height < (y2-y1+1))
		nOutputHeight = BMHDhead->bmh_Height;
	else    nOutputHeight = (y2-y1+1);
	
	/* allocate buffers */
	ubPixelArray = AllocMem(nOutputWidth,MEMF_ANY);		/* holds up to one row of delicious IFF pixels! */
	ubByteArray  = AllocMem(nOutputWidth*8,MEMF_ANY);	/* holds up to 8 interbyteleaved rows */	
	if ((ubPixelArray == NULL)||(ubByteArray == NULL))
	{
		MakeReq("AmiSlate Error","Couldn't allocate memory for IFF load buffers","Cancel");
		CleanUpIFF(SlateIFF);
		ReplyRexxIFF(FALSE);
		return(FALSE);
	}
	
	/* Set the raster to the picture's size */
	PState.LocalRaster.nRX = 0;	/* Always load to upper left! */
	PState.LocalRaster.nRY = 0;
	FixPos(&PState.LocalRaster.nRX, &PState.LocalRaster.nRY);	/* Fix that... */
	PState.LocalRaster.nRWidth = nOutputWidth;
	PState.LocalRaster.nRHeight = nOutputHeight;
	PState.LocalRaster.nRCurrentOffset = 0;
	
	OutputAction(FROM_IDCMP, COMMAND, COMMAND_SETRASTER, NOP_PAD, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);
	
	nBytesPerRow = (BMHDhead->bmh_Width + 15)/16;	/* now in words */
	nBytesPerRow *= 2;		/* convert to bytes */
	
	if ((BCompression == COMP_NONE)||(BCompression == COMP_BYTERUN))
	{		
		/* Now the tough part--loading in the pixel bits themselves... */
		for (i=0;i<nOutputHeight;i++)
		{	
		  if (CheckForUserAbort() == TRUE) 
		  {
		  	CleanUpIFF(SlateIFF);
		  	ReplyRexxIFF(FALSE);
		  	return(FALSE);
		  }
		  			
		  /* Reset buffer for this scanline = 8 bits per byte in each scanline */
		  memset(ubByteArray,0,nBytesPerRow<<3);
		  		
		  for (nPlane=0;nPlane<BMHDhead->bmh_Depth;nPlane++)
		  {
			if (BCompression == COMP_BYTERUN)
			     nBytesRead = DecompressBytes(SlateIFF, ubPixelArray, nBytesPerRow);
			else nBytesRead = ReadChunkBytes(SlateIFF,ubPixelArray,nBytesPerRow);
				
			if (nBytesRead < 0)
			{
				sprintf(ubPixelArray,"Error (%i) Reading IFF, found in line %i\0",nBytesRead, i);
				MakeReq("AmiSlate Error",ubPixelArray,"Cancel");
				CleanUpIFF(SlateIFF);
				ReplyRexxIFF(FALSE);
				return(FALSE);
			}
			else
			{
			/* or in this row to the accumulative buffer */
			OrRasterLine(ubPixelArray,ubByteArray,nPlane,nBytesPerRow);
			}
		  }

		  DecodeRasterLine(ubPenArray, ubByteArray, nOutputWidth, (i != (nOutputHeight-1)));

		  /* Read mask plane and discard it, if there is one */
		  if (BMHDhead->bmh_Masking == MASK_HASMASK) 
		  {
			if (BCompression == COMP_BYTERUN)
			     nBytesRead = DecompressBytes(SlateIFF, ubPixelArray, nBytesPerRow);
			else nBytesRead = ReadChunkBytes(SlateIFF,ubPixelArray,nBytesPerRow);
		  }
		} 	
	}
 	else
 		MakeReq("AmiSlate Error","I don't know how to decompress this ILBM.","Cancel");
 				
	CleanUpIFF(SlateIFF);
	ReplyRexxIFF(TRUE);
	return(TRUE);
}


/* If there is a Rexx command hanging on the successful completion of
   this load, then let him return with return code BWasSuccessful */
static void ReplyRexxIFF(BOOL BWasSuccessful)
{
	/* If ARexx was waiting on this, let him go */
        if (PState.uwRexxWaitMask & REXX_REPLY_IFFLOAD)
        {	
	    /* prototype: ((struct rxd_waitevent *) *(&RexxState.array))->res.code1= &lCode1FromWhom; */
	    RexxState.rc = BWasSuccessful;
	
	    SetStandardRexxReturns();
        }
	return;
}


/* Reads compressed ILBM data from SlateIFF and decompresses it into ubPixelArray until 
   nBytesPerRow bytes have been filled. */
static int DecompressBytes(struct IFFHandle * SlateIFF, UBYTE * ubPixelArray, int nBytesPerRow)
{
	int nLineCount = 0;	/* Start with zero bytes read */
	BYTE bNextByte,bCopyByte;

	while (nLineCount < nBytesPerRow)
	{
		if (ReadChunkBytes(SlateIFF,&bNextByte,1) != 1) return(nLineCount);
		if (bNextByte >= 0)
		{
			/* Copy the next n+1 bytes into the buffer */
			if (ReadChunkBytes(SlateIFF,&ubPixelArray[nLineCount],bNextByte+1) != (bNextByte+1)) return(nLineCount);
			nLineCount += bNextByte+1;
		}
		else if (bNextByte != -128)
		{
			/* Replicate the next byte 1-n times */
			if (ReadChunkBytes(SlateIFF,&bCopyByte,1) != 1) return(nLineCount);
			memset(&ubPixelArray[nLineCount],bCopyByte,1-bNextByte);
			nLineCount += 1-bNextByte;
		}
	}
	return(nLineCount);
}

			
void CleanUpIFF(struct IFFHandle * mySlateIFF)
{
	if (ubPixelArray != NULL) FreeMem(ubPixelArray,nOutputWidth);		/* holds up to one row of delicious IFF pixels! */
	if (ubByteArray  != NULL) FreeMem(ubByteArray,nOutputWidth*8);		/* holds up to one row of delicious IFF pixels! */

	ubPixelArray = NULL;
	ubByteArray = NULL;
	
	if (mySlateIFF == NULL) mySlateIFF = SlateIFF;	/* default--so that AmiSlate.c doesn't have to know about SlateIFF */
	if (mySlateIFF == NULL) return;		/* SlateIFF is NULL?  Well, nevermind then. */
	
	CloseIFF(mySlateIFF);

	if (mySlateIFF->iff_Stream != NULL) Close(mySlateIFF->iff_Stream);
	FreeIFF(mySlateIFF);

	if (mySlateIFF == SlateIFF) SlateIFF = NULL;
	
	return;
}



/* Save the current canvas as an IFF to szFileName.  Return TRUE
   if successful, else FALSE. */
BOOL SaveIFF(char *szFileName)
{
	int nTop=0,nBot=99999,nLeft=0,nRight=99999;
	int nWidth, nHeight, i, nY, nPlane, nBytesPerRow, nBytesInThisRow;
	struct BitMapHeader newBMHDhead;
	struct IFFHandle * WriteIFF = NULL;
	struct ThreeUnsignedBytes OurPaletteEntry;
	UWORD uwRGB;
	
	/* Get top left and bottom right co-ordinates */
	FixPos(&nLeft, &nTop);
	FixPos(&nRight, &nBot);
	
	nWidth  = nRight - nLeft + 1;
	nHeight = nBot   - nTop  + 1;
	
	/* Fill out our header struct */
	newBMHDhead.bmh_Width       = nWidth;
	newBMHDhead.bmh_Height      = nHeight;
	newBMHDhead.bmh_Left        = 0;
	newBMHDhead.bmh_Top 	    = 0;
	newBMHDhead.bmh_Depth       = Scr->RastPort.BitMap->Depth;
	newBMHDhead.bmh_Masking     = MASK_NOMASK;

	if (nWidth > 32)	
		newBMHDhead.bmh_Compression = COMP_BYTERUN;	
	else	
		newBMHDhead.bmh_Compression = COMP_NONE;	
		
	newBMHDhead.bmh_Pad         = 0;		/* unused */
	newBMHDhead.bmh_Transparent = 0;		/* unused */
	newBMHDhead.bmh_XAspect     = 1;		/* we're fudging this, at least for now! */
	newBMHDhead.bmh_YAspect     = 1;
	newBMHDhead.bmh_PageWidth   = Scr->Width;	/* um, this is okay, right? */
	newBMHDhead.bmh_PageHeight  = Scr->Height;	

#ifdef DEBUG
	printf("BitMapHeaderInfo:\n");
	printf("Width = %u, Height = %u\n",newBMHDhead.bmh_Width, newBMHDhead.bmh_Height);
	printf("Depth = %u, Compre = %u\n",newBMHDhead.bmh_Depth, newBMHDhead.bmh_Compression);
	printf("Mask  = %u\n",newBMHDhead.bmh_Masking);
#endif

	nBytesPerRow = (newBMHDhead.bmh_Width + 15)/16;	/* now in words */
	nBytesPerRow *= 2;				/* convert to bytes */

	/* Make sure we have mem to do this */
	if (PrepareTempRaster() == FALSE)
	{
		MakeReq("AmiSlate Error", "Not enough memory to save!", "How embarrassing");
		return(FALSE);
	}
	
	WriteIFF = AllocIFF();
	if (WriteIFF == NULL) return(FALSE);
	
	WriteIFF->iff_Stream = Open(szFileName, MODE_NEWFILE);
	if (WriteIFF->iff_Stream == NULL)
	{
		FreeIFF(WriteIFF);
		return(FALSE);
	}
	
	InitIFFasDOS(WriteIFF);
	
	if (OpenIFF(WriteIFF, IFFF_WRITE) != 0L)
	{
		Close(WriteIFF->iff_Stream);
		FreeIFF(WriteIFF);
		return(FALSE);
	}

	/* Begin writing with the standard headers */
	if (PushChunk(WriteIFF, ID_ILBM, ID_FORM, IFFSIZE_UNKNOWN) != 0L)
	{
		CleanUpIFF(WriteIFF);
		return(FALSE);
	}
	if (PushChunk(WriteIFF, ID_ILBM, ID_BMHD, sizeof(struct BitMapHeader)) != 0L)
	{
		CleanUpIFF(WriteIFF);
		return(FALSE);
	}
	
	/* The BitMapHeader info */
	if (WriteChunkBytes(WriteIFF, &newBMHDhead, sizeof(newBMHDhead)) < 0)
	{
		CleanUpIFF(WriteIFF);
		return(FALSE);
	}
	PopChunk(WriteIFF);	/* Pop BitMapHeader */
	
	if (PushChunk(WriteIFF, ID_ILBM, ID_CMAP, 3*(1<<Scr->RastPort.BitMap->Depth)) != 0L)
	{
		CleanUpIFF(WriteIFF);
		return(FALSE);
	}
	
	/* Save palette info */
  	for (i=0;i<(1<<Scr->RastPort.BitMap->Depth);i++)
  	{
  		uwRGB = RGBComponents(i);
		OurPaletteEntry.ubBlue  = (uwRGB     ) & 0x000F;
                OurPaletteEntry.ubGreen = (uwRGB >> 4) & 0x000F;
                OurPaletteEntry.ubRed   = (uwRGB >> 8) & 0x000F;

  		/* Convert to 8-bit values */
		OurPaletteEntry.ubBlue  |= (OurPaletteEntry.ubBlue   << 4);
                OurPaletteEntry.ubGreen |= (OurPaletteEntry.ubGreen  << 4);
                OurPaletteEntry.ubRed   |= (OurPaletteEntry.ubRed    << 4);
  	
		if (WriteChunkBytes(WriteIFF, &OurPaletteEntry.ubRed, sizeof(UBYTE)) < 0)
		{
			CleanUpIFF(WriteIFF);
			return(FALSE);
		}
		if (WriteChunkBytes(WriteIFF, &OurPaletteEntry.ubGreen, sizeof(UBYTE)) < 0)
		{
			CleanUpIFF(WriteIFF);
			return(FALSE);
		}
		if (WriteChunkBytes(WriteIFF, &OurPaletteEntry.ubBlue, sizeof(UBYTE)) < 0)
		{
			CleanUpIFF(WriteIFF);
			return(FALSE);
		}	
	}	
	PopChunk(WriteIFF);

	/* Now write the body header and lastly the body */
	if (PushChunk(WriteIFF, ID_ILBM, ID_BODY, IFFSIZE_UNKNOWN) != 0L)
	{
		CleanUpIFF(WriteIFF);
		return(FALSE);
	}
	
	/* Write body info */
	/* format:
	
	   scanline 0 :   bitplane 0
	   		  bitplane 1
	   		  ...
	   		  bitplane (Depth-1)
	   scanline 1:    ...
	   ...
	   scanline (nHeight-1) */
	   
	/* default: */
	nBytesInThisRow = nBytesPerRow;

	for (nY=nTop; nY<(nTop+nHeight); nY++)
	{
		for (nPlane = 0; nPlane < Scr->RastPort.BitMap->Depth; nPlane++)
		{
			/* Copy row of pixels from appropriate window bitplane into our buffer */
			GetBitRow(ubByteArray, nWidth, nY, nPlane);

			if (newBMHDhead.bmh_Compression == COMP_BYTERUN)
				nBytesInThisRow = CompressBytes(ubByteArray, nBytesPerRow);
		 
			if (WriteChunkBytes(WriteIFF, ubByteArray, nBytesInThisRow) < 0)
			{
				CleanUpIFF(WriteIFF);
				FreeTempRaster();
				return(FALSE);
			}
		}
	}
	FreeTempRaster();
	PopChunk(WriteIFF);	/* Pop Body */
	PopChunk(WriteIFF);	/* Pop Form */
	CleanUpIFF(WriteIFF);	
	return(TRUE);
}


/* Puts a row of 1-bit pixels in ubTempBuffer, from nPlane of nRow of the
   AmiSlate window.  The row will be (nBytesPerRow*8) pixels long. */
/* This function requires that the array ubTempBuffer be AT LEAST 
   nBytesPerRow long, even though it will only output nBytesPerRow/8 bytes! */
void GetBitRow(UBYTE * ubTempBuffer, int nNumPixels, int nRow, int nPlane)
{
	int i,nPixelCount=0,nRight;
	UBYTE ubCurrentPen;
	int nStartX=0;	/* will be set to the left edge of the window */
	
	FixPos(&nStartX,&nRow);		/* set nStartX */
	
	/* Read the array of pen numbers into the temp buffer */
	ReadPixelArray8(DrawWindow->RPort, nStartX, nRow, nStartX+nNumPixels-1, nRow, ubTempBuffer, &tempRaster);

	nRight = nStartX+nNumPixels;
	
	for (i=nStartX;i<nRight;i++)
	{
		ubCurrentPen = ubTempBuffer[nPixelCount];
		
		/* Isolate the bit from our bitplane */
		ubCurrentPen >>= nPlane;	/* shift it to bit 0 */	 
		ubCurrentPen  &= 0x1;		/* remove all other bits */

		/* Clear our byte if it's new */
		if ((nPixelCount % 8) == 0) ubTempBuffer[nPixelCount>>3] = 0;

		/* If our bit is one, or it in to the array in the correct bit */
		if (ubCurrentPen)
		{
			ubCurrentPen <<= (7-(nPixelCount % 8));
			ubTempBuffer[nPixelCount>>3] |= ubCurrentPen;
		}
		nPixelCount++;
	}
	/* make sure the last bytes are 0 */
	ubTempBuffer[((nPixelCount-1)>>3)+1] = 0;
	
	return;
}


/* Sets up a temporary area for ReadPixelArray8 to work with */
BOOL PrepareTempRaster(void)
{
	int nPlane;
	
	/* As per page 253 of the RKM:Includes */
	/* Make a copy of the window's RastPort */
	memcpy(&tempRaster, DrawWindow->RPort, sizeof(struct RastPort));

	/* Now do the modifications described */
	tempRaster.Layer = NULL;
	tempRaster.BitMap = &rMsBitMap;
	
	rMsBitMap.BytesPerRow = (((DrawWindow->Width+15)>>4)<<1);
	rMsBitMap.Rows	      = 1;		/* only need 1 row */
	rMsBitMap.Flags	      = 0;		/* I guess? */
	rMsBitMap.Depth	      = Scr->RastPort.BitMap->Depth;	
	for (nPlane = 0; nPlane < rMsBitMap.Depth; nPlane++)
	{
		rMsBitMap.Planes[nPlane] = AllocRaster(rMsBitMap.BytesPerRow*8, rMsBitMap.Rows);
		if (rMsBitMap.Planes[nPlane] == NULL)
		{
			FreeTempRaster();
			return(FALSE);
		}
	}
	return(TRUE);
}


BOOL FreeTempRaster(void)
{
	int nPlane;
	
	for (nPlane = 0; nPlane < rMsBitMap.Depth; nPlane++)
	{
		if (rMsBitMap.Planes[nPlane] != NULL)
		{
			FreeRaster(rMsBitMap.Planes[nPlane], rMsBitMap.BytesPerRow*8, rMsBitMap.Rows);
			rMsBitMap.Planes[nPlane] = NULL;	/* just to be safe */
		}
	}
	return(TRUE);
}
	

/* Compresses the bits in ubBuffer in-place using byte-run compression. 
   Returns the new width of the row after compression.  */
int CompressBytes(UBYTE * ubInArray, int nWidth)
{
	BYTE ubOutArray[PIXELBUFFERSIZE];	/* holds up to one row of delicious IFF pixels! */
	BYTE * ubTempOut = ubOutArray, * ubTempIn = ubInArray;
	int nReturn;
		
	/* Return number of bytes in output array */
	nReturn = PackRow((BYTE **) &ubTempIn, (BYTE **) &ubTempOut, nWidth);

	/* Put our data in the user's array */
	memcpy(ubInArray,ubOutArray,nReturn);
	
	return(nReturn);
}



/* Puts each bit in the ubPixel array into its proper spot in the
   ubByteArray.  This is basically a one-line planar to chunky
   conversion!  */
static void OrRasterLine(UBYTE * ubPixelArray, UBYTE * ubByteArray,
		int nPlaneOffset, int nBytesPerRow)
{
	int i;

   for (i=0;i<nBytesPerRow;i++)
   {	
     /* Given the ith byte of ubPixel Array, we need to spread each of
        its bits out to a separate byte in the ubByteArray.   */
      
     ubByteArray[i*8+7] |= ((ubPixelArray[i] & 0x01)!=0) << nPlaneOffset;
     ubByteArray[i*8+6] |= ((ubPixelArray[i] & 0x02)!=0) << nPlaneOffset;
     ubByteArray[i*8+5] |= ((ubPixelArray[i] & 0x04)!=0) << nPlaneOffset;
     ubByteArray[i*8+4] |= ((ubPixelArray[i] & 0x08)!=0) << nPlaneOffset;
     ubByteArray[i*8+3] |= ((ubPixelArray[i] & 0x10)!=0) << nPlaneOffset;
     ubByteArray[i*8+2] |= ((ubPixelArray[i] & 0x20)!=0) << nPlaneOffset;
     ubByteArray[i*8+1] |= ((ubPixelArray[i] & 0x40)!=0) << nPlaneOffset;
     ubByteArray[i*8+0] |= ((ubPixelArray[i] & 0x80)!=0) << nPlaneOffset;
     
   }   
   
   return;
}

	
/* Examines the scan line, compresses, draws, and transmits it!  */	
/* Note that the input array should be a "chunky" array... i.e.  */
/* an array of nWidth pen values.  We can just look use each pen */
/* value to look up what color to send from our pen array. 	 */
/*							         */
/* If BContinued is TRUE, we will add onto/draw more of the last */
/* chunk on the next pass through, otherwise we'll add it in hre */
static void DecodeRasterLine(UBYTE * ubPenArray, UBYTE * ubByteArray, int nWidth, BOOL BContinued)
{
	int x1, nTemp;
	static int nCurrentPen = -1;
	static ULONG ulCount = 0;
	
	/* Set initial color if unset */
	if (nCurrentPen < 0) nCurrentPen = ubPenArray[ubByteArray[0]]; 
	
	for (x1=0; x1<nWidth; x1++)
	{
		nTemp = ubPenArray[ubByteArray[x1]];
		
		/* Careful about pixel overflow--we don't want to bump into the control codes
		   which start at 0xF0F0 */
		if ((nTemp != nCurrentPen)||(ulCount >= 0xF000))
		{
			DrawRasterChunk(ulCount, RGBComponents(nCurrentPen), &PState.LocalRaster, &nCurrentPen);
			nCurrentPen = nTemp;
			ulCount = 1;
		}
		else
			ulCount++;
	}

	/* If we don't plan on doing any more lines, draw the last bit now */
	if (BContinued == FALSE)
	{
		DrawRasterChunk(ulCount, RGBComponents(nCurrentPen), &PState.LocalRaster, &nCurrentPen);
		
		/* Reset to initial state */
		ulCount = 0;
		nCurrentPen = -1;
	}
	return;
}



/* Given the 4-bit RGB values for a color, change the (non-marked) color in 
   our palette that is closest to this color to the new color. */
int AdaptNewColor(int red, int green, int blue, BOOL * BPenMap,BOOL BTransmit)
{
	BOOL BJustAlloced;
	UWORD uwBestPen = MatchPalette(red, green, blue, FALSE, BPenMap, &BJustAlloced);
	UWORD uwRGBComp, uwOldRGBComp = RGBComponents(uwBestPen);
	UBYTE ubRed, ubGreen, ubBlue;
	
	uwRGBComp = (red<<8)|(green<<4)|(blue);	
	if ((BJustAlloced == TRUE)||(uwRGBComp & 0x0FFF) == (uwOldRGBComp & 0x0FFF))
	{
		/* do nothing */
	}
	else
	{
		ubRed   = ((uwOldRGBComp >> 8) & 0x000F);
		ubGreen = ((uwOldRGBComp >> 4) & 0x000F);
		ubBlue  = (uwOldRGBComp & 0x000F);
		if (abs(ubRed-red) > 1)     ubRed   = (red + ubRed) >> 1;
				       else ubRed   = red;
				      
		if (abs(ubGreen-green) > 1) ubGreen = (green + ubGreen) >> 1;
			 	       else ubGreen = green;
				      
		if (abs(ubBlue-blue) > 1)   ubBlue  = (blue + ubBlue) >> 1;
				       else ubBlue  = blue;
		uwRGBComp = (ubRed<<8)|(ubGreen<<4)|(ubBlue);
	}		
	if (uwBestPen != -1) AdjustColor(0,0,uwBestPen,&uwRGBComp,BTransmit);
	return(uwBestPen);
}


#endif

