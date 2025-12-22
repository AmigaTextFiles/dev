/****************************************************************
   This file was created automatically by `FlexCat V1.0'
   Do NOT edit by hand!
****************************************************************/

#include <proto/locale.h>
#include <libraries/locale.h>

#ifndef MUIBuilder_CAT_H
#include "MUIBuilder_cat.h"
#endif	/*  !MUIBuilder_CAT_H		 */

#include <string.h>

#ifndef EXEC_MEMORY_H
#include <exec/memory.h>
#endif	/*  !EXEC_MEMORY_H	    */
#ifndef LIBRARIES_IFFPARSE_H
#include <libraries/iffparse.h>
#endif	/*  !LIBRARIES_IFFPARSE_H   */

#ifndef CLIB_IFFPARSE_PROTOS_H
#include <clib/iffparse_protos.h>
#endif	/*  !CLIB_IFFPARSE_PROTOS_H */
#ifndef CLIB_LOCALE_PROTOS_H
#include <clib/locale_protos.h>
#endif	/*  !CLIB_LOCALE_PROTOS_H   */
#ifndef CLIB_DOS_PROTOS_H
#include <clib/dos_protos.h>
#endif	/*  !DOS_PROTOS_H	    */
#ifndef CLIB_EXEC_PROTOS_H
#include <clib/exec_protos.h>
#endif	/*  !EXEC_PROTOS_H	    */
#ifndef CLIB_UTILITY_PROTOS_H
#include <clib/utility_protos.h>
#endif	/*  !CLIB_UTILITY_PROTOS_H  */

#ifdef AZTEC_C
#ifndef __PRAGMAS_LOCALE_LIB_H
#include <pragmas/locale_lib.h>
#endif	/*  !PRAGMAS_LOCALE_LIB_H   */
#ifndef __PRAGMAS_IFFPARSE_LIB_H
#include <pragmas/iffparse_lib.h>
#endif	/*  !PRAGMAS_IFFPARSE_LIB_H */
#ifndef __PRAGMAS_DOS_LIB_H
#include <pragmas/dos_lib.h>
#endif	/*  !PRAGMAS_DOS_LIB_H	    */
#ifndef __PRAGMAS_EXEC_LIB_H
#include <pragmas/exec_lib.h>
#endif	/*  !PRAGMAS_EXEC_LIB_H     */
#ifndef __PRAGMAS_UTILITY_LIB_H
#include <pragmas/utility_lib.h>
#endif	/*  !PRAGMAS_UTILITY_LIB_H  */
#endif	/*  AZTEC_C		    */

static LONG MUIBuilder_Version = 0;
static const STRPTR MUIBuilder_BuiltInLanguage = (STRPTR) "english";

struct FC_Type
{   LONG    ID;
    STRPTR  Str;
};

