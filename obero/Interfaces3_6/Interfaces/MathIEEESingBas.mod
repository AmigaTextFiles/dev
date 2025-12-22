(*
(*
**  Amiga Oberon Interface Module:
**  $VER: MathIEEESingBas.mod 40.15 (28.12.93) Oberon 3.4
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE MathIEEESingBas;

IMPORT
  E  * := Exec,
  ml * := MathLibrary,
  SYSTEM *;

CONST
  pi      * = SYSTEM.VAL(E.SINGLE,040490FDAH);

  twoPi   * = SYSTEM.VAL(E.SINGLE,040C90FDAH);
  pi2     * = SYSTEM.VAL(E.SINGLE,03FC90FDAH);
  pi4     * = SYSTEM.VAL(E.SINGLE,03F490FDAH);

  e       * = SYSTEM.VAL(E.SINGLE,0402DF854H);

  log10   * = SYSTEM.VAL(E.SINGLE,040135D8DH);
  fpTen   * = SYSTEM.VAL(E.SINGLE,041200000H);
  fpOne   * = SYSTEM.VAL(E.SINGLE,03F800000H);
  fpHalf  * = SYSTEM.VAL(E.SINGLE,03F000000H);
  fpZero  * = SYSTEM.VAL(E.SINGLE,000000000H);

  mathIEEESingBasName * = "mathieeesingbas.library";

VAR

  base * : ml.MathIEEEBasePtr;


PROCEDURE Fix*  {base,- 30}(x{0} : E.SINGLE ): LONGINT;
PROCEDURE Flt*  {base,- 36}(x{0} : LONGINT  ): E.SINGLE;
PROCEDURE Cmp*  {base,- 42}(x{0} : E.SINGLE;
                            y{1} : E.SINGLE ): LONGINT;
PROCEDURE Tst*  {base,- 48}(x{0} : E.SINGLE ): LONGINT;
PROCEDURE Abs*  {base,- 54}(x{0} : E.SINGLE ): E.SINGLE;
PROCEDURE Neg*  {base,- 60}(x{0} : E.SINGLE ): E.SINGLE;
PROCEDURE Add*  {base,- 66}(x{0} : E.SINGLE;
                            y{1} : E.SINGLE ): E.SINGLE;
PROCEDURE Sub*  {base,- 72}(x{0} : E.SINGLE;
                            y{1} : E.SINGLE ): E.SINGLE;
PROCEDURE Mul*  {base,- 78}(x{0} : E.SINGLE;
                            y{1} : E.SINGLE ): E.SINGLE;
PROCEDURE Div*  {base,- 84}(x{0} : E.SINGLE;
                            y{1} : E.SINGLE ): E.SINGLE;
PROCEDURE Floor*{base,- 90}(x{0} : E.SINGLE ): E.SINGLE;
PROCEDURE Ceil* {base,- 96}(x{0} : E.SINGLE ): LONGREAL;


(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

BEGIN
  base := E.OpenLibrary(mathIEEESingBasName,37);

CLOSE
  IF base # NIL THEN E.CloseLibrary(base) END;

END MathIEEESingBas.

