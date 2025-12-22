{
    $Id: msg2inc.pp,v 1.3 1998/08/11 14:00:42 peter Exp $
    This program is part of the Free Pascal run time library.
    Copyright (c) 1998 by the Free Pascal development team

    Simple touch utility

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
Program Touch;

Uses Dos;

procedure dofile (const s : string);
var
 filename: string;
 DT: DateTime;
 time: longint;
 f : file;
 Hour,Minute,Second,Sec100: word;
 Year,Month,Day,DayOfWeek: word;
begin
  filename:=s;
  assign(f,filename);
  {$i-}
   reset(f,1);
  {$i+}
  if IOResult<>0 then
    begin
      writeln ('IO-Error when opening :',filename,', Skipping.');
      exit
    end
  else
  begin
    gettime(Hour,Minute,Second,Sec100);
    getdate(Year,Month,Day,DayOfWeek);
    DT.Year:=Year;
    DT.Month:=Month;
    DT.Day:=Day;
    DT.Hour:=Hour;
    DT.Min:=Minute;
    DT.Sec:=Second;
    packtime(DT,time);
    setftime(f,time);
    close(f);
    WriteLn('...');
  end;
end;




var
 nrfile: integer;
Begin
     writeln('FPC Touch Version 1.0');
     writeln('Copyright (c) 1995-98 by the Free Pascal Development Team');
     writeln;
     filemode:=0;
     if paramcount<1 then
       begin
          writeln('touch <filename1> <filename2>...');
          halt(1);
       end;
     for nrfile :=1 to paramcount do
       dofile (paramstr(nrfile));
end.