/* $Revision Header built automatically *************** (do not edit) ************
**
** © Copyright by Dirk Federlein
**
** File             : DFView.c
** Created on       : Tuesday, 13.07.93 02:33:25
** Created by       : Dirk Federlein
** Current revision : V1.12
**
** Auto: smake
**
**
**
** Revision V1.12
** --------------
** created on Tuesday, 03.08.93 14:48:10  by  Dirk Federlein.   LogMessage :
**   - Reduced stack usage by replacing all char ...[*] with
**     static char ...[*]. 
**     Added a static to  all "big" structures (struct GlobalPrefs etc.)
**     as well.
**     This has been done, because DFView
**     would not work correctly, if it was compiled with the
**     "standard" demo.h that defines a stack of 8192 Byte.
**     (Request: Stefan Stuntz)
**
** Revision V1.11
** --------------
** created on Monday, 02.08.93 23:11:25  by  Dirk Federlein.   LogMessage :
**  -*-  changed on Monday, 02.08.93 23:12:59  by  Dirk Federlein.   LogMessage :
**   - Changed the kind of the labeling of the gauge objects.
**     Use MUIA_Weight instead of MUIA_SetMax, because
**     MUIA_SetMax made it impossible to format the text 
**     rightsided.
**  -*-  created on Monday, 02.08.93 23:11:25  by  Dirk Federlein.   LogMessage :
**   - Changed the ..._lv_up() and ..._lv_down() function to use
**     the new MUIM_List_Exchange method.
**
** Revision V1.10
** --------------
** created on Friday, 30.07.93 00:28:32  by  Dirk Federlein.   LogMessage :
**   - Removed a bug in the listview-down and listview-bottom
**     functions. The caused the listview to "generate" a junk
**     line if you hit "down" and the listview _was_ empty.
**     Some minor changes in the locale files
**
** Revision V1.9
** --------------
** created on Thursday, 29.07.93 03:26:30  by  Dirk Federlein.   LogMessage :
**   - Added complete online help. 
**     For this reason I wrote a manual for DFView using
**     TeXInfo. The manual is supplied as TeX (DVI), AmigaGuide
**     and ASCII file.
**
** Revision V1.8
** --------------
** created on Tuesday, 27.07.93 15:04:09  by  Dirk Federlein.   LogMessage :
**  -*-  changed on Wednesday, 28.07.93 15:52:57  by  Dirk Federlein.   LogMessage :
**   - Added a few options to the global prefs window
**     (user adjustable listview format). Notice that it is NOT
**     possible to reformat the cycle gadget
**     AT ONCE. These changes are shown after restart only!
**  -*-  changed on Tuesday, 27.07.93 15:05:10  by  Dirk Federlein.   LogMessage :
**   - Did many changes to compile DFView under MUI V40A
**  -*-  changed on Tuesday, 27.07.93 15:04:27  by  Dirk Federlein.   LogMessage :
**   - Removed bug: Tried to get a cycle value via getmutex() :-(
**  -*-  created on Tuesday, 27.07.93 15:04:09  by  Dirk Federlein.   LogMessage :
**   - Added global prefs window
**
** Revision V1.7
** --------------
** created on Wednesday, 21.07.93 13:59:10  by  Dirk Federlein.   LogMessage :
**  -*-  changed on Wednesday, 21.07.93 14:01:01  by  Dirk Federlein.   LogMessage :
**   - Removed the SingleTask=True flag. Now you can start DFView
**     multiple times - great eh?
**     (Request: Stefan Stuntz)
**  -*-  created on Wednesday, 21.07.93 13:59:10  by  Dirk Federlein.   LogMessage :
**   - Removed a BUG that caused the program to crash as soon as
**     the user changed 1st the "Process"-Cycle-Gadget(Preferences)
**     and second tried to view some files.
**
** Revision V1.6
** --------------
** created on Tuesday, 20.07.93 17:17:59  by  Dirk Federlein.   LogMessage :
**  -*-  changed on Tuesday, 20.07.93 20:52:15  by  Dirk Federlein.   LogMessage :
**   - Changed the locale strings refering to pictures to files.
**     DFView doesn't show only pictures, but anything else as
**     well as long as you have a "viewer" for it.
**  -*-  changed on Tuesday, 20.07.93 20:51:09  by  Dirk Federlein.   LogMessage :
**   - Added support for doubleclicking the listview. If you
**     doubleclick an item now it will be shown at once,
**     no matter if it is selected or not.
**     (Request: Stefan Stuntz)
**  -*-  changed on Tuesday, 20.07.93 20:50:16  by  Dirk Federlein.   LogMessage :
**   - Renamed the file from dfv to dfview according to the
**     application name
**     (Request: Stefan Stuntz)
**  -*-  changed on Tuesday, 20.07.93 17:19:09  by  Dirk Federlein.   LogMessage :
**   - Implemented repeat "feature" for <UP> and <DOWN> buttons
**  -*-  created on Tuesday, 20.07.93 17:17:59  by  Dirk Federlein.   LogMessage :
**   - Implemented a better program/pathname determination
**
** Revision V1.5
** --------------
** created on Monday, 19.07.93 02:46:58  by  Dirk Federlein.   LogMessage :
**   - Added Locale support
**
** Revision V1.4
** --------------
** created on Monday, 19.07.93 02:44:40  by  Dirk Federlein.   LogMessage :
**   - Added support for a nicer AppIcon to get rid of the
**     DEFAULT AppIcon.
**     Changed MX gadget to Cycle gadget.
**
** Revision V1.3
** --------------
** created on Sunday, 18.07.93 23:54:47  by  Dirk Federlein.   LogMessage :
**   - Did some changes according to Stefans wishes
**     (No C++ comments, smaller main window)
**
** Revision V1.2
** --------------
** created on Sunday, 18.07.93 13:24:05  by  Dirk Federlein.   LogMessage :
**   - Adaped source according to the changes that came with
**     Version 37A of MUI.
**
** Revision V1.1
** --------------
** created on Saturday, 17.07.93 01:29:51  by  Dirk Federlein.   LogMessage :
**   - Used a MX gadget instead of a Cycle gadget, because of some
**     bugs within the cycle gadget class (35A)
**
**
** Purpose
** -------
**   - DFV - The MUI based picture viewer
**
** Revision V1.0
** --------------
** created on Tuesday, 13.07.93 02:33:25  by  Dirk Federlein.   LogMessage :
**     --- Initial release ---
**
*********************************************************************************/
#define REVISION "1.12"
#define REVDATE  "03.08.93"
#define REVTIME  "14:48:10"
#define AUTHOR   "Dirk Federlein"
#define VERNUM   1
#define REVNUM   12

/* --- Includes --------------------------------------------------------- */

#include "demo.h"

#include <libraries/asl.h>

#define MAXNAMELEN		256
#define MAXCLILEN		480
#define CMDBUFFER		(MAXCLILEN*2)	/* Just for savety! */

#include <exec/memory.h>
#include <workbench/workbench.h>
#include <clib/icon_protos.h>
#include <clib/utility_protos.h>
#include <dos/dos.h>
#include <dos/dostags.h>
#include <libraries/locale.h>
#include <clib/locale_protos.h>

#include "dfview_protos.h"

#define CATCOMP_NUMBERS
#define CATCOMP_BLOCK

#include "dfview_locale.h"

/* ---------------------------------------------------------------------- */
/* --- FileList formats ------------------------------------------------- */
/* ---------------------------------------------------------------------- */

/* --- Filename only ---------------------------------------------------- */
#define FILELIST_FMT1	"COL=1 DELTA=8"

/* --- Filepath and filename -------------------------------------------- */
#define FILELIST_FMT2	"COL=0 DELTA=8,COL=1 DELTA=8"

/* --- Filename and filesize -------------------------------------------- */
#define FILELIST_FMT3	"COL=1 DELTA=8,COL=2 DELTA=8 P=\33r"

/* --- Filepath, filename and filesize ---------------------------------- */
#define FILELIST_FMT4	"COL=0 DELTA=8,COL=1 DELTA=8,COL=2 DELTA=8 P=\33r"

/* ---------------------------------------------------------------------- */
/* --- Online Help File ------------------------------------------------- */
/* ---------------------------------------------------------------------- */

#define GUIDEFILE			"DFView.guide"

/* ---------------------------------------------------------------------- */
/* --- Online Help Nodes ------------------------------------------------ */
/* ---------------------------------------------------------------------- */

#define NODE_MAIN_TOP			"MainWindow"
#define NODE_MAIN_FILES			"Files"
#define NODE_MAIN_FILELIST		"File list"
#define NODE_MAIN_QUICKCHANGE	"Quick change"
#define NODE_MAIN_SELECTED		"Selected"
#define NODE_MAIN_UNSELECTED	"Unselected"
#define NODE_MAIN_PROCESSQUIT	"Process and Quit"

#define NODE_PREFS_TOP			"FilePrefs"
#define NODE_PREFS_COMMAND		"Command"
#define NODE_PREFS_PARAMS		"Parameter"
#define NODE_PREFS_PARAMSFIRST	"Params first"
#define NODE_PREFS_AUTODESELECT	"Auto deselect"
#define NODE_PREFS_PROCESS		"ProcessKind"
#define NODE_PREFS_OKCANCEL		"Ok and Cancel"

#define NODE_GPREFS_TOP			"DFView Preferences"
#define NODE_GPREFS_FILELISTS	"File lists"
#define NODE_GPREFS_AUTOLOAD	"Auto load"
#define NODE_GPREFS_CLEAR		"ClearALoad"
#define NODE_GPREFS_SHOWPATH	"Show path"
#define NODE_GPREFS_SHOWSIZE	"Show size"

/* ---------------------------------------------------------------------- */
/* --- Support Functions ------------------------------------------------ */
/* ---------------------------------------------------------------------- */

char *GetStr(APTR obj)
{
	char *str;

	if (!get(obj,MUIA_String_Contents,&str))
		get(obj,MUIA_Text_Contents,&str);

	return(str);
}

BOOL GetBool(APTR obj)
{
	LONG x;
	get(obj,MUIA_Selected,&x);
	return((BOOL)x);
}

LONG GetRadio(APTR obj)
{
	LONG x;
	get(obj,MUIA_Radio_Active,&x);
	return((LONG)x);
}

LONG GetCycle(APTR obj)
{
	LONG x;
	get(obj,MUIA_Cycle_Active,&x);
	return((LONG)x);
}

/* ---------------------------------------------------------------------- */
/* --- Ids -------------------------------------------------------------- */
/* ---------------------------------------------------------------------- */

static enum ids
{
	ID_DUMMY,
	ID_MAIN_PICS,
	ID_MAIN_PICVIEW,
	ID_MAIN_ABOUT,
	ID_MAIN_PREFS,
	ID_MAIN_ADD,
	ID_MAIN_REMOVE,
	ID_MAIN_REMSEL,
	ID_MAIN_SELALL,
	ID_MAIN_SELSHIFT,
	ID_MAIN_SELPAT,
	ID_MAIN_SELNONE,
	ID_MAIN_SORT,
	ID_MAIN_TOP,
	ID_MAIN_UP,
	ID_MAIN_DOWN,
	ID_MAIN_BOTTOM,
	ID_MAIN_CLEAR,
	ID_MAIN_SAVE,
	ID_MAIN_LOAD,
	ID_MAIN_FILEPREFS,
	ID_MAIN_QUICK,
	ID_MAIN_SELECTED,
	ID_MAIN_UNSELECTED,
	ID_MAIN_SHOW,
	ID_MAIN_QUIT,
	/* --- Global Preferences ------------------------------------------- */
	ID_GLOBALPREFS_FILES,
	ID_GLOBALPREFS_ADD,
	ID_GLOBALPREFS_REMOVE,
	ID_GLOBALPREFS_REMSEL,
	ID_GLOBALPREFS_SORT,
	ID_GLOBALPREFS_TOP,
	ID_GLOBALPREFS_UP,
	ID_GLOBALPREFS_DOWN,
	ID_GLOBALPREFS_BOTTOM,
	ID_GLOBALPREFS_AUTOLOAD,
	ID_GLOBALPREFS_CLEAR,
	ID_GLOBALPREFS_SHOWPATH,
	ID_GLOBALPREFS_SHOWSIZE,
	ID_GLOBALPREFS_SAVE,
	ID_GLOBALPREFS_LOAD,
	ID_GLOBALPREFS_USE,
	ID_GLOBALPREFS_CANCEL,
	/* --- String requester --------------------------------------------- */
	ID_SREQ_STRING,
	ID_SREQ_OK,
	ID_SREQ_CANCEL,
	/* --- Prefs Window ------------------------------------------------- */
	ID_FILEPREFS_CMD,
	ID_FILEPREFS_GETCMD,
	ID_FILEPREFS_PARAMS,
	ID_FILEPREFS_AUTO,
	ID_FILEPREFS_POS,
	ID_FILEPREFS_KIND,
	ID_FILEPREFS_OK,
	ID_FILEPREFS_CANCEL
};

/* ---------------------------------------------------------------------- */
/* --- Handles for the objects ------------------------------------------ */
/* ---------------------------------------------------------------------- */

/* --- Application ------------------------------------------------------ */

Object * APH_DFV;

/* --- Windows ---------------------------------------------------------- */

Object * WIH_MAIN;
Object * WIH_SREQ;
Object * WIH_PREFS;
Object * WIH_GLOBALPREFS;

/* --- Main Window ------------------------------------------------------ */

Object * MAIN_LVH_PICS;
Object * MAIN_LIH_PICS;

Object * MAIN_BTH_ADD;
Object * MAIN_BTH_REMOVE;
Object * MAIN_BTH_REMSEL;
Object * MAIN_BTH_SORT;
Object * MAIN_BTH_SELALL;
Object * MAIN_BTH_SELSHIFT;
Object * MAIN_BTH_SELPAT;
Object * MAIN_BTH_SELNONE;
Object * MAIN_BTH_TOP;
Object * MAIN_BTH_UP;
Object * MAIN_BTH_DOWN;
Object * MAIN_BTH_BOTTOM;

Object * MAIN_BTH_CLEAR;
Object * MAIN_BTH_SAVE;
Object * MAIN_BTH_LOAD;
Object * MAIN_BTH_PREFS;
Object * MAIN_CYH_QUICK;
Object * MAIN_GAH_SELECTED;
Object * MAIN_GAH_UNSELECTED;

