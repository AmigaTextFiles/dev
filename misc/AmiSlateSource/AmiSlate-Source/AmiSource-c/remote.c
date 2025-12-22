#include <stdio.h>
#include <stdlib.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <exec/types.h>
#include <libraries/dos.h>			/* contains RETURN_OK, RETURN_WARN #def's */
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <string.h>
#include <graphics/gfxbase.h>

#include "DrawLang.h"
#include "Tools.h"
#include "AmiSlate.h"
#include "remote.h"
#include "drawrexx.h"
#include "drawrexx_aux.h"
#include "drawtcp.h"
#include "asl.h"
#include "StringRequest.h"
#include "flood.h"
#include "ilbm.h"

#define INTUI_V36_NAMES_ONLY

#define MAXARGS 15
#define PAD_CHAR '\1'
#define PAD_STRING "\1"
#define MAGIC_BYTE 200		/* ASCII 200, the E variant used to separate substrings */

extern int Not[2];             /* a NOT lookup array */
extern struct Library *IntuitionBase;
extern struct GfxBase *GraphicsBase;
extern struct Window *DrawWindow;
extern struct PaintInfo PState;
extern struct Screen *Scr;
extern FILE *fpIn;
extern FILE *fpOut;
extern BOOL BNetConnect;
extern BOOL BPalettesLocked;
extern BOOL BAcceptingTCP;
extern BOOL BIFFLoadPending;
extern BOOL BProtectInter;
extern char targethost[100];
extern char sBuf[140];
extern char szSendString[256];
extern char szReceiveString[256];
extern char szUserString[256];
extern struct RexxHost *rexxHost;
extern char szRexxOutputFile[200];

/* Private local variables */
static int XPen = -1, YPen = -1;
static UWORD wArgs[MAXARGS];
static UWORD wCommand = NOTSENDABLE;
static int nSaveState = MODE_INVALID;
static int nNextArg = -1;
static UWORD uwPreviousMode = MODE_INVALID;		/* used by OutputAction */
static BOOL RemotePenMap[MAXCOLORS];

/* 
    Explanation of Modes used here  (#defined in DrawLang.h) :

    	MODE_COMMAND:   Have read the COMMAND keyword, awaiting command type 
    	MODE_DOT:       Awaiting dot co-ordinates
    	MODE_PEN:       Awaiting pen co-ordinates
    	MODE_LINE:      Awaiting line co-ordinates
    	MODE_CIRCLE:    Awaiting circle co-ordinates
    	MODE_SQUARE:    Awaiting square co-ordinates
    	MODE_POLY:      Awaiting poly co-ordinates
    	MODE_FLOOD:     Awaiting flood co-ordinates
    	MODE_RASTER:	Awaiting raster info
    	
    	MODE_MODE:      Awaiting new mode choice
     	
    	MODEC_RGB:       Read COMMAND_RGB keyword, awaiting RGB values
    	MODEC_SIZE:      Read COMMAND_SIZE keyword, awaiting sizing values
	MODEC_SYNCH:     Read COMMAND_SYNCH keyword, awaiting all values
	MODEC_SENDSTRING: Read COMMAND_SENDSTRING keyword (+ string), awaiting chars
		
*/

