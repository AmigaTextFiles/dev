(*
 * Source generated with ARexxBox 1.11 (Apr 20 1993)
 * which is Copyright (c) 1992,1993 Michael Balzer
 * Oberon-2 Source by hartmut Goebel 1993
 *)

MODULE Test2RXIF;

(* !ARB: I 727904534 *)

IMPORT
  arb:= Test2ARB,
  BT := BasicTypes,
  d  := Dos,
  e  := Exec,
        OberonLib,
  rxh:= ARBRexxHost,
  s  := SYSTEM,
  u  := Utility;

TYPE
(* rxd-Strukturen dürfen nur AM ENDE um lokale Variablen erweitert werden! *)

  rxdAlias = RECORD (rxh.RXD)
    arg: STRUCT
           global: rxh.ArgBool;
           name: rxh.ArgString;
           command: rxh.ArgString;
    END;
  END;

  rxdCmdshell = RECORD (rxh.RXD)
    arg: STRUCT
           open: rxh.ArgBool;
           close: rxh.ArgBool;
    END;
  END;

  rxdDisable = RECORD (rxh.RXD)
    arg: STRUCT
           global: rxh.ArgBool;
           names: rxh.ArgStringArray;
    END;
  END;

  rxdEnable = RECORD (rxh.RXD)
    arg: STRUCT
           global: rxh.ArgBool;
           names: rxh.ArgStringArray;
    END;
  END;

  rxdFault = RECORD (rxh.RXD)
    arg: STRUCT
           var, stem: rxh.ArgString;
           number: rxh.ArgLong;
    END;
    res: STRUCT
           description: rxh.ResString;
    END;
  END;

  rxdHelp = RECORD (rxh.RXD)
    arg: STRUCT
           var, stem: rxh.ArgString;
           command: rxh.ArgString;
           prompt: rxh.ArgBool;
    END;
    res: STRUCT
           commanddesc: rxh.ResString;
           commandlist: rxh.ResStringArray;
    END;
  END;

  rxdRx = RECORD (rxh.RXD)
    arg: STRUCT
           var, stem: rxh.ArgString;
           console: rxh.ArgBool;
           async: rxh.ArgBool;
           command: rxh.ArgString;
    END;
    res: STRUCT
           rc: rxh.ResLong;
           result: rxh.ResString;
    END;
  END;


(* !ARB: B 1 ALIAS *)
PROCEDURE Alias * (host: rxh.RexxHost; VAR rxd: rxh.RXDPtr; action: INTEGER);
VAR
  rd: POINTER TO rxdAlias;
BEGIN
   rd := rxd(rxdAlias); (* TypeGuard, stellt sicher, daß auch der richtige *)
           (* RECORD übergeben wurde, wenn rxd = NIL wird nicht geprüft *)
   CASE action OF
   |rxh.init:
       s.ALLOCATE(rd);
       rxd := rd;
       IF rd # NIL THEN
         (* set your DEFAULTS here *)
       END;

   |rxh.action:
     (* Insert your CODE here *)
     rd.rc := 0;

   |rxh.free:
     (* FREE your local data here *)
(* $IFNOT GarbageCollector *)
     DISPOSE(rd);
(* $END *)
  END;
END Alias;
(* !ARB: E 1 ALIAS *)


(* !ARB: B 2 CMDSHELL *)
(*
 * Dieses Kommando kann nur von ARexx aus eine CmdShell
 * _ÖFFNEN_, und nur von einer CmdShell aus diese _SCHLIEßEN_.
 *
 * Mit etwas mehr Aufwand (Buchführung über die Hosts) kann man
 * auch eine andere (flexiblere) Lösung finden.
 *
 * ACHTUNG: Buchführung über offene CmdShells ist zwingend
 * notwendig für den CloseDown! Sonst bleiben nach 'Quit' u.U.
 * noch CmdShells offen!
 *)
PROCEDURE runCommandShell(host: rxh.RexxHost): BT.ANY;
VAR
  fh: d.FileHandlePtr;
  rh: rxh.RexxHost;
