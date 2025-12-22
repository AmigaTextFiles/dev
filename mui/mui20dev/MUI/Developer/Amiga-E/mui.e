/***************************************************************************
**
** MUI - MagicUserInterface
** (c) 1993 by Stefan Stuntz
**
** Main Header File
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
*/


/****************************************************************************/
/** Notify.mui 7.13 (01.12.93)                                             **/
/****************************************************************************/

PROC muiC_Notify() RETURN 'Notify.mui'

/* Methods */

CONST MUIM_CallHook                  = $8042b96b
CONST MUIM_KillNotify                = $8042d240
CONST MUIM_MultiSet                  = $8042d356
CONST MUIM_Notify                    = $8042c9cb
CONST MUIM_Set                       = $8042549a
CONST MUIM_SetAsString               = $80422590
CONST MUIM_WriteLong                 = $80428d86
CONST MUIM_WriteString               = $80424bf4

/* Attributes */

CONST MUIA_AppMessage                 = $80421955 /* ..g struct AppMessage * */
CONST MUIA_HelpFile                   = $80423a6e /* isg STRPTR            */
CONST MUIA_HelpLine                   = $8042a825 /* isg LONG              */
CONST MUIA_HelpNode                   = $80420b85 /* isg STRPTR            */
CONST MUIA_NoNotify                   = $804237f9 /* .s. BOOL              */
CONST MUIA_Revision                   = $80427eaa /* ..g LONG              */
CONST MUIA_UserData                   = $80420313 /* isg ULONG             */
CONST MUIA_Version                    = $80422301 /* ..g LONG              */



/****************************************************************************/
/** Application.mui 7.12 (28.11.93)                                        **/
/****************************************************************************/

PROC muiC_Application() RETURN 'Application.mui'

/* Methods */

CONST MUIM_Application_GetMenuCheck  = $8042c0a7
CONST MUIM_Application_GetMenuState  = $8042a58f
CONST MUIM_Application_Input         = $8042d0f5
CONST MUIM_Application_InputBuffered = $80427e59
CONST MUIM_Application_Load          = $8042f90d
CONST MUIM_Application_PushMethod    = $80429ef8
CONST MUIM_Application_ReturnID      = $804276ef
CONST MUIM_Application_Save          = $804227ef
CONST MUIM_Application_SetMenuCheck  = $8042a707
CONST MUIM_Application_SetMenuState  = $80428bef
CONST MUIM_Application_ShowHelp      = $80426479

/* Attributes */

CONST MUIA_Application_Active         = $804260ab /* isg BOOL              */
CONST MUIA_Application_Author         = $80424842 /* i.g STRPTR            */
CONST MUIA_Application_Base           = $8042e07a /* i.g STRPTR            */
CONST MUIA_Application_Broker         = $8042dbce /* ..g Broker *          */
CONST MUIA_Application_BrokerHook     = $80428f4b /* isg struct Hook *     */
CONST MUIA_Application_BrokerPort     = $8042e0ad /* ..g struct MsgPort *  */
CONST MUIA_Application_BrokerPri      = $8042c8d0 /* i.g LONG              */
CONST MUIA_Application_Commands       = $80428648 /* isg struct MUI_Command * */
CONST MUIA_Application_Copyright      = $8042ef4d /* i.g STRPTR            */
CONST MUIA_Application_Description    = $80421fc6 /* i.g STRPTR            */
CONST MUIA_Application_DiskObject     = $804235cb /* isg struct DiskObject * */
CONST MUIA_Application_DoubleStart    = $80423bc6 /* ..g BOOL              */
CONST MUIA_Application_DropObject     = $80421266 /* is. Object *          */
CONST MUIA_Application_Iconified      = $8042a07f /* .sg BOOL              */
CONST MUIA_Application_Menu           = $80420e1f /* i.g struct NewMenu *  */
CONST MUIA_Application_MenuAction     = $80428961 /* ..g ULONG             */
CONST MUIA_Application_MenuHelp       = $8042540b /* ..g ULONG             */
CONST MUIA_Application_RexxHook       = $80427c42 /* isg struct Hook *     */
CONST MUIA_Application_RexxMsg        = $8042fd88 /* ..g struct RxMsg *    */
CONST MUIA_Application_RexxString     = $8042d711 /* .s. STRPTR            */
CONST MUIA_Application_SingleTask     = $8042a2c8 /* i.. BOOL              */
CONST MUIA_Application_Sleep          = $80425711 /* .s. BOOL              */
CONST MUIA_Application_Title          = $804281b8 /* i.g STRPTR            */
CONST MUIA_Application_Version        = $8042b33f /* i.g STRPTR            */
CONST MUIA_Application_Window         = $8042bfe0 /* i.. Object *          */



