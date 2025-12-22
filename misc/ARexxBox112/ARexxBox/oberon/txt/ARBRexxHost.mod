(*************************************************************************

:Program.    ARBRexxHost.mod
:Contents.   simple rexx interface for use with ARexxBox
:Author.     Hartmut Goebel [hG]
:Copyright.  Copyright © 1990 by Hartmut Goebel
:Copyright.  original 'C' definitions copyright © 1990 by Michael Balzer
:Language.   Oberon-2
:Translator. Amiga Oberon V3.01
:History.    V1.0, 31 Aug 1992 [hG]
:History.    V1.02 24 Oct 1992 [hG]
:Date.       25 Dec 1992 17:40:11

*************************************************************************)

(* $StackChk- $NilChk- $RangeChk- $CaseChk- $OvflChk- $ReturnChk- $ClearVars- *)

MODULE ARBRexxHost;

IMPORT
  BT := BasicTypes,
  e  := Exec,
  d  := Dos,
  ms := MoreStrings,
  pf := Printf,
  rx := Rexx,
  rxs:= RexxSysLib,
  rxh:= RexxHost,
  y  := SYSTEM,
  str:= Strings;

TYPE
  RexxHost * = POINTER TO RexxHostDesc;
  RexxHostDesc * = RECORD (rxh.RexxHost)
    rdargs   -: d.RDArgsPtr;
    flags    *: LONGSET;
    userdata *: e.APTR;
  END;

CONST
  (* RexxHost.flags *)
  cmdShell * = 0;

