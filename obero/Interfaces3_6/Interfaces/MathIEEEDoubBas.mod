(*
(*
**  Amiga Oberon Interface Module:
**  $VER: MathIEEEDoubBas.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE MathIEEEDoubBas;

IMPORT
  Exec,
  I   := Intuition,
  ml *:= MathLibrary;

CONST
  pi      * = 3.141592653589793D;

  twoPi   * = 2 * pi;
  pi2     * = pi / 2;
  pi4     * = pi / 4;

  e       * = 2.718281828459045D;

  log10   * = 2.302585092994046D;
  fpTen   * = 10.0D;
  fpOne   * = 1.0D;
  fpHalf  * = 0.5D;
  fpZero  * = 0.0D;

  mathIEEEDoubBasName * = "mathieeedoubbas.library";


VAR

  base * : ml.MathIEEEBasePtr;

(*--- functions in V33 or higher (Release 1.2) ---*)

PROCEDURE Fix*  {base,- 30}(x{0} : LONGREAL): LONGINT;
PROCEDURE Flt*  {base,- 36}(x{0} : LONGINT ): LONGREAL;
PROCEDURE Cmp*  {base,- 42}(x{0} : LONGREAL;
                            y{2} : LONGREAL): LONGINT;
PROCEDURE Tst*  {base,- 48}(x{0} : LONGREAL): LONGINT;
PROCEDURE Abs*  {base,- 54}(x{0} : LONGREAL): LONGREAL;
PROCEDURE Neg*  {base,- 60}(x{0} : LONGREAL): LONGREAL;
PROCEDURE Add*  {base,- 66}(x{0} : LONGREAL;
                            y{2} : LONGREAL): LONGREAL;
PROCEDURE Sub*  {base,- 72}(x{0} : LONGREAL;
                            y{2} : LONGREAL): LONGREAL;
PROCEDURE Mul*  {base,- 78}(x{0} : LONGREAL;
                            y{2} : LONGREAL): LONGREAL;
PROCEDURE Div*  {base,- 84}(x{0} : LONGREAL;
                            y{2} : LONGREAL): LONGREAL;
PROCEDURE Floor*{base,- 90}(x{0} : LONGREAL): LONGREAL;
PROCEDURE Ceil* {base,- 96}(x{0} : LONGREAL): LONGREAL;


(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

BEGIN
  base := Exec.OpenLibrary(mathIEEEDoubBasName,33);
  IF base=NIL THEN
    IF I.DisplayAlert(0,"\x00\x64\x14missing mathieeedoubbas.library\o\o",50) THEN END;
    HALT(20)
  END;

CLOSE
  IF base#NIL THEN Exec.CloseLibrary(base) END;

END MathIEEEDoubBas.

