{ Classes.i }

{$I   "Include:utility/Hooks.i"}
{$I   "Include:Intuition/classusr.i"}


{*****************************************}
{** "White box" access to struct IClass **}
{*****************************************}

{ This structure is READ-ONLY, and allocated only by Intuition }
TYPE
   IClass = Record
    cl_Dispatcher       : Hook;
    cl_Reserved         : Integer;    { must be 0  }
    cl_Super            : ^IClass;
    cl_ID               : ClassID;

    { where within an object is the instance data for this class? }
    cl_InstOffset       : Short;
    cl_InstSize         : Short;

    cl_UserData         : Integer;    { per-class data of your choice }
    cl_SubclassCount    : Integer;
                                        { how many direct subclasses?  }
    cl_ObjectCount      : Integer;
                                { how many objects created of this class? }
    cl_Flags            : Integer;
   END;
   IClassPtr = ^IClass;

CONST
 CLF_INLIST    =  $00000001;      { class is in public class list }



{************************************************}
{** "White box" access to struct _Object       **}
{************************************************}

{
 * We have this, the instance data of the root class, PRECEDING
 * the "object".  This is so that Gadget objects are Gadget pointers,
 * and so on.  If this structure grows, it will always have o_Class
 * at the end, so the macro OCLASS(o) will always have the same
 * offset back from the pointer returned from NewObject().
 *
 * This data structure is subject to change.  Do not use the o_Node
 * embedded structure.
 }
Type
  _Object = Record
    o_Node    : MinNode;
    o_Class   : IClassPtr;
  END;
  _ObjectPtr = ^_Object;

{ add offset for instance data to an object handle }
FUNCTION INST_DATA(cl : IClassPtr; o : _ObjectPtr) : Integer;
 External;
 

{ sizeof the instance data for a given class }
FUNCTION SIZEOF_INSTANCE(cl : IClass) : Integer;
 External;


{ convenient typecast  }
FUNCTION _OBJ(o : _Objectptr) : Integer;
 External;

{ get "public" handle on baseclass instance from real beginning of obj data }
FUNCTION BASEOBJECT(_obj : _ObjectPtr) : Integer;
 External;

{ get back to object data struct from public handle }
FUNCTION __OBJECT(o : _ObjectPtr) : Integer;
 External;

{ get class pointer from an object handle      }
FUNCTION OCLASS(o : _ObjectPtr) : Integer;
 External;