/****************************************************************************/
/** Window.mui 7.16 (03.12.93)                                             **/
/****************************************************************************/

PROC muiC_Window() RETURN 'Window.mui'

/* Methods */

CONST MUIM_Window_GetMenuCheck       = $80420414
CONST MUIM_Window_GetMenuState       = $80420d2f
CONST MUIM_Window_ScreenToBack       = $8042913d
CONST MUIM_Window_ScreenToFront      = $804227a4
CONST MUIM_Window_SetCycleChain      = $80426510
CONST MUIM_Window_SetMenuCheck       = $80422243
CONST MUIM_Window_SetMenuState       = $80422b5e
CONST MUIM_Window_ToBack             = $8042152e
CONST MUIM_Window_ToFront            = $8042554f

/* Attributes */

CONST MUIA_Window_Activate            = $80428d2f /* isg BOOL              */
CONST MUIA_Window_ActiveObject        = $80427925 /* .sg Object *          */
CONST MUIA_Window_AltHeight           = $8042cce3 /* i.g LONG              */
CONST MUIA_Window_AltLeftEdge         = $80422d65 /* i.g LONG              */
CONST MUIA_Window_AltTopEdge          = $8042e99b /* i.g LONG              */
CONST MUIA_Window_AltWidth            = $804260f4 /* i.g LONG              */
CONST MUIA_Window_AppWindow           = $804280cf /* i.. BOOL              */
CONST MUIA_Window_Backdrop            = $8042c0bb /* i.. BOOL              */
CONST MUIA_Window_Borderless          = $80429b79 /* i.. BOOL              */
CONST MUIA_Window_CloseGadget         = $8042a110 /* i.. BOOL              */
CONST MUIA_Window_CloseRequest        = $8042e86e /* ..g BOOL              */
CONST MUIA_Window_DefaultObject       = $804294d7 /* isg Object *          */
CONST MUIA_Window_DepthGadget         = $80421923 /* i.. BOOL              */
CONST MUIA_Window_DragBar             = $8042045d /* i.. BOOL              */
CONST MUIA_Window_Height              = $80425846 /* i.g LONG              */
CONST MUIA_Window_ID                  = $804201bd /* isg ULONG             */
CONST MUIA_Window_InputEvent          = $804247d8 /* ..g struct InputEvent * */
CONST MUIA_Window_LeftEdge            = $80426c65 /* i.g LONG              */
CONST MUIA_Window_Menu                = $8042db94 /* i.. struct NewMenu *  */
CONST MUIA_Window_NoMenus             = $80429df5 /* .s. BOOL              */
CONST MUIA_Window_Open                = $80428aa0 /* .sg BOOL              */
CONST MUIA_Window_PublicScreen        = $804278e4 /* isg STRPTR            */
CONST MUIA_Window_RefWindow           = $804201f4 /* is. Object *          */
CONST MUIA_Window_RootObject          = $8042cba5 /* i.. Object *          */
CONST MUIA_Window_Screen              = $8042df4f /* isg struct Screen *   */
CONST MUIA_Window_ScreenTitle         = $804234b0 /* isg STRPTR            */
CONST MUIA_Window_SizeGadget          = $8042e33d /* i.. BOOL              */
CONST MUIA_Window_SizeRight           = $80424780 /* i.. BOOL              */
CONST MUIA_Window_Sleep               = $8042e7db /* .sg BOOL              */
CONST MUIA_Window_Title               = $8042ad3d /* isg STRPTR            */
CONST MUIA_Window_TopEdge             = $80427c66 /* i.g LONG              */
CONST MUIA_Window_Width               = $8042dcae /* i.g LONG              */
CONST MUIA_Window_Window              = $80426a42 /* ..g struct Window *   */

