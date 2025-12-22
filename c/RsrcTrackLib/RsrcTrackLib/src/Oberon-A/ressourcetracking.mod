(**************************************************************************

  ressourcetracking.mod

  Interface to ressourcetracking.library

  Date: 03-08-1998
  Author: BURNAND Patrick

***************************************************************************)

<* STANDARD- *>

MODULE [2] ressourcetracking;

IMPORT  SYS:=SYSTEM,  Kernel,  e:=Exec,  s:=Sets;

(*
**      $VER: ressourcetracking.h 37.0 (03.08.98)
**
**      external declarations for ressourcetracking.library
*)

CONST

  ressourcetrackingName * = "ressourcetracking.library";

VAR

  base * : e.LibraryPtr;


(*-- Library Functions ------------------------------------------------*)

(*
**      $VER: ressourcetracking_protos.h 37.0 (03.08.98)
*)

PROCEDURE AddManager*    [base,-30]  ( recNum[1]: e.ULONG ) : LONGINT;
PROCEDURE RemManager*    [base,-36]  (  );
PROCEDURE FindNumUsed*   [base,-42]  (  ) : LONGINT;

PROCEDURE SetMarker*     [base,-48]  (  );
PROCEDURE UnsetMarker*   [base,-78]  (  );

(*
** SetCustomF0(), SetCustomF1() and SetCustomF2() aren't usable with Oberon-A.
** There is a system crash when ressourcetracking.library calls the procedure passed
** to SetCustomF0(), SetCustomF1() or SetCustomF2().
** But Oberon-A features a cleanup system in module Kernel.
**
** PROCEDURE SetCustomF0*   [base,-60]  ( func[1]: e.APTR );
** PROCEDURE SetCustomF1*   [base,-66]  ( func[1]: e.APTR ; arg1[2]: e.ULONG );
** PROCEDURE SetCustomF2*   [base,-72]  ( func[1]: e.APTR ; arg1[2]: e.ULONG ; arg2[3]: e.ULONG );
*)

PROCEDURE AllocMem*      [base,-54]  ( byteSize[1]: e.ULONG ; requirements[2]: s.SET32 ) : e.APTR;
PROCEDURE AllocSignal*   [base,-84]  ( signalNum[1]: e.ULONG ) : e.BYTE;
PROCEDURE OpenLibrary*   [base,-90]  ( libName[1]: ARRAY OF CHAR ; version[2]: e.ULONG ) : e.LibraryPtr;
PROCEDURE AddSemaphore*  [base,-96]  ( sigSem[1]: e.SignalSemaphorePtr );
PROCEDURE Forbid*        [base,-102] (  );
PROCEDURE AllocTrap*     [base,-108] ( trapNum[1]: e.ULONG ) : LONGINT;
PROCEDURE CreateMsgPort* [base,-114] (  ) : e.MsgPortPtr;
PROCEDURE AddPort*       [base,-120] ( port[1]: e.MsgPortPtr );


(*-- Library Base variable --------------------------------------------*)

<*$LongVars-*>

(*-----------------------------------*)
PROCEDURE* [0] CloseLib (VAR rc : LONGINT);

BEGIN (* CloseLib *)
  IF base # NIL THEN e.CloseLibrary (base) END
END CloseLib;

BEGIN
  base := e.OpenLibrary (ressourcetrackingName, e.libraryMinimum);
  IF base = NIL THEN HALT (100) END;
  Kernel.SetCleanup (CloseLib)
END ressourcetracking.