/* ---------------- Main remote function --------------------------- */
/*                                                                   */
/* Each time this functin is called it will process one word of      */
/* remote input.  It will return FALSE if it encounters a	     */
/* NOTSENDABLE or COMMAND_QUIT char, else TRUE                       */
/*								     */
/* If fpFile == NULL, we will get our input from the TCP link,       */
/* otherwise we'll read it from that file.                           */
BOOL RemoteHandler(FILE *fpFile, BOOL BEchoToRemote)
{
	UWORD uwNext;
	UBYTE ubRed, ubGreen, ubBlue;
	static UBYTE ubStringIndex = 0;
	static UWORD uwStringType  = 0;
	static LONG lStringType;
	const static LONG lType = REXX_REPLY_MESSAGE, lConnectType = REXX_REPLY_CONNECT;
	BOOL BNotBk, BXorFlag, BFilledFlag;
	int i;
	
	if (fpFile == NULL)
		uwNext = Wread(NULL, FROM_PEER);
	else
		uwNext = Wread(fpFile, FROM_FILE);

	if (uwNext == SEND_EMPTY) return(TRUE);	/* Nothing to recieve, but no errors! */
	if ((uwNext == NOTSENDABLE)||(uwNext == SEND_ERROR)) return(FALSE); 
    
	/* If we're in string mode, we listen for nothing else until it's done! */
	if (PState.uwRemoteMode == MODEC_SENDSTRING)
	{
		/* If we don't have a string type yet, the first word should
		   be it.  Get it. */
		if (uwStringType == 0) 
		{
			uwStringType = uwNext;
			return(TRUE);
		}
		
		/* Check for special end-of-string marker */
		if (uwNext == STOP_STRING) 
		{
			PState.uwRemoteMode = nSaveState;
			szReceiveString[ubStringIndex] = '\0';
			if (szReceiveString[ubStringIndex-1] == PAD_CHAR)
				szReceiveString[ubStringIndex-1] = '\0';
			
			if (PState.uwRexxWaitMask & REXX_REPLY_MESSAGE)
			{
				((struct rxd_waitevent *) *(&RexxState.array))->res.type    = &lType; 
				((struct rxd_waitevent *) *(&RexxState.array))->res.code1   = &lStringType;
				((struct rxd_waitevent *) *(&RexxState.array))->res.message = szReceiveString; 
			}
			
			switch(uwStringType)
			{
				case STRING_USER: 	  lStringType = 1; break;
				case STRING_EASYREQREP:   lStringType = 2; break;
				case STRING_STRINGREQREP: lStringType = 3; break;
				case STRING_EASYREQ:
					RemoteEasyReq();	/* We just have to send off our answer--nothing goes to REXX here */
					break;
				case STRING_STRINGREQ:
					RemoteStringReq();
					break;
				case STRING_SETWINTITLE:
					SetWindowTitle(szReceiveString);
					break;
				case STRING_REXXCOMMAND:
					RemoteRexxCommand();
					break;
				default:
					Printf("Invalid stringtype code [%i]\n",uwStringType);
					break;
			}
            
            		/* Only release an ARexx WaitEvent() if the string was one of the
            		   types meant to be sent to ARexx */
			if ((PState.uwRexxWaitMask & REXX_REPLY_MESSAGE)&&
				((uwStringType == STRING_USER)||
				 (uwStringType == STRING_EASYREQREP)||
				 (uwStringType == STRING_STRINGREQREP)))
			{	
				SetStandardRexxReturns();
 			}
		}
		else
		{
			memcpy(&szReceiveString[ubStringIndex], &uwNext, 2);
	  		if (ubStringIndex < 252) ubStringIndex += 2;
		}
		return(TRUE);
	}

	if (PState.BPenDown == TRUE) BreakAction(PState.uwMode);
		
	/* We never want to write a Quit from here, because that should only
	   be done via HandleIDCMP! */
	if (uwNext == COMMAND_QUIT)
	{
		ReceivedQuitStuff();
		return(FALSE);
	}

	if (BEchoToRemote == TRUE) Wprint(uwNext,DEST_PEER);	
	if (CheckStandardEscapes(uwNext) == FALSE)
	{
		switch(PState.uwRemoteMode & ~(MODE_FILLED) & ~(MODE_XOR))
		{			
			case MODE_MODE:
				/* Check for MODE_FILLED, and MODE_XOR modifiers */
				if (uwNext & MODE_FILLED)
				{
					BFilledFlag = TRUE;
					uwNext &= ~(MODE_FILLED);
				}
				else BFilledFlag = FALSE;
			
				if (uwNext & MODE_XOR)
				{
					BXorFlag = TRUE;
					uwNext &= ~(MODE_XOR);
				}
				else BXorFlag = FALSE;

				switch(uwNext)
				{
					case MODE_FIRST:  break;  /* This is only here to force a mode change */
					case MODE_DOT:	  PState.uwRemoteMode = MODE_DOT;    break;
					case MODE_PEN:	  PState.uwRemoteMode = MODE_PEN;    break;
					case MODE_LINE:   PState.uwRemoteMode = MODE_LINE;   break;
					case MODE_CIRCLE: PState.uwRemoteMode = MODE_CIRCLE; break;
					case MODE_SQUARE: PState.uwRemoteMode = MODE_SQUARE; break;
					case MODE_POLY:	  PState.uwRemoteMode = MODE_POLY;   break;
					case MODE_FLOOD:  PState.uwRemoteMode = MODE_FLOOD;  break;
					case MODE_DTEXT:  PState.uwRemoteMode = MODE_DTEXT;  break;
					case MODE_RASTER: PState.uwRemoteMode = MODE_RASTER; break;
					default:  Printf("Parse error: MODE_MODE [%i]\n",uwNext);
				}
				if (BFilledFlag == TRUE) PState.uwRemoteMode |= MODE_FILLED;
				if (BXorFlag == TRUE) 	 PState.uwRemoteMode |= MODE_XOR;
				break;
			
			case MODE_COMMAND:
				switch(uwNext)
				{
					case COMMAND_SIZELOCK:	  switch(PState.nSizeState)
								  {
								  	case SIZEMODE_PASSIVE:
								  		SetWindowTitle("Warning-double SizeLock!");
								  		break;
								  		
								  	case SIZEMODE_NORMAL:
								  		PState.nSizeState = SIZEMODE_PASSIVE;
								  		OutputAction(FROM_IDCMP, COMMAND, COMMAND_SIZEOK, NOP_PAD, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);
								  		break;
								  		
								  	/* This is a shitty case.  I'm waiting for his okay, and since he sent me a lock
								  	   request, that means he'll be waiting for my size-okay.  We need some asymmetry here!
								  	   so, if I'm AcceptingTCP, I'll send an Okay and go passive.  If I'm the connect-er,
								  	   I'll do nothing but wait for their okay.  */
								  	case SIZEMODE_ACTIVE:
								  		if (BAcceptingTCP == TRUE)
								  		{
								  			PState.nSizeState = SIZEMODE_PASSIVE;
								  			OutputAction(FROM_IDCMP, COMMAND, COMMAND_SIZEOK, NOP_PAD, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);
								  		}
								  		/* else: do nothing */
								  		break;
								  		
								  	default:
								  		Printf("HandleRemote:  bad nSizeState!\n");
								  		break;
								  }
								  PState.uwRemoteMode = nSaveState;
								  break;
								  
					case COMMAND_SIZEUNLOCK:  if (PState.nSizeState == SIZEMODE_PASSIVE) 
								  {
								  	PState.nSizeState = SIZEMODE_NORMAL;
								  	ReSizeWindow(DrawWindow->Height, DrawWindow->Width, TRUE);
								  }
	
								  PState.uwRemoteMode = nSaveState;
								  break;
								  
					case COMMAND_SIZEOK:	  if (PState.nSizeState == SIZEMODE_ACTIVE) 
								  {
								  	/* Draw OUR window now that we know it's ok */
								  	DrawResizedWindow(PState.uwWidth, PState.uwHeight, TRUE);
								  	OutputAction(FROM_IDCMP, COMMAND, COMMAND_SIZE, DrawWindow->Width, DrawWindow->Height, NOP_PAD, DEST_PEER|DEST_FILE);
								  	if (BIFFLoadPending == TRUE) 
								  	{
								  		if (LoadIFF2() == TRUE)		/* Draw our picture now if we were waiting to do that */
								  			SetWindowTitle("IFF Loaded/Transmited.");
								  		else
								  			SetWindowTitle("IFF Load/Transmit failed.");
								  			
								  		ClearPointer(DrawWindow);
								  	}
								  	PState.nSizeState = SIZEMODE_NORMAL;
								  }
								  else
								  SetWindowTitle("Warning--unsolicited SizeOk");
								  
								  PState.uwRemoteMode = nSaveState;
								  break;

					case COMMAND_BEEP:	  DisplayBeep(Scr);
								  PState.uwRemoteMode = nSaveState;
								  break;

					case COMMAND_CLEARMAP:	  for (i=0;i<MAXCOLORS;i++) RemotePenMap[i] = FALSE;
								  if (BProtectInter == TRUE) 
								  {
								  	RemotePenMap[0] = 2;	/* Protect GUI pens */
								  	RemotePenMap[1] = 2;
								  	RemotePenMap[2] = 2;
								  	RemotePenMap[3] = 2;
								  }
								  PState.uwRemoteMode = nSaveState;
								  break;
					
					case COMMAND_SENDSCREEN:  OutputAction(FROM_IDCMP, COMMAND, COMMAND_LOCK, NOP_PAD, NOP_PAD, NOP_PAD, DEST_PEER);
								  TransmitDrawCanvas();
								  PState.uwRemoteMode = nSaveState;				  
								  strncpy(szSendString,"Screen synchronization complete.", sizeof(szSendString));
				                                  OutputAction(FROM_IDCMP, COMMAND, COMMAND_SENDSTRING, STRING_SETWINTITLE, NOP_PAD, NOP_PAD, DEST_PEER);
				                                  OutputAction(FROM_IDCMP, COMMAND, COMMAND_UNLOCK, NOP_PAD, NOP_PAD, NOP_PAD, DEST_PEER);
								  break;
								  
					case COMMAND_LOCK:	  EnableDraw(FALSE);
								  PState.uwRemoteMode = nSaveState;
								  break;
					case COMMAND_UNLOCK:  EnableDraw(TRUE);
							      PState.uwRemoteMode = nSaveState; 
							      break;
					case COMMAND_QUIT:    ReceivedQuitStuff(); return(FALSE);
					case COMMAND_SENDPALETTE:  SetWindowTitle("Transmitting Palette to Remote...");
					 			   SendPalette(); 
					 			   SetWindowTitle("Ready.");
								   BPalettesLocked = TRUE;
								   SetMenuValues();
								   PState.uwRemoteMode = nSaveState;
								   break;
					case COMMAND_CLEAR:   ClearWindow();  
							      PState.uwRemoteMode = nSaveState; 
							      break;
					case COMMAND_HELLO:   BNetConnect = TRUE;
							      sprintf(sBuf, "Connection to %s established.", targethost);
							      SetWindowTitle(sBuf);
							      ClearWindow();
							      if (PState.uwRexxWaitMask & REXX_REPLY_CONNECT)
							      {
								((struct rxd_waitevent *) *(&RexxState.array))->res.type    = &lConnectType; 
								((struct rxd_waitevent *) *(&RexxState.array))->res.message = targethost; 
								SetStandardRexxReturns();
							      }
							      break;
					case COMMAND_SETCOLOR:PState.uwRemoteMode = MODEC_SETCOLOR; break;
					case COMMAND_RGB:     PState.uwRemoteMode = MODEC_RGB;   break;
					case COMMAND_SIZE:    PState.uwRemoteMode = MODEC_SIZE;  break;
					case COMMAND_SYNCH:   PState.uwRemoteMode = MODEC_SYNCH; break;
					case COMMAND_SENDSTRING:  PState.uwRemoteMode = MODEC_SENDSTRING;
								  ubStringIndex = 0;
								  uwStringType = 0;
								  break;			  
					case COMMAND_SETRASTER:   PState.uwRemoteMode = MODEC_SETRASTER; break;
					
					default:  Printf("Parse error: MODE_COMMAND [%i]\n", uwNext);
				}
				break;
				
			case MODE_DOT:
				if (FillArgs(uwNext,2) == TRUE) Remote_Dot(wArgs[0], wArgs[1]);
				break;
	
			case MODE_PEN:
				if (FillArgs(uwNext,2) == TRUE) 
				{
					if ((wArgs[0] == STOP_STRING)||(wArgs[1] == STOP_STRING))	
						Remote_Pen(-1, -1);	/* end the chain */
					else
						Remote_Pen(wArgs[0], wArgs[1]);
				}
				break;
								
			case MODE_LINE:
				if (FillArgs(uwNext,4) == TRUE) 
					Remote_Line(wArgs[0], wArgs[1], wArgs[2], wArgs[3]);
				break;

			case MODE_CIRCLE:
				if (FillArgs(uwNext,4) == TRUE) Remote_Circle(wArgs[0], wArgs[1], wArgs[2], wArgs[3]);
				break;
	
			case MODE_SQUARE:
				if (FillArgs(uwNext,4) == TRUE) Remote_Square(wArgs[0], wArgs[1], wArgs[2], wArgs[3]);
				break;
				
			case MODE_FLOOD:
				if (FillArgs(uwNext,3) == TRUE) Remote_Flood(wArgs[0], wArgs[1], wArgs[2]);
				break;

			case MODE_DTEXT:
				/* If we ARE echoing this, then it's from a local file, in
				   which case we want text on the BOTTOM line.  If we're NOT
				   echoing, than it's really from the remote guy, so we want
				   text on the TOP line! */
				DisplayKeyPress(uwNext, BEchoToRemote);
				break;
		
			case MODE_RASTER:
				if (FillArgs(uwNext,2) == TRUE)	DrawRasterChunk(wArgs[0],wArgs[1],&PState.RemoteRaster,NULL);
				break;
				
			case MODEC_RGB:
				if (FillArgs(uwNext,2) == TRUE)
				{
					/* Decipher 12 righthand bits of word into ints */
					ubBlue  = (wArgs[0]     ) & 0x000F;
					ubGreen = (wArgs[0] >> 4) & 0x000F;
					ubRed   = (wArgs[0] >> 8) & 0x000F;
					BNotBk  = (wArgs[0] >> 15)& 0x0001;
					PState.uwRemoteFColor = MatchPalette(ubRed, ubGreen, ubBlue, BNotBk, NULL, NULL);
					ubBlue  = (wArgs[1]     ) & 0x000F;
					ubGreen = (wArgs[1] >> 4) & 0x000F;
					ubRed   = (wArgs[1] >> 8) & 0x000F;
					BNotBk  = (wArgs[1] >> 15)& 0x0001;
					PState.uwRemoteBColor = MatchPalette(ubRed, ubGreen, ubBlue, BNotBk, NULL, NULL);
					PState.uwRemoteMode = nSaveState;
				}
				break;

			case MODEC_SETCOLOR:
				if (FillArgs(uwNext,2) == TRUE)
				{
					/* Decipher 12 righthand bits of word into ints */
					ubBlue  = (wArgs[1]     ) & 0x000F;
					ubGreen = (wArgs[1] >> 4) & 0x000F;
					ubRed   = (wArgs[1] >> 8) & 0x000F;
					BNotBk  = (wArgs[1] >> 15)& 0x0001;
					if (wArgs[0] == (~0))
					{
						/* ~0 means "find your own best spot for it" */
						AdaptNewColor(ubRed, ubGreen, ubBlue, RemotePenMap,FALSE);
					}
					else
					SetRGB4(&Scr->ViewPort, wArgs[0], ubRed, ubGreen, ubBlue);
					
					PState.uwRemoteMode = nSaveState;
				}
				break;
				
			case MODEC_SIZE:
				if (FillArgs(uwNext,2) == TRUE)
				{
					ReSizeWindow(wArgs[0], wArgs[1], FALSE);
					PState.uwRemoteMode = nSaveState;
				}				
				break;

			case MODEC_SYNCH:
				if (FillArgs(uwNext, 7) == TRUE)
				{
					PState.uwRemoteFColor = wArgs[0];
					PState.uwRemoteBColor = wArgs[1];
					if ((wArgs[2] != DrawWindow->Width) || 
					    (wArgs[3] != DrawWindow->Height)) 
					    		ReSizeWindow(Min(wArgs[2], DrawWindow->Width),
					    						 Min(wArgs[3], DrawWindow->Height), FALSE);
					PState.ubRemoteDepth = wArgs[4];
					PState.uwRemoteScreenWidth = wArgs[5];
					PState.uwRemoteScreenHeight = wArgs[6];

					/* Make our maximum window width the minimum of our two widths, and 
						our maximum window height the minimum of our two heights. */
					/* use wArgs[0] for the width, wArgs[1] for the height */
					if (PState.uwRemoteScreenWidth < Scr->Width)
						wArgs[0] = PState.uwRemoteScreenWidth;
					else
						wArgs[0] = 0;
						
					if (PState.uwRemoteScreenHeight < Scr->Width)
						wArgs[1] = PState.uwRemoteScreenHeight;
					else
						wArgs[1] = 0;

					/* Set the new limits (0=maintain old limit) */
					WindowLimits(DrawWindow, 0, 0, wArgs[0], wArgs[1]);

					SetMenuValues();
				}
				break;
				
			case MODEC_SETRASTER:
				if (FillArgs(uwNext, 5) == TRUE)
				{
					PState.RemoteRaster.nRX      = wArgs[0];
					PState.RemoteRaster.nRY      = wArgs[1];
					PState.RemoteRaster.nRWidth  = wArgs[2];
					PState.RemoteRaster.nRHeight = wArgs[3];					
					PState.RemoteRaster.nRCurrentOffset = wArgs[4];
					PState.uwRemoteMode = nSaveState;
				}
				break;

			case MODE_INVALID:
				Printf("Parse error: entered the Invalid state! (no beginning MODE_CHANGE/COMMAND?)\n");
				ResumeAction(PState.uwMode);
				return(FALSE);			
	
			
			default:
				Printf("Parse error: unknown state!\n");
				break;		
		}
	}
 if (PState.BPenDown == TRUE) ResumeAction(PState.uwMode);
 return(TRUE);
}


