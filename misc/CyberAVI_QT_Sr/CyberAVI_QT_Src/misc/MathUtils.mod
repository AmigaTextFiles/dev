MODULE  MathUtils;

(* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)

IMPORT  e:=Exec,
        mf:=MathFFP,
        mt:=MathTrans,
        sl:=StringLib,
        t:=Timer,
        y:=SYSTEM;

(* $JOIN Math64.o *)

PROCEDURE Add64 * {"_add64"} (VAR dst{8},src{9}: t.EClockVal); (* dst=dst+src *)

PROCEDURE Sub64 * {"_sub64"} (VAR dst{8},src{9}: t.EClockVal); (* dst=dst-src *)

PROCEDURE Cmp64 * {"_cmp64"} (VAR dst{8},src{9}: t.EClockVal): LONGINT; (* -1   dst>src
                                                                            0   dst=src
                                                                           +1   dst<src *)

(* /// --------------------------- "PROCEDURE max()" --------------------------- *)
PROCEDURE max * (a: LONGINT;
                 b: LONGINT): LONGINT;
BEGIN
  IF a>b THEN
    RETURN a;
  ELSE
    RETURN b;
  END;
END max;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------------- "PROCEDURE min()" --------------------------- *)
PROCEDURE min * (a: LONGINT;
                 b: LONGINT): LONGINT;
BEGIN
  IF a<b THEN
    RETURN a;
  ELSE
    RETURN b;
  END;
END min;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------- "PROCEDURE floor()" -------------------------- *)
PROCEDURE floor * (x: REAL): LONGINT;
BEGIN
  RETURN ENTIER(x+0.5);
END floor;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE real2int()" ------------------------- *)
PROCEDURE real2int * (r: REAL;
                      VAR entier: LONGINT;
                      VAR fraction: LONGINT;
                      fracLen: LONGINT);

VAR     x: LONGINT;
        factor: LONGINT;
        neg: BOOLEAN;

BEGIN
  factor:=1;
  FOR x:=1 TO fracLen DO factor:=factor*10; END;
  neg:=(r<0);
  r:=mf.Abs(r);
  entier:=floor(r*factor) DIV factor;
  fraction:=floor((r-entier)*factor);
  IF neg THEN entier:=-entier; END;
END real2int;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE real2str()" ------------------------- *)
PROCEDURE real2str * (f: REAL;
                      VAR str: e.STRING;
                      fracLen: LONGINT);

VAR     entier: LONGINT;
        fraction: LONGINT;
        c: LONGINT;
        fmt: e.STRING;

BEGIN
  IF f<0 THEN
    c:=1;
    str[0]:="-";
    f:=mf.Abs(f);
  ELSE
    c:=0;
  END;
  f:=f+mt.Pow(fracLen,0.1)/2;
  entier:=ENTIER(f);
  fraction:=ENTIER(mt.Pow(fracLen,10)*(f-mf.Floor(f)));
  sl.sprintf(fmt,"%%ld.%%0%ldld",fracLen);
  sl.sprintfP(y.ADR(str[c]),fmt,entier,fraction);
END real2str;
(* \\\ ------------------------------------------------------------------------- *)

END MathUtils.

