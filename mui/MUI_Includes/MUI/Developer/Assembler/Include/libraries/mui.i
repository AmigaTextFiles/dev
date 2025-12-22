****************************************************************************
**
** MUI - MagicUserInterface V2.3
** (c) 1993-95 by Stefan Stuntz
**
** Main Header File
**
*** Assembler modifications 05-Jan-95 by Stefan Sommerfeld.
*** Updated 12-May-99 to version 3.8 by Ilkka Lehtoranta.
** 
**
****************************************************************************
** General Header File Information
****************************************************************************
**
** All macro and structure definitions follow these rules:
**
** Name 		      Meaning
**
** MUIC_<class> 	      Name of a class
** MUIM_<class>_<method>      Method
** MUIP_<class>_<method>      Methods parameter structure
** MUIV_<class>_<method>_<x>  Special method value
** MUIA_<class>_<attrib>      Attribute
** MUIV_<class>_<attrib>_<x>  Special attribute value
** MUIE_<error> 	      Error return code from MUI_Error()
** MUII_<name>  	      Standard MUI image
** MUII_<name>  	      Object type for MUI_MakeObject()
**
** MUIA_... attribute definitions are followed by a comment
** consisting of the three possible letters I, S and G.
** I: it's possible to specify this attribute at object creation time.
** S: it's possible to change this attribute with SetAttrs().
** G: it's possible to get this attribute with GetAttr().
**
** Items marked with "Custom Class" are for use in custom classes only!



	IFND LIBRARIES_MUI_I
LIBRARIES_MUI_I SET 1

	IFND EXEC_TYPES_I
	INCLUDE "exec/types.i"
	ENDC	;EXEC_TYPES_I

	IFND INTUITION_CLASSES_I
	INCLUDE "intuition/classes.i"
	ENDC	;INTUITION_CLASSES_I

	IFND INTUITION_SCREENS_I
	INCLUDE "intuition/screens.i"
	ENDC	;INTUITION_SCREENS_I

	IFND UTILITY_HOOKS_I
	INCLUDE "utility/hooks.i"
	ENDC	;UTILITY_HOOKS_I

	IFND LIBRARIES_ASL_I
	INCLUDE "libraries/asl.i"
	ENDC

****************************************************************************
** Library specification
****************************************************************************

MUIMASTER_NAME MACRO
	dc.b	"muimaster.library",0
	even
	ENDM
MUIMASTER_VMIN = 8
CALLMUI  MACRO
	move.l	_MUIMasterBase,a6
	jsr	_LVO\1(a6)
	ENDM

	ENDASM
NULL     =      0
TRUE     =      1
FALSE    =      NULL
	ASM


***************************************************************************
** Object Types for MUI_MakeObject()
***************************************************************************

MUIO_Label		= 1	* STRPTR label, ULONG flags 
MUIO_Button		= 2	* STRPTR label
MUIO_Checkmark		= 3	* STRPTR label
MUIO_Cycle		= 4	* STRPTR label, STRPTR *entries 
MUIO_Radio		= 5	* STRPTR label, STRPTR *entries 
MUIO_Slider		= 6	* STRPTR label, LONG min, LONG max 
MUIO_String		= 7	* STRPTR label, LONG maxlen 
MUIO_PopButton		= 8	* STRPTR imagespec 
MUIO_HSpace		= 9	* LONG space   
MUIO_VSpace		= 10	* LONG space   
MUIO_HBar		= 11	* LONG space   
MUIO_VBar		= 12	* LONG space   
MUIO_MenustripNM	= 13	* struct NewMenu .*ULONG flags 
MUIO_Menuitem		= 14	* STRPTR label, STRPTR shortcut, ULONG flags, ULONG data 
MUIO_BarTitle		= 15	* STRPTR label 
MUIO_NumericButton	= 16	* STRPTR label, LONG min, LONG max, STRPTR format

MUIO_Menuitem_CopyStrings	= 1<<30

MUIO_Label_SingleFrame	= 1<<8
MUIO_Label_DoubleFrame	= 1<<9
MUIO_Label_LeftAligned	= 1<<10
MUIO_Label_Centered	= 1<<11
MUIO_Label_FreeVert	= 1<<12

MUIO_MenustripNM_CommandKeyCheck	= 1<<0 * check for "localized" menu items such as "O\0Open"


****************************************************************************
** ARexx Interface
****************************************************************************
*
* STRUCTURE MUI_Command,0
*   APTR     mc_Name
*   APTR     mc_Template
*   LONG     mc_Parameters
*   STRUCT   mc_Hook,h_SIZEOF
*   STRUCT   mc_Reserved,4*5
*   LABEL    MUI_Command_SIZEOF

MC_TEMPLATE_ID = ~0


MUI_RXERR_BADDEFINITION		= -1
MUI_RXERR_OUTOFMEMORY		= -2
MUI_RXERR_UNKNOWNCOMMAND	= -3
MUI_RXERR_BADSYNTAX		= -4



****************************************************************************
** Return values for MUI_Error()
****************************************************************************

MUIE_OK				= 0
MUIE_OutOfMemory		= 1
MUIE_OutOfGfxMemory		= 2
MUIE_InvalidWindowObject	= 3
MUIE_MissingLibrary		= 4
MUIE_NoARexx			= 5
MUIE_SingleTask			= 6



****************************************************************************
** Standard MUI Images & Backgrounds
****************************************************************************

MUII_WindowBack		= 0	; These images are configured
MUII_RequesterBack	= 1	; with the preferences program.
MUII_ButtonBack		= 2
MUII_ListBack		= 3
MUII_TextBack		= 4
MUII_PropBack		= 5
MUII_PopupBack		= 6
MUII_SelectedBack	= 7
MUII_ListCursor		= 8
MUII_ListSelect		= 9
MUII_ListSelCur		= 10
MUII_ArrowUp		= 11
MUII_ArrowDown		= 12
MUII_ArrowLeft		= 13
MUII_ArrowRight		= 14
MUII_CheckMark		= 15
MUII_RadioButton	= 16
MUII_Cycle		= 17
MUII_PopUp		= 18
MUII_PopFile		= 19
MUII_PopDrawer		= 20
MUII_PropKnob		= 21
MUII_Drawer		= 22
MUII_HardDisk		= 23
MUII_Disk		= 24
MUII_Chip		= 25
MUII_Volume		= 26
MUII_PopUpBack		= 27
MUII_Network		= 28
MUII_Assign		= 29
MUII_TapePlay		= 30
MUII_TapePlayBack	= 31
MUII_TapePause		= 32
MUII_TapeStop		= 33
MUII_TapeRecord		= 34
MUII_GroupBack		= 35
MUII_SliderBack		= 36
MUII_SliderKnob		= 37
MUII_TapeUp		= 38
MUII_TapeDown		= 39
MUII_PageBack		= 40
MUII_ReadListBack	= 41
MUII_Count		= 42

MUII_BACKGROUND		= 128
MUII_SHADOW		= 129
MUII_SHINE		= 130
MUII_FILL		= 131
MUII_SHADOWBACK		= 132
MUII_SHADOWFILL		= 133
MUII_SHADOWSHINE	= 134
MUII_FILLBACK		= 135
MUII_FILLSHINE		= 136
MUII_SHINEBACK		= 137
MUII_FILLBACK2		= 138
MUII_HSHINEBACK		= 139
MUII_HSHADOWBACK	= 140
MUII_HSHINESHINE	= 141
MUII_HSHADOWSHADOW	= 142
MUII_MARKSHINE		= 143
MUII_MARKHALFSHINE	= 144
MUII_MARKBACKGROUND	= 145
MUII_LASTPAT		= 145


****************************************************************************
** Special values for some methods 
****************************************************************************

MUIV_TriggerValue	= $49893131
MUIV_NotTriggerValue	= $49893133
MUIV_EveryTime		= $49893131

MUIV_Notify_Self		= 1
MUIV_Notify_Window		= 2
MUIV_Notify_Application		= 3
MUIV_Notify_Parent		= 4

MUIV_Application_Save_ENV	= 0
MUIV_Application_Save_ENVARC	= ~0
MUIV_Application_Load_ENV	= 0
MUIV_Application_Load_ENVARC	= ~0

MUIV_Application_ReturnID_Quit	= -1

MUIV_List_Insert_Top		= 0
MUIV_List_Insert_Active		= -1
MUIV_List_Insert_Sorted		= -2
MUIV_List_Insert_Bottom		= -3

MUIV_List_Remove_First		= 0
MUIV_List_Remove_Active		= -1
MUIV_List_Remove_Last		= -2
MUIV_List_Remove_Selected	= -3

MUIV_List_Select_Off		= 0
MUIV_List_Select_On		= 1
MUIV_List_Select_Toggle		= 2
MUIV_List_Select_Ask		= 3

MUIV_List_GetEntry_Active	= -1
MUIV_List_Select_Active		= -1
MUIV_List_Select_All		= -2

MUIV_List_Redraw_Active		= -1
MUIV_List_Redraw_All		= -2

