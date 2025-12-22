#include "GenerateIndex.h"

extern struct WBStartup *_WBenchMsg;

const UBYTE VersTag[] = "$VER: GenerateIndex " VERSION " " DATE;

UBYTE Template[] =  "FROM/M,TO,SETTINGS,"
		    "RECURSIVELY/S,KEEPEMPTY/S,UNRECOGAREDOCS/S,"
		    "AUTODOC/S,"
		    "C/S,C_DEFINE/S,C_STRUCT/S,C_TYPEDEF/S,"
		    "E/S,E_CONST/S,E_OBJECT/S,E_PROC/S,"
		    "ASM/S,ASM_EQU/S,ASM_STRUCTURE/S,ASM_MACRO/S";

UBYTE CLI_Help[] = "\n"
		   "GenerateIndex [[FROM] {wildcard}] [TO <file>] [SETTINGS <file>]\n"
		   "\t[RECURSIVELY] [KEEPEMPTY] [UNRECOGAREDOCS]\n"
		   "\t[AUTODOC]\n"
		   "\t[C] [C_DEFINE] [C_STRUCT] [C_TYPEDEF]\n"
		   "\t[E] [E_CONST] [E_OBJECT] [E_PROC]\n"
		   "\t[ASM] [ASM_EQU] [ASM_STRUCTURE] [ASM_MACRO]\n"
		   "\n"
		   "- Not specifying FROM will open the GUI (ReqTools and Triton required)\n"
		   "- A script is handy for Shell usage\n"
		   "- Study the guide for more information\n"
		   "\n";

/* Structure for ReadArgs() to return parsed arguments into */
struct {
    STRPTR (*From)[];
    STRPTR To;
    STRPTR Settings;
    LONG Recursively, KeepEmpty, UnrecogAreDocs;
    LONG AutoDoc;
    LONG C_Active, C_Define, C_Struct, C_Typedef;
    LONG E_Active, E_Const, E_Object, E_Proc;
    LONG Asm_Active, Asm_Equ, Asm_Structure, Asm_Macro;
} StartupArgs;

APTR catalog;
struct List FileList, EmptyList;
struct RDArgs *Args;
struct ReqToolsBase * ReqToolsBase;
struct Library * GTLayoutBase, * LocaleBase;

UBYTE DataName[256];

/* __main() -- handle parsing of WB/Shell arguments */
long main (long argc, char ** argv)
{
    ReqToolsBase = (struct ReqToolsBase *) OpenLibrary ("reqtools.library", 38);
    if (! ReqToolsBase)
	CloseAll (ERROR_CUSTOM, "You need ReqTools version 38+ for the GUI!");

    GTLayoutBase = OpenLibrary ("gtlayout.library", 39);
    if (! GTLayoutBase)
	CloseAll (ERROR_CUSTOM, "You need gtlayout.library version 39+ for the GUI!");

    /* This will initialize the list (FileList) and create a pool (FilePool) */
    InitializeFileList();       /* voir lists.c */
    NewList (&EmptyList);

    if (LocaleBase = OpenLibrary ("locale.library",38))
	catalog = OpenCatalog (NULL, "GenerateIndex.catalog", OC_Version, 1, TAG_DONE);

    if (_WBenchMsg)
    {
	struct DiskObject *diskobj;

	CurrentDir (_WBenchMsg->sm_ArgList->wa_Lock);
	if (diskobj = GetDiskObject (_WBenchMsg->sm_ArgList->wa_Name))
	{
	    STRPTR arg;

	    if (arg = FindToolType (diskobj->do_ToolTypes, "TO"))
		strncpy (DataName, arg, 255);

	    /* Load specified or default settings file */
	    arg = FindToolType (diskobj->do_ToolTypes, "SETTINGS");
	    LoadSettings (arg ? arg : (STRPTR) "ENV:FetchRefs_GI.prefs");

	    /* Release icon again */
	    FreeDiskObject (diskobj);

	    /* Open GUI */
	    GoGUI ();
	} else
	    CloseAll (IoErr());
    } else
    {
	if (Args = AllocDosObject (DOS_RDARGS, NULL))
	{
	    /* Activate extended help */
	    Args->RDA_ExtHelp = CLI_Help;

	    /* Parse arguments */
	    StartupArgs.From = (APTR)1;
	    if (ReadArgs(Template, (LONG *)&StartupArgs, Args))
	    {
		/* Minor hack to help PostMessage() */
		if (StartupArgs.From == (APTR) 1)
		    StartupArgs.From = NULL;

		/* Do not bother to start if the user pressed CTRL-C during
		 * load time or during a 'GenerateIndex ?' help session.
		 */
		if (CheckSignal (SIGBREAKF_CTRL_C))
		    CloseAll (0);

		/* Set options */
		if (StartupArgs.Settings)
		    LoadSettings (StartupArgs.Settings);
		else
		{
		    if (StartupArgs.AutoDoc)
			Settings.AutoDocPrf.Active = TRUE;

		    if (StartupArgs.C_Active)
			Settings.CPrf.Active = TRUE;
		    if (StartupArgs.C_Define)
			Settings.CPrf.Define = TRUE;
		    if (StartupArgs.C_Struct)
			Settings.CPrf.Struct = TRUE;
		    if (StartupArgs.C_Typedef)
			Settings.CPrf.Typedef = TRUE;

		    if (StartupArgs.E_Active)
			Settings.EPrf.Active = TRUE;
		    if (StartupArgs.E_Const)
			Settings.EPrf.Const = TRUE;
		    if (StartupArgs.E_Object)
			Settings.EPrf.Object = TRUE;
		    if (StartupArgs.E_Proc)
			Settings.EPrf.Proc = TRUE;

		    if (StartupArgs.Asm_Active)
			Settings.AsmPrf.Active = TRUE;
		    if (StartupArgs.Asm_Equ)
			Settings.AsmPrf.Equ = TRUE;
		    if (StartupArgs.Asm_Structure)
			Settings.AsmPrf.Structure = TRUE;
		    if (StartupArgs.Asm_Macro)
			Settings.AsmPrf.Macro = TRUE;

		    if (StartupArgs.Recursively)
			Settings.Recursively = TRUE;
		    if (StartupArgs.KeepEmpty)
			Settings.KeepEmpty = TRUE;
		    if (StartupArgs.UnrecogAreDocs)
			Settings.UnknownAsAutoDoc = TRUE;
		}

		if (StartupArgs.To)
		{
		    if	(! StartupArgs.From)
			strncpy (DataName, StartupArgs.To, 255);
		    else
			LoadData (StartupArgs.To);
		}

		if  (! StartupArgs.From)
		    GoGUI ();               /* voir GUI.c */
		else if (StartupArgs.To)
		{
		    /* Expand each wildcard (which can also be just a file)
		     * and generate index
		     */
		    ULONG count;
		    STRPTR path;
		    struct AnchorPath * fanchor;

		    if (fanchor = AllocVec (sizeof(struct AnchorPath) + 256, MEMF_CLEAR))
		    {
			fanchor->ap_Strlen = 256;
			for (count = 0; path = (*StartupArgs.From)[count]; count++)
			{
			    if (! MatchFirst (path, fanchor))
			    {
				do
				{
				    STRPTR name;

				    if (name = FullName (fanchor->ap_Buf))
				    {
					StartScanning();
					if (fanchor->ap_Info.fib_DirEntryType < 0)
					    IndexFile (name, "");
					else
					    IndexRecursive (fanchor->ap_Buf, "");
					StopScanning (TRUE);
					FreeVec (name);
				    } else
					CloseAll (IoErr());
				} while (! MatchNext (fanchor));
				MatchEnd (fanchor);
			    }
			}
			FreeVec (fanchor);

			/* Sort the scanned list and save it */
			SortExecList (&FileList, SortCompareFunc, NULL);
			SaveData (StartupArgs.To);
		    }
		    else
			CloseAll (ERROR_NO_FREE_STORE);
		 }
		 else
		    CloseAll (ERROR_REQUIRED_ARG_MISSING);
	    }
	    else
		CloseAll (IoErr());
	}
	else
	    CloseAll (ERROR_NO_FREE_STORE);
    }

    CloseAll (0);
}

