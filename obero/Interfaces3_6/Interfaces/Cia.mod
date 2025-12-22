(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Cia.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE Cia;

IMPORT e * := Exec;

CONST

  ciaaName * = "ciaa.resource";
  ciabName * = "ciab.resource";


VAR

(*
 *  You have to put a pointer to the cia?.resource here to use the cia
 *  procedures:
 *)

  base * : e.APTR;


PROCEDURE AddICRVector *{base,- 6}(icrBit{0}    : SHORTINT;
                                   interrupt{9} : e.InterruptPtr):e.InterruptPtr;
PROCEDURE RemICRVector *{base,-12}(icrBit{0}    : SHORTINT;
                                   interrupt{9} : e.InterruptPtr);
PROCEDURE AbleICR      *{base,-18}(mask{0}      : SHORTSET):SHORTSET;
PROCEDURE SetICR       *{base,-24}(mask{0}      : SHORTSET):SHORTSET;

END Cia.

