/* $Id: classes.h 25583 2007-03-26 23:38:53Z dariusb $ */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/libraries', 'target/intuition/classusr', 'target/utility/hooks', 'target/aros/asmcall'
MODULE 'target/exec/nodes', 'target/exec/types'
{#include <intuition/classes.h>}
NATIVE {INTUITION_CLASSES_H} CONST

/* The following structure is READ-ONLY */
NATIVE {IClass} OBJECT iclass
    {cl_Dispatcher}	dispatcher	:hook
    {cl_Reserved}	reserved	:ULONG
    {cl_Super}	super	:PTR TO iclass         /* Super-Class */
    {cl_ID}	id	:CLASSID
    {cl_InstOffset}	instoffset	:UINT
    {cl_InstSize}	instsize	:UINT
    {cl_UserData}	userdata	:IPTR      /* application specific */
    {cl_SubclassCount}	subclasscount	:ULONG /* # of direct suclasses */
    {cl_ObjectCount}	objectcount	:ULONG   /* # of objects, made from this class
                                        must be 0, if the class is to be
                                        deleted */
    {cl_Flags}	flags	:ULONG         /* see below */
    {cl_ObjectSize}	objectsize	:ULONG    /* cl_InstOffset + cl_InstSize + sizeof(struct _Object) */
    {cl_MemoryPool}	memorypool	:APTR
ENDOBJECT /*Class*/
NATIVE {Class} DEF

/* cl_Flags */
NATIVE {CLF_INLIST} CONST CLF_INLIST = $1

/* This structure is situated before the pointer. It may grow in future,
   but o_Class will always stay at the end, so that you can substract
   the size of a pointer from the object-pointer to get a pointer to the
   pointer to the class of the object. */
#define object _object
NATIVE {_Object} OBJECT _object
    {o_Node}	node	:mln  /* PRIVATE */
    {o_Class}	class	:PTR TO iclass
ENDOBJECT

NATIVE {_OBJ} PROC	->_OBJ(obj) ((struct _Object *)(obj))
NATIVE {BASEOBJECT} CONST	->BASEOBJECT(obj) ((Object *)(_OBJ(obj) + 1))
NATIVE {_OBJECT} PROC	->_OBJECT(obj) (_OBJ(obj) - 1)

NATIVE {OCLASS} CONST	->OCLASS(obj) ((_OBJECT(obj))->o_Class)

NATIVE {INST_DATA} CONST	->INST_DATA(class, obj) ((APTR)(((UBYTE *)(obj)) + (class)->cl_InstOffset))

NATIVE {SIZEOF_INSTANCE} CONST	->SIZEOF_INSTANCE(class) ((class)->cl_InstOffset + (class)->cl_InstSize + sizeof(struct _Object))

NATIVE {ClassLibrary} OBJECT classlibrary
    {cl_Lib}	lib	:lib
    {cl_Pad}	pad	:UINT
    {cl_Class}	class	:PTR TO iclass
ENDOBJECT

/* 
    With the following define a typical dispatcher will looks like this:
    BOOPSI_DISPATCHER(IPTR,IconWindow_Dispatcher,cl,obj,msg)
*/
NATIVE {BOOPSI_DISPATCHER} CONST	->BOOPSI_DISPATCHER(rettype,name,cl,obj,msg) AROS_UFH3(rettype, name, AROS_UFHA(Class  *, cl,  A0), AROS_UFHA(Object *, obj, A2), AROS_UFHA(Msg     , msg, A1)) {AROS_USERFUNC_INIT
NATIVE {BOOPSI_DISPATCHER_END} CONST ->BOOPSI_DISPATCHER_END = AROS_USERFUNC_EXIT}
NATIVE {BOOPSI_DISPATCHER_PROTO} CONST	->BOOPSI_DISPATCHER_PROTO(rettype,name,cl,obj,msg) AROS_UFP3(rettype, name, AROS_UFPA(Class  *, cl,  A0), AROS_UFPA(Object *, obj, A2), AROS_UFPA(Msg     , msg, A1))

-> instoffset and instsize are unsigned so AND with $FFFF
#define INST_DATA(cl, o) Inst_data(cl, o)
PROC Inst_data(cl:PTR TO iclass, o) IS cl.instoffset AND $FFFF + o
#define SIZEOF_INSTANCE(cl) Sizeof_instance(cl)
PROC Sizeof_instance(cl:PTR TO iclass) IS (cl.instoffset AND $FFFF)+(cl.instsize AND $FFFF)+SIZEOF _object

#define _OBJ(o) (o)
#define BASEOBJECT(_obj) ((_obj)+SIZEOF object)
#define _OBJECT(o) ((o)-SIZEOF object)
#define OCLASS(o) (GetLong(_OBJECT(o)+OJ_CLASS))