MUIV_List_Move_Top		= 0
MUIV_List_Move_Active		= -1
MUIV_List_Move_Bottom		= -2
MUIV_List_Move_Next		= -3 ; only valid for second parameter 
MUIV_List_Move_Previous		= -4 ; only valid for second parameter
 
MUIV_List_Exchange_Top		=  0
MUIV_List_Exchange_Active	= -1
MUIV_List_Exchange_Bottom	= -2
MUIV_List_Exchange_Next		= -3 ; only valid for second parameter
MUIV_List_Exchange_Previous	= -4 ; only valid for second parameter

MUIV_List_Jump_Top		= 0
MUIV_List_Jump_Active		= -1
MUIV_List_Jump_Bottom		= -2
MUIV_List_Jump_Up		= -4
MUIV_List_Jump_Down		= -3

MUIV_Colorpanel_GetColor_Active	= -1
MUIV_Colorpanel_SetColor_Active	= -1

MUIV_List_NextSelected_Start	= -1
MUIV_List_NextSelected_End	= -1

MUIV_DragQuery_Refuse		EQU	0
MUIV_DragQuery_Accept		EQU	1

MUIV_DragReport_Abort		EQU	0	
MUIV_DragReport_Continue	EQU	1
MUIV_DragReport_Lock		EQU	2
MUIV_DragReport_Refresh		EQU	3

***************************************************************************
** Parameter structures for some classes
***************************************************************************

* STRUCTURE MUI_Palette_Entry,0
*   LONG    mpe_ID
*   LONG    mpe_Red
*   LONG    mpe_Green
*   LONG    mpe_Blue
*   LONG    mpe_Group
*   LABEL   MUI_Palette_Entry_SIZEOF

MUIV_Palette_Entry_End = -1


* STRUCTURE MUI_Scrmodelist_Entry,0
*   APTR     sme_Name
*   LONG     sme_ModeID
*   LABEL    MUI_Scrmodelist_Entry_SIZEOF





*********************************************
** Begin of automatic header file creation **
*********************************************




****************************************************************************
** Notify
****************************************************************************

** Methods **

MUIM_CallHook		= $8042b96b ;** V4  **
MUIM_Export		= $80420f1c ;** V12 **
MUIM_FindUData		= $8042c196 ;** V8  **
MUIM_GetConfigItem	= $80423edb ;** V11 **
MUIM_GetUData		= $8042ed0c ;** V8  **
MUIM_KillNotify		= $8042d240 ;** V4  **
MUIM_KillNotifyObj	= $8042b145 ;** V16 **
MUIM_MultiSet		= $8042d356 ;** V7  **
MUIM_NoNotifySet	= $8042216f ;** V9  **
MUIM_Notify		= $8042c9cb ;** V4  **
MUIM_Set		= $8042549a ;** V4  **
MUIM_SetAsString	= $80422590 ;** V4  **
MUIM_SetUData		= $8042c920 ;** V8  **
MUIM_SetUDataOnce	= $8042ca19 ;** V11 **
MUIM_WriteLong		= $80428d86 ;** V6  **
MUIM_WriteString	= $80424bf4 ;** V6  **

** Attributes **

MUIA_ApplicationObject	= $8042d3ee ;** V4  ..g Object *
MUIA_AppMessage		= $80421955 ;** V5  ..g struct AppMessage *
MUIA_HelpLine		= $8042a825 ;** V4  isg LONG
MUIA_HelpNode		= $80420b85 ;** V4  isg STRPTR
MUIA_NoNotify		= $804237f9 ;** V7  .s. BOOL
MUIA_ObjectID		= $8042d76e ;** V11 isg ULONG
MUIA_Parent		= $8042e35f ;** V11 ..g Object *
MUIA_Revision		= $80427eaa ;** V4  ..g LONG
MUIA_UserData		= $80420313 ;** V4  isg ULONG
MUIA_Version		= $80422301 ;** V4  ..g LONG



****************************************************************************
** Family
****************************************************************************

** Methods **

MUIM_Family_AddHead	= $8042e200 ;** V8  **
MUIM_Family_AddTail	= $8042d752 ;** V8  **
MUIM_Family_Insert	= $80424d34 ;** V8  **
MUIM_Family_Remove	= $8042f8a9 ;** V8  **
MUIM_Family_Sort	= $80421c49 ;** V8  **
MUIM_Family_Transfer	= $8042c14a ;** V8  **

** Attributes **

MUIA_Family_Child	= $8042c696 ;** V8  i.. Object
MUIA_Family_List	= $80424b9e ;** V8  ..g struct MinList *



****************************************************************************
** Menustrip
****************************************************************************

;** Methods **


;** Attributes **

MUIA_Menustrip_Enabled	= $8042815b ;** V8  isg BOOL



****************************************************************************
** Menu
****************************************************************************

;** Methods **


;** Attributes **

MUIA_Menu_Enabled	= $8042ed48 ;** V8  isg BOOL
MUIA_Menu_Title		= $8042a0e3 ;** V8  isg STRPTR



****************************************************************************
** Menuitem
****************************************************************************

** Methods **


** Attributes **

MUIA_Menuitem_Checked		= $8042562a ;** V8  isg BOOL
MUIA_Menuitem_Checkit		= $80425ace ;** V8  isg BOOL
MUIA_Menuitem_CommandString	= $8042b9cc ;** V16 isg BOOL
MUIA_Menuitem_Enabled		= $8042ae0f ;** V8  isg BOOL
MUIA_Menuitem_Exclude		= $80420bc6 ;** V8  isg LONG
MUIA_Menuitem_Shortcut		= $80422030 ;** V8  isg char
MUIA_Menuitem_Title		= $804218be ;** V8  isg STRPTR
MUIA_Menuitem_Toggle		= $80424d5c ;** V8  isg BOOL
MUIA_Menuitem_Trigger		= $80426f32 ;** V8  ..g struct MenuItem

MUIV_Menuitem_Shortcut_Check	EQU	-1


****************************************************************************
** Application
****************************************************************************

** Methods **

MUIM_Application_AboutMUI		= $8042d21d ;** V14
MUIM_Application_AddInputHandler	= $8042f099 ;** V11
MUIM_Application_CheckRefresh		= $80424d68 ;** V11
	IFD	MUI_OBSOLETE
MUIM_Application_GetMenuCheck		= $8042c0a7 ;** V4  **
MUIM_Application_GetMenuState		= $8042a58f ;** V4  **
MUIM_Application_Input			= $8042d0f5 ;** V4  **
	ENDC
MUIM_Application_InputBuffered		= $80427e59 ;** V4  **
MUIM_Application_Load			= $8042f90d ;** V4  **
MUIM_Application_NewInput		= $80423ba6 ;** V11
MUIM_Application_OpenConfigWindow	= $804299ba ;** V11
MUIM_Application_PushMethod		= $80429ef8 ;** V4  **
MUIM_Application_RemInputHandler	= $8042e7af ;** V11
MUIM_Application_ReturnID		= $804276ef ;** V4  **
MUIM_Application_Save			= $804227ef ;** V4  **
MUIM_Application_SetConfigItem		= $80424a80 ;** V11
	IFD	MUI_OBSOLETE
MUIM_Application_SetMenuCheck		= $8042a707 ;** V4  **
MUIM_Application_SetMenuState		= $80428bef ;** V4  **
	ENDC
MUIM_Application_ShowHelp		= $80426479 ;** V4  **

** Attributes **

MUIA_Application_Active		= $804260ab ;** V4  isg BOOL
MUIA_Application_Author		= $80424842 ;** V4  i.g STRPTR
MUIA_Application_Base		= $8042e07a ;** V4  i.g STRPTR
MUIA_Application_Broker		= $8042dbce ;** V4  ..g Broker
MUIA_Application_BrokerHook	= $80428f4b ;** V4  isg struct Hook
MUIA_Application_BrokerPort	= $8042e0ad ;** V6  ..g struct MsgPort
MUIA_Application_BrokerPri	= $8042c8d0 ;** V6  i.g LONG
MUIA_Application_Commands	= $80428648 ;** V4  isg struct MUI_Command
MUIA_Application_Copyright	= $8042ef4d ;** V4  i.g STRPTR
MUIA_Application_Description	= $80421fc6 ;** V4  i.g STRPTR
MUIA_Application_DiskObject	= $804235cb ;** V4  isg struct DiskObject
MUIA_Application_DoubleStart	= $80423bc6 ;** V4  ..g BOOL
MUIA_Application_DropObject	= $80421266 ;** V5  is. Object
MUIA_Application_ForceQuit	= $804257df ;** V8  ..g BOOL
MUIA_Application_HelpFile	= $804293f4 ;** V8  isg STRPTR
MUIA_Application_Iconified	= $8042a07f ;** V4  .sg BOOL
	IFD	MUI_OBSOLETE
MUIA_Application_Menu		= $80420e1f ;** V4  i.g struct NewMenu
	ENDC
