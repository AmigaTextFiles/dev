/* $VER: classusr.h 38.2 (14.4.1992) */
OPT NATIVE, PREPROCESS
MODULE 'target/utility/hooks'
MODULE 'target/utility/tagitem', 'target/intuition/cghooks', 'target/exec/lists', 'target/exec/types'
{MODULE 'intuition/classusr'}

TYPE INTUIOBJECT IS VALUE
TYPE CLASSID     IS ARRAY


NATIVE {msg} OBJECT msg
    {methodid}	methodid	:ULONG
    /* method-specific data follows, some examples below */
ENDOBJECT

NATIVE {ROOTCLASS}	CONST
#define ROOTCLASS rootclass
STATIC rootclass	= 'rootclass'		/* classusr.h	  */
NATIVE {IMAGECLASS}	CONST
#define IMAGECLASS imageclass
STATIC imageclass	= 'imageclass'		/* imageclass.h   */
NATIVE {FRAMEICLASS}	CONST
#define FRAMEICLASS frameiclass
STATIC frameiclass	= 'frameiclass'
NATIVE {SYSICLASS}	CONST
#define SYSICLASS sysiclass
STATIC sysiclass	= 'sysiclass'
NATIVE {FILLRECTCLASS}	CONST
#define FILLRECTCLASS fillrectclass
STATIC fillrectclass	= 'fillrectclass'
NATIVE {GADGETCLASS}	CONST
#define GADGETCLASS gadgetclass
STATIC gadgetclass	= 'gadgetclass'		/* gadgetclass.h  */
NATIVE {PROPGCLASS}	CONST
#define PROPGCLASS propgclass
STATIC propgclass	= 'propgclass'
NATIVE {STRGCLASS}	CONST
#define STRGCLASS strgclass
STATIC strgclass	= 'strgclass'
NATIVE {BUTTONGCLASS}	CONST
#define BUTTONGCLASS buttongclass
STATIC buttongclass	= 'buttongclass'
NATIVE {FRBUTTONCLASS}	CONST
#define FRBUTTONCLASS frbuttonclass
STATIC frbuttonclass	= 'frbuttonclass'
NATIVE {GROUPGCLASS}	CONST
#define GROUPGCLASS groupgclass
STATIC groupgclass	= 'groupgclass'
NATIVE {ICCLASS}		CONST
#define ICCLASS icclass
STATIC icclass		= 'icclass'		/* icclass.h	  */
NATIVE {MODELCLASS}	CONST
#define MODELCLASS modelclass
STATIC modelclass	= 'modelclass'
NATIVE {ITEXTICLASS}	CONST
#define ITEXTICLASS itexticlass
STATIC itexticlass	= 'itexticlass'
NATIVE {POINTERCLASS}	CONST
#define POINTERCLASS pointerclass
STATIC pointerclass	= 'pointerclass'		/* pointerclass.h */

CONST OM_DUMMY	= ($100)
NATIVE {OM_NEW}		CONST OM_NEW		= ($101)	/* 'object' parameter is "true class"	*/
NATIVE {OM_DISPOSE}	CONST OM_DISPOSE	= ($102)	/* delete self (no parameters)		*/
NATIVE {OM_SET}		CONST OM_SET		= ($103)	/* set attributes (in tag list)		*/
NATIVE {OM_GET}		CONST OM_GET		= ($104)	/* return single attribute value	*/
NATIVE {OM_ADDTAIL}	CONST OM_ADDTAIL	= ($105)	/* add self to a List (let root do it)	*/
NATIVE {OM_REMOVE}	CONST OM_REMOVE	= ($106)	/* remove self from list		*/
NATIVE {OM_NOTIFY}	CONST OM_NOTIFY	= ($107)	/* send to self: notify dependents	*/
NATIVE {OM_UPDATE}	CONST OM_UPDATE	= ($108)	/* notification message from somebody	*/
NATIVE {OM_ADDMEMBER}	CONST OM_ADDMEMBER	= ($109)	/* used by various classes with lists	*/
NATIVE {OM_REMMEMBER}	CONST OM_REMMEMBER	= ($10A)	/* used by various classes with lists	*/

/* Parameter "Messages" passed to methods	*/

/* OM_NEW and OM_SET	*/
NATIVE {opset} OBJECT opset
    {methodid}	methodid	:ULONG
    {attrlist}	attrlist	:ARRAY OF tagitem	/* new attributes	*/
    {ginfo}	ginfo	:PTR TO gadgetinfo	/* always there for gadgets,
					 * when SetGadgetAttrs() is used,
					 * but will be NULL for OM_NEW
					 */
ENDOBJECT

/* OM_NOTIFY, and OM_UPDATE	*/
NATIVE {opupdate} OBJECT opupdate
    {methodid}	methodid	:ULONG
    {attrlist}	attrlist	:ARRAY OF tagitem	/* new attributes	*/
    {ginfo}	ginfo	:PTR TO gadgetinfo	/* non-NULL when SetGadgetAttrs or
					 * notification resulting from gadget
					 * input occurs.
					 */
    {flags}	flags	:ULONG	/* defined below	*/
ENDOBJECT

NATIVE {OPUF_INTERIM}	CONST OPUF_INTERIM	= $1

/* OM_GET	*/
NATIVE {opget} OBJECT opget
    {methodid}	methodid	:ULONG
    {attrid}	attrid	:ULONG
    {storage}	storage	:PTR TO ULONG	/* may be other types, but "int"
					 * types are all ULONG
					 */
ENDOBJECT

/* OM_ADDTAIL	*/
NATIVE {opaddtail} OBJECT opaddtail
    {methodid}	methodid	:ULONG
    {list}	list	:PTR TO lh
ENDOBJECT

/* OM_ADDMEMBER, OM_REMMEMBER	*/
NATIVE {opmember} OBJECT opmember
    {methodid}	methodid	:ULONG
    {object}	object	:PTR TO INTUIOBJECT
ENDOBJECT


NATIVE {opnew} OBJECT opnew OF opset
ENDOBJECT

NATIVE {opnotify} OBJECT opnotify OF opupdate
ENDOBJECT

NATIVE {opaddmember} OBJECT opaddmember OF opmember
ENDOBJECT

NATIVE {opremmember} OBJECT opremmember OF opmember
ENDOBJECT
