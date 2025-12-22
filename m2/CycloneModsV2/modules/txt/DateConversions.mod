IMPLEMENTATION MODULE DateConversions;

(* (C) Copyright 1995, Marcel Timmermans. All rights reserved. *)

(*$ RangeChk- *)

FROM SYSTEM IMPORT ADR,ASSEMBLE,SETREG;

IMPORT DosD,io:InOut;

CONST
  minYear=1978;
  start=59;

TYPE
  MonthsType=POINTER TO ARRAY[1..12] OF SHORTINT;

PROCEDURE MonthConst;
(*$ EntryExitCode- *)
(* MonthTabel *)
BEGIN
 ASSEMBLE( 
  DC.B 31 
  DC.B 28
  DC.B 31
  DC.B 30
  DC.B 31
  DC.B 30
  DC.B 31
  DC.B 31
  DC.B 30
  DC.B 31
  DC.B 30
  DC.B 31
 END);
END MonthConst;


PROCEDURE DaysToDMY(Days:LONGINT; VAR d,m,y:LONGINT);
VAR 
  leap:LONGINT;
  Months:MonthsType;
  i:INTEGER;


 PROCEDURE CalcDate;
 BEGIN
  y:=minYear; m:=0; leap:=0;
  IF (Days<0) THEN 
    DEC(y);
    WHILE (Days + (365 + leap) < 0) DO
      INC(Days,(365 + leap));
      DEC(y);
      IF ((y MOD 4 ) = 0) THEN leap:=1; END;
      IF ((y MOD 4 ) = 1) THEN leap:=0; END;
    END;
  ELSE
    INC(Days);
    WHILE (Days - (365 + leap) > 0) DO
      DEC(Days,(365+leap));
      INC(y);
      IF ((y MOD 4 ) = 0) THEN leap:=1; END;
      IF ((y MOD 4 ) = 1) THEN leap:=0; END;
    END;
  END;

  INC(Months^[2],leap); (* leap year *)

  IF (Days<0) THEN
    m:=12;
    WHILE (ABS(Days)>Months^[m]) DO
     INC(Days,Months^[m]);
     DEC(m);
    END;
    INC(Days,(Months^[m]+1));
  ELSE
    m:=1;
    WHILE (Days>Months^[m]) DO
     DEC(Days,Months^[m]);
     INC(m);
    END;
  END;
  DEC(Months^[2],leap); (* leap year *)
 END CalcDate;

BEGIN
 Months:=ADR(MonthConst);
 CalcDate; 
 d:=Days;
END DaysToDMY;

PROCEDURE DMYToDays(d,m,y:LONGINT):LONGINT;
VAR 
  Months:MonthsType;
  i:LONGINT;
BEGIN
 IF (m<3) THEN DEC(d); END;
 IF (y<minYear) THEN RETURN -1; END;
 Months:=ADR(MonthConst);
 WHILE (m>1) DO 
  DEC(m);
  INC(d,Months^[m]);
 END;
 WHILE (minYear<y) DO
  DEC(y);
  FOR i:=1 TO 12 DO INC(d,Months^[i]); END;
  IF ((y MOD 4 ) = 0) THEN INC(d); END;
 END;
 RETURN d;
END DMYToDays;


PROCEDURE DateToStr(dt:DosD.Date;formatStr:ARRAY OF CHAR;VAR to:ARRAY OF CHAR);
(*$ CopyDyn- *)
TYPE
  CharPtr=POINTER TO CHAR;
VAR
  fcnt:INTEGER;
  toP:CharPtr;
  day,month,year:LONGINT;


 PROCEDURE AddVal(val{6}:LONGINT;Allign{5}:SHORTINT);
 VAR 
  i{7}:INTEGER;
  valstr:ARRAY[0..5] OF CHAR;
 BEGIN
  FOR i:=5 TO 0 BY -1 DO
   valstr[i]:=CHAR(INTEGER('0')+val MOD 10); 
   val:=val DIV 10;
  END;
  WHILE Allign>0 DO toP^:=valstr[6-Allign]; INC(toP); DEC(Allign); END;
  DEC(toP);
 END AddVal;


