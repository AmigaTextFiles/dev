(*
(*
**  Amiga Oberon Interface Module:
**  $VER: MathFFP.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE MathFFP;

IMPORT
  Exec *;

CONST
  pi    * = 3.141592653589793;
  twoPi * = 2 * pi;
  pi2   * = pi / 2;
  pi4   * = pi / 4;

  e     * = 2.718281828459045;
  log10 * = 2.302585092994046;

  fpTen  * = 10;
  fpOne  * = 1;
  fpHalf * = 1/2;
  fpZero * = 0;

CONST
  MathFFPName * = "mathffp.library";

VAR
  base * : Exec.LibraryPtr;

(*--- functions in V33 or higher (Release 1.2) ---*)

PROCEDURE Fix  * {base,-30}(x{0} : REAL): LONGINT;
PROCEDURE Flt  * {base,-36}(x{0} : LONGINT): REAL;
PROCEDURE Cmp  * {base,-42}(x{1} : REAL;
                            y{0} : REAL): LONGINT;
PROCEDURE Tst  * {base,-48}(x{1} : REAL): LONGINT;
PROCEDURE Abs  * {base,-54}(x{0} : REAL): REAL;
PROCEDURE Neg  * {base,-60}(x{0} : REAL): REAL;
PROCEDURE Add  * {base,-66}(x{0} : REAL;
                            y{1} : REAL): REAL;
PROCEDURE Sub  * {base,-72}(x{0} : REAL;
                            y{1} : REAL): REAL;
PROCEDURE Mul  * {base,-78}(x{0} : REAL;
                            y{1} : REAL): REAL;
PROCEDURE Div  * {base,-84}(x{0} : REAL;
                            y{1} : REAL): REAL;
PROCEDURE Floor* {base,-90}(x{0} : REAL): REAL;
PROCEDURE Ceil * {base,-96}(x{0} : REAL): REAL;

(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

BEGIN
  base := Exec.OpenLibrary(MathFFPName,33);
  IF base=NIL THEN HALT(20) END;

CLOSE
  IF base#NIL THEN Exec.CloseLibrary(base) END;

END MathFFP.