/* What to do when our partner has bailed on us */
void ReceivedQuitStuff(void)
{	
	/* Close our end of the socket */
	CloseDrawSocket();
	Delay(30);		/* Necessary to avoid busy-waiting??? */

	/* If we encounter a "Quit" and are reading/writing to a local file,
	   a generated colorset command might keep us from forgetting to have
	   the right color change when we load it in next time? */
	ResumeAction(PState.uwMode);
	return;
}


/* Transmits all palette values--of our palette is less than or equal to
   the size of their palette, do it on a pen-by-pen basis; if our palette
   is bigger than their palette, do it on a dynamic basis */
void SendPalette(void)
{
	
	UWORD i, uwPaletteSize = (1 << PState.ubDepth);
	
	if (PState.ubDepth > PState.ubRemoteDepth)
	{
		/* dynamic palette transmission */
		OutputAction(FROM_IDCMP, COMMAND, COMMAND_CLEARMAP, NOP_PAD, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);
	
		for (i=0; i<uwPaletteSize; i++)
			OutputAction(FROM_IDCMP, COMMAND, COMMAND_SETCOLOR, (UWORD) (~0), RGBComponents(i), NOP_PAD, DEST_PEER|DEST_FILE);
	}
	else
	{
		/* static palette transmission */
		for (i=0; i<uwPaletteSize; i++)
			OutputAction(FROM_IDCMP, COMMAND, COMMAND_SETCOLOR, i, RGBComponents(i), NOP_PAD, DEST_PEER|DEST_FILE);
	}		
	return;
}	
	
    
void RemoteEasyReq()
{
	char *szTitle, *szMessage, *szGadgets;
	int nResult;
	
	szTitle = szReceiveString;
	szMessage = strchr(szReceiveString, 200);	/* Pos of seperator char */
	if (szMessage == NULL) return;
	*szMessage = '\0';				/* terminate title string */
	szMessage++;
	szGadgets = strchr(szMessage, 200);
	if (szGadgets == NULL) return;
	*szGadgets = '\0';
	szGadgets++;

	nResult = MakeReq(szTitle, szMessage, szGadgets);
	    
	sprintf(szSendString,"%i",nResult);
	OutputAction(FROM_IDCMP, COMMAND, COMMAND_SENDSTRING, STRING_EASYREQREP, NOP_PAD, NOP_PAD, DEST_PEER);
	return;
}


