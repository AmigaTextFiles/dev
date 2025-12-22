****************************************************************************
**
** MUI - MagicUserInterface
** (c) 1993 by Stefan Stuntz
**
** Main Header File
**
*** Assembler modifications 26-Aug-93 by Henri Veisterä.
**
****************************************************************************
** General Header File Information
****************************************************************************
**
** All macro and structure definitions follow these rules:
**
** Name                       Meaning
**
** MUIC_<class>               Name of a class
** MUIM_<class>_<method>      Method
** MUIP_<class>_<method>      Methods parameter structure
** MUIV_<class>_<method>_<x>  Special method value
** MUIA_<class>_<attrib>      Attribute
** MUIV_<class>_<attrib>_<x>  Special attribute value
** MUIE_<error>               Error return code from MUI_Error()
** MUII_<name>                Standard MUI image
**
** MUIA_... attribute definitions are followed by a comment
** consisting of the three possible letters I, S and G.
** I: it's possible to specify this attribute at object creation time.
** S: it's possible to change this attribute with SetAttrs().
** G: it's possible to get this attribute with GetAttr().
**


   IFND LIBRARIES_MUI_I
LIBRARIES_MUI_I SET 1

   IFND EXEC_TYPES_I
   INCLUDE "exec/types.i"
   ENDC  ;EXEC_TYPES_I

   IFND INTUITION_CLASSES_I
   INCLUDE "intuition/classes.i"
   ENDC  ;INTUITION_CLASSES_I

   IFND INTUITION_SCREENS_I
   INCLUDE "intuition/screens.i"
   ENDC  ;INTUITION_SCREENS_I

   IFND UTILITY_HOOKS_I
   INCLUDE "utility/hooks.i"
   ENDC  ;UTILITY_HOOKS_I



****************************************************************************
** Library specification
****************************************************************************

MUIMASTER_NAME MACRO
         dc.b     "muimaster.library",0
         even
         ENDM
MUIMASTER_VMIN EQU 4
CALLMUI  MACRO   ; Func
         move.l   _MUIMasterBase(pc),a6
         jsr      _LVO\1(a6)
         ENDM
NULL     equ      0
TRUE     equ      1
FALSE    equ      NULL


****************************************************************************
** ARexx Interface
****************************************************************************

 STRUCTURE MUI_Command,0
   APTR     mc_Name
   APTR     mc_Template
   LONG     mc_Parameters
   STRUCT   mc_Hook,h_SIZEOF
   STRUCT   mc_Reserved,4*5
   LABEL    MUI_Command_SIZEOF

MC_TEMPLATE_ID EQU ~0


****************************************************************************
** Return values for MUI_Error()
****************************************************************************

MUIE_OK                    EQU 0
MUIE_OutOfMemory           EQU 1
MUIE_OutOfGfxMemory        EQU 2
MUIE_InvalidWindowObject   EQU 3
MUIE_MissingLibrary        EQU 4
MUIE_NoARexx               EQU 5
MUIE_SingleTask            EQU 6



****************************************************************************
** Standard MUI Images
****************************************************************************

MUII_WindowBack      EQU 0
MUII_RequesterBack   EQU 1
MUII_ButtonBack      EQU 2
MUII_ListBack        EQU 3
MUII_TextBack        EQU 4
MUII_PropBack        EQU 5
MUII_ActiveBack      EQU 6
MUII_SelectedBack    EQU 7
MUII_ListCursor      EQU 8
MUII_ListSelect      EQU 9
MUII_ListSelCur      EQU 10
MUII_ArrowUp         EQU 11
MUII_ArrowDown       EQU 12
MUII_ArrowLeft       EQU 13
MUII_ArrowRight      EQU 14
MUII_CheckMark       EQU 15
MUII_RadioButton     EQU 16
MUII_Cycle           EQU 17
MUII_PopUp           EQU 18
MUII_PopFile         EQU 19
MUII_PopDrawer       EQU 20
MUII_PropKnob        EQU 21
MUII_Drawer          EQU 22
MUII_HardDisk        EQU 23
MUII_Disk            EQU 24
MUII_Chip            EQU 25
MUII_Volume          EQU 26
MUII_Count           EQU 27

MUII_BACKGROUND      EQU (128+0)
MUII_SHADOW          EQU (128+1)
MUII_SHINE           EQU (128+2)
MUII_FILL            EQU (128+3)
MUII_SHADOWBACK      EQU (128+4)
MUII_SHADOWFILL      EQU (128+5)
MUII_SHADOWSHINE     EQU (128+6)
MUII_FILLBACK        EQU (128+7)
MUII_FILLSHINE       EQU (128+8)
MUII_SHINEBACK       EQU (128+9)
MUII_FILLBACK2       EQU (128+10)


****************************************************************************
** Special values for some methods 
****************************************************************************

MUIV_TriggerValue       EQU $49893131
MUIV_EveryTime          EQU $49893131

MUIV_Application_Save_ENV     EQU 0
MUIV_Application_Save_ENVARC  EQU ~0
MUIV_Application_Load_ENV     EQU 0
MUIV_Application_Load_ENVARC  EQU ~0

MUIV_Application_ReturnID_Quit   EQU -1

MUIV_List_Insert_Top       EQU 0
MUIV_List_Insert_Active    EQU -1
MUIV_List_Insert_Sorted    EQU -2
MUIV_List_Insert_Bottom    EQU -3

MUIV_List_Remove_First     EQU 0
MUIV_List_Remove_Active    EQU -1
MUIV_List_Remove_Last      EQU -2

MUIV_List_Select_Off       EQU 0
MUIV_List_Select_On        EQU 1
MUIV_List_Select_Toggle    EQU 2
MUIV_List_Select_Ask       EQU 3

MUIV_List_Jump_Active      EQU -1
MUIV_List_GetEntry_Active  EQU -1
MUIV_List_Select_Active    EQU -1

MUIV_List_Redraw_Active    EQU -1
MUIV_List_Redraw_All       EQU -2

MUIV_List_Exchange_Active  EQU -1




;****************************************************************************
;** Notify.mui 7.13 (01.12.93)                                             **
;****************************************************************************

;** Methods **

MUIM_CallHook                  EQU $8042b96b
MUIM_KillNotify                EQU $8042d240
MUIM_MultiSet                  EQU $8042d356
MUIM_Notify                    EQU $8042c9cb
MUIM_Set                       EQU $8042549a
MUIM_SetAsString               EQU $80422590
MUIM_WriteLong                 EQU $80428d86
MUIM_WriteString               EQU $80424bf4

;** Attributes **

MUIA_AppMessage                 EQU $80421955 ;** ..g struct AppMessage * **
MUIA_HelpFile                   EQU $80423a6e ;** isg STRPTR            **
MUIA_HelpLine                   EQU $8042a825 ;** isg LONG              **
MUIA_HelpNode                   EQU $80420b85 ;** isg STRPTR            **
MUIA_NoNotify                   EQU $804237f9 ;** .s. BOOL              **
MUIA_Revision                   EQU $80427eaa ;** ..g LONG              **
MUIA_UserData                   EQU $80420313 ;** isg ULONG             **
MUIA_Version                    EQU $80422301 ;** ..g LONG              **



;****************************************************************************
;** Application.mui 7.12 (28.11.93)                                        **
;****************************************************************************

;** Methods **

MUIM_Application_GetMenuCheck  EQU $8042c0a7
MUIM_Application_GetMenuState  EQU $8042a58f
MUIM_Application_Input         EQU $8042d0f5
MUIM_Application_InputBuffered EQU $80427e59
MUIM_Application_Load          EQU $8042f90d
MUIM_Application_PushMethod    EQU $80429ef8
MUIM_Application_ReturnID      EQU $804276ef
MUIM_Application_Save          EQU $804227ef
MUIM_Application_SetMenuCheck  EQU $8042a707
MUIM_Application_SetMenuState  EQU $80428bef
MUIM_Application_ShowHelp      EQU $80426479

;** Attributes **

