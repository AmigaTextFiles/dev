****************************************************************************
**
** MUI - MagicUserInterface V2.3
** (c) 1993-95 by Stefan Stuntz
**
** Main Header File
**
*** Assembler modifications 05-Jan-95 by Stefan Sommerfeld.
**
**
****************************************************************************
** General Header File Information
****************************************************************************
**
** All macro and structure definitions follow these rules:
**
** Name  							Meaning
**
** MUIC_<class>					Name of a class
** MUIM_<class>_<method>		Method
** MUIP_<class>_<method>		Methods parameter structure
** MUIV_<class>_<method>_<x>  Special method value
** MUIA_<class>_<attrib>		Attribute
** MUIV_<class>_<attrib>_<x>  Special attribute value
** MUIE_<error>					Error return code from MUI_Error()
** MUII_<name> 					Standard MUI image
** MUII_<name> 					Object type for MUI_MakeObject()
**
** MUIA_... attribute definitions are followed by a comment
** consisting of the three possible letters I, S and G.
** I: it's possible to specify this attribute at object creation time.
** S: it's possible to change this attribute with SetAttrs().
** G: it's possible to get this attribute with GetAttr().
**
** Items marked with "Custom Class" are for use in custom classes only!
*/

 IFND LIBRARIES_MUI_I
LIBRARIES_MUI_I SET 1

 IFND EXEC_TYPES_I
	INCLUDE "exec/types.i"
 ENDC  ;EXEC_TYPES_I

; IFND INTUITION_CLASSES_I
;	INCLUDE "intuition/classes.i"
; ENDC  ;INTUITION_CLASSES_I

; IFND INTUITION_SCREENS_I
;	INCLUDE "intuition/screens.i"
; ENDC  ;INTUITION_SCREENS_I

 IFND UTILITY_HOOKS_I
	INCLUDE "utility/hooks.i"
 ENDC  ;UTILITY_HOOKS_I

; IFND LIBRARIES_ASL_I
;	INCLUDE "libraries/asl.i"
; ENDC


****************************************************************************
** Library specification
****************************************************************************

MUIMASTER_NAME MACRO
	dc.b		"muimaster.library",0
	even
	ENDM
MUIMASTER_VMIN = 8
CALLMUI  MACRO
	move.l	_MUIMasterBase,a6
	jsr		_LVO\1(a6)
	ENDM

NULL	EQU	0
TRUE	EQU	1
FALSE	EQU	NULL

***************************************************************************
** Object Types for MUI_MakeObject()
***************************************************************************

MUIO_Label			EQU	1	;STRPTR label, ULONG flags
MUIO_Button			EQU	2	;STRPTR label
MUIO_Checkmark		EQU	3	;STRPTR label
MUIO_Cycle			EQU	4	;STRPTR label, STRPTR *entries
MUIO_Radio			EQU	5	;STRPTR label, STRPTR *entries
MUIO_Slider			EQU	6	;STRPTR label, LONG min, LONG max
MUIO_String			EQU	7	;STRPTR label, LONG maxlen
MUIO_PopButton		EQU	8	;STRPTR imagespec
MUIO_HSpace			EQU	9	;LONG space
MUIO_VSpace			EQU	10	;LONG space
MUIO_HBar			EQU	11	;LONG space
MUIO_VBar			EQU	12	;LONG space
MUIO_MenustripNM	EQU	13	;struct NewMenu .*ULONG flags
MUIO_Menuitem		EQU	14	;STRPTR label, STRPTR shortcut, ULONG flags, ULONG data
MUIO_BarTitle		EQU	15	;STRPTR label

MUIO_Label_SingleFrame	EQU	1<<8
MUIO_Label_DoubleFrame	EQU	1<<9
MUIO_Label_LeftAligned	EQU	1<<10
MUIO_Label_Centered		EQU	1<<11


****************************************************************************
** ARexx Interface
****************************************************************************

 STRUCTURE	MUI_Command,0
	APTR		mc_Name
	APTR		mc_Template
	LONG		mc_Parameters
	STRUCT	mc_Hook,h_SIZEOF
	STRUCT	mc_Reserved,4*5
 LABEL	MUI_Command_SIZEOF

MC_TEMPLATE_ID	EQU	~0

MUI_RXERR_BADDEFINITION		EQU	-1
MUI_RXERR_OUTOFMEMORY		EQU	-2
MUI_RXERR_UNKNOWNCOMMAND	EQU	-3
MUI_RXERR_BADSYNTAX			EQU	-4


****************************************************************************
** Return values for MUI_Error()
****************************************************************************

MUIE_OK							EQU	0
MUIE_OutOfMemory				EQU	1
MUIE_OutOfGfxMemory			EQU	2
MUIE_InvalidWindowObject	EQU	3
MUIE_MissingLibrary			EQU	4
MUIE_NoARexx					EQU	5
MUIE_SingleTask				EQU	6


****************************************************************************
** Standard MUI Images
****************************************************************************

MUII_WindowBack		EQU	0
MUII_RequesterBack	EQU	1
MUII_ButtonBack		EQU	2
MUII_ListBack			EQU	3
MUII_TextBack			EQU	4
MUII_PropBack			EQU	5
MUII_PopupBack			EQU	6
MUII_SelectedBack		EQU	7
MUII_ListCursor		EQU	8
MUII_ListSelect		EQU	9
MUII_ListSelCur		EQU	10
MUII_ArrowUp			EQU	11
MUII_ArrowDown			EQU	12
MUII_ArrowLeft			EQU	13
MUII_ArrowRight		EQU	14
MUII_CheckMark			EQU	15
MUII_RadioButton		EQU	16
MUII_Cycle				EQU	17
MUII_PopUp				EQU	18
MUII_PopFile			EQU	19
MUII_PopDrawer			EQU	20
MUII_PropKnob			EQU	21
MUII_Drawer				EQU	22
MUII_HardDisk			EQU	23
MUII_Disk				EQU	24
MUII_Chip				EQU	25
MUII_Volume				EQU	26
MUII_PopUpBack			EQU	27
MUII_Network			EQU	28
MUII_Assign				EQU	29
MUII_TapePlay			EQU	30
MUII_TapePlayBack		EQU	31
MUII_TapePause			EQU	32
MUII_TapeStop			EQU	33
MUII_TapeRecord		EQU	34
MUII_GroupBack			EQU	35
MUII_SliderBack		EQU	36
MUII_SliderKnob		EQU	37
MUII_TapeUp				EQU	38
MUII_TapeDown			EQU	39
MUII_PageBack			EQU	40
MUII_ReadListBack		EQU	41
MUII_Count				EQU	42

MUII_BACKGROUND		EQU	(128+0)
MUII_SHADOW				EQU	(128+1)
MUII_SHINE				EQU	(128+2)
MUII_FILL				EQU	(128+3)
MUII_SHADOWBACK		EQU	(128+4)
MUII_SHADOWFILL		EQU	(128+5)
MUII_SHADOWSHINE		EQU	(128+6)
MUII_FILLBACK			EQU	(128+7)
MUII_FILLSHINE			EQU	(128+8)
MUII_SHINEBACK			EQU	(128+9)
MUII_FILLBACK2			EQU	(128+10)
MUII_HSHINEBACK		EQU	(128+11)
MUII_HSHADOWBACK		EQU	(128+12)
MUII_HSHINESHINE		EQU	(128+13)
MUII_HSHADOWSHADOW	EQU	(128+14)
MUII_LASTPAT			EQU	(128+15)


****************************************************************************
** Special values for some methods
****************************************************************************

MUIV_TriggerValue					EQU	$49893131
MUIV_NotTriggerValue				EQU	$49893133
MUIV_EveryTime						EQU	$49893131

MUIV_Application_Save_ENV		EQU	0
MUIV_Application_Save_ENVARC	EQU	~0
MUIV_Application_Load_ENV		EQU	0
MUIV_Application_Load_ENVARC	EQU	~0