CONST MUIV_Window_ActiveObject_None = 0
CONST MUIV_Window_ActiveObject_Next = -1
CONST MUIV_Window_ActiveObject_Prev = -2
PROC muiV_Window_AltHeightMinMax(p) RETURN (0-(p))
PROC muiV_Window_AltHeightVisible(p) RETURN (-100-(p))
PROC muiV_Window_AltHeightScreen(p) RETURN (-200-(p))
CONST MUIV_Window_AltHeight_Scaled = -1000
CONST MUIV_Window_AltLeftEdge_Centered = -1
CONST MUIV_Window_AltLeftEdge_Moused = -2
CONST MUIV_Window_AltLeftEdge_NoChange = -1000
CONST MUIV_Window_AltTopEdge_Centered = -1
CONST MUIV_Window_AltTopEdge_Moused = -2
PROC muiV_Window_AltTopEdgeDelta(p) RETURN (-3-(p))
CONST MUIV_Window_AltTopEdge_NoChange = -1000
PROC muiV_Window_AltWidthMinMax(p) RETURN (0-(p))
PROC muiV_Window_AltWidthVisible(p) RETURN (-100-(p))
PROC muiV_Window_AltWidthScreen(p) RETURN (-200-(p))
CONST MUIV_Window_AltWidth_Scaled = -1000
PROC muiV_Window_HeightMinMax(p) RETURN (0-(p))
PROC muiV_Window_HeightVisible(p) RETURN (-100-(p))
PROC muiV_Window_HeightScreen(p) RETURN (-200-(p))
CONST MUIV_Window_Height_Scaled = -1000
CONST MUIV_Window_Height_Default = -1001
CONST MUIV_Window_LeftEdge_Centered = -1
CONST MUIV_Window_LeftEdge_Moused = -2
CONST MUIV_Window_Menu_NoMenu = -1
CONST MUIV_Window_TopEdge_Centered = -1
CONST MUIV_Window_TopEdge_Moused = -2
PROC muiV_Window_TopEdgeDelta(p) RETURN (-3-(p))
PROC muiV_Window_WidthMinMax(p) RETURN (0-(p))
PROC muiV_Window_WidthVisible(p) RETURN (-100-(p))
PROC muiV_Window_WidthScreen(p) RETURN (-200-(p))
CONST MUIV_Window_Width_Scaled = -1000
CONST MUIV_Window_Width_Default = -1001


/****************************************************************************/
/** Area.mui 7.15 (28.11.93)                                               **/
/****************************************************************************/

PROC muiC_Area() RETURN 'Area.mui'

/* Methods */

CONST MUIM_AskMinMax                 = $80423874
CONST MUIM_Cleanup                   = $8042d985
CONST MUIM_Draw                      = $80426f3f
CONST MUIM_HandleInput               = $80422a1a
CONST MUIM_Hide                      = $8042f20f
CONST MUIM_Setup                     = $80428354
CONST MUIM_Show                      = $8042cc84

/* Attributes */

CONST MUIA_ApplicationObject          = $8042d3ee /* ..g Object *          */
CONST MUIA_Background                 = $8042545b /* is. LONG              */
CONST MUIA_BottomEdge                 = $8042e552 /* ..g LONG              */
CONST MUIA_ControlChar                = $8042120b /* i.. char              */
CONST MUIA_Disabled                   = $80423661 /* isg BOOL              */
CONST MUIA_ExportID                   = $8042d76e /* isg LONG              */
CONST MUIA_FixHeight                  = $8042a92b /* i.. LONG              */
CONST MUIA_FixHeightTxt               = $804276f2 /* i.. LONG              */
CONST MUIA_FixWidth                   = $8042a3f1 /* i.. LONG              */
CONST MUIA_FixWidthTxt                = $8042d044 /* i.. STRPTR            */
CONST MUIA_Font                       = $8042be50 /* i.g struct TextFont * */
CONST MUIA_Frame                      = $8042ac64 /* i.. LONG              */
CONST MUIA_FramePhantomHoriz          = $8042ed76 /* i.. BOOL              */
CONST MUIA_FrameTitle                 = $8042d1c7 /* i.. STRPTR            */
CONST MUIA_Height                     = $80423237 /* ..g LONG              */
CONST MUIA_HorizWeight                = $80426db9 /* i.. LONG              */
CONST MUIA_InnerBottom                = $8042f2c0 /* i.. LONG              */
CONST MUIA_InnerLeft                  = $804228f8 /* i.. LONG              */
CONST MUIA_InnerRight                 = $804297ff /* i.. LONG              */
CONST MUIA_InnerTop                   = $80421eb6 /* i.. LONG              */
CONST MUIA_InputMode                  = $8042fb04 /* i.. LONG              */
CONST MUIA_LeftEdge                   = $8042bec6 /* ..g LONG              */
CONST MUIA_Pressed                    = $80423535 /* ..g BOOL              */
CONST MUIA_RightEdge                  = $8042ba82 /* ..g LONG              */
CONST MUIA_Selected                   = $8042654b /* isg BOOL              */
CONST MUIA_ShowMe                     = $80429ba8 /* isg BOOL              */
CONST MUIA_ShowSelState               = $8042caac /* i.. BOOL              */
CONST MUIA_Timer                      = $80426435 /* ..g LONG              */
CONST MUIA_TopEdge                    = $8042509b /* ..g LONG              */
CONST MUIA_VertWeight                 = $804298d0 /* i.. LONG              */
CONST MUIA_Weight                     = $80421d1f /* i.. LONG              */
CONST MUIA_Width                      = $8042b59c /* ..g LONG              */
CONST MUIA_Window                     = $80421591 /* ..g struct Window *   */
CONST MUIA_WindowObject               = $8042669e /* ..g Object *          */