MUIA_Application_Active         EQU $804260ab ;** isg BOOL              **
MUIA_Application_Author         EQU $80424842 ;** i.g STRPTR            **
MUIA_Application_Base           EQU $8042e07a ;** i.g STRPTR            **
MUIA_Application_Broker         EQU $8042dbce ;** ..g Broker *          **
MUIA_Application_BrokerHook     EQU $80428f4b ;** isg struct Hook *     **
MUIA_Application_BrokerPort     EQU $8042e0ad ;** ..g struct MsgPort *  **
MUIA_Application_BrokerPri      EQU $8042c8d0 ;** i.g LONG              **
MUIA_Application_Commands       EQU $80428648 ;** isg struct MUI_Command * **
MUIA_Application_Copyright      EQU $8042ef4d ;** i.g STRPTR            **
MUIA_Application_Description    EQU $80421fc6 ;** i.g STRPTR            **
MUIA_Application_DiskObject     EQU $804235cb ;** isg struct DiskObject * **
MUIA_Application_DoubleStart    EQU $80423bc6 ;** ..g BOOL              **
MUIA_Application_DropObject     EQU $80421266 ;** is. Object *          **
MUIA_Application_Iconified      EQU $8042a07f ;** .sg BOOL              **
MUIA_Application_Menu           EQU $80420e1f ;** i.g struct NewMenu *  **
MUIA_Application_MenuAction     EQU $80428961 ;** ..g ULONG             **
MUIA_Application_MenuHelp       EQU $8042540b ;** ..g ULONG             **
MUIA_Application_RexxHook       EQU $80427c42 ;** isg struct Hook *     **
MUIA_Application_RexxMsg        EQU $8042fd88 ;** ..g struct RxMsg *    **
MUIA_Application_RexxString     EQU $8042d711 ;** .s. STRPTR            **
MUIA_Application_SingleTask     EQU $8042a2c8 ;** i.. BOOL              **
MUIA_Application_Sleep          EQU $80425711 ;** .s. BOOL              **
MUIA_Application_Title          EQU $804281b8 ;** i.g STRPTR            **
MUIA_Application_Version        EQU $8042b33f ;** i.g STRPTR            **
MUIA_Application_Window         EQU $8042bfe0 ;** i.. Object *          **



;****************************************************************************
;** Window.mui 7.16 (03.12.93)                                             **
;****************************************************************************

;** Methods **

MUIM_Window_GetMenuCheck       EQU $80420414
MUIM_Window_GetMenuState       EQU $80420d2f
MUIM_Window_ScreenToBack       EQU $8042913d
MUIM_Window_ScreenToFront      EQU $804227a4
MUIM_Window_SetCycleChain      EQU $80426510
MUIM_Window_SetMenuCheck       EQU $80422243
MUIM_Window_SetMenuState       EQU $80422b5e
MUIM_Window_ToBack             EQU $8042152e
MUIM_Window_ToFront            EQU $8042554f

;** Attributes **

MUIA_Window_Activate            EQU $80428d2f ;** isg BOOL              **
MUIA_Window_ActiveObject        EQU $80427925 ;** .sg Object *          **
MUIA_Window_AltHeight           EQU $8042cce3 ;** i.g LONG              **
MUIA_Window_AltLeftEdge         EQU $80422d65 ;** i.g LONG              **
MUIA_Window_AltTopEdge          EQU $8042e99b ;** i.g LONG              **
MUIA_Window_AltWidth            EQU $804260f4 ;** i.g LONG              **
MUIA_Window_AppWindow           EQU $804280cf ;** i.. BOOL              **
MUIA_Window_Backdrop            EQU $8042c0bb ;** i.. BOOL              **
MUIA_Window_Borderless          EQU $80429b79 ;** i.. BOOL              **
MUIA_Window_CloseGadget         EQU $8042a110 ;** i.. BOOL              **
MUIA_Window_CloseRequest        EQU $8042e86e ;** ..g BOOL              **
MUIA_Window_DefaultObject       EQU $804294d7 ;** isg Object *          **
MUIA_Window_DepthGadget         EQU $80421923 ;** i.. BOOL              **
MUIA_Window_DragBar             EQU $8042045d ;** i.. BOOL              **
MUIA_Window_Height              EQU $80425846 ;** i.g LONG              **
MUIA_Window_ID                  EQU $804201bd ;** isg ULONG             **
MUIA_Window_InputEvent          EQU $804247d8 ;** ..g struct InputEvent * **
MUIA_Window_LeftEdge            EQU $80426c65 ;** i.g LONG              **
MUIA_Window_Menu                EQU $8042db94 ;** i.. struct NewMenu *  **
MUIA_Window_NoMenus             EQU $80429df5 ;** .s. BOOL              **
MUIA_Window_Open                EQU $80428aa0 ;** .sg BOOL              **
MUIA_Window_PublicScreen        EQU $804278e4 ;** isg STRPTR            **
MUIA_Window_RefWindow           EQU $804201f4 ;** is. Object *          **
MUIA_Window_RootObject          EQU $8042cba5 ;** i.. Object *          **
MUIA_Window_Screen              EQU $8042df4f ;** isg struct Screen *   **
MUIA_Window_ScreenTitle         EQU $804234b0 ;** isg STRPTR            **
MUIA_Window_SizeGadget          EQU $8042e33d ;** i.. BOOL              **
MUIA_Window_SizeRight           EQU $80424780 ;** i.. BOOL              **
MUIA_Window_Sleep               EQU $8042e7db ;** .sg BOOL              **
MUIA_Window_Title               EQU $8042ad3d ;** isg STRPTR            **
MUIA_Window_TopEdge             EQU $80427c66 ;** i.g LONG              **
MUIA_Window_Width               EQU $8042dcae ;** i.g LONG              **
MUIA_Window_Window              EQU $80426a42 ;** ..g struct Window *   **

MUIV_Window_ActiveObjectNone    EQU 0
MUIV_Window_ActiveObjectNext    EQU -1
MUIV_Window_ActiveObjectPrev    EQU -2
MUIV_Window_AltHeightMinMax     EQU 0
MUIV_Window_AltHeightVisible    EQU -100
MUIV_Window_AltHeightScreen     EQU -200
MUIV_Window_AltHeightScaled     EQU -1000
MUIV_Window_AltLeftEdgeCentered EQU -1
MUIV_Window_AltLeftEdgeMoused   EQU -2
MUIV_Window_AltLeftEdgeNoChange EQU -1000
MUIV_Window_AltTopEdgeCentered  EQU -1
MUIV_Window_AltTopEdgeMoused    EQU -2
MUIV_Window_AltTopEdgeDelta     EQU -3
MUIV_Window_AltTopEdgeNoChange  EQU -1000
MUIV_Window_AltWidthMinMax      EQU 0
MUIV_Window_AltWidthVisible     EQU -100
MUIV_Window_AltWidthScreen      EQU -200
MUIV_Window_AltWidthScaled      EQU -1000
MUIV_Window_HeightMinMax        EQU 0
MUIV_Window_HeightVisible       EQU -100
MUIV_Window_HeightScreen        EQU -200
MUIV_Window_HeightScaled        EQU -1000
MUIV_Window_HeightDefault       EQU -1001
MUIV_Window_LeftEdgeCentered    EQU -1
MUIV_Window_LeftEdgeMoused      EQU -2
MUIV_Window_MenuNoMenu          EQU -1
MUIV_Window_TopEdgeCentered     EQU -1
MUIV_Window_TopEdgeMoused       EQU -2
MUIV_Window_TopEdgeDelta        EQU -3
MUIV_Window_WidthMinMax         EQU 0
MUIV_Window_WidthVisible        EQU -100
MUIV_Window_WidthScreen         EQU -200
MUIV_Window_WidthScaled         EQU -1000
MUIV_Window_WidthDefault        EQU -1001


;****************************************************************************
;** Area.mui 7.15 (28.11.93)                                               **
;****************************************************************************

;** Methods **

MUIM_AskMinMax                 EQU $80423874
MUIM_Cleanup                   EQU $8042d985
MUIM_Draw                      EQU $80426f3f
MUIM_HandleInput               EQU $80422a1a
MUIM_Hide                      EQU $8042f20f
MUIM_Setup                     EQU $80428354
MUIM_Show                      EQU $8042cc84

;** Attributes **

