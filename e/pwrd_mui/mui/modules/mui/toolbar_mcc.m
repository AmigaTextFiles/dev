/*
**
** $VER: Toolbar_mcc.h V15.6
** Copyright © 1997-00 Benny Kjær Nielsen. All rights reserved.
**
** Translated into D by Miklós Németh
**
*/

/*** Include stuff ***/

MODULE 'libraries/mui'
MODULE 'utility/tagitem'
MODULE 'intuition/classes'

CONST BKN_SERIAL =$fcf70000


/*** MUI Defines ***/

#define MUIC_Toolbar 'Toolbar.mcc'
#define ToolbarObject MUI_NewObjectA(MUIC_Toolbar,[TAG_IGNORE, 0

/*** Methods ***/

CONST MUIM_Toolbar_BottomEdge      =$FCF70007
CONST MUIM_Toolbar_CheckNotify     =$FCF7000d
CONST MUIM_Toolbar_DrawButton      =$FCF7000c
CONST MUIM_Toolbar_KillNotify      =$FCF70002
CONST MUIM_Toolbar_KillNotifyObj   =$FCF70003
CONST MUIM_Toolbar_LeftEdge        =$FCF70008
CONST MUIM_Toolbar_MultiSet        =$FCF70004
CONST MUIM_Toolbar_Notify          =$FCF70001
CONST MUIM_Toolbar_Redraw          =$FCF70005
CONST MUIM_Toolbar_ReloadImages    =$FCF7000b
CONST MUIM_Toolbar_RightEdge       =$FCF70009
CONST MUIM_Toolbar_Set             =$FCF70006
CONST MUIM_Toolbar_TopEdge         =$FCF7000a

/*** Method OBJECTs ***/

OBJECT MUIP_Toolbar_CheckNotify
    MethodID:ULONG,
    TrigButton:ULONG,
    TrigAttr:ULONG,
    TrigValue:ULONG

OBJECT MUIP_Toolbar_Edge
    MethodID:ULONG,
    Button:ULONG

OBJECT MUIP_Toolbar_KillNotify
    MethodID:ULONG,
    TrigButton:ULONG,
    TrigAttr:ULONG

OBJECT MUIP_Toolbar_KillNotifyObj
    MethodID:ULONG

OBJECT MUIP_Toolbar_MultiSet
    MethodID:ULONG,
    Flag:ULONG,
    Value:ULONG,
    Button:LONG

OBJECT MUIP_Toolbar_Notify
    MethodID:ULONG,
    TrigButton:ULONG,
    TrigAttr:ULONG,
    TrigValue:ULONG,
    DestObj:PTR TO _Object,
    FollowParams:ULONG

OBJECT MUIP_Toolbar_Redraw
    MethodID:ULONG,
    Changes:ULONG

OBJECT MUIP_Toolbar_ReloadImages
    MethodID:ULONG,
    Normal:PTR TO UBYTE,
    Select:PTR TO UBYTE,
    Ghost:PTR TO UBYTE

OBJECT MUIP_Toolbar_Set
    MethodID:ULONG,
    Button:ULONG,
    Flag:ULONG,
    Value:ULONG

/*** Special method values ***/

CONST MUIV_Toolbar_Set_Ghosted     =$04
CONST MUIV_Toolbar_Set_Gone        =$08
CONST MUIV_Toolbar_Set_Selected    =$10

CONST MUIV_Toolbar_Notify_Pressed    =0
CONST MUIV_Toolbar_Notify_Active     =1
CONST MUIV_Toolbar_Notify_Ghosted    =2
CONST MUIV_Toolbar_Notify_Gone       =3
CONST MUIV_Toolbar_Notify_LeftEdge   =4
CONST MUIV_Toolbar_Notify_RightEdge  =5
CONST MUIV_Toolbar_Notify_TopEdge    =6
CONST MUIV_Toolbar_Notify_BottomEdge =7

/*** Special value for MUIM_Toolbar_Notify ***/

CONST MUIV_Toolbar_Qualifier =$49893135

/*** Special method flags ***/

/*** Attributes ***/

CONST MUIA_Toolbar_Description     =$FCF70016
CONST MUIA_Toolbar_HelpString      =$FCF70017
CONST MUIA_Toolbar_Horizontal      =$FCF70015
CONST MUIA_Toolbar_ImageGhost      =$FCF70013
CONST MUIA_Toolbar_ImageNormal     =$FCF70011
CONST MUIA_Toolbar_ImageSelect     =$FCF70012
CONST MUIA_Toolbar_ImageType       =$FCF70010
CONST MUIA_Toolbar_ParseUnderscore =$FCF70018
CONST MUIA_Toolbar_Path            =$FCF7001b
CONST MUIA_Toolbar_Permutation     =$FCF7001a
CONST MUIA_Toolbar_Qualifier       =$FCF7001c
CONST MUIA_Toolbar_Reusable        =$FCF70019

/*** Special attribute values ***/

CONST MUIV_Toolbar_ImageType_File     =0
CONST MUIV_Toolbar_ImageType_Memory   =1
CONST MUIV_Toolbar_ImageType_Object   =2

/*** OBJECTures, Flags & Values ***/

CONST TP_SPACE =-2
CONST TP_END   =-1

OBJECT MUIP_Toolbar_Description
  Type:UBYTE,               /* Type of button - see possible values below (TDT_). */
  Key:UBYTE,                /* Hotkey */
  Flags:UWORD,              /* The buttons current setting - see the TDF_ flags */
  ToolText:PTR TO UBYTE,    /* The text beneath the icons. */
  HelpString:PTR TO UBYTE,  /* The string used for help-bubbles or MUIA_Toolbar_HelpString */
  MutualExclude:ULONG       /* Buttons to be released when this button is pressed down */


/*** Toolbar Description Types ***/

CONST TDT_BUTTON  =0
CONST TDT_SPACE   =1
CONST TDT_IGNORE  =2 // Obsolete
CONST TDT_END     =3

CONST TDT_IGNORE_FLAG =128

/*** Toolbar Description Flags ***/

CONST TDF_TOGGLE      =$01 /* Set this if it's a toggle-button */
CONST TDF_RADIO       =$02 /* AND this if it's also a radio-button */
CONST TDF_GHOSTED     =$04
CONST TDF_GONE        =$08 /* Make the button temporarily go away */
CONST TDF_SELECTED    =$10 /* State of a toggle-button */

#define TDF_RADIOTOGGLE (TDF_TOGGLE|TDF_RADIO) /* A practical definition */

/* TDF_RADIO and TDF_SELECTED only makes sense
   if you have set the TDF_TOGGLE flag.          */

/*** Toolbar Macros ***/

#define Toolbar_Button(flags, text)           TDT_BUTTON, NIL, flags, text, NIL, NIL
#define Toolbar_KeyButton(flags, text, key)   TDT_BUTTON, key,  flags, text, NIL, NIL
#define Toolbar_Space                         TDT_SPACE,  NIL, NIL,  NIL, NIL, NIL
#define Toolbar_End                           TDT_END,    NIL, NIL,  NIL, NIL, NIL