static const struct FC_Type MUIBuilder_Array [] =
{
    MSG_Application, (STRPTR) "Application",
    MSG_Base, (STRPTR) "Base",
    MSG_Author, (STRPTR) "Author",
    MSG_Title, (STRPTR) "Title",
    MSG_Version, (STRPTR) "Version",
    MSG_Copyright, (STRPTR) "Copyright",
    MSG_Description, (STRPTR) "Description",
    MSG_Cancel, (STRPTR) "_Cancel",
    MSG_Ok, (STRPTR) "_OK",
    MSG_ChoseFunction, (STRPTR) "Chose a function",
    MSG_MergeFile, (STRPTR) "Merge File",
    MSG_ComeBack, (STRPTR) "Go back to the main window to load !",
    MSG_ApplicationLost, (STRPTR) "You will lose all your application\n           if you continue.",
    MSG_AboutText, (STRPTR) "\033c\n%s\nwas written by\n\n\033bEric TOTEL\033n\n\nand released on %s\n\nThis program is Giftware\nAll rights reserved\n",
    MSG_Failed, (STRPTR) "Failed to create application !",
    MSG_Arguments, (STRPTR) "I keep only the first argument !",
    MSG_NeedWindows, (STRPTR) "You need windows in your application !!",
    MSG_NotEnoughMemory, (STRPTR) "Not Enough Memory Error !",
    MSG_SelectWindow, (STRPTR) "You must select a window first !",
    MSG_Confirm, (STRPTR) "Are you sure you want to do that ?",
    MSG_ConfirmExit, (STRPTR) "Really quit?",
    MSG_SelectObject, (STRPTR) "You must select an object first !",
    MSG_SelectTmpObject, (STRPTR) "You need to select an object in tmp !",
    MSG_RemoveRootGroup, (STRPTR) "You can't remove the group child !",
    MSG_QuitWindowAttributes, (STRPTR) "You need a title, a label, and groups !",
    MSG_NoChild, (STRPTR) "The Root group must have childs !",
    MSG_NothingToUndelete, (STRPTR) "There is nothing to undelete !",
    MSG_CantMoveRoot, (STRPTR) "You can't move root group !",
    MSG_NeedLabel, (STRPTR) "You need a label !",
    MSG_NeedLabelTitle, (STRPTR) "You need a label and a title",
    MSG_NeedImageLabel, (STRPTR) "You need to select an image and a label !",
    MSG_NeedBase, (STRPTR) "You Need to fill in the application 'BASE' argument !",
    MSG_NotBuilderSaveFile, (STRPTR) "It's NOT a MUIBuilder Save File !!!",
    MSG_WrongVersion, (STRPTR) "Unknown MUIBuilder save file : probably wrong version !",
    MSG_SelectEntry, (STRPTR) "You must select a list entry !",
    MSG_NeedLabelEntries, (STRPTR) "You need a label and list entries !",
    MSG_SeletNotifyLink, (STRPTR) "Select a notify link !",
    MSG_NotifyExists, (STRPTR) "Notification already exists !",
    MSG_SelectAction, (STRPTR) "Select an action please !",
    MSG_SelectEvent, (STRPTR) "Select an event please !",
    MSG_SelectNotifyLink, (STRPTR) "Select a notify link !",
    MSG_CantMovePopObjectChild, (STRPTR) "You can't move a PopObject Child !",
    MSG_CantDeletePopObjectChild, (STRPTR) "You can't delete a PopObject Child !",
    MSG_CopyNotImplemented, (STRPTR) "Internal Error\nThe copy of this object is not implemented",
    MSG_ErrorReading, (STRPTR) "Error occured while reading Modules directory",
    MSG_GroupError, (STRPTR) "Warning !!!\nThe group called\n%s\nshould have %d children\nand has %d.\nDon't forget to correct this error !!!\n",
    MSG_SelectMenuTitle, (STRPTR) "Select a menu title first !",
    MSG_SelectSubMenu, (STRPTR) "Select a submenu first !",
    MSG_GiveObjectAndLabel, (STRPTR) "Give an object and a label first !",
    MSG_AlreadyGenerated, (STRPTR) "This Label is already generated in the code !",
    MSG_SelectLabel, (STRPTR) "You must select a generated label first !",
    MSG_RectangleChoices, (STRPTR) "Rectangle Choices",
    MSG_Rectangle, (STRPTR) "Rectangle",
    MSG_HorizontalBar, (STRPTR) "Horizontal Bar",
    MSG_VerticalBar, (STRPTR) "Vertical Bar",
    MSG_Configuration, (STRPTR) "Preferences",
    MSG_ConfigChoices, (STRPTR) "Config Choices",
    MSG_GhostWindows, (STRPTR) "Ghost Windows",
    MSG_Icons, (STRPTR) "Icons",
    MSG_Requests, (STRPTR) "Requests",
    MSG_Editor, (STRPTR) "Editor",
    MSG_Save, (STRPTR) "_Save",
    MSG_EditorChoice, (STRPTR) "Editor Choice",
    MSG_TestLabel, (STRPTR) "Test",
    MSG_Depth, (STRPTR) "Depth",
    MSG_TreeChar, (STRPTR) "Tree Char",
    MSG_WrittenBy, (STRPTR) "Written by Eric Totel",
    MSG_Windows, (STRPTR) "Windows",
    MSG_Creation, (STRPTR) "Creation Control",
    MSG_Appli, (STRPTR) "_Application",
    MSG_NewWindow, (STRPTR) "New _Window",
    MSG_EditWindow, (STRPTR) "_Edit Window",
    MSG_Delete, (STRPTR) "_Delete",
    MSG_View, (STRPTR) "_View",
    MSG_Code, (STRPTR) "_Code",
    MSG_Guide, (STRPTR) "_Guide",
    MSG_Quit, (STRPTR) "_Quit",
    MSG_WindowAttributes, (STRPTR) "Window Attributes",
    MSG_WindowIdentification, (STRPTR) "Window Identification",
    MSG_Label, (STRPTR) "Label",
    MSG_AddChild, (STRPTR) "_Add Child",
    MSG_RemoveChild, (STRPTR) "_Remove",
    MSG_Up, (STRPTR) "_Up",
    MSG_Down, (STRPTR) "_Down",
    MSG_Tmp, (STRPTR) "Tmp",
    MSG_ToTmp, (STRPTR) "-_>Move",
    MSG_ToChild, (STRPTR) "_<-Move",
    MSG_RemoveTmp, (STRPTR) "Remo_ve",
    MSG_Test, (STRPTR) "_Test",
    MSG_EditObject, (STRPTR) "_Edit",
    MSG_Notify, (STRPTR) "_Notify",
    MSG_Menu, (STRPTR) "_Menu",
    MSG_Copy, (STRPTR) "->_Copy",
    MSG_CopyTmp, (STRPTR) "<-Co_py",
    MSG_OpenAtInit, (STRPTR) "Open at Init",
    MSG_AppWindow, (STRPTR) "AppWindow",
    MSG_Backdrop, (STRPTR) "BackDrop",
    MSG_Borderless, (STRPTR) "Borderless",
    MSG_CloseGadget, (STRPTR) "Close Gadget",
    MSG_DepthGadget, (STRPTR) "Depth Gadget",
    MSG_DragBar, (STRPTR) "Dragbar",
    MSG_SizeGadget, (STRPTR) "Size Gadget",
    MSG_GroupWindow, (STRPTR) "Group Choices",
    MSG_GroupAttributes, (STRPTR) "Group Attributes",
    MSG_HorizGroup, (STRPTR) "Horizontal Group",
    MSG_PageMode, (STRPTR) "Register Mode",
    MSG_SameHeight, (STRPTR) "Same Height",
    MSG_SameWidth, (STRPTR) "Same Width",
    MSG_SameSize, (STRPTR) "Same Size",
    MSG_VirtualGroup, (STRPTR) "Virtual Group",
    MSG_Columns, (STRPTR) "Columns",
    MSG_Rows, (STRPTR) "Rows",
    MSG_HorizSpacing, (STRPTR) "Horizontal Spacing",
    MSG_VertSpacing, (STRPTR) "Vertical Spacing",
    MSG_Register, (STRPTR) "Register",
    MSG_RegisterEntries, (STRPTR) "Register Entries",
    MSG_RowsColumns, (STRPTR) "Rows/Columns",
    MSG_Number, (STRPTR) "Number",
    MSG_Spacing, (STRPTR) "Spacing",
    MSG_Horizontal, (STRPTR) "Horizontal",
    MSG_Vertical, (STRPTR) "Vertical",
    MSG_GroupIdent, (STRPTR) "Group Identification",
    MSG_ObjectChoice, (STRPTR) "Object Choice",
    MSG_Group, (STRPTR) "_Group",
    MSG_KeyButton, (STRPTR) "_KeyButton",
    MSG_ListView, (STRPTR) "ListVie_w",
    MSG_DirList, (STRPTR) "_DirList",
    MSG_String, (STRPTR) "_String",
    MSG_LabelObj, (STRPTR) "Lab_el",
    MSG_Cycle, (STRPTR) "C_ycle",
    MSG_Radio, (STRPTR) "Radi_o",
    MSG_Image, (STRPTR) "I_mage",
    MSG_Space, (STRPTR) "Sp_ace",
    MSG_CheckMark, (STRPTR) "C_heckMark",
    MSG_Slider, (STRPTR) "Sl_ider",
    MSG_Gauge, (STRPTR) "Ga_uge",
    MSG_Scale, (STRPTR) "Sca_le",
    MSG_Text, (STRPTR) "_Text",
    MSG_Prop, (STRPTR) "P_rop",
    MSG_Bar, (STRPTR) "Recta_ngle",
    MSG_Colorfield, (STRPTR) "Color_field",
    MSG_PopAsl, (STRPTR) "_PopAsl",
    MSG_PopObject, (STRPTR) "PopOb_ject",
    MSG_LabelIdent, (STRPTR) "Label Identification",
    MSG_LabelChoice, (STRPTR) "Label Choice",
    MSG_Left, (STRPTR) "Left",
    MSG_Right, (STRPTR) "Right",
    MSG_Center, (STRPTR) "Center",
    MSG_StringChoice, (STRPTR) "String Choice",
    MSG_UseTitle, (STRPTR) "Use a title",
    MSG_SecretString, (STRPTR) "Secret String",
    MSG_IntegerString, (STRPTR) "Integer String",
    MSG_StringIdent, (STRPTR) "String Identification",
    MSG_Content, (STRPTR) "Content",
    MSG_Accept, (STRPTR) "Accept",
    MSG_Reject, (STRPTR) "Reject",
    MSG_MaxLen, (STRPTR) "MaxLength",
    MSG_ButtonChoices, (STRPTR) "Button Choices",
    MSG_ButtonIdent, (STRPTR) "Button Identification",
    MSG_ShortKey, (STRPTR) "Hot Key",
    MSG_CheckMarkChoice, (STRPTR) "CheckMark Choice",
    MSG_CheckMarkIdent, (STRPTR) "CheckMark Identification",
    MSG_InitialState, (STRPTR) "Initial State",
    MSG_CycleChoice, (STRPTR) "Cycle Choices",
    MSG_CycleEntries, (STRPTR) "Cycle Entries",
    MSG_New, (STRPTR) "_New",
    MSG_Remove, (STRPTR) "_Remove",
    MSG_Entry, (STRPTR) "Entry",
    MSG_RadioChoices, (STRPTR) "Radio Choices",
    MSG_RadioEntries, (STRPTR) "Radio Entries",
    MSG_SortbyName, (STRPTR) "Sort by Name",
    MSG_SortbyDate, (STRPTR) "Sort by Date",
    MSG_SortbySize, (STRPTR) "Sort by Size",
    MSG_ListDirChoices, (STRPTR) "ListDir Choices",
    MSG_Attributes, (STRPTR) "Attributes",
    MSG_DrawersOnly, (STRPTR) "Drawers Only",
    MSG_FilesOnly, (STRPTR) "Files Only",
    MSG_FilterDrawers, (STRPTR) "Filter Drawers",
    MSG_MultiSelection, (STRPTR) "Multi Selection",
    MSG_RejectIcons, (STRPTR) "Reject Icons",
    MSG_SortHighLow, (STRPTR) "Sort High-Low",
    MSG_SortType, (STRPTR) "Sort Type",
    MSG_Dir, (STRPTR) "Dir",
    MSG_SortDirs, (STRPTR) "Sort Dirs",
    MSG_DirsFirst, (STRPTR) "Dirs First",
    MSG_DirsLast, (STRPTR) "Dirs Last",
    MSG_DirsMixed, (STRPTR) "Dirs Mixed",
    MSG_GaugeChoices, (STRPTR) "Gauge Choices",
    MSG_Choices, (STRPTR) "Choices",
    MSG_HorizGauge, (STRPTR) "Horizontal Gauge",
    MSG_FixHeight, (STRPTR) "Fix Height",
    MSG_FixWidth, (STRPTR) "Fix Width",
    MSG_Divide, (STRPTR) "Divide",
    MSG_Maximum, (STRPTR) "Maximum",
    MSG_Height, (STRPTR) "Height",
    MSG_Width, (STRPTR) "Width",
    MSG_Infotext, (STRPTR) "Info Text",
    MSG_MultiplyDefinedLabel, (STRPTR) "\033c\0338Warning!\nThe following Labels are\nmultiply defined",
    MSG_MultiDefinitions, (STRPTR) "MultiDefinitions",
    MSG_CodeFileName, (STRPTR) "Code File Name",
    MSG_ObjectsLabels, (STRPTR) "Objects Labels",
    MSG_GeneratedLabels, (STRPTR) "Generated Labels",
    MSG_AppCode, (STRPTR) "App _Code",
    MSG_ObjectCode, (STRPTR) "_Object Code",
    MSG_RemoveLabel, (STRPTR) "_Remove Label",
    MSG_AddLabel, (STRPTR) "_Add Label",
    MSG_Options, (STRPTR) "Options",
    MSG_Declarations, (STRPTR) "Declarations",
    MSG_Environment, (STRPTR) "Environment",
    MSG_CodeOption, (STRPTR) "Code",
    MSG_NotificationsOption, (STRPTR) "Notifications",
    MSG_CatalogButton, (STRPTR) "Catalo_g",
    MSG_Catalog, (STRPTR) "Catalog",
    MSG_Locale, (STRPTR) "Locale",
    MSG_GetString, (STRPTR) "GetString",
    MSG_TextLength, (STRPTR) "\0338 Actually Text Length",
    MSG_NodeTitle, (STRPTR) "Node Title",
    MSG_EditNodeText, (STRPTR) "_Edit Node Text",
    MSG_CantOpen, (STRPTR) "Can't Open temporary file !",
    MSG_AmigaGuide, (STRPTR) "AmigaGuide",
    MSG_Objects, (STRPTR) "Objects",
    MSG_Edit, (STRPTR) "_Edit",
    MSG_Edit2, (STRPTR) "E_dit",
    MSG_Operations, (STRPTR) "Operations",
    MSG_AppNode, (STRPTR) "_App Node",
    MSG_WindowNode, (STRPTR) "Wind_ow Node",
    MSG_ObjectNode, (STRPTR) "O_bject Node",
    MSG_GenerateWholeDoc, (STRPTR) "Generate _Whole Doc",
    MSG_GenerateWinDoc, (STRPTR) "Generate W_in Doc",
    MSG_GenerateObjDoc, (STRPTR) "Generate Ob_j Doc",
    MSG_ViewDoc, (STRPTR) "_View Doc",
    MSG_AmigaguideDocName, (STRPTR) "AmigaGuide Doc Name",
    MSG_CantOpenAmigaGuide, (STRPTR) "Can't Open AmigaGuide File !",
    MSG_ImageChoice, (STRPTR) "Image Choice",
    MSG_FreeVertical, (STRPTR) "Free Vertical",
    MSG_FreeHorizontal, (STRPTR) "Free Horizontal",
    MSG_InputMode, (STRPTR) "Input Mode",
    MSG_Frame, (STRPTR) "Frame",
    MSG_Size, (STRPTR) "Size",
    MSG_ImageIdent, (STRPTR) "Image Identification",
    MSG_Images, (STRPTR) "Images",
    MSG_ListChoice, (STRPTR) "List Choice",
    MSG_ListType, (STRPTR) "List Type",
    MSG_ListIdent, (STRPTR) "List Identification",
    MSG_StandardList, (STRPTR) "Standard List",
    MSG_FloattextList, (STRPTR) "Floattext List",
    MSG_VolumeList, (STRPTR) "Volume List",
    MSG_NoEntry, (STRPTR) "No Entry",
    MSG_FirstEntry, (STRPTR) "First Entry",
    MSG_LastEntry, (STRPTR) "Last Entry",
    MSG_Strings, (STRPTR) "Strings",
    MSG_AdjustHeight, (STRPTR) "Adjust Height",
    MSG_AdjustWidth, (STRPTR) "Adjust Width",
    MSG_Activate, (STRPTR) "Activate",
    MSG_DisplayHook, (STRPTR) "Display Hook",
    MSG_ConstructHook, (STRPTR) "Construct Hook",
    MSG_DestructHook, (STRPTR) "Destruct Hook",
    MSG_CompareHook, (STRPTR) "Compare Hook",
    MSG_MultiTestHook, (STRPTR) "Multitest Hook",
    MSG_Format, (STRPTR) "Format",
    MSG_FloatText, (STRPTR) "Float Text",
    MSG_FileName, (STRPTR) "File Name",
    MSG_DoubleClick, (STRPTR) "Double Click",
    MSG_PropChoices, (STRPTR) "Prop Choices",
    MSG_HorizontalProp, (STRPTR) "Horizontal Prop",
    MSG_EntriesNumber, (STRPTR) "Entries Number",
    MSG_FirstNumber, (STRPTR) "First Number",
    MSG_VisibleNumber, (STRPTR) "Visible Number",
    MSG_ScaleTitle, (STRPTR) "Scale",
    MSG_Orientation, (STRPTR) "Orientation",
    MSG_SliderChoice, (STRPTR) "Slider Choice",
    MSG_Reverse, (STRPTR) "Reverse",
    MSG_SliderQuiet, (STRPTR) "Slider Quiet",
    MSG_UseTitleSlider, (STRPTR) "Use a title for slider",
    MSG_Minimum, (STRPTR) "Minimum",
    MSG_Init, (STRPTR) "Initialisation",
    MSG_SliderIdent, (STRPTR) "Slider Identification",
    MSG_TextAttributes, (STRPTR) "Text Attributes",
    MSG_TextSetMax, (STRPTR) "Text SetMax",
    MSG_TextSetMin, (STRPTR) "Text SetMin",
    MSG_Backgrounds, (STRPTR) "Backgrounds",
    MSG_TextContent, (STRPTR) "Text Content",
    MSG_Preparse, (STRPTR) "Preparse",
    MSG_TestWindow, (STRPTR) "Test Window",
    MSG_TestClick, (STRPTR) "_Click Here",
    MSG_FirstLine, (STRPTR) "First Line",
    MSG_SecondLine, (STRPTR) "Second Line",
    MSG_ThirdLine, (STRPTR) "Third Line",
    MSG_NotifyTitle, (STRPTR) "Notify",
    MSG_InternalError, (STRPTR) "Internal Error",
    MSG_ChoseIdent, (STRPTR) "Chose an indentifier",
    MSG_ChoseVariable, (STRPTR) "Chose a variable",
    MSG_Editing, (STRPTR) "\033cEditing : ",
    MSG_Events, (STRPTR) "Events",
    MSG_Actions, (STRPTR) "Actions",
    MSG_AddNotify, (STRPTR) "_Add Notify",
    MSG_RemoveNotify, (STRPTR) "_Remove Notify",
    MSG_AddToList, (STRPTR) "Add",
    MSG_RemoveFromList, (STRPTR) "_Remove",
    MSG_SelectIdentifier, (STRPTR) "Select an identifier first !",
    MSG_IdentifierExists, (STRPTR) "Identifier already exists !",
    MSG_GetConstant, (STRPTR) "Get Constant Value",
    MSG_IntegerConstant, (STRPTR) "Integer",
    MSG_BooleanConstant, (STRPTR) "Boolean",
    MSG_StringConstant, (STRPTR) "String",
    MSG_CharConstant, (STRPTR) "Char",
    MSG_Area, (STRPTR) "Area",
    MSG_Hide, (STRPTR) "Hide",
    MSG_Disable, (STRPTR) "Disable",
    MSG_PhantomFrame, (STRPTR) "Phantom Frame",
    MSG_Weight, (STRPTR) "Weight",
    MSG_Background, (STRPTR) "Background",
    MSG_ControlChar, (STRPTR) "Control Char",
    MSG_TitleFrame, (STRPTR) "Title Frame",
    MSG_PopUpImage, (STRPTR) "PopUp Image",
    MSG_PopFileImage, (STRPTR) "PopFile Image",
    MSG_PopDrawerImage, (STRPTR) "PopDrawer Image",
    MSG_FileRequester, (STRPTR) "File Requester",
    MSG_FontRequester, (STRPTR) "Font Requester",
    MSG_ScreenModeRequester, (STRPTR) "Screen Mode Requester",
    MSG_PopAslChoices, (STRPTR) "PopAsl Choices",
    MSG_RequesterType, (STRPTR) "Requester Type",
    MSG_CallHook, (STRPTR) "Call Hooks",
    MSG_StartHook, (STRPTR) "Start Hook",
    MSG_StopHook, (STRPTR) "Stop Hook",
    MSG_PopObjectChoices, (STRPTR) "PopObject Choices",
    MSG_Follow, (STRPTR) "Follow",
    MSG_Light, (STRPTR) "Light",
    MSG_Volatile, (STRPTR) "Volatile",
    MSG_Object, (STRPTR) "Object",
    MSG_OpenHook, (STRPTR) "Open Hook",
    MSG_CloseHook, (STRPTR) "Close Hook",
    MSG_ColorfieldChoices, (STRPTR) "Colorfield Choices",
    MSG_Indentification, (STRPTR) "Identification",
    MSG_MenuCreation, (STRPTR) "Menu Creation",
    MSG_EnableCheck, (STRPTR) "Enable Check",
    MSG_CheckState, (STRPTR) "Check State",
    MSG_Toggle, (STRPTR) "Toggle",
    MSG_ShortCut, (STRPTR) "Short Cut",
    MSG_Enable, (STRPTR) "Enable",
    MSG_NewTitle, (STRPTR) "New _Title",
    MSG_SubMenu, (STRPTR) "_SubMenu",
    MSG_MenuItem, (STRPTR) "Menu_Item",
    MSG_DeleteMenu, (STRPTR) "_Delete",
    MSG_Project, (STRPTR) "Project",
    MSG_Merge, (STRPTR) "M\0Merge",
    MSG_SaveMenu, (STRPTR) "S\0Save",
    MSG_QuitMenu, (STRPTR) "Q\0Quit",
    MSG_Fold, (STRPTR) "F\0Fold",
    MSG_Unfold, (STRPTR) "D\0Unfold",
    MSG_About, (STRPTR) "?\0About",
    MSG_Config, (STRPTR) "P\0Prefs",
    MSG_Undo, (STRPTR) "U\0Undelete",
    MSG_Load, (STRPTR) "O\0Open",
    MSG_NewMenu, (STRPTR) "N\0New",
    MSG_SaveAs, (STRPTR) "A\0SaveAs",
    MSG_EditMenu, (STRPTR) "Edit",
    MSG_Tree, (STRPTR) "Tree",
    MSG_CatalogPrepend, (STRPTR) "Prepend",
    MSG_HelpGenerated, (STRPTR) "Generated",
    MSG_NotifyHide, (STRPTR) "Hide",
    MSG_NotifyShow, (STRPTR) "Show",
    MSG_NotifyDisable, (STRPTR) "Disable",
    MSG_NotifyEnable, (STRPTR) "Enable",
    MSG_NotifyActivate, (STRPTR) "Activate",
    MSG_ReturnID, (STRPTR) "Return ID",
    MSG_ReturnQuit, (STRPTR) "Return Quit",
    MSG_ApplicationSleep, (STRPTR) "Application Sleep",
    MSG_ApplicationWake, (STRPTR) "Application Wake",
    MSG_CallFunction, (STRPTR) "Call function",
    MSG_Iconify, (STRPTR) "Iconify",
    MSG_UnIconify, (STRPTR) "Uniconify",
    MSG_Unactivate, (STRPTR) "Unactivate",
    MSG_OpenWindow, (STRPTR) "Open Window",
    MSG_CloseWindow, (STRPTR) "Close Window",
    MSG_Active, (STRPTR) "Active",
    MSG_CloseRequest, (STRPTR) "Close Request",
    MSG_Deactivate, (STRPTR) "Deactivate",
    MSG_PutTriggerValue, (STRPTR) "Put Trigger Value",
    MSG_PutConstantValue, (STRPTR) "Put Constant Value",
    MSG_PutVariableValue, (STRPTR) "Put Variable Value",
    MSG_PressButton, (STRPTR) "Press Button",
    MSG_ReleaseButton, (STRPTR) "Release Button",
    MSG_NotifyDisabled, (STRPTR) "Disabled",
    MSG_NotifyEnabled, (STRPTR) "Enabled",
    MSG_TimerAction, (STRPTR) "Timer Action",
    MSG_ChangePage, (STRPTR) "Change Page",
    MSG_Acknowlede, (STRPTR) "Acknowledge",
    MSG_ChangePosition, (STRPTR) "Change Position",
    MSG_ChangeContent, (STRPTR) "Change Content",
    MSG_ClearList, (STRPTR) "Clear List",
    MSG_JumpToPosition, (STRPTR) "JumpToPosition",
    MSG_RedrawAll, (STRPTR) "Redraw All",
    MSG_RedrawActive, (STRPTR) "Redraw Active",
    MSG_RemoveActive, (STRPTR) "Remove Active",
    MSG_SortList, (STRPTR) "Sort List",
    MSG_NotifyDoubleClick, (STRPTR) "Double Click",
    MSG_ChangeActive, (STRPTR) "Change Active",
    MSG_ChangeValue, (STRPTR) "Change Value",
    MSG_ActiveModified, (STRPTR) "Active Modified",
    MSG_Select, (STRPTR) "Select",
    MSG_Unselect, (STRPTR) "Unselect",
    MSG_SelectOn, (STRPTR) "Select ON",
    MSG_SelectOff, (STRPTR) "Select OFF",
    MSG_SelectChange, (STRPTR) "Select Change",
    MSG_PressImage, (STRPTR) "Press Image",
    MSG_ReleaseImage, (STRPTR) "Release Image",
    MSG_ChangedPosition, (STRPTR) "Changed Position",
    MSG_NotifyReverse, (STRPTR) "Reverse",
    MSG_ChangedText, (STRPTR) "Changed Text",
    MSG_ChangedEntriesNumber, (STRPTR) "Changed Entries Number",
    MSG_ChangedVisibleEntries, (STRPTR) "Changed Visible Entries",
    MSG_PutTriggerRed, (STRPTR) "Put Red Value (Trigger Value)",
    MSG_PutTriggerBlue, (STRPTR) "Put Blue Value (Trigger Value)",
    MSG_PutTriggerGreen, (STRPTR) "Put Green Value (Trigger Value)",
    MSG_PutConstantRed, (STRPTR) "Put Red Value (Constant Value)",
    MSG_PutConstantGreen, (STRPTR) "Put Green Value (Constant Value)",
    MSG_PutConstantBlue, (STRPTR) "Put Blue Value (Constant Value)",
    MSG_PutVariableRed, (STRPTR) "Put Red Value (Variable Value)",
    MSG_PutVariableGreen, (STRPTR) "Put Green Value (Variable Value)",
    MSG_PutVariableBlue, (STRPTR) "Put Blue Value (Variable Value)",
    MSG_ChangedRed, (STRPTR) "Changed Red Value",
    MSG_ChangedGreen, (STRPTR) "Changed Green Value",
    MSG_ChangedBlue, (STRPTR) "Changed Blue Value",
    MSG_ChangeTitleTrigger, (STRPTR) "Change Title (Trigger Value)",
    MSG_ChangeTitleVariable, (STRPTR) "Change Title (Variable Value)",
    MSG_ChangeTitleConstant, (STRPTR) "Change Title (Constant Value)",
    MSG_CheckMenuON, (STRPTR) "Check ON",
    MSG_CheckMenuOFF, (STRPTR) "Check OFF",
    MSG_CheckableON, (STRPTR) "Checkable ON",
    MSG_CheckableOFF, (STRPTR) "Checkable OFF",
    MSG_ChangeShortTrigger, (STRPTR) "Change Shortcut (Trigger Value)",
    MSG_ChangeShortVariable, (STRPTR) "Change Shortcut (Variable Value)",
    MSG_ChangeShortConstant, (STRPTR) "Change Shortcut (Constant Value)",
    MSG_ToggleFlagON, (STRPTR) "Toggle Flag ON",
    MSG_ToggleFlagOFF, (STRPTR) "Toggle Flag OFF",
    MSG_MenuTriggered, (STRPTR) "Menu Triggered",
    MSG_SpaceChoice, (STRPTR) "Space Choices",
    MSG_HorizontalVertical, (STRPTR) "Horizontal and Vertical",
    MSG_ActiveNoObj, (STRPTR) "Activate No Object",
    MSG_ActiveNextObj, (STRPTR) "Activate Next Object",
    MSG_ActivePrevObj, (STRPTR) "Activate Previous Object",
    MSG_CantFindImages, (STRPTR) "Unable to find Images !",
    MSG_GenerateSource, (STRPTR) "Generating Source",
    MSG_CodeGeneration, (STRPTR) "Generating Temporary files",
    MSG_Misc, (STRPTR) "Misc",
    MSG_ImageDrawer, (STRPTR) "Image Drawer",
    MSG_GenerateAllIDs, (STRPTR) "Generate All IDs",
    MSG_NoMenu, (STRPTR) "No Menu",
    MSG_NeedMouse, (STRPTR) "Needs Mouse",
};

