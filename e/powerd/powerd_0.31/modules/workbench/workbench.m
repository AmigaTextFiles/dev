MODULE 'intuition/intuition','workbench/startup'

CONST WBDISK=1,
 WBDRAWER=2,
 WBTOOL=3,
 WBPROJECT=4,
 WBGARBAGE=5,
 WBDEVICE=6,
 WBKICK=7,
 WBAPPICON=8

OBJECT OldDrawerData
  NewWindow:NewWindow,
  CurrentX:LONG,
  CurrentY:LONG
#define OLDDRAWERDATAFILESIZE   SIZEOF_OldDrawerData

OBJECT DrawerData
  NewWindow:NewWindow,
  CurrentX:LONG,
  CurrentY:LONG,
  Flags:ULONG,
  ViewModes:UWORD
#define DRAWERDATAFILESIZE  SIZEOF_DrawerData

#define DDVM_BYDEFAULT    0
#define DDVM_BYICON     1
#define DDVM_BYNAME     2
#define DDVM_BYDATE     3
#define DDVM_BYSIZE     4
#define DDVM_BYTYPE     5
#define DDFLAGS_SHOWDEFAULT   0
#define DDFLAGS_SHOWICONS   1
#define DDFLAGS_SHOWALL     2

OBJECT DiskObject
  Magic:UWORD,
  Version:UWORD,
  Gadget:Gadget,
  Type:UBYTE,
  DefaultTool:PTR TO UBYTE,
  ToolTypes:PTR TO PTR TO UBYTE,
  CurrentX:LONG,
  CurrentY:LONG,
  DrawerData:PTR TO DrawerData,
  ToolWindow:PTR TO UBYTE,
  StackSize:LONG

#define WB_DISKMAGIC  $e310 
#define WB_DISKVERSION  1
#define WB_DISKREVISION   1
#define WB_DISKREVISIONMASK   255
OBJECT FreeList
  NumFree:WORD,
  MemList:List

#define GFLG_GADGBACKFILL  $0001
#define GADGBACKFILL    $0001    
#define NO_ICON_POSITION  ($80000000)
#define WORKBENCH_NAME    'workbench.library'
#define AM_VERSION  1
OBJECT AppMessage
  Message:Message,
  Type:UWORD,
  UserData:ULONG,
  ID:ULONG,
  NumArgs:LONG,
  ArgList:PTR TO WBArg,
  Version:UWORD,
  Class:UWORD,
  MouseX:WORD,
  MouseY:WORD,
  Seconds:ULONG,
  Micros:ULONG,
  Reserved[8]:ULONG

#define AMTYPE_APPWINDOW         7
#define AMTYPE_APPICON          8
#define AMTYPE_APPMENUITEM       9
#define AMTYPE_APPWINDOWZONE    10
#define AMCLASSICON_Open  0
#define AMCLASSICON_Copy  1
#define AMCLASSICON_Rename  2
#define AMCLASSICON_Information   3
#define AMCLASSICON_Snapshot  4
#define AMCLASSICON_UnSnapshot  5
#define AMCLASSICON_LeaveOut  6
#define AMCLASSICON_PutAway   7
#define AMCLASSICON_Delete  8
#define AMCLASSICON_FormatDisk  9
#define AMCLASSICON_EmptyTrash  10
#define AMCLASSICON_Selected  11
#define AMCLASSICON_Unselected  12
OBJECT AppWindow
  PRIVATE:VOID

OBJECT AppWindowDropZone
  PRIVATE:VOID

OBJECT AppIcon
  PRIVATE:VOID

OBJECT AppMenuItem
  PRIVATE:VOID

OBJECT AppMenu
  PRIVATE:VOID

