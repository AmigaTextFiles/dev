// MPGui - requester library
// Copyright (C) © 1995 Mark John Paddock

// mark@topic.demon.co.uk
// mpaddock@cix.compulink.co.uk

// This source is freely distributable

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/intuition.h>
#include <proto/amigaguide.h>
#include <proto/locale.h>
extern struct Library *AmigaGuideBase = NULL;
extern struct Library *LocaleBase = NULL;

#include <dos/dos.h>

#include <libraries/MPGui.h>
#include <pragmas/MPGui_pragmas.h>
#include <clib/MPGui_protos.h>
#include <dos.h>
#include <string.h>
#include <dos/rdargs.h>
#include <dos/dostags.h>

#define TEMPLATE "FROM/A,TO/K,RELMOUSE/S,PUBSCREEN/K,HELP/K,CHELP/S,NEWLINE/S,PREFS/S,BUTTONS/K,NOBUTTONS/S,PARAMS/K/M"

#define OPT_FILE			0
#define OPT_TO				1
#define OPT_MOUSE			2
#define OPT_SCREEN		3
#define OPT_HELP			4
#define OPT_CHELP			5
#define OPT_NEWLINE		6
#define OPT_PREFS			7
#define OPT_BUTTONS		8
#define OPT_NOBUTTONS	9
#define OPT_PARAMS		10

#define OPT_COUNT			11

extern long __oslibversion=39;

struct Library *MPGuiBase;

const char Version[]="$VER: RunMPGui 5.4 (26.2.97)";

AMIGAGUIDECONTEXT 	handle 	= NULL;
struct NewAmigaGuide	nag 		= {NULL};
struct AmigaGuideMsg *agm;			// message from amigaguide
ULONG ASig = 0;

int sprintf(char *buffer,char *ctl, ...);

extern long __stack = 16000;

extern char *ButtonExe=NULL;

static char ButtonExe1[256];

struct Hook SigHook = {
	0
};
extern struct Catalog *Catalog=NULL;

#define CATCOMP_BLOCK
#define CATCOMP_NUMBERS
#include "Rmessages.h"

ULONG __saveds __asm MyButtons(register __a0 struct Hook *hook,
										register __a2 struct MPGuiHandle *gh,
										register __a1 ULONG ButtonNo) {
	LONG error;
	sprintf(ButtonExe1,ButtonExe,gh,ButtonNo);
	error = SystemTags(ButtonExe1,
						SYS_Input,	NULL,
						SYS_Output,	NULL,
						NP_Name,		"RunMPGui SubTask",
						TAG_END);
	if (-1 == error) {
		return 0;
	}
	if (error) {
		return 0;
	}
	return 1;
}

ULONG __saveds __asm MySig(register __a0 struct Hook *hook,
								  register __a2 ULONG signal,
								  register __a1 ULONG notused) {
	while (agm = GetAmigaGuideMsg(handle)) {
		ReplyAmigaGuideMsg(agm);
	}
	return 1;
}

ULONG __saveds __asm Help(register __a0 struct Hook *hook,
								  register __a2 char *name,
								  register __a1 APTR notused) {
	char buffer[256];
	while (agm = GetAmigaGuideMsg(handle)) {
		ReplyAmigaGuideMsg(agm);
	}
	sprintf(buffer,"LINK %s",name);
	SendAmigaGuideCmdA(handle,buffer,NULL);
	while (agm = GetAmigaGuideMsg(handle)) {
		ReplyAmigaGuideMsg(agm);
	}
	return 1;
}

char
*GetMessage(UWORD message) {
	LONG   *l;
	UWORD  *w;
	STRPTR  builtIn;

   l = (LONG *)CatCompBlock;

	while (*l != message)  {
		w = (UWORD *)((ULONG)l + 4);
		l = (LONG *)((ULONG)l + (ULONG)*w + 6);
	}
	builtIn = (STRPTR)((ULONG)l + 6);
	return(GetCatalogStr(Catalog,message,builtIn));
}

