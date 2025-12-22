        IFND    GADTOOLSBOX_GUI_I
GADTOOLSBOX_GUI_I   SET     1
**
**      $Filename: gadtoolsbox/gui.i $
**      $Release: 1.0 $
**      $Revision: 38.7 $
**
**      GadToolsBox GUI file loader definitions.
**
**      (C) Copyright 1992 Jaba Development.
**          Written by Jan van den Baard
**
        IFND    EXEC_TYPES_I
        include "exec/types.i"
        ENDC

        IFND    GADTOOLSBOX_PREFS_I
        include "gadtoolsbox/prefs.i"
        ENDC

        IFND    GADTOOLSBOX_FORMS_I
        include "gadtoolsbox/forms.i"
        ENDC

        STRUCTURE ExtNewGadget,0
            APTR        en_Next;
            APTR        en_Prev;
            APTR        en_Tags;
            STRUCT      en_Reserved0,4
            STRUCT      en_NewGadget,gng_SIZEOF
            STRUCT      en_GadgetLabel,MAXGADGETLABEL
            STRUCT      en_GadgetText,MAXGADGETTEXT
            ULONG       en_Flags        ; See gadtoolsbox/forms.i ID_GADA
            UWORD       en_Kind
            STRUCT      en_Reserved1,138
        LABEL           en_SIZEOF

        STRUCTURE ExtGadgetList,0
            APTR        gl_First
            APTR        gl_EndMark
            APTR        gl_Last
        LABEL           gl_SIZEOF

        STRUCTURE ExtNewMenu,0
            APTR        em_Next
            APTR        em_Prev
            STRUCT      em_Reserved0,6
            STRUCT      em_NewMenu,gnm_SIZEOF
            STRUCT      em_MenuTitle,MAXMENUTITLE
            STRUCT      em_MenuLabel,MAXMENULABEL
            STRUCT      em_Reserved1,4
            APTR        em_Items
            STRUCT      em_Reserved2,2
            STRUCT      em_CommKey,MAXSHORTCUT
            STRUCT      em_Reserved3,2
        LABEL           em_SIZEOF

        STRUCTURE ExtMenuList,0
            APTR        ml_First
            APTR        ml_EndMark
            APTR        ml_Last
        LABEL           ml_SIZEOF

        STRUCTURE BevelBox,0
            APTR        bb_Next
            APTR        bb_Prev
            STRUCT      bb_Reserved0,4
            UWORD       bb_Left
            UWORD       bb_Top
            WORD        bb_Width
            WORD        bb_Height
            STRUCT      bb_Reserved1,32
            UWORD       bb_Flags        ; See gadtoolsbox/forms.i ID_BBOX
        LABEL           bb_SIZEOF

        STRUCTURE BevelList,0
            APTR        bl_First
            APTR        bl_EndMark
            APTR        bl_Last
        LABEL           bl_SIZEOF

        STRUCTURE ProjectWindow,0
            APTR        pw_Next
            APTR        pw_Prev
            STRUCT      pw_Reserved0,6
            STRUCT      pw_Name,MAXWINDOWNAME
            UWORD       pw_CountIDFrom
            APTR        pw_Tags
            UWORD       pw_LeftBorder
            UWORD       pw_TopBorder
            STRUCT      pw_WindowTitle,MAXWINDOWTITLE
            STRUCT      pw_ScreenTitle,MAXSCREENTITLE
            STRUCT      pw_Reserved2,192
            ULONG       pw_IDCMP
            ULONG       pw_WindowFlags
            APTR        pw_WindowText
            STRUCT      pw_Gadgets,gl_SIZEOF
            STRUCT      pw_Menus,ml_SIZEOF
            STRUCT      pw_Boxes,bl_SIZEOF
            ULONG       pw_TagFlags     ; See gadtoolsbox/forms.i ID_WDDA
            WORD        pw_InnerWidth
            WORD        pw_InnerHeight
            WORD        pw_ShowTitle
            STRUCT      pw_Reserved3,6
            UWORD       pw_MouseQueue
            UWORD       pw_RptQueue
            UWORD       pw_Flags
        LABEL           pw_SIZEOF

        STRUCTURE WindowList,0
            APTR        wl_First
            APTR        wl_EndMark
            APTR        wl_Last
        LABEL           wl_SIZEOF

** tags for the GTX_LoadGUI() routine
RG_TagBase              EQU     TAG_USER+512

RG_GUI                  EQU     RG_TagBase+1
RG_Config               EQU     RG_TagBase+2
RG_CConfig              EQU     RG_TagBase+3
RG_AsmConfig            EQU     RG_TagBase+4
RG_LibGen               EQU     RG_TagBase+5
RG_WindowList           EQU     RG_TagBase+6
RG_Valid                EQU     RG_TagBase+7
RG_PasswordEntry        EQU     RG_TagBase+8

** valid flags
        BITDEF  VL,GUI,0
        BITDEF  VL,CONFIG,1
        BITDEF  VL,CCONFIG,2
        BITDEF  VL,ASMCONFIG,3
        BITDEF  VL,LIBGEN,4
        BITDEF  VL,WINDOWLIST,5

** possible LoadGUI() errors
ERROR_NOMEM             EQU     1
ERROR_OPEN              EQU     2
ERROR_READ              EQU     3
ERROR_WRITE             EQU     4
ERROR_PARSE             EQU     5
ERROR_PACKER            EQU     6
ERROR_PPLIB             EQU     7
ERROR_NOTGUIFILE        EQU     8

        ENDC
