#define MUIPP_NOINLINES
#define MUI_OBSOLETE
#include <libraries/mui.hpp>

Object * CMUI_Notify::ApplicationObject (void) const
{
	 return (Object *)GetAttr (MUIA_ApplicationObject);
}

struct AppMessage * CMUI_Notify::AppMessage (void) const
{
	 return (struct AppMessage *)GetAttr (MUIA_AppMessage);
}

LONG CMUI_Notify::HelpLine (void) const
{
	 return (LONG)GetAttr (MUIA_HelpLine);
}

void CMUI_Notify::SetHelpLine (LONG value)
{
	 SetAttr (MUIA_HelpLine, (ULONG)value);
}

STRPTR CMUI_Notify::HelpNode (void) const
{
	 return (STRPTR)GetAttr (MUIA_HelpNode);
}

void CMUI_Notify::SetHelpNode (STRPTR value)
{
	 SetAttr (MUIA_HelpNode, (ULONG)value);
}

void CMUI_Notify::SetNoNotify (BOOL value)
{
	 SetAttr (MUIA_NoNotify, (ULONG)value);
}

ULONG CMUI_Notify::ObjectID (void) const
{
	 return (ULONG)GetAttr (MUIA_ObjectID);
}

void CMUI_Notify::SetObjectID (ULONG value)
{
	 SetAttr (MUIA_ObjectID, (ULONG)value);
}

Object * CMUI_Notify::Parent (void) const
{
	 return (Object *)GetAttr (MUIA_Parent);
}

LONG CMUI_Notify::Revision (void) const
{
	 return (LONG)GetAttr (MUIA_Revision);
}

ULONG CMUI_Notify::UserData (void) const
{
	 return (ULONG)GetAttr (MUIA_UserData);
}

void CMUI_Notify::SetUserData (ULONG value)
{
	 SetAttr (MUIA_UserData, (ULONG)value);
}

LONG CMUI_Notify::Version (void) const
{
	 return (LONG)GetAttr (MUIA_Version);
}

ULONG CMUI_Notify::CallHook (StartVarArgs sva, struct Hook * Hook, ULONG param1, ...)
{
	sva.methodID = MUIM_CallHook;
	return DoMethodA ((Msg)&sva);
}

ULONG CMUI_Notify::Export (Object * dataspace)
{
	return DoMethod (MUIM_Export, dataspace);
}

ULONG CMUI_Notify::FindUData (ULONG udata)
{
	return DoMethod (MUIM_FindUData, udata);
}

ULONG CMUI_Notify::GetConfigItem (ULONG id, ULONG * storage)
{
	return DoMethod (MUIM_GetConfigItem, id, storage);
}

ULONG CMUI_Notify::GetUData (ULONG udata, ULONG attr, ULONG * storage)
{
	return DoMethod (MUIM_GetUData, udata, attr, storage);
}

ULONG CMUI_Notify::Import (Object * dataspace)
{
	return DoMethod (MUIM_Import, dataspace);
}

ULONG CMUI_Notify::KillNotify (ULONG TrigAttr)
{
	return DoMethod (MUIM_KillNotify, TrigAttr);
}

ULONG CMUI_Notify::KillNotifyObj (ULONG TrigAttr, Object * dest)
{
	return DoMethod (MUIM_KillNotifyObj, TrigAttr, dest);
}

ULONG CMUI_Notify::MultiSet (StartVarArgs sva, ULONG attr, ULONG val, APTR obj, ...)
{
	sva.methodID = MUIM_MultiSet;
	return DoMethodA ((Msg)&sva);
}

ULONG CMUI_Notify::NoNotifySet (StartVarArgs sva, ULONG attr, char * format, ULONG val, ...)
{
	sva.methodID = MUIM_NoNotifySet;
	return DoMethodA ((Msg)&sva);
}

ULONG CMUI_Notify::Notify (StartVarArgs sva, ULONG TrigAttr, ULONG TrigVal, APTR DestObj, ULONG FollowParams, ...)
{
	sva.methodID = MUIM_Notify;
	return DoMethodA ((Msg)&sva);
}

ULONG CMUI_Notify::Set (ULONG attr, ULONG val)
{
	return DoMethod (MUIM_Set, attr, val);
}

ULONG CMUI_Notify::SetAsString (StartVarArgs sva, ULONG attr, char * format, ULONG val, ...)
{
	sva.methodID = MUIM_SetAsString;
	return DoMethodA ((Msg)&sva);
}

ULONG CMUI_Notify::SetUData (ULONG udata, ULONG attr, ULONG val)
{
	return DoMethod (MUIM_SetUData, udata, attr, val);
}

ULONG CMUI_Notify::SetUDataOnce (ULONG udata, ULONG attr, ULONG val)
{
	return DoMethod (MUIM_SetUDataOnce, udata, attr, val);
}

ULONG CMUI_Notify::WriteLong (ULONG val, ULONG * memory)
{
	return DoMethod (MUIM_WriteLong, val, memory);
}

ULONG CMUI_Notify::WriteString (char * str, char * memory)
{
	return DoMethod (MUIM_WriteString, str, memory);
}

struct MinList * CMUI_Family::List (void) const
{
	 return (struct MinList *)GetAttr (MUIA_Family_List);
}

ULONG CMUI_Family::AddHead (Object * obj)
{
	return DoMethod (MUIM_Family_AddHead, obj);
}

ULONG CMUI_Family::AddTail (Object * obj)
{
	return DoMethod (MUIM_Family_AddTail, obj);
}

ULONG CMUI_Family::Insert (Object * obj, Object * pred)
{
	return DoMethod (MUIM_Family_Insert, obj, pred);
}

ULONG CMUI_Family::Remove (Object * obj)
{
	return DoMethod (MUIM_Family_Remove, obj);
}

ULONG CMUI_Family::Sort (StartVarArgs sva, Object * obj, ...)
{
	sva.methodID = MUIM_Family_Sort;
	return DoMethodA ((Msg)&sva);
}

ULONG CMUI_Family::Transfer (Object * family)
{
	return DoMethod (MUIM_Family_Transfer, family);
}

BOOL CMUI_Menustrip::Enabled (void) const
{
	 return (BOOL)GetAttr (MUIA_Menustrip_Enabled);
}

void CMUI_Menustrip::SetEnabled (BOOL value)
{
	 SetAttr (MUIA_Menustrip_Enabled, (ULONG)value);
}

BOOL CMUI_Menu::Enabled (void) const
{
	 return (BOOL)GetAttr (MUIA_Menu_Enabled);
}

void CMUI_Menu::SetEnabled (BOOL value)
{
	 SetAttr (MUIA_Menu_Enabled, (ULONG)value);
}

STRPTR CMUI_Menu::Title (void) const
{
	 return (STRPTR)GetAttr (MUIA_Menu_Title);
}

void CMUI_Menu::SetTitle (STRPTR value)
{
	 SetAttr (MUIA_Menu_Title, (ULONG)value);
}

BOOL CMUI_Menuitem::Checked (void) const
{
	 return (BOOL)GetAttr (MUIA_Menuitem_Checked);
}

void CMUI_Menuitem::SetChecked (BOOL value)
{
	 SetAttr (MUIA_Menuitem_Checked, (ULONG)value);
}

BOOL CMUI_Menuitem::Checkit (void) const
{
	 return (BOOL)GetAttr (MUIA_Menuitem_Checkit);
}

void CMUI_Menuitem::SetCheckit (BOOL value)
{
	 SetAttr (MUIA_Menuitem_Checkit, (ULONG)value);
}

BOOL CMUI_Menuitem::CommandString (void) const
{
	 return (BOOL)GetAttr (MUIA_Menuitem_CommandString);
}

void CMUI_Menuitem::SetCommandString (BOOL value)
{
	 SetAttr (MUIA_Menuitem_CommandString, (ULONG)value);
}

BOOL CMUI_Menuitem::Enabled (void) const
{
	 return (BOOL)GetAttr (MUIA_Menuitem_Enabled);
}

void CMUI_Menuitem::SetEnabled (BOOL value)
{
	 SetAttr (MUIA_Menuitem_Enabled, (ULONG)value);
}

LONG CMUI_Menuitem::Exclude (void) const
{
	 return (LONG)GetAttr (MUIA_Menuitem_Exclude);
}

void CMUI_Menuitem::SetExclude (LONG value)
{
	 SetAttr (MUIA_Menuitem_Exclude, (ULONG)value);
}

STRPTR CMUI_Menuitem::Shortcut (void) const
{
	 return (STRPTR)GetAttr (MUIA_Menuitem_Shortcut);
}

void CMUI_Menuitem::SetShortcut (STRPTR value)
{
	 SetAttr (MUIA_Menuitem_Shortcut, (ULONG)value);
}

STRPTR CMUI_Menuitem::Title (void) const
{
	 return (STRPTR)GetAttr (MUIA_Menuitem_Title);
}

void CMUI_Menuitem::SetTitle (STRPTR value)
{
	 SetAttr (MUIA_Menuitem_Title, (ULONG)value);
}

BOOL CMUI_Menuitem::Toggle (void) const
{
	 return (BOOL)GetAttr (MUIA_Menuitem_Toggle);
}

void CMUI_Menuitem::SetToggle (BOOL value)
{
	 SetAttr (MUIA_Menuitem_Toggle, (ULONG)value);
}

struct MenuItem * CMUI_Menuitem::Trigger (void) const
{
	 return (struct MenuItem *)GetAttr (MUIA_Menuitem_Trigger);
}

BOOL CMUI_Application::Active (void) const
{
	 return (BOOL)GetAttr (MUIA_Application_Active);
}

void CMUI_Application::SetActive (BOOL value)
{
	 SetAttr (MUIA_Application_Active, (ULONG)value);
}

STRPTR CMUI_Application::Author (void) const
{
	 return (STRPTR)GetAttr (MUIA_Application_Author);
}

STRPTR CMUI_Application::Base (void) const
{
	 return (STRPTR)GetAttr (MUIA_Application_Base);
}

CxObj * CMUI_Application::Broker (void) const
{
	 return (CxObj *)GetAttr (MUIA_Application_Broker);
}

struct Hook * CMUI_Application::BrokerHook (void) const
{
	 return (struct Hook *)GetAttr (MUIA_Application_BrokerHook);
}