MUIA_Application_MenuAction	= $80428961 ;** V4  ..g ULONG
MUIA_Application_MenuHelp	= $8042540b ;** V4  ..g ULONG
MUIA_Application_Menustrip	= $804252d9 ;** V8  i.. Object
MUIA_Application_RexxHook	= $80427c42 ;** V7  isg struct Hook
MUIA_Application_RexxMsg	= $8042fd88 ;** V4  ..g struct RxMsg
MUIA_Application_RexxString	= $8042d711 ;** V4  .s. STRPTR
MUIA_Application_SingleTask	= $8042a2c8 ;** V4  i.. BOOL
MUIA_Application_Sleep		= $80425711 ;** V4  .s. BOOL
MUIA_Application_Title		= $804281b8 ;** V4  i.g STRPTR
MUIA_Application_UseCommodities	= $80425ee5 ;** V10 i.. BOOL
MUIA_Application_UseRexx	= $80422387 ;** V10 i.. BOOL
MUIA_Application_Version	= $8042b33f ;** V4  i.g STRPTR
MUIA_Application_Window		= $8042bfe0 ;** V4  i.. Object
MUIA_Application_WindowList	= $80429abe ;** V13 ..g struct List *

MUIV_Application_Package_NetConnect	EQU	$a3ff7b49


****************************************************************************
** Window
****************************************************************************

** Methods **

MUIM_Window_AddEventHandler	= $804203b7 ;** V16
	IFD	MUI_OBSOLETE
MUIM_Window_GetMenuCheck	= $80420414 ;** V4
MUIM_Window_GetMenuState	= $80420d2f ;** V4
	ENDC
MUIM_Window_RemEventHandler	= $8042679e ;** V16
MUIM_Window_ScreenToBack	= $8042913d ;** V4
MUIM_Window_ScreenToFront	= $804227a4 ;** V4
	IFD	MUI_OBSOLETE
MUIM_Window_SetCycleChain	= $80426510 ;** V4
MUIM_Window_SetMenuCheck	= $80422243 ;** V4
MUIM_Window_SetMenuState	= $80422b5e ;** V4
	ENDC
MUIM_Window_Snapshot		= $8042945e ;** V11
MUIM_Window_ToBack		= $8042152e ;** V4
MUIM_Window_ToFront		= $8042554f ;** V4

;** Attributes **

MUIA_Window_Activate		= $80428d2f ;** V4  isg BOOL
MUIA_Window_ActiveObject	= $80427925 ;** V4  .sg Object
MUIA_Window_AltHeight		= $8042cce3 ;** V4  i.g LONG
MUIA_Window_AltLeftEdge		= $80422d65 ;** V4  i.g LONG
MUIA_Window_AltTopEdge		= $8042e99b ;** V4  i.g LONG
MUIA_Window_AltWidth		= $804260f4 ;** V4  i.g LONG
MUIA_Window_AppWindow		= $804280cf ;** V5  i.. BOOL
MUIA_Window_Backdrop		= $8042c0bb ;** V4  i.. BOOL
MUIA_Window_Borderless		= $80429b79 ;** V4  i.. BOOL
MUIA_Window_CloseGadget		= $8042a110 ;** V4  i.. BOOL
MUIA_Window_CloseRequest	= $8042e86e ;** V4  ..g BOOL
MUIA_Window_DefaultObject	= $804294d7 ;** V4  isg Object
MUIA_Window_DepthGadget		= $80421923 ;** V4  i.. BOOL
MUIA_Window_DragBar		= $8042045d ;** V4  i.. BOOL
MUIA_Window_FancyDrawing	= $8042bd0e ;** V8  isg BOOL
MUIA_Window_Height		= $80425846 ;** V4  i.g LONG
MUIA_Window_ID			= $804201bd ;** V4  isg ULONG
MUIA_Window_InputEvent		= $804247d8 ;** V4  ..g struct InputEvent
MUIA_Window_IsSubWindow		= $8042b5aa ;** V4  isg BOOL
MUIA_Window_LeftEdge		= $80426c65 ;** V4  i.g LONG
	IFD	MUI_OBSOLETE
MUIA_Window_Menu		= $8042db94 ;** V4  i.. struct NewMenu
	ENDC
MUIA_Window_MenuAction		= $80427521 ;** V8  isg ULONG
MUIA_Window_Menustrip		= $8042855e ;** V8  i.. Object
MUIA_Window_MouseObject		= $8042bf9b ;** V10 ..g Object
MUIA_Window_NeedsMouseObject	= $8042372a ;** V10 i.. BOOL
MUIA_Window_NoMenus		= $80429df5 ;** V4  is. BOOL
MUIA_Window_Open		= $80428aa0 ;** V4  .sg BOOL
MUIA_Window_PublicScreen	= $804278e4 ;** V6  isg STRPTR
MUIA_Window_RefWindow		= $804201f4 ;** V4  is. Object
MUIA_Window_RootObject		= $8042cba5 ;** V4  i.. Object
MUIA_Window_Screen		= $8042df4f ;** V4  isg struct Screen
MUIA_Window_ScreenTitle		= $804234b0 ;** V5  isg STRPTR
MUIA_Window_SizeGadget		= $8042e33d ;** V4  i.. BOOL
MUIA_Window_SizeRight		= $80424780 ;** V4  i.. BOOL
MUIA_Window_Sleep		= $8042e7db ;** V4  .sg BOOL
MUIA_Window_Title		= $8042ad3d ;** V4  isg STRPTR
MUIA_Window_TopEdge		= $80427c66 ;** V4  i.g LONG
MUIA_Window_UseBottomBorderScroller	= $80424e79 ;** V13 isg BOOL
MUIA_Window_UseLeftBorderScroller	= $8042433e ;** V13 isg BOOL
MUIA_Window_UseRightBorderScroller	= $8042c05e ;** V13 isg BOOL
MUIA_Window_Width			= $8042dcae ;** V4  i.g LONG
MUIA_Window_Window	 		= $80426a42 ;** V4  ..g struct Window

MUIV_Window_ActiveObjectNone	= 0
MUIV_Window_ActiveObjectNext	= -1
MUIV_Window_ActiveObjectPrev	= -2
MUIV_Window_AltHeightMinMax	= 0
MUIV_Window_AltHeightVisible	= -100
MUIV_Window_AltHeightScreen	= -200
MUIV_Window_AltHeightScaled	= -1000
MUIV_Window_AltLeftEdgeCentered	= -1
MUIV_Window_AltLeftEdgeMoused	= -2
MUIV_Window_AltLeftEdgeNoChangr	= -1000
MUIV_Window_AltTopEdgeCentered	= -1
MUIV_Window_AltTopEdgeMoused	= -2
MUIV_Window_AltTopEdgeDelta	= -3
MUIV_Window_AltTopEdgeNoChange	= -1000
MUIV_Window_AltWidthMinMax	= 0
MUIV_Window_AltWidthVisible	= -100
MUIV_Window_AltWidthScreen	= -200
MUIV_Window_AltWidthScaled	= -1000
MUIV_Window_HeightMinMax	= 0
MUIV_Window_HeightVisible	= -100
MUIV_Window_HeightScreen	= -200
MUIV_Window_HeightScaled	= -1000
MUIV_Window_HeightDefault	= -1001
MUIV_Window_LeftEdgeCentered	= -1
MUIV_Window_LeftEdgeMoused	= -2
	IFD	MUI_OBSOLETE
MUIV_Window_Menu_NoMenu		= -1
	ENDC
MUIV_Window_TopEdgeCentered	= -1
MUIV_Window_TopEdgeMoused	= -2
MUIV_Window_TopEdgeDelta	= -3
MUIV_Window_WidthMinMax		= 0
MUIV_Window_WidthVisible	= -100
MUIV_Window_WidthScreen		= -200
MUIV_Window_WidthScaled		= -1000
MUIV_Window_WidthDefault	= -1001


****************************************************************************
** Aboutmui
****************************************************************************

** Methods **


** Attributes **

MUIA_Aboutmui_Application	EQU	80422523 ;** V11 i.. Object *



****************************************************************************
** Area
****************************************************************************

** Methods **

MUIM_AskMinMax		= $80423874 ;** V4
MUIM_Cleanup		= $8042d985 ;** V4
MUIM_ContextMenuBuild	= $80429d2e ;** V11
MUIM_ContextMenuChoice	= $80420f0e ;** V11
MUIM_CreateBubble	= $80421c41 ;** V18
MUIM_CreateShortHelp	= $80428e93 ;** V11
MUIM_DeleteBubble	= $804211af ;** V18
MUIM_DeleteShortHelp	= $8042d35a ;** V11
MUIM_DragBegin		= $8042c03a ;** V11
MUIM_DragDrop		= $8042c555 ;** V11
MUIM_DragFinish		= $804251f0 ;** V11
MUIM_DragQuery		= $80420261 ;** V11
MUIM_DragReport		= $8042edad ;** V11
MUIM_Draw		= $80426f3f ;** V4
MUIM_DrawBackground	= $804238ca ;** V11
MUIM_HandleEvent	= $80426d66 ;** Custom Class V16
MUIM_HandleInput	= $80422a1a ;** V4
MUIM_Hide		= $8042f20f ;** V4
MUIM_Setup		= $80428354 ;** V4
MUIM_Show		= $8042cc84 ;** V4