MUIV_Notify_Self					EQU	1
MUIV_Notify_Window				EQU	2
MUIV_Notify_Application			EQU	3

MUIV_Application_ReturnID_Quit	EQU	-1

MUIV_List_Insert_Top				EQU	0
MUIV_List_Insert_Active			EQU	-1
MUIV_List_Insert_Sorted			EQU	-2
MUIV_List_Insert_Bottom			EQU	-3

MUIV_List_Remove_First			EQU	0
MUIV_List_Remove_Active			EQU	-1
MUIV_List_Remove_Last			EQU	-2
MUIV_List_Remove_Selected		EQU	-3

MUIV_List_Select_Off				EQU	0
MUIV_List_Select_On				EQU	1
MUIV_List_Select_Toggle			EQU	2
MUIV_List_Select_Ask				EQU	3

MUIV_List_GetEntry_Active		EQU	-1
MUIV_List_Select_Active			EQU	-1
MUIV_List_Select_All				EQU	-2

MUIV_List_Redraw_Active			EQU	-1
MUIV_List_Redraw_All				EQU	-2

MUIV_List_Move_Top				EQU	0
MUIV_List_Move_Active			EQU	-1
MUIV_List_Move_Bottom			EQU	-2
MUIV_List_Move_Next				EQU	-3	;only valid for second parameter
MUIV_List_Move_Previous			EQU	-4	;only valid for second parameter

MUIV_List_Exchange_Top			EQU	0
MUIV_List_Exchange_Active		EQU	-1
MUIV_List_Exchange_Bottom		EQU	-2
MUIV_List_Exchange_Next			EQU	-3	;only valid for second parameter
MUIV_List_Exchange_Previous	EQU	-4	;only valid for second parameter

MUIV_List_Jump_Top				EQU	0
MUIV_List_Jump_Active			EQU	-1
MUIV_List_Jump_Bottom			EQU	-2

MUIV_Colorpanel_GetColor_Active	EQU	-1
MUIV_Colorpanel_SetColor_Active	EQU	-1

MUIV_List_NextSelected_Start	EQU	-1
MUIV_List_NextSelected_End		EQU	-1


***************************************************************************
** Parameter structures for some classes
***************************************************************************

 STRUCTURE	MUI_Palette_Entry,0
	LONG	mpe_ID
	LONG	mpe_Red
	LONG	mpe_Green
	LONG	mpe_Blue
	LONG	mpe_Group
 LABEL	MUI_Palette_Entry_SIZEOF

MUIV_Palette_Entry_End	EQU	-1

 STRUCTURE	MUI_Scrmodelist_Entry,0
	APTR	sme_Name
	LONG	sme_ModeID
 LABEL	MUI_Scrmodelist_Entry_SIZEOF


*********************************************
** Begin of automatic header file creation **
*********************************************

****************************************************************************
** Notify
****************************************************************************

** Methods **
MUIM_CallHook		EQU	$8042b96b	;** V4  **
MUIM_Export			EQU	$80420f1c	;** V12 **
MUIM_FindUData		EQU	$8042c196	;** V8  **
MUIM_GetConfigItem EQU	$80423edb	;** V11 **
MUIM_GetUData		EQU	$8042ed0c	;** V8  **
MUIM_Import			EQU	$8042d012	;** V12 88
MUIM_KillNotify	EQU	$8042d240	;** V4  **
MUIM_KillNotifyObj EQU	$8042b145	;** V16 **
MUIM_MultiSet		EQU	$8042d356	;** V7  **
MUIM_NoNotifySet	EQU	$8042216f	;** V9  **
MUIM_Notify			EQU	$8042c9cb	;** V4  **
MUIM_Set				EQU	$8042549a	;** V4  **
MUIM_SetAsString	EQU	$80422590	;** V4  **
MUIM_SetUData		EQU	$8042c920	;** V8  **
MUIM_SetUDataOnce	EQU	$8042ca19	;** V11 **
MUIM_WriteLong		EQU	$80428d86	;** V6  **
MUIM_WriteString	EQU	$80424bf4	;** V6  **

** Attributes **
MUIA_ApplicationObject EQU $8042d3ee ;** V4 ..g Object *
MUIA_AppMessage	EQU	$80421955	;** V5  ..g struct AppMessage *
;OBS MUIA_HelpFile		EQU	$80423a6e	;** V4  isg STRPTR
MUIA_HelpLine		EQU	$8042a825	;** V4  isg LONG
MUIA_HelpNode		EQU	$80420b85	;** V4  isg STRPTR
MUIA_NoNotify		EQU	$804237f9	;** V7  .s. BOOL
MUIA_ObjectID		EQU	$8042d76e	;** V11 isg ULONG
MUIA_Parent			EQU	$8042e35f	;** V11 ..g Object *
MUIA_Revision		EQU	$80427eaa	;** V4  ..g LONG
MUIA_UserData		EQU	$80420313	;** V4  isg ULONG
MUIA_Version		EQU	$80422301	;** V4  ..g LONG


****************************************************************************
** Family
****************************************************************************

** Methods **
MUIM_Family_AddHead	EQU	$8042e200	;** V8  **
MUIM_Family_AddTail	EQU	$8042d752	;** V8  **
MUIM_Family_Insert	EQU	$80424d34	;** V8  **
MUIM_Family_Remove	EQU	$8042f8a9	;** V8  **
MUIM_Family_Sort		EQU	$80421c49	;** V8  **
MUIM_Family_Transfer	EQU	$8042c14a	;** V8  **

** Attributes **
MUIA_Family_Child		EQU	$8042c696	;** V8  i.. Object
MUIA_Family_List		EQU	$80424b9e	;** V8  ..g struct MinList *


****************************************************************************
** Menustrip
****************************************************************************

;** Attributes **
MUIA_Menustrip_Enabled	EQU	$8042815b	;** V8  isg BOOL


****************************************************************************
** Menu
****************************************************************************

;** Attributes **
MUIA_Menu_Enabled		EQU	$8042ed48	;** V8  isg BOOL
MUIA_Menu_Title		EQU	$8042a0e3	;** V8  isg STRPTR


****************************************************************************
** Menuitem
****************************************************************************

** Attributes **
MUIA_Menuitem_Checked	EQU	$8042562a	;** V8  isg BOOL
MUIA_Menuitem_Checkit	EQU	$80425ace	;** V8  isg BOOL
MUIA_Menuitem_CommandString EQU $8042b9cc	;** V16 isg BOOL
MUIA_Menuitem_Enabled	EQU	$8042ae0f	;** V8  isg BOOL
MUIA_Menuitem_Exclude	EQU	$80420bc6	;** V8  isg LONG
MUIA_Menuitem_Shortcut	EQU	$80422030	;** V8  isg char
MUIA_Menuitem_Title		EQU	$804218be	;** V8  isg STRPTR
MUIA_Menuitem_Toggle		EQU	$80424d5c	;** V8  isg BOOL
MUIA_Menuitem_Trigger	EQU	$80426f32	;** V8  ..g struct MenuItem *


****************************************************************************
** Application
****************************************************************************

