 /* Copyright © 1995-1996 Kai Hofmann. All rights reserved. */

 #ifndef NOERRORHANDLING
 #include "muiext.h"
 #include <exec/types.h>
 #include <proto/dos.h>
 #include <libraries/mui.h>
 #include <mui/Busy_mcc.h>
 #include <mui/MonthNavigator_mcc.h>
 #include <string.h>


 #define MUIM_GetConfigItem			0x80423edb
 struct MUIP_GetConfigItem			{ULONG MethodID; ULONG id; ULONG *storage;};
 #define MUIM_Settingsgroup_ConfigToGadgets	0x80427043
 struct MUIP_Settingsgroup_ConfigToGadgets	{ ULONG MethodID; Object *configdata; };
 #define MUIM_Settingsgroup_GadgetsToConfig	0x80425242
 struct MUIP_Settingsgroup_GadgetsToConfig	{ ULONG MethodID; Object *configdata; };
 #define MUIM_Dataspace_Find			0x8042832c
 struct MUIP_Dataspace_Find			{ ULONG MethodID; ULONG id; };


 struct AttrAttachStruct {
                          ULONG  AttrID;
                          STRPTR AttrName;
                          ULONG  ClassID;
                         };


 static struct AttrAttachStruct AttrAttach[] = {
               #ifndef NOMUIERRORHANDLING
               /* Notify */
               {MUIA_ApplicationObject,"MUIA_ApplicationObject",NotifyClass},
               {MUIA_AppMessage,"MUIA_AppMessage",NotifyClass},
               {MUIA_HelpLine,"MUIA_HelpLine",NotifyClass},
               {MUIA_HelpNode,"MUIA_HelpNode",NotifyClass},
               {MUIA_NoNotify,"MUIA_NoNotify",NotifyClass},
               {MUIA_Parent,"MUIA_Parent",NotifyClass},
               {MUIA_Revision,"MUIA_Revision",NotifyClass},
               {MUIA_UserData,"MUIA_UserData",NotifyClass},
               {MUIA_Version,"MUIA_Version",NotifyClass},
               /* Family */
               {MUIA_Family_Child,"MUIA_Family_Child",FamilyClass},
               {MUIA_Family_List,"MUIA_Family_List",FamilyClass},
               /* Menustrip */
               {MUIA_Menustrip_Enabled,"MUIA_Menustrip_Enabled",MenustripClass},
               /* Menu */
               {MUIA_Menu_Enabled,"MUIA_Menu_Enabled",MenuClass},
               {MUIA_Menu_Title,"MUIA_Menu_Title",MenuClass},
               /* Menuitem */
               {MUIA_Menuitem_Checked,"MUIA_Menuitem_Checked",MenuitemClass},
               {MUIA_Menuitem_Checkit,"MUIA_Menuitem_Checkit",MenuitemClass},
               {MUIA_Menuitem_Enabled,"MUIA_Menuitem_Enabled",MenuitemClass},
               {MUIA_Menuitem_Exclude,"MUIA_Menuitem_Exclude",MenuitemClass},
               {MUIA_Menuitem_Shortcut,"MUIA_Menuitem_Shortcut",MenuitemClass},
               {MUIA_Menuitem_Title,"MUIA_Menuitem_Title",MenuitemClass},
               {MUIA_Menuitem_Toggle,"MUIA_Menuitem_Toggle",MenuitemClass},
               {MUIA_Menuitem_Trigger,"MUIA_Menuitem_Trigger",MenuitemClass},
               /* Application */
               {MUIA_Application_Active,"MUIA_Application_Active",ApplicationClass},
               {MUIA_Application_Author,"MUIA_Application_Author",ApplicationClass},
               {MUIA_Application_Base,"MUIA_Application_Base",ApplicationClass},
               {MUIA_Application_Broker,"MUIA_Application_Broker",ApplicationClass},
               {MUIA_Application_BrokerHook,"MUIA_Application_BrokerHook",ApplicationClass},
               {MUIA_Application_BrokerPort,"MUIA_Application_BrokerPort",ApplicationClass},
               {MUIA_Application_BrokerPri,"MUIA_Application_BrokerPri",ApplicationClass},
               {MUIA_Application_Commands,"MUIA_Application_Commands",ApplicationClass},
               {MUIA_Application_Copyright,"MUIA_Application_Copyright",ApplicationClass},
               {MUIA_Application_Description,"MUIA_Application_Description",ApplicationClass},
               {MUIA_Application_DiskObject,"MUIA_Application_DiskObject",ApplicationClass},
               {MUIA_Application_DoubleStart,"MUIA_Application_DoubleStart",ApplicationClass},
               {MUIA_Application_DropObject,"MUIA_Application_DropObject",ApplicationClass},
               {MUIA_Application_ForceQuit,"MUIA_Application_ForceQuit",ApplicationClass},
               {MUIA_Application_HelpFile,"MUIA_Application_HelpFile",ApplicationClass},
               {MUIA_Application_Iconified,"MUIA_Application_Iconified",ApplicationClass},
               {MUIA_Application_Menu,"MUIA_Application_Menu",ApplicationClass},
               {MUIA_Application_MenuAction,"MUIA_Application_MenuAction",ApplicationClass},
               {MUIA_Application_MenuHelp,"MUIA_Application_MenuHelp",ApplicationClass},
               {MUIA_Application_Menustrip,"MUIA_Application_Menustrip",ApplicationClass},
               {MUIA_Application_RexxHook,"MUIA_Application_RexxHook",ApplicationClass},
               {MUIA_Application_RexxMsg,"MUIA_Application_RexxMsg",ApplicationClass},
               {MUIA_Application_RexxString,"MUIA_Application_RexxString",ApplicationClass},
               {MUIA_Application_SingleTask,"MUIA_Application_SingleTask",ApplicationClass},
               {MUIA_Application_Sleep,"MUIA_Application_Sleep",ApplicationClass},
               {MUIA_Application_Title,"MUIA_Application_Title",ApplicationClass},
               {MUIA_Application_UseCommodities,"MUIA_Application_UseCommodities",ApplicationClass},
               {MUIA_Application_UseRexx,"MUIA_Application_UseRexx",ApplicationClass},
               {MUIA_Application_Version,"MUIA_Application_Version",ApplicationClass},
               {MUIA_Application_Window,"MUIA_Application_Window",ApplicationClass},
               {MUIA_Application_WindowList,"MUIA_Application_WindowList",ApplicationClass},
               /* Window */
               {MUIA_Window_Activate,"MUIA_Window_Activate",WindowClass},
               {MUIA_Window_ActiveObject,"MUIA_Window_ActiveObject",WindowClass},
               {MUIA_Window_AltHeight,"MUIA_Window_AltHeight",WindowClass},
               {MUIA_Window_AltLeftEdge,"MUIA_Window_AltLeftEdge",WindowClass},
               {MUIA_Window_AltTopEdge,"MUIA_Window_AltTopEdge",WindowClass},
               {MUIA_Window_AltWidth,"MUIA_Window_AltWidth",WindowClass},
               {MUIA_Window_AppWindow,"MUIA_Window_AppWindow",WindowClass},
               {MUIA_Window_Backdrop,"MUIA_Window_Backdrop",WindowClass},
               {MUIA_Window_Borderless,"MUIA_Window_Borderless",WindowClass},
               {MUIA_Window_CloseGadget,"MUIA_Window_CloseGadget",WindowClass},
               {MUIA_Window_CloseRequest,"MUIA_Window_CloseRequest",WindowClass},
               {MUIA_Window_DefaultObject,"MUIA_Window_DefaultObject",WindowClass},
               {MUIA_Window_DepthGadget,"MUIA_Window_DepthGadget",WindowClass},
               {MUIA_Window_DragBar,"MUIA_Window_DragBar",WindowClass},
               {MUIA_Window_FancyDrawing,"MUIA_Window_FancyDrawing",WindowClass},
               {MUIA_Window_Height,"MUIA_Window_Height",WindowClass},
               {MUIA_Window_ID,"MUIA_Window_ID",WindowClass},
               {MUIA_Window_InputEvent,"MUIA_Window_InputEvent",WindowClass},
               {MUIA_Window_IsSubWindow,"MUIA_Window_IsSubWindow",WindowClass},
               {MUIA_Window_LeftEdge,"MUIA_Window_LeftEdge",WindowClass},
               {MUIA_Window_Menu,"MUIA_Window_Menu",WindowClass},
               {MUIA_Window_MenuAction,"MUIA_Window_MenuAction",WindowClass},
               {MUIA_Window_Menustrip,"MUIA_Window_Menustrip",WindowClass},
               {MUIA_Window_MouseObject,"MUIA_Window_MouseObject",WindowClass},
               {MUIA_Window_NeedsMouseObject,"MUIA_Window_NeedsMouseObject",WindowClass},
               {MUIA_Window_NoMenus,"MUIA_Window_NoMenus",WindowClass},
               {MUIA_Window_Open,"MUIA_Window_Open",WindowClass},
               {MUIA_Window_PublicScreen,"MUIA_Window_PublicScreen",WindowClass},
               {MUIA_Window_RefWindow,"MUIA_Window_RefWindow",WindowClass},
               {MUIA_Window_RootObject,"MUIA_Window_RootObject",WindowClass},
               {MUIA_Window_Screen,"MUIA_Window_Screen",WindowClass},
               {MUIA_Window_ScreenTitle,"MUIA_Window_ScreenTitle",WindowClass},
               {MUIA_Window_SizeGadget,"MUIA_Window_SizeGadget",WindowClass},
               {MUIA_Window_SizeRight,"MUIA_Window_SizeRight",WindowClass},
               {MUIA_Window_Sleep,"MUIA_Window_Sleep",WindowClass},
               {MUIA_Window_Title,"MUIA_Window_Title",WindowClass},
               {MUIA_Window_TopEdge,"MUIA_Window_TopEdge",WindowClass},
               {MUIA_Window_UseBottomBorderScroller,"MUIA_Window_UseBottomBorderScroller",WindowClass},
               {MUIA_Window_UseLeftBorderScroller,"MUIA_Window_UseLeftBorderScroller",WindowClass},
               {MUIA_Window_UseRightBorderScroller,"MUIA_Window_UseRightBorderScroller",WindowClass},
               {MUIA_Window_Width,"MUIA_Window_Width",WindowClass},
               {MUIA_Window_Window,"MUIA_Window_Window",WindowClass},
               /* Aboutmui */
               {MUIA_Aboutmui_Application,"MUIA_Aboutmui_Application",AboutmuiClass},
               /* Area */
               {MUIA_Background,"MUIA_Background",AreaClass},
               {MUIA_BottomEdge,"MUIA_BottomEdge",AreaClass},
               {MUIA_ContextMenu,"MUIA_ContextMenu",AreaClass},
               {MUIA_ContextMenuTrigger,"MUIA_ContextMenuTrigger",AreaClass},
               {MUIA_ControlChar,"MUIA_ControlChar",AreaClass},
               {MUIA_CycleChain,"MUIA_CycleChain",AreaClass},
               {MUIA_Disabled,"MUIA_Disabled",AreaClass},
               {MUIA_Draggable,"MUIA_Draggable",AreaClass},
               {MUIA_Dropable,"MUIA_Dropable",AreaClass},
               {MUIA_ExportID,"MUIA_ExportID",AreaClass},
               {MUIA_FillArea,"MUIA_FillArea",AreaClass},
               {MUIA_FixHeight,"MUIA_FixHeight",AreaClass},
               {MUIA_FixHeightTxt,"MUIA_FixHeightTxt",AreaClass},
               {MUIA_FixWidth,"MUIA_FixWidth",AreaClass},
               {MUIA_FixWidthTxt,"MUIA_FixWidthTxt",AreaClass},
               {MUIA_Font,"MUIA_Font",AreaClass},
               {MUIA_Frame,"MUIA_Frame",AreaClass},
               {MUIA_FramePhantomHoriz,"MUIA_FramePhantomHoriz",AreaClass},
               {MUIA_FrameTitle,"MUIA_FrameTitle",AreaClass},
               {MUIA_Height,"MUIA_Height",AreaClass},
               {MUIA_HorizDisappear,"MUIA_HorizDisappear",AreaClass},
               {MUIA_HorizWeight,"MUIA_HorizWeight",AreaClass},
               {MUIA_InnerBottom,"MUIA_InnerBottom",AreaClass},
               {MUIA_InnerLeft,"MUIA_InnerLeft",AreaClass},
               {MUIA_InnerRight,"MUIA_InnerRight",AreaClass},
               {MUIA_InnerTop,"MUIA_InnerTop",AreaClass},
               {MUIA_InputMode,"MUIA_InputMode",AreaClass},
               {MUIA_LeftEdge,"MUIA_LeftEdge",AreaClass},
               {MUIA_MaxHeight,"MUIA_MaxHeight",AreaClass},
               {MUIA_MaxWidth,"MUIA_MaxWidth",AreaClass},
               {MUIA_ObjectID,"MUIA_ObjectID",AreaClass},
               {MUIA_Pressed,"MUIA_Pressed",AreaClass},
               {MUIA_RightEdge,"MUIA_RightEdge",AreaClass},
               {MUIA_Selected,"MUIA_Selected",AreaClass},
               {MUIA_ShortHelp,"MUIA_ShortHelp",AreaClass},
               {MUIA_ShowMe,"MUIA_ShowMe",AreaClass},
               {MUIA_ShowSelState,"MUIA_ShowSelState",AreaClass},
               {MUIA_Timer,"MUIA_Timer",AreaClass},
               {MUIA_TopEdge,"MUIA_TopEdge",AreaClass},
               {MUIA_VertDisappear,"MUIA_VertDisappear",AreaClass},
               {MUIA_VertWeight,"MUIA_VertWeight",AreaClass},
               {MUIA_Weight,"MUIA_Weight",AreaClass},
               {MUIA_Width,"MUIA_Width",AreaClass},
               {MUIA_Window,"MUIA_Window",AreaClass},
               {MUIA_WindowObject,"MUIA_WindowObject",AreaClass},
               /* Rectangle */
               {MUIA_Rectangle_BarTitle,"MUIA_Rectangle_BarTitle",RectangleClass},
               {MUIA_Rectangle_HBar,"MUIA_Rectangle_HBar",RectangleClass},
               {MUIA_Rectangle_VBar,"MUIA_Rectangle_VBar",RectangleClass},
               /* Balance */
               /* Image */
               {MUIA_Image_FontMatch,"MUIA_Image_FontMatch",ImageClass},
               {MUIA_Image_FontMatchHeight,"MUIA_Image_FontMatchHeight",ImageClass},
               {MUIA_Image_FontMatchWidth,"MUIA_Image_FontMatchWidth",ImageClass},
               {MUIA_Image_FreeHoriz,"MUIA_Image_FreeHoriz",ImageClass},
               {MUIA_Image_FreeVert,"MUIA_Image_FreeVert",ImageClass},
               {MUIA_Image_OldImage,"MUIA_Image_OldImage",ImageClass},
               {MUIA_Image_Spec,"MUIA_Image_Spec",ImageClass},
               {MUIA_Image_State,"MUIA_Image_State",ImageClass},
               /* Bitmap */
               {MUIA_Bitmap_Bitmap,"MUIA_Bitmap_Bitmap",BitmapClass},
               {MUIA_Bitmap_Height,"MUIA_Bitmap_Height",BitmapClass},
               {MUIA_Bitmap_MappingTable,"MUIA_Bitmap_MappingTable",BitmapClass},
               {MUIA_Bitmap_Precision,"MUIA_Bitmap_Precision",BitmapClass},
               {MUIA_Bitmap_RemappedBitmap,"MUIA_Bitmap_RemappedBitmap",BitmapClass},
               {MUIA_Bitmap_SourceColors,"MUIA_Bitmap_SourceColors",BitmapClass},
               {MUIA_Bitmap_Transparent,"MUIA_Bitmap_Transparent",BitmapClass},
               {MUIA_Bitmap_UseFriend,"MUIA_Bitmap_UseFriend",BitmapClass},
               {MUIA_Bitmap_Width,"MUIA_Bitmap_Width",BitmapClass},
               /* Bodychunk */
               {MUIA_Bodychunk_Body,"MUIA_Bodychunk_Body",BodychunkClass},
               {MUIA_Bodychunk_Compression,"MUIA_Bodychunk_Compression",BodychunkClass},
               {MUIA_Bodychunk_Depth,"MUIA_Bodychunk_Depth",BodychunkClass},
               {MUIA_Bodychunk_Masking,"MUIA_Bodychunk_Masking",BodychunkClass},
               /* Text */
               {MUIA_Text_Contents,"MUIA_Text_Contents",TextClass},
               {MUIA_Text_HiChar,"MUIA_Text_HiChar",TextClass},
               {MUIA_Text_PreParse,"MUIA_Text_PreParse",TextClass},
               {MUIA_Text_SetMax,"MUIA_Text_SetMax",TextClass},
               {MUIA_Text_SetMin,"MUIA_Text_SetMin",TextClass},
               {MUIA_Text_SetVMax,"MUIA_Text_SetVMax",TextClass},
               /* Gadget */
               {MUIA_Gadget_Gadget,"MUIA_Gadget_Gadget",GadgetClass},
               /* String */
               {MUIA_String_Accept,"MUIA_String_Accept",StringClass},
               {MUIA_String_Acknowledge,"MUIA_String_Acknowledge",StringClass},
               {MUIA_String_AdvanceOnCR,"MUIA_String_AdvanceOnCR",StringClass},
               {MUIA_String_AttachedList,"MUIA_String_AttachedList",StringClass},
               {MUIA_String_BufferPos,"MUIA_String_BufferPos",StringClass},
               {MUIA_String_Contents,"MUIA_String_Contents",StringClass},
               {MUIA_String_DisplayPos,"MUIA_String_DisplayPos",StringClass},
               {MUIA_String_EditHook,"MUIA_String_EditHook",StringClass},
               {MUIA_String_Format,"MUIA_String_Format",StringClass},
               {MUIA_String_Integer,"MUIA_String_Integer",StringClass},
               {MUIA_String_LonelyEditHook,"MUIA_String_LonelyEditHook",StringClass},
               {MUIA_String_MaxLen,"MUIA_String_MaxLen",StringClass},
               {MUIA_String_Reject,"MUIA_String_Reject",StringClass},
               {MUIA_String_Secret,"MUIA_String_Secret",StringClass},
               /* Boopsi */
               {MUIA_Boopsi_Class,"MUIA_Boopsi_Class",BoopsiClass},
               {MUIA_Boopsi_ClassID,"MUIA_Boopsi_ClassID",BoopsiClass},
               {MUIA_Boopsi_MaxHeight,"MUIA_Boopsi_MaxHeight",BoopsiClass},
               {MUIA_Boopsi_MaxWidth,"MUIA_Boopsi_MaxWidth",BoopsiClass},
               {MUIA_Boopsi_MinHeight,"MUIA_Boopsi_MinHeight",BoopsiClass},
               {MUIA_Boopsi_MinWidth,"MUIA_Boopsi_MinWidth",BoopsiClass},
               {MUIA_Boopsi_Object,"MUIA_Boopsi_Object",BoopsiClass},
               {MUIA_Boopsi_Remember,"MUIA_Boopsi_Remember",BoopsiClass},
               {MUIA_Boopsi_Smart,"MUIA_Boopsi_Smart",BoopsiClass},
               {MUIA_Boopsi_TagDrawInfo,"MUIA_Boopsi_TagDrawInfo",BoopsiClass},
               {MUIA_Boopsi_TagScreen,"MUIA_Boopsi_TagScreen",BoopsiClass},
               {MUIA_Boopsi_TagWindow,"MUIA_Boopsi_TagWindow",BoopsiClass},
               /* Prop */
               {MUIA_Prop_Entries,"MUIA_Prop_Entries",PropClass},
               {MUIA_Prop_First,"MUIA_Prop_First",PropClass},
               {MUIA_Prop_Horiz,"MUIA_Prop_Horiz",PropClass},
               {MUIA_Prop_Slider,"MUIA_Prop_Slider",PropClass},
               {MUIA_Prop_UseWinBorder,"MUIA_Prop_UseWinBorder",PropClass},
               {MUIA_Prop_Visible,"MUIA_Prop_Visible",PropClass},
               /* Gauge */
               {MUIA_Gauge_Current,"MUIA_Gauge_Current",GaugeClass},
               {MUIA_Gauge_Divide,"MUIA_Gauge_Divide",GaugeClass},
               {MUIA_Gauge_Horiz,"MUIA_Gauge_Horiz",GaugeClass},
               {MUIA_Gauge_InfoText,"MUIA_Gauge_InfoText",GaugeClass},
               {MUIA_Gauge_Max,"MUIA_Gauge_Max",GaugeClass},
               /* Scale */
               {MUIA_Scale_Horiz,"MUIA_Scale_Horiz",ScaleClass},
               /* Colorfield */
               {MUIA_Colorfield_Blue,"MUIA_Colorfield_Blue",ColorfieldClass},
               {MUIA_Colorfield_Green,"MUIA_Colorfield_Green",ColorfieldClass},
               {MUIA_Colorfield_Pen,"MUIA_Colorfield_Pen",ColorfieldClass},
               {MUIA_Colorfield_Red,"MUIA_Colorfield_Red",ColorfieldClass},
               {MUIA_Colorfield_RGB,"MUIA_Colorfield_RGB",ColorfieldClass},
               /* List */
               {MUIA_List_Active,"MUIA_List_Active",ListClass},
               {MUIA_List_AdjustHeight,"MUIA_List_AdjustHeight",ListClass},
               {MUIA_List_AdjustWidth,"MUIA_List_AdjustWidth",ListClass},
               {MUIA_List_AutoVisible,"MUIA_List_AutoVisible",ListClass},
               {MUIA_List_CompareHook,"MUIA_List_CompareHook",ListClass},
               {MUIA_List_ConstructHook,"MUIA_List_ConstructHook",ListClass},
               {MUIA_List_DestructHook,"MUIA_List_DestructHook",ListClass},
               {MUIA_List_DisplayHook,"MUIA_List_DisplayHook",ListClass},
               {MUIA_List_DragSortable,"MUIA_List_DragSortable",ListClass},
               {MUIA_List_DropMark,"MUIA_List_DropMark",ListClass},
               {MUIA_List_Entries,"MUIA_List_Entries",ListClass},
               {MUIA_List_First,"MUIA_List_First",ListClass},
               {MUIA_List_Format,"MUIA_List_Format",ListClass},
               {MUIA_List_InsertPosition,"MUIA_List_InsertPosition",ListClass},
               {MUIA_List_MinLineHeight,"MUIA_List_MinLineHeight",ListClass},
               {MUIA_List_MultiTestHook,"MUIA_List_MultiTestHook",ListClass},
               {MUIA_List_Pool,"MUIA_List_Pool",ListClass},
               {MUIA_List_PoolPuddleSize,"MUIA_List_PoolPuddleSize",ListClass},
               {MUIA_List_PoolThreshSize,"MUIA_List_PoolThreshSize",ListClass},
               {MUIA_List_Quiet,"MUIA_List_Quiet",ListClass},
               {MUIA_List_ShowDropMarks,"MUIA_List_ShowDropMarks",ListClass},
               {MUIA_List_SourceArray,"MUIA_List_SourceArray",ListClass},
               {MUIA_List_Title,"MUIA_List_Title",ListClass},
               {MUIA_List_Visible,"MUIA_List_Visible",ListClass},
               /* Floattext */
               {MUIA_Floattext_Justify,"MUIA_Floattext_Justify",FloattextClass},
               {MUIA_Floattext_SkipChars,"MUIA_Floattext_SkipChars",FloattextClass},
               {MUIA_Floattext_TabSize,"MUIA_Floattext_TabSize",FloattextClass},
               {MUIA_Floattext_Text,"MUIA_Floattext_Text",FloattextClass},
               /* Volumelist */
               /* Scrmodelist */
               /* Dirlist */
               {MUIA_Dirlist_AcceptPattern,"MUIA_Dirlist_AcceptPattern",DirlistClass},
               {MUIA_Dirlist_Directory,"MUIA_Dirlist_Directory",DirlistClass},
               {MUIA_Dirlist_DrawersOnly,"MUIA_Dirlist_DrawersOnly",DirlistClass},
               {MUIA_Dirlist_FilesOnly,"MUIA_Dirlist_FilesOnly",DirlistClass},
               {MUIA_Dirlist_FilterDrawers,"MUIA_Dirlist_FilterDrawers",DirlistClass},
               {MUIA_Dirlist_FilterHook,"MUIA_Dirlist_FilterHook",DirlistClass},
               {MUIA_Dirlist_MultiSelDirs,"MUIA_Dirlist_MultiSelDirs",DirlistClass},
               {MUIA_Dirlist_NumBytes,"MUIA_Dirlist_NumBytes",DirlistClass},
               {MUIA_Dirlist_NumDrawers,"MUIA_Dirlist_NumDrawers",DirlistClass},
               {MUIA_Dirlist_NumFiles,"MUIA_Dirlist_NumFiles",DirlistClass},
               {MUIA_Dirlist_Path,"MUIA_Dirlist_Path",DirlistClass},
               {MUIA_Dirlist_RejectIcons,"MUIA_Dirlist_RejectIcons",DirlistClass},
               {MUIA_Dirlist_RejectPattern,"MUIA_Dirlist_RejectPattern",DirlistClass},
               {MUIA_Dirlist_SortDirs,"MUIA_Dirlist_SortDirs",DirlistClass},
               {MUIA_Dirlist_SortHighLow,"MUIA_Dirlist_SortHighLow",DirlistClass},
               {MUIA_Dirlist_SortType,"MUIA_Dirlist_SortType",DirlistClass},
               {MUIA_Dirlist_Status,"MUIA_Dirlist_Status",DirlistClass},
               /* Numeric */
               {MUIA_Numeric_Default,"MUIA_Numeric_Default",NumericClass},
               {MUIA_Numeric_Format,"MUIA_Numeric_Format",NumericClass},
               {MUIA_Numeric_Max,"MUIA_Numeric_Max",NumericClass},
               {MUIA_Numeric_Min,"MUIA_Numeric_Min",NumericClass},
               {MUIA_Numeric_Reverse,"MUIA_Numeric_Reverse",NumericClass},
               {MUIA_Numeric_RevLeftRight,"MUIA_Numeric_RevLeftRight",NumericClass},
               {MUIA_Numeric_RevUpDown,"MUIA_Numeric_RevUpDown",NumericClass},
               {MUIA_Numeric_Value,"MUIA_Numeric_Value",NumericClass},
               /* Framedisplay */
               /* Popframe */
               /* Imagedisplay */
               /* Popimage */
               /* Pendisplay */
               {MUIA_Pendisplay_Pen,"MUIA_Pendisplay_Pen",PendisplayClass},
               {MUIA_Pendisplay_Reference,"MUIA_Pendisplay_Reference",PendisplayClass},
               {MUIA_Pendisplay_RGBcolor,"MUIA_Pendisplay_RGBcolor",PendisplayClass},
               {MUIA_Pendisplay_Spec,"MUIA_Pendisplay_Spec",PendisplayClass},
               /* Poppen */
               /* Knob */
               /* Levelmeter */
               {MUIA_Levelmeter_Label,"MUIA_Levelmeter_Label", LevelmeterClass},
               /* Numericbutton */
               /* Slider */
               {MUIA_Slider_Horiz,"MUIA_Slider_Horiz",SliderClass},
               {MUIA_Slider_Level,"MUIA_Slider_Level",SliderClass},
               {MUIA_Slider_Max,"MUIA_Slider_Max",SliderClass},
               {MUIA_Slider_Min,"MUIA_Slider_Min",SliderClass},
               {MUIA_Slider_Quiet,"MUIA_Slider_Quiet",SliderClass},
               {MUIA_Slider_Reverse,"MUIA_Slider_Reverse",SliderClass},
               /* Group */
               {MUIA_Group_ActivePage,"MUIA_Group_ActivePage",GroupClass},
               {MUIA_Group_Child,"MUIA_Group_Child",GroupClass},
               {MUIA_Group_ChildList,"MUIA_Group_ChildList",GroupClass},
               {MUIA_Group_Columns,"MUIA_Group_Columns",GroupClass},
               {MUIA_Group_Horiz,"MUIA_Group_Horiz",GroupClass},
               {MUIA_Group_HorizSpacing,"MUIA_Group_HorizSpacing",GroupClass},
               {MUIA_Group_LayoutHook,"MUIA_Group_LayoutHook",GroupClass},
               {MUIA_Group_PageMode,"MUIA_Group_PageMode",GroupClass},
               {MUIA_Group_Rows,"MUIA_Group_Rows",GroupClass},
               {MUIA_Group_SameHeight,"MUIA_Group_SameHeight",GroupClass},
               {MUIA_Group_SameSize,"MUIA_Group_SameSize",GroupClass},
               {MUIA_Group_SameWidth,"MUIA_Group_SameWidth",GroupClass},
               {MUIA_Group_Spacing,"MUIA_Group_Spacing",GroupClass},
               {MUIA_Group_VertSpacing,"MUIA_Group_VertSpacing",GroupClass},
               /* Mccprefs */
               /* Register */
               {MUIA_Register_Frame,"MUIA_Register_Frame",RegisterClass},
               {MUIA_Register_Titles,"MUIA_Register_Titles",RegisterClass},
               /* Settingsgroup */
               /* Settings */
               /* Frameadjust */
               /* Penadjust */
               {MUIA_Penadjust_PSIMode,"MUIA_Penadjust_PSIMode",PenadjustClass},
               /* Imageadjust */
               /* Virtgroup */
               {MUIA_Virtgroup_Height,"MUIA_Virtgroup_Height",VirtgroupClass},
               {MUIA_Virtgroup_Input,"MUIA_Virtgroup_Input",VirtgroupClass},
               {MUIA_Virtgroup_Left,"MUIA_Virtgroup_Left",VirtgroupClass},
               {MUIA_Virtgroup_Top,"MUIA_Virtgroup_Top",VirtgroupClass},
               {MUIA_Virtgroup_Width,"MUIA_Virtgroup_Width",VirtgroupClass},
               /* Scrollgroup */
               {MUIA_Scrollgroup_Contents,"MUIA_Scrollgroup_Contents",ScrollgroupClass},
               {MUIA_Scrollgroup_FreeHoriz,"MUIA_Scrollgroup_FreeHoriz",ScrollgroupClass},
               {MUIA_Scrollgroup_FreeVert,"MUIA_Scrollgroup_FreeVert",ScrollgroupClass},
               {MUIA_Scrollgroup_UseWinBorder,"MUIA_Scrollgroup_UseWinBorder",ScrollgroupClass},
               /* Scrollbar */
               {MUIA_Scrollbar_Type,"MUIA_Scrollbar_Type",ScrollbarClass},
               /* Listview */
               {MUIA_Listview_ClickColumn,"MUIA_Listview_ClickColumn", ListviewClass},
               {MUIA_Listview_DefClickColumn,"MUIA_Listview_DefClickColumn", ListviewClass},
               {MUIA_Listview_DoubleClick,"MUIA_Listview_DoubleClick", ListviewClass},
               {MUIA_Listview_DragType,"MUIA_Listview_DragType", ListviewClass},
               {MUIA_Listview_Input,"MUIA_Listview_Input", ListviewClass},
               {MUIA_Listview_List,"MUIA_Listview_List", ListviewClass},
               {MUIA_Listview_MultiSelect,"MUIA_Listview_MultiSelect", ListviewClass},
               {MUIA_Listview_ScrollerPos,"MUIA_Listview_ScrollerPos", ListviewClass},
               {MUIA_Listview_SelectChange,"MUIA_Listview_SelectChange", ListviewClass},
               /* Radio */
               {MUIA_Radio_Active,"MUIA_Radio_Active",RadioClass},
               {MUIA_Radio_Entries,"MUIA_Radio_Entries",RadioClass},
               /* Cycle */
               {MUIA_Cycle_Active,"MUIA_Cycle_Active",CycleClass},
               {MUIA_Cycle_Entries,"MUIA_Cycle_Entries",CycleClass},
               /* Coloradjust */
               {MUIA_Coloradjust_Blue,"MUIA_Coloradjust_Blue",ColoradjustClass},
               {MUIA_Coloradjust_Green,"MUIA_Coloradjust_Green",ColoradjustClass},
               {MUIA_Coloradjust_ModeID,"MUIA_Coloradjust_ModeID",ColoradjustClass},
               {MUIA_Coloradjust_Red,"MUIA_Coloradjust_Red",ColoradjustClass},
               {MUIA_Coloradjust_RGB,"MUIA_Coloradjust_RGB",ColoradjustClass},
               /* Palette */
               {MUIA_Palette_Entries,"MUIA_Palette_Entries",PaletteClass},
               {MUIA_Palette_Groupable,"MUIA_Palette_Groupable",PaletteClass},
               {MUIA_Palette_Names,"MUIA_Palette_Names",PaletteClass},
               /* Popstring */
               {MUIA_Popstring_Button,"MUIA_Popstring_Button",PopstringClass},
               {MUIA_Popstring_CloseHook,"MUIA_Popstring_CloseHook",PopstringClass},
               {MUIA_Popstring_OpenHook,"MUIA_Popstring_OpenHook",PopstringClass},
               {MUIA_Popstring_String,"MUIA_Popstring_String",PopstringClass},
               {MUIA_Popstring_Toggle,"MUIA_Popstring_Toggle",PopstringClass},
               /* Popobject */
               {MUIA_Popobject_Follow,"MUIA_Popobject_Follow",PopobjectClass},
               {MUIA_Popobject_Light,"MUIA_Popobject_Light",PopobjectClass},
               {MUIA_Popobject_Object,"MUIA_Popobject_Object",PopobjectClass},
               {MUIA_Popobject_ObjStrHook,"MUIA_Popobject_ObjStrHook",PopobjectClass},
               {MUIA_Popobject_StrObjHook,"MUIA_Popobject_StrObjHook",PopobjectClass},
               {MUIA_Popobject_Volatile,"MUIA_Popobject_Volatile",PopobjectClass},
               {MUIA_Popobject_WindowHook,"MUIA_Popobject_WindowHook",PopobjectClass},
               /* Poplist */
               {MUIA_Poplist_Array,"MUIA_Poplist_Array",PoplistClass},
               /* Popscreen */
               /* Popasl */
               {MUIA_Popasl_Active,"MUIA_Popasl_Active",PopaslClass},
               {MUIA_Popasl_StartHook,"MUIA_Popasl_StartHook",PopaslClass},
               {MUIA_Popasl_StopHook,"MUIA_Popasl_StopHook",PopaslClass},
               {MUIA_Popasl_Type,"MUIA_Popasl_Type",PopaslClass},
               /* Semaphore */
               /* Applist */
               /* Dataspace */
               {MUIA_Dataspace_Pool,"MUIA_Dataspace_Pool",DataspaceClass},
               /* Configdata */

               /* Busy */
               {MUIA_Busy_Speed,"MUIA_Busy_Speed",BusyClass},
               /* MonthNavigator */
               {MUIA_MonthNavigator_Day,"MUIA_MonthNavigator_Day",MonthNavigatorClass},
               {MUIA_MonthNavigator_Month,"MUIA_MonthNavigator_Month",MonthNavigatorClass},
               {MUIA_MonthNavigator_Year,"MUIA_MonthNavigator_Year",MonthNavigatorClass},
               {MUIA_MonthNavigator_FirstWeekday,"MUIA_MonthNavigator_FirstWeekday",MonthNavigatorClass},
               {MUIA_MonthNavigator_ShowWeekdayNames,"MUIA_MonthNavigator_ShowWeekdayNames",MonthNavigatorClass},
               {MUIA_MonthNavigator_ShowWeekNumbers,"MUIA_MonthNavigator_ShowWeekNumbers",MonthNavigatorClass},
               {MUIA_MonthNavigator_Language,"MUIA_MonthNavigator_Language",MonthNavigatorClass},
               {MUIA_MonthNavigator_Country,"MUIA_MonthNavigator_Country",MonthNavigatorClass},
               #endif
               {NULL,"UNKNOWN",0}
                                               };


 struct MethodAttachStruct {
                            ULONG  MethodID;
                            STRPTR MethodName;
                            ULONG  ClassID;
                           };


 static struct MethodAttachStruct MethodAttach[] = {
               #ifndef NOMUIERRORHANDLING
               /* Amiga OS */
               {OM_NEW,"OM_NEW",0},
               {OM_DISPOSE,"OM_DISPOSE",0},
               {OM_SET,"OM_SET",0},
               {OM_GET,"OM_GET",0},
               {OM_ADDTAIL,"OM_ADDTAIL",0},
               {OM_REMOVE,"OM_REMOVE",0},
               {OM_NOTIFY,"OM_NOTIFY",0},
               {OM_UPDATE,"OM_UPDATE",0},
               {OM_ADDMEMBER,"OM_ADDMEMBER",0},
               {OM_REMMEMBER,"OM_REMMEMBER",0},
               /* ??? */
               {MUIM_BoopsiQuery,"MUIM_BoopsiQuery",0},
               /* Notify */
               {MUIM_CallHook,"MUIM_CallHook",NotifyClass},
               {MUIM_Export,"MUIM_Export",NotifyClass},
               {MUIM_FindUData,"MUIM_FindUData",NotifyClass},
               {MUIM_GetUData,"MUIM_GetUData",NotifyClass},
               {MUIM_Import,"MUIM_Import",NotifyClass},
               {MUIM_KillNotify,"MUIM_KillNotify",NotifyClass},
               {MUIM_MultiSet,"MUIM_MultiSet",NotifyClass},
               {MUIM_NoNotifySet,"MUIM_NoNotifySet",NotifyClass},
               {MUIM_Notify,"MUIM_Notify",NotifyClass},
               {MUIM_Set,"MUIM_Set",NotifyClass},
               {MUIM_SetAsString,"MUIM_SetAsString",NotifyClass},
               {MUIM_SetUData,"MUIM_SetUData",NotifyClass},
               {MUIM_SetUDataOnce,"MUIM_SetUDataOnce",NotifyClass},
               {MUIM_WriteLong,"MUIM_WriteLong",NotifyClass},
               {MUIM_WriteString,"MUIM_WriteString",NotifyClass},
               /* Family */
               {MUIM_Family_AddHead,"MUIM_Family_AddHead",FamilyClass},
               {MUIM_Family_AddTail,"MUIM_Family_AddTail",FamilyClass},
               {MUIM_Family_Insert,"MUIM_Family_Insert",FamilyClass},
               {MUIM_Family_Remove,"MUIM_Family_Remove",FamilyClass},
               {MUIM_Family_Sort,"MUIM_Family_Sort",FamilyClass},
               {MUIM_Family_Transfer,"MUIM_Family_Transfer",FamilyClass},
               /* Menustrip */
               /* Menu */
               /* Menuitem */
               /* Application */
               {MUIM_Application_AboutMUI,"MUIM_Application_AboutMUI",ApplicationClass},
               {MUIM_Application_AddInputHandler,"MUIM_Application_AddInputHandler",ApplicationClass},
               {MUIM_Application_CheckRefresh,"MUIM_Application_CheckRefresh",ApplicationClass},
               {MUIM_Application_GetMenuCheck,"MUIM_Application_GetMenuCheck",ApplicationClass},
               {MUIM_Application_GetMenuState,"MUIM_Application_GetMenuState",ApplicationClass},
               {MUIM_Application_Input,"MUIM_Application_Input",ApplicationClass},
               {MUIM_Application_InputBuffered,"MUIM_Application_InputBuffered",ApplicationClass},
               {MUIM_Application_Load,"MUIM_Application_Load",ApplicationClass},
               {MUIM_Application_NewInput,"MUIM_Application_NewInput",ApplicationClass},
               {MUIM_Application_OpenConfigWindow,"MUIM_Application_OpenConfigWindow",ApplicationClass},
               {MUIM_Application_PushMethod,"MUIM_Application_PushMethod",ApplicationClass},
               {MUIM_Application_RemInputHandler,"MUIM_Application_RemInputHandler",ApplicationClass},
               {MUIM_Application_ReturnID,"MUIM_Application_ReturnID",ApplicationClass},
               {MUIM_Application_Save,"MUIM_Application_Save",ApplicationClass},
               {MUIM_Application_SetConfigItem,"MUIM_Application_SetConfigItem",ApplicationClass},
               {MUIM_Application_SetMenuCheck,"MUIM_Application_SetMenuCheck",ApplicationClass},
               {MUIM_Application_SetMenuState,"MUIM_Application_SetMenuState",ApplicationClass},
               {MUIM_Application_ShowHelp,"MUIM_Application_ShowHelp",ApplicationClass},
               /* Window */
               {MUIM_Window_GetMenuCheck,"MUIM_Window_GetMenuCheck",WindowClass},
               {MUIM_Window_GetMenuState,"MUIM_Window_GetMenuState",WindowClass},
               {MUIM_Window_ScreenToBack,"MUIM_Window_ScreenToBack",WindowClass},
               {MUIM_Window_ScreenToFront,"MUIM_Window_ScreenToFront",WindowClass},
               {MUIM_Window_SetCycleChain,"MUIM_Window_SetCycleChain",WindowClass},
               {MUIM_Window_SetMenuCheck,"MUIM_Window_SetMenuCheck",WindowClass},
               {MUIM_Window_SetMenuState,"MUIM_Window_SetMenuState",WindowClass},
               {MUIM_Window_ToBack,"MUIM_Window_ToBack",WindowClass},
               {MUIM_Window_ToFront,"MUIM_Window_ToFront",WindowClass},
               /* Aboutmui */
               /* Area */
               {MUIM_AskMinMax,"MUIM_AskMinMax",AreaClass},
               {MUIM_Cleanup,"MUIM_Cleanup",AreaClass},
               {MUIM_ContextMenuBuild,"MUIM_ContextMenuBuild",AreaClass},
               {MUIM_ContextMenuChoice,"MUIM_ContextMenuChoice",AreaClass},
               {MUIM_DragBegin,"MUIM_DragBegin",AreaClass},
               {MUIM_DragDrop,"MUIM_DragDrop",AreaClass},
               {MUIM_DragFinish,"MUIM_DragFinish",AreaClass},
               {MUIM_DragQuery,"MUIM_DragQuery",AreaClass},
               {MUIM_DragReport,"MUIM_DragReport",AreaClass},
               {MUIM_Draw,"MUIM_Draw",AreaClass},
               {MUIM_HandleInput,"MUIM_HandleInput",AreaClass},
               {MUIM_Hide,"MUIM_Hide",AreaClass},
               {MUIM_Setup,"MUIM_Setup",AreaClass},
               {MUIM_Show,"MUIM_Show",AreaClass},
               /* Rectangle */
               /* Balance */
               /* Image */
               /* Bitmap */
               /* Bodychunk */
               /* Text */
               /* Gadget */
               /* String */
               /* Boopsi */
               /* Prop */
               /* Gauge */
               /* Scale */
               /* Colorfield */
               /* List */
               {MUIM_List_Clear,"MUIM_List_Clear",ListClass},
               {MUIM_List_CreateImage,"MUIM_List_CreateImage",ListClass},
               {MUIM_List_DeleteImage,"MUIM_List_DeleteImage",ListClass},
               {MUIM_List_Exchange,"MUIM_List_Exchange",ListClass},
               {MUIM_List_GetEntry,"MUIM_List_GetEntry",ListClass},
               {MUIM_List_Insert,"MUIM_List_Insert",ListClass},
               {MUIM_List_InsertSingle,"MUIM_List_InsertSingle",ListClass},
               {MUIM_List_Jump,"MUIM_List_Jump",ListClass},
               {MUIM_List_Move,"MUIM_List_Move",ListClass},
               {MUIM_List_NextSelected,"MUIM_List_NextSelected",ListClass},
               {MUIM_List_Redraw,"MUIM_List_Redraw",ListClass},
               {MUIM_List_Remove,"MUIM_List_Remove",ListClass},
               {MUIM_List_Select,"MUIM_List_Select",ListClass},
               {MUIM_List_Sort,"MUIM_List_Sort",ListClass},
               {MUIM_List_TestPos,"MUIM_List_TestPos",ListClass},
               /* Floattext */
               /* Volumelist */
               /* Scrmodelist */
               /* Dirlist */
               {MUIM_Dirlist_ReRead,"MUIM_Dirlist_ReRead",DirlistClass},
               /* Numeric */
               {MUIM_Numeric_Decrease,"MUIM_Numeric_Decrease",NumericClass},
               {MUIM_Numeric_Increase,"MUIM_Numeric_Increase",NumericClass},
               {MUIM_Numeric_ScaleToValue,"MUIM_Numeric_ScaleToValue",NumericClass},
               {MUIM_Numeric_SetDefault,"MUIM_Numeric_SetDefault",NumericClass},
               {MUIM_Numeric_Stringify,"MUIM_Numeric_Stringify",NumericClass},
               {MUIM_Numeric_ValueToScale,"MUIM_Numeric_ValueToScale",NumericClass},
               /* Framedisplay */
               /* Popframe */
               /* Imagedisplay */
               /* Popimage */
               /* Pendisplay */
               {MUIM_Pendisplay_SetColormap,"MUIM_Pendisplay_SetColormap",PendisplayClass},
               {MUIM_Pendisplay_SetMUIPen,"MUIM_Pendisplay_SetMUIPen",PendisplayClass},
               {MUIM_Pendisplay_SetRGB,"MUIM_Pendisplay_SetRGB",PendisplayClass},
               /* Poppen */
               /* Knob */
               /* Levelmeter */
               /* Numericbutton */
               /* Slider */
               /* Group */
               {MUIM_Group_ExitChange,"MUIM_Group_ExitChange",GroupClass},
               {MUIM_Group_InitChange,"MUIM_Group_InitChange",GroupClass},
               /* Mccprefs */
               /* Register */
               /* Settingsgroup */
               {MUIM_Settingsgroup_ConfigToGadgets,"MUIM_Settingsgroup_ConfigToGadgets",SettingsgroupClass},
               {MUIM_Settingsgroup_GadgetsToConfig,"MUIM_Settingsgroup_GadgetsToConfig",SettingsgroupClass},
               /* Settings */
               /* Frameadjust */
               /* Penadjust */
               /* Imageadjust */
               /* Virtgroup */
               /* Scrollgroup */
               /* Scrollbar */
               /* Listview */
               /* Radio */
               /* Cycle */
               /* Coloradjust */
               /* Palette */
               /* Popstring */
               {MUIM_Popstring_Close,"MUIM_Popstring_Close",PopstringClass},
               {MUIM_Popstring_Open,"MUIM_Popstring_Open",PopstringClass},
               /* Popobject */
               /* Poplist */
               /* Popscreen */
               /* Popasl */
               /* Semaphore */
               {MUIM_Semaphore_Attempt,"MUIM_Semaphore_Attempt",SemaphoreClass},
               {MUIM_Semaphore_AttemptShared,"MUIM_Semaphore_AttemptShared",SemaphoreClass},
               {MUIM_Semaphore_Obtain,"MUIM_Semaphore_Obtain",SemaphoreClass},
               {MUIM_Semaphore_ObtainShared,"MUIM_Semaphore_ObtainShared",SemaphoreClass},
               {MUIM_Semaphore_Release,"MUIM_Semaphore_Release",SemaphoreClass},
               /* Applist */
               /* Dataspace */
               {MUIM_Dataspace_Add,"MUIM_Dataspace_Add",DataspaceClass},
               {MUIM_Dataspace_Clear,"MUIM_Dataspace_Clear",DataspaceClass},
               {MUIM_Dataspace_Merge,"MUIM_Dataspace_Merge",DataspaceClass},
               {MUIM_Dataspace_ReadIFF,"MUIM_Dataspace_ReadIFF",DataspaceClass},
               {MUIM_Dataspace_Remove,"MUIM_Dataspace_Remove",DataspaceClass},
               {MUIM_Dataspace_WriteIFF,"MUIM_Dataspace_WriteIFF",DataspaceClass},
               {MUIM_Dataspace_Find,"MUIM_Dataspace_Find",DataspaceClass},
               /* Configdata */
               {MUIM_GetConfigItem,"MUIM_GetConfigItem",ConfigdataClass},

               /* Busy */
               {MUIM_Busy_Move,"MUIM_Busy_Move",BusyClass},
               /* MonthNavigator */
               #endif
               {NULL,"UNKNOWN",0}
                                                   };


 static char *ClassName[] = {
                             "UNKNOWN",
                             #ifndef NOMUIERRORHANDLING
                             MUIC_Notify,
                             MUIC_Family,
                             MUIC_Menustrip,
                             MUIC_Menu,
                             MUIC_Menuitem,
                             MUIC_Application,
                             MUIC_Window,
                             MUIC_Aboutmui,
                             MUIC_Area,
                             MUIC_Rectangle,
                             MUIC_Balance,
                             MUIC_Image,
                             MUIC_Bitmap,
                             MUIC_Bodychunk,
                             MUIC_Text,
                             MUIC_Gadget,
                             MUIC_String,
                             MUIC_Boopsi,
                             MUIC_Prop,
                             MUIC_Gauge,
                             MUIC_Scale,
                             MUIC_Colorfield,
                             MUIC_List,
                             MUIC_Floattext,
                             MUIC_Volumelist,
                             MUIC_Scrmodelist,
                             MUIC_Dirlist,
                             MUIC_Numeric,
                             MUIC_Framedisplay,
                             MUIC_Popframe,
                             MUIC_Imagedisplay,
                             MUIC_Popimage,
                             MUIC_Pendisplay,
                             MUIC_Poppen,
                             MUIC_Knob,
                             MUIC_Levelmeter,
                             MUIC_Numericbutton,
                             MUIC_Slider,
                             MUIC_Group,
                             MUIC_Mccprefs,
                             MUIC_Register,
                             MUIC_Settingsgroup,
                             MUIC_Settings,
                             MUIC_Frameadjust,
                             MUIC_Penadjust,
                             MUIC_Imageadjust,
                             MUIC_Virtgroup,
                             MUIC_Scrollgroup,
                             MUIC_Scrollbar,
                             MUIC_Listview,
                             MUIC_Radio,
                             MUIC_Cycle,
                             MUIC_Coloradjust,
                             MUIC_Palette,
                             MUIC_Popstring,
                             MUIC_Popobject,
                             MUIC_Poplist,
                             MUIC_Popscreen,
                             MUIC_Popasl,
                             MUIC_Semaphore,
                             MUIC_Applist,
                             MUIC_Dataspace,
                             MUIC_Configdata,

                             MUIC_Busy,
                             MUIC_MonthNavigator,
                             #endif
                             NULL
                            };


 static void MUI_Fault_strcpy(LONG strnr, LONG headerlen, STRPTR buffer, LONG len)

