MODULE AShell;

IMPORT
  io,
  E   : Exec,
  ER  : EasyRexx,
  U   : Utility,
  I   : Intuition,
  R   : Rexx,
  sys : SYSTEM;

CONST
  HelloWorld   = "Hello World! :)";
  ErrorMessage = "Error: Because you asked for it ;)";

  clear  =  1;
  getvar =  2;
  help   =  3;
  open   =  4;
  quit   =  5;
  row    =  6;
  save   =  7;
  text   =  8;
  rx     =  9;
  causeerror = 10;

PROCEDURE myHandleARexx(c : ER.ARexxContextPtr) : BOOLEAN;

VAR
  done : BOOLEAN;
  resultString,
  error : E.STRPTR;
  result1 : LONGINT;
  errTag,resTag : U.TagID;
  args : ARRAY 3 OF E.APTR;

  argString : E.STRPTR;

BEGIN
  done:=FALSE;
  result1:=R.ok;
  IF ER.GetARexxMsg(c) THEN
    io.WriteString("Received: ");
    CASE c.id OF
      clear  : io.WriteString("CLEAR");
               IF ER.Arg(c,0) # NIL THEN
                 io.WriteString(" FORCE=on");
               END;
     |getvar : io.WriteString("GETVAR");
               IF ER.Arg(c,0) # NIL THEN
                 io.WriteString(" HELLOWORLD");
                 resultString:=sys.ADR(HelloWorld);
               END;
     |help   : io.WriteString("HELP");
               IF ER.Arg(c,0) # NIL THEN
                 io.WriteString(" AMIGAGUIDE");
               END;
               IF ER.Arg(c,1) # NIL THEN
                 argString:=ER.ArgString(c,1);
                 io.Format(" TOPIC=%s",sys.ADR(argString));
               END;
     |open   : io.WriteString("OPEN");
               IF ER.Arg(c,1) # NIL THEN
                 io.WriteString(" TEXT");
               ELSE
                 io.WriteString(" PROJECT");
               END;
               IF ER.Arg(c,2) # NIL THEN
                 argString:=ER.ArgString(c,2);
                 io.Format(" '%s'",sys.ADR(argString));
               END;
     |quit   : io.WriteString("QUIT");
               done:=TRUE;
     |row    : io.WriteString("ROW");
               IF ER.Arg(c,0) # NIL THEN
(* Watch out : No sys.ADR(...) here ! *)
                 io.Format(" %ld",ER.ArgNumber(c,0));
               END;
     |save   : io.WriteString("SAVE");
               IF ER.Arg(c,0) # NIL THEN
                 io.WriteString(" AS");
               END;
               IF ER.Arg(c,1) # NIL THEN
                 argString:=ER.ArgString(c,1);
                 io.Format(" '%s'",sys.ADR(argString));
               END;
     |text   : io.WriteString("TEXT");
               IF ER.Arg(c,0) # NIL THEN
                 argString:=ER.ArgString(c,0);
                 io.Format(" '%s'",sys.ADR(argString));
               END;
     |rx     : args[0]:=ER.ArgString(c,0);
               args[1]:=ER.ArgString(c,0);
               args[2]:=c.portName;
               io.Format("RX '%s'\n* Sending command asynchronously: '%s' to the '%s' port",sys.ADR(args));
               IF ER.SendARexxCommand(ER.ArgString(c,0),ER.Port,c.port,
                                                     ER.Context,c,
                                                     ER.Asynch,1,
                                                     U.done) # 0 THEN END;
     |causeerror : io.WriteString("CAUSEERROR");
                   error:=sys.ADR(ErrorMessage);
                   result1:=R.error;
    END;
    IF error # NIL THEN
      errTag:=ER.ErrorMessage;
    ELSE
      errTag:=U.ignore;
    END;
    IF resultString # NIL THEN
      resTag:=ER.ResultString;
    ELSE
      resTag:=U.ignore;
    END;
    ER.ReplyARexxMsg(c,ER.ReturnCode,result1,
                       errTag,error,
                       resTag,resultString,
                       U.done);
    io.WriteLn;
  END;
  RETURN done;
