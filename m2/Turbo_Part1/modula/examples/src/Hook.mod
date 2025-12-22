MODULE Hook ;

FROM SYSTEM IMPORT ADDRESS, ADR ;
IMPORT U := Utility{36}, Dos{36} ;

(* This simple function is used to initialize a Hook *)

PROCEDURE InitHook ( VAR h : U.Hook ; func : U.HOOKFUNC ; data : ADDRESS ) ;
BEGIN (* Fill in the Hook fields *)
  h.h_Entry := U.HookEntry;
  h.h_SubEntry := func ;
  h.h_Data := data ;
END InitHook ;

(* This function only prints out a message indicating that we are inside      *)
(* the callback function.						      *)
(* The '@G' comment obtains access to the global data segment (for this       *)
(* procedure only), this is the same as the DICE '__geta4' qualifier          *)
(* Any procedure that is the entry point of an OS callback		      *)
(* (eg Hook functions, argument of CreateTask etc) must fetch the global      *)
(* variable pointer or otherwise crash.					      *)
(* NB: Any program that does this can not be made resident (linking will fail)*)

PROCEDURE (* @G *)
	  MyFunction ( VAR h : U.Hook ; o : ADDRESS ; msg : ADDRESS ) : LONGINT;
BEGIN
  Dos.Printf( "Inside Hook.MyFunction(%ld,%ld)\n", o, msg ) ;
  RETURN 1
END MyFunction ;

VAR
   h : U.Hook ;

BEGIN
  InitHook( h, U.HOOKFUNC( MyFunction ), NIL) ;
  U.CallHookPkt( ADR(h), 42, 43)
END Hook.
