#ifndef IEDITOR_H
#define IEDITOR_H

/*
** InterfaceEditor definitions' file     **
**                                       **
** ©1994-1996 Simone Tellini             **
** All Rights Reserved                   **
**                                       **
** $VER: IEditor_Include 3.12 (5.12.96)  **
*/


#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef  EXEC_LISTS_H
#include <exec/lists.h>
#endif
#ifndef EXEC_NODES_H
#include <exec/nodes.h>
#endif
#ifndef GRAPHICS_TEXT_H
#include <graphics/text.h>
#endif




/***********************************
**  Values for Alloc/Free Object  **
***********************************/

#define     IE_WINDOW                   0
#define     IE_GADGET                   1
#define     IE_BOOLEAN                  2
#define     IE_ITEM                     3
#define     IE_BEVELBOX                 4
#define     IE_WNDIMAGE                 5
#define     IE_INTUITEXT                6
#define     IE_IMAGE                    7
#define     IE_MENUSUB                  8
#define     IE_MENUITEM                 9
#define     IE_MENUTITLE               10
#define     IE_REXXCMD                 11
#define     IE_WNDTOOPEN               12
#define     IE_LIBRARY                 13
#define     IE_GADGETBANK              14
#define     IE_BGADGET                 15
#define     IE_BOOPSI                  16
#define     IE_BTAG                    17
#define     IE_LOCALE_STRING           18
#define     IE_LOCALE_LANGUAGE         19
#define     IE_LOCALE_TRANSLATION      20
#define     IE_ARRAY_NODE              21

#define     IE_LASTOBJ                 21


/****************
**  Expanders  **
****************/



#define MIN_IEX_ID  15      // minimum ID for an expander

struct IEXNode {
	struct Node         Node;
	struct Expander    *Base;
	ULONG               ID;
	STRPTR              Support;
	UWORD               UseCount;
	struct Node         Copy;
};


/*
    Structure passed to AddARexxCmd

    AddARexxCmd will make a copy of the structure, which can be then
    reused.
*/

struct ExCmdNode {
	struct Node Node;
	STRPTR      Template;
	ULONG       ( *Routine )( __A0 ULONG *, __A1 struct RexxMsg *, __A2 struct IE_Data *, __D0 ULONG );
			      /*  ArgArray      RexxMsg                IE Data                ID   */
	ULONG       ID; /* leave empty */
};




/***********************************************
**  Functions called by the source generator  **
***********************************************/

struct IEXSrcFun {
	/*  write the globals variable */
	void    ( *Globals )( __A0 struct GenFiles * );
	/*  called in the GUI Setup function  */
	void    ( *Setup )( __A0 struct GenFiles * );
	/*  called in the GUI CloseDown function  */
	void    ( *CloseDown )( __A0 struct GenFiles * );
	/*  write the headers  */
	void    ( *Headers )( __A0 struct GenFiles * );
	/*  called in the Render routine  */
	void    ( *RenderMinusZero )( __A0 struct GenFiles * );
	void    ( *RenderPlusZero )( __A0 struct GenFiles * );
	/*  OR the IDCMP passed with the ones you need  */
	ULONG   ( *IDCMP )( __D0 ULONG );
	/*  write your data  */
	void    ( *Data )( __A0 struct GenFiles * );
	/*  write your chip data  */
	void    ( *ChipData )( __A0 struct GenFiles * );
	/*  write your support routine(s) (if needed)  */
	void    ( *Support )( __A0 struct GenFiles * );
	/*  called in the Open<Window Label>Window routine  */
	void    ( *OpenWnd )( __A0 struct GenFiles * );
	/*  called in the Close<Window Label>Window routine  */
	void    ( *CloseWnd )( __A0 struct GenFiles * );
};


/**************************************
**  Support functions for expanders  **
**************************************/

struct IEXFun {
	/* Args:  UBYTE *Buffer                    */
	void        ( *SplitLines )( __A0 UBYTE * );

	/* Args:  UBYTE *Buffer, STRPTR ID_string  */
	STRPTR      ( *GetFirstLine )( __A0 UBYTE *, __A1 STRPTR );

