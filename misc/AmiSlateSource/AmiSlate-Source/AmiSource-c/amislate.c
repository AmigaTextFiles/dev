#include <stdio.h>
#include <stdlib.h> 
#include <dos/dosextens.h>

#include <devices/timer.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <intuition/screens.h>
#include <exec/ports.h>
#include <exec/memory.h>
#include <exec/types.h>
#include <exec/io.h>
#include <exec/libraries.h>
#include <libraries/dos.h>			/* contains RETURN_OK, RETURN_WARN #def's */
#include <clib/alib_protos.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/wb_protos.h>
#include <clib/icon_protos.h>
#include <clib/diskfont_protos.h>
#include <clib/iffparse_protos.h>

#include <string.h>
#include <graphics/gfxbase.h>
#include <errno.h>
#include <libraries/gadtools.h>
#include <inetd.h>
#include <sys/types.h>
#include <workbench/workbench.h>
#include <workbench/startup.h>

#include "DrawLang.h"
#include "AmiSlate.h"
#include "ToolBox.h"
#include "drawtcp.h"
#include "tools.h"
#include "palette.h"
#include "display.h"
#include "remote.h"
#include "drawrexx.h"
#include "drawrexx_aux.h"
#include "asl.h"
#include "ilbm.h"

#define INTUI_V36_NAMES_ONLY
#define INTUITION_AREA_SIZE	2000
#define MIN_WIDTH_OFFSET	26	/* AmiSlate window must be at least ToolBarWidth + this */
#define MIN_HEIGHT_OFFSET	10	/* AmiSlate window must be at least nTitleHeight + nGetToolBoxHeight + this */
#define MAXIDCMPBATCH		3	/* How many IDCMP messages we do in a row before attending elsewhere */
#define FIRSTREXXITEM		26	/* Position of first custom ARexx item in menus */

#define CHAR_ESCAPE		27	/* ASCII code for the escape key */
#define RAWKEYCODE_BASEOFFSET   300	/* Raw keys start here */


struct Library *IntuitionBase = NULL;
struct Library *SocketBase    = NULL;
struct Library *IconBase      = NULL;
struct GfxBase *GraphicsBase  = NULL;
struct Library *GadToolsBase  = NULL;
struct Library *AslBase       = NULL;
struct Library *TimerBase     = NULL;
struct Library *IFFParseBase  = NULL;

struct Window *DrawWindow     = NULL;
struct Screen *Scr 	      = NULL;
struct RexxHost *rexxHost     = NULL;

struct PaintInfo PState;
struct TextAttr topaz8 = {"topaz.font",8,NULL,FPF_ROMFONT};
struct TextFont *ChatFont = NULL;

struct TmpRas TempRaster;

struct Menu     *Menu     = NULL;
struct MenuItem *MenuItem = NULL;

void *vi = NULL;

PLANEPTR TempRasterBitPlane = NULL;

char szWinTitle[120];
char szRexxOutputFile[200] = "";

#define REXXNAMELENGTH 15
char szRexxNames[10][REXXNAMELENGTH];	/* ten names in menu, each has max 14 chars */
#define REXXSCRIPTLENGTH 150
char szRexxScripts[10][REXXSCRIPTLENGTH];	/* ten filepaths in menu, each has max 149 chars */

/* Gadtools menu stuff */
#define P_OPEN		102
#define P_SAVE		103
#define P_ABOUT 	104
#define P_QUIT  	105
#define T_CONNECT 	106
#define T_DISCONNECT    107
#define S_PLAYBACK      108
#define S_RECORD        109
#define S_APPEND 	110
#define M_LOADPALETTES  111
#define M_EXPANDWINDOW  112
#define M_PROTECTINTER  113
#define M_SAFEFLOOD     114
#define M_LOCKPALETTES  115
#define M_RESYNCH	116
#define M_RESETPALETTE  117
#define R_EXECREXX      118
#define R_ABORTREXX     119
#define R_AREXX		120

/* R_AREXX goes from 120 to 129 */

const char szDefaultRexxName[] = "Unused Slot";

struct NewMenu nmMenus[] = {
    NM_TITLE, "Project", 	 NULL, 	0L, 	   	 NULL, NULL,
    NM_ITEM,  "Open IFF",	 "O",	0L,		 NULL, (void *) P_OPEN,
    NM_ITEM,  "Save IFF",	 "S",	0L,		 NULL, (void *) P_SAVE,
    NM_ITEM,  "About",           "?",   0L, 	   	 NULL, (void *) P_ABOUT,
    NM_ITEM,  NM_BARLABEL, 	 NULL, 	0L, 	   	 NULL, NULL,
    NM_ITEM,  "Quit",  	 	 "Q",  	0L, 	   	 NULL, (void *) P_QUIT,
    NM_TITLE, "TCP", 		 NULL,  0L, 	   	 NULL, NULL,
    NM_ITEM,  "Connect",	 "C",  	0L, 	   	 NULL, (void *) T_CONNECT,
    NM_ITEM,  "Disconnect",      "D",  	0L,        	 NULL, (void *) T_DISCONNECT,
    NM_TITLE, "Script",          NULL,  0L,        	 NULL, NULL,
    NM_ITEM,  "Play Script",     "P",   0L,        	 NULL, (void *) S_PLAYBACK,
    NM_ITEM,  "Record Script",   "B",   CHECKIT,   	 NULL, (void *) S_RECORD,
    NM_ITEM,  "Append Scripts",  "]",   CHECKIT,   	 NULL, (void *) S_APPEND,
    NM_TITLE, "Options",         NULL,  0L,        	 NULL, NULL,
    NM_ITEM,  "IFF Load",	 NULL,  0L,		 NULL, NULL,
    NM_SUB,   "Load Palette",	 "T",   CHECKIT,	 NULL, (void *) M_LOADPALETTES,
    NM_SUB,   "Expand Window",	 "W",   CHECKIT,	 NULL, (void *) M_EXPANDWINDOW, 
    NM_SUB,   "Protect GUI Pens","G",   CHECKIT,	 NULL, (void *) M_PROTECTINTER,
    NM_ITEM,  "Safe Flood Fills","F",   CHECKIT,   	 NULL, (void *) M_SAFEFLOOD, 
    NM_ITEM,  "Lock Palettes",   "L",   CHECKIT,   	 NULL, (void *) M_LOCKPALETTES,
    NM_ITEM,  "Resynch to Remote","R",  0L,		 NULL, (void *) M_RESYNCH,
    NM_ITEM,  "Reset Palette",   ".",   0L,		 NULL, (void *) M_RESETPALETTE,
    NM_TITLE, "Rexx",            NULL,  0L,        	 NULL, NULL,
    NM_ITEM,  "Execute Rexx script","E",0L,        	 NULL, (void *) R_EXECREXX,
    NM_ITEM,  "Abort Rexx scripts", "A",0L,        	 NULL, (void *) R_ABORTREXX,
    NM_ITEM,  NM_BARLABEL,	 NULL,  0L,	   	 NULL, NULL,
    NM_ITEM,  szDefaultRexxName, "1",   NM_ITEMDISABLED, NULL, (void *) (R_AREXX+0),
    NM_ITEM,  szDefaultRexxName, "2",   NM_ITEMDISABLED, NULL, (void *) (R_AREXX+1),
    NM_ITEM,  szDefaultRexxName, "3",   NM_ITEMDISABLED, NULL, (void *) (R_AREXX+2),
    NM_ITEM,  szDefaultRexxName, "4",   NM_ITEMDISABLED, NULL, (void *) (R_AREXX+3),
    NM_ITEM,  szDefaultRexxName, "5",   NM_ITEMDISABLED, NULL, (void *) (R_AREXX+4),
    NM_ITEM,  szDefaultRexxName, "6",   NM_ITEMDISABLED, NULL, (void *) (R_AREXX+5),
    NM_ITEM,  szDefaultRexxName, "7",   NM_ITEMDISABLED, NULL, (void *) (R_AREXX+6),
    NM_ITEM,  szDefaultRexxName, "8",   NM_ITEMDISABLED, NULL, (void *) (R_AREXX+7),
    NM_ITEM,  szDefaultRexxName, "9",   NM_ITEMDISABLED, NULL, (void *) (R_AREXX+8),
    NM_ITEM,  szDefaultRexxName, "0",   NM_ITEMDISABLED, NULL, (void *) (R_AREXX+9),
    NM_END,   NULL, 		 NULL, 	NULL, 	   	 NULL, NULL
};

char szVersionString[] = "$VER:AmiSlate v1.3";
char szCompileDate[]   = __DATE__;
char *sWindowTitle = szVersionString + 5;
char *sScreenTitle = szVersionString + 5;
char szSendString[256];
char szReceiveString[256];
char szUserString[256];
char szTempString[256];
ULONG lCacheChar = 0;

char * szProgramName = NULL;	/* used to access icon when run from cli w/o args */

int Not[2] = {TRUE, FALSE};             /* a NOT lookup array */
int XPos, YPos;
BOOL BMore = TRUE;
BOOL BAGA = TRUE;		/* AGA chipset present? */
BOOL BNetConnect = FALSE;
BOOL BAcceptingTCP = FALSE;
BOOL BPalettesLocked = FALSE;
BOOL BProgramDone = FALSE;
BOOL BStartedFromWB = FALSE;
BOOL BDos20 = TRUE;
BOOL BProtectInter = TRUE;	/* never overwrite colors 0-3 */

int nWinOldWidth  = -1;		/* Used for correct window erasing */ 
int nWinOldHeight = -1;

ULONG timerSignal = 0L;
ULONG ulIDCMPmask;
ULONG lOutputQueueSize = 2047L;	/* Default size */

__chip WORD AreaBuffer[INTUITION_AREA_SIZE];
struct AreaInfo AreaInfo = { 0 };
struct DiskObject *AmiSlateIconDiskObject = NULL;

struct timerequest *TimerIO = NULL;	/* For ARexx timeouts */
struct MsgPort     *TimerMP = NULL;
struct Message     *TimerMSG= NULL;

/* network defaults */
char targethost[80];
char *sDefaultTitle = szVersionString+5;
char *pcWhatToAbort = "whatever";
char sBuf[140];
char **argv;

