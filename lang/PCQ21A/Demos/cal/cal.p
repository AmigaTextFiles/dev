Program Cal_v20;

{
    cal v2.0
    © 1995 by Andreas Tetzl
    FREEWARE
}

{
    Removed the stub functions for NameFromFH and GetVar.
    They work ok in pcq.lib. Also removed the opening
    and closeing of utility.library, it's done by pcq.
}


{ /// ------------------------------ "Includes" ------------------------------ }

{$I "Include:Utility/Utility.i"}
{$I "Include:Utility/Date.i"}
{$I "Include:Exec/Libraries.i"}
{$I "Include:Exec/Memory.i"}
{$I "Include:Exec/Lists.i"}
{$I "Include:Exec/Nodes.i"}
{$I "Include:Exec/Tasks.i"}
{$I "Include:Libraries/Locale.i"}
{$I "Include:Utils/TimerUtils.i"}
{$I "Include:Utils/StringLib.i"}
{$I "Include:Utils/Parameters.i"}
{$I "Include:Utils/Break.i"}
{$I "Include:DOS/DOSExtens.i"}
{$I "Include:DOS/RDArgs.i"}
{$I "Include:DOS/Var.i"}

{ /// ------------------------------------------------------------------------ }

{ /// -------------------------------- "VAR" --------------------------------- }

Type  DateStruct = Record
        succ, pred : ^DateStruct;
        day, month, year, color, bcolor : Integer;
        bold, italics, underlined : Boolean;
      end;
      DateStructPtr = ^DateStruct;

const   spaces = "                    ";

    version = "$VER: cal v2.0 (05-Nov-95) by Andreas Tetzl";

    configfilename : Array[0..2] of String = (NIL,"cal.dates","s:cal.dates");

VAR Timer : TimeRequestPtr;
    TV : TimeVal;
    CD : ClockData;
    amigadate, i, j : Integer;
    mday : String;
    Str : Array[1..9] of String;
    posadd : Array[1..9] of Integer;
    month, year : Integer;
    SUNDAY_LAST, WHOLE_YEAR : Boolean;

    Dates : ListPtr;

    { Strings }
    wdays_sunday_first,
    wdays_sunday_last : String;
    mon : Array[1..12] of String;
    badnumber : String;

{ /// ------------------------------------------------------------------------ }

{ /// ------------------------- "PROCEDURE FreeList" ------------------------- }

PROCEDURE FreeList(L : ListPtr);
{ free the list }
VAR MyNode, ThisNode : DateStructPtr;
BEGIN
  MyNode:=DateStructPtr(L^.lh_head);
  While MyNode^.succ<>NIL do
   BEGIN
    ThisNode:=MyNode;
    MyNode:=MyNode^.succ;
    Dispose(ThisNode);
   END;
  Dispose(L);
END;

{ /// ------------------------------------------------------------------------ }

{ /// ------------------------ "PROCEDURE CleanExit" ------------------------- }

PROCEDURE CleanExit(Why : String; RC : Integer);
BEGIN
  FreeList(Dates);
  If Timer<>NIL then DeleteTimer(Timer);
  If Why<>NIL then Writeln(Why);
  Exit(RC);
END;

{ /// ------------------------------------------------------------------------ }

{ /// --------------------------- "FUNCTION leap" ---------------------------- }

FUNCTION leap(year : Integer) : Boolean;
{ TRUE for leap year, FALSE otherwise }
BEGIN
 if (year mod 4=0) and NOT((year>1582) and (year mod 100=0) and (year mod 400<>0)) then
  leap:=TRUE
 else
  leap:=FALSE;
END;

{ /// ------------------------------------------------------------------------ }

{ /// --------------------------- "FUNCTION days" ---------------------------- }

FUNCTION days(year, month : Integer) : Integer;
{ return number of days in the given month }
const day  : Array[1..12] of Integer = (
                    31,28,31,30,31,30,
                    31,31,30,31,30,31);
BEGIN
  if (month=2) and (leap(year)) then days:=day[month]+1
                                else days:=day[month];

END;

{ /// ------------------------------------------------------------------------ }

{ /// ------------------------- "FUNCTION AddNode" -------------------------- }

FUNCTION AddNode(day, month, year, color, bcolor : Integer; bold, italics, underl : Boolean) : Boolean;
{ add an element to the list of dates to be highlighted }
VAR MyNode : DateStructPtr;
BEGIN
{
  Writeln(year,"-",month,"-",day);
  Writeln(color," ",Integer(bold)," ",Integer(italics)," ",Integer(underl));
  Writeln;
}
  if (year>3000) or (month>12) or (day>days(year,month)) or (day<1) then AddNode:=FALSE;
  if (year=1582) and (month=10) and (day>4) and (day<15) then AddNode:=FALSE;

  New(MyNode);
  MyNode^.day:=day;
  MyNode^.month:=month;
  MyNode^.year:=year;
  MyNode^.color:=color;
  MyNode^.bcolor:=bcolor;
  MyNode^.bold:=bold;
  MyNode^.italics:=italics;
  MyNode^.underlined:=underl;
  AddTail(Dates,NodePtr(MyNode));
  AddNode:=TRUE;
END;

{ /// ------------------------------------------------------------------------ }

{ /// ------------------------ "PROCEDURE ReadConfig" ------------------------ }

PROCEDURE ReadConfig;
{ parse s:cal.dates
  call AddNode for each entry }

VAR FH : FileHandle;
    line, Str : String;
    c, c2 : Char;
    i, j, l : Integer;
    year, month, day, color, bcolor : Integer;
    bold, italics, underl : Boolean;
BEGIN
  l:=0;
  line:=AllocString(100);
  Str:=AllocString(100);

  FH:=NIL;
  if NOT StrEq(configfilename[0],"") then FH:=DOSOpen(configfilename[0],MODE_OLDFILE);
  if FH=NIL then FH:=DOSOpen(configfilename[1],MODE_OLDFILE);
  if FH=NIL then FH:=DOSOpen(configfilename[2],MODE_OLDFILE);
  if FH=NIL then Return;

  While FGets(FH,line,100)<>NIL do
   BEGIN
    Inc(l);
    i:=0;
    While isspace(line[i]) do Inc(i);

    if (line[0]<>'\0') and (line[0]<>'\n') and (line[0]<>';') and (line[i]<>';') then
     BEGIN
      bold:=FALSE; italics:=FALSE; underl:=FALSE; color:=-1; bcolor:=-1;
      year:=0; month:=0; day:=0;

      i:=0;
      While isspace(line[i]) do Inc(i);
      if (isdigit(line[i])) or (line[i]='?') then    { detected a date }
       BEGIN
        StrCpy(Str,"");
        While (isdigit(line[i])) or (line[i]='?') do
         BEGIN
          StrnCat(Str,adr(line[i]),1); { copy year }
          Inc(i);
         END;
        j:=StrToLong(Str,adr(year));
        Inc(i);  { - or / }

        StrCpy(Str,"");
        While (isdigit(line[i])) or (line[i]='?') do
         BEGIN
          StrnCat(Str,adr(line[i]),1); { copy month }
          Inc(i);
         END;
        j:=StrToLong(Str,adr(month));
        Inc(i);  { - or / }

        StrCpy(Str,"");
        While isdigit(line[i]) do   { don't allow '?' for day }
         BEGIN
          StrnCat(Str,adr(line[i]),1); { copy day }
          Inc(i);
         END;
        j:=StrToLong(Str,adr(day));
       END;

      Dec(i);
      Repeat
       Inc(i);
       While isspace(line[i]) do Inc(i);
       c:=line[i]; c2:=line[i+1];
       While isalnum(line[i]) do Inc(i);
       Case toupper(c) of
        'B' : bold:=TRUE;
        'I' : italics:=TRUE;
        'U' : underl:=TRUE;
        'C' : color:=ord(c2)-48;
        'R' : bcolor:=ord(c2)-48;
       END;
      Until (line[i]='\n') or (line[i]='\0') or (line[i]=';');
      if ((day=0) and (month=0) and (year=0)) or
         ((color=-1) and (bcolor=-1) and (bold=FALSE) and (italics=FALSE) and (underl=FALSE)) then
       BEGIN
        If NameFromFH(FH,Str,100) then;
        DOSClose(FH);
        Writeln("syntax error in line ",l," of ",Str);
        FreeList(Dates);
        New(Dates);
        NewList(Dates); { create empty list }
        Return;
       END
       ELSE
        if NOT AddNode(day,month,year,color,bcolor,bold,italics,underl) then
         BEGIN
          If NameFromFH(FH,Str,100) then;
          DOSClose(FH);
          Writeln("invalid date in line ",l," of ",Str);
          FreeList(Dates);
          New(Dates);
          NewList(Dates); { create empty list }
          Return;
         END;
     END;
   END;

  DOSClose(FH);
END;

{ /// ------------------------------------------------------------------------ }

{ /// -------------------------- "PROCEDURE ReadENV" -------------------------- }

PROCEDURE ReadENV;
{ read ENV:SUNDAY_LAST
  if it does'nt exists, don't change the boolean var
}
VAR Str : String;
    Mypr : ProcessPtr;
    OldWin : Address;
BEGIN
  Str:=AllocString(10);

  MyPr:=ProcessPtr(FindTask(NIL));
  OldWin:=MyPr^.pr_WindowPtr;
  MyPr^.pr_WindowPtr:=address(-1);  { disable "please insert" requesters }

  if GetVar("SUNDAY_LAST",Str,2,0)<>-1 then
   if Str[0]='1' then SUNDAY_LAST:=TRUE
                 else SUNDAY_LAST:=FALSE;

  MyPr^.pr_WindowPtr:=OldWin;   { allow error requesters }
end;

{ /// ------------------------------------------------------------------------ }

{ /// ----------------------- "PROCEDURE Init" ------------------------ }

PROCEDURE Init;
{ initialize all strings, use locale.library if possible }
VAR i : Integer;
    loc : LocalePtr;
    cat : CatalogPtr;
    Str : String;
BEGIN
  Str:=AllocString(30);
  wdays_sunday_first:=AllocString(20);
  wdays_sunday_last:=AllocString(20);
  badnumber:=AllocString(30);
  configfilename[0]:=AllocString(200);
  For i:=1 to 12 do
   mon[i]:=AllocString(20);

  StrCpy(wdays_sunday_first,"Su Mo Tu We Th Fr Sa");
  StrCpy(wdays_sunday_last,"Mo Tu We Th Fr Sa Su");
  StrCpy(mon[1],"January");
  StrCpy(mon[2],"February");
  StrCpy(mon[3],"March");
  StrCpy(mon[4],"April");
  StrCpy(mon[5],"May");
  StrCpy(mon[6],"June");
  StrCpy(mon[7],"July");
  StrCpy(mon[8],"August");
  StrCpy(mon[9],"September");
  StrCpy(mon[10],"October");
  StrCpy(mon[11],"November");
  StrCpy(mon[12],"December");
  StrCpy(badnumber,"bad number");

  LocaleBase:=OpenLibrary("locale.library",38);
  if LocaleBase=NIL then Return;

  loc:=OpenLocale(NIL);
  if loc=NIL then
   BEGIN
    CloseLibrary(localebase);
    Return;
   END;

  If loc^.loc_CalendarType=CT_7MON then SUNDAY_LAST:=TRUE else SUNDAY_LAST:=FALSE;

  StrnCpy(wdays_sunday_first,GetLocaleStr(loc,ABDAY_1),2);
  StrCat(wdays_sunday_first," ");
  StrnCat(wdays_sunday_first,GetLocaleStr(loc,ABDAY_2),2);
  StrCat(wdays_sunday_first," ");
  StrnCat(wdays_sunday_first,GetLocaleStr(loc,ABDAY_3),2);
  StrCat(wdays_sunday_first," ");
  StrnCat(wdays_sunday_first,GetLocaleStr(loc,ABDAY_4),2);
  StrCat(wdays_sunday_first," ");
  StrnCat(wdays_sunday_first,GetLocaleStr(loc,ABDAY_5),2);
  StrCat(wdays_sunday_first," ");
  StrnCat(wdays_sunday_first,GetLocaleStr(loc,ABDAY_6),2);
  StrCat(wdays_sunday_first," ");
  StrnCat(wdays_sunday_first,GetLocaleStr(loc,ABDAY_7),2);
  StrCat(wdays_sunday_first," ");

  StrnCpy(wdays_sunday_last,GetLocaleStr(loc,ABDAY_2),2);
  StrCat(wdays_sunday_last," ");
  StrnCat(wdays_sunday_last,GetLocaleStr(loc,ABDAY_3),2);
  StrCat(wdays_sunday_last," ");
  StrnCat(wdays_sunday_last,GetLocaleStr(loc,ABDAY_4),2);
  StrCat(wdays_sunday_last," ");
  StrnCat(wdays_sunday_last,GetLocaleStr(loc,ABDAY_5),2);
  StrCat(wdays_sunday_last," ");
  StrnCat(wdays_sunday_last,GetLocaleStr(loc,ABDAY_6),2);
  StrCat(wdays_sunday_last," ");
  StrnCat(wdays_sunday_last,GetLocaleStr(loc,ABDAY_7),2);
  StrCat(wdays_sunday_last," ");
  StrnCat(wdays_sunday_last,GetLocaleStr(loc,ABDAY_1),2);
  StrCat(wdays_sunday_last," ");

  StrCpy(mon[1],GetLocaleStr(loc,MON_1));
  StrCpy(mon[2],GetLocaleStr(loc,MON_2));
  StrCpy(mon[3],GetLocaleStr(loc,MON_3));
  StrCpy(mon[4],GetLocaleStr(loc,MON_4));
  StrCpy(mon[5],GetLocaleStr(loc,MON_5));
  StrCpy(mon[6],GetLocaleStr(loc,MON_6));
  StrCpy(mon[7],GetLocaleStr(loc,MON_7));
  StrCpy(mon[8],GetLocaleStr(loc,MON_8));
  StrCpy(mon[9],GetLocaleStr(loc,MON_9));
  StrCpy(mon[10],GetLocaleStr(loc,MON_10));
  StrCpy(mon[11],GetLocaleStr(loc,MON_11));
  StrCpy(mon[12],GetLocaleStr(loc,MON_12));


  cat:=OpenCatalogA(loc,"sys/dos.catalog",NIL);
  if cat<>NIL then
   BEGIN
    badnumber:=GetCatalogStr(cat,115,"bad number"); { get localized "bad number" from dos.catalog }
    CloseCatalog(cat);
   END;

  CloseLocale(loc);
  CloseLibrary(LocaleBase);
END;

{ /// ------------------------------------------------------------------------ }

{ /// ----------------------- "PROCEDURE InsertString" ----------------------- }

PROCEDURE InsertString(s, ins : String; pos, l : Integer);
{ insert a string into another one at the given position
}

VAR Str : String;
    i, j : Integer;
BEGIN
  j:=0;
  For i:=0 to Strlen(s) do
   BEGIN
    if s[i]='\e' then
     BEGIN
      if (s[i+2]='0') and (s[i+3]='m') then Inc(pos,4)
      else
      if (s[i+2]='1') and (s[i+3]='m') then Inc(pos,4)
      else
      if (s[i+2]='3') and (s[i+3]='m') then Inc(pos,4)
      else
      if (s[i+2]='4') and (s[i+3]='m') then Inc(pos,4)
      else
      if (s[i+2]='3') and (isdigit(s[i+3])) and (s[i+4]='m') then Inc(pos,5)
      else
      if (s[i+2]='4') and (isdigit(s[i+3])) and (s[i+4]='m') then Inc(pos,5);
     END;
   END;

  Str:=AllocString(255);
  if pos>0 then StrnCpy(Str,s,pos);
  StrCat(Str,ins);
  StrCat(Str,adr(s[pos]));
  StrCpy(s,spaces);
  StrCpy(s,Str);
  FreeString(Str);

  posadd[l]:=0;
  For i:=0 to Strlen(s) do
   BEGIN
    if s[i]='\e' then
     BEGIN
      if (s[i+2]='0') and (s[i+3]='m') then Inc(posadd[l],4)
      else
      if (s[i+2]='1') and (s[i+3]='m') then Inc(posadd[l],4)
      else
      if (s[i+2]='3') and (s[i+3]='m') then Inc(posadd[l],4)
      else
      if (s[i+2]='4') and (s[i+3]='m') then Inc(posadd[l],4)
      else
      if (s[i+2]='3') and (isdigit(s[i+3])) and (s[i+4]='m') then Inc(posadd[l],5)
      else
      if (s[i+2]='4') and (isdigit(s[i+3])) and (s[i+4]='m') then Inc(posadd[l],5);
     END;
   END;
END;

{ /// ------------------------------------------------------------------------ }

{ /// ------------------------ "PROCEDURE Highlight" ------------------------- }

PROCEDURE Highlight(s : String; d : DateStructPtr; l : Integer);
{ interprete highlighting-list-entry and insert ansi-sequence }
const
  Bold    = "\e[1m";
  Italics = "\e[3m";
  Underl  = "\e[4m";

VAR ESC, Str : String;
BEGIN
  ESC:=AllocString(255);
  Str:=AllocString(10);
  StrCpy(ESC,"");

  if d^.bold then StrCat(ESC,Bold);
  if d^.italics then StrCat(ESC,Italics);
  if d^.underlined then StrCat(ESC,Underl);
  if d^.color<>-1 then
   BEGIN
    StrCat(ESC,"\e[3");
    i:=IntToStr(Str,d^.color);
    StrCat(ESC,Str);
    StrCat(ESC,"m");
   END;
  if d^.bcolor<>-1 then
   BEGIN
    StrCat(ESC,"\e[4");
    i:=IntToStr(Str,d^.bcolor);
    StrCat(ESC,Str);
    StrCat(ESC,"m");
   END;

  StrCpy(s,ESC);
END;

{ /// ------------------------------------------------------------------------ }

{ /// ----------------------- "FUNCTION My_Date2Amiga" ------------------------ }

FUNCTION My_Date2Amiga(date : ClockDataPtr) : Integer;

{ calculate days (!) from 1-Jan-1 to the given date }

const days : Array[1..12] of Integer = (
                    31,28,31,30,31,30,
                    31,31,30,31,30,31);

years : Array[0..59] of Integer =
 (0, 18262, 36525, 54787, 73050, 91312, 109575, 127837, 146100,
 164362, 182625, 200887, 219150, 237412, 255675, 273937, 292200,
 310462, 328725, 346987, 365250, 383512, 401775, 420037, 438300,
 456562, 474825, 493087, 511350, 529612, 547875, 566137, 584389,
 602651, 620913, 639175, 657437, 675699, 693961, 712223, 730486,
 748748, 767010, 785272, 803534, 821796, 840058, 858320, 876583,
 894845, 913107, 931369, 949631, 967893, 986155, 1004417, 1022680,
 1040942, 1059204, 1077466);


VAR amigatime, i, j, l, y : Integer;
BEGIN
  y:=(date^.year div 50)*50;
  if date^.year div 50=date^.year/50 then Dec(y,50);
  amigatime:=years[y div 50];

  For i:=y+1 to date^.year-1 do
   BEGIN
    if (i=1582) then Dec(amigatime,11);  { julian -> gregorian calendar }

    if leap(i) then Inc(amigatime,366)
               else Inc(amigatime,365);
   END;

  For i:=1 to date^.month-1 do
   BEGIN
    l:=days[i];
    if (i=2) and (leap(date^.year)) then Inc(l,1);
    For j:=1 to l do
     Inc(amigatime,1);
   END;

  For i:=1 to date^.mday-1 do Inc(amigatime,1);

  My_Date2Amiga:=amigatime;
END;

{ /// ------------------------------------------------------------------------ }

{ /// ------------------------- "FUNCTION Shiftwday" ------------------------- }

FUNCTION Shiftwday(wday, pos : Integer) : Integer;
{ rotate weekday
  Saturday->Sunday
  Sunday->Monday
  ...
}
VAR i : Integer;
BEGIN
  if pos=0 then Shiftwday:=wday;
  If pos>0 then
   For i:=1 to pos do
    BEGIN
     Inc(wday);
     if wday=7 then wday:=0;
    END
  else
   For i:=-1 downto pos do
    BEGIN
     Dec(wday);
     if wday=-1 then wday:=6;
    END;

  Shiftwday:=wday;
END;

{ /// ------------------------------------------------------------------------ }

{ /// -------------------------- "FUNCTION weekday" -------------------------- }

FUNCTION weekday(year, month, day : Integer) : Integer;
{ return the weekday of the given date }
VAR CD : ClockData;
    wday : Integer;
BEGIN
  if amigadate=0 then
   BEGIN
    CD.year:=year;
    CD.month:=month;
    CD.mday:=day;
    amigadate:=My_Date2Amiga(adr(CD));
   END
  ELSE Inc(amigadate);

  if (year<1582) or ((year=1582) and (month<10)) or ((year=1582) and (month=10) and (day<=4)) then
   wday:=((amigadate+6) mod 7)
  else
   wday:=((amigadate-7) mod 7);

  { julian -> gregorian }

  if (year=1582) and (month=10) and (day>=5) and (day<15) then
   wday:=5;

  if (year=1582) and (((month=10) and (day>14)) or (month>10)) then wday:=Shiftwday(wday,3);

  weekday:=wday;
END;

{ /// ------------------------------------------------------------------------ }

{ /// ------------------------- "FUNCTION DateMatch" ------------------------- }

FUNCTION DateMatch(year, month, day : Integer) : DateStructPtr;
{ parse hightlighting-list and return entry-ptr if match }
VAR d : DateStructPtr;
BEGIN
  d:=DateStructPtr(dates^.lh_head);
  While d^.succ<>NIL do
   BEGIN
    if ((d^.year=0) or (year=d^.year)) and
       ((d^.month=0) or (month=d^.month)) and
       (day=d^.day) then DateMatch:=d;
    d:=d^.succ;
   END;

  DateMatch:=NIL;
END;

{ /// ------------------------------------------------------------------------ }

{ /// --------------------- "PROCEDURE Cal" ------------------------------- }

PROCEDURE Cal(x : WORD);
{ create calendar with sunday last }
VAR l, j, i, k, n, wday : Integer;
    y, s, s2 : String;

    MyDS : DateStructPtr;

BEGIN
  amigadate:=0;
  y:=AllocString(40);
  s:=AllocString(40);
  s2:=AllocString(40);

  For i:=1 to 9 do
   For j:=0 to x+19 do
    if Str[i][j]='\0' then Str[i][j]:=' ';

  StrCpy(y,"");
  For i:=1 to 7-(StrLen(mon[CD.month]) div 2) do StrCat(y," ");
  If WHOLE_YEAR=TRUE then StrCat(y,"  ");
  StrCpy(adr(Str[1][x]),y);
  StrCat(Str[1],mon[CD.month]);
  StrCat(Str[1]," ");
  i:=IntToStr(y,CD.year);
  if WHOLE_YEAR=FALSE then StrCat(Str[1],y);

  If SUNDAY_LAST then
   StrCpy(adr(Str[2][x]),wdays_sunday_last)
  else
   StrCpy(adr(Str[2][x]),wdays_sunday_first);

  l:=3;

  CD.mday:=1;
  For k:=1 to days(CD.year,CD.month) do
   BEGIN
    i:=IntToStr(mday,CD.mday);
    if Strlen(mday)=1 then
     BEGIN
      mday[1]:=mday[0];
      mday[0]:='0';
      mday[2]:='\0';
     END;

    wday:=weekday(CD.year,CD.month,CD.mday);
    MyDS:=DateMatch(CD.year,CD.month,CD.mday);

    If SUNDAY_LAST=TRUE then
     Case wday of
      1 : n:=0;
      2 : n:=3;
      3 : n:=6;
      4 : n:=9;
      5 : n:=12;
      6 : n:=15;
      0 : n:=18;
     end
    else
     Case wday of
      0 : n:=0;
      1 : n:=3;
      2 : n:=6;
      3 : n:=9;
      4 : n:=12;
      5 : n:=15;
      6 : n:=18;
     end;

    If MyDS<>NIL then
     BEGIN
      StrCpy(s,"  \0");
      StrCpy(s2,"");
      s[1]:=mday[1];
      if mday[0]<>'0' then s[0]:=mday[0];
      Highlight(s2,MyDS,l);
      StrCat(s2,s);
      StrCat(s2,"\e[0m");
      InsertString(Str[l],s2,x+n,l);
     END
    ELSE
     BEGIN
      Str[l][x+posadd[l]+n+1]:=mday[1];
      if mday[0]<>'0' then Str[l][x+posadd[l]+n]:=mday[0];
     END;

    if ((SUNDAY_LAST=TRUE) and (wday=0)) or
       ((SUNDAY_LAST=FALSE) and (wday=6)) then Inc(l);
    Inc(CD.mday);
  end;

  Inc(CD.month);
END;           

{ /// ------------------------------------------------------------------------ }

{ /// ------------------------- "PROCEDURE Cal_YEAR" ------------------------- }

PROCEDURE Cal_YEAR;
{ create a calendar for a whole year }
VAR j, i : Integer;
BEGIN
  CD.month:=1;

  For j:=1 to 4 do
   BEGIN
    For i:=1 to 9 do
     BEGIN
      StrCpy(Str[i],"                                                                                                                                 ");
      posadd[i]:=0;
     END;

    Cal(0); Cal(23); Cal(46);

    For i:=1 to 9 do
     BEGIN
      j:=Strlen(Str[i])-1;
      While isspace(Str[i][j]) do
       BEGIN                         { cut spaces }
        Str[i][j]:='\0';
        Dec(j);
       END;
      if StrLen(Str[i])>0 then Writeln(Str[i]);
      If CheckBreak then CleanExit("*** break",0);
     END;
    Writeln;
   END;
END;

{ /// ------------------------------------------------------------------------ }

{ /// ------------------------- "PROCEDURE GetArgs" -------------------------- }

PROCEDURE GetArgs;
{ read arguments from command line }

const template = "MONTH/N,YEAR/N,Y/S,DATES/K";
      ExtHelp = "\ncal v2.0 © 1995 by Andreas Tetzl\n\nMONTH  : specify month of year (1..12, default: current month)\nYEAR   : specify year (1..3000, default: current year)\nY      : show calendar of a whole year (default: off)\nDATES  : specify config-filename (default: s:cal.dates)\n\n";

VAR rda : RDArgsPtr;
    vec : Array[0..3] of Address;

BEGIN
  vec[0]:=NIL;
  vec[1]:=NIL;
  vec[2]:=NIL;
  vec[3]:=NIL;

  rda:=AllocDosObject(DOS_RDARGS,NIL);
  if rda=NIL then CleanExit(NIL,20);

  rda^.RDA_ExtHelp:=ExtHelp;

  if ReadArgs(template,adr(vec),rda)=NIL then
   BEGIN
    If Printfault(IoErr,NIL) then;
    FreeDosObject(DOS_RDARGS,rda);
    CleanExit(NIL,0);
   END;

  year:=0;
  month:=0;

  if vec[0]<>NIL then CopyMem(vec[0],adr(month),4);
  if vec[1]<>NIL then CopyMem(vec[1],adr(year),4);
  WHOLE_YEAR:=Boolean(vec[2]);
  if vec[3]<>NIL then StrCpy(configfilename[0],vec[3]);

  FreeArgs(rda);
  FreeDosObject(DOS_RDARGS,rda);

  if year=-1 then year:=-2;
  if month=-1 then month:=-2;

  if (WHOLE_YEAR) and (year=0) then
   BEGIN
    year:=month;
    month:=-1;
   END;

  if (year=0) and (month>13) then
   BEGIN
    year:=month;
    month:=-1;
    WHOLE_YEAR:=TRUE;
   END;

  if year=0 then year:=-1;
  if month=0 then month:=-1;
END;

{ /// ------------------------------------------------------------------------ }

{ /// -------------------------------- "Main" -------------------------------- }

BEGIN
  For i:=1 to 9 do Str[i]:=AllocString(1000);
  mday:=AllocString(10);

  New(Dates);
  NewList(Dates);

  Timer:=CreateTimer(UNIT_VBLANK);
  If Timer=NIL then CleanExit("could not open timer.device",10);

  Init;
  GetArgs;
  ReadENV;  { if env-variable exists, overwrite locale settings }

  GetSysTime(Timer,TV);
  Amiga2Date(TV.tv_Secs,adr(CD));

  if ((month<>-1) and (month<1)) or (month>12) or ((year<1) and (year<>-1)) or (year>3000) then
   CleanExit(badnumber,10);

  ReadConfig;

  if year<>-1 then CD.year:=year;
  if month<>-1 then CD.month:=month;

  if WHOLE_YEAR then
   BEGIN
    Writeln("                              ",CD.year,"\n");
    Cal_YEAR;
   END
  else
   BEGIN
    Cal(0);
    For i:=1 to 9 do
     BEGIN
      j:=Strlen(Str[i])-1;
      While isspace(Str[i][j]) do
       BEGIN                         { cut spaces }
        Str[i][j]:='\0';
        Dec(j);
       END;
      if Strlen(Str[i])>0 then Writeln(Str[i]);
      If CheckBreak then CleanExit("*** break",0);
     END;
    Writeln;
   END;

  CleanExit(NIL,0);
END.

{ /// ------------------------------------------------------------------------ }