CONST MUIV_Font_Inherit = 0
CONST MUIV_Font_Normal = -1
CONST MUIV_Font_List = -2
CONST MUIV_Font_Tiny = -3
CONST MUIV_Font_Fixed = -4
CONST MUIV_Font_Title = -5
CONST MUIV_Frame_None = 0
CONST MUIV_Frame_Button = 1
CONST MUIV_Frame_ImageButton = 2
CONST MUIV_Frame_Text = 3
CONST MUIV_Frame_String = 4
CONST MUIV_Frame_ReadList = 5
CONST MUIV_Frame_InputList = 6
CONST MUIV_Frame_Prop = 7
CONST MUIV_Frame_Gauge = 8
CONST MUIV_Frame_Group = 9
CONST MUIV_Frame_PopUp = 10
CONST MUIV_Frame_Virtual = 11
CONST MUIV_Frame_Slider = 12
CONST MUIV_Frame_Count = 13
CONST MUIV_InputMode_None = 0
CONST MUIV_InputMode_RelVerify = 1
CONST MUIV_InputMode_Immediate = 2
CONST MUIV_InputMode_Toggle = 3


/****************************************************************************/
/** Rectangle.mui 7.14 (28.11.93)                                          **/
/****************************************************************************/

PROC muiC_Rectangle() RETURN 'Rectangle.mui'

/* Attributes */

CONST MUIA_Rectangle_HBar             = $8042c943 /* i.g BOOL              */
CONST MUIA_Rectangle_VBar             = $80422204 /* i.g BOOL              */



/****************************************************************************/
/** Image.mui 7.13 (28.11.93)                                              **/
/****************************************************************************/

PROC muiC_Image() RETURN 'Image.mui'

/* Attributes */

CONST MUIA_Image_FontMatch            = $8042815d /* i.. BOOL              */
CONST MUIA_Image_FontMatchHeight      = $80429f26 /* i.. BOOL              */
CONST MUIA_Image_FontMatchWidth       = $804239bf /* i.. BOOL              */
CONST MUIA_Image_FreeHoriz            = $8042da84 /* i.. BOOL              */
CONST MUIA_Image_FreeVert             = $8042ea28 /* i.. BOOL              */
CONST MUIA_Image_OldImage             = $80424f3d /* i.. struct Image *    */
CONST MUIA_Image_Spec                 = $804233d5 /* i.. char *            */
CONST MUIA_Image_State                = $8042a3ad /* is. LONG              */



/****************************************************************************/
/** Text.mui 7.15 (28.11.93)                                               **/
/****************************************************************************/

PROC muiC_Text() RETURN 'Text.mui'

/* Attributes */

CONST MUIA_Text_Contents              = $8042f8dc /* isg STRPTR            */
CONST MUIA_Text_HiChar                = $804218ff /* i.. char              */
CONST MUIA_Text_PreParse              = $8042566d /* isg STRPTR            */
CONST MUIA_Text_SetMax                = $80424d0a /* i.. BOOL              */
CONST MUIA_Text_SetMin                = $80424e10 /* i.. BOOL              */



/****************************************************************************/
/** String.mui 7.13 (28.11.93)                                             **/
/****************************************************************************/

PROC muiC_String() RETURN 'String.mui'

/* Attributes */

CONST MUIA_String_Accept              = $8042e3e1 /* isg STRPTR            */
CONST MUIA_String_Acknowledge         = $8042026c /* ..g STRPTR            */
CONST MUIA_String_AttachedList        = $80420fd2 /* i.. Object *          */
CONST MUIA_String_BufferPos           = $80428b6c /* .sg LONG              */
CONST MUIA_String_Contents            = $80428ffd /* isg STRPTR            */
CONST MUIA_String_DisplayPos          = $8042ccbf /* .sg LONG              */
CONST MUIA_String_EditHook            = $80424c33 /* isg struct Hook *     */
CONST MUIA_String_Format              = $80427484 /* i.g LONG              */
CONST MUIA_String_Integer             = $80426e8a /* isg ULONG             */
CONST MUIA_String_MaxLen              = $80424984 /* i.. LONG              */
CONST MUIA_String_Reject              = $8042179c /* isg STRPTR            */
CONST MUIA_String_Secret              = $80428769 /* i.g BOOL              */