BEGIN
 DaysToDMY(dt.days,day,month,year);
 toP:=ADR(to);
 fcnt:=0;
 LOOP
  IF formatStr[fcnt]='%' THEN
    INC(fcnt);
    CASE formatStr[fcnt] OF
     | 'd': AddVal(day,2);
     | 'm': AddVal(month,2);
     | 'y': AddVal(year MOD 100,2);
     | 'Y': AddVal(year,4);
     | 'S': AddVal(dt.tick DIV 50,2);
     | 'M': AddVal(dt.minute MOD 60,2);
     | 'H': AddVal(dt.minute DIV 60,2);
    ELSE
     toP^:=formatStr[fcnt];
    END;
  ELSIF (formatStr[fcnt]=0C) OR (fcnt>=HIGH(formatStr)) THEN 
    toP^:=0C;
    EXIT;
  ELSE
   toP^:=formatStr[fcnt];
  END;
  INC(fcnt); INC(toP);
 END;
END DateToStr;


PROCEDURE DayOfWeek(d,m,y:INTEGER):SHORTINT;
VAR ma,jh,je,dd:LONGINT;
BEGIN
 ma:=m-2;
 jh:=y DIV 100; je:= y MOD 100;
 IF ma<=0 THEN
  INC(ma,12);
  DEC(je);
 END;
 IF je<0 THEN
  je:=99;
  DEC(jh);
 END;
 dd:=d+TRUNC(2.6*REAL(ma)-0.2)+(je / 4 + je)+(TRUNC(REAL(jh) / 4.0)-2*jh);
 WHILE dd<0 DO INC(dd,7); END;
 dd:=dd MOD 7;
 RETURN dd;
END DayOfWeek;

PROCEDURE dayOfWeek(dt:DosD.Date):SHORTINT;
BEGIN
 RETURN dt.days MOD 7;
END dayOfWeek;

PROCEDURE Easter(year:LONGINT; VAR day,month:LONGINT);
VAR a,b,c,d,e,M,N:LONGINT;
BEGIN
 IF year<100 THEN INC(year,1900); END;
 a:=year MOD 19;
 b:=year MOD 4;
 c:=year MOD 7;
 IF year<=1582 THEN 
  M:=15; N:=6;
 ELSE
  M:=((year DIV 100) - (year DIV 400) - (year DIV 300) + 15) MOD 30; 
  N:=((year DIV 100) - (year DIV 400) + 4) MOD 7;
 END;
 d:=(19*a+M) MOD 30;
 e:=(2*b+4*c+6*d+N) MOD 7;
(* io.WriteInt(a,3); io.WriteLn;
 io.WriteInt(b,3); io.WriteLn;
 io.WriteInt(c,3); io.WriteLn;
 io.WriteInt(d,3); io.WriteLn;
 io.WriteInt(e,3); io.WriteLn;
 io.WriteInt(M,3); io.WriteLn;
 io.WriteInt(N,3); io.WriteLn; *)
 IF (e=6) AND ((d=29) OR ((d=28) AND (a>10))) THEN
   day:=15+d+e;
 ELSE
   day:=22+d+e;
 END;
 IF day<32 THEN month:=3; ELSE month:=4; DEC(day,31); END;
END Easter;


PROCEDURE WhitSun(year:LONGINT; VAR day,month:LONGINT);
VAR days:LONGINT;
BEGIN
 Easter(year,day,month);
 DaysToDMY(DMYToDays(day,month,year)+49,day,month,year);
END WhitSun;

PROCEDURE WhitMon(year:LONGINT; VAR day,month:LONGINT);
VAR days:LONGINT;
BEGIN
 Easter(year,day,month);
 DaysToDMY(DMYToDays(day,month,year)+50,day,month,year);
END WhitMon;

PROCEDURE AscensionDay(year:LONGINT; VAR day,month:LONGINT);
BEGIN
 Easter(year,day,month);
 DaysToDMY(DMYToDays(day,month,year)+39,day,month,year); 
END AscensionDay;

PROCEDURE SacramentalDay(year:LONGINT; VAR day,month:LONGINT); 
BEGIN
 Easter(year,day,month);
 DaysToDMY(DMYToDays(day,month,year)+60,day,month,year);
END SacramentalDay;

PROCEDURE ChristMas1(day,month:LONGINT);
BEGIN
 day:=25;
 month:=12;
END ChristMas1;

PROCEDURE ChristMas2(day,month:LONGINT);
BEGIN
 day:=26;
 month:=12;
END ChristMas2;

END DateConversions.