/****i* muiext/MUI_Fault_strcpy() *********************************************
*
*   NAME
*	MUI_Fault_strcpy -- Help-function for MUI_Fault()
*
*   SYNOPSIS
*	MUI_Fault_strcpy(strnr, headerlen, buffer, len);
*
*	static void MUI_Fault_strcpy(LONG strnr, LONG headerlen, STRPTR buffer,
*	    LONG len);
*
*   FUNCTION
*	Help-function for MUI_Fault() that copies the MUI error message into
*	the given buffer.
*
*   INPUTS
*	strnr     - Number of the MUI error message.
*	headerlen - Length of the header to insert before error message.
*	buffer    - Buffer to receive error message.
*	len       - Length of the buffer.
*
*   RESULT
*	None.
*
*   EXAMPLE
*	Have a look into the MUI_Fault() code!
*
*   NOTES
*	None.
*
*   BUGS
*	Unknown.
*
*   SEE ALSO
*	MUI_Fault()
*
******************************************************************************/

  {
   static char *errstr[] = {
                            "ok",
                            "out of memory",
                            "out of gfx memory",
                            "invalid window bbject",
                            "missing library",
                            "no ARexx",
                            "single task",
                            "bad ARexx defintion",
                            "unknown ARexx command",
                            "bad ARexx syntax"
                           };
   static int errstrlen[] = {
                              2,
                             13,
                             17,
                             21,
                             15,
                              8,
                             11,
                             19,
                             21,
                             16
                            };

   buffer[0] = '\0';
   if ((strnr >= 0) && (strnr <= 9))
    {
     if (len >= errstrlen[strnr]+headerlen+1)
      {
       strcpy(buffer,errstr[strnr]);
      }
    }
  }


 LONG MUI_Fault(LONG code, STRPTR header, STRPTR buffer, LONG len)