CONST MUIV_String_Format_Left = 0
CONST MUIV_String_Format_Center = 1
CONST MUIV_String_Format_Right = 2


/****************************************************************************/
/** Prop.mui 7.12 (28.11.93)                                               **/
/****************************************************************************/

PROC muiC_Prop() RETURN 'Prop.mui'

/* Attributes */

CONST MUIA_Prop_Entries               = $8042fbdb /* isg LONG              */
CONST MUIA_Prop_First                 = $8042d4b2 /* isg LONG              */
CONST MUIA_Prop_Horiz                 = $8042f4f3 /* i.g BOOL              */
CONST MUIA_Prop_Slider                = $80429c3a /* isg BOOL              */
CONST MUIA_Prop_Visible               = $8042fea6 /* isg LONG              */



/****************************************************************************/
/** Gauge.mui 7.42 (10.02.94)                                              **/
/****************************************************************************/

PROC muiC_Gauge() RETURN 'Gauge.mui'

/* Attributes */

CONST MUIA_Gauge_Current              = $8042f0dd /* isg LONG              */
CONST MUIA_Gauge_Divide               = $8042d8df /* isg BOOL              */
CONST MUIA_Gauge_Horiz                = $804232dd /* i.. BOOL              */
CONST MUIA_Gauge_InfoText             = $8042bf15 /* isg char *            */
CONST MUIA_Gauge_Max                  = $8042bcdb /* isg LONG              */



/****************************************************************************/
/** Scale.mui 7.38 (10.02.94)                                              **/
/****************************************************************************/

PROC muiC_Scale() RETURN 'Scale.mui'

/* Attributes */

CONST MUIA_Scale_Horiz                = $8042919a /* isg BOOL              */



/****************************************************************************/
/** Boopsi.mui 7.37 (10.02.94)                                             **/
/****************************************************************************/

PROC muiC_Boopsi() RETURN 'Boopsi.mui'

/* Attributes */

CONST MUIA_Boopsi_Class               = $80426999 /* isg struct IClass *   */
CONST MUIA_Boopsi_ClassID             = $8042bfa3 /* isg char *            */
CONST MUIA_Boopsi_MaxHeight           = $8042757f /* isg ULONG             */
CONST MUIA_Boopsi_MaxWidth            = $8042bcb1 /* isg ULONG             */
CONST MUIA_Boopsi_MinHeight           = $80422c93 /* isg ULONG             */
CONST MUIA_Boopsi_MinWidth            = $80428fb2 /* isg ULONG             */
CONST MUIA_Boopsi_Object              = $80420178 /* ..g Object *          */
CONST MUIA_Boopsi_Remember            = $8042f4bd /* i.. ULONG             */
CONST MUIA_Boopsi_TagDrawInfo         = $8042bae7 /* isg ULONG             */
CONST MUIA_Boopsi_TagScreen           = $8042bc71 /* isg ULONG             */
CONST MUIA_Boopsi_TagWindow           = $8042e11d /* isg ULONG             */



/****************************************************************************/
/** Colorfield.mui 7.39 (10.02.94)                                         **/
/****************************************************************************/

PROC muiC_Colorfield() RETURN 'Colorfield.mui'

/* Attributes */

CONST MUIA_Colorfield_Blue            = $8042d3b0 /* isg ULONG             */
CONST MUIA_Colorfield_Green           = $80424466 /* isg ULONG             */
CONST MUIA_Colorfield_Pen             = $8042713a /* ..g ULONG             */
CONST MUIA_Colorfield_Red             = $804279f6 /* isg ULONG             */
CONST MUIA_Colorfield_RGB             = $8042677a /* isg ULONG *           */



/****************************************************************************/
/** List.mui 7.22 (28.11.93)                                               **/
/****************************************************************************/

PROC muiC_List() RETURN 'List.mui'

/* Methods */

CONST MUIM_List_Clear                = $8042ad89
CONST MUIM_List_Exchange             = $8042468c
CONST MUIM_List_GetEntry             = $804280ec
CONST MUIM_List_Insert               = $80426c87
CONST MUIM_List_InsertSingle         = $804254d5
CONST MUIM_List_Jump                 = $8042baab
CONST MUIM_List_NextSelected         = $80425f17
CONST MUIM_List_Redraw               = $80427993
CONST MUIM_List_Remove               = $8042647e
CONST MUIM_List_Select               = $804252d8
CONST MUIM_List_Sort                 = $80422275

/* Attributes */