BEGIN
  (* diese Funktion wird als eigener Prozeß gestartet *)
    
  (* Host, Fenster und CmdShell öffnen *)
  (* rh := arb.SetupARexxHost(NIL); *)
  IF rh # NIL THEN
    fh := d.Open( "CON:////CommandShell/AUTO", d.newFile);
    IF fh # NIL THEN
      rh.CommandShell( fh, fh, "> " );
      d.OldClose( fh );
    END;
    (* arb.CloseDownARexxHost( rh ); *)
  END;
  RETURN NIL;
END runCommandShell;


PROCEDURE Cmdshell * (host: rxh.RexxHost; VAR rxd: rxh.RXDPtr; action: INTEGER);
VAR
  rd: POINTER TO rxdCmdshell;
BEGIN
   rd := rxd(rxdCmdshell);

   CASE action OF
   |rxh.init:
       s.ALLOCATE(rd);

   |rxh.action:
     IF rd.arg.close # NIL THEN (* schließen *)
       IF rxh.cmdShell IN host.flags THEN
         (* Flag löschen *)
         EXCL(host.flags,rxh.cmdShell);
       ELSE
         rd.rc := -10;
         rd.rc2 := s.ADR("Not a CommandShell");
       END;
     ELSE (* öffnen (OPEN ist unnötig) *)
       (* CmdShell asynchron als neuen Prozeß starten *)
       (* Design-Probleme!  Wie erzuege ich ein Objekt von gleichen
        * Typ wie der  dynamische Typ von rxh? Mit dem Modul Objects von
        * Fridtjof Siebert ist eine Lösung möglich, wird hier aber nicht
        * diskutiert, weil es noch nicht released wurde.
       Concurrency.NewProcessX(runCommandShell,host,4000,e.exec.thisTask.pri);
       *)
     END;

   |rxh.free:
(* $IFNOT GarbageCollector *)
     DISPOSE(rd);
(* $END *)
  END;
END Cmdshell;
(* !ARB: E 2 CMDSHELL *)


(* !ARB: B 3 DISABLE *)
(*
 * Dieses Kommando sollte besser auch Kommandos lokal zu einem
 * Host beeinflussen können. Vorschlag: Zusätzlicher Switch
 * "GLOBAL/S" (Default wäre damit LOKAL).
 *)
PROCEDURE Disable * (host: rxh.RexxHost; VAR rxd: rxh.RXDPtr; action: INTEGER);
VAR
  rd: POINTER TO rxdDisable;
  sp: rxh.ArgStringArray;
  i, rxc: INTEGER;
BEGIN
   rd := rxd(rxdDisable);

   CASE action OF
   |rxh.init:
       s.ALLOCATE(rd);

   |rxh.action:
     sp := rd.arg.names;
     IF sp # NIL THEN
       i := 0;
       (* Liste der Namen abarbeiten *)
       WHILE sp[i] # NIL DO
         IF rd.arg.global # 0 THEN
           rxc := host.FindCommand(sp[i]^);
           IF rxc >= 0 THEN
             EXCL(arb.RXCFlags[rxc],rxh.enabled);
           END;
         END;
         INC(i);
       END;
     END;
     rd.rc := 0;

   |rxh.free:
(* $IFNOT GarbageCollector *)
     DISPOSE(rd);
(* $END *)
  END;
END Disable;
(* !ARB: E 3 DISABLE *)


(* !ARB: B 4 ENABLE *)
(*
 * Dieses Kommando sollte besser auch Kommandos lokal zu einem
 * Host beeinflussen können. Vorschlag: Zusätzlicher Switch
 * "GLOBAL/S" (Default wäre damit LOKAL).
 *)
PROCEDURE Enable * (host: rxh.RexxHost; VAR rxd: rxh.RXDPtr; action: INTEGER);
VAR
  rd: POINTER TO rxdEnable;
  sp: rxh.ArgStringArray;
  i, rxc: INTEGER;
