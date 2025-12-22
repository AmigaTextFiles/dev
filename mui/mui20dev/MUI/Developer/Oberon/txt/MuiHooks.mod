MODULE MuiHooks;

(* $StackChk- *)
IMPORT
  m  := Mui,
  e  := Exec,
  y  := SYSTEM,
  fr := MuiFileRequester,
  mb := MuiBasics;


  VAR  getFileHook *: mb.Hook;



(****** MuiHooks/GetFile ****************************************************
*
*   NAME
*       GetFile -- Holt Dateinamen über das Dateiauswahlfenster
*
*   SYNOPSIS
*       GetFile*( hook   : mb.Hook;
*                 string : m.Object;
*                 args   : mb.Args ):LONGINT;
*
*   FUNCTION
*       Läßt den Benutzer sich einen Dateinamen inkl. Pfad auswählen und
*       schreibt diesen in ein StringObjekt. Aus diesem String Objekt
*       wird vorher noch ein evtl. vorhandener Dateiname (inkl. Pfad)
*       als Vorgabe für das Dateiauswahlfenster genommen.
*
*   INPUTS
*       hook   = Zeiger auf den eigenen Hook
*       string = StringObjekt von-/indem der Dateiname geholt bzw.
*                geschrieben werden soll.
*       args   = Zeiger auf die Parameterstruktur, die Struktur sie so aus:
*
*                   TYPE a = STRUCT( dummy : mb.ArgsDesc );
*                              hail   : e.STRPTR;
*                            END;
*
*                hail = Zeiger auf den Titeltext im Dateiwauswahlfenster
*
*   RESULTS
*       Der Dateinname (inkl. Pfad) wird in das String Objekt geschrieben
*       (falls nicht in dem Dateiauswahlfenster der Abbruch Knopf gedrückt
*        wurde).
*
*   EXAMPLE
*       Mui.DoMethod( string, Mui.mCallHook, hook,
*                             SYSTEM.ADR( "Datei laden ..." ) );
*
*   NOTES
*       Diesen Hook kann man vorzugsweise an einen Popup Button Objekt,
*       der neben einem String Objekt plaziert ist, anhängen so das
*       eine Dateiauswahl erleichert wird.
*
*       Nachdem der Dateinamen an das String Objekt übergeben worden ist
*       wird noch ein "Mui.aStringAcknowledge" an das String Objekt
*       gesandt, so daß das Programm darauf reagieren kann.
*
*
*   SEE ALSO
*       String.mui/MUIA_String_Acknowledge
*
*****************************************************************************
*
*)
  PROCEDURE GetFile*( hook   : mb.Hook;
                      string : m.Object;
                      args   : mb.Args ):LONGINT;

    TYPE a = STRUCT( dummy : mb.ArgsDesc );
               hail   : e.STRPTR;
             END;
    VAR name : ARRAY 256 OF CHAR;
        str  : e.STRPTR;
        window : m.Object;

    BEGIN
      mb.Get( string, m.aStringContents, str );
      COPY( str^, name );
      mb.Get( string, m.aWindowObject, window );
      IF fr.OpenForLoad( args(a).hail^, name, window ) THEN
        mb.Set( string, m.aStringContents, y.ADR( name ) );
        mb.Set( string, m.aStringAcknowledge, e.true );
      END;
      RETURN 0;
    END GetFile;

BEGIN
  getFileHook := mb.MakeHook( GetFile );
END MuiHooks.

