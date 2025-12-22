Program KillDM;

{ ***************************************************************************
  *                                                                         *
  *                         KillDM Version 1.1                              *
  *                                                                         *
  * Löscht Disaster-MasterV2-Virus von der Disk und aus dem Speicher.       *
  * Geschrieben am 6.12.1992. Compiliert mit PCQ-Pascal 1.2b.               *
  * Dieses Programm ist Freeware. Wenn teile des sourcecodes in eigenen     *
  * Programmen benutzt werden sollte angegeben werden das sie von mir sind. *
  *                                                                         *
  * Meine Adresse:                                                          *
  *                                                                         *
  *  Andreas Tetzl                                                          *
  *  Liebethaler Str.18                                                     *
  *  O-8300, Pirna-Copitz                                                   *
  *                                                                         *
  ***************************************************************************
}

{$I "Include:Utils/Stringlib.i" }
{$I "Include:Libraries/Dos.i"   }
{$I "Include:Exec/Execbase.i"   }
{$I "Include:Utils/Parameters.i"}

VAR 	F,F2				:	Text;
	Zeile,Antwort,
	Device,
	Datei,clsPfad,
     startupPfad		:	String;
	DM,Startup,OK		:	Boolean;
	Fib				: 	FileInfoBlockPtr;
	F_Lock			: 	Filelock;
	Size				: 	Integer;
	ExecPtr			: 	Execbaseptr;


Procedure FileLoeschen;
Begin
  If DeleteFile(clsPfad)=TRUE then Begin
    Write("VirusFile gelöscht\n");
  End Else Begin
    Write("Kann Virus nicht löschen\n");
  End;
End;

Procedure StartupLoeschen;   { Erste Zeile der Startup-Sequence löschen }
Begin
  If Reopen(StartupPfad,F) then Begin
    Readln(F,Zeile);				{ Zeile mit Virusaufruf überlesen }
    If Open("ram:Startup-Sequence.copy",F2) then Begin	   { Neue Startup- }
      While Not EOF(F) do Begin					   { Sequence in   }
        Readln(F,Zeile);							   { RAM-DISK      }
        Writeln(F2,zeile);
      End;
      Close(F2);
    End Else Begin
      Exit(20);
    End;
    Close(F);
  End Else Begin
    Write("Kann Startup-Sequence nich öffnen\n");
    Exit(20);
  End;

  If Reopen ("ram:startup-sequence.copy",F) then Begin	 { Neue Startup- }
    If Open(StartupPfad,F2) then Begin				 { Sequence auf  }
      While not EOF(F) do Begin					 { Disk          }
        Readln(F,Zeile);
        Writeln(F2,Zeile);
      End;
      Close(F2);
    End;
    Close(F);
  End;

  If DeleteFile("ram:startup-sequence.copy") then;
  Write("Virusaufruf aus Startup-Sequence entfernt.\n");
End;

Function Checklen : Integer;		{ Filelänge überprüfen }
Begin
   F_Lock:=Lock(clsPfad,shared_lock);
   New(Fib);
   OK:=Examine(F_Lock,Fib);
   Unlock(F_Lock);
   Size := Fib^.Fib_Size;
   Dispose(Fib);
   Checklen:=Size;
end;


Procedure Check;
Begin
  If Reopen(clsPfad,F)=TRUE then Begin		{ existiert eine cls-Datei? }
    If Checklen=1740 then DM:=TRUE;
    Close(F);
  End;

  If Reopen(StartupPfad,F) then Begin			{ Startup-Sequence }
    Read(F,Zeile);							{ überprüfen       }
    If Streq(Zeile,"cls *")=TRUE then Startup:=TRUE;
    Close(F);
  End;

  If (DM=TRUE) and (Startup=FALSE) then Begin
    If Checklen=1740 then Begin
      Write("Achtung ! Im Verzeichnis c: ist ein verdächtiges File,\n");
      Write("der Virus wird aber nicht in der Startup-Sequence aufgerufen.\n");
      Write("Soll ich das File löschen ? (j/n) ");
      Readln(Antwort);
      If Antwort[0]=Chr(106) then FileLoeschen;
    End;
    Return;
  End;


  If (DM=TRUE) and (Startup=TRUE) then Begin
    Write("DisasterMasterV2-Virus gefunden. Löschen ? (j/n) ");
    Readln(Antwort);
    If Antwort[0]=Chr(106) then Begin
      FileLoeschen;
      StartupLoeschen;
    End;
    Return;
  End;
End;

Procedure ClearVector(v : ^Address);
Begin
  v^:=NIL;		{ Vektor löschen }
End;


Begin
  {$A
	move.l  $4,_ExecPtr
  }

  Write("\e[33m\e[1mKillDM\e[0m V1.1 © 1992 by Andreas Tetzl\n\n");
 
  Zeile:=AllocString(80);
  Device:=AllocString(31);
  Datei:=AllocString(100);
  StartupPfad:=AllocString(49);
  clsPfad:=AllocString(36);
  
  GetParam(1, Device);
  strcpy(StartupPfad,Device);
  strcat(StartupPfad,"c/cls");
  strcpy(clsPfad,StartupPfad);
  strcat(Device,"s/Startup-Sequence");
  strcpy(StartupPfad,Device);
  Check;
  
  FreeString(Zeile);
  FreeString(Device);
  FreeString(Datei);
  FreeString(StartupPfad);
  FreeString(clsPfad);
  
  Clearvector(Adr(ExecPtr^.KickTagPtr));
  Clearvector(Adr(ExecPtr^.KickCheckSum));
End.



