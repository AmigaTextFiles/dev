(*
(*
**  Amiga Oberon Interface Module:
**  $VER: MathIEEEDoubTrans.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE MathIEEEDoubTrans;

IMPORT
  e   := Exec,
  I   := Intuition,
  ml *:= MathLibrary;

CONST

  mathIEEEDoubTransName * = "mathieeedoubtrans.library";

VAR

  base * : ml.MathIEEEBasePtr;

PROCEDURE Atan  * {base,- 30}(x{0}       : LONGREAL): LONGREAL;
PROCEDURE Sin   * {base,- 36}(x{0}       : LONGREAL): LONGREAL;
PROCEDURE Cos   * {base,- 42}(x{0}       : LONGREAL): LONGREAL;
PROCEDURE Tan   * {base,- 48}(x{0}       : LONGREAL): LONGREAL;
PROCEDURE Sincos* {base,- 54}(VAR cos{8} : LONGREAL;
                              x{0}       : LONGREAL): LONGREAL;
PROCEDURE Sinh  * {base,- 60}(x{0}       : LONGREAL): LONGREAL;
PROCEDURE Cosh  * {base,- 66}(x{0}       : LONGREAL): LONGREAL;
PROCEDURE Tanh  * {base,- 72}(x{0}       : LONGREAL): LONGREAL;
PROCEDURE Exp   * {base,- 78}(x{0}       : LONGREAL): LONGREAL;
PROCEDURE Log   * {base,- 84}(x{0}       : LONGREAL): LONGREAL;
PROCEDURE Pow   * {base,- 90}(exp{2}     : LONGREAL;
                              x{0}       : LONGREAL): LONGREAL;
PROCEDURE Sqrt  * {base,- 96}(x{0}       : LONGREAL): LONGREAL;
PROCEDURE Tieee * {base,-102}(x{0}       : LONGREAL): e.SINGLE;
PROCEDURE Fieee * {base,-108}(x{0}       : e.SINGLE): LONGREAL;
PROCEDURE Asin  * {base,-114}(x{0}       : LONGREAL): LONGREAL;
PROCEDURE Acos  * {base,-120}(x{0}       : LONGREAL): LONGREAL;
PROCEDURE Log10 * {base,-126}(x{0}       : LONGREAL): LONGREAL;


(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

BEGIN
  base := e.OpenLibrary(mathIEEEDoubTransName,34);
  IF base=NIL THEN
    IF I.DisplayAlert(0,"\x00\x64\x14missing mathieeedoubtrans.library\o\o",50) THEN END;
    HALT(20)
  END;

CLOSE
  IF base#NIL THEN e.CloseLibrary(base) END;

END MathIEEEDoubTrans.