CONST MUIA_List_Active                = $8042391c /* isg LONG              */
CONST MUIA_List_AdjustHeight          = $8042850d /* i.. BOOL              */
CONST MUIA_List_AdjustWidth           = $8042354a /* i.. BOOL              */
CONST MUIA_List_CompareHook           = $80425c14 /* is. struct Hook *     */
CONST MUIA_List_ConstructHook         = $8042894f /* is. struct Hook *     */
CONST MUIA_List_DestructHook          = $804297ce /* is. struct Hook *     */
CONST MUIA_List_DisplayHook           = $8042b4d5 /* is. struct Hook *     */
CONST MUIA_List_Entries               = $80421654 /* ..g LONG              */
CONST MUIA_List_First                 = $804238d4 /* ..g LONG              */
CONST MUIA_List_Format                = $80423c0a /* isg STRPTR            */
CONST MUIA_List_MultiTestHook         = $8042c2c6 /* is. struct Hook *     */
CONST MUIA_List_Quiet                 = $8042d8c7 /* .s. BOOL              */
CONST MUIA_List_SourceArray           = $8042c0a0 /* i.. APTR              */
CONST MUIA_List_Title                 = $80423e66 /* isg char *            */
CONST MUIA_List_Visible               = $8042191f /* ..g LONG              */

CONST MUIV_List_Active_Off = -1
CONST MUIV_List_Active_Top = -2
CONST MUIV_List_Active_Bottom = -3
CONST MUIV_List_Active_Up = -4
CONST MUIV_List_Active_Down = -5
CONST MUIV_List_Active_PageUp = -6
CONST MUIV_List_Active_PageDown = -7
CONST MUIV_List_ConstructHook_String = -1
CONST MUIV_List_DestructHook_String = -1


/****************************************************************************/
/** Floattext.mui 7.40 (10.02.94)                                          **/
/****************************************************************************/

PROC muiC_Floattext() RETURN 'Floattext.mui'

/* Attributes */

CONST MUIA_Floattext_Justify          = $8042dc03 /* isg BOOL              */
CONST MUIA_Floattext_SkipChars        = $80425c7d /* is. STRPTR            */
CONST MUIA_Floattext_TabSize          = $80427d17 /* is. LONG              */
CONST MUIA_Floattext_Text             = $8042d16a /* isg STRPTR            */



/****************************************************************************/
/** Volumelist.mui 7.37 (10.02.94)                                         **/
/****************************************************************************/

PROC muiC_Volumelist() RETURN 'Volumelist.mui'


/****************************************************************************/
/** Scrmodelist.mui 7.45 (10.02.94)                                        **/
/****************************************************************************/

PROC muiC_Scrmodelist() RETURN 'Scrmodelist.mui'

/* Attributes */




/****************************************************************************/
/** Dirlist.mui 7.38 (10.02.94)                                            **/
/****************************************************************************/

PROC muiC_Dirlist() RETURN 'Dirlist.mui'

/* Methods */

CONST MUIM_Dirlist_ReRead            = $80422d71

/* Attributes */

CONST MUIA_Dirlist_AcceptPattern      = $8042760a /* is. STRPTR            */
CONST MUIA_Dirlist_Directory          = $8042ea41 /* is. STRPTR            */
CONST MUIA_Dirlist_DrawersOnly        = $8042b379 /* is. BOOL              */
CONST MUIA_Dirlist_FilesOnly          = $8042896a /* is. BOOL              */
CONST MUIA_Dirlist_FilterDrawers      = $80424ad2 /* is. BOOL              */
CONST MUIA_Dirlist_FilterHook         = $8042ae19 /* is. struct Hook *     */
CONST MUIA_Dirlist_MultiSelDirs       = $80428653 /* is. BOOL              */
CONST MUIA_Dirlist_NumBytes           = $80429e26 /* ..g LONG              */
CONST MUIA_Dirlist_NumDrawers         = $80429cb8 /* ..g LONG              */
CONST MUIA_Dirlist_NumFiles           = $8042a6f0 /* ..g LONG              */
CONST MUIA_Dirlist_Path               = $80426176 /* ..g STRPTR            */
CONST MUIA_Dirlist_RejectIcons        = $80424808 /* is. BOOL              */
CONST MUIA_Dirlist_RejectPattern      = $804259c7 /* is. STRPTR            */
CONST MUIA_Dirlist_SortDirs           = $8042bbb9 /* is. LONG              */
CONST MUIA_Dirlist_SortHighLow        = $80421896 /* is. BOOL              */
CONST MUIA_Dirlist_SortType           = $804228bc /* is. LONG              */
CONST MUIA_Dirlist_Status             = $804240de /* ..g LONG              */