void CMUI_Application::SetBrokerHook (struct Hook * value)
{
	 SetAttr (MUIA_Application_BrokerHook, (ULONG)value);
}

struct MsgPort * CMUI_Application::BrokerPort (void) const
{
	 return (struct MsgPort *)GetAttr (MUIA_Application_BrokerPort);
}

LONG CMUI_Application::BrokerPri (void) const
{
	 return (LONG)GetAttr (MUIA_Application_BrokerPri);
}

struct MUI_Command * CMUI_Application::Commands (void) const
{
	 return (struct MUI_Command *)GetAttr (MUIA_Application_Commands);
}

void CMUI_Application::SetCommands (struct MUI_Command * value)
{
	 SetAttr (MUIA_Application_Commands, (ULONG)value);
}

STRPTR CMUI_Application::Copyright (void) const
{
	 return (STRPTR)GetAttr (MUIA_Application_Copyright);
}

STRPTR CMUI_Application::Description (void) const
{
	 return (STRPTR)GetAttr (MUIA_Application_Description);
}

struct DiskObject * CMUI_Application::DiskObject (void) const
{
	 return (struct DiskObject *)GetAttr (MUIA_Application_DiskObject);
}

void CMUI_Application::SetDiskObject (struct DiskObject * value)
{
	 SetAttr (MUIA_Application_DiskObject, (ULONG)value);
}

BOOL CMUI_Application::DoubleStart (void) const
{
	 return (BOOL)GetAttr (MUIA_Application_DoubleStart);
}

void CMUI_Application::SetDropObject (Object * value)
{
	 SetAttr (MUIA_Application_DropObject, (ULONG)value);
}

BOOL CMUI_Application::ForceQuit (void) const
{
	 return (BOOL)GetAttr (MUIA_Application_ForceQuit);
}

STRPTR CMUI_Application::HelpFile (void) const
{
	 return (STRPTR)GetAttr (MUIA_Application_HelpFile);
}

void CMUI_Application::SetHelpFile (STRPTR value)
{
	 SetAttr (MUIA_Application_HelpFile, (ULONG)value);
}

BOOL CMUI_Application::Iconified (void) const
{
	 return (BOOL)GetAttr (MUIA_Application_Iconified);
}

void CMUI_Application::SetIconified (BOOL value)
{
	 SetAttr (MUIA_Application_Iconified, (ULONG)value);
}

struct NewMenu * CMUI_Application::Menu (void) const
{
	 return (struct NewMenu *)GetAttr (MUIA_Application_Menu);
}

ULONG CMUI_Application::MenuAction (void) const
{
	 return (ULONG)GetAttr (MUIA_Application_MenuAction);
}

ULONG CMUI_Application::MenuHelp (void) const
{
	 return (ULONG)GetAttr (MUIA_Application_MenuHelp);
}

struct Hook * CMUI_Application::RexxHook (void) const
{
	 return (struct Hook *)GetAttr (MUIA_Application_RexxHook);
}

void CMUI_Application::SetRexxHook (struct Hook * value)
{
	 SetAttr (MUIA_Application_RexxHook, (ULONG)value);
}

struct RxMsg * CMUI_Application::RexxMsg (void) const
{
	 return (struct RxMsg *)GetAttr (MUIA_Application_RexxMsg);
}

void CMUI_Application::SetRexxString (STRPTR value)
{
	 SetAttr (MUIA_Application_RexxString, (ULONG)value);
}

void CMUI_Application::SetSleep (BOOL value)
{
	 SetAttr (MUIA_Application_Sleep, (ULONG)value);
}

STRPTR CMUI_Application::Title (void) const
{
	 return (STRPTR)GetAttr (MUIA_Application_Title);
}

STRPTR CMUI_Application::Version (void) const
{
	 return (STRPTR)GetAttr (MUIA_Application_Version);
}

struct List * CMUI_Application::WindowList (void) const
{
	 return (struct List *)GetAttr (MUIA_Application_WindowList);
}

ULONG CMUI_Application::AboutMUI (Object * refwindow)
{
	return DoMethod (MUIM_Application_AboutMUI, refwindow);
}

ULONG CMUI_Application::AddInputHandler (struct MUI_InputHandlerNode * ihnode)
{
	return DoMethod (MUIM_Application_AddInputHandler, ihnode);
}

ULONG CMUI_Application::CheckRefresh (void)
{
	return DoMethod (MUIM_Application_CheckRefresh);
}

ULONG CMUI_Application::GetMenuCheck (ULONG MenuID)
{
	return DoMethod (MUIM_Application_GetMenuCheck, MenuID);
}

ULONG CMUI_Application::GetMenuState (ULONG MenuID)
{
	return DoMethod (MUIM_Application_GetMenuState, MenuID);
}

ULONG CMUI_Application::Input (LONGBITS * signal)
{
	return DoMethod (MUIM_Application_Input, signal);
}

ULONG CMUI_Application::InputBuffered (void)
{
	return DoMethod (MUIM_Application_InputBuffered);
}

ULONG CMUI_Application::Load (STRPTR name)
{
	return DoMethod (MUIM_Application_Load, name);
}

ULONG CMUI_Application::NewInput (LONGBITS * signal)
{
	return DoMethod (MUIM_Application_NewInput, signal);
}

ULONG CMUI_Application::OpenConfigWindow (ULONG flags)
{
	return DoMethod (MUIM_Application_OpenConfigWindow, flags);
}

ULONG CMUI_Application::PushMethod (StartVarArgs sva, Object * dest, LONG count, ...)
{
	sva.methodID = MUIM_Application_PushMethod;
	return DoMethodA ((Msg)&sva);
}

ULONG CMUI_Application::RemInputHandler (struct MUI_InputHandlerNode * ihnode)
{
	return DoMethod (MUIM_Application_RemInputHandler, ihnode);
}

ULONG CMUI_Application::ReturnID (ULONG retid)
{
	return DoMethod (MUIM_Application_ReturnID, retid);
}

ULONG CMUI_Application::Save (STRPTR name)
{
	return DoMethod (MUIM_Application_Save, name);
}

ULONG CMUI_Application::SetConfigItem (ULONG item, APTR data)
{
	return DoMethod (MUIM_Application_SetConfigItem, item, data);
}

ULONG CMUI_Application::SetMenuCheck (ULONG MenuID, LONG stat)
{
	return DoMethod (MUIM_Application_SetMenuCheck, MenuID, stat);
}

ULONG CMUI_Application::SetMenuState (ULONG MenuID, LONG stat)
{
	return DoMethod (MUIM_Application_SetMenuState, MenuID, stat);
}

ULONG CMUI_Application::ShowHelp (Object * window, char * name, char * node, LONG line)
{
	return DoMethod (MUIM_Application_ShowHelp, window, name, node, line);
}

BOOL CMUI_Window::Activate (void) const
{
	 return (BOOL)GetAttr (MUIA_Window_Activate);
}

void CMUI_Window::SetActivate (BOOL value)
{
	 SetAttr (MUIA_Window_Activate, (ULONG)value);
}

Object * CMUI_Window::ActiveObject (void) const
{
	 return (Object *)GetAttr (MUIA_Window_ActiveObject);
}

void CMUI_Window::SetActiveObject (Object * value)
{
	 SetAttr (MUIA_Window_ActiveObject, (ULONG)value);
}

LONG CMUI_Window::AltHeight (void) const
{
	 return (LONG)GetAttr (MUIA_Window_AltHeight);
}

LONG CMUI_Window::AltLeftEdge (void) const
{
	 return (LONG)GetAttr (MUIA_Window_AltLeftEdge);
}

LONG CMUI_Window::AltTopEdge (void) const
{
	 return (LONG)GetAttr (MUIA_Window_AltTopEdge);
}

LONG CMUI_Window::AltWidth (void) const
{
	 return (LONG)GetAttr (MUIA_Window_AltWidth);
}

BOOL CMUI_Window::CloseRequest (void) const
{
	 return (BOOL)GetAttr (MUIA_Window_CloseRequest);
}

Object * CMUI_Window::DefaultObject (void) const
{
	 return (Object *)GetAttr (MUIA_Window_DefaultObject);
}

void CMUI_Window::SetDefaultObject (Object * value)
{
	 SetAttr (MUIA_Window_DefaultObject, (ULONG)value);
}

BOOL CMUI_Window::FancyDrawing (void) const
{
	 return (BOOL)GetAttr (MUIA_Window_FancyDrawing);
}

void CMUI_Window::SetFancyDrawing (BOOL value)
{
	 SetAttr (MUIA_Window_FancyDrawing, (ULONG)value);
}

LONG CMUI_Window::Height (void) const
{
	 return (LONG)GetAttr (MUIA_Window_Height);
}

ULONG CMUI_Window::ID (void) const
{
	 return (ULONG)GetAttr (MUIA_Window_ID);
}

void CMUI_Window::SetID (ULONG value)
{
	 SetAttr (MUIA_Window_ID, (ULONG)value);
}

struct InputEvent * CMUI_Window::InputEvent (void) const
{
	 return (struct InputEvent *)GetAttr (MUIA_Window_InputEvent);
}

BOOL CMUI_Window::IsSubWindow (void) const
{
	 return (BOOL)GetAttr (MUIA_Window_IsSubWindow);
}

void CMUI_Window::SetIsSubWindow (BOOL value)
{
	 SetAttr (MUIA_Window_IsSubWindow, (ULONG)value);
}

LONG CMUI_Window::LeftEdge (void) const
{
	 return (LONG)GetAttr (MUIA_Window_LeftEdge);
}

ULONG CMUI_Window::MenuAction (void) const
{
	 return (ULONG)GetAttr (MUIA_Window_MenuAction);
}

void CMUI_Window::SetMenuAction (ULONG value)
{
	 SetAttr (MUIA_Window_MenuAction, (ULONG)value);
}

Object * CMUI_Window::Menustrip (void) const
{
	 return (Object *)GetAttr (MUIA_Window_Menustrip);
}

Object * CMUI_Window::MouseObject (void) const
{
	 return (Object *)GetAttr (MUIA_Window_MouseObject);
}

void CMUI_Window::SetNoMenus (BOOL value)
{
	 SetAttr (MUIA_Window_NoMenus, (ULONG)value);
}

