/* $VER: classes.h 40.0 (15.2.1994) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/exec/libraries', 'target/utility/hooks', 'target/intuition/classusr'
MODULE 'target/exec/nodes'
{#include <intuition/classes.h>}
NATIVE {INTUITION_CLASSES_H} CONST

/*****************************************************************************/
/***************** "White Box" access to struct IClass ***********************/
/*****************************************************************************/

/* This structure is READ-ONLY, and allocated only by Intuition */
NATIVE {IClass} OBJECT iclass
    {cl_Dispatcher}	dispatcher	:hook		/* Class dispatcher */
    {cl_Reserved}	reserved	:ULONG		/* Must be 0  */
    {cl_Super}	super	:PTR TO iclass		/* Pointer to superclass */
    {cl_ID}	id	:CLASSID			/* Class ID */

    {cl_InstOffset}	instoffset	:UINT		/* Offset of instance data */
    {cl_InstSize}	instsize	:UINT		/* Size of instance data */

    {cl_UserData}	userdata	:ULONG		/* Class global data */
    {cl_SubclassCount}	subclasscount	:ULONG	/* Number of subclasses */
    {cl_ObjectCount}	objectcount	:ULONG	/* Number of objects */
    {cl_Flags}	flags	:ULONG

ENDOBJECT /*Class*/
NATIVE {Class} OBJECT

NATIVE {CLF_INLIST}	CONST CLF_INLIST	= $00000001
    /* class is in public class list */

/*****************************************************************************/

/* add offset for instance data to an object handle */
NATIVE {INST_DATA} CONST	->INST_DATA(cl,o)		((void *)(((UBYTE *)o)+cl->cl_InstOffset))

/*****************************************************************************/

/* sizeof the instance data for a given class */
NATIVE {SIZEOF_INSTANCE} CONST	->SIZEOF_INSTANCE(cl)	((cl)->cl_InstOffset + (cl)->cl_InstSize + sizeof (struct _Object))

/*****************************************************************************/
/***************** "White box" access to struct _Object **********************/
/*****************************************************************************/

/* We have this, the instance data of the root class, PRECEDING the "object".
 * This is so that Gadget objects are Gadget pointers, and so on.  If this
 * structure grows, it will always have o_Class at the end, so the macro
 * OCLASS(o) will always have the same offset back from the pointer returned
 * from NewObject().
 *
 * This data structure is subject to change.  Do not use the o_Node embedded
 * structure. */
#define object _object
NATIVE {_Object} OBJECT _object
    {o_Node}	node	:mln
    {o_Class}	class	:PTR TO iclass

ENDOBJECT

/*****************************************************************************/

/* convenient typecast	*/
NATIVE {_OBJ} PROC	->_OBJ(o)			((struct _Object *)(o))

/* get "public" handle on baseclass instance from real beginning of obj data */
NATIVE {BASEOBJECT} CONST	->BASEOBJECT(_obj)	((Object *)(_OBJ(_obj)+1))

/* get back to object data struct from public handle */
NATIVE {_OBJECT} PROC	->_OBJECT(o)		(_OBJ(o) - 1)

/* get class pointer from an object handle	*/
NATIVE {OCLASS} CONST	->OCLASS(o)		((_OBJECT(o))->o_Class)

/*****************************************************************************/

/* BOOPSI class libraries should use this structure as the base for their
 * library data.  This allows developers to obtain the class pointer for
 * performing object-less inquiries. */
NATIVE {ClassLibrary} OBJECT classlibrary
    {cl_Lib}	lib	:lib	/* Embedded library */
    {cl_Pad}	pad	:UINT	/* Align the structure */
    {cl_Class}	class	:PTR TO iclass	/* Class pointer */

ENDOBJECT

-> instoffset and instsize are unsigned so AND with $FFFF
#define INST_DATA(cl, o) Inst_data(cl, o)
PROC Inst_data(cl:PTR TO iclass, o) IS cl.instoffset AND $FFFF + o
#define SIZEOF_INSTANCE(cl) Sizeof_instance(cl)
PROC Sizeof_instance(cl:PTR TO iclass) IS (cl.instoffset AND $FFFF)+(cl.instsize AND $FFFF)+SIZEOF _object

#define _OBJ(o) (o)
#define BASEOBJECT(_obj) ((_obj)+SIZEOF _object)
#define _OBJECT(o) ((o)-SIZEOF _object)
#define OCLASS(o) (GetLong(_OBJECT(o)+OJ_CLASS))
