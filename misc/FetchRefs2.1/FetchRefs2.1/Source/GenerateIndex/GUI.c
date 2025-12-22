#include "GenerateIndex.h"

extern struct Library * GTLayoutBase, * LocaleBase;
extern APTR catalog;
struct rtFileRequester *DataFileReq, *AddFileReq, *PrefsFileReq;
struct LayoutHandle * MainPrj, * ScanStatPrj, * OptionsPrj, * RefPrj;

BOOL GoOn = TRUE, FileChanged;

enum { LISTE_REFERENCES=1, NBRE_REFERENCES, SCAN_NEWREF, DELETE_FILE, OPTIONS, RESCAN_REF,
    RESCAN_ALL, SAVE_REFS, LOAD_REFS, CLEAR, INFOS, QUIT,
    AUTODOCS, C_INCLUDES, E_INCLUDES, ASM_INCLUDES, DEFINES, STRUCT_UNIONS,
    TYPEDEFS, CONSTANTES, OBJECTS, PROCEDURES, EQU_BITDEF, STRUCTURES, MACROS,
    SCAN_DRAWERS_RECURS, TREAT_UNRECOGNIZED_FILES, KEEP_FILES, LOAD_OPT, SAVE_OPT, SAVEAS_OPT,
    USE_OPT, LASTSAVED, CANCEL_OPT, INPUT_REFERENCES,
    REF_FILE, OFFSET, LINE, SIZE, DELETE_REF
};

#define SPREAD 1
#define SAME_SIZE 2
#define FRAME 4

/* Localisation tables */
enum { NULL_STRING=0, REFERENCES_LOC, SCANNEW_LOC, DELETE_LOC, OPTIONS_LOC, RESCAN_LOC,
    RESCAN_ALL_LOC, SAVE_REFS_LOC, LOAD_REFS_LOC, CLEAR_REFS_LOC, ABOUT_LOC, QUIT_LOC,
    /* References window */
    FILE_LOC, OFFSET_LOC, SIZE_LOC, LINE_LOC,
    /* Prefs window */
    GEN_OPT_LOC, AUTODOCS_LOC, C_INCLUDES_LOC, DEFINES_LOC, STRUCTUNIONS_LOC, TYPDEDEF_LOC,
    E_INCLUDES_LOC, CONST_LOC, OBJECT_LOC, PROC_LOC,
    ASM_INCLUDES_LOC, EQUBITDEF_LOC, STRUCTURE_LOC, MACRO_LOC,
    SCAN_RECURS_LOC, UNRECOGNIZED_LOC, KEEP_FILES_LOC,
    LOADPREFS_LOC, LASTSAVED_LOC, CANCEL_LOC, SAVEAS_LOC, USEREFS_LOC,
    /* Stop scanning window */
    SCANNING_LOC, STOP_SCANNING_LOC,
    /* Other messages */
    SELECT_INDEXFILES_LOC, LOOSE_CHANGES_LOC, OK_CANCEL_LOC, NOEMPTYLIST_LOC,
    REPLACE_APPEND_LOC, CLEAR_LIST_LOC,
};

char * strings[] = {	"", "References", "Scan...", "Delete", "Options...", "Rescan",
    "Rescan all", "Save", "Load", "Clear", "About", "Quit",
    /* References window */
    "File", "Offset", "Size", "Line",
    /* Prefs window */
    "GenerateIndex Options", "AutoDocs", "C includes", "#define", "struct/union", "typedef",
    "E includes", "CONST", "Object", "PROC",
    "ASM includes", "EQU/BITDEF", "STRUCTURE", "MACRO",
    "Scan drawers recursively", "Treat unrecognized files as Autodocs",
    "Keep files without references",
    "Load...", "Last saved", "Cancel", "Save as...", "Use",
    /* Stop scanning window */
    "Scanning...", "Stop scanning",
    /* Other messages */
    "Select files to index...", "There are changes!\nReally load a new file?",
    "_Okay|_Cancel", "Current list is not empty!", "_Replace|_Append|_Cancel",
    "There are changes!\nReally clear the entire list?"
};

char * __regargs GetString (long indice)
{   STRPTR def = strings[indice];
    return (catalog ? GetCatalogStr (catalog, indice, def) : def);
}

__saveds __asm char * LocaleHookFunc (register __a0 struct Hook * UnusedHook, register __a2 APTR Unused, register __a1 long ID)
{
    return GetString(ID);
}

struct Hook LocaleHook = { 0, 0, (HOOKFUNC) LocaleHookFunc, 0, 0 };

void CloseProject (struct TR_Project * p)
{
}

static void __regargs New_Horizontal_group (struct LayoutHandle * h, long tag)
{   long i = 1;
    struct TagItem tags[5];

    tags[0].ti_Tag = LA_Type;
    tags[0].ti_Data = HORIZONTAL_KIND;
    if (tag & SPREAD)
    {	tags[i].ti_Tag = LAGR_Spread;	tags[i].ti_Data = TRUE; i++;	}
    if (tag & SAME_SIZE)
    {	tags[i].ti_Tag = LAGR_SameSize; tags[i].ti_Data = TRUE; i++;	}
    if (tag & FRAME)
    {	tags[i].ti_Tag = LAGR_Frame;	tags[i].ti_Data = TRUE; i++;	}
    tags[i].ti_Tag = TAG_DONE;
    LT_NewA (h, tags);
}

static void __regargs New_Button (struct LayoutHandle * h, long id, long locale_ID)
{
    LT_New (h,
	LA_Type,    BUTTON_KIND,
	LA_ID,	    id,
	LA_LabelID, locale_ID,
    TAG_DONE);
}

