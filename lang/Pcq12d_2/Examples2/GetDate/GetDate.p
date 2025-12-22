Program GetDate;

{ GetDate v1.0 1995 by Andreas Tetzl }
{ Public Domain }

{$I "Include:DOS/DOS.i"}
{$I "Include:DOS/RDArgs.i"}
{$I "Include:DOS/DateTime.i"}
{$I "Include:Utils/StringLib.i"}

const template = "Format/K,Help/S";

      version = "$VER: GetDate 1.0 (21.2.95)";

VAR DS : DateStampRec;
    DT : DateTime;
    rda : RDArgsPtr;
    WeekDay, Date, Time, hours, mins, secs, day, month, year : String;
    vec : Array[0..1] of Address;
    i : Integer;
    LFormat : String;

Procedure PrintFormat;
VAR Str : String;
Begin
 Str:=AllocString(200);
 For i:=0 to StrLen(LFormat)-1 do
  begin
   If LFormat[i]='%' then
    Begin
     Case ToUpper(LFormat[i+1]) of
      'D' : StrCat(Str,Date);
      'W' : StrCat(Str,WeekDay);
      'T' : StrCat(Str,Time);
      'H' : StrCat(Str,hours);
      'M' : StrCat(Str,Mins);
      'S' : StrCat(Str,Secs);
      'A' : StrCat(Str,Day);
      'O' : StrCat(Str,Month);
      'Y' : StrCat(Str,Year);
     end;
     i:=i+1;
    end
   else
    StrnCat(Str,adr(LFormat[i]),1);
  end;
 Writeln(Str);
 FreeString(Str);
end;

Procedure Help;
Begin
 Writeln("\nGetDate v1.0 1995 by Andreas Tetzl");
 Writeln("Public Domain\n");
 Writeln("Die Platzhalter für Format:\n");
 Writeln(" %d : Datum");
 Writeln(" %w : Wochentag");
 Writeln(" %t : Uhrzeit mit Stunden, Minuten und Sekunden");
 Writeln(" %h : Stunden");
 Writeln(" %m : Minuten");
 Writeln(" %s : Sekunden");
 Writeln(" %a : Tag");
 Writeln(" %o : Monat");
 Writeln(" %y : Jahr\n");
 Exit;
end;

begin
 For i:=0 to 1 do Vec[i]:=NIL;

 rda:=ReadArgs(Template,adr(vec),NIL);
 If rda=NIL then
  Begin
   If PrintFault(IoErr,NIL) then;
   Exit(10);
  end;

 LFormat:=AllocString(100);

 If NOT StrEq(vec[0],"") then StrCpy(LFormat,vec[0]) else LFormat:=NIL;
 If vec[1]<>NIL then Help;

 WeekDay:=AllocString(LEN_DATSTRING);
 Date:=AllocString(LEN_DATSTRING);
 Time:=AllocString(LEN_DATSTRING);
 Hours:=AllocString(10);
 Mins:=AllocString(10);
 Secs:=AllocString(10);
 Day:=AllocString(10);
 Month:=AllocString(10);
 Year:=AllocString(10);

 DateStamp(DS);
 DT.dat_Stamp:=DS;
 DT.dat_Format:=Format_DOS;
 DT.dat_StrDay:=WeekDay;
 DT.dat_StrDate:=Date;
 DT.dat_StrTime:=Time;
 If DateToStr(adr(DT)) then;

 StrnCpy(hours,Time,2);
 StrnCpy(Mins,adr(Time[3]),2);
 StrnCpy(Secs,adr(Time[6]),2);
 StrnCpy(Day,Date,2);
 StrnCpy(Month,adr(Date[3]),3);
 StrnCpy(Year,adr(Date[7]),2);

 { In den deutschen Locale-Strings von OS3.0 scheint ein Fehler zu sein. }
 { Am Datums-String ist hinten noch ein Leerzeichen, also "16-Feb-95 ".  }
 { Hier wird geprüft, ob das letzte Zeichen ein Leerzeichen ist.         }
 { Das Leerzeichen wird dann durch '\0' (Stringende) ersetzt.            }
 If Date[StrLen(Date)-1]=' ' then Date[StrLen(Date)-1]:='\0';

 If LFormat=NIL then
  Writeln(WeekDay," ",Date," ",Time)
 else 
  PrintFormat;

 FreeString(LFormat);
 FreeString(WeekDay);
 FreeString(date);
 FreeString(Time);
 FreeString(hours);
 FreeString(mins);
 FreeString(secs);
 FreeString(Day);
 FreeString(Month);
 FreeString(Year);
end.