static struct Catalog *MUIBuilder_Catalog = NULL;
static struct FC_Type *MUIBuilder_OwnCatalog = NULL;
static LONG MUIBuilder_OwnStrings;
static LONG MUIBuilder_OwnBytes;

void OpenMUIBuilderCatalog(struct Locale *loc, STRPTR language)
{ LONG tag, tagarg;
  //extern struct Library *LocaleBase;
  extern struct Library *IFFParseBase;

  CloseMUIBuilderCatalog();  /*  Not needed if the programmer pairs Open-()
			 and CloseCatalog() right, but does no harm. */
  if (language == NULL)
  { tag = TAG_IGNORE;
  }
  else
  { tag = OC_Language;
    tagarg = (LONG) language;
  }
  if (LocaleBase != NULL  &&  MUIBuilder_Catalog == NULL)
  { MUIBuilder_Catalog = OpenCatalog(loc, (STRPTR) "MUIBuilder.catalog",
			     OC_BuiltInLanguage, MUIBuilder_BuiltInLanguage,
			     tag, tagarg,
			     OC_Version, MUIBuilder_Version,
			     TAG_DONE);
  }
  if (LocaleBase == NULL  &&  IFFParseBase != NULL  &&  language != NULL  &&
      Stricmp(language, MUIBuilder_BuiltInLanguage) != 0)
  { struct IFFHandle *iffhandle;
    char path[128]; /*	Enough to hold 4 path items (dos.library 3.0)  */

    if ((iffhandle = AllocIFF())  !=  NULL)
    { /*  Trying to open the catalog  */
      strcpy(path, "Catalogs");
      AddPart((STRPTR) path, language, sizeof(path));
      AddPart((STRPTR) path, (STRPTR) "MUIBuilder.catalog", sizeof(path));
      if ((iffhandle->iff_Stream = Open((STRPTR) path, MODE_OLDFILE))
				 ==  NULL)
      { strcpy(path, "Locale:Catalogs");
	AddPart((STRPTR) path, language, sizeof(path));
	AddPart((STRPTR) path, (STRPTR) "MUIBuilder.catalog", sizeof(path));
	iffhandle->iff_Stream = Open((STRPTR) path, MODE_OLDFILE);
      }

      if (iffhandle->iff_Stream)
      { InitIFFasDOS(iffhandle);
	if (!OpenIFF(iffhandle, IFFF_READ))
	{ if (!PropChunk(iffhandle, MAKE_ID('C','T','L','G'),
			 MAKE_ID('S','T','R','S')))
	  { struct StoredProperty *sp;
	    int error;

	    for (;;)
	    { if ((error = ParseIFF(iffhandle, IFFPARSE_STEP))
			 ==  IFFERR_EOC)
	      { continue;
	      }
	      if (error != 0)
	      { break;
	      }

	      if (sp = FindProp(iffhandle, MAKE_ID('C','T','L','G'),
				MAKE_ID('S','T','R','S')))
	      { LONG *ptr;
		LONG BytesToScan, StrLength;

		/*  First scan: Check the number of strings		*/
		/*  Note that this assumes that the strings are padded	*/
		/*  to a longword boundary!				*/
		MUIBuilder_OwnBytes = 0;
		MUIBuilder_OwnStrings = 0;
		BytesToScan = sp->sp_Size;
		ptr = sp->sp_Data;
		while (BytesToScan > 0)
		{ ++MUIBuilder_OwnStrings;
		  ++ptr;		      /*  Skip ID		*/
		  StrLength = *ptr+1;	      /*  NUL-Byte!		*/
		  MUIBuilder_OwnBytes += StrLength;
		  ptr += 1+(StrLength+3)/4;   /*  Skip Length and String*/
		  BytesToScan -= 8+((StrLength+3)/4)*4;
		}

		/*  Marginal check: BytesToScan has to be 0!		*/
		if (BytesToScan == 0)
		{ char *cptr;
		  LONG i;

		  if (MUIBuilder_OwnCatalog = (struct FC_Type *)
		      AllocMem(MUIBuilder_OwnStrings*sizeof(struct FC_Type)+MUIBuilder_OwnBytes,
			       MEMF_ANY))
		  { /*	Second scan: Copy the strings and their ID's    */
		    cptr = (char *) &MUIBuilder_OwnCatalog[MUIBuilder_OwnStrings];
		    BytesToScan = sp->sp_Size;
		    ptr = sp->sp_Data;
		    i = 0;
		    while (BytesToScan > 0)
		    { MUIBuilder_OwnCatalog[i].ID = *(ptr++);
		      MUIBuilder_OwnCatalog[i].Str = (STRPTR) cptr;
		      StrLength = *ptr+1;     /*  NUL-Byte!		*/
		      ptr++;
		      strncpy(cptr, (char *) ptr, StrLength);
					/*  Not more, not less bytes!	*/
		      cptr+=StrLength;
		      ptr += (StrLength+3)/4;
		      BytesToScan -= 8+((StrLength+3)/4)*4;
		      ++i;
		    }
		    break;
		  }
		}
	      }
	    }
	  }
	  CloseIFF(iffhandle);
	}
	Close(iffhandle->iff_Stream);
      }

      FreeIFF(iffhandle);
    }
  }
}