Object * MAIN_BTH_SHOW;
Object * MAIN_BTH_QUIT;

/* --- Global Preferences ----------------------------------------------- */

Object * GLOBALPREFS_LVH_FILES;
Object * GLOBALPREFS_BTH_ADD;
Object * GLOBALPREFS_BTH_REMOVE;
Object * GLOBALPREFS_BTH_REMSEL;
Object * GLOBALPREFS_BTH_SORT;
Object * GLOBALPREFS_BTH_TOP;
Object * GLOBALPREFS_BTH_UP;
Object * GLOBALPREFS_BTH_DOWN;
Object * GLOBALPREFS_BTH_BOTTOM;
Object * GLOBALPREFS_TXH_AUTOLOAD;
Object * GLOBALPREFS_BTH_CLEAR;
Object * GLOBALPREFS_CBH_SHOWPATH;
Object * GLOBALPREFS_CBH_SHOWSIZE;
Object * GLOBALPREFS_BTH_SAVE;
Object * GLOBALPREFS_BTH_LOAD;
Object * GLOBALPREFS_BTH_USE;
Object * GLOBALPREFS_BTH_CANCEL;

/* --- String Requester ------------------------------------------------- */

Object * SREQ_STH_STRING;
Object * SREQ_BTH_OK;
Object * SREQ_BTH_CANCEL;

/* --- File Preferences ------------------------------------------------- */

Object * PREFS_STH_CMD;
Object * PREFS_SCH_GETCMD;
Object * PREFS_STH_PARAMS;
Object * PREFS_CBH_POS;
Object * PREFS_CBH_AUTO;
Object * PREFS_CYH_KIND;
Object * PREFS_BTH_OK;
Object * PREFS_BTH_CANCEL;

/* ---------------------------------------------------------------------- */
/* --- Cycle gadgets ---------------------------------------------------- */
/* ---------------------------------------------------------------------- */

static char * CYA_KIND[] =
{
	"",
	"",
	"",
	NULL,
};

static char * CYA_QUICK[22] =
{
	NULL
};

/* ---------------------------------------------------------------------- */
/* --- Picture List Entries --------------------------------------------- */
/* ---------------------------------------------------------------------- */

struct PicData
{
	char			pd_PicPath[256];	/*	Path only */
	char			pd_PicName[64];		/* Filename only */
	char			pd_PicSize[12];		/* Filesize - not used */
	char			pd_PicRes[32];		/* X x Y x Planes - not used */
	char			pd_PicFormat[16];	/* IFF, PCX, GIF - not used */
};

/* ---------------------------------------------------------------------- */
/* --- Picture list preferences ----------------------------------------- */
/* ---------------------------------------------------------------------- */

struct PicPrefs
{
	char			pp_Command[256];
	char			pp_Params[256];
	BOOL			pp_Auto;
	BOOL			pp_Pos;
	LONG			pp_Kind;
} PicPrefs =
{
	"", "", TRUE, TRUE, 0L
};

/* ---------------------------------------------------------------------- */
/* --- File List Entries ------------------------------------------------ */
/* ---------------------------------------------------------------------- */

struct FileData
{
	char			fd_Path[256];
	char			fd_File[64];
};

/* ---------------------------------------------------------------------- */
/* --- Global Prefs ----------------------------------------------------- */
/* ---------------------------------------------------------------------- */

struct GlobalPrefs
{
	struct FileData		gp_Initial;

	struct FileData		gp_QuickChange[20];

	BOOL				gp_ShowPath;
	BOOL				gp_ShowSize;
};

/* ---------------------------------------------------------------------- */
/* --- Global stuff ----------------------------------------------------- */
/* ---------------------------------------------------------------------- */

static char			piclist_dirbuf[256] = { 0,0 };

static char			piclist_filebuf[256] = { 0,0 }; /* only 64 used, but... */

static char			pic_dirbuf[256] = {0,0};

static char			filelist_dirbuf[256] = { 0,0 };

struct Library		* WorkbenchBase	= NULL;

/* ---------------------------------------------------------------------- */
/* --- Locale stuff ----------------------------------------------------- */
/* ---------------------------------------------------------------------- */

struct LocaleInfo		DFVLocaleInfo	= { NULL, NULL };
struct Library			* LocaleBase	= NULL;
APTR					DFVCatalog		= NULL;

STRPTR GetLocaleString( LONG stringNum )
{
	LONG		* l;
	UWORD		* w;
	STRPTR		builtIn;

	l = (LONG *)CatCompBlock;

	while (*l != stringNum)
	{
		w = (UWORD *)((ULONG)l + 4);
		l = (LONG *)((ULONG)l + (ULONG)*w + 6);
	}
	builtIn = (STRPTR)((ULONG)l + 6);

	if (LocaleBase)
		return(GetCatalogStr(DFVCatalog,stringNum,builtIn));

	return(builtIn);
}

/* ---------------------------------------------------------------------- */
/* --- DiskObject support functions ------------------------------------- */
/* ---------------------------------------------------------------------- */

struct DiskObject * dfv_getdiskobject(char * programname)
{
	struct DiskObject		* dobj	= NULL;

	if (WorkbenchBase = OpenLibrary("workbench.library", 36))
	{
		dobj = GetDiskObject(programname) ;

		CloseLibrary(WorkbenchBase);
	}

	return(dobj);
}

void dfv_remdiskobject(struct DiskObject * dobj)
{
	if (dobj)
	{
		if (WorkbenchBase = OpenLibrary("workbench.library", 36))
		{
			FreeDiskObject(dobj);

			CloseLibrary(WorkbenchBase);
		}
	}
}

/* ---------------------------------------------------------------------- */
/* --- Hook functions for the PicData Listview (-> MainWindow) ---------- */
/* ---------------------------------------------------------------------- */

SAVEDS ASM APTR ConstructFunc(REG(a0) struct Hook *hook, REG(a2) APTR mempool, REG(a1) struct PicData * pd)
{
	struct PicData *new;

	if (new=AllocMem(sizeof(struct PicData),MEMF_ANY))
	{
		*new = *pd;
		return(new);
	}
	return(NULL);
}

static struct Hook ConstructHook =
{
	{NULL, NULL},
	(void *)ConstructFunc,
	NULL, NULL
};

SAVEDS ASM VOID DestructFunc(REG(a0) struct Hook *hook, REG(a2) APTR mempool, REG(a1) struct PicData * pd)
{
	FreeMem(pd,sizeof(struct PicData));
}

static struct Hook DestructHook = {
	{NULL, NULL},
	(void *)DestructFunc,
	NULL, NULL
};

SAVEDS ASM LONG CompareFunc(REG(a0) struct Hook *hook, REG(a1) struct PicData * p1,REG(a2) struct PicData * p2)
{
	return(stricmp(p1->pd_PicName,p2->pd_PicName));
}

static struct Hook CompareHook = {
	{NULL, NULL},
	(void *)CompareFunc,
	NULL, NULL
};

SAVEDS ASM LONG DisplayFunc(REG(a0) struct Hook *hook,REG(a2) char **array,REG(a1) struct PicData *pd)
{
	*array++	= pd->pd_PicPath;
	*array++	= pd->pd_PicName;

	/* --- Following fields are not used/filled up to now --------------- */

	*array++	= pd->pd_PicSize;
	*array++	= pd->pd_PicRes;
	*array		= pd->pd_PicFormat;

	return(0);
}

static struct Hook DisplayHook = {
	{NULL, NULL},
	(void *)DisplayFunc,
	NULL, NULL
};

/* ---------------------------------------------------------------------- */
/* --- Hooks for the File List (-> Global Prefs) ------------------------ */
/* ---------------------------------------------------------------------- */

SAVEDS ASM APTR FileConstructFunc
(
	REG(a0) struct Hook		* hook,
	REG(a2) APTR			mempool,
	REG(a1) struct FileData	* fd
)
{
	struct FileData *new;

	if (new=AllocMem(sizeof(struct FileData),MEMF_ANY))
	{
		*new = *fd;
		return(new);
	}

	return(NULL);
}

static struct Hook FileConstructHook =
{
	{NULL, NULL},
	(void *)FileConstructFunc,
	NULL, NULL
};

SAVEDS ASM VOID FileDestructFunc
(
	REG(a0) struct Hook		* hook,
	REG(a2) APTR 			mempool,
	REG(a1) struct FileData	* fd
)
{
	FreeMem(fd,sizeof(struct FileData));
}

static struct Hook FileDestructHook = {
	{NULL, NULL},
	(void *)FileDestructFunc,
	NULL, NULL
};

SAVEDS ASM LONG FileCompareFunc
(
	REG(a0) struct Hook		* hook,
	REG(a1) struct FileData	* f1,
	REG(a2) struct FileData	* f2
)
{
	return(stricmp(f1->fd_File,f2->fd_File));
}

static struct Hook FileCompareHook = {
	{NULL, NULL},
	(void *)FileCompareFunc,
	NULL, NULL
};

SAVEDS ASM LONG FileDisplayFunc
(
	REG(a0) struct Hook		* hook,
	REG(a2) char			** array,
	REG(a1) struct FileData	* fd
)
{
	*array++	= fd->fd_Path;
	*array		= fd->fd_File;

	return(0);
}

static struct Hook FileDisplayHook = {
	{NULL, NULL},
	(void *)FileDisplayFunc,
	NULL, NULL
};

/* ---------------------------------------------------------------------- */

LONG dfv_load_piclist(char * filename)
{
	char					* rbuf;
	static char				piclist[256];
	static char				linebuf[256];

	LONG					err		= 0L;

	FILE					* fh	= NULL;

	struct FileRequester	* frq;

	static struct PicData			pd;
	struct PicData			* pdp;

	struct TagItem frqtags[] =
	{
		ASL_Hail,		0L,
		ASL_OKText,		0L,
		ASL_CancelText, 0L,
		ASL_File,		0L,
		ASL_Dir,        0L,
		ASLFR_Window,	0L,
		TAG_DONE
	};

	frqtags[0].ti_Data	= (long)GetLocaleString(MSG_LOADPICLIST_WINDOWTITLE);
	frqtags[1].ti_Data	= (long)GetLocaleString(MSG_LOADPICLIST_LOAD);
	frqtags[2].ti_Data	= (long)GetLocaleString(MSG_LOADPICLIST_CANCEL);
	frqtags[3].ti_Data	= (long)piclist_filebuf;
	frqtags[4].ti_Data	= (long)piclist_dirbuf;

	if (filename != NULL)
	{
		/* --- Hold listview quiet until all entries are loaded --------- */

		set(MAIN_LVH_PICS, MUIA_List_Quiet, TRUE);

		if (fh = fopen (filename, "r"))
		{
			fgets(linebuf, 256, fh);
			stccpy(PicPrefs.pp_Command, linebuf, strlen(linebuf));

			fgets(linebuf, 256, fh);
			stccpy(PicPrefs.pp_Params, linebuf, strlen(linebuf));

			fgets(linebuf, 256, fh);
			PicPrefs.pp_Kind	= atoi(linebuf);
			fgets(linebuf, 256, fh);
			PicPrefs.pp_Pos	= atoi(linebuf);
			fgets(linebuf, 256, fh);
			PicPrefs.pp_Auto	= atoi(linebuf);

			do
			{
				fgets(linebuf, 256, fh);
				stccpy(pd.pd_PicPath, linebuf, strlen(linebuf));

				fgets(linebuf, 64, fh);
				stccpy(pd.pd_PicName, linebuf, strlen(linebuf));

				fgets(linebuf, 12, fh);
				stccpy(pd.pd_PicSize, linebuf, strlen(linebuf));

				fgets(linebuf, 32, fh);
				stccpy(pd.pd_PicRes, linebuf, strlen(linebuf));

				rbuf = fgets(linebuf, 16, fh);

				stccpy(pd.pd_PicFormat, linebuf, strlen(linebuf));

				if (rbuf)
				{
					pdp = &pd;

					DoMethod(MAIN_LVH_PICS,
						MUIM_List_Insert, &pdp,1, MUIV_List_Insert_Bottom);
				}

			} while(rbuf);

			fclose(fh);

			dfv_adjust_gauges();
		}
		else
			err = 1L;

		/* --- "Wake up" listview --------------------------------------- */

		set(MAIN_LVH_PICS, MUIA_List_Quiet, FALSE);

	}
	else
	{
		if (frq = (struct FileRequester *)
			MUI_AllocAslRequest(ASL_FileRequest, frqtags))
		{
			if (MUI_AslRequest(frq,NULL))
			{
				/* --- Save directory --------------------------------------- */
				stccpy(piclist_dirbuf, frq->fr_Drawer, 256);

				/* --- Save filename ---------------------------------------- */
				stccpy(piclist_filebuf, frq->fr_File, 64);

				stccpy(piclist, frq->fr_Drawer, 256);
				AddPart(piclist, frq->fr_File, 256);

				/* --- Hold listview quiet until all entries ---------------- */
				/* --- are loaded ------------------------------------------- */

				set(MAIN_LVH_PICS, MUIA_List_Quiet, TRUE);

				if (fh = fopen (piclist, "r"))
				{
					fgets(linebuf, 256, fh);
					stccpy(PicPrefs.pp_Command, linebuf, strlen(linebuf));

					fgets(linebuf, 256, fh);
					stccpy(PicPrefs.pp_Params, linebuf, strlen(linebuf));

					fgets(linebuf, 256, fh);
					PicPrefs.pp_Kind	= atoi(linebuf);
					fgets(linebuf, 256, fh);
					PicPrefs.pp_Pos	= atoi(linebuf);
					fgets(linebuf, 256, fh);
					PicPrefs.pp_Auto	= atoi(linebuf);

					do
					{
						fgets(linebuf, 256, fh);
						stccpy(pd.pd_PicPath, linebuf, strlen(linebuf));

						fgets(linebuf, 64, fh);
						stccpy(pd.pd_PicName, linebuf, strlen(linebuf));

						fgets(linebuf, 12, fh);
						stccpy(pd.pd_PicSize, linebuf, strlen(linebuf));

						fgets(linebuf, 32, fh);
						stccpy(pd.pd_PicRes, linebuf, strlen(linebuf));

						rbuf = fgets(linebuf, 16, fh);

						stccpy(pd.pd_PicFormat, linebuf, strlen(linebuf));

						if (rbuf)
						{
							pdp = &pd;
							DoMethod(MAIN_LVH_PICS,
								MUIM_List_Insert, &pdp,1, MUIV_List_Insert_Bottom);
						}

					} while(rbuf);

					fclose(fh);

					dfv_adjust_gauges();

				}

				/* --- "Wake up" listview ------------------------------- */

				set(MAIN_LVH_PICS, MUIA_List_Quiet, FALSE);

			}
			else
				err = 1L;

			MUI_FreeAslRequest(frq);

		}
	}

	return(0L);
}