** Methods **
MUIM_Application_AboutMUI			EQU	$8042d21d	;** V14 **
MUIM_Application_AddInputHandler	EQU	$8042f099	;** V11 **
MUIM_Application_CheckRefresh		EQU	$80424d68	;** V11 **
;OBS MUIM_Application_GetMenuCheck		EQU	$8042c0a7	;** V4  **
;OBS MUIM_Application_GetMenuState		EQU	$8042a58f	;** V4  **
;OBS MUIM_Application_Input				EQU	$8042d0f5	;** V4  **
MUIM_Application_InputBuffered	EQU	$80427e59	;** V4  **
MUIM_Application_Load				EQU	$8042f90d	;** V4  **
MUIM_Application_NewInput			EQU	$80423ba6	;** V11 **
MUIM_Application_OpenConfigWindow EQU	$804299ba	;** V11 **
MUIM_Application_PushMethod		EQU	$80429ef8	;** V4  **
MUIM_Application_RemInputHandler	EQU	$8042e7af	;** V11 **
MUIM_Application_ReturnID			EQU	$804276ef	;** V4  **
MUIM_Application_Save				EQU	$804227ef	;** V4  **
MUIM_Application_SetConfigItem	EQU	$80424a80	;** V11 **
;OBS MUIM_Application_SetMenuCheck		EQU	$8042a707	;** V4  **
;OBS MUIM_Application_SetMenuState		EQU	$80428bef	;** V4  **
MUIM_Application_ShowHelp			EQU	$80426479	;** V4  **

** Attributes **
MUIA_Application_Active				EQU	$804260ab	;** V4  isg BOOL
MUIA_Application_Author				EQU	$80424842	;** V4  i.g STRPTR
MUIA_Application_Base				EQU	$8042e07a	;** V4  i.g STRPTR
MUIA_Application_Broker				EQU	$8042dbce	;** V4  ..g Broker
MUIA_Application_BrokerHook		EQU	$80428f4b	;** V4  isg struct Hook
MUIA_Application_BrokerPort		EQU	$8042e0ad	;** V6  ..g struct MsgPort
MUIA_Application_BrokerPri			EQU	$8042c8d0	;** V6  i.g LONG
MUIA_Application_Commands			EQU	$80428648	;** V4  isg struct MUI_Command
MUIA_Application_Copyright			EQU	$8042ef4d	;** V4  i.g STRPTR
MUIA_Application_Description		EQU	$80421fc6	;** V4  i.g STRPTR
MUIA_Application_DiskObject		EQU	$804235cb	;** V4  isg struct DiskObject
MUIA_Application_DoubleStart		EQU	$80423bc6	;** V4  ..g BOOL
MUIA_Application_DropObject		EQU	$80421266	;** V5  is. Object
MUIA_Application_ForceQuit			EQU	$804257df	;** V8  ..g BOOL
MUIA_Application_HelpFile			EQU	$804293f4	;** V8  isg STRPTR
MUIA_Application_Iconified			EQU	$8042a07f	;** V4  .sg BOOL
;OBS MUIA_Application_Menu				EQU	$80420e1f	;** V4  i.g struct NewMenu
MUIA_Application_MenuAction		EQU	$80428961	;** V4  ..g ULONG
MUIA_Application_MenuHelp			EQU	$8042540b	;** V4  ..g ULONG
MUIA_Application_Menustrip			EQU	$804252d9	;** V8  i.. Object
MUIA_Application_RexxHook			EQU	$80427c42	;** V7  isg struct Hook
MUIA_Application_RexxMsg			EQU	$8042fd88	;** V4  ..g struct RxMsg
MUIA_Application_RexxString		EQU	$8042d711	;** V4  .s. STRPTR
MUIA_Application_SingleTask		EQU	$8042a2c8	;** V4  i.. BOOL
MUIA_Application_Sleep				EQU	$80425711	;** V4  .s. BOOL
MUIA_Application_Title				EQU	$804281b8	;** V4  i.g STRPTR
MUIA_Application_UseCommodities	EQU	$80425ee5	;** V10 i.. BOOL
MUIA_Application_UseRexx			EQU	$80422387	;** V10 i.. BOOL
MUIA_Application_Version			EQU	$8042b33f	;** V4  i.g STRPTR
MUIA_Application_Window				EQU	$8042bfe0	;** V4  i.. Object
MUIA_Application_WindowList		EQU	$80429abe	;** V13 ..g struct List *


****************************************************************************
** Window
****************************************************************************

** Methods **
MUIM_Window_AddEventHandler	EQU	$804203b7	;** V16
;OBS MUIM_Window_GetMenuCheck		EQU	$80420414	;** V4
;OBS MUIM_Window_GetMenuState		EQU	$80420d2f	;** V4
MUIM_Window_RemEventHandler	EQU	$8042679e	;** V16
MUIM_Window_ScreenToBack		EQU	$8042913d	;** V4
MUIM_Window_ScreenToFront		EQU	$804227a4	;** V4
MUIM_Window_SetCycleChain		EQU	$80426510	;** V4
MUIM_Window_SetMenuCheck		EQU	$80422243	;** V4
MUIM_Window_SetMenuState		EQU	$80422b5e	;** V4
MUIM_Window_ToBack				EQU	$8042152e	;** V4
MUIM_Window_ToFront				EQU	$8042554f	;** V4

;** Attributes **
MUIA_Window_Activate				EQU	$80428d2f	;** V4  isg BOOL
MUIA_Window_ActiveObject		EQU	$80427925	;** V4  .sg Object
MUIA_Window_AltHeight			EQU	$8042cce3	;** V4  i.g LONG
MUIA_Window_AltLeftEdge			EQU	$80422d65	;** V4  i.g LONG
MUIA_Window_AltTopEdge			EQU	$8042e99b	;** V4  i.g LONG
MUIA_Window_AltWidth				EQU	$804260f4	;** V4  i.g LONG
MUIA_Window_AppWindow			EQU	$804280cf	;** V5  i.. BOOL
MUIA_Window_Backdrop				EQU	$8042c0bb	;** V4  i.. BOOL
MUIA_Window_Borderless			EQU	$80429b79	;** V4  i.. BOOL
MUIA_Window_CloseGadget			EQU	$8042a110	;** V4  i.. BOOL
MUIA_Window_CloseRequest		EQU	$8042e86e	;** V4  ..g BOOL
MUIA_Window_DefaultObject		EQU	$804294d7	;** V4  isg Object
MUIA_Window_DepthGadget			EQU	$80421923	;** V4  i.. BOOL
MUIA_Window_DragBar				EQU	$8042045d	;** V4  i.. BOOL
MUIA_Window_FancyDrawing		EQU	$8042bd0e	;** V8  isg BOOL
MUIA_Window_Height				EQU	$80425846	;** V4  i.g LONG
MUIA_Window_ID						EQU	$804201bd	;** V4  isg ULONG
MUIA_Window_InputEvent			EQU	$804247d8	;** V4  ..g struct InputEvent
MUIA_Window_LeftEdge				EQU	$80426c65	;** V4  i.g LONG
MUIA_Window_Menu					EQU	$8042db94	;** V4  i.. struct NewMenu
MUIA_Window_MenuAction			EQU	$80427521	;** V8  isg ULONG
MUIA_Window_Menustrip			EQU	$8042855e	;** V8  i.. Object
MUIA_Window_MouseObject			EQU	$8042bf9b	;** V10 ..g Object
MUIA_Window_NeedsMouseObject	EQU	$8042372a	;** V10 i.. BOOL
MUIA_Window_NoMenus				EQU	$80429df5	;** V4  is. BOOL
MUIA_Window_Open					EQU	$80428aa0	;** V4  .sg BOOL
MUIA_Window_PublicScreen		EQU	$804278e4	;** V6  isg STRPTR
MUIA_Window_RefWindow			EQU	$804201f4	;** V4  is. Object
MUIA_Window_RootObject			EQU	$8042cba5	;** V4  i.. Object
MUIA_Window_Screen				EQU	$8042df4f	;** V4  isg struct Screen
MUIA_Window_ScreenTitle			EQU	$804234b0	;** V5  isg STRPTR
MUIA_Window_SizeGadget			EQU	$8042e33d	;** V4  i.. BOOL
MUIA_Window_SizeRight			EQU	$80424780	;** V4  i.. BOOL
MUIA_Window_Sleep					EQU	$8042e7db	;** V4  .sg BOOL
MUIA_Window_Title					EQU	$8042ad3d	;** V4  isg STRPTR
MUIA_Window_TopEdge				EQU	$80427c66	;** V4  i.g LONG
MUIA_Window_UseBottomBorderScroller EQU $80424e79 ;** V13 is. BOOL
MUIA_Window_UseLeftBorderScroller EQU $8042433e	;** V13 is. BOOL
MUIA_Window_UseRightBorderScroller EQU $8042c05e ;** V13 is. BOOL
MUIA_Window_Width					EQU	$8042dcae	;** V4  i.g LONG
MUIA_Window_Window				EQU	$80426a42	;** V4  ..g struct Window