/****** muiext/MUI_Fault() ****************************************************
*
*   NAME
*	MUI_Fault -- Returns the text for a MUI or DOS error code (V36)
*
*   SYNOPSIS
*	len = MUI_Fault(code, header, buffer, len);
*
*	LONG MUI_Fault(LONG code, STRPTR header, STRPTR buffer, LONG len);
*
*   FUNCTION
*	This routine obtains the error message text for the given error code.
*	The header is prepended to the text of the error message, followed
*	by a colon. Puts a null-terminated string for the error message into
*	the buffer. By convention, error messages should be no longer than
*	FAULT_MAX characters.
*	If the error code comes not from MUI MUI_Fault() will fall back to
*	the normal DOS Fault().
*
*   INPUTS
*	code   - Error code.
*	header - Header to output before error text.
*	buffer - Buffer to receive error message.
*	len    - Length of the buffer.
*
*   RESULT
*	len    - Number of characters put into buffer (may be 0)
*
*   EXAMPLE
*	...
*	switch (MUI_Request(app,win,0,PROGNAME,GetString(buttons),
*	    GetString(reqtxt)))
*	 {
*	  case 0 : ioerr = IoErr();
*	           if (ioerr != MUIE_OK)
*	            {
*	             / * error code (may be an out of memory occurs) * /
*	             MUI_Fault(ioerr,NULL,errstr,FAULT_MAX);
*	             printf("%s\n",errstr);
*	             break;
*	            }
*	           / * code for button 0 * /
*	           break;
*	  ...
*	 }
*	...
*
*   NOTES
*	None.
*
*   BUGS
*	Unknown.
*
*   SEE ALSO
*	dos/IoErr(), dos/SetIoErr(), dos/Fault(), dos/PrintFault()
*
******************************************************************************/

  {
   LONG headerlen = strlen(header);

   if (headerlen > 0)
    {
     headerlen += 2;
    }
   switch (code)
    {
     case MUIE_OK                  : MUI_Fault_strcpy(0,headerlen,buffer,len);
                                     break;
     case MUI_RXERR_OUTOFMEMORY    :
     case MUIE_OutOfMemory         : MUI_Fault_strcpy(1,headerlen,buffer,len);
                                     break;
     case MUIE_OutOfGfxMemory      : MUI_Fault_strcpy(2,headerlen,buffer,len);
                                     break;
     case MUIE_InvalidWindowObject : MUI_Fault_strcpy(3,headerlen,buffer,len);
                                     break;
     case MUIE_MissingLibrary      : MUI_Fault_strcpy(4,headerlen,buffer,len);
                                     break;
     case MUIE_NoARexx             : MUI_Fault_strcpy(5,headerlen,buffer,len);
                                     break;
     case MUIE_SingleTask          : MUI_Fault_strcpy(6,headerlen,buffer,len);
                                     break;
     case MUI_RXERR_BADDEFINITION  : MUI_Fault_strcpy(7,headerlen,buffer,len);
                                     break;
     case MUI_RXERR_UNKNOWNCOMMAND : MUI_Fault_strcpy(8,headerlen,buffer,len);
                                     break;
     case MUI_RXERR_BADSYNTAX      : MUI_Fault_strcpy(9,headerlen,buffer,len);
                                     break;
     default                       : buffer[0] = '\0';
                                     return(Fault(code,header,buffer,len));
    }
   if ((header != NULL) && (strlen(buffer) > 0))
    {
     strins(buffer,": ");
     strins(buffer,header);
    }
   return((LONG)strlen(buffer));
  }


 const STRPTR MUI_AttrName(const STRPTR ClassName, const ULONG AttrID)

