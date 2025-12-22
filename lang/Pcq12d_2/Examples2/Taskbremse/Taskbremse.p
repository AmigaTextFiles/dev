Program TaskBremse;

{
    Mit diesem Programm kann durch folgende Tasten der Amiga angehalten
    oder gestartet werden:
    AMIGA-LINKS  : Stop
    AMIGA-RECHTS : Weiter
    DEL          : Ende
}

{$I "Include:Libraries/DOS.i"}
{$I "Include:Exec/Tasks.i"}
{$I "Include:Exec/Libraries.i"}

VAR
        MeinTask    : TaskPtr;
        b1   : byte;
        i : integer;

{ --------------------------------------------------------------------- }

Function GetChar() : byte;
{ Liefert den RAW-Wert einer Taste zurück.
  Ein paar Tastencodes:     AMIGA-links   : $33
                            AMIGA-rechts  : $31
                            DEL           : $73
}

begin

{$A
    move.b  $bfec01,d0  ; Tastaturcode in D0
}
end; {GetChar}

{ --------------------------------------------------------------------- }
begin

{$A
        move.l  #0,d0
        move.l  d0,-(sp)
        jsr     _FindTask
        addq.w  #4,sp
        move.l  d0,_MeinTask
}
    if MeinTask = NIL then begin
        writeln("Kann mich nicht finden!");
        exit(10);
    end;

    i := SetTaskPri(MeinTask,127);
    writeln("AMIGA-LINKS  : Stop, AMIGA-RECHTS : Weiter, DEL = Ende ");

    repeat
        if GetChar() = $33 then begin  { AMIGA-links }
            repeat
            b1 := 1;    { Nur damit unser Task was zu tun bekommt }
            until (GetChar()=$31) or (GetChar()= $73);
        end;
        Delay(5); { Damit andere auch mal dran kommen }
    until GetChar() = $73; { DEL - Taste }
    i := SetTaskPri(MeinTask,0);
end.