CONST MUIV_Dirlist_SortDirs_First = 0
CONST MUIV_Dirlist_SortDirs_Last = 1
CONST MUIV_Dirlist_SortDirs_Mix = 2
CONST MUIV_Dirlist_SortType_Name = 0
CONST MUIV_Dirlist_SortType_Date = 1
CONST MUIV_Dirlist_SortType_Size = 2
CONST MUIV_Dirlist_Status_Invalid = 0
CONST MUIV_Dirlist_Status_Reading = 1
CONST MUIV_Dirlist_Status_Valid = 2


/****************************************************************************/
/** Group.mui 7.12 (28.11.93)                                              **/
/****************************************************************************/

PROC muiC_Group() RETURN 'Group.mui'

/* Methods */


/* Attributes */

CONST MUIA_Group_ActivePage           = $80424199 /* isg LONG              */
CONST MUIA_Group_Child                = $804226e6 /* i.. Object *          */
CONST MUIA_Group_Columns              = $8042f416 /* is. LONG              */
CONST MUIA_Group_Horiz                = $8042536b /* i.. BOOL              */
CONST MUIA_Group_HorizSpacing         = $8042c651 /* is. LONG              */
CONST MUIA_Group_PageMode             = $80421a5f /* is. BOOL              */
CONST MUIA_Group_Rows                 = $8042b68f /* is. LONG              */
CONST MUIA_Group_SameHeight           = $8042037e /* i.. BOOL              */
CONST MUIA_Group_SameSize             = $80420860 /* i.. BOOL              */
CONST MUIA_Group_SameWidth            = $8042b3ec /* i.. BOOL              */
CONST MUIA_Group_Spacing              = $8042866d /* is. LONG              */
CONST MUIA_Group_VertSpacing          = $8042e1bf /* is. LONG              */



/****************************************************************************/
/** Group.mui 7.12 (28.11.93)                                              **/
/****************************************************************************/

PROC muiC_Register() RETURN 'Register.mui'

/* Attributes */

CONST MUIA_Register_Frame             = $8042349b /* i.g BOOL              */
CONST MUIA_Register_Titles            = $804297ec /* i.g STRPTR *          */



/****************************************************************************/
/** Virtgroup.mui 7.37 (10.02.94)                                          **/
/****************************************************************************/

PROC muiC_Virtgroup() RETURN 'Virtgroup.mui'

/* Methods */


/* Attributes */

CONST MUIA_Virtgroup_Height           = $80423038 /* ..g LONG              */
CONST MUIA_Virtgroup_Left             = $80429371 /* isg LONG              */
CONST MUIA_Virtgroup_Top              = $80425200 /* isg LONG              */
CONST MUIA_Virtgroup_Width            = $80427c49 /* ..g LONG              */



/****************************************************************************/
/** Scrollgroup.mui 7.35 (10.02.94)                                        **/
/****************************************************************************/

PROC muiC_Scrollgroup() RETURN 'Scrollgroup.mui'

/* Attributes */

CONST MUIA_Scrollgroup_Contents       = $80421261 /* i.. Object *          */



/****************************************************************************/
/** Scrollbar.mui 7.12 (28.11.93)                                          **/
/****************************************************************************/

PROC muiC_Scrollbar() RETURN 'Scrollbar.mui'


/****************************************************************************/
/** Listview.mui 7.13 (28.11.93)                                           **/
/****************************************************************************/

PROC muiC_Listview() RETURN 'Listview.mui'

/* Attributes */

CONST MUIA_Listview_ClickColumn       = $8042d1b3 /* ..g LONG              */
CONST MUIA_Listview_DefClickColumn    = $8042b296 /* isg LONG              */
CONST MUIA_Listview_DoubleClick       = $80424635 /* i.g BOOL              */
CONST MUIA_Listview_Input             = $8042682d /* i.. BOOL              */
CONST MUIA_Listview_List              = $8042bcce /* i.. Object *          */
CONST MUIA_Listview_MultiSelect       = $80427e08 /* i.. LONG              */
CONST MUIA_Listview_SelectChange      = $8042178f /* ..g BOOL              */

CONST MUIV_Listview_MultiSelect_None = 0
CONST MUIV_Listview_MultiSelect_Default = 1
CONST MUIV_Listview_MultiSelect_Shifted = 2
CONST MUIV_Listview_MultiSelect_Always = 3


/****************************************************************************/
/** Radio.mui 7.12 (28.11.93)                                              **/
/****************************************************************************/

PROC muiC_Radio() RETURN 'Radio.mui'

/* Attributes */

CONST MUIA_Radio_Active               = $80429b41 /* isg LONG              */
CONST MUIA_Radio_Entries              = $8042b6a1 /* i.. STRPTR *          */



/****************************************************************************/
/** Cycle.mui 7.16 (28.11.93)                                              **/
/****************************************************************************/