void dfv_clear_piclist(void)
{
	DoMethod(MAIN_LVH_PICS, MUIM_List_Clear);

	dfv_adjust_gauges();
}

LONG dfv_save_piclist(void)
{
	static char				piclist[256];
	LONG					err		= 0L;

	LONG					end, i;

	FILE					* fh	= NULL;

	struct FileRequester	* frq;

	struct PicData			* pdp;

	struct TagItem frqtags[] =
	{
		ASL_Hail,		0L,
		ASL_OKText,		0L,
		ASL_CancelText, 0L,
		ASL_File,		0L,
		ASL_Dir,        0L,
		ASLFR_Window,	0L,
		TAG_DONE
	};

	frqtags[0].ti_Data	= (long)GetLocaleString(MSG_SAVEPICLIST_WINDOWTITLE);
	frqtags[1].ti_Data	= (long)GetLocaleString(MSG_SAVEPICLIST_SAVE);
	frqtags[2].ti_Data	= (long)GetLocaleString(MSG_SAVEPICLIST_CANCEL);
	frqtags[3].ti_Data	= (long)piclist_filebuf;
	frqtags[4].ti_Data	= (long)piclist_dirbuf;

	if (frq = (struct FileRequester *)
		MUI_AllocAslRequest(ASL_FileRequest, frqtags))
	{
		if (MUI_AslRequest(frq,NULL))
		{
			/* --- Save drawer and filename ----------------------------- */
			stccpy(piclist_dirbuf, frq->fr_Drawer, 256);
			stccpy(piclist_filebuf, frq->fr_File, 64);

			stccpy(piclist, frq->fr_Drawer, 256);
			AddPart(piclist, frq->fr_File, 256);

			if (fh = fopen (piclist, "w"))
			{
				fprintf(fh,"%s\n", PicPrefs.pp_Command);
				fprintf(fh,"%s\n", PicPrefs.pp_Params);
				fprintf(fh,"%ld\n", PicPrefs.pp_Kind);
				fprintf(fh,"%ld\n", PicPrefs.pp_Pos);
				fprintf(fh,"%ld\n", PicPrefs.pp_Auto);

				/* --- Get number of all entries ------------------------ */
				get(MAIN_LVH_PICS, MUIA_List_Entries, &end);

				for (i=0; i<end ; i++)
				{
					DoMethod(MAIN_LVH_PICS, MUIM_List_GetEntry, i, &pdp);

					fprintf(fh,"%s\n", pdp->pd_PicPath);
					fprintf(fh,"%s\n", pdp->pd_PicName);
					fprintf(fh,"%s\n", pdp->pd_PicSize);
					fprintf(fh,"%s\n", pdp->pd_PicRes);
					fprintf(fh,"%s\n", pdp->pd_PicFormat);
				}

				fclose(fh);
			}
		}
        else
			err = 1L;

		MUI_FreeAslRequest(frq);

	}

	return(0L);
}

LONG dfv_add_picture(void)
{
	long err		= 0L;

	struct FileRequester	* frq;

	struct TagItem frqtags[] =
	{
		ASL_Hail,		0L,
		ASL_OKText,		0L,
		ASL_CancelText, 0L,
		ASL_File,		0L,
		ASL_Dir,		0L,
		ASL_FuncFlags,	FILF_MULTISELECT,	/* Allow multiselect! */
		TAG_DONE, 0L
	};

	static struct PicData	npd;
	struct PicData			* npd_ptr = NULL;

	frqtags[0].ti_Data	= (long)GetLocaleString(MSG_ADDPIC_WINDOWTITLE);
	frqtags[1].ti_Data	= (long)GetLocaleString(MSG_ADDPIC_SELECT);
	frqtags[2].ti_Data	= (long)GetLocaleString(MSG_ADDPIC_CANCEL);
	frqtags[3].ti_Data	= (long)"";
	frqtags[4].ti_Data	= (long)pic_dirbuf ;

	if (frq = (struct FileRequester *)
		MUI_AllocAslRequest(ASL_FileRequest, frqtags))
	{

		if (MUI_AslRequest(frq,NULL))
		{
			set(MAIN_LVH_PICS, MUIA_List_Quiet, TRUE);

			if (frq->fr_NumArgs)
			{
				/* Multiselection detected */

				long		x;

				for (x=0; x < frq->fr_NumArgs; x++)
				{

					stccpy(npd.pd_PicPath, frq->fr_Drawer, 256);
					stccpy(npd.pd_PicName, frq->fr_ArgList[x].wa_Name, 64);

					/* -------------------------------------------------- */
					/* --- Notice: The three items below SHOULD be ------ */
					/* --- filled with some USEFULL values, but --------- */
					/* --- up to now, I've been too lazy to implement --- */
					/* --- this :-) ------------------------------------- */

					npd.pd_PicSize[0] = 0;
					npd.pd_PicRes[0] = 0;
					npd.pd_PicFormat[0] = 0;

					/* -------------------------------------------------- */

					npd_ptr	= &npd;

					DoMethod(MAIN_LVH_PICS,MUIM_List_Insert,&npd_ptr,1,MUIV_List_Insert_Bottom);

					set(MAIN_LVH_PICS,MUIA_List_Active,MUIV_List_Active_Bottom);

				}

				stccpy(pic_dirbuf, frq->fr_Drawer, 256);

			}
			else
			{
				/* --- "Normal" selection ------------------------------- */

				stccpy(pic_dirbuf, frq->fr_Drawer, 256);

				stccpy(npd.pd_PicPath, frq->fr_Drawer, 256);
				stccpy(npd.pd_PicName, frq->fr_File, 64);

				npd.pd_PicSize[0] = 0;
				npd.pd_PicRes[0] = 0;
				npd.pd_PicFormat[0] = 0;

				npd_ptr	= &npd;

				DoMethod(MAIN_LVH_PICS,MUIM_List_Insert,&npd_ptr,1,MUIV_List_Insert_Bottom);

				set(MAIN_LVH_PICS,MUIA_List_Active,MUIV_List_Active_Bottom);
			}

			set(MAIN_LVH_PICS, MUIA_List_Quiet, FALSE);

			dfv_adjust_gauges();
		}
        else
			err = 1L;

		MUI_FreeAslRequest(frq);

	}

	return(0L);
}

void dfv_rem_picture(void)
{
	DoMethod(MAIN_LVH_PICS, MUIM_List_Remove, MUIV_List_Remove_Active );

	dfv_adjust_gauges();
}

void dfv_remsel_picture(void)
{
	LONG end, i;
	LONG sel;

	/* --- Get number of all entries ------------------------------------ */
	get(MAIN_LVH_PICS, MUIA_List_Entries, &end);

	for (i=end-1; i>=0 ; i--)
	{
		DoMethod(MAIN_LVH_PICS, MUIM_List_Select, i, MUIV_List_Select_Ask, &sel);

		if (sel)
			DoMethod(MAIN_LVH_PICS, MUIM_List_Remove, i );
	}

	dfv_adjust_gauges();
}

void dfv_lv_top(Object * lv, long size)
{
	LONG		pos;

	char		* data;
	char		* tmp;

	if(data = AllocVec(size, MEMF_ANY|MEMF_CLEAR))
	{
		get(lv, MUIA_List_Active, &pos);

		if (pos > 0L)
		{
			DoMethod(lv, MUIM_List_GetEntry, pos, &tmp);

			/* --- Save the data ---------------------------------------- */

			memcpy (data, tmp, size);

			/* --- Remove entry ----------------------------------------- */

			DoMethod(lv, MUIM_List_Remove, pos);

			tmp = data; /* Set pointer */

			DoMethod(lv, MUIM_List_Insert, &tmp, 1, MUIV_List_Insert_Top);

			set(lv, MUIA_List_Active, MUIV_List_Active_Top);
		}

		FreeVec(data);
	}
}

void dfv_lv_up(Object * lv)
{
	LONG		pos;

	get(lv, MUIA_List_Active, &pos);

	if (pos > 0L)
	{
		/* --- Exchange entry 'pos' with entry 'pos-1' ------------------ */
		DoMethod(lv, MUIM_List_Exchange, pos, pos-1);

		/* --- Previous entry becomes the active entry ------------------ */
		set(lv, MUIA_List_Active, pos-1);
	}

}

void dfv_lv_down(Object * lv)
{
	LONG		pos;
	LONG		last;

	get(lv, MUIA_List_Entries, &last);
	get(lv, MUIA_List_Active, &pos);

	/* --- Recalc. "last". Notice the MUIA_List_Entries ----------------- */
	/* --- gives you the number of entries! ----------------------------- */

	last--;

	if((pos < last) && (last > 0L))
	{
		/* --- Exchange entry 'pos' and entry 'pos+1' ------------------- */
		DoMethod(lv, MUIM_List_Exchange, pos, pos+1);

		/* --- Next entry becomes the active one ------------------------ */
		set(lv, MUIA_List_Active, pos+1);
	}
}

void dfv_lv_bottom(Object * lv, long size)
{
	LONG		pos;
	LONG		last;

	char		* data;
	char		* tmp;

	if(data = AllocVec(size, MEMF_ANY|MEMF_CLEAR))
	{
		get(lv, MUIA_List_Entries, &last);
		get(lv, MUIA_List_Active, &pos);

		/* --- Recalc. "last". Notice the MUIA_List_Entries ------------- */
		/* --- gives you the number of entries! ------------------------- */

		last--;

		if ((pos < last) && (last>0L))
		{
			DoMethod(lv, MUIM_List_GetEntry, pos, &tmp);

			/* --- Save the data -------------------------------------------- */

			memcpy (data, tmp, size);

			DoMethod(lv, MUIM_List_Remove, pos); /* remove entry */

			tmp = data; /* Set pointer */

			DoMethod(lv, MUIM_List_Insert, &tmp, 1, MUIV_List_Insert_Bottom);

			set(lv, MUIA_List_Active, MUIV_List_Active_Bottom);
		}

		FreeVec(data);
	}
}

void dfv_lv_sort(Object * lv)
{
	DoMethod(lv, MUIM_List_Sort);
}

void dfv_selall_picture(void)
{
	LONG end, i;
	LONG sel;

	/* --- Get number of all entries ------------------------------------ */
	get(MAIN_LVH_PICS, MUIA_List_Entries, &end);

	for (i=0; i<end ; i++)
		DoMethod(MAIN_LVH_PICS, MUIM_List_Select, i, MUIV_List_Select_On, &sel);

	/*** refresh display ***/
	DoMethod(MAIN_LVH_PICS, MUIM_List_Redraw, MUIV_List_Redraw_All);

	dfv_adjust_gauges();
}

void dfv_selshift_picture(void)
{
	LONG end, i;
	LONG sel;

	/* --- Get number of all entries ------------------------------------ */
	get(MAIN_LVH_PICS, MUIA_List_Entries, &end);

	for (i=0; i<end ; i++)
	{
		DoMethod(MAIN_LVH_PICS, MUIM_List_Select, i, MUIV_List_Select_Ask, &sel);

		DoMethod(MAIN_LVH_PICS, MUIM_List_Select, i,
			sel ? MUIV_List_Select_Off : MUIV_List_Select_On, &sel);
	}

	/* --- Refresh display ---------------------------------------------- */
	DoMethod(MAIN_LVH_PICS, MUIM_List_Redraw, MUIV_List_Redraw_All);

	dfv_adjust_gauges();
}

void dfv_selpat_picture(char * pattern)
{
	LONG			end, i;
	LONG			sel;

	struct PicData	* picdata;

	char			* pattern_token;

	/* --- Alloc mem for pattern_name ----------------------------------- */
	if (pattern_token = AllocVec(256, MEMF_ANY|MEMF_CLEAR))
	{
		/* --- Tokenize pattern ----------------------------------------- */
		ParsePatternNoCase(pattern, pattern_token, 256);

		/* --- Get number of all entries -------------------------------- */
		get(MAIN_LVH_PICS, MUIA_List_Entries, &end);

		for (i=0; i<end ; i++)
		{
			DoMethod(MAIN_LVH_PICS, MUIM_List_GetEntry, i, &picdata);

			/* --- Check if pic_name fits on pattern -------------------- */
			if (MatchPatternNoCase(pattern_token, picdata->pd_PicName))
				DoMethod(MAIN_LVH_PICS, MUIM_List_Select, i, MUIV_List_Select_On, &sel);
		}

		/*** refresh display ***/
		DoMethod(MAIN_LVH_PICS, MUIM_List_Redraw, MUIV_List_Redraw_All);

		FreeVec(pattern_token);
	}

	dfv_adjust_gauges();
}

void dfv_selnone_picture(void)
{
	LONG end, i;
	LONG sel;

	/*** get number of all entries ***/
	get(MAIN_LVH_PICS, MUIA_List_Entries, &end);

	for (i=0; i<end ; i++)
		DoMethod(MAIN_LVH_PICS, MUIM_List_Select, i, MUIV_List_Select_Off, &sel);

	/*** refresh display ***/
	DoMethod(MAIN_LVH_PICS, MUIM_List_Redraw, MUIV_List_Redraw_All);

	dfv_adjust_gauges();
}

void dfv_show_active(void)
{
	char			* command;
	static char		filepath[256];

	struct PicData	* pdp;

	if (command = AllocVec (512, MEMF_ANY|MEMF_CLEAR))
	{

		DoMethod(MAIN_LVH_PICS, MUIM_List_GetEntry, MUIV_List_GetEntry_Active, &pdp);

		stccpy(filepath, pdp->pd_PicPath, 256);
		AddPart(filepath,pdp->pd_PicName, 256);

		if (PicPrefs.pp_Pos)
			sprintf(command, "%s %s %s",
				PicPrefs.pp_Command, PicPrefs.pp_Params, filepath);
		else
			sprintf(command, "%s %s %s",
				PicPrefs.pp_Command, filepath, PicPrefs.pp_Params);

		SystemTags ( command, SYS_Input, NULL,
			SYS_Output, NULL, TAG_DONE);

		FreeVec(command);
	}
}


