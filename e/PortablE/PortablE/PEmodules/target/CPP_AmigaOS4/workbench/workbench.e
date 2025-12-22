/* $Id: workbench.h,v 1.16 2005/11/10 15:39:42 hjfrieden Exp $ */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/tasks', 'target/dos/dos', 'target/intuition/intuition'
MODULE 'target/utility/tagitem', 'target/exec/types', 'target/exec/lists', 'target/exec/ports', 'target/workbench/startup', 'target/graphics/rastport'
{#include <workbench/workbench.h>}
NATIVE {WORKBENCH_WORKBENCH_H} CONST

NATIVE {WBDISK}    CONST WBDISK    = 1
NATIVE {WBDRAWER}  CONST WBDRAWER  = 2
NATIVE {WBTOOL}    CONST WBTOOL    = 3
NATIVE {WBPROJECT} CONST WBPROJECT = 4
NATIVE {WBGARBAGE} CONST WBGARBAGE = 5
NATIVE {WBDEVICE}  CONST WBDEVICE  = 6
NATIVE {WBKICK}    CONST WBKICK    = 7
NATIVE {WBAPPICON} CONST WBAPPICON = 8

NATIVE {OldDrawerData} OBJECT olddrawerdata
    {dd_NewWindow}	newwindow	:nw /* args to open window */
    {dd_CurrentX}	currentx	:VALUE  /* current x coordinate of origin */
    {dd_CurrentY}	currenty	:VALUE  /* current y coordinate of origin */
ENDOBJECT
/* the amount of DrawerData actually written to disk */
NATIVE {OLDDRAWERDATAFILESIZE} CONST OLDDRAWERDATAFILESIZE = $38	->(sizeof(struct OldDrawerData))

NATIVE {DrawerData} OBJECT drawerdata
    {dd_NewWindow}	newwindow	:nw /* args to open window */
    {dd_CurrentX}	currentx	:VALUE  /* current x coordinate of origin */
    {dd_CurrentY}	currenty	:VALUE  /* current y coordinate of origin */
    {dd_Flags}	flags	:ULONG     /* flags for drawer */
    {dd_ViewModes}	viewmodes	:UINT /* view mode for drawer */
ENDOBJECT
/* the amount of DrawerData actually written to disk */
NATIVE {DRAWERDATAFILESIZE} CONST DRAWERDATAFILESIZE = $3E	->(sizeof(struct DrawerData))

/* definitions for dd_ViewModes */
NATIVE {DDVM_BYDEFAULT} CONST DDVM_BYDEFAULT = 0 /* default (inherit parent's view mode) */
NATIVE {DDVM_BYICON}    CONST DDVM_BYICON    = 1 /* view as icons */
NATIVE {DDVM_BYNAME}    CONST DDVM_BYNAME    = 2 /* view as text, sorted by name */
NATIVE {DDVM_BYDATE}    CONST DDVM_BYDATE    = 3 /* view as text, sorted by date */
NATIVE {DDVM_BYSIZE}    CONST DDVM_BYSIZE    = 4 /* view as text, sorted by size */
NATIVE {DDVM_BYTYPE}    CONST DDVM_BYTYPE    = 5 /* view as text, sorted by type */

/* definitions for dd_Flags */
NATIVE {DDFLAGS_SHOWDEFAULT} CONST DDFLAGS_SHOWDEFAULT = 0 /* default (show only icons) */
NATIVE {DDFLAGS_SHOWICONS}   CONST DDFLAGS_SHOWICONS   = 1 /* show only icons */
NATIVE {DDFLAGS_SHOWALL}     CONST DDFLAGS_SHOWALL     = 2 /* show all files */

NATIVE {DiskObject} OBJECT diskobject
    {do_Magic}	magic	:UINT   /* magic number at the start of the file */
    {do_Version}	version	:UINT /* a version number, so we can change it */
    {do_Gadget}	gadget	:gadget  /* a copy of in core gadget */
    {do_Type}	type	:UBYTE
    {do_DefaultTool } pad_byte:NATIVE {STRPTR} VALUE	->hack to fix typed lists
    {do_DefaultTool}	defaulttool	:/*STRPTR*/ ARRAY OF CHAR
    {do_ToolTypes}	tooltypes	:ARRAY OF /*STRPTR*/ ARRAY OF CHAR
    {do_CurrentX}	currentx	:VALUE
    {do_CurrentY}	currenty	:VALUE
    {do_DrawerData}	drawerdata	:PTR TO drawerdata
    {do_ToolWindow}	toolwindow	:/*STRPTR*/ ARRAY OF CHAR  /* only applies to tools */
    {do_StackSize}	stacksize	:VALUE   /* only applies to tools */
ENDOBJECT

NATIVE {WB_DISKMAGIC}       CONST WB_DISKMAGIC       = $e310 /* a magic number, not easily impersonated */
NATIVE {WB_DISKVERSION}          CONST WB_DISKVERSION          = 1 /* our current version number */
NATIVE {WB_DISKREVISION}         CONST WB_DISKREVISION         = 1 /* our current revision number */
/* I only use the lower 8 bits of Gadget.UserData for the revision # */
NATIVE {WB_DISKREVISIONMASK}   CONST WB_DISKREVISIONMASK   = 255

NATIVE {FreeList} OBJECT freelist
    {fl_NumFree}	numfree	:INT
    {fl_MemList}	memlist	:lh
ENDOBJECT

/* workbench does different complement modes for its gadgets.
** It supports separate images, complement mode, and backfill mode.
** The first two are identical to intuitions GFLG_GADGIMAGE and GFLG_GADGHCOMP.
** backfill is similar to GFLG_GADGHCOMP, but the region outside of the
** image (which normally would be color three when complemented)
** is flood-filled to color zero.
*/
NATIVE {GFLG_GADGBACKFILL} CONST GFLG_GADGBACKFILL = $0001
NATIVE {GADGBACKFILL}      CONST GADGBACKFILL      = $0001 /* an old synonym */

/* if an icon does not really live anywhere, set its current position
** to here
*/
NATIVE {NO_ICON_POSITION} CONST NO_ICON_POSITION = ($80000000)

/* workbench now is a library.  this is it's name */
NATIVE {WORKBENCH_NAME} CONST
#define WORKBENCH_NAME workbench_name
STATIC workbench_name = 'workbench.library'

/****************************************************************************/

/* If you find am_Version >= AM_VERSION, you know this structure has
 * at least the fields defined in this version of the include file
 */
NATIVE {AM_VERSION} CONST AM_VERSION = 1

NATIVE {AppMessage} OBJECT appmessage
    {am_Message}	message	:mn     /* standard message structure */
    {am_Type}	type	:UINT        /* message type               */
    {am_UserData}	userdata	:ULONG    /* application specific       */
    {am_ID}	id	:ULONG          /* application definable ID   */
    {am_NumArgs}	numargs	:VALUE     /* # of elements in arglist   */
    {am_ArgList}	arglist	:ARRAY OF wbarg     /* the arguments themselves   */
    {am_Version}	version	:UINT     /* will be >= AM_VERSION      */
    {am_Class}	class	:UINT       /* message class              */
    {am_MouseX}	mousex	:INT      /* mouse x position of event  */
    {am_MouseY}	mousey	:INT      /* mouse y position of event  */
    {am_Seconds}	seconds	:ULONG     /* current system clock time  */
    {am_Micros}	micros	:ULONG      /* current system clock time  */
    {am_Reserved}	reserved[8]	:ARRAY OF ULONG /* avoid recompilation        */
ENDOBJECT

/* types of app messages */
NATIVE {AMTYPE_APPWINDOW}      CONST AMTYPE_APPWINDOW      = 7 /* app window message           */
NATIVE {AMTYPE_APPICON}        CONST AMTYPE_APPICON        = 8 /* app icon message             */
NATIVE {AMTYPE_APPMENUITEM}    CONST AMTYPE_APPMENUITEM    = 9 /* app menu item message        */
NATIVE {AMTYPE_APPWINDOWZONE} CONST AMTYPE_APPWINDOWZONE = 10 /* app window drop zone message */

/* Classes of AppIcon messages (V44) */
NATIVE {AMCLASSICON_Open}        CONST AMCLASSICON_OPEN        = 0 /* The "Open" menu item was invoked,
                                   * the icon got double-clicked or an
                                   * icon got dropped on it.
                                   */
NATIVE {AMCLASSICON_Copy}        CONST AMCLASSICON_COPY        = 1 /* The "Copy" menu item was invoked */
NATIVE {AMCLASSICON_Rename}      CONST AMCLASSICON_RENAME      = 2 /* The "Rename" menu item was invoked */
NATIVE {AMCLASSICON_Information} CONST AMCLASSICON_INFORMATION = 3 /* The "Information" menu item was invoked */
NATIVE {AMCLASSICON_Snapshot}    CONST AMCLASSICON_SNAPSHOT    = 4 /* The "Snapshot" menu item was invoked */
NATIVE {AMCLASSICON_UnSnapshot}  CONST AMCLASSICON_UNSNAPSHOT  = 5 /* The "UnSnapshot" menu item was invoked */
NATIVE {AMCLASSICON_LeaveOut}    CONST AMCLASSICON_LEAVEOUT    = 6 /* The "Leave Out" menu item was invoked */
NATIVE {AMCLASSICON_PutAway}     CONST AMCLASSICON_PUTAWAY     = 7 /* The "Put Away" menu item was invoked */
NATIVE {AMCLASSICON_Delete}      CONST AMCLASSICON_DELETE      = 8 /* The "Delete" menu item was invoked */
NATIVE {AMCLASSICON_FormatDisk}  CONST AMCLASSICON_FORMATDISK  = 9 /* The "Format Disk" menu item was invoked */
NATIVE {AMCLASSICON_EmptyTrash} CONST AMCLASSICON_EMPTYTRASH = 10 /* The "Empty Trash" menu item was invoked */

NATIVE {AMCLASSICON_Selected}   CONST AMCLASSICON_SELECTED   = 11 /* The icon is now selected */
NATIVE {AMCLASSICON_Unselected} CONST AMCLASSICON_UNSELECTED = 12 /* The icon is now unselected */

/*
 * The following structures are private.  These are just stub
 * structures for code compatibility...
 */
NATIVE {AppWindow} OBJECT appwindow
	{aw_PRIVATE}	private	:PTR
ENDOBJECT
NATIVE {AppWindowDropZone} OBJECT appwindowdropzone
	{awdz_PRIVATE}	private	:PTR
ENDOBJECT
NATIVE {AppIcon} OBJECT appicon
	{ai_PRIVATE}	private	:PTR
ENDOBJECT
NATIVE {AppMenuItem} OBJECT appmenuitem
	{ami_PRIVATE}	private	:PTR
ENDOBJECT
NATIVE {AppMenu} OBJECT appmenu
	{am_PRIVATE}	private	:PTR
ENDOBJECT

/****************************************************************************/

NATIVE {WBA_Dummy} CONST WBA_DUMMY = (TAG_USER+$A000)

/****************************************************************************/

/* Tags for use with AddAppIconA() */

/* AppIcon responds to the "Open" menu item (BOOL). */
NATIVE {WBAPPICONA_SupportsOpen}        CONST WBAPPICONA_SUPPORTSOPEN        = (WBA_DUMMY+1)

/* AppIcon responds to the "Copy" menu item (BOOL). */
NATIVE {WBAPPICONA_SupportsCopy}        CONST WBAPPICONA_SUPPORTSCOPY        = (WBA_DUMMY+2)

/* AppIcon responds to the "Rename" menu item (BOOL). */
NATIVE {WBAPPICONA_SupportsRename}      CONST WBAPPICONA_SUPPORTSRENAME      = (WBA_DUMMY+3)

/* AppIcon responds to the "Information" menu item (BOOL). */
NATIVE {WBAPPICONA_SupportsInformation} CONST WBAPPICONA_SUPPORTSINFORMATION = (WBA_DUMMY+4)

/* AppIcon responds to the "Snapshot" menu item (BOOL). */
NATIVE {WBAPPICONA_SupportsSnapshot}    CONST WBAPPICONA_SUPPORTSSNAPSHOT    = (WBA_DUMMY+5)

/* AppIcon responds to the "UnSnapshot" menu item (BOOL). */
NATIVE {WBAPPICONA_SupportsUnSnapshot}  CONST WBAPPICONA_SUPPORTSUNSNAPSHOT  = (WBA_DUMMY+6)

/* AppIcon responds to the "LeaveOut" menu item (BOOL). */
NATIVE {WBAPPICONA_SupportsLeaveOut}    CONST WBAPPICONA_SUPPORTSLEAVEOUT    = (WBA_DUMMY+7)

/* AppIcon responds to the "PutAway" menu item (BOOL). */
NATIVE {WBAPPICONA_SupportsPutAway}     CONST WBAPPICONA_SUPPORTSPUTAWAY     = (WBA_DUMMY+8)

/* AppIcon responds to the "Delete" menu item (BOOL). */
NATIVE {WBAPPICONA_SupportsDelete}      CONST WBAPPICONA_SUPPORTSDELETE      = (WBA_DUMMY+9)

/* AppIcon responds to the "FormatDisk" menu item (BOOL). */
NATIVE {WBAPPICONA_SupportsFormatDisk}  CONST WBAPPICONA_SUPPORTSFORMATDISK  = (WBA_DUMMY+10)

/* AppIcon responds to the "EmptyTrash" menu item (BOOL). */
NATIVE {WBAPPICONA_SupportsEmptyTrash}  CONST WBAPPICONA_SUPPORTSEMPTYTRASH  = (WBA_DUMMY+11)

/* AppIcon position should be propagated back to original DiskObject (BOOL). */
NATIVE {WBAPPICONA_PropagatePosition}   CONST WBAPPICONA_PROPAGATEPOSITION   = (WBA_DUMMY+12)

/* Callback hook to be invoked when rendering this icon (struct Hook *). */
NATIVE {WBAPPICONA_RenderHook}          CONST WBAPPICONA_RENDERHOOK          = (WBA_DUMMY+13)

/* AppIcon wants to be notified when its select state changes (BOOL). */
NATIVE {WBAPPICONA_NotifySelectState}   CONST WBAPPICONA_NOTIFYSELECTSTATE   = (WBA_DUMMY+14)

/****************************************************************************/

/* Tags for use with AddAppMenuA() */

/* Command key string for this AppMenu (STRPTR). */
NATIVE {WBAPPMENUA_CommandKeyString}    CONST WBAPPMENUA_COMMANDKEYSTRING    = (WBA_DUMMY+15)

/* Item to be added should get sub menu items attached to; make room for it,
 * then return the key to use later for attaching the items (ULONG *).
 */
NATIVE {WBAPPMENUA_GetKey}              CONST WBAPPMENUA_GETKEY              = (WBA_DUMMY+65)

/* This item should be attached to a sub menu; the key provided refers to
 * the sub menu it should be attached to (ULONG).
 */
NATIVE {WBAPPMENUA_UseKey}              CONST WBAPPMENUA_USEKEY              = (WBA_DUMMY+66)

/* Item to be added is in fact a new menu title; make room for it, then
 * return the key to use later for attaching the items (ULONG *).
 */
NATIVE {WBAPPMENUA_GetTitleKey}         CONST WBAPPMENUA_GETTITLEKEY         = (WBA_DUMMY+77)

/****************************************************************************/

/* Tags for use with OpenWorkbenchObjectA() */

/* Corresponds to the wa_Lock member of a struct WBArg */
NATIVE {WBOPENA_ArgLock}                CONST WBOPENA_ARGLOCK                = (WBA_DUMMY+16)

/* Corresponds to the wa_Name member of a struct WBArg */
NATIVE {WBOPENA_ArgName}                CONST WBOPENA_ARGNAME                = (WBA_DUMMY+17)

/* When opening a drawer, show all files or only icons?
 * This must be one out of DDFLAGS_SHOWICONS,
 * or DDFLAGS_SHOWALL; (UBYTE); (V45)
 */
NATIVE {WBOPENA_Show}                   CONST WBOPENA_SHOW                   = (WBA_DUMMY+75)

/* When opening a drawer, view the contents by icon, name,
 * date, size or type? This must be one out of DDVM_BYICON,
 * DDVM_BYNAME, DDVM_BYDATE, DDVM_BYSIZE or DDVM_BYTYPE;
 * (UBYTE); (V45)
 */
NATIVE {WBOPENA_ViewBy}                 CONST WBOPENA_VIEWBY                 = (WBA_DUMMY+76)

/****************************************************************************/

/* Tags for use with ChangeWorkbenchSelectionA() */

/* Return the full path name of an icon, rather than just
 * the object name (BOOL). (V50)
 */
NATIVE {WBSELA_GetFullName}             CONST WBSELA_GETFULLNAME             = (WBA_DUMMY+106)

/****************************************************************************/

/* Tags for use with WorkbenchControlA() */

/* Check if the named drawer is currently open (LONG *). */
NATIVE {WBCTRLA_IsOpen}                 CONST WBCTRLA_ISOPEN                 = (WBA_DUMMY+18)

/* Create a duplicate of the Workbench private search path list (BPTR *). */
NATIVE {WBCTRLA_DuplicateSearchPath}    CONST WBCTRLA_DUPLICATESEARCHPATH    = (WBA_DUMMY+19)

/* Free the duplicated search path list (BPTR). */
NATIVE {WBCTRLA_FreeSearchPath}         CONST WBCTRLA_FREESEARCHPATH         = (WBA_DUMMY+20)

/* Get the default stack size for launching programs with (ULONG *). */
NATIVE {WBCTRLA_GetDefaultStackSize}    CONST WBCTRLA_GETDEFAULTSTACKSIZE    = (WBA_DUMMY+21)

/* Set the default stack size for launching programs with (ULONG). */
NATIVE {WBCTRLA_SetDefaultStackSize}    CONST WBCTRLA_SETDEFAULTSTACKSIZE    = (WBA_DUMMY+22)

/* Cause an AppIcon to be redrawn (struct AppIcon *). */
NATIVE {WBCTRLA_RedrawAppIcon}          CONST WBCTRLA_REDRAWAPPICON          = (WBA_DUMMY+23)

/* Get a list of currently running Workbench programs (struct List **). */
NATIVE {WBCTRLA_GetProgramList}         CONST WBCTRLA_GETPROGRAMLIST         = (WBA_DUMMY+24)

/* Release the list of currently running Workbench programs (struct List *). */
NATIVE {WBCTRLA_FreeProgramList}        CONST WBCTRLA_FREEPROGRAMLIST        = (WBA_DUMMY+25)

/* Get a list of currently selected icons (struct List **). */
NATIVE {WBCTRLA_GetSelectedIconList}    CONST WBCTRLA_GETSELECTEDICONLIST    = (WBA_DUMMY+36)

/* Release the list of currently selected icons (struct List *). */
NATIVE {WBCTRLA_FreeSelectedIconList}   CONST WBCTRLA_FREESELECTEDICONLIST   = (WBA_DUMMY+37)

/* Get a list of currently open drawers (struct List **). */
NATIVE {WBCTRLA_GetOpenDrawerList}      CONST WBCTRLA_GETOPENDRAWERLIST      = (WBA_DUMMY+38)

/* Release the list of currently open icons (struct List *). */
NATIVE {WBCTRLA_FreeOpenDrawerList}     CONST WBCTRLA_FREEOPENDRAWERLIST     = (WBA_DUMMY+39)

/* Get the list of hidden devices (struct List **). */
NATIVE {WBCTRLA_GetHiddenDeviceList}    CONST WBCTRLA_GETHIDDENDEVICELIST    = (WBA_DUMMY+42)

/* Release the list of hidden devices (struct List *). */
NATIVE {WBCTRLA_FreeHiddenDeviceList}   CONST WBCTRLA_FREEHIDDENDEVICELIST   = (WBA_DUMMY+43)

/* Add the name of a device which Workbench should never try to
 * read a disk icon from (STRPTR).
 */
NATIVE {WBCTRLA_AddHiddenDeviceName}    CONST WBCTRLA_ADDHIDDENDEVICENAME    = (WBA_DUMMY+44)

/* Remove a name from list of hidden devices (STRPTR). */
NATIVE {WBCTRLA_RemoveHiddenDeviceName} CONST WBCTRLA_REMOVEHIDDENDEVICENAME = (WBA_DUMMY+45)

/* Get the number of seconds that have to pass before typing
 * the next character in a drawer window will restart
 * with a new file name (ULONG *).
 */
NATIVE {WBCTRLA_GetTypeRestartTime}     CONST WBCTRLA_GETTYPERESTARTTIME     = (WBA_DUMMY+47)

/* Set the number of seconds that have to pass before typing
 * the next character in a drawer window will restart
 * with a new file name (ULONG).
 */
NATIVE {WBCTRLA_SetTypeRestartTime}     CONST WBCTRLA_SETTYPERESTARTTIME     = (WBA_DUMMY+48)

/* Obtain the hook that will be invoked when Workbench starts
 * to copy files and data (struct Hook **); (V45)
 */
NATIVE {WBCTRLA_GetCopyHook}            CONST WBCTRLA_GETCOPYHOOK            = (WBA_DUMMY+69)

/* Install the hook that will be invoked when Workbench starts
 * to copy files and data (struct Hook *); (V45)
 */
NATIVE {WBCTRLA_SetCopyHook}            CONST WBCTRLA_SETCOPYHOOK            = (WBA_DUMMY+70)

/* Obtain the hook that will be invoked when Workbench discards
 * files and drawers or empties the trashcan (struct Hook **);
 * (V45).
 */
NATIVE {WBCTRLA_GetDeleteHook}          CONST WBCTRLA_GETDELETEHOOK          = (WBA_DUMMY+71)

/* Install the hook that will be invoked when Workbench discards
 * files and drawers or empties the trashcan (struct Hook *);
 * (V45).
 */
NATIVE {WBCTRLA_SetDeleteHook}          CONST WBCTRLA_SETDELETEHOOK          = (WBA_DUMMY+72)

/* Obtain the hook that will be invoked when Workbench requests
 * that the user enters text, such as when a file is to be renamed
 * or a new drawer is to be created (struct Hook **); (V45)
 */
NATIVE {WBCTRLA_GetTextInputHook}       CONST WBCTRLA_GETTEXTINPUTHOOK       = (WBA_DUMMY+73)

/* Install the hook that will be invoked when Workbench requests
 * that the user enters text, such as when a file is to be renamed
 * or a new drawer is to be created (struct Hook *); (V45)
 */
NATIVE {WBCTRLA_SetTextInputHook}       CONST WBCTRLA_SETTEXTINPUTHOOK       = (WBA_DUMMY+74)

/* Add a hook that will be invoked when Workbench is about
 * to shut down (cleanup), and when Workbench has returned
 * to operational state (setup) (struct Hook *); (V45)
 */
NATIVE {WBCTRLA_AddSetupCleanupHook}    CONST WBCTRLA_ADDSETUPCLEANUPHOOK    = (WBA_DUMMY+78)

/* Remove a hook that has been installed with the
 * WBCTRLA_AddSetupCleanupHook tag (struct Hook *); (V45)
 */
NATIVE {WBCTRLA_RemSetupCleanupHook}    CONST WBCTRLA_REMSETUPCLEANUPHOOK    = (WBA_DUMMY+79)

/* Enable WBCTRLA_GetSelectedIconList to return icons which don't
 * actually have an associated file or directory (BOOL). (V50)
 */
NATIVE {WBCTRLA_AllowLoneIcons}         CONST WBCTRLA_ALLOWLONEICONS         = (WBA_DUMMY+107)

/* Get a list of currently displayed AppIcons (struct List **). (V50) */
NATIVE {WBCTRLA_GetAppIconList}         CONST WBCTRLA_GETAPPICONLIST         = (WBA_DUMMY+110)

/* Release the list of currently displayed AppIcons (struct List *). (V50) */
NATIVE {WBCTRLA_FreeAppIconList}        CONST WBCTRLA_FREEAPPICONLIST        = (WBA_DUMMY+111)

/****************************************************************************/

/* The message your setup/cleanup hook gets invoked with. */
NATIVE {SetupCleanupHookMsg} OBJECT setupcleanuphookmsg
    {schm_Length}	length	:ULONG /* Size of this data structure (in bytes). */
    {schm_State}	state	:VALUE  /* See below for definitions. */
ENDOBJECT

NATIVE {SCHMSTATE_TryCleanup} CONST SCHMSTATE_TRYCLEANUP = 0 /* Workbench will attempt to shut down now. */
NATIVE {SCHMSTATE_Cleanup}    CONST SCHMSTATE_CLEANUP    = 1 /* Workbench will really shut down now. */
NATIVE {SCHMSTATE_Setup}      CONST SCHMSTATE_SETUP      = 2 /* Workbench is operational again or
                                * could not be shut down.
                                */

/****************************************************************************/

/* Tags for use with AddAppWindowDropZoneA() */

/* Zone left edge (WORD) */
NATIVE {WBDZA_Left}      CONST WBDZA_LEFT      = (WBA_DUMMY+26)

/* Zone left edge, if relative to the right edge of the window (WORD) */
NATIVE {WBDZA_RelRight}  CONST WBDZA_RELRIGHT  = (WBA_DUMMY+27)

/* Zone top edge (WORD) */
NATIVE {WBDZA_Top}       CONST WBDZA_TOP       = (WBA_DUMMY+28)

/* Zone top edge, if relative to the bottom edge of the window (WORD) */
NATIVE {WBDZA_RelBottom} CONST WBDZA_RELBOTTOM = (WBA_DUMMY+29)

/* Zone width (WORD) */
NATIVE {WBDZA_Width}     CONST WBDZA_WIDTH     = (WBA_DUMMY+30)

/* Zone width, if relative to the window width (WORD) */
NATIVE {WBDZA_RelWidth}  CONST WBDZA_RELWIDTH  = (WBA_DUMMY+31)

/* Zone height (WORD) */
NATIVE {WBDZA_Height}    CONST WBDZA_HEIGHT    = (WBA_DUMMY+32)

/* Zone height, if relative to the window height (WORD) */
NATIVE {WBDZA_RelHeight} CONST WBDZA_RELHEIGHT = (WBA_DUMMY+33)

/* Zone position and size (struct IBox *). */
NATIVE {WBDZA_Box}       CONST WBDZA_BOX       = (WBA_DUMMY+34)

/* Hook to invoke when the mouse enters or leave a drop zone (struct Hook *).
 */
NATIVE {WBDZA_Hook}      CONST WBDZA_HOOK      = (WBA_DUMMY+35)

/****************************************************************************/

/* Tags for use with WhichWorkbenchObjectA() (V50) */

/* Type of icon: one of the WB#? definitions from above (ULONG *). */
NATIVE {WBOBJA_Type}           CONST WBOBJA_TYPE           = (WBA_DUMMY+86)

/* Left offset of the icon box relative to its parent window (LONG *). */
NATIVE {WBOBJA_Left}           CONST WBOBJA_LEFT           = (WBA_DUMMY+87)

/* Top offset of the icon box relative to its parent window (LONG *). */
NATIVE {WBOBJA_Top}            CONST WBOBJA_TOP            = (WBA_DUMMY+88)

/* Width of the icon box, including border (ULONG *). */
NATIVE {WBOBJA_Width}          CONST WBOBJA_WIDTH          = (WBA_DUMMY+89)

/* Height of the icon box, including border (ULONG *). */
NATIVE {WBOBJA_Height}         CONST WBOBJA_HEIGHT         = (WBA_DUMMY+90)

/* Current state of the icon: IDS_NORMAL, IDS_SELECTED... (ULONG *). */
NATIVE {WBOBJA_State}          CONST WBOBJA_STATE          = (WBA_DUMMY+91)

/* Is the icon a fake one (i.e. without a real .info file)? (ULONG *). */
NATIVE {WBOBJA_IsFake}         CONST WBOBJA_ISFAKE         = (WBA_DUMMY+92)

/* Name of the icon as displayed in the Workbench window (STRPTR). */
NATIVE {WBOBJA_Name}           CONST WBOBJA_NAME           = (WBA_DUMMY+93)

/* Size of the buffer provided with WBOBJA_Name; default is 64 (ULONG). */
NATIVE {WBOBJA_NameSize}       CONST WBOBJA_NAMESIZE       = (WBA_DUMMY+94)

/* Full path (if applicable) of the object the icon represents (STRPTR). */
NATIVE {WBOBJA_FullPath}       CONST WBOBJA_FULLPATH       = (WBA_DUMMY+95)

/* Size of the buffer provided with WBOBJA_FullPath; default is 512 (ULONG). */
NATIVE {WBOBJA_FullPathSize}   CONST WBOBJA_FULLPATHSIZE   = (WBA_DUMMY+96)

/* Does the icon represent a link, rather than a real file? (ULONG *). */
NATIVE {WBOBJA_IsLink}         CONST WBOBJA_ISLINK         = (WBA_DUMMY+97)

/* Path of the drawer whose window the given coordinates fall into (STRPTR). */
NATIVE {WBOBJA_DrawerPath}     CONST WBOBJA_DRAWERPATH     = (WBA_DUMMY+98)

/* Size of the buffer provided with WBOBJA_DrawerPath; default is 64 (ULONG).
 */
NATIVE {WBOBJA_DrawerPathSize} CONST WBOBJA_DRAWERPATHSIZE = (WBA_DUMMY+99)

/* Current flags of the drawer found at the given coordinates (ULONG *). */
NATIVE {WBOBJA_DrawerFlags}    CONST WBOBJA_DRAWERFLAGS    = (WBA_DUMMY+116)

/* Current viewmodes of the drawer found at the given coordinates (ULONG *). */
NATIVE {WBOBJA_DrawerModes}    CONST WBOBJA_DRAWERMODES    = (WBA_DUMMY+117)

/****************************************************************************/

/* Possible results from WhichWorkbenchObjectA() (V50) */

NATIVE {WBO_NONE}   CONST WBO_NONE   = (0)  /* No Workbench object is found at these coordinates */
NATIVE {WBO_DRAWER} CONST WBO_DRAWER = (1)  /* A drawer window is found at these coordinates */
NATIVE {WBO_ICON}   CONST WBO_ICON   = (2)  /* An icon is found at these coordinates */

/****************************************************************************/

/* Reserved tags; don't use! */
NATIVE {WBA_Reserved1}   CONST WBA_RESERVED1   = (WBA_DUMMY+40)
NATIVE {WBA_Reserved2}   CONST WBA_RESERVED2   = (WBA_DUMMY+41)
NATIVE {WBA_Reserved3}   CONST WBA_RESERVED3   = (WBA_DUMMY+46)
NATIVE {WBA_Reserved4}   CONST WBA_RESERVED4   = (WBA_DUMMY+49)
NATIVE {WBA_Reserved5}   CONST WBA_RESERVED5   = (WBA_DUMMY+50)
NATIVE {WBA_Reserved6}   CONST WBA_RESERVED6   = (WBA_DUMMY+51)
NATIVE {WBA_Reserved7}   CONST WBA_RESERVED7   = (WBA_DUMMY+52)
NATIVE {WBA_Reserved8}   CONST WBA_RESERVED8   = (WBA_DUMMY+53)
NATIVE {WBA_Reserved9}   CONST WBA_RESERVED9   = (WBA_DUMMY+54)
NATIVE {WBA_Reserved10}  CONST WBA_RESERVED10  = (WBA_DUMMY+55)
NATIVE {WBA_Reserved11}  CONST WBA_RESERVED11  = (WBA_DUMMY+56)
NATIVE {WBA_Reserved12}  CONST WBA_RESERVED12  = (WBA_DUMMY+57)
NATIVE {WBA_Reserved13}  CONST WBA_RESERVED13  = (WBA_DUMMY+58)
NATIVE {WBA_Reserved14}  CONST WBA_RESERVED14  = (WBA_DUMMY+59)
NATIVE {WBA_Reserved15}  CONST WBA_RESERVED15  = (WBA_DUMMY+60)
NATIVE {WBA_Reserved16}  CONST WBA_RESERVED16  = (WBA_DUMMY+61)
NATIVE {WBA_Reserved17}  CONST WBA_RESERVED17  = (WBA_DUMMY+62)
NATIVE {WBA_Reserved18}  CONST WBA_RESERVED18  = (WBA_DUMMY+63)
NATIVE {WBA_Reserved19}  CONST WBA_RESERVED19  = (WBA_DUMMY+64)
NATIVE {WBA_Reserved20}  CONST WBA_RESERVED20  = (WBA_DUMMY+67)
NATIVE {WBA_Reserved21}  CONST WBA_RESERVED21  = (WBA_DUMMY+68)
NATIVE {WBA_Reserved22}  CONST WBA_RESERVED22  = (WBA_DUMMY+80)
NATIVE {WBA_Reserved23}  CONST WBA_RESERVED23  = (WBA_DUMMY+81)
NATIVE {WBA_Reserved24}  CONST WBA_RESERVED24  = (WBA_DUMMY+82)
NATIVE {WBA_Reserved25}  CONST WBA_RESERVED25  = (WBA_DUMMY+83)
NATIVE {WBA_Reserved26}  CONST WBA_RESERVED26  = (WBA_DUMMY+84)
NATIVE {WBA_Reserved27}  CONST WBA_RESERVED27  = (WBA_DUMMY+85)
NATIVE {WBA_Reserved28}  CONST WBA_RESERVED28  = (WBA_DUMMY+100)
NATIVE {WBA_Reserved29}  CONST WBA_RESERVED29  = (WBA_DUMMY+101)
NATIVE {WBA_Reserved30}  CONST WBA_RESERVED30  = (WBA_DUMMY+102)
NATIVE {WBA_Reserved31}  CONST WBA_RESERVED31  = (WBA_DUMMY+103)
NATIVE {WBA_Reserved32}  CONST WBA_RESERVED32  = (WBA_DUMMY+104)
NATIVE {WBA_Reserved33}  CONST WBA_RESERVED33  = (WBA_DUMMY+105)
NATIVE {WBA_Reserved34}  CONST WBA_RESERVED34  = (WBA_DUMMY+108)
NATIVE {WBA_Reserved35}  CONST WBA_RESERVED35  = (WBA_DUMMY+109)
NATIVE {WBA_Reserved36}  CONST WBA_RESERVED36  = (WBA_DUMMY+112)
NATIVE {WBA_Reserved37}  CONST WBA_RESERVED37  = (WBA_DUMMY+113)
NATIVE {WBA_Reserved38}  CONST WBA_RESERVED38  = (WBA_DUMMY+114)
NATIVE {WBA_Reserved39}  CONST WBA_RESERVED39  = (WBA_DUMMY+115)

/****************************************************************************/

NATIVE {WBA_LAST_TAG} CONST WBA_LAST_TAG = (WBA_DUMMY+117)

/****************************************************************************/

/* The message your AppIcon rendering hook gets invoked with. */
NATIVE {AppIconRenderMsg} OBJECT appiconrendermsg
    {arm_RastPort}	rastport	:PTR TO rastport /* RastPort to render into */
    {arm_Icon}	icon	:PTR TO diskobject     /* The icon to be rendered */
    {arm_Label}	label	:/*STRPTR*/ ARRAY OF CHAR    /* The icon label txt */
    {arm_Tags}	tags	:ARRAY OF tagitem     /* Further tags to be passed on
                                       * to DrawIconStateA().
                                       */

    {arm_Left}	left	:INT     /* \ Rendering origin, not taking the */
    {arm_Top}	top	:INT      /* / button border into account. */

    {arm_Width}	width	:INT    /* \ Limit your rendering to */
    {arm_Height}	height	:INT   /* / this area. */

    {arm_State}	state	:ULONG    /* IDS_SELECTED, IDS_NORMAL, etc. */
ENDOBJECT

/****************************************************************************/

/* The message your drop zone hook gets invoked with. */
NATIVE {AppWindowDropZoneMsg} OBJECT appwindowdropzonemsg
    {adzm_RastPort}	rastport	:PTR TO rastport    /* RastPort to render into. */
    {adzm_DropZoneBox}	dropzonebox	:ibox /* Limit your rendering to this area.
                                         */
    {adzm_ID}	id	:ULONG          /* \ These come from straight */
    {adzm_UserData}	userdata	:ULONG    /* / from AddAppWindowDropZoneA(). */
    {adzm_Action}	action	:VALUE      /* See below for a list of actions. */
ENDOBJECT

NATIVE {ADZMACTION_Enter} CONST ADZMACTION_ENTER = (0)
NATIVE {ADZMACTION_Leave} CONST ADZMACTION_LEAVE = (1)

/****************************************************************************/

/* The message your icon selection change hook is invoked with. */
NATIVE {IconSelectMsg} OBJECT iconselectmsg
    /* Size of this data structure (in bytes). */
    {ism_Length}	length	:ULONG

    /* Lock on the drawer this object resides in,
     * NULL for Workbench backdrop (devices).
     */
    {ism_Drawer}	drawer	:BPTR

    /* Name of the object in question. */
    {ism_Name}	name	:/*STRPTR*/ ARRAY OF CHAR

    /* One of WBDISK, WBDRAWER, WBTOOL, WBPROJECT,
     * WBGARBAGE, WBDEVICE, WBKICK or WBAPPICON.
     */
    {ism_Type}	type	:UINT

    /* TRUE if currently selected, FALSE otherwise. */
    {ism_Selected}	selected	:INT

    /* Pointer to the list of tag items passed to
     * ChangeWorkbenchSelectionA().
     */
    {ism_Tags}	tags	:ARRAY OF tagitem

    /* Pointer to the window attached to this icon,
     * if the icon is a drawer-like object.
     */
    {ism_DrawerWindow}	drawerwindow	:PTR TO window

    /* Pointer to the window the icon resides in. */
    {ism_ParentWindow}	parentwindow	:PTR TO window

    /* Position and size of the icon; note that the
     * icon may not entirely reside within the visible
     * bounds of the parent window.
     */
    {ism_Left}	left	:INT
    {ism_Top}	top	:INT
    {ism_Width}	width	:INT
    {ism_Height}	height	:INT
ENDOBJECT

/* These are the values your hook code can return. */
NATIVE {ISMACTION_Unselect} CONST ISMACTION_UNSELECT = (0) /* Unselect the icon */
NATIVE {ISMACTION_Select}   CONST ISMACTION_SELECT   = (1) /* Select the icon */
NATIVE {ISMACTION_Ignore}   CONST ISMACTION_IGNORE   = (2) /* Do not change the selection state. */
NATIVE {ISMACTION_Stop}     CONST ISMACTION_STOP     = (3) /* Do not invoke the hook code again,
                                * leave the icon as it is.
                                */

/****************************************************************************/

/* The messages your copy hook is invoked with. */
NATIVE {CopyBeginMsg} OBJECT copybeginmsg
    {cbm_Length}	length	:ULONG            /* Size of this data structure in bytes. */
    {cbm_Action}	action	:VALUE            /* Will be set to CPACTION_Begin (see below).
                                  */
    {cbm_SourceDrawer}	sourcedrawer	:BPTR      /* A lock on the source drawer. */
    {cbm_DestinationDrawer}	destinationdrawer	:BPTR /* A lock on the destination drawer. */
ENDOBJECT

NATIVE {CopyDataMsg} OBJECT copydatamsg
    {cdm_Length}	length	:ULONG          /* Size of this data structure in bytes. */
    {cdm_Action}	action	:VALUE          /* Will be set to CPACTION_Copy (see below). */

    {cdm_SourceLock}	sourcelock	:BPTR      /* A lock on the parent directory of the
                                 * source file/drawer.
                                 */
    {cdm_SourceName}	sourcename	:/*STRPTR*/ ARRAY OF CHAR      /* The name of the source file or drawer. */

    {cdm_DestinationLock}	destinationlock	:BPTR /* A lock on the parent directory of the
                                 * destination file/drawer.
                                 */
    {cdm_DestinationName}	destinationname	:/*STRPTR*/ ARRAY OF CHAR /* The name of the destination file/drawer.
                                 * This may or may not match the name of
                                 * the source file/drawer in case the
                                 * data is to be copied under a different
                                 * name. For example, this is the case
                                 * with the Workbench "Copy" command which
                                 * creates duplicates of file/drawers by
                                 * prefixing the duplicate's name with
                                 * "Copy_XXX_of".
                                 */
    {cdm_DestinationX}	destinationx	:VALUE /* When the icon corresponding to the
                              * destination is written to disk, this
                              * is the position (put into its
                              * DiskObject->do_CurrentX/DiskObject->do_CurrentY
                              * fields) it should be placed at.
                              */
    {cdm_DestinationY}	destinationy	:VALUE
ENDOBJECT

NATIVE {CopyEndMsg} OBJECT copyendmsg
    {cem_Length}	length	:ULONG /* Size of this data structure in bytes. */
    {cem_Action}	action	:VALUE /* Will be set to CPACTION_End (see below). */
ENDOBJECT

NATIVE {CPACTION_Begin} CONST CPACTION_BEGIN = (0) /* This message arrives when the copying
                            * process is started.
                            */
NATIVE {CPACTION_Copy}  CONST CPACTION_COPY  = (1) /* This message arrives for each file or
                            * drawer to be copied.
                            */
NATIVE {CPACTION_End}   CONST CPACTION_END   = (2) /* This message arrives when all files/drawers
                            * have been copied.
                            */

/****************************************************************************/

/* The messages your delete hook is invoked with. */
NATIVE {DeleteBeginMsg} OBJECT deletebeginmsg
    {dbm_Length}	length	:ULONG /* Size of this data structure in bytes. */
    {dbm_Action}	action	:VALUE /* Will be set to either DLACTION_BeginDiscard
                       * or DLACTION_BeginEmptyTrash (see below).
                       */
ENDOBJECT

NATIVE {DeleteDataMsg} OBJECT deletedatamsg
    {ddm_Length}	length	:ULONG /* Size of this data structure in bytes. */
    {ddm_Action}	action	:VALUE /* Will be set to either DLACTION_DeleteContents
                        * or DLACTION_DeleteObject (see below).
                        */
    {ddm_Lock}	lock	:BPTR   /* A Lock on the parent directory of the object
                        * whose contents or which itself should be
                        * deleted.
                        */
    {ddm_Name}	name	:/*STRPTR*/ ARRAY OF CHAR   /* The name of the object whose contents or
                        * which itself should be deleted.
                        */
ENDOBJECT

NATIVE {DeleteEndMsg} OBJECT deleteendmsg
    {dem_Length}	length	:ULONG /* Size of this data structure in bytes. */
    {dem_Action}	action	:VALUE /* Will be set to DLACTION_End (see below). */
ENDOBJECT

NATIVE {DLACTION_BeginDiscard}    CONST DLACTION_BEGINDISCARD    = (0) /* This indicates that a number of
                                      * files and drawers should be
                                      * discarded; note that you will
                                      * receive a different kind of message
                                      * if the trashcan is to be emptied
                                      * (see below).
                                      */
NATIVE {DLACTION_BeginEmptyTrash} CONST DLACTION_BEGINEMPTYTRASH = (1) /* This indicates that the following
                                      * delete operations are intended to
                                      * empty the trashcan.
                                      */
NATIVE {DLACTION_DeleteContents}  CONST DLACTION_DELETECONTENTS  = (3) /* This indicates that the object
                                      * described by lock and name refers
                                      * to a drawer; you should empty its
                                      * contents but *DO NOT* delete the
                                      * drawer itself!
                                      */
NATIVE {DLACTION_DeleteObject}    CONST DLACTION_DELETEOBJECT    = (4) /* This indicates that the object
                                      * described by lock and name should
                                      * be deleted; this could be a file
                                      * or an empty drawer.
                                      */
NATIVE {DLACTION_End}             CONST DLACTION_END             = (5) /* This indicates that the
                                      * deletion process is finished.
                                      */

/****************************************************************************/

/* The messages your text input hook is invoked with. */
NATIVE {TextInputMsg} OBJECT textinputmsg
    {tim_Length}	length	:ULONG /* Size of this data structure
                        * in bytes.
                        */
    {tim_Action}	action	:VALUE /* One of the TIACTION_...
                        * values listed below.
                        */
    {tim_Prompt}	prompt	:/*STRPTR*/ ARRAY OF CHAR /* The Workbench suggested
                        * result, depending on what
                        * kind of input is requested
                        * (as indicated by the
                        * tim_Action member).
                        */
ENDOBJECT

NATIVE {TIACTION_Rename}        CONST TIACTION_RENAME        = (0) /* A file or drawer is to be
                                    * renamed.
                                    */
NATIVE {TIACTION_RelabelVolume} CONST TIACTION_RELABELVOLUME = (1) /* A volume is to be relabeled. */
NATIVE {TIACTION_NewDrawer}     CONST TIACTION_NEWDRAWER     = (2) /* A new drawer is to be created. */
NATIVE {TIACTION_Execute}       CONST TIACTION_EXECUTE       = (3) /* A program or script is to be
                                    * executed.
                                    */

/****************************************************************************/

/* Parameters for the UpdateWorkbench() function. */

NATIVE {UPDATEWB_ObjectRemoved} CONST UPDATEWB_OBJECTREMOVED = (0) /* Object has been deleted. */
NATIVE {UPDATEWB_ObjectAdded}   CONST UPDATEWB_OBJECTADDED   = (1) /* Object is new or has changed. */
