(*
 * Source generated with ARexxBox 1.11 (Apr 20 1993)
 * which is Copyright (c) 1992,1993 Michael Balzer
 * Oberon-2 Source by hartmut Goebel 1993
 *)

(* $NilChk- $RangeChk- $CaseChk- $OvflChk- $ReturnChk- $ClearVars- *)

MODULE RxTest2;

(* Dies sind die Basisroutinen der ARexxBox *)

IMPORT
  if  := Test2RXIF,  (* die Implementation der Routinen *)
  arb := Test2ARB,   (* das ARB-Modul *)
  BT  := BasicTypes,
  e   := Exec,
  d   := Dos,
  ms  := MoreStrings,
  ol  := OberonLib,
  pf  := Printf,
         RVI,
  rx  := Rexx,
  rxh := ARBRexxHost,
  rxs := RexxSysLib,
  y   := SYSTEM,
  str := Strings;

TYPE
  RexxHost * = POINTER TO RexxHostDesc;
  RexxHostDesc * = RECORD (rxh.RexxHostDesc)
  END;

  ArgVarStem = UNTRACED POINTER TO STRUCT
    varName: e.STRPTR;
    stemName: e.STRPTR;
  END;

CONST
  numCmds = arb.numCmds;

TYPE
  CommandListType = ARRAY numCmds OF rxh.Command;

CONST
  CommandList = CommandListType(
	y.ADR("ALIAS"), y.ADR("GLOBAL/S,NAME/A,COMMAND/F"), NIL, 0, if.Alias, LONGSET{rxh.enabled},
	y.ADR("CMDSHELL"), y.ADR("OPEN/S,CLOSE/S"), NIL, 0, if.Cmdshell, LONGSET{rxh.enabled},
	y.ADR("DISABLE"), y.ADR("GLOBAL/S,NAMES/M"), NIL, 0, if.Disable, LONGSET{rxh.enabled},
	y.ADR("ENABLE"), y.ADR("GLOBAL/S,NAMES/M"), NIL, 0, if.Enable, LONGSET{rxh.enabled},
	y.ADR("FAULT"), y.ADR("NUMBER/N/A"), y.ADR("DESCRIPTION"), SIZE(rxh.RXD)+1*SIZE(LONGINT), if.Fault, LONGSET{rxh.enabled},
	y.ADR("HELP"), y.ADR("COMMAND,PROMPT/S"), y.ADR("COMMANDDESC,COMMANDLIST/M"), SIZE(rxh.RXD)+2*SIZE(LONGINT), if.Help, LONGSET{rxh.enabled},
	y.ADR("RX"), y.ADR("CONSOLE/S,ASYNC/S,COMMAND/F"), y.ADR("RC/N,RESULT"), SIZE(rxh.RXD)+3*SIZE(LONGINT), if.Rx, LONGSET{rxh.enabled}
    );

(*------------- hier beginnt der allgemeine Teil ------------*)

PROCEDURE (host: RexxHost) FindCommand * (com: ARRAY OF CHAR): INTEGER;
VAR
  n, pos: INTEGER;
  ug, og, cmp: INTEGER;