void dfv_show_picture(void)
{
	BOOL			notdone		= TRUE;
	BOOL			anyselected = FALSE;

	static char		filepath[256];
	char			* command;

	LONG			end, i;
	LONG			sel;

	struct PicData	* pdp;

	/* --- Get number of all entries ------------------------------------ */
	get(MAIN_LVH_PICS, MUIA_List_Entries, &end);

	switch(PicPrefs.pp_Kind)
	{
		case 0:		/* One by one */
			if (command = AllocVec (CMDBUFFER, MEMF_ANY|MEMF_CLEAR))
			{
				for (i=0; i<end ; i++)
				{
					/* --- Entry selected ? ----------------------------------------- */
					DoMethod(MAIN_LVH_PICS, MUIM_List_Select, i, MUIV_List_Select_Ask, &sel);

					if (sel)
					{
						if (PicPrefs.pp_Auto)
						{
							LONG		dummy;

							DoMethod(MAIN_LVH_PICS, MUIM_List_Select, i, MUIV_List_Select_Off, &dummy);

							/*** refresh display ***/
							DoMethod(MAIN_LVH_PICS, MUIM_List_Redraw, i);
						}

						DoMethod(MAIN_LVH_PICS, MUIM_List_GetEntry, i, &pdp);

						stccpy(filepath, pdp->pd_PicPath, 256);
						AddPart(filepath,pdp->pd_PicName, 256);

						if (PicPrefs.pp_Pos)
							sprintf(command, "%s %s %s",
								PicPrefs.pp_Command, PicPrefs.pp_Params, filepath);
						else
							sprintf(command, "%s %s %s",
								PicPrefs.pp_Command, filepath, PicPrefs.pp_Params);

						SystemTags ( command, SYS_Input, NULL,
							SYS_Output, NULL, TAG_DONE);
					}
				}

				FreeVec(command);
			}

			break;

		case 1:		/* All at once */

			if (command = AllocVec (CMDBUFFER, MEMF_ANY|MEMF_CLEAR))
			{
				if (PicPrefs.pp_Pos)
					sprintf(command, "%s %s ",
						PicPrefs.pp_Command, PicPrefs.pp_Params);
				else
					sprintf(command, "%s ",
						PicPrefs.pp_Command);

				for (i=0; i<end ; i++)
				{
					/* --- Entry selected ? ----------------------------------------- */
					DoMethod(MAIN_LVH_PICS, MUIM_List_Select, i, MUIV_List_Select_Ask, &sel);

					if (sel)
					{
						anyselected = TRUE;

						if (PicPrefs.pp_Auto)
						{
							LONG		dummy;

							DoMethod(MAIN_LVH_PICS, MUIM_List_Select, i, MUIV_List_Select_Off, &dummy);

							/* --- Refresh display ---------------------- */
							DoMethod(MAIN_LVH_PICS, MUIM_List_Redraw, i);
						}

						DoMethod(MAIN_LVH_PICS, MUIM_List_GetEntry, i, &pdp);

						stccpy(filepath, pdp->pd_PicPath, 256);
						AddPart(filepath,pdp->pd_PicName, 256);

						if (PicPrefs.pp_Pos == TRUE)
						{
							if (strlen(command)+strlen(filepath)+1 >= MAXCLILEN)
								goto cmdtoolong1;
						}
						else
						{
							if (strlen(command)+strlen(filepath)+1+strlen(PicPrefs.pp_Params)
								>= MAXCLILEN)
								goto cmdtoolong1;
						}

						strcat(command, filepath);
						strcat(command, " ");
					}
				}

cmdtoolong1:

				if (PicPrefs.pp_Pos == FALSE)
				{
					strcat(command, PicPrefs.pp_Params);
				}

				if ( anyselected )
					SystemTags ( command, SYS_Input, NULL,
						SYS_Output, NULL, TAG_DONE);

				FreeVec(command);
			}

			break;

		case 2:		/* All until done */

			if (command = AllocVec (CMDBUFFER, MEMF_ANY|MEMF_CLEAR))
			{
				i = 0;

				while(notdone)
				{
					notdone = FALSE;
					anyselected = FALSE;

					if (PicPrefs.pp_Pos)
						sprintf(command, "%s %s ",
							PicPrefs.pp_Command, PicPrefs.pp_Params);
					else
						sprintf(command, "%s ",
							PicPrefs.pp_Command);

					for (; i<end ; i++)
					{
						/* --- Entry selected ? ----------------------------------------- */
						DoMethod(MAIN_LVH_PICS, MUIM_List_Select, i, MUIV_List_Select_Ask, &sel);

						if (sel)
						{
							anyselected = TRUE;

							if (PicPrefs.pp_Auto)
							{
								LONG		dummy;

								DoMethod(MAIN_LVH_PICS, MUIM_List_Select, i, MUIV_List_Select_Off, &dummy);

								/* --- Refresh display ------------------ */
								DoMethod(MAIN_LVH_PICS, MUIM_List_Redraw, i);
							}

							DoMethod(MAIN_LVH_PICS, MUIM_List_GetEntry, i, &pdp);

							stccpy(filepath, pdp->pd_PicPath, 256);
							AddPart(filepath,pdp->pd_PicName, 256);

							if (PicPrefs.pp_Pos == TRUE)
							{
								if (strlen(command)+strlen(filepath)+1
									>= MAXCLILEN)
								{
									notdone = TRUE;
									goto cmdtoolong;
								}
							}
							else
							{
								if (strlen(command)+strlen(filepath)+1+strlen(PicPrefs.pp_Params)
									>= MAXCLILEN)
								{
									notdone = TRUE;
									goto cmdtoolong;
								}
							}

							strcat(command, filepath);
							strcat(command, " ");
						}
					}

cmdtoolong:

					if (PicPrefs.pp_Pos == FALSE)
					{
						strcat(command, PicPrefs.pp_Params);
					}

					if ( anyselected )
						SystemTags ( command, SYS_Input, NULL,
							SYS_Output, NULL, TAG_DONE);
				}

				FreeVec(command);
			}

			break;

		default:
			break;
	}

	dfv_adjust_gauges();
}

BOOL OpenStringRequester(void)
{
	WIH_SREQ = WindowObject,
		MUIA_Window_ID, MAKE_ID('S','R','E','Q'),
		MUIA_Window_Title, GetLocaleString(MSG_SREQ_WINDOWTITLE),
		MUIA_Window_RefWindow, WIH_MAIN,
		MUIA_Window_Menu, MUIV_Window_Menu_NoMenu,
		WindowContents, VGroup,
			Child, VSpace(2),
			Child, ColGroup(2),
				Child, TextObject,
					MUIA_Text_Contents, GetLocaleString(MSG_SREQ_INPUTPATTERN_GAD),
					MUIA_Text_HiChar, * GetLocaleString(MSG_SREQ_INPUTPATTERN_SC),
					MUIA_Weight,  1,
					StringFrame, MUIA_FramePhantomHoriz, TRUE, End,
				Child, SREQ_STH_STRING = StringObject,
					StringFrame, MUIA_Weight, 100,
					MUIA_String_MaxLen, 64, End,
				End,
			Child, VSpace(4),
			Child, HGroup,
				MUIA_Group_SameSize, TRUE,
				Child, SREQ_BTH_OK = KeyButton(GetLocaleString(MSG_SREQ_OK_GAD), * GetLocaleString(MSG_SREQ_OK_SC)),
				Child, HSpace(0),
				Child, SREQ_BTH_CANCEL = KeyButton(GetLocaleString(MSG_SREQ_CANCEL_GAD),* GetLocaleString(MSG_SREQ_CANCEL_SC)),
				End,
			End,
		End;


	/* --- String request failed ---------------------------------------- */
	if (!WIH_SREQ)
		fail(APH_DFV, GetLocaleString(MSG_ERR_SREQFAILED));

	/* --- Connections & Cycle ------------------------------------------ */

	DoMethod(WIH_SREQ, MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		APH_DFV, 2, MUIM_Application_ReturnID, ID_SREQ_CANCEL);

	DoMethod(SREQ_BTH_OK, MUIM_Notify, MUIA_Pressed, FALSE,
		APH_DFV, 2, MUIM_Application_ReturnID, ID_SREQ_OK);
	DoMethod(SREQ_BTH_CANCEL, MUIM_Notify, MUIA_Pressed, FALSE,
		APH_DFV, 2, MUIM_Application_ReturnID, ID_SREQ_CANCEL);

	/* --- Do the string activation ------------------------------------- */
	/* --- Note: This HAS to be done via the DoMethod(..,MUIM_Notify, ..) */
	/* --- stuff. It can't be done via the MUIA_ControlChar tag. -------- */

	DoMethod(WIH_SREQ, MUIM_Notify,
		MUIA_Window_InputEvent, GetLocaleString(MSG_SREQ_INPUTPATTERN_SC),
		WIH_SREQ, 3, MUIM_Set, MUIA_Window_ActiveObject, SREQ_STH_STRING);

	/* --- Activate ok-button if string is ready ------------------------ */
	DoMethod(SREQ_STH_STRING,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		WIH_SREQ, 3,
		MUIM_Set, MUIA_Window_ActiveObject, SREQ_BTH_OK);

	DoMethod(WIH_SREQ, MUIM_Window_SetCycleChain,
		SREQ_STH_STRING,
		SREQ_BTH_OK,
		SREQ_BTH_CANCEL,
		NULL);

	/* --- Set main window into sleeping state -------------------------- */

	set(WIH_MAIN, MUIA_Window_Sleep, TRUE);

	/* --- Add & open window -------------------------------------------- */

	DoMethod(APH_DFV, OM_ADDMEMBER, WIH_SREQ);
	set(WIH_SREQ, MUIA_Window_Open, TRUE);
	set(WIH_SREQ, MUIA_Window_ActiveObject, SREQ_STH_STRING);

	return(TRUE);
}

void CloseStringRequester(void)
{
	/* --- Close & remove window ---------------------------------------- */

	set(WIH_SREQ, MUIA_Window_Open, FALSE);
	DoMethod(APH_DFV, OM_REMMEMBER, WIH_SREQ);

	/* --- Now really KILL the subwindow -------------------------------- */

	MUI_DisposeObject ( WIH_SREQ );

	/* --- Wake up main window ------------------------------------------ */
	set(WIH_MAIN, MUIA_Window_Sleep, FALSE);
}

LONG dfv_get_command(void)
{
	static char				cmdpath[256];
	long 					err				= 0L;

	struct FileRequester	* frq;

	struct TagItem			frqtags[] =
	{
		ASL_Hail,		0L,
		ASL_OKText,		0L,
		ASL_CancelText, 0L,
		ASL_File,		0L,
		ASL_Dir,        0L,
		ASLFR_Window,	0L,
		TAG_DONE
	};

	frqtags[0].ti_Data	= (long)GetLocaleString(MSG_GETCMD_WINDOWTITLE);
	frqtags[1].ti_Data	= (long)GetLocaleString(MSG_GETCMD_SELECT_GAD);
	frqtags[2].ti_Data	= (long)GetLocaleString(MSG_GETCMD_CANCEL_GAD);
	frqtags[3].ti_Data	= (long)NULL;
	frqtags[4].ti_Data	= (long)NULL;
	frqtags[5].ti_Data	= (long)NULL;

	if (frq = (struct FileRequester *)
		MUI_AllocAslRequest(ASL_FileRequest, frqtags))
	{
		if (MUI_AslRequest(frq,NULL))
		{

			stccpy(cmdpath, frq->fr_Drawer, 256);
			AddPart(cmdpath, frq->fr_File, 256);

			set(PREFS_STH_CMD, MUIA_String_Contents, cmdpath);
		}
        else
			err = 1L;

		MUI_FreeAslRequest(frq);

	}

	return(0L);
}

