/* $VER: classes.h 40.0 (15.2.1994) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/exec/libraries', 'target/utility/hooks', 'target/intuition/classusr'
MODULE 'target/exec/nodes'
{MODULE 'intuition/classes'}

/*****************************************************************************/
/***************** "White Box" access to struct IClass ***********************/
/*****************************************************************************/

/* This structure is READ-ONLY, and allocated only by Intuition */
NATIVE {iclass} OBJECT iclass
    {dispatcher}	dispatcher	:hook		/* Class dispatcher */
    {reserved}	reserved	:ULONG		/* Must be 0  */
    {super}	super	:PTR TO iclass		/* Pointer to superclass */
    {id}	id	:CLASSID			/* Class ID */

    {instoffset}	instoffset	:UINT		/* Offset of instance data */
    {instsize}	instsize	:UINT		/* Size of instance data */

    {userdata}	userdata	:ULONG		/* Class global data */
    {subclasscount}	subclasscount	:ULONG	/* Number of subclasses */
    {objectcount}	objectcount	:ULONG	/* Number of objects */
    {flags}	flags	:ULONG

ENDOBJECT /*Class*/

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

#define object _object
NATIVE {object} OBJECT _object
    {node}	node	:mln
    {class}	class	:PTR TO iclass

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

NATIVE {classlibrary} OBJECT classlibrary
    {lib}	lib	:lib	/* Embedded library */
    {pad}	pad	:UINT	/* Align the structure */
    {class}	class	:PTR TO iclass	/* Class pointer */

ENDOBJECT

-> instoffset and instsize are unsigned so AND with $FFFF
#define INST_DATA(cl, o) Inst_data(cl, o)
PROC Inst_data(cl:PTR TO iclass, o) IS cl.instoffset AND $FFFF + o
#define SIZEOF_INSTANCE(cl) Sizeof_instance(cl)
PROC Sizeof_instance(cl:PTR TO iclass) IS (cl.instoffset AND $FFFF)+(cl.instsize AND $FFFF)+SIZEOF _object

#define _OBJ(o) (o)
#define BASEOBJECT(_obj) ((_obj)+SIZEOF object)
#define _OBJECT(o) ((o)-SIZEOF object)
#define OCLASS(o) (GetLong(_OBJECT(o)+OJ_CLASS))
