#INTUITION_CLASSES_H = 1
;
; **  $VER: classes.h 38.1 (11.11.91)
; **  Includes Release 40.15
; **
; **  Used only by class implementors
; **
; **  (C) Copyright 1989-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "utility/hooks.pb"
XIncludeFile "intuition/classusr.pb"

; *****************************************
; ** "White box" access to struct IClass **
; *****************************************

;  This structure is READ-ONLY, and allocated only by Intuition
Structure IClass
    cl_Dispatcher.Hook
    cl_Reserved.l ;  must be 0
    *cl_Super.IClass
    cl_ID.b

    ;  where within an object is the instance data for this class?
    cl_InstOffset.w
    cl_InstSize.w

    cl_UserData.l ;  per-class data of your choice
    cl_SubclassCount.l
     ;  how many direct subclasses?
    cl_ObjectCount.l
    ;  how many objects created of this class?
    cl_Flags.l
EndStructure

#CLF_INLIST = $00000001 ;  class is in public class list

;  add offset for instance data to an object handle
;#INST_DATA( = cl, o ) ((VOID *) (((*)o)+cl\cl_InstOffset)).b

;  sizeof the instance data for a given class
;#SIZEOF_INSTANCE( = cl ) ((cl)\cl_InstOffset + (cl)\cl_InstSize \
;   + SizeOf ())._Object

; ************************************************
; ** "White box" access to struct _Object **
; ************************************************

;
;  * We have this, the instance data of the root class, PRECEDING
;  * the "object".  This is so that Gadget objects are Gadget pointers,
;  * and so on.  If this structure grows, it will always have o_Class
;  * at the end, so the macro OCLASS(o) will always have the same
;  * offset back from the pointer returned from NewObject().
;  *
;  * This data structure is subject to change.  Do not use the o_Node
;  * embedded structure.
;
Structure _Object
    o_Node.MinNode
    *o_Class.IClass
EndStructure

;  convenient typecast
;#_OBJ( = o ) ((*)(o))._Object

;  get "public" handle on baseclass instance from real beginning of obj data
;#BASEOBJECT( = _obj ) ( (Object *) (#_OBJ(_obj)+1) )

;  get back to object data struct from public handle
;#_OBJECT( = o )  (#_OBJ(o) - 1)

;  get class pointer from an object handle
;#OCLASS( = o ) ( (#_OBJECT(o))\o_Class )