	/* Args:  BPTR File, STRPTR String, struct Descriptor *Descriptors */
	void        ( *WriteFormatted )( __D0 BPTR, __A0 STRPTR, __A1 struct Descriptor * );

	/* Args:  struct Expander *IEXBase, struct Node *GadgetKind */
	BOOL        ( *AddGadgetKind )( __A0 struct Expander *, __A1 struct Node * );

	/* Args:  struct ExCmdNode *Command  */
	BOOL        ( *AddARexxCmd )( __A0 struct ExCmdNode * );
};


/*********************************************
**  Support functions for external modules  **
*********************************************/

struct MiscFun {

	/* Args: struct TextAttr *FontToAdd                 */
	struct TxtAttrNode *( *AddFont )( __A0 struct TextAttr * );

	/* Args: UBYTE *Text, BOOL Beep, ULONG CatNumber    */
	/* Text - Will be displayed in IE's status bar      */
	/* Beep - Set to TRUE if it is a warning message    */
	/* CatNumber - Leave to 0                           */
	void                ( *Status )( __A0 UBYTE *, __D0 BOOL, __D1 ULONG );

	/* Args: struct TxtAttrNode *FontToRemove           */
	void                ( *RemoveFont )( __A0 struct TxtAttrNode * );

	/* Args:  UWORD Object type, see above              */
	APTR                ( *AllocObject )( __D0 UWORD );
	/* Args:  APTR Object, UWORD Object type            */
	void                ( *FreeObject  )( __A0 APTR, __D0 UWORD );

	/* No Args:                                         */
	struct GadgetInfo  *( *GetGadget )( void );

	/* Args:  struct MinList *Strings,  STRPTR String   */
	struct LocaleStr   *( *FindString )( __A0 struct MinList *, __A1 STRPTR );

	/* Args:  struct MinList *Array, struct MinList *Array  */
	struct ArrayNode   *( *FindArray )( __A0 struct MinList *, __A1 struct MinList * );
};





/*******************************
**  Internal data structures  **
*******************************/

struct LocaleData {
	STRPTR          Catalog;    /*  the name of the catalog to create  */
	STRPTR          JoinFile;   /*  the file to prepend                */
	STRPTR          BuiltIn;    /*  built-in language                  */
	ULONG           Version;    /*  minimum catalog version required   */
	struct MinList  ExtraStrings; /*  strings to put in the cd         */
	struct MinList  Languages;  /*  catalog translations to create     */
	struct MinList  Translations;
	struct MinList  Arrays;
};

struct LocaleStr {
	struct Node     Node;
	struct MinList  Translations;
	TEXT            ID[30];
	TEXT            String[1024];
};

#define LOC_GUI     (1 << 0)        /* the strings is part of the GUI */
#define LOC_FREE    (1 << 1)

struct LocaleLanguage {
	struct Node     Node;
	TEXT            Language[60];
	TEXT            File[256];
};

struct LocaleTranslation {
	struct Node     Node;
	STRPTR          Original;
	STRPTR          String;
};


struct ArrayNode {
	    struct ArrayNode   *Next;
	    struct ArrayNode   *Prev;
	    UBYTE             **Array;
	    UBYTE               Label[80];
};



/***************************
**       Screen Info      **
***************************/

struct ScreenInfo {
	APTR                Visual;     /* VisualInfo of IE's screen */
	UWORD               YOffset;
	struct TextAttr     NewFont;
	UWORD               ScrAttrs;   /* see below SC_xxx */
	UWORD               St_Left;
	UWORD               St_Top;
	UWORD               Type;
	UBYTE              *FontScr;
	UBYTE              *Title;
	UBYTE              *PubName;
	ULONG              *Tags;       /* point to a TagItem array */
					/* at the end of the file   */
					/* you'll find the index to */
					/* access the data          */
	UWORD              *DriPens;    /* 12 dripens               */
	struct Screen      *Screen;
	UWORD               XOffset;
};


