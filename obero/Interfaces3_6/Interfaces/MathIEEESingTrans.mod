(*
(*
**  Amiga Oberon Interface Module:
**  $VER: MathIEEESingTrans.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE MathIEEESingTrans;

IMPORT
  e  * := Exec,
  ml * := MathLibrary;

CONST

  mathIEEESingTransName * = "mathieeesingtrans.library";

VAR

  base * : ml.MathIEEEBasePtr;

PROCEDURE Atan  * {base,- 30}(x{0}       :e.SINGLE):e.SINGLE;
PROCEDURE Sin   * {base,- 36}(x{0}       :e.SINGLE):e.SINGLE;
PROCEDURE Cos   * {base,- 42}(x{0}       :e.SINGLE):e.SINGLE;
PROCEDURE Tan   * {base,- 48}(x{0}       :e.SINGLE):e.SINGLE;
PROCEDURE Sincos* {base,- 54}(VAR cos{8} : e.SINGLE;
                              x{0}       :e.SINGLE) :e.SINGLE;
PROCEDURE Sinh  * {base,- 60}(x{0}       :e.SINGLE):e.SINGLE;
PROCEDURE Cosh  * {base,- 66}(x{0}       :e.SINGLE):e.SINGLE;
PROCEDURE Tanh  * {base,- 72}(x{0}       :e.SINGLE):e.SINGLE;
PROCEDURE Exp   * {base,- 78}(x{0}       :e.SINGLE):e.SINGLE;
PROCEDURE Log   * {base,- 84}(x{0}       :e.SINGLE):e.SINGLE;
PROCEDURE Pow   * {base,- 90}(exp{1}     : e.SINGLE;
                              x{0}       :e.SINGLE):e.SINGLE;
PROCEDURE Sqrt  * {base,- 96}(x{0}       :e.SINGLE):e.SINGLE;
PROCEDURE Tieee * {base,-102}(x{0}       :e.SINGLE):e.SINGLE;
PROCEDURE Fieee * {base,-108}(x{0}       :e.SINGLE):e.SINGLE;
PROCEDURE Asin  * {base,-114}(x{0}       :e.SINGLE):e.SINGLE;
PROCEDURE Acos  * {base,-120}(x{0}       :e.SINGLE):e.SINGLE;
PROCEDURE Log10 * {base,-126}(x{0}       :e.SINGLE):e.SINGLE;


(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

BEGIN
  base := e.OpenLibrary(mathIEEESingTransName,37);

CLOSE
  IF base#NIL THEN e.CloseLibrary(base) END;

END MathIEEESingTrans.

