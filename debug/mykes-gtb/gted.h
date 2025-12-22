/*-- AutoRev header do NOT edit!
*
*   Program         :   GTEd.h
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   21-Sep-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   21-Sep-91     1.00            Header with very important definitions.
*
*-- REV_END --*/

#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <dos/dostags.h>
#include <dos/rdargs.h>
//#include <libraries/nofrag.h>
#include <libraries/commodities.h>
#include <libraries/gadtools.h>
#include <libraries/asl.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <intuition/sghooks.h>
#include <graphics/gfx.h>
#include <workbench/workbench.h>
#include <workbench/startup.h>
#include <workbench/icon.h>
#ifndef abs
#define abs
#endif
#include <stdio.h>
#include <fcntl.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>

#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/commodities_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/asl_protos.h>
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>
#include <clib/diskfont_protos.h>
#include <clib/icon_protos.h>

extern struct Library	*GadToolsBase;

#define GT_FILETYPE     ((ULONG)'GTED') /* file identifier */
#define GT_MAXLABEL     32L             /* max sourcelabel name */
#define GT_MAXLABELNAME 80L             /* max gadget text */
#define GT_VERSION      1L              /* file version */
#define PR_VERSION      1L              /* prefs version */

#define GT_TITLE        ((UBYTE *)"GadToolsBox v1.0 © 1991")

/*
 * --- This is the way NewGadget structures including it's
 * --- TagItems are stored.
 */
struct ExtNewGadget {
    struct ExtNewGadget *en_Next;       /* successor */
    struct ExtNewGadget *en_Prev;       /* predecessor */
    struct TagItem      *en_Tags;       /* NewGadget TagItems */
    struct Gadget       *en_Gadget;     /* The created gadget */
    struct NewGadget     en_NewGadget;  /* The NewGadget */
    UBYTE                en_SourceLabel[GT_MAXLABEL+1];   /* Source label */
    UBYTE                en_GadgetText[GT_MAXLABELNAME+1]; /* gadget text */
    ULONG                en_SpecialFlags;  /* special internal flags */
    UWORD                en_Kind;        /* NewGadget kind */
    UWORD                en_NumTags;     /* Number of tagitems */

    /*** Specials for the string and integer gadgets ***/
    LONG                 en_DefInt;      /* Default number */
    UBYTE               *en_DefString;   /* Default string */
    UWORD                en_MaxChars;    /* max # of chars */

    /*** Specials for the listview gadgets ***/
    struct List          en_Entries;     /* entries in the listview */
    UWORD                en_ScrollWidth; /* scroller width */
    UWORD                en_Spacing;     /* spacing mx & listview */

    /*** Specials for the cycle and mx gadgets ***/
    UBYTE               *en_Labels[25];  /* gadget labels max 25 for now */

    /*** Specials for the slider gadget ***/
    UBYTE               *en_LevelFormat; /* slider format string */

    /*** Specials for the palette gadget ***/
    UWORD                en_IndicatorSize; /* indicator size */

    /*** Specials for the scroller gadget ***/
    UWORD                en_ArrowSize; /* arrow size */
};

#define EGF_DISABLED     0x00000001     /* to indicate GA_Disabled tag */
#define EGF_USERLABEL    0x00000002     /* to indicate a user label */
#define EGF_CHECKED      0x00000004     /* to indicate checked state */
#define EGF_READONLY     0x00000008     /* to indicate read listview */
#define EGF_NOGADGETUP   0x00000010     /* to indicate no RelVerify */
#define EGF_ISLOCKED     0x00000020     /* to indicate gadget locked */
#define EGF_NEEDLOCK     0x00000040     /* to indicate gadget lock */

/*
 * --- This is really a MinList structured for the ExtNewGadgets.
 */
struct ExtGadgetList {
    struct ExtNewGadget *gl_First;   /* First in the list */
    struct ExtNewGadget *gl_EndMark; /* End marker */
    struct ExtNewGadget *gl_Last;    /* Last in the list  */
};

/*
 * --- This is the way the NewMenu structures are strored.
 */
struct ExtNewMenu {
    struct ExtNewMenu   *em_Next;       /* successor */
    struct ExtNewMenu   *em_Prev;       /* predecessor */
    UBYTE                em_Bull0;      /* not used */
    BYTE                 em_Bull1;      /* not used */
    UBYTE               *em_NodeName;   /* used in listview */
    struct NewMenu       em_NewMenu;    /* the NewMenu itself */
    BYTE                 em_TheMenuName[GT_MAXLABELNAME+1]; /* Menu text */
    ULONG                em_SpecialFlags; /* special internal flags */
    struct ExtMenuList  *em_Items; /* this menu it's items */
    BOOL                 em_Dummy; /* specify dummy item */
    UBYTE                em_ShortCut[2]; /* keboard short-cut */
    UWORD                em_NumSlaves; /* for binary file */
};

