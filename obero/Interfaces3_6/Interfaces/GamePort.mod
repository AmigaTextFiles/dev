(*
(*
**  Amiga Oberon Interface Module:
**  $VER: GamePort.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE GamePort;

IMPORT e * := Exec;

CONST

(******  GamePort commands ******)
  readEvent   * = e.nonstd+0;
  askCType    * = e.nonstd+1;
  setCType    * = e.nonstd+2;
  askTrigger  * = e.nonstd+3;
  setTrigger  * = e.nonstd+4;

(******  GamePort structures ******)

(* gpt_Keys *)
  downKeys  * = 0;
  upKeys    * = 1;

TYPE

  GamePortTriggerPtr * = UNTRACED POINTER TO GamePortTrigger;
  GamePortTrigger * = STRUCT
    keys * : SET;             (* key transition triggers *)
    timeout * : INTEGER;      (* time trigger (vertical blank units) *)
    xDelta * : INTEGER;       (* X distance trigger *)
    yDelta * : INTEGER;       (* Y distance trigger *)
  END;


CONST

(****** Controller Types ******)
  allocated    * = -1;  (* allocated by another user *)
  noController * = 0;

  mouse       * = 1;
  relJoystick * = 2;
  absJoystick * = 3;


(****** Errors ******)
  errSetCType * = 1;     (* this controller not valid at this time *)

END GamePort.