BEGIN
  ug := 0; og := numCmds-1;
  n := SHORT(str.Length(com));
  IF n = 0 THEN RETURN -1; END;

  str.Upper(com);

  (* Init *)

  pos := (og + ug) DIV 2;

  (* Suchen *)

  LOOP
    IF og - ug <= 0 THEN EXIT; END;

    cmp := ms.NCStrCmp(com, CommandList[pos].command^);

    IF cmp = 0 THEN
      (* gefunden! *)
      EXIT;
    ELSIF cmp < 0 THEN
      (* im linken Zweig weitersuchen *)
      og := pos - 1;
    ELSE
      (* im rechten Zweig weitersuchen *)
      ug := pos + 1;
    END;

    pos := (og + ug) DIV 2;
  END;

  (* Nachlese *)
  IF cmp # 0 THEN

    (* noch nicht gefunden *)

    IF ms.NCStrCmp(com, CommandList[pos].command^) = 0 THEN
      RETURN pos;
    ELSIF (ug # og) & (ms.NCStrCmp(com, CommandList[pos+1].command^) = 0) THEN
      RETURN pos+1;
    ELSE
      RETURN -1;
    END;

  ELSE
    (* letzter Vergleich war ok *)
    RETURN pos;
  END;
END FindCommand;


PROCEDURE (host: RexxHost) HandleCommand * (rexxmsg: rx.RexxMsgPtr);
VAR
  com: rxh.CommandPtr;
  rxc: INTEGER;
  argb, argb2: BT.DynString;
  arg: e.STRPTR;
  array: rxh.RXDPtr;
  argVarStem: ArgVarStem;
  resarray: e.APTR;
  rc, rc2: LONGINT;
  cargstr, result: BT.DynString;
  stem, st: rxh.StemNodePtr;
  rm: rx.RexxMsgPtr;
BEGIN
  argb := NIL; cargstr := NIL; result := NIL; array := NIL;
  rc2:=0;
  rc:=20;

  LOOP  (* dummy *)
  argb := ms.CopyCStringAdd(rexxmsg.args[0],1);
  IF argb = NIL THEN
    rc2 := rxh.errorNoFreeStore;
    EXIT;
  END;

  (* welches Kommando? *)

  str.AppendChar(argb^,"\n");
  arg := y.ADR(argb^);

  rxc := host.ParseCommand(arg);

(* $IF RxAlias *)
  IF rxc = -1 THEN

    argb2 := if.ExpandRXCommand(host,rexxmsg.args[0]);
    IF argb2 # NIL THEN
      DISPOSE(argb);
      y.ALLOCATE(argb,str.Length(argb2^)+2);
      IF argb = NIL THEN
        rc2 := rxh.errorNoFreeStore;
        EXIT;
      END;

      COPY(argb2^,argb^);
      str.AppendChar(argb^,"\n");
      DISPOSE(argb2);
      arg := y.ADR(argb^);

      (* nochmal den Parser mit dem neuen Befehl anwerfen *)
      rxc := ParseRXCommand(arg);
    END;
  END;
(* $END *)

  IF rxc = -1 THEN
    (* Msg an ARexx schicken, vielleicht existiert ein Skript *)

      rm := host.CreateCommand(rexxmsg.args[0]^, NIL);
      IF rm # NIL THEN
        (* Original-Msg merken *)
        rm.args[15] := y.VAL(e.STRPTR,rexxmsg);

        IF host.MsgToRexx(rm) # NIL THEN
          (* Reply wird später vom Dispatcher gemacht *)
(* $IFNOT GarbageCollector *)
            DISPOSE(argb);
(* $END *)
            RETURN;
        ELSE
          rc2 := rxh.errorNotImplemented;
        END;
      ELSE
        rc2 := rxh.errorNoFreeStore;
      END;
    EXIT;
  END;

  IF ~(rxh.enabled IN arb.RXCFlags[rxc]) THEN
    rc := -10;
    rc2 := y.ADR(rxh.CommandDisabled);
    EXIT;
  END;
  com := y.ADR(CommandList[rxc]);

  (* Speicher für Argumente etc. holen *)

  com.function(host, array, rxh.init);

  (* Speicher für ReadArgs()-Schablone: 15 Zeichen mehr
   * für Var&Stem (falls Resultate erzeugt werden, s.u.)
   *)

  IF com.args # NIL THEN
    cargstr := ms.CopyCStringAdd(com.args,15);
  ELSE
    y.ALLOCATE(cargstr,15);
  END;

  IF (array = NIL) OR (cargstr = NIL) THEN
    rc2 := rxh.errorNoFreeStore;
    EXIT;
  END;

  (* Adressen der Argumente- und Resultate-Substruktur
   * bestimmen
   *)

  argVarStem := y.VAL(y.ADDRESS,y.VAL(LONGINT,array) + SIZE(rxh.RXD));
  resarray := y.VAL(y.ADDRESS,y.VAL(LONGINT,array) + com.resindex);

  (* Argumente parsen *)

  IF com.results # NIL THEN
    (* Präfix für Resultate: *)
    cargstr^ := "VAR/K,STEM/K";
  ELSE
    cargstr^ := "";
  END;

  (* mit dem Argumente-Template zusammensetzen *)

  IF  com.args # NIL THEN
    IF cargstr^ # "" THEN
      str.AppendChar(cargstr^, ","); END;
    str.Append(cargstr^, com.args^);
  END;

  (* und ReadArgs() darauf loslassen *)

  IF cargstr^ # "" THEN
    host.rdargs.source.buffer := y.ADR(arg^);
    host.rdargs.source.length := str.Length(arg^);
    host.rdargs.source.curChr := 0;
    host.rdargs.daList := NIL;
    host.rdargs.buffer := NIL;

    IF d.ReadArgs(cargstr^, argVarStem^, host.rdargs) = NIL THEN
      rc := 10;
      rc2 := d.IoErr();
      EXIT;
    END;
  END;

  (* Funktion aufrufen *)
  (* Phase 2 (ACTION)! *)

  com.function( host, array, rxh.action );

  (* Returncodes auslesen *)

  rc := array.rc;
  rc2 := array.rc2;

  (* Resultat(e) auswerten *)

  IF (com.results # NIL) & (rc=0)
    & (rx.rxfResult IN rx.ActionFlags(rexxmsg.action)) THEN

    (* Stem-Liste und Variable direkt generieren *)

    stem := rxh.CreateSTEM(com, resarray, argVarStem.stemName);
    result := rxh.CreateVAR(stem);

    IF stem = NIL THEN
      result := NIL;
      rc := 20;
      rc2 := rxh.errorNoFreeStore;
    ELSIF result # NIL THEN
      (* argarray[0] ist der Name für das VAR-Result *)
      IF argVarStem.varName # NIL THEN
        IF RVI.SetRexxVar(rexxmsg, argVarStem.varName^, result^, str.Length(result^)) = NIL THEN
          rc := -10;
          rc2 := y.ADR(rxh.CantSetVar);
        END;

(* $IFNOT GarbageCollector *)
        DISPOSE(result);
(* $ELSE *)
        result := NIL;
(* $END *)
      END;

      (* argarray[0] ist der Name für das STEM-Result *)
      IF argVarStem.stemName # NIL THEN
        (* STEM-Liste abarbeiten und setzen *)
        st := stem;
        WHILE st # NIL DO
          rc := rc + RVI.SetRexxVar(rexxmsg,st.name^,st.value^,str.Length(st.value^));
          st := st.succ;
        END;
        (* in rc ist der akkumulierte Fehlercode *)

        IF rc # 0 THEN
          rc := -10;
          rc2 := y.ADR(rxh.CantSetVar);
        END;

(* $IFNOT GarbageCollector *)
        DISPOSE(result);
(* $ELSE *)
        result := NIL;
(* $END *)
      END;
    END;

    rxh.FreeStemList(stem);
  END;
  EXIT;
  END; (* dummyLoop *)

  (* Nur RESULT, wenn weder VAR noch STEM *)

  host.ReplyMsg(rexxmsg, rc, rc2, result);

  (* benutzten Speicher freigeben *)
(* $IFNOT GarbageCollector *)
  DISPOSE(result);
(* $ELSE *)
  result := NIL;
(* $END *)
  d.FreeArgs(host.rdargs);
  IF (array # NIL) THEN com.function(host,array, rxh.free); END;
(* $IFNOT GarbageCollector *)
  DISPOSE(cargstr);
  DISPOSE(argb);
(* $END *)
END HandleCommand;


PROCEDURE (host: RexxHost) HandleShellCommand * (comline: ARRAY OF CHAR;
                                                   fhout: d.FileHandlePtr);
VAR
  com: rxh.CommandPtr;
  rxc: INTEGER;
  argb, argb2: BT.DynString;
  arg: e.STRPTR;
  array: rxh.RXDPtr;
  argVarStem: ArgVarStem;
  resarray: e.APTR;
  rc, rc2: LONGINT;
  cargstr, result: BT.DynString;
  sentrm, rm: rx.RexxMsgPtr;
  waiting: BOOLEAN;
  stem, st: rxh.StemNodePtr;
BEGIN
  argb := NIL; cargstr := NIL; array := NIL;
  rc2:=0; rc:=20;

  LOOP  (* dummy *)
  y.ALLOCATE(argb,str.Length(comline)+2);
  IF argb = NIL THEN
    rc2 := rxh.errorNoFreeStore;
    EXIT;
  END;

  (* welches Kommando? *)
  COPY(comline,argb^);
  str.AppendChar(argb^,"\n");
  arg := y.ADR(argb^);

  rxc := host.ParseCommand(arg);

(* $IF RxAlias *)
  IF rxc = -1 THEN

    argb2 := if.ExpandRXCommand(host,comline);
    IF argb2 # NIL THEN
      DISPOSE(argb);
      y.ALLOCATE(argb,str.Length(argb2^)+2);
      IF argb = NIL THEN
        rc2 := rxh.errorNoFreeStore;
        EXIT;
      END;

      COPY(argb2^,argb^);
      str.AppendChar(argb^,"\n");
      DISPOSE(argb2);
      arg := y.ADR(argb^);

      rxc := ParseRXCommand(arg);
    END;
  END;
(* $END *)

  IF rxc = -1 THEN

    sentrm := host.SendCommand(comline,NIL);
    IF sentrm # NIL THEN
      (* auf Reply warten *)
      waiting := TRUE;
      REPEAT
        e.WaitPort(host.port);
        LOOP
          rm := e.GetMsg(host.port);
          IF rm = NIL THEN EXIT; END;

          (* Reply *)
          IF rm.node.node.type = e.replyMsg THEN

            (* zu diesem Kommando *)
            IF rm = sentrm THEN
              IF rm.result1 # 0 THEN
                rc := 20;
                rc2 := rxh.errorNotImplemented;
              ELSE
                rc := 0; rc2 := 0;
                IF rm.result2 # 0 THEN
                  IF d.FPrintf(fhout,"%s\n",rm.result2) = 0 THEN END;
                END;
              END;
              waiting  := FALSE;
            END;
            host.FreeCommand(rm);
            DEC(host.replies);

          ELSE
            host.ReplyMsg(rm,-20,y.ADR("CommandShell Port"),NIL);
          END;

        END;
      UNTIL ~ waiting;
    ELSE
      rc2 := rxh.errorNoFreeStore;
      EXIT;
    END;
  END;

  IF ~(rxh.enabled IN arb.RXCFlags[rxc]) THEN
    rc := -10;
    rc2 := y.ADR(rxh.CommandDisabled);
    EXIT;
  END;
  com := y.ADR(CommandList[rxc]);

  (* Speicher für Argumente etc. holen *)

  com.function(host, array, rxh.init );
  IF com.args # NIL THEN
    cargstr := ms.CopyCStringAdd(com.args,512);
  ELSE
    y.ALLOCATE(cargstr,512);
  END;

  IF (array = NIL) OR (cargstr = NIL) THEN
    rc2 := rxh.errorNoFreeStore;
    EXIT;
  END;

  argVarStem := y.VAL(y.ADDRESS,y.VAL(LONGINT,array) + SIZE(rxh.RXD));
  resarray := y.VAL(y.ADDRESS,y.VAL(LONGINT,array) + com.resindex);

  (* Argumente parsen *)

  IF com.results # NIL THEN
    (* Präfix für Resultate: *)
    cargstr^ := "VAR/K,STEM/K";
  ELSE
    cargstr^ := "";
  END;

  (* mit dem Argumente-Template zusammensetzen *)

  IF  com.args # NIL THEN
    IF cargstr^ # "" THEN
      str.AppendChar(cargstr^, ","); END;
    str.Append(cargstr^, com.args^);
  END;

  (* und ReadArgs() darauf loslassen *)

  IF cargstr^ # "" THEN
    host. rdargs.source.buffer := y.ADR(arg^);
    host.rdargs.source.length := str.Length(arg^);
    host.rdargs.source.curChr := 0;
    host.rdargs.daList := NIL;
    host.rdargs.buffer := NIL;
    host.rdargs.flags := LONGSET{d.noPrompt};

    IF d.ReadArgs(cargstr^, argVarStem^, host.rdargs) = NIL THEN
      rc := 10;
      rc2 := d.IoErr();
      EXIT;
    END;
  END;

  (* Funktion aufrufen *)

  com.function( host,array, rxh.action );

  (* Resultat(e) ausgeben *)

  IF (com.results # NIL) & (argVarStem.varName # NIL)
    & (fhout # NIL) THEN

    stem := rxh.CreateSTEM(com, resarray, argVarStem.stemName);
    result := rxh.CreateVAR(stem);

    IF result # NIL THEN (* Variablenwerte nun hier direkt auf die Console
                          * ausgeben, statt SetRexxVar() *)
      IF argVarStem.varName # NIL THEN
        IF stem = NIL THEN      (* VAR *)
          rc2 := rxh.errorNoFreeStore;
          EXIT;
        END;
        IF d.FPrintf(fhout,"%s = %s\n",argVarStem.varName,y.ADR(result^)) = 0 THEN END;
(* $IFNOT GarbageCollector *)
        DISPOSE(result);
(* $ELSE *)
        result := NIL;
(* $END *)
      END;

      IF argVarStem.stemName # NIL THEN
        IF stem = NIL THEN
          rc2 := rxh.errorNoFreeStore;
          EXIT;
        END;

        st := stem;
        WHILE st # NIL DO
          IF d.FPrintf(fhout,"%s = %s\n",y.ADR(st.name^),y.ADR(st.value^)) = 0 THEN END;
        END;
(* $IFNOT GarbageCollector *)
        DISPOSE(result);
(* $ELSE *)
        result := NIL;
(* $END *)
      END;
    END;

    rxh.FreeStemList(stem);
  END;

  (* Nur RESULT, wenn weder VAR noch STEM *)
  IF result # NIL THEN
    IF stem = NIL THEN
      rc2 := rxh.errorNoFreeStore;
      EXIT;
    ELSE
      IF d.FPrintf( fhout, "%s\n", y.ADR(result^) ) = 0 THEN END;
(* $IFNOT GarbageCollector *)
      DISPOSE(result);
(* $ELSE *)
      result := NIL;
(* $END *)
    END;
  END;

  rc  := array.rc;
  rc2 := array.rc2;

  EXIT;
  END; (* dummyLoop *)

  arg := NIL;

  (* Fehler ebenfalls direkt in lesbarer Form in die
   * Ausgabedatei drucken
   *)

  IF rc2 # 0 THEN
    IF cargstr = NIL THEN y.ALLOCATE(cargstr,512); END;

    IF cargstr = NIL THEN
      arg := y.ADR("ERROR: Absolutely out of memory");
    ELSIF rc > 0 THEN
      IF d.Fault( rc2, "ERROR", cargstr^, 512 ) THEN
        arg := y.ADR(cargstr^);
      ELSE
        arg := y.ADR("ERROR: Unknown Problem");
      END;
    ELSIF rc < 0 THEN
      cargstr^ := "ERROR: ";
      str.Append(cargstr^,y.VAL(e.STRPTR,rc2)^);
      arg := y.ADR(cargstr^);
    END;
  END;

  IF (arg # NIL) & (d.FPrintf( fhout, "%s\n", arg ) = 0) THEN END;

  (* benutzten Speicher freigeben *)

  d.FreeArgs(host.rdargs);
  IF (array # NIL) THEN com.function(host,array, rxh.free); END;
(* $IFNOT GarbageCollector *)
  DISPOSE(cargstr);
  DISPOSE(argb);
(* $END *)
END HandleShellCommand;


PROCEDURE SetupARexxHost * (basename: e.STRPTR): RexxHost;
VAR
  rh: RexxHost;
BEGIN
  NEW(rh);
  IF rh # NIL THEN
    IF ~ rxh.Init(rh,basename,arb.defaultName,arb.extension) THEN
     (* $IFNOT GarbageCollector *)
       DISPOSE(rh);
     (* $END *)
     rh := NIL;
    END;
  END;
  RETURN rh;
END SetupARexxHost;

PROCEDURE CloseDownARexxHost * (VAR rh: RexxHost);
BEGIN
  rh.Uninit;
  (* $IFNOT GarbageCollector *)
    DISPOSE(rh);
  (* $END *)
  rh := NIL;
END CloseDownARexxHost;


PROCEDURE InitFlags;
VAR
  i: INTEGER;
BEGIN
  i := numCmds;
  REPEAT
    DEC(i); arb.RXCFlags[i] := CommandList[i].flags;
  UNTIL i = 0;
END InitFlags;

BEGIN
  InitFlags;

END RxTest2.
