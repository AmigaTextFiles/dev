IMPLEMENTATION MODULE Random;

(* (C) Copyright 1994 Marcel Timmermans. All rights reserved. *)

FROM SYSTEM IMPORT ADR,CAST;
FROM MathIEEESingBas IMPORT Floor;

VAR seed1,seed2,seed3:LONGINT;

PROCEDURE Randomize():REAL;
VAR rt:REAL;
BEGIN
  INC(seed1);
  seed1:=(seed1 * 706) MOD 500009;
  INC(seed2);
  seed2:=(seed2 * 774) MOD 600011;
  INC(seed3);
  seed3:=(seed3 * 871) MOD 765241;
  rt:=(REAL(seed1)/500009.0+REAL(seed2)/600011.0+REAL(seed3)/765241.0);
  RETURN rt-Floor(rt);
END Randomize;

PROCEDURE RND(n:LONGINT):LONGINT;
BEGIN
 RETURN TRUNC(Randomize()*REAL(n))
END RND;

PROCEDURE SetSeed(seed:LONGINT);
BEGIN
  seed1:=seed MOD 1000003;
  seed2:=(RND(65000) * RND(65000)) MOD 600011;
  seed3:=(RND(65000) * RND(65000)) MOD 765241;
END SetSeed;

BEGIN
 SetSeed(19);
END Random.
