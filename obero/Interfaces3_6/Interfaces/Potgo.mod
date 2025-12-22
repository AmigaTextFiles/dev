(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Potgo.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE Potgo;

IMPORT e * := Exec;

CONST
  potgoName * = "potgo.resource";

VAR

(*
 *  You have to put a pointer to the potgo.resource here to use the potgo
 *  procedures:
 *)

  base * : e.APTR;


PROCEDURE AllocPotBits *{base,-  6}(bits{0}  : SET): SET;
PROCEDURE FreePotBits  *{base,- 12}(bits{0}  : SET);
PROCEDURE WritePotgo   *{base,- 18}(word{0}  : SET;
                                    mask{1}  : SET);

END Potgo.


