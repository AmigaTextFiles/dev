// This source is freely distributable
// mark@topic.demon.co.uk

/* All the Amiga stuff	*/

#define INTUI_V36_NAMES_ONLY
#define INTUITION_IOBSOLETE_H
#define ASL_V38_NAMES_ONLY
#define __USE_SYSBASE 1

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/asl.h>
#include <proto/amigaguide.h>
#include <proto/locale.h>
extern struct Library *AmigaGuideBase = NULL;
extern struct Library *LocaleBase = NULL;
#include <proto/icon.h>
#include <proto/intuition.h>
#include <proto/graphics.h>

#include <intuition/imageclass.h>

#include <exec/memory.h>
#include <dos/dos.h>
#include <dos/rdargs.h>
#include <libraries/gadtools.h>

#include <pragmas/rexxsyslib_pragmas.h>
#include <clib/rexxsyslib_protos.h>

extern struct RxsLib *RexxSysBase = NULL;

/* MPGui					*/
#include <libraries/MPGui.h>
#include <pragmas/MPGui_pragmas.h>
#include <clib/MPGui_protos.h>

extern struct Library *MPGuiBase = NULL;

int sprintf(char *buffer,char *ctl, ...);

#define USE_BUILTIN_MATH
#include <string.h>
#include <stdlib.h>

/* ARexx stuff			*/
#include "a/EditPrefs.h"

#define CATCOMP_BLOCK
#define CATCOMP_NUMBERS
#include "messages.h"

const char Version[]="$VER: EditPrefs 5.4 (26.2.97)";

int MPMorphPrefsOpen( void );
int MPMorphPrefsSaveAs( void );
int MPMorphPrefsQuit( void );
int MPMorphPrefsResetToDefaults( void );
int MPMorphPrefsLastSaved( void );
int MPMorphPrefsRestore( void );
int MPMorphPrefsCreateIcons( void );

typedef int (FPTR(void));

struct MenuCom {
	char *Help;
	FPTR *Function;
} MenuCom[] = {
	"EditPrefs.guide/men",NULL,
	"EditPrefs.guide/men-Project",NULL,
	"EditPrefs.guide/men-P-Open",MPMorphPrefsOpen,
	"EditPrefs.guide/men-P-SaveAs",MPMorphPrefsSaveAs,
	"EditPrefs.guide/men-Project",NULL,
	"EditPrefs.guide/men-P-Quit",MPMorphPrefsQuit,
	"EditPrefs.guide/men-Edit",NULL,
	"EditPrefs.guide/men-E-ResetD",MPMorphPrefsResetToDefaults,
	"EditPrefs.guide/men-E-LastS",MPMorphPrefsLastSaved,
	"EditPrefs.guide/men-E-Restore",MPMorphPrefsRestore,
	"EditPrefs.guide/men-Settings",NULL,
	"EditPrefs.guide/men-S-Icons",MPMorphPrefsCreateIcons
};

struct NewMenu MPMorphPrefsNewMenu[] = {
	NM_TITLE, NULL, NULL, 0, NULL, (APTR)1,
	NM_ITEM, NULL, NULL, 0, 0L, (APTR)2,
	NM_ITEM, NULL, NULL, 0, 0L, (APTR)3,
	NM_ITEM, (STRPTR)NM_BARLABEL, NULL, 0, 0L, (APTR)4,
	NM_ITEM, NULL, NULL, 0, 0L, (APTR)5,
	NM_TITLE, NULL, NULL, 0, NULL, (APTR)6,
	NM_ITEM, NULL, NULL, 0, 0L, (APTR)7,
	NM_ITEM, NULL, NULL, 0, 0L, (APTR)8,
	NM_ITEM, NULL, NULL, 0, 0L, (APTR)9,
	NM_TITLE, NULL, NULL, 0, NULL, (APTR)10,
	NM_ITEM, NULL, NULL, CHECKIT|MENUTOGGLE|CHECKED, 0L, (APTR)11,
	NM_END, NULL, NULL, 0, 0L, NULL };