/* Asks user whether he wants to run an ARexx command suggested by remote
   ARexx script, and if he agrees, runs it (the user also has the option to
   choose another script to run).  Sends a message to the remote client of
   1 if the user agreed, 2 if he selected another file to run, and 0 on
   failure. */
void RemoteRexxCommand()
{
	char *szFile, *szDirPiece = NULL, *szFilePiece;
	char szRunString[50], szRunBuffer[300], cTemp;
	char szRedirectOrNo[] = ">\0\0";
	int nResult,nTries=0;
	FILE *fpTest = NULL;
		
	szFile = strchr(szReceiveString, 200);
	if (szFile == NULL) return;
	*szFile = '\0';			/* terminate Message substring */
	szFile++;			/* move past to file substring */

        fpTest = fopen(szFile,"r");
        if (fpTest == NULL)
        {	
        	/* File can't be opened, only allow user to find another */
        	sprintf(szRunBuffer,"Remote Rexx Client wants me to run\n%s\nbut I can't find it!",szFile);
        	sprintf(szRunString,"Choose Another Script|Cancel");
		nResult = MakeReq(szReceiveString,szRunBuffer,szRunString);
		if (nResult == 1) nResult = 2;	/* Choose own file, below */
        }
        else
        {
		fclose(fpTest);
		sprintf(szRunBuffer,"Remote Rexx Client wants me to run\n%s",szFile);
		sprintf(szRunString,"Run It|Choose Another|Cancel");
		nResult = MakeReq(szReceiveString,szRunBuffer,szRunString);
	}
	
		
	switch(nResult)
	{
	    case 1: /* User chose to run as is */
	            break;
	            
	    case 2: /* User wants to choose his own file to run */
	    	    szFilePiece = strrchr(szFile,'/');
	    	    if (szFilePiece == NULL)
	    	    {	
	    	    	szFilePiece = strrchr(szFile,':');
	    	    	if (szFilePiece == NULL) szFilePiece = szFile;
	    	    }
	    	    if (szFilePiece != szFile) 
	    	    {
	    	    	cTemp = *szFilePiece; /* Last char in dir */

			*szFilePiece = '\0';	    	    	
	    	    	szFilePiece++; /* move past : or / sign */

			/* now copy the filename into a temporary buffer */
	    	    	strncpy(szRunBuffer,szFilePiece,sizeof(szRunBuffer));

			szFilePiece--;         /* Go back to where : or / was */
			*szFilePiece = cTemp;  /* Replace last char in dir */
			szFilePiece++;
			*szFilePiece = '\0';   /* Now terminate dir */
			
			szFilePiece = szRunBuffer;	/* just filename */	    	    	
			szDirPiece = szFile;		/* What's left is the dir */
	    	    }
	    	    
	    	    
	    	    if (FileRequest("Choose another ARexx script", szFile, 
	    	    	"Execute", szDirPiece, szFilePiece, FALSE) == FALSE)
	    	    		nResult = 0;
	    	    		
	    	    break;

	    default:
	    	    nResult = 0;	/* Error out */
	    	    break;
	}
		
	/* Run the script! */
        if (nResult > 0)
        {				
        	if (strlen(szRexxOutputFile) == 0) *szRedirectOrNo = '\0';
        	sprintf(szRunBuffer,"run >NIL: <NIL: rx %s%s %s %s REMOTE", 
       			szRedirectOrNo, UniqueName(szRexxOutputFile), szFile, rexxHost->portname);
       		system(szRunBuffer);
        }
        
	sprintf(szSendString,"%i",nResult);
	OutputAction(FROM_IDCMP, COMMAND, COMMAND_SENDSTRING, STRING_EASYREQREP, NOP_PAD, NOP_PAD, DEST_PEER);		
	return;
}


