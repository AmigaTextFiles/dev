
{
    PCQUtils/Amiga.i

    This functions are not tested but they should
    work without any problems. (I hope).
}


(*  Intuition hook and boopsi support functions in amiga.lib. *)
(*  These functions do not require any particular ROM revision *)
(*  to operate correctly, though they deal with concepts first introduced *)
(*  in V36.  These functions would work with compatibly-implemented *)
(*  hooks or objects under V34. *)

{$C+}
FUNCTION CallHookA( HookP : HookPtr; obj : _ObjectPtr; mess : ADDRESS): INTEGER;
EXTERNAL;

FUNCTION CallHook( hookp : HookPtr; obj : _ObjectPtr; ... ): INTEGER;
EXTERNAL;

FUNCTION DoMethodA( obj : _ObjectPtr; mess : tMsgPtr): INTEGER;
EXTERNAL;

FUNCTION DoMethod( obj : _ObjectPtr; ... ): INTEGER;
EXTERNAL;

FUNCTION DoSuperMethodA( cl : IClassPtr; obj : _ObjectPtr; mess : tMsgPtr): INTEGER;
EXTERNAL;

FUNCTION DoSuperMethod( cd : IClassPtr; obj : _ObjectPtr ; ... ): INTEGER;
EXTERNAL;

FUNCTION CoerceMethodA( cl : IClassPtr ; obj : _ObjectPtr ;  mess : tMsgPtr): INTEGER;
EXTERNAL;

FUNCTION CoerceMethod( cl : IClassPtr; obj : _ObjectPtr ; ... ): INTEGER;
EXTERNAL;

FUNCTION SetSuperAttrs( cl : IClassPtr ; obj : _ObjectPtr;  ... ): INTEGER;
EXTERNAL;
{$C-}