// Icons from this program
BOOL Icons = TRUE;

// Prototypes
void SaveSettings(char *,char *,char *);
void LoadSettings(char *filename,BOOL open);
BOOL GetAFile(char *name,char *Prompt,ULONG flags,char *positive);
void InitParams(UBYTE *string);
static void Error(const char *message,const char *extra);

AMIGAGUIDECONTEXT 	handle 	= NULL;
struct NewAmigaGuide	nag 		= {NULL};
struct AmigaGuideMsg *agm;			// message from amigaguide

extern long __stack = 16000;

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

#define TEMPLATE "DIR/K/A,SAVEDIR/K/A,FILE/K/A,HELP/K/A,DEFAULT/K/A,GUI/K/A,PORTNAME/K"

#define OPT_DIR			0
#define OPT_SAVEDIR		1
#define OPT_FILE			2
#define OPT_HELP			3
#define OPT_DEFAULT		4
#define OPT_GUI			5
#define OPT_PORTNAME		6

#define OPT_COUNT			7

extern long __oslibversion=39;

struct FileRequester *filereq;
char TempFileName[256];

struct DefaultSettings {
	char Title[64];
	char Name[64];
	char *Value;
	BOOL NoSetDefault;	// Set to TRUE to not update on set to defaults
	char *MValues;			// An MList
};

extern LONG opts[OPT_COUNT] = {0};
extern struct MPGuiHandle *MPGuiHandle = NULL;
struct DefaultSettings *Defaults;
int kount = 0;
char *prefs[60] = {0};

extern struct RexxHost *myhost = NULL;

extern ULONG RexxQuitFlag = 1;

ULONG ASig = 0;

extern struct Catalog *Catalog=NULL;

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

ULONG __saveds __asm MyRexx(register __a0 struct Hook *hook,
								  register __a2 ULONG signal,
								  register __a1 ULONG notused) {
	if (signal & ASig) {
		while (agm = GetAmigaGuideMsg(handle)) {
			ReplyAmigaGuideMsg(agm);
		}
	}
	RexxQuitFlag = 1;
	ARexxDispatch(myhost);
	return RexxQuitFlag;
}

ULONG __saveds __asm MyMenu(register __a0 struct Hook *hook,
								  register __a2 struct IntuiMessage *msg,
								  register __a1 struct Menu *menu) {
	struct MenuItem *n;
	int			(*func)(void);
	int			running=1;
	int			i;

	if (msg->Class == IDCMP_MENUHELP) {
		// recheck the checked menu items
		Icons = ((ItemAddress(menu,FULLMENUNUM(2,0,NOSUB)))->Flags & CHECKED);
		if ((msg->Code == MENUNULL) || (MENUNUM(msg->Code) == NOMENU)) {
			i = 0;
		}
		else {
			if (ITEMNUM(msg->Code) == NOITEM) {
				if (MENUNUM(msg->Code) == 0) {
					i = 1;
				}
				else {
					if (MENUNUM(msg->Code) == 1) {
						i = 6;
					}
					else {
						i = 10;
					}
				}
			}
			else {
				n = ItemAddress(menu, msg->Code);
				i = (int)GTMENUITEM_USERDATA(n);
			}
		}
		Help(NULL,MenuCom[i].Help,NULL);		
		return 1;
	}
	while( msg->Code != MENUNULL ) {
		n = ItemAddress( menu, msg->Code );
		i = (int)GTMENUITEM_USERDATA(n);
		if (func = MenuCom[i].Function) {
			running = (*func)();
		}
		msg->Code = n->NextSelect;
	}
	return (ULONG) running;
}

ULONG __saveds __asm MyRefresh(register __a0 struct Hook *hook,
								  register __a2 struct FileRequester *fr,
								  register __a1 struct IntuiMessage *msg) {
	if (msg->Class == IDCMP_REFRESHWINDOW) {
		RefreshMPGui(MPGuiHandle);
	}
	return 0;
}

static char string[2049];

static struct Hook RefreshHook = {
	0
};