BOOL CMUI_Window::Open (void) const
{
	 return (BOOL)GetAttr (MUIA_Window_Open);
}

void CMUI_Window::SetOpen (BOOL value)
{
	 SetAttr (MUIA_Window_Open, (ULONG)value);
}

STRPTR CMUI_Window::PublicScreen (void) const
{
	 return (STRPTR)GetAttr (MUIA_Window_PublicScreen);
}

void CMUI_Window::SetPublicScreen (STRPTR value)
{
	 SetAttr (MUIA_Window_PublicScreen, (ULONG)value);
}

void CMUI_Window::SetRefWindow (Object * value)
{
	 SetAttr (MUIA_Window_RefWindow, (ULONG)value);
}

Object * CMUI_Window::RootObject (void) const
{
	 return (Object *)GetAttr (MUIA_Window_RootObject);
}

void CMUI_Window::SetRootObject (Object * value)
{
	 SetAttr (MUIA_Window_RootObject, (ULONG)value);
}

struct Screen * CMUI_Window::Screen (void) const
{
	 return (struct Screen *)GetAttr (MUIA_Window_Screen);
}

void CMUI_Window::SetScreen (struct Screen * value)
{
	 SetAttr (MUIA_Window_Screen, (ULONG)value);
}

STRPTR CMUI_Window::ScreenTitle (void) const
{
	 return (STRPTR)GetAttr (MUIA_Window_ScreenTitle);
}

void CMUI_Window::SetScreenTitle (STRPTR value)
{
	 SetAttr (MUIA_Window_ScreenTitle, (ULONG)value);
}

BOOL CMUI_Window::Sleep (void) const
{
	 return (BOOL)GetAttr (MUIA_Window_Sleep);
}

void CMUI_Window::SetSleep (BOOL value)
{
	 SetAttr (MUIA_Window_Sleep, (ULONG)value);
}

STRPTR CMUI_Window::Title (void) const
{
	 return (STRPTR)GetAttr (MUIA_Window_Title);
}

void CMUI_Window::SetTitle (STRPTR value)
{
	 SetAttr (MUIA_Window_Title, (ULONG)value);
}

LONG CMUI_Window::TopEdge (void) const
{
	 return (LONG)GetAttr (MUIA_Window_TopEdge);
}

BOOL CMUI_Window::UseBottomBorderScroller (void) const
{
	 return (BOOL)GetAttr (MUIA_Window_UseBottomBorderScroller);
}

void CMUI_Window::SetUseBottomBorderScroller (BOOL value)
{
	 SetAttr (MUIA_Window_UseBottomBorderScroller, (ULONG)value);
}

BOOL CMUI_Window::UseLeftBorderScroller (void) const
{
	 return (BOOL)GetAttr (MUIA_Window_UseLeftBorderScroller);
}

void CMUI_Window::SetUseLeftBorderScroller (BOOL value)
{
	 SetAttr (MUIA_Window_UseLeftBorderScroller, (ULONG)value);
}

BOOL CMUI_Window::UseRightBorderScroller (void) const
{
	 return (BOOL)GetAttr (MUIA_Window_UseRightBorderScroller);
}

void CMUI_Window::SetUseRightBorderScroller (BOOL value)
{
	 SetAttr (MUIA_Window_UseRightBorderScroller, (ULONG)value);
}

LONG CMUI_Window::Width (void) const
{
	 return (LONG)GetAttr (MUIA_Window_Width);
}

struct Window * CMUI_Window::Window (void) const
{
	 return (struct Window *)GetAttr (MUIA_Window_Window);
}

ULONG CMUI_Window::AddEventHandler (struct MUI_EventHandlerNode * ehnode)
{
	return DoMethod (MUIM_Window_AddEventHandler, ehnode);
}

ULONG CMUI_Window::GetMenuCheck (ULONG MenuID)
{
	return DoMethod (MUIM_Window_GetMenuCheck, MenuID);
}

ULONG CMUI_Window::GetMenuState (ULONG MenuID)
{
	return DoMethod (MUIM_Window_GetMenuState, MenuID);
}

ULONG CMUI_Window::RemEventHandler (struct MUI_EventHandlerNode * ehnode)
{
	return DoMethod (MUIM_Window_RemEventHandler, ehnode);
}

ULONG CMUI_Window::ScreenToBack (void)
{
	return DoMethod (MUIM_Window_ScreenToBack);
}

ULONG CMUI_Window::ScreenToFront (void)
{
	return DoMethod (MUIM_Window_ScreenToFront);
}

ULONG CMUI_Window::SetCycleChain (StartVarArgs sva, Object * obj, ...)
{
	sva.methodID = MUIM_Window_SetCycleChain;
	return DoMethodA ((Msg)&sva);
}

ULONG CMUI_Window::SetMenuCheck (ULONG MenuID, LONG stat)
{
	return DoMethod (MUIM_Window_SetMenuCheck, MenuID, stat);
}

ULONG CMUI_Window::SetMenuState (ULONG MenuID, LONG stat)
{
	return DoMethod (MUIM_Window_SetMenuState, MenuID, stat);
}

ULONG CMUI_Window::Snapshot (LONG flags)
{
	return DoMethod (MUIM_Window_Snapshot, flags);
}

ULONG CMUI_Window::ToBack (void)
{
	return DoMethod (MUIM_Window_ToBack);
}

ULONG CMUI_Window::ToFront (void)
{
	return DoMethod (MUIM_Window_ToFront);
}

void CMUI_Area::SetBackground (LONG value)
{
	 SetAttr (MUIA_Background, (ULONG)value);
}

LONG CMUI_Area::BottomEdge (void) const
{
	 return (LONG)GetAttr (MUIA_BottomEdge);
}

Object * CMUI_Area::ContextMenu (void) const
{
	 return (Object *)GetAttr (MUIA_ContextMenu);
}

void CMUI_Area::SetContextMenu (Object * value)
{
	 SetAttr (MUIA_ContextMenu, (ULONG)value);
}

Object * CMUI_Area::ContextMenuTrigger (void) const
{
	 return (Object *)GetAttr (MUIA_ContextMenuTrigger);
}

char CMUI_Area::ControlChar (void) const
{
	 return (char)GetAttr (MUIA_ControlChar);
}

void CMUI_Area::SetControlChar (char value)
{
	 SetAttr (MUIA_ControlChar, (ULONG)value);
}

LONG CMUI_Area::CycleChain (void) const
{
	 return (LONG)GetAttr (MUIA_CycleChain);
}

void CMUI_Area::SetCycleChain (LONG value)
{
	 SetAttr (MUIA_CycleChain, (ULONG)value);
}

BOOL CMUI_Area::Disabled (void) const
{
	 return (BOOL)GetAttr (MUIA_Disabled);
}

void CMUI_Area::SetDisabled (BOOL value)
{
	 SetAttr (MUIA_Disabled, (ULONG)value);
}

BOOL CMUI_Area::Draggable (void) const
{
	 return (BOOL)GetAttr (MUIA_Draggable);
}

void CMUI_Area::SetDraggable (BOOL value)
{
	 SetAttr (MUIA_Draggable, (ULONG)value);
}

BOOL CMUI_Area::Dropable (void) const
{
	 return (BOOL)GetAttr (MUIA_Dropable);
}

void CMUI_Area::SetDropable (BOOL value)
{
	 SetAttr (MUIA_Dropable, (ULONG)value);
}

ULONG CMUI_Area::ExportID (void) const
{
	 return (ULONG)GetAttr (MUIA_ExportID);
}

void CMUI_Area::SetExportID (ULONG value)
{
	 SetAttr (MUIA_ExportID, (ULONG)value);
}

void CMUI_Area::SetFillArea (BOOL value)
{
	 SetAttr (MUIA_FillArea, (ULONG)value);
}

struct TextFont * CMUI_Area::Font (void) const
{
	 return (struct TextFont *)GetAttr (MUIA_Font);
}

LONG CMUI_Area::Height (void) const
{
	 return (LONG)GetAttr (MUIA_Height);
}

LONG CMUI_Area::HorizDisappear (void) const
{
	 return (LONG)GetAttr (MUIA_HorizDisappear);
}

void CMUI_Area::SetHorizDisappear (LONG value)
{
	 SetAttr (MUIA_HorizDisappear, (ULONG)value);
}

WORD CMUI_Area::HorizWeight (void) const
{
	 return (WORD)GetAttr (MUIA_HorizWeight);
}

void CMUI_Area::SetHorizWeight (WORD value)
{
	 SetAttr (MUIA_HorizWeight, (ULONG)value);
}

LONG CMUI_Area::InnerBottom (void) const
{
	 return (LONG)GetAttr (MUIA_InnerBottom);
}

LONG CMUI_Area::InnerLeft (void) const
{
	 return (LONG)GetAttr (MUIA_InnerLeft);
}

LONG CMUI_Area::InnerRight (void) const
{
	 return (LONG)GetAttr (MUIA_InnerRight);
}

LONG CMUI_Area::InnerTop (void) const
{
	 return (LONG)GetAttr (MUIA_InnerTop);
}

LONG CMUI_Area::LeftEdge (void) const
{
	 return (LONG)GetAttr (MUIA_LeftEdge);
}

BOOL CMUI_Area::Pressed (void) const
{
	 return (BOOL)GetAttr (MUIA_Pressed);
}

LONG CMUI_Area::RightEdge (void) const
{
	 return (LONG)GetAttr (MUIA_RightEdge);
}

BOOL CMUI_Area::Selected (void) const
{
	 return (BOOL)GetAttr (MUIA_Selected);
}

void CMUI_Area::SetSelected (BOOL value)
{
	 SetAttr (MUIA_Selected, (ULONG)value);
}

STRPTR CMUI_Area::ShortHelp (void) const
{
	 return (STRPTR)GetAttr (MUIA_ShortHelp);
}

void CMUI_Area::SetShortHelp (STRPTR value)
{
	 SetAttr (MUIA_ShortHelp, (ULONG)value);
}

BOOL CMUI_Area::ShowMe (void) const
{
	 return (BOOL)GetAttr (MUIA_ShowMe);
}