MUIV_Window_ActiveObjectNone	EQU	0
MUIV_Window_ActiveObjectNext	EQU	-1
MUIV_Window_ActiveObjectPrev	EQU	-2
MUIV_Window_AltHeightMinMax	EQU	0
MUIV_Window_AltHeightVisible	EQU	-100
MUIV_Window_AltHeightScreen	EQU	-200
MUIV_Window_AltHeightScaled	EQU	-1000
MUIV_Window_AltLeftEdgeCentered EQU	-1
MUIV_Window_AltLeftEdgeMoused	EQU	-2
MUIV_Window_AltLeftEdgeNoChangr EQU	-1000
MUIV_Window_AltTopEdgeCentered EQU	-1
MUIV_Window_AltTopEdgeMoused	EQU	-2
MUIV_Window_AltTopEdgeDelta	EQU	-3
MUIV_Window_AltTopEdgeNoChange EQU	-1000
MUIV_Window_AltWidthMinMax		EQU	0
MUIV_Window_AltWidthVisible	EQU	-100
MUIV_Window_AltWidthScreen		EQU	-200
MUIV_Window_AltWidthScaled		EQU	-1000
MUIV_Window_HeightMinMax		EQU	0
MUIV_Window_HeightVisible		EQU	-100
MUIV_Window_HeightScreen		EQU	-200
MUIV_Window_HeightScaled		EQU	-1000
MUIV_Window_HeightDefault		EQU	-1001
MUIV_Window_LeftEdgeCentered	EQU	-1
MUIV_Window_LeftEdgeMoused		EQU	-2
;OBS MUIV_Window_MenuNoMenu			EQU	-1
MUIV_Window_TopEdgeCentered	EQU	-1
MUIV_Window_TopEdgeMoused		EQU	-2
MUIV_Window_TopEdgeDelta		EQU	-3
MUIV_Window_WidthMinMax			EQU	0
MUIV_Window_WidthVisible		EQU	-100
MUIV_Window_WidthScreen			EQU	-200
MUIV_Window_WidthScaled			EQU	-1000
MUIV_Window_WidthDefault		EQU	-1001


****************************************************************************
** Aboutmui
****************************************************************************

;** Attributes **
MUIA_Aboutmui_Application	EQU	$80422523	;** V11 i.. Object *


****************************************************************************
** Area
****************************************************************************

;** Methods **
MUIM_AskMinMax				EQU	$80423874	;** V4
MUIM_Cleanup				EQU	$8042d985	;** V4
MUIM_ContextMenuBuild	EQU	$80429d2e	;** V11
MUIM_ContextMenuChoice	EQU	$80420f0e	;** V11
MUIM_DragBegin				EQU	$8042c03a	;** V11
MUIM_DragDrop				EQU	$8042c555	;** V11
MUIM_DragFinish			EQU	$804251f0	;** V11
MUIM_DragQuery				EQU	$80420261	;** V11
MUIM_DragReport			EQU	$8042edad	;** V11
MUIM_Draw					EQU	$80426f3f	;** V4
MUIM_DrawBackground		EQU	$804238ca	;** V11
MUIM_HandleEvent			EQU	$80426d66	;** V16
MUIM_HandleInput			EQU	$80422a1a	;** V4
MUIM_Hide					EQU	$8042f20f	;** V4
MUIM_Setup					EQU	$80428354	;** V4
MUIM_Show					EQU	$8042cc84	;** V4

;** Attributes **
MUIA_Background			EQU	$8042545b	;** V4  is. LONG
MUIA_BottomEdge			EQU	$8042e552	;** V4  ..g LONG
MUIA_ContextMenu			EQU	$8042b704	;** V11 isg Object *
MUIA_ContextMenuTrigger	EQU	$8042a2c1	;** V11 ..g Object *
MUIA_ControlChar			EQU	$8042120b	;** V4  i.. char
MUIA_CycleChain			EQU	$80421ce7	;** V11 isg LONG
MUIA_Disabled				EQU	$80423661	;** V4  isg BOOL
MUIA_Draggable				EQU	$80420b6e	;** V11 isg BOOL
MUIA_Dropable				EQU	$8042fbce	;** V11 isg BOOL
MUIA_ExportID				EQU	$8042d76e	;** V4  isg LONG
MUIA_FixHeight				EQU	$8042a92b	;** V4  i.. LONG
MUIA_FixHeightTxt			EQU	$804276f2	;** V4  i.. LONG
MUIA_FixWidth				EQU	$8042a3f1	;** V4  i.. LONG
MUIA_FixWidthTxt			EQU	$8042d044	;** V4  i.. STRPTR
MUIA_Font					EQU	$8042be50	;** V4  i.g struct TextFont
MUIA_Frame					EQU	$8042ac64	;** V4  i.. LONG
MUIA_FramePhantomHoriz	EQU	$8042ed76	;** V4  i.. BOOL
MUIA_FrameTitle			EQU	$8042d1c7	;** V4  i.. STRPTR
MUIA_Height					EQU	$80423237	;** V4  ..g LONG
MUIA_HorizDisappear		EQU	$80429615	;** V11 isg LONG
MUIA_HorizWeight			EQU	$80426db9	;** V4  i.. WORD
MUIA_InnerBottom			EQU	$8042f2c0	;** V4  i.. LONG
MUIA_InnerLeft				EQU	$804228f8	;** V4  i.. LONG
MUIA_InnerRight			EQU	$804297ff	;** V4  i.. LONG
MUIA_InnerTop				EQU	$80421eb6	;** V4  i.. LONG
MUIA_InputMode				EQU	$8042fb04	;** V4  i.. LONG
MUIA_LeftEdge				EQU	$8042bec6	;** V4  ..g LONG
MUIA_MaxHeight				EQU	$804293e4	;** V11 i.. LONG
MUIA_MaxWidth				EQU	$8042f112	;** V11 i.. LONG
MUIA_Pressed				EQU	$80423535	;** V4  ..g BOOL
MUIA_RightEdge				EQU	$8042ba82	;** V4  ..g LONG
MUIA_Selected				EQU	$8042654b	;** V4  isg BOOL
MUIA_ShortHelp				EQU	$80428fe3	;** V11 isg STRPTR
MUIA_ShowMe					EQU	$80429ba8	;** V4  isg BOOL
MUIA_ShowSelState			EQU	$8042caac	;** V4  i.. BOOL
MUIA_Timer					EQU	$80426435	;** V4  ..g LONG
MUIA_TopEdge				EQU	$8042509b	;** V4  ..g LONG
MUIA_VertDisappear		EQU	$8042d12f	;** V11 isg LONG
MUIA_VertWeight			EQU	$804298d0	;** V4  i.. WORD
MUIA_Weight					EQU	$80421d1f	;** V4  i.. WORD
MUIA_Width					EQU	$8042b59c	;** V4  ..g LONG
MUIA_Window					EQU	$80421591	;** V4  ..g struct Window
MUIA_WindowObject			EQU	$8042669e	;** V4  ..g Object