void RemoteStringReq()
{
	char szUserStringBuf[250];
	char *szDefaultString, *szTitle, *szMessage, *szToSend;

	/* Parse out sub-strings */
	szTitle = szReceiveString;
	szDefaultString = strchr(szReceiveString,MAGIC_BYTE);
	if (szDefaultString == NULL) return;
	*szDefaultString = '\0';		/* Terminate Title string and move on */
	szDefaultString++;
	
	szMessage = strchr(szDefaultString,MAGIC_BYTE);
	if (szMessage == NULL) return;
	*szMessage = '\0';
	szMessage++;
	
	strncpy(szUserStringBuf,szDefaultString,sizeof(szUserStringBuf));
	
	if (GetUserString(szUserStringBuf, szTitle, szMessage, sizeof(szUserStringBuf)) == TRUE)
		szToSend = szUserStringBuf;
		else
		szToSend = "(User aborted)";

	strncpy(szSendString,szToSend,sizeof(szSendString));		
	OutputAction(FROM_REXX, COMMAND, COMMAND_SENDSTRING, STRING_STRINGREQREP, NOP_PAD, NOP_PAD, DEST_PEER);
	return;
}

		
BOOL Synch(void)
{
	if (BNetConnect == TRUE)
	{
		Wprint(COMMAND, DEST_PEER);
		Wprint(COMMAND_SYNCH, DEST_PEER);
		Wprint(PState.uwFColor, DEST_PEER);
		Wprint(PState.uwBColor, DEST_PEER);
		Wprint((UWORD) DrawWindow->Width, DEST_PEER);
		Wprint((UWORD) DrawWindow->Height, DEST_PEER);
		Wprint((UWORD) PState.ubDepth, DEST_PEER);
		Wprint((UWORD) Scr->Width, DEST_PEER);
		Wprint((UWORD) Scr->Height, DEST_PEER);
		uwPreviousMode = MODE_INVALID;		/* Force mode change on next write */
		return(TRUE);
	}
	return(FALSE);
}