void CMUI_Area::SetShowMe (BOOL value)
{
	 SetAttr (MUIA_ShowMe, (ULONG)value);
}

LONG CMUI_Area::Timer (void) const
{
	 return (LONG)GetAttr (MUIA_Timer);
}

LONG CMUI_Area::TopEdge (void) const
{
	 return (LONG)GetAttr (MUIA_TopEdge);
}

LONG CMUI_Area::VertDisappear (void) const
{
	 return (LONG)GetAttr (MUIA_VertDisappear);
}

void CMUI_Area::SetVertDisappear (LONG value)
{
	 SetAttr (MUIA_VertDisappear, (ULONG)value);
}

WORD CMUI_Area::VertWeight (void) const
{
	 return (WORD)GetAttr (MUIA_VertWeight);
}

void CMUI_Area::SetVertWeight (WORD value)
{
	 SetAttr (MUIA_VertWeight, (ULONG)value);
}

LONG CMUI_Area::Width (void) const
{
	 return (LONG)GetAttr (MUIA_Width);
}

struct Window * CMUI_Area::Window (void) const
{
	 return (struct Window *)GetAttr (MUIA_Window);
}

Object * CMUI_Area::WindowObject (void) const
{
	 return (Object *)GetAttr (MUIA_WindowObject);
}

ULONG CMUI_Area::AskMinMax (struct MUI_MinMax * MinMaxInfo)
{
	return DoMethod (MUIM_AskMinMax, MinMaxInfo);
}

ULONG CMUI_Area::Cleanup (void)
{
	return DoMethod (MUIM_Cleanup);
}

ULONG CMUI_Area::ContextMenuBuild (LONG mx, LONG my)
{
	return DoMethod (MUIM_ContextMenuBuild, mx, my);
}

ULONG CMUI_Area::ContextMenuChoice (Object * item)
{
	return DoMethod (MUIM_ContextMenuChoice, item);
}

ULONG CMUI_Area::CreateBubble (LONG x, LONG y, char * txt, ULONG flags)
{
	return DoMethod (MUIM_CreateBubble, x, y, txt, flags);
}

ULONG CMUI_Area::CreateShortHelp (LONG mx, LONG my)
{
	return DoMethod (MUIM_CreateShortHelp, mx, my);
}

ULONG CMUI_Area::DeleteBubble (APTR bubble)
{
	return DoMethod (MUIM_DeleteBubble, bubble);
}

ULONG CMUI_Area::DeleteShortHelp (STRPTR help)
{
	return DoMethod (MUIM_DeleteShortHelp, help);
}

ULONG CMUI_Area::DragBegin (Object * obj)
{
	return DoMethod (MUIM_DragBegin, obj);
}

ULONG CMUI_Area::DragDrop (Object * obj, LONG x, LONG y)
{
	return DoMethod (MUIM_DragDrop, obj, x, y);
}

ULONG CMUI_Area::DragFinish (Object * obj)
{
	return DoMethod (MUIM_DragFinish, obj);
}

ULONG CMUI_Area::DragQuery (Object * obj)
{
	return DoMethod (MUIM_DragQuery, obj);
}

ULONG CMUI_Area::DragReport (Object * obj, LONG x, LONG y, LONG update)
{
	return DoMethod (MUIM_DragReport, obj, x, y, update);
}

ULONG CMUI_Area::Draw (ULONG flags)
{
	return DoMethod (MUIM_Draw, flags);
}

ULONG CMUI_Area::DrawBackground (LONG left, LONG top, LONG width, LONG height, LONG xoffset, LONG yoffset, LONG flags)
{
	return DoMethod (MUIM_DrawBackground, left, top, width, height, xoffset, yoffset, flags);
}

ULONG CMUI_Area::HandleEvent (struct IntuiMessage * imsg, LONG muikey)
{
	return DoMethod (MUIM_HandleEvent, imsg, muikey);
}

ULONG CMUI_Area::HandleInput (struct IntuiMessage * imsg, LONG muikey)
{
	return DoMethod (MUIM_HandleInput, imsg, muikey);
}

ULONG CMUI_Area::Hide (void)
{
	return DoMethod (MUIM_Hide);
}

ULONG CMUI_Area::Setup (struct MUI_RenderInfo * RenderInfo)
{
	return DoMethod (MUIM_Setup, RenderInfo);
}

ULONG CMUI_Area::Show (void)
{
	return DoMethod (MUIM_Show);
}

STRPTR CMUI_Rectangle::BarTitle (void) const
{
	 return (STRPTR)GetAttr (MUIA_Rectangle_BarTitle);
}

BOOL CMUI_Rectangle::HBar (void) const
{
	 return (BOOL)GetAttr (MUIA_Rectangle_HBar);
}

BOOL CMUI_Rectangle::VBar (void) const
{
	 return (BOOL)GetAttr (MUIA_Rectangle_VBar);
}

void CMUI_Image::SetState (LONG value)
{
	 SetAttr (MUIA_Image_State, (ULONG)value);
}

struct BitMap * CMUI_Bitmap::Bitmap (void) const
{
	 return (struct BitMap *)GetAttr (MUIA_Bitmap_Bitmap);
}

void CMUI_Bitmap::SetBitmap (struct BitMap * value)
{
	 SetAttr (MUIA_Bitmap_Bitmap, (ULONG)value);
}

LONG CMUI_Bitmap::Height (void) const
{
	 return (LONG)GetAttr (MUIA_Bitmap_Height);
}

void CMUI_Bitmap::SetHeight (LONG value)
{
	 SetAttr (MUIA_Bitmap_Height, (ULONG)value);
}

UBYTE * CMUI_Bitmap::MappingTable (void) const
{
	 return (UBYTE *)GetAttr (MUIA_Bitmap_MappingTable);
}

void CMUI_Bitmap::SetMappingTable (UBYTE * value)
{
	 SetAttr (MUIA_Bitmap_MappingTable, (ULONG)value);
}

LONG CMUI_Bitmap::Precision (void) const
{
	 return (LONG)GetAttr (MUIA_Bitmap_Precision);
}

void CMUI_Bitmap::SetPrecision (LONG value)
{
	 SetAttr (MUIA_Bitmap_Precision, (ULONG)value);
}

struct BitMap * CMUI_Bitmap::RemappedBitmap (void) const
{
	 return (struct BitMap *)GetAttr (MUIA_Bitmap_RemappedBitmap);
}

ULONG * CMUI_Bitmap::SourceColors (void) const
{
	 return (ULONG *)GetAttr (MUIA_Bitmap_SourceColors);
}

void CMUI_Bitmap::SetSourceColors (ULONG * value)
{
	 SetAttr (MUIA_Bitmap_SourceColors, (ULONG)value);
}

LONG CMUI_Bitmap::Transparent (void) const
{
	 return (LONG)GetAttr (MUIA_Bitmap_Transparent);
}

void CMUI_Bitmap::SetTransparent (LONG value)
{
	 SetAttr (MUIA_Bitmap_Transparent, (ULONG)value);
}

LONG CMUI_Bitmap::Width (void) const
{
	 return (LONG)GetAttr (MUIA_Bitmap_Width);
}

void CMUI_Bitmap::SetWidth (LONG value)
{
	 SetAttr (MUIA_Bitmap_Width, (ULONG)value);
}

UBYTE * CMUI_Bodychunk::Body (void) const
{
	 return (UBYTE *)GetAttr (MUIA_Bodychunk_Body);
}

void CMUI_Bodychunk::SetBody (UBYTE * value)
{
	 SetAttr (MUIA_Bodychunk_Body, (ULONG)value);
}

UBYTE CMUI_Bodychunk::Compression (void) const
{
	 return (UBYTE)GetAttr (MUIA_Bodychunk_Compression);
}

void CMUI_Bodychunk::SetCompression (UBYTE value)
{
	 SetAttr (MUIA_Bodychunk_Compression, (ULONG)value);
}

LONG CMUI_Bodychunk::Depth (void) const
{
	 return (LONG)GetAttr (MUIA_Bodychunk_Depth);
}

void CMUI_Bodychunk::SetDepth (LONG value)
{
	 SetAttr (MUIA_Bodychunk_Depth, (ULONG)value);
}

UBYTE CMUI_Bodychunk::Masking (void) const
{
	 return (UBYTE)GetAttr (MUIA_Bodychunk_Masking);
}

void CMUI_Bodychunk::SetMasking (UBYTE value)
{
	 SetAttr (MUIA_Bodychunk_Masking, (ULONG)value);
}

STRPTR CMUI_Text::Contents (void) const
{
	 return (STRPTR)GetAttr (MUIA_Text_Contents);
}

void CMUI_Text::SetContents (STRPTR value)
{
	 SetAttr (MUIA_Text_Contents, (ULONG)value);
}

STRPTR CMUI_Text::PreParse (void) const
{
	 return (STRPTR)GetAttr (MUIA_Text_PreParse);
}

void CMUI_Text::SetPreParse (STRPTR value)
{
	 SetAttr (MUIA_Text_PreParse, (ULONG)value);
}

struct Gadget * CMUI_Gadget::Gadget (void) const
{
	 return (struct Gadget *)GetAttr (MUIA_Gadget_Gadget);
}

STRPTR CMUI_String::Accept (void) const
{
	 return (STRPTR)GetAttr (MUIA_String_Accept);
}

void CMUI_String::SetAccept (STRPTR value)
{
	 SetAttr (MUIA_String_Accept, (ULONG)value);
}

STRPTR CMUI_String::Acknowledge (void) const
{
	 return (STRPTR)GetAttr (MUIA_String_Acknowledge);
}

BOOL CMUI_String::AdvanceOnCR (void) const
{
	 return (BOOL)GetAttr (MUIA_String_AdvanceOnCR);
}

void CMUI_String::SetAdvanceOnCR (BOOL value)
{
	 SetAttr (MUIA_String_AdvanceOnCR, (ULONG)value);
}

Object * CMUI_String::AttachedList (void) const
{
	 return (Object *)GetAttr (MUIA_String_AttachedList);
}

void CMUI_String::SetAttachedList (Object * value)
{
	 SetAttr (MUIA_String_AttachedList, (ULONG)value);
}

LONG CMUI_String::BufferPos (void) const
{
	 return (LONG)GetAttr (MUIA_String_BufferPos);
}

