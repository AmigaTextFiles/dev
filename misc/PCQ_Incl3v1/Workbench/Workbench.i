{
        Workbench.i for PCQ Pascal
}

{$I   "Include:Exec/Nodes.i"}
{$I   "Include:Exec/Lists.i"}
{$I   "Include:Exec/Tasks.i"}
{$I   "Include:Intuition/Intuition.i"}
{$I   "Include:WorkBench/Startup.i"}
{$I   "Include:DOS/DOS.i"}

VAR  WorkbenchBase : Address;

Const

    WBDISK              = 1;
    WBDRAWER            = 2;
    WBTOOL              = 3;
    WBPROJECT           = 4;
    WBGARBAGE           = 5;
    WBDEVICE            = 6;
    WBKICK              = 7;
    WBAPPICON           = 8;

Type

    OldDrawerData = record
        dd_NewWindow    : NewWindow;    { args to open window }
        dd_CurrentX     : Integer;      { current x coordinate of origin }
        dd_CurrentY     : Integer;      { current y coordinate of origin }
    end;
    OldDrawerDataPtr = ^OldDrawerData;

Const

{ the amount of DrawerData actually written to disk }

    OLDDRAWERDATAFILESIZE  = 56;  { sizeof(OldDrawerData) }

Type
    DrawerData = record
        dd_NewWindow    : NewWindow;    { args to open window }
        dd_CurrentX     : Integer;      { current x coordinate of origin }
        dd_CurrentY     : Integer;      { current y coordinate of origin }
        dd_Flags        : Integer;      { flags for drawer }
        dd_ViewModes    : Short;        { view mode for drawer }
    end;
    DrawerDataPtr = ^DrawerData;

Const

{ the amount of DrawerData actually written to disk }

    DRAWERDATAFILESIZE  = 62;  { sizeof(DrawerData) }


Type

    DiskObject = record
        do_Magic        : Short;        { a magic number at the start of the file }
        do_Version      : Short;        { a version number, so we can change it }
        do_Gadget       : Gadget;       { a copy of in core gadget }
        do_Type         : Byte;
        do_DefaultTool  : String;
        do_ToolTypes    : Address;
        do_CurrentX     : Integer;
        do_CurrentY     : Integer;
        do_DrawerData   : DrawerDataPtr;
        do_ToolWindow   : String;       { only applies to tools }
        do_StackSize    : Integer;      { only applies to tools }
    end;
    DiskObjectPtr = ^DiskObject;

Const

    WB_DISKMAGIC        = $e310;        { a magic number, not easily impersonated }
    WB_DISKVERSION      = 1;            { our current version number }
    WB_DISKREVISION     = 1;            { our current revision number }
  {I only use the lower 8 bits of Gadget.UserData for the revision # }
    WB_DISKREVISIONMASK = 255;
Type

    FreeList = record
        fl_NumFree      : Short;
        fl_MemList      : List;
    end;
    FreeListPtr = FreeList;

Const

{ each message that comes into the WorkBenchPort must have a type field
 * in the preceeding short.  These are the defines for this type
 }

    MTYPE_PSTD          = 1;    { a "standard Potion" message }
    MTYPE_TOOLEXIT      = 2;    { exit message from our tools }
    MTYPE_DISKCHANGE    = 3;    { dos telling us of a disk change }
    MTYPE_TIMER         = 4;    { we got a timer tick }
    MTYPE_CLOSEDOWN     = 5;    { <unimplemented> }
    MTYPE_IOPROC        = 6;    { <unimplemented> }
    MTYPE_APPWINDOW     = 7;    {     msg from an app window }
    MTYPE_APPICON       = 8;    {     msg from an app icon }
    MTYPE_APPMENUITEM   = 9;    {     msg from an app menuitem }
    MTYPE_COPYEXIT      = 10;   {     exit msg from copy process }
    MTYPE_ICONPUT       = 11;   {     msg from PutDiskObject in icon.library }


{ workbench does different complement modes for its gadgets.
 * It supports separate images, complement mode, and backfill mode.
 * The first two are identical to intuitions GADGIMAGE and GADGHCOMP.
 * backfill is similar to GADGHCOMP, but the region outside of the
 * image (which normally would be color three when complemented)
 * is flood-filled to color zero.
 }

    GFLG_GADGBACKFILL   = $0001;
    GADGBACKFILL        = $0001;   { an old synonym }

{ if an icon does not really live anywhere, set its current position
 * to here
 }

    NO_ICON_POSITION    = $80000000;

{    workbench now is a library.  this is it's name }
CONST
 WORKBENCH_NAME    =      "workbench.library";

{    If you find am_Version >= AM_VERSION, you know this structure has
 * at least the fields defined in this version of the include file
 }
 AM_VERSION   =   1;

Type
   AppMessage = Record
    am_Message       : Message;            {    standard message structure }
    am_Type          : Short;              {    message type }
    am_UserData      : Integer;            {    application specific }
    am_ID            : Integer;            {    application definable ID }
    am_NumArgs       : Integer;            {    # of elements in arglist }
    am_ArgList       : WBArgListPtr;       {    the arguements themselves }
    am_Version       : Short;              {    will be AM_VERSION }
    am_Class         : Short;              {    message class }
    am_MouseX        : Short;              {    mouse x position of event }
    am_MouseY        : Short;              {    mouse y position of event }
    am_Seconds       : Integer;            {    current system clock time }
    am_Micros        : Integer;            {    current system clock time }
    am_Reserved      : Array[0..7] of Integer;       {    avoid recompilation }
   END;
   AppMessagePtr = ^AppMessage;

{
 * The following structures are private.  These are just stub
 * structures for code compatibility...
 }
 AppWindow = Record aw_PRIVATE : Address; END;
 AppWindowPtr = ^AppWindow;
 AppIcon = Record ai_PRIVATE : Address; END;
 AppIconPtr = ^AppIcon;
 AppMenuItem = Record ami_PRIVATE : Address; END;
 AppMenuItemPtr = ^AppMenuItem;


 FUNCTION AddAppWindowA(ID, UserData : Integer; Win : WindowPtr; 
                        Port : MsgPortPtr; TagList : Address) : AppWindowPtr;
  External;

 FUNCTION RemoveAppWindow(AppWin : AppWindowPtr) : Boolean;
  External;

 FUNCTION AddAppIconA(ID, UserData : Integer; Txt : String; Port : MsgPortPtr;
                      FL : FileLock; diskobj : DiskObjectPtr; taglist : Address) : AppIconPtr;
  External;

 FUNCTION RemoveAppIcon(AIcon : AppIconPtr) : Boolean;
  External;

 FUNCTION AddAppMenuItem(ID, UserData : Integer; Txt : String; Port : MsgPortPtr;
                         taglist : Address) : AppMenuItemPtr;
  External;

 FUNCTION RemoveAppMenuItem(AppMI : AppMenuItemPtr) : Boolean;
  External;


 { --- functions in V39 or higher (Release 3) --- }

 PROCEDURE WBInfo(l : Address; name : String; Scr : ScreenPtr);
                 { l = lock }
    External;