#define EMF_HASDUMMY     0x00000001 /* this specifies menu has no items */

/*
 * --- This is really a MinList structured for the ExtNewMenus.
 */
struct ExtMenuList {
    struct ExtNewMenu   *ml_First;    /* First in the list */
    struct ExtNewMenu   *ml_EndMark;  /* End marker */
    struct ExtNewMenu   *ml_Last;     /* Last in the list */
};

/*
 * --- This data is written before all gadgets and/or menus.
 */
struct BinHeader {
    /*** miscelanious info ***/
    ULONG                bh_FileType;       /* file identification */
    UWORD                bh_Version;        /* file version */
    ULONG                bh_Flags0;         /* flags */
    ULONG                bh_Flags1;         /* flags */
    UWORD                bh_ActiveKind;     /* kind edited last */
    UWORD                bh_SpareSlots[10]; /* future! */

    /*** Used font ***/
    UBYTE                bh_FontName[80];   /* font name */
    struct TextAttr      bh_Font;           /* used font */

    /*** Screen info ***/
    UBYTE                bh_ScreenTitle[80]; /* screen title */
    struct TagItem       bh_ScreenTags[13];  /* screen tags */
    struct TagItem       bh_ScreenExt[10];   /* extended tags */
    struct ColorSpec     bh_Colors[33];      /* color specs */
    UWORD                bh_DriPens[NUMDRIPENS + 1]; /* screen dripens */
    ULONG                bh_ScreenSpare[10]; /* future! */

    /*** Window info ***/
    UBYTE                bh_WindowTitle[80]; /* window title */
    struct TagItem       bh_WindowTags[14];  /* window tags */
    struct TagItem       bh_WindowExt[10];   /* extended tags */
    WORD                 bh_Zoom[4];         /* zoom positions */
    UWORD                bh_MouseQueue;      /* max mouse queue */
    UWORD                bh_RptQueue;        /* max key queue */
    ULONG                bh_IDCMP;           /* user IDCMP */
    ULONG                bh_Flags;           /* user flags */
};

/*
 * --- Binary file flags concerning window extended tags flags
 */
#define BHF_INNERWIDTH      0x00000001 /* WA_InnerWidth tag */
#define BHF_INNERHEIGHT     0x00000002 /* WA_InnerHeight tag */
#define BHF_ZOOM            0x00000004 /* WA_Zoom tag */
#define BHF_MOUSEQUEUE      0x00000008 /* WA_MouseQueue tag */
#define BHF_RPTQUEUE        0x00000010 /* WA_RptQueue tag */
#define BHF_AUTOADJUST      0x00000020 /* WA_AutoAdjust tag */

/*
 * --- Binary file flags concerning screen extended tags flags
 */
#define BHF_AUTOSCROLL      0x00010000 /* SA_AutoScroll tag */
#define BHF_WBENCH          0x00020000 /* source uses workbench screen */
#define BHF_PUBLIC          0x00040000 /* source uses def. public screen */
#define BHF_CUSTOM          0x00080000 /* custom screen */

/*
 * --- The preferences structure. This data will definitly
 * --- change!!!!!
 */
struct Prefs {
    UWORD                pr_Version;        /* prefs version */
    ULONG                pr_PrefFlags0;     /* flags */
    ULONG                pr_PrefFlags1;     /* flags */
    UWORD                pr_CountIDFrom;    /* Begin ID count from this */
    UBYTE                pr_ProjectPrefix[5];  /* Label prefix */
   /*
    struct ColorSpec     pr_Colors[33];
    */
};

#define PRF_STATIC       0x00000001         /* generate static structures */
#define PRF_RAW          0x00000002         /* generate raw assem source */
#define PRF_COORDS       0x00000004         /* coordinates */
#define PRF_WRITEICON    0x00000008         /* write icon */

/*
 * --- A special node to use with ListView gadgets. This structure has
 * --- four 32-bit slots for extra data plus 100 bytes for the node name.
 */
struct ListViewNode {
    struct ListViewNode *ln_Succ;   /* successor */
    struct ListViewNode *ln_Pred;   /* predecessor */
    UBYTE                ln_Type;   /* bull */
    BYTE                 ln_Pri;    /* bull */
    char                *ln_Name;   /* points to ln_NameBytes[0] */
    ULONG                ln_UserData[4];  /* userdata slots */
    UBYTE                ln_NameBytes[100]; /* the node name */
};


