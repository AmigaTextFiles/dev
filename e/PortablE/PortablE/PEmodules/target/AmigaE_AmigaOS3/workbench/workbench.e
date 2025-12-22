/* $VER: workbench.h 45.6 (23.11.2000) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/tasks', 'target/dos/dos', 'target/intuition/intuition'
MODULE 'target/utility/tagitem', 'target/exec/types', 'target/exec/lists', 'target/exec/ports', 'target/workbench/startup', 'target/graphics/rastport'
{MODULE 'workbench/workbench'}

NATIVE {WBDISK}		CONST WBDISK		= 1
NATIVE {WBDRAWER}	CONST WBDRAWER	= 2
NATIVE {WBTOOL}		CONST WBTOOL		= 3
NATIVE {WBPROJECT}	CONST WBPROJECT	= 4
NATIVE {WBGARBAGE}	CONST WBGARBAGE	= 5
NATIVE {WBDEVICE}	CONST WBDEVICE	= 6
NATIVE {WBKICK}		CONST WBKICK		= 7
NATIVE {WBAPPICON}	CONST WBAPPICON	= 8

NATIVE {olddrawerdata} OBJECT olddrawerdata /* pre V36 definition */
    {newwindow}	newwindow	:nw	/* args to open window */
    {currentx}	currentx	:VALUE	/* current x coordinate of origin */
    {currenty}	currenty	:VALUE	/* current y coordinate of origin */
ENDOBJECT
/* the amount of DrawerData actually written to disk */
NATIVE {OLDDRAWERDATAFILESIZE}	CONST OLDDRAWERDATAFILESIZE	= $38	->(sizeof(struct OldDrawerData))

NATIVE {drawerdata} OBJECT drawerdata
    {newwindow}	newwindow	:nw	/* args to open window */
    {currentx}	currentx	:VALUE	/* current x coordinate of origin */
    {currenty}	currenty	:VALUE	/* current y coordinate of origin */
    {flags}	flags	:ULONG	/* flags for drawer */
    {viewmodes}	viewmodes	:UINT	/* view mode for drawer */
ENDOBJECT
/* the amount of DrawerData actually written to disk */
NATIVE {DRAWERDATAFILESIZE}	CONST DRAWERDATAFILESIZE	= $3E	->(sizeof(struct DrawerData))

/* definitions for dd_ViewModes */
CONST DDVM_BYDEFAULT		= 0	/* default (inherit parent's view mode) */
CONST DDVM_BYICON		= 1	/* view as icons */
CONST DDVM_BYNAME		= 2	/* view as text, sorted by name */
CONST DDVM_BYDATE		= 3	/* view as text, sorted by date */
CONST DDVM_BYSIZE		= 4	/* view as text, sorted by size */
CONST DDVM_BYTYPE		= 5	/* view as text, sorted by type */

/* definitions for dd_Flags */
CONST DDFLAGS_SHOWDEFAULT	= 0	/* default (show only icons) */
CONST DDFLAGS_SHOWICONS	= 1	/* show only icons */
CONST DDFLAGS_SHOWALL		= 2	/* show all files */

NATIVE {diskobject} OBJECT diskobject
    {magic}	magic	:UINT /* a magic number at the start of the file */
    {version}	version	:UINT /* a version number, so we can change it */
    {gadget}	gadget	:gadget	/* a copy of in core gadget */
    {type}	type	:UBYTE
    {pad_byte} pad_byte:CHAR
    {defaulttool}	defaulttool	:/*STRPTR*/ ARRAY OF CHAR
    {tooltypes}	tooltypes	:ARRAY OF /*STRPTR*/ ARRAY OF CHAR
    {currentx}	currentx	:VALUE
    {currenty}	currenty	:VALUE
    {drawerdata}	drawerdata	:PTR TO drawerdata
    {toolwindow}	toolwindow	:/*STRPTR*/ ARRAY OF CHAR	/* only applies to tools */
    {stacksize}	stacksize	:VALUE	/* only applies to tools */

ENDOBJECT

NATIVE {WB_DISKMAGIC}	CONST WB_DISKMAGIC	= $e310	/* a magic number, not easily impersonated */
NATIVE {WB_DISKVERSION}	CONST WB_DISKVERSION	= 1	/* our current version number */
NATIVE {WB_DISKREVISION}	CONST WB_DISKREVISION	= 1	/* our current revision number */
/* I only use the lower 8 bits of Gadget.UserData for the revision # */
NATIVE {WB_DISKREVISIONMASK}	CONST WB_DISKREVISIONMASK	= 255