PROC muiC_Cycle() RETURN 'Cycle.mui'

/* Attributes */

CONST MUIA_Cycle_Active               = $80421788 /* isg LONG              */
CONST MUIA_Cycle_Entries              = $80420629 /* i.. STRPTR *          */

CONST MUIV_Cycle_Active_Next = -1
CONST MUIV_Cycle_Active_Prev = -2


/****************************************************************************/
/** Slider.mui 7.12 (28.11.93)                                             **/
/****************************************************************************/

PROC muiC_Slider() RETURN 'Slider.mui'

/* Attributes */

CONST MUIA_Slider_Level               = $8042ae3a /* isg LONG              */
CONST MUIA_Slider_Max                 = $8042d78a /* i.. LONG              */
CONST MUIA_Slider_Min                 = $8042e404 /* i.. LONG              */
CONST MUIA_Slider_Quiet               = $80420b26 /* i.. BOOL              */
CONST MUIA_Slider_Reverse             = $8042f2a0 /* isg BOOL              */



/****************************************************************************/
/** Coloradjust.mui 7.47 (10.02.94)                                        **/
/****************************************************************************/

PROC muiC_Coloradjust() RETURN 'Coloradjust.mui'

/* Attributes */

CONST MUIA_Coloradjust_Blue           = $8042b8a3 /* isg ULONG             */
CONST MUIA_Coloradjust_Green          = $804285ab /* isg ULONG             */
CONST MUIA_Coloradjust_ModeID         = $8042ec59 /* isg ULONG             */
CONST MUIA_Coloradjust_Red            = $80420eaa /* isg ULONG             */
CONST MUIA_Coloradjust_RGB            = $8042f899 /* isg ULONG *           */



/****************************************************************************/
/** Palette.mui 7.36 (10.02.94)                                            **/
/****************************************************************************/

PROC muiC_Palette() RETURN 'Palette.mui'

/* Attributes */

CONST MUIA_Palette_Entries            = $8042a3d8 /* i.g struct MUI_Palette_Entry * */
CONST MUIA_Palette_Groupable          = $80423e67 /* isg BOOL              */
CONST MUIA_Palette_Names              = $8042c3a2 /* isg char **           */



/****************************************************************************/
/** Colorpanel.mui 7.12 (10.02.94)                                         **/
/****************************************************************************/

PROC muiC_Colorpanel() RETURN 'Colorpanel.mui'

/* Methods */


/* Attributes */




/****************************************************************************/
/** Popstring.mui 7.19 (02.12.93)                                          **/
/****************************************************************************/

PROC muiC_Popstring() RETURN 'Popstring.mui'

/* Methods */

CONST MUIM_Popstring_Close           = $8042dc52
CONST MUIM_Popstring_Open            = $804258ba

/* Attributes */

CONST MUIA_Popstring_Button           = $8042d0b9 /* i.g Object *          */
CONST MUIA_Popstring_CloseHook        = $804256bf /* isg struct Hook *     */
CONST MUIA_Popstring_OpenHook         = $80429d00 /* isg struct Hook *     */
CONST MUIA_Popstring_String           = $804239ea /* i.g Object *          */
CONST MUIA_Popstring_Toggle           = $80422b7a /* isg BOOL              */



/****************************************************************************/
/** Popobject.mui 7.18 (02.12.93)                                          **/
/****************************************************************************/

PROC muiC_Popobject() RETURN 'Popobject.mui'

/* Attributes */

CONST MUIA_Popobject_Follow           = $80424cb5 /* isg BOOL              */
CONST MUIA_Popobject_Light            = $8042a5a3 /* isg BOOL              */
CONST MUIA_Popobject_Object           = $804293e3 /* i.g Object *          */
CONST MUIA_Popobject_ObjStrHook       = $8042db44 /* isg struct Hook *     */
CONST MUIA_Popobject_StrObjHook       = $8042fbe1 /* isg struct Hook *     */
CONST MUIA_Popobject_Volatile         = $804252ec /* isg BOOL              */



/****************************************************************************/
/** Popasl.mui 7.5 (03.12.93)                                              **/
/****************************************************************************/

PROC muiC_Popasl() RETURN 'Popasl.mui'

/* Attributes */

CONST MUIA_Popasl_Active              = $80421b37 /* ..g BOOL              */
CONST MUIA_Popasl_StartHook           = $8042b703 /* isg struct Hook *     */
CONST MUIA_Popasl_StopHook            = $8042d8d2 /* isg struct Hook *     */
CONST MUIA_Popasl_Type                = $8042df3d /* i.g ULONG             */


/* PROC main() RETURN 10   dummy */