/* This function will fill out the wArgs array up to the nLastArg'th 
   entry.  When it has filled out the last entry, it will return TRUE
   and reset itself. */
BOOL FillArgs(UWORD uwNext, int nLastArg)
{
	nNextArg++;
	
	wArgs[nNextArg] = uwNext;
	
	if ((nNextArg >= (nLastArg-1))||(nNextArg > MAXARGS))
	{
		ResetArgCount();
		return(TRUE);
	}
	
	return(FALSE);
}




void ResetArgCount(void)
{
	nNextArg = -1;
	return;
}




/* This function will return us to the correct mode if uwNext is one
   of the special "high" characters (0xFF**).   Returns TRUE if an
   escape was encountered (and thus a mode change effected) */
BOOL CheckStandardEscapes(UWORD uwNext)
{
	switch(uwNext)
	{			
		case COMMAND:
			ResetArgCount();
			nSaveState = PState.uwRemoteMode;
			PState.uwRemoteMode = MODE_COMMAND;
			return(TRUE);

		case MODE_CHANGE:
			ResetArgCount();
			PState.uwRemoteMode = MODE_MODE;
			return(TRUE);
					
		default:
			return(FALSE);
	}
}
	
	

/* Prints a UWORD out as two bytes to file or to peer--see remote.h for
   defines for DestCode */	
void Wprint(UWORD uwWord, LONG DestCode)
{
	UWORD wLeftByte, wRightByte;
	UBYTE cLeftByte, cRightByte;
	static char sString[2] = "  ";
	
	wLeftByte  = (uwWord & 0xFF00)>>8;
	wRightByte = uwWord & 0x00FF;
	
	cLeftByte = wLeftByte;
	cRightByte = wRightByte;
	
	if ((DestCode & DEST_FILE)&&(fpOut != NULL)) fprintf(fpOut,"%c%c",cLeftByte,cRightByte);

	sString[0] = cLeftByte;
	sString[1] = cRightByte;
	
	if ((DestCode & DEST_PEER)&&(BNetConnect == TRUE)) SendString(sString,2);
	return;
}



/* Reads two bytes in a returns a UWORD */
UWORD Wread(FILE *fpFile, LONG FromCode)
{
	static UWORD uwInstr = 0;
	UWORD uwTemp;
	UBYTE ubNew;
	UBYTE *pu1, *pu2;
	int nBytesReceived;
	BOOL BOutputWord = FALSE;
	static BOOL BFirst = FALSE;
	
	pu1 = &uwTemp;
	pu2 = pu1+1;
	
	if (FromCode & FROM_FILE)
	{
		if (fpFile == NULL) return(NOTSENDABLE);
		if (fread(&uwTemp, sizeof(UWORD), 1, fpFile) != 1) return(NOTSENDABLE);
		return(uwTemp);
	}
	else
	{
		nBytesReceived = Receive((char *) &ubNew, 1);
		
		if (nBytesReceived < 1)	return(SEND_EMPTY);
		
		/* see if there is anything here already--if there is, mark that we
		   are going to ship it out during this call */
		if (BFirst == TRUE) 
		{
			BOutputWord = TRUE;
			uwInstr = uwInstr << 8; 	/* Shift old data left one byte */
		}
		else
		{
			BFirst = TRUE;
		}
		
		uwInstr |= ubNew;	
	}

	if (BOutputWord == TRUE)
	{
	 	BFirst = FALSE;
	 	uwTemp = uwInstr;
	 	uwInstr = 0;
		return(uwTemp);
	}

	return(SEND_EMPTY);
}
	
	
	
	
	