void LoadMenu(int num,UWORD message) {
	char *mes;
	mes = GetMessage(message);
	MPMorphPrefsNewMenu[num].nm_Label = mes+2;
	if (*mes) {
		MPMorphPrefsNewMenu[num].nm_CommKey = mes;
	}
}

int
main(int argc,char **argv) {
	struct RDArgs *rdargs;
	char *res;
	int resx = 0;
	BPTR settings;
	int kount1 = 0;
	int i;
	char *p,*s;
	struct Hook HelpHook = {
		0
	};
	struct Hook MenuHook = {
		0
	};
	struct Hook RexxHook = {
		0
	};
	struct Image *Check=0,*Amiga=0;
	struct DrawInfo *dri;
	struct Screen* Screen;

	if (!(LocaleBase = OpenLibrary("locale.library",38))) {
		Printf("Error Opening locale.library(38)\n");
		return RETURN_FAIL;
	}
	Catalog = OpenCatalog(NULL,
  								"mp/editprefs.catalog",
  								TAG_END);
  	LoadMenu(0,MSG_M_P);
  	LoadMenu(1,MSG_M_PO);
  	LoadMenu(2,MSG_M_PSA);
  	LoadMenu(4,MSG_M_PQ);
  	LoadMenu(5,MSG_M_E);
  	LoadMenu(6,MSG_M_ERD);
  	LoadMenu(7,MSG_M_ELS);
  	LoadMenu(8,MSG_M_ER);
  	LoadMenu(9,MSG_M_S);
  	LoadMenu(10,MSG_M_SCI);
	if (!(rdargs = ReadArgs((char *)TEMPLATE, opts, NULL))) {
		PrintFault(IoErr(),NULL);
		CloseCatalog(Catalog);
		CloseLibrary(LocaleBase);
		return RETURN_ERROR;
	}
	if (RexxSysBase = (struct RxsLib *)OpenLibrary("rexxsyslib.library",0L)) {
		if (opts[OPT_PORTNAME]) {
			myhost = SetupARexxHost((char *)opts[OPT_PORTNAME],NULL);
		}
	}
	AmigaGuideBase = OpenLibrary("amigaguide.library",34);

	if (settings = Open((char *)opts[OPT_DEFAULT],MODE_OLDFILE)) {
		// If we have found a file then count the relevant lines
		while (FGets(settings,string,2048)) {		// read in each line
			if ((string[0] != '\n') &&				// ignore blank lines
				 (string[0] != ';')) {				// and commented out lines
				++kount;									// count the rest
			}
		}
		Close(settings);								// close the file
		if (settings = Open((char *)opts[OPT_DEFAULT],MODE_OLDFILE)) {	// reopen it (why not seek?)
			// Allocate memory for settings from file pointers (including zero at end
			if (Defaults = AllocVec((kount+1) * sizeof(struct DefaultSettings),MEMF_CLEAR)) {
				// Read in all settings
				while (FGets(settings,string,2048) &&
						 (kount1 < kount)) {									// Do not do too many
					// remove newline (from FGets)
					string[strlen(string)-1] = '\0';
					// ignore blank and comment lines
					if (string[0] && (string[0]!=';')) {
						// Clone settings in memory
						p = string;
						if (*p == '+') {
							Defaults[kount1].NoSetDefault = TRUE;
							++p;
						}
						i = 0;
						while (*p && (*p != '=')) {
							Defaults[kount1].Title[i] = *p++;
							i++;
						}
						if (*p) {
							++p;
							i = 0;
							while (*p && (*p != '=')) {
								Defaults[kount1].Name[i] = *p++;
								i++;
							}
						}
						if (*p) {
							++p;
							s = strchr(p,'=');
							if (s) {
								*s = 0;
								Defaults[kount1].Value = strdup(p);
								++s;
								Defaults[kount1].MValues = strdup(s);
								prefs[kount1] = malloc(strlen(s)+2);
								prefs[kount1][0] = 0;
								strcat(prefs[kount1],Defaults[kount1].Value);
							}
							else {
								Defaults[kount1].Value = strdup(p);
								prefs[kount1] = Defaults[kount1].Value;
							}
						}
						++kount1;
					}
				}
			}
			// Close file and change directory back if required
			Close(settings);
			if (Defaults) {
				char buffer[256];
				sprintf(buffer,"%s%s",opts[OPT_DIR],opts[OPT_FILE]);
				LoadSettings(buffer,FALSE);
				// get File requester and open window
				if (filereq = (struct FileRequester *)AllocAslRequest(ASL_FileRequest,NULL)) {
					if (MPGuiBase = OpenLibrary("MPGui.library",5)) {
						if (AmigaGuideBase) {
							nag.nag_BaseName		= "EditPrefs";
							nag.nag_Name			= (char *)opts[OPT_HELP];
							nag.nag_ClientPort	= "EditPrefs_HELP";
							nag.nag_Flags			= HTF_NOACTIVATE;
							nag.nag_PubScreen 	= NULL;
							handle = OpenAmigaGuideAsync(&nag, TAG_END);
							if (handle) {
								ASig = AmigaGuideSignal(handle);
								HelpHook.h_Entry = (HOOKFUNC)Help;
								while (agm = GetAmigaGuideMsg(handle)) {
									ReplyAmigaGuideMsg(agm);
								}
							}
						}
						MenuHook.h_Entry = (HOOKFUNC)MyMenu;
						RexxHook.h_Entry = (HOOKFUNC)MyRexx;
						RefreshHook.h_Entry = (HOOKFUNC)MyRefresh;
						if (Screen = LockPubScreen( NULL )) {
							if (dri = GetScreenDrawInfo(Screen)) {
								Check = (struct Image *)NewObject(NULL,"sysiclass",
										SYSIA_DrawInfo,	dri,
										SYSIA_Which,		MENUCHECK,
										SYSIA_Size,			SYSISIZE_MEDRES,
//										SYSIA_ReferenceFont,	Scr->RastPort.Font,
										IA_Width,			TextLength(&(Screen->RastPort),"M",1)+2,
										IA_Height,			Screen->RastPort.Font->tf_YSize,
										TAG_END);
								Amiga = (struct Image *)NewObject(NULL,"sysiclass",
										SYSIA_DrawInfo,	dri,
										SYSIA_Which,		AMIGAKEY,
										SYSIA_Size,			SYSISIZE_MEDRES,
//										SYSIA_ReferenceFont,	Scr->RastPort.Font,
										IA_Width,			TextLength(&(Screen->RastPort),"M",1)+4,
										IA_Height,			Screen->RastPort.Font->tf_YSize,
										TAG_END);
								FreeScreenDrawInfo(Screen,dri);
							}
							UnlockPubScreen(NULL, Screen);
						}
						if (MPGuiHandle = AllocMPGuiHandle(MPG_RELMOUSE, FALSE,
														MPG_HELP,			handle ? (ULONG)&HelpHook : NULL,
														MPG_NEWLINE,		TRUE,
														MPG_PREFS,			TRUE,
														MPG_MENUS,			MPMorphPrefsNewMenu,
														MPG_MENUHOOK,		(ULONG)&MenuHook,
														MPG_PARAMS,			(ULONG)prefs,
														MPG_SIGNALS,		(myhost ? (1L<<myhost->port->mp_SigBit) : 0)|ASig,
														MPG_SIGNALHOOK,	(ULONG)&RexxHook,
														MPG_CHECKMARK,		Check,
														MPG_AMIGAKEY,		Amiga,
														TAG_END)) {
							res = SyncMPGuiRequest((char *)opts[OPT_GUI],MPGuiHandle);
							if (res == (char *)-1) {
								Error(MPGuiError(MPGuiHandle),NULL);
								resx = RETURN_ERROR;
							}
							else {
								if (res) {
									SaveSettings((char *)opts[OPT_DIR],(char *)opts[OPT_FILE],res);
									if (MPGuiResponse(MPGuiHandle) == MPG_SAVE) {
										SaveSettings((char *)opts[OPT_SAVEDIR],(char *)opts[OPT_FILE],res);
									}
								}
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
						Error(GetMessage(MSG_ERR_GUIL),NULL);
					}
					FreeAslRequest(filereq);
				}
				else {
					Error(GetMessage(MSG_ERR_FILER),NULL);
				}
				FreeVec(Defaults);
			}
			else {
				Error(GetMessage(MSG_ERR_NOMEM),NULL);
			}
		}
		else {
			Error(GetMessage(MSG_ERR_DPREFS),NULL);
		}
	}
	else {
		Error(GetMessage(MSG_ERR_DPREFS),NULL);
	}
	if (myhost) {
		CloseDownARexxHost(myhost);
	}
	if (AmigaGuideBase) {
		CloseLibrary(AmigaGuideBase);
	}
	if (RexxSysBase) {
		CloseLibrary((struct Library *)RexxSysBase);
	}
	FreeArgs(rdargs);
	CloseCatalog(Catalog);
	CloseLibrary(LocaleBase);
	return resx;
}

int
MPMorphPrefsOpen( void ) {
	/* routine when (sub)item "Open..." is selected. */
	LoadSettings(NULL,TRUE);
	return 1;
}

int
MPMorphPrefsSaveAs( void ) {
	/* routine when (sub)item "Save As..." is selected. */
	SaveSettings(NULL,NULL,MPGuiCurrentAttrs(MPGuiHandle));
	return 1;
}

int
MPMorphPrefsQuit( void ) {
	/* routine when (sub)item "Quit" is selected. */
	// nothing
	return 0;
}

int
MPMorphPrefsResetToDefaults( void ) {
	/* routine when (sub)item "Reset To Defaults" is selected. */
	int i;

	for (i=0; i<kount; i++) {
		if (!Defaults[i].NoSetDefault) {
			SetMPGuiGadgetValue(MPGuiHandle,Defaults[i].Title,Defaults[i].Value);
		}
	}
	return 1;
}

int
MPMorphPrefsLastSaved( void ) {
	/* routine when (sub)item "Last Saved" is selected. */
	char buffer[256];
	sprintf(buffer,"%s%s",opts[OPT_SAVEDIR],opts[OPT_FILE]);
	LoadSettings(buffer,TRUE);
	return 1;
}

int
MPMorphPrefsRestore( void ) {
	/* routine when (sub)item "Restore" is selected. */
	char buffer[256];
	sprintf(buffer,"%s%s",opts[OPT_DIR],opts[OPT_FILE]);
	LoadSettings(buffer,TRUE);
	return 1;
}

int
MPMorphPrefsCreateIcons( void ) {
	/* routine when (sub)item "Create Icons?" is selected. */
	Icons = !Icons;
	return 1;
}

// Save settings to a file
void
SaveSettings(char *dir, char *file,char *contents) {
	char buffer[256];
	char buffer1[80];
	struct DiskObject *MyDiskObject;
	BOOL ok = TRUE;
	BPTR settings;

	if (!dir || !file) {
		sprintf(buffer,"%s%s",opts[OPT_DIR],opts[OPT_FILE]);
		ok = GetAFile(buffer,GetMessage(MSG_SAVEP),FRF_DOSAVEMODE,GetMessage(MSG_SAVE));
		if (ok) {
			strcpy(buffer,TempFileName);
		}
	}
	else {
		sprintf(buffer,"%s%s",dir,file);
	}
	if (ok) {
		if (Icons) {
			if (MyDiskObject = GetDiskObject(buffer)) {
				FreeDiskObject(MyDiskObject);
			}
			else {
				sprintf(buffer1,"%s%s",opts[OPT_DIR],"def_prefs");
				if (!(MyDiskObject = GetDiskObject(buffer1))) {
					if (!(MyDiskObject = GetDiskObject("ENV:SYS/def_prefs"))) {
						MyDiskObject = GetDefDiskObject(WBPROJECT);
					}
				}
				if (MyDiskObject) {
					PutDiskObject(buffer,MyDiskObject);
					FreeDiskObject(MyDiskObject);
				}
			}
		}
		if (settings = Open(buffer,MODE_NEWFILE)) {
			Write(settings,contents,strlen(contents));
			Close(settings);
		}
		else {
			Error(GetMessage(MSG_ERR_SAVE),buffer);
		}
	}
}

// Load settings from a file
void
LoadSettings(char *filename,BOOL open) {
	char string[65];
	char *ifilename = NULL;
	BPTR settings;
	int i;
	char *p;

	if (!filename) {
		if (GetAFile((char *)opts[OPT_FILE],GetMessage(MSG_LOADP),0,GetMessage(MSG_LOAD))) {
			ifilename = TempFileName;
		}
	}
	else {
		ifilename = filename;
	}
	if (ifilename) {
		if (settings = Open(ifilename,MODE_OLDFILE)) {
			for (i=0; i<kount; i++) {
				if (Defaults[i].MValues) {
					prefs[i][0] = 0;
				}
			}
			while (FGets(settings,string,64)) {
				string[strlen(string)-1] = '\0';
				// ignore blank and comment lines
				if (string[0] && (string[0]!=';')) {
					p = string;
					while (*p && (*p!='=')) {
						++p;
					}
					if (*p) {
						*p = 0;
						++p;
						// If leading and trailing " then remove
						if (('"' == *p) && ('"' == p[strlen(p)-1])) {
							p[strlen(p)-1] = 0;
							++p;
						}
						for (i=0; i<kount; i++) {
							if (!strcmp(Defaults[i].Name,string)) {
								if (open) {
									SetMPGuiGadgetValue(MPGuiHandle,Defaults[i].Title,p);
								}
								else {
									prefs[i] = strdup(p);
								}
							}
						}
					}
					else {
						for (i=0; i<kount; i++) {
							if (Defaults[i].MValues) {
								if (strstr(Defaults[i].MValues,string)) {
									strcat(prefs[i],string);
									strcat(prefs[i]," ");
								}
							}
						}
					}
				}
			}
			if (open) {
				for (i=0; i<kount; i++) {
					if (Defaults[i].MValues) {
						SetMPGuiGadgetValue(MPGuiHandle,Defaults[i].Title,prefs[i]);
					}
				}
			}
			// Close file and change directory back if required
			Close(settings);
		}
		else {
			Error(GetMessage(MSG_ERR_LOAD),ifilename);
		}
	}
}

/* Shows ASL file requester for a file
 * name	: current file name
 * Prompt: Title
 * flags	: e.g. for save flag
 * Returns: TRUE if file selected, name is TempFileName
 */
BOOL
GetAFile(char *name,char *Prompt,ULONG flags,char *positive) {
	// Split of directory name
	strncpy(TempFileName,name,PathPart(name) - name);
	TempFileName[PathPart(name) - name] = 0;
	// Show requesters
	if (AslRequestTags((APTR) filereq,
							ASLFR_TitleText,(Tag) Prompt,
							ASLFR_Flags1,flags,
							ASLFR_InitialDrawer, (Tag) TempFileName,
							ASLFR_InitialFile,(Tag) FilePart(name),
							ASLFR_PositiveText, positive,
							ASLFR_Window, MPGuiWindow(MPGuiHandle),
							ASLFR_IntuiMsgFunc, &RefreshHook,
							TAG_DONE)) {
		// rejoin name
		strncpy(TempFileName,filereq->fr_Drawer,256);
		AddPart(TempFileName,filereq->fr_File,256);
		return TRUE;
	}
	else {
		return FALSE;
	}
	return TRUE;
}

static void
Error(const char *message,const char *extra) {
	struct EasyStruct es = {
		sizeof(struct EasyStruct),
		0,
		"EditPrefs",
		NULL,
		NULL
	};
	es.es_TextFormat = message;
	es.es_GadgetFormat = GetMessage(MSG_OK);
	EasyRequest(NULL,&es,NULL,extra);
}
