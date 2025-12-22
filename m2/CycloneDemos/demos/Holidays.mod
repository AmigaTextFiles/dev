MODULE Holidays;

(* Simple test program, Written on a rainy sunday! 
   MT 26.05.1996
*)

FROM SYSTEM IMPORT ADR;
IMPORT io:InOut,dtcnv:DateConversions,DosL,DosD;

VAR
 dt:DosD.Date;
 text:ARRAY[0..15] OF CHAR;
 year,month,day:LONGINT;

BEGIN
 DosL.DateStamp(ADR(dt)); dtcnv.DateToStr(dt,"%d.%m.%Y",text);
 io.WriteString("Today          : "); io.WriteString(text); io.WriteLn;

 dt.days:=dtcnv.DMYToDays(1,1,1996);  dtcnv.DateToStr(dt,"%d.%m.%Y",text);
 io.WriteString("Newyears day   : "); io.WriteString(text); io.WriteLn;

 dtcnv.Easter(1996,day,month);
 dt.days:=dtcnv.DMYToDays(day,month,1996); dtcnv.DateToStr(dt,"%d.%m.%Y",text);
 io.WriteString("Easter (first) : "); io.WriteString(text); io.WriteLn;
 INC(dt.days); dtcnv.DateToStr(dt,"%d.%m.%Y",text);
 io.WriteString("Easter (sec.)  : "); io.WriteString(text); io.WriteLn;

 dtcnv.AscensionDay(1996,day,month);
 dt.days:=dtcnv.DMYToDays(day,month,1996); dtcnv.DateToStr(dt,"%d.%m.%Y",text);
 io.WriteString("AscensionDay   : "); io.WriteString(text); io.WriteLn;

 dtcnv.WhitSun(1996,day,month);
 dt.days:=dtcnv.DMYToDays(day,month,1996); dtcnv.DateToStr(dt,"%d.%m.%Y",text);
 io.WriteString("WhitSunday     : "); io.WriteString(text); io.WriteLn;

 dtcnv.WhitMon(1996,day,month);
 dt.days:=dtcnv.DMYToDays(day,month,1996); dtcnv.DateToStr(dt,"%d.%m.%Y",text);
 io.WriteString("WhitMonday     : "); io.WriteString(text); io.WriteLn;

 dtcnv.SacramentalDay(1996,day,month);
 dt.days:=dtcnv.DMYToDays(day,month,1996); dtcnv.DateToStr(dt,"%d.%m.%Y",text);
 io.WriteString("SacramentalDay : "); io.WriteString(text); io.WriteLn;

 dt.days:=dtcnv.DMYToDays(25,12,1996);  dtcnv.DateToStr(dt,"%d.%m.%Y",text);
 io.WriteString("ChristMas Day 1: "); io.WriteString(text); io.WriteLn;

 dt.days:=dtcnv.DMYToDays(26,12,1996);  dtcnv.DateToStr(dt,"%d.%m.%Y",text);
 io.WriteString("ChristMas Day 2: "); io.WriteString(text); io.WriteLn;

END Holidays.