MUIV_DragQuery_Refuse	EQU	0
MUIV_DragQuery_Accept	EQU	1
MUIV_DragReport_Abort	EQU	0
MUIV_DragReport_Continue EQU	1
MUIV_DragReport_Lock		EQU	2
MUIV_DragReport_Refresh	EQU	3
MUIV_FontInherit			EQU	0
MUIV_FontNormal			EQU	-1
MUIV_FontList				EQU	-2
MUIV_FontTiny				EQU	-3
MUIV_FontFixed				EQU	-4
MUIV_FontTitle				EQU	-5
MUIV_FontBig				EQU	-6
MUIV_FontButton			EQU	-7
MUIV_Frame_None			EQU	0
MUIV_Frame_Button			EQU	1
MUIV_Frame_ImageButton	EQU	2
MUIV_Frame_Text			EQU	3
MUIV_Frame_String			EQU	4
MUIV_Frame_ReadList		EQU	5
MUIV_Frame_InputList		EQU	6
MUIV_Frame_Prop			EQU	7
MUIV_Frame_Gauge			EQU	8
MUIV_Frame_Group			EQU	9
MUIV_Frame_PopUp			EQU	10
MUIV_Frame_Virtual		EQU	11
MUIV_Frame_Slider			EQU	12
MUIV_Frame_Count			EQU	13
MUIV_InputMode_None		EQU	0
MUIV_InputMode_RelVerify EQU	1
MUIV_InputMode_Immediate EQU	2
MUIV_InputMode_Toggle	EQU	3


****************************************************************************
** Rectangle
****************************************************************************

** Attributes **
MUIA_Rectangle_BarTitle	EQU	$80426689	;** V11 i.g STRPTR
MUIA_Rectangle_HBar		EQU	$8042c943	;** V7  i.g BOOL
MUIA_Rectangle_VBar		EQU	$80422204	;** V7  i.g BOOL


****************************************************************************
** Balance
****************************************************************************

****************************************************************************
** Image
****************************************************************************

** Attributes **
MUIA_Image_FontMatch			EQU	$8042815d	;** V4  i.. BOOL
MUIA_Image_FontMatch_Height EQU	$80429f26	;** V4  i.. BOOL
MUIA_Image_FontMatch_Width	EQU	$804239bf	;** V4  i.. BOOL
MUIA_Image_FreeHoriz			EQU	$8042da84	;** V4  i.. BOOL
MUIA_Image_FreeVert			EQU	$8042ea28	;** V4  i.. BOOL
MUIA_Image_OldImage			EQU	$80424f3d	;** V4  i.. struct Image
MUIA_Image_Spec				EQU	$804233d5	;** V4  i.. char
MUIA_Image_State				EQU	$8042a3ad	;** V4  is. LONG


****************************************************************************
** Bitmap
****************************************************************************

** Attributes **
MUIA_Bitmap_Bitmap			EQU	$804279bd	;** V8  isg struct BitMap
MUIA_Bitmap_Height			EQU	$80421560	;** V8  isg LONG
MUIA_Bitmap_MappingTable	EQU	$8042e23d	;** V8  isg UBYTE
MUIA_Bitmap_Precision		EQU	$80420c74	;** V11 isg LONG
MUIA_Bitmap_RemappedBitmap	EQU	$80423a47	;** V11 ..g struct BitMap *
MUIA_Bitmap_SourceColors	EQU	$80425360	;** V8  isg ULONG
MUIA_Bitmap_Transparent		EQU	$80422805	;** V8  isg LONG
MUIA_Bitmap_UseFriend		EQU	$804239d8	;** V11 i.. BOOL
MUIA_Bitmap_Width				EQU	$8042eb3a	;** V8  isg LONG


****************************************************************************
** Bodychunk
****************************************************************************

** Attributes **
MUIA_Bodychunk_Body			EQU	$8042ca67	;** V8  isg UBYTE
MUIA_Bodychunk_Compression	EQU	$8042de5f	;** V8  isg UBYTE
MUIA_Bodychunk_Depth			EQU	$8042c392	;** V8  isg LONG
MUIA_Bodychunk_Masking		EQU	$80423b0e	;** V8  isg UBYTE


****************************************************************************
** Text
****************************************************************************

** Attributes **
MUIA_Text_Contents		EQU	$8042f8dc	;** V4  isg STRPTR
MUIA_Text_HiChar			EQU	$804218ff	;** V4  i.. char
MUIA_Text_PreParse		EQU	$8042566d	;** V4  isg STRPTR
MUIA_Text_SetMax			EQU	$80424d0a	;** V4  i.. BOOL
MUIA_Text_SetMin			EQU	$80424e10	;** V4  i.. BOOL
MUIA_Text_SetVMax			EQU	$80420d8b	;** V11 i.. BOOL


****************************************************************************
** Gadget
****************************************************************************

** Attributes **
MUIA_Gadget_Gadget		EQU	$8042ec1a	;** V11 ..g struct Gadget *


****************************************************************************
** String
****************************************************************************

** Attributes **
MUIA_String_Accept			EQU	$8042e3e1	;** V4  isg STRPTR
MUIA_String_Acknowledge		EQU	$8042026c	;** V4  ..g STRPTR
MUIA_String_AdvanceOnCR		EQU	$804226de	;** V11 isg BOOL
MUIA_String_AttachedList	EQU	$80420fd2	;** V4  i.. Object
MUIA_String_BufferPos		EQU	$80428b6c	;** V4  .sg LONG
MUIA_String_Contents			EQU	$80428ffd	;** V4  isg STRPTR
MUIA_String_DisplayPos		EQU	$8042ccbf	;** V4  .sg LONG
MUIA_String_EditHook			EQU	$80424c33	;** V7  isg struct Hook
MUIA_String_Format			EQU	$80427484	;** V4  i.g LONG
MUIA_String_Integer			EQU	$80426e8a	;** V4  isg ULONG
MUIA_String_LonelyEditHook	EQU	$80421569	;** V11 isg BOOL
MUIA_String_MaxLen			EQU	$80424984	;** V4  i.g LONG
MUIA_String_Reject			EQU	$8042179c	;** V4  isg STRPTR
MUIA_String_Secret			EQU	$80428769	;** V4  i.g BOOL

MUIV_String_Format_Left		EQU	0
MUIV_String_Format_Center	EQU	1
MUIV_String_Format_Right	EQU	2


****************************************************************************
** Boopsi
****************************************************************************

** Attributes **
MUIA_Boopsi_Class				EQU	$80426999	;** V4  isg struct IClass *
MUIA_Boopsi_ClassID			EQU	$8042bfa3	;** V4  isg char *
MUIA_Boopsi_MaxHeight		EQU	$8042757f	;** V4  isg ULONG
MUIA_Boopsi_MaxWidth			EQU	$8042bcb1	;** V4  isg ULONG
MUIA_Boopsi_MinHeight		EQU	$80422c93	;** V4  isg ULONG
MUIA_Boopsi_MinWidth			EQU	$80428fb2	;** V4  isg ULONG
MUIA_Boopsi_Object			EQU	$80420178	;** V4  ..g Object *
MUIA_Boopsi_Remember			EQU	$8042f4bd	;** V4  i.. ULONG
MUIA_Boopsi_Smart				EQU	$8042b8d7	;** V9  i.. BOOL
MUIA_Boopsi_TagDrawInfo		EQU	$8042bae7	;** V4  isg ULONG
MUIA_Boopsi_TagScreen		EQU	$8042bc71	;** V4  isg ULONG
MUIA_Boopsi_TagWindow		EQU	$8042e11d	;** V4  isg ULONG


****************************************************************************
** Prop
****************************************************************************

** Methods **
MUIM_Prop_Decrease				EQU	$80420dd1	;** V16
MUIM_Prop_Increase				EQU	$8042cac0	;** V16

** Attributes **
MUIA_Prop_Entries					EQU	$8042fbdb	;** V4  isg LONG
MUIA_Prop_First					EQU	$8042d4b2	;** V4  isg LONG
MUIA_Prop_Horiz					EQU	$8042f4f3	;** V4  i.g BOOL
MUIA_Prop_Slider					EQU	$80429c3a	;** V4  isg BOOL
MUIA_Prop_UseWinBorder			EQU	$8042deee	;** V13 i.. LONG
MUIA_Prop_Visible					EQU	$8042fea6	;** V4  isg LONG

