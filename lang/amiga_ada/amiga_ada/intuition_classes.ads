with Interfaces; use Interfaces;

with exec_nodes; use exec_nodes;
with intuition_classusr; use intuition_classusr;
with utility_hooks; use utility_hooks;

package intuition_classes is

--#ifndef UTILITY_HOOKS_H
--#include <utility/hooks.h>
--#endif
--
--#ifndef INTUITION_CLASSUSR_H
--#include <intuition/classusr.h>
--#endif
--
type IClass;
type IClass_Ptr is access IClass;
type IClass is record
cl_Dispatcher : Hook;
cl_Reserved : Unsigned_32;
cl_Super : IClass_Ptr;
cl_ID : ClassID;
cl_InstOffset : Unsigned_16;
cl_InstSize : Unsigned_16;
cl_UserData : Unsigned_32;
cl_SubclassCount : Unsigned_32;
cl_ObjectCount : Unsigned_32;
cl_Flags : Unsigned_32;
end record;

Class : IClass;

--#define CLF_INLIST 0x00000001
--#define INST_DATA( cl, o ) ((VOID_Ptr ) (((UBYTE_Ptr )o)+cl->cl_InstOffset))
--#define SIZEOF_INSTANCE( cl ) ((cl)->cl_InstOffset (cl)->cl_InstSize sizeof (_Object ))

type A_Object;
type A_Object_Ptr is access A_Object;
type A_Object is record
   o_Node : MinNode;
   o_Class : IClass_Ptr;
end record;

--#define _OBJ( o ) ((_Object_Ptr )(o))
--#define BASEOBJECT( _obj ) ( (Object_Ptr ) (_OBJ(_obj)+1) )
--#define _OBJECT( o ) (_OBJ(o) - 1)
--#define OCLASS( o ) ( (_OBJECT(o))->o_Class )

end intuition_classes;