static void __regargs New_CheckBox (struct LayoutHandle * handle, long id, long label)
{
    LT_New (handle,
	LA_Type,	CHECKBOX_KIND,
	LA_ID,		id,
	LA_LabelID,	label,
	LA_LabelPlace,	PLACE_Right,
    TAG_DONE);
}

static struct LayoutHandle * CreateMainWindow (void)
{
    struct LayoutHandle * h = LT_CreateHandleTags (0, LAHN_LocaleHook, &LocaleHook, TAG_DONE);
    if (h)
    {
	LT_New (h, LA_Type, VERTICAL_KIND, TAG_DONE);
	{   LT_New (h, LA_Type, VERTICAL_KIND, LAGR_Frame, TRUE, TAG_DONE);
	    {
		LT_New (h,
		    LA_Type,	    LISTVIEW_KIND,
		    LA_Chars,	    31,
		    LALV_Lines,     10,
		    LALV_ResizeY,   TRUE,
		    LALV_ResizeX,   TRUE,
		    LALV_CursorKey, TRUE,
		    LALV_Link,	    NIL_LINK,
		    LA_ID,	    LISTE_REFERENCES,
		TAG_DONE);
		New_Horizontal_group (h, 0);
		{
		    LT_New (h,
			LA_Type,    TEXT_KIND,
			LATX_Picker, TRUE,
			LA_Chars,   31-strlen(GetString(REFERENCES_LOC)),
			LA_LabelID, REFERENCES_LOC,
			GTTX_Border, TRUE,
			LA_ID,	    NBRE_REFERENCES,
		    TAG_DONE);
		    LT_EndGroup (h);
		}
		LT_EndGroup (h);
	    }
	    LT_New (h, LA_Type, VERTICAL_KIND, LAGR_Frame, TRUE, TAG_DONE);
	    {
		New_Horizontal_group (h, SPREAD | SAME_SIZE);
		{   New_Button (h, SCAN_NEWREF, SCANNEW_LOC);
		    New_Button (h, DELETE_FILE, DELETE_LOC);
		    New_Button (h, OPTIONS, OPTIONS_LOC);
		    LT_EndGroup (h);
		}
		New_Horizontal_group (h, SAME_SIZE);
		{   New_Button (h, RESCAN_REF, RESCAN_LOC);
		    New_Button (h, RESCAN_ALL, RESCAN_ALL_LOC);
		    LT_EndGroup (h);
		}
		LT_EndGroup (h);
	    }
	    LT_New (h, LA_Type, VERTICAL_KIND, LAGR_Frame, TRUE, TAG_DONE);
	    {
		New_Horizontal_group (h, SPREAD | SAME_SIZE);
		{   New_Button (h, SAVE_REFS, SAVE_REFS_LOC);
		    New_Button (h, LOAD_REFS, LOAD_REFS_LOC);
		    New_Button (h, CLEAR, CLEAR_REFS_LOC);
		    New_Button (h, INFOS, ABOUT_LOC);
		    New_Button (h, QUIT, QUIT_LOC);
		    LT_EndGroup (h);
		}
		LT_EndGroup (h);
	    }
	    LT_EndGroup (h);
	}
	if (LT_Build (h,
	    LAWN_Title,     "GenerateIndex",
	    LAWN_IDCMP,     IDCMP_CLOSEWINDOW | LISTVIEWIDCMP | RAWKEY,
	    WA_DepthGadget, TRUE,
	    WA_RMBTrap,     TRUE,
	    WA_DragBar,     TRUE,
	    WA_Activate,    TRUE,
	    WA_CloseGadget, TRUE,
	TAG_DONE))
	    return h;

	LT_DeleteHandle (h);
    }
    return 0;
}

void About (void)
{
    rtEZRequestTags ("GenerateIndex " VERSION " " DATE "\n"
		     "Index file generator for FetchRefs\n"
		     "\n"
		     "By Roland Florac, FreeWare, 2000-2001\n\n"
		     "Original program by Anders Melchiorsen\n"
		     "1994-1996",
		     "Okay",
		     NULL, NULL,
		     RTEZ_Flags, EZREQF_CENTERTEXT,
		     TAG_END,	 NULL
		    );
}

/* OpenRefWindow() */
void OpenReferencesWindow (void)
{
    struct LayoutHandle * h;

    if (! RefPrj)
    {
	/* We call UpdateMain() because it also updates the text gadget
	 * with the file name of the ref window. */
	h = LT_CreateHandleTags (0, LAHN_LocaleHook, &LocaleHook, TAG_DONE);
	if (h)
	{   LT_New (h, LA_Type, VERTICAL_KIND, LAGR_Frame, TRUE, TAG_DONE);
	    {
		LT_New (h,
		    LA_Type,	    LISTVIEW_KIND,
		    LA_Chars,	    31,
		    LALV_Lines,     10,
		    LALV_ResizeY,   TRUE,
		    LALV_ResizeX,   TRUE,
		    LALV_CursorKey, TRUE,
		    LALV_Link,	    NIL_LINK,
		    LA_ID,	    INPUT_REFERENCES,
		TAG_DONE);
		New_Horizontal_group (h, SPREAD | SAME_SIZE | FRAME);
		{
		    LT_New (h,
			LA_Type,    TEXT_KIND,
			LA_Chars,   31-strlen(GetString(FILE_LOC)),
			LA_LabelID, FILE_LOC,
			GTTX_Border, TRUE,
			LA_ID,	    REF_FILE,
		    TAG_DONE);
		    LT_EndGroup (h);
		}
		LT_New (h, LA_Type, VERTICAL_KIND, LAGR_Frame, TRUE, TAG_DONE);
		{
		    LT_New (h,
			LA_Type,    TEXT_KIND,
			LA_Chars,   12,
			LA_LabelID, OFFSET_LOC,
			GTTX_Border, TRUE,
			LA_ID,	    OFFSET,
		    TAG_DONE);
		    LT_New (h,
			LA_Type,    TEXT_KIND,
			LA_Chars,   12,
			LA_LabelID, SIZE_LOC,
			GTTX_Border, TRUE,
			LA_ID,	    SIZE,
		    TAG_DONE);
		    LT_New (h,
			LA_Type,    TEXT_KIND,
			LA_Chars,   12,
			LA_LabelID, LINE_LOC,
			GTTX_Border, TRUE,
			LA_ID,	    LINE,
		    TAG_DONE);
		    LT_EndGroup (h);
		}
		New_Button (h, DELETE_REF, DELETE_LOC);
	    }
	    LT_EndGroup (h);
	    if (LT_Build (h,
		LAWN_Title,	GetString(REFERENCES_LOC),
		LAWN_IDCMP,	IDCMP_CLOSEWINDOW | LISTVIEWIDCMP | RAWKEY,
		WA_DepthGadget, TRUE,
		WA_RMBTrap,	TRUE,
		WA_DragBar,	TRUE,
		WA_Activate,	TRUE,
		WA_CloseGadget, TRUE,
	    TAG_DONE))
	    {
		RefPrj = h;
		UpdateMain();
	    }
	    else
		LT_DeleteHandle (h);
	}
    }
    else
    {
	struct Window * win;

	/* Bring the ref window to the front */
	if (win = RefPrj->Window)
	{
	    WindowToFront (win);
	    ActivateWindow (win);
	}
    }
}