MUIA_ApplicationObject          EQU $8042d3ee ;** ..g Object *          **
MUIA_Background                 EQU $8042545b ;** is. LONG              **
MUIA_BottomEdge                 EQU $8042e552 ;** ..g LONG              **
MUIA_ControlChar                EQU $8042120b ;** i.. char              **
MUIA_Disabled                   EQU $80423661 ;** isg BOOL              **
MUIA_ExportID                   EQU $8042d76e ;** isg LONG              **
MUIA_FixHeight                  EQU $8042a92b ;** i.. LONG              **
MUIA_FixHeightTxt               EQU $804276f2 ;** i.. LONG              **
MUIA_FixWidth                   EQU $8042a3f1 ;** i.. LONG              **
MUIA_FixWidthTxt                EQU $8042d044 ;** i.. STRPTR            **
MUIA_Font                       EQU $8042be50 ;** i.g struct TextFont * **
MUIA_Frame                      EQU $8042ac64 ;** i.. LONG              **
MUIA_FramePhantomHoriz          EQU $8042ed76 ;** i.. BOOL              **
MUIA_FrameTitle                 EQU $8042d1c7 ;** i.. STRPTR            **
MUIA_Height                     EQU $80423237 ;** ..g LONG              **
MUIA_HorizWeight                EQU $80426db9 ;** i.. LONG              **
MUIA_InnerBottom                EQU $8042f2c0 ;** i.. LONG              **
MUIA_InnerLeft                  EQU $804228f8 ;** i.. LONG              **
MUIA_InnerRight                 EQU $804297ff ;** i.. LONG              **
MUIA_InnerTop                   EQU $80421eb6 ;** i.. LONG              **
MUIA_InputMode                  EQU $8042fb04 ;** i.. LONG              **
MUIA_LeftEdge                   EQU $8042bec6 ;** ..g LONG              **
MUIA_Pressed                    EQU $80423535 ;** ..g BOOL              **
MUIA_RightEdge                  EQU $8042ba82 ;** ..g LONG              **
MUIA_Selected                   EQU $8042654b ;** isg BOOL              **
MUIA_ShowMe                     EQU $80429ba8 ;** isg BOOL              **
MUIA_ShowSelState               EQU $8042caac ;** i.. BOOL              **
MUIA_Timer                      EQU $80426435 ;** ..g LONG              **
MUIA_TopEdge                    EQU $8042509b ;** ..g LONG              **
MUIA_VertWeight                 EQU $804298d0 ;** i.. LONG              **
MUIA_Weight                     EQU $80421d1f ;** i.. LONG              **
MUIA_Width                      EQU $8042b59c ;** ..g LONG              **
MUIA_Window                     EQU $80421591 ;** ..g struct Window *   **
MUIA_WindowObject               EQU $8042669e ;** ..g Object *          **

MUIV_FontInherit                EQU 0
MUIV_FontNormal                 EQU -1
MUIV_FontList                   EQU -2
MUIV_FontTiny                   EQU -3
MUIV_FontFixed                  EQU -4
MUIV_FontTitle                  EQU -5
MUIV_FrameNone                  EQU 0
MUIV_FrameButton                EQU 1
MUIV_FrameImageButton           EQU 2
MUIV_FrameText                  EQU 3
MUIV_FrameString                EQU 4
MUIV_FrameReadList              EQU 5
MUIV_FrameInputList             EQU 6
MUIV_FrameProp                  EQU 7
MUIV_FrameGauge                 EQU 8
MUIV_FrameGroup                 EQU 9
MUIV_FramePopUp                 EQU 10
MUIV_FrameVirtual               EQU 11
MUIV_FrameSlider                EQU 12
MUIV_FrameCount                 EQU 13
MUIV_InputModeNone              EQU 0
MUIV_InputModeRelVerify         EQU 1
MUIV_InputModeImmediate         EQU 2
MUIV_InputModeToggle            EQU 3


;****************************************************************************
;** Rectangle.mui 7.14 (28.11.93)                                          **
;****************************************************************************

;** Attributes **

MUIA_Rectangle_HBar             EQU $8042c943 ;** i.g BOOL              **
MUIA_Rectangle_VBar             EQU $80422204 ;** i.g BOOL              **



;****************************************************************************
;** Image.mui 7.13 (28.11.93)                                              **
;****************************************************************************

;** Attributes **

MUIA_Image_FontMatch            EQU $8042815d ;** i.. BOOL              **
MUIA_Image_FontMatchHeight      EQU $80429f26 ;** i.. BOOL              **
MUIA_Image_FontMatchWidth       EQU $804239bf ;** i.. BOOL              **
MUIA_Image_FreeHoriz            EQU $8042da84 ;** i.. BOOL              **
MUIA_Image_FreeVert             EQU $8042ea28 ;** i.. BOOL              **
MUIA_Image_OldImage             EQU $80424f3d ;** i.. struct Image *    **
MUIA_Image_Spec                 EQU $804233d5 ;** i.. char *            **
MUIA_Image_State                EQU $8042a3ad ;** is. LONG              **



;****************************************************************************
;** Text.mui 7.15 (28.11.93)                                               **
;****************************************************************************

;** Attributes **

MUIA_Text_Contents              EQU $8042f8dc ;** isg STRPTR            **
MUIA_Text_HiChar                EQU $804218ff ;** i.. char              **
MUIA_Text_PreParse              EQU $8042566d ;** isg STRPTR            **
MUIA_Text_SetMax                EQU $80424d0a ;** i.. BOOL              **
MUIA_Text_SetMin                EQU $80424e10 ;** i.. BOOL              **



;****************************************************************************
;** String.mui 7.13 (28.11.93)                                             **
;****************************************************************************

;** Attributes **

MUIA_String_Accept              EQU $8042e3e1 ;** isg STRPTR            **
MUIA_String_Acknowledge         EQU $8042026c ;** ..g STRPTR            **
MUIA_String_AttachedList        EQU $80420fd2 ;** i.. Object *          **
MUIA_String_BufferPos           EQU $80428b6c ;** .sg LONG              **
MUIA_String_Contents            EQU $80428ffd ;** isg STRPTR            **
MUIA_String_DisplayPos          EQU $8042ccbf ;** .sg LONG              **
MUIA_String_EditHook            EQU $80424c33 ;** isg struct Hook *     **
MUIA_String_Format              EQU $80427484 ;** i.g LONG              **
MUIA_String_Integer             EQU $80426e8a ;** isg ULONG             **
MUIA_String_MaxLen              EQU $80424984 ;** i.. LONG              **
MUIA_String_Reject              EQU $8042179c ;** isg STRPTR            **
MUIA_String_Secret              EQU $80428769 ;** i.g BOOL              **

MUIV_String_FormatLeft          EQU 0
MUIV_String_FormatCenter        EQU 1
MUIV_String_FormatRight         EQU 2


;****************************************************************************
;** Prop.mui 7.12 (28.11.93)                                               **
;****************************************************************************

;** Attributes **

MUIA_Prop_Entries               EQU $8042fbdb ;** isg LONG              **
MUIA_Prop_First                 EQU $8042d4b2 ;** isg LONG              **
MUIA_Prop_Horiz                 EQU $8042f4f3 ;** i.g BOOL              **
MUIA_Prop_Slider                EQU $80429c3a ;** isg BOOL              **
MUIA_Prop_Visible               EQU $8042fea6 ;** isg LONG              **



;****************************************************************************
;** Gauge.mui 7.42 (10.02.94)                                              **
;****************************************************************************

;** Attributes **

MUIA_Gauge_Current              EQU $8042f0dd ;** isg LONG              **
MUIA_Gauge_Divide               EQU $8042d8df ;** isg BOOL              **
MUIA_Gauge_Horiz                EQU $804232dd ;** i.. BOOL              **
MUIA_Gauge_InfoText             EQU $8042bf15 ;** isg char *            **
MUIA_Gauge_Max                  EQU $8042bcdb ;** isg LONG              **



;****************************************************************************
;** Scale.mui 7.38 (10.02.94)                                              **
;****************************************************************************

;** Attributes **

MUIA_Scale_Horiz                EQU $8042919a ;** isg BOOL              **



;****************************************************************************
;** Boopsi.mui 7.37 (10.02.94)                                             **
;****************************************************************************

;** Attributes **

MUIA_Boopsi_Class               EQU $80426999 ;** isg struct IClass *   **
MUIA_Boopsi_ClassID             EQU $8042bfa3 ;** isg char *            **
MUIA_Boopsi_MaxHeight           EQU $8042757f ;** isg ULONG             **
MUIA_Boopsi_MaxWidth            EQU $8042bcb1 ;** isg ULONG             **
MUIA_Boopsi_MinHeight           EQU $80422c93 ;** isg ULONG             **
MUIA_Boopsi_MinWidth            EQU $80428fb2 ;** isg ULONG             **
MUIA_Boopsi_Object              EQU $80420178 ;** ..g Object *          **
MUIA_Boopsi_Remember            EQU $8042f4bd ;** i.. ULONG             **
MUIA_Boopsi_TagDrawInfo         EQU $8042bae7 ;** isg ULONG             **
MUIA_Boopsi_TagScreen           EQU $8042bc71 ;** isg ULONG             **
MUIA_Boopsi_TagWindow           EQU $8042e11d ;** isg ULONG             **



;****************************************************************************
;** Colorfield.mui 7.39 (10.02.94)                                         **
;****************************************************************************

;** Attributes **

