/* Official Amiga libraries */
#define __USE_SYSBASE
#include <proto/amigaguide.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/gadtools.h>
#include <proto/graphics.h>
#include <proto/icon.h>
#include <proto/intuition.h>
#include <proto/reqtools.h>
#include <proto/utility.h>
#include <clib/alib_protos.h>

#include <proto/reqtools.h>
#include <proto/sortlist.h>
#include <pragmas/locale_pragmas.h>
#include <proto/gtlayout_protos.h>
#include <pragmas/gtlayout_pragmas.h>
#include <libraries/gtlayout.h>
#include <libraries/reqtools.h>

/* Misc stuff */
#include <exec/memory.h>
#include <workbench/startup.h>

#include <ctype.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "protos.h"

#define VERSION "2.0"
#define DATE __AMIGADATE__

/* Error value passed to CloseAll() when a custom text is passed */
#define ERROR_CUSTOM 1

extern struct List FileList, EmptyList;
extern struct rtFileRequester *DataFileReq;

extern UBYTE DataName[256];
extern BOOL FileChanged;

enum FileTypes { FILE_UNKNOWN, FILE_AUTODOC, FILE_C, FILE_E, FILE_ASM,
    FILE_EMODULE, FILE_AMIGAGUIDE };

/* This is just a number; structs are allocated depending on actual length */
#define MAX_STRING_LENGTH 50000

struct FileEntry {
    union {

	/* This structure contains special data only needed when saved.
	 * Upon loading it is replaced by the linking Node structure.
	 */
	struct {
	    LONG NodeSize;
	} savedata;

	struct Node node;
    };

    union {
	char FileData[1];      /* Just for referencing - never used */

	/* The real data, pointed to by FileData */
	struct {
	    struct List RefsList;
	    UBYTE Name[MAX_STRING_LENGTH];
	} data;
    };

};

/* This structure is used to read files in memory (FileEntry headers) */
struct File_Entry {
    union {
	long NodeSize;
	struct Node node;
    };
};

#define sizeofFileEntry (sizeof(struct FileEntry) - MAX_STRING_LENGTH)

struct RefsEntry {
   union {
       struct {
	   LONG NodeSize;
       } savedata;

       struct Node node;
   };

   union {
       char RefsData[1];    /* Just for referencing the real data */

       /* This is the real data */
       struct {
	    LONG Offset;
	    LONG Length;
	    WORD Goto;
	    UBYTE Name[MAX_STRING_LENGTH];
	} data;
    };
};
#define sizeofRefsEntry (sizeof(struct RefsEntry) - MAX_STRING_LENGTH)

/// Settings struct
struct Prefs {
    struct {
	BYTE Active;
    } AutoDocPrf;

    struct {
	BYTE Active;
	BYTE Define;
	BYTE Struct;
	BYTE Typedef;
    } CPrf;

    struct {
	BYTE Active;
	BYTE Const;
	BYTE Object;
	BYTE Proc;
    } EPrf;

    struct {
	BYTE Active;
	BYTE Equ;
	BYTE Structure;
	BYTE Macro;
    } AsmPrf;

    BYTE Recursively;
    BYTE KeepEmpty;
    BYTE UnknownAsAutoDoc;
};
extern struct Prefs Settings;
///

/// Triton IDs
enum {
    WINDOW_MAIN_ID = 1,
    WINDOW_REF_ID,
    WINDOW_OPTIONS_ID,
    WINDOW_SCANSTAT_ID,

    MAIN_MENU_PROJECT_CLEAR,
    MAIN_MENU_PROJECT_LOAD,
    MAIN_MENU_PROJECT_SAVE,
    MAIN_MENU_PROJECT_ABOUT,
    MAIN_MENU_PROJECT_QUIT,

    MAIN_LIST_ID,
    MAIN_REFERENCES_ID,
    MAIN_OPENREFWINDOW_ID,
    MAIN_SCAN_ID,
    MAIN_DELETE_ID,
    MAIN_OPTIONS_ID,
    MAIN_RESCAN_ID,
    MAIN_RESCANALL_ID,

    REF_LIST_ID,
    REF_FILE_ID,
    REF_OFFSET_ID,
    REF_LENGTH_ID,
    REF_GOTO_ID,
    REF_DELETE_ID,

    OPTIONS_MENU_PROJECT_OPEN_ID,
    OPTIONS_MENU_PROJECT_SAVEAS_ID,
    OPTIONS_MENU_PROJECT_LASTSAVED_ID,

    OPTIONS_AUTODOC_ID,

    OPTIONS_C_ID,
    OPTIONS_C_DEFINE_ID,
    OPTIONS_C_STRUCT_ID,
    OPTIONS_C_TYPEDEF_ID,

    OPTIONS_E_ID,
    OPTIONS_E_CONST_ID,
    OPTIONS_E_OBJECT_ID,
    OPTIONS_E_PROC_ID,

    OPTIONS_ASM_ID,
    OPTIONS_ASM_EQU_ID,
    OPTIONS_ASM_STRUCTURE_ID,
    OPTIONS_ASM_MACRO_ID,

    OPTIONS_RECURSIVELY_ID,
    OPTIONS_KEEPEMPTY_ID,
    OPTIONS_UNKNOWNASAUTODOC_ID,

    OPTIONS_SAVE_ID,
    OPTIONS_USE_ID,
    OPTIONS_CANCEL_ID,

    SCANSTAT_STOP_ID,
};
///