/****** muiext/MUI_AttrName() *************************************************
*
*   NAME
*	MUI_AttrName -- Returns the name of a MUI attribute (V33)
*
*   SYNOPSIS
*	attrname = MUI_AttrName(ClassName, AttrID);
*
*	const STRPTR MUI_AttrName(const STRPTR ClassName, const ULONG AttrID);
*
*   FUNCTION
*	 Returns the name of a MUI attribute.
*
*   INPUTS
*	ClassName - Reserved for future extensions.
*	AttrID    - The ID of a MUI attribute - normaly MUIA_...
*
*   RESULT
*	attrname  - Name string of the attribute.
*
*   EXAMPLE
*	...
*	attrstr = MUI_AttrName(NULL,MUIA_Application_ForceQuit);
*	printf("Couldn't get attribute %s\n",attrstr);
*	...
*
*   NOTES
*	None.
*
*   BUGS
*	Unknown.
*
*   SEE ALSO
*	MUI_AttrClass(), MUI_ClassName(), MUI_MethodName(), MUI_MethodClass()
*
******************************************************************************/

  {
   ULONG i=0;

   while ((AttrAttach[i].AttrID != NULL) && (AttrAttach[i].AttrID != AttrID))
    {
     i++;
    }
   return(AttrAttach[i].AttrName);
  }


 ULONG MUI_AttrClass(const ULONG AttrID)