extern LONG lQLength;	/* defined in drawtcp.c */
extern BOOL BIFFLoadPending;	/* defined in ilbm.c */

/* -- GLOBAL VARIABLES TO BE (RE)SET BY USER via RUNTIME ARGUMENTS */
BOOL BUseCustomScreen = TRUE, BSafeFloods = TRUE;
BOOL BIgnoreResizeEvent = FALSE, BAppendScripts = FALSE;
BOOL BLoadIFFPalettes = TRUE, BExpandIFFWindow = TRUE, BRexxPenDown = FALSE;
int nUserReqHeight = -1, nUserReqWidth = -1, screentype = USE_CUSTOMSCREEN;
int nUserReqLeft = -1, nUserReqTop = -1;
int nTitleHeight = 11;	/* guess a default */
int argc;
char szPubScreenName[50] = "Workbench";
FILE *fpIn = NULL, *fpOut = NULL;

__chip UWORD waitPointer[] =
	{
	0x0000, 0x0000,
	0x0400, 0x07c0,
	0x0000, 0x07c0,
	0x0100, 0x0380,
	0x0000, 0x07e0,
	0x07c0, 0x1ff8,
	0x1ff0, 0x3fec,
	0x3ff8, 0x7fde,
	0x3ff8, 0x7fbe,
	0x7ffc, 0xff7f,
	0x7efc, 0xffff,
	0x7ffc, 0xffff,
	0x3ff8, 0x7ffe,
	0x3ff8, 0x7ffe,
	0x1ff0, 0x3ffc,
	0x07c0, 0x1ff8,
	0x0000, 0x07e0,
	0x0000, 0x0000};
	

__chip unsigned short crossPointer[] = 
	{
	0x0000, 0x0000,
	0x0000, 0x0100,
	0x0000, 0x0100,
	0x0000, 0x0100,
	0x0000, 0x0100,
	0x0000, 0x0100,
	0x0000, 0x0000,
	0x0100, 0xFC7E,
	0x0000, 0x0000,
	0x0000, 0x0100,
	0x0000, 0x0100,
	0x0000, 0x0100,
	0x0000, 0x0100,
	0x0000, 0x0100,
	0x0000, 0x0000,
	0x0000, 0x0000,
	0x0000, 0x0000,
	0x0000, 0x0000,
	0x0000, 0x0000,
	0x0000, 0x0000
};


LONG Max(LONG lA, LONG lB)
{
	if (lA > lB) return(lA);
	return(lB);
}

LONG Min(LONG lA, LONG lB)
{
	if (lA < lB) return(lA);
	return(lB);
}


void SetStandardRexxReturns(void)
{
	static ULONG lMouseButton, lMouseX, lMouseY, lLastChar;
	int nupX=XPos, nupY=YPos;

	UnFixCoords(&nupX, &nupY);
		
	lMouseButton = BRexxPenDown;
	lMouseX = nupX;
	lMouseY = nupY;
	lLastChar = lCacheChar;
	lCacheChar = 0;		/* ensure that we don't send the same char twice */
	
	((struct rxd_waitevent *) *(&RexxState.array))->res.mousex  = &lMouseX;
	((struct rxd_waitevent *) *(&RexxState.array))->res.mousey  = &lMouseY;
	((struct rxd_waitevent *) *(&RexxState.array))->res.button  = &lMouseButton;
	((struct rxd_waitevent *) *(&RexxState.array))->res.lastkey = &lLastChar;
	ReplyAndFreeRexxMsg(TRUE);
	PState.uwRexxWaitMask = 0;
}


void ExecuteRexxScript(char *szPreparedFileName)
{
	char szFileName[450];
	char szTemp[470];
	char szRedirectOrNo[] = ">\0\0";
	
	if (szPreparedFileName != NULL) strncpy(szFileName,szPreparedFileName,sizeof(szFileName));
	if ((szPreparedFileName != NULL)||(FileRequest("Select an ARexx macro to execute", szFileName, "Execute", "SlateRexx:", NULL, FALSE) == TRUE))
	{
	    sprintf(szWinTitle,"Now Executing ");
	    strncat(szWinTitle,szFileName,sizeof(szWinTitle));
	    SetWindowTitle(szWinTitle);

	    /* If there is no output file, don't put a redirect symbol */
	    if (strlen(szRexxOutputFile) == 0) *szRedirectOrNo = '\0';
	    
	    sprintf(szTemp,"run >NIL: <NIL: rx %s%s %s %s LOCAL", szRedirectOrNo, 
	    		UniqueName(szRexxOutputFile), szFileName, 
	    			rexxHost->portname);
	    system(szTemp);
	}
	return;
}

void LoadUserIFF(char *szPreparedFileName)
{
	char szFileName[450];
	
	if (szPreparedFileName != NULL) strncpy(szFileName,szPreparedFileName,sizeof(szFileName));
	if ((szPreparedFileName != NULL)||(FileRequest("Select an IFF ILBM to display", szFileName, "Load", NULL, NULL, FALSE) == TRUE))
	{
		LoadUserIFFNamed(FROM_IDCMP,szFileName);
	}
	return;
}

/* used by both LoadUserIFF and by ARexx LOADIFF */
BOOL LoadUserIFFNamed(int nFromCode, char * szFileName)
{
	    BOOL BTemp;

	    sprintf(szWinTitle,"Now Displaying ");
	    strncat(szWinTitle,szFileName,sizeof(szWinTitle));
	    SetWindowTitle(szWinTitle);

	    SetPointer(DrawWindow, waitPointer, 16, 16, -6, 0);

	    BTemp = LoadIFF1(nFromCode, szFileName);
		
     	    /* The operation is only done if BIFFLoadPending is FALSE, otherwise we need to resize */
    	    if (BIFFLoadPending == FALSE)
	    {
	    	if (BTemp == TRUE)
		    	SetWindowTitle("IFF loaded.");
		    	else
		    	SetWindowTitle("IFF load failed.");

		ClearPointer(DrawWindow);
		return(BTemp);
	    }
	    else SetWindowTitle("Resizing remote screen...");    	
	    return(TRUE);
}


void SaveUserIFF(char *szPreparedFileName)
{
	char szFileName[450];
	

	if (szPreparedFileName != NULL) strncpy(szFileName,szPreparedFileName,sizeof(szFileName));
	if ((szPreparedFileName != NULL)||(FileRequest("Choose a filename for this picture", szFileName, "Save", NULL, NULL, TRUE) == TRUE))
	{
		SaveUserIFFNamed(szFileName);
	}


	return;
}


BOOL SaveUserIFFNamed(char *szFileName)
{
	BOOL BReturn;
	
	SetPointer(DrawWindow, waitPointer, 16, 16, -6, 0);

	sprintf(szWinTitle,"Now Saving ");
	strncat(szWinTitle,szFileName,sizeof(szWinTitle));
	SetWindowTitle(szWinTitle);

	BReturn = SaveIFF(szFileName);
	
	if (BReturn == TRUE)
		SetWindowTitle("IFF saved.");
	else
		SetWindowTitle("IFF save failed.");

	ClearPointer(DrawWindow);
	return(BReturn);
}


void BreakRexxScripts(void)
{
    static LONG lAbortType = REXX_REPLY_QUIT;
    
    if (rexxHost == NULL) return;
    
    if (DrawWindow != NULL) SetPointer(DrawWindow, waitPointer, 16, 16, -6, 0);
    SetWindowTitle("Closing ARexx port");
    ulIDCMPmask &= ~(1L<<rexxHost->port->mp_SigBit);

    if (PState.uwRexxWaitMask != 0)
    {	
	((struct rxd_waitevent *) *(&RexxState.array))->res.type  = &lAbortType;
	SetStandardRexxReturns();
    }
        
    CloseDownARexxHost(rexxHost);

    Delay(10);	/* Enough time for the next request to be sent & break, we hope */

    EnableDraw(TRUE);

    SetWindowTitle("Reopening ARexx port");
    rexxHost = SetupARexxHost("AMISLATE",NULL);
    if (rexxHost == NULL) 
    {
        MakeReq(NULL,"Warning: Couldn't reopen ARexx port!",NULL);
        SetWindowTitle("ARexx port is disabled");
    }
    else 
    {
        SetWindowTitle("ARexx port cleared");
        ulIDCMPmask |= (1L<<rexxHost->port->mp_SigBit); 
    }
    ClearPointer(DrawWindow);
    SetMenuValues();
    
    return;
}




