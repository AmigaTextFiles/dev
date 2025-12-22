IMPLEMENTATION MODULE Prof;

(* (C) Copyright 1995 Marcel Timmermans. All rights reserved. *)

FROM SYSTEM IMPORT ADR,ASSEMBLE;
IMPORT ExecL,ExecD,hw:Hardware,io:InOut,rio:RealInOut;

(*$ Align- *)

PROCEDURE StartTimer(DmaOff:BOOLEAN);
BEGIN
 ExecL.Forbid;
 ExecL.Disable;
 IF DmaOff THEN
  hw.custom.dmacon:=hw.DmaFlagSet{hw.master};
 END;
 hw.ciab.cra:=hw.CiaCraFlagSet{}; (* Timer A Stop *)
 hw.ciab.crb:=hw.CiaCrbFlagSet{}; (* Timer B Stop *)
 hw.ciab.talo:=255;
 hw.ciab.tahi:=255; (* Timer A $FFFF *)
 hw.ciab.tblo:=255;
 hw.ciab.tbhi:=255;
 hw.ciab.crb:=hw.CiaCrbFlagSet{hw.crbStart,hw.crbInmode1}; (* Timer B Start *)
 hw.ciab.cra:=hw.CiaCraFlagSet{hw.craStart};               (* Timer A Start *)
END StartTimer;

PROCEDURE StopTimer(VAR Cycles:LONGCARD);
BEGIN
 hw.ciab.cra:=hw.CiaCraFlagSet{}; (* Timer A Stoppen *)
 hw.ciab.crb:=hw.CiaCrbFlagSet{}; (* Timer B Stoppen *)
 Cycles:=0FFFFFFFFH-(hw.ciab.talo+hw.ciab.tahi*100H+hw.ciab.tblo*10000H+
  hw.ciab.tbhi*1000000H);
 (* Calculate start *)
 hw.custom.dmacon:=hw.DmaFlagSet{hw.dmaSet,hw.master};
 ExecL.Enable;
 ExecL.Permit;
END StopTimer;

PROCEDURE WriteTime(t,Korector:LONGCARD);
VAR Out : ARRAY [1..10] OF CHAR;
    Err : BOOLEAN;
    Tijd: REAL;
BEGIN
 DEC(t,Korector);
 Tijd:=REAL(t);
 Tijd:=Tijd*140056.022E-12*10.0;
 io.WriteString("Time : ");rio.WriteReal(Tijd,10,3);io.WriteString(" Sec.\n");
 io.WriteString("Time : ");rio.WriteReal((Tijd*1000.0),10,3);io.WriteString(" mSec.\n\n");
END WriteTime;


END Prof.mod
