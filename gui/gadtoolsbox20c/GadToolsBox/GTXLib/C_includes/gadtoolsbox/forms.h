#ifndef GADTOOLSBOX_FORMS_H
#define GADTOOLSBOX_FORMS_H
/*
**      $VER: gadtoolsbox/forms.h 39.1 (12.4.93)
**      GTXLib headers release 2.0.
**
**      GadToolsBox IFF FORM definitions.
**
**      (C) Copyright 1992,1993 Jaba Development.
**          Written by Jan van den Baard
**/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef LIBRARIES_GADTOOLS_H
#include <libraries/gadtools.h>
#endif

#ifndef LIBRARIES_IFFPARSE_H
#include <libraries/iffparse.h>
#endif

/* GadToolsBox FORM identifiers */
#define ID_GXMN             MAKE_ID('G','X','M','N')
#define ID_GXTX             MAKE_ID('G','X','T','X')
#define ID_GXBX             MAKE_ID('G','X','B','X')
#define ID_GXGA             MAKE_ID('G','X','G','A')
#define ID_GXWD             MAKE_ID('G','X','W','D')
#define ID_GXUI             MAKE_ID('G','X','U','I')

/* GadToolsBox chunk identifiers. */
#define ID_MEDA             MAKE_ID('M','E','D','A')
#define ID_ITXT             MAKE_ID('I','T','X','T')
#define ID_BBOX             MAKE_ID('B','B','O','X')
#define ID_GADA             MAKE_ID('G','A','D','A')
#define ID_WDDA             MAKE_ID('W','D','D','A')
#define ID_GGUI             MAKE_ID('G','G','U','I')

#define ID_VERS             MAKE_ID('V','E','R','S')

/* Version (ID_VERS) chunk...
** This chunk will be used in the future for chunk format changes
** that might occure.
**/
typedef struct {
    UWORD                   vr_Version;
    UWORD                   vr_Flags;
    ULONG                   vr_Reserved[ 4 ];
} VERSION;

/* NewMenu (ID_MEDA) chunk... */
#define MAXMENUTITLE        80
#define MAXMENULABEL        34
#define MAXSHORTCUT         2

#define MENUVERSION         0

typedef struct {
    struct NewMenu          mda_NewMenu;
    UBYTE                   mda_Title[ MAXMENUTITLE ];
    UBYTE                   mda_Label[ MAXMENULABEL ];
    UBYTE                   mda_ShortCut[ MAXSHORTCUT ];
    UWORD                   mda_Flags;
} MENUDATA;

/* IntuiText (ID_ITXT) chunk... */
#define MAXTEXTLENGTH       80

#define ITXTVERSION         0

typedef struct {
    struct IntuiText        it_IText;
    UBYTE                   it_Text[ MAXTEXTLENGTH ];
} ITEXTDATA;

/* BevelBox (ID_BBOX) chunk... */
#define BBOXVERSION         0

typedef struct {
    WORD                    bbx_Left;
    WORD                    bbx_Top;
    UWORD                   bbx_Width;
    UWORD                   bbx_Height;
    UWORD                   bbx_Flags;
} BBOXDATA;

/* BevelBox flag bits */
#define BBF_RECESSED        (1<<0)
#define BBF_DROPBOX         (1<<1)

/* NewGadget (ID_GADA) chunk... */
#define MAXGADGETTEXT       80
#define MAXGADGETLABEL      34

#define GADGETVERSION       0

typedef struct {
    struct NewGadget        gd_NewGadget;
    UBYTE                   gd_GadgetText[ MAXGADGETTEXT ];
    UBYTE                   gd_GadgetLabel[ MAXGADGETLABEL ];
    ULONG                   gd_Flags;
    UWORD                   gd_Kind;
    UWORD                   gd_NumTags;
    ULONG                   gd_Reserved[ 4 ];
} GADGETDATA;

/* NewGadget flag bits */
#define GDF_ISLOCKED        (1<<5)
#define GDF_NEEDLOCK        (1<<6)

/* Window (ID_WDDA) chunk... */
#define MAXWINDOWNAME       34
#define MAXWINDOWTITLE      80
#define MAXWDSCREENTITLE    80

#define WINDOWVERSION       0

typedef struct {
    UBYTE                   wda_Name[ MAXWINDOWNAME ];
    UBYTE                   wda_Title[ MAXWINDOWTITLE ];
    UBYTE                   wda_ScreenTitle[ MAXWDSCREENTITLE ];
    UWORD                   wda_NumTags;
    UWORD                   wda_IDCountFrom;
    ULONG                   wda_IDCMP;
    ULONG                   wda_WindowFlags;
    ULONG                   wda_TagFlags;
    UWORD                   wda_InnerWidth;
    UWORD                   wda_InnerHeight;
    BOOL                    wda_ShowTitle;
    UWORD                   wda_MouseQueue;
    UWORD                   wda_RptQueue;
    UWORD                   wda_Flags;
    UWORD                   wda_LeftBorder;
    UWORD                   wda_TopBorder;
    UBYTE                   wda_Reserved[ 10 ];
} WINDOWDATA;

/* Window tag flag bits */
#define WDF_INNERWIDTH      (1<<0)
#define WDF_INNERHEIGHT     (1<<1)
#define WDF_ZOOM            (1<<2)
#define WDF_MOUSEQUEUE      (1<<3)
#define WDF_RPTQUEUE        (1<<4)
#define WDF_AUTOADJUST      (1<<5)
#define WDF_DEFAULTZOOM     (1<<6)
#define WDF_FALLBACK        (1<<7)

/* GUI (ID_GGUI) chunk... */
#define MAXSCREENTITLE      80
#define FONTNAMELENGTH      128
#define MAXCOLORSPEC        33
#define MAXDRIPENS          10
#define MAXMOREDRIPENS      10

#define GUIVERSION          0

typedef struct {
    ULONG                   gui_Flags0;
    UBYTE                   gui_ScreenTitle[ MAXSCREENTITLE ];
    UWORD                   gui_Left;
    UWORD                   gui_Top;
    UWORD                   gui_Width;
    UWORD                   gui_Height;
    UWORD                   gui_Depth;
    ULONG                   gui_DisplayID;
    UWORD                   gui_Overscan;
    UWORD                   gui_DriPens[ MAXDRIPENS ];
    struct ColorSpec        gui_Colors[ MAXCOLORSPEC ];
    UBYTE                   gui_FontName[ FONTNAMELENGTH ];
    struct TextAttr         gui_Font;
    UWORD                   gui_MoreDriPens[ MAXMOREDRIPENS ];
    ULONG                   gui_Reserved[ 5 ];
   /*
    * The following fields are private to
    * GadToolsBox and they should not be useful
    * to you!
    */
    ULONG                   gui_Flags1;
    UWORD                   gui_StdScreenWidth;
    UWORD                   gui_StdScreenHeight;
    UWORD                   gui_ActiveKind;
    UWORD                   gui_LastProject;
    UWORD                   gui_GridX;
    UWORD                   gui_GridY;
    UWORD                   gui_OffX;
    UWORD                   gui_OffY;
    UWORD                   gui_Reserved1[ 7 ];
} GUIDATA;

/* GUI gui_Flags0 flag bits */
#define GU0_AUTOSCROLL      (1<<0)
#define GU0_WORKBENCH       (1<<1)
#define GU0_PUBLIC          (1<<2)
#define GU0_CUSTOM          (1<<3)

#endif