struct IE_Data {
	UBYTE               flags;              /*  various flags  */
	UBYTE               flags_2;            /*  see below      */
	UBYTE               mainprefs;
	UBYTE               SrcFlags;
	UBYTE               MainProcFlags;
	UBYTE               AsmPrefs;
	UBYTE               AsmPrefs2;
	UBYTE               C_Prefs;
	struct GadgetInfo  *gad_id;             /* last selected gadget */
	struct Window      *win_active;         /* active window        */
	struct WindowInfo  *win_info;           /* active window info   */
	APTR                colortable;
	UWORD               win_open;
	UWORD               num_win;
	struct MinList      win_list;           /* window list */
	struct MinList      FntLst;             /* font list   */
	UWORD               NumImgs;
	struct MinList      Img_List;           /* images list */
	UBYTE              *ScreenName;         /* ^ to my pub name */
	UBYTE              *ARexxPortName;
	UWORD               NumLibs;
	struct MinList      Libs_List;          /* libraries to open */
	UWORD               NumWndTO;
	struct MinList      WndTO_List;         /* windows to open   */
	UWORD               NumRexxs;
	struct MinList      Rexx_List;          /* rexx commands     */
	struct ScreenInfo  *ScreenData;
	struct MiscFun     *Functions;
	UBYTE              *RexxExt;
	UBYTE              *RexxPortName;
	UBYTE              *ExtraProc;
	struct UserData    *User;
	UBYTE              *ChipString;         /* prefs for the */
						/* Asm generator */
	UBYTE              *IntString;
	UBYTE              *DosString;
	UBYTE              *GfxString;
	UBYTE              *GadString;
	UBYTE              *FntString;
	UBYTE              *RexxString;
	struct LocaleData  *Locale;
	struct IEXFun      *IEXFun;             /* for expanders */
	APTR                UserData;           /* for expanders */
	struct MinList      Expanders;
	struct IEXSrcFun   *IEXSrcFun;          /* used by generators */
	UBYTE              *SharedPort;
};


/***************
**  ScrAttrs  **
***************/

#define SC_LEFT             (1<<0)
#define SC_TOP              (1<<1)
#define SC_SHOWTITLE        (1<<2)
#define SC_BEHIND           (1<<3)
#define SC_QUIET            (1<<4)
#define SC_OVERSCAN         (1<<5)
#define SC_FULLPALETTE      (1<<6)
#define SC_ERRORCODE        (1<<7)
#define SC_DRAGGABLE        (1<<8)
#define SC_EXCLUSIVE        (1<<9)
#define SC_SHAREPENS        (1<<10)
#define SC_INTERLEAVED      (1<<11)
#define SC_LIKEWORKBENCH    (1<<12)
#define SC_MINIMIZEISG      (1<<13)
#define SC_LOC_TITLE        (1<<14)     /*  Localize the screen title  */



struct UserData {
	STRPTR  Name;
	ULONG   Number;
};



struct GadgetBank {
	struct Node     Node;
	struct MinList  Gadgets;        /*  list of BGadget nodes   */
	TEXT            Label[ 60 ];
	struct MinList  Storage;        /*  List of the gadgets of  */
					/*  the bank that can be    */
					/*  used by generators      */
	UWORD           Count;          /*  # of stored gadgets     */
};

struct BGadget {
	struct BGadget     *Succ;
	struct BGadget     *Pred;
	struct GadgetInfo  *Gadget;
};


/* GadgetBank flags (stored in Node.ln_Type) */

#define GB_ONOPEN       (1<<0)  /* attach when opening the window */
#define GB_REATTACH     (1<<1)  /*  PRIVATE  */
#define GB_ATTACHED     (1<<2)  /* currently attached             */



/*****************
**  WindowInfo  **
*****************/


