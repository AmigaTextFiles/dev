MODULE RexxM2Error;

   (** RexxM2Error.mod - Stellt einen AREXX-Port zur Verfügung und
    *                    liefert dann die Fehlermeldungen von M2Amiga.
    * Version     : $VER RexxM2Error.mod 0.97 (© 1994 Fin Schuppenhauer)
    * Autor       : Fin Schuppenhauer
    *               Braußpark 10
    *               20537 Hamburg
    *               (Germany)
    * E-Mail      : schuppen@rzdspc2.informatik.uni-hamburg.de
    * Copyright   : © 1994 Fin Schuppenhauer
    *               "Freely distributable copyrighted software"
    * Erstellt am : 18.03.1994
    * Letzte Änd. : 19.03.1994
    * Geschichte  :
    **)

IMPORT   ed:ExecD,      el:ExecL,      es:ExecSupport,
         rxd:RexxD,     rxl:RexxL,
         dd:DosD,       dl:DosL,
         wd:WorkbenchD,
         icl:IconL,
         str:String,
         Arts,
         con:Conversions;

FROM Heap      IMPORT Allocate, Deallocate;
FROM UtilityD  IMPORT tagEnd;
FROM SYSTEM    IMPORT ADDRESS, ADR, LONGSET, CAST, TAG;


CONST VersionStr = "$VER RexxM2Error 0.97 (© 1994 Fin Schuppenhauer)";

CONST REXXCOMMPROCS  = 6;
      TEXTLIMIT      = 40000;


TYPE  Commands = (ERROR, ERRORS, RESET, LOAD, QUIT, QUERY, UNKNOWN);

TYPE  String      = ARRAY [0..79] OF CHAR;
      StringPtr   = POINTER TO String;
      TextPtr     = POINTER TO ARRAY [0..TEXTLIMIT] OF CHAR;
      INTEGERPtr = POINTER TO INTEGER;
      LONGINTPtr  = POINTER TO LONGINT;

      RexxCommProc = PROCEDURE(VAR LONGINT, VAR LONGINT, BOOLEAN, dd.RDArgsPtr);

(* ---------------------------------------------------------------------- *)
(** Debug-Stuff *)
VAR   DEBUG    := BOOLEAN{TRUE};
      dbghdl   : dd.FileHandlePtr;

PROCEDURE DbgWrite (msg : ARRAY OF CHAR);
VAR   li : LONGINT;
BEGIN
   (*$ StackParms:=TRUE *)
   li := dl.Write(dbghdl, ADR(msg), str.Length(msg));
   (*$ POP StackParms *)
END DbgWrite;

PROCEDURE DbgWriteLn;
VAR   li : LONGINT;
BEGIN
   li := dl.Write(dbghdl, ADR("\n"), 1);
END DbgWriteLn;
(* **)
(* ---------------------------------------------------------------------- *)

PROCEDURE TemplateError;
(**   Funktion : Wird aufgerufen, falls es bei der Auswertung eines
  *              Templates zu einem Fehler gekommen ist.
  *              Diese Funktion ermittelt den Fehler und öffnet einen
  *              Requester mit der Fehlermeldung.
  *)
VAR   IoErrMsg   : String;
      b        : BOOLEAN;
BEGIN
   IF dl.Fault(dl.IoErr(), NIL, ADR(IoErrMsg), 75) THEN
      b := Arts.Requester (ADR("REXXM2ERROR detected an IoErr:"),
                           ADR(IoErrMsg), NIL, ADR("Damned!"));
   END;
END TemplateError;
(* **)

(* ---------------------------------------------------------------------- *)

PROCEDURE CheckToolTypes (VAR name : ARRAY OF CHAR);
(**   Funktion : Liest die Tooltypes ein.
  *)
VAR   info  : wd.DiskObjectPtr;
      type  : ADDRESS;
BEGIN
   (* .info-Datei einlesen: *)
   info := icl.GetDiskObject(ADR("RexxM2Error"));

   IF info # NIL THEN
      type := icl.FindToolType(info^.toolTypes, ADR("ERRORMSGFILE"));
      IF type # NIL THEN
         str.Copy (name, StringPtr(type)^);
      ELSE
         str.Copy (name, "M2:Fehler-Meldungen");
      END;
      icl.FreeDiskObject (info);
   END;
END CheckToolTypes;
(* **)

(* ---------------------------------------------------------------------- *)
VAR   ErrorMsgBase   := TextPtr{NIL};
      ERRORMSGFILE   : String;

PROCEDURE LoadErrorMsgFile (filename : ARRAY OF CHAR) : LONGINT;
(**   Funktion : Lädt die Datei mit den Texten zu den Fehlermeldungen.
 *               Wurde sie nicht gefunden, wird 10, gab es einen
 *               Lesefehler 20, zurückgegeben, bei Erfolg 0.
 *)
VAR   hdl      : dd.FileHandlePtr;
      fib      : dd.FileInfoBlockPtr;
      li       : LONGINT;
      taglist  : ARRAY [0..10] OF LONGINT;