void CloseMUIBuilderCatalog(void)
{ if (LocaleBase != NULL)
  { CloseCatalog(MUIBuilder_Catalog);
  }
  MUIBuilder_Catalog = NULL;
  if (MUIBuilder_OwnCatalog != NULL)
  { FreeMem(MUIBuilder_OwnCatalog,
	    MUIBuilder_OwnStrings*sizeof(struct FC_Type)+MUIBuilder_OwnBytes);
    MUIBuilder_OwnCatalog = NULL;
  }
}


STRPTR GetMUIBuilderString(LONG strnum)
{ STRPTR defaultstr = NULL;
  LONG i;

  for (i = 0;  i < sizeof(MUIBuilder_Array)/sizeof(struct FC_Type);  i++)
    { if (MUIBuilder_Array[i].ID == strnum)
      { defaultstr = MUIBuilder_Array[i].Str;
	break;
      }
    }
  if (MUIBuilder_Catalog == NULL)
  { if (MUIBuilder_OwnCatalog != NULL)
    { for (i = 0;  i < MUIBuilder_OwnStrings;  i++)
       { if (MUIBuilder_OwnCatalog[i].ID == strnum)
	 { return(MUIBuilder_OwnCatalog[i].Str);
	 }
       }
    }
    return(defaultstr);
  }
  return(GetCatalogStr(MUIBuilder_Catalog, strnum, defaultstr));
}