/* OpenScanStatWindow() */
void OpenScanStatWindow (void)
{
    struct LayoutHandle * h = LT_CreateHandleTags (0, LAHN_LocaleHook, &LocaleHook, TAG_DONE);
    if (h)
    {	New_Horizontal_group (h, SPREAD | SAME_SIZE | FRAME);
	{   New_Button (h, SCAN_NEWREF, STOP_SCANNING_LOC);
	    LT_EndGroup (h);
	}
	if (LT_Build (h,
	    LAWN_Title,     GetString(SCANNING_LOC),
	    LAWN_IDCMP,     IDCMP_GADGETUP,
	    WA_DepthGadget, TRUE,
	    WA_RMBTrap,     TRUE,
	    WA_DragBar,     TRUE,
	    WA_Activate,    TRUE,
	    WA_CloseGadget, TRUE,
	TAG_DONE))
	    ScanStatPrj = h;
	else
	    LT_DeleteHandle (ScanStatPrj);
    }
}

static struct LayoutHandle * OpenOptions (void)
{
    struct LayoutHandle * h = LT_CreateHandleTags (0, LAHN_LocaleHook, &LocaleHook, TAG_DONE);
    if (h)
    {	LT_New (h, LA_Type, VERTICAL_KIND, TAG_DONE);
	{
	    New_Horizontal_group (h, FRAME | SPREAD | SAME_SIZE);
	    {
		New_CheckBox (h, AUTODOCS, AUTODOCS_LOC);
		LT_EndGroup (h);
	    }
	    New_Horizontal_group (h, SPREAD | SAME_SIZE);
	    {
		LT_New (h, LA_Type, VERTICAL_KIND, LAGR_Frame, TRUE, TAG_DONE);
		{
		    New_CheckBox (h, C_INCLUDES, C_INCLUDES_LOC);
		    LT_New (h, LA_Type, XBAR_KIND, TAG_DONE);
		    New_CheckBox (h, DEFINES, DEFINES_LOC);
		    New_CheckBox (h, STRUCT_UNIONS, STRUCTUNIONS_LOC);
		    New_CheckBox (h, TYPEDEFS, TYPDEDEF_LOC);
		    LT_EndGroup (h);
		}
		LT_New (h, LA_Type, VERTICAL_KIND, LAGR_Frame, TRUE, TAG_DONE);
		{
		    New_CheckBox (h, E_INCLUDES, E_INCLUDES_LOC);
		    LT_New (h, LA_Type, XBAR_KIND, TAG_DONE);
		    New_CheckBox (h, CONSTANTES, CONST_LOC);
		    New_CheckBox (h, OBJECTS, OBJECT_LOC);
		    New_CheckBox (h, PROCEDURES, PROC_LOC);
		    LT_EndGroup (h);
		}
		LT_New (h, LA_Type, VERTICAL_KIND, LAGR_Frame, TRUE, TAG_DONE);
		{
		    New_CheckBox (h, ASM_INCLUDES, ASM_INCLUDES_LOC);
		    LT_New (h, LA_Type, XBAR_KIND, TAG_DONE);
		    New_CheckBox (h, EQU_BITDEF, EQUBITDEF_LOC);
		    New_CheckBox (h, STRUCTURES, STRUCTURE_LOC);
		    New_CheckBox (h, MACROS, MACRO_LOC);
		    LT_EndGroup (h);
		}
		LT_EndGroup (h);
	    }
	    LT_New (h, LA_Type, VERTICAL_KIND, LAGR_Frame, TRUE, TAG_DONE);
	    {
		New_CheckBox (h, SCAN_DRAWERS_RECURS, SCAN_RECURS_LOC);
		New_CheckBox (h, TREAT_UNRECOGNIZED_FILES, UNRECOGNIZED_LOC);
		New_CheckBox (h, KEEP_FILES, KEEP_FILES_LOC);
		LT_EndGroup (h);
	    }
	    LT_New (h, LA_Type, VERTICAL_KIND, LAGR_Frame, TRUE, TAG_DONE);
	    {
		New_Horizontal_group (h, SPREAD | SAME_SIZE);
		{
		    New_Button (h, LOAD_OPT, LOADPREFS_LOC);
		    New_Button (h, LASTSAVED, LASTSAVED_LOC);
		    New_Button (h, CANCEL_OPT, CANCEL_LOC);
		    LT_EndGroup (h);
		}
		New_Horizontal_group (h, SPREAD | SAME_SIZE);
		{
		    New_Button (h, SAVEAS_OPT, SAVEAS_LOC);
		    New_Button (h, SAVE_OPT, SAVE_REFS_LOC);
		    New_Button (h, USE_OPT, USEREFS_LOC);
		    LT_EndGroup (h);
		}
		LT_EndGroup (h);
	    }
	    LT_EndGroup (h);
	}
	if (! LT_Build (h,
	    LAWN_Title,     GetString(GEN_OPT_LOC),
	    LAWN_IDCMP,     IDCMP_CLOSEWINDOW | IDCMP_GADGETUP,
	    WA_DepthGadget, TRUE,
	    WA_RMBTrap,     TRUE,
	    WA_DragBar,     TRUE,
	    WA_Activate,    TRUE,
	    WA_CloseGadget, TRUE,
	TAG_DONE))
	{
	    LT_DeleteHandle (h);
	    h = 0;
	}
    }
    return h;
}