void CMUI_String::SetBufferPos (LONG value)
{
	 SetAttr (MUIA_String_BufferPos, (ULONG)value);
}

STRPTR CMUI_String::Contents (void) const
{
	 return (STRPTR)GetAttr (MUIA_String_Contents);
}

void CMUI_String::SetContents (STRPTR value)
{
	 SetAttr (MUIA_String_Contents, (ULONG)value);
}

LONG CMUI_String::DisplayPos (void) const
{
	 return (LONG)GetAttr (MUIA_String_DisplayPos);
}

void CMUI_String::SetDisplayPos (LONG value)
{
	 SetAttr (MUIA_String_DisplayPos, (ULONG)value);
}

struct Hook * CMUI_String::EditHook (void) const
{
	 return (struct Hook *)GetAttr (MUIA_String_EditHook);
}

void CMUI_String::SetEditHook (struct Hook * value)
{
	 SetAttr (MUIA_String_EditHook, (ULONG)value);
}

LONG CMUI_String::Format (void) const
{
	 return (LONG)GetAttr (MUIA_String_Format);
}

ULONG CMUI_String::Integer (void) const
{
	 return (ULONG)GetAttr (MUIA_String_Integer);
}

void CMUI_String::SetInteger (ULONG value)
{
	 SetAttr (MUIA_String_Integer, (ULONG)value);
}

BOOL CMUI_String::LonelyEditHook (void) const
{
	 return (BOOL)GetAttr (MUIA_String_LonelyEditHook);
}

void CMUI_String::SetLonelyEditHook (BOOL value)
{
	 SetAttr (MUIA_String_LonelyEditHook, (ULONG)value);
}

LONG CMUI_String::MaxLen (void) const
{
	 return (LONG)GetAttr (MUIA_String_MaxLen);
}

STRPTR CMUI_String::Reject (void) const
{
	 return (STRPTR)GetAttr (MUIA_String_Reject);
}

void CMUI_String::SetReject (STRPTR value)
{
	 SetAttr (MUIA_String_Reject, (ULONG)value);
}

BOOL CMUI_String::Secret (void) const
{
	 return (BOOL)GetAttr (MUIA_String_Secret);
}

struct IClass * CMUI_Boopsi::Class (void) const
{
	 return (struct IClass *)GetAttr (MUIA_Boopsi_Class);
}

void CMUI_Boopsi::SetClass (struct IClass * value)
{
	 SetAttr (MUIA_Boopsi_Class, (ULONG)value);
}

char * CMUI_Boopsi::ClassID (void) const
{
	 return (char *)GetAttr (MUIA_Boopsi_ClassID);
}

void CMUI_Boopsi::SetClassID (char * value)
{
	 SetAttr (MUIA_Boopsi_ClassID, (ULONG)value);
}

ULONG CMUI_Boopsi::MaxHeight (void) const
{
	 return (ULONG)GetAttr (MUIA_Boopsi_MaxHeight);
}

void CMUI_Boopsi::SetMaxHeight (ULONG value)
{
	 SetAttr (MUIA_Boopsi_MaxHeight, (ULONG)value);
}

ULONG CMUI_Boopsi::MaxWidth (void) const
{
	 return (ULONG)GetAttr (MUIA_Boopsi_MaxWidth);
}

void CMUI_Boopsi::SetMaxWidth (ULONG value)
{
	 SetAttr (MUIA_Boopsi_MaxWidth, (ULONG)value);
}

ULONG CMUI_Boopsi::MinHeight (void) const
{
	 return (ULONG)GetAttr (MUIA_Boopsi_MinHeight);
}

void CMUI_Boopsi::SetMinHeight (ULONG value)
{
	 SetAttr (MUIA_Boopsi_MinHeight, (ULONG)value);
}

ULONG CMUI_Boopsi::MinWidth (void) const
{
	 return (ULONG)GetAttr (MUIA_Boopsi_MinWidth);
}

void CMUI_Boopsi::SetMinWidth (ULONG value)
{
	 SetAttr (MUIA_Boopsi_MinWidth, (ULONG)value);
}

Object * CMUI_Boopsi::BoopsiObject (void) const
{
	 return (Object *)GetAttr (MUIA_Boopsi_Object);
}

ULONG CMUI_Boopsi::TagDrawInfo (void) const
{
	 return (ULONG)GetAttr (MUIA_Boopsi_TagDrawInfo);
}

void CMUI_Boopsi::SetTagDrawInfo (ULONG value)
{
	 SetAttr (MUIA_Boopsi_TagDrawInfo, (ULONG)value);
}

ULONG CMUI_Boopsi::TagScreen (void) const
{
	 return (ULONG)GetAttr (MUIA_Boopsi_TagScreen);
}

void CMUI_Boopsi::SetTagScreen (ULONG value)
{
	 SetAttr (MUIA_Boopsi_TagScreen, (ULONG)value);
}

ULONG CMUI_Boopsi::TagWindow (void) const
{
	 return (ULONG)GetAttr (MUIA_Boopsi_TagWindow);
}

void CMUI_Boopsi::SetTagWindow (ULONG value)
{
	 SetAttr (MUIA_Boopsi_TagWindow, (ULONG)value);
}

LONG CMUI_Prop::Entries (void) const
{
	 return (LONG)GetAttr (MUIA_Prop_Entries);
}

void CMUI_Prop::SetEntries (LONG value)
{
	 SetAttr (MUIA_Prop_Entries, (ULONG)value);
}

LONG CMUI_Prop::First (void) const
{
	 return (LONG)GetAttr (MUIA_Prop_First);
}

void CMUI_Prop::SetFirst (LONG value)
{
	 SetAttr (MUIA_Prop_First, (ULONG)value);
}

BOOL CMUI_Prop::Horiz (void) const
{
	 return (BOOL)GetAttr (MUIA_Prop_Horiz);
}

BOOL CMUI_Prop::Slider (void) const
{
	 return (BOOL)GetAttr (MUIA_Prop_Slider);
}

void CMUI_Prop::SetSlider (BOOL value)
{
	 SetAttr (MUIA_Prop_Slider, (ULONG)value);
}

LONG CMUI_Prop::Visible (void) const
{
	 return (LONG)GetAttr (MUIA_Prop_Visible);
}

void CMUI_Prop::SetVisible (LONG value)
{
	 SetAttr (MUIA_Prop_Visible, (ULONG)value);
}

ULONG CMUI_Prop::Decrease (LONG amount)
{
	return DoMethod (MUIM_Prop_Decrease, amount);
}

ULONG CMUI_Prop::Increase (LONG amount)
{
	return DoMethod (MUIM_Prop_Increase, amount);
}

LONG CMUI_Gauge::Current (void) const
{
	 return (LONG)GetAttr (MUIA_Gauge_Current);
}

void CMUI_Gauge::SetCurrent (LONG value)
{
	 SetAttr (MUIA_Gauge_Current, (ULONG)value);
}

BOOL CMUI_Gauge::Divide (void) const
{
	 return (BOOL)GetAttr (MUIA_Gauge_Divide);
}

void CMUI_Gauge::SetDivide (BOOL value)
{
	 SetAttr (MUIA_Gauge_Divide, (ULONG)value);
}

STRPTR CMUI_Gauge::InfoText (void) const
{
	 return (STRPTR)GetAttr (MUIA_Gauge_InfoText);
}

void CMUI_Gauge::SetInfoText (STRPTR value)
{
	 SetAttr (MUIA_Gauge_InfoText, (ULONG)value);
}

LONG CMUI_Gauge::Max (void) const
{
	 return (LONG)GetAttr (MUIA_Gauge_Max);
}

void CMUI_Gauge::SetMax (LONG value)
{
	 SetAttr (MUIA_Gauge_Max, (ULONG)value);
}

BOOL CMUI_Scale::Horiz (void) const
{
	 return (BOOL)GetAttr (MUIA_Scale_Horiz);
}

void CMUI_Scale::SetHoriz (BOOL value)
{
	 SetAttr (MUIA_Scale_Horiz, (ULONG)value);
}

ULONG CMUI_Colorfield::Blue (void) const
{
	 return (ULONG)GetAttr (MUIA_Colorfield_Blue);
}

void CMUI_Colorfield::SetBlue (ULONG value)
{
	 SetAttr (MUIA_Colorfield_Blue, (ULONG)value);
}

ULONG CMUI_Colorfield::Green (void) const
{
	 return (ULONG)GetAttr (MUIA_Colorfield_Green);
}

void CMUI_Colorfield::SetGreen (ULONG value)
{
	 SetAttr (MUIA_Colorfield_Green, (ULONG)value);
}

ULONG CMUI_Colorfield::Pen (void) const
{
	 return (ULONG)GetAttr (MUIA_Colorfield_Pen);
}

ULONG CMUI_Colorfield::Red (void) const
{
	 return (ULONG)GetAttr (MUIA_Colorfield_Red);
}

void CMUI_Colorfield::SetRed (ULONG value)
{
	 SetAttr (MUIA_Colorfield_Red, (ULONG)value);
}

ULONG * CMUI_Colorfield::RGB (void) const
{
	 return (ULONG *)GetAttr (MUIA_Colorfield_RGB);
}

void CMUI_Colorfield::SetRGB (ULONG * value)
{
	 SetAttr (MUIA_Colorfield_RGB, (ULONG)value);
}

LONG CMUI_List::Active (void) const
{
	 return (LONG)GetAttr (MUIA_List_Active);
}

void CMUI_List::SetActive (LONG value)
{
	 SetAttr (MUIA_List_Active, (ULONG)value);
}

BOOL CMUI_List::AutoVisible (void) const
{
	 return (BOOL)GetAttr (MUIA_List_AutoVisible);
}

void CMUI_List::SetAutoVisible (BOOL value)
{
	 SetAttr (MUIA_List_AutoVisible, (ULONG)value);
}

void CMUI_List::SetCompareHook (struct Hook * value)
{
	 SetAttr (MUIA_List_CompareHook, (ULONG)value);
}

void CMUI_List::SetConstructHook (struct Hook * value)
{
	 SetAttr (MUIA_List_ConstructHook, (ULONG)value);
}

void CMUI_List::SetDestructHook (struct Hook * value)
{
	 SetAttr (MUIA_List_DestructHook, (ULONG)value);
}

