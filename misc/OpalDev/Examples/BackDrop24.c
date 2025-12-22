#include <exec/types.h>
#include <opal/opallib.h>
#include <intuition/intuitionbase.h>
#include <workbench/icon.h>
#include <workbench/workbench.h>
#include <workbench/startup.h>
#include <proto/all.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>


#define VERSION "1.2"

	/* 2.0 style version string for the VERSION command */
char Version[] = "\0$VER: BackDrop24 " VERSION " (5.11.92)";

struct OpalBase *OpalBase;
struct GfxBase *GfxBase;
struct IntuitionBase *IntuitionBase;
struct OpalScreen *OScrn;
struct WBArg *WBArg;
BOOL FromWB;

#define OR ||
#define AND &&

char Banner[] = "[33mBackDrop24[31m V"VERSION" by Martin Boyd, ©1992 Opal Technology Pty Ltd.\n";
char Usage[] = "Usage: BackDrop24 File\n";

void Clean_Up (char *String,int RetCode);
char *WB_Arg (void);
int Num_WB_Args (struct WBStartup *ArgMsg);
void Remove_Latch (void);
BOOL Display_Mode_Check (void);


void main (int argc,char *argv[])
{
   long Err;
   int NumArgs;
   char *Name;

	if (argc==0)
		{ NumArgs = Num_WB_Args ((struct WBStartup *)argv);
		  FromWB = TRUE;
		}
	else
		NumArgs = argc-1;

	if (!FromWB)
		puts (Banner);
	if (!Display_Mode_Check())
		Clean_Up ("You cannot run a backdrop with a high scan-rate Amiga display (>15Khz).\n",0);


	OpalBase = (struct OpalBase *) OpenLibrary ("opal.library",0L);
	if (OpalBase==0L)
		Clean_Up ("Can't open opal.library\n",10);

	if (NumArgs==0)
		{ Remove_Latch();
		  if (!FromWB)
			puts (Usage);
		  Clean_Up ("BackDrop Removed.",0);
		}

	if (NumArgs!=1)
		Clean_Up (Usage,0);

	OScrn = NULL;
	if (FromWB)
		Name = WB_Arg();
	else
		Name = argv[1];
	Err = LoadIFF24 (NULL,Name,VIRTUALSCREEN24);
	if (Err < OL_ERR_MAXERR)
		{ if (Err==OL_ERR_OPENFILE)
			Clean_Up ("Error opening file!!\n",10);
		  else if ((Err==OL_ERR_NOTILBM) OR (Err==OL_ERR_BADIFF)
			OR (Err==OL_ERR_NOTIFF))
			Clean_Up ("Not a recognised file format!!\n",10);
		  else if (Err==OL_ERR_OUTOFMEM)
			Clean_Up ("Out of memory!!\n",10);
		  else if (Err==OL_ERR_CTRLC)
			Clean_Up ("",0);
		  else
			Clean_Up ("Error displaying file!!\n",10);
		}
	OScrn = (struct OpalScreen *) Err;
	Err = (long)LowMemUpdate24 (OScrn,0);
	if ((Err>OL_ERR_MAXERR) AND (!(OScrn->Flags&ILACE24)))
		Err = (long)LowMemUpdate24 (OScrn,6);
	FreeScreen24 (OScrn);
	if (Err < OL_ERR_MAXERR)
		{ if (Err==OL_ERR_OUTOFMEM)
			Clean_Up ("Out of memory!!\n",10);
		  if (Err==OL_ERR_CANTCLOSE)
			Clean_Up ("OpalVision Display in Use.\n",10);
		  Clean_Up ("Error Displaying Backdrop\n",10);
		}
	AmigaPriority ();
	DualDisplay24 ();
	AutoSync24 (TRUE);
	Delay (2L);
	LatchDisplay24 (TRUE);
	Delay (2L);
	Clean_Up (NULL,0);
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
	Clean_Up ("Aborted\n",0);
}

void Remove_Latch (void)
{
	if (OpenScreen24(CONTROLONLY24)!=NULL)
		{ Delay (2L);
		  CloseScreen24();
		}
}


void Clean_Up (char *String,int RetCode)
{

	if (OpalBase!=NULL)
		{ CloseScreen24 ();
		  CloseLibrary ((struct Library *)OpalBase);
		}
	if ((String!=NULL) AND (!FromWB))
		puts (String);
	exit (RetCode);
}


BOOL Display_Mode_Check (void)
{
   struct MonitorInfo MonitorInfo;
   DisplayInfoHandle Handle;
   ULONG ModeID;
   LONG Result;

	GfxBase = (struct GfxBase *)OpenLibrary ("graphics.library",36L);
	if (GfxBase==NULL) return (TRUE);
	IntuitionBase = (struct IntuitionBase *)OpenLibrary ("intuition.library",0L);
	if (IntuitionBase==NULL)
		{ CloseLibrary ((struct Library *)GfxBase);
		  return (TRUE);
		}
	ModeID = GetVPModeID (&IntuitionBase->FirstScreen->ViewPort);
	Handle = FindDisplayInfo (ModeID);
	Result = GetDisplayInfoData (Handle,(UBYTE *)&MonitorInfo,
			sizeof (struct MonitorInfo),DTAG_MNTR,NULL);

	/*  If line frequency if >15Khz, a backdrop
	 * cannot be displayed.
	 */

	if (MonitorInfo.TotalColorClocks<220)
		{ CloseLibrary ((struct Library *)GfxBase);
		  CloseLibrary ((struct Library *)IntuitionBase);
		  return (FALSE);
		}
	CloseLibrary ((struct Library *)GfxBase);
	CloseLibrary ((struct Library *)IntuitionBase);
	return (TRUE);
}