/****** muiext/MUI_AttrClass() ************************************************
*
*   NAME
*	MUI_AttrClass -- Returns the class id of a given MUI attribute (V33)
*
*   SYNOPSIS
*	classid = MUI_AttrClass(AttrID);
*
*	ULONG MUI_AttrClass(const ULONG AttrID);
*
*   FUNCTION
*	 Returns the class id of a given MUI attribute.
*
*   INPUTS
*	AttrID    - The ID of a MUI attribute - normaly MUIA_...
*
*   RESULT
*	classid   - The classid of the given MUI attribute.
*
*   EXAMPLE
*	...
*	classid = MUI_AttrClass(MUIA_Application_ForceQuit);
*	...
*
*   NOTES
*	None.
*
*   BUGS
*	Unknown.
*
*   SEE ALSO
*	MUI_AttrName(), MUI_ClassName(), MUI_MethodName(), MUI_MethodClass()
*
******************************************************************************/

  {
   ULONG i=0;

   while ((AttrAttach[i].AttrID != NULL) && (AttrAttach[i].AttrID != AttrID))
    {
     i++;
    }
   return(AttrAttach[i].ClassID);
  }


 const STRPTR MUI_MethodName(const STRPTR ClassName, const ULONG MethodID)

/****** muiext/MUI_MethodName() *********************************************
*
*   NAME
*	MUI_MethodName -- Returns the name of a MUI method (V33)
*
*   SYNOPSIS
*	methodname = MUI_MethodName(ClassName, MethodID);
*
*	const STRPTR MUI_MethodName(const STRPTR ClassName,
*	    const ULONG MethodID);
*
*   FUNCTION
*	 Returns the name of a MUI method.
*
*   INPUTS
*	ClassName - Reserved for future extensions.
*	MethodID  - The ID of a MUI method - normaly MUIM_...
*
*   RESULT
*	methodname  - Name string of the method.
*
*   EXAMPLE
*	...
*	methodstr = MUI_MethodName(NULL,MUIM_Set);
*	printf("Dispatcher detects method %s\n",methodstr);
*	...
*
*   NOTES
*	None.
*
*   BUGS
*	Unknown.
*
*   SEE ALSO
*	MUI_MethodClass(), MUI_ClassName(), MUI_AttrName(), MUI_AttrClass()
*
******************************************************************************/

  {
   ULONG i=0;

   while ((MethodAttach[i].MethodID != NULL) && (MethodAttach[i].MethodID != MethodID))
    {
     i++;
    }
   return(MethodAttach[i].MethodName);
  }


 ULONG MUI_MethodClass(const ULONG MethodID)