;** Attributes **

MUIA_Background		= $8042545b ;** V4  is. LONG
MUIA_BottomEdge		= $8042e552 ;** V4  ..g LONG
MUIA_ContextMenu	= $8042b704 ;** V11 isg Object *
MUIA_ContextMenuTrigger	= $8042a2c1 ;** V11 ..g Object *
MUIA_ControlChar	= $8042120b ;** V4  i.. char
MUIA_CycleChain		= $80421ce7 ;** V11 isg LONG
MUIA_Disabled		= $80423661 ;** V4  isg BOOL
MUIA_Draggable		= $80420b6e ;** V11 isg BOOL
MUIA_Dropable		= $8042fbce ;** V11 isg BOOL
	IFD	MUI_OBSOLETE
MUIA_ExportID		= $8042d76e ;** V4  isg LONG
	ENDC
MUIA_FillArea		= $804294a3 ;** V4  is. BOOL
MUIA_FixHeight		= $8042a92b ;** V4  i.. LONG
MUIA_FixHeightTxt	= $804276f2 ;** V4  i.. LONG
MUIA_FixWidth		= $8042a3f1 ;** V4  i.. LONG
MUIA_FixWidthTxt	= $8042d044 ;** V4  i.. STRPTR
MUIA_Font		= $8042be50 ;** V4  i.g struct TextFont
MUIA_Frame		= $8042ac64 ;** V4  i.. LONG
MUIA_FramePhantomHoriz	= $8042ed76 ;** V4  i.. BOOL
MUIA_FrameTitle		= $8042d1c7 ;** V4  i.. STRPTR
MUIA_Height		= $80423237 ;** V4  ..g LONG
MUIA_HorizDisappear	= $80429615 ;** V11 isg LONG
MUIA_HorizWeight	= $80426db9 ;** V4  i.. WORD
MUIA_InnerBottom	= $8042f2c0 ;** V4  i.. LONG
MUIA_InnerLeft		= $804228f8 ;** V4  i.. LONG
MUIA_InnerRight		= $804297ff ;** V4  i.. LONG
MUIA_InnerTop		= $80421eb6 ;** V4  i.. LONG
MUIA_InputMode		= $8042fb04 ;** V4  i.. LONG
MUIA_LeftEdge		= $8042bec6 ;** V4  ..g LONG
MUIA_MaxHeight		= $804293e4 ;** V11 i.. LONG
MUIA_MaxWidth		= $8042f112 ;** V11 i.. LONG
MUIA_Pressed		= $80423535 ;** V4  ..g BOOL
MUIA_RightEdge		= $8042ba82 ;** V4  ..g LONG
MUIA_Selected		= $8042654b ;** V4  isg BOOL
MUIA_ShortHelp		= $80428fe3 ;** V11 isg STRPTR
MUIA_ShowMe		= $80429ba8 ;** V4  isg BOOL
MUIA_ShowSelState	= $8042caac ;** V4  i.. BOOL
MUIA_Timer		= $80426435 ;** V4  ..g LONG
MUIA_TopEdge		= $8042509b ;** V4  ..g LONG
MUIA_VertDisappear	= $8042d12f ;** V11 isg LONG
MUIA_VertWeight		= $804298d0 ;** V4  i.. WORD
MUIA_Weight		= $80421d1f ;** V4  i.. WORD
MUIA_Width		= $8042b59c ;** V4  ..g LONG
MUIA_Window		= $80421591 ;** V4  ..g struct Window
MUIA_WindowObject	= $8042669e ;** V4  ..g Object

MUIV_Font_Inherit		= 0
MUIV_Font_Normal		= -1
MUIV_Font_List			= -2
MUIV_Font_Tiny			= -3
MUIV_Font_Fixed			= -4
MUIV_Font_Title			= -5
MUIV_Font_Big			= -6
MUIV_Font_Button		= -7
MUIV_Frame_None			= 0
MUIV_Frame_Button		= 1
MUIV_Frame_ImageButton		= 2
MUIV_Frame_Text			= 3
MUIV_Frame_String		= 4
MUIV_Frame_ReadList		= 5
MUIV_Frame_InputList		= 6
MUIV_Frame_Prop			= 7
MUIV_Frame_Gauge		= 8
MUIV_Frame_Group		= 9
MUIV_Frame_PopUp		= 10
MUIV_Frame_Virtual		= 11
MUIV_Frame_Slider		= 12
MUIV_Frame_Count		= 13
MUIV_InputMode_None		= 0
MUIV_InputMode_RelVerify	= 1
MUIV_InputMode_Immediate	= 2
MUIV_InputMode_Toggle		= 3


****************************************************************************
** Rectangle
****************************************************************************

** Attributes **

MUIA_Rectangle_BarTitle	= $80426689 ;** V11 i.g STRPTR
MUIA_Rectangle_HBar	= $8042c943 ;** V7  i.g BOOL
MUIA_Rectangle_VBar	= $80422204 ;** V7  i.g BOOL



****************************************************************************
** Image
****************************************************************************

** Attributes **

MUIA_Image_FontMatch		= $8042815d ;** V4  i.. BOOL
MUIA_Image_FontMatch_Height	= $80429f26 ;** V4  i.. BOOL
MUIA_Image_FontMatch_Width	= $804239bf ;** V4  i.. BOOL
MUIA_Image_FreeHoriz		= $8042da84 ;** V4  i.. BOOL
MUIA_Image_FreeVert		= $8042ea28 ;** V4  i.. BOOL
MUIA_Image_OldImage		= $80424f3d ;** V4  i.. struct Image
MUIA_Image_Spec			= $804233d5 ;** V4  i.. char
MUIA_Image_State		= $8042a3ad ;** V4  is. LONG



****************************************************************************
** Bitmap
****************************************************************************

** Attributes **

MUIA_Bitmap_Bitmap		= $804279bd ;** V8  isg struct BitMap
MUIA_Bitmap_Height		= $80421560 ;** V8  isg LONG
MUIA_Bitmap_MappingTable	= $8042e23d ;** V8  isg UBYTE
MUIA_Bitmap_Precision		= $80420c74 ;** V11 isg LONG
MUIA_Bitmap_RemappedBitmap	= $80423a47 ;** V11 ..g struct BitMap *
MUIA_Bitmap_SourceColors	= $80425360 ;** V8  isg ULONG
MUIA_Bitmap_Transparent		= $80422805 ;** V8  isg LONG
MUIA_Bitmap_UseFriend		= $804239d8 ;** V11 i.. BOOL
MUIA_Bitmap_Width		= $8042eb3a ;** V8  isg LONG



****************************************************************************
** Bodychunk
****************************************************************************

** Attributes **

MUIA_Bodychunk_Body		= $8042ca67 ;** V8  isg UBYTE
MUIA_Bodychunk_Compression	= $8042de5f ;** V8  isg UBYTE
MUIA_Bodychunk_Depth		= $8042c392 ;** V8  isg LONG
MUIA_Bodychunk_Masking		= $80423b0e ;** V8  isg UBYTE



****************************************************************************
** Text
****************************************************************************

** Attributes **

MUIA_Text_Contents	= $8042f8dc ;** V4  isg STRPTR
MUIA_Text_HiChar	= $804218ff ;** V4  i.. char
MUIA_Text_PreParse	= $8042566d ;** V4  isg STRPTR
MUIA_Text_SetMax	= $80424d0a ;** V4  i.. BOOL
MUIA_Text_SetMin	= $80424e10 ;** V4  i.. BOOL
MUIA_Text_SetVMax	= $80420d8b ;** V11 i.. BOOL



****************************************************************************
** Gadget
****************************************************************************

** Attributes **

MUIA_Gadget_Gadget	EQU	$8042ec1a ;** V11 ..g struct Gadget *



****************************************************************************
** String
****************************************************************************

** Attributes **

MUIA_String_Accept		= $8042e3e1 ;** V4  isg STRPTR
MUIA_String_Acknowledge		= $8042026c ;** V4  ..g STRPTR
MUIA_String_AdvanceOnCR		= $804226de ;** V11 isg BOOL
MUIA_String_AttachedList	= $80420fd2 ;** V4  i.. Object
MUIA_String_BufferPos		= $80428b6c ;** V4  .sg LONG
MUIA_String_Contents		= $80428ffd ;** V4  isg STRPTR
MUIA_String_DisplayPos		= $8042ccbf ;** V4  .sg LONG
MUIA_String_EditHook		= $80424c33 ;** V7  isg struct Hook
MUIA_String_Format		= $80427484 ;** V4  i.g LONG
MUIA_String_Integer		= $80426e8a ;** V4  isg ULONG
MUIA_String_LonelyEditHook	= $80421569 ;** V11 isg BOOL
MUIA_String_MaxLen		= $80424984 ;** V4  i.g LONG
MUIA_String_Reject		= $8042179c ;** V4  isg STRPTR
MUIA_String_Secret		= $80428769 ;** V4  i.g BOOL

MUIV_String_FormatLeft		= 0
MUIV_String_FormatCenter	= 1
MUIV_String_FormatRight		= 2


****************************************************************************
** Boopsi
****************************************************************************

** Attributes **

MUIA_Boopsi_Class	EQU	$80426999 ;** V4  isg struct IClass *
MUIA_Boopsi_ClassID	EQU	$8042bfa3 ;** V4  isg char *
MUIA_Boopsi_MaxHeight	EQU	$8042757f ;** V4  isg ULONG
MUIA_Boopsi_MaxWidth	EQU	$8042bcb1 ;** V4  isg ULONG
MUIA_Boopsi_MinHeight	EQU	$80422c93 ;** V4  isg ULONG
MUIA_Boopsi_MinWidth	EQU	$80428fb2 ;** V4  isg ULONG
MUIA_Boopsi_Object	EQU	$80420178 ;** V4  ..g Object *
MUIA_Boopsi_Remember	EQU	$8042f4bd ;** V4  i.. ULONG
MUIA_Boopsi_Smart	EQU	$8042b8d7 ;** V9  i.. BOOL
MUIA_Boopsi_TagDrawInfo	EQU	$8042bae7 ;** V4  isg ULONG
MUIA_Boopsi_TagScreen	EQU	$8042bc71 ;** V4  isg ULONG
MUIA_Boopsi_TagWindow	EQU	$8042e11d ;** V4  isg ULONG



****************************************************************************
** Prop
****************************************************************************

** Methods **

MUIM_Prop_Decrease	EQU	$80420dd1 ;** V16
MUIM_Prop_Increase	EQU	$8042cac0 ;** V16

** Attributes **

MUIA_Prop_Entries	= $8042fbdb ;** V4  isg LONG
MUIA_Prop_First		= $8042d4b2 ;** V4  isg LONG
MUIA_Prop_Horiz		= $8042f4f3 ;** V4  i.g BOOL
MUIA_Prop_Slider	= $80429c3a ;** V4  isg BOOL
MUIA_Prop_UseWinBorder	= $8042deee ;** V13 i.. LONG
MUIA_Prop_Visible	= $8042fea6 ;** V4  isg LONG

MUIV_Prop_UseWinBorder_None	EQU	0
MUIV_Prop_UseWinBorder_Left	EQU	1
MUIV_Prop_UseWinBorder_Right	EQU	2
MUIV_Prop_UseWinBorder_Bottom	EQU	3


****************************************************************************
** Gauge
****************************************************************************

** Attributes **

MUIA_Gauge_Current	= $8042f0dd ;** V4  isg LONG
MUIA_Gauge_Divide	= $8042d8df ;** V4  isg BOOL
MUIA_Gauge_Horiz	= $804232dd ;** V4  i.. BOOL
MUIA_Gauge_InfoText	= $8042bf15 ;** V7  isg char
MUIA_Gauge_Max		= $8042bcdb ;** V4  isg LONG



****************************************************************************
** Scale
****************************************************************************

** Attributes **

MUIA_Scale_Horiz	= $8042919a ;** V4  isg BOOL



****************************************************************************
** Colorfield
****************************************************************************

** Attributes **

MUIA_Colorfield_Blue	= $8042d3b0 ;** V4  isg ULONG
MUIA_Colorfield_Green	= $80424466 ;** V4  isg ULONG
MUIA_Colorfield_Pen	= $8042713a ;** V4  ..g ULONG
MUIA_Colorfield_Red	= $804279f6 ;** V4  isg ULONG
MUIA_Colorfield_RGB	= $8042677a ;** V4  isg ULONG



****************************************************************************
** List
****************************************************************************

** Methods **

MUIM_List_Clear		= $8042ad89 ;** V4
MUIM_List_CreateImage	= $80429804 ;** V11
MUIM_List_DeleteImage	= $80420f58 ;** V11
MUIM_List_Exchange	= $8042468c ;** V4
MUIM_List_GetEntry	= $804280ec ;** V4
MUIM_List_Insert	= $80426c87 ;** V4
MUIM_List_InsertSingle	= $804254d5 ;** V7
MUIM_List_Jump		= $8042baab ;** V4
MUIM_List_Move		= $804253c2 ;** V9
MUIM_List_NextSelected	= $80425f17 ;** V6
MUIM_List_Redraw	= $80427993 ;** V4
MUIM_List_Remove	= $8042647e ;** V4
MUIM_List_Select	= $804252d8 ;** V4
MUIM_List_Sort		= $80422275 ;** V4
MUIM_List_TestPos	= $80425f48 ;** V11

** Attributes **

MUIA_List_Active		= $8042391c ;** V4  isg LONG
MUIA_List_AdjustHeight		= $8042850d ;** V4  i.. BOOL
MUIA_List_AdjustWidth		= $8042354a ;** V4  i.. BOOL
MUIA_List_AutoVisible		= $8042a445 ;** V11 isg BOOL
MUIA_List_CompareHook		= $80425c14 ;** V4  is. struct Hook
MUIA_List_ConstructHook		= $8042894f ;** V4  is. struct Hook
MUIA_List_DestructHook		= $804297ce ;** V4  is. struct Hook
MUIA_List_DisplayHook		= $8042b4d5 ;** V4  is. struct Hook
MUIA_List_DragSortable		= $80426099 ;** V11 isg BOOL
MUIA_List_DropMark		= $8042aba6 ;** V11 ..g LONG
MUIA_List_Entries		= $80421654 ;** V4  ..g LONG
MUIA_List_First			= $804238d4 ;** V4  ..g LONG
MUIA_List_Format		= $80423c0a ;** V4  isg STRPTR
MUIA_List_InsertPosition	= $8042d0cd ;** V9  ..g LONG
MUIA_List_MinLineHeight		= $8042d1c3 ;** V4  i.. LONG
MUIA_List_MultiTestHook		= $8042c2c6 ;** V4  is. struct Hook
MUIA_List_Pool			= $80423431 ;** V13 i.. APTR
MUIA_List_PoolPuddleSize	= $8042a4eb ,** V13 i.. ULONG
MUIA_List_PoolThreshSize	= $8042c48c ;** V13 i.. ULONG
MUIA_List_Quiet			= $8042d8c7 ;** V4  .s. BOOL
MUIA_List_ShowDropMarks		= $8042c6f3 ;** V11 isg BOOL
MUIA_List_SourceArray		= $8042c0a0 ;** V4  i.. APTR
MUIA_List_Title			= $80423e66 ;** V6  isg char
MUIA_List_Visible		= $8042191f ;** V4  ..g LONG

MUIV_List_Active_Off		= -1
MUIV_List_Active_Top		= -2
MUIV_List_Active_Bottom		= -3
MUIV_List_Active_Up		= -4
MUIV_List_Active_Down		= -5
MUIV_List_Active_PageUp		= -6
MUIV_List_Active_PageDown	= -7
MUIV_List_ConstructHookString	= -1
MUIV_List_DestructHookString	= -1
MUIV_List_CursorType_None	= 0
MUIV_List_CursorType_Bar	= 1
MUIV_List_CursorType_Rect	= 2
MUIV_List_DestructHook_String	= -1


****************************************************************************
** Floattext
****************************************************************************

** Attributes **

MUIA_Floattext_Justify		= $8042dc03 ;** V4  isg BOOL
MUIA_Floattext_SkipChars	= $80425c7d ;** V4  is. STRPTR
MUIA_Floattext_TabSize		= $80427d17 ;** V4  is. LONG
MUIA_Floattext_Text		= $8042d16a ;** V4  isg STRPTR



****************************************************************************
** Volumelist
****************************************************************************


****************************************************************************
** Scrmodelist
****************************************************************************

** Attributes **




****************************************************************************
** Dirlist
****************************************************************************

** Methods **

MUIM_Dirlist_ReRead		= $80422d71 ;** V4

** Attributes **

MUIA_Dirlist_AcceptPattern	= $8042760a ;** V4  is. STRPTR
MUIA_Dirlist_Directory		= $8042ea41 ;** V4  isg STRPTR
MUIA_Dirlist_DrawersOnly	= $8042b379 ;** V4  is. BOOL
MUIA_Dirlist_FilesOnly		= $8042896a ;** V4  is. BOOL
MUIA_Dirlist_FilterDrawers	= $80424ad2 ;** V4  is. BOOL
MUIA_Dirlist_FilterHook		= $8042ae19 ;** V4  is. struct Hook
MUIA_Dirlist_MultiSelDirs	= $80428653 ;** V6  is. BOOL
MUIA_Dirlist_NumBytes		= $80429e26 ;** V4  ..g LONG
MUIA_Dirlist_NumDrawers		= $80429cb8 ;** V4  ..g LONG
MUIA_Dirlist_NumFiles		= $8042a6f0 ;** V4  ..g LONG
MUIA_Dirlist_Path		= $80426176 ;** V4  ..g STRPTR
MUIA_Dirlist_RejectIcons	= $80424808 ;** V4  is. BOOL
MUIA_Dirlist_RejectPattern	= $804259c7 ;** V4  is. STRPTR
MUIA_Dirlist_SortDirs		= $8042bbb9 ;** V4  is. LONG
MUIA_Dirlist_SortHighLow	= $80421896 ;** V4  is. BOOL
MUIA_Dirlist_SortType		= $804228bc ;** V4  is. LONG
MUIA_Dirlist_Status		= $804240de ;** V4  ..g LONG

