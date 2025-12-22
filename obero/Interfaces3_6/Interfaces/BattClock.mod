(*
(*
**  Amiga Oberon Interface Module:
**  $VER: BattClock.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE BattClock;

IMPORT e * := Exec;

CONST

  battClockName * = "battclock.resource";


VAR

(*
 *  You have to put a pointer to the battclock.resource here to use the battclock
 *  procedures:
 *)

  base * : e.APTR;

PROCEDURE ResetBattClock    *{base,-  6}();
PROCEDURE ReadBattClock     *{base,- 12}(): LONGINT;
PROCEDURE WriteBattClock    *{base,- 18}(time{0}   : LONGINT);
PROCEDURE ReadBattClockMem  *{base,- 24}(offset{1} : LONGINT;
                                         length{2} : LONGINT): LONGINT;
PROCEDURE WriteBattClockMem *{base,- 30}(offset{1} : LONGINT;
                                         length{2} : LONGINT);

END BattClock.