/* CloseScanStatWindow() */
void CloseScanStatWindow (void)
{
    if (ScanStatPrj)
	LT_DeleteHandle (ScanStatPrj);
    ScanStatPrj = NULL;
}

/// GiveHelp() - open guide positioned at the help for <id>
#include "HelpTable.h"

void
GiveHelp(LONG id, struct Screen *scr)
{
    struct Library *AmigaGuideBase;
    struct NewAmigaGuide nag = { NULL };
    AMIGAGUIDECONTEXT handle;
    LONG cnt;

    LockGUI();

    nag.nag_Name = "FetchRefs_GI.guide";
    nag.nag_Screen = scr;

    for (cnt = 0; HelpTable[cnt].id; cnt++)
	if (HelpTable[cnt].id == id)
	    break;
    nag.nag_Node = HelpTable[cnt].node;
    nag.nag_Line = HelpTable[cnt].line;

    /* Show the guide */
    if (AmigaGuideBase = OpenLibrary("amigaguide.library", 34))
    {
	if (handle = OpenAmigaGuideA(&nag, NULL))
	    CloseAmigaGuide(handle);
	else
	    PostMessage ("Could not open guide");

	CloseLibrary(AmigaGuideBase);
    } else
	PostMessage ("Could not open amigaguide.library v34+");

    UnlockGUI();
}

/* LockGUI() */
void LockGUI (void)
{
    if (MainPrj)
	LT_LockWindow (MainPrj->Window);
    if (RefPrj)
	LT_LockWindow (RefPrj->Window);
    if (OptionsPrj)
	LT_LockWindow (OptionsPrj->Window);
}

/* UnlockGUI() */
void UnlockGUI (void)
{
    if (MainPrj)
	LT_DeleteWindowLock (MainPrj->Window);
    if (RefPrj)
	LT_DeleteWindowLock (RefPrj->Window);
    if (OptionsPrj)
	LT_DeleteWindowLock (OptionsPrj->Window);
}

/* AttachMainList() */
void AttachMainList (struct List *newlist)
{
    static struct List *lastlist = &FileList;

    if (!newlist)
	newlist = lastlist;
    else
	lastlist = newlist;

    if (MainPrj)
    {
	LT_SetAttributes (MainPrj, LISTE_REFERENCES, GTLV_Labels, newlist, GTLV_Selected, 0, TAG_END);

	if (newlist == &FileList)
	    UpdateMain();
    }
}

/* DetachMainList() */
void DetachMainList (void)
{
    if (MainPrj)
	LT_SetAttributes (MainPrj, LISTE_REFERENCES, GTLV_Labels, ~0, TAG_END);
}

/* AttachRefList() */
void AttachRefList (void)
{
    struct FileEntry *f;

    if (RefPrj)
    {
	f = SelectedMain();
	LT_SetAttributes (RefPrj, INPUT_REFERENCES, GTLV_Labels, (ULONG) (f ? &f->data.RefsList : &EmptyList), TAG_END);
    }
}

/* DetachRefList() */
void DetachRefList (void)
{
    if (RefPrj)
	LT_SetAttributes (RefPrj, INPUT_REFERENCES, GTLV_Labels, ~0, TAG_END);
}

/* DeleteSelectedFile() */
static void DeleteSelectedFile (void)
{
    struct FileEntry *f;

    if (f = SelectedMain())
    {
	DetachMainList ();
	FreeFile (f);
	AttachMainList (NULL);
	UpdateMain ();

	FileChanged = TRUE;
    }
}

/* DeleteSelectedReference() */
void DeleteSelectedReference (void)
{
    struct RefsEntry *r;

    if (r = SelectedRef())
    {
	FreeRef (r);
	FileChanged = TRUE;
    }
}

/* RescanAllFiles() */
static void RescanAllFiles (void)
{
    struct Node *n, *next;

    for (next = GetHead (&FileList);  n = next, next = next->ln_Succ;  )
    {
	/* If the user break (window is closed) the list is not sorted
	 * so we do that before returning. */
	if (! ScanStatPrj)
	{
	    SortExecList (&FileList, SortCompareFunc, NULL);
	    break;
	}

	/* Rescan this one. This may delete the entry, so we have cached
	 * a pointer to the next. */
	IndexFile ("", n->ln_Name);
    }
}