LONG OpenPrefsWindow(void)
{
	CYA_KIND[0]		= GetLocaleString(MSG_FILEPREFS_CY1_GAD);
	CYA_KIND[1]		= GetLocaleString(MSG_FILEPREFS_CY2_GAD);
	CYA_KIND[2]		= GetLocaleString(MSG_FILEPREFS_CY3_GAD);

	WIH_PREFS = WindowObject,
		MUIA_Window_ID, MAKE_ID('P','R','F','S'),
		MUIA_HelpNode, NODE_PREFS_TOP,
		MUIA_Window_Title, GetLocaleString(MSG_FILEPREFS_WINDOWTITLE),
		MUIA_Window_RefWindow, WIH_MAIN,
		MUIA_Window_Menu, MUIV_Window_Menu_NoMenu,
		WindowContents, VGroup,
			Child, VSpace(2),
			Child, ColGroup(2),
				Child, TextObject,
					MUIA_HelpNode, NODE_PREFS_COMMAND,
					MUIA_Text_PreParse, "\33r",
					MUIA_Text_Contents, GetLocaleString(MSG_FILEPREFS_COMMAND_GAD),
					MUIA_Text_HiChar  ,* GetLocaleString(MSG_FILEPREFS_COMMAND_SC),
					MUIA_Weight,  1,
					StringFrame, MUIA_FramePhantomHoriz, TRUE, End,
				Child, HGroup, GroupSpacing(1),
					MUIA_HelpNode, NODE_PREFS_COMMAND,
					Child, PREFS_STH_CMD = StringObject,
						StringFrame, MUIA_Weight, 100,
						MUIA_InputMode    , MUIV_InputMode_None,
						MUIA_String_MaxLen, 256, End,
					Child, PREFS_SCH_GETCMD = ImageObject,
						MUIA_Image_Spec, MUII_PopFile,
						MUIA_Image_FreeVert, TRUE,
						MUIA_ShowSelState     , TRUE,
						MUIA_Weight, 1,
						MUIA_ControlChar  , ToUpper(* GetLocaleString(MSG_FILEPREFS_COMMAND_SC)),
						MUIA_Frame    , MUIV_Frame_Button,
						MUIA_Background   , MUII_BACKGROUND,
						MUIA_InputMode    , MUIV_InputMode_RelVerify,
						End,
					End,
				Child, TextObject,
					MUIA_HelpNode, NODE_PREFS_PARAMS,
					MUIA_Text_PreParse, "\33r",
					MUIA_Text_Contents, GetLocaleString(MSG_FILEPREFS_PARAMS_GAD),
					MUIA_Text_HiChar  ,*  GetLocaleString(MSG_FILEPREFS_PARAMS_SC),
					MUIA_Weight,  1,
					StringFrame, MUIA_FramePhantomHoriz, TRUE, End,
				Child, PREFS_STH_PARAMS = StringObject,
					MUIA_HelpNode, NODE_PREFS_PARAMS,
					StringFrame, MUIA_Weight, 100,
					MUIA_InputMode    , MUIV_InputMode_None,
					MUIA_String_MaxLen, 256, End,
				End,
			Child, VSpace(2),
			Child, HGroup, MUIA_Group_SameSize, TRUE, GroupFrame,
				Child, VGroup,
					Child, HGroup,
						MUIA_HelpNode, NODE_PREFS_PARAMSFIRST,
						Child, PREFS_CBH_POS = KeyCheckMark(TRUE,*  GetLocaleString(MSG_FILEPREFS_POS_SC)),
						Child, HSpace(1),
						Child, TextObject,
							MUIA_Text_PreParse, "\33l",
							MUIA_Text_Contents, GetLocaleString(MSG_FILEPREFS_POS_GAD),
							MUIA_Text_HiChar  ,* GetLocaleString(MSG_FILEPREFS_POS_SC),
							MUIA_Weight,  1,
							StringFrame, MUIA_FramePhantomHoriz, TRUE, End,
					End,
					Child, HGroup,
						MUIA_HelpNode, NODE_PREFS_AUTODESELECT,
						Child, PREFS_CBH_AUTO = KeyCheckMark(TRUE,*  GetLocaleString(MSG_FILEPREFS_AUTO_SC)),
						Child, HSpace(1),
						Child, TextObject,
							MUIA_Text_PreParse, "\33l",
							MUIA_Text_Contents, GetLocaleString(MSG_FILEPREFS_AUTO_GAD),
							MUIA_Text_HiChar  ,*  GetLocaleString(MSG_FILEPREFS_AUTO_SC),
							MUIA_Weight,  1,
							StringFrame, MUIA_FramePhantomHoriz, TRUE, End,
					End,
				End,
				Child, ColGroup(2),
					MUIA_HelpNode, NODE_PREFS_PROCESS,
					Child, TextObject,
						MUIA_Text_PreParse, "\33r",
						MUIA_Text_Contents, GetLocaleString(MSG_FILEPREFS_PROCESS_GAD),
						MUIA_Weight, 0, MUIA_InnerLeft, 0,
						MUIA_InnerRight, 0,
						MUIA_Text_HiChar,*  GetLocaleString(MSG_FILEPREFS_PROCESS_SC),
						TextFrame, MUIA_FramePhantomHoriz, TRUE,
					End,
					Child, PREFS_CYH_KIND = KeyCycle(CYA_KIND,*  (GetLocaleString(MSG_FILEPREFS_PROCESS_SC))),
				End,
			End,

			Child, VSpace(4),

			Child, HGroup,
				MUIA_HelpNode, NODE_PREFS_OKCANCEL,
				MUIA_Group_SameSize, TRUE,
				Child, PREFS_BTH_OK = KeyButton(GetLocaleString(MSG_FILEPREFS_OK_GAD),* GetLocaleString(MSG_FILEPREFS_OK_SC)),
				Child, HSpace(0),
				Child, HSpace(0),
				Child, HSpace(0),
				Child, PREFS_BTH_CANCEL = KeyButton(GetLocaleString(MSG_FILEPREFS_CANCEL_GAD),* GetLocaleString(MSG_FILEPREFS_CANCEL_SC)),
			End,
		End,
	End;

	/* --- Preferences Window OK ? -------------------------------------- */
	if (!WIH_PREFS)
		fail(APH_DFV, "Creating prefs window failed !");

	/* --- Connections -------------------------------------------------- */

	DoMethod(WIH_PREFS, MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		APH_DFV, 2, MUIM_Application_ReturnID, ID_FILEPREFS_CANCEL);

	DoMethod(PREFS_SCH_GETCMD, MUIM_Notify, MUIA_Pressed, FALSE,
		APH_DFV, 2, MUIM_Application_ReturnID, ID_FILEPREFS_GETCMD);
	DoMethod(PREFS_BTH_OK, MUIM_Notify, MUIA_Pressed, FALSE,
		APH_DFV, 2, MUIM_Application_ReturnID, ID_FILEPREFS_OK);
	DoMethod(PREFS_BTH_CANCEL, MUIM_Notify, MUIA_Pressed, FALSE,
		APH_DFV, 2, MUIM_Application_ReturnID, ID_FILEPREFS_CANCEL);

	/* --- Do the string activation ------------------------------------- */
	/* --- Note: This HAS to be done via the DoMethod(..,MUIM_Notify, ..) */
	/* --- stuff. It can't be done via the MUIA_ControlChar tag. -------- */

	DoMethod(WIH_PREFS, MUIM_Notify,
		MUIA_Window_InputEvent, GetLocaleString(MSG_FILEPREFS_COMMAND_SC),
		WIH_PREFS, 3, MUIM_Set, MUIA_Window_ActiveObject, PREFS_STH_CMD);
	DoMethod(WIH_PREFS, MUIM_Notify,
		MUIA_Window_InputEvent, GetLocaleString(MSG_FILEPREFS_PARAMS_SC),
		WIH_PREFS, 3, MUIM_Set, MUIA_Window_ActiveObject, PREFS_STH_PARAMS);

	/* --- Cycle chain -------------------------------------------------- */

	DoMethod(WIH_PREFS, MUIM_Window_SetCycleChain,
		PREFS_STH_CMD,
		PREFS_SCH_GETCMD,
		PREFS_STH_PARAMS,
		PREFS_CBH_POS,
		PREFS_CBH_AUTO,
		PREFS_CYH_KIND,
		PREFS_BTH_OK,
		PREFS_BTH_CANCEL,
		NULL);

	/* --- Set values --------------------------------------------------- */
	setstring(PREFS_STH_CMD, PicPrefs.pp_Command);
	setstring(PREFS_STH_PARAMS, PicPrefs.pp_Params);

	setcycle(PREFS_CYH_KIND, PicPrefs.pp_Kind);
	setcheckmark(PREFS_CBH_POS, PicPrefs.pp_Pos);
	setcheckmark(PREFS_CBH_AUTO, PicPrefs.pp_Auto);

	/* --- Set main window into sleeping state -------------------------- */

	set(WIH_MAIN, MUIA_Window_Sleep, TRUE);

	/* --- Add & open window -------------------------------------------- */

	DoMethod(APH_DFV, OM_ADDMEMBER, WIH_PREFS);
	set(WIH_PREFS, MUIA_Window_Open, TRUE);

	return(TRUE);
}

void ClosePrefsWindow(void)
{
	/* --- Close & remove window ---------------------------------------- */

	set(WIH_PREFS, MUIA_Window_Open, FALSE);

	DoMethod(APH_DFV, OM_REMMEMBER, WIH_PREFS);

	/* --- Now really KILL the subwindow -------------------------------- */

	MUI_DisposeObject ( WIH_PREFS );

	/* --- Wake up main window ------------------------------------------ */

	set(WIH_MAIN, MUIA_Window_Sleep, FALSE);
}

/* ---------------------------------------------------------------------- */
/* --- Global Prefs support funtions ------------------------------------ */
/* ---------------------------------------------------------------------- */

void dfv_readprefs(struct GlobalPrefs * gp)
{
	static char		linebuf[256]	= { 0,0 } ;

	long			i;

	FILE			* envfile;

	if (envfile = fopen ("ENV:DFView", "r"))
	{
		fgets(linebuf, 256, envfile);

		stccpy(gp->gp_Initial.fd_Path, linebuf, strlen(linebuf));

		fgets(linebuf, 256, envfile);

		stccpy(gp->gp_Initial.fd_File, linebuf, strlen(linebuf));

		fgets(linebuf, 256, envfile);

		gp->gp_ShowPath		= atoi (linebuf);

		fgets(linebuf, 256, envfile);

		gp->gp_ShowSize		= atoi (linebuf);

		/* --- Read the filelists --------------------------------------- */

		i = 0;

		while (fgets(linebuf, 256, envfile) != NULL)
		{
			stccpy(gp->gp_QuickChange[i].fd_Path, linebuf, strlen(linebuf));

			fgets(linebuf, 256, envfile);

			stccpy(gp->gp_QuickChange[i].fd_File, linebuf, strlen(linebuf));

			i++;
		}

		fclose(envfile);
	}
	else
	{
		/* --- Not prefs File - set all to NULL ------------------------- */

		*(gp->gp_Initial.fd_Path)	= 0;
		*(gp->gp_Initial.fd_File)	= 0;

		gp->gp_ShowPath				= FALSE;
		gp->gp_ShowSize				= FALSE;

		for(i=0;i<20;i++)
		{
			*(gp->gp_QuickChange[i].fd_Path)	= 0;
			*(gp->gp_QuickChange[i].fd_File)	= 0;
		}
	}
}

void dfv_saveprefs(struct GlobalPrefs * gp)
{
	long			i;

	FILE			* envfile;

	/* --- Save Prefs to env: ------------------------------------------- */

	if (envfile = fopen ("ENV:DFView", "w"))
	{
		fprintf(envfile, "%s\n", gp->gp_Initial.fd_Path);
		fprintf(envfile, "%s\n", gp->gp_Initial.fd_File);

		fprintf(envfile, "%d\n", gp->gp_ShowPath);
		fprintf(envfile, "%d\n", gp->gp_ShowSize);

		for(i=0; i<20; i++)
		{
			fprintf(envfile, "%s\n", gp->gp_QuickChange[i].fd_Path);
			fprintf(envfile, "%s\n", gp->gp_QuickChange[i].fd_File);
		}

		fclose(envfile);
	}

	/* --- Save Prefs to EnvArc: ---------------------------------------- */

	if (envfile = fopen ("ENVARC:DFView", "w"))
	{
		fprintf(envfile, "%s\n", gp->gp_Initial.fd_Path);
		fprintf(envfile, "%s\n", gp->gp_Initial.fd_File);

		fprintf(envfile, "%d\n", gp->gp_ShowPath);
		fprintf(envfile, "%d\n", gp->gp_ShowSize);

		for(i=0; i<20; i++)
		{
			fprintf(envfile, "%s\n", gp->gp_QuickChange[i].fd_Path);
			fprintf(envfile, "%s\n", gp->gp_QuickChange[i].fd_File);
		}

		fclose(envfile);
	}
}

void dfv_acceptprefs(struct GlobalPrefs * gp)
{
	char		* lvformat	= ",";

	LONG		last;
	LONG		i;

	struct FileData		* fdp;

	/* --- Get Text value ----------------------------------------------- */

	strcpy (gp->gp_Initial.fd_Path, GetStr(GLOBALPREFS_TXH_AUTOLOAD));
	strcpy (gp->gp_Initial.fd_File, FilePart(GetStr(GLOBALPREFS_TXH_AUTOLOAD)));

	/* --- Cut off filename from path ----------------------------------- */

	gp->gp_Initial.fd_Path[strlen(gp->gp_Initial.fd_Path)-strlen(gp->gp_Initial.fd_File)]
		= 0;

	/* --- Get FileListView format CBs ---------------------------------- */

	gp->gp_ShowPath		= GetBool(GLOBALPREFS_CBH_SHOWPATH);
	gp->gp_ShowSize		= GetBool(GLOBALPREFS_CBH_SHOWSIZE);

	/* --- Get number of list entries ----------------------------------- */

	get(GLOBALPREFS_LVH_FILES, MUIA_List_Entries, &last);

	if (last)
	{
		for(i=0; i<last; i++)
		{
			DoMethod(GLOBALPREFS_LVH_FILES, MUIM_List_GetEntry, i, &fdp);

			strcpy(gp->gp_QuickChange[i].fd_Path, fdp->fd_Path);
			strcpy(gp->gp_QuickChange[i].fd_File, fdp->fd_File);
		}

		if (last<20)
		{
			*(gp->gp_QuickChange[last+1].fd_Path) = 0;
			*(gp->gp_QuickChange[last+1].fd_File) = 0;
		}
		else
		{
			*(gp->gp_QuickChange[20].fd_Path) = 0;
			*(gp->gp_QuickChange[20].fd_File) = 0;
		}
	}
	else
	{
		/* --- Listview is empty ---------------------------------------- */
		/* --- Clear all strings ---------------------------------------- */
		for (i=0;i<20;i++)
		{
			*(gp->gp_QuickChange[i].fd_Path)	= 0;
			*(gp->gp_QuickChange[i].fd_File)	= 0;
		}
	}

	/* ------------------------------------------------------------------ */
	/* --- Important: You will NOT see your changes at once, ------------ */
	/* --- but only after you quited your application and restarted it -- */
	/* --- This is, because it is NOT ALLOWED to change the contents ---- */
	/* --- of an existing cycle gadget! Sorry. -------------------------- */
	/* ------------------------------------------------------------------ */

	/* --- Of course, the Listview will be reformatted at once ---------- */

	if(gp->gp_ShowPath)
	{
		if(gp->gp_ShowSize)
		{
			/* --- Filepath, filename and filesize ---------------------- */
			lvformat	= FILELIST_FMT4;
		}
		else
		{
			/* --- Filepath and filename -------------------------------- */
			lvformat	= FILELIST_FMT2;
		}
	}
	else
	{
		if(gp->gp_ShowSize)
		{
			/* --- Filename and filesize -------------------------------- */
			lvformat	= FILELIST_FMT3;
		}
		else
		{
			/* --- Filename only ---------------------------------------- */
			lvformat	= FILELIST_FMT1;
		}
	}

	set(MAIN_LVH_PICS, MUIA_List_Format, lvformat);
}