/****** MPGui.library/--RunMPGui-- ******************************************
*
* RunMPGui provides a simple Shell interface to MPGui.library
*
* Parameters are:
*
* FROM/A       Input GUI file
* TO/K         Output file
* RELMOUSE/S   Open reqester by the pointer
* PUBSCREEN/K  Specify the public screen to open on
* HELP/K       AmigaGuide file to show help
* CHELP/S      Show help continuously
* NEWLINE/S    Put a new line between each gadget
* PREFS/S      Show Save/Use/Cancel gadgets rather than OK/Cancel
* BUTTONS/K    Command to run when a button is pressed
* NOBUTTONS/S  Do not show OK/Cancel gadgets
* PARAMS/K/M   Parameters to substitute in GUI file
*
* The BUTTON command should be specified as "command %ld %ld"
*
* The command is then passed two numbers - the address of the handle and
* the number of the button.
*
* Return a failure from this command to Cancel the GUI.
*
* The response from MPGui is:
*
*   0 if OK is pressed;
*   5 if Cancel is pressed;
*  10 if there is an error in the GUI file;
*  20 if there is some fatal error.
*
* Version 5 - Refreshes windows when a requester is open
*             Tries amigaguide.library version 34
* Version 5.2 - Localised.
* Version 5.3 - non beta
* Version 5.4 - Opens locale.library(38) to work on OS3.0.
*
*****************************************************************************
*
*/