/* Updates menus */
void SetMenuValues (void)
{
 struct Menu *currentMenu = Menu;
 struct MenuItem *currentItem, *currentSub;
 
 if (currentMenu == NULL) return;
	
 if (DrawWindow != NULL) ClearMenuStrip(DrawWindow);

 currentItem = currentMenu->FirstItem;	/* Open IFF... */
 if (IFFParseBase == NULL)
 	currentItem->Flags &= ~(ITEMENABLED);
 else 	currentItem->Flags |= ITEMENABLED;
 	
 currentItem = currentItem->NextItem;	/* Save IFF... */
 if (IFFParseBase == NULL)
 	currentItem->Flags &= ~(ITEMENABLED);
 else 	currentItem->Flags |= ITEMENABLED;

 currentMenu = currentMenu->NextMenu;     /* TCP Menu */
 
 if (SocketBase == NULL) 
 	currentMenu->Flags &= ~(MENUENABLED);
 else 
 {
 	currentMenu->Flags |= MENUENABLED;
   currentItem = currentMenu->FirstItem;		/* #1 : Connect */

   if (BNetConnect == TRUE)
   {
   	currentItem->Flags &= ~(ITEMENABLED);
	   currentItem = currentItem->NextItem;		/* #2 : Disconnect */
   	currentItem->Flags |= ITEMENABLED;
   }
   else
   {
   	currentItem->Flags |= ITEMENABLED;
	   currentItem = currentItem->NextItem;		/* #2 : Disconnect */
   	currentItem->Flags &= ~(ITEMENABLED);
   }
 }
 currentMenu = currentMenu->NextMenu;   /* Script Menu */
 currentItem = currentMenu->FirstItem;	/* Play Script */
 currentItem = currentItem->NextItem;   /* Record Script */
 if (fpOut != NULL) currentItem->Flags |= CHECKED;
 	       else currentItem->Flags &= ~(CHECKED);
 currentItem = currentItem->NextItem;	/* Append Scripts */
 if (BAppendScripts == TRUE) currentItem->Flags |= CHECKED;
 			else currentItem->Flags &= ~(CHECKED);
 
 currentMenu = currentMenu->NextMenu;		/* Options Menu */
 currentItem = currentMenu->FirstItem;		/* IFF Load options */
 currentSub  = currentItem->SubItem;		/* Load palette */
 if (BLoadIFFPalettes == TRUE) currentSub->Flags |= CHECKED;
 			  else currentSub->Flags &= ~(CHECKED);
 			  
 currentSub  = currentSub->NextItem;		/* Expand to fit */
 if (BExpandIFFWindow == TRUE) currentSub->Flags |= CHECKED;
 			  else currentSub->Flags &= ~(CHECKED);

 currentSub  = currentSub->NextItem;		/* Protect Interface pens*/
 if (BProtectInter == TRUE) currentSub->Flags |= CHECKED;
 		       else currentSub->Flags &= ~(CHECKED);
 
 currentItem = currentItem->NextItem;		/* SafeFloods */
 if (BNetConnect == TRUE) currentItem->Flags |= ITEMENABLED;
 		     else currentItem->Flags &= ~(ITEMENABLED); 				  	 
 if (BSafeFloods == TRUE) currentItem->Flags |= CHECKED;
		     else currentItem->Flags &= ~(CHECKED);

 currentItem = currentItem->NextItem;		/* Lock Palettes */
 if (BNetConnect == TRUE) currentItem->Flags |= ITEMENABLED;
			else currentItem->Flags &= ~(ITEMENABLED);
 if (BPalettesLocked == TRUE) currentItem->Flags |= CHECKED;
 			 else currentItem->Flags &= ~(CHECKED);

 currentItem = currentItem->NextItem;		/* Resynch to Remote */
 if (BNetConnect == TRUE) currentItem->Flags |= ITEMENABLED;
 		     else currentItem->Flags &= ~(ITEMENABLED); 				  	  
 
 
 currentMenu = currentMenu->NextMenu;		/* Arexx Menu */
    
 if (rexxHost == NULL)	currentMenu->Flags &= ~(MENUENABLED);
 			else currentMenu->Flags |= MENUENABLED;
 
#ifdef PROBABLY_NOT_NEEDED
 currentItem = currentMenu->FirstItem;	/* Execute ARexx Script */
 currentItem = currentMenu->NextItem;   /* Break ARexx Scripts */
 currentItem = currentMenu->NextItem;	/* First custom item */
#endif
 
 if (DrawWindow != NULL) ResetMenuStrip(DrawWindow, Menu);                 
 return;	
}


/* Custom set window title function--always shows queue size */
void SetWindowTitle(char *sString)
{
	if (DrawWindow == NULL) return;
			
	if (sString != NULL)
	{
		/* Only do this if we're note already using szWinTitle, otherwise
		   we get this funky recursive effect ([Rec] [Rec] [Rec]) sometimes! */
		if (sString != szWinTitle)
		{
			if (fpOut != NULL) sprintf(szWinTitle,"[Rec] %s", sString);
					  else sprintf(szWinTitle, "%s", sString);
		}		
		SetWindowTitles(DrawWindow, szWinTitle, (char *) ~0);
	}
	else
	{
		Printf("SetWindowTitle: Null sString!\n");
	}
	return;
}


int MakeReq(char *sTitle, char *sText, char *sGadgets)
{
	struct EasyStruct myreq;
	LONG number = 0L;
	int nResult;

	if (sTitle == NULL) sTitle = "AmiSlate Message";
	if (sText == NULL) sText = "Hey, something's up!";
	if (sGadgets == NULL) sGadgets = "OK";

	myreq.es_TextFormat   = sText;
	myreq.es_Title        = sTitle;
	myreq.es_GadgetFormat = sGadgets;

	if (DrawWindow != NULL) SetPointer(DrawWindow, waitPointer, 16, 16, -6, 0);
	nResult = EasyRequest(DrawWindow, &myreq, NULL, NULL, number);
	if (DrawWindow != NULL) ClearPointer(DrawWindow);

	return(nResult);
}



BOOL CreateDrawMenus(void)
{   
	Menu = CreateMenus(nmMenus, TAG_DONE);
	if (Menu == NULL)
	{
		UserError("Couldn't Create Menus!");
		return(FALSE);
	}
	
	vi = GetVisualInfo(Scr, TAG_END);
	if (vi == NULL)
	{
		UserError("Couldn't get visual info for menus!");
		return(FALSE);
	}
	
	if (LayoutMenus(Menu, vi, TAG_DONE))
	{
		SetMenuStrip(DrawWindow, Menu);
	}
	else
	{
		FreeVisualInfo(vi);
		UserError("Couldn't LayoutMenus!");
		return(FALSE);
	}

	FreeVisualInfo(vi);
	return(TRUE);
}

int SaveScriptToDisk(void)
{
	char szFileName[500];
	
	if (fpOut != NULL)
	{
		fclose(fpOut);
		fpOut = NULL;
		SetWindowTitle("Recording complete.");
		return(TRUE);
	}
	
	if (FileRequest("Select a Script file to save to", szFileName, "Save", "SlateScripts:", NULL, TRUE) == TRUE)
	{
		if (BAppendScripts == FALSE) fpOut = fopen(szFileName,"wb");
					else fpOut = fopen(szFileName,"ab");	/* append mode */
					
		if (fpOut == NULL) MakeReq(NULL,"Couldn't open script file for writing!",NULL);
		/* Save basic state information to disk */
		OutputAction(FROM_IDCMP, COMMAND, COMMAND_RGB, PState.uwFColor, PState.uwBColor, NOP_PAD, DEST_FILE);
		
		/* This will force a mode change back! */
		OutputAction(FROM_IDCMP, MODE_CHANGE, MODE_FIRST,    NOP_PAD, NOP_PAD, NOP_PAD, DEST_FILE);
		OutputAction(FROM_IDCMP, MODE_CHANGE, PState.uwMode, NOP_PAD, NOP_PAD, NOP_PAD, DEST_FILE);
		SetWindowTitle("Now recording actions.");
	}
	return(TRUE);
}


int PlayScriptFromDisk(void)
{
	char szFileName[500];
	UWORD uwSaveRemoteMode   = PState.uwRemoteMode;
	UWORD uwSaveRemoteFColor = PState.uwRemoteFColor;
	UWORD uwSaveRemoteBColor = PState.uwRemoteBColor;
	if (FileRequest("Select a Script file to play", szFileName, "Play", "SlateScripts:", NULL, FALSE) == TRUE)
	{
		fpIn = fopen(szFileName,"rb");
		if (fpIn == NULL) MakeReq(NULL,"Couldn't open script file!",NULL);
		else
		{
			SetPointer(DrawWindow, waitPointer, 16, 16, -6, 0);
	  
			/* playback script file */
			SetWindowTitle("Playing Script file.");
			while ((RemoteHandler(fpIn, TRUE) == TRUE)&&(CheckForUserAbort() == FALSE))
			{
				/* re-assign this in case it was changed somehow */
				pcWhatToAbort = "Script Playback";
			} 
			
			fclose(fpIn);
			fpIn = NULL;
			SetWindowTitle("Script file finished.");
			
			/* Restore remote state */
			PState.uwRemoteMode   = uwSaveRemoteMode;
			PState.uwRemoteFColor = uwSaveRemoteFColor;
			PState.uwRemoteBColor = uwSaveRemoteBColor;
			
			/* Restore remote state on remote machine */
			OutputAction(FROM_IDCMP, MODE_CHANGE, PState.uwMode, NOP_PAD, NOP_PAD, NOP_PAD, DEST_PEER);
			OutputAction(FROM_IDCMP, COMMAND, COMMAND_RGB, PState.uwFColor, PState.uwBColor, NOP_PAD, DEST_PEER);

			ClearPointer(DrawWindow);
		}
	}
	return(TRUE);
}

int ShowAbout(void)
{
	char szTempBuf[250];
	sprintf(szTempBuf,"%s\nby Jeremy Friesner\njfriesne@ucsd.edu\n(Compiled %s)",szVersionString+5,szCompileDate);
	MakeReq("About AmiSlate",szTempBuf,"Very Nice");
	return;
}
	
void Swap(int *i1, int *i2)
{
	int temp;
	
	temp = *i1;
	*i1 = *i2;
	*i2 = temp;
	return;
}



void SwapPointers(void *(*p1), void *(*p2))
{
	void *temp;
	
	temp = *p1;
	*p1 = *p2;
	*p2 = temp;
	return;
}


void debug(int nID)
{
	Printf("Debug point: %i\n",nID);
	Delay(100);
	return;
}




void ClearWindow(void)
{
	int nToolBoxLeft = nGetToolBoxLeft();  
   	int nWindowBottom;

	nWindowBottom = DrawWindow->Height - DrawWindow->BorderBottom - 1;

  	/* Erase Window */
	SetAPen(DrawWindow->RPort,0);
	Rectangle(DrawWindow->BorderLeft,DrawWindow->BorderTop
						,nToolBoxLeft - 2, nWindowBottom-25, TRUE);	

	/* Clear chat lines */
	EraseChatLines(DrawWindow->Width, DrawWindow->Height);
	DrawChatLines();
	
	return;
}

/* Given an entry in our palette, returns a word with right justified
   R, G, B values for that entry */
UWORD RGBComponents(UWORD uwPaletteEntry)
{
	ULONG ulThisColor;
	
	ulThisColor = GetRGB4(Scr->ViewPort.ColorMap, uwPaletteEntry);
    
    /* Flag if we don't want the background color used */
    if (uwPaletteEntry != PState.uwBColor)
    	ulThisColor |= 0x00008000;
    	
	return((UWORD) ulThisColor);
}	
				


/* This function takes red, green, blue values and gives the closest
   palette color */