long dfv_addfileentry(void)
{
	char			filepath[256];

	long 			err		= 0L;

	BPTR			lock;

	struct FileRequester	* frq;

	struct TagItem frqtags[] =
	{
		ASL_Hail,		0L,
		ASL_OKText,		0L,
		ASL_CancelText, 0L,
		ASL_File,		0L,
		ASL_Dir,		0L,
		TAG_DONE, 0L
	};

	struct FileData		fd;
	struct FileData		* fdp;

	frqtags[0].ti_Data	= (long)GetLocaleString(MSG_ADDFILELIST_WINDOWTITLE);
	frqtags[1].ti_Data	= (long)GetLocaleString(MSG_ADDFILELIST_LOAD);
	frqtags[2].ti_Data	= (long)GetLocaleString(MSG_ADDFILELIST_CANCEL);
	frqtags[3].ti_Data	= (long)"";
	frqtags[4].ti_Data	= (long)filelist_dirbuf;

	if (frq = (struct FileRequester *)
		MUI_AllocAslRequest(ASL_FileRequest, frqtags))
	{

		if (MUI_AslRequest(frq,NULL))
		{
			stccpy(filelist_dirbuf, frq->fr_Drawer, 256);

			stccpy(filepath, frq->fr_Drawer, 256);

			AddPart(filepath, frq->fr_File, 256);

			if (lock = Lock(filepath, ACCESS_READ))
			{
				NameFromLock(lock, fd.fd_Path, 256);

				UnLock(lock);

				/* --- Fill in filename --------------------------------- */
				stccpy(fd.fd_File, FilePart(fd.fd_Path), 64);

				/* --- Cut off filename --------------------------------- */

				fd.fd_Path[strlen(fd.fd_Path)-strlen(fd.fd_File)] = 0;

				fdp	= &fd;

				DoMethod(GLOBALPREFS_LVH_FILES,MUIM_List_Insert,&fdp,1,MUIV_List_Insert_Bottom);

				set(GLOBALPREFS_LVH_FILES,MUIM_List_Insert,MUIV_List_Insert_Bottom);
			}
			else
				err = 1L;
		}
        else
			err = 1L;

		MUI_FreeAslRequest(frq);
	}

	return(0L);
}

void dfv_remfileentry(void)
{
	DoMethod(GLOBALPREFS_LVH_FILES, MUIM_List_Remove, MUIV_List_Remove_Active );
}

void dfv_remselfileentries(void)
{
	LONG end, i;
	LONG sel;

	/* --- Get number of all entries ------------------------------------ */
	get(GLOBALPREFS_LVH_FILES, MUIA_List_Entries, &end);

	for (i=end-1; i>=0 ; i--)
	{
		DoMethod(GLOBALPREFS_LVH_FILES, MUIM_List_Select, i, MUIV_List_Select_Ask, &sel);

		if (sel)
			DoMethod(GLOBALPREFS_LVH_FILES, MUIM_List_Remove, i );
	}
}

/* ---------------------------------------------------------------------- */

LONG OpenGlobalPrefs(struct GlobalPrefs * gp)
{
	static char	initialstring[256];

	LONG		i;

	struct FileData		fd;
	struct FileData		* fdp;

	/* --- Generate text for text gadget -------------------------------- */

	strcpy(initialstring, gp->gp_Initial.fd_Path);
	AddPart(initialstring, gp->gp_Initial.fd_File, 256);

	WIH_GLOBALPREFS = WindowObject,
		MUIA_Window_ID, MAKE_ID('G','L','O','B'),
		MUIA_HelpNode, NODE_GPREFS_TOP,
		MUIA_Window_Title, GetLocaleString(MSG_GLOBALPREFS_WINDOWTITLE),
		MUIA_Window_RefWindow, WIH_MAIN,
		MUIA_Window_Menu, MUIV_Window_Menu_NoMenu,
			WindowContents, VGroup,
				Child, VGroup,
					Child, HGroup, MUIA_Group_SameHeight, TRUE,
						Child, VGroup,
							Child, VGroup, GroupSpacing(0),
								GroupFrameT(GetLocaleString(MSG_GLOBALPREFS_FILES_GAD)),
								MUIA_HelpNode, NODE_GPREFS_FILELISTS,
								Child, GLOBALPREFS_LVH_FILES = ListviewObject,
									MUIA_Listview_List, ListObject,
										InputListFrame,
										MUIA_List_Format, "COL=0 DELTA=8, COL=1 DELTA=8",
										MUIA_List_ConstructHook, &FileConstructHook,
										MUIA_List_DestructHook, &FileDestructHook,
										MUIA_List_DisplayHook, &FileDisplayHook,
										MUIA_List_CompareHook, &FileCompareHook,
									End,
								End,
								Child, HGroup, GroupSpacing(0), MUIA_Group_SameSize, TRUE,
									Child, GLOBALPREFS_BTH_ADD		= KeyButton(GetLocaleString(MSG_GLOBALPREFS_ADD_GAD),* GetLocaleString(MSG_GLOBALPREFS_ADD_SC)),
									Child, GLOBALPREFS_BTH_REMOVE	= KeyButton(GetLocaleString(MSG_GLOBALPREFS_REMOVE_GAD),* GetLocaleString(MSG_GLOBALPREFS_REMOVE_SC)),
									Child, GLOBALPREFS_BTH_REMSEL	= KeyButton(GetLocaleString(MSG_GLOBALPREFS_REMSEL_GAD),* GetLocaleString(MSG_GLOBALPREFS_REMSEL_SC)),
									Child, GLOBALPREFS_BTH_SORT		= KeyButton(GetLocaleString(MSG_GLOBALPREFS_SORT_GAD),* GetLocaleString(MSG_GLOBALPREFS_SORT_SC)),
								End,
								Child, HGroup, GroupSpacing(0), MUIA_Group_SameSize, TRUE,
									Child, GLOBALPREFS_BTH_TOP		= KeyButton(GetLocaleString(MSG_GLOBALPREFS_TOP_GAD),* GetLocaleString(MSG_GLOBALPREFS_TOP_SC)),
									Child, GLOBALPREFS_BTH_UP		= KeyButton(GetLocaleString(MSG_GLOBALPREFS_UP_GAD),* GetLocaleString(MSG_GLOBALPREFS_UP_SC)),
									Child, GLOBALPREFS_BTH_DOWN	= KeyButton(GetLocaleString(MSG_GLOBALPREFS_DOWN_GAD),* GetLocaleString(MSG_GLOBALPREFS_DOWN_SC)),
									Child, GLOBALPREFS_BTH_BOTTOM	= KeyButton(GetLocaleString(MSG_GLOBALPREFS_BOTTOM_GAD),* GetLocaleString(MSG_GLOBALPREFS_BOTTOM_SC)),
								End,
							End,
							Child, VGroup, GroupFrame,
								MUIA_HelpNode, NODE_GPREFS_TOP,
								Child, ColGroup(2),
									Child, TextObject,
										MUIA_HelpNode, NODE_GPREFS_AUTOLOAD,
										MUIA_Text_PreParse, "\33r",
										MUIA_Text_Contents, GetLocaleString(MSG_GLOBALPREFS_AUTOLOAD_GAD),
										MUIA_Weight,  1,
										TextFrame, MUIA_FramePhantomHoriz, TRUE, End,
									Child, HGroup,
										Child, GLOBALPREFS_TXH_AUTOLOAD = TextObject,
											MUIA_HelpNode, NODE_GPREFS_AUTOLOAD,
											MUIA_Weight, 100,
											MUIA_Background   , MUII_TextBack,
											TextFrame, MUIA_Weight, 100,
											MUIA_Text_Contents, initialstring,
										End,
										Child, GLOBALPREFS_BTH_CLEAR = TextObject,
											ButtonFrame,
											MUIA_HelpNode, NODE_GPREFS_CLEAR,
											MUIA_Weight, 0,
											MUIA_Text_Contents, GetLocaleString(MSG_GLOBALPREFS_CLEAR_GAD),
											MUIA_Text_PreParse, "\33c",
											MUIA_Text_SetMax  , FALSE,
											MUIA_Text_HiChar  , * GetLocaleString(MSG_GLOBALPREFS_CLEAR_SC),
											MUIA_ControlChar  , * GetLocaleString(MSG_GLOBALPREFS_CLEAR_SC),
											MUIA_InputMode    , MUIV_InputMode_RelVerify,
											MUIA_Background   , MUII_ButtonBack,
										End,
									End,
									Child, TextObject,
										MUIA_HelpNode, NODE_GPREFS_SHOWPATH,
										MUIA_Text_PreParse, "\33r",
										MUIA_Text_Contents, GetLocaleString(MSG_GLOBALPREFS_SHOWPATH_GAD),
										MUIA_Text_HiChar, *GetLocaleString(MSG_GLOBALPREFS_SHOWPATH_SC),
										MUIA_Weight,  1,
										TextFrame, MUIA_FramePhantomHoriz, TRUE, End,
									Child, HGroup,
										MUIA_HelpNode, NODE_GPREFS_SHOWPATH,
										Child, GLOBALPREFS_CBH_SHOWPATH = KeyCheckMark(TRUE,* GetLocaleString(MSG_GLOBALPREFS_SHOWPATH_SC)),
										Child, HSpace(0),
										Child, HGroup,
											MUIA_HelpNode, NODE_GPREFS_SHOWSIZE,
											Child, TextObject,
												MUIA_Text_PreParse, "\33r",
												MUIA_Text_Contents, GetLocaleString(MSG_GLOBALPREFS_SHOWSIZE_GAD),
												MUIA_Text_HiChar, *GetLocaleString(MSG_GLOBALPREFS_SHOWSIZE_SC),
												MUIA_Weight,  1,
												TextFrame, MUIA_FramePhantomHoriz, TRUE, End,
											Child, GLOBALPREFS_CBH_SHOWSIZE = KeyCheckMark(TRUE,* GetLocaleString(MSG_GLOBALPREFS_SHOWSIZE_SC)),
										End,
									End,
								End,
							End,
						End,
					End,
					Child, VSpace(2),
					Child, HGroup,
						MUIA_HelpNode, NODE_GPREFS_TOP,
						Child, GLOBALPREFS_BTH_SAVE		=
							KeyButton(GetLocaleString(MSG_GLOBALPREFS_SAVE_GAD),* GetLocaleString(MSG_GLOBALPREFS_SAVE_SC)),
						Child, HSpace(0),
						Child, GLOBALPREFS_BTH_USE =
							KeyButton(GetLocaleString(MSG_GLOBALPREFS_USE_GAD),* GetLocaleString(MSG_GLOBALPREFS_USE_SC)),
						Child, HSpace(0),
						Child, GLOBALPREFS_BTH_LOAD		=
							KeyButton(GetLocaleString(MSG_GLOBALPREFS_LOAD_GAD),* GetLocaleString(MSG_GLOBALPREFS_LOAD_SC)),
						Child, HSpace(0),
						Child, GLOBALPREFS_BTH_CANCEL =
							KeyButton(GetLocaleString(MSG_GLOBALPREFS_CANCEL_GAD),* GetLocaleString(MSG_GLOBALPREFS_CANCEL_SC)),
					End,
				End,
			End,
		End;

	/* --- Preferences Window OK ? -------------------------------------- */
	if (!WIH_GLOBALPREFS)
		fail(APH_DFV, "Creating Global Prefs window failed !");

	/* --- Connetions and Cycle chain ----------------------------------- */

	DoMethod(WIH_GLOBALPREFS, MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		APH_DFV, 2, MUIM_Application_ReturnID, ID_GLOBALPREFS_CANCEL);

	DoMethod(GLOBALPREFS_LVH_FILES, MUIM_Notify, MUIA_List_Active,MUIV_EveryTime,
		APH_DFV, 2, MUIM_Application_ReturnID, ID_GLOBALPREFS_FILES);

	DoMethod(GLOBALPREFS_LVH_FILES, MUIM_Notify, MUIA_Listview_DoubleClick, TRUE, APH_DFV,
		2, MUIM_Application_ReturnID, ID_GLOBALPREFS_AUTOLOAD);

	DoMethod(GLOBALPREFS_BTH_ADD, MUIM_Notify, MUIA_Pressed, FALSE,
		APH_DFV, 2, MUIM_Application_ReturnID, ID_GLOBALPREFS_ADD);
	DoMethod(GLOBALPREFS_BTH_REMOVE, MUIM_Notify, MUIA_Pressed, FALSE,
		APH_DFV, 2, MUIM_Application_ReturnID, ID_GLOBALPREFS_REMOVE);
	DoMethod(GLOBALPREFS_BTH_REMSEL, MUIM_Notify, MUIA_Pressed, FALSE,
		APH_DFV, 2, MUIM_Application_ReturnID, ID_GLOBALPREFS_REMSEL);
	DoMethod(GLOBALPREFS_BTH_SORT, MUIM_Notify, MUIA_Pressed, FALSE,
		APH_DFV, 2, MUIM_Application_ReturnID, ID_GLOBALPREFS_SORT);

	DoMethod(GLOBALPREFS_BTH_TOP, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_GLOBALPREFS_TOP);
	DoMethod(GLOBALPREFS_BTH_UP, MUIM_Notify, MUIA_Timer, MUIV_EveryTime, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_GLOBALPREFS_UP);
	DoMethod(GLOBALPREFS_BTH_DOWN, MUIM_Notify, MUIA_Timer, MUIV_EveryTime, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_GLOBALPREFS_DOWN);
	DoMethod(GLOBALPREFS_BTH_BOTTOM, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_GLOBALPREFS_BOTTOM);

	DoMethod(GLOBALPREFS_BTH_CLEAR, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_GLOBALPREFS_CLEAR);

	DoMethod(GLOBALPREFS_BTH_LOAD, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_GLOBALPREFS_LOAD);
	DoMethod(GLOBALPREFS_BTH_SAVE, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_GLOBALPREFS_SAVE);

	DoMethod(GLOBALPREFS_BTH_USE, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_GLOBALPREFS_USE);
	DoMethod(GLOBALPREFS_BTH_CANCEL, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_GLOBALPREFS_CANCEL);

	DoMethod(WIH_GLOBALPREFS, MUIM_Window_SetCycleChain,
		GLOBALPREFS_LVH_FILES,
		GLOBALPREFS_BTH_ADD,
		GLOBALPREFS_BTH_REMOVE,
		GLOBALPREFS_BTH_REMSEL,
		GLOBALPREFS_BTH_SORT,
		GLOBALPREFS_BTH_TOP,
		GLOBALPREFS_BTH_UP,
		GLOBALPREFS_BTH_DOWN,
		GLOBALPREFS_BTH_BOTTOM,
		GLOBALPREFS_BTH_CLEAR,
		GLOBALPREFS_CBH_SHOWPATH,
		GLOBALPREFS_CBH_SHOWSIZE,
		GLOBALPREFS_BTH_SAVE,
		GLOBALPREFS_BTH_USE,
		GLOBALPREFS_BTH_LOAD,
		GLOBALPREFS_BTH_CANCEL,
		NULL);

	/* --- Set the Checkboxes ------------------------------------------- */

	setcheckmark(GLOBALPREFS_CBH_SHOWPATH, gp->gp_ShowPath);
	setcheckmark(GLOBALPREFS_CBH_SHOWSIZE, gp->gp_ShowSize);

	/* --- Fill the listview -------------------------------------------- */
	i	= 0;
	fdp	= &fd;

	while (*(gp->gp_QuickChange[i].fd_File))
	{
		strcpy(fd.fd_Path, gp->gp_QuickChange[i].fd_Path);
		strcpy(fd.fd_File, gp->gp_QuickChange[i].fd_File);

		DoMethod(GLOBALPREFS_LVH_FILES,MUIM_List_Insert,&fdp,1,MUIV_List_Insert_Bottom);

		i++;
	}

	/* --- Set main window into sleeping state -------------------------- */

	set(WIH_MAIN, MUIA_Window_Sleep, TRUE);

	/* ------------------------------------------------------------------ */
	/* --- Now open the window ------------------------------------------ */
	/* ------------------------------------------------------------------ */

	DoMethod(APH_DFV, OM_ADDMEMBER, WIH_GLOBALPREFS);

	set(WIH_GLOBALPREFS, MUIA_Window_Open, TRUE);

	return(TRUE);
}