MUIA_Colorfield_Blue            EQU $8042d3b0 ;** isg ULONG             **
MUIA_Colorfield_Green           EQU $80424466 ;** isg ULONG             **
MUIA_Colorfield_Pen             EQU $8042713a ;** ..g ULONG             **
MUIA_Colorfield_Red             EQU $804279f6 ;** isg ULONG             **
MUIA_Colorfield_RGB             EQU $8042677a ;** isg ULONG *           **



;****************************************************************************
;** List.mui 7.22 (28.11.93)                                               **
;****************************************************************************

;** Methods **

MUIM_List_Clear                EQU $8042ad89
MUIM_List_Exchange             EQU $8042468c
MUIM_List_GetEntry             EQU $804280ec
MUIM_List_Insert               EQU $80426c87
MUIM_List_InsertSingle         EQU $804254d5
MUIM_List_Jump                 EQU $8042baab
MUIM_List_NextSelected         EQU $80425f17
MUIM_List_Redraw               EQU $80427993
MUIM_List_Remove               EQU $8042647e
MUIM_List_Select               EQU $804252d8
MUIM_List_Sort                 EQU $80422275

;** Attributes **

MUIA_List_Active                EQU $8042391c ;** isg LONG              **
MUIA_List_AdjustHeight          EQU $8042850d ;** i.. BOOL              **
MUIA_List_AdjustWidth           EQU $8042354a ;** i.. BOOL              **
MUIA_List_CompareHook           EQU $80425c14 ;** is. struct Hook *     **
MUIA_List_ConstructHook         EQU $8042894f ;** is. struct Hook *     **
MUIA_List_DestructHook          EQU $804297ce ;** is. struct Hook *     **
MUIA_List_DisplayHook           EQU $8042b4d5 ;** is. struct Hook *     **
MUIA_List_Entries               EQU $80421654 ;** ..g LONG              **
MUIA_List_First                 EQU $804238d4 ;** ..g LONG              **
MUIA_List_Format                EQU $80423c0a ;** isg STRPTR            **
MUIA_List_MultiTestHook         EQU $8042c2c6 ;** is. struct Hook *     **
MUIA_List_Quiet                 EQU $8042d8c7 ;** .s. BOOL              **
MUIA_List_SourceArray           EQU $8042c0a0 ;** i.. APTR              **
MUIA_List_Title                 EQU $80423e66 ;** isg char *            **
MUIA_List_Visible               EQU $8042191f ;** ..g LONG              **

MUIV_List_ActiveOff             EQU -1
MUIV_List_ActiveTop             EQU -2
MUIV_List_ActiveBottom          EQU -3
MUIV_List_ActiveUp              EQU -4
MUIV_List_ActiveDown            EQU -5
MUIV_List_ActivePageUp          EQU -6
MUIV_List_ActivePageDown        EQU -7
MUIV_List_ConstructHookString   EQU -1
MUIV_List_DestructHookString    EQU -1


;****************************************************************************
;** Floattext.mui 7.40 (10.02.94)                                          **
;****************************************************************************

;** Attributes **

MUIA_Floattext_Justify          EQU $8042dc03 ;** isg BOOL              **
MUIA_Floattext_SkipChars        EQU $80425c7d ;** is. STRPTR            **
MUIA_Floattext_TabSize          EQU $80427d17 ;** is. LONG              **
MUIA_Floattext_Text             EQU $8042d16a ;** isg STRPTR            **



;****************************************************************************
;** Volumelist.mui 7.37 (10.02.94)                                         **
;****************************************************************************


;****************************************************************************
;** Scrmodelist.mui 7.45 (10.02.94)                                        **
;****************************************************************************

;** Attributes **




;****************************************************************************
;** Dirlist.mui 7.38 (10.02.94)                                            **
;****************************************************************************

;** Methods **

MUIM_Dirlist_ReRead            EQU $80422d71

;** Attributes **

MUIA_Dirlist_AcceptPattern      EQU $8042760a ;** is. STRPTR            **
MUIA_Dirlist_Directory          EQU $8042ea41 ;** is. STRPTR            **
MUIA_Dirlist_DrawersOnly        EQU $8042b379 ;** is. BOOL              **
MUIA_Dirlist_FilesOnly          EQU $8042896a ;** is. BOOL              **
MUIA_Dirlist_FilterDrawers      EQU $80424ad2 ;** is. BOOL              **
MUIA_Dirlist_FilterHook         EQU $8042ae19 ;** is. struct Hook *     **
MUIA_Dirlist_MultiSelDirs       EQU $80428653 ;** is. BOOL              **
MUIA_Dirlist_NumBytes           EQU $80429e26 ;** ..g LONG              **
MUIA_Dirlist_NumDrawers         EQU $80429cb8 ;** ..g LONG              **
MUIA_Dirlist_NumFiles           EQU $8042a6f0 ;** ..g LONG              **
MUIA_Dirlist_Path               EQU $80426176 ;** ..g STRPTR            **
MUIA_Dirlist_RejectIcons        EQU $80424808 ;** is. BOOL              **
MUIA_Dirlist_RejectPattern      EQU $804259c7 ;** is. STRPTR            **
MUIA_Dirlist_SortDirs           EQU $8042bbb9 ;** is. LONG              **
MUIA_Dirlist_SortHighLow        EQU $80421896 ;** is. BOOL              **
MUIA_Dirlist_SortType           EQU $804228bc ;** is. LONG              **
MUIA_Dirlist_Status             EQU $804240de ;** ..g LONG              **

MUIV_Dirlist_SortDirsFirst      EQU 0
MUIV_Dirlist_SortDirsLast       EQU 1
MUIV_Dirlist_SortDirsMix        EQU 2
MUIV_Dirlist_SortTypeName       EQU 0
MUIV_Dirlist_SortTypeDate       EQU 1
MUIV_Dirlist_SortTypeSize       EQU 2
MUIV_Dirlist_StatusInvalid      EQU 0
MUIV_Dirlist_StatusReading      EQU 1
MUIV_Dirlist_StatusValid        EQU 2


;****************************************************************************
;** Group.mui 7.12 (28.11.93)                                              **
;****************************************************************************

;** Methods **


;** Attributes **

MUIA_Group_ActivePage           EQU $80424199 ;** isg LONG              **
MUIA_Group_Child                EQU $804226e6 ;** i.. Object *          **
MUIA_Group_Columns              EQU $8042f416 ;** is. LONG              **
MUIA_Group_Horiz                EQU $8042536b ;** i.. BOOL              **
MUIA_Group_HorizSpacing         EQU $8042c651 ;** is. LONG              **
MUIA_Group_PageMode             EQU $80421a5f ;** is. BOOL              **
MUIA_Group_Rows                 EQU $8042b68f ;** is. LONG              **
MUIA_Group_SameHeight           EQU $8042037e ;** i.. BOOL              **
MUIA_Group_SameSize             EQU $80420860 ;** i.. BOOL              **
MUIA_Group_SameWidth            EQU $8042b3ec ;** i.. BOOL              **
MUIA_Group_Spacing              EQU $8042866d ;** is. LONG              **
MUIA_Group_VertSpacing          EQU $8042e1bf ;** is. LONG              **



;****************************************************************************
;** Group.mui 7.12 (28.11.93)                                              **
;****************************************************************************

;** Attributes **

MUIA_Register_Frame             EQU $8042349b ;** i.g BOOL              **
MUIA_Register_Titles            EQU $804297ec ;** i.g STRPTR *          **



;****************************************************************************
;** Virtgroup.mui 7.37 (10.02.94)                                          **
;****************************************************************************

;** Methods **


;** Attributes **

MUIA_Virtgroup_Height           EQU $80423038 ;** ..g LONG              **
MUIA_Virtgroup_Left             EQU $80429371 ;** isg LONG              **
MUIA_Virtgroup_Top              EQU $80425200 ;** isg LONG              **
MUIA_Virtgroup_Width            EQU $80427c49 ;** ..g LONG              **



;****************************************************************************
;** Scrollgroup.mui 7.35 (10.02.94)                                        **
;****************************************************************************

;** Attributes **

MUIA_Scrollgroup_Contents       EQU $80421261 ;** i.. Object *          **



;****************************************************************************
;** Scrollbar.mui 7.12 (28.11.93)                                          **
;****************************************************************************


;****************************************************************************
;** Listview.mui 7.13 (28.11.93)                                           **
;****************************************************************************

;** Attributes **

MUIA_Listview_ClickColumn       EQU $8042d1b3 ;** ..g LONG              **
MUIA_Listview_DefClickColumn    EQU $8042b296 ;** isg LONG              **
MUIA_Listview_DoubleClick       EQU $80424635 ;** i.g BOOL              **
MUIA_Listview_Input             EQU $8042682d ;** i.. BOOL              **
MUIA_Listview_List              EQU $8042bcce ;** i.. Object *          **
MUIA_Listview_MultiSelect       EQU $80427e08 ;** i.. LONG              **
MUIA_Listview_SelectChange      EQU $8042178f ;** ..g BOOL              **

