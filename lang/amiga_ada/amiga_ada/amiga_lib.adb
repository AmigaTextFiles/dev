with System;
with intuition_classusr; use intuition_classusr;
package body amiga_lib is

function DoMethodA( obj : Object_Ptr ; message : Msg ) return Unsigned_32 is
   function DoMethodA( obj : Object_Ptr ; message : System.Address ) return Unsigned_32;
   pragma Import (C, DoMethodA, "DoMethodA" );

   begin
      return DoMethodA(obj, message.MsgAddress );
   end DoMethodA;
pragma Inline(DoMethodA);

function DoSuperMethodA( cl : IClass_Ptr; obj : Object_Ptr; Message : Msg ) return Unsigned_32 is
   function DoSuperMethodA( cl : IClass_Ptr; obj : Object_Ptr; Message : System.Address ) return Unsigned_32;
   pragma Import (C, DoSuperMethodA, "DoSuperMethodA" );

   begin
      return DoSuperMethodA(cl,obj,Message.MsgAddress);
   end DoSuperMethodA;
pragma Inline(DoSuperMethodA);

function CoerceMethodA( cl : IClass_Ptr; obj : Object_Ptr ; Message : Msg ) return Unsigned_32 is
   function CoerceMethodA( cl : IClass_Ptr; obj : Object_Ptr ; Message : System.Address ) return Unsigned_32;
   pragma Import (C, CoerceMethodA, "CoerceMethodA" );

   begin
      return CoerceMethodA(cl,obj,Message.MsgAddress);
   end CoerceMethodA;
pragma Inline(CoerceMethodA);

end amiga_lib;