#define WBA_Dummy  (TAG_USER+$A000)
#define WBAPPICONA_SupportsOpen     (WBA_Dummy+1)
#define WBAPPICONA_SupportsCopy     (WBA_Dummy+2)
#define WBAPPICONA_SupportsRename   (WBA_Dummy+3)
#define WBAPPICONA_SupportsInformation  (WBA_Dummy+4)
#define WBAPPICONA_SupportsSnapshot   (WBA_Dummy+5)
#define WBAPPICONA_SupportsUnSnapshot   (WBA_Dummy+6)
#define WBAPPICONA_SupportsLeaveOut   (WBA_Dummy+7)
#define WBAPPICONA_SupportsPutAway  (WBA_Dummy+8)
#define WBAPPICONA_SupportsDelete   (WBA_Dummy+9)
#define WBAPPICONA_SupportsFormatDisk   (WBA_Dummy+10)
#define WBAPPICONA_SupportsEmptyTrash   (WBA_Dummy+11)
#define WBAPPICONA_PropagatePosition  (WBA_Dummy+12)
#define WBAPPICONA_RenderHook     (WBA_Dummy+13)
#define WBAPPICONA_NotifySelectState  (WBA_Dummy+14)
#define WBAPPMENUA_CommandKeyString    (WBA_Dummy+15)
#define WBAPPMENUA_GetKey     (WBA_Dummy+65)
#define WBAPPMENUA_UseKey     (WBA_Dummy+66)
#define WBAPPMENUA_GetTitleKey    (WBA_Dummy+77)
#define WBOPENA_ArgLock       (WBA_Dummy+16)
#define WBOPENA_ArgName       (WBA_Dummy+17)
#define WBOPENA_Show      (WBA_Dummy+75)
#define WBOPENA_ViewBy      (WBA_Dummy+76)
#define WBCTRLA_IsOpen      (WBA_Dummy+18)
#define WBCTRLA_DuplicateSearchPath   (WBA_Dummy+19)
#define WBCTRLA_FreeSearchPath    (WBA_Dummy+20)
#define WBCTRLA_GetDefaultStackSize   (WBA_Dummy+21)
#define WBCTRLA_SetDefaultStackSize   (WBA_Dummy+22)
#define WBCTRLA_RedrawAppIcon     (WBA_Dummy+23)
#define WBCTRLA_GetProgramList    (WBA_Dummy+24)
#define WBCTRLA_FreeProgramList     (WBA_Dummy+25)
#define WBCTRLA_GetSelectedIconList   (WBA_Dummy+36)
#define WBCTRLA_FreeSelectedIconList  (WBA_Dummy+37)
#define WBCTRLA_GetOpenDrawerList   (WBA_Dummy+38)
#define WBCTRLA_FreeOpenDrawerList  (WBA_Dummy+39)
#define WBCTRLA_GetHiddenDeviceList   (WBA_Dummy+42)
#define WBCTRLA_FreeHiddenDeviceList  (WBA_Dummy+43)
#define WBCTRLA_AddHiddenDeviceName   (WBA_Dummy+44)
#define WBCTRLA_RemoveHiddenDeviceName  (WBA_Dummy+45)
#define WBCTRLA_GetTypeRestartTime  (WBA_Dummy+47)
#define WBCTRLA_SetTypeRestartTime  (WBA_Dummy+48)
#define WBCTRLA_GetCopyHook     (WBA_Dummy+69)
#define WBCTRLA_SetCopyHook     (WBA_Dummy+70)
#define WBCTRLA_GetDeleteHook     (WBA_Dummy+71)
#define WBCTRLA_SetDeleteHook     (WBA_Dummy+72)
#define WBCTRLA_GetTextInputHook  (WBA_Dummy+73)
#define WBCTRLA_SetTextInputHook  (WBA_Dummy+74)
#define WBCTRLA_AddSetupCleanupHook   (WBA_Dummy+78)
#define WBCTRLA_RemSetupCleanupHook   (WBA_Dummy+79)
OBJECT SetupCleanupHookMsg
  Length:ULONG,
  State:LONG