END myHandleARexx;

VAR
  context : ER.ARexxContextPtr;
  signals : LONGSET;
  done    : BOOLEAN;
  table   : ARRAY 11 OF ER.ARexxCommandTable;

BEGIN
  table[0].id         :=clear;
  table[0].command    :=sys.ADR("CLEAR");
  table[0].cmdTemplate:=sys.ADR("FORCE/S");
  table[0].userData   :=NIL;

  table[1].id         :=getvar;
  table[1].command    :=sys.ADR("GETVAR");
  table[1].cmdTemplate:=sys.ADR("HELLOWORLD/S");
  table[1].userData   :=NIL;

  table[2].id         :=help;
  table[2].command    :=sys.ADR("HELP");
  table[2].cmdTemplate:=sys.ADR("AMIGAGUIDE/S,TOPIC/F");
  table[2].userData   :=NIL;

  table[3].id         :=open;
  table[3].command    :=sys.ADR("OPEN");
  table[3].cmdTemplate:=sys.ADR("PROJECT/S,TEXT/S,NAME/F");
  table[3].userData   :=NIL;

  table[4].id         :=quit;
  table[4].command    :=sys.ADR("QUIT");
  table[4].cmdTemplate:=sys.ADR("");
  table[4].userData   :=NIL;

  table[5].id         :=row;
  table[5].command    :=sys.ADR("ROW");
  table[5].cmdTemplate:=sys.ADR("NUMBER/A/N");
  table[5].userData   :=NIL;

  table[6].id         :=save;
  table[6].command    :=sys.ADR("SAVE");
  table[6].cmdTemplate:=sys.ADR("AS/S,NAME/F");
  table[6].userData   :=NIL;

  table[7].id         :=text;
  table[7].command    :=sys.ADR("TEXT");
  table[7].cmdTemplate:=sys.ADR("TEXT/A/F");
  table[7].userData   :=NIL;

  table[8].id         :=rx;
  table[8].command    :=sys.ADR("RX");
  table[8].cmdTemplate:=sys.ADR("COMMAND/A/F");
  table[8].userData   :=NIL;

  table[9].id         :=causeerror;
  table[9].command    :=sys.ADR("CAUSEERROR");
  table[9].cmdTemplate:=sys.ADR("");
  table[9].userData   :=NIL;

  table[10].id         :=NIL;
  table[10].command    :=NIL;
  table[10].cmdTemplate:=NIL;
  table[10].userData   :=NIL;

  IF ER.base # NIL THEN
    context:=ER.AllocARexxContext(ER.CommandTable, sys.ADR(table),
                                  ER.Author,sys.ADR("Ketil Hunn"),
                                  ER.Copyright,sys.ADR("© 1995 Ketil Hunn"),
                                  ER.Version,sys.ADR("2"),
                                  ER.PortName,sys.ADR("EASYREXX_Test"),
                                  U.done);
    IF context # NIL THEN
      IF ER.OpenARexxCommandShell(context,I.waTitle,sys.ADR("AREXX Commandline Interface"),
                                   I.waLeft,0,
                                   I.waWidth,320,
                                   I.waHeight,100,
                                   I.waDragBar,1,
                                   I.waDepthGadget,1,
                                   I.waSizeGadget,1,
                                   I.waCloseGadget,1,
                                   I.waMinWidth,50,
                                   I.waMinHeight,50,
                                   I.waMaxWidth,-1,
                                   I.waMaxHeight,-1,
                                   I.waSizeBBottom,1,
                                   U.done) THEN END;
      done:=FALSE;
      REPEAT
        signals:=E.Wait(ER.Signal(context));
        ER.SetSignals(context,signals);
        IF (signals * ER.Signal(context) # LONGSET{}) THEN
          done:=myHandleARexx(context);
        END;
      UNTIL done;
      ER.FreeARexxContext(context);
    END;
  ELSE
    IF I.DisplayAlert(0,"\x00\x64\x14missing easyrexx.library \o\o",50) THEN END;
  END;
END AShell.