/* UpdateMain() */
void UpdateMain (void)
{
    struct FileEntry *n = SelectedMain();
    static char val[10];
    ULONG nf;

    /* Update main windows action gadgets: no list, no action */
    if (MainPrj)
    {
	LT_SetAttributes (MainPrj, DELETE_FILE, GA_Disabled, !n, TAG_END);
	LT_SetAttributes (MainPrj, RESCAN_REF, GA_Disabled, !n, TAG_END);
	LT_SetAttributes (MainPrj, RESCAN_ALL, GA_Disabled, !n, TAG_END);

	/* Update main 'references count' gadget */
	if (n)
	    nf =  NumOfNodes(&n->data.RefsList);
	else
	    nf = 0;
	sprintf (val, "%ld", nf);
	LT_SetAttributes (MainPrj, NBRE_REFERENCES, GTTX_Text, val, TAG_END);
	LT_SetAttributes (MainPrj, SAVE_REFS, GA_Disabled, !nf, TAG_END);
	LT_SetAttributes (MainPrj, CLEAR, GA_Disabled, !nf, TAG_END);
    }

    /* Update ref 'file' gadget */
    if (RefPrj)
    {
	LT_SetAttributes (RefPrj, REF_FILE, GTTX_Text, (ULONG) (n ? (STRPTR)n->data.Name : (STRPTR)""), TAG_END);
	UpdateRef();
    }
}

/* UpdateRef() */
void UpdateRef (void)
{
    static struct FileEntry *shown = (APTR)-1;
    static char offset[10], size[10], line[10];

    if (RefPrj)
    {
	struct FileEntry *f = SelectedMain();
	struct RefsEntry *r = SelectedRef();

	/* Update ref window 'delete' gadget */
	LT_SetAttributes (RefPrj, DELETE_REF, GA_Disabled, !r, TAG_END);

	/* Update ref window's listview if main window is changed */
	if (f != shown)
	{
	    LT_SetAttributes (RefPrj, INPUT_REFERENCES, GTLV_Labels, ~0, TAG_END);
	    AttachRefList();
	}

	/* Update ref windows information gadgets */
	sprintf (offset, "%ld", r ? r->data.Offset : 0);
	LT_SetAttributes (RefPrj, OFFSET, GTTX_Text, offset, TAG_END);
	sprintf (size, "%ld", r ? r->data.Length : 0);
	LT_SetAttributes (RefPrj, SIZE, GTTX_Text, size, TAG_END);
	sprintf (line, "%ld", r ? r->data.Goto : 0);
	LT_SetAttributes (RefPrj, LINE, GTTX_Text, line, TAG_END);

	shown = f;
    }
    else
	shown = (APTR)-1;
}

/* UpdateOptions() */
void UpdateOptions (void)
{
    LT_SetAttributes (OptionsPrj, AUTODOCS, GTCB_Checked, Settings.AutoDocPrf.Active, TAG_END);

    LT_SetAttributes (OptionsPrj, C_INCLUDES, GTCB_Checked, Settings.CPrf.Active, TAG_END);
    LT_SetAttributes (OptionsPrj, DEFINES, GTCB_Checked, Settings.CPrf.Define, TAG_END);
    LT_SetAttributes (OptionsPrj, STRUCT_UNIONS, GTCB_Checked, Settings.CPrf.Struct, TAG_END);
    LT_SetAttributes (OptionsPrj, TYPEDEFS, GTCB_Checked, Settings.CPrf.Typedef, TAG_END);

    LT_SetAttributes (OptionsPrj, E_INCLUDES, GTCB_Checked, Settings.EPrf.Active, TAG_END);
    LT_SetAttributes (OptionsPrj, CONSTANTES, GTCB_Checked, Settings.EPrf.Const, TAG_END);
    LT_SetAttributes (OptionsPrj, OBJECTS, GTCB_Checked, Settings.EPrf.Object, TAG_END);
    LT_SetAttributes (OptionsPrj, PROCEDURES, GTCB_Checked, Settings.EPrf.Proc, TAG_END);

    LT_SetAttributes (OptionsPrj, ASM_INCLUDES, GTCB_Checked, Settings.AsmPrf.Active, TAG_END);
    LT_SetAttributes (OptionsPrj, EQU_BITDEF, GTCB_Checked, Settings.AsmPrf.Equ, TAG_END);
    LT_SetAttributes (OptionsPrj, STRUCTURES, GTCB_Checked, Settings.AsmPrf.Structure, TAG_END);
    LT_SetAttributes (OptionsPrj, MACROS, GTCB_Checked, Settings.AsmPrf.Macro, TAG_END);

    LT_SetAttributes (OptionsPrj, SCAN_DRAWERS_RECURS, GTCB_Checked, Settings.Recursively, TAG_END);
    LT_SetAttributes (OptionsPrj, KEEP_FILES, GTCB_Checked, Settings.KeepEmpty, TAG_END);
    LT_SetAttributes (OptionsPrj, TREAT_UNRECOGNIZED_FILES, GTCB_Checked, Settings.UnknownAsAutoDoc, TAG_END);

    UpdateOptionsGhost();
}

/* UpdateOptionsGhost() */
void UpdateOptionsGhost (void)
{
    LONG ghost;

    if (! OptionsPrj)
	return;

    ghost = ! LT_GetAttributes (OptionsPrj, C_INCLUDES, TAG_DONE);
    LT_SetAttributes (OptionsPrj, DEFINES, GA_Disabled, ghost, TAG_DONE);
    LT_SetAttributes (OptionsPrj, STRUCT_UNIONS, GA_Disabled, ghost, TAG_DONE);
    LT_SetAttributes (OptionsPrj, TYPEDEFS, GA_Disabled, ghost, TAG_DONE);

    ghost = ! LT_GetAttributes (OptionsPrj, E_INCLUDES, TAG_DONE);
    LT_SetAttributes (OptionsPrj, CONSTANTES, GA_Disabled, ghost, TAG_DONE);
    LT_SetAttributes (OptionsPrj, OBJECTS, GA_Disabled, ghost, TAG_DONE);
    LT_SetAttributes (OptionsPrj, PROCEDURES, GA_Disabled, ghost, TAG_DONE);

    ghost = ! LT_GetAttributes (OptionsPrj, ASM_INCLUDES, TAG_DONE);
    LT_SetAttributes (OptionsPrj, EQU_BITDEF, GA_Disabled, ghost, TAG_DONE);
    LT_SetAttributes (OptionsPrj, STRUCTURES, GA_Disabled, ghost, TAG_DONE);
    LT_SetAttributes (OptionsPrj, MACROS, GA_Disabled, ghost, TAG_DONE);
}