/* returns -1 if no pen can be matched due to DeniedPen restrictions */
/* If BJustAlloced is non-NULL, it will be set to TRUE if a new pen was
   allocated during this call, otherwise FALSE */
int MatchPalette(UBYTE ubRed, UBYTE ubGreen, UBYTE ubBlue, BOOL BDontUseBackGround, BOOL * DeniedPenMap, BOOL * BJustAlloced)
{
	int i,nBest=-1,nFallBackBest=-1;	/* default to error */
	ULONG ulMinDist=15000,ulThisDist,ulFallBackMinDist=15000;
	UWORD uwThisColor;
	UBYTE ubThisRed, ubThisGreen, ubThisBlue;
	BOOL BUseFallBack = TRUE;
	
	/* default */
	if (BJustAlloced != NULL) *BJustAlloced = FALSE;
	
	for (i=0;i<(1<<Scr->RastPort.BitMap->Depth);i++)
	{
		uwThisColor = RGBComponents(i);
		
		/* Extract R, G, B from return value */
		ubThisBlue  = (uwThisColor      & 0x000F); /* Right 4 bits */
		ubThisGreen = ((uwThisColor>>4) & 0x000F); /* 2nd 4 bits from right */
		ubThisRed   = ((uwThisColor>>8) & 0x000F); /* 3rd 4 bits from right */
			
		/* No need to sqrt since we only want order, not actual distance */
		ulThisDist  = (ubRed   - ubThisRed  ) * (ubRed   - ubThisRed  ) +
		              (ubGreen - ubThisGreen) * (ubGreen - ubThisGreen) +
			      (ubBlue  - ubThisBlue ) * (ubBlue  - ubThisBlue );

		/* If we don't want to use the Background color, and this is it,
		   make it very unattractive! */
		if ((BDontUseBackGround == TRUE)&&(i == PState.uwBColor)) ulThisDist = 4096;
		
		/* If we find an exact match, return right away */
		if (ulThisDist == 0) 
		{
			if (BJustAlloced != NULL) *BJustAlloced = TRUE;
			if ((DeniedPenMap != NULL)&&(DeniedPenMap[i] == FALSE)) DeniedPenMap[i] = TRUE;	/* Flag this pos as used */	
			return(i);
		}
		
		/* get this one--absolute best, saved or no saved. */
		/* However, if DeniedPenMap[i] == 2, then don't get */
		/* it no matter what. */
		if ((ulThisDist < ulFallBackMinDist)&&((DeniedPenMap == NULL)||(DeniedPenMap[i] < 2)))
		{
			/* keep track of the absolute best, regardless of "saved" spots */
			ulFallBackMinDist = ulThisDist;
			nFallBackBest     = i;
		}
		
		/* if this spot isn't saved, grab it as best of the non-saved spots */
		if (((DeniedPenMap == NULL)||(DeniedPenMap[i]==FALSE)) &&
		    (ulThisDist < ulMinDist))
		{
			ulMinDist = ulThisDist;
			nBest     = i;
			BUseFallBack = FALSE;	/* Cause we got a free spot */
		}
	}
	
	/* No pen map?  No problem! */
	if (DeniedPenMap == NULL) return(nBest);
	
	if (BUseFallBack == TRUE) return(nFallBackBest);	/* oops, had to double up */
	else 
	{
		if (DeniedPenMap[nBest] == FALSE) DeniedPenMap[nBest] = TRUE;
		if (BJustAlloced != NULL) *BJustAlloced = TRUE;
		return(nBest);		/* a free spot is allocated */
	}
}


/* Toggles Locked palettes, getting the remote palette as necessary */
void ToggleLockPalettes(void)
{
	BPalettesLocked = Not[BPalettesLocked];	
	if (BPalettesLocked == TRUE) 
		OutputAction(FROM_IDCMP, COMMAND, COMMAND_SENDPALETTE, NOP_PAD, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);	
	
	SetMenuValues();
}


BOOL HandleIDCMP(struct IntuiMessage * defaultMessage) 
{
	int nToolBoxLeft = nGetToolBoxLeft(); 
	struct IntuiMessage *message = NULL;
	ULONG class, code, qual, ulItemCode;
	int nTestX, nTestY, nProc = 0;
	struct MenuItem *mItem;
	const static LONG lKeyType  = REXX_REPLY_KEYPRESS;
	const static LONG lMoveType = REXX_REPLY_MOUSEMOVE;

	static LONG lCode;

	/* Get the first message from the queue, or use the one we already have */
	if (defaultMessage == NULL) message = (struct IntuiMessage *) GetMsg(DrawWindow->UserPort);
			       else message = defaultMessage;

	/* Examine pending messages */	
	while (message != NULL)
	{
		nProc++;
		class = message->Class;		/* extract needed info from message */
		code  = message->Code;
		qual  = message->Qualifier;

		XPos = message->MouseX;		/* set mouse tracking positions */
		YPos = message->MouseY;

		/* tell Intuition we got the message */
		ReplyMsg((struct Message *)message);

		/* see what events occured, take correct action */
		switch(class)
		{		
			case IDCMP_CLOSEWINDOW: 
				BProgramDone = TRUE;  
				break;

			case IDCMP_MOUSEBUTTONS:
			  switch(code)
      			  {
      				case SELECTUP:	  BRexxPenDown = FALSE;
      						  if ((PState.BPenDown == TRUE)||(PState.BDrawEnabled == FALSE))
      						  {
      							MouseUpAction(PState.uwMode);   
      							crossPointer[14] = 0x0100;
      						  }
      						  break;

      				case SELECTDOWN:  BRexxPenDown = TRUE;
	      					  if (XPos < nToolBoxLeft)
      						  {
      						   	crossPointer[14] = 0x0000;
      							MouseDownAction(PState.uwMode);
      						  }
      						  else HandleToolBox(-1);
      						  break;

      				case MENUDOWN:	  if (PState.BPenDown == TRUE)
      						  {
      							BreakAction(PState.uwMode);
      							PState.BPenDown = FALSE;
      					 	  }
      						  break;

      				default:  	  /* Printf("IDCMP_MOUSEBUTTONS:  bad Code\n");  */
      						  break;
      			  }				
     			break;

      			case IDCMP_NEWSIZE:
			if (BIgnoreResizeEvent == TRUE) BIgnoreResizeEvent = FALSE;
				else
      				ReSizeWindow(DrawWindow->Width, DrawWindow->Height, TRUE);
		      	break;
      	
			case IDCMP_MOUSEMOVE:
				/* Make sure we have the right pointer */
				nTestX = XPos;
				nTestY = YPos;
				if (FixPos(&nTestX, &nTestY) == TRUE)
				{
					SetPointer(DrawWindow, crossPointer, 16, 16, -8, -6);
					/* Trap RMB events--this instruction needs to be done atomically! */
					/* DrawWindow->Flags |= WFLG_RMBTRAP;  */
				}
				else
				{
					ClearPointer(DrawWindow);
					/* Don't trap RMB events */
					/* DrawWindow->Flags &= ~(WFLG_RMBTRAP);  */
				}
				if (PState.uwRexxWaitMask & REXX_REPLY_MOUSEMOVE)
				{
					((struct rxd_waitevent *) *(&RexxState.array))->res.type  = &lMoveType;
					SetStandardRexxReturns();
				}

				if (PState.BPenDown == TRUE) MouseMoveAction(PState.uwMode);
			break;

			case IDCMP_RAWKEY:
				if ((code >= 96)&&(code <= 103)) break;	/* repress shift key events, etc.! */
				lCacheChar = code + RAWKEYCODE_BASEOFFSET;
				if (PState.uwRexxWaitMask & REXX_REPLY_KEYPRESS)
				{
					lCode = code + RAWKEYCODE_BASEOFFSET;
					((struct rxd_waitevent *) *(&RexxState.array))->res.type  = &lKeyType;
					((struct rxd_waitevent *) *(&RexxState.array))->res.code1 = &lCode;
					SetStandardRexxReturns();
				}
				break;				
			
			case IDCMP_VANILLAKEY: 
				if ((qual & IEQUALIFIER_NUMERICPAD)&&
					(code >= '1') && (code <= '9')) 
						AdjustColor((char) code, 
							1+2*((qual & IEQUALIFIER_LSHIFT)||
							     (qual & IEQUALIFIER_RSHIFT)), 
								PState.uwFColor, NULL,TRUE);
					else
					{
						DisplayKeyPress((char) code, TRUE); 
						lCacheChar = code;
						if (PState.uwRexxWaitMask & REXX_REPLY_KEYPRESS)
						{
							lCode = code;
							((struct rxd_waitevent *) *(&RexxState.array))->res.type  = &lKeyType;
							((struct rxd_waitevent *) *(&RexxState.array))->res.code1 = &lCode;
							SetStandardRexxReturns();
						}
					}
					break;
				
			case IDCMP_MENUPICK:
				while( code != MENUNULL ) 
				{
					mItem = ItemAddress( Menu, code );
					ulItemCode = (ULONG) GTMENUITEM_USERDATA(mItem);
					switch(ulItemCode)
					{
						case P_OPEN:	    LoadUserIFF(NULL);	  break;
						case P_SAVE:	    SaveUserIFF(NULL);	  break;
					 	case P_ABOUT: 	    ShowAbout();          break;
					 	case P_QUIT:  	    CleanExit(RETURN_OK); break;
					 	case T_CONNECT:	    if (ConnectDrawSocket(TRUE)) Synch(); break;
					 	case T_DISCONNECT:  CloseDrawSocket();	  break;
					 	case S_PLAYBACK:    PlayScriptFromDisk(); break;
					 	case S_RECORD:      SaveScriptToDisk();	  break;
					 	case S_APPEND:	    BAppendScripts = Not[BAppendScripts]; SetMenuValues(); break;
					 	case M_LOADPALETTES:BLoadIFFPalettes = Not[BLoadIFFPalettes]; SetMenuValues(); break;
						case M_EXPANDWINDOW:BExpandIFFWindow = Not[BExpandIFFWindow]; SetMenuValues(); break;
						case M_PROTECTINTER:BProtectInter    = Not[BProtectInter];
								    if (BProtectInter == TRUE) SaveScreenPalette(FALSE, 3);	/* Restore GUI pens */
								    SetMenuValues(); 
								    break;
					 	case M_SAFEFLOOD:   ToggleSafeFlood();	  break;
					 	case M_LOCKPALETTES:ToggleLockPalettes(); break;
					 	case M_RESYNCH:	    SetWindowTitle("Requesting Screen Transmission from Remote"); 
					 			    OutputAction(FROM_IDCMP, COMMAND, COMMAND_SENDSCREEN, NOP_PAD, NOP_PAD, NOP_PAD, DEST_PEER); 
					 			    break;
					 	case M_RESETPALETTE:SaveScreenPalette(FALSE, -1); break;
					 	case R_EXECREXX:    ExecuteRexxScript(NULL);  break;
					 	case R_ABORTREXX:   BreakRexxScripts();   break;
					 	default:  	    
					 		if ((ulItemCode >= R_AREXX)&&(ulItemCode < (R_AREXX+10)))
					 		{
					 			if (szRexxScripts[ulItemCode-R_AREXX][0] != '\0')
					 				ExecuteRexxScript(szRexxScripts[ulItemCode-R_AREXX]);
					 		}
					 		else
					 		MakeReq(NULL, "Bad Menu Item", NULL); 
					 		break;
					}
					code = mItem->NextSelect;
				}
				break;
				       
			default:        /* Printf("handleIDCMP: bad class\n");   */
					break;
		}
	
		/* Only do the one message if it's a custom message */
		if (defaultMessage != NULL) return(BProgramDone);

		/* Get next message from the queue */
		if (nProc >= MAXIDCMPBATCH) return(BProgramDone);
	 	                       else message = (struct IntuiMessage *)GetMsg(DrawWindow->UserPort);
	}
	return(BProgramDone);
}




