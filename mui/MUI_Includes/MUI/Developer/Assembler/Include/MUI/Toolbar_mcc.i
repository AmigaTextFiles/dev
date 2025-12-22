	IFND	TOOLBAR_MCC_I
TOOLBAR_MCC_I	SET	1

**
** $VER: Toolbar_mcc.h V15.5
** Copyright © 1997-98 Benny Kjær Nielsen. All rights reserved.
**
** Assembler version by Ilkka Lehtoranta (1 Dec 1999)

*** Include stuff ***

	IFND	LIBRARIES_MUI_I
	INCLUDE	"libraries/mui.i"
	ENDC

	IFND	EXEC_TYPES_I
	INCLUDE	"exec/types.i"
	ENDC


	IFND	BENNY_SERIAL
BENNY_SERIAL	EQU	(31991<<16)
	ENDC

*** MUI Defines ***

;#define MUIC_Toolbar "Toolbar.mcc"
;#define ToolbarObject MUI_NewObject(MUIC_Toolbar

*** Methods ***

MUIM_Toolbar_BottomEdge		EQU	(TAG_USER | BENNY_SERIAL | $0007 )
MUIM_Toolbar_KillNotify		EQU	(TAG_USER | BENNY_SERIAL | $0002 )
MUIM_Toolbar_KillNotifyObj	EQU	(TAG_USER | BENNY_SERIAL | $0003 )
MUIM_Toolbar_LeftEdge		EQU	(TAG_USER | BENNY_SERIAL | $0008 )
MUIM_Toolbar_MultiSet		EQU	(TAG_USER | BENNY_SERIAL | $0004 )
MUIM_Toolbar_Notify		EQU	(TAG_USER | BENNY_SERIAL | $0001 )
MUIM_Toolbar_Redraw		EQU	(TAG_USER | BENNY_SERIAL | $0005 )
MUIM_Toolbar_ReloadImages	EQU	(TAG_USER | BENNY_SERIAL | $000B )
MUIM_Toolbar_RightEdge		EQU	(TAG_USER | BENNY_SERIAL | $0009 )
MUIM_Toolbar_Set		EQU	(TAG_USER | BENNY_SERIAL | $0006 )
MUIM_Toolbar_TopEdge		EQU	(TAG_USER | BENNY_SERIAL | $000A )

*** Method structs ***

	ENDASM
struct MUIP_Toolbar_Edge	     {ULONG MethodID; ULONG Button; };
struct MUIP_Toolbar_KillNotify       {ULONG MethodID; ULONG TrigButton; ULONG TrigAttr; };
struct MUIP_Toolbar_KillNotifyObj    {ULONG MethodID; };
struct MUIP_Toolbar_MultiSet         {ULONG MethodID; ULONG Flag; ULONG Value; ULONG Button; /* ... */ };
struct MUIP_Toolbar_Notify           {ULONG MethodID; ULONG TrigButton; ULONG TrigAttr; ULONG TrigValue; APTR DestObj; ULONG FollowParams; /* ... */};
struct MUIP_Toolbar_Redraw           {ULONG MethodID; ULONG Changes; };
struct MUIP_Toolbar_ReloadImages     {ULONG MethodID; STRPTR Normal; STRPTR Select; STRPTR Ghost; };
struct MUIP_Toolbar_Set 	     {ULONG MethodID; ULONG Button; ULONG Flag; ULONG Value; };
	ASM

*** Special method values ***

MUIV_Toolbar_Set_Ghosted	EQU	$0000004
MUIV_Toolbar_Set_Gone		EQU	$0000008
MUIV_Toolbar_Set_Selected	EQU	$0000010

MUIV_Toolbar_Notify_Pressed	EQU	$0000000
MUIV_Toolbar_Notify_Active	EQU	$0000001
MUIV_Toolbar_Notify_Ghosted	EQU	$0000002
MUIV_Toolbar_Notify_Gone	EQU	$0000003
MUIV_Toolbar_Notify_LeftEdge	EQU	$0000004
MUIV_Toolbar_Notify_RightEdge	EQU	$0000005
MUIV_Toolbar_Notify_TopEdge	EQU	$0000006
MUIV_Toolbar_Notify_BottomEdge	EQU	$0000007

*** Special method flags ***

*** Attributes ***

MUIA_Toolbar_Description	EQU	(TAG_USER | BENNY_SERIAL | $0016 )
MUIA_Toolbar_HelpString		EQU	(TAG_USER | BENNY_SERIAL | $0017 )
MUIA_Toolbar_Horizontal		EQU	(TAG_USER | BENNY_SERIAL | $0015 )
MUIA_Toolbar_ImageGhost		EQU	(TAG_USER | BENNY_SERIAL | $0013 )
MUIA_Toolbar_ImageNormal	EQU	(TAG_USER | BENNY_SERIAL | $0011 )
MUIA_Toolbar_ImageSelect	EQU	(TAG_USER | BENNY_SERIAL | $0012 )
MUIA_Toolbar_ImageType		EQU	(TAG_USER | BENNY_SERIAL | $0010 )
MUIA_Toolbar_ParseUnderscore	EQU	(TAG_USER | BENNY_SERIAL | $0018 )
MUIA_Toolbar_Permutation	EQU	(TAG_USER | BENNY_SERIAL | $001A )
MUIA_Toolbar_Reusable		EQU	(TAG_USER | BENNY_SERIAL | $0019 )

*** Special attribute values ***

MUIV_Toolbar_ImageType_File	EQU	0
MUIV_Toolbar_ImageType_Memory	EQU	1
MUIV_Toolbar_ImageType_Object	EQU	2

*** Structures, Flags & Values ***

	ENDASM
struct MUIP_Toolbar_Description
{
  UBYTE   Type; 	 ; Type of button - see possible values below (TDT_). */
  UBYTE   Key;  	 ; Hotkey */
  UWORD   Flags;	 ; The buttons current setting - see the TDF_ flags */
  STRPTR  ToolText;      ; The text beneath the icons. */
  STRPTR  HelpString;    ; The string used for help-bubbles or MUIA_Toolbar_HelpString */
  ULONG   MutualExclude; ; Buttons to be released when this button is pressed down */
};
	ASM

*** Toolbar Description Types ***

TDT_BUTTON	EQU	0
TDT_SPACE	EQU	1
TDT_IGNORE	EQU	2 ; Obsolete
TDT_END		EQU	3

TDT_IGNORE_FLAG	EQU	128

*** Toolbar Description Flags ***

TDF_TOGGLE	EQU	$0000001 ; Set this if it's a toggle-button
TDF_RADIO	EQU	$0000002 ; AND this if it's also a radio-button
TDF_GHOSTED	EQU	$0000004
TDF_GONE	EQU	$0000008 ; Make the button temporarily go away
TDF_SELECTED	EQU	$0000010 ; State of a toggle-button

TDF_RADIOTOGGLE	EQU	(TDF_TOGGLE|TDF_RADIO) ; A practical definition

* TDF_RADIO and TDF_SELECTED only makes sense
* if you have set the TDF_TOGGLE flag.

*** Toolbar Macros ***

;#define Toolbar_Button(flags, text)          { TDT_BUTTON, NULL, flags, text, NULL, NULL}
;#define Toolbar_KeyButton(flags, text, key)  { TDT_BUTTON, key,  flags, text, NULL, NULL}
;#define Toolbar_Space   		     { TDT_SPACE,  NULL, NULL,  NULL, NULL, NULL}
;#define Toolbar_End     		     { TDT_END,    NULL, NULL,  NULL, NULL, NULL}

	ENDC	; TOOLBAR_MCC_I
