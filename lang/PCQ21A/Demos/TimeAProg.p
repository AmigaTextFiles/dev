Program TimeAProg;

{

    TimeAProg ProgramName

    A simple way of timimg a program
}

{$I "Include:Dos/Dos.i"}
{$I "Include:PCQUtils/Utils.i"}
{$I "Include:PCQUtils/Args.i"}

var

    start, theend : integer;
begin
    if ParamCount() <> 1 then begin
       Writeln('Usage: TimeAProg Programname');
       Exit(10);
    end;

    start := TimerTicks();
    
    if Execute(ParamStr(1),nil,nil) then begin
       theend := TimerTicks();
       writeln(theend - start);
    end else
        Writeln('Could not run the program');
end.


