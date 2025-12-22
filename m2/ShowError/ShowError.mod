(*(*-------------------------------------------------------------------------
  :Program.    ModGen
  :Contents.   Displays Turbo Modula-2 errors in ARexx based Editors
  :Author.     Frank Lömker
  :Address.    E-Mail: floemker@techfak.uni-bielefeld.de
  :Copyright.  FreeWare
  :Language.   Modula-2
  :Translator. Turbo Modula-2 V1.40
  :History.    1.0 [Frank] 03-Oct-95
  :Bugs.       no known
-------------------------------------------------------------------------*)*)

MODULE ShowError;

IMPORT e:=Exec, d:=Dos{37}, i:=Intuition, r:=Rexx, a:=AmigaLib,
       s:=String (* , io:=StdIO *);
FROM M2Lib IMPORT _ErrorReq,malloc,free;
FROM SYSTEM IMPORT STRING,ADR,ADDRESS,LONGSET;

CONST Version="$VER: ShowError V1.0 (3.10.95) by Frank Lömker\n";
      ErrFile="t:Errors";
      ConfigFile="Modula:s/ShowError.config";
      PortName="SHOWERROR";
      ReplyName="ShowEReply";
      tempDos="PORT/K,QUIT/S,READ/S,FIRST/S,NEXT/S,PREV/S";
      tempRexx="PORT/K,QUIT/S,READ/S,FIRST/S,NEXT/S,PREV/S,LINE/S,COLUMN/S";
      errMem="Error: Not enough memory";
TYPE str60=ARRAY [0..60] OF CHAR;
     str255=ARRAY [0..255] OF CHAR;
     Pchars=POINTER TO ARRAY [1..MAX(LONGINT)] OF CHAR;
     ListPtr=POINTER TO List;
     List=RECORD
            next:ListPtr;
            zeile,spalte,size:INTEGER;
          END;
     Tconfig=RECORD
               buf:Pchars;
               len:LONGINT;
               port,text,line,col,notify:STRING;
               newport,multiline:BOOLEAN;
               width:INTEGER;
             END;
VAR rootL,aktErr:ListPtr;
    ioPort:e.MsgPortPtr;
    config:Tconfig;
    buffer:str60;
    replyCnt:INTEGER;

PROCEDURE Request (str,dat:STRING);
VAR easy:i.EasyStruct;
BEGIN
  easy:=[SIZE(i.EasyStruct),{},"ShowError",str,"OK"];
  i.EasyRequestArgs (NIL,ADR(easy),NIL,ADR(dat));
END Request;

PROCEDURE senden (reply:e.MsgPortPtr;repname,port,arg:STRING):BOOLEAN;
VAR RexxMsg:r.RexxMsgPtr;
    DestPort:e.MsgPortPtr;
BEGIN
  RexxMsg:=r.CreateRexxMsg (reply,NIL,repname);
  IF RexxMsg=NIL THEN
    Request ("Unable to create RexxMsg",NIL); RETURN FALSE;
  END;
  WITH RexxMsg^ DO
    rm_Args[0]:=r.CreateArgstring (arg,s.strlen(arg));
    IF rm_Args[0]=NIL THEN
      r.DeleteRexxMsg (RexxMsg);
      Request ("Unable to create RexxMsg",NIL);
      RETURN FALSE;
    END;
    rm_Action:=r.RXCOMM;
    rm_Node.mn_Node.ln_Name:="REXX";
  END;
  e.Forbid;
  DestPort:=e.FindPort (port);
  IF DestPort#NIL THEN
    e.PutMsg (DestPort,RexxMsg);
    e.Permit;
    INC (replyCnt);
  ELSE
    e.Permit;
    r.DeleteArgstring (RexxMsg^.rm_Args[0]);
    RexxMsg^.rm_Node.mn_Node.ln_Name:=NIL;
    r.DeleteRexxMsg (RexxMsg);
    Request ('Unable to find MessagePort "%s"',port);
    RETURN FALSE;
  END;
  RETURN TRUE;
END senden;

PROCEDURE sendText (msg,arg:STRING):BOOLEAN;
VAR copyProc:LONGCARD;
    liste:ListPtr;
    help:STRING;
    data:ARRAY [0..2] OF ADDRESS;
    length,nr,anz,pos:INTEGER;
    ok:BOOLEAN;
