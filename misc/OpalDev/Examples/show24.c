#include <opal/opallib.h>
#include <workbench/icon.h>
#include <workbench/workbench.h>
#include <workbench/startup.h>
#include <intuition/intuitionbase.h>
#include <proto/all.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>


#define VERSION "1.3"

	/* 2.0 style version string for the VERSION command */
char Version[] = "\0$VER: Show24 " VERSION " (5.11.92)";

struct IntuitionBase *IntuitionBase;
struct GfxBase *GfxBase;
struct OpalBase *OpalBase;
struct OpalScreen *OScrn;
struct WBArg *WBArg;
BOOL FromWB;
UBYTE *Button = (UBYTE *)0xbfe001;		/* Nasty */

#define OR ||
#define AND &&

char Banner[] = "[33mShow24[31m V"VERSION" by Martin Boyd, ©1992 Opal Technology Pty Ltd.\n";

void Show_Pic (char *Name);
void Clean_Up (char *String,int RetCode);
char *WB_Arg (void);
int Num_WB_Args (struct WBStartup *ArgMsg);

void Open_BGScreen (void);
void Close_BGScreen (void);
static struct Screen *BGScrn;

void App_Wait (void);
void Error_Msg (char *String);


void main (int argc,char *argv[])
{
   int i,NumArgs;
   char *Name;

	if (argc==0)
		{ NumArgs = Num_WB_Args ((struct WBStartup *)argv);
		  FromWB = TRUE;
		}
	else
		NumArgs = argc-1;

	if (!FromWB)
		puts (Banner);

	GfxBase = (struct GfxBase *) OpenLibrary ("graphics.library",0L);
	IntuitionBase = (struct IntuitionBase *) OpenLibrary ("intuition.library",0L);
	if ((GfxBase==NULL) OR (IntuitionBase==NULL))
		Clean_Up (NULL,10);

	OpalBase = (struct OpalBase *) OpenLibrary ("opal.library",0L);
	if (OpalBase==0L)
		Clean_Up ("Can't open opal.library\n",10);
	OScrn = NULL;

	if ((FromWB) AND (NumArgs==0))
		{ App_Wait();
		  Clean_Up (NULL,0);
		}

	if (NumArgs<1)
		Clean_Up ("Usage: Show24 File\n",0);


	for (i=1; i<=NumArgs; i++)
		{ if (FromWB)
			Name = WB_Arg();
		  else
			Name = argv[i];
		  Show_Pic (Name);
		}

	Clean_Up (NULL,0);
}


void Show_Pic (char *Name)
{
   long Err;

	Err = LoadIFF24 (NULL,Name,VIRTUALSCREEN24);
	if (Err < OL_ERR_MAXERR)
		{ if (Err==OL_ERR_OPENFILE)
			Error_Msg ("Error opening file!!");
		  else if ((Err==OL_ERR_NOTILBM) OR (Err==OL_ERR_BADIFF)
			OR (Err==OL_ERR_FORMATUNKNOWN))
			Error_Msg ("Not a recognised file format!!");
		  else if (Err==OL_ERR_OUTOFMEM)
			Error_Msg ("Out of memory!!\n");
		  else if (Err==OL_ERR_CTRLC)
			Error_Msg ("Aborted");
		  else
			Error_Msg ("Error displaying image!!");
		  return;
		}
	if (BGScrn==NULL)
		Open_BGScreen ();
	OScrn = (struct OpalScreen *) Err;
	Err = (long)LowMemUpdate24 (OScrn,0);
	if ((Err>OL_ERR_MAXERR) AND (!(OScrn->Flags&ILACE24)))
		{ AutoSync24 (TRUE);
		  Err = (long)LowMemUpdate24 (OScrn,6);
		}
	FreeScreen24 (OScrn);
	if (Err < OL_ERR_MAXERR)
		{ CloseScreen24 ();
		  if (Err==OL_ERR_OUTOFMEM)
			Error_Msg ("Out of memory!!");
		  else if (Err==OL_ERR_CANTCLOSE)
			Error_Msg ("OpalVision Display in Use.");
		  else
			Error_Msg ("Error Displaying image!!");
		  return;
		}
	AutoSync24 (TRUE);

	while (!(*Button & (1<<6)));
	while (*Button & (1<<6));

	CloseScreen24();
}