BEGIN
   IF DEBUG THEN
      DbgWrite ("Loading ErrorMsgFile ...\n");
   END;
   (* Für den Fall, daß schon mal die Datei mit den Fehlertexten geladen
    * wurde, werden wir hier mal schnell den belegten Speicher freigeben:
    *)
   IF ErrorMsgBase # NIL THEN
      Deallocate (ErrorMsgBase);
   END;
   ERRORMSGFILE := "";

   hdl := dl.Open(ADR(filename), dd.readOnly);
   IF hdl = NIL THEN
      RETURN dd.error;
   END;

   fib := dl.AllocDosObject(dd.dosFib, TAG(taglist, tagEnd));
   IF fib = NIL THEN
      dl.Close (hdl);
      RETURN dd.fail;
   END;

   IF dl.ExamineFH(hdl, fib) THEN
      Allocate (ErrorMsgBase, fib^.size);
      IF ErrorMsgBase = NIL THEN
         IF DEBUG THEN
            DbgWrite ("   not enough memory\n");
         END;
         dl.Close (hdl);
         dl.FreeDosObject (dd.dosFib, fib);
         RETURN dd.fail;
      END;
      IF DEBUG THEN
         DbgWrite ("   Memory for ErrorMsgBase allocated.\n");
      END;
      li := dl.Read(hdl, ErrorMsgBase, fib^.size);
      dl.Close (hdl);
      IF li < fib^.size THEN
         IF DEBUG THEN
            DbgWrite ("   read error\n");
         END;
         (* Lesefehler *)
         dl.FreeDosObject (dd.dosFib, fib);
         Deallocate (ErrorMsgBase);
         RETURN dd.fail;
      END;
      dl.FreeDosObject (dd.dosFib, fib);
      str.Copy (ERRORMSGFILE, filename);
      IF DEBUG THEN
         DbgWrite ("   ready.\n");
      END;
      RETURN dd.ok;
   ELSE
      dl.FreeDosObject (dd.dosFib, fib);
      RETURN dd.fail;
   END;
END LoadErrorMsgFile;
(* **)

(* ---------------------------------------------------------------------- *)

TYPE  ErrorDescriptionPtr = POINTER TO ErrorDescription;
      ErrorDescription = RECORD
         offset   : LONGINT;
         ErrNum   : INTEGER;
         ErrMsg   : StringPtr;
         next     : ErrorDescriptionPtr;
      END;

VAR   MAXERRORS   := LONGINT{0};
      ErrorArray  : POINTER TO ARRAY [0..150] OF ErrorDescription;
      ERRORFILE   : String;

PROCEDURE LoadErrorFile (filename : ARRAY OF CHAR) : LONGINT;
(**   Funktion: Lädt die zu filename zugehöroge Fehlerdatei.
                Wenn sie nicht gefunden wird, wird 5, bei Lese-
                fehler o.ä 20 zurückgegeben.
*)
VAR   ErrorBase   : TextPtr;

   PROCEDURE ParseErrorPart (ed : ErrorDescriptionPtr; VAR pos : CARDINAL);
