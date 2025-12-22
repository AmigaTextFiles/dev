        IFND    GADTOOLSBOX_FORMS_I
GADTOOLSBOX_FORMS_I SET     1
**
**      $Filename: gadtoolsbox/forms.i $
**      $Release: 1.0 $
**      $Revision: 38.10 $
**
**      GadToolsBox IFF FORM definitions.
**
**      (C) Copyright 1992,1993 Jaba Development.
**          Written by Jan van den Baard
**
        IFND    EXEC_TYPES_I
        include "exec/types.i"
        ENDC

        IFND    LIBRARIES_GADTOOLS_I
        include "libraries/gadtools.i"
        ENDC

        IFND    LIBRARIES_IFFPARSE_I
        include "libraries/iffparse.i"
        ENDC

** GadToolsBox FORM identifiers
ID_GXMN             EQU     'GXMN'
ID_GXTX             EQU     'GXTX'
ID_GXBX             EQU     'GXBX'
ID_GXGA             EQU     'GXGA'
ID_GXWD             EQU     'GXWD'
ID_GXUI             EQU     'GXUI'

** GadToolsBox chunk identifiers
ID_MEDA             EQU     'MEDA'
ID_ITXT             EQU     'ITXT'
ID_BBOX             EQU     'BBOX'
ID_GADA             EQU     'GADA'
ID_WDDA             EQU     'WDDA'
ID_GGUI             EQU     'GGUI'

ID_VERS             EQU     'VERS'

** Version (ID_VERS) chunk...
** This chunk will be used in the future for chunk format changes
** that might occure.
        STRUCTURE Version,0
            UWORD       vr_Version
            UWORD       vr_Flags
            STRUCT      vr_Reserved,4*4
        LABEL           vr_SIZEOF
** NewMenu (ID_MEDA) chunk...
MAXMENUTITLE        EQU     80
MAXMENULABEL        EQU     34
MAXSHORTCUT         EQU     2

MENUVERSION         EQU     0

        STRUCTURE MenuData,0
            STRUCT      mda_NewMenu,gnm_SIZEOF
            STRUCT      mda_Title,MAXMENUTITLE
            STRUCT      mda_Label,MAXMENULABEL
            STRUCT      mda_ShortCut,MAXSHORTCUT
            UWORD       mda_Flags
        LABEL           mda_SIZEOF

** IntuiText (ID_ITXT) chunk...
MAXTEXTLENGTH       EQU     80

ITXTVERSION         EQU     0

        STRUCTURE ITextData,0
            STRUCT      itx_IText,it_SIZEOF
            STRUCT      itx_Text,MAXTEXTLENGTH
        LABEL           itx_SIZEOF

** BevelBox (ID_BBOX) chunk...
BBOXVERSION         EQU     0

        STRUCTURE BBoxData,0
            WORD        bbx_Left
            WORD        bbx_Top
            UWORD       bbx_Width
            UWORD       bbx_Height
            UWORD       bbx_Flags
        LABEL           bbx_SIZEOF

** BevelBox flag bits
        BITDEF      BB,RECESSED,0
        BITDEF      BB,DROPBOX,1

** NewGadget (ID_GADA) chunk...
MAXGADGETTEXT       EQU     80
MAXGADGETLABEL      EQU     34

GADGETVERSION       EQU     0

        STRUCTURE GadgetData,0
            STRUCT      gda_NewGadget,gng_SIZEOF
            STRUCT      gda_GadgetText,MAXGADGETTEXT
            STRUCT      gda_GadgetLabel,MAXGADGETLABEL
            ULONG       gda_Flags
            UWORD       gda_Kind
            UWORD       gda_NumTags
            STRUCT      gda_Reserved,4*4
        LABEL           gda_SIZEOF

** NewGadget flag bits
        BITDEF      GD,ISLOCKED,5
        BITDEF      GD,NEEDLOCK,6

** Window (ID_WDDA) chunk...
MAXWINDOWNAME       EQU     34
MAXWINDOWTITLE      EQU     80
MAXWDSCREENTITLE    EQU     80

WINDOWVERSION       EQU     0

        STRUCTURE WindowData,0
            STRUCT      wda_Name,MAXWINDOWNAME
            STRUCT      wda_Title,MAXWINDOWTITLE
            STRUCT      wda_ScreenTitle,MAXWDSCREENTITLE
            UWORD       wda_NumTags
            UWORD       wda_IDCountFrom
            ULONG       wda_IDCMP
            ULONG       wda_WindowFlags
            ULONG       wda_TagFlags
            UWORD       wda_InnerWidth
            UWORD       wda_InnerHeight
            WORD        wda_ShowTitle
            UWORD       wda_MouseQueue
            UWORD       wda_RptQueue
            UWORD       wda_Flags
            UWORD       wda_LeftBorder
            UWORD       wda_TopBorder
            STRUCT      wda_Reserved,10
        LABEL           wda_SIZEOF

** Window tag flag bits
        BITDEF      WD,INNERWIDTH,0
        BITDEF      WD,INNERHEIGHT,1
        BITDEF      WD,ZOOM,2
        BITDEF      WD,MOUSEQUEUE,3
        BITDEF      WD,RPTQUEUE,4
        BITDEF      WD,AUTOADJUST,5
        BITDEF      WD,DEFAULTZOOM,6
        BITDEF      WD,FALLBACK,7

** GUI (ID_GGUI) chunk...
MAXSCREENTITLE      EQU     80
FONTNAMELENGTH      EQU     128
MAXCOLORSPEC        EQU     33
MAXDRIPENS          EQU     10
MAXMOREDRIPENS      EQU     10

GUIVERSION          EQU     0

        STRUCTURE GUIData,0
            ULONG       gui_Flags0
            STRUCT      gui_ScreenTitle,MAXSCREENTITLE
            UWORD       gui_Left
            UWORD       gui_Top
            UWORD       gui_Width
            UWORD       gui_Height
            UWORD       gui_Depth
            ULONG       gui_DisplayID
            UWORD       gui_Overscan
            STRUCT      gui_DriPens,MAXDRIPENS*2
            STRUCT      gui_Colors,MAXCOLORSPEC*cs_SIZEOF
            STRUCT      gui_FontName,FONTNAMELENGTH
            STRUCT      gui_Font,ta_SIZEOF
            STRUCT      gui_MoreDriPens,MAXMOREDRIPENS*2
            STRUCT      gui_Reserved,5*4
*
* The following fields are private to
* GadToolsBox and they should not be useful
* to you!
*
            ULONG       gui_Flags1
            UWORD       gui_StdScreenWidth
            UWORD       gui_StdScreenHeight
            UWORD       gui_ActiveKind
            UWORD       gui_LastProject
            UWORD       gui_GridX
            UWORD       gui_GridY
            UWORD       gui_OffX
            UWORD       gui_OffY
            STRUCT      gui_Reserved1,7*2
        LABEL           gui_SIZEOF

** GUI gui_Flags0 flag bits
        BITDEF      GU0,AUTOSCROLL,0
        BITDEF      GU0,WORKBENCH,1
        BITDEF      GU0,PUBLIC,2
        BITDEF      GU0,CUSTOM,3

        ENDC