int Num_WB_Args (struct WBStartup *ArgMsg)
{
	WBArg = ArgMsg->sm_ArgList;
	return (ArgMsg->sm_NumArgs-1);
}


char *WB_Arg (void)
{
	WBArg++;
	CurrentDir (WBArg->wa_Lock);
	return (WBArg->wa_Name);
}

void _abort (void)
{
	Clean_Up (NULL,0);
}


void Clean_Up (char *String,int RetCode)
{

	if (OpalBase!=NULL)
		{ CloseScreen24 ();
		  CloseLibrary ((struct Library *)OpalBase);
		}
	if (String!=NULL)
		Error_Msg (String);
	Close_BGScreen ();
	if (IntuitionBase!=NULL) CloseLibrary ((struct Library *)IntuitionBase);
	if (GfxBase!=NULL) CloseLibrary ((struct Library *)GfxBase);
	exit (RetCode);
}



/*  Open a standard screen intuition so that it will function
 * correctly with the AA chip set in multi sync mode.
 */

static struct NewScreen BGNewScreen = {
	0,0,320,2,1,(UBYTE)-1,(UBYTE)-1,0,
	CUSTOMSCREEN|SCREENQUIET,
	NULL,NULL,NULL,NULL
};


static USHORT BGPalette[] = { 0x0001 };

void Open_BGScreen (void)
{
   struct MonitorInfo MonitorInfo;
   struct DisplayInfo DisplayInfo;
   DisplayInfoHandle Handle;
   ULONG ModeID;
   LONG Result;

	if (IntuitionBase->LibNode.lib_Version<36) return;
	ModeID = GetVPModeID (&IntuitionBase->FirstScreen->ViewPort);
	Handle = FindDisplayInfo (ModeID);
	Result = GetDisplayInfoData (Handle,(UBYTE *)&MonitorInfo,
			sizeof (struct MonitorInfo),DTAG_MNTR,NULL);
	Result = GetDisplayInfoData (Handle,(UBYTE *)&DisplayInfo,
			sizeof (struct DisplayInfo),DTAG_DISP,NULL);

	/*  If line frequency if >15Khz, we must open
	 * a low scan rate frequency screen.
	 */

	if (MonitorInfo.TotalColorClocks<220)
		{ if (DisplayInfo.PropertyFlags & DIPF_IS_PAL)
			BGNewScreen.Height = 256;
		  else
			BGNewScreen.Height = 200;
		  BGScrn = OpenScreen (&BGNewScreen);
		  if (BGScrn!=NULL)
			LoadRGB4 (&BGScrn->ViewPort,BGPalette,1L);
		}
}

void Close_BGScreen (void)
{
	if (BGScrn!=NULL)
		CloseScreen (BGScrn);
	BGScrn = NULL;
}



/* Start an AppIcon and wait for messages.
 */

extern struct DiskObject AppObject;
struct Library *WorkbenchBase;

BOOL Info_Req (void);


void App_Wait (void)
{
   struct MsgPort *AppPort;
   struct AppIcon *AppIcon;
   struct AppMessage *AppMsg;
   BPTR OldDir;
   int i;

	WorkbenchBase = OpenLibrary ("workbench.library",36L);
	if (WorkbenchBase==NULL) return;
	AppPort = CreateMsgPort ();
	if (AppPort==NULL)
		{ CloseLibrary (WorkbenchBase);
		  return;
		}

	AppIcon = AddAppIconA (0,NULL,"Show24",AppPort,NULL,&AppObject,NULL);
	if (AppIcon==NULL)
		{ DeleteMsgPort (AppPort);
		  CloseLibrary (WorkbenchBase);
		  return;
		}

	/* Wait for App Messages */

	FOREVER
		{ WaitPort (AppPort);
		  while (AppMsg = (struct AppMessage *)GetMsg (AppPort))
			{ if (AppMsg->am_NumArgs==0L)
				{ if (!Info_Req ())
					{ RemoveAppIcon (AppIcon);
					  DeleteMsgPort (AppPort);
					  CloseLibrary (WorkbenchBase);
					  return;
					}
				}
			  else if (AppMsg->am_NumArgs>0)
				{ for (i=0; i<AppMsg->am_NumArgs; i++)
					{ OldDir = CurrentDir (AppMsg->am_ArgList[i].wa_Lock);
					  Show_Pic (AppMsg->am_ArgList[i].wa_Name);
					  CurrentDir (OldDir);
					}
				}
			}
		  Close_BGScreen ();
		}
}



