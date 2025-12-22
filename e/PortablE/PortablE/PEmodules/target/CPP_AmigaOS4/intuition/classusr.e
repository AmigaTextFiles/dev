/* $Id: classusr.h,v 1.14 2005/11/10 15:39:40 hjfrieden Exp $ */
OPT NATIVE, PREPROCESS
MODULE 'target/utility/hooks'
MODULE 'target/utility/tagitem', 'target/intuition/cghooks', 'target/exec/lists', 'target/exec/types'
{#include <intuition/classusr.h>}
NATIVE {INTUITION_CLASSUSR_H} CONST

TYPE INTUIOBJECT IS NATIVE {Object} ULONG
TYPE CLASSID     IS NATIVE {ClassID} ARRAY


/*** User visible handles on objects, classes, messages ***/
NATIVE {Object} CONST /* abstract handle */

NATIVE {ClassID} CONST

/* you can use this type to point to a "generic" message,
 * in the object-oriented programming parlance.  Based on
 * the value of 'MethodID', you dispatch to processing
 * for the various message types.  The meaningful parameter
 * packet structure definitions are defined below.
 */
NATIVE {_Msg} OBJECT msg
    {MethodID}	methodid	:ULONG
    /* method-specific data follows, some examples below */
ENDOBJECT
NATIVE {Msg} OBJECT

/*
 * Class id strings for Intuition classes.
 * There's no real reason to use the uppercase constants
 * over the lowercase strings, but this makes a good place
 * to list the names of the built-in classes.
 */
NATIVE {ROOTCLASS}      CONST
#define ROOTCLASS rootclass
STATIC rootclass      = 'rootclass'      /* classusr.h     */
NATIVE {IMAGECLASS}     CONST
#define IMAGECLASS imageclass
STATIC imageclass     = 'imageclass'     /* imageclass.h   */
NATIVE {FRAMEICLASS}    CONST
#define FRAMEICLASS frameiclass
STATIC frameiclass    = 'frameiclass'
NATIVE {SYSICLASS}      CONST
#define SYSICLASS sysiclass
STATIC sysiclass      = 'sysiclass'
NATIVE {FILLRECTCLASS}  CONST
#define FILLRECTCLASS fillrectclass
STATIC fillrectclass  = 'fillrectclass'
NATIVE {GADGETCLASS}    CONST
#define GADGETCLASS gadgetclass
STATIC gadgetclass    = 'gadgetclass'    /* gadgetclass.h  */
NATIVE {PROPGCLASS}     CONST
#define PROPGCLASS propgclass
STATIC propgclass     = 'propgclass'
NATIVE {STRGCLASS}      CONST
#define STRGCLASS strgclass
STATIC strgclass      = 'strgclass'
NATIVE {BUTTONGCLASS}   CONST
#define BUTTONGCLASS buttongclass
STATIC buttongclass   = 'buttongclass'
NATIVE {FRBUTTONCLASS}  CONST
#define FRBUTTONCLASS frbuttonclass
STATIC frbuttonclass  = 'frbuttonclass'
NATIVE {GROUPGCLASS}    CONST
#define GROUPGCLASS groupgclass
STATIC groupgclass    = 'groupgclass'
NATIVE {SCROLLERGCLASS} CONST
#define SCROLLERGCLASS scrollergclass
STATIC scrollergclass = 'scrollergclass' /* V50            */
NATIVE {ICCLASS}        CONST
#define ICCLASS icclass
STATIC icclass        = 'icclass'        /* icclass.h      */
NATIVE {MODELCLASS}     CONST
#define MODELCLASS modelclass
STATIC modelclass     = 'modelclass'
NATIVE {ITEXTICLASS}    CONST
#define ITEXTICLASS itexticlass
STATIC itexticlass    = 'itexticlass'
NATIVE {POINTERCLASS}   CONST
#define POINTERCLASS pointerclass
STATIC pointerclass   = 'pointerclass'   /* pointerclass.h */

/* Dispatched method ID's
 * NOTE: Applications should use Intuition entry points, not direct
 * DoMethod() calls, for NewObject, DisposeObject, SetAttrs,
 * SetGadgetAttrs, and GetAttr.
 */

NATIVE {OM_Dummy}     CONST OM_DUMMY     = ($100)
NATIVE {OM_NEW}       CONST OM_NEW       = ($101) /* 'object' parameter is "true class"  */
NATIVE {OM_DISPOSE}   CONST OM_DISPOSE   = ($102) /* delete self (no parameters)         */
NATIVE {OM_SET}       CONST OM_SET       = ($103) /* set attributes (in tag list)        */
NATIVE {OM_GET}       CONST OM_GET       = ($104) /* return single attribute value       */
NATIVE {OM_ADDTAIL}   CONST OM_ADDTAIL   = ($105) /* add self to a List (let root do it) */
NATIVE {OM_REMOVE}    CONST OM_REMOVE    = ($106) /* remove self from list               */
NATIVE {OM_NOTIFY}    CONST OM_NOTIFY    = ($107) /* send to self: notify dependents     */
NATIVE {OM_UPDATE}    CONST OM_UPDATE    = ($108) /* notification message from somebody  */
NATIVE {OM_ADDMEMBER} CONST OM_ADDMEMBER = ($109) /* used by various classes with lists  */
NATIVE {OM_REMMEMBER} CONST OM_REMMEMBER = ($10A) /* used by various classes with lists  */

/* Parameter "Messages" passed to methods */

/* OM_NEW and OM_SET */
NATIVE {opSet} OBJECT opset
    {MethodID}	methodid	:ULONG
    {ops_AttrList}	attrlist	:ARRAY OF tagitem /* new attributes */
    {ops_GInfo}	ginfo	:PTR TO gadgetinfo    /* always there for gadgets,
                                      * when SetGadgetAttrs() is used,
                                      * but will be NULL for OM_NEW
                                      */
ENDOBJECT

/* OM_NOTIFY, and OM_UPDATE */
NATIVE {opUpdate} OBJECT opupdate
    {MethodID}	methodid	:ULONG
    {opu_AttrList}	attrlist	:ARRAY OF tagitem /* new attributes */
    {opu_GInfo}	ginfo	:PTR TO gadgetinfo    /* non-NULL when SetGadgetAttrs or
                                      * notification resulting from gadget
                                      * input occurs.
                                      */
    {opu_Flags}	flags	:ULONG    /* defined below */
ENDOBJECT

/* this flag means that the update message is being issued from
 * something like an active gadget, a la GACT_FOLLOWMOUSE.  When
 * the gadget goes inactive, it will issue a final update
 * message with this bit cleared.  Examples of use are for
 * GACT_FOLLOWMOUSE equivalents for propgadclass, and repeat strobes
 * for buttons.
 */
NATIVE {OPUF_INTERIM} CONST OPUF_INTERIM = $1

/* OM_GET */
NATIVE {opGet} OBJECT opget
    {MethodID}	methodid	:ULONG
    {opg_AttrID}	attrid	:ULONG
    {opg_Storage}	storage	:PTR TO ULONG /* may be other types, but "int"
                         * types are all ULONG
                         */
ENDOBJECT

/* OM_ADDTAIL */
NATIVE {opAddTail} OBJECT opaddtail
    {MethodID}	methodid	:ULONG
    {opat_List}	list	:PTR TO lh
ENDOBJECT

/* OM_ADDMEMBER, OM_REMMEMBER */
NATIVE {opAddMember} CONST
NATIVE {opMember} OBJECT opmember
    {MethodID}	methodid	:ULONG
    {opam_Object}	object	:PTR TO INTUIOBJECT
ENDOBJECT