BOOL OutputAction(UBYTE bFromCode, UWORD uwModeID, UWORD arg1, UWORD arg2, UWORD arg3, UWORD arg4, LONG DestCode)
{
	static UWORD uwPreviousForeGround = -1;
	static UWORD uwPreviousBackGround = -1;
	UWORD *uwCheckForeGround, *uwCheckBackGround;
	ULONG ulStringLength;
		
	/* Parse out whether we're from the Arexx or IDCMP */
	switch(bFromCode)
	{
		case FROM_REXX:
			uwCheckForeGround = &PState.uwRexxFColor;
			uwCheckBackGround = &PState.uwRexxBColor;
			break;
		case FROM_IDCMP:
			uwCheckForeGround = &PState.uwFColor;
			uwCheckBackGround = &PState.uwBColor;
			break;
		case FROM_REMOTE:
			uwCheckForeGround = &PState.uwRemoteFColor;
			uwCheckBackGround = &PState.uwRemoteBColor;
			break;
		default:
			Printf("OutputAction:  Unknown source!\n");
			return(FALSE);
	}
	
	/* Can't send data if we're not connected */
	if (BNetConnect == FALSE) DestCode &= ~(DEST_PEER);
	if (fpOut == FALSE)	  DestCode &= ~(DEST_FILE);
	
	/* If nothing to do, don't do it! */
	if (DestCode == FALSE) return(FALSE);
	
	if (uwModeID != COMMAND)
	{	
		/* make sure we're in the correct mode */
		if ((uwModeID != uwPreviousMode) &&
			(uwModeID != MODE_CHANGE))
		{
			uwPreviousMode = uwModeID;
			OutputAction(bFromCode, MODE_CHANGE, uwModeID, NOP_PAD, NOP_PAD, NOP_PAD, DestCode);
		}
		
		/* make sure we have the correct colors */
		if ((arg1 != COMMAND_RGB)    &&
			(uwModeID != MODE_DTEXT) &&
		    ((*uwCheckForeGround != uwPreviousForeGround)||
		     (*uwCheckBackGround != uwPreviousBackGround)))
		{
			OutputAction(bFromCode, COMMAND, COMMAND_RGB, *uwCheckForeGround, 
			               *uwCheckBackGround, NOP_PAD, DestCode);
			uwPreviousForeGround = *uwCheckForeGround;
			uwPreviousBackGround = *uwCheckBackGround;
		}
	}
		    
	/* This is the real, binary output! */
	switch(uwModeID & ~(MODE_XOR) & ~(MODE_FILLED))
	{
		case COMMAND:
			Wprint(COMMAND, DestCode);
			Wprint(arg1, DestCode);
			switch(arg1)
			{
				case COMMAND_RGB:
					Wprint(RGBComponents(arg2), DestCode);
					Wprint(RGBComponents(arg3), DestCode);
				break;
				case COMMAND_SIZE:
					Wprint(arg2, DestCode);
					Wprint(arg3, DestCode);
				break;
				case COMMAND_SETCOLOR:
					Wprint(arg2, DestCode);
					Wprint(arg3, DestCode);
				break;
				case COMMAND_SENDSTRING:
					ulStringLength = strlen(szSendString);
					/* If string length is odd, add an extra byte, 
					   since all instructions should terminate on a 
					   word boundary.  */
					if ((ulStringLength & 0x0001) == 1L)
					{
						strncat(szSendString, PAD_STRING, 1);
						ulStringLength++;
					}
					/* Send string type */
					Wprint(arg2, DestCode);
					SendString(szSendString, ulStringLength);
					Wprint(STOP_STRING, DestCode);
				break;
				case COMMAND_SETRASTER:
					/* Send info from appropriate struct */
					if (bFromCode == FROM_REXX)
					{
						Wprint(PState.RexxRaster.nRX, DestCode);
						Wprint(PState.RexxRaster.nRY, DestCode);
						Wprint(PState.RexxRaster.nRWidth, DestCode);
						Wprint(PState.RexxRaster.nRHeight, DestCode);
						Wprint(PState.RexxRaster.nRCurrentOffset, DestCode);
					}
					else if (bFromCode == FROM_IDCMP)
					{
						Wprint(PState.LocalRaster.nRX, DestCode);
						Wprint(PState.LocalRaster.nRY, DestCode);
						Wprint(PState.LocalRaster.nRWidth, DestCode);
						Wprint(PState.LocalRaster.nRHeight, DestCode);
						Wprint(PState.LocalRaster.nRCurrentOffset, DestCode);
					}
					
				case COMMAND_SENDSCREEN:  break;
				
				break;	
			}
			break;	
		case MODE_DOT:
			Wprint(arg1, DestCode);
			Wprint(arg2, DestCode);
			break;
		case MODE_PEN:
			Wprint(arg1, DestCode);
			Wprint(arg2, DestCode);
			break;
		case MODE_LINE:
			Wprint(arg1, DestCode);
			Wprint(arg2, DestCode);
			Wprint(arg3, DestCode);
			Wprint(arg4, DestCode);
			break;
		case MODE_CIRCLE:
			Wprint(arg1, DestCode);
			Wprint(arg2, DestCode);
			Wprint(arg3, DestCode);
			Wprint(arg4, DestCode);
			break;
		case MODE_SQUARE:
			Wprint(arg1, DestCode);
			Wprint(arg2, DestCode);
			Wprint(arg3, DestCode);
			Wprint(arg4, DestCode);
			break;
		case MODE_POLY:
			break;
		case MODE_FLOOD:
			Wprint(arg1, DestCode);
			Wprint(arg2, DestCode);
			Wprint(RGBComponents(arg3), DestCode);
			break;
		case MODE_DTEXT:
			Wprint(arg1, DestCode);
			break;
		case MODE_CHANGE:
			Wprint(uwModeID, DestCode);
			Wprint(arg1, DestCode);
			break;
		case MODE_RASTER:
			Wprint(arg1, DestCode);
			Wprint(arg2, DestCode);
			break;
		default:
			Printf("OutputAction:  Error: Unknown mode: [%ux]", (uwModeID & ~(MODE_XOR) & ~(MODE_FILLED)));
			Printf("OutputAction:  Err...arg1=%i, arg2=%i, arg3=%i, arg4=%i\n",arg1,arg2,arg3,arg4);
			break;
	}
	return TRUE;


}		
		
	
/* ---------------- REMOTE FUNCTIONS FOR MODE_DOT ------------------ */
BOOL Remote_Dot(int nX, int nY)
{
	BOOL BInWindow = FixPos(&nX, &nY);

	if (BInWindow == TRUE) 
	{
		if (PState.uwRemoteMode & MODE_XOR)
			SetDrMd(DrawWindow->RPort, COMPLEMENT);
		else
			SetAPen(DrawWindow->RPort,PState.uwRemoteFColor); 
	
		WritePixel(DrawWindow->RPort,nX,nY);
		OutputAction(FROM_REMOTE, PState.uwRemoteMode, nX, nY, NOP_PAD, NOP_PAD, DEST_FILE);
	
		SetDrMd(DrawWindow->RPort, JAM1);
	}
	return(TRUE);
}




/* ---------------- REMOTE FUNCTIONS FOR MODE_PEN ------------------ */
BOOL Remote_Pen(int nX, int nY)
{
 	BOOL BInWindow;
	static BOOL BLastIn;

	if (PState.uwRemoteMode & MODE_XOR)
		SetDrMd(DrawWindow->RPort, COMPLEMENT);
	else
	SetAPen(DrawWindow->RPort,PState.uwRemoteFColor); 
	 	
	/* What to do if this is the end marker for a chain */
	if ((nX < 0)&&(nY < 0))
	{
		if (FixPos(&XPen, &YPen) == TRUE) WritePixel(DrawWindow->RPort, XPen, YPen);
		OutputAction(FROM_REMOTE, MODE_DOT | (PState.uwRemoteMode & MODE_XOR), XPen, YPen, NOP_PAD, NOP_PAD, DEST_FILE);
		XPen = -1;
		YPen = -1;
		BLastIn = FALSE;
		SetDrMd(DrawWindow->RPort, JAM1);
		return(TRUE);
	}

	BInWindow = FixPos(&nX, &nY);
	if ((XPen == -1)&&(YPen == -1))
	{
		XPen = nX;
		YPen = nY;
		SetDrMd(DrawWindow->RPort, JAM1);
		return(TRUE);
	}
	
	Move(DrawWindow->RPort, XPen, YPen);	
	if (BInWindow == TRUE) 
	{
		Draw(DrawWindow->RPort, nX, nY);
		OutputAction(FROM_REMOTE, MODE_LINE | (PState.uwRemoteMode & MODE_XOR), XPen, YPen, nX, nY, DEST_FILE);
		BLastIn = TRUE;
	}
	else
	{
		if (BLastIn == TRUE)
		{
			Draw(DrawWindow->RPort, nX, nY);
			OutputAction(FROM_REMOTE, MODE_LINE | (PState.uwRemoteMode & MODE_XOR), XPen, YPen, nX, nY, DEST_FILE);
		}
		BLastIn = FALSE;
	}
	
	XPen = nX;
	YPen = nY;	
	SetDrMd(DrawWindow->RPort, JAM1);
	return(BInWindow);
}