char Banner2[] = "Show24 V"VERSION" ©1992 Opal Technology";

struct EasyStruct MyES = 
	{ sizeof (struct EasyStruct),
	  0,
	  (UBYTE *)Banner2,
	  (UBYTE *)"To display images, drop their\nicons onto this icon.\nTo Remove Show24 select quit.",
	  (UBYTE *)"Continue|Quit"
	};





BOOL Info_Req (void)
{
   BOOL Res;

	if (IntuitionBase->LibNode.lib_Version<36)
		return (TRUE);
	Res = EasyRequestArgs (NULL,&MyES,NULL,NULL);
	return (Res);
}


struct EasyStruct ErrorES = 
	{ sizeof (struct EasyStruct),
	  0,
	  (UBYTE *)Banner2,
	  NULL,
	  (UBYTE *)"OK"
	};


void Error_Msg (char *String)
{

	if (String==NULL) return;
	if (!FromWB)
		{ puts (String);
		  return;
		}

	if (IntuitionBase->LibNode.lib_Version<36)
		return;
	ErrorES.es_TextFormat = (UBYTE *)String;
	EasyRequestArgs (NULL,&ErrorES,NULL,NULL);
}


USHORT IconData[] = {
	0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,
	0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,
	0x1FFF,0xFFFF,0xFC00,0x0000,0x1000,0x0000,0x0400,0x0000,
	0x10AA,0xAABA,0x8400,0x0000,0x12AA,0xAAFA,0xA400,0x0000,
	0x12AA,0xABFA,0xA40F,0x0700,0x12AA,0xAFFA,0xA41F,0x8F80,
	0x12AA,0xBFFF,0xFF8D,0xDF80,0x12AA,0xBFFF,0xFFC3,0xFF80,
	0x12AA,0xBFFF,0xFFC7,0xBFC0,0x12AA,0xAFFF,0xFFCF,0x1FE0,
	0x12AA,0xABFA,0xA41F,0x8380,0x12AA,0xAAFA,0xA40F,0xC180,
	0x10AA,0xAABA,0x8400,0x0000,0x1000,0x0000,0x0400,0x0000,
	0x1FFF,0xFFFF,0xFC00,0x0000,0x007F,0x003F,0x8000,0x0000,
	0x0100,0x0000,0x2000,0x0000,0x0200,0x0000,0x1000,0x0000,
	0x03FF,0xFFFF,0xF000,0x0000,0x0000,0x0000,0x0000,0x0000,
	0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,
	0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,
	0x0FFF,0xFFFF,0xF800,0x0000,0x0E00,0x0010,0x3800,0x0000,
	0x0C00,0x0070,0x1800,0x0000,0x0C00,0x01F0,0x180F,0x0700,
	0x0C00,0x07F0,0x1819,0x8F00,0x0C00,0x1FFF,0xFF81,0x9B00,
	0x0C00,0x3FFF,0xFF83,0x3300,0x0C00,0x0FFF,0xFF86,0x3FC0,
	0x0C00,0x03F0,0x000C,0x0300,0x0C00,0x00F0,0x181F,0x8300,
	0x0C00,0x0030,0x1800,0x0000,0x0E00,0x0000,0x3800,0x0000,
	0x0FFF,0xFFFF,0xF800,0x0000,0x0000,0x0000,0x0000,0x0000,
	0x0000,0xFFC0,0x0000,0x0000,0x00FF,0xFFFF,0xC000,0x0000,
	0x01FF,0xFFFF,0xE000,0x0000,0x0000,0x0000,0x0000,0x0000
};

struct Image IconImage = {
	0,0,
	59,23,
	2,
	IconData,
	0x0003,0x0000,
	NULL
};

struct DiskObject AppObject =
	{ NULL,
	  NULL,
		{ NULL,
		  0,0,
		  59,23,
		  NULL,
		  NULL,
		  NULL,
		  (APTR)&IconImage,
		  NULL,NULL,NULL,NULL,
		  NULL,NULL
		},
	  NULL,
	  NULL,		/* NAME */
	  NULL,
	  NO_ICON_POSITION,
	  NO_ICON_POSITION,
	  NULL,
	  NULL,
	  NULL
	};