void CloseGlobalPrefs(void)
{
	/* --- Close & remove window ---------------------------------------- */

	set(WIH_GLOBALPREFS, MUIA_Window_Open, FALSE);

	DoMethod(APH_DFV, OM_REMMEMBER, WIH_GLOBALPREFS);

	/* --- Now really KILL the subwindow -------------------------------- */

	MUI_DisposeObject ( WIH_GLOBALPREFS );

	/* --- Wake up main window ------------------------------------------ */

	set(WIH_MAIN, MUIA_Window_Sleep, FALSE);
}

void dfv_adjust_gauges (void)
{
	LONG					end			= 0L;
	LONG					i			= 0L;
	LONG					sel			= 0L;
	LONG					numsel		= 0L;
	LONG					numunsel	= 0L;

	get(MAIN_LVH_PICS, MUIA_List_Entries, &end);

	if (end)
	{
		for (i=0L ; i<end ; i++)
		{
			DoMethod(MAIN_LVH_PICS, MUIM_List_Select, i, MUIV_List_Select_Ask, &sel);

			if (sel)
				numsel++;
		}
	}
	else
	{
		numsel = 0L;
	}

	numunsel	= end-numsel;

	set(MAIN_GAH_SELECTED, MUIA_Gauge_Max, end);
	set(MAIN_GAH_SELECTED, MUIA_Gauge_Current, numsel);

	set(MAIN_GAH_UNSELECTED, MUIA_Gauge_Max, end);
	set(MAIN_GAH_UNSELECTED, MUIA_Gauge_Current, numunsel);
}

/* ---------------------------------------------------------------------- */

struct NewMenu menu_list[] =
{
	{ NM_TITLE,	"",				0,	0,	0,	0							},

	{ NM_ITEM,	"",				"",	0,	0,	(APTR) ID_MAIN_ABOUT		},
	{ NM_ITEM,	NM_BARLABEL,	0,	0,	0,	0							},
	{ NM_ITEM,	"",				"",	0,	0,	(APTR) ID_MAIN_PREFS		},
	{ NM_ITEM,	NM_BARLABEL,	0,	0,	0,	0							},
	{ NM_ITEM,	"",				"",	0,	0,	(APTR) ID_MAIN_QUIT			},

	{ NM_END,	NULL,			0,	0,	0,	0							},
};

/* --- Main loop -------------------------------------------------------- */