#define SCHMSTATE_TryCleanup  0
#define SCHMSTATE_Cleanup   1
#define SCHMSTATE_Setup     2
#define WBDZA_Left  (WBA_Dummy+26)
#define WBDZA_RelRight  (WBA_Dummy+27)
#define WBDZA_Top   (WBA_Dummy+28)
#define WBDZA_RelBottom   (WBA_Dummy+29)
#define WBDZA_Width   (WBA_Dummy+30)
#define WBDZA_RelWidth  (WBA_Dummy+31)
#define WBDZA_Height  (WBA_Dummy+32)
#define WBDZA_RelHeight   (WBA_Dummy+33)
#define WBDZA_Box   (WBA_Dummy+34)
#define WBDZA_Hook  (WBA_Dummy+35)
#define WBA_Reserved1   (WBA_Dummy+40)
#define WBA_Reserved2   (WBA_Dummy+41)
#define WBA_Reserved3   (WBA_Dummy+46)
#define WBA_Reserved4   (WBA_Dummy+49)
#define WBA_Reserved5   (WBA_Dummy+50)
#define WBA_Reserved6   (WBA_Dummy+51)
#define WBA_Reserved7   (WBA_Dummy+52)
#define WBA_Reserved8   (WBA_Dummy+53)
#define WBA_Reserved9   (WBA_Dummy+54)
#define WBA_Reserved10  (WBA_Dummy+55)
#define WBA_Reserved11  (WBA_Dummy+56)
#define WBA_Reserved12  (WBA_Dummy+57)
#define WBA_Reserved13  (WBA_Dummy+58)
#define WBA_Reserved14  (WBA_Dummy+59)
#define WBA_Reserved15  (WBA_Dummy+60)
#define WBA_Reserved16  (WBA_Dummy+61)
#define WBA_Reserved17  (WBA_Dummy+62)
#define WBA_Reserved18  (WBA_Dummy+63)
#define WBA_Reserved19  (WBA_Dummy+64)
#define WBA_Reserved20  (WBA_Dummy+67)
#define WBA_Reserved21  (WBA_Dummy+68)
#define WBA_LAST_TAG  (WBA_Dummy+79)
OBJECT AppIconRenderMsg
  RastPort:PTR TO RastPort,
  Icon:PTR TO DiskObject,
  Label:PTR TO UBYTE,
  Tags:PTR TO TagItem,
  Left:WORD,
  Top:WORD,
  Width:WORD,
  Height:WORD,
  State:ULONG

OBJECT AppWindowDropZoneMsg
  RastPort:PTR TO RastPort,
  DropZoneBox:IBox,
  ID:ULONG,
  UserData:ULONG,
  Action:LONG

#define ADZMACTION_Enter  (0)
#define ADZMACTION_Leave  (1)
OBJECT IconSelectMsg
  Length:ULONG,
  Drawer:PTR,
  Name:PTR TO UBYTE,
  Type:UWORD,
  Selected:BOOL,
  Tags:PTR TO TagItem,
  DrawerWindow:PTR TO Window,
  ParentWindow:PTR TO Window,
  Left:WORD,
  Top:WORD,
  Width:WORD,
  Height:WORD

#define ISMACTION_Unselect  (0)
#define ISMACTION_Select  (1)
#define ISMACTION_Ignore  (2)
#define ISMACTION_Stop    (3)
OBJECT CopyBeginMsg
  Length:ULONG,
  Action:LONG,
  SourceDrawer:PTR,
  DestinationDrawer:PTR

OBJECT CopyDataMsg
  Length:ULONG,
  Action:LONG,
  SourceLock:PTR,
  SourceName:PTR TO UBYTE,
  DestinationLock:PTR,
  DestinationName:PTR TO UBYTE,
  DestinationX:LONG,
  DestinationY:LONG

OBJECT CopyEndMsg
  Length:ULONG,
  Action:LONG

#define CPACTION_Begin    (0)
#define CPACTION_Copy     (1)
#define CPACTION_End    (2)
OBJECT DeleteBeginMsg
  Length:ULONG,
  Action:LONG

OBJECT DeleteDataMsg
  Length:ULONG,
  Action:LONG,
  Lock:PTR,
  Name:PTR TO UBYTE

OBJECT DeleteEndMsg
  Length:ULONG,
  Action:LONG

#define DLACTION_BeginDiscard     (0)
#define DLACTION_BeginEmptyTrash  (1)
#define DLACTION_DeleteContents     (3)
#define DLACTION_DeleteObject     (4)
#define DLACTION_End      (5)
OBJECT TextInputMsg
  Length:ULONG,
  Action:LONG,
  Prompt:PTR TO UBYTE

#define TIACTION_Rename     (0) 
#define TIACTION_RelabelVolume  (1) 
#define TIACTION_NewDrawer  (2) 
#define TIACTION_Execute  (3) 
#define UPDATEWB_ObjectRemoved  (0)
#define UPDATEWB_ObjectAdded  (1)
