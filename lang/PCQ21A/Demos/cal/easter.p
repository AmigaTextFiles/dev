Program easter;

{
    easter v1.0
    © 1995 by Andreas Tetzl
    FREEWARE
}

{$I "Include:Utils/Parameters.i"}
{$I "Include:Utils/StringLib.i"}
{$I "Include:DOS/DOS.i"}

const version = "$VER: easter v1.0 (3-Nov-95) by Andreas Tetzl";

VAR i,a,b,c,d,e,m,n : Integer;
    param : String;
    year, month, day : Integer;


BEGIN
  param:=AllocString(50);
  GetParam(1,param);
  if (StrEq(param,"?")) or (StrEq(param,"")) then
   BEGIN
    Writeln("YEAR/N");
    Exit(20);
   END;

  i:=StrToLong(param,adr(year));
  if (year<1583) or (year>2299) then
   BEGIN
    Writeln("only years between 1583 and 2299 allowed");
    Exit(20);
   END;

  Case year of
    1583..1699 : BEGIN m:=22; n:=2; END;
    1700..1799 : BEGIN m:=23; n:=3; END;
    1800..1899 : BEGIN m:=23; n:=4; END;
    1900..2099 : BEGIN m:=24; n:=5; END;
    2100..2199 : BEGIN m:=24; n:=6; END;
    2200..2299 : BEGIN m:=25; n:=0; END;
  end;

  a:=year mod 19;
  b:=year mod 4;
  c:=year mod 7;
  d:=(19*a+m) mod 30;
  e:=(2*b+4*c+6*d+n) mod 7;

  day:=22+d+e;
  if day<=31 then
   month:=3
  else
   BEGIN
    month:=4;
    day:=d+e-9;
   END;

  if (month=4) and (day=26) then day:=19;
  if (month=4) and (day=25) and (d=28) and (e=6) and (a>10) then day:=18;

  Write(year,"-");
  if month=3 then Write("Mar") else Write("Apr");
  Writeln("-",day);
END.