int main(int argc, char *argv[])
{
	BOOL		not_end			= TRUE;
	BOOL		prefs_active	= FALSE;
	BOOL		str_active		= FALSE;
	BOOL		no_quickchange	= FALSE;


	static char		* programname	= "DFV";

	static char	pattern[64];
	static char	programpath[256];
	static char	initialstring[256];

	char		* LVFormat		= ",";	/* Default for path/file */

	LONG		i				= 0L;

	BPTR				tmplock;

	struct DiskObject	* DFV_DiskObject	= NULL;
	struct WBStartup	* WBenchMsg			= NULL;

	static struct GlobalPrefs	GlobalPrefs;

	struct FileData		* fdp;

	/* ------------------------------------------------------------------ */

	init();

	/* --- Get program path --------------------------------------------- */

	if (argc)
	{
		/* --- Shell startup -------------------------------------------- */

		GetProgramName(programpath, 256);
	}
	else
	{
		/* --- Workbench startup ---------------------------------------- */
		WBenchMsg	= (struct WBStartup *) argv;

		programname	= WBenchMsg->sm_ArgList->wa_Name;

		tmplock	= Lock ( programname, ACCESS_READ );
		NameFromLock ( tmplock, programpath, 256 );
		UnLock ( tmplock);
	}

	/* --- Get real program name ---------------------------------------- */

	programname = FilePart(programpath);

	/* --- Try to get disk object --------------------------------------- */

	DFV_DiskObject = dfv_getdiskobject(programpath);

	/* --- Try to open locale - if no success, english texts are used! -- */

	if (LocaleBase = (struct Library *)OpenLibrary("locale.library", 38L))
	{
		DFVCatalog		= OpenCatalogA(NULL, "dfview.catalog", NULL);
	}

	/* --- Fill the localized strings into the menu structures ---------- */

	menu_list[0].nm_Label	= GetLocaleString(MSG_MAIN_PROJECT_MENU);
	menu_list[1].nm_Label	= GetLocaleString(MSG_MAIN_ABOUT_ITEM);
	menu_list[1].nm_CommKey	= GetLocaleString(MSG_MAIN_ABOUT_ISC);
	menu_list[3].nm_Label	= GetLocaleString(MSG_MAIN_PREFS_ITEM);
	menu_list[3].nm_CommKey	= GetLocaleString(MSG_MAIN_PREFS_ISC);
	menu_list[5].nm_Label	= GetLocaleString(MSG_MAIN_QUIT_ITEM);
	menu_list[5].nm_CommKey	= GetLocaleString(MSG_MAIN_QUIT_ISC);

	/* --- Load the global prefs ---------------------------------------- */

	dfv_readprefs(&GlobalPrefs);

	/* --- Set global prefs file list ----------------------------------- */

	i = 0L;

	while (*(GlobalPrefs.gp_QuickChange[i].fd_File) != 0)
	{
		/* --- Use only filenames for cycle gadget ! -------------------- */
		CYA_QUICK[i]	= GlobalPrefs.gp_QuickChange[i].fd_File;
		i++;
	}

	if(*(GlobalPrefs.gp_QuickChange[0].fd_File) == 0)
	{
		i = 0;
		CYA_QUICK[i++]	= GetLocaleString(MSG_MAIN_QUICK_NOTUSED_TEXT);;
		/* --- If there is NO text for the cycle gadget besides --------- */
		/* --- this "not used" thing, make sure that this gadget -------- */
		/* --- stays disabled ------------------------------------------- */

		no_quickchange	= TRUE;
	}

	/* --- Terminate string vector -------------------------------------- */

	CYA_QUICK[i]	= NULL;


	/* --- Now set the listview format string --------------------------- */

	if(GlobalPrefs.gp_ShowPath)
	{
		if(GlobalPrefs.gp_ShowSize)
		{
			/* --- Filepath, filename and filesize ---------------------- */
			LVFormat	= FILELIST_FMT4;
		}
		else
		{
			/* --- Filepath and filename -------------------------------- */
			LVFormat	= FILELIST_FMT2;
		}
	}
	else
	{
		if(GlobalPrefs.gp_ShowSize)
		{
			/* --- Filename and filesize -------------------------------- */
			LVFormat	= FILELIST_FMT3;
		}
		else
		{
			/* --- Filename only ---------------------------------------- */
			LVFormat	= FILELIST_FMT1;
		}
	}

	/* --- Set up the MUI application ----------------------------------- */

	APH_DFV = ApplicationObject,
		MUIA_Application_Title,				"DFView",
		MUIA_Application_Version,			"$VER: DFView " REVISION " " REVDATE + 6,
		MUIA_Application_Copyright,			"© 1993, " AUTHOR,
		MUIA_Application_Author,			AUTHOR,
		MUIA_Application_Description,		GetLocaleString(MSG_APP_DESCRIPTION),
		MUIA_Application_Base,				"DFVIEW",
		MUIA_Application_Menu,				menu_list,
		MUIA_Application_DiskObject,		DFV_DiskObject,
		MUIA_HelpFile,						GUIDEFILE,

		/* --- Set up the main window ----------------------------------- */
		SubWindow, WIH_MAIN = WindowObject,
			MUIA_Window_ID, MAKE_ID('M','A','I','N'),
			MUIA_Window_Title, GetLocaleString(MSG_MAIN_WINDOWTITLE),
			MUIA_HelpNode, NODE_MAIN_TOP,
			WindowContents, VGroup,
				Child, VGroup,
					Child, HGroup, MUIA_Group_SameHeight, TRUE,
						Child, VGroup, GroupSpacing(0),
							MUIA_HelpNode, NODE_MAIN_FILES,
							GroupFrameT(GetLocaleString(MSG_MAIN_PICTURES_GAD)),
							Child, MAIN_LVH_PICS = ListviewObject,
								MUIA_Listview_MultiSelect, TRUE,
								MUIA_Listview_DoubleClick, TRUE,
								MUIA_Listview_List, MAIN_LIH_PICS = ListObject,
								InputListFrame,
									MUIA_List_Format, LVFormat,
									MUIA_List_ConstructHook,	& ConstructHook,
									MUIA_List_DestructHook,		& DestructHook,
									MUIA_List_DisplayHook,		& DisplayHook,
									MUIA_List_CompareHook,		& CompareHook,
									End,
								End,
							Child, ColGroup(4), GroupSpacing(0), MUIA_Group_SameSize, TRUE,
								Child, MAIN_BTH_ADD		= KeyButton(GetLocaleString(MSG_MAIN_ADD_GAD),*  GetLocaleString(MSG_MAIN_ADD_SC)),
								Child, MAIN_BTH_REMOVE	= KeyButton(GetLocaleString(MSG_MAIN_REMOVE_GAD),* GetLocaleString(MSG_MAIN_REMOVE_SC)),
								Child, MAIN_BTH_REMSEL	= KeyButton(GetLocaleString(MSG_MAIN_REMSEL_GAD),* GetLocaleString(MSG_MAIN_REMSEL_SC)),
								Child, MAIN_BTH_SORT	= KeyButton(GetLocaleString(MSG_MAIN_SORT_GAD),* GetLocaleString(MSG_MAIN_SORT_SC)),
								Child, MAIN_BTH_SELALL	= KeyButton(GetLocaleString(MSG_MAIN_ALL_GAD),* GetLocaleString(MSG_MAIN_ALL_SC)),
								Child, MAIN_BTH_SELSHIFT= KeyButton(GetLocaleString(MSG_MAIN_TOGGLE_GAD),* GetLocaleString(MSG_MAIN_TOGGLE_SC)),
								Child, MAIN_BTH_SELPAT	= KeyButton(GetLocaleString(MSG_MAIN_PATTERN_GAD),* GetLocaleString(MSG_MAIN_PATTERN_SC)),
								Child, MAIN_BTH_SELNONE	= KeyButton(GetLocaleString(MSG_MAIN_NONE_GAD),* GetLocaleString(MSG_MAIN_NONE_SC)),
								Child, MAIN_BTH_TOP		= KeyButton(GetLocaleString(MSG_MAIN_TOP_GAD),* GetLocaleString(MSG_MAIN_TOP_SC)),
								Child, MAIN_BTH_UP		= KeyButton(GetLocaleString(MSG_MAIN_UP_GAD),* GetLocaleString(MSG_MAIN_UP_SC)),
								Child, MAIN_BTH_DOWN	= KeyButton(GetLocaleString(MSG_MAIN_DOWN_GAD),* GetLocaleString(MSG_MAIN_DOWN_SC)),
								Child, MAIN_BTH_BOTTOM	= KeyButton(GetLocaleString(MSG_MAIN_BOTTOM_GAD),* GetLocaleString(MSG_MAIN_BOTTOM_SC)),
							End,
						End,
						Child, VGroup, MUIA_Group_SameWidth, TRUE,
							Child, VGroup,
							GroupFrameT(GetLocaleString(MSG_MAIN_PICTURELIST_FRAME)),
								MUIA_HelpNode, NODE_MAIN_FILELIST,
								MUIA_Group_SameWidth, TRUE,
								Child, MAIN_BTH_CLEAR	= KeyButton(GetLocaleString(MSG_MAIN_CLEAR_GAD),* GetLocaleString(MSG_MAIN_CLEAR_SC)),
								Child, MAIN_BTH_LOAD	= KeyButton(GetLocaleString(MSG_MAIN_LOAD_GAD),* GetLocaleString(MSG_MAIN_LOAD_SC)),
								Child, MAIN_BTH_SAVE	= KeyButton(GetLocaleString(MSG_MAIN_SAVE_GAD),* GetLocaleString(MSG_MAIN_SAVE_SC)),
								Child, MAIN_BTH_PREFS	= KeyButton(GetLocaleString(MSG_MAIN_FILEPREFS_GAD),* GetLocaleString(MSG_MAIN_FILEPREFS_SC)),

								Child, RectangleObject,
									TextFrame, MUIA_Weight, 0, InnerSpacing(0,0),
								End,

								Child, TextObject,
									MUIA_HelpNode, NODE_MAIN_QUICKCHANGE,
									MUIA_Text_PreParse, "\33c",
									MUIA_Text_Contents, GetLocaleString(MSG_MAIN_QUICK_GAD),
									MUIA_Weight, 0, MUIA_InnerLeft, 0,
									MUIA_InnerRight, 0,
									MUIA_Text_HiChar, * GetLocaleString(MSG_MAIN_QUICK_SC),
								End,
								Child, MAIN_CYH_QUICK = CycleObject,
									MUIA_HelpNode, NODE_MAIN_QUICKCHANGE,
									MUIA_Disabled, no_quickchange,
									MUIA_Cycle_Entries, CYA_QUICK,
									MUIA_ControlChar, * GetLocaleString(MSG_MAIN_QUICK_SC),
								End,

								Child, VSpace(0),

								Child, RectangleObject,
									TextFrame, MUIA_Weight, 0, InnerSpacing(0,0),
								End,
								Child, ColGroup(2),
									MUIA_Group_VertSpacing, 0,
									Child, TextObject,
										MUIA_HelpNode, NODE_MAIN_SELECTED,
										MUIA_Text_PreParse, "\33r",
										MUIA_Weight, 0,
										MUIA_Text_Contents, GetLocaleString(MSG_MAIN_SELECTEDITEMS_GAD),
										TextFrame, MUIA_FramePhantomHoriz, TRUE,
									End,
									Child, MAIN_GAH_SELECTED = GaugeObject,
										GaugeFrame,
										MUIA_HelpNode, NODE_MAIN_SELECTED,
										MUIA_Gauge_Horiz, TRUE,
										MUIA_Weight, 100,
										MUIA_FixHeight, 12,
									End,
									Child, TextObject,
										MUIA_HelpNode, NODE_MAIN_UNSELECTED,
										MUIA_Text_PreParse, "\33r",
										MUIA_Weight, 0,
										MUIA_Text_Contents, GetLocaleString(MSG_MAIN_UNSELECTEDITEMS_GAD),
										TextFrame, MUIA_FramePhantomHoriz, TRUE,
									End,
									Child, MAIN_GAH_UNSELECTED = GaugeObject,
										GaugeFrame,
										MUIA_HelpNode, NODE_MAIN_UNSELECTED,
										MUIA_Gauge_Horiz, TRUE,
										MUIA_Weight, 100,
										MUIA_FixHeight, 12,
									End,
									/* Notice: A VSpace() is CORRECT here   */
									/* because, A VSpace() has a horizontal */
									/* weight of zero!                      */
									Child, VSpace(0),
									Child, ScaleObject, MUIA_Scale_Horiz, TRUE,
									End,
								End,
							End,
						End,
					End,
				End,

				Child, VSpace(1),

				Child, HGroup,
					MUIA_HelpNode, NODE_MAIN_PROCESSQUIT,
					MUIA_Group_SameSize, TRUE,
					Child, MAIN_BTH_SHOW = KeyButton(GetLocaleString(MSG_MAIN_SHOW_GAD),* GetLocaleString(MSG_MAIN_SHOW_SC)),
					Child, HSpace(0),
					Child, HSpace(0),
					Child, HSpace(0),
					Child, MAIN_BTH_QUIT = KeyButton(GetLocaleString(MSG_MAIN_QUIT_GAD),* GetLocaleString(MSG_MAIN_QUIT_SC)),
					End,
				End,
			End,
		End;

	/* --- Everything OK ------------------------------------------------ */
	if (!APH_DFV)
		fail(APH_DFV, "Creating application failed !");

	/* --- Connetions and Cycle chain ----------------------------------- */
	DoMethod(WIH_MAIN, MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		APH_DFV, 2, MUIM_Application_ReturnID, ID_MAIN_QUIT);

	DoMethod(MAIN_LVH_PICS, MUIM_Notify, MUIA_Listview_SelectChange, MUIV_EveryTime, APH_DFV,
		2, MUIM_Application_ReturnID, ID_MAIN_PICS);

	DoMethod(MAIN_LVH_PICS, MUIM_Notify, MUIA_Listview_DoubleClick, TRUE, APH_DFV,
		2, MUIM_Application_ReturnID, ID_MAIN_PICVIEW);

	DoMethod(MAIN_BTH_ADD, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_MAIN_ADD);
	DoMethod(MAIN_BTH_REMOVE, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_MAIN_REMOVE);
	DoMethod(MAIN_BTH_REMSEL, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_MAIN_REMSEL);
	DoMethod(MAIN_BTH_SORT, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_MAIN_SORT);

	DoMethod(MAIN_BTH_SELSHIFT, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_MAIN_SELSHIFT);
	DoMethod(MAIN_BTH_SELALL, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_MAIN_SELALL);
	DoMethod(MAIN_BTH_SELPAT, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_MAIN_SELPAT);
	DoMethod(MAIN_BTH_SELNONE, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_MAIN_SELNONE);

	DoMethod(MAIN_BTH_TOP, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_MAIN_TOP);

	DoMethod(MAIN_BTH_UP, MUIM_Notify, MUIA_Timer, MUIV_EveryTime, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_MAIN_UP);
	DoMethod(MAIN_BTH_DOWN, MUIM_Notify, MUIA_Timer, MUIV_EveryTime, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_MAIN_DOWN);

	DoMethod(MAIN_BTH_BOTTOM, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_MAIN_BOTTOM);

	DoMethod(MAIN_BTH_CLEAR, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_MAIN_CLEAR);
	DoMethod(MAIN_BTH_SAVE, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_MAIN_SAVE);
	DoMethod(MAIN_BTH_LOAD, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_MAIN_LOAD);
	DoMethod(MAIN_BTH_PREFS, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_MAIN_FILEPREFS);

	/* --- The cycle gadget has to send a notify message ---------------- */
	/* --- EVERY TIME it is hit ----------------------------------------- */
	DoMethod(MAIN_CYH_QUICK, MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		APH_DFV, 2, MUIM_Application_ReturnID, ID_MAIN_QUICK);

	DoMethod(MAIN_BTH_SHOW, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_MAIN_SHOW);
	DoMethod(MAIN_BTH_QUIT, MUIM_Notify, MUIA_Pressed, FALSE, APH_DFV, 2,
		MUIM_Application_ReturnID, ID_MAIN_QUIT);

	DoMethod(WIH_MAIN, MUIM_Window_SetCycleChain,
		MAIN_LVH_PICS,
		MAIN_BTH_ADD,
		MAIN_BTH_REMOVE,
		MAIN_BTH_REMSEL,
		MAIN_BTH_SORT,
		MAIN_BTH_SELALL,
		MAIN_BTH_SELSHIFT,
		MAIN_BTH_SELPAT,
		MAIN_BTH_SELNONE,
		MAIN_BTH_TOP,
		MAIN_BTH_UP,
		MAIN_BTH_DOWN,
		MAIN_BTH_BOTTOM,
		MAIN_BTH_CLEAR,
		MAIN_BTH_LOAD,
		MAIN_BTH_SAVE,
		MAIN_BTH_PREFS,
		MAIN_CYH_QUICK,
		MAIN_BTH_SHOW,
		MAIN_BTH_QUIT,
		NULL);

	/* --- Use prefs ---------------------------------------------------- */
	/* --- I.e. load initial file --------------------------------------- */

	if (*(GlobalPrefs.gp_Initial.fd_File))
	{
		strcpy(initialstring, GlobalPrefs.gp_Initial.fd_Path);
		AddPart(initialstring, GlobalPrefs.gp_Initial.fd_File, 256);

		/* --- Load Filelist -------------------------------------------- */
		dfv_load_piclist(initialstring);
	}

	/* --- Now open the window ------------------------------------------ */
	set(WIH_MAIN, MUIA_Window_Open, TRUE);

	/* --- Main loop ---------------------------------------------------- */
	while (not_end)
	{
		LONG signal, id;

		switch (id = DoMethod(APH_DFV, MUIM_Application_Input, &signal))
		{
			case ID_MAIN_ABOUT:
					MUI_Request(APH_DFV, WIH_MAIN, 0,
					GetLocaleString(MSG_ABOUT_WINDOWTITLE),
					GetLocaleString(MSG_ABOUT_OK_GAD),
					"\33c\33b%s \33n\n\n \33b%s\33n \33c%s %s \n\33c\33b%s\33n\n\33c%s %s",
					GetLocaleString(MSG_ABOUT_BODYTEXT),
					"\33c$VER: DFView V" REVISION " (" REVDATE ")\n" + 8,
					GetLocaleString(MSG_ABOUT_COPYRIGHT),
					AUTHOR " \n",
					GetLocaleString(MSG_ABOUT_MUIAPPLICATION),
					GetLocaleString(MSG_ABOUT_MUICOPYRIGHT),
					"Stefan Stuntz");
				break;

			case ID_MAIN_PREFS:		/* Global Prefs */
				OpenGlobalPrefs(&GlobalPrefs);
				break;

			case MUIV_Application_ReturnID_Quit:
			case ID_MAIN_QUIT:
				not_end = FALSE;
			break;

			case ID_MAIN_PICS:
				dfv_adjust_gauges();

				break;

			case ID_MAIN_PICVIEW:
				/* --- Listview got double click ------------------------ */
				/* --- Now show the selected item. no matter if it is --- */
				/* --- selected or not ---------------------------------- */

				dfv_show_active();

				break;

			case ID_MAIN_SHOW:

				dfv_show_picture();

				break;

			case ID_MAIN_ADD:

				dfv_add_picture();

				break;

			case ID_MAIN_REMOVE:
				dfv_rem_picture();
				break;

			case ID_MAIN_REMSEL:
				dfv_remsel_picture();
				break;

			case ID_MAIN_UP:
				dfv_lv_up(MAIN_LVH_PICS);
				break;

			case ID_MAIN_DOWN:
				dfv_lv_down(MAIN_LVH_PICS);
				break;

			case ID_MAIN_TOP:
				dfv_lv_top(MAIN_LVH_PICS, sizeof(struct PicData));
				break;

			case ID_MAIN_BOTTOM:
				dfv_lv_bottom(MAIN_LVH_PICS, sizeof(struct PicData));
				break;

			case ID_MAIN_SORT:
				dfv_lv_sort(MAIN_LVH_PICS);
				break;

			case ID_MAIN_SELALL:
				dfv_selall_picture();
				break;

			case ID_MAIN_SELSHIFT:
				dfv_selshift_picture();
				break;

			case ID_MAIN_SELPAT:
				if (str_active == FALSE)
				{
					str_active = TRUE;
					OpenStringRequester();
				}

				break;

			case ID_MAIN_SELNONE:
				dfv_selnone_picture();
				break;

			case ID_MAIN_CLEAR:
				dfv_clear_piclist();
				break;

			case ID_MAIN_SAVE:
				dfv_save_piclist();
				break;

			case ID_MAIN_LOAD:
				dfv_load_piclist(NULL);
				break;

			case ID_MAIN_FILEPREFS:
				if (prefs_active == FALSE)
				{
					prefs_active = TRUE;
					OpenPrefsWindow();
				}

				break;

			case ID_MAIN_QUICK:
				dfv_clear_piclist();

				strcpy(initialstring, 
					GlobalPrefs.gp_QuickChange[GetCycle(MAIN_CYH_QUICK)].fd_Path);
				AddPart(initialstring, 
					GlobalPrefs.gp_QuickChange[GetCycle(MAIN_CYH_QUICK)].fd_File, 256);

				/* --- Load Filelist ---------------------------------------- */
				dfv_load_piclist(initialstring);

				break;

			/* --- Global Preferences ----------------------------------- */

			case ID_GLOBALPREFS_AUTOLOAD:
				DoMethod(GLOBALPREFS_LVH_FILES, MUIM_List_GetEntry, MUIV_List_GetEntry_Active, &fdp);

				strcpy(initialstring, fdp->fd_Path);
				AddPart(initialstring, fdp->fd_File, 256);

				set(GLOBALPREFS_TXH_AUTOLOAD, MUIA_Text_Contents, initialstring);

				break;

			case ID_GLOBALPREFS_ADD:
				dfv_addfileentry();
				break;

			case ID_GLOBALPREFS_REMOVE:
				dfv_remfileentry();
				break;

			case ID_GLOBALPREFS_REMSEL:
				dfv_remselfileentries();
				break;

			case ID_GLOBALPREFS_SORT:
				dfv_lv_sort(GLOBALPREFS_LVH_FILES);
				break;

			case ID_GLOBALPREFS_TOP:
				dfv_lv_top(GLOBALPREFS_LVH_FILES, sizeof(struct FileData));
				break;

			case ID_GLOBALPREFS_UP:
				dfv_lv_up(GLOBALPREFS_LVH_FILES);
				break;

			case ID_GLOBALPREFS_DOWN:
				dfv_lv_down(GLOBALPREFS_LVH_FILES);
				break;

			case ID_GLOBALPREFS_BOTTOM:
				dfv_lv_bottom(GLOBALPREFS_LVH_FILES, sizeof(struct FileData));
				break;

			case ID_GLOBALPREFS_CLEAR:
				set(GLOBALPREFS_TXH_AUTOLOAD, MUIA_Text_Contents, NULL);
				break;

			case ID_GLOBALPREFS_SAVE:
				/* --- First make changes available --------------------- */
				dfv_acceptprefs(&GlobalPrefs);

				/* --- ...then save them -------------------------------- */
				dfv_saveprefs(&GlobalPrefs);

				CloseGlobalPrefs();
				break;

			case ID_GLOBALPREFS_USE:
				dfv_acceptprefs(&GlobalPrefs);

				/* --- NO BREAK HERE ! -------------------------------- */

			case ID_GLOBALPREFS_CANCEL:
				CloseGlobalPrefs();
				break;

			/* ---------------------------------------------------------- */

			/* --- String requester ------------------------------------- */

			case ID_SREQ_OK:
				stccpy(pattern, GetStr(SREQ_STH_STRING), 64);
				dfv_selpat_picture(pattern);

				/* --- NO BREAK HERE ! -------------------------------- */

			case ID_SREQ_CANCEL:
				CloseStringRequester();
				str_active = FALSE;
				break;

			/* ---------------------------------------------------------- */

			case ID_FILEPREFS_GETCMD:
				dfv_get_command();
				break;

			case ID_FILEPREFS_OK:

				/* --- Get values --------------------------------------- */
				stccpy(PicPrefs.pp_Command, GetStr(PREFS_STH_CMD), 256);
				stccpy(PicPrefs.pp_Params, GetStr(PREFS_STH_PARAMS), 256);

				PicPrefs.pp_Pos		= GetBool(PREFS_CBH_POS);
				PicPrefs.pp_Auto	= GetBool(PREFS_CBH_AUTO);
				PicPrefs.pp_Kind	= GetCycle(PREFS_CYH_KIND);

				/* --- NO BREAK HERE ! -------------------------------- */

			case ID_FILEPREFS_CANCEL:

				ClosePrefsWindow();
				prefs_active = FALSE;
				break;

			default:

				break;
		}

		if (not_end && signal)
			Wait(signal);
	}

	dfv_remdiskobject ( DFV_DiskObject );

	if (DFVCatalog)
		CloseCatalog(DFVCatalog);

	if (LocaleBase)
		CloseLibrary(LocaleBase);

	fail(APH_DFV, NULL);
}