MUIV_Prop_UseWinBorder_None	EQU	0
MUIV_Prop_UseWinBorder_Left	EQU	1
MUIV_Prop_UseWinBorder_Right	EQU	2
MUIV_Prop_UseWinBorder_Bottom	EQU	3


****************************************************************************
** Gauge
****************************************************************************

** Attributes **
MUIA_Gauge_Current	EQU	$8042f0dd	;** V4  isg LONG
MUIA_Gauge_Divide		EQU	$8042d8df	;** V4  isg BOOL
MUIA_Gauge_Horiz		EQU	$804232dd	;** V4  i.. BOOL
MUIA_Gauge_InfoText	EQU	$8042bf15	;** V7  isg char
MUIA_Gauge_Max			EQU	$8042bcdb	;** V4  isg LONG


****************************************************************************
** Scale
****************************************************************************

** Attributes **
MUIA_Scale_Horiz		EQU	$8042919a	;** V4  isg BOOL


****************************************************************************
** Colorfield
****************************************************************************

** Attributes **
MUIA_Colorfield_Blue		EQU	$8042d3b0	;** V4  isg ULONG
MUIA_Colorfield_Green	EQU	$80424466	;** V4  isg ULONG
MUIA_Colorfield_Pen		EQU	$8042713a	;** V4  ..g ULONG
MUIA_Colorfield_Red		EQU	$804279f6	;** V4  isg ULONG
MUIA_Colorfield_RGB		EQU	$8042677a	;** V4  isg ULONG


****************************************************************************
** List
****************************************************************************

** Methods **
MUIM_List_Clear			EQU	$8042ad89	;** V4
MUIM_List_CreateImage	EQU	$80429804	;** V11
MUIM_List_DeleteImage	EQU	$80420f58	;** V11
MUIM_List_Exchange		EQU	$8042468c	;** V4
MUIM_List_GetEntry		EQU	$804280ec	;** V4
MUIM_List_Insert			EQU	$80426c87	;** V4
MUIM_List_InsertSingle	EQU	$804254d5	;** V7
MUIM_List_Jump				EQU	$8042baab	;** V4
MUIM_List_Move				EQU	$804253c2	;** V9
MUIM_List_NextSelected	EQU	$80425f17	;** V6
MUIM_List_Redraw			EQU	$80427993	;** V4
MUIM_List_Remove			EQU	$8042647e	;** V4
MUIM_List_Select			EQU	$804252d8	;** V4
MUIM_List_Sort				EQU	$80422275	;** V4
MUIM_List_TestPos			EQU	$80425f48	;** V11

** Attributes **
MUIA_List_Active			EQU	$8042391c	;** V4  isg LONG
MUIA_List_AdjustHeight	EQU	$8042850d	;** V4  i.. BOOL
MUIA_List_AdjustWidth	EQU	$8042354a	;** V4  i.. BOOL
MUIA_List_AutoVisable	EQU	$8042a445	;** V11 isg BOOL
MUIA_List_CompareHook	EQU	$80425c14	;** V4  is. struct Hook
MUIA_List_ConstructHook	EQU	$8042894f	;** V4  is. struct Hook
MUIA_List_DestructHook	EQU	$804297ce	;** V4  is. struct Hook
MUIA_List_DisplayHook	EQU	$8042b4d5	;** V4  is. struct Hook
MUIA_List_DragSortable	EQU	$80426099	;** V11 isg BOOL
MUIA_List_DropMark		EQU	$8042aba6	;** V11 ..g LONG
MUIA_List_Entries			EQU	$80421654	;** V4  ..g LONG
MUIA_List_First			EQU	$804238d4	;** V4  ..g LONG
MUIA_List_Format			EQU	$80423c0a	;** V4  isg STRPTR
MUIA_List_InsertPosition EQU	$8042d0cd	;** V9  ..g LONG
MUIA_List_MultiTestHook	EQU	$8042c2c6	;** V4  is. struct Hook
MUIA_List_Pool				EQU	$80423431	;** V13 i.. APTR
MUIA_List_PoolPuddleSize EQU	$8042a4eb	;** V13 i.. ULONG
MUIA_List_PoolThreshSize EQU	$8042c48c	;** V13 i.. ULONG
MUIA_List_Quiet			EQU	$8042d8c7	;** V4  .s. BOOL
MUIA_List_ShowDropMarks	EQU	$8042c6f3	;** V11 isg BOOL
MUIA_List_SourceArray	EQU	$8042c0a0	;** V4  i.. APTR
MUIA_List_Title			EQU	$80423e66	;** V6  isg char
MUIA_List_Visible			EQU	$8042191f	;** V4  ..g LONG

MUIV_List_Active_Off				EQU	-1
MUIV_List_Active_Top				EQU	-2
MUIV_List_Active_Bottom			EQU	-3
MUIV_List_Active_Up				EQU	-4
MUIV_List_Active_Down			EQU	-5
MUIV_List_Active_PageUp			EQU	-6
MUIV_List_Active_PageDown		EQU	-7
MUIV_List_ConstructHookString	EQU	-1
MUIV_List_CopyHookString		EQU	-1
MUIV_List_CursorType_None		EQU	0
MUIV_List_CursorType_Bar		EQU	1
MUIV_List_CursorType_Rect		EQU	2
MUIV_List_DestructHookString	EQU	-1


****************************************************************************
** Floattext
****************************************************************************

** Attributes **
MUIA_Floattext_Justify		EQU	$8042dc03	;** V4  isg BOOL
MUIA_Floattext_SkipChars	EQU	$80425c7d	;** V4  is. STRPTR
MUIA_Floattext_TabSize		EQU	$80427d17	;** V4  is. LONG
MUIA_Floattext_Text			EQU	$8042d16a	;** V4  isg STRPTR


****************************************************************************
** Volumelist
****************************************************************************

****************************************************************************
** Scrmodelist
****************************************************************************

****************************************************************************
** Dirlist
****************************************************************************

** Methods **
MUIM_Dirlist_ReRead			EQU	$80422d71	;** V4

** Attributes **
MUIA_Dirlist_AcceptPattern	EQU	$8042760a	;** V4  is. STRPTR
MUIA_Dirlist_Directory		EQU	$8042ea41	;** V4  isg STRPTR
MUIA_Dirlist_DrawersOnly	EQU	$8042b379	;** V4  is. BOOL
MUIA_Dirlist_FilesOnly		EQU	$8042896a	;** V4  is. BOOL
MUIA_Dirlist_FilterDrawers	EQU	$80424ad2	;** V4  is. BOOL
MUIA_Dirlist_FilterHook		EQU	$8042ae19	;** V4  is. struct Hook
MUIA_Dirlist_MultiSelDirs	EQU	$80428653	;** V6  is. BOOL
MUIA_Dirlist_NumBytes		EQU	$80429e26	;** V4  ..g LONG
MUIA_Dirlist_NumDrawers		EQU	$80429cb8	;** V4  ..g LONG
MUIA_Dirlist_NumFiles		EQU	$8042a6f0	;** V4  ..g LONG
MUIA_Dirlist_Path				EQU	$80426176	;** V4  ..g STRPTR
MUIA_Dirlist_RejectIcons	EQU	$80424808	;** V4  is. BOOL
MUIA_Dirlist_RejectPattern	EQU	$804259c7	;** V4  is. STRPTR
MUIA_Dirlist_SortDirs		EQU	$8042bbb9	;** V4  is. LONG
MUIA_Dirlist_SortHighLow	EQU	$80421896	;** V4  is. BOOL
MUIA_Dirlist_SortType		EQU	$804228bc	;** V4  is. LONG
MUIA_Dirlist_Status			EQU	$804240de	;** V4  ..g LONG

