/* AmiSlate.h -- function prototypes & etc. */
#ifndef AMISLATE_H
#define AMISLATE_H

#define USE_WORKBENCHSCREEN 0
#define USE_CUSTOMSCREEN    1
#define USE_PUBLICSCREEN    2

/* SlateRaster contains the current state of a given raster transmission
   box. */
struct SlateRaster {
	int nRX;	   	/* left edge of raster box */
	int nRY;	   	/* top edge of raster box */
	int nRWidth;  		/* width of raster box */
	int nRHeight; 		/* height of raster box */
	int nRCurrentOffset;	/* number of pixels into the box */
};


/* PaintInfo contains all the state information needed to interpret sent
   commands correctly.  */
struct PaintInfo {
	UBYTE  BPenDown;	/* TRUE = Pen Down, False = Pen Up */
	UBYTE  ubDepth;	    	/* Depth of Window */
	UWORD  uwWidth;	    	/* Width of Window */
	UWORD  uwHeight;	/* Height of Window */
	UWORD  uwMode;		/* Current Mode of Window (MODE_*) */
	UWORD  uwFColor;	/* Current Foreground Color of Window */
	UWORD  uwBColor;	/* Current Background Color of Window */
	int    nToolBoxWidth;
	int    nToolBoxHeight; 
	int    nDefaultWidth;
	int    nDefaultHeight;
	BOOL   BDrawEnabled;
	int    nSizeState;      /* normal, active, or passive */
	
	/* Info on Rexx port's state */
	UWORD  uwRexxFColor;
	UWORD  uwRexxBColor;
	UWORD  uwRexxWaitMask;
	
	/* From here down contains info on the remote machine's state */
	UWORD  uwRemoteScreenWidth;
	UWORD  uwRemoteScreenHeight;
	UBYTE  ubRemoteDepth;   /* # of bitplanes on remote machine's screen */
	UWORD  uwRemoteMode;    /* Current mode of remote machine (MODE_*) */
	UWORD  uwRemoteFColor;
	UWORD  uwRemoteBColor;
	
	struct SlateRaster RemoteRaster;
	struct SlateRaster LocalRaster;	 	
	struct SlateRaster RexxRaster;		
};



/* Here are the bit codes for different ARexx_return_ready values */
#define REXX_REPLY_TIMEOUT     0x0001
#define REXX_REPLY_MESSAGE     0x0002
#define REXX_REPLY_MOUSEDOWN   0x0004
#define REXX_REPLY_MOUSEUP     0x0008
#define REXX_REPLY_RESIZE      0x0010
#define REXX_REPLY_QUIT        0x0020
#define REXX_REPLY_CONNECT     0x0040
#define REXX_REPLY_DISCONNECT  0x0080
#define REXX_REPLY_TOOLSELECT  0x0100
#define REXX_REPLY_COLORSELECT 0x0200
#define REXX_REPLY_KEYPRESS    0x0400
#define REXX_REPLY_MOUSEMOVE   0x0800

#define REXX_REPLY_IMMEDIATE   0x4000	/* Internal use only--when timeout = 0 */
#define REXX_REPLY_IFFLOAD     0x8000	/* Internal use only */

/* These help arbitrate window sizing to avoid race conditions */
#define SIZEMODE_NORMAL	 0x0000
#define SIZEMODE_ACTIVE  0x0001
#define SIZEMODE_PASSIVE 0x0002

VOID ResetState(struct PaintInfo *pi);
VOID Swap(int *i1, int *i2);
VOID SwapPointers(VOID *(*p1), VOID *(*p2));
VOID ClearWindow(VOID);
VOID SetGlobalDefaults(VOID);
VOID ParseArgs(VOID);
VOID UpperCase(char *sOldString);
VOID LowerCase(char *sOldString);
VOID SetWindowTitle(char *sString);
VOID ToggleSafeFlood(VOID);
VOID AdjustColor(char cKeyPressed, int nStep, int nPaletteEntry, UWORD *uwPresetColor, BOOL BTransmit);
VOID SaveScreenPalette(BOOL BSaveIt, int nOptMaxPen);
VOID ExecuteRexxScript(char *szPreparedFileName);
VOID BreakRexxScripts(VOID);
VOID SetMenuValues (VOID);
VOID UserError(char *szErrorString);
VOID ToggleLockPalettes(VOID);
VOID SaveUserIFF(char *szPreparedFileName);
VOID LoadUserIFF(char *szPreparedFileName);

int  ScreenTitleHeight(VOID);
int  MatchPalette(UBYTE ubRed, UBYTE ubGreen, UBYTE ubBlue, BOOL BNotBackground, BOOL * BDeniedPenMap, BOOL * BJustAlloced);
int  CleanExit(LONG lReturnResult);
int  SaveScriptToDisk(VOID);
int  PlayScriptFromDisk(VOID);
int  ShowAbout(VOID);
BOOL HandleIDCMP(struct IntuiMessage *defaultMessage);
BOOL CreateDrawMenus(VOID);
BOOL GetSlateArg(char *szArg, int *nParam, char **szParam);
BOOL GetCLIArg(char *szArg, int *nParam, char **szParam);
BOOL GetToolTypeArg(char *szArg, int *nParam, char **szParam);
BOOL SetupToolTypeArg(void);
BOOL LoadUserIFFNamed(int nFromCode, char * szFileName);
BOOL SaveUserIFFNamed(char *szFileName);

LONG Max(LONG lA, LONG lB);
LONG Min(LONG lA, LONG lB);

UWORD RGBComponents(UWORD uwPaletteEntry);
UWORD ParseRexxMenu(UWORD uwMask);

int MakeReq(char *sText, char *sTitle, char *sGadgets);

char * UniqueName(char *szPath);

void debug(int nID);
VOID wbmain(struct WBStartup *wbargv);
int main(int local_argc, char *local_argv[]);
BOOL CheckForUserAbort(void);
void SetStandardRexxReturns(void);

#endif