/* UpdateSettingsStruct() */
void UpdateSettingsStruct (void)
{
    Settings.AutoDocPrf.Active	= LT_GetAttributes (OptionsPrj, AUTODOCS, TAG_DONE);

    Settings.CPrf.Active	= LT_GetAttributes (OptionsPrj, C_INCLUDES, TAG_DONE);
    Settings.CPrf.Define	= LT_GetAttributes (OptionsPrj, DEFINES, TAG_DONE);
    Settings.CPrf.Struct	= LT_GetAttributes (OptionsPrj, STRUCT_UNIONS, TAG_DONE);
    Settings.CPrf.Typedef	= LT_GetAttributes (OptionsPrj, TYPEDEFS, TAG_DONE);

    Settings.EPrf.Active	= LT_GetAttributes (OptionsPrj, E_INCLUDES, TAG_DONE);
    Settings.EPrf.Const 	= LT_GetAttributes (OptionsPrj, CONSTANTES, TAG_DONE);
    Settings.EPrf.Object	= LT_GetAttributes (OptionsPrj, OBJECTS, TAG_DONE);
    Settings.EPrf.Proc		= LT_GetAttributes (OptionsPrj, PROCEDURES, TAG_DONE);

    Settings.AsmPrf.Active	= LT_GetAttributes (OptionsPrj, ASM_INCLUDES, TAG_DONE);
    Settings.AsmPrf.Equ 	= LT_GetAttributes (OptionsPrj, EQU_BITDEF, TAG_DONE);
    Settings.AsmPrf.Structure	= LT_GetAttributes (OptionsPrj, STRUCTURES, TAG_DONE);
    Settings.AsmPrf.Macro	= LT_GetAttributes (OptionsPrj, MACROS, TAG_DONE);

    Settings.Recursively	= LT_GetAttributes (OptionsPrj, SCAN_DRAWERS_RECURS, TAG_DONE);
    Settings.KeepEmpty		= LT_GetAttributes (OptionsPrj, KEEP_FILES, TAG_DONE);
    Settings.UnknownAsAutoDoc	= LT_GetAttributes (OptionsPrj, TREAT_UNRECOGNIZED_FILES, TAG_DONE);
}

void __regargs HandleReferencesPrj (struct IntuiMessage * msg)
{
    struct Gadget * gad = (struct Gadget *) msg->IAddress;

    switch (msg->Class)
    {
	case IDCMP_CLOSEWINDOW:
	    LT_DeleteHandle (RefPrj);
	    RefPrj = NULL;
	    /* Forget what the listview contains */
	    UpdateRef();
	    break;
	case IDCMP_IDCMPUPDATE:
	    UpdateRef ();
	    break;
	case IDCMP_GADGETUP:
	    switch (gad->GadgetID)
	    {
		case INPUT_REFERENCES:
		    UpdateRef ();
		    break;
		case DELETE_REF:
		    DeleteSelectedReference();
		    UpdateMain();
		    break;
	    }
    }
}

BOOL __regargs HandleMainprj (struct IntuiMessage * msg)
{
    struct Gadget * gad = (struct Gadget *) msg->IAddress;

    switch (msg->Class)
    {
	case IDCMP_IDCMPUPDATE:
	    switch (gad->GadgetID)
	    {	case LISTE_REFERENCES:
		case NBRE_REFERENCES:
		    OpenReferencesWindow ();    break;
	    }
	    break;
	case IDCMP_GADGETUP:
	    switch (gad->GadgetID)
	    {
		case SCAN_NEWREF:
		    {
			struct rtFileList * selfiles;
			char tmpname[108];

			LockGUI();
			tmpname[0] = 0;
			if (selfiles = rtFileRequest (AddFileReq, tmpname,
				GetString(SELECT_INDEXFILES_LOC),
				RTFI_Flags, FREQF_MULTISELECT | FREQF_SELECTDIRS | FREQF_PATGAD,
				TAG_END))
			{
			    StartScanning ();
			    IndexFileList (AddFileReq->Dir, selfiles);
			    rtFreeFileList (selfiles);
			    SortExecList (&FileList, SortCompareFunc, NULL);
			    StopScanning (FALSE);
			}
			UnlockGUI();
		    }
		    break;
		case RESCAN_REF:
		    {
			struct FileEntry *f;

			if (f = SelectedMain())
			{
			    StartScanning();
			    LockGUI ();

			    /* Rescan. This will free the old references */
			    IndexFile ("", f->data.Name);

			    UnlockGUI();
			    StopScanning (FALSE);
			}
		    }
		    break;

		case RESCAN_ALL:
		    StartScanning();
		    LockGUI();
		    RescanAllFiles();
		    UnlockGUI();
		    StopScanning (FALSE);
		    break;

		case DELETE_FILE:
		    DeleteSelectedFile();       break;

		case QUIT:
		    return 0;

		case LISTE_REFERENCES:
		    UpdateMain ();
		    break;

		case LOAD_REFS:
		    LockGUI();
		    if ((!FileChanged) || rtEZRequestTags (GetString(LOOSE_CHANGES_LOC),
					GetString (OK_CANCEL_LOC),  NULL, NULL,
					RT_Underscore, '_', TAG_END))
		    {
			if (! IsListEmpty (&FileList))
			{
			    ULONG ret;
			    ret = rtEZRequestTags (GetString (NOEMPTYLIST_LOC),
				    GetString (REPLACE_APPEND_LOC), NULL, NULL,
				    RT_Underscore, '_',     TAG_END);

			    if (ret == 0)
			    {
				UnlockGUI ();
				break;
			    }
			    else if (ret == 1)
			    {
				InitializeFileList ();
				UpdateMain ();

				FileChanged = FALSE;
			    }
			    else if (ret == 2)
				FileChanged = TRUE;
			}
			else
			    FileChanged = FALSE;

			LoadData (NULL);
			UpdateMain ();
		    }
		    UnlockGUI();
		    break;

		case SAVE_REFS:
		    if (! IsListEmpty (&FileList))
		    {
			LockGUI ();
			SaveData (NULL);
			UnlockGUI ();
		    }
		    break;

		case CLEAR:
		    LockGUI();
		    if ((!FileChanged) || rtEZRequestTags (GetString(CLEAR_LIST_LOC),
			    GetString (OK_CANCEL_LOC), NULL, NULL,
			    RT_Underscore, '_',     TAG_END))
		    {
			InitializeFileList();
			UpdateMain();

			FileChanged = FALSE;
		    }
		    UnlockGUI();
		    break;

		case OPTIONS:
		    if (! OptionsPrj)
		    {
			LT_SetAttributes (MainPrj, SCAN_NEWREF, GA_Disabled, TRUE, TAG_END);
			if (OptionsPrj = OpenOptions ())
			    UpdateOptions();
			else
			    LT_SetAttributes (MainPrj, SCAN_NEWREF, GA_Disabled, FALSE, TAG_END);
		    }
		    else
		    {
			struct Window *win;

			/* Bring the options window to the front */
			if (win = OptionsPrj->Window)
			{
			    WindowToFront (win);
			    ActivateWindow (win);
			    // TR_ReleaseWindow(win);
			}
		    }
		    break;
		case INFOS:
		    LockGUI();
		    About();
		    UnlockGUI();
		    break;
	    }
	    break;
	case IDCMP_CLOSEWINDOW:
	    return 0;
    }
    return 1;
}

