IMPLEMENTATION MODULE Arguments;

(* (C) Copyright 1993 Marcel Timmermans. All rights reserved. *)

(* 
   REVISON
   -------
   Removed space bug (20C # space) 07.05.95/MT

*)

FROM SYSTEM    IMPORT SHIFT,ADDRESS,ADR,SETREG,CAST;
FROM ModulaLib IMPORT dosCmdBuf,wbStarted,wbenchMsg,thisTask;

IMPORT DosD,
       DosL,
       ExecL,
       wb:Workbench;

CONST
  LF=CHAR(0AH);
  quote='"';

TYPE
	CharPtr = POINTER TO CHAR;

VAR
	WBSt: wb.WBStartupPtr;
	CommLine:CharPtr;


PROCEDURE GetParms(VAR s:ARRAY OF CHAR);
VAR
  i:INTEGER;

  PROCEDURE SkipSpace;
  BEGIN
    WHILE CommLine^=' ' DO INC(CommLine); END;
  END SkipSpace;

BEGIN
  i:=0; SkipSpace;
  IF CommLine^=quote THEN
    INC(CommLine);
    LOOP
      IF i=HIGH(s) THEN i:=0; END;
      IF CommLine^=quote THEN INC(CommLine); EXIT;
      ELSIF CommLine^=LF THEN EXIT;
      ELSE
        s[i]:=CommLine^; INC(CommLine);
        INC(i);
      END;
    END;
  ELSE (* no quote (") *)
    LOOP
      IF (CommLine^=' ') OR (CommLine^=LF) THEN EXIT;
      ELSE
        IF i<HIGH(s) THEN s[i]:=CommLine^; END;
        INC(CommLine);
        INC(i);
      END;
    END;
  END;
  IF i<HIGH(s) THEN s[i]:=0C; END;
  SkipSpace;
END GetParms;

PROCEDURE NumArgs():INTEGER;
VAR
  cnt:INTEGER;
  dummy:ARRAY[0..255] OF CHAR;
BEGIN
  IF wbStarted THEN
    RETURN WBSt^.numArgs-1
  ELSE
    CommLine:=dosCmdBuf;
    cnt:=0;
    WHILE CommLine^#LF DO
      GetParms(dummy);
      INC(cnt);
    END;
    RETURN cnt
  END
END NumArgs;

PROCEDURE GetArg(arg: INTEGER; VAR argument: ARRAY OF CHAR);
VAR i:INTEGER;
    p:DosD.ProcessPtr;
BEGIN
  IF arg<=NumArgs() THEN
    IF wbStarted THEN
      i:=0;
      CommLine:=WBSt^.argList^[arg].name;
      WHILE i<HIGH(argument) DO
        argument[i]:=CommLine^; INC(CommLine);
        INC(i);
      END;
      SETREG(0,DosL.CurrentDir(WBSt^.argList^[arg].lock)); (* cancel result *)
    ELSE (* cli *)
      IF arg=0 THEN
        p:=thisTask; CommLine:=ADR(p^.cli^.commandName^); (* BSTR *)
        i:=ORD(CommLine^); (* BSTR LEN *)
        INC(CommLine);
        ExecL.CopyMem(CommLine,ADR(argument[0]),i);
        IF i<HIGH(argument) THEN argument[i]:=0C; ELSE i:=HIGH(argument); END;
      ELSE (* arg#0 *)
        CommLine:=dosCmdBuf;
        WHILE arg>0 DO
          DEC(arg);
          GetParms(argument);
        END;
      END;
    END (* if wbstarted *)
  END;
END GetArg;

PROCEDURE GetLock(arg: INTEGER): DosD.FileLockPtr;
BEGIN
  IF wbStarted THEN
    WITH WBSt^ DO
      IF arg<numArgs THEN
        RETURN argList^[arg].lock
      END
    END (* WITH *)
  END;
  RETURN NIL
END GetLock;

BEGIN
  IF wbStarted THEN
    WBSt:=wbenchMsg;
  END;
END Arguments.mod
