MODULE  FixedPoint;

(* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)

(* /// -------------------------------- "TYPE" --------------------------------- *)
TYPE    FixedPoint16 * =INTEGER;
        FixedPoint32 * =LONGINT;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE FP16toREAL()" ------------------------ *)
PROCEDURE FP16toREAL * (fp: FixedPoint16): REAL;

VAR     real: REAL;

BEGIN
  real:=fp/256;
  IF real<0 THEN real:=real+256.0; END;
  RETURN real;
END FP16toREAL;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE FP16toINT()" ------------------------ *)
PROCEDURE FP16toINT * (fp: FixedPoint16): LONGINT;

VAR     int: LONGINT;

BEGIN
  int:=ENTIER(fp/256+0.5);
  IF int<0 THEN INC(int,256); END;
  RETURN int;
END FP16toINT;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE FP32toREAL()" ------------------------ *)
PROCEDURE FP32toREAL * (fp: FixedPoint32): REAL;

VAR     real: REAL;

BEGIN
  real:=fp/65536;
  IF real<0 THEN real:=real+65536.0; END;
  RETURN real;
END FP32toREAL;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE FP32toINT()" ------------------------ *)
PROCEDURE FP32toINT * (fp: FixedPoint32): LONGINT;

VAR     int: LONGINT;

BEGIN
  int:=ENTIER(fp/65536+0.5);
  IF int<0 THEN INC(int,65536); END;
  RETURN int;
END FP32toINT;
(* \\\ ------------------------------------------------------------------------- *)

END FixedPoint.