/* ---------------- REMOTE FUNCTIONS FOR MODE_LINE ------------------ */
/* What to do in MODE_LINE when the user releases the mouse button */
/* returns true if cursor is in window, else false */
BOOL Remote_Line(int X1, int Y1, int X2, int Y2)
{
	BOOL B1, B2;
	
	B1 = FixPos(&X1, &Y1);
	B2 = FixPos(&X2, &Y2);
	
	if (B1||B2)
	{
		/* Set Color */
		if (PState.uwRemoteMode & MODE_XOR)
			SetDrMd(DrawWindow->RPort, COMPLEMENT);
		else
		SetAPen(DrawWindow->RPort,PState.uwRemoteFColor); 	
	
		/* Draw line */
		Move(DrawWindow->RPort, X1, Y1);
		Draw(DrawWindow->RPort, X2, Y2);
		OutputAction(FROM_REMOTE, PState.uwRemoteMode, X1, Y1, X2, Y2, DEST_FILE);      
	
		SetDrMd(DrawWindow->RPort, JAM1);
		return(TRUE);
 	}
 	return(FALSE);
}






/* ---------------- REMOTE FUNCTIONS FOR MODE_CIRCLE ------------------ */
BOOL Remote_Circle(int X, int Y, int RX, int RY)
{
	int nTop = Y-RY, nBottom = Y+RY, nLeft = X-RX, nRight = X+RX;
		
	/* Only draw this if it still fits in the window! 
	   (This is only a problem if the window has just been resized) */
	if (FixPos(&X, &Y)&&FixPos(&nLeft,&nTop)&&FixPos(&nRight,&nBottom))
	{
		/* Set Color */
		if (PState.uwRemoteMode & MODE_XOR)
			SetDrMd(DrawWindow->RPort, COMPLEMENT);
		else
		SetAPen(DrawWindow->RPort,PState.uwRemoteFColor);
	
		/* Draw final circle */
		Ellipse(X, Y, RX, RY, ((PState.uwRemoteMode & MODE_FILLED) != FALSE));
		OutputAction(FROM_REMOTE, PState.uwRemoteMode, X, Y, RX, RY, DEST_FILE);
		SetDrMd(DrawWindow->RPort, JAM1);
	}
 	return(TRUE);
}





/* ---------------- REMOTE FUNCTIONS FOR MODE_SQUARE ------------------ */
BOOL Remote_Square(int X1, int Y1, int X2, int Y2)
{
	BOOL BIn = FALSE;
	
	/* Draw final square */
	BIn =  FixPos(&X1, &Y1);
	BIn |= FixPos(&X2, &Y2);
	
	if (BIn)
	{
		/* Set Color */
		if (PState.uwRemoteMode & MODE_XOR)
			SetDrMd(DrawWindow->RPort, COMPLEMENT);
		else
		SetAPen(DrawWindow->RPort,PState.uwRemoteFColor); 	

		Rectangle(X1, Y1, X2, Y2, ((PState.uwRemoteMode & MODE_FILLED) != FALSE));
    		OutputAction(FROM_REMOTE, PState.uwRemoteMode, X1, Y1, X2, Y2, DEST_FILE);
		SetDrMd(DrawWindow->RPort, JAM1);
	}
 	return(TRUE);
}




/* ---------------- REMOTE FUNCTIONS FOR MODE_FLOOD ------------------ */
/* What to do in MODE_FLOOD when the user pushes the left mouse button */
/* returns true if cursor is in window, else false */
/* Note that this method of transmitting a flood fill is not very safe */
/* and that for that reason, this function is only called when         */
/* Safe Fills (in the Misc. menu) is turned OFF.                       */
BOOL Remote_Flood(int X1, int Y1, UWORD uwExpectedFilledColor)
{ 
	int nTemp, nExpectedFillPaletteEntry;
	UBYTE ubBlue, ubGreen, ubRed;
	BOOL BNotBk;
	
	/* Decipher 12 righthand bits of word into R,G,B bytes */
	ubBlue  = (uwExpectedFilledColor     ) & 0x000F;
	ubGreen = (uwExpectedFilledColor >> 4) & 0x000F;
	ubRed   = (uwExpectedFilledColor >> 8) & 0x000F;
	BNotBk  = (uwExpectedFilledColor >>15) & 0x0001;
	
	nExpectedFillPaletteEntry = MatchPalette(ubRed, ubGreen, ubBlue, BNotBk, NULL, NULL);
					
	if (FixPos(&X1, &Y1) == TRUE) 
	{
		nTemp = ReadPixel(DrawWindow->RPort,X1,Y1);
		if ((nExpectedFillPaletteEntry == nTemp) && (PState.uwRemoteFColor != nTemp))
		{
			SetAPen(DrawWindow->RPort,PState.uwRemoteFColor);
			FloodFill(X1, Y1, nExpectedFillPaletteEntry, 0, 0, 0, FALSE);		
			OutputAction(FROM_REMOTE, MODE_FLOOD, X1, Y1, nExpectedFillPaletteEntry, NOP_PAD, DEST_FILE);
			return(TRUE);
		}
	}
	return(FALSE);
}
