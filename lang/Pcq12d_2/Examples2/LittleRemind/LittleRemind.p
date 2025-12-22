  

Program LittleRemind;

{ * benötigt KickStart 2.0 oder höher ! * }

{ * Auf dem Rüthener Treffen kurz zusammengehackt, für den ebenso * }
{ * gestreßten wie auch verschnupften Andreas Mauß ...  :)        * }
{ * Zusammengehackt von "Diesel" Bernd Künnen. Sourcecode und     * }
{ * Programm sind Public Domain.		17.09.1994	  * }


{ * Zweck des Programmes ist es, innerhalb eines bestimmten Zeit- * }
{ * abstandes ein Kommando auszuführen. Grundlage dafür war Andis * }
{ * bedürfnis, alle paar Wochen automatisch 'ABackup' gestartet   * }
{ * zu bekommen ...  =;-)					  * }


{$I "Include:dos/dos.i"          }
{$I "Include:exec/libraries.i"   }
{$I "Include:utils/stringlib.i"  }
{$I "Include:utils/parameters.i" }
{$I "Include:utility/Date.i"     }


Const
	cd_size = SizeOf( ClockData );    { Größe des verw, Records }

					  { Datei mit Zeit-Daten }
	s_file  : String = "S:LittleRemind_lasttime";

	Monat   : Array[1..12] of Short =  { Anzahl Tage Jan. bis Dez. }
		  ( 31,59,90,120,151,181,212,243,273,304,334,365 );

var
	dst		: DateStampRec;
	hora_old,
	hora_new	: ClockDataPtr;
	
	sys_seconds,
	differz,
	old_day,
	new_day		: Integer;

	hdl		: FileHandle;
	UtilityBase	: Address;

	time_out	: Array[1..10] of Char;
	time_int	: Integer;
	x_command	: String;


{ ---------------------------------------------------------------- }

{ Zum sauberen Verlassen des Programms, egal wo ... }

Procedure CleanExit( why: String; rt : Integer);
Begin
	{ Bibliothek schließen }
	If UtilityBase <> NIL then CloseLibrary( UtilityBase );

	{ Datei schließen }
	If hdl <> nil then  DosClose(hdl);

	{ Ggf. Fehlermeldung }
	If why <> nil then  writeln(why);
	Exit(rt);

end;

{ ---------------------------------------------------------------- }

Procedure Init;
Var
	z, zahl, multi : Integer;

Begin
	{ Kleine Begrüßung }
	Writeln(" LittleRemind V1.0, (P)1994 by Diesel - Public Domain");

	{ Bibliothek öffnen, für Amiga2Date() }
	UtilityBase := OpenLibrary( "utility.library", 37);
	If UtilityBase = NIL then CleanExit("Benötige Kickstart >= 2.0 !", 20);

	{ Zu verwendende Datenbereiche initialisieren }
	New( hora_old );
	New( hora_new );
	x_command := AllocString(80);

	{ Parameter holen }
	GetParam( 1, Adr(time_out) );
	GetParam( 2, x_command );

	{ Keine Parameter ? }
	If strlen( x_command ) = 0
	then
	  CleanExit("Aufruf: LittleRemind Auszeit(in Tagen) Kommando\n   Z.B. LittleRemind 14 \"type s:EsIstZeit.txt\" ", 10);

	multi := 1;

	{ Parameter-Tageszahl nach Integer konvertieren } 
	for z := strlen( Adr(time_out) ) downto 1 do begin	{ Rückwärts }
	
	  zahl := Byte( time_out[z] ) - Byte('0');	{ '1'/Char -> 1/int }
	  If (zahl > -1) AND (zahl < 10)  Then		{ Nur 0-9 zulassen  }
	  begin
	    Inc( time_int, (zahl * multi) );
	    multi := 10 * multi;
	  end;
	end;

End;

{ ---------------------------------------------------------------- }

{ Aktuelles Datum in Datei schreiben } 

Procedure Schreibe_NeueZeit( newtime: ClockDataPtr );;
Begin
	{ Datei öffnen } 
	hdl := DosOpen( s_file, mode_newfile );
	If hdl = NIL then
	  CleanExit(" FEHLER: Kann Datei S:LittleRemind_lasttime nicht erzeugen !",10);

	{ Schreiben ... }
	If (DosWrite( hdl, newtime, CD_Size ) <> CD_Size )
	Then CleanExit("FEHLER beim Schreiben in Datei !", 10);

	{ Datei schließen }
	DosClose( hdl );
	hdl := NIL;

End;

{ ---------------------------------------------------------------- }

{ Beim Erst-Start erstmal eine Datei anlegen ... }

Procedure Erzeuge_Datei;
Begin
	Write("Datei ", s_file, " nicht vorhanden.\nErzeuge...");
	DosClose(hdl);

	{ Datei anlegen, mit aktiellem Datum }
	Schreibe_NeueZeit( hora_new );

	{ Uuuund Tschüßßß ! }
	CleanExit("fertig.",0);

End;

{ ---------------------------------------------------------------- }

{ Hier wird das gewünschte Kommando ausgeführt. Läßt sich nach  }
{ eigenen Anspüchen ausbauen. 					}

Procedure Do_Action;
Begin
	If Execute( x_command, nil, nil)<> True Then;
end;

{ ---------------------------------------------------------------- }

begin
	{ Alles initialisieren }
	Init;

	{ Systemzeit holen }
	DateStamp( dst );

	{ Sekunden seit 01.01.1978, 0:00 Uhr }
	sys_seconds :=    (dst.ds_days * 24 * 60 * 60)
			+ (dst.ds_minute * 60);

	{ Umwandeln in 'lesbaren' Record }
	Amiga2Date( sys_seconds, hora_new );

	{ Schon Datei da ? }
	hdl := DosOpen( s_file, mode_oldfile );
	if hdl = NIL then
	  Erzeuge_Datei;	{ Nicht ? Dann erzeuge ... }

	{ Alte Daten laden ... }
	If DosRead( hdl, hora_old, CD_Size) <> CD_Size
	Then CleanExit("FEHLER beim Lesen von S:LittleRemind_lasttime\nBitte löschen Sie die Datei und starten sie LittleRemind neu.", 10);
	DosClose(hdl);
	hdl := NIL;

	{ Erstmal Systemzeit ausgeben }
	With hora_new^ do begin
	  WriteLn( " Sternzeit ", mday, ".", month, ".", year,
		            "  ", hour, ":", min );
	end;

	{ Differenz seit letztem Aufruf MIT Action berechnen }
	old_day := Monat[hora_old^.month] + hora_old^.mday;
	new_day := Monat[hora_new^.month] + hora_new^.mday;
	differz := new_day - old_day;

	{ Seit letztem Aufruf MIT Action Jahreswechsel ?? }
	If   differz < 0
	then differz := ( 365 - old_day ) + new_day;

	{ Wenn Zeitspanne überschritten, ACTION !!! }
	If differz >= time_int
	then begin

	  { Aktuelles Datum (=Datum der letzen Action) in Datei speichern }
	  Write(" Erneuere ", s_file, " ... ");
	  Schreibe_NeueZeit( hora_new );
	  Writeln("fertig");

	  { GO for it ! }
	  Do_Action;

	end;

	{ Das wars .... }
 	Cleanexit(NIL,0);

end.