/* CloseAll (LONG error [, STRPTR errtxt]) */
void CloseAll (LONG error, ...)
{
    STRPTR errtxt;
    va_list args;

    va_start (args, error);
    errtxt = *(STRPTR *) args;
    va_end (args);

    FreeFileList ();        /* voir lists.c */

    if (error)
    {
	if (error == ERROR_CUSTOM)
	    PostMessage (errtxt);
	else
	{
	    UBYTE errortxt[80];

	    Fault (error, "GenerateIndex", errortxt, 80);
	    PostMessage (errortxt);
	}
    }

    if (Args)
    {
	FreeArgs (Args);
	FreeDosObject (DOS_RDARGS, Args);
    }

    CloseLibrary (&ReqToolsBase->LibNode);
    CloseLibrary (GTLayoutBase);

    if (LocaleBase)
    {	CloseCatalog (catalog);
	CloseLibrary (LocaleBase);
    }
    exit (error ? 5 : 0);
}

/* LoadSettings() */
void LoadSettings (STRPTR file)
{
    BPTR f;

    if (f = Open (file, MODE_OLDFILE))
    {
	Read (f, &Settings, sizeof(Settings));
	Close (f);
    }
}

/* SaveSettings() */
void SaveSettings (STRPTR file)
{
    BPTR f;

    if (f = Open (file, MODE_NEWFILE))
    {
	Write (f, &Settings, sizeof(Settings));
	Close (f);
    }
}

/* PostMessage() - does its best to get a message through to the user */
void PostMessage (STRPTR fmt, ...)
{
    static struct EasyStruct msgreq =
    {
	sizeof(struct EasyStruct),
	0,
	"GenerateIndex " VERSION " by Anders Melchiorsen",
	NULL,
	"Okay"
    };

    va_list args;

    msgreq.es_TextFormat = fmt;
    va_start(args, fmt);

    /* Use a requester if the GUI is active */
    if ((_WBenchMsg) || (! StartupArgs.From))
    {
	if (ReqToolsBase)
	    rtEZRequestA (fmt, "Okay", NULL, args, NULL);
	else
	    EasyRequestArgs (NULL, &msgreq, NULL, args);
    }
    else
    {
	/* Print in Shell window */
	VPrintf (fmt, args);
	PutStr ("\n");
    }

    va_end (args);
}
