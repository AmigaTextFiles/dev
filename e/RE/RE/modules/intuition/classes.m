//Converting: ram:classes.h
//dest: ram:classes.m
#ifndef	INTUITION_CLASSES_H
#define INTUITION_CLASSES_H	1

#ifndef UTILITY_HOOKS_H
MODULE  'utility/hooks'
#endif
#ifndef	INTUITION_CLASSUSR_H
MODULE  'intuition/classusr'
#endif
#ifndef	EXEC_LIBRARIES_H
MODULE  'exec/libraries'
#endif 




  OBJECT IClass
 
    		Dispatcher:Hook
    Reserved:LONG	
    	Super:PTR TO IClass
    ID:PTR TO CHAR->ClassID
    
    InstOffset:UWORD
    InstSize:UWORD
    UserData:LONG	
    SubclassCount:LONG
					
    ObjectCount:LONG
				
    Flags:LONG
ENDOBJECT 
#define	CLF_INLIST	00000001	

/*
#define INST_DATA ( cl, o )	(( *) (((UBYTE *)o)+cl.cl_InstOffset))
#define SIZEOF_INSTANCE ( cl )	((cl).cl_InstOffset + (cl).cl_InstSize \
			+   SIZEOF _Object )

#define _OBJ ( o )	(  (o))
#define BASEOBJECT ( _obj )	 ( (Object *) (_OBJ(_obj)+1) )
#define _OBJECT ( o )		(_OBJ(o) - 1)
#define OCLASS ( o )	 ( (_OBJECT(o)).o_Class )
*/
#define INST_DATA(cl,o) ((o)+(cl::IClass.InstOffset))
#define SIZEOF_INSTANCE(cl) ((cl::IClass.InstOffset)+(cl::IClass.InstSize)+SIZEOF _Object)

OBJECT _Object
    	Node:MinNode
    	Class:PTR TO IClass
ENDOBJECT

CONST	OJ_CLASS=8

#define _OBJ(o) (o)
#define BASEOBJECT(_obj) ((_obj)+SIZEOF _Object)
#define _OBJECT(o) ((o)-SIZEOF _Object)
#define OCLASS(o) (Long(_OBJECT(o)+OJ_CLASS))

OBJECT ClassLibrary
	Lib:Library
	Pad:INT
	Class:PTR TO IClass
ENDOBJECT

#endif