MUIV_Listview_MultiSelectNone   EQU 0
MUIV_Listview_MultiSelectDefaul EQU 1
MUIV_Listview_MultiSelectShifte EQU 2
MUIV_Listview_MultiSelectAlways EQU 3


;****************************************************************************
;** Radio.mui 7.12 (28.11.93)                                              **
;****************************************************************************

;** Attributes **

MUIA_Radio_Active               EQU $80429b41 ;** isg LONG              **
MUIA_Radio_Entries              EQU $8042b6a1 ;** i.. STRPTR *          **



;****************************************************************************
;** Cycle.mui 7.16 (28.11.93)                                              **
;****************************************************************************

;** Attributes **

MUIA_Cycle_Active               EQU $80421788 ;** isg LONG              **
MUIA_Cycle_Entries              EQU $80420629 ;** i.. STRPTR *          **

MUIV_Cycle_ActiveNext           EQU -1
MUIV_Cycle_ActivePrev           EQU -2


;****************************************************************************
;** Slider.mui 7.12 (28.11.93)                                             **
;****************************************************************************

;** Attributes **

MUIA_Slider_Level               EQU $8042ae3a ;** isg LONG              **
MUIA_Slider_Max                 EQU $8042d78a ;** i.. LONG              **
MUIA_Slider_Min                 EQU $8042e404 ;** i.. LONG              **
MUIA_Slider_Quiet               EQU $80420b26 ;** i.. BOOL              **
MUIA_Slider_Reverse             EQU $8042f2a0 ;** isg BOOL              **



;****************************************************************************
;** Coloradjust.mui 7.47 (10.02.94)                                        **
;****************************************************************************

;** Attributes **

MUIA_Coloradjust_Blue           EQU $8042b8a3 ;** isg ULONG             **
MUIA_Coloradjust_Green          EQU $804285ab ;** isg ULONG             **
MUIA_Coloradjust_ModeID         EQU $8042ec59 ;** isg ULONG             **
MUIA_Coloradjust_Red            EQU $80420eaa ;** isg ULONG             **
MUIA_Coloradjust_RGB            EQU $8042f899 ;** isg ULONG *           **



;****************************************************************************
;** Palette.mui 7.36 (10.02.94)                                            **
;****************************************************************************

;** Attributes **

MUIA_Palette_Entries            EQU $8042a3d8 ;** i.g struct MUI_Palette_Entry * **
MUIA_Palette_Groupable          EQU $80423e67 ;** isg BOOL              **
MUIA_Palette_Names              EQU $8042c3a2 ;** isg char **           **



;****************************************************************************
;** Colorpanel.mui 7.12 (10.02.94)                                         **
;****************************************************************************

;** Methods **


;** Attributes **




;****************************************************************************
;** Popstring.mui 7.19 (02.12.93)                                          **
;****************************************************************************

;** Methods **

MUIM_Popstring_Close           EQU $8042dc52
MUIM_Popstring_Open            EQU $804258ba

;** Attributes **

MUIA_Popstring_Button           EQU $8042d0b9 ;** i.g Object *          **
MUIA_Popstring_CloseHook        EQU $804256bf ;** isg struct Hook *     **
MUIA_Popstring_OpenHook         EQU $80429d00 ;** isg struct Hook *     **
MUIA_Popstring_String           EQU $804239ea ;** i.g Object *          **
MUIA_Popstring_Toggle           EQU $80422b7a ;** isg BOOL              **



;****************************************************************************
;** Popobject.mui 7.18 (02.12.93)                                          **
;****************************************************************************

;** Attributes **

MUIA_Popobject_Follow           EQU $80424cb5 ;** isg BOOL              **
MUIA_Popobject_Light            EQU $8042a5a3 ;** isg BOOL              **
MUIA_Popobject_Object           EQU $804293e3 ;** i.g Object *          **
MUIA_Popobject_ObjStrHook       EQU $8042db44 ;** isg struct Hook *     **
MUIA_Popobject_StrObjHook       EQU $8042fbe1 ;** isg struct Hook *     **
MUIA_Popobject_Volatile         EQU $804252ec ;** isg BOOL              **



;****************************************************************************
;** Popasl.mui 7.5 (03.12.93)                                              **
;****************************************************************************

;** Attributes **

MUIA_Popasl_Active              EQU $80421b37 ;** ..g BOOL              **
MUIA_Popasl_StartHook           EQU $8042b703 ;** isg struct Hook *     **
MUIA_Popasl_StopHook            EQU $8042d8d2 ;** isg struct Hook *     **
MUIA_Popasl_Type                EQU $8042df3d ;** i.g ULONG             **


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
*** NOTE: This .i file contains the corresponding macros for
*** assembler programmers.  All assembler related comments are
*** marked with three *'s.  The original comments and examples for
*** C are still intact.
**
****************************************************************************

   IFND MUI_NOSHORTCUTS



****************************************************************************
**
** Object Generation
** -----------------
**
** The xxxObject (and xChilds) macros generate new instances of MUI classes.
** Every xxxObject can be followed by tagitems specifying initial create
** time attributes for the new object and must be terminated with the
** End macro:
**
** obj = StringObject,
**          MUIA_String_Contents, "foo",
**          MUIA_String_MaxLen  , 40,
**          End;
**
** With the Child, SubWindow and WindowContents shortcuts you can
** construct a complete GUI within one command:
**
** app = ApplicationObject,
**
**          ...
**
**          SubWindow, WindowObject,
**             WindowContents, VGroup,
**                Child, String("foo",40),
**                Child, String("bar",50),
**                Child, HGroup,
**                   Child, CheckMark(TRUE),
**                   Child, CheckMark(FALSE),
**                   End,
**                End,
**             End,
**
**          SubWindow, WindowObject,
**             WindowContents, HGroup,
**                Child, ...,
**                Child, ...,
**                End,
**             End,
**
**          ...
**
**          End;
**
****************************************************************************