/****** muiext/MUI_MethodClass() ********************************************
*
*   NAME
*	MUI_MethodClass -- Returns the class id of a given MUI method (V33)
*
*   SYNOPSIS
*	classid = MUI_MethodClass(MethodID);
*
*	ULONG MUI_MethodClass(const ULONG MethodID);
*
*   FUNCTION
*	 Returns the class id of a given MUI method.
*
*   INPUTS
*	MethodID  - The ID of a MUI method - normaly MUIM_...
*
*   RESULT
*	classid   - The classid of the given MUI method.
*
*   EXAMPLE
*	...
*	classid = MUI_MethodClass(MUIM_Set);
*	...
*
*   NOTES
*	None.
*
*   BUGS
*	Unknown.
*
*   SEE ALSO
*	MUI_MethodName(), MUI_ClassName(), MUI_AttrName(), MUI_AttrClass()
*
******************************************************************************/

  {
   ULONG i=0;

   while ((MethodAttach[i].MethodID != NULL) && (MethodAttach[i].MethodID != MethodID))
    {
     i++;
    }
   return(MethodAttach[i].ClassID);
  }


 const STRPTR MUI_ClassName(const ULONG ClassID)

/****** muiext/MUI_ClassName() ************************************************
*
*   NAME
*	MUI_ClassName -- Returns the name of a MUI class (V33)
*
*   SYNOPSIS
*	classname = MUI_ClassName(ClassID);
*
*	const STRPTR MUI_ClassName(const ULONG ClassID);
*
*   FUNCTION
*	 Returns the name of a MUI class.
*
*   INPUTS
*	ClassID - ID of the MUI class.
*
*   RESULT
*	classname  - Name string of the class.
*
*   EXAMPLE
*	...
*	classstr = MUI_ClassName(MUI_AttrClass(MUIA_Application_ForceQuit));
*	printf("Trouble with MUI class %s\n",classstr);
*	...
*
*   NOTES
*	None.
*
*   BUGS
*	Unknown.
*
*   SEE ALSO
*	MUI_AttrName(), MUI_AttrClass()
*
******************************************************************************/

  {
   #ifndef NOMUIERRORHANDLING
   return(ClassName[ClassID]);
   #else
   return(ClassName[0]);
   #endif
  }
 #endif