BEGIN
  copyProc:=16C04E75H; ok:=FALSE;
  WITH config DO
   IF text#NIL THEN
    length:=s.strlen(msg);
    help:=malloc (length+(length-1) DIV width+1);
    IF help=NIL THEN
      Request (errMem,NIL);
    ELSE
      s.strcpy (help,msg);
      IF length>width THEN
        IF multiline THEN
          anz:=(length-1) DIV width;
          FOR nr:=anz TO 1 BY -1 DO
            s.memmove (ADDRESS(help)+nr*width+1,ADDRESS(help)+nr*width,
                       length-nr*width+1);
            help^[nr*width]:="\n";
            INC (length);
          END;
        ELSE
          help^[width]:=0C;
        END;
      END;
      liste:=rootL; anz:=0; pos:=0;
      WHILE liste#NIL DO
        INC (anz);
        IF liste=aktErr THEN pos:=anz; END;
        liste:=liste^.next;
      END;
      nr:=0; length:=0; ok:=FALSE;
      WHILE (text^[nr]#0C) AND (length<3) DO
        IF text^[nr]="%" THEN
          REPEAT
            INC (nr);
          UNTIL (text^[nr]="%") OR (text^[nr]=0C) OR
                (text^[nr]="s") OR (text^[nr]="d");
          IF text^[nr]="s" THEN
            data[length]:=help;
            INC (length);
          ELSIF text^[nr]="d" THEN
            IF ok THEN data[length]:=anz
                  ELSE data[length]:=pos; END;
            INC (length); ok:=TRUE;
          ELSIF (text^[nr]="%") AND (text^[nr-1]="%") THEN INC (nr); END;
        ELSE INC (nr); END;
      END;
      e.RawDoFmt (text,ADR(data),PROC(ADR(copyProc)),arg);
      ok:=senden (ioPort,PortName,port,arg);
      free (help);
    END;
   END;
  END;
  RETURN ok;
END sendText;

PROCEDURE Fehler (msg:STRING);
VAR arg:STRING;
BEGIN
  IF config.port#NIL THEN
    arg:=malloc (s.strlen(config.text)+s.strlen(msg)+25);
    IF arg=NIL THEN
      Request (errMem,NIL);
    ELSE
      IF NOT sendText (msg,arg) THEN
        Request (msg,NIL);
      END;
      free (arg);
    END;
  END;
END Fehler;

PROCEDURE FileSize (dat:d.FileHandlePtr):LONGINT;
BEGIN
  d.Seek (dat,0,d.OFFSET_END);
  RETURN d.Seek (dat,0,d.OFFSET_BEGINNING);
END FileSize;

PROCEDURE LoadDat (name:STRING;VAR buf:Pchars;VAR len:LONGINT):BOOLEAN;
VAR dat:d.FileHandlePtr;
    anz:LONGINT;
    ok:BOOLEAN;
BEGIN
  ok:=FALSE;
  dat:=d.Open (name,d.MODE_OLDFILE);
  IF dat#NIL THEN
    len:=FileSize (dat);
    IF len>0 THEN
      INC (len);    (* 0C *)
      buf:=e.AllocMem (len,{});
      IF buf#NIL THEN
        anz:=d.Read (dat,buf,len-1);
        IF anz=len-1 THEN
          buf^[len]:=0C; ok:=TRUE;
        END;
      END;
    END;
    d.Close (dat);
  END;
  RETURN ok;
END LoadDat;

PROCEDURE LoadConfig (VAR config:Tconfig);
VAR SText:ARRAY [0..6] OF STRING;
    help:STRING;
    nr,stelle,length:INTEGER;
    start,found:BOOLEAN;
BEGIN
  SText:=["PORT","TEXT","LINE","COLUMN","NOTIFY","MULTILINE","WIDTH"];
  WITH config DO
    IF LoadDat (ConfigFile,buf,len) AND (len>12) THEN
      FOR nr:=0 TO 6 DO
        length:=s.strlen (SText[nr]);
        help:=ADDRESS(buf); start:=TRUE; found:=FALSE;
        REPEAT
          IF (help^[0]="\n") OR (help^[0]=0C) OR start THEN
            IF NOT start THEN help:=ADDRESS(ADDRESS(help)+1); END;
            start:=FALSE;
            stelle:=0;
            WHILE (stelle<length) AND (CAP(help^[stelle])=SText[nr]^[stelle]) DO
              INC (stelle);
            END;
            IF stelle=length THEN
              WHILE help^[stelle]=" " DO INC(stelle); END;
              IF help^[stelle]="=" THEN
                found:=TRUE;
                REPEAT INC (stelle); UNTIL help^[stelle]#" ";
              END;
            END;
          ELSE
            help:=ADDRESS(ADDRESS(help)+1);
          END;  (* IF (help^[0] *)
        UNTIL (ADDRESS(help)>ADDRESS(buf)+len-length) OR found;
        help:=ADDRESS(ADDRESS(help)+stelle);
        IF found AND (help^[0]#"\n") AND (help^[0]#0C) THEN
          CASE nr OF
            0: IF NOT newport THEN port:=help; END;
           |1: text:=help;
           |2: line:=help;
           |3: col:=help;
           |4: notify:=help;
           |5: IF (CAP(help^[0])="N") AND (CAP(help^[1])="O") THEN
                 multiline:=FALSE;
               ELSE multiline:=TRUE; END;
           |6: stelle:=0; width:=0;
               WHILE (help^[stelle]>="0") AND (help^[stelle]<="9") AND (width<1000) DO
                 width:=width*10+ORD(help^[stelle])-ORD("0");
                 INC (stelle);
               END;
               IF width<10 THEN width:=10
               ELSIF width>1000 THEN width:=1000; END;
          END;
          stelle:=0; length:=0;
          WHILE (help^[stelle]#"\n") AND (help^[stelle]#0C) DO
            IF (CAP(help^[stelle])="N") AND (help^[stelle-1]="\\") THEN
              INC (length);
              help^[stelle-length]:="\n";
            ELSE
              help^[stelle-length]:=help^[stelle];
            END;
            INC (stelle);
          END;
          help^[stelle-length]:=0C;
        END;  (* IF found *)
      END;  (* FOR nr *)
    ELSIF len#-1 THEN
      IF buf#NIL THEN e.FreeMem (buf,len); END;
      Request ('Unable to load "Modula:s/ShowError.config"',NIL);
    END;  (* IF LoadDat *)
  END;  (* WITH config *)
END LoadConfig;

PROCEDURE FreeErrors;
VAR help:ListPtr;
BEGIN
  WHILE rootL#NIL DO
    help:=rootL^.next; e.FreeMem (rootL,SIZE(List)+rootL^.size); rootL:=help;
  END;
END FreeErrors;

PROCEDURE GetError (buf:Pchars;len:LONGINT);
VAR nr,nr2,pos:LONGINT;
    spalte,zeile:INTEGER;
    msg:str255;
    akt,help:ListPtr;
BEGIN
  nr:=1;
  WHILE nr<len DO
    IF (buf^[nr]="\n") AND ((buf^[nr+1]="@") OR (buf^[nr+1]="^")) THEN
      INC (nr); nr2:=nr;
      WHILE (nr2<len) AND (buf^[nr2]#"\n") DO INC (nr2); END;
      IF (buf^[nr2]="\n") AND (buf^[nr2+1]="@") THEN
        spalte:=1;
        WHILE (buf^[nr+spalte-1]#"\n") AND (nr<len) DO
          IF buf^[nr+spalte-1]="^" THEN
            pos:=0; zeile:=0;
            WHILE buf^[nr2]#"m" DO INC (nr2); END; INC (nr2);
            WHILE (buf^[nr2]>="0") AND (buf^[nr2]<="9") DO
              zeile:=zeile*10+ORD(buf^[nr2])-ORD("0");
              INC (nr2);
            END;
            WHILE buf^[nr2]#"m" DO INC (nr2); END; INC (nr2);
            WHILE buf^[nr2]#"\n" DO
              IF buf^[nr2]=33C THEN
                WHILE buf^[nr2]#"m" DO INC (nr2); END;
              ELSE msg[pos]:=buf^[nr2]; INC (pos); END;
              INC (nr2);
            END;
            msg[pos]:=0C;
            akt:=e.AllocMem (SIZE(List)+pos+1,{});
            IF akt=NIL THEN
              Request (errMem,NIL);
              nr:=len;
            ELSE
              akt^.zeile:=zeile;
              akt^.spalte:=spalte;
              akt^.size:=pos+1;
              akt^.next:=NIL;
              e.CopyMem (ADR(msg),ADDRESS(akt)+SIZE(List),pos+1);
              IF rootL=NIL THEN rootL:=akt; help:=rootL;
              ELSE
                help^.next:=akt; help:=akt;
              END;
            END;
          END;  (* IF buf^[nr+spalte-1]="^" *)
          INC (spalte);
        END;  (* WHILE buf^[nr+spalte-1]#"\n" *)
      END;  (* IF buf^[nr2] *)
    END;  (* IF (buf^[nr]="\n") *)
    INC (nr);
  END;  (* WHILE nr<len *)
END GetError;

PROCEDURE ReadErrors():BOOLEAN;
VAR len:LONGINT;
    buf:Pchars;
    ok:BOOLEAN;
BEGIN
  ok:=FALSE; buf:=NIL;
  IF LoadDat (ErrFile,buf,len) THEN
    FreeErrors;
    GetError (buf,len);
    ok:=rootL#NIL;
    IF buf#NIL THEN e.FreeMem (buf,len); END;
  ELSE
    IF buf#NIL THEN e.FreeMem (buf,len); END;
    Fehler ('Unable to load "t:Errors"');
  END;
  RETURN ok;
END ReadErrors;

VAR msg:r.RexxMsgPtr;
    args:ARRAY [0..7] OF LONGINT; (* port,quit,read,first,next,prev,line,column *)
    rd:d.RDArgsPtr;
    nrequest:d.NotifyRequest;
    notify:BOOLEAN;

PROCEDURE ZeigError (getRes:BOOLEAN);
VAR copyProc:LONGCARD;
    arg:str255;
    dat:ARRAY [0..1] OF LONGINT;
    ok:BOOLEAN;
BEGIN
  IF getRes AND (msg^.rm_Result2=0) THEN
    msg^.rm_Result2:=ADDRESS(
      r.CreateArgstring (ADDRESS(ADDRESS(aktErr)+SIZE(List)),aktErr^.size-1));
  END;
  WITH config DO
    IF config.port#NIL THEN
      copyProc:=16C04E75H; ok:=TRUE;
      IF line#NIL THEN
        dat:=[aktErr^.zeile,aktErr^.spalte];
        e.RawDoFmt (line,ADR(dat),PROC(ADR(copyProc)),ADR(arg));
        ok:=senden (ioPort,PortName,port,arg);
      END;
      IF ok AND (col#NIL) THEN
        dat:=[aktErr^.spalte,aktErr^.zeile];
        e.RawDoFmt (col,ADR(dat),PROC(ADR(copyProc)),ADR(arg));
        ok:=senden (ioPort,PortName,port,arg);
      END;
      IF ok THEN
        ok:=sendText (ADDRESS(ADDRESS(aktErr)+SIZE(List)),arg);
      END;
    END;  (* IF config.port#NIL *)
  END;  (* WITH config *)
END ZeigError;

PROCEDURE HandleArgs (getRes:BOOLEAN):INTEGER;
VAR nr,anz,rc:INTEGER;
    help:ListPtr;
BEGIN
  rc:=0;
  IF (args[2]=d.DOSTRUE) THEN  (* read *)
    IF ReadErrors() THEN
      aktErr:=rootL; ZeigError (getRes);
    ELSE rc:=15; END;
  END;
  anz:=0;
  FOR nr:=3 TO 7 DO
    INC (anz,args[nr]);
  END;
  IF (anz#0) AND (rootL=NIL) THEN
    Fehler ("Error: No Errorfile loaded"); rc:=10;
  ELSE
    IF args[3]=d.DOSTRUE THEN  (* first *)
      aktErr:=rootL; ZeigError (getRes);
    END;
    IF args[4]=d.DOSTRUE THEN  (* next *)
      IF aktErr^.next#NIL THEN
        aktErr:=aktErr^.next; ZeigError (getRes);
      ELSE Fehler ("Error: No more errors"); rc:=5; END;
    END;
    IF args[5]=d.DOSTRUE THEN  (* prev *)
      IF aktErr#rootL THEN
        help:=rootL;
        WHILE help^.next#aktErr DO help:=help^.next; END;
        aktErr:=help;
        ZeigError (getRes);
      ELSE Fehler ("Error: No previous error"); rc:=5; END;
    END;
    IF getRes AND (msg^.rm_Result2=0) AND
       ((args[6]=d.DOSTRUE) OR (args[7]=d.DOSTRUE)) THEN
      IF args[6]=d.DOSTRUE THEN nr:=aktErr^.zeile; END;  (* line *)
      IF args[7]=d.DOSTRUE THEN nr:=aktErr^.spalte; END;  (* column *)
      buffer:="       "; anz:=7;
      REPEAT
        DEC (anz);
        buffer[anz]:=CHR(ORD("0")+nr MOD 10);
        nr:=nr DIV 10;
      UNTIL nr=0;
      msg^.rm_Result2:=ADDRESS(r.CreateArgstring (ADR(buffer[anz]),
                                                  s.strlen(buffer)-anz));
    END;
  END;  (* IF Error loaded *)
  FOR nr:=2 TO 7 DO
    args[nr]:=d.DOSFALSE;
  END;
  RETURN rc;
END HandleArgs;

PROCEDURE GetNewPort;
BEGIN
  IF args[0]#NIL THEN
    WITH config DO
      IF newport THEN free (port); END;
      port:=malloc (s.strlen (ADDRESS(args[0]))+1);
      s.strcpy (port,ADDRESS(args[0]));
      newport:=TRUE;
    END;
  END;
END GetNewPort;

PROCEDURE HandlePort;
VAR arg:str60;
    set,wset:LONGSET;
    nr:INTEGER;
BEGIN
  rd:=d.AllocDosObject (d.DOS_RDARGS,NIL);
  IF rd=NIL THEN _ErrorReq (" ","Not enough memory"); END;
  rd^.RDA_Flags:=d.RDAF_NOPROMPT;
  wset:=LONGSET{ioPort^.mp_SigBit,d.SIGBREAKB_CTRL_C};
  IF notify THEN INCL (wset,nrequest.nr_stuff.nr_Signal.nr_SignalNum); END;
  LOOP
    IF args[1]=d.DOSTRUE THEN EXIT; END;
    set:=e.Wait (wset);
    IF d.SIGBREAKB_CTRL_C IN set THEN
      EXIT;
    ELSIF (nrequest.nr_stuff.nr_Signal.nr_SignalNum IN set) AND notify THEN
      IF senden (ioPort,PortName,config.port,config.notify) THEN
        args[2]:=d.DOSTRUE;
        nr:=HandleArgs (FALSE);
      END;
    ELSIF ioPort^.mp_SigBit IN set THEN
      e.WaitPort (ioPort);
      msg:=e.GetMsg (ioPort);
      WHILE msg#NIL DO
        IF (msg^.rm_Node.mn_Node.ln_Type=e.NT_REPLYMSG) THEN
          IF msg^.rm_Args[0]#NIL THEN r.DeleteArgstring (msg^.rm_Args[0]); END;
          msg^.rm_Node.mn_Node.ln_Name:=NIL;
          r.DeleteRexxMsg (msg);
          DEC (replyCnt);
        ELSE
          IF msg^.rm_Args[0]#NIL THEN
            msg^.rm_Result1:=0; msg^.rm_Result2:=0;
            s.strncpy (arg,msg^.rm_Args[0],48);
            WITH rd^ DO
              RDA_Source.CS_Buffer:=ADR(arg);
              RDA_Source.CS_Length:=s.strlen(arg)+1;
              arg[RDA_Source.CS_Length-1]:=12C;
              arg[RDA_Source.CS_Length]:=0C;
              RDA_Source.CS_CurChr:=0;
              RDA_DAList:=NIL;
              RDA_Buffer:=NIL;
            END;
            args[0]:=0;
            IF d.ReadArgs(tempRexx,ADR(args),rd)#NIL THEN
              GetNewPort;
              d.FreeArgs (rd);
              msg^.rm_Result1:=HandleArgs (r.RXFB_RESULT IN LONGSET(msg^.rm_Action));
            ELSE
              msg^.rm_Result1:=20;
            END;
          END;
          e.ReplyMsg (msg);
        END;
        msg:=e.GetMsg (ioPort);
      END;  (* WHILE msg#NIL *)
    END;  (* ELSIF ioPort^.mp_SigBit IN set *)
  END;  (* LOOP *)
END HandlePort;

VAR argstr:ARRAY [1..5] OF STRING;
    nr:INTEGER;
    signal:SHORTINT;
BEGIN
  rootL:=NIL; aktErr:=NIL; ioPort:=NIL; replyCnt:=0;
  signal:=-1; notify:=FALSE; rd:=NIL;
  config:=[NIL,-1,NIL,NIL,NIL,NIL,NIL,FALSE,FALSE,255];
  args[0]:=0;
  rd:=d.ReadArgs (tempDos,ADR(args),NIL);
  IF rd#NIL THEN
    GetNewPort;
    d.FreeArgs (rd); rd:=NIL;
  ELSE
    d.Fault (d.IoErr(),NIL,buffer,SIZE(buffer));
    _ErrorReq (" ",buffer);
  END;
  ioPort:=e.FindPort (PortName);
  IF ioPort=NIL THEN
    ioPort:=a.CreatePort (PortName,0);
    IF ioPort=NIL THEN _ErrorReq (" ","Unable to open MsgPort"); END;
    LoadConfig (config);
    IF (config.port#NIL) AND (config.notify#NIL) THEN
      signal:=e.AllocSignal (-1);
      IF signal=-1 THEN
        Request ("Unable to get signal\nNotify not possible",NIL)
      ELSE
        WITH nrequest DO
          nr_Name:=ErrFile;
          nr_Flags:=d.NRF_SEND_SIGNAL;
          nr_stuff.nr_Signal.nr_Task:=e.FindTask (NIL);
          nr_stuff.nr_Signal.nr_SignalNum:=signal;
        END;
        notify:=d.StartNotify (ADR(nrequest));
        IF NOT notify THEN
          Request ("Notify not possible",NIL);
          e.FreeSignal (signal);
          signal:=-1;
        END;
      END;
    END;
    nr:=HandleArgs (FALSE);
    HandlePort;
  ELSE
    ioPort:=a.CreatePort (ReplyName,0);
    IF ioPort=NIL THEN _ErrorReq (" ","Unable to open MsgPort"); END;
    IF config.port#NIL THEN
      buffer:='PORT "'; s.strcat(buffer,config.port);
      s.strcat(buffer,'" ');
    ELSE
      buffer:="";
    END;
    argstr:=["QUIT ","READ ","FIRST ","NEXT ","PREV "];
    FOR nr:=1 TO 5 DO
      IF args[nr]=d.DOSTRUE THEN s.strcat(buffer,argstr[nr]); END;
    END;
    IF senden (ioPort,ReplyName,PortName,buffer) THEN END;
  END;  (* IF ioPort#NIL *)
CLOSE
  IF config.buf#NIL THEN e.FreeMem (config.buf,config.len); END;
  FreeErrors;
  IF notify THEN d.EndNotify (ADR(nrequest)); notify:=FALSE; END;
  IF signal#-1 THEN
    e.FreeSignal (signal); signal:=-1;
  END;
  IF rd#NIL THEN d.FreeDosObject (d.DOS_RDARGS,rd); rd:=NIL; END;
  IF ioPort#NIL THEN
    e.RemPort (ioPort);
    WHILE replyCnt>0 DO
      e.WaitPort (ioPort);
      msg:=e.GetMsg (ioPort);
      WHILE msg#NIL DO
        IF (msg^.rm_Node.mn_Node.ln_Type=e.NT_REPLYMSG) THEN
          IF msg^.rm_Args[0]#NIL THEN r.DeleteArgstring (msg^.rm_Args[0]); END;
          msg^.rm_Node.mn_Node.ln_Name:=NIL;
          r.DeleteRexxMsg (msg);
          DEC (replyCnt);
        ELSE
          e.ReplyMsg (msg);
        END;
        msg:=e.GetMsg (ioPort);
      END;
    END;  (* WHILE *)
    e.Forbid;
    msg:=e.GetMsg (ioPort);
    WHILE msg#NIL DO
      e.ReplyMsg (msg);
      msg:=e.GetMsg (ioPort);
    END;
    a.DeletePort (ioPort);
    e.Permit;
    ioPort:=NIL;
  END;
END ShowError.