BEGIN
   rd := rxd(rxdEnable);

   CASE action OF
   |rxh.init:
       s.ALLOCATE(rd);

   |rxh.action:
     sp := rd.arg.names;
     IF sp # NIL THEN
       i := 0;
       (* Liste der Namen abarbeiten *)
       WHILE sp[i] # NIL DO
         IF rd.arg.global # 0 THEN
           rxc := host.FindCommand(sp[i]^);
           IF rxc >= 0 THEN
             INCL(arb.RXCFlags[rxc],rxh.enabled);
           END;
         END;
         INC(i);
       END;
     END;
     rd.rc := 0;

   |rxh.free:
(* $IFNOT GarbageCollector *)
     DISPOSE(rd);
(* $END *)
  END;
END Enable;
(* !ARB: E 4 ENABLE *)


(* !ARB: B 5 FAULT *)
PROCEDURE Fault * (host: rxh.RexxHost; VAR rxd: rxh.RXDPtr; action: INTEGER);
VAR
  rd: POINTER TO rxdFault;
BEGIN
   rd := rxd(rxdFault);

   CASE action OF
   |rxh.init:
       s.ALLOCATE(rd);

   |rxh.action:
     s.ALLOCATE(rd.res.description,256);
     IF rd.res.description # NIL THEN
       IF ~d.Fault(rd.arg.number[0],"DESC", rd.res.description^,
                   LEN(rd.res.description^)) THEN
         rd.rc := -10;
         rd.rc2 := s.ADR("FAULT failed");
       END;
     ELSE
       rd.rc := 10;
       rd.rc2 := rxh.errorNoFreeStore;
     END;

   |rxh.free:
(* $IFNOT GarbageCollector *)
     DISPOSE(rd.res.description);
     DISPOSE(rd);
(* $END *)
  END;
END Fault;
(* !ARB: E 5 FAULT *)


(* !ARB: B 6 HELP *)
PROCEDURE Help * (host: rxh.RexxHost; VAR rxd: rxh.RXDPtr; action: INTEGER);
VAR
  rd: POINTER TO rxdHelp;
BEGIN
   rd := rxd(rxdHelp); (* TypeGuard, stellt sicher, daß auch der richtige *)
           (* RECORD übergeben wurde, wenn rxd = NIL wird nicht geprüft *)
   CASE action OF
   |rxh.init:
       s.ALLOCATE(rd);
       rxd := rd;
       IF rd # NIL THEN
         (* set your DEFAULTS here *)
       END;

   |rxh.action:
     (* Insert your CODE here *)
     rd.rc := 0;

   |rxh.free:
     (* FREE your local data here *)
(* $IFNOT GarbageCollector *)
     DISPOSE(rd);
(* $END *)
  END;
END Help;
(* !ARB: E 6 HELP *)


(* !ARB: B 7 RX *)
PROCEDURE Rx * (host: rxh.RexxHost; VAR rxd: rxh.RXDPtr; action: INTEGER);
VAR
  rd: POINTER TO rxdRx;
BEGIN
   rd := rxd(rxdRx); (* TypeGuard, stellt sicher, daß auch der richtige *)
           (* RECORD übergeben wurde, wenn rxd = NIL wird nicht geprüft *)
   CASE action OF
   |rxh.init:
       s.ALLOCATE(rd);
       rxd := rd;
       IF rd # NIL THEN
         (* set your DEFAULTS here *)
       END;

   |rxh.action:
     (* Insert your CODE here *)
     rd.rc := 0;

   |rxh.free:
     (* FREE your local data here *)
(* $IFNOT GarbageCollector *)
     DISPOSE(rd);
(* $END *)
  END;
END Rx;
(* !ARB: E 7 RX *)


(* $IFNOT RxAlias *)

PROCEDURE ExpandRXCommand*(host: rxh.RexxHost; command: BT.DynString): BT.DynString;
BEGIN
  (* Insert your ALIAS-HANDLER here *)
  RETURN NIL;
END ExpandRXCommand;

(* $END *)

END Test2RXIF.