/* Changes colors according to keystrokes on the numeric keypad a la
   DeluxePaint! 
   
   If * uwPresetColor is non-NULL, use the value located there
   to set the color instead of the key pressed.  
   
   If BTransmit if FALSE, don't send the adjust back to the peer */
void AdjustColor(char cKeyPressed, int nStep, int nPaletteEntry, UWORD * uwPresetColor, BOOL BTransmit)
{
	UWORD uwThisColor = RGBComponents(nPaletteEntry);
	UBYTE ubThisBlue, ubThisGreen, ubThisRed, *pubTemp;
	int nInc;
	
	if (uwPresetColor == NULL)
	{
		/* Extract R, G, B from current foreground color */
		ubThisBlue  = (uwThisColor      & 0x000F); /* Right 4 bits */
		ubThisGreen = ((uwThisColor>>4) & 0x000F); /* 2nd 4 bits from right */
		ubThisRed   = ((uwThisColor>>8) & 0x000F); /* 3rd 4 bits from right */
	
		switch(cKeyPressed)
		{
			case '1':  pubTemp = &ubThisBlue;  nInc = -nStep; break;
			case '2':  pubTemp = &ubThisBlue;  nInc =  nStep; break;
			case '3':  pubTemp = &ubThisBlue;  nInc = -ubThisBlue;  break;
			case '4':  pubTemp = &ubThisGreen; nInc = -nStep; break;
			case '5':  pubTemp = &ubThisGreen; nInc =  nStep; break;
			case '6':  pubTemp = &ubThisGreen; nInc = -ubThisGreen; break;
			case '7':  pubTemp = &ubThisRed;   nInc = -nStep; break;
			case '8':  pubTemp = &ubThisRed;   nInc =  nStep; break;
			case '9':  pubTemp = &ubThisRed;   nInc = -ubThisRed;   break;
			default:   
				   /* Printf("AdjustColor:  invalid keypress!\n");    */
				   break;
		} 
		
		/* Adjust color level */
		*pubTemp += nInc;
		if (*pubTemp == 16) *pubTemp = 0;		/* Wrap around */
		if (*pubTemp == -1) *pubTemp = 15;
	}
	else
	{
		/* just set palette entry to our given color. */
		/* Extract R, G, B from current foreground color */
		ubThisBlue  = (*uwPresetColor      & 0x000F); /* Right 4 bits */
		ubThisGreen = ((*uwPresetColor>>4) & 0x000F); /* 2nd 4 bits from right */
		ubThisRed   = ((*uwPresetColor>>8) & 0x000F); /* 3rd 4 bits from right */
	}
			
	SetRGB4(&Scr->ViewPort, nPaletteEntry, ubThisRed, ubThisGreen, ubThisBlue);
				
	if ((BPalettesLocked == TRUE)&&(BTransmit == TRUE))
	{
		/* Note that this only works with static transmission! */
		Wprint(COMMAND, DEST_PEER|DEST_FILE);
		Wprint(COMMAND_SETCOLOR, DEST_PEER|DEST_FILE);
		Wprint((UWORD) nPaletteEntry, DEST_PEER|DEST_FILE);	
		Wprint(RGBComponents(nPaletteEntry), DEST_PEER|DEST_FILE);
	}
	return;
}
	
	
	
	

/* Toggles BSafeFloods flag */
VOID ToggleSafeFlood(void)
{
	BSafeFloods = Not[BSafeFloods];
	SetMenuValues();
	return;
}
	
	



int CleanExit(LONG returnValue)
{
	const static LONG lType = REXX_REPLY_QUIT;
	
	/* If an ARexx waitevent() is pending, send it a QUIT message */
	if (PState.uwRexxWaitMask != 0)
	{
		((struct rxd_waitevent *) *(&RexxState.array))->res.type = &lType;
		SetStandardRexxReturns();
	}
	
	if (rexxHost != NULL) CloseDownARexxHost(rexxHost);
	if (ChatFont != NULL) CloseFont(ChatFont);
	
	/* Free Output Queue */
	FreeQueue(); 
	
	if (BNetConnect == TRUE) CloseDrawSocket();

	/* If a picture was being held for transmission, free it */
	/* if (BIFFLoadPending == TRUE) */
	CleanUpIFF(NULL);
	
	/* Clean and close timer io */
	if (TimerIO != NULL)
	{
		if (!(CheckIO((struct IORequest *)TimerIO))) 
		{
			AbortIO((struct IORequest *)TimerIO);	/* Ask device to abort any pending requests */
			WaitIO((struct IORequest *)TimerIO);	/* proceed when ready */
		}
		CloseDevice((struct IORequest *) TimerIO);
		DeleteExtIO((struct IORequest *) TimerIO);
	}
	if (TimerMP != NULL) DeletePort(TimerMP);
	
	/* close window */
	if (DrawWindow != NULL)
	{
		CloseWindow(DrawWindow);	/* Close window if it's open */
		DrawWindow = NULL;		/* and tell the world it's closed */
	}
	
	/* Free Area-Draw's Bitplane o' Memory */
	if ((TempRasterBitPlane != NULL)&&(Scr != NULL))
		 FreeRaster(TempRasterBitPlane, Scr->Width, Scr->Height);
	
	/* Free Menus */
	if (Menu != NULL) FreeMenus(Menu);
	
	/* close screen */
	if (Scr != NULL)				 
	{
		if (screentype == USE_CUSTOMSCREEN)
		{
			CloseScreen(Scr);
		}
		else
		{
		    	SaveScreenPalette(FALSE,-1);    /* Restore original screen palette */
			UnlockPubScreen(NULL,Scr);
		}
	}

	
	/* Close the Library(s) */
	if (IntuitionBase) CloseLibrary(IntuitionBase);
	if (IconBase)	   CloseLibrary(IconBase);
	if (GraphicsBase)  CloseLibrary((struct Library *)GraphicsBase);
	if (GadToolsBase)  CloseLibrary(GadToolsBase);
	if (SocketBase)    CloseLibrary(SocketBase);
	if (AslBase)       CloseLibrary(AslBase);
	if (IFFParseBase)  CloseLibrary(IFFParseBase);

	/* don't close TimerBase, since we don't access it through OpenLibrary() */
	
	if ((fpOut != NULL)&&(fpOut != stdout)) fclose(fpOut);
	if ((fpIn != NULL)&&(fpIn != stdin)) fclose(fpIn);
	
	exit(returnValue);
}


int ScreenTitleHeight(void)
{
	return(Scr->WBorTop + Scr->RastPort.TxHeight + 1);
}	


void ResetState(struct PaintInfo *pi)
{

	/* clear send/recieve buffers */
	memset(szSendString,    '\0', sizeof(szSendString));
	memset(szReceiveString, '\0', sizeof(szReceiveString));
	
	pi->BPenDown     = FALSE;	
	pi->BDrawEnabled = TRUE;

	if (Scr != NULL)
			pi->ubDepth = Scr->RastPort.BitMap->Depth;
	else
			pi->ubDepth = 1;		/* minimum to assume! */
	
	if (DrawWindow != NULL)	pi->uwWidth    = DrawWindow->Width;
	else
	{
		if (BAcceptingTCP == FALSE)
		{
			if (nUserReqWidth == -1)
				pi->uwWidth    = Scr->Width;
			else
				pi->uwWidth    = nUserReqWidth;
		}
	}
	
	if (DrawWindow != NULL)
		pi->uwHeight   = DrawWindow->Height;
	else
	{
		if (BAcceptingTCP == FALSE)
		{
			if (nUserReqHeight == -1)
				pi->uwHeight   = Scr->Height - ScreenTitleHeight();
			else
				pi->uwHeight   = nUserReqHeight;
		}
	}
	
	pi->uwMode     = MODE_PEN;		
	pi->uwFColor   = 1;
	pi->uwBColor   = 0;
	pi->uwRemoteFColor = pi->uwFColor;
	pi->uwRemoteBColor = pi->uwBColor;
	pi->uwRemoteMode = MODE_DOT;
	
	if (BAcceptingTCP == FALSE)
	{
	    pi->uwRemoteScreenWidth = -1;
	    pi->uwRemoteScreenHeight = -1;
	    pi->ubRemoteDepth = -1;
	}
	
	pi->uwRexxFColor = 1;
	pi->uwRexxBColor = 0;
	pi->uwRexxWaitMask = 0;
		
	pi->nToolBoxWidth = TOOLBOXH_WIDTH;
	pi->nToolBoxHeight = TOOLBOXH_HEIGHT;
	pi->nDefaultWidth = pi->uwWidth;
	pi->nDefaultHeight = pi->uwHeight;

};



