(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Input.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE Input;

IMPORT e * := Exec;

CONST

  addHandler  * = e.nonstd+0;
  remHandler  * = e.nonstd+1;
  writeEvent  * = e.nonstd+2;
  setThresh   * = e.nonstd+3;
  setPeriod   * = e.nonstd+4;
  setMPort    * = e.nonstd+5;
  setMType    * = e.nonstd+6;
  setMTrig    * = e.nonstd+7;

VAR

(*
 *  You have to put a pointer to the input.device here to use the input
 *  procedures:
 *)

  base * : e.DevicePtr;

(*--- functions in V36 or higher (Release 2.0) ---*)
PROCEDURE PeekQualifier*{base,-42}(): SET;

END Input.

