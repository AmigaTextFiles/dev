(*
(*
**  Amiga Oberon Interface Module:
**  $VER: MathTrans.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE MathTrans;

IMPORT
  e * := Exec,
  I   := Intuition;

CONST
  MathTransName * = "mathtrans.library";

VAR
  base * : e.LibraryPtr;

PROCEDURE Atan  * {base,- 30}(x{0}       : REAL): REAL;
PROCEDURE Sin   * {base,- 36}(x{0}       : REAL): REAL;
PROCEDURE Cos   * {base,- 42}(x{0}       : REAL): REAL;
PROCEDURE Tan   * {base,- 48}(x{0}       : REAL): REAL;
PROCEDURE Sincos* {base,- 54}(VAR cos{1} : REAL;
                              x{0}       : REAL): REAL;
PROCEDURE Sinh  * {base,- 60}(x{0}       : REAL): REAL;
PROCEDURE Cosh  * {base,- 66}(x{0}       : REAL): REAL;
PROCEDURE Tanh  * {base,- 72}(x{0}       : REAL): REAL;
PROCEDURE Exp   * {base,- 78}(x{0}       : REAL): REAL;
PROCEDURE Log   * {base,- 84}(x{0}       : REAL): REAL;
PROCEDURE Pow   * {base,- 90}(e{1}       : REAL;
                              b{0}       : REAL): REAL;
PROCEDURE Sqrt  * {base,- 96}(x{0}       : REAL): REAL;
PROCEDURE Tieee * {base,-102}(x{0}       : REAL): LONGINT;
PROCEDURE Fieee * {base,-108}(x{0}       : LONGINT): REAL;
PROCEDURE Asin  * {base,-114}(x{0}       : REAL): REAL;
PROCEDURE Acos  * {base,-120}(x{0}       : REAL): REAL;
PROCEDURE Log10 * {base,-126}(x{0}       : REAL): REAL;


(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

BEGIN
  base := e.OpenLibrary(MathTransName,33);
  IF base=NIL THEN
    IF I.DisplayAlert(0,"\x00\x64\x14missing mathtrans.library\o\o",50) THEN END;
    HALT(0)
  END;

CLOSE
  IF base#NIL THEN e.CloseLibrary(base) END;

END MathTrans.

