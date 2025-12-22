/*
** $PROJECT: XRef-Tools
**
** $VER: aguidexref.h 0.1 (07.08.94)
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1994
** All Rights Reserved !
**
** $HISTORY:
**
** 07.08.94 : 000.001 :  initial
*/

/* ------------------------------- includes ------------------------------- */

#include "Def.h"

#include <libraries/xref.h>
#include <clib/xref_protos.h>
#include <pragmas/xref_pragmas.h>

#include <debug.h>
#include <register.h>

#include "/lib/xrefsupport.h"

#include <graphics/gfxbase.h>

/* ------------------------------- defines -------------------------------- */

#define PATH_LEN                 256
#define MAIN_LEN                 128
#define TEMP_LEN                 128

#define STRING_LEN               256
#define CATEGORY_LEN              40

#define PUDDLE_SIZE              2048
#define TRESH_SIZE               PUDDLE_SIZE

/* ------------------------------ Prototypes ------------------------------ */

STRPTR tmpname(struct GlobalData *gd);
void insertbyname(struct List *list,struct Node *node);
BOOL parsexref(struct GlobalData *gd);
void getstdargs(struct GlobalData *gd,ULONG *para);

extern char *prgname;
extern struct Library *SysBase;

/* ------------------------------ structures ------------------------------ */

struct Entry
{
   struct Node e_Node;
   LONG e_Type;
   STRPTR e_Name;
   STRPTR e_File;
   STRPTR e_Path;
   STRPTR e_NodeName;
   ULONG e_Line;
};

struct MenuDef
{
   UWORD md_MenuType;                  /* NewMenu type */
   ULONG md_MenuTextID;                /* textid for the appStrings[] array or 
                                        * -1 for barlabel */
   UWORD md_MenuFlags;                 /* MenuItem flags */
   UWORD md_MenuCmd;                   /* internal command number for execute_cmd() */
};

struct GlobalData
{
   STRPTR gd_XRefFile;                 /* xreffile for the parse */
   ULONG gd_Matching;                  /* matching for the parse */
   ULONG gd_Limit;                     /* limit for entries */

   BPTR gd_FileHandle;                 /* filehandle to write all xref links */

   struct Entry gd_LastEntry;          /* store entry, if only one is found */

   LONG gd_Num;                        /* actual number of xrefs */
   UWORD gd_Column;                    /* actual column */
   UWORD gd_LineLength;                /* maximal linelength */
   UWORD gd_Columns;                   /* number of columns to use */
   UWORD gd_Chars;                     /* chars for each column */

   STRPTR gd_Object;                   /* object, on which occured an error */
   ULONG gd_Error;                     /* an exiplict error , not en IoErr() */
   ULONG *gd_Para;                     /* link to the CLI args */
   ULONG gd_TempCount;                 /* counter for the tempory names */

   APTR gd_Pool;                       /* pool for sorting entries */
   struct List gd_EntryList;           /* list of all found entries */

   struct Screen *gd_Screen;           /* screen to open window */
   struct Window *gd_Window;           /* window for the amigaguide */

   UBYTE gd_FileBuffer[PATH_LEN];      /* filename buffer */
   UBYTE gd_MainBuffer[MAIN_LEN];      /* table of contents buffer */
   UBYTE gd_TempBuffer[TEMP_LEN];      /* tempory name buffer */

   UBYTE gd_String[STRING_LEN];        /* buffer for the string gadget */
   UBYTE gd_Category[CATEGORY_LEN];    /* buffer for the category */

   struct Library *gd_XRefBase;        /* library base for the xref.library */

#ifndef OSV37
   UBYTE gd_Directory[PATH_LEN];       /* directory to use */

   struct Library *gd_DataTypesBase;   /* library base for the datatypes.library */
   struct Library *gd_GadToolsBase;    /* library base for the gadtools.library */
   struct Library *gd_GfxBase;         /* library base for the graphics.library */
   struct Library *gd_DiskFontBase;    /* library base for the diskfont.library */
   struct Library *gd_AslBase;         /* library base for the asl.library */
   struct Library *gd_LocaleBase;      /* library base for the locale.library */

   struct Catalog *gd_Catalog;         /* locale catalog to use */

   BOOL gd_Running;                    /* aguidexref running ? */
   ULONG gd_Flags;                     /* some flags see below */

   struct DrawInfo *gd_DrawInfo;       /* screen drawinfo */
   APTR gd_VisualInfo;                 /* gadtools visualinfo structure */
   struct NewMenu *gd_NewMenu;         /* gadtools menu structure */
   struct Menu *gd_Menu;               /* menu for the window */

   Object *gd_AGObject;                /* AmigaGuide Object */
   BOOL gd_ObjectAdded;                /* object is added to the window */
   struct IBox gd_ObjectBox;           /* rectangle for the amigaguide object */

   struct NewGadget gd_NewGadget;      /* NewGadget struct for CreateGadgetA() */
   UWORD gd_OldFHeight;                /* old screen font height */

   ULONG gd_NumGadgets;                /* number os actual gadgets */

   struct Gadget *gd_FirstGadget;      /* Gadget Pointer for CreateGadgetA() */
   struct Gadget *gd_CategoryGad;      /* pointer to the category gadget */
   struct Gadget *gd_StringGad;        /* pointer to the string gadget */
   struct Image *gd_Images[4];         /* arrow button images */
   struct Gadget *gd_Buttons[4];       /* arrow button gadgets */
   struct Gadget *gd_HorizProp;        /* horizontal slider */
   struct Gadget *gd_VertProp;         /* vertical slider */

   struct TextFont *gd_TextFont;       /* pointer to the TextFont structure */
   struct TextAttr gd_TextAttr;        /* textfont to use for the datatype object */

   /* preference entries */

   UBYTE gd_FontName[MAXFONTNAME];     /* font to use */

   struct IBox gd_InitialRect;         /* initial window rectangle */
   struct IBox gd_WindowRect;          /* window rectangle */
   struct IBox gd_WindowAltRect;       /* window alternate rectangle */
#endif
};

#define GDF_FORCEFONT      (1<<0)      /* font is specified via ReadArgs(), thus
                                          don't use the font in the prefs file */
#define GDF_SYNC           (1<<1)      /* use DTA_Sync instead of the OM_UPDATE
                                          method */

/* redirect library bases to global data structure */

#define XRefBase                       gd->gd_XRefBase
#define DataTypesBase                  gd->gd_DataTypesBase
#define GadToolsBase                   gd->gd_GadToolsBase
#define GfxBase                        gd->gd_GfxBase
#define DiskFontBase                   gd->gd_DiskFontBase
#define AslBase                        gd->gd_AslBase
#define LocaleBase                     gd->gd_LocaleBase

