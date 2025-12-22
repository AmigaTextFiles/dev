IMPLEMENTATION MODULE Break;

(* (C) Copyright 1994 Marcel Timmermans. All rights reserved. *)

(*$ EntryClear-
    Align+
 *)

FROM SYSTEM    IMPORT ADR,LONGSET,SETREG,ASSEMBLE,REG;
FROM InOut     IMPORT WriteString;
FROM DosD      IMPORT ctrlC,ctrlD,ctrlE,ctrlF,ProcessPtr;
FROM ExecD     IMPORT sigDos;
FROM ExecL     IMPORT SetSignal,SetExcept,Forbid,Permit,GetMsg;
FROM ModulaLib IMPORT Terminate, thisTask;

CONST
    NoBreak = LONGSET{};
    CBreak  = LONGSET{ctrlC};
    PossibleSignals = LONGSET{ctrlC..ctrlF};

VAR 
  MyProcess: ProcessPtr;
  oldExceptCode: PROC;
  oldExceptData:LONGINT;
  actualBreak: LONGSET;


PROCEDURE ExitBreak;
BEGIN
  WriteString(BreakText);
  Terminate;
END ExitBreak;

PROCEDURE TestBreak;
BEGIN
  IF SetSignal(NoBreak,actualBreak)*actualBreak # NoBreak THEN
    ExitBreak()
  END;
END TestBreak;

PROCEDURE ExceptionHandler;
(*$ AutoRegs- SaveA4+ *)
VAR
  DosSig: BOOLEAN;
  savedD0: LONGINT;
BEGIN
  (* D0 may not changed !! [RMK] *)
  ASSEMBLE(
        MOVE.L  D0,savedD0(A5)
	MOVEA.L A1,A4
  END);
  Forbid(); (* be sure that nobody mess up the signals! *)
  WITH MyProcess^.task DO
    DosSig:=sigDos IN (sigWait/sigRecvd);
  END;
  Permit;
  IF ~DosSig THEN
    SETREG(0,GetMsg(ADR(MyProcess^.msgPort)));
    ExitBreak;
  END;
  SETREG(0,savedD0); (* Send the Signals back *)
END ExceptionHandler;


PROCEDURE InstallException;
BEGIN
  Forbid;
  WITH MyProcess^.task DO 
   exceptCode:=ExceptionHandler;  (* install ExceptionHandler *)
   exceptData:=REG(4+8);          (* remember A4 *)
  END;
  SETREG(0,SetSignal(NoBreak,PossibleSignals));
  SETREG(0,SetExcept(CBreak,CBreak));
  Permit;
END InstallException;

PROCEDURE RemoveException;
BEGIN
  Forbid;
  SETREG(0,SetExcept(NoBreak,CBreak));
  WITH MyProcess^.task DO
    exceptCode:=oldExceptCode;
    exceptData:=oldExceptData;
  END;
  Permit;
END RemoveException;


BEGIN (* Break *)
  MyProcess:=thisTask;
  WITH MyProcess^.task DO
   oldExceptCode:=exceptCode;    (* remark old expcode *)
   oldExceptData:=exceptData;    (* remark old data *)
  END;
  SETREG(0,SetExcept(NoBreak,PossibleSignals)); (* Clear all Exceptions *)
  actualBreak:=CBreak; 
CLOSE
  SETREG(0,SetExcept(NoBreak,PossibleSignals)); (* Clear all Exceptions ! *)
  WITH MyProcess^.task DO
    exceptCode:=oldExceptCode;
    exceptData:=oldExceptData;
  END;
END Break.mod
