include "inc/exec/types.inc";
include "inc/exec/nodes.inc";
include "inc/exec/lists.inc";
include "inc/exec/tasks.inc";
include "inc/intuition/intuition.inc";

def WBDISK = 1;
def WBDRAWER = 2;
def WBTOOL = 3;
def WBPROJECT = 4;
def WBGARBAGE = 5;
def WBDEVICE = 6;
def WBKICK = 7;
def WBAPPICON = 8;

struct DrawerData is
  dd_NewWindow:NewWindow;
  dd_CurrentX:long;
  dd_CurrentY:long;
  dd_Flags:ulong;
  dd_ViewModes:uword;
;

def DRAWERDATAFILESIZE = (sizeof(DrawerData));

struct DiskObject is
  do_Magic:uword;
  do_Version:uword;
  do_Gadget:Gadget;
  do_Type:ubyte;
  do_DefaultTool:ulong;
  do_ToolTypes:ulong;
  do_CurrentX:long;
  do_CurrentY:long;
  do_DrawerData:ulong;
  do_ToolWindow:ulong;
  do_StackSize:long;

;

def WB_DISKMAGIC = $e310;
def WB_DISKVERSION = 1;
def WB_DISKREVISION = 1;

def WB_DISKREVISIONMASK = 255;

struct FreeList is
  fl_NumFree:word;
  fl_MemList:List;
;

def GFLG_GADGBACKFILL = $0001;

def NO_ICON_POSITION = ($80000000);

def WORKBENCH_NAME = "workbench.library";

def AM_VERSION = 1;

struct AppMessage is
  am_Message:Message;
  am_Type:uword;
  am_UserData:ulong;
  am_ID:ulong;
  am_NumArgs:long;
  am_ArgList:ulong;
  am_Version:uword;
  am_Class:uword;
  am_MouseX:word;
  am_MouseY:word;
  am_Seconds:ulong;
  am_Micros:ulong;
  am_Reserved[8]:ulong;
;

def AMTYPE_APPWINDOW = 7;
def AMTYPE_APPICON = 8;
def AMTYPE_APPMENUITEM = 9;

struct AppWindow is
  aw_PRIVATE:ulong;
;

struct AppIcon is
  ai_PRIVATE:ulong;
;

struct AppMenuItem is
  ami_PRIVATE:ulong;
;