int
main(int argc,char **argv) {
	struct MPGuiHandle *MPGuiHandle;
	char *res;
	BOOL FromWB = FALSE;
	struct RDArgs *rdargs = NULL;
	long opts[OPT_COUNT] = {
		0
	};
	int resx = RETURN_OK;
	struct EasyStruct es = {
		sizeof(struct EasyStruct),
		0,
		"RunMPGui",
		NULL,
		NULL
	};
	BPTR fh;
	struct Hook HelpHook = {
		0
	};
	struct Hook ButtonHook = {
		0
	};

	if (!(LocaleBase = OpenLibrary("locale.library",38))) {
		if (FromWB) {
			es.es_TextFormat = "Error Opening locale.library(38)";
			EasyRequestArgs(NULL,&es,NULL,NULL);
		}
		else {
			Printf("Error Opening locale.library(38)");
			Printf((char *)"\n");
		}
		return RETURN_FAIL;
	}
	Catalog = OpenCatalog(NULL,
  								"mp/runmpgui.catalog",
  								TAG_END);
	es.es_GadgetFormat = GetMessage(MSG_OK);
	if (argc == 0) {
		argc = _WBArgc;
		argv = _WBArgv;
		FromWB = TRUE;
		if (argc < 2) {
			es.es_TextFormat = GetMessage(MSG_DOUBLE);
			EasyRequestArgs(NULL,&es,NULL,NULL);
			CloseCatalog(Catalog);
			CloseLibrary(LocaleBase);
			return RETURN_WARN;
		}
	}
	else {
		if (!(rdargs = ReadArgs((char *)TEMPLATE, opts, NULL))) {
			PrintFault(IoErr(), NULL);
			CloseCatalog(Catalog);
			CloseLibrary(LocaleBase);
			return RETURN_ERROR;
		}
	}
	AmigaGuideBase = OpenLibrary("amigaguide.library",34);
	if (MPGuiBase = OpenLibrary("MPGui.library",5)) {
		if (opts[OPT_HELP]) {
			if (AmigaGuideBase) {
				nag.nag_BaseName		= "RunMPGui";
				nag.nag_Name			= (char *)opts[OPT_HELP];
				nag.nag_ClientPort	= "RunMPGui_HELP";
				nag.nag_Flags			= HTF_NOACTIVATE;
				nag.nag_PubScreen 	= (char *)opts[OPT_SCREEN];
				handle = OpenAmigaGuideAsync(&nag, TAG_END);
			}
		}
		if (handle) {
			ASig = AmigaGuideSignal(handle);
			HelpHook.h_Entry = (HOOKFUNC)Help;
			while (agm = GetAmigaGuideMsg(handle)) {
				ReplyAmigaGuideMsg(agm);
			}
		}
		ButtonHook.h_Entry = (HOOKFUNC)MyButtons;
		ButtonExe = (char *)opts[OPT_BUTTONS];
		SigHook.h_Entry = (HOOKFUNC)MySig;
		if (MPGuiHandle = AllocMPGuiHandle(MPG_RELMOUSE, opts[OPT_MOUSE],
													MPG_PUBSCREENNAME,opts[OPT_SCREEN],
													MPG_HELP,handle ? (ULONG)&HelpHook : NULL,
													MPG_CHELP,opts[OPT_CHELP],
													MPG_NEWLINE,opts[OPT_NEWLINE],
													MPG_PREFS,opts[OPT_PREFS],
													MPG_PARAMS, opts[OPT_PARAMS],
													MPG_SIGNALS,	ASig,
													MPG_SIGNALHOOK,(ULONG)&SigHook,
													MPG_BUTTONHOOK, opts[OPT_BUTTONS] ? (ULONG)&ButtonHook : NULL,
													MPG_NOBUTTONS, opts[OPT_NOBUTTONS] ? TRUE : FALSE,
													TAG_END)) {
			if (FromWB) {
				res = SyncMPGuiRequest(argv[1],MPGuiHandle);
			}
			else {
				res = SyncMPGuiRequest((char *)opts[OPT_FILE],MPGuiHandle);
			}
			if (res == (char *)-1) {
				if (FromWB) {
					es.es_TextFormat = (char *)MPGuiError(MPGuiHandle);
					EasyRequestArgs(NULL,&es,NULL,NULL);
				}
				else {
					Printf(MPGuiError(MPGuiHandle));
				}
				resx = RETURN_ERROR;
			}
			else {
				if (res) {
					if (opts[OPT_TO]) {
						if (fh = Open((char *)opts[OPT_TO],MODE_NEWFILE)) {
							Write(fh,res,strlen(res));
							Close(fh);
						}
						else {
							if (FromWB) {
								es.es_TextFormat = GetMessage(MSG_OUTPUT);
								EasyRequest(NULL,&es,NULL,(char *)opts[OPT_TO]);
							}
							else {
								Printf(GetMessage(MSG_OUTPUT),(char *)opts[OPT_TO]);
								Printf((char *)"\n");
							}
							resx = RETURN_FAIL;
						}
					}
					else {
						if (FromWB) {
							es.es_TextFormat = res;
							EasyRequestArgs(NULL,&es,NULL,NULL);
						}
						else {
							Printf((char *)res);
							Printf((char *)"\n");
						}
					}
				}
				else {
					if (!opts[OPT_TO]) {
						if (FromWB) {
							es.es_TextFormat = GetMessage(MSG_CANCEL);
							EasyRequestArgs(NULL,&es,NULL,NULL);
						}
						else {
							Printf(GetMessage(MSG_CANCEL));
							Printf((char *)"\n");
						}
					}
					resx = RETURN_WARN;
				}
			}
			FreeMPGuiHandle(MPGuiHandle);
		}
		else {
			if (FromWB) {
				es.es_TextFormat = GetMessage(MSG_HANDLE);
				EasyRequestArgs(NULL,&es,NULL,NULL);
			}
			else {
				Printf(GetMessage(MSG_HANDLE));
				Printf((char *)"\n");
			}
		}
		if (handle) {
			while (agm = GetAmigaGuideMsg(handle)) {
				ReplyAmigaGuideMsg(agm);
			}
			CloseAmigaGuide(handle);
		}
		CloseLibrary(MPGuiBase);
	}
	else {
		if (FromWB) {
			es.es_TextFormat = GetMessage(MSG_GUIL);
			EasyRequestArgs(NULL,&es,NULL,NULL);
		}
		else {
			Printf(GetMessage(MSG_GUIL));
			Printf((char *)"\n");
		}
		resx = RETURN_FAIL;
	}
	if (AmigaGuideBase) {
		CloseLibrary(AmigaGuideBase);
	}
	if (rdargs) {
		FreeArgs(rdargs);
	}
	CloseCatalog(Catalog);
	CloseLibrary(LocaleBase);
	return resx;
}
