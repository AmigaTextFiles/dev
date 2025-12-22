|##########|
|#MAGIC   #|FPILJJIO
|#PROJECT #|"CLIStartup"
|#PATHS   #|"StdProject"
|#LINK    #|""
|#GUIDE   #|""
|#STACK   #|"4096"
|#FLAGS   #|xx---x--xx----x-----------------
|#USERSW  #|--------------------------------
|#USERMASK#|--x-----------------------------
|#SWITCHES#|x----xxxxx-xx---
|##########|

IMPLEMENTATION MODULE CLIStartup;

FROM Dos               IMPORT FreeArgs, RDArgsPtr;

VAR
  RD         : RDArgsPtr := NIL;
  error      : Dos.IoErrors;

PROCEDURE ReadArgs (REF template : STRING;
                    VAR args     : ANYTYPE);
BEGIN
  RD := Dos.ReadArgs (template, args'PTR, NIL);
  IF = THEN
    error := Dos.IoErr();
    FORGET Dos.PrintFault (error, NIL);
    (*
      double remark about Template looks ugly,
      if "Command ?" is entered and the parameter request is also skipped
    *)
    |FORGET Dos.VPrintf ("Usage: %s"+&10, template.data'ADR);
    HALT (LONGINT (error));
  END;
END ReadArgs;

BEGIN
CLOSE
  IF RD#NIL THEN FreeArgs (RD) END;
END CLIStartup.