void CMUI_List::SetDisplayHook (struct Hook * value)
{
	 SetAttr (MUIA_List_DisplayHook, (ULONG)value);
}

BOOL CMUI_List::DragSortable (void) const
{
	 return (BOOL)GetAttr (MUIA_List_DragSortable);
}

void CMUI_List::SetDragSortable (BOOL value)
{
	 SetAttr (MUIA_List_DragSortable, (ULONG)value);
}

LONG CMUI_List::DropMark (void) const
{
	 return (LONG)GetAttr (MUIA_List_DropMark);
}

LONG CMUI_List::Entries (void) const
{
	 return (LONG)GetAttr (MUIA_List_Entries);
}

LONG CMUI_List::First (void) const
{
	 return (LONG)GetAttr (MUIA_List_First);
}

STRPTR CMUI_List::Format (void) const
{
	 return (STRPTR)GetAttr (MUIA_List_Format);
}

void CMUI_List::SetFormat (STRPTR value)
{
	 SetAttr (MUIA_List_Format, (ULONG)value);
}

LONG CMUI_List::InsertPosition (void) const
{
	 return (LONG)GetAttr (MUIA_List_InsertPosition);
}

void CMUI_List::SetMultiTestHook (struct Hook * value)
{
	 SetAttr (MUIA_List_MultiTestHook, (ULONG)value);
}

void CMUI_List::SetQuiet (BOOL value)
{
	 SetAttr (MUIA_List_Quiet, (ULONG)value);
}

BOOL CMUI_List::ShowDropMarks (void) const
{
	 return (BOOL)GetAttr (MUIA_List_ShowDropMarks);
}

void CMUI_List::SetShowDropMarks (BOOL value)
{
	 SetAttr (MUIA_List_ShowDropMarks, (ULONG)value);
}

char * CMUI_List::Title (void) const
{
	 return (char *)GetAttr (MUIA_List_Title);
}

void CMUI_List::SetTitle (char * value)
{
	 SetAttr (MUIA_List_Title, (ULONG)value);
}

LONG CMUI_List::Visible (void) const
{
	 return (LONG)GetAttr (MUIA_List_Visible);
}

ULONG CMUI_List::Clear (void)
{
	return DoMethod (MUIM_List_Clear);
}

ULONG CMUI_List::CreateImage (Object * obj, ULONG flags)
{
	return DoMethod (MUIM_List_CreateImage, obj, flags);
}

ULONG CMUI_List::DeleteImage (APTR listimg)
{
	return DoMethod (MUIM_List_DeleteImage, listimg);
}

ULONG CMUI_List::Exchange (LONG pos1, LONG pos2)
{
	return DoMethod (MUIM_List_Exchange, pos1, pos2);
}

ULONG CMUI_List::GetEntry (LONG pos, APTR * entry)
{
	return DoMethod (MUIM_List_GetEntry, pos, entry);
}

ULONG CMUI_List::Insert (APTR * entries, LONG count, LONG pos)
{
	return DoMethod (MUIM_List_Insert, entries, count, pos);
}

ULONG CMUI_List::InsertSingle (APTR entry, LONG pos)
{
	return DoMethod (MUIM_List_InsertSingle, entry, pos);
}

ULONG CMUI_List::Jump (LONG pos)
{
	return DoMethod (MUIM_List_Jump, pos);
}

ULONG CMUI_List::Move (LONG from, LONG to)
{
	return DoMethod (MUIM_List_Move, from, to);
}

ULONG CMUI_List::NextSelected (LONG * pos)
{
	return DoMethod (MUIM_List_NextSelected, pos);
}

ULONG CMUI_List::Redraw (LONG pos)
{
	return DoMethod (MUIM_List_Redraw, pos);
}

ULONG CMUI_List::Remove (LONG pos)
{
	return DoMethod (MUIM_List_Remove, pos);
}

ULONG CMUI_List::Select (LONG pos, LONG seltype, LONG * state)
{
	return DoMethod (MUIM_List_Select, pos, seltype, state);
}

ULONG CMUI_List::Sort (void)
{
	return DoMethod (MUIM_List_Sort);
}

ULONG CMUI_List::TestPos (LONG x, LONG y, struct MUI_List_TestPos_Result * res)
{
	return DoMethod (MUIM_List_TestPos, x, y, res);
}

BOOL CMUI_Floattext::Justify (void) const
{
	 return (BOOL)GetAttr (MUIA_Floattext_Justify);
}

void CMUI_Floattext::SetJustify (BOOL value)
{
	 SetAttr (MUIA_Floattext_Justify, (ULONG)value);
}

void CMUI_Floattext::SetSkipChars (STRPTR value)
{
	 SetAttr (MUIA_Floattext_SkipChars, (ULONG)value);
}

void CMUI_Floattext::SetTabSize (LONG value)
{
	 SetAttr (MUIA_Floattext_TabSize, (ULONG)value);
}

STRPTR CMUI_Floattext::Text (void) const
{
	 return (STRPTR)GetAttr (MUIA_Floattext_Text);
}

void CMUI_Floattext::SetText (STRPTR value)
{
	 SetAttr (MUIA_Floattext_Text, (ULONG)value);
}

void CMUI_Dirlist::SetAcceptPattern (STRPTR value)
{
	 SetAttr (MUIA_Dirlist_AcceptPattern, (ULONG)value);
}

STRPTR CMUI_Dirlist::Directory (void) const
{
	 return (STRPTR)GetAttr (MUIA_Dirlist_Directory);
}

void CMUI_Dirlist::SetDirectory (STRPTR value)
{
	 SetAttr (MUIA_Dirlist_Directory, (ULONG)value);
}

void CMUI_Dirlist::SetDrawersOnly (BOOL value)
{
	 SetAttr (MUIA_Dirlist_DrawersOnly, (ULONG)value);
}

void CMUI_Dirlist::SetFilesOnly (BOOL value)
{
	 SetAttr (MUIA_Dirlist_FilesOnly, (ULONG)value);
}

void CMUI_Dirlist::SetFilterDrawers (BOOL value)
{
	 SetAttr (MUIA_Dirlist_FilterDrawers, (ULONG)value);
}

void CMUI_Dirlist::SetFilterHook (struct Hook * value)
{
	 SetAttr (MUIA_Dirlist_FilterHook, (ULONG)value);
}

void CMUI_Dirlist::SetMultiSelDirs (BOOL value)
{
	 SetAttr (MUIA_Dirlist_MultiSelDirs, (ULONG)value);
}

LONG CMUI_Dirlist::NumBytes (void) const
{
	 return (LONG)GetAttr (MUIA_Dirlist_NumBytes);
}

LONG CMUI_Dirlist::NumDrawers (void) const
{
	 return (LONG)GetAttr (MUIA_Dirlist_NumDrawers);
}

LONG CMUI_Dirlist::NumFiles (void) const
{
	 return (LONG)GetAttr (MUIA_Dirlist_NumFiles);
}

STRPTR CMUI_Dirlist::Path (void) const
{
	 return (STRPTR)GetAttr (MUIA_Dirlist_Path);
}

void CMUI_Dirlist::SetRejectIcons (BOOL value)
{
	 SetAttr (MUIA_Dirlist_RejectIcons, (ULONG)value);
}

void CMUI_Dirlist::SetRejectPattern (STRPTR value)
{
	 SetAttr (MUIA_Dirlist_RejectPattern, (ULONG)value);
}

void CMUI_Dirlist::SetSortDirs (LONG value)
{
	 SetAttr (MUIA_Dirlist_SortDirs, (ULONG)value);
}

void CMUI_Dirlist::SetSortHighLow (BOOL value)
{
	 SetAttr (MUIA_Dirlist_SortHighLow, (ULONG)value);
}

void CMUI_Dirlist::SetSortType (LONG value)
{
	 SetAttr (MUIA_Dirlist_SortType, (ULONG)value);
}

LONG CMUI_Dirlist::Status (void) const
{
	 return (LONG)GetAttr (MUIA_Dirlist_Status);
}

ULONG CMUI_Dirlist::ReRead (void)
{
	return DoMethod (MUIM_Dirlist_ReRead);
}

BOOL CMUI_Numeric::CheckAllSizes (void) const
{
	 return (BOOL)GetAttr (MUIA_Numeric_CheckAllSizes);
}

void CMUI_Numeric::SetCheckAllSizes (BOOL value)
{
	 SetAttr (MUIA_Numeric_CheckAllSizes, (ULONG)value);
}

LONG CMUI_Numeric::Default (void) const
{
	 return (LONG)GetAttr (MUIA_Numeric_Default);
}

void CMUI_Numeric::SetDefault (LONG value)
{
	 SetAttr (MUIA_Numeric_Default, (ULONG)value);
}

STRPTR CMUI_Numeric::Format (void) const
{
	 return (STRPTR)GetAttr (MUIA_Numeric_Format);
}

void CMUI_Numeric::SetFormat (STRPTR value)
{
	 SetAttr (MUIA_Numeric_Format, (ULONG)value);
}

LONG CMUI_Numeric::Max (void) const
{
	 return (LONG)GetAttr (MUIA_Numeric_Max);
}

void CMUI_Numeric::SetMax (LONG value)
{
	 SetAttr (MUIA_Numeric_Max, (ULONG)value);
}

LONG CMUI_Numeric::Min (void) const
{
	 return (LONG)GetAttr (MUIA_Numeric_Min);
}

void CMUI_Numeric::SetMin (LONG value)
{
	 SetAttr (MUIA_Numeric_Min, (ULONG)value);
}

BOOL CMUI_Numeric::Reverse (void) const
{
	 return (BOOL)GetAttr (MUIA_Numeric_Reverse);
}

void CMUI_Numeric::SetReverse (BOOL value)
{
	 SetAttr (MUIA_Numeric_Reverse, (ULONG)value);
}

BOOL CMUI_Numeric::RevLeftRight (void) const
{
	 return (BOOL)GetAttr (MUIA_Numeric_RevLeftRight);
}

void CMUI_Numeric::SetRevLeftRight (BOOL value)
{
	 SetAttr (MUIA_Numeric_RevLeftRight, (ULONG)value);
}