/* HandleOptionsPrj () */
void HandleOptionsPrj (struct IntuiMessage * m)
{
    static UBYTE prefname[108];
    struct Prefs tmpsettings;
    BPTR newdir, olddir;

    if (m->Class == IDCMP_CLOSEWINDOW)
    {
	LT_DeleteHandle (OptionsPrj);
	OptionsPrj = NULL;
	LT_SetAttributes (MainPrj, SCAN_NEWREF, GA_Disabled, FALSE, TAG_END);
	return;
    }

    if (m->Class == IDCMP_GADGETUP)
    {
	struct Gadget * gad = (struct Gadget *) m->IAddress;

	switch (gad->GadgetID)
	{
	    case USE_OPT:
	    case SAVE_OPT:
		UpdateSettingsStruct ();

		if (gad->GadgetID == SAVE_OPT)
		    SaveSettings ("ENVARC:FetchRefs_GI.prefs");
		SaveSettings ("ENV:FetchRefs_GI.prefs");

	    case CANCEL_OPT:
		LT_DeleteHandle (OptionsPrj);
		OptionsPrj = NULL;
		LT_SetAttributes (MainPrj, SCAN_NEWREF, GA_Disabled, FALSE, TAG_END);
		break;

	    case SAVEAS_OPT:
		if (rtFileRequest (PrefsFileReq, prefname, "Save settings...",
				  RTFI_Flags, FREQF_SAVE,	TAG_END))
		{
		    if (newdir = Lock (PrefsFileReq->Dir, SHARED_LOCK))
		    {

			/* As SaveSettings() uses the 'Settings' struct we
			 * need to fill it with the current settings even
			 * though they may still be Cancel'ed. Therefore we
			 * copy the original back. */
			CopyMem (&Settings, &tmpsettings, sizeof(struct Prefs));
			UpdateSettingsStruct ();
			olddir = CurrentDir (newdir);
			SaveSettings (prefname);
			CurrentDir (olddir);
			UnLock (newdir);
			CopyMem (&tmpsettings, &Settings, sizeof(struct Prefs));
		    }
		}
		break;

	    case LASTSAVED:
		/* We copy to 'tmpsettings' to be able to restore the
		 * original settings if Cancel is chosen. */
		CopyMem (&Settings, &tmpsettings, sizeof(struct Prefs));
		LoadSettings ("ENVARC:FetchRefs_GI.prefs");
		UpdateOptions ();
		CopyMem (&tmpsettings, &Settings, sizeof(struct Prefs));
		break;

	    case LOAD_OPT:
		if (rtFileRequest (PrefsFileReq, prefname, "Load settings...", TAG_END))
		{
		    if (newdir = Lock (PrefsFileReq->Dir, SHARED_LOCK))
		    {
			/* We copy to 'tmpsettings' to be able to restore the
			 * original settings if Cancel is chosen. By using a
			 * temporary variable only the state of the gadgets
			 * is changed. The change is not permanent until Use
			 * or Save is chosen. */
			CopyMem (&Settings, &tmpsettings, sizeof(struct Prefs));
			olddir = CurrentDir (newdir);
			LoadSettings (prefname);
			CurrentDir (olddir);
			UnLock (newdir);
			UpdateOptions ();
			CopyMem (&tmpsettings, &Settings, sizeof(struct Prefs));
		    }
		}
		break;

	    case AUTODOCS:
	    case C_INCLUDES:
	    case E_INCLUDES:
	    case ASM_INCLUDES:
		UpdateOptionsGhost ();
		break;
	}
    }
}