NATIVE {freelist} OBJECT freelist
    {numfree}	numfree	:INT
    {memlist}	memlist	:lh
ENDOBJECT

/* workbench does different complement modes for its gadgets.
** It supports separate images, complement mode, and backfill mode.
** The first two are identical to intuitions GFLG_GADGIMAGE and GFLG_GADGHCOMP.
** backfill is similar to GFLG_GADGHCOMP, but the region outside of the
** image (which normally would be color three when complemented)
** is flood-filled to color zero.
*/
NATIVE {GFLG_GADGBACKFILL} CONST GFLG_GADGBACKFILL = $0001
NATIVE {GADGBACKFILL}	  CONST GADGBACKFILL	  = $0001    /* an old synonym */

/* if an icon does not really live anywhere, set its current position
** to here
*/
NATIVE {NO_ICON_POSITION}	CONST NO_ICON_POSITION	= ($80000000)

/* workbench now is a library.  this is it's name */
NATIVE {WORKBENCH_NAME}		CONST
#define WORKBENCH_NAME workbench_name
STATIC workbench_name		= 'workbench.library'

/****************************************************************************/

/* If you find am_Version >= AM_VERSION, you know this structure has
 * at least the fields defined in this version of the include file
 */
NATIVE {AM_VERSION}	CONST AM_VERSION	= 1

NATIVE {appmessage} OBJECT appmessage
    {message}	message	:mn	/* standard message structure */
    {type}	type	:UINT		/* message type */
    {userdata}	userdata	:ULONG		/* application specific */
    {id}	id	:ULONG		/* application definable ID */
    {numargs}	numargs	:VALUE		/* # of elements in arglist */
    {arglist}	arglist	:ARRAY OF wbarg	/* the arguments themselves */
    {version}	version	:UINT		/* will be >= AM_VERSION */
    {class}	class	:UINT		/* message class */
    {mousex}	mousex	:INT		/* mouse x position of event */
    {mousey}	mousey	:INT		/* mouse y position of event */
    {seconds}	seconds	:ULONG		/* current system clock time */
    {micros}	micros	:ULONG		/* current system clock time */
    {reserved}	reserved[8]	:ARRAY OF ULONG	/* avoid recompilation */
ENDOBJECT

/* types of app messages */
NATIVE {AMTYPE_APPWINDOW}        CONST AMTYPE_APPWINDOW        = 7	/* app window message    */
NATIVE {AMTYPE_APPICON}	        CONST AMTYPE_APPICON	        = 8	/* app icon message      */
NATIVE {AMTYPE_APPMENUITEM}      CONST AMTYPE_APPMENUITEM      = 9	/* app menu item message */
CONST AMTYPE_APPWINDOWZONE   = 10	/* app window drop zone message    */

/* Classes of AppIcon messages (V44) */
CONST AMCLASSICON_OPEN	= 0	/* The "Open" menu item was invoked,
					 * the icon got double-clicked or an
					 * icon got dropped on it.
					 */
CONST AMCLASSICON_COPY	= 1	/* The "Copy" menu item was invoked */
CONST AMCLASSICON_RENAME	= 2	/* The "Rename" menu item was invoked */
CONST AMCLASSICON_INFORMATION	= 3	/* The "Information" menu item was invoked */
CONST AMCLASSICON_SNAPSHOT	= 4	/* The "Snapshot" menu item was invoked */
CONST AMCLASSICON_UNSNAPSHOT	= 5	/* The "UnSnapshot" menu item was invoked */
CONST AMCLASSICON_LEAVEOUT	= 6	/* The "Leave Out" menu item was invoked */
CONST AMCLASSICON_PUTAWAY	= 7	/* The "Put Away" menu item was invoked */
CONST AMCLASSICON_DELETE	= 8	/* The "Delete" menu item was invoked */
CONST AMCLASSICON_FORMATDISK	= 9	/* The "Format Disk" menu item was invoked */
CONST AMCLASSICON_EMPTYTRASH	= 10	/* The "Empty Trash" menu item was invoked */

CONST AMCLASSICON_SELECTED	= 11	/* The icon is now selected */
CONST AMCLASSICON_UNSELECTED	= 12	/* The icon is now unselected */

/*
 * The following structures are private.  These are just stub
 * structures for code compatibility...
 */
NATIVE {appwindow} OBJECT appwindow
	{private}	private	:PTR
ENDOBJECT
NATIVE {appicon} OBJECT appicon
	{private}	private	:PTR
ENDOBJECT
NATIVE {appmenuitem} OBJECT appmenuitem
	{private}	private	:PTR