BOOL CMUI_Numeric::RevUpDown (void) const
{
	 return (BOOL)GetAttr (MUIA_Numeric_RevUpDown);
}

void CMUI_Numeric::SetRevUpDown (BOOL value)
{
	 SetAttr (MUIA_Numeric_RevUpDown, (ULONG)value);
}

LONG CMUI_Numeric::Value (void) const
{
	 return (LONG)GetAttr (MUIA_Numeric_Value);
}

void CMUI_Numeric::SetValue (LONG value)
{
	 SetAttr (MUIA_Numeric_Value, (ULONG)value);
}

ULONG CMUI_Numeric::Decrease (LONG amount)
{
	return DoMethod (MUIM_Numeric_Decrease, amount);
}

ULONG CMUI_Numeric::Increase (LONG amount)
{
	return DoMethod (MUIM_Numeric_Increase, amount);
}

ULONG CMUI_Numeric::ScaleToValue (LONG scalemin, LONG scalemax, LONG scale)
{
	return DoMethod (MUIM_Numeric_ScaleToValue, scalemin, scalemax, scale);
}

ULONG CMUI_Numeric::SetDefault (void)
{
	return DoMethod (MUIM_Numeric_SetDefault);
}

ULONG CMUI_Numeric::Stringify (LONG value)
{
	return DoMethod (MUIM_Numeric_Stringify, value);
}

ULONG CMUI_Numeric::ValueToScale (LONG scalemin, LONG scalemax)
{
	return DoMethod (MUIM_Numeric_ValueToScale, scalemin, scalemax);
}

STRPTR CMUI_Levelmeter::Label (void) const
{
	 return (STRPTR)GetAttr (MUIA_Levelmeter_Label);
}

void CMUI_Levelmeter::SetLabel (STRPTR value)
{
	 SetAttr (MUIA_Levelmeter_Label, (ULONG)value);
}

BOOL CMUI_Slider::Horiz (void) const
{
	 return (BOOL)GetAttr (MUIA_Slider_Horiz);
}

void CMUI_Slider::SetHoriz (BOOL value)
{
	 SetAttr (MUIA_Slider_Horiz, (ULONG)value);
}

LONG CMUI_Slider::Level (void) const
{
	 return (LONG)GetAttr (MUIA_Slider_Level);
}

void CMUI_Slider::SetLevel (LONG value)
{
	 SetAttr (MUIA_Slider_Level, (ULONG)value);
}

LONG CMUI_Slider::Max (void) const
{
	 return (LONG)GetAttr (MUIA_Slider_Max);
}

void CMUI_Slider::SetMax (LONG value)
{
	 SetAttr (MUIA_Slider_Max, (ULONG)value);
}

LONG CMUI_Slider::Min (void) const
{
	 return (LONG)GetAttr (MUIA_Slider_Min);
}

void CMUI_Slider::SetMin (LONG value)
{
	 SetAttr (MUIA_Slider_Min, (ULONG)value);
}

BOOL CMUI_Slider::Reverse (void) const
{
	 return (BOOL)GetAttr (MUIA_Slider_Reverse);
}

void CMUI_Slider::SetReverse (BOOL value)
{
	 SetAttr (MUIA_Slider_Reverse, (ULONG)value);
}

Object * CMUI_Pendisplay::Pen (void) const
{
	 return (Object *)GetAttr (MUIA_Pendisplay_Pen);
}

Object * CMUI_Pendisplay::Reference (void) const
{
	 return (Object *)GetAttr (MUIA_Pendisplay_Reference);
}

void CMUI_Pendisplay::SetReference (Object * value)
{
	 SetAttr (MUIA_Pendisplay_Reference, (ULONG)value);
}

struct MUI_RGBcolor * CMUI_Pendisplay::RGBcolor (void) const
{
	 return (struct MUI_RGBcolor *)GetAttr (MUIA_Pendisplay_RGBcolor);
}

void CMUI_Pendisplay::SetRGBcolor (struct MUI_RGBcolor * value)
{
	 SetAttr (MUIA_Pendisplay_RGBcolor, (ULONG)value);
}

struct MUI_PenSpec  * CMUI_Pendisplay::Spec (void) const
{
	 return (struct MUI_PenSpec  *)GetAttr (MUIA_Pendisplay_Spec);
}

void CMUI_Pendisplay::SetSpec (struct MUI_PenSpec  * value)
{
	 SetAttr (MUIA_Pendisplay_Spec, (ULONG)value);
}

ULONG CMUI_Pendisplay::SetColormap (LONG colormap)
{
	return DoMethod (MUIM_Pendisplay_SetColormap, colormap);
}

ULONG CMUI_Pendisplay::SetMUIPen (LONG muipen)
{
	return DoMethod (MUIM_Pendisplay_SetMUIPen, muipen);
}

ULONG CMUI_Pendisplay::SetRGB (ULONG red, ULONG green, ULONG blue)
{
	return DoMethod (MUIM_Pendisplay_SetRGB, red, green, blue);
}

LONG CMUI_Group::ActivePage (void) const
{
	 return (LONG)GetAttr (MUIA_Group_ActivePage);
}

void CMUI_Group::SetActivePage (LONG value)
{
	 SetAttr (MUIA_Group_ActivePage, (ULONG)value);
}

struct List * CMUI_Group::ChildList (void) const
{
	 return (struct List *)GetAttr (MUIA_Group_ChildList);
}

void CMUI_Group::SetColumns (LONG value)
{
	 SetAttr (MUIA_Group_Columns, (ULONG)value);
}

LONG CMUI_Group::HorizSpacing (void) const
{
	 return (LONG)GetAttr (MUIA_Group_HorizSpacing);
}

void CMUI_Group::SetHorizSpacing (LONG value)
{
	 SetAttr (MUIA_Group_HorizSpacing, (ULONG)value);
}

void CMUI_Group::SetRows (LONG value)
{
	 SetAttr (MUIA_Group_Rows, (ULONG)value);
}

void CMUI_Group::SetSpacing (LONG value)
{
	 SetAttr (MUIA_Group_Spacing, (ULONG)value);
}

LONG CMUI_Group::VertSpacing (void) const
{
	 return (LONG)GetAttr (MUIA_Group_VertSpacing);
}

void CMUI_Group::SetVertSpacing (LONG value)
{
	 SetAttr (MUIA_Group_VertSpacing, (ULONG)value);
}

ULONG CMUI_Group::ExitChange (void)
{
	return DoMethod (MUIM_Group_ExitChange);
}

ULONG CMUI_Group::InitChange (void)
{
	return DoMethod (MUIM_Group_InitChange);
}

ULONG CMUI_Group::Sort (StartVarArgs sva, Object * obj, ...)
{
	sva.methodID = MUIM_Group_Sort;
	return DoMethodA ((Msg)&sva);
}

BOOL CMUI_Register::Frame (void) const
{
	 return (BOOL)GetAttr (MUIA_Register_Frame);
}

STRPTR * CMUI_Register::Titles (void) const
{
	 return (STRPTR *)GetAttr (MUIA_Register_Titles);
}

ULONG CMUI_Settingsgroup::ConfigToGadgets (Object * configdata)
{
	return DoMethod (MUIM_Settingsgroup_ConfigToGadgets, configdata);
}

ULONG CMUI_Settingsgroup::GadgetsToConfig (Object * configdata)
{
	return DoMethod (MUIM_Settingsgroup_GadgetsToConfig, configdata);
}

LONG CMUI_Virtgroup::Height (void) const
{
	 return (LONG)GetAttr (MUIA_Virtgroup_Height);
}

LONG CMUI_Virtgroup::Left (void) const
{
	 return (LONG)GetAttr (MUIA_Virtgroup_Left);
}

void CMUI_Virtgroup::SetLeft (LONG value)
{
	 SetAttr (MUIA_Virtgroup_Left, (ULONG)value);
}

LONG CMUI_Virtgroup::Top (void) const
{
	 return (LONG)GetAttr (MUIA_Virtgroup_Top);
}

void CMUI_Virtgroup::SetTop (LONG value)
{
	 SetAttr (MUIA_Virtgroup_Top, (ULONG)value);
}

LONG CMUI_Virtgroup::Width (void) const
{
	 return (LONG)GetAttr (MUIA_Virtgroup_Width);
}

Object * CMUI_Scrollgroup::Contents (void) const
{
	 return (Object *)GetAttr (MUIA_Scrollgroup_Contents);
}

Object * CMUI_Scrollgroup::HorizBar (void) const
{
	 return (Object *)GetAttr (MUIA_Scrollgroup_HorizBar);
}

Object * CMUI_Scrollgroup::VertBar (void) const
{
	 return (Object *)GetAttr (MUIA_Scrollgroup_VertBar);
}

LONG CMUI_Listview::ActivePage (void) const
{
	 return (LONG)GetAttr (MUIA_Group_ActivePage);
}

void CMUI_Listview::SetActivePage (LONG value)
{
	 SetAttr (MUIA_Group_ActivePage, (ULONG)value);
}

struct List * CMUI_Listview::ChildList (void) const
{
	 return (struct List *)GetAttr (MUIA_Group_ChildList);
}

void CMUI_Listview::SetColumns (LONG value)
{
	 SetAttr (MUIA_Group_Columns, (ULONG)value);
}

LONG CMUI_Listview::HorizSpacing (void) const
{
	 return (LONG)GetAttr (MUIA_Group_HorizSpacing);
}

void CMUI_Listview::SetHorizSpacing (LONG value)
{
	 SetAttr (MUIA_Group_HorizSpacing, (ULONG)value);
}

void CMUI_Listview::SetRows (LONG value)
{
	 SetAttr (MUIA_Group_Rows, (ULONG)value);
}

void CMUI_Listview::SetSpacing (LONG value)
{
	 SetAttr (MUIA_Group_Spacing, (ULONG)value);
}

LONG CMUI_Listview::VertSpacing (void) const
{
	 return (LONG)GetAttr (MUIA_Group_VertSpacing);
}

void CMUI_Listview::SetVertSpacing (LONG value)
{
	 SetAttr (MUIA_Group_VertSpacing, (ULONG)value);
}

ULONG CMUI_Listview::ExitChange (void)
{
	return DoMethod (MUIM_Group_ExitChange);
}

