#ifndef GADTOOLSBOX_GUI_H
#define GADTOOLSBOX_GUI_H
/*
**      $VER: gadtoolsbox/gui.h 39.1 (12.4.93)
**      GTXLib headers release 2.0.
**
**      GadToolsBox GUI file loader definitions.
**
**      (C) Copyright 1992,1993 Jaba Development.
**          Written by Jan van den Baard.
**/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef GADTOOLSBOX_PREFS_H
#include <gadtoolsbox/prefs.h>
#endif

#ifndef GADTOOLSBOX_FORMS_H
#include <gadtoolsbox/forms.h>
#endif

struct ExtNewGadget {
    struct ExtNewGadget             *en_Next;
    struct ExtNewGadget             *en_Prev;
    struct TagItem                  *en_Tags;
    UBYTE                            en_Reserved0[ 4 ];
    struct NewGadget                 en_NewGadget;
    UBYTE                            en_GadgetLabel[ MAXGADGETLABEL ];
    UBYTE                            en_GadgetText[ MAXGADGETTEXT ];
    ULONG                            en_Flags;   /* See gadtoolsbox/forms.h ID_GADA */
    UWORD                            en_Kind;
    UBYTE                            en_Reserved1[ 138 ];
};

struct ExtGadgetList {
    struct ExtNewGadget             *gl_First;
    struct ExtNewGadget             *gl_EndMark;
    struct ExtNewGadget             *gl_Last;
};

struct ExtNewMenu {
    struct ExtNewMenu               *em_Next;
    struct ExtNewMenu               *em_Prev;
    UBYTE                            em_Reserved0[ 6 ];
    struct NewMenu                   em_NewMenu;
    UBYTE                            em_MenuTitle[ MAXMENUTITLE ];
    UBYTE                            em_MenuLabel[ MAXMENULABEL ];
    UBYTE                            em_Reserved1[ 4 ];
    struct ExtMenuList              *em_Items;
    UBYTE                            em_Reserved2[ 2 ];
    UBYTE                            em_CommKey[ MAXSHORTCUT ];
    UBYTE                            em_Reserved3[ 2 ];
};

struct ExtMenuList {
    struct ExtNewMenu               *ml_First;
    struct ExtNewMenu               *ml_EndMark;
    struct ExtNewMenu               *ml_Last;
};

struct BevelBox {
    struct BevelBox                 *bb_Next;
    struct BevelBox                 *bb_Prev;
    UBYTE                            bb_Reserved0[ 4 ];
    UWORD                            bb_Left;
    UWORD                            bb_Top;
    WORD                             bb_Width;
    WORD                             bb_Height;
    UBYTE                            bb_Reserved1[ 32 ];
    UWORD                            bb_Flags; /* See gadtoolsbox/forms.h ID_BBOX */
};

struct BevelList {
    struct BevelBox                 *bl_First;
    struct BevelBox                 *bl_EndMark;
    struct BevelBox                 *bl_Last;
};

struct ProjectWindow {
    struct ProjectWindow            *pw_Next;
    struct ProjectWindow            *pw_Prev;
    UBYTE                            pw_Reserved0[ 6 ];
    UBYTE                            pw_Name[ MAXWINDOWNAME ];
    UWORD                            pw_CountIDFrom;
    struct TagItem                  *pw_Tags;
    UWORD                            pw_LeftBorder;
    UWORD                            pw_TopBorder;
    UBYTE                            pw_WindowTitle[ MAXWINDOWTITLE ];
    UBYTE                            pw_ScreenTitle[ MAXWDSCREENTITLE ];
    UBYTE                            pw_Reserved2[ 192 ];
    ULONG                            pw_IDCMP;
    ULONG                            pw_WindowFlags;
    struct IntuiText                *pw_WindowText;
    struct ExtGadgetList             pw_Gadgets;
    struct ExtMenuList               pw_Menus;
    struct BevelList                 pw_Boxes;
    ULONG                            pw_TagFlags; /* See gadtoolsbox/forms.h ID_WDDA */
    WORD                             pw_InnerWidth;
    WORD                             pw_InnerHeight;
    BOOL                             pw_ShowTitle;
    UBYTE                            pw_Reserved3[ 6 ];
    UWORD                            pw_MouseQueue;
    UWORD                            pw_RptQueue;
    UWORD                            pw_Flags;
};

struct WindowList {
    struct ProjectWindow            *wl_First;
    struct ProjectWindow            *wl_EndMark;
    struct ProjectWindow            *wl_Last;
};

/* tags for the GTX_LoadGUI() routine */
#define RG_TagBase                  (TAG_USER+512)

#define RG_GUI                      (RG_TagBase+1)
#define RG_Config                   (RG_TagBase+2)
#define RG_CConfig                  (RG_TagBase+3)
#define RG_AsmConfig                (RG_TagBase+4)
#define RG_LibGen                   (RG_TagBase+5)
#define RG_WindowList               (RG_TagBase+6)
#define RG_Valid                    (RG_TagBase+7)
#define RG_PasswordEntry            (RG_TagBase+8)

#define VLF_GUI                     (1<<0)
#define VLF_CONFIG                  (1<<1)
#define VLF_CCONFIG                 (1<<2)
#define VLF_ASMCONFIG               (1<<3)
#define VLF_LIBGEN                  (1<<4)
#define VLF_WINDOWLIST              (1<<5)

#define ERROR_NOMEM                 1
#define ERROR_OPEN                  2
#define ERROR_READ                  3
#define ERROR_WRITE                 4
#define ERROR_PARSE                 5
#define ERROR_PACKER                6
#define ERROR_PPLIB                 7
#define ERROR_NOTGUIFILE            8

#endif