TYPE
  ResLong        * = POINTER TO ARRAY 1 OF LONGINT;
  ResLongArray   * = POINTER TO ARRAY OF LONGINT;
  ResBool        * = LONGINT;
  ResString      * = BT.DynString;
  ResStringArray * = POINTER TO ARRAY OF ResString;

  (* these are UNTRACED 'cause allocated by DOS *)
  ArgLong        * = UNTRACED POINTER TO ARRAY 1 OF LONGINT;
  ArgLongArray   * = UNTRACED POINTER TO ARRAY d.maxMultiArgs OF ArgLong;
  ArgBool        * = LONGINT;
  ArgString      * = e.STRPTR;
  ArgStringArray * = UNTRACED POINTER TO ARRAY d.maxMultiArgs OF ArgString;

CONST
  (* better check for # LFALSE then = LTRUE due to AmigaDOS reasons *)
  LFALSE * = d.DOSFALSE;
  LTRUE  * = d.DOSTRUE;

TYPE
  RXDPtr * = POINTER TO RXD;
  RXD * = RECORD
    rc *, rc2 *: LONGINT;
  END;

CONST
  (* Die Msg-Typen für die Interfacefunktionen *)
  init   * = 1;
  action * = 2;
  free   * = 3;

TYPE
  HostFunction * = PROCEDURE (    host: RexxHost;
                              VAR data: RXDPtr;
                                  action: INTEGER);

  CommandPtr * = UNTRACED POINTER TO Command;
  Command * = STRUCT
    command *, args *, results *: e.STRPTR;
    resindex *: LONGINT;
    function *: HostFunction;
    flags    *: LONGSET;
  END;

CONST
  (* Command.flags *)
  enabled  * = 0;

  (* error codes and texts *)
  (* change it to your needs *)
  CommandDisabled * = "Command disabled";
  CantSetVar * = "Unable to set Rexx variable";

  errorNoFreeStore * = rx.err10003;
  errorNotImplemented * = rx.err10015;

TYPE
  StemNodePtr * = POINTER TO StemNode;
  StemNode = STRUCT
    succ -: StemNodePtr;
    name -, value -: BT.DynString;
  END;

PROCEDURE (host: RexxHost) Uninit *;
BEGIN
  IF host.rdargs # NIL THEN
    d.FreeDosObject(d.rdArgs, host.rdargs);
  END;
  host.Uninit^();
END Uninit;


PROCEDURE Init * (host: RexxHost;
                  basename: e.STRPTR; (* $CopyArrays- *)
                  default: ARRAY OF CHAR;
                  extension: ARRAY OF CHAR): BOOLEAN;
BEGIN
  IF rxh.Init(host^,basename,default,extension) THEN
    host.rdargs := d.AllocDosObject(d.rdArgs,NIL);
    IF host.rdargs = NIL THEN
      host.Uninit;
      RETURN FALSE;
    END;

    host.rdargs.flags := LONGSET{d.noPrompt};
    RETURN TRUE;
  END;
  RETURN FALSE;
END Init;


PROCEDURE (host: RexxHost) FindCommand * (com: ARRAY OF CHAR): INTEGER;
BEGIN HALT(20); END FindCommand;


PROCEDURE (host: RexxHost) ParseCommand * (VAR arg: e.STRPTR): INTEGER;
VAR
  com: e.STRING;
  i: INTEGER;
BEGIN
  i := 0;
  LOOP
    IF i >= SIZE(com) THEN EXIT; END;
    CASE arg[i] OF
    CHR(0), " ", "\n": EXIT;
    ELSE END;
    com[i] := arg[i]; INC(i);
  END;
  com[i] := CHR(0);
  WHILE arg[i] = " " DO INC(i); END;
  arg := y.ADR(arg[i]);
  RETURN host.FindCommand(com);
END ParseCommand;

TYPE
  DoubleStr = ARRAY 512 OF CHAR;
  DoubleStrPtr = UNTRACED POINTER TO DoubleStr;


PROCEDURE (rxh: RexxHost) HandleShellCommand * (comline: ARRAY OF CHAR;
                                              fhout: d.FileHandlePtr);
BEGIN HALT(20) END HandleShellCommand;


PROCEDURE (host: RexxHost) CommandShell * (fhin, fhout: d.FileHandlePtr;
                                          prompt: ARRAY OF CHAR);
VAR
  i : INTEGER;
  in: DoubleStrPtr;
  rm: rx.RexxMsgPtr;
  comLine: DoubleStr;
BEGIN
  IF fhin = NIL THEN
    RETURN; END;
  INCL(host.flags,cmdShell); (* auf diesem Port läuft eine CommandShell *)

  REPEAT
    IF (fhout # NIL) & (prompt # "") (* Prompt ausgeben *)
      & d.FPuts(fhout, prompt) THEN END;

    in := d.FGets(fhin, comLine, SIZE(comLine));
    IF in # NIL THEN
      i := 0;
      WHILE (i < SIZE(comLine)) & ((in[0] = " ") OR (in[0] = "\t")) DO
        INC(i); in := y.ADR(in[1]); END;
      IF (i < SIZE(comLine)) & (in[0] # "\n") THEN
        host.HandleShellCommand( in^, fhout ); END;
    ELSE
      EXCL(host.flags,cmdShell); (* CommandShell Ende *)
    END;

    (* Port des Hosts leeren (asynchrone Replies) *)
    LOOP
      rm := e.GetMsg(host.port);
      IF rm = NIL THEN EXIT; END;
      IF rm.node.node.type = e.replyMsg THEN (* Reply? *)
        host.FreeCommand(rm);
        DEC(host.replies);
      (* sonst Kommando . Fehler *)
      ELSE
        host.ReplyMsg( rm, -20, y.ADR("CommandShell Port"), NIL );
      END;
    END;
  UNTIL ~(cmdShell IN host.flags);
END CommandShell;

(* ---------------------------------------------------------------- *)
(* --- methods and procs for STEM and VAR handling  --------------- *)

(* Diese Funktion setzt aus der StemListe (s.u.) eine einzelne Variable
 * zusammen indem sie alle Resultate durch Spaces getrennt hintereinanderkopiert.
 *)
PROCEDURE CreateVAR * (stem: StemNodePtr): BT.DynString;
VAR
  var: BT.DynString;
  sn: StemNodePtr;
  size: LONGINT;
BEGIN
  IF (stem = NIL) THEN RETURN NIL; END;
  size := 0;
  sn := stem;
  REPEAT
    INC(size,str.Length(sn.value^)+1);
    sn := sn.succ;
  UNTIL sn = NIL;
  y.ALLOCATE(var,size+1);
  IF (var = NIL) THEN RETURN NIL END;
  var^ := "";
  sn := stem;
  REPEAT
    str.Append(var^,sn.value^);
    IF sn.succ # NIL THEN
      str.AppendChar(var^," "); END;
    sn := sn.succ;
  UNTIL sn = NIL;
  RETURN var;
END CreateVAR;


PROCEDURE FreeStemList * (VAR first: StemNodePtr);
(* $IF GarbageCollector *)
BEGIN
  first := NIL;
(* $ELSE *)
VAR
  next: StemNodePtr;
BEGIN
  WHILE first # NIL DO
    next := first.succ;
    DISPOSE(first.name);
    DISPOSE(first.value);
    DISPOSE(first);
    first := next;
  END;
(* $END *)
END FreeStemList;


(* Diese Funktion generiert die StemListe anhand der
 * Resultate und der Resultatschablone des Kommandos
 *)
PROCEDURE CreateSTEM * (rxc: CommandPtr;
                   resarray: UNTRACED POINTER TO ARRAY MAX(INTEGER) OF LONGINT;
                   stembase: e.STRPTR): StemNodePtr;
VAR
  first, old, new: StemNodePtr;
  rs, rb, t, wordCnt: INTEGER;
  optn, optm: BOOLEAN;
  longbuff: ARRAY 16 OF CHAR;
  resb: ARRAY 512 OF CHAR;
CONST
  ResLongWords = SIZE(ResLong) DIV SIZE(LONGINT);
  DynStrWords  = SIZE(BT.DynString) DIV SIZE(LONGINT);
TYPE
  ValueDummy = UNTRACED POINTER TO ValueDummyDesc;
  ValueDummyDesc = STRUCT END;
  NumValue = STRUCT (d: ValueDummyDesc)
    num: ResLong;
  END;
  StringValue = STRUCT (d: ValueDummyDesc)
    str: BT.DynString;
  END;

  PROCEDURE NewStemNode (): StemNodePtr;
  VAR
    new: StemNodePtr;
  BEGIN
    y.ALLOCATE(new);
    IF new = NIL THEN RETURN NIL; END;
    IF old # NIL THEN
      old.succ := new; old := new;
    ELSE
      first := new; old := new;
    END;
    RETURN new;
  END NewStemNode;

  PROCEDURE GetValue (value: ValueDummy; deref: BOOLEAN; VAR cnt: INTEGER): BT.DynString;
  (* deref tells, wether /N are ResLong or LONGINT *)
  TYPE
    SingleNumValue = STRUCT (d: ValueDummyDesc)
      num: LONGINT;
    END;
  BEGIN
    IF optn THEN (* numerisch *)
      IF ~ deref THEN (* direkt values, no pointers *)
        INC(cnt);
        pf.SPrintf1( longbuff, "%ld", value(SingleNumValue).num);
      ELSE
        INC(cnt,ResLongWords);
        pf.SPrintf1( longbuff, "%ld", value(NumValue).num^[0]);
      END;
      RETURN ms.CopyString(longbuff);
    ELSE (* string *)
      INC(cnt,DynStrWords);
      RETURN ms.CopyString(value(StringValue).str^);
    END;
  END GetValue;

  PROCEDURE CreateResultList(value: ValueDummy): BOOLEAN;
  VAR
    mWordCnt, index: INTEGER;
    len: LONGINT;
    countnd: StemNodePtr;
    tt: e.STRPTR;
  TYPE
    LArrayVal = UNTRACED POINTER TO STRUCT (d: ValueDummyDesc)
      arr: UNTRACED POINTER TO ARRAY OF ResLong;
    END;
    DStrArrayVal = UNTRACED POINTER TO STRUCT (d: ValueDummyDesc)
      arr: UNTRACED POINTER TO ARRAY OF BT.DynString;
    END;
    WordValue = UNTRACED POINTER TO STRUCT (d: ValueDummyDesc)
      arr: ARRAY MAX(INTEGER) OF LONGINT;
    END;

  BEGIN
    tt := y.ADR(resb[t]);
    INC(wordCnt);
    new := NewStemNode(); (* Node für die Anzahl der Elemente erzeugen *)
    IF new = NIL THEN     (* ausgefüllt wird sie erst nach dem Listenbau! *)
      RETURN FALSE; END;
    countnd := new;
    IF optn THEN len := LEN(value(LArrayVal).arr^);
    ELSE len := LEN(value(DStrArrayVal).arr^);
    END;
    index := 0; mWordCnt := 0;
    WHILE index < len DO
      new := NewStemNode();
      IF new = NIL THEN
        RETURN FALSE; END;
      pf.SPrintf1( tt^, ".%ld", index); (* Index an den Stem-Namen anhängen *)
      new.name := ms.CopyString(resb);
      new.value := GetValue(y.ADR(value(WordValue).arr[mWordCnt]),FALSE,mWordCnt);
      INC(index);
    END;
    tt^ := ".COUNT"; (* Die Count-Node (erste, s.o.) ausfüllen *)
    countnd.name := ms.CopyString( resb );
    pf.SPrintf1( longbuff, "%ld", index );
    countnd.value := ms.CopyString( longbuff );
  END CreateResultList;

  PROCEDURE isResultHere (value: ValueDummy; VAR cnt: INTEGER): BOOLEAN;
  BEGIN
    IF optn & (value(NumValue).num = NIL) THEN
      INC(cnt,ResLongWords);
      RETURN FALSE;
    ELSIF (value(StringValue).str = NIL) THEN
      INC(cnt,DynStrWords);
      RETURN FALSE;
    END;
    RETURN TRUE;
  END isResultHere;

BEGIN
  first := NIL; old := NIL;
  wordCnt := 0;
  IF stembase # NIL THEN (* Präfix einbauen *)
    COPY(stembase^,resb); rb := SHORT(str.Length(resb));
  ELSE
    resb := ""; rb := 0;
  END;
  rs := 0;

  (* Liste aufbauen *)
  WHILE rxc.results[rs] # CHR(0) DO
    t := rb; optn := FALSE; optm := FALSE;
    WHILE (rxc.results[rs] # CHR(0)) & (rxc.results[rs] # ",") DO
      IF rxc.results[rs] = "/" THEN
        INC(rs);
        CASE rxc.results[rs] OF
          "N": optn := TRUE;
        | "M": optm := TRUE;
        ELSE END;
      ELSE
        resb[t] := CAP(rxc.results[rs]); INC(t); (* Resultatnamen kopieren *)
      END;
      INC(rs);
    END;
    IF rxc.results[rs] = "," THEN INC(rs); END;
    resb[t] := CHR(0);

    (* hier ist nun der Basisname der Stem-Variable in resb,
     * und t zeigt in resb auf die Stelle, an der nun ggf. die
     * Stem-Erweiterungen (.COUNT, .0 - .n) angehängt werden
     *)
    IF optm THEN (* /M war im Namen, also Liste *)
      IF ~ CreateResultList(y.ADR(resarray[wordCnt])) THEN
        FreeStemList(first);
        RETURN NIL;
      END;
    ELSE (* keine Liste *)
      IF isResultHere(y.ADR(resarray[wordCnt]),wordCnt) THEN
        new := NewStemNode();
        IF new = NIL THEN
          FreeStemList(first);
          RETURN NIL;
        END;
        new.name := ms.CopyString(resb);
        new.value := GetValue(y.ADR(resarray[wordCnt]),TRUE,wordCnt);
      END;
    END;
  END;
  RETURN first;
END CreateSTEM;

END ARBRexxHost.

