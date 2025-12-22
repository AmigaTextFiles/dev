(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Keyboard.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE Keyboard;   (* $Implementation- *)

IMPORT e * := Exec;

CONST
  keyboardName * = "keyboard.device";

  readEvent        * = e.nonstd+0;
  readMatrix       * = e.nonstd+1;
  addResetHandler  * = e.nonstd+2;
  remResetHandler  * = e.nonstd+3;
  resetHandlerDone * = e.nonstd+4;

END Keyboard.