MUIV_Dirlist_SortDirsFirst	EQU	0
MUIV_Dirlist_SortDirsLast	EQU	1
MUIV_Dirlist_SortDirsMix	EQU	2
MUIV_Dirlist_SortTypeName	EQU	0
MUIV_Dirlist_SortTypeDate	EQU	1
MUIV_Dirlist_SortTypeSize	EQU	2
MUIV_Dirlist_StatusInvalid	EQU	0
MUIV_Dirlist_StatusReading	EQU	1
MUIV_Dirlist_StatusValid	EQU	2


****************************************************************************
** Numeric
****************************************************************************

** Methods **
MUIM_Numeric_Decrease			EQU	$804243a7	;** V11
MUIM_Numeric_Increase			EQU	$80426ecd	;** V11
MUIM_Numeric_ScaleToValue		EQU	$8042032c	;** V11
MUIM_Numeric_SetDefault			EQU	$8042ab0a	;** V11
MUIM_Numeric_Stringify			EQU	$80424891	;** V11
MUIM_Numeric_ValueToScale		EQU	$80423e4f	;** V11

** Attributes **
MUIA_Numeric_Dedault			EQU	$804263e8	;** V11 isg LONG
MUIA_Numeric_Format			EQU	$804263e9	;** V11 isg STRPTR
MUIA_Numeric_Max				EQU	$8042d78a	;** V11 isg LONG
MUIA_Numeric_Min				EQU	$8042e404	;** V11 isg LONG
MUIA_Numeric_Reverse			EQU	$8042f2a0	;** V11 isg BOOL
MUIA_Numeric_RevLeftRight	EQU	$804294a7	;** V11 isg BOOL
MUIA_Numeric_RevUpDown		EQU	$804252dd	;** V11 isg BOOL
MUIA_Numeric_Value			EQU	$8042ae3a	;** V11 isg LONG


****************************************************************************
** Knob
****************************************************************************

****************************************************************************
** Levelmeter
****************************************************************************

** Attributes **
MUIA_Levelmeter_Label	EQU	$80420dd5	;** V11 isg STRPTR


****************************************************************************
** Numericbutton
****************************************************************************

****************************************************************************
** Slider
****************************************************************************

** Attributes **
MUIA_Slider_Horiz		EQU	$8042fad1	;** V11 isg BOOL
MUIA_Slider_Level		EQU	$8042ae3a	;** V4  isg LONG
MUIA_Slider_Max		EQU	$8042d78a	;** V4  isg LONG
MUIA_Slider_Min		EQU	$8042e404	;** V4  isg LONG
MUIA_Slider_Quiet		EQU	$80420b26	;** V6  i.. BOOL
MUIA_Slider_Reverse	EQU	$8042f2a0	;** V4  isg BOOL


****************************************************************************
** Framedisplay
****************************************************************************

****************************************************************************
** PopFrame
****************************************************************************

****************************************************************************
** Imagedisplay
****************************************************************************

****************************************************************************
** Popimage
****************************************************************************

****************************************************************************
** Pendisplay
****************************************************************************

** Methods **
MUIM_Pendisplay_SetColormap EQU	$80426c80	;** V13
MUIM_Pendisplay_SetMUIPen	EQU	$8042039d	;** V13
MUIM_Pendisplay_SetRGB		EQU	$8042c131	;** V13

** Attributes **
MUIA_Pendisplay_Pen			EQU	$8042a748	;** V13 ..g Object *
MUIA_Pendisplay_Reference	EQU	$8042dc24	;** V13 isg Object *
MUIA_Pendisplay_RGBcolor	EQU	$8042a1a9	;** V11 isg struct MUI_RGBcolor *
MUIA_Pendisplay_Spec			EQU	$8042a204	;** V11 isg struct MUI_PenSpec *


****************************************************************************
** Poppen
****************************************************************************

****************************************************************************
** Group
****************************************************************************

** Methods **
MUIM_Group_ExitChange	EQU	$8042d1cc	;** V11
MUIM_Group_InitChange	EQU	$80420887	;** V11
MUIM_Group_Sort			EQU	$80427417	;** V4

** Attributes **
MUIA_Group_ActivePage	EQU	$80424199	;** V5  isg LONG
MUIA_Group_Child			EQU	$804226e6	;** V4  i.. Object
MUIA_Group_Columns		EQU	$8042f416	;** V4  is. LONG
MUIA_Group_Horiz			EQU	$8042536b	;** V4  i.. BOOL
MUIA_Group_HorizSpacing	EQU	$8042c651	;** V4  is. LONG
MUIA_Group_LayoutHook	EQU	$8042c3b2	;** V11 i.. struct Hook *
MUIA_Group_PageMode		EQU	$80421a5f	;** V5  is. BOOL
MUIA_Group_Rows			EQU	$8042b68f	;** V4  is. LONG
MUIA_Group_SameHeight	EQU	$8042037e	;** V4  i.. BOOL
MUIA_Group_SameSize		EQU	$80420860	;** V4  i.. BOOL
MUIA_Group_SameWidth		EQU	$8042b3ec	;** V4  i.. BOOL
MUIA_Group_Spacing		EQU	$8042866d	;** V4  is. LONG
MUIA_Group_VertSpacing	EQU	$8042e1bf	;** V4  is. LONG

MUIV_Group_ActivePageFirst	EQU	0
MUIV_Group_ActivePageLast	EQU	-1
MUIV_Group_ActivePagePrev	EQU	-2
MUIV_Group_ActivePageNext	EQU	-3
MUIV_Group_ActivePageAdvance EQU	-4


****************************************************************************
** Mccprefs
****************************************************************************

****************************************************************************
** Register
****************************************************************************

** Attributes **
MUIA_Register_Frame	EQU	$8042349b	;** V7  i.g BOOL
MUIA_Register_Titles	EQU	$804297ec	;** V7  i.g STRPTR


****************************************************************************
** Penadjust
****************************************************************************

** Attributes **
MUIA_Penadjust_PSIMode	EQU	$80421cbb	;** V11 i.. BOOL


****************************************************************************
** SettingsGroup
****************************************************************************

** Methods **
MUIM_Settingsgroup_ConfigToGadgets	EQU	$80427043	;** V11
MUIM_Settingsgroup_GadgetsToConfig	EQU	$80425242	;** V11


****************************************************************************
** Settings
****************************************************************************

****************************************************************************
** Frameadjust
****************************************************************************

****************************************************************************
** Imageadjust
****************************************************************************

MUIV_Imageadjust_Type_All			EQU	0
MUIV_Imageadjust_Type_Image		EQU	1
MUIV_Imageadjust_Type_Background	EQU	2
MUIV_Imageadjust_Type_Pen			EQU	3


****************************************************************************
** Virtgroup
****************************************************************************

** Attributes **
MUIA_Virtgroup_Height	EQU	$80423038	;** V6  ..g LONG
MUIA_Virtgroup_Input		EQU	$80427f7e	;** V11 i.. BOOL
MUIA_Virtgroup_Left		EQU	$80429371	;** V6  isg LONG
MUIA_Virtgroup_Top		EQU	$80425200	;** V6  isg LONG
MUIA_Virtgroup_Width		EQU	$80427c49	;** V6  ..g LONG


****************************************************************************
** Scrollgroup
****************************************************************************

** Attributes **
MUIA_Scrollgroup_Contents	EQU	$80421261	;** V4  i.. Object
MUIA_Scrollgroup_FreeHoriz	EQU	$804292f3	;** V9  i.. BOOL
MUIA_Scrollgroup_FreeVert	EQU	$804224f2	;** V9  i.. BOOL
MUIA_Scrollgroup_HorizBar	EQU	$8042b63d	;** V16	..g Object *
MUIA_Scrollgroup_UseWinBorder	EQU $804284c1	;** V13 i.. BOOL
MUIA_Scrollgroup_VertBar	EQU	$8042cdc0	;** V16 ..g Object *