int nGetToolBoxWidth(void)
{
	return(TOOLBOXH_WIDTH);
}

int nGetToolBoxHeight(void)
{
	return(TOOLBOXH_HEIGHT);
}


VOID UpperCase(char *sOldString)
{
char *i = sOldString;
const int diff = 'a' - 'A';

 if (sOldString == NULL) return();
 while (*i != '\0')
 {
	if ((*i >= 'a')&&(*i <= 'z')) *i = *i - diff;
	i++;
 }
 return;
}


VOID LowerCase(char *sOldString)
{
char *i = sOldString;
const int diff = 'a' - 'A';

 if (sOldString == NULL) return();
 while (*i != '\0')
 {
	if ((*i >= 'A')&&(*i <= 'Z')) *i += diff;
	i++;
 }
 return;
}

void SetGlobalDefaults(void)
{
	nUserReqHeight = 200;
	nUserReqWidth  = 320;
	return;
}

/* Sets all startup options from startup arguments, using ToolTypes if
   BStartedFromWB is TRUE, otherwise from command line */
/* Returns the result of the ParseRexx() function */
void ParseArgs(void)
{
	int nParam;
	char *szParam, *pcTemp;
	BOOL BSuccess;
	static char szIconName[150];
	static UWORD uwRexxArgsFound = 0L;		/* start empty */
	static BOOL BParsedBefore = FALSE;
		
	if (BStartedFromWB == TRUE) 
	{
		if (SetupToolTypeArg() == FALSE) return;
	}	/* can't proceed unless we can access the icon! */
	else
	{
		if ((argc == 1)||(BParsedBefore == TRUE))
		{
			szProgramName = argv[0];
			if ((szProgramName == NULL)||(strlen(szProgramName) == 0)||(strcmp(szProgramName," ") == 0)) szProgramName = "AmiSlate";
			*szIconName = '\0';
			
			/* Add path, if there isn't a base in the filename */
			pcTemp = strchr(szProgramName,':');
			if (pcTemp == NULL) strcpy(szIconName,"PROGDIR:");		
			
			strncat(szIconName, szProgramName, sizeof(szIconName));			
			szProgramName = szIconName;			
			if (SetupToolTypeArg() == FALSE) szProgramName = NULL;
		}
	}
	
	if (BParsedBefore == FALSE)
	{
		BSuccess = GetSlateArg("WIDTH",&nUserReqWidth, &szParam);
		if ((BSuccess)&&(nUserReqWidth < (nGetToolBoxWidth()+MIN_WIDTH_OFFSET))) 
			nUserReqWidth = nGetToolBoxWidth()+MIN_WIDTH_OFFSET;	 /* Minimum width */
	
		BSuccess = GetSlateArg("HEIGHT",&nUserReqHeight, &szParam);
		if ((BSuccess)&&(nUserReqHeight < (nGetToolBoxHeight()+nTitleHeight+MIN_HEIGHT_OFFSET))) 
			nUserReqHeight = nGetToolBoxHeight()+nTitleHeight+MIN_HEIGHT_OFFSET; /* Minimum height */

	
		BSuccess = GetSlateArg("TOP",&nUserReqTop, &szParam);
		
		BSuccess = GetSlateArg("LEFT",&nUserReqLeft, &szParam);
		
		BSuccess = GetSlateArg("PUBSCREEN", &nParam, &szParam);
		if (!BSuccess) BSuccess = GetSlateArg("PUBLICSCREEN", &nParam, &szParam);
		if (BSuccess)
		{
		   strncpy(szPubScreenName,szParam,sizeof(szPubScreenName));
		   BUseCustomScreen = FALSE;
		   screentype = USE_PUBLICSCREEN;
		}
		
		BSuccess = GetSlateArg("REXXOUTPUT", &nParam, &szParam);
		if (BSuccess) strncpy(szRexxOutputFile,szParam,sizeof(szRexxOutputFile));
	
		BSuccess = GetSlateArg("WBSCREEN", &nParam, &szParam);
		if (!BSuccess) BSuccess = GetSlateArg("WORKBENCHSCREEN", &nParam, &szParam);
		if (BSuccess)
		{
			BUseCustomScreen = FALSE;
			screentype = USE_WORKBENCHSCREEN;
		}
		
		BSuccess = GetSlateArg("OUTQUEUE", &nParam, &szParam);
		if (BSuccess == TRUE) lOutputQueueSize = nParam;
	}
		
	uwRexxArgsFound = ParseRexxMenu(uwRexxArgsFound);
	
	BParsedBefore = TRUE;
        if (AmiSlateIconDiskObject != NULL) FreeDiskObject(AmiSlateIconDiskObject);
	return;
}


/* returns a bit pattern with bit n set if option n was set.
   Argument is a bit pattern in the same format, will not set an
   option if that bit is set. */
UWORD ParseRexxMenu(UWORD uwMask)
{
	int nParam,i,j;
	char *szParam, *pcTemp, szRexxArg[12];
	BOOL BSuccess;

	/* Get names/locations of Rexx quickies */
	for (i=-1; i < 10; i++)
	{ 
		sprintf(szRexxArg,"REXXMENU%i\0",i+1);

		if (i >= 0) j = i; else j = 9;
		
		if (!(uwMask & (1L << i)))
		{
			BSuccess = GetSlateArg(szRexxArg, &nParam, &szParam);
			if (BSuccess == TRUE)
			{
				/* Get first letter in _file_name */
				pcTemp = strrchr(szParam,'/');
				if (pcTemp == NULL) pcTemp = strrchr(szParam,':');
				if (pcTemp == NULL) pcTemp = szParam - 1;
				pcTemp++;	/* move past symbol to first char in name */
	
				strncpy(szRexxNames[j],pcTemp,REXXNAMELENGTH-1);
				strncpy(szRexxScripts[j],szParam,REXXSCRIPTLENGTH-1);
	
				/* Remove ugly .rexx extention from menu name */
				pcTemp = strrchr(szRexxNames[j],'.');
				if (pcTemp != NULL) *pcTemp = '\0';
				
				uwMask |= (1L << j);
			}
		}
	}
	return(uwMask);
}
	


BOOL GetSlateArg(char * szArg, int * nParam, char **szParam)
{
	if ((BStartedFromWB == TRUE)||(szProgramName != NULL))
		return(GetToolTypeArg(szArg,nParam,szParam));
	else
		return(GetCLIArg(szArg,nParam,szParam));
}

/* Searches command line arguments for an argument of the form
   ARG, ARG=PARAM, or arguments of the form ARG PARAM
   
   That is, if ARG is found, the next argument will be returned
   as PARAM */
BOOL GetCLIArg(char *szArg, int *nParam, char **szParam)
{
	int i;
	char *pcTemp;
	char szTemp[50];
		
	/* argc, argv must be defined globally! */
	
	for (i=1;i<argc;i++)
	{
		strncpy(szTemp,argv[i],sizeof(szTemp));
		UpperCase(szTemp);
		
		pcTemp = strchr(szTemp,'=');
		if (pcTemp != NULL) *pcTemp = '\0';
		
		if (strcmp(szTemp,szArg) == 0)
		{
			/* Found our argument! */
			
			/* Form is ARG=PARAM */
			if (pcTemp != NULL)
			{
				*szParam = strchr(argv[i], '=') + 1;
				*nParam  = atoi(pcTemp+1);
			}
			else
			{
				if (argv[i+1] == NULL)
				{
					*szParam = "";
					*nParam = 0;
				}
				else
				{
					*szParam = argv[i+1];
					*nParam = atoi(argv[i+1]);
				}
			}
			return(TRUE);
		}
	}
	return(FALSE);
}


BOOL SetupToolTypeArg(void)
{
	struct WBArg *wb_arg = ((struct WBStartup *) argv)->sm_ArgList;

	if (szProgramName != NULL)
		AmiSlateIconDiskObject = GetDiskObject((UBYTE *)szProgramName);
	else
		AmiSlateIconDiskObject = GetDiskObject((UBYTE *)wb_arg->wa_Name);
	return(AmiSlateIconDiskObject != NULL);
}




/* You must call SetupToolTypeArg before calling this function! */
BOOL GetToolTypeArg(char *szArg, int *nParam, char **szParam)
{
	static char sToolParam[200];
	char **toolarray = (char **) AmiSlateIconDiskObject->do_ToolTypes;
	char *sTemp;

	/* Clear default string */
	sToolParam[0] = '\0';
	*szParam = sToolParam;	/* Return pointer to it */
			
	if ((toolarray != NULL) &&
	    ((sTemp = (char *) FindToolType(toolarray,szArg)) != NULL))
	{
		*nParam = atoi(sTemp);
		strncpy(sToolParam,sTemp,sizeof(sToolParam));
		return(TRUE);
	}		 			
 	return(FALSE);
}

	

/* If given BSaveIt == TRUE, saves Scr's palette to an internal array.  If
   BSaveIt == FALSE, restore palette to screen Scr. */
/* If nOptMaxPen is negative, save/restore all colors, else restore pens zero
   through nOptMaxPen. */
void SaveScreenPalette(BOOL BSaveIt, int nOptMaxPen)
{
	static UWORD OrigScreenPalette[256];
	int i;
	UBYTE ubBlue, ubGreen, ubRed;
	
	if (nOptMaxPen < 0) nOptMaxPen = (1<<Scr->RastPort.BitMap->Depth);
	
	if (BSaveIt == TRUE)
	{
		for (i=0;i<nOptMaxPen;i++)
			OrigScreenPalette[i] = RGBComponents(i);
	}
	else
	{
		for (i=0;i<nOptMaxPen;i++)
		{	
			/* Decipher 12 righthand bits of word into ints */
			ubBlue  = (OrigScreenPalette[i]     ) & 0x000F;
			ubGreen = (OrigScreenPalette[i] >> 4) & 0x000F;
			ubRed   = (OrigScreenPalette[i] >> 8) & 0x000F;
			SetRGB4(&Scr->ViewPort, i, ubRed, ubGreen, ubBlue);
		}
		if (BPalettesLocked == TRUE) SendPalette();
	}
	
	return;
}




BOOL InitAreaStuff(void)
{	
	/* Clear buffer */
	memset(AreaBuffer, '\0', sizeof(WORD)*INTUITION_AREA_SIZE);
	InitArea(&AreaInfo, AreaBuffer, (INTUITION_AREA_SIZE * sizeof(WORD)) /5);
	
	TempRasterBitPlane = AllocRaster(Scr->Width, Scr->Height);
	if (TempRasterBitPlane == NULL) return(FALSE);
	
	InitTmpRas(&TempRaster, TempRasterBitPlane, RASSIZE(Scr->Height, Scr->Width));
	
	DrawWindow->RPort->TmpRas   = &TempRaster;
	DrawWindow->RPort->AreaInfo = &AreaInfo;

	return(TRUE);
}



/* UniqueName -- searches the given directory & filename and returns */
/*               a unique filename based on that filename            */
char * UniqueName(char *szPath)
{
	static char szRawFileName[600];
	int nCurrentRev = 0, nTries = 0;
	char *cTemp = NULL;
	FILE *fpTestWrite = NULL;

	/* Return an empty string given an empty string... */
	if (strlen(szPath) == 0) return("");

	/* Make a copy of the user's string to return */
	strncpy(szRawFileName, szPath, sizeof(szRawFileName));

	/* If it ends in a colon, return the original string immediately */
	/* This way, if the user specifies CON: or SPEAK: or something,
	   AmiSlate won't be foolishly opening CON:1, CON:2, etc. */
	cTemp = strchr(szRawFileName,'\0') - 1;
	if (*cTemp == ':') return(szRawFileName);
	
	/* First try it with the original filename */
	fpTestWrite = fopen(szRawFileName,"w");
	if (fpTestWrite != NULL) 
	{
		fclose(fpTestWrite);
		return(szRawFileName);
	}

	cTemp = strchr(szRawFileName, (char) 0);	/* now points to just after end of name */	
	cTemp--;  /* now points to last char */
	
	while ((cTemp >= szRawFileName)&&(*cTemp >= '0')&&(*cTemp <= '9')) cTemp--;
	cTemp++;	/* cTemp now points to the numerical extension of the name */
	
	nCurrentRev = atoi(cTemp);
	
	while (nTries < 300)
	{
		nCurrentRev++;
		nTries++;

		fpTestWrite = NULL;
		sprintf(cTemp,"%i",nCurrentRev);	
		fpTestWrite = fopen(szRawFileName,"w");
		if (fpTestWrite != NULL) 
		{
			fclose(fpTestWrite);
			return(szRawFileName);
		}		
	}
	return("");	/* Fail! */
}


VOID UserError(char *szErrorString)
{
	if (BStartedFromWB == TRUE)
		MakeReq("AmiSlate Aborting",szErrorString,NULL);
	else
		Printf("AmiSlate Abort: [%s]\n",szErrorString);
	return;
}



BOOL CheckForUserAbort(void)
{
	static int nReturn;
	static char szPrompt[50]="";
	static struct IntuiMessage *imsg;
	
	while (imsg = GT_GetIMsg(DrawWindow->UserPort)) 
	{
		switch (imsg->Class)
		{
			case IDCMP_CLOSEWINDOW:
				GT_ReplyIMsg(imsg);
				CleanExit(RETURN_OK);
				break;
				
			case IDCMP_VANILLAKEY: 
				if (imsg->Code == CHAR_ESCAPE)
				{
					GT_ReplyIMsg(imsg);
					sprintf(szPrompt,"Abort the %s?",pcWhatToAbort);
					nReturn = (MakeReq("AmiSlate Abort Request",szPrompt,"Continue|Abort") == 0);
					if (DrawWindow != NULL) SetPointer(DrawWindow, waitPointer, 16, 16, -6, 0);
					PState.BPenDown = FALSE;
					return(nReturn);
				}
				else GT_ReplyIMsg(imsg);
				break;
				
		 	case IDCMP_NEWSIZE: case IDCMP_REFRESHWINDOW:
				HandleIDCMP(imsg); 	/* do window resize, the regular way */
		 		break;

			case IDCMP_MENUPICK:
				SetMenuValues();	/* undo the damage */
				GT_ReplyIMsg(imsg);
				break;

		 	default:
		 		GT_ReplyIMsg(imsg);
		 		break;
		}
	}
	return(FALSE);
}




				
VOID wbmain(struct WBStartup *wbargv)
{
	BStartedFromWB = TRUE;
	main(0,(char **)wbargv);
	return;
}