MUIV_Dirlist_SortDirsFirst	= 0
MUIV_Dirlist_SortDirsLast	= 1
MUIV_Dirlist_SortDirsMix	= 2
MUIV_Dirlist_SortTypeName	= 0
MUIV_Dirlist_SortTypeDate	= 1
MUIV_Dirlist_SortTypeSize	= 2
MUIV_Dirlist_StatusInvalid	= 0
MUIV_Dirlist_StatusReading	= 1
MUIV_Dirlist_StatusValid	= 2


****************************************************************************
** Numeric
****************************************************************************

** Methods **

MUIM_Numeric_Decrease		EQU	$804243a7 ;** V11
MUIM_Numeric_Increase		EQU	$80426ecd ;** V11
MUIM_Numeric_ScaleToValue	EQU	$8042032c ;** V11
MUIM_Numeric_SetDefault		EQU	$8042ab0a ;** V11
MUIM_Numeric_Stringify		EQU	$80424891 ;** V11
MUIM_Numeric_ValueToScale	EQU	$80423e4f ;** V11

** Attributes **

MUIA_Numeric_CheckAllSizes	EQU	$80421594 ;** V11 isg BOOL
MUIA_Numeric_Default		EQU	$804263e8 ;** V11 isg LONG
MUIA_Numeric_Format		EQU	$804263e9 ;** V11 isg STRPTR
MUIA_Numeric_Max		EQU	$8042d78a ;** V11 isg LONG
MUIA_Numeric_Min		EQU	$8042e404 ;** V11 isg LONG
MUIA_Numeric_Reverse		EQU	$8042f2a0 ;** V11 isg BOOL
MUIA_Numeric_RevLeftRight	EQU	$804294a7 ;** V11 isg BOOL
MUIA_Numeric_RevUpDown		EQU	$804252dd ;** V11 isg BOOL
MUIA_Numeric_Value		EQU	$8042ae3a ;** V11 isg LONG



****************************************************************************
** Knob
****************************************************************************



****************************************************************************
** Levelmeter
****************************************************************************

** Attributes **

MUIA_Levelmeter_Label	EQU	$80420dd5 ;** V11 isg STRPTR



****************************************************************************
** Numericbutton
****************************************************************************



****************************************************************************
** Slider
****************************************************************************

** Attributes **

MUIA_Slider_Horiz	EQU     $8042fad1 ;** V11 isg BOOL
	IFD	MUI_OBSOLETE
MUIA_Slider_Level	EQU	$8042ae3a ;** V4  isg LONG
MUIA_Slider_Max		EQU	$8042d78a ;** V4  isg LONG
MUIA_Slider_Min		EQU	$8042e404 ;** V4  isg LONG
	ENDC
MUIA_Slider_Quiet	EQU	$80420b26 ;** V6  i.. BOOL
	IFD	MUI_OBSOLETE
MUIA_Slider_Reverse	EQU	$8042f2a0 ;** V4  isg BOOL
	ENDC



****************************************************************************
** Framedisplay
****************************************************************************

** Attributes **




****************************************************************************
** Popframe
****************************************************************************



****************************************************************************
** Imagedisplay
****************************************************************************

** Attributes **




****************************************************************************
** Popimage
****************************************************************************



****************************************************************************
** Pendisplay
****************************************************************************

** Methods **

MUIM_Pendisplay_SetColormap	EQU	$80426c80 ;** V13
MUIM_Pendisplay_SetMUIPen	EQU	$8042039d ;** V13
MUIM_Pendisplay_SetRGB		EQU	$8042c131 ;** V13

;** Attributes */

MUIA_Pendisplay_Pen		EQU	$8042a748 ;** V13 ..g Object *
MUIA_Pendisplay_Reference	EQU	$8042dc24 ;** V13 isg Object *
MUIA_Pendisplay_RGBcolor	EQU	$8042a1a9 ;** V11 isg struct MUI_RGBcolor *
MUIA_Pendisplay_Spec		EQU	$8042a204 ;** V11 isg struct MUI_PenSpec  *



****************************************************************************
** Poppen
****************************************************************************



****************************************************************************
** Group
****************************************************************************

** Methods **

MUIM_Group_ExitChange	= $8042d1cc ;** V11
MUIM_Group_InitChange	= $80420887 ;** V11
MUIM_Group_Sort		= $80427417 ;** V4

** Attributes **

MUIA_Group_ActivePage	= $80424199 ;** V5  isg LONG
MUIA_Group_Child	= $804226e6 ;** V4  i.. Object
MUIA_Group_ChildList	= $80424748 ;** V4  ..g struct List *
MUIA_Group_Columns	= $8042f416 ;** V4  is. LONG
MUIA_Group_Horiz	= $8042536b ;** V4  i.. BOOL
MUIA_Group_HorizSpacing	= $8042c651 ;** V4  is. LONG
MUIA_Group_LayoutHook	= $8042c3b2 ;** V11 i.. struct Hook *
MUIA_Group_PageMode	= $80421a5f ;** V5  is. BOOL
MUIA_Group_Rows		= $8042b68f ;** V4  is. LONG
MUIA_Group_SameHeight	= $8042037e ;** V4  i.. BOOL
MUIA_Group_SameSize	= $80420860 ;** V4  i.. BOOL
MUIA_Group_SameWidth	= $8042b3ec ;** V4  i.. BOOL
MUIA_Group_Spacing	= $8042866d ;** V4  is. LONG
MUIA_Group_VertSpacing	= $8042e1bf ;** V4  is. LONG

MUIV_Group_ActivePage_First	= 0
MUIV_Group_ActivePage_Last	= -1
MUIV_Group_ActivePage_Prev	= -2
MUIV_Group_ActivePage_Next	= -3
MUIV_Group_ActivePage_Advance	= -4


****************************************************************************
** Mccprefs
****************************************************************************



****************************************************************************
** Register
****************************************************************************

** Attributes **

MUIA_Register_Frame	= $8042349b ;** V7  i.g BOOL
MUIA_Register_Titles	= $804297ec ;** V7  i.g STRPTR



****************************************************************************
** Penadjust
****************************************************************************

** Methods **


** Attributes **

MUIA_Penadjust_PSIMode	EQU	$80421cbb ;** V11 i.. BOOL



****************************************************************************
** Settingsgroup
****************************************************************************

** Methods **

MUIM_Settingsgroup_ConfigToGadgets	EQU	$80427043 ;** V11
MUIM_Settingsgroup_GadgetsToConfig	EQU	$80425242 ;** V11

** Attributes **




****************************************************************************
** Settings
****************************************************************************

** Methods **


** Attributes **




****************************************************************************
** Frameadjust
****************************************************************************

** Methods **


** Attributes **




****************************************************************************
** Imageadjust
****************************************************************************

** Methods **


** Attributes **


MUIV_Imageadjust_Type_All		EQU	0
MUIV_Imageadjust_Type_Image		EQU	1
MUIV_Imageadjust_Type_Background	EQU	2
MUIV_Imageadjust_Type_Pen		EQU	3


****************************************************************************
** Virtgroup
****************************************************************************

** Methods **


** Attributes **

MUIA_Virtgroup_Height	= $80423038 ;** V6  ..g LONG
MUIA_Virtgroup_Input	= $80427f7e ;** V11 i.. BOOL
MUIA_Virtgroup_Left	= $80429371 ;** V6  isg LONG
MUIA_Virtgroup_Top	= $80425200 ;** V6  isg LONG
MUIA_Virtgroup_Width	= $80427c49 ;** V6  ..g LONG



****************************************************************************
** Scrollgroup
****************************************************************************

** Methods **


** Attributes **

MUIA_Scrollgroup_Contents	= $80421261 ;** V4  i.. Object
MUIA_Scrollgroup_FreeHoriz	= $804292f3 ;** V9  i.. BOOL
MUIA_Scrollgroup_FreeVert	= $804224f2 ;** V9  i.. BOOL
MUIA_Scrollgroup_HorizBar	= $8042b63d ;** V16 ..g Object *
MUIA_Scrollgroup_UseWinBorder	= $804284c1 ;** V13 i.. BOOL
MUIA_Scrollgroup_VertBar	= $8042cdc0 ;** V16 ..g Object *



****************************************************************************
** Scrollbar
****************************************************************************

** Attributes **

MUIA_Scrollbar_Type		EQU	$8042fb6b ;** V11 i.. LONG

MUIV_Scrollbar_Type_Default	EQU	0
MUIV_Scrollbar_Type_Bottom	EQU	1
MUIV_Scrollbar_Type_Top		EQU	2
MUIV_Scrollbar_Type_Sym		EQU     3


****************************************************************************
** Listview
****************************************************************************

** Attributes **

MUIA_Listview_ClickColumn	= $8042d1b3 ;** V7  ..g LONG
MUIA_Listview_DefClickColumn	= $8042b296 ;** V7  isg LONG
MUIA_Listview_DoubleClick	= $80424635 ;** V4  i.g BOOL
MUIA_Listview_DragType		= $80425cd3 ;** V11 isg LONG
MUIA_Listview_Input		= $8042682d ;** V4  i.. BOOL
MUIA_Listview_List		= $8042bcce ;** V4  i.. Object
MUIA_Listview_MultiSelect	= $80427e08 ;** V7  i.. LONG
MUIA_Listview_ScrollerPos	= $8042b1b4 ;** V10 i.. BOOL
MUIA_Listview_SelectChange	= $8042178f ;** V4  ..g BOOL

MUIV_Listview_DragType_None		= 0
MUIV_Listview_DragType_Immediate	= 1
MUIV_Listview_MultiSelect_None		= 0
MUIV_Listview_MultiSelect_Default	= 1
MUIV_Listview_MultiSelect_Shifte	= 2
MUIV_Listview_MultiSelect_Always	= 3
MUIV_Listview_ScrollerPos_Default	= 0
MUIV_Listview_ScrollerPos_Left		= 1
MUIV_Listview_ScrollerPos_Right		= 2
MUIV_Listview_ScrollerPos_None		= 3


****************************************************************************
** Radio
****************************************************************************

** Attributes **

MUIA_Radio_Active	= $80429b41 ;** V4  isg LONG
MUIA_Radio_Entries	= $8042b6a1 ;** V4  i.. STRPTR



****************************************************************************
** Cycle
****************************************************************************

** Attributes **

MUIA_Cycle_Active	= $80421788 ;** V4  isg LONG
MUIA_Cycle_Entries	= $80420629 ;** V4  i.. STRPTR

MUIV_Cycle_ActiveNext	= -1
MUIV_Cycle_ActivePrev	= -2


****************************************************************************
** Coloradjust
****************************************************************************

** Attributes **

MUIA_Coloradjust_Blue	= $8042b8a3 ;** V4  isg ULONG
MUIA_Coloradjust_Green	= $804285ab ;** V4  isg ULONG
MUIA_Coloradjust_ModeID	= $8042ec59 ;** V4  isg ULONG
MUIA_Coloradjust_Red	= $80420eaa ;** V4  isg ULONG
MUIA_Coloradjust_RGB	= $8042f899 ;** V4  isg ULONG



****************************************************************************
** Palette
****************************************************************************

** Attributes **

MUIA_Palette_Entries	= $8042a3d8 ;** V6  i.g struct MUI_Palette_Entry
MUIA_Palette_Groupable	= $80423e67 ;** V6  isg BOOL
MUIA_Palette_Names	= $8042c3a2 ;** V6  isg char



****************************************************************************
** Popstring
****************************************************************************

** Methods **

MUIM_Popstring_Close	= $8042dc52 ;** V7
MUIM_Popstring_Open 	= $804258ba ;** V7

** Attributes **

MUIA_Popstring_Button		= $8042d0b9 ;** V7  i.g Object
MUIA_Popstring_CloseHook	= $804256bf ;** V7  isg struct Hook
MUIA_Popstring_OpenHook		= $80429d00 ;** V7  isg struct Hook
MUIA_Popstring_String		= $804239ea ;** V7  i.g Object
MUIA_Popstring_Toggle		= $80422b7a ;** V7  isg BOOL



****************************************************************************
** Popobject
****************************************************************************

** Attributes **

MUIA_Popobject_Follow		= $80424cb5 ;** V7  isg BOOL
MUIA_Popobject_Light		= $8042a5a3 ;** V7  isg BOOL
MUIA_Popobject_Object		= $804293e3 ;** V7  i.g Object
MUIA_Popobject_ObjStrHook	= $8042db44 ;** V7  isg struct Hook
MUIA_Popobject_StrObjHook	= $8042fbe1 ;** V7  isg struct Hook
MUIA_Popobject_Volatile		= $804252ec ;** V7  isg BOOL
MUIA_Popobject_WindowHook	= $8042f194 ;** V9  isg struct Hook



****************************************************************************
** Poplist
****************************************************************************

** Attributes **

MUIA_Poplist_Array	= $8042084c ;** V8  i.. char



****************************************************************************
** Popscreen
****************************************************************************

** Attributes **




****************************************************************************
** Popasl
****************************************************************************

** Attributes **

MUIA_Popasl_Active	= $80421b37 ;** V7  ..g BOOL
MUIA_Popasl_StartHook	= $8042b703 ;** V7  isg struct Hook
MUIA_Popasl_StopHook	= $8042d8d2 ;** V7  isg struct Hook
MUIA_Popasl_Type	= $8042df3d ;** V7  i.g ULONG



****************************************************************************
** Semaphore
****************************************************************************

** Methods **

MUIM_Semaphore_Attempt		EQU	$80426ce2 ;** V11
MUIM_Semaphore_AttemptShared	EQU	$80422551 ;** V11
MUIM_Semaphore_Obtain		EQU	$804276f0 ;** V11
MUIM_Semaphore_ObtainShared	EQU	$8042ea02 ;** V11
MUIM_Semaphore_Release		EQU	$80421f2d ;** V11


****************************************************************************
** Applist
****************************************************************************

** Methods **



****************************************************************************
** Cclist
****************************************************************************

** Methods **



****************************************************************************
** Dataspace
****************************************************************************

** Methods **

MUIM_Dataspace_Add		EQU	$80423366 ;** V11
MUIM_Dataspace_Clear		EQU	$8042b6c9 ;** V11
MUIM_Dataspace_Find		EQU	$8042832c ;** V11
MUIM_Dataspace_Merge		EQU	$80423e2b ;** V11
MUIM_Dataspace_ReadIFF		EQU	$80420dfb ;** V11
MUIM_Dataspace_Remove		EQU	$8042dce1 ;** V11
MUIM_Dataspace_WriteIFF		EQU	$80425e8e ;** V11

** Attributes **

MUIA_Dataspace_Pool		EQU     $80424cf9 ;** V11 i.. APTR



****************************************************************************
** Configdata
****************************************************************************

** Methods **


** Attributes **




****************************************************************************
** Dtpic
****************************************************************************

** Attributes **




;*******************************************
;** End of automatic header file creation **
;*******************************************


****************************************************************************
**
** Macro Section
** -------------
**
** To make GUI creation more easy and understandable, you can use the
** macros below. If you dont want, just define MUI_NOSHORTCUTS to disable
** them.
**
** These macros are available to C programmers only.
**
**
****************************************************************************


*	Assembler macros removed!!	*

*** Macro to move a tagitem to stack if it is given

cmv3	MACRO
	IFNC	'\1',''
	move.l	\1,-(sp)
	ENDC
	ENDM

cmv4	MACRO
	IFNC	'\1',''
	move.l	#\1,-(sp)
	ENDC
	ENDM

Child		= MUIA_Group_Child
SubWindow	= MUIA_Application_Window
WindowContents	= MUIA_Window_RootObject


* End of Include file, for using MUI from an application program. The rest
* of this is for custom class implementors only
*
*****************************************************************************
*****************************************************************************
*****************************************************************************

****************************************************************************
**
** For Boopsi Image Implementors Only:
**
** If MUI is using a boopsi image object, it will send a special method
** immediately after object creation. This method has a parameter structure
** where the boopsi can fill in its minimum and maximum size and learn if
** its used in a horizontal or vertical context.
**
** The boopsi image must use the method id (MUIM_BoopsiQuery) as return
** value. That's how MUI sees that the method is implemented.
**
** Note: MUI does not depend on this method. If the boopsi image doesn't
**       implement it, minimum size will be 0 and maximum size unlimited.
**
***************************************************************************/

MUIM_BoopsiQuery	= $80427157 ;* this is send to the boopsi and *
MUI_BoopsiQuery		= $80427157 ;* this is send to the boopsi and *
				;* must be used as return value   *

* STRUCTURE MUI_BoopsiQuery,0	     ;* parameter structure *

* LONG 	mbq_MethodID	    ;* always MUIM_BoopsiQuery */
* APTR 	mbq_Screen	      ;* obsolete, use mbq_RenderInfo */
* LONG 	mbq_Flags;	      ;* read only, see below */
* LONG 	mbq_MinWidth	    ;* write only, fill in min width  */
* LONG 	mbq_MinHeight		;* write only, fill in min height */
* LONG	  mbq_MaxWidth	    ;* write only, fill in max width  */
* LONG	  mbq_MaxHeight	   ;* write only, fill in max height */
* LONG	  mbq_DefWidth	    ;* write only, fill in def width  */
* LONG	  mbq_DefHeight	   ;* write only, fill in def height */
* APTR	  mbq_RenderInfo		;* read only, display context */

* LABEL MUI_BoopsiQuery_SIZEOF		;* may grow in future ... */


MUIP_BoopsiQuery = MUI_BoopsiQuery  ;* old structure name *

MBQF_HORIZ = 1<<0		 ;* object used in a horizontal *
				  ;* context (else vertical)     *

MBQ_MUI_MAXMAX = 10000	     ;* use this for unlimited MaxWidth/Height *







*************************************************************************
** Structures and Macros for creating custom classes.
*************************************************************************


*
** GENERAL NOTES:
**
** - Everything described in this header file is only valid within
**   MUI classes. You may never use any of these things out of
**   a class, e.g. in a traditional MUI application.
**
** - Except when otherwise stated, all structures are strictly read only.
*


* Global information for every object *

* STRUCTURE MUI_GlobalInfo,0

* LONG priv0
* APTR mgi_ApplicationObject

 * ... private data follows ... *




* Instance data of notify class *

	STRUCTURE MUI_NotifyData,0
	APTR	mnd_GlobalInfo
	LONG	mnd_UserData
	LONG	priv1
	LONG	priv2
	LONG	priv3
	LONG	priv4
	LONG	priv5
	LABEL	MUI_NotifyData_SIZEOF


* MUI_MinMax structure holds information about minimum, maximum
* and default dimensions of an object. *

	STRUCTURE MUI_MinMax,0
	WORD	MMM_MinWidth
	WORD	MMM_MinHeight
	WORD	MMM_MaxWidth
	WORD	MMM_MaxHeight
	WORD	MMM_DefWidth
	WORD	MMM_DefHeight
 	LABEL	MUI_MinMax_SIZEOF


MUI_MAXMAX = 10000 * use this if a dimension is not limited. *


* (partial) instance data of area class *

	STRUCTURE MUI_AreaData,0
	APTR	mad_RenderInfo		;* RenderInfo for this object *
	ULONG	priv6			;
	APTR	mad_Font		;* Font *
	STRUCT	mad_MinMax,MUI_MinMax_SIZEOF	;* min/max/default sizes *
	STRUCT	mad_Box,ibox_SIZEOF	;* position and dimension *
	BYTE	mad_addleft		;* frame & innerspacing left offset *
	BYTE	mad_addtop		;* frame & innerspacing top offset  *
	BYTE	mad_subwidth		;* frame & innerspacing add. width  *
	BYTE	mad_subheight		;* frame & innerspacing add. height *
	LONG	mad_Flags		;* see definitions below *

		;* ... private data follows ... *


* Definitions for mad_Flags, other flags are private *

MADF_DRAWOBJECT	=	1<<0   * completely redraw yourself *
MADF_DRAWUPDATE =	1<<1   * only update yourself *




* MUI's draw pens *

MPEN_SHINE	= 0
MPEN_HALFSHINE	= 1
MPEN_BACKGROUND	= 2
MPEN_HALFSHADOW	= 3
MPEN_SHADOW	= 4
MPEN_TEXT	= 5
MPEN_FILL	= 6
MPEN_ACTIVEOBJ	= 7
MPEN_COUNT	= 8


MUIPEN_MASK	EQU	$0000ffff


* Information on display environment *

	STRUCTURE MUI_RenderInfo,0
	APTR	mri_WindowObject	;* valid between MUIM_Setup/MUIM_Cleanup *
	APTR	mri_Screen		;* valid between MUIM_Setup/MUIM_Cleanup *
	APTR	mri_DrawInfo		;* valid between MUIM_Setup/MUIM_Cleanup *
	APTR	mri_Pens		;* valid between MUIM_Setup/MUIM_Cleanup *
	APTR	mri_Window		;* valid between MUIM_Show/MUIM_Hide *
	APTR	mri_RastPort		;* valid between MUIM_Show/MUIM_Hide *

		;* ... private data follows ... *



* the following macros can be used to get pointers to an objects
*   GlobalInfo and RenderInfo structures. */
*
*NOTE: These have not been converted from the C header.
;
;struct __dummyXFC2__ {
;
; STRUCT MUI_NotifyData mnd;
;	struct MUI_AreaData   mad;
;};
;
;#define muiNotifyData(obj) (&(((struct __dummyXFC2__ *)(obj))->mnd))
;#define muiAreaData(obj)   (&(((struct __dummyXFC2__ *)(obj))->mad))
;
;define muiGlobalInfo(obj) (((struct __dummyXFC2__ *)(obj))->mnd.mnd_GlobalInfo)
;#define muiUserData(obj)   (((struct __dummyXFC2__ *)(obj))->mnd.mnd_UserData)
;#define muiRenderInfo(obj) (((struct __dummyXFC2__ *)(obj))->mad.mad_RenderInfo)



* User configurable keyboard events coming with MUIM_HandleInput *


MUIKEY_RELEASE		= -2 * not a real key, faked when MUIKEY_PRESS is released *
MUIKEY_NONE		= -1
MUIKEY_PRESS		=  0
MUIKEY_TOGGLE		=  1
MUIKEY_UP		=  2
MUIKEY_DOWN		=  3
MUIKEY_PAGEUP		=  4
MUIKEY_PAGEDOWN		=  5
MUIKEY_TOP		=  6
MUIKEY_BOTTOM		=  7
MUIKEY_LEFT		=  8
MUIKEY_RIGHT		=  9
MUIKEY_WORDLEFT		= 10
MUIKEY_WORDRIGHT	= 11
MUIKEY_LINESTART	= 12
MUIKEY_LINEEND		= 13
MUIKEY_GADGET_NEXT	= 14
MUIKEY_GADGET_PREV	= 15
MUIKEY_GADGET_OFF	= 16
MUIKEY_WINDOW_CLOSE	= 17
MUIKEY_WINDOW_NEXT	= 18
MUIKEY_WINDOW_PREV	= 19
MUIKEY_HELP		= 20
MUIKEY_POPUP		= 21
MUIKEY_COUNT		= 22 * counter *


********************************************************************
* Some useful shortcuts. define MUI_NOSHORTCUTS to get rid of them *

* I Have left the original C macros here, so you can see what they are
* for, but I have not converted them to assembler.
*
*

;#define _app(obj)	(muiGlobalInfo(obj)->mgi_ApplicationObject)
;#define _win(obj)	(muiRenderInfo(obj)->mri_WindowObject)
;#define _dri(obj)	(muiRenderInfo(obj)->mri_DrawInfo)
;#define _window(obj)      (muiRenderInfo(obj)->mri_Window)
;#define _screen(obj)      (muiRenderInfo(obj)->mri_Screen)
;#define _rp(obj)	 (muiRenderInfo(obj)->mri_RastPort)
;#define _left(obj)        (muiAreaData(obj)->mad_Box.Left)
;#define _top(obj)	(muiAreaData(obj)->mad_Box.Top)
;#define _width(obj)       (muiAreaData(obj)->mad_Box.Width)
;#define _height(obj)      (muiAreaData(obj)->mad_Box.Height)
;#define _right(obj)       (_left(obj)+_width(obj)-1)
;#define _bottom(obj)      (_top(obj)+_height(obj)-1)
;#define _addleft(obj)     (muiAreaData(obj)->mad_addleft  )
;#define _addtop(obj)      (muiAreaData(obj)->mad_addtop   )
;#define _subwidth(obj)    (muiAreaData(obj)->mad_subwidth )
;#define _subheight(obj)   (muiAreaData(obj)->mad_subheight)
;#define _mleft(obj)       (_left(obj)+_addleft(obj))
;#define _mtop(obj)        (_top(obj)+_addtop(obj))
;#define _mwidth(obj)      (_width(obj)-_subwidth(obj))
;#define _mheight(obj)     (_height(obj)-_subheight(obj))
;#define _mright(obj)      (_mleft(obj)+_mwidth(obj)-1)
;#define _mbottom(obj)     (_mtop(obj)+_mheight(obj)-1)
;#define _font(obj)        (muiAreaData(obj)->mad_Font)
;#define _flags(obj)       (muiAreaData(obj)->mad_Flags)





* MUI_CustomClass returned by MUI_CreateCustomClass() *

	STRUCTURE MUI_CustomClass,0
	APTR	mcc_UserData		;* use for whatever you want *
	APTR	mcc_UtilityBase		;* MUI has opened these libraries *
	APTR	mcc_DOSBase		;* for you automatically. You can *
	APTR	mcc_GfxBase		;* use them or decide to open     *
	APTR	mcc_IntuitionBase	;* your libraries yourself.       *

	APTR	mcc_Super		;* pointer to super class   *
	APTR	mcc_Class		;* pointer to the new class *

		;* ... private data follows ... *

****************************************************************************

	ENDC	;LIBRARIES_MUI_I