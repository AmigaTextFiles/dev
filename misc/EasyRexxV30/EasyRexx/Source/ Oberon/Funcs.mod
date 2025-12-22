MODULE Funcs;

IMPORT
  io,
  ER  : EasyRexx,
  E   : Exec,
  U   : Utility,
  I   : Intuition,
  R   : Rexx,
  sys : SYSTEM;

CONST
  HelloWorld   = "Hello World! :)";
  ErrorMessage = "Error : Because you asked for it ;)";

  clear  = 1;
  getvar = 2;
  help   = 3;
  open   = 4;
  quit   = 5;
  row    = 6;
  save   = 7;
  text   = 8;
  rx     = 9;
  causeerror = 10;

TYPE
  ARexxRetValues = STRUCT
                     result,
                     resultLong : LONGINT;
                     resultString,
                     error      : E.STRPTR;
                   END;

  Func = PROCEDURE (c : ER.ARexxContextPtr) : E.BYTE;

VAR
  myReturn  : ARexxRetValues;
  argString : E.STRPTR;

PROCEDURE arexxfuncCLEAR(c : ER.ARexxContextPtr) : E.BYTE;

BEGIN
  io.WriteString("CLEAR");
  IF ER.Arg(c,0) # NIL THEN
    io.WriteString(" FORCE=on");
  END;
  RETURN R.ok;
END arexxfuncCLEAR;

PROCEDURE arexxfuncGETVAR(c : ER.ARexxContextPtr) : E.BYTE;

BEGIN
  io.WriteString("GETVAR");
  IF ER.Arg(c,0) # NIL THEN
    io.WriteString(" HELLOWORLD\n* string returned");
    myReturn.resultString:=sys.ADR(HelloWorld);
  END;
  RETURN R.ok;
END arexxfuncGETVAR;

PROCEDURE arexxfuncHELP(c : ER.ARexxContextPtr) : E.BYTE;

BEGIN
  io.WriteString("HELP");
  IF ER.Arg(c,0) # NIL THEN
    io.WriteString(" AMIGAGUIDE");
  END;
  IF ER.Arg(c,1) # NIL THEN
    argString:=ER.ArgString(c,1);
    io.Format(" TOPIC=%s", sys.ADR(argString));
  END;
  RETURN R.ok;
END arexxfuncHELP;

PROCEDURE arexxfuncOPEN(c : ER.ARexxContextPtr) : E.BYTE;

BEGIN
  io.WriteString("OPEN");
  IF ER.Arg(c,1) # NIL THEN
    io.WriteString(" TEXT");
  ELSE
    io.WriteString(" PROJECT");
  END;
  IF ER.Arg(c,2) # NIL THEN
    argString:=ER.ArgString(c,2);
    io.Format(" '%s'", sys.ADR(argString));
  END;
  RETURN R.ok;
END arexxfuncOPEN;

PROCEDURE arexxfuncQUIT(c : ER.ARexxContextPtr) : E.BYTE;

BEGIN
  io.WriteString("QUIT");
  RETURN -1;
END arexxfuncQUIT;

PROCEDURE arexxfuncROW(c : ER.ARexxContextPtr) : E.BYTE;

BEGIN
  io.WriteString("ROW");
  IF ER.Arg(c,0) # NIL THEN
    io.Format(" %ld", ER.ArgNumber(c,0));
  END;
  RETURN R.ok;
END arexxfuncROW;

PROCEDURE arexxfuncSAVE(c : ER.ARexxContextPtr) : E.BYTE;

BEGIN
  io.WriteString("SAVE");
  IF ER.Arg(c,0) # NIL THEN
    io.WriteString(" AS");
  END;
  IF ER.Arg(c,1) # NIL THEN
    argString:=ER.ArgString(c,1);
    io.Format(" '%s'",sys.ADR(argString));
  END;
  RETURN R.ok;
END arexxfuncSAVE;

PROCEDURE arexxfuncTEXT(c : ER.ARexxContextPtr) : E.BYTE;

BEGIN
  io.WriteString("TEXT");
  IF ER.Arg(c,0) # NIL THEN
    argString:=ER.ArgString(c,0);
    io.Format(" '%s'", sys.ADR(argString));
  END;
  RETURN R.ok;
END arexxfuncTEXT;

PROCEDURE arexxfuncRX(c : ER.ARexxContextPtr) : E.BYTE;

VAR
  args : ARRAY 3 OF E.STRPTR;

BEGIN
  args[0]:=ER.ArgString(c,0);
  args[1]:=ER.ArgString(c,0);
  args[2]:=c.portName;
  io.Format("RX '%s'\n* Sending command asynchronously: '%s' to the '%s' port",sys.ADR(args));
  IF ER.SendARexxCommand(ER.ArgString(c,0),ER.Port,c.port,
                                          ER.Context,c,
                                          ER.Asynch,1,
                                          U.done) # 0 THEN END;
  RETURN R.ok;
END arexxfuncRX;

PROCEDURE arexxfuncCAUSEERROR(c : ER.ARexxContextPtr) : E.BYTE;

BEGIN
  io.WriteString("CAUSEERROR");
  myReturn.error:=sys.ADR(ErrorMessage);
  RETURN R.error;
END arexxfuncCAUSEERROR;

PROCEDURE myHandleARexx(c : ER.ARexxContextPtr) : BOOLEAN;

VAR
  i    : E.ULONG;
  func : Func;
  exit : BOOLEAN;

  returnCode : LONGINT;
  errTag,resTag,resLongTag : U.TagID;

(* This one`s necessary for some evil type-casting [vs] *)
  res : SHORTINT;

BEGIN
  myReturn.result      :=R.ok;
  myReturn.resultLong  :=NIL;
  myReturn.resultString:=NIL;
  myReturn.error       :=NIL;
  IF ER.GetARexxMsg(c) THEN
    i:=0;
    io.WriteString("Received: ");
    exit:=FALSE;
    WHILE (c.table[i].command # NIL) AND ~exit DO
      IF c.table[i].id = c.id THEN
        func:=sys.VAL(Func,c.table[i].userData);
        IF func # NIL THEN
          res:=func(c);
(* This one extends the SHORTINT to INTEGER & LONGINT ;) *)
          myReturn.result:=LONG(LONG(res));
        END;
        exit:=TRUE;
      ELSE
        INC(i);
      END;
    END;
    IF myReturn.error # NIL THEN
      errTag:=ER.ErrorMessage;
    ELSE
      errTag:=U.ignore;
    END;
    IF myReturn.resultLong # 0 THEN
      resLongTag:=ER.ResultLong;
    ELSE
      resLongTag:=U.ignore;
    END;
    IF myReturn.resultString # NIL THEN
      resTag:=ER.ResultString;
    ELSE
      resTag:=U.ignore;
    END;
    ER.ReplyARexxMsg(c,ER.ReturnCode,myReturn.result,
                       errTag,myReturn.error,
                       resLongTag,myReturn.resultLong,
                       resTag,myReturn.resultString,
                       U.done);
    io.WriteLn;
  END;
  RETURN (myReturn.result = -1);
END myHandleARexx;

VAR
  done    : BOOLEAN;
  context : ER.ARexxContextPtr;
  signals : LONGSET;
  table   : ARRAY 11 OF ER.ARexxCommandTable;

BEGIN
  table[0].id         :=clear;
  table[0].command    :=sys.ADR("CLEAR");
  table[0].cmdTemplate:=sys.ADR("FORCE/S");
  table[0].userData   :=sys.VAL(E.APTR,arexxfuncCLEAR);

  table[1].id         :=getvar;
  table[1].command    :=sys.ADR("GETVAR");
  table[1].cmdTemplate:=sys.ADR("HELLOWORLD/S");
  table[1].userData   :=sys.VAL(E.APTR,arexxfuncGETVAR);

  table[2].id         :=help;
  table[2].command    :=sys.ADR("HELP");
  table[2].cmdTemplate:=sys.ADR("AMIGAGUIDE/S,TOPIC/F");
  table[2].userData   :=sys.VAL(E.APTR,arexxfuncHELP);

  table[3].id         :=open;
  table[3].command    :=sys.ADR("OPEN");
  table[3].cmdTemplate:=sys.ADR("PROJECT/S,TEXT/S,NAME/F");
  table[3].userData   :=sys.VAL(E.APTR,arexxfuncOPEN);

  table[4].id         :=quit;
  table[4].command    :=sys.ADR("QUIT");
  table[4].cmdTemplate:=sys.ADR("");
  table[4].userData   :=sys.VAL(E.APTR,arexxfuncQUIT);

  table[5].id         :=row;
  table[5].command    :=sys.ADR("ROW");
  table[5].cmdTemplate:=sys.ADR("NUMBER/A/N");
  table[5].userData   :=sys.VAL(E.APTR,arexxfuncROW);

  table[6].id         :=save;
  table[6].command    :=sys.ADR("SAVE");
  table[6].cmdTemplate:=sys.ADR("AS/S,NAME/F");
  table[6].userData   :=sys.VAL(E.APTR,arexxfuncSAVE);

  table[7].id         :=text;
  table[7].command    :=sys.ADR("TEXT");
  table[7].cmdTemplate:=sys.ADR("TEXT/A/F");
  table[7].userData   :=sys.VAL(E.APTR,arexxfuncTEXT);

  table[8].id         :=rx;
  table[8].command    :=sys.ADR("RX");
  table[8].cmdTemplate:=sys.ADR("COMMAND/A/F");
  table[8].userData   :=sys.VAL(E.APTR,arexxfuncRX);

  table[9].id         :=causeerror;
  table[9].command    :=sys.ADR("CAUSEERROR");
  table[9].cmdTemplate:=sys.ADR("");
  table[9].userData   :=sys.VAL(E.APTR,arexxfuncCAUSEERROR);

  table[10].id         :=NIL;
  table[10].command    :=NIL;
  table[10].cmdTemplate:=NIL;
  table[10].userData   :=NIL;

  IF ER.base # NIL THEN
    context:=ER.AllocARexxContext(ER.CommandTable, sys.ADR(table),
                                  ER.Author,sys.ADR("Ketil Hunn"),
                                  ER.Copyright,sys.ADR("© 1995 Ketil Hunn"),
                                  ER.Version,sys.ADR("2"),
                                  ER.PortName,sys.ADR("EASYREXX_TEST"),
                                  U.done);
    IF context # NIL THEN
      io.WriteString("Welcome to a small EasyRexx demonstration\n"
                     "-----------------------------------------\n"
                     "Open another shell and start the small\n"
                     "AREXX script: rx test\n"
                     "or doubleclick on the test.rexx icon.\n");
      REPEAT
        signals:=E.Wait(ER.Signal(context));
        ER.SetSignals(context,signals);
        IF (signals * ER.Signal(context) # LONGSET{}) THEN
          done:=myHandleARexx(context);
        END;
      UNTIL done & ER.SafeToQuit(context);
      ER.FreeARexxContext(context);
    END;
  ELSE
    IF I.DisplayAlert(0,"\x00\x64\x14missing easyrexx.library \o\o",50) THEN END;
  END;
END Funcs.