struct WindowInfo {
	APTR    wi_succ;
	APTR    wi_pred;
	UBYTE   wi_flags1;             /* see below  */
	UBYTE   wi_flags2;
	UBYTE  *wi_name;               /* point to Titolo  */
	struct Window *wi_winptr;      /* Window ^  */
	WORD    wi_Top;                /* window data  */
	WORD    wi_Left;
	UWORD   wi_Width;
	UWORD   wi_Height;
	WORD    wi_MinWidth;
	WORD    wi_MaxWidth;
	WORD    wi_MinHeight;
	WORD    wi_MaxHeight;
	UWORD   wi_InnerWidth;
	UWORD   wi_InnerHeight;
	WORD    wi_ZLeft;              /* zoom  */
	WORD    wi_ZTop;
	UWORD   wi_ZWidth;
	UWORD   wi_ZHeight;
	UWORD   wi_MouseQueue;
	UWORD   wi_RptQueue;
	ULONG   wi_Flags;
	ULONG   wi_IDCMP;
	ULONG   wi_Tags;               /* tags packed  */
	UBYTE   wi_Titolo[120];
	UBYTE   wi_TitoloSchermo[120];
	UBYTE   wi_Label[40];
	struct Gadget *wi_GList;       /* private  */
	UWORD   wi_NumGads;            /* # of gadgets in this window  */
	struct  MinList wi_Gadgets;
	UWORD   wi_NumMenus;           /* # of menus  */
	struct  MinList wi_Menus;
	UWORD   wi_GadTypes[13];
	UWORD   wi_NumBools;           /* # of boolean gadgets  */
	UWORD   wi_NumKeys;            /* # of gadget activation keys  */
	UWORD   wi_NumBoxes;           /* # of bevel boxes  */
	struct  MinList wi_Boxes;
	UWORD   wi_NumImages;
	struct  MinList wi_Images;
	UWORD   wi_NumTexts;
	struct  MinList wi_ITexts;
	APTR    wi_Lock;               /*  *** PRIVATE ***  */
	UWORD   wi_NumObjects;         /* # of external objects */
	UWORD   wi_NeedRender;         /* this window needs a Render routine */
	UWORD   wi_NewGadID;           /*  *** PRIVATE ***  */
	BOOL    wi_NoOpenWnd;          /* don't write the Open<label>Window */
				       /* routine. It'll be written by an   */
				       /* external module.                  */
	UBYTE   wi_pad;
	struct  MinList wi_GBanks;     /* Gadget banks */
	UWORD   wi_NumGBanks;
};


/*****************************
**  Window Flags  (flags1)  **
*****************************/

#define W_APERTA        (1<<0)      /* currently open  */
#define W_USA_INNER_W   (1<<1)      /* use InnerWidth in the src  */
#define W_USA_INNER_H   (1<<2)      /* use InnerHeight in the src  */
#define W_RIAPRI        (1<<3)      /* private  */

/******************
**  Window Tags  **
******************/

#define W_SCREENTITLE   (1<<1)
#define W_MOUSEQUEUE    (1<<2)
#define W_RPTQUEUE      (1<<3)
#define W_AUTOADJUST    (1<<4)
#define W_FALLBACK      (1<<5)
#define W_ZOOM          (1<<6)
#define W_TABLETMESSAGE (1<<7)
#define W_MENUHELP      (1<<8)
#define W_NOTIFYDEPTH   (1<<9)
#define W_SHARED_PORT   (1<<10)     /* use the shared port */
#define W_BACKFILL      (1<<11)

#define W_LOC_TITLE     (1<<31)     /* localize its title  */
#define W_LOC_SCRTITLE  (1<<30)     /* localize its screen title  */
#define W_LOC_GADGETS   (1<<29)     /* localize its gadgets  */
#define W_LOC_TEXTS     (1<<28)     /* localize its intuitexts  */
#define W_LOC_MENUS     (1<<27)     /* localize its menus  */


/* Menu Flags  ; not implemented yet

; MF_NEWLOOK    EQU     0
; MF_ERROR      EQU     1
; MF_FRONTPEN   EQU     2

*/

struct WndImages {
	APTR                wim_Next;
	APTR                wim_Prev;
	WORD                wim_Left;
	WORD                wim_Top;
	UWORD               wim_Width;
	UWORD               wim_Height;
	UWORD               wim_Depth;
	APTR                wim_Data;       /* ^ to image raw data  */
	UBYTE               wim_PlanePick;
	UBYTE               wim_PlaneOnOff;
	APTR                wim_NextImage;  /* ^ to next image  */
	struct ImageNode   *wim_ImageNode;  /* ^ to the original image node */
};


struct TxtAttrNode {
	APTR    txa_Next;
	APTR    txa_Prev;
	APTR    txa_Ptr;
	UWORD   txa_OpenCnt;
	STRPTR  txa_FontName;   /* points to txa_Name...  */
	UWORD   txa_Size;
	UBYTE   txa_Style;
	UBYTE   txa_Flags;
	UBYTE   txa_Name[40];
	UBYTE   txa_Label[50];
};


/* These structures are placed instead of GadgetInfo->g_Data, see below */

struct BK {                 /* Button and Checkbox Kind */
	ULONG   D1;         /* Dx, Px are unused fields */
	ULONG   D2;
	ULONG   D3;
	ULONG   D4;
	ULONG   D5;
	ULONG   D6;
	ULONG   D7;
};

struct IK {                 /* Integer Kind    */
	LONG    Num;        /* Number          */
	UWORD   MaxC;       /* Mx Chars        */
	WORD    P2;
	WORD    Just;       /* Justification   */
	WORD    P3;
	ULONG   D4;
	ULONG   D5;
	ULONG   D6;
	ULONG   D7;
};

struct LK {                 /* Listview Kind    */
	UWORD   Top;        /* Top              */
	UBYTE   MultiSelect;/* MultiSelect      */
	UBYTE   P1;
	UWORD   Vis;        /* Make Visible     */
	WORD    P2;
	UWORD   ScW;        /* Scroller Width   */
	WORD    P3;
	UWORD   Sel;        /* Selected         */
	WORD    P4;
	UWORD   Spc;        /* Spacing          */
	WORD    P5;
	UWORD   IH;         /* Item Height      */
	WORD    P6;
	WORD    MaxP;       /* Max Pen          */
	WORD    P7;
};

struct MK {                 /* MX Kind           */
	UWORD   Act;        /* Active            */
	WORD    P1;
	UWORD   Spc;        /* Spacing           */
	WORD    P2;
	UWORD   TitPlc;     /* Title Place       */
	WORD    P3;
	UWORD   D4;
	WORD    P4;
	UWORD   D5;
	WORD    P5;
	UWORD   D6;
	WORD    P6;
	WORD    D7;
	WORD    P7;
};

struct NK {                 /* Number Kind         */
	LONG    Num;        /* Number              */
	BYTE    FPen;       /* Front Pen           */
	BYTE    P2;
	WORD    PP2;
	BYTE    BPen;       /* Back Pen            */
	BYTE    P3;
	UWORD   Just;       /* Justification       */
	ULONG   MNL;        /* Max Number Len      */
	UBYTE   Format[12];
};

struct CK {                 /* Cycle Kind          */
	UWORD   Act;        /* Active              */
	WORD    P1;
	UWORD   D2;
	WORD    P2;
	WORD    D2;
	WORD    P3;
	ULONG   D4;
	ULONG   D5;
	ULONG   D6;
	ULONG   D7;
};

struct PK {                 /* Palette Kind  */
	UWORD   Depth;      /* Depth  */
	WORD    P1;
	UBYTE   Color;      /* Color  */
	BYTE    PP2;
	WORD    P2;
	UBYTE   ColOff;     /* Color Offset  */
	BYTE    PP3;
	WORD    P3;
	UWORD   IW;         /* Indicator Width  */
	WORD    P4;
	UWORD   IH;         /* Indicator Height  */
	WORD    P4;
	UWORD   NumCol;     /* Num Colors  */
	WORD    P6;
	ULONG   D7;
};

struct SK {                 /* Scroller Kind  */
	UWORD   Top;        /* Top  */
	WORD    p;
	UWORD   Tot;        /* Total  */
	WORD    P2;
	UWORD   Vis;        /* Visible  */
	WORD    P3;
	UWORD   Arr;        /* Arrows  */
	WORD    p4;
	UWORD   Free;       /* Freedom  */
	WORD    p5;
	ULONG   D6;
	ULONG   D7;
};

struct SlK {                /* Slider Kind  */
	WORD    Min;        /* Min  */
	WORD    Max;        /* Max  */
	WORD    Level;      /* Level  */
	UWORD   MLL;        /* Max Level Len  */
	UBYTE   LevPlc;     /* Level Place  */
	UBYTE   Just;       /* Justification  */
	UBYTE   Free;       /* Freedom  */
	BYTE    p3;
	ULONG   MPL;        /* Max Pixel Len  */
	UBYTE   Format[12];
};

struct StK {                /* String Kind  */
	UWORD   MaxC;       /* Max Chars  */
	UWORD   P1;
	UWORD   Just;       /* Justification  */
	WORD    P2;
	WORD    d3;
	WORD    P3;
	ULONG   D4;
	ULONG   D5;
	ULONG   D6;
	ULONG   D7;
};

struct TK {                 /* Text Kind  */
	WORD    FPen;       /* Front Pen  */
	WORD    p1;
	WORD    BPen;       /* Back Pen  */
	WORD    P2;
	WORD    Just;       /* Justification  */
	WORD    P3;
	ULONG   D4;
	ULONG   D5;
	ULONG   D6;
	ULONG   D7;
};

struct GadgetInfo {
	struct  Node g_Node;
	UWORD   g_Kind;         /* gadget kind  */
	UBYTE   g_flags2;
	UBYTE   g_Key;
	struct TxtAttrNode *g_Font;
	UBYTE   g_Titolo[80];   /* title  */
	UBYTE   g_Label[40];    /* label  */
	APTR    g_ExtraMem;     /* private  */
	WORD    g_Left;         /* structure NewGadget  */
	WORD    g_Top;
	UWORD   g_Width;
	UWORD   g_Height;
	APTR    g_GadgetText;
	APTR    g_TextAttr;
	WORD    g_GadgetID;
	LONG    g_Flags;
	APTR    g_VisualInfo;
	APTR    g_UserData;
	APTR    g_Ptr;          /* private  */
	ULONG   g_Tags;         /* tags  */
	struct BK g_Data;       /* various data  */
	UWORD   g_NumScelte;    /* items if MX, LISTVIEW or CYCLE  */
	struct MinList g_Scelte;
};




/********************
**  Gadgets flags  **
********************/

#define G_ATTIVO            (1<<1)      /* the object is selected            */
#define G_CONTORNO          (1<<2)      /* *** PRIVATE ***                   */
#define G_WAS_ACTIVE        (1<<3)      /* *** PRIVATE ***                   */
#define G_CARICATO          (1<<4)      /* *** PRIVATE ***                   */
#define G_CLICKED           (1<<5)      /* needs a <Label>Clicked routine    */
#define G_KEYPRESSED        (1<<6)      /* needs a <Label>KeyPressed routine */
#define G_NO_TEMPLATE       (1<<7)      /* template already written          */



/*************************
**  Extra Gadget types  **
*************************/

#define BOOLEAN             14

struct BooleanInfo {
	struct Node b_Node;
	UWORD               b_Kind;         /* always = BOOLEAN  */
	UBYTE               b_flags2;
	UBYTE               b_Pad;
	struct TxtAttrNode *b_Font;
	UBYTE               b_Titolo[80];   /* title  */
	UBYTE               b_Label[40];    /* label  */
	struct Gadget      *b_NextGadget;
	WORD                b_Left;         /* structure Gadget  */
	WORD                b_Top;
	UWORD               b_Width;
	UWORD               b_Height;
	UWORD               b_Flags;
	UWORD               b_Activation;
	UWORD               b_GadgetType;   /* always = GTYP_BOOLGADGET  */
	struct Image       *b_GadgetRender;
	struct Image       *b_SelectRender;
	struct IntuiText   *b_GadgetText;
	LONG                b_MutualExclude;
	APTR                b_SpecialInfo;
	WORD                b_GadgetID;
	APTR                b_UserData;
	BYTE                b_FrontPen;     /* IntuiText structure  */
	BYTE                b_BackPen;
	BYTE                b_DrawMode;
	BYTE                b_AdjustToWord;
	WORD                b_TxtLeft;
	WORD                b_TxtTop;
	APTR                b_TextFont;
	UBYTE              *b_Text;
	APTR                b_NextText;     /* always = NULL  */
};


/* Boolean Gadget Flags  */

#define B_TEXT          (1<<0)



/******************************
**  BOOPSI object structure  **
******************************/


struct BOOPSIInfo {
	struct Node         Node;
	UWORD               Kind;         /* gadget kind  */
	UBYTE               Flags;
	UBYTE               Key;
	struct TxtAttrNode *Font;
	UBYTE               Title[80];
	UBYTE               Label[40];
	APTR                User;
	WORD                Left;
	WORD                Top;
	UWORD               Width;
	UWORD               Height;
	struct MinList      Tags;
};


struct BTag {
	struct BTag    *Succ, *Pred;
	UBYTE           Type;           /* see expanders.h                  */
	UBYTE           BoolValue;      /* value for TT_BOOL                */
	STRPTR          Name;
	ULONG           Value;          /* value for TT_BYTE, WORD, LONG    */
	struct MinList  Items;          /* value for TT_#?_PTR, LIST        */
	TEXT            String[256];
};





/* This is for MX, LIST and CYCLE gadgets (or others that have items)  */

struct GadgetScelta {
	struct Node     gs_Node;
	UBYTE           gs_Testo[40];   /* text of item  */
};




struct ImageNode {
	struct Node in_Node;
	WORD    in_Left;        /* always set to 0, 0  */
	WORD    in_Top;
	UWORD   in_Width;
	UWORD   in_Height;
	UWORD   in_Depth;
	APTR    in_Data;        /* ^ to image raw data  */
	UBYTE   in_PlanePick;
	UBYTE   in_PlaneOnOff;
	APTR    in_NextImage;   /* ^ to next image, always NULL  */
	UBYTE   in_Label[40];
	ULONG   in_Size;        /* size of Data allocation  */
};



struct MenuTitle {
	struct Node mt_Node;
	UBYTE   mt_Flags;       /* see M_xxx below  */
	BYTE    mt_Pad;
	UWORD   mt_NumItems;
	struct MinList mt_Items;
	UBYTE   mt_Text[100];
	UBYTE   mt_Label[40];
};


struct _MenuItem {
	struct Node min_Node;
	UBYTE   min_Flags;      /* see M_xxx below  */
	BYTE    min_Pad;
	UBYTE   min_Text[100];
	APTR    min_Image;
	UBYTE   min_CommKey[16];
	UBYTE   min_Label[40];
	ULONG   min_MutualExclude;
	UWORD   min_NumSubs;
	struct  MinList min_Subs;
};


struct MenuSub {
	struct Node msn_Node;
	UBYTE   msn_Flags;      /* see M_xxx below  */
	BYTE    msn_Pad;
	UBYTE   msn_Text[100];
	APTR    msn_Image;
	UBYTE   msn_CommKey[16];
	UBYTE   msn_Label[40];
	ULONG   msn_MutualExclude;
};



/*****************
**  Menu flags  **
*****************/

#define M_DISABLED          (1<<0)
#define M_BARLABEL          (1<<1)
#define M_CHECKIT           (1<<2)
#define M_CHECKED           (1<<3)
#define M_MENUTOGGLE        (1<<4)



struct BevelBoxNode {
	APTR    bb_Next;
	APTR    bb_Prev;
	WORD    bb_Left;
	WORD    bb_Top;
	UWORD   bb_Width;
	UWORD   bb_Height;
	ULONG   bb_VITag;
	ULONG   bb_VisualInfo;
	ULONG   bb_RTag;
	ULONG   bb_Recessed;
	ULONG   bb_TTag;
	ULONG   bb_FrameType;
	ULONG   bb_TagEnd;
	UBYTE   bb_Flags;
};


/* BevelBoxes's flags  -  PRIVATE  */

#define BB_SELECTED         (1<<0)
#define BB_MAYBE            (1<<1)   /* maybe it's the one to active... */
/* Flag 2 is equal to CONTORNO  */



struct ITextNode {
	struct Node itn_Node;
	BYTE    itn_FrontPen;
	BYTE    itn_BackPen;
	BYTE    itn_DrawMode;
	BYTE    itn_AdjustToWord;
	WORD    itn_LeftEdge;
	WORD    itn_TopEdge;
	struct TextAttr *itn_ITextFont;
	APTR    itn_IText;
	APTR    itn_NextText;
	UBYTE   itn_Text[120];
	struct TextAttr *itn_FontCopy;
};


/* IntuiText flags (stored in LN_TYPE)  */

#define IT_SCRFONT      (1<<0)      /* use the screen font  */



struct RexxNode {
	struct Node rxn_Node;
	UBYTE   rxn_Label[40];
	UBYTE   rxn_Name[40];
	UBYTE   rxn_Template[500];
};


struct LibNode {
	struct Node lbn_Node;
	UWORD   lbn_Version;
	UBYTE   lbn_Name[60];
	UBYTE   lbn_Base[60];
};

/* Library flags (stored in LN_PRI)  */

#define L_FAIL          (1<<0)

struct WndToOpen {
	struct Node wto_Node;
	UBYTE   wto_Label[40];
};


/*********************************
**  General Flags  ( flags_2 )  **
*********************************/

#define         GENERASCR       (1<<1)  /* READ ONLY  */

/* ( flags ) - This can be set by loaders */

#define         NO_IEX          (1<<4)  /* set this if you didn't    */
					/* find an external module   */
#define         NODISKFONT      (1<<7)  /* set this if you failed to */
					/* open a disk font          */

/*******************************
**  C Preferences  (C_Prefs)  **
*******************************/

#define GEN_TEMPLATE            (1<<0)  /* generate Templates for functions  */
#define SMART_STR               (1<<1)  /* don't write a string twice        */
#define ONLY_NEW_TMP            (1<<2)  /* write only the new templates      */

/**********************************
**  Asm Preferences  (AsmPrefs)  **
**********************************/

#define SEC_DATA            (1<<0)      /* create a DATA section            */
#define SEC_BSS             (1<<1)      /* create a BSS section             */
#define GAD_LABELS          (1<<2)      /* create a label for every gadget  */

/* Asm Preferences 2 (AsmPrefs2)  */

#define RAW_CODE            (1<<0)      /* generate RawCode                 */


/**********************************************
**  Source parameters  (C_Prefs & AsmPrefs)  **
**********************************************/

#define INTUIMSG            (1<<7)      /* write an IntuiMsg for every window */
#define CLICKED             (1<<6)      /* generate Clicked pointers          */
#define IDCMP_HANDLER       (1<<5)      /* generate IDCMP Handlers            */
#define KEY_HANDLER         (1<<4)      /* generate VanillaKey Handlers       */
#define TO_LOWER            (1<<3)      /* activation key are lowercased      */

/* ( SrcFlags )  */

#define OPENDISKFONT        (1<<0)
#define MAINPROC            (1<<1)
#define LOCALIZE            (1<<2)      /* localize the gui                  */
#define AREXX_CMD_LIST      (1<<3)      /* put ARexx commands in a list      */
#define SHARED_PORT         (1<<4)      /* windows use a shared port         */
#define FONTSENSITIVE       (1<<6)


/********************
**  MainProcFlags  **
********************/

#define MAIN_CTRL_C         (1<<0)      /* handle CTRL C                  */
#define MAIN_OTHERBITS      (1<<1)
#define MAIN_WB             (1<<2)      /* generate wbmain() entry-point  */


/* This one is for my sources... I'm too lazy to delete it... ;-)  */

struct GXY {
    UWORD   Width;
    UWORD   Height;
    BOOL    Resize;
};


/*****************************************
**  Values index of ScreenData->Tags[]  **
*****************************************/

#define     SCRWIDTH        1
#define     SCRHEIGHT       3
#define     SCRDEPTH        5
#define     SCRID           7       /* DisplayID    */
#define     SCRFNT          9       /* Don't touch! */
#define     SCROVERSCAN    11
#define     SCRAUTOSCROLL  13

#endif