ENDOBJECT

/****************************************************************************/

CONST WBA_DUMMY = (TAG_USER+$A000)

/****************************************************************************/

/* Tags for use with AddAppIconA() */

/* AppIcon responds to the "Open" menu item (BOOL). */
CONST WBAPPICONA_SUPPORTSOPEN		= (WBA_DUMMY+1)

/* AppIcon responds to the "Copy" menu item (BOOL). */
CONST WBAPPICONA_SUPPORTSCOPY		= (WBA_DUMMY+2)

/* AppIcon responds to the "Rename" menu item (BOOL). */
CONST WBAPPICONA_SUPPORTSRENAME	= (WBA_DUMMY+3)

/* AppIcon responds to the "Information" menu item (BOOL). */
CONST WBAPPICONA_SUPPORTSINFORMATION	= (WBA_DUMMY+4)

/* AppIcon responds to the "Snapshot" menu item (BOOL). */
CONST WBAPPICONA_SUPPORTSSNAPSHOT	= (WBA_DUMMY+5)

/* AppIcon responds to the "UnSnapshot" menu item (BOOL). */
CONST WBAPPICONA_SUPPORTSUNSNAPSHOT	= (WBA_DUMMY+6)

/* AppIcon responds to the "LeaveOut" menu item (BOOL). */
CONST WBAPPICONA_SUPPORTSLEAVEOUT	= (WBA_DUMMY+7)

/* AppIcon responds to the "PutAway" menu item (BOOL). */
CONST WBAPPICONA_SUPPORTSPUTAWAY	= (WBA_DUMMY+8)

/* AppIcon responds to the "Delete" menu item (BOOL). */
CONST WBAPPICONA_SUPPORTSDELETE	= (WBA_DUMMY+9)

/* AppIcon responds to the "FormatDisk" menu item (BOOL). */
CONST WBAPPICONA_SUPPORTSFORMATDISK	= (WBA_DUMMY+10)

/* AppIcon responds to the "EmptyTrash" menu item (BOOL). */
CONST WBAPPICONA_SUPPORTSEMPTYTRASH	= (WBA_DUMMY+11)

/* AppIcon position should be propagated back to original DiskObject (BOOL). */
CONST WBAPPICONA_PROPAGATEPOSITION	= (WBA_DUMMY+12)

/* Callback hook to be invoked when rendering this icon (struct Hook *). */
CONST WBAPPICONA_RENDERHOOK		= (WBA_DUMMY+13)

/* AppIcon wants to be notified when its select state changes (BOOL). */
CONST WBAPPICONA_NOTIFYSELECTSTATE	= (WBA_DUMMY+14)

/****************************************************************************/

/* Tags for use with AddAppMenuA() */

/* Command key string for this AppMenu (STRPTR). */
CONST WBAPPMENUA_COMMANDKEYSTRING	 = (WBA_DUMMY+15)

/* Item to be added should get sub menu items attached to; make room for it,
 * then return the key to use later for attaching the items (ULONG *).
 */
CONST WBAPPMENUA_GETKEY		= (WBA_DUMMY+65)

/* This item should be attached to a sub menu; the key provided refers to
 * the sub menu it should be attached to (ULONG).
 */
CONST WBAPPMENUA_USEKEY		= (WBA_DUMMY+66)

/* Item to be added is in fact a new menu title; make room for it, then
 * return the key to use later for attaching the items (ULONG *).
 */
CONST WBAPPMENUA_GETTITLEKEY		= (WBA_DUMMY+77)

/****************************************************************************/

/* Tags for use with OpenWorkbenchObjectA() */

/* Corresponds to the wa_Lock member of a struct WBArg */
CONST WBOPENA_ARGLOCK			= (WBA_DUMMY+16)

/* Corresponds to the wa_Name member of a struct WBArg */
CONST WBOPENA_ARGNAME			= (WBA_DUMMY+17)

/* When opening a drawer, show all files or only icons?
 * This must be one out of DDFLAGS_SHOWICONS,
 * or DDFLAGS_SHOWALL; (UBYTE); (V45)
 */
CONST WBOPENA_SHOW			= (WBA_DUMMY+75)

/* When opening a drawer, view the contents by icon, name,
 * date, size or type? This must be one out of DDVM_BYICON,
 * DDVM_BYNAME, DDVM_BYDATE, DDVM_BYSIZE or DDVM_BYTYPE;
 * (UBYTE); (V45)
 */
CONST WBOPENA_VIEWBY			= (WBA_DUMMY+76)