/* HandleGUI() */
void HandleGUI (void)
{
    struct IntuiMessage * Message, msg;
    ULONG classe;

    if (ScanStatPrj)
    {
	while (Message = LT_GetIMsg (ScanStatPrj))
	{   classe = Message->Class;
	    LT_ReplyIMsg (Message);
	    if (classe == IDCMP_GADGETUP)
	    {	StopScanning (TRUE);    break;  }
	}
    }

    while (Message = LT_GetIMsg (MainPrj))
    {
	memcpy (&msg, Message, sizeof(struct IntuiMessage));
	LT_ReplyIMsg (Message);
	if (! HandleMainprj (&msg))
	    GoOn = 0;
    }
    if (RefPrj)
	while (Message = LT_GetIMsg (RefPrj))
	{
	    memcpy (&msg, Message, sizeof(struct IntuiMessage));
	    LT_ReplyIMsg (Message);
	    HandleReferencesPrj (&msg);
	    if (! RefPrj)
		break;
	}

    if (OptionsPrj)
	while (Message = LT_GetIMsg (OptionsPrj))
	{
	    memcpy (&msg, Message, sizeof(struct IntuiMessage));
	    LT_ReplyIMsg (Message);
	    HandleOptionsPrj (&msg);
	    if (! OptionsPrj)
		break;
	}

    /* struct TR_Message *msg;

    while (msg = TR_GetMsg(Application))
    {
	if (msg->trm_Class == TRMS_HELP)
	{
	    struct Window *win;
	    struct Screen *scr;

	    if (win = MainPrj->Window)
	    {
		scr = win->WScreen;
		TR_ReleaseWindow (win);
	    } else
		scr = NULL;

	    GiveHelp (msg->trm_ID, scr);
	}
    } */

    /* Make sure that the user wants to quit */
    if ((! GoOn)  &&  (FileChanged))
    {
	LONG val;

	LockGUI();
	val = rtEZRequestTags ("There are changes!\nReally quit?",
		"_Save and quit|_Quit|_Cancel",
		NULL, NULL, RT_Underscore, '_', TAG_END);

	if (val == 0)
	    GoOn = TRUE;
	else if (val == 1)
	{
	    if (!SaveData(NULL))
		GoOn = TRUE;
	}
	UnlockGUI();
    }
}

/* NumOfNodes() */
ULONG NumOfNodes (struct List *l)
{
    struct Node * n = GetHead (l);
    ULONG cnt = 0;

    while (n->ln_Succ)
    {
	cnt++;
	n = n->ln_Succ;
    }
    return cnt;
}

/* SelectedMain() */
struct FileEntry * SelectedMain (void)
{
    struct FileEntry * f = 0;

    /* Find pointer to selected node in main listview */
    if (! IsListEmpty (&FileList))
    {
	long cnt = LT_GetAttributes (MainPrj, LISTE_REFERENCES, TAG_DONE);
	if (cnt >= 0)
	{
	    f = (struct FileEntry *) GetHead (&FileList);
	    while (cnt--)
		f = GetSucc (f);
	}
    }
    return f;
}

/* SelectedRef() */
struct RefsEntry * SelectedRef (void)
{
    struct FileEntry * f = SelectedMain();
    struct RefsEntry * r = 0;

    /* Find pointer to selected node in main listview */
    if ((f != NULL) && (! IsListEmpty(&f->data.RefsList)))
    {
	long cnt = LT_GetAttributes (RefPrj, INPUT_REFERENCES, TAG_DONE);
	if (cnt >= 0)
	{
	    r = (struct RefsEntry *) GetHead (&f->data.RefsList);
	    while (cnt--)
		r = GetSucc (r);
	}
    }
    return r;
}

/* GoGUI() */
void GoGUI (void)
{
    ULONG signaux;

    if (DataFileReq = rtAllocRequestA (RT_FILEREQ, NULL))
    {
	if (AddFileReq = rtAllocRequestA (RT_FILEREQ, NULL))
	{
	    rtChangeReqAttr (AddFileReq, RTFI_MatchPat, "~(#?.(guide|a|c|e|o))", TAG_END);

	    if (PrefsFileReq = rtAllocRequestA (RT_FILEREQ, NULL))
	    {
		/* Load a data file if any is specified by tool types/Shell arguments */
		if (DataName[0])
		{
		    STRPTR p;

		    LoadData (DataName);
		    p = PathPart (DataName);

		    /* If a path is specified we split up in path and file name */
		    if (p  !=  DataName)
		    {
			UBYTE c = *p;
			*p = 0;
			rtChangeReqAttr (DataFileReq, RTFI_Dir, DataName, TAG_END);
			*p = c;
			strcpy (DataName, FilePart(DataName));
		    }
		}

		MainPrj = CreateMainWindow ();
		if (MainPrj)
		{
		    UpdateMain ();

		    while (GoOn)
		    {	signaux = (1 << MainPrj->Window->UserPort->mp_SigBit);
			if (ScanStatPrj)
			    signaux |= (1 << ScanStatPrj->Window->UserPort->mp_SigBit);
			if (OptionsPrj)
			    signaux |= (1 << OptionsPrj->Window->UserPort->mp_SigBit);
			if (RefPrj)
			    signaux |= (1 << RefPrj->Window->UserPort->mp_SigBit);
			Wait (signaux);
			HandleGUI ();
		    }
		    LT_DeleteHandle (MainPrj);
		    MainPrj = 0;
		}
	    }
	}
    }
    CloseGUI ();
}

/* CloseGUI() */
void CloseGUI (void)
{
    if (ReqToolsBase)
    {
	rtFreeRequest (DataFileReq);
	rtFreeRequest (AddFileReq);
	rtFreeRequest (PrefsFileReq);
    }

    if (GTLayoutBase)
    {
	if (MainPrj)
	    LT_DeleteHandle (MainPrj);
	if (RefPrj)
	    LT_DeleteHandle (RefPrj);
	if (OptionsPrj)
	    LT_DeleteHandle (OptionsPrj);
    }
}