****************************************************************************
***
*** These assembler macros behave somewhat in the same way as the C macros
*** but with some minor differences:
*** The macro names End, and SET are already in use in most assembler
*** compilers, so they are replaced with Endi and seti (for consistencys
*** sake get is also renamed to geti).
***
*** You must provide memory for all the taglists needed in the object
*** creation.  The maximum memory needed is passed to you in the 
*** TAG_SPACE variable.  This is not the mimimum memory needed in most
*** cases and is often a few kilos too large, but this is the best I
*** could come up with the assembler macro commands.
*** Note that you must store the value of TAG_SPACE only after all
*** the objects are created.  TAG_SPACE is incremented as object
*** creation macros are called and in the end holds the maximum
*** theoretical tagitem space usage in bytes.  You pass the pointer to
*** this memory (which you have yourself allocated) in the register MR.
*** You can EQUR MR to any of the registers a3, a4 or a5 (the macros
*** don't use these registers).
***
*** All calls to xxxObject and xxxGroup _must_ be finished with an Endi
*** call.  The Endi macro actually calls the MUI_NewObjectA function
*** and places the result object to the taglist.
***
*** The MUIT macro is just a handy way of moving mixed stuff to the
*** taglist.  Upto 9 items can be moved to the stack on one source line.
*** You can move _only constants_ with the MUIT macro, use the
*** MUIT2 macro to move more mixed stuff (pointers, registers).
*** Remember to use # to denote constants when using MUIT2.
*** The Endi macro is a special case for the MUIT and MUIT2 macros.
*** This is snooped out and every 'MUIT Endi' call is converted to
*** an Endi macro call.
***
*** Also the very common calls 'MUIT Child', 'MUIT SubWindow' and
*** 'MUIT WindowContents' have their own macros Childi, SubWindowi
*** and WindowContentsi.  Childi macro can take upto five arguments.
*** There are three versions of Childi: Childi, Child2 and Child3.
*** Templates for these macros are:
*** Childi [macro[,argument1[,argument2[,argument3[,argument4]]]]]
*** Child2 [macro[,macro[,macro[,macro[,macro]]]]]
*** Child3 [macro[,macro[,argument1[,argument2[,argument3]]]]]
*** Arguments for Childi are interpreted as the first one being a
*** full macro name and the last four arguments for this macro.
*** Arguments for Child2 are treated as macros placed on their
*** own separate lines.  These macros can't have any arguments.
*** Arguments for Child3 are treated as two macros placed on their
*** own separate lines.  The last macro can have three arguments.
***
*** The C example above with these assembler macros:
***
***   ApplicationObject
***   
***      ...
***
***      SubWindowi
***      WindowObject
***         WindowContentsi
***         VGroup
***            Childi String,foo,40
***            Childi String,bar,50
***            Childi HGroup
***               Childi Checkmark,TRUE
***               Childi Checkmark,FALSE
***               Endi
***            Endi
***         Endi
***
***      SubWindowi
***      WindowObject
***         WindowContentsi
***         HGroup
***            Childi
***            ...
***            Childi
***            ...
***            Endi
***         Endi
***
***      ...
***         
***      Endi
***      is app
***
***   app   dc.l  0
***   bar   dc.b  "bar",0
***   foo   dc.b  "foo",0
***
****************************************************************************

*** TAG_SPACE will hold the max taglist size in bytes

TAG_SPACE SET 0

*** Macros to move a tagitem to the taglist if it is given

cmv   MACRO ; Tag
   IFNC  '\1',''
   IFC   '\1','Endi'
      Endi
   ELSEIF
      move.l   #\1,(MR)+
TAG_SPACE SET TAG_SPACE+4
   ENDC
   ENDC
      ENDM

cmv2  MACRO ; Tag
   IFNC  '\1',''
   IFC   '\1','Endi'
      Endi
   ELSEIF
      move.l   \1,(MR)+
TAG_SPACE SET TAG_SPACE+4
   ENDC
   ENDC
      ENDM

*** Macro to move a tagitem to stack if it is given

cmv3  MACRO ; Tag
   IFNC  '\1',''
      move.l   \1,-(sp)
   ENDC
      ENDM

*** Macros to move max 9 tagitems to the taglist

MUIT  MACRO ; Tag1, [...]
      cmv   \1
      cmv   \2
      cmv   \3
      cmv   \4
      cmv   \5
      cmv   \6
      cmv   \7
      cmv   \8
      cmv   \9
      ENDM

MUIT2 MACRO ; Tag1, [...]
      cmv2  \1
      cmv2  \2
      cmv2  \3
      cmv2  \4
      cmv2  \5
      cmv2  \6
      cmv2  \7
      cmv2  \8
      cmv2  \9
      ENDM

*** DoMethod macro for easier assembler DoMethod'ing, max 20 tagitems.
*** Note that _DoMethod is defined in amiga.lib, so you must link
*** your own object code with it.

DoMethod    MACRO ; obj, MethodID, tag1, [...]
            movem.l  a0/a2,-(sp)
            move.l   sp,a2
            clr.l    -(sp)
            cmv3     \L
            cmv3     \K
            cmv3     \J
            cmv3     \I
            cmv3     \H
            cmv3     \G
            cmv3     \F
            cmv3     \E
            cmv3     \D
            cmv3     \C
            cmv3     \B
            cmv3     \A
            cmv3     \9
            cmv3     \8
            cmv3     \7
            cmv3     \6
            cmv3     \5
            cmv3     \4
            cmv3     \3
            cmv3     \2
            cmv3     \1
            jsr      _DoMethod
            move.l   a2,sp
            movem.l  (sp)+,a0/a2
            ENDM

*** MUI_Request macro for easier assembler MUI_Request'ing, max
*** 20 tagitems.

MUI_Request MACRO    ; app,win,flags,title,gadgets,format,[params,...]
            movem.l  a0-a4,-(sp)
            move.l   sp,a4
            cmv3     \L
            cmv3     \K
            cmv3     \J
            cmv3     \I
            cmv3     \H
            cmv3     \G
            cmv3     \F
            cmv3     \E
            cmv3     \D
            cmv3     \C
            cmv3     \B
            cmv3     \A
            cmv3     \9
            cmv3     \8
            cmv3     \7
            move.l   a4,a3
            move.l   #\6,a2
            move.l   #\5,a1
            move.l   #\4,a0
            move.l   #\3,d2
            move.l   \2,d1
            move.l   \1,d0
            CALLMUI  MUI_RequestA
            move.l   a4,sp
            movem.l  (sp)+,a0-a4
            ENDM

*** Macro for getting a pointer to an object you just created.
*** This is valid only after an Endi macro.

is          MACRO    ; pointer
            move.l   d0,\1
            ENDM

WindowObject         MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Window,a0
                     move.l   a4,a2
                     ENDM
Endi                 MACRO
                     clr.l    (MR)+
                     move.l   a2,a1
                     CALLMUI  MUI_NewObjectA
                     move.l   a2,a4
                     movem.l  (sp)+,a0/a2
                     cmv2     d0
                     ENDM
ImageObject          MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Image,a0
                     move.l   a4,a2
                     ENDM
NotifyWindowObject   MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Notify,a0
                     move.l   a4,a2
                     ENDM
ApplicationObject    MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Application,a0
                     move.l   a4,a2
                     ENDM
TextObject           MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Text,a0
                     move.l   a4,a2
                     ENDM
RectangleObject      MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Rectangle,a0
                     move.l   a4,a2
                     ENDM
ListObject           MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_List,a0
                     move.l   a4,a2
                     ENDM
PropObject           MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Prop,a0
                     move.l   a4,a2
                     ENDM
StringObject         MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_String,a0
                     move.l   a4,a2
                     ENDM
ScrollbarObject      MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Scrollbar,a0
                     move.l   a4,a2
                     ENDM
ListviewObject       MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Listview,a0
                     move.l   a4,a2
                     ENDM
RadioObject          MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Radio,a0
                     move.l   a4,a2
                     ENDM
VolumelistObject     MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Volumelist,a0
                     move.l   a4,a2
                     ENDM
FloattextObject      MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Floattext,a0
                     move.l   a4,a2
                     ENDM
DirlistObject        MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Dirlist,a0
                     move.l   a4,a2
                     ENDM
ApplistObject        MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Applist,a0
                     move.l   a4,a2
                     ENDM
DatatypeObject       MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Datatype,a0
                     move.l   a4,a2
                     ENDM
SliderObject         MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Slider,a0
                     move.l   a4,a2
                     ENDM
CycleObject          MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Cycle,a0
                     move.l   a4,a2
                     ENDM
GaugeObject          MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Gauge,a0
                     move.l   a4,a2
                     ENDM
ScaleObject          MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Scale,a0
                     move.l   a4,a2
                     ENDM
BoopsiObject         MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Boopsi,a0
                     move.l   a4,a2
                     ENDM
GroupObject          MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Group,a0
                     move.l   a4,a2
                     ENDM
VGroup               MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Group,a0
                     move.l   a4,a2
                     ENDM
HGroup               MACRO
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Group,a0
                     move.l   a4,a2
                     MUIT     MUIA_Group_Horiz,TRUE
                     ENDM
ColGroup             MACRO ; cols
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Group,a0
                     move.l   a4,a2
                     MUIT     MUIA_Group_Columns,\1
                     ENDM
RowGroup             MACRO ; rows
                     movem.l  a0/a2,-(sp)
                     move.l   MUIC_Group,a0
                     move.l   a4,a2
                     MUIT     MUIA_Group_Rows,\1
                     ENDM

Childi               MACRO ; [macro[,argument1[,argument2[,argument3[,argument4]]]]]
                     cmv   MUIA_Group_Child
                     \1 \2,\3,\4,\5
                     ENDM
Child2               MACRO ; [macro[,macro[,macro[,macro[,macro]]]]]
                     cmv   MUIA_Group_Child
                     \1
                     \2
                     \3
                     \4
                     \5
                     ENDM
Child3               MACRO ; [macro[,macro[,argument1[,argument2[,argument3]]]]]
                     cmv   MUIA_Group_Child
                     \1
                     \2 \3,\4,\5
                     ENDM
SubWindowi           MACRO
                     cmv   MUIA_Application_Window
                     ENDM
WindowContentsi      MACRO
                     cmv   MUIA_Window_RootObject
                     ENDM


Child          EQU   MUIA_Group_Child
SubWindow      EQU   MUIA_Application_Window
WindowContents EQU   MUIA_Window_RootObject



****************************************************************************
**
** Frame Types
** -----------
**
** These macros may be used to specify one of MUI's different frame types.
** Note that every macro consists of one or more { ti_Tag, ti_Data }
** pairs.
**
** GroupFrameT() is a special kind of frame that contains a centered
** title text.
**
** HGroup, GroupFrameT("Horiz Groups"),
**    Child, RectangleObject, TextFrame  , End,
**    Child, RectangleObject, StringFrame, End,
**    Child, RectangleObject, ButtonFrame, End,
**    Child, RectangleObject, ListFrame  , End,
**    End,
**
****************************************************************************

****************************************************************************
***
*** Assembler version of the above C example:
***
*** HGroup
***    GroupFrameT horizg
***    Child2 RectangleObject,TextFrame,Endi
***    Child2 RectangleObject,StringFrame,Endi
***    Child2 RectangleObject,ButtonFrame,Endi
***    Child2 RectangleObject,ListFrame,Endi
***    Endi
***
*** horizg  dc.b  "Horiz Groups",0
***         even
***
****************************************************************************

*** These macros call MUIT themselves, do not use eg. 'MUIT NoFrame'

NoFrame     MACRO
            MUIT  MUIA_Frame,MUIV_FrameNone
            ENDM
ButtonFrame MACRO
            MUIT  MUIA_Frame,MUIV_FrameButton
            ENDM
ImageButtonFrame  MACRO
            MUIT  MUIA_Frame,MUIV_FrameImageButton
            ENDM
TextFrame   MACRO
            MUIT  MUIA_Frame,MUIV_FrameText
            ENDM
StringFrame MACRO
            MUIT  MUIA_Frame,MUIV_FrameString
            ENDM
ReadListFrame  MACRO
            MUIT  MUIA_Frame,MUIV_FrameReadList
            ENDM
InputListFrame MACRO
            MUIT  MUIA_Frame,MUIV_FrameInputList
            ENDM
PropFrame   MACRO
            MUIT  MUIA_Frame,MUIV_FrameProp
            ENDM
GaugeFrame  MACRO
            MUIT  MUIA_Frame,MUIV_FrameGauge
            ENDM
GroupFrame  MACRO
            MUIT  MUIA_Frame,MUIV_FrameGroup
            ENDM
GroupFrameT MACRO ; s
            MUIT  MUIA_Frame,MUIV_FrameGroup,MUIA_FrameTitle,\1
            ENDM



****************************************************************************
**
** Spacing Macros
** --------------
**
****************************************************************************

*** For these macros tagitem space is allocated from the stack and is
*** fixed in size.  So, there is no need for a separate Endi call.

HVSpace     MACRO
            move.l   a0,-(sp)
            move.l   MUIC_Rectangle,a0
            clr.l    -(sp)
            move.l   sp,a1
            CALLMUI  MUI_NewObjectA
            addq.l   #4,sp
            move.l   (sp)+,a0
            MUIT2    d0
            ENDM
   
HSpace      MACRO ; x
            move.l   a0,-(sp)
            move.l   MUIC_Rectangle,a0
            clr.l    -(sp)
            clr.l    -(sp)
            pea      MUIA_VertWeight
            move.l   #\1,-(sp)
         IFND  \1
            pea      MUIA_FixWidth
         ELSEIF
            pea      1.w
         ENDC
            move.l   sp,a1
            CALLMUI  MUI_NewObjectA
            lea      20(sp),sp
            move.l   (sp)+,a0
            MUIT2    d0
            ENDM

VSpace      MACRO ; x
            move.l   a0,-(sp)
            move.l   MUIC_Rectangle,a0
            clr.l    -(sp)
            clr.l    -(sp)
            pea      MUIA_HorizWeight
            move.l   #\1,-(sp)
         IFND  \1
            pea      MUIA_FixHeight
         ELSEIF
            pea      1.w
         ENDC
            move.l   sp,a1
            CALLMUI  MUI_NewObjectA
            lea      20(sp),sp
            move.l   (sp)+,a0
            MUIT2    d0
            ENDM

HCenter     MACRO ; obj
            HGroup
               GroupSpacing 0
               Childi HSpace,0
               Childi MUIT2,\1
               Childi HSpace,0
               Endi
            ENDM

VCenter     MACRO ; obj
            VGroup
               GroupSpacing 0
               Childi VSpace,0
               Childi MUIT2,\1
               Childi VSpace,0
               Endi
            ENDM

InnerSpacing   MACRO ; h,v
               MUIT MUIA_InnerLeft,\1,MUIA_InnerRight,\1,MUIA_InnerTop,\2,MUIA_InnerBottom,\2
               ENDM

GroupSpacing   MACRO ; x
               MUIT  MUIA_Group_Spacing,\1
               ENDM



****************************************************************************
***
*** You use these assembler macros like this:
***
*** String mystr1,40
***
*** CheckMark TRUE
***
*** SimpleButton mysbut1
***
*** KeyButton mykbut1,"c"
***
*** Cycle myentr1
***
*** KeyCycle myentr1,"k"
***
*** Radio rname1,rbuts1
***
*** String mystr1,35
*** is strobj1
*** Popup ST_Font,strobj1,MyHook,MUII_Popup
***
***
*** MyHook  rts   ; dummy hook, does nothing
*** mysrt1  dc.b  "String contents",0
***         even
*** mysbut1 dc.b  "Button",0
***         even
*** mykbut1 dc.b  "Cancel",0
***         even
*** myentr1 dc.l  entrs1,entrs2,entrs3,NULL
*** entrs1  dc.b  "One",0
*** entrs2  dc.b  "Two",0
*** entrs3  dc.b  "Three",0
***         even
*** rname1  dc.b  "Radio Buttons:",0
***         even
*** rbuts1  dc.l  rbut1,rbut2,rbut3,NULL
*** rbut1   dc.b  "Button1",0
***         even
*** rbut2   dc.b  "Button2",0
***         even
*** rbut3   dc.b  "Button3",0
***         even
*** strobj  dc.l  0
*** ST_Font dc.l  0
***
***
****************************************************************************

****************************************************************************
**
** String-Object
** -------------
**
** The following macro creates a simple string gadget.
**
****************************************************************************

String MACRO ; contents,maxlen
   StringObject
      StringFrame
      MUIT MUIA_String_MaxLen,\2
      MUIT MUIA_String_Contents,\1
      Endi
   ENDM


****************************************************************************
**
** CheckMark-Object
** ----------------
**
** The following macro creates a checkmark gadget.
**
****************************************************************************

CheckMark MACRO ; selected
   ImageObject
      ImageButtonFrame
      MUIT MUIA_InputMode,MUIV_InputModeToggle
      MUIT MUIA_Image_Spec,MUII_CheckMark
      MUIT MUIA_Image_FreeVert,TRUE
      MUIT MUIA_Selected,\1
      MUIT MUIA_Background,MUII_ButtonBack
      MUIT MUIA_ShowSelState,FALSE
      Endi
   ENDM


****************************************************************************
**
** Button-Objects
** --------------
**
** Note: Use small letters for KeyButtons, e.g.
**       KeyButton("Cancel",'c')  and not  KeyButton("Cancel",'C') !!
**
****************************************************************************

SimpleButton MACRO ; name
   TextObject
      ButtonFrame
      MUIT MUIA_Text_Contents,\1
      MUIT MUIA_Text_PreParse,PreParse
      MUIT MUIA_Text_SetMax,FALSE
      MUIT MUIA_InputMode,MUIV_InputModeRelVerify
      MUIT MUIA_Background,MUII_ButtonBack
      Endi
   ENDM

KeyButton MACRO ; name,key
   TextObject
      ButtonFrame
      MUIT MUIA_Text_Contents,\1
      MUIT MUIA_Text_PreParse,PreParse
      MUIT MUIA_Text_SetMax,FALSE
      MUIT MUIA_Text_HiChar,\2
      MUIT MUIA_ControlChar,\2
      MUIT MUIA_InputMode,MUIV_InputModeRelVerify
      MUIT MUIA_Background,MUII_ButtonBack
      Endi
   ENDM



****************************************************************************
**
** Cycle-Object
** ------------
**
****************************************************************************

Cycle MACRO ; entries
   CycleObject
      MUIT MUIA_Cycle_Entries,\1
      Endi
   ENDM

KeyCycle MACRO ; entries,key
   CycleObject
      MUIT  MUIA_Cycle_Entries,\1,MUIA_ControlChar,\2
      Endi
   ENDM



****************************************************************************
**
** Radio-Object
** ------------
**
****************************************************************************

Radio MACRO ; name,array
   RadioObject
      GroupFrameT \1
      MUIT  MUIA_Radio_Entries,\2
      Endi
   ENDM



****************************************************************************
**
** Popup-Object
** ------------
**
** An often needed GUI element is a string gadget with a little button
** that opens up a (small) window with a list containing possible entries
** for this gadget. Together with the Popup and the String macro,
** such a thing would look like
**
** VGroup,
**    Child, Popup(ST_Font, String("helvetica/13",32), &Hook, MUII_Popup),
**    ...,
**
** ST_Font will hold a pointer to the embedded string gadget and can
** be used to set and get its contents as with every other string object.
**
** The hook will be called with the string gadget as object whenever
** the user releases the popup button and could look like this:
**
** ULONG __asm __saveds HookFunc(register __a2 APTR obj,MUII_File)
** {
**    ...
**
**    // put our application to sleep while displaying the requester
**    set(Application,MUIA_Application_Sleep,TRUE);
**
**    // get the calling objects window and position
**    get(obj,MUIA_Window  ,&window);
**    get(obj,MUIA_LeftEdge,&l);
**    get(obj,MUIA_TopEdge ,&t);
**    get(obj,MUIA_Width   ,&w);
**    get(obj,MUIA_Height  ,&h);
**
**    if (req=MUI_AllocAslRequestTags(ASL_FontRequest,TAG_DONE))
**    {
**       if (MUI_AslRequestTags(req,
**          ASLFO_Window         ,window,
**          ASLFO_PrivateIDCMP   ,TRUE,
**          ASLFO_TitleText      ,"Select Font",
**          ASLFO_InitialLeftEdge,window->LeftEdge + l,
**          ASLFO_InitialTopEdge ,window->TopEdge  + t+h,
**          ASLFO_InitialWidth   ,w,
**          ASLFO_InitialHeight  ,250,
**          TAG_DONE))
**       {
**          // set the new contents for our string gadget
**          set(obj,MUIA_String_Contents,req->fo_Attr.ta_Name);
**       }
**       MUI_FreeAslRequest(req);
**    }
**
**    // wake up our application again
**    set(Application,MUIA_Application_Sleep,FALSE);
**
**    return(0);
** }
**
** Note: This macro needs a "APTR dummy;" declaration somewhere in your
**       code to work.
**
****************************************************************************

Popup MACRO ; ptr,obj,hook,img
   HGroup
      GroupSpacing 1
      MUIT2 #Child,\2
      move.l   \2,\1
      Child2 ImageObject,ImageButtonFrame
         MUIT MUIA_Image_Spec,\4
         MUIT MUIA_Image_FontMatchWidth,TRUE
         MUIT MUIA_Image_FreeVert,TRUE
         MUIT MUIA_InputMode,MUIV_InputModeRelVerify
         MUIT MUIA_Background,MUII_BACKGROUND
         Endi
      move.l   (sp),dummy
      MUIT TAG_IGNORE
      tst.l dummy
      beq.b pop\@
      tst.l \1
      beq.b pop\@
      DoMethod dummy,#MUIM_Notify,#MUIA_Pressed,#FALSE,\1,#2,#MUIM_CallHook,\2
      MUIT2 d0
      bra.b pup\@
pop\@ MUIT  0
pup\@ Endi
   ENDM



****************************************************************************
**
** Labeling Objects
** ----------------
**
** Labeling objects, e.g. a group of string gadgets,
**
**   Small: |foo   |
**  Normal: |bar   |
**     Big: |foobar|
**    Huge: |barfoo|
**
** is done using a 2 column group:
**
** ColGroup(2),
**    Child, Label2("Small:" ),
**    Child, StringObject, End,
**    Child, Label2("Normal:"),
**    Child, StringObject, End,
**    Child, Label2("Big:"   ),
**    Child, StringObject, End,
**    Child, Label2("Huge:"  ),
**    Child, StringObject, End,
**    End,
**
** Note that we have three versions of the label macro, depending on
** the frame type of the right hand object:
**
** Label1(): For use with standard frames (e.g. checkmarks).
** Label2(): For use with double high frames (e.g. string gadgets).
** Label() : For use with objects without a frame.
**
** These macros ensure that your label will look fine even if the
** user of your application configured some strange spacing values.
** If you want to use your own labeling, you'll have to pay attention
** on this topic yourself.
**
****************************************************************************

****************************************************************************
***
*** And the above C example in assembler:
***
*** ColGroup 2
***   Childi Label2,small
***   Child2 StringObject,Endi
***   Childi Label2,normal
***   Child2 StringObject,Endi
***   Childi Label2,big
***   Child2 StringObject,Endi
***   Childi Label2,huge
***   Child2 StringObject,Endi
***   Endi
***
*** small   dc.b  "Small:",0
***         even
*** normal  dc.b  "Normal:",0
***         even
*** big     dc.b  "Big:",0
***         even
*** huge    dc.b  "Huge:",0
***         even
***
****************************************************************************

Label MACRO ; label
   TextObject
      MUIT MUIA_Text_PreParse,PreParse2,MUIA_Text_Contents,\1
      MUIT MUIA_Weight,0,MUIA_InnerLeft,0,MUIA_InnerRight,0
      Endi
   ENDM

Label1 MACRO ; label
   TextObject
      MUIT MUIA_Text_PreParse,PreParse2,MUIA_Text_Contents,\1
      MUIT MUIA_Weight,0,MUIA_InnerLeft,0,MUIA_InnerRight,0
      ButtonFrame
      MUIT MUIA_FramePhantomHoriz,TRUE
      Endi
   ENDM

Label2 MACRO ; label
   TextObject
      MUIT MUIA_Text_PreParse,PreParse2,MUIA_Text_Contents,\1,
      MUIT MUIA_Weight,0,MUIA_InnerLeft,0,MUIA_InnerRight,0
      StringFrame
      MUIT MUIA_FramePhantomHoriz,TRUE
      Endi
   ENDM

KeyLabel MACRO ; label,hichar
   TextObject
      MUIT MUIA_Text_PreParse,PreParse2,MUIA_Text_Contents,\1
      MUIT MUIA_Weight,0,MUIA_InnerLeft,0,MUIA_InnerRight,0,
      MUIT MUIA_Text_HiChar,\2
      Endi
   ENDM

KeyLabel1 MACRO ; label,hichar
   TextObject
      MUIT MUIA_Text_PreParse,PreParse2,MUIA_Text_Contents,\1
      MUIT MUIA_Weight,0,MUIA_InnerLeft,0,MUIA_InnerRight,0
      MUIT MUIA_Text_HiChar,\2
      ButtonFrame
      MUIT MUIA_FramePhantomHoriz,TRUE
      Endi
   ENDM

KeyLabel2 MACRO ; label,hichar
   TextObject
      MUIT MUIA_Text_PreParse,PreParse2,MUIA_Text_Contents,\1
      MUIT MUIA_Weight,0,MUIA_InnerLeft,0,MUIA_InnerRight,0
      MUIT MUIA_Text_HiChar,\2
      StringFrame
      MUIT MUIA_FramePhantomHoriz,TRUE
      Endi
   ENDM



****************************************************************************
**
** Controlling Objects
** -------------------
**
** set() and get() are two short stubs for BOOPSI GetAttr() and SetAttrs()
** calls:
**
** {
**    char *x;
**
**    set(obj,MUIA_String_Contents,"foobar");
**    get(obj,MUIA_String_Contents,&x);
**
**    printf("gadget contains '%s'\n",x);
** }
**
****************************************************************************

****************************************************************************
***
*** And the above C example in assembler:
***
*** seti obj,#MUIA_String_Contents,#foobar
*** geti obj,#MUIA_String_Contents,#x
***   move.l   #myfmt,d1
***   move.l   #data,d2
***   CALLDOS VPrintf
***
*** foobar     dc.b  "foobar",0
***            even
*** data       dc.l  x
*** x          dcb.b 10
*** myfmt      dc.b  "gadget contains '%s'",10,0
***            even
***
*** The names of the set and get macros have been changed to seti and geti
*** since most assemblers already have the pseudo op-code SET.
*** Note that seti is designed to take multiple tagitems (max 8).
***
****************************************************************************

geti  MACRO ; obj,attr,store
      move.l   \2,d0
      move.l   \1,a0
      move.l   \3,a1
      CALLINT GetAttr
      ENDM
seti  MACRO ; obj,attr,value [,attr,value,...]
      move.l   sp,a2
      cmv3     #TAG_DONE
      cmv3     \9
      cmv3     \8
      cmv3     \7
      cmv3     \6
      cmv3     \5
      cmv3     \4
      cmv3     \3
      cmv3     \2
      move.l   \1,a0
      move.l   sp,a1
      CALLINT SetAttrsA
      move.l   a2,sp
      ENDM

setmutex MACRO ; obj,n
      seti \1,#MUIA_Radio_Active,\2
      ENDM
setcycle MACRO ; obj,n
      seti \1,#MUIA_Cycle_Active,\2
      ENDM
setstring MACRO ; obj,s
      seti \1,#MUIA_String_Contents,\2
      ENDM
setcheckmark MACRO ; obj,b
      seti \1,#MUIA_Selected,\2
      ENDM
setslider MACRO ; obj,l
      seti \1,#MUIA_Slider_Level,\2
      ENDM


   ENDC  ;MUI_NOSHORTCUTS

   ENDC  ;LIBRARIES_MUI_I