int main(int local_argc, char *local_argv[])
{
BOOL BQuitNow = FALSE;
int i;
UWORD penarray[7] = {~0};
UBYTE bToDo = 0;
struct Process *me;
struct DaemonMessage *dm;
char sBuffer[100];

/* Yep, set global vars... what style! */
argc = local_argc;
argv = local_argv;

memset(targethost,'\0',sizeof(targethost));

IntuitionBase = OpenLibrary("intuition.library",38);
if (IntuitionBase != NULL) BDos20 = FALSE;
else
{
	IntuitionBase = OpenLibrary("intuition.library",37);
	if (IntuitionBase == NULL)
	{
		Printf("Couldn't open intuition.library!\n");
		CleanExit(RETURN_FAIL);
	}		
}

SocketBase = OpenLibrary("bsdsocket.library", 2);
/* No need to check SocketBase now, if it is NULL 
   we just disable network functions later... */
   
/* See if we were started by inetd... if so, go into passive mode */
me = (struct Process *) FindTask(NULL);
if (me != NULL)
{
	dm = (struct DaemonMessage *)me->pr_ExitData;
	if (dm != NULL)
	{
		 BAcceptingTCP = TRUE;			/* This means we're receiving, not necessarily that the user accepts */
 		 AcceptDrawSocket(dm);
		 if (BNetConnect == FALSE) CleanExit(RETURN_FAIL);
		 GetDrawPeerName(targethost, sizeof(targethost));
 		 sprintf(sBuffer, "AmiSlate connection requested by\n%s",targethost);
		 if (MakeReq(NULL, sBuffer,"Accept|Deny") == 0)	
		 {
		 	OutputAction(FROM_IDCMP, COMMAND, COMMAND_QUIT, NOP_PAD, NOP_PAD, NOP_PAD, DEST_PEER);
		 	CleanExit(RETURN_OK);
		 }
   }
}

/* If the first argument on the command line is ? then spit out info and exit */
if ((BAcceptingTCP == FALSE)&&(BStartedFromWB == FALSE)&&(argc > 1)&&(strcmp(argv[1],"?")==0))
{
	printf("Template:  AmiSlate WBSCREEN/S,TOP/K/N,LEFT/K/N,WIDTH/K/N,\
HEIGHT/K/N,PUBSCREEN/K,REXXOUTPUT/K,REXXOUTPUT/K,OUTQUEUE/K/N,REXXMENU1/K,\
REXXMENU2/K,{...}\n");

	CleanExit(RETURN_OK);
}



/* Sneaky test to see if we have OS3.x ? */
/* Accept TCP connection if appropriate */
GraphicsBase = OpenLibrary("graphics.library",37);
if (GraphicsBase == NULL)
{
	UserError("Couldn't open graphics.library!");
	CleanExit(RETURN_FAIL);
}

GadToolsBase = OpenLibrary("gadtools.library",36);
 if (GadToolsBase == NULL)
 {
 	UserError("Couldn't open gadtools.library!");
 	CleanExit(RETURN_FAIL);
 }
 
AslBase = OpenLibrary("asl.library",37L);
if (AslBase == NULL)
{
	UserError("Couldn't open asl.library!");
	CleanExit(RETURN_FAIL);
}

IconBase = OpenLibrary("icon.library",33);
if (IconBase == NULL) 
{
	UserError("Couldn't open icon.library!");
	CleanExit(RETURN_FAIL);
}


IFFParseBase = OpenLibrary("iffparse.library",37);
/* No user error/CleanExit bit--we'll just disable the IFF functions... */

/* Default to standard, non-functinal Rexx menu items */
memset(szRexxNames, '\0', sizeof(szRexxNames));
memset(szRexxScripts, '\0', sizeof(szRexxScripts));
 
ChatFont = (struct TextFont *) OpenDiskFont(&topaz8);
 if (ChatFont == NULL)
 {
 	UserError("Couldn't open topaz 8 font!");
 	CleanExit(RETURN_FAIL);
 }

InitToolBox();				/* SetUp ToolBox BitMap */
ParseArgs();				/* Get Startup arguments */

if (BStartedFromWB == FALSE) ParseArgs();	/* Do it again to fill any unused ARexx fields from ToolTypes */

/* Insert new ARexx menu items as per ToolTypes */
for (i=0; i<10; i++)
{
	if (szRexxNames[i][0] != '\0') 	
	{
		nmMenus[i+FIRSTREXXITEM].nm_Label = szRexxNames[i];
		nmMenus[i+FIRSTREXXITEM].nm_Flags &= ~(NM_ITEMDISABLED);
	}
}

if (AllocQueue(lOutputQueueSize) == FALSE)
{
	UserError("Unable to allocate memory for send queue");
	CleanExit(RETURN_FAIL);
}

/* Setup timer.device I/O request for ARexx command timeouts */
if (!(TimerMP = CreatePort(0,0)))
{
	UserError("Couldn't create timer IO port");
	CleanExit(RETURN_FAIL);
}

if (!(TimerIO = (struct timerequest *) CreateExtIO(TimerMP, (sizeof (struct timerequest)))))
{
	UserError("Couldn't create timer IO request");
	CleanExit(RETURN_FAIL);
}
timerSignal = 1L << TimerMP->mp_SigBit;

/* Allow access to timer device's library functions */
TimerBase = (struct Library *) TimerIO->tr_node.io_Device;

/* Open the timer.device with UNIT_WAITUNTIL for ARexx timeouts */
if (OpenDevice(TIMERNAME,UNIT_VBLANK,(struct IORequest *)TimerIO,0))
{
	UserError("Couldn't open timer.device");
	CleanExit(RETURN_FAIL);
}
TimerIO->tr_node.io_Message.mn_ReplyPort = TimerMP;
TimerIO->tr_node.io_Command = TR_ADDREQUEST;
TimerIO->tr_node.io_Flags = 0;
TimerIO->tr_node.io_Error = 0;
TimerIO->tr_time.tv_secs  = 0;
TimerIO->tr_time.tv_micro = 0; /* this won't be set until we actually do the req */

/* Get Screen Data for user's info when selecting a screen */
if (BAcceptingTCP == TRUE)
{
	if (GetRemoteScreenInfo(&PState.uwRemoteScreenHeight,
	                        &PState.uwRemoteScreenWidth,
	                        &PState.ubRemoteDepth,
	                        &PState.uwHeight,
	                        &PState.uwWidth) == FALSE) 
	{
		MakeReq("AmiSlate Error","Couldn't Get Remote Screen Info","Abort");
		CleanExit(RETURN_OK);
	}
}
else
    PState.ubRemoteDepth = -1;		/* Keeps Display requester from showing remote screen specs */

/* now open/lock the screen */
if (BUseCustomScreen == TRUE)
{
	Scr = GetDisplay(PState.uwRemoteScreenHeight, PState.uwRemoteScreenWidth, PState.ubRemoteDepth);	
 	if ((Scr == NULL)&&(screentype == USE_CUSTOMSCREEN)) CleanExit(RETURN_OK);
}

if ((screentype == USE_WORKBENCHSCREEN)||(screentype == USE_PUBLICSCREEN))
{
	Scr = LockPubScreen(szPubScreenName);
	if (Scr == NULL)
	{
		sprintf(szRexxOutputFile,"Couldn't lock the screen: [%s]!\n",szPubScreenName);
		UserError(szRexxOutputFile);
		CleanExit(RETURN_FAIL);
	}
	BUseCustomScreen = FALSE;
}

nTitleHeight = ScreenTitleHeight();
ResetState(&PState);		/* Initialize to defaults */

if (BAcceptingTCP == TRUE)
{
	/* Correct for the obvious */
	if (PState.uwWidth  > PState.uwRemoteScreenWidth)  PState.uwWidth  = PState.uwRemoteScreenWidth;
	if (PState.uwHeight > PState.uwRemoteScreenHeight) PState.uwHeight = PState.uwRemoteScreenHeight;
}


if (nUserReqLeft == -1) nUserReqLeft = (Scr->Width-PState.uwWidth)/2;
if (nUserReqTop  == -1) nUserReqTop  = (Scr->Height-PState.uwHeight)/2 + ScreenTitleHeight();

if (BUseCustomScreen == TRUE)
{
	DrawWindow = OpenWindowTags(NULL,
		 WA_Left,	    nUserReqLeft,
		 WA_Top,	    nUserReqTop,
		 WA_Width,	    PState.uwWidth,
		 WA_Height,	    PState.uwHeight,
		 WA_MinWidth,	    PState.nToolBoxWidth+MIN_WIDTH_OFFSET,
		 WA_MinHeight,	    PState.nToolBoxHeight+nTitleHeight+MIN_HEIGHT_OFFSET,
		 WA_MaxWidth,	    PState.uwRemoteScreenWidth,
		 WA_MaxHeight,	    PState.uwRemoteScreenHeight,
		 WA_CustomScreen,   Scr,
		 WA_ScreenTitle,    sScreenTitle,
		 WA_Title,	    sWindowTitle,
		 WA_CloseGadget,    TRUE,
		 WA_DepthGadget,    TRUE,
		 WA_SizeGadget,     TRUE,
		 WA_Activate,	    TRUE,
		 WA_DragBar,	    TRUE,
		 WA_ReportMouse,    TRUE,
		 WA_SizeBBottom,    TRUE,
/*		 WA_RMBTrap,        TRUE, */
		 /* Specify what events we want to be notified of */
		 WA_IDCMP,	    IDCMP_MENUPICK|IDCMP_MOUSEMOVE|
		                    IDCMP_MOUSEBUTTONS|IDCMP_CLOSEWINDOW|
		                    IDCMP_NEWSIZE|IDCMP_VANILLAKEY|IDCMP_RAWKEY,
		 TAG_DONE);
	screentype = USE_CUSTOMSCREEN;
}
else
{
	/* Don't mess with the palette on IFF load if we're not on our own screen, at least by default */
	BLoadIFFPalettes = FALSE;
	
	if (strcmp(szPubScreenName,"Workbench") == 0)
	{
		DrawWindow = OpenWindowTags(NULL,
		 WA_Left,	    nUserReqLeft,
		 WA_Top,	    nUserReqTop,
		 WA_Width,	    PState.uwWidth,
		 WA_Height,	    PState.uwHeight,
		 WA_MinWidth,	    PState.nToolBoxWidth+MIN_WIDTH_OFFSET,
		 WA_MinHeight,	    PState.nToolBoxHeight+nTitleHeight+MIN_HEIGHT_OFFSET,
		 WA_MaxWidth,	    PState.uwRemoteScreenWidth,
		 WA_MaxHeight,	    PState.uwRemoteScreenHeight,
		 WA_CloseGadget,    TRUE,
		 WA_DepthGadget,    TRUE,
		 WA_ScreenTitle,    sScreenTitle,
		 WA_Title,	    sWindowTitle,
		 WA_SizeGadget,     TRUE,
		 WA_Activate,	    TRUE,
		 WA_DragBar,	    TRUE,
		 WA_ReportMouse,    TRUE,
		 WA_SizeBBottom,    TRUE,
/*		 WA_RMBTrap,        TRUE,*/
		 /* Specify what events we want to be notified of */
		 WA_IDCMP,	    IDCMP_MENUPICK|IDCMP_MOUSEMOVE|
		 		    IDCMP_MOUSEBUTTONS|IDCMP_CLOSEWINDOW|
		 		    IDCMP_NEWSIZE|IDCMP_VANILLAKEY|IDCMP_RAWKEY,
		 TAG_DONE);										 
		screentype = USE_WORKBENCHSCREEN;
	}
	else
	{
		DrawWindow = OpenWindowTags(NULL,
		 WA_Left,	       nUserReqLeft,
		 WA_Top,	       nUserReqTop,
		 WA_Width,	       PState.uwWidth,
		 WA_Height,	       PState.uwHeight,
		 WA_MinWidth,	       PState.nToolBoxWidth+MIN_WIDTH_OFFSET,
		 WA_MinHeight,	       PState.nToolBoxHeight+nTitleHeight+MIN_HEIGHT_OFFSET,
		 WA_MaxWidth,	       PState.uwRemoteScreenWidth,
		 WA_MaxHeight,	       PState.uwRemoteScreenHeight,
		 WA_PubScreen,	       Scr,
		 WA_PubScreenFallBack, TRUE,
		 WA_ScreenTitle,       sScreenTitle,
		 WA_Title,	       sWindowTitle,
		 WA_CloseGadget,       TRUE,
		 WA_DepthGadget,       TRUE,
		 WA_SizeGadget,        TRUE,
		 WA_Activate,	       TRUE,
		 WA_DragBar,	       TRUE,
		 WA_ReportMouse,       TRUE,
		 WA_SizeBBottom,       TRUE,
/*		 WA_RMBTrap,           TRUE,*/
		 /* Specify what events we want to be notified of */
		 WA_IDCMP,	IDCMP_MENUPICK    | IDCMP_MOUSEMOVE|
		                IDCMP_MOUSEBUTTONS| IDCMP_CLOSEWINDOW|
		                IDCMP_NEWSIZE     | IDCMP_VANILLAKEY|IDCMP_RAWKEY,
		 TAG_DONE);	
		screentype = USE_PUBLICSCREEN;
	}
}

if ((DrawWindow==NULL)||(CreateDrawMenus() == FALSE)) CleanExit(RETURN_WARN);

/* Keep original palette values for when we Exit */
SaveScreenPalette(TRUE,-1);

if (BAcceptingTCP == TRUE) 
{
	Synch();
	sprintf(sBuf,"Connection to %s established.", targethost);
	SetWindowTitle(sBuf);
 	OutputAction(FROM_IDCMP, COMMAND, COMMAND_HELLO, NOP_PAD, NOP_PAD, NOP_PAD, DEST_PEER);
}

SetFont(DrawWindow->RPort, ChatFont);

/* Plonk down the ToolBox */
DrawToolBox();
DrawChatLines();

/* window IDCMP, timer IDCMP (when implemented), CTRL-C */
ulIDCMPmask =  (1L << DrawWindow->UserPort->mp_SigBit) | SIGBREAKF_CTRL_C | timerSignal;   
rexxHost = SetupARexxHost("AMISLATE",NULL);

if (rexxHost == NULL) Printf("Warning--couldn't open ARexx port!\n");
		 else ulIDCMPmask |= (1L<<rexxHost->port->mp_SigBit);

SetMenuValues();


if (InitAreaStuff() == FALSE) 
{
	UserError("Couldn't allocate Temp Raster!\n");
	CleanExit(RETURN_FAIL);
}
					
/* This is the main event loop. */
while (BProgramDone == FALSE)
 {
   if (PState.uwRexxWaitMask & REXX_REPLY_IMMEDIATE) SetStandardRexxReturns();

   bToDo |= DrawWait();
   if (bToDo & IDCMP_READY) {HandleIDCMP(NULL); bToDo &= ~(IDCMP_READY);}
   if (bToDo & READ_READY)  {RemoteHandler(NULL,FALSE); bToDo &= ~(READ_READY);}
   if ((bToDo & AREXX_READY)&&(PState.uwRexxWaitMask == 0)) 
   			    {ARexxDispatch(rexxHost); bToDo &= ~(AREXX_READY);}
   if (bToDo & WRITE_READY) {ReduceQueue(); bToDo &= ~(WRITE_READY);}
 }	
CleanExit(RETURN_OK);		/* Exit the program */
}