ULONG CMUI_Listview::InitChange (void)
{
	return DoMethod (MUIM_Group_InitChange);
}

ULONG CMUI_Listview::Sort (StartVarArgs sva, Object * obj, ...)
{
	sva.methodID = MUIM_Group_Sort;
	return DoMethodA ((Msg)&sva);
}

LONG CMUI_Listview::ClickColumn (void) const
{
	 return (LONG)GetAttr (MUIA_Listview_ClickColumn);
}

LONG CMUI_Listview::DefClickColumn (void) const
{
	 return (LONG)GetAttr (MUIA_Listview_DefClickColumn);
}

void CMUI_Listview::SetDefClickColumn (LONG value)
{
	 SetAttr (MUIA_Listview_DefClickColumn, (ULONG)value);
}

BOOL CMUI_Listview::DoubleClick (void) const
{
	 return (BOOL)GetAttr (MUIA_Listview_DoubleClick);
}

LONG CMUI_Listview::DragType (void) const
{
	 return (LONG)GetAttr (MUIA_Listview_DragType);
}

void CMUI_Listview::SetDragType (LONG value)
{
	 SetAttr (MUIA_Listview_DragType, (ULONG)value);
}

Object * CMUI_Listview::List (void) const
{
	 return (Object *)GetAttr (MUIA_Listview_List);
}

BOOL CMUI_Listview::SelectChange (void) const
{
	 return (BOOL)GetAttr (MUIA_Listview_SelectChange);
}

LONG CMUI_Radio::Active (void) const
{
	 return (LONG)GetAttr (MUIA_Radio_Active);
}

void CMUI_Radio::SetActive (LONG value)
{
	 SetAttr (MUIA_Radio_Active, (ULONG)value);
}

LONG CMUI_Cycle::Active (void) const
{
	 return (LONG)GetAttr (MUIA_Cycle_Active);
}

void CMUI_Cycle::SetActive (LONG value)
{
	 SetAttr (MUIA_Cycle_Active, (ULONG)value);
}

ULONG CMUI_Coloradjust::Blue (void) const
{
	 return (ULONG)GetAttr (MUIA_Coloradjust_Blue);
}

void CMUI_Coloradjust::SetBlue (ULONG value)
{
	 SetAttr (MUIA_Coloradjust_Blue, (ULONG)value);
}

ULONG CMUI_Coloradjust::Green (void) const
{
	 return (ULONG)GetAttr (MUIA_Coloradjust_Green);
}

void CMUI_Coloradjust::SetGreen (ULONG value)
{
	 SetAttr (MUIA_Coloradjust_Green, (ULONG)value);
}

ULONG CMUI_Coloradjust::ModeID (void) const
{
	 return (ULONG)GetAttr (MUIA_Coloradjust_ModeID);
}

void CMUI_Coloradjust::SetModeID (ULONG value)
{
	 SetAttr (MUIA_Coloradjust_ModeID, (ULONG)value);
}

ULONG CMUI_Coloradjust::Red (void) const
{
	 return (ULONG)GetAttr (MUIA_Coloradjust_Red);
}

void CMUI_Coloradjust::SetRed (ULONG value)
{
	 SetAttr (MUIA_Coloradjust_Red, (ULONG)value);
}

ULONG * CMUI_Coloradjust::RGB (void) const
{
	 return (ULONG *)GetAttr (MUIA_Coloradjust_RGB);
}

void CMUI_Coloradjust::SetRGB (ULONG * value)
{
	 SetAttr (MUIA_Coloradjust_RGB, (ULONG)value);
}

struct MUI_Palette_Entry * CMUI_Palette::Entries (void) const
{
	 return (struct MUI_Palette_Entry *)GetAttr (MUIA_Palette_Entries);
}

BOOL CMUI_Palette::Groupable (void) const
{
	 return (BOOL)GetAttr (MUIA_Palette_Groupable);
}

void CMUI_Palette::SetGroupable (BOOL value)
{
	 SetAttr (MUIA_Palette_Groupable, (ULONG)value);
}

char ** CMUI_Palette::Names (void) const
{
	 return (char **)GetAttr (MUIA_Palette_Names);
}

void CMUI_Palette::SetNames (char ** value)
{
	 SetAttr (MUIA_Palette_Names, (ULONG)value);
}

Object * CMUI_Popstring::Button (void) const
{
	 return (Object *)GetAttr (MUIA_Popstring_Button);
}

struct Hook * CMUI_Popstring::CloseHook (void) const
{
	 return (struct Hook *)GetAttr (MUIA_Popstring_CloseHook);
}

void CMUI_Popstring::SetCloseHook (struct Hook * value)
{
	 SetAttr (MUIA_Popstring_CloseHook, (ULONG)value);
}

struct Hook * CMUI_Popstring::OpenHook (void) const
{
	 return (struct Hook *)GetAttr (MUIA_Popstring_OpenHook);
}

void CMUI_Popstring::SetOpenHook (struct Hook * value)
{
	 SetAttr (MUIA_Popstring_OpenHook, (ULONG)value);
}

Object * CMUI_Popstring::String (void) const
{
	 return (Object *)GetAttr (MUIA_Popstring_String);
}

BOOL CMUI_Popstring::Toggle (void) const
{
	 return (BOOL)GetAttr (MUIA_Popstring_Toggle);
}

void CMUI_Popstring::SetToggle (BOOL value)
{
	 SetAttr (MUIA_Popstring_Toggle, (ULONG)value);
}

ULONG CMUI_Popstring::Close (LONG result)
{
	return DoMethod (MUIM_Popstring_Close, result);
}

ULONG CMUI_Popstring::Open (void)
{
	return DoMethod (MUIM_Popstring_Open);
}

BOOL CMUI_Popobject::Follow (void) const
{
	 return (BOOL)GetAttr (MUIA_Popobject_Follow);
}

void CMUI_Popobject::SetFollow (BOOL value)
{
	 SetAttr (MUIA_Popobject_Follow, (ULONG)value);
}

BOOL CMUI_Popobject::Light (void) const
{
	 return (BOOL)GetAttr (MUIA_Popobject_Light);
}

void CMUI_Popobject::SetLight (BOOL value)
{
	 SetAttr (MUIA_Popobject_Light, (ULONG)value);
}

Object * CMUI_Popobject::PopObject (void) const
{
	 return (Object *)GetAttr (MUIA_Popobject_Object);
}

struct Hook * CMUI_Popobject::ObjStrHook (void) const
{
	 return (struct Hook *)GetAttr (MUIA_Popobject_ObjStrHook);
}

void CMUI_Popobject::SetObjStrHook (struct Hook * value)
{
	 SetAttr (MUIA_Popobject_ObjStrHook, (ULONG)value);
}

struct Hook * CMUI_Popobject::StrObjHook (void) const
{
	 return (struct Hook *)GetAttr (MUIA_Popobject_StrObjHook);
}

void CMUI_Popobject::SetStrObjHook (struct Hook * value)
{
	 SetAttr (MUIA_Popobject_StrObjHook, (ULONG)value);
}

BOOL CMUI_Popobject::Volatile (void) const
{
	 return (BOOL)GetAttr (MUIA_Popobject_Volatile);
}

void CMUI_Popobject::SetVolatile (BOOL value)
{
	 SetAttr (MUIA_Popobject_Volatile, (ULONG)value);
}

struct Hook * CMUI_Popobject::WindowHook (void) const
{
	 return (struct Hook *)GetAttr (MUIA_Popobject_WindowHook);
}

void CMUI_Popobject::SetWindowHook (struct Hook * value)
{
	 SetAttr (MUIA_Popobject_WindowHook, (ULONG)value);
}

BOOL CMUI_Popasl::Active (void) const
{
	 return (BOOL)GetAttr (MUIA_Popasl_Active);
}

struct Hook * CMUI_Popasl::StartHook (void) const
{
	 return (struct Hook *)GetAttr (MUIA_Popasl_StartHook);
}

void CMUI_Popasl::SetStartHook (struct Hook * value)
{
	 SetAttr (MUIA_Popasl_StartHook, (ULONG)value);
}

struct Hook * CMUI_Popasl::StopHook (void) const
{
	 return (struct Hook *)GetAttr (MUIA_Popasl_StopHook);
}

void CMUI_Popasl::SetStopHook (struct Hook * value)
{
	 SetAttr (MUIA_Popasl_StopHook, (ULONG)value);
}

ULONG CMUI_Popasl::Type (void) const
{
	 return (ULONG)GetAttr (MUIA_Popasl_Type);
}

ULONG CMUI_Semaphore::Attempt (void)
{
	return DoMethod (MUIM_Semaphore_Attempt);
}

ULONG CMUI_Semaphore::AttemptShared (void)
{
	return DoMethod (MUIM_Semaphore_AttemptShared);
}

ULONG CMUI_Semaphore::Obtain (void)
{
	return DoMethod (MUIM_Semaphore_Obtain);
}

ULONG CMUI_Semaphore::ObtainShared (void)
{
	return DoMethod (MUIM_Semaphore_ObtainShared);
}

ULONG CMUI_Semaphore::Release (void)
{
	return DoMethod (MUIM_Semaphore_Release);
}

ULONG CMUI_Dataspace::Add (APTR data, LONG len, ULONG id)
{
	return DoMethod (MUIM_Dataspace_Add, data, len, id);
}

ULONG CMUI_Dataspace::Clear (void)
{
	return DoMethod (MUIM_Dataspace_Clear);
}

ULONG CMUI_Dataspace::Find (ULONG id)
{
	return DoMethod (MUIM_Dataspace_Find, id);
}

ULONG CMUI_Dataspace::Merge (Object * dataspace)
{
	return DoMethod (MUIM_Dataspace_Merge, dataspace);
}

ULONG CMUI_Dataspace::ReadIFF (struct IFFHandle * handle)
{
	return DoMethod (MUIM_Dataspace_ReadIFF, handle);
}

ULONG CMUI_Dataspace::Remove (ULONG id)
{
	return DoMethod (MUIM_Dataspace_Remove, id);
}

ULONG CMUI_Dataspace::WriteIFF (struct IFFHandle * handle, ULONG type, ULONG id)
{
	return DoMethod (MUIM_Dataspace_WriteIFF, handle, type, id);
}

