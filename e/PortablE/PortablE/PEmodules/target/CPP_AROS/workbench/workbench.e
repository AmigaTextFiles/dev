OPT NATIVE, PREPROCESS
MODULE 'target/exec/lists', 'target/exec/nodes', 'target/exec/tasks', 'target/exec/types', 'target/dos/bptr', 'target/intuition/intuition'
MODULE 'target/utility/tagitem', 'target/exec/ports', 'target/workbench/startup', 'target/graphics/rastport', 'target/dos/dos'
{#include <workbench/workbench.h>}
NATIVE {WORKBENCH_WORKBENCH_H} CONST

/*** Workbench library name *************************************************/
NATIVE {WORKBENCHNAME}           CONST
#define WORKBENCHNAME workbenchname
STATIC workbenchname           = 'workbench.library'

/*** Structures and associated definitions **********************************/
NATIVE {DrawerData} OBJECT drawerdata
    {dd_NewWindow}	newwindow	:nw
    {dd_CurrentX}	currentx	:VALUE
    {dd_CurrentY}	currenty	:VALUE
    {dd_Flags}	flags	:ULONG
    {dd_ViewModes}	viewmodes	:UINT
ENDOBJECT

NATIVE {DRAWERDATAFILESIZE} CONST ->#DRAWERDATAFILESIZE = (sizeof(struct DrawerData))

/* Definitions for dd_ViewModes */
NATIVE {DDVM_BYDEFAULT}      CONST DDVM_BYDEFAULT      = 0 /* Default (inherit parent's view mode) */
NATIVE {DDVM_BYICON}         CONST DDVM_BYICON         = 1 /* View as icons */
NATIVE {DDVM_BYNAME}         CONST DDVM_BYNAME         = 2 /* View as text, sorted by name */
NATIVE {DDVM_BYDATE}         CONST DDVM_BYDATE         = 3 /* View as text, sorted by date */
NATIVE {DDVM_BYSIZE}         CONST DDVM_BYSIZE         = 4 /* View as text, sorted by size */
NATIVE {DDVM_BYTYPE}         CONST DDVM_BYTYPE         = 5 /* View as text, sorted by type */

/* Definitions for dd_Flags */
NATIVE {DDFLAGS_SHOWDEFAULT} CONST DDFLAGS_SHOWDEFAULT = 0 /* Default (show only icons) */
NATIVE {DDFLAGS_SHOWICONS}   CONST DDFLAGS_SHOWICONS   = 1 /* Show only icons */
NATIVE {DDFLAGS_SHOWALL}     CONST DDFLAGS_SHOWALL     = 2 /* Show all files */

NATIVE {DiskObject} OBJECT diskobject
    {do_Magic}	magic	:UINT
    {do_Version}	version	:UINT
    {do_Gadget}	gadget	:gadget
    {do_Type}	type	:UBYTE        /* see below */
    {do_DefaultTool } pad_byte:NATIVE {STRPTR} VALUE	->hack to fix typed lists
    {do_DefaultTool}	defaulttool	:/*STRPTR*/ ARRAY OF CHAR
    {do_ToolTypes}	tooltypes	:ARRAY OF /*STRPTR*/ ARRAY OF CHAR
    {do_CurrentX}	currentx	:VALUE
    {do_CurrentY}	currenty	:VALUE
    {do_DrawerData}	drawerdata	:PTR TO drawerdata
    {do_ToolWindow}	toolwindow	:/*STRPTR*/ ARRAY OF CHAR
    {do_StackSize}	stacksize	:VALUE
ENDOBJECT

NATIVE {WBDISK}    CONST WBDISK    = (1)
NATIVE {WBDRAWER}  CONST WBDRAWER  = (2)
NATIVE {WBTOOL}    CONST WBTOOL    = (3)
NATIVE {WBPROJECT} CONST WBPROJECT = (4)
NATIVE {WBGARBAGE} CONST WBGARBAGE = (5)
NATIVE {WBDEVICE}  CONST WBDEVICE  = (6)
NATIVE {WBKICK}    CONST WBKICK    = (7)
NATIVE {WBAPPICON} CONST WBAPPICON = (8)

NATIVE {WB_DISKVERSION}  CONST WB_DISKVERSION  = (1)
NATIVE {WB_DISKREVISION} CONST WB_DISKREVISION = (1)
NATIVE {WB_DISKREVISIONMASK} CONST WB_DISKREVISIONMASK = ($FF)

NATIVE {WB_DISKMAGIC} CONST WB_DISKMAGIC = ($E310)

NATIVE {FreeList} OBJECT freelist
    {fl_NumFree}	numfree	:INT
    {fl_MemList}	memlist	:lh
ENDOBJECT

/* Icons */
NATIVE {GFLG_GADGBACKFILL} CONST GFLG_GADGBACKFILL = $0001
NATIVE {NO_ICON_POSITION}  CONST NO_ICON_POSITION  = $80000000

NATIVE {AppMessage} OBJECT appmessage
    {am_Message}	message	:mn
    {am_Type}	type	:UINT     /* see below */
    {am_UserData}	userdata	:ULONG
    {am_ID}	id	:ULONG
    {am_NumArgs}	numargs	:VALUE
    {am_ArgList}	arglist	:ARRAY OF wbarg
    {am_Version}	version	:UINT  /* see below */
    {am_Class}	class	:UINT
    {am_MouseX}	mousex	:INT
    {am_MouseY}	mousey	:INT
    {am_Seconds}	seconds	:ULONG
    {am_Micros}	micros	:ULONG
    {am_Reserved}	reserved[8]	:ARRAY OF ULONG
ENDOBJECT

/* Definition for am_Version */
NATIVE {AM_VERSION}         CONST AM_VERSION         = 1

/* Definitions for am_Type */
NATIVE {AMTYPE_APPWINDOW}   CONST AMTYPE_APPWINDOW   = 7
NATIVE {AMTYPE_APPICON}     CONST AMTYPE_APPICON     = 8
NATIVE {AMTYPE_APPMENUITEM} CONST AMTYPE_APPMENUITEM = 9

/* Definitions for am_Class */
NATIVE {AMCLASSICON_Open}        CONST AMCLASSICON_OPEN        = 0
NATIVE {AMCLASSICON_Copy}        CONST AMCLASSICON_COPY        = 1
NATIVE {AMCLASSICON_Rename}      CONST AMCLASSICON_RENAME      = 2
NATIVE {AMCLASSICON_Information} CONST AMCLASSICON_INFORMATION = 3
NATIVE {AMCLASSICON_Snapshot}    CONST AMCLASSICON_SNAPSHOT    = 4
NATIVE {AMCLASSICON_UnSnapshot}  CONST AMCLASSICON_UNSNAPSHOT  = 5
NATIVE {AMCLASSICON_LeaveOut}    CONST AMCLASSICON_LEAVEOUT    = 6
NATIVE {AMCLASSICON_PutAway}     CONST AMCLASSICON_PUTAWAY     = 7
NATIVE {AMCLASSICON_Delete}      CONST AMCLASSICON_DELETE      = 8
NATIVE {AMCLASSICON_FormatDisk}  CONST AMCLASSICON_FORMATDISK  = 9
NATIVE {AMCLASSICON_EmptyTrash} CONST AMCLASSICON_EMPTYTRASH = 10
NATIVE {AMCLASSICON_Selected}   CONST AMCLASSICON_SELECTED   = 11
NATIVE {AMCLASSICON_Unselected} CONST AMCLASSICON_UNSELECTED = 12

NATIVE {AppIconRenderMsg} OBJECT appiconrendermsg
    {arm_RastPort}	rastport	:PTR TO rastport
    {arm_Icon}	icon	:PTR TO diskobject
    {arm_Label}	label	:/*STRPTR*/ ARRAY OF CHAR
    {arm_Tags}	tags	:ARRAY OF tagitem
    {arm_Left}	left	:INT
    {arm_Top}	top	:INT
    {arm_Width}	width	:INT
    {arm_Height}	height	:INT
    {arm_State}	state	:ULONG
ENDOBJECT

NATIVE {AppWindowDropZoneMsg} OBJECT appwindowdropzonemsg
    {adzm_RastPort}	rastport	:PTR TO rastport
    {adzm_DropZoneBox}	dropzonebox	:ibox
    {adzm_ID}	id	:ULONG
    {adzm_UserData}	userdata	:ULONG
    {adzm_Action}	action	:VALUE  /* see below */
ENDOBJECT

/* Definitions for adzm_Action */
NATIVE {ADZMACTION_Enter} CONST ADZMACTION_ENTER = (0)
NATIVE {ADZMACTION_Leave} CONST ADZMACTION_LEAVE = (1)

NATIVE {IconSelectMsg} OBJECT iconselectmsg
    {ism_Length}	length	:ULONG
    {ism_Drawer}	drawer	:BPTR
    {ism_Name}	name	:/*STRPTR*/ ARRAY OF CHAR
    {ism_Type}	type	:UINT
    {ism_Selected}	selected	:INT
    {ism_Tags}	tags	:ARRAY OF tagitem
    {ism_DrawerWindow}	drawerwindow	:PTR TO window
    {ism_ParentWindow}	parentwindow	:PTR TO window
    {ism_Left}	left	:INT
    {ism_Top}	top	:INT
    {ism_Width}	width	:INT
    {ism_Height}	height	:INT
ENDOBJECT

/* Hook return values */
NATIVE {ISMACTION_Unselect} CONST ISMACTION_UNSELECT = (0)
NATIVE {ISMACTION_Select}   CONST ISMACTION_SELECT   = (1)
NATIVE {ISMACTION_Ignore}   CONST ISMACTION_IGNORE   = (2)
NATIVE {ISMACTION_Stop}     CONST ISMACTION_STOP     = (3)

/*** Private structures *****************************************************/
NATIVE {AppWindow} OBJECT appwindow
ENDOBJECT
NATIVE {AppWindowDropZone} OBJECT appwindowdropzone
ENDOBJECT
NATIVE {AppIcon} OBJECT appicon
ENDOBJECT
NATIVE {AppMenuItem} OBJECT appmenuitem
ENDOBJECT

/*** Start of workbench.library tags ****************************************/
NATIVE {WBA_BASE}                          CONST WBA_BASE                          = (TAG_USER+$A000)

/*** Tags for use with AddAppIconA() ****************************************/
/* The different menu items the AppIcon responds to (BOOL) */
NATIVE {WBAPPICONA_SupportsOpen}            CONST WBAPPICONA_SUPPORTSOPEN            = (WBA_BASE+1)
NATIVE {WBAPPICONA_SupportsCopy}            CONST WBAPPICONA_SUPPORTSCOPY            = (WBA_BASE+2)
NATIVE {WBAPPICONA_SupportsRename}          CONST WBAPPICONA_SUPPORTSRENAME          = (WBA_BASE+3)
NATIVE {WBAPPICONA_SupportsInformation}     CONST WBAPPICONA_SUPPORTSINFORMATION     = (WBA_BASE+4)
NATIVE {WBAPPICONA_SupportsSnapshot}        CONST WBAPPICONA_SUPPORTSSNAPSHOT        = (WBA_BASE+5)
NATIVE {WBAPPICONA_SupportsUnSnapshot}      CONST WBAPPICONA_SUPPORTSUNSNAPSHOT      = (WBA_BASE+6)
NATIVE {WBAPPICONA_SupportsLeaveOut}        CONST WBAPPICONA_SUPPORTSLEAVEOUT        = (WBA_BASE+7)
NATIVE {WBAPPICONA_SupportsPutAway}         CONST WBAPPICONA_SUPPORTSPUTAWAY         = (WBA_BASE+8)
NATIVE {WBAPPICONA_SupportsDelete}          CONST WBAPPICONA_SUPPORTSDELETE          = (WBA_BASE+9)
NATIVE {WBAPPICONA_SupportsFormatDisk}      CONST WBAPPICONA_SUPPORTSFORMATDISK      = (WBA_BASE+10)
NATIVE {WBAPPICONA_SupportsEmptyTrash}      CONST WBAPPICONA_SUPPORTSEMPTYTRASH      = (WBA_BASE+11)

/* Propagate the AppIcons position back to original DiskObject (BOOL) */
NATIVE {WBAPPICONA_PropagatePosition}       CONST WBAPPICONA_PROPAGATEPOSITION       = (WBA_BASE+12)

/* Call this hook when rendering this AppIcon (struct Hook *) */
NATIVE {WBAPPICONA_RenderHook}              CONST WBAPPICONA_RENDERHOOK              = (WBA_BASE+13)

/* Notify the AppIcon when it's select state changes (BOOL) */
NATIVE {WBAPPICONA_NotifySelectState}        CONST WBAPPICONA_NOTIFYSELECTSTATE        = (WBA_BASE+14)

/*** Tags for use with AddAppMenuItemA() ************************************/
/* Command key string for this AppMenu (STRPTR) */
NATIVE {WBAPPMENUA_CommandKeyString}         CONST WBAPPMENUA_COMMANDKEYSTRING         = (WBA_BASE+15)

/*** Tags for use with OpenWorkbenchObjectA() *******************************/
NATIVE {WBOPENA_ArgLock}                     CONST WBOPENA_ARGLOCK                     = (WBA_BASE+16)
NATIVE {WBOPENA_ArgName}                     CONST WBOPENA_ARGNAME                     = (WBA_BASE+17)

/*** Tags for use with WorkbenchControlA() **********************************/
NATIVE {WBCTRLA_IsOpen}                      CONST WBCTRLA_ISOPEN                      = (WBA_BASE+18)
NATIVE {WBCTRLA_DuplicateSearchPath}         CONST WBCTRLA_DUPLICATESEARCHPATH         = (WBA_BASE+19)
NATIVE {WBCTRLA_FreeSearchPath}              CONST WBCTRLA_FREESEARCHPATH              = (WBA_BASE+20)
NATIVE {WBCTRLA_GetDefaultStackSize}         CONST WBCTRLA_GETDEFAULTSTACKSIZE         = (WBA_BASE+21)
NATIVE {WBCTRLA_SetDefaultStackSize}         CONST WBCTRLA_SETDEFAULTSTACKSIZE         = (WBA_BASE+22)
NATIVE {WBCTRLA_RedrawAppIcon}               CONST WBCTRLA_REDRAWAPPICON               = (WBA_BASE+23)
NATIVE {WBCTRLA_GetProgramList}              CONST WBCTRLA_GETPROGRAMLIST              = (WBA_BASE+24)
NATIVE {WBCTRLA_FreeProgramList}             CONST WBCTRLA_FREEPROGRAMLIST             = (WBA_BASE+25)
NATIVE {WBCTRLA_GetSelectedIconList}         CONST WBCTRLA_GETSELECTEDICONLIST         = (WBA_BASE+36)
NATIVE {WBCTRLA_FreeSelectedIconList}        CONST WBCTRLA_FREESELECTEDICONLIST        = (WBA_BASE+37)
NATIVE {WBCTRLA_GetOpenDrawerList}           CONST WBCTRLA_GETOPENDRAWERLIST           = (WBA_BASE+38)
NATIVE {WBCTRLA_FreeOpenDrawerList}          CONST WBCTRLA_FREEOPENDRAWERLIST          = (WBA_BASE+39)
NATIVE {WBCTRLA_GetHiddenDeviceList}         CONST WBCTRLA_GETHIDDENDEVICELIST         = (WBA_BASE+42)
NATIVE {WBCTRLA_FreeHiddenDeviceList}        CONST WBCTRLA_FREEHIDDENDEVICELIST        = (WBA_BASE+43)
NATIVE {WBCTRLA_AddHiddenDeviceName}         CONST WBCTRLA_ADDHIDDENDEVICENAME         = (WBA_BASE+44)
NATIVE {WBCTRLA_RemoveHiddenDeviceName}      CONST WBCTRLA_REMOVEHIDDENDEVICENAME      = (WBA_BASE+45)
NATIVE {WBCTRLA_GetTypeRestartTime}          CONST WBCTRLA_GETTYPERESTARTTIME          = (WBA_BASE+47)
NATIVE {WBCTRLA_SetTypeRestartTime}          CONST WBCTRLA_SETTYPERESTARTTIME          = (WBA_BASE+48)

/*** Tags for use with AddAppWindowDropZoneA() ******************************/
NATIVE {WBDZA_Left}                          CONST WBDZA_LEFT                          = (WBA_BASE+26)
NATIVE {WBDZA_RelRight}                      CONST WBDZA_RELRIGHT                      = (WBA_BASE+27)
NATIVE {WBDZA_Top}                           CONST WBDZA_TOP                           = (WBA_BASE+28)
NATIVE {WBDZA_RelBottom}                     CONST WBDZA_RELBOTTOM                     = (WBA_BASE+29)
NATIVE {WBDZA_Width}                         CONST WBDZA_WIDTH                         = (WBA_BASE+30)
NATIVE {WBDZA_RelWidth}                      CONST WBDZA_RELWIDTH                      = (WBA_BASE+31)
NATIVE {WBDZA_Height}                        CONST WBDZA_HEIGHT                        = (WBA_BASE+32)
NATIVE {WBDZA_RelHeight}                     CONST WBDZA_RELHEIGHT                     = (WBA_BASE+33)
NATIVE {WBDZA_Box}                           CONST WBDZA_BOX                           = (WBA_BASE+34)
NATIVE {WBDZA_Hook}                          CONST WBDZA_HOOK                          = (WBA_BASE+35)

/*** Reserved tags **********************************************************/
NATIVE {WBA_Reserved1}                       CONST WBA_RESERVED1                       = (WBA_BASE+40)
NATIVE {WBA_Reserved2}                       CONST WBA_RESERVED2                       = (WBA_BASE+41)
NATIVE {WBA_Reserved3}                       CONST WBA_RESERVED3                       = (WBA_BASE+46)
NATIVE {WBA_Reserved4}                       CONST WBA_RESERVED4                       = (WBA_BASE+49)
NATIVE {WBA_Reserved5}                       CONST WBA_RESERVED5                       = (WBA_BASE+50)
NATIVE {WBA_Reserved6}                       CONST WBA_RESERVED6                       = (WBA_BASE+51)
NATIVE {WBA_Reserved7}                       CONST WBA_RESERVED7                       = (WBA_BASE+52)
NATIVE {WBA_Reserved8}                       CONST WBA_RESERVED8                       = (WBA_BASE+53)
NATIVE {WBA_Reserved9}                       CONST WBA_RESERVED9                       = (WBA_BASE+54)
NATIVE {WBA_Reserved10}                      CONST WBA_RESERVED10                      = (WBA_BASE+55)
NATIVE {WBA_Reserved11}                      CONST WBA_RESERVED11                      = (WBA_BASE+56)
NATIVE {WBA_Reserved12}                      CONST WBA_RESERVED12                      = (WBA_BASE+57)
NATIVE {WBA_Reserved13}                      CONST WBA_RESERVED13                      = (WBA_BASE+58)
NATIVE {WBA_Reserved14}                      CONST WBA_RESERVED14                      = (WBA_BASE+59)
NATIVE {WBA_Reserved15}                      CONST WBA_RESERVED15                      = (WBA_BASE+60)
NATIVE {WBA_Reserved16}                      CONST WBA_RESERVED16                      = (WBA_BASE+61)
NATIVE {WBA_Reserved17}                      CONST WBA_RESERVED17                      = (WBA_BASE+62)
NATIVE {WBA_Reserved18}                      CONST WBA_RESERVED18                      = (WBA_BASE+63)
NATIVE {WBA_Reserved19}                      CONST WBA_RESERVED19                      = (WBA_BASE+64)

/*** Last tag ***************************************************************/

NATIVE {WBA_LAST_TAG}                        CONST WBA_LAST_TAG                        = (WBA_BASE+64)
