/*===================================*/
/*   AmigaE module for ToolBar.mcc   */
/*     by QXY (qxyka@elender.hu)     */
/*                                   */
/* ToolBar.mcc (C)Benny Kjær Nielsen */
/*===================================*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'libraries/mui', 'exec/types'

/*** MUI Defines ***/

#define MUIC_Toolbar 'Toolbar.mcc'
#define ToolbarObject Mui_NewObjectA(MUIC_Toolbar,[TAG_IGNORE,0

/*** Methods ***/

CONST MUIM_Toolbar_BottomEdge    =  $FCF70007,
      MUIM_Toolbar_KillNotify    =  $FCF70002,
      MUIM_Toolbar_KillNotifyObj =  $FCF70003,
      MUIM_Toolbar_LeftEdge      =  $FCF70008,
      MUIM_Toolbar_MultiSet      =  $FCF70004,
      MUIM_Toolbar_Notify        =  $FCF70001,
      MUIM_Toolbar_Redraw        =  $FCF70005,
      MUIM_Toolbar_ReloadImages  =  $FCF7000B,
      MUIM_Toolbar_RightEdge     =  $FCF70009,
      MUIM_Toolbar_Set           =  $FCF70006,
      MUIM_Toolbar_TopEdge       =  $FCF7000A

/*** Method structs ***/

OBJECT muip_toolbar_edge
  methodid:LONG, button:LONG
ENDOBJECT

OBJECT muip_toolbar_killnotify
 methodid:LONG, trigbutton:LONG, trigattr:LONG
ENDOBJECT

OBJECT muip_toolbar_killnotifyobj
  methodid:LONG
ENDOBJECT

OBJECT muip_toolbar_multiset
  methodid:LONG, flag:LONG, value:LONG, button:LONG /* ... */
ENDOBJECT

OBJECT muip_toolbar_notify
  methodid:LONG, trigbutton:LONG, trigattr:LONG
  trigvalue:LONG, destobj:LONG, followparams:LONG /* ... */
ENDOBJECT

OBJECT muip_toolbar_redraw
  methodid:LONG, changes:LONG
ENDOBJECT

OBJECT muip_toolbar_reloadimages
  methodid:LONG, normal:PTR TO CHAR, select:PTR TO CHAR, ghost:PTR TO CHAR
ENDOBJECT

OBJECT muip_toolbar_set
  methodid:LONG, button:LONG, flag:LONG, value:LONG
ENDOBJECT

/*** Special method values ***/

CONST MUIV_Toolbar_Set_Ghosted       = $00000004,
      MUIV_Toolbar_Set_Gone          = $00000008,
      MUIV_Toolbar_Set_Selected      = $00000010,

      MUIV_Toolbar_Notify_Pressed    = $00000000,
      MUIV_Toolbar_Notify_Active     = $00000001,
      MUIV_Toolbar_Notify_Ghosted    = $00000002,
      MUIV_Toolbar_Notify_Gone       = $00000003,
      MUIV_Toolbar_Notify_LeftEdge   = $00000004,
      MUIV_Toolbar_Notify_RightEdge  = $00000005,
      MUIV_Toolbar_Notify_TopEdge    = $00000006,
      MUIV_Toolbar_Notify_BottomEdge = $00000007

/*** Special method flags ***/

/*** Attributes ***/

CONST MUIA_Toolbar_Description     = $FCF70016,
      MUIA_Toolbar_HelpString      = $FCF70017,
      MUIA_Toolbar_Horizontal      = $FCF70015,
      MUIA_Toolbar_ImageGhost      = $FCF70013,
      MUIA_Toolbar_ImageNormal     = $FCF70011,
      MUIA_Toolbar_ImageSelect     = $FCF70012,
      MUIA_Toolbar_ImageType       = $FCF70010,
      MUIA_Toolbar_ParseUnderscore = $FCF70018,
      MUIA_Toolbar_Permutation     = $FCF7001A,
      MUIA_Toolbar_Reusable        = $FCF70019

/*** Special attribute values ***/

ENUM MUIV_Toolbar_ImageType_File,   -> 0
     MUIV_Toolbar_ImageType_Memory, -> 1
     MUIV_Toolbar_ImageType_Object  -> 2

/*** Structures, Flags & Values ***/

OBJECT muip_toolbar_description
  type          :CHAR        /* Type of button - see possible values below (TDT_). */
  key           :CHAR        /* Hotkey */
  flags         :INT         /* The buttons current setting - see the TDF_ flags */
  tooltext      :PTR TO CHAR /* The text beneath the icons. */
  helpstring    :PTR TO CHAR /* The string used for help-bubbles or MUIA_Toolbar_HelpString */
  mutualexclude :LONG        /* Buttons to be released when this button is pressed down */
ENDOBJECT

/*** Toolbar Description Types ***/

ENUM  TDT_BUTTON,  -> 0
      TDT_SPACE,   -> 1
      TDT_IGNORE,  -> 2 (Obsolete)
      TDT_END      -> 3

CONST TDT_IGNORE_FLAG = 128

/*** Toolbar Description Flags ***/

SET TDF_TOGGLE,   /* $00000001 - Set this if it's a toggle-button */
    TDF_RADIO,    /* $00000002 - and this if it's also a radio-button */
    TDF_GHOSTED,  /* $00000004   */
    TDF_GONE,     /* $00000008 - Make the button temporarily go away */
    TDF_SELECTED  /* $00000010 - State of a toggle-button */

#define TDF_RADIOTOGGLE TDF_TOGGLE+TDF_RADIO /* A practical definition */

/* TDF_RADIO AND TDF_SELECTED only makes sense if you have set the TDF_TOGGLE flag. */

/*** Toolbar Macros ***/

#define Toolbar_Button(flags, text)          [TDT_BUTTON, NIL,  flags, text, NIL, NIL]:muip_toolbar_description
#define Toolbar_KeyButton(flags, text, key)  [TDT_BUTTON, key,  flags, text, NIL, NIL]:muip_toolbar_description
#define Toolbar_Space                        [TDT_SPACE,  NIL,  NIL,   NIL,  NIL, NIL]:muip_toolbar_description
#define Toolbar_End                          [TDT_END,    NIL,  NIL,   NIL,  NIL, NIL]:muip_toolbar_description