(** Funktion: Anlysiert ErrorPart *)
   VAR   i        : CARDINAL;
         errstr   : String;
   VAR   zahlstr  : ARRAY [0..10] OF CHAR;
         err      : BOOLEAN;
   BEGIN
      IF DEBUG THEN
         DbgWrite ("         ParseErrorPart\n");
      END;
      WITH ed^ DO
         IF ErrorBase^[pos] = CHAR(0C2H) THEN
            IF DEBUG THEN
               DbgWrite ("            String = ");
            END;
            ErrNum := 0;
            INC (pos);
            i := 0;
            WHILE ErrorBase^[pos] # 0C DO
               errstr[i] := ErrorBase^[pos];
               INC (i); INC (pos);
            END;
            errstr[i] := 0C;
            INC (pos);
            IF DEBUG THEN
               DbgWrite (errstr);
               DbgWriteLn;
            END;
            IF pos MOD 2 = 1 THEN INC (pos); END;
            Allocate (ErrMsg, str.Length(errstr));
            IF ErrMsg # NIL THEN
               str.Copy (ErrMsg^, errstr);
            END;
         ELSE
            IF DEBUG THEN
               DbgWrite ("            ErrNum = ");
            END;
            ErrNum := CAST(INTEGERPtr, ADDRESS(ErrorBase)+ADDRESS(pos))^;
            IF DEBUG THEN
               con.ValToStr (ErrNum, FALSE, zahlstr, 16, 4, "0", err);
               DbgWrite (zahlstr);
               DbgWriteLn;
            END;
            INC (pos, 2);
            ErrMsg := NIL;
         END;
         IF (CAST(LONGINTPtr, ADDRESS(ErrorBase)+ADDRESS(pos))^ # CAST(LONGINT,"ÁERR")) &
            (CAST(INTEGERPtr, ADDRESS(ErrorBase)+ADDRESS(pos))^ # -1) THEN
            Allocate (next, SIZE(ErrorDescription));
            ParseErrorPart (next, pos);
         END;
      END;
   END ParseErrorPart;
(* **)

   PROCEDURE ParseError (nr : CARDINAL; VAR pos : CARDINAL);
(** Funktion: Analysiert die Fehlercodierung *)
   VAR   zahlstr  : ARRAY [0..10] OF CHAR;
         err      : BOOLEAN;
   BEGIN
      IF DEBUG THEN
         DbgWrite ("      ParseError\n");
      END;

      IF CAST(LONGINTPtr, ADDRESS(ErrorBase)+ADDRESS(pos))^ # CAST(LONGINT, "ÁERR") THEN
         (* Ugly Incredible Unexpected Catastrophalicy Error:
          * Confused With ErrorFile.
          *)
         WITH ErrorArray^[nr] DO
            offset := -1;
            ErrNum := -1;
            ErrMsg := NIL;
            next   := NIL;
         END;
         RETURN;
      ELSE
         INC (pos, 4);
      END;

      WITH ErrorArray^[nr] DO
         offset   := CAST(LONGINTPtr, ADDRESS(ErrorBase)+ADDRESS(pos))^;
         IF DEBUG THEN
            DbgWrite ("         Offset = ");
            zahlstr := "";
            con.ValToStr (offset, FALSE, zahlstr, 16, 4, "0", err);
            DbgWrite (zahlstr);
            DbgWriteLn;
         END;
         INC (pos, 4);
         ParseErrorPart (ADR(ErrorArray^[nr]), pos);
      END;
   END ParseError;
(* **)

VAR   hdl         : dd.FileHandlePtr;
      fib         : dd.FileInfoBlockPtr;
      li          : LONGINT;
      pos, i      : CARDINAL;
      taglist     : ARRAY [0..10] OF LONGINT;
VAR   zahlstr  : ARRAY [0..10] OF CHAR;
      err      : BOOLEAN;
BEGIN
   IF DEBUG THEN
      DbgWrite ("Loading ErrorFile ... Filename = ");
      DbgWrite (filename);
      DbgWriteLn;
   END;
   IF ErrorArray # NIL THEN
      Deallocate (ErrorArray);
   END;
   MAXERRORS := 0;
   ERRORFILE := "";

   hdl := dl.Open(ADR(filename), dd.readOnly);
   IF hdl = NIL THEN
      RETURN dd.warn;
   END;

   fib := dl.AllocDosObject(dd.dosFib, TAG(taglist, tagEnd));
   IF fib = NIL THEN
      dl.Close (hdl);
      RETURN dd.fail;
   END;

   IF dl.ExamineFH(hdl, fib) THEN
      Allocate (ErrorBase, fib^.size);
      IF ErrorBase = NIL THEN
         dl.Close (hdl);
         dl.FreeDosObject (dd.dosFib, fib);
         RETURN dd.fail;
      END;
      IF DEBUG THEN
         DbgWrite ("   Memory allocated.\n");
      END;
      li := dl.Read(hdl, ErrorBase, fib^.size);
      dl.Close (hdl);
      IF li < fib^.size THEN
         IF DEBUG THEN
            DbgWrite ("   read error\n");
         END;
         Deallocate (ErrorBase);
         dl.FreeDosObject (dd.dosFib, fib);
         RETURN dd.fail;
      END;

      pos := 0;
      WHILE (LONGINT(pos) < fib^.size) DO
         IF ErrorBase^[pos] = "Á" THEN
            IF (ErrorBase^[pos+1] = "E") &
               (ErrorBase^[pos+2] = "R") &
               (ErrorBase^[pos+3] = "R") THEN
               INC (MAXERRORS);
               INC (pos,3);
            END;
         END;
         INC (pos);
      END;

      Allocate (ErrorArray, SIZE(ErrorDescription) * MAXERRORS);
      IF DEBUG THEN
         DbgWrite ("   Memory for ErrorArray allocated.\n");
      END;
      IF ErrorArray = NIL THEN
         Deallocate (ErrorBase);
         dl.FreeDosObject (dd.dosFib, fib);
         RETURN dd.fail;
      END;
      IF DEBUG THEN
         DbgWrite ("   converting into ErrorArray ...\n");
      END;
      pos := 4;
      FOR i := 0 TO MAXERRORS-1 DO
         ParseError (i, pos);
         IF ErrorArray^[i].offset = -1 THEN
            (* Verdammt schwerer Fehler beim Parsing aufgetreten! *)
            IF DEBUG THEN
               DbgWrite ("HARD CATASTROPHIE PARSINGERROR !!!!\n");
            END;
            MAXERRORS := -1;
            i := 6000;
         END;
      END;
      dl.FreeDosObject (dd.dosFib, fib);
      str.Copy (ERRORFILE, filename);
      RETURN dd.ok;
   END;
END LoadErrorFile;
(* **)

(* ---------------------------------------------------------------------- *)

PROCEDURE GetErrorMessage (nr : INTEGER;
                           VAR msg : ARRAY OF CHAR);
(**   Funktion : Ermittelt den zur Fehlernummer <nr> zugehörigen
  *              Fehlertext.
  *)
VAR   i     : CARDINAL;
      pos   : CARDINAL;
      next  : LONGINT;
      currNr: INTEGER;
BEGIN
   IF DEBUG THEN
      DbgWrite ("   GetErrorMessage called ...\n");
   END;
   pos := 0;
   LOOP
      next := CAST(LONGINTPtr, ADDRESS(ErrorMsgBase)+ADDRESS(pos))^;
      INC (pos, 4);
      currNr := CAST(INTEGERPtr, ADDRESS(ErrorMsgBase)+ADDRESS(pos))^;
      INC (pos, 2);
      IF (currNr = nr) OR (currNr = -1) THEN EXIT; END;
      pos := next;
   END;
   i := 0;
   WHILE ErrorMsgBase^[pos-1] # 0C DO
      msg[i] := ErrorMsgBase^[pos];
      INC (i);
      INC (pos);
   END;
END GetErrorMessage;
(* **)

(* ---------------------------------------------------------------------- *)

PROCEDURE GetM2Error (nr : CARDINAL;
                      VAR off : LONGINT;
                      VAR errnum : INTEGER;
                      VAR errstr : ARRAY OF CHAR);
(**   Funktion : Ermittelt den Byteoffset, die Fehlernummer und
  *              den Fehlertext zum nr-sten Fehler.
  *)
VAR   helpstr     : String;
      helperrnum  : INTEGER;
      ed          : ErrorDescriptionPtr;
BEGIN
   WITH ErrorArray^[nr] DO
      off         := offset;
      errnum      := ErrNum;
      errstr[0]   := 0C;
      helperrnum  := ErrNum;
   END;
   ed := ADR(ErrorArray^[nr]);
   LOOP
      IF helperrnum = 0 THEN
         str.Concat (errstr, ed^.ErrMsg^);
      ELSE
         GetErrorMessage (helperrnum, helpstr);
         str.Concat (errstr, helpstr);
      END;
      IF ed^.next = NIL THEN EXIT; END;
      str.ConcatChar(errstr, " ");
      ed := ed^.next;
      helperrnum := ed^.ErrNum;
   END;
END GetM2Error;
(* **)

(* ---------------------------------------------------------------------- *)

PROCEDURE GetM2ErrorByte (offset : LONGINT;
                          VAR off      : LONGINT;
                          VAR errnum   : INTEGER;
                          VAR errstr   : ARRAY OF CHAR);
(**   Funktion: Wie GetM2Error, jedoch anhand eines vorgegebenen
  *             Byte-Offsets.
  *)
VAR   i, helperrnum  : INTEGER;
      helpstr        : String;
      ed             : ErrorDescriptionPtr;
BEGIN
   IF DEBUG THEN
      DbgWrite ("GetM2ErrorByte called.\n");
   END;
   i := 0;
   WHILE (offset > ErrorArray^[i].offset) & (i < MAXERRORS) DO
      INC (i);
   END;
   IF i = MAXERRORS THEN
      off := -1;
   ELSE
      WITH ErrorArray^[i] DO
         off      := offset;
         errnum   := ErrNum;

         errstr[0]   := 0C;
         helperrnum  := ErrNum;
      END;
      ed := ADR(ErrorArray^[i]);
      LOOP
         IF helperrnum = 0 THEN
            str.Concat (errstr, ed^.ErrMsg^);
         ELSE
            GetErrorMessage (helperrnum, helpstr);
            str.Concat (errstr, helpstr);
         END;
         IF ed^.next = NIL THEN EXIT; END;
         str.ConcatChar(errstr, " ");
         ed := ed^.next;
         helperrnum := ed^.ErrNum;
      END;
   END;
END GetM2ErrorByte;
(* **)

(* ---------------------------------------------------------------------- *)

PROCEDURE GetRexxCommand (string : ARRAY OF CHAR; VAR cl : INTEGER) : Commands;
(**   Funktion : Extrahiert das Kommando aus der eingegangenen
  *              Rexx-Nachricht. Ist es "RexxM2Error" nicht bekannt,
  *              wird eine Fehlermeldung ausgegeben.
  *)
VAR   i        : INTEGER;
      commstr  : String;
      b        : BOOLEAN;
BEGIN
   i := 0;
   WHILE (string[i] # " ") & (string[i] # 0C) DO
      commstr[i] := string[i];
      INC (i);
   END;
   commstr[i] := 0C;
   cl := str.Length(commstr) + 1;   (* wird für rdargs benötigt *)

   IF str.Compare(commstr, "ERROR") = 0 THEN RETURN ERROR;
   ELSIF str.Compare(commstr, "ERRORS") = 0 THEN RETURN ERRORS;
   ELSIF str.Compare(commstr, "RESET") = 0 THEN RETURN RESET;
   ELSIF str.Compare(commstr, "LOAD") = 0 THEN RETURN LOAD;
   ELSIF str.Compare(commstr, "QUIT") = 0 THEN RETURN QUIT;
   ELSIF str.Compare(commstr, "QUERY") = 0 THEN RETURN QUERY;
   ELSE
      b := Arts.Requester (ADR("REXXM2ERROR detected an unknown command:"),
                           ADR(string), NIL, ADR("Huch!"));
      RETURN UNKNOWN;
   END;
END GetRexxCommand;
(* **)

(* ---------------------------------------------------------------------- *)
(* ----- AREXX-Kommandos ------------------------------------------------ *)
(* ---------------------------------------------------------------------- *)


PROCEDURE Quit (VAR rs1, rs2 : LONGINT; result : BOOLEAN; rdargs : dd.RDArgsPtr);
(**   Format      : QUIT
      Schablone   : -
      Funktion    : RexxM2Error beenden
      Beschreibung: Beendet dieses Programm.
*)
BEGIN
   rs1 := dd.ok;
END Quit;
(* **)

(* ---------------------------------------------------------------------- *)

VAR   CURRERR  := LONGINT{0};

PROCEDURE Error (VAR rs1, rs2 : LONGINT; result : BOOLEAN; rdargs : dd.RDArgsPtr);
(**   Format      : ERROR [ NEXT | PREV | FIRST | BYTE=<Byte-Offset> | NUMBER=<Nummer> ]
      Schablone   : NEXT/S,PREV/S,FIRST/S,BYTE/K/N,NUMBER/K/N
      Funktion    : Liefert eine Fehlermeldung
      Beschreibung: Je nach verwendeter Option liefert ERROR den nächsten
                    (NEXT), vorhergehenden (PREV) oder ersten (FIRST)
                    Fehler.
                    Mit der Option BYTE kann ein Offset angegeben werden.
                    Es wird dann der im Quelltext hierauf folgende Fehler
                    zurückgegeben.
                    Mit NUMBER kann ein bestimmter Fehler angesprungen
                    werden: Der <Nummer>. Fehler.

                    Wurde noch ein Fehler gefunden, so liefert ERROR das
                    Ergebnis in einem String folgender Form:

                        OFFSET/A,ERRNUM/A,ERRMSG/A

                    wobei OFFSET den Byteoffset im Quelltext enthält,
                    ERRNUM die Fehlernummer und ERRMSG den Fehlertext.

                    Wenn es keinen weiteren Fehler mehr gibt, ist rc = 5.
*)
CONST MAXOPTIONS  = 5;
      next        = 0;
      prev        = 1;
      first       = 2;
      byte        = 3;
      number      = 4;
VAR   template    : String;
      options     : ARRAY [0..MAXOPTIONS-1] OF LONGINT;
      rs2str      : ARRAY [0..255] OF CHAR;
      errnum      : INTEGER;
      errstr      : ARRAY [0..127] OF CHAR;
      zahlstr     : ARRAY [0..10] OF CHAR;
      err         : BOOLEAN;
      i           : INTEGER;
      offset      : LONGINT;
      success     : dd.RDArgsPtr;
BEGIN
   IF DEBUG THEN
      DbgWrite ("REXX: ERROR\n");
   END;
   IF MAXERRORS = 0 THEN
      (* Es gibt überhaupt keine Fehler! *)
      rs1 := dd.warn;
      RETURN;
   ELSE

      rs1 := dd.ok;
      template := "NEXT/S,PREV/S,FIRST/S,BYTE/K/N,NUMBER/K/N";
      FOR i := 0 TO MAXOPTIONS-1 DO
         options[i] := 0;
      END;
      success := dl.ReadArgs(ADR(template), ADR(options), rdargs);
      IF success = NIL THEN
         TemplateError;
         rs1 := dd.error;
         RETURN;
      END;

      IF options[prev] # 0 THEN
         DEC (CURRERR);
         IF CURRERR < 0 THEN
            rs1 := dd.warn;
            CURRERR := 0;
         ELSE
            GetM2Error (CURRERR, offset, errnum, errstr);
         END;

      ELSIF options[first] # 0 THEN
         CURRERR := 0;
         GetM2Error (CURRERR, offset, errnum, errstr);
         INC (CURRERR);

      ELSIF options[byte] # 0 THEN
         IF DEBUG THEN
            DbgWrite ("BYTE\n");
         END;
         GetM2ErrorByte (CAST(LONGINTPtr, options[byte])^, offset, errnum, errstr);

      ELSIF options[number] # 0 THEN
         IF DEBUG THEN
            DbgWrite ("NUMBER\n");
         END;
         IF (CAST(LONGINTPtr,options[number])^ >= MAXERRORS) OR
            (CAST(LONGINTPtr,options[number])^ < 0) THEN
            rs1 := dd.warn;
         ELSE
            CURRERR := CAST(LONGINTPtr, options[number])^;
            GetM2Error (CURRERR, offset, errnum, errstr);
            INC (CURRERR);
         END;

      ELSE
         IF CURRERR >= MAXERRORS THEN
            rs1 := dd.warn;
         ELSE
            GetM2Error (CURRERR, offset, errnum, errstr);
            INC (CURRERR );
         END;
      END;
      dl.FreeArgs (rdargs);
   END;

   IF rs1 = dd.ok THEN
      IF errnum >= 0 THEN
         IF result THEN
            con.ValToStr (offset, FALSE, rs2str, 10, -6, 0C, err);
            str.ConcatChar (rs2str, " ");
            con.ValToStr (errnum, FALSE, zahlstr, 10, -6, 0C, err);
            str.Concat (rs2str, zahlstr);
            str.ConcatChar (rs2str, " ");
            str.Concat (rs2str, errstr);
            rs2 := CAST(LONGINT, rxl.CreateArgstring(ADR(rs2str), str.Length(rs2str)));
         END;
      ELSE
         rs1 := dd.fail;
      END;
   END;
END Error;
(* **)

(* ---------------------------------------------------------------------- *)

PROCEDURE Errors (VAR rs1, rs2 : LONGINT; result : BOOLEAN; rdargs : dd.RDArgsPtr);
(**   Format      : ERRORS
      Schablone   : -
      Funktion    : Liefert die Anzahl der Fehler.
*)
VAR   zahlstr  : ARRAY [0..10] OF CHAR;
      err      : BOOLEAN;
BEGIN
   IF DEBUG THEN
      DbgWrite ("REXX: ERRORS\n");
   END;
   rs1 := dd.ok;
   IF result THEN
      con.ValToStr (MAXERRORS, FALSE, zahlstr, 10, -5, 0C, err);
      rs2 := CAST(LONGINT, rxl.CreateArgstring(ADR(zahlstr), str.Length(zahlstr)));
   END;
END Errors;
(* **)

(* ---------------------------------------------------------------------- *)

PROCEDURE Reset (VAR rs1, rs2 : LONGINT; result : BOOLEAN; rdargs : dd.RDArgsPtr);
(**   Format      : RESET [ NUMBER = <Nummer> ]
      Schablone   : NUMBER/K/N
      Funktion    : Setzt den aktuelle Fehler neu.
      Beschreibung: Hiermit wird CURRERR mit einem neuen Wert versehen.
                    Die Option NUMBER setzt CURRERR auf den angegebenen
                    Wert.
                    Ohne Option wird CURRERR auf 0 gesetzt (was dem
                    ersten Fehler entspricht).
*)
CONST MAXOPTIONS  = 1;
      number      = 0;
VAR   template    : String;
      options     : ARRAY [0..MAXOPTIONS-1] OF LONGINT;
      success     : dd.RDArgsPtr;
BEGIN
   IF DEBUG THEN
      DbgWrite ("REXX: RESET\n");
   END;
   template := "NUMBER/K/N";
   options[number] := 0;

   success := dl.ReadArgs(ADR(template), ADR(options), rdargs);
   IF success = NIL THEN
      TemplateError;
      rs1 := dd.error;
      RETURN;
   ELSE
      CURRERR := CAST(LONGINTPtr, options[number])^;
      IF (CURRERR >= MAXERRORS) OR (CURRERR < 0) THEN
         CURRERR := 0;
         rs1 := dd.warn;
      ELSE
         rs1 := dd.ok;
      END;
   END;
   dl.FreeArgs (rdargs);
END Reset;
(* **)

(* ---------------------------------------------------------------------- *)

PROCEDURE Load (VAR rs1, rs2 : LONGINT; result : BOOLEAN; rdargs : dd.RDArgsPtr);
(**   Format      : LOAD <Moduldatei> | <Fehlermeldungen> ERRORMSG
      Schablone   : FILE/A,ERRORMSG/S
      Funktion    : Lädt die Fehlerdatei.
      Beschreibung: Zu dem angegebenen Modul wird die zugehörige Fehler-
                    datei geladen (gleicher Dateiname plus "E").
                    Gibt es keine, wird rc auf 5 gesetzt; bei einem
                    Lesefehler auf 20.
                    Wird die Option ERRORMSG angegeben, so handelt es
                    sich bei der Datei um die Datei mit den Fehler-
                    meldungen.
                    Voreingestellt ist hier M2:Fehler-Meldungen.
*)
CONST MAXOPTIONS  = 2;
      file        = 0;
      errormsg    = 1;
VAR   template    : String;
      options     : ARRAY [0..MAXOPTIONS-1] OF LONGINT;
      filename    : ARRAY [0..255] OF CHAR;
      success     : dd.RDArgsPtr;
BEGIN
   IF DEBUG THEN
      DbgWrite ("REXX: LOAD\n");
   END;
   template := "FILE/A,ERRORMSG/S";
   options[file] := 0;
   options[errormsg] := 0;
   CURRERR := 0;

   success := dl.ReadArgs(ADR(template), ADR(options), rdargs);
   IF success = NIL THEN
      TemplateError;
      rs1 := dd.error;
   ELSE
      str.Copy (filename, CAST(StringPtr, options[file])^);
      IF options[errormsg] # 0 THEN
         rs1 := LoadErrorMsgFile (filename);
      ELSE
         str.ConcatChar (filename, "E");
         rs1 := LoadErrorFile (filename);
      END;
   END;
   dl.FreeArgs (rdargs);
END Load;
(* **)

(* ---------------------------------------------------------------------- *)

PROCEDURE Query (VAR rs1, rs2 : LONGINT; result : BOOLEAN; rdargs : dd.RDArgsPtr);
(**   Format      : QUERY FILE | CURRERR | MAXERRORS | ERRORMSGFILE
      Schablone   : FILE/S,CURRERR/S,MAXERRORS/S,ERRORMSGFILE/S
      Funktion    : Interne Variablen ermitteln.
      Beschreibung:

      Dieses Kommando gibt Auskunft über interne Variablen.
      FILE gibt in RESULT den Namen der geladenen Fehlerdatei (mit
      Endung "E") zurück oder eine Warnung, wenn keine Fehlerdatei ge-
      laden ist.
      Mit CURRERR kann der interne Fehlerzähler abgefragt werden.
      MAXERROS liefert wie ERRORS die Anzahl der Fehler und mit
      ERRORMSGFILE kann der Name der Datei abgefragt werden, die zur
      Bestimmung der Fehlertexte verwendet wird.
*)

CONST MAXOPTIONS  = 4;
      optFile           = 0;
      optCurrErr        = 1;
      optMaxErrors      = 2;
      optErrorMsgFile   = 3;

VAR   template : String;
      success  : dd.RDArgsPtr;
      options  : ARRAY [0..MAXOPTIONS-1] OF LONGINT;
      zahlstr  : ARRAY [0..10] OF CHAR;
      err      : BOOLEAN;
      i        : CARDINAL;
BEGIN
   IF DEBUG THEN
      DbgWrite ("REXX: QUERY\n");
   END;
   template := "FILE/S,CURRERR/S,MAXERRORS/S,ERRORMSGFILE/S";
   FOR i := 0 TO MAXOPTIONS-1 DO
      options[i] := 0;
   END;
   success := dl.ReadArgs(ADR(template), ADR(options), rdargs);
   IF success = NIL THEN
      TemplateError;
      rs1 := dd.error;
   ELSE
      IF DEBUG THEN
         DbgWrite ("   Template erfolgreich\n");
      END;
      IF options[optFile] # 0 THEN
         IF DEBUG THEN
            DbgWrite ("   FILE\n");
         END;
         IF str.Length(ERRORFILE) > 0 THEN
            rs1 := dd.ok;
            rs2 := CAST(LONGINT, rxl.CreateArgstring(ADR(ERRORFILE), str.Length(ERRORFILE)));
         ELSE
            rs1 := dd.warn;
         END;
      ELSIF options[optCurrErr] # 0 THEN
         IF DEBUG THEN
            DbgWrite ("   CURRERR\n");
         END;
         con.ValToStr (CURRERR, FALSE, zahlstr, 10, -5, 0C, err);
         rs1 := dd.ok;
         IF result THEN
            rs2 := CAST(LONGINT, rxl.CreateArgstring(ADR(zahlstr), str.Length(zahlstr)));
         END;
      ELSIF options[optMaxErrors] # 0 THEN
         IF DEBUG THEN
            DbgWrite ("MAXERRORS\n");
         END;
         con.ValToStr (MAXERRORS, FALSE, zahlstr, 10, -5, 0C, err);
         rs1 := dd.ok;
         IF result THEN
            rs2 := CAST(LONGINT, rxl.CreateArgstring(ADR(zahlstr), str.Length(zahlstr)));
         END;
      ELSIF options[optErrorMsgFile] # 0 THEN
         IF DEBUG THEN
            DbgWrite ("ERRORMSGFILE\n");
         END;
         IF str.Length(ERRORMSGFILE) > 0 THEN
            rs1 := dd.ok;
            IF result THEN
               rs2 := CAST(LONGINT, rxl.CreateArgstring(ADR(ERRORMSGFILE), str.Length(ERRORMSGFILE)));
            END;
         ELSE
            rs1 := dd.warn;
         END;
      END;
   END;
   IF DEBUG THEN
      DbgWrite ("   freeing rdargs\n");
   END;
   dl.FreeArgs (rdargs);
END Query;

(* ---------------------------------------------------------------------- *)

PROCEDURE Unknown (VAR rs1, rs2 : LONGINT; result : BOOLEAN; rdargs : dd.RDArgsPtr);
(**   Format      : intern
      Schablone   : -
      Funktion    : Wird bei nicht identifizierten Kommandos aufgerufen.
*)
BEGIN
   rs1 := dd.fail;
END Unknown;
(* **)

(* ---------------------------------------------------------------------- *)

CONST (* Konstanten für template-options *)
      opt_errormsgfile  = 0;
      opt_debug         = 1;

VAR   rexxPort    := ed.MsgPortPtr{NIL};
      rexxproc    : ARRAY Commands OF RexxCommProc;
      template    := String{"ERRORMSGFILE/K,DEBUG/S"};
      options     : ARRAY [0..2] OF LONGINT;
      help        : String;
      rdargs      := dd.RDArgsPtr{NIL};
      success     : dd.RDArgsPtr;
      errorMsgFile: String;
      done        : BOOLEAN;
      sigmask,
      rcvdsigs    : LONGSET;
      msg         : ADDRESS;
      rexxCommand : Commands;
      arg0        : String;
      taglist     : ARRAY [0..10] OF LONGINT;
      result      : BOOLEAN;
      cl          : INTEGER;  (* Länge des AREXX-Kommandos *)
BEGIN
   IF Arts.wbStarted THEN
      CheckToolTypes (errorMsgFile);

   ELSE
      (* Übergebene Parameter überprüfen: *)
      help := "RexxM2Error V 0.97 © 1994 Fin Schuppenhauer";
      rdargs := dl.AllocDosObject(dd.dosRdArgs, TAG(taglist, tagEnd));
      IF rdargs # NIL THEN
         rdargs^.extHelp := ADR(help);
         (* ^^^ Wieso tut das nicht funktionieren ? *)
         options[opt_errormsgfile] := ADR("M2:Fehler-Meldungen");
         success := dl.ReadArgs(ADR(template), ADR(options), rdargs);
         IF success = NIL THEN
            TemplateError;
            Arts.returnVal := dd.error;
            RETURN;
         ELSE
            (* Parameter auswerten: *)
            IF options[opt_errormsgfile] # 0 THEN
               str.Copy (errorMsgFile, CAST(StringPtr, options[opt_errormsgfile])^);
            END;
            DEBUG := options[opt_debug] # 0;
         END;
         dl.FreeArgs (rdargs);
         dl.FreeDosObject (dd.dosRdArgs, rdargs);
         rdargs := NIL;
      END;
   END;
   
   IF DEBUG THEN
      dbghdl := dl.Output();
   END;

   
   (* Einen Arexx-Port creieren: *)
   el.Forbid();
      rexxPort := el.FindPort(ADR("REXXM2ERROR"));
   el.Permit();
   IF rexxPort # NIL THEN
      done := Arts.Requester(ADR("REXXM2ERROR detected an error:"),
                     ADR("Program already running!"), NIL, ADR("Ohh"));
      rexxPort := NIL; 
      (* Der CLOSE-Teil darf auf gar keinen Fall diesen Port entfernen! *)
      RETURN;
   END;
   rexxPort := es.CreatePort(ADR("REXXM2ERROR"), 0);

   IF LoadErrorMsgFile (errorMsgFile) # 0 THEN
      es.DeletePort (rexxPort);
      rexxPort := NIL;
      Arts.returnVal := 20;
      RETURN;
   END;

   rexxproc[ERROR]      := Error;
   rexxproc[ERRORS]     := Errors;
   rexxproc[RESET]      := Reset;
   rexxproc[LOAD]       := Load;
   rexxproc[QUIT]       := Quit;
   rexxproc[QUERY]      := Query;
   rexxproc[UNKNOWN]    := Unknown;

   sigmask := LONGSET{dd.ctrlC, rexxPort^.sigBit};
   done := FALSE;
   WHILE ~done DO
      IF DEBUG THEN
         DbgWrite ("Waiting for messages... ");
      END;
      (* Hier warten wir auf eine Arexx-Nachricht oder ein CTRL-C: *)
      rcvdsigs := el.Wait(sigmask);
      IF DEBUG THEN
         DbgWrite (" received.\n");
      END;

      IF dd.ctrlC IN rcvdsigs THEN
         (* Ein CTRL-C wurde uns gemeldet; wir werden das Programm
          * beenden:
          *)
         done := TRUE;
      END;

      LOOP
         msg := el.GetMsg(rexxPort);
         IF msg = NIL THEN EXIT; END;

         IF rxl.IsRexxMsg(msg) THEN
            (* Die eingegangene Nachricht ist eine Arexx-Nachricht: *)

            WITH CAST(rxd.RexxMsgPtr, msg)^ DO
               str.Copy (arg0, CAST(StringPtr, args[0])^);
               rexxCommand := GetRexxCommand(arg0, cl);

               IF rxd.comm = action.command THEN
                  (* Eine Arexx-Kommando; alles steht in args[0]. *)
                  result := (rxd.result IN action.modifier);
                  rdargs := dl.AllocDosObject(dd.dosRdArgs, TAG(taglist, tagEnd));
                  IF rdargs # NIL THEN
                     (* Jetzt modifizieren wir rdargs, da unsere Eingabe
                      * für ReadArgs() nicht vom Terminal, sondern hier
                      * aus unserem Programm kommt:
                      *)
                     str.ConcatChar (arg0, "\n");
                     WITH rdargs^.source DO
                        (* Das Kommando selber soll nicht Teil unseres
                         * zu überprüfenden Templates sein:
                         *)
                        buffer := ADR(arg0) + ADDRESS(cl);
                        length := str.Length(CAST(StringPtr, buffer)^);
                        curChr := 0;
                     END;
                     IF DEBUG THEN
                        DbgWrite ("Calling Rexx-Proc with template: ");
                        DbgWrite (CAST(StringPtr, rdargs^.source.buffer)^);
                        DbgWriteLn;
                     END;

                     (* Jetzt rufen wir die implementierten ARexx-
                      * Routinen auf:
                      *)
                     rexxproc[rexxCommand] (result1, result2, result, rdargs);
                     IF (rexxCommand = QUIT) & (result1 = 0) THEN
                        done := TRUE;
                     END;
                     dl.FreeDosObject(dd.dosRdArgs, rdargs);
                     rdargs := NIL;
                  ELSE
                     IF DEBUG THEN
                        DbgWrite ("rdargs not available.\n");
                     END;
                     result1 := 20;
                  END;
               ELSIF rxd.func = action.command THEN
                  (* Wann kann dieses passieren ??? *)
                  IF DEBUG THEN
                     DbgWrite ("rxd.func\n");
                  END;
                  (* Eine Arexx-Funktion; das Kommando steht in args[0],
                   * die Parameter in args[>0].
                   *)
                  result1 := 20;
               END;
            END;
         END;
         el.ReplyMsg (msg);
      END;
   END;

   IF DEBUG THEN
      DbgWrite ("Leaving programm...\n");
   END;
   es.DeletePort (rexxPort);
   rexxPort := NIL;

CLOSE
   IF ErrorMsgBase # NIL THEN
      Deallocate (ErrorMsgBase);
   END;
   IF ErrorArray # NIL THEN
      Deallocate (ErrorArray);
   END;

   IF rdargs # NIL THEN
      dl.FreeDosObject (dd.dosRdArgs, rdargs);
      rdargs := NIL;
   END;
   IF rexxPort # NIL THEN
      es.DeletePort (rexxPort);
      rexxPort := NIL;
   END;
END RexxM2Error.