****************************************************************************
** Scrollbar
****************************************************************************

** Attributes **
MUIA_Scrollbar_Type				EQU	$8042fb6b	;** V11 i.. LONG

MUIV_Scrollbar_Type_Default	EQU	0
MUIV_Scrollbar_Type_Bottom		EQU	1
MUIV_Scrollbar_Type_Top			EQU	2
MUIV_Scrollbar_Type_Sym			EQU	3


****************************************************************************
** Listview
****************************************************************************

** Attributes **
MUIA_Listview_ClickColumn		EQU	$8042d1b3	;** V7  ..g LONG
MUIA_Listview_DefClickColumn	EQU	$8042b296	;** V7  isg LONG
MUIA_Listview_DoubleClick		EQU	$80424635	;** V4  i.g BOOL
MUIA_Listview_DragType			EQU	$80425cd3	;** V11 isg LONG
MUIA_Listview_Input				EQU	$8042682d	;** V4  i.. BOOL
MUIA_Listview_List				EQU	$8042bcce	;** V4  i.. Object
MUIA_Listview_MultiSelect		EQU	$80427e08	;** V7  i.. LONG
MUIA_Listview_ScrollerPos		EQU	$8042b1b4	;** V10 i.. BOOL
MUIA_Listview_SelectChange		EQU	$8042178f	;** V4  ..g BOOL

MUIV_Listview_DragType_None			EQU	0
MUIV_Listview_DragType_Immediate		EQU	1
MUIV_Listview_MultiSelect_None		EQU	0
MUIV_Listview_MultiSelect_Default	EQU	1
MUIV_Listview_MultiSelect_Shifte		EQU	2
MUIV_Listview_MultiSelect_Always		EQU	3
MUIV_Listview_ScrollerPos_Default	EQU	0
MUIV_Listview_ScrollerPos_Left		EQU	1
MUIV_Listview_ScrollerPos_Right		EQU	2
MUIV_Listview_ScrollerPos_None		EQU	3


****************************************************************************
** Radio
****************************************************************************

** Attributes **
MUIA_Radio_Active		EQU	$80429b41	;** V4  isg LONG
MUIA_Radio_Entries	EQU	$8042b6a1	;** V4  i.. STRPTR


****************************************************************************
** Cycle
****************************************************************************

** Attributes **
MUIA_Cycle_Active			EQU	$80421788	;** V4  isg LONG
MUIA_Cycle_Entries		EQU	$80420629	;** V4  i.. STRPTR

MUIV_Cycle_ActiveNext	EQU	-1
MUIV_Cycle_ActivePrev	EQU	-2


****************************************************************************
** Coloradjust
****************************************************************************

** Attributes **
MUIA_Coloradjust_Blue	EQU	$8042b8a3	;** V4  isg ULONG
MUIA_Coloradjust_Green	EQU	$804285ab	;** V4  isg ULONG
MUIA_Coloradjust_ModeID	EQU	$8042ec59	;** V4  isg ULONG
MUIA_Coloradjust_Red		EQU	$80420eaa	;** V4  isg ULONG
MUIA_Coloradjust_RGB		EQU	$8042f899	;** V4  isg ULONG


****************************************************************************
** Palette
****************************************************************************

** Attributes **
MUIA_Palette_Entries		EQU	$8042a3d8	;** V6  i.g struct MUI_Palette_Entry
MUIA_Palette_Groupable	EQU	$80423e67	;** V6  isg BOOL
MUIA_Palette_Names		EQU	$8042c3a2	;** V6  isg char


****************************************************************************
** Colorpanel
****************************************************************************

****************************************************************************
** Popstring
****************************************************************************

** Methods **
MUIM_Popstring_Close			EQU	$8042dc52	;** V7
MUIM_Popstring_Open			EQU	$804258ba	;** V7

** Attributes **
MUIA_Popstring_Button		EQU	$8042d0b9	;** V7  i.g Object
MUIA_Popstring_CloseHook	EQU	$804256bf	;** V7  isg struct Hook
MUIA_Popstring_OpenHook		EQU	$80429d00	;** V7  isg struct Hook
MUIA_Popstring_String		EQU	$804239ea	;** V7  i.g Object
MUIA_Popstring_Toggle		EQU	$80422b7a	;** V7  isg BOOL


****************************************************************************
** Popobject
****************************************************************************

** Attributes **
MUIA_Popobject_Follow		EQU	$80424cb5	;** V7  isg BOOL
MUIA_Popobject_Light			EQU	$8042a5a3	;** V7  isg BOOL
MUIA_Popobject_Object		EQU	$804293e3	;** V7  i.g Object
MUIA_Popobject_ObjStrHook	EQU	$8042db44	;** V7  isg struct Hook
MUIA_Popobject_StrObjHook	EQU	$8042fbe1	;** V7  isg struct Hook
MUIA_Popobject_Volatile		EQU	$804252ec	;** V7  isg BOOL
MUIA_Popobject_WindowHook	EQU	$8042f194	;** V9  isg struct Hook


****************************************************************************
** Poplist
****************************************************************************

** Attributes **
MUIA_Poplist_Array	EQU	$8042084c	;** V8  i.. char


****************************************************************************
** Popscreen
****************************************************************************

****************************************************************************
** Popasl
****************************************************************************

** Attributes **
MUIA_Popasl_Active		EQU	$80421b37	;** V7  ..g BOOL
MUIA_Popasl_StartHook	EQU	$8042b703	;** V7  isg struct Hook
MUIA_Popasl_StopHook		EQU	$8042d8d2	;** V7  isg struct Hook
MUIA_Popasl_Type			EQU	$8042df3d	;** V7  i.g ULONG


****************************************************************************
** Semaphore
****************************************************************************

** Methods **
MUIM_Semaphore_Attempt			EQU	$80426ce2	;** V11
MUIM_Semaphore_AttemptShared	EQU	$80422551	;** V11
MUIM_Semaphore_Obtain			EQU	$804276f0	;** V11
MUIM_Semaphore_ObtainShared	EQU	$8042ea02	;** V11
MUIM_Semaphore_Release			EQU	$80421f2d	;** V11

****************************************************************************
** Applist
****************************************************************************

****************************************************************************
** Cclist
****************************************************************************

****************************************************************************
** Dataspace
****************************************************************************

** Methods **
MUIM_Dataspace_Add			EQU	$80423366	;** V11
MUIM_Dataspace_Clear			EQU	$8042b6c9	;** V11
MUIM_Dataspace_Find			EQU	$8042832c	;** V11
MUIM_Dataspace_Merge			EQU	$80423e2b	;** V11
MUIM_Dataspace_ReadIFF		EQU	$80420dfb	;** V11
MUIM_Dataspace_Remove		EQU	$8042dce1	;** V11
MUIM_Dataspace_WriteIFF		EQU	$80425e8e	;** V11

** Attributes **
MUIA_Dataspace_Pool			EQU	$80424cf9	;** V11 i.. APTR


****************************************************************************
** Configdata
****************************************************************************


;*******************************************
;** End of automatic header file creation **
;*******************************************


;* MUI_CustomClass returned by MUI_CreateCustomClass() *

 STRUCTURE MUI_CustomClass,0

	APTR	mcc_UserData			;* use for whatever you want *

	APTR	mcc_UtilityBase		;* MUI has opened these libraries *
	APTR	mcc_DOSBase				;* for you automatically. You can *
	APTR	mcc_GfxBase				;* use them or decide to open 	 *
	APTR	mcc_IntuitionBase		;* your libraries yourself.		 *

	APTR	mcc_Super				;* pointer to super class   *
	APTR	mcc_Class				;* pointer to the new class *

		;* ... private data follows ... *

****************************************************************************

 ENDC  ;LIBRARIES_MUI_I
