{-- GE_classes.i --}

{-------------------------------------}
{-   Started on October 30 - 2001    -}
{-     (c) 2001 by Pablo Roldán      -}
{-------------------------------------}
{-  1-Nov-2001 : Finished MakeClass, -} 
{-               FreeClass, AddClass -}
{-               & RemoveClass, not  -}
{-               tested yet.         -}
{- 27-Nov-2001 : All functions       -}
{                rewritten in asm.   -} 
{-------------------------------------}

{$I "Include:Libraries/GEngine.i"}
{$I "Include:Libraries/GE_TagItem.i"}
{$I "Include:Libraries/GE_Hooks.i"}
{$I "Include:Utils/StringLib.i"}

TYPE
   Object = Integer;
   ObjectPtr = ^Object;
   ClassID = ^Byte;

{ This structure is READ-ONLY, and allocated only by Intuition... }
{ erm... I mean, GEngine.}
{ The same as IClass but renamed }

   GEClass = Record
    gc_Dispatcher       : Hook;
    gc_Reserved         : Integer;    { must be 0  }
    gc_Super            : ^GEClass;
    gc_ID               : ClassID;

    { where within an object is the instance data for this class? }
    gc_InstOffset       : Short;
    gc_InstSize         : Short;

    gc_UserData         : Integer;    { per-class data of your choice }
    gc_SubclassCount    : Integer;
                                        { how many direct subclasses?  }
    gc_ObjectCount      : Integer;
                                { how many objects created of this class? }
    gc_Flags            : Integer;
   END;
   GEClassPtr = ^GEClass;

CONST
 GCF_INLIST    =  $00000001;      { class is in public class list }
{-----}
Var
 RClass : GEClassPtr;


{-------How are objects placed in memory-------}

{  |========|   \  }
{  |go_node |   |- _GObject struct}
{  |--------|   |  (root class instance)}
{  |go_Class|   |  }
{  |========|   /  }
{  | GGClass| <- Return of Newobject   root}
{  | inst.  |      points here           |}
{  |(gadget)|                         GGClass}
{  |========|                            |}
{  | inst 1 |                         class1}
{  |========|                            |}
{  | inst 2 |                         class2}
{  |========| }

Type

  _GObject = Record
    go_Node    : MinNode;
    go_Class   : GEClassPtr;
  END;
  _GObjectPtr = ^_GObject;

Const
{ Dispatched method ID's }

 GM_Dummy       = $100;
 GM_NEW         = $101; { 'object' parameter is "true class"   }
 GM_DISPOSE     = $102; { delete self (no parameters)          }
 GM_SET         = $103; { set attributes (in tag list)         }
 GM_GET         = $104; { return single attribute value        }
 GM_ADDTAIL     = $105; { add self to a List (let root do it)  }
 GM_REMOVE      = $106; { remove self from list                }
 GM_NOTIFY      = $107; { send to self: notify dependents      }
 GM_UPDATE      = $108; { notification message from somebody   }
 GM_ADDMEMBER   = $109; { used by various classes with lists   }
 GM_REMMEMBER   = $10A; { used by various classes with lists   }


{ GM_NEW and GM_SET    }
Type
   gpSet = Record
    MethodID            : Integer;
    gps_AttrList        : TagItemPtr;   { new attributes       }
    gps_GInfo           : GadgetInfoPtr; { always there for gadgets,
                                         * when GE_SetGadgetAttrs() is used,
                                         * but will be NULL for GM_NEW
                                         }
   END;
   gpSetPtr = ^gpSet;

{ GM_GET       }
Type
  gpGet = Record
    MethodID,
    gpg_AttrID          : Integer;
    gpg_Storage         : Address;   { may be other types, but "int"
                                         * types are all ULONG
                                         }
  END;
  gpGetPtr = ^gpGet;

{ GERoot Class dispatcher }

Function _GERootHook(class:GEClassPtr; Object,Msg:Address):Integer;
Var
 MM: ^Array[0..0]of integer;
 TMem: _GObjectPtr;
 TClass: GEClassPtr;
 i: Integer;

Begin
 if (Object<>Nil)and(Msg<>Nil)then begin
  MM:= Msg;
  Case MM^[0] of
   GM_NEW : if class<>GEClassPtr(Object) then begin
    TClass:= Object;
    i:= TClass^.gc_InstOffset+TClass^.gc_InstSize; {Size of the sum of all instances}
    TMem:= GE_PoolAlloc(GEngineBase^.eb_ObjPool,i);
    if TMem<>Nil then begin
     TMem^.go_Class:= TClass;
     inc(TClass^.gc_ObjectCount);
     _GERootHook:= Integer(TMem);
    end;
   end;
   GM_DISPOSE : Begin
    TMem:= _GObjectPtr(Object);
    i:= (TMem^.go_Class^.gc_InstOffset)+(TMem^.go_Class^.gc_InstSize);
    dec(TMem^.go_Class^.gc_ObjectCount);
    GE_PoolDealloc(GEngineBase^.eb_ObjPool,TMem,i);
   end;
  end; 
 end;
 _GERootHook:=0;
end;


{ --- }

FUNCTION GE_MakeClass(classID : String; superClassID : String; superClass : GEClassPtr; instanceSize : Short; flags : Integer) : GEClassPtr;
External;

Function GE_FreeClass(class: GEClassPtr):Boolean;
External;

Procedure GE_AddClass(class: GEClassPtr);
External;

Procedure GE_RemoveClass(class: GEClassPtr);
External;

Function GE_IsObject(Obj:Address):Boolean;
External;

Function INST_DATA(cl:GEClassPtr;o:_GObjectPtr):Address;

Begin
 INST_DATA:= Address(integer(o)+ cl^.gc_InstOffset);
end;


Function DoMethodA(Obj:_GObjectPtr; Msg:Address):Integer;

Begin
 DoMethodA:=CallHook(HookPtr(Obj^.go_Class),Obj,Msg);
end;

Function DoSuperMethodA(C:GEClassPtr; Obj:_GObjectPtr; Msg:Address):Integer;

Begin
 DoSuperMethodA:= CallHook(HookPtr(C^.gc_Super),Obj,Msg);
end;