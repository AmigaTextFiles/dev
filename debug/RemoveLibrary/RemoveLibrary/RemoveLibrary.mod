|##########|
|#MAGIC   #|FPJKJBHG
|#PROJECT #|"RemoveLibrary"
|#PATHS   #|"StdProject"
|#LINK    #|""
|#GUIDE   #|""
|#STACK   #|"4096"
|#FLAGS   #|xx-x-x--xx---xx-x---------------
|#USERSW  #|--------------------------------
|#USERMASK#|--x-----------------------------
|#SWITCHES#|x----xxxxx-xx---
|##########|

MODULE RemoveLibrary;

FROM CLIStartup        IMPORT All;
FROM System            IMPORT SysStringPtr;
FROM Dos               IMPORT VPrintf;
FROM Exec              IMPORT LibGrp;

TYPE
  ArgRec   = RECORD lib : SysStringPtr; force : LONGBOOL END;

VAR
  args    := ArgRec : (NIL, FALSE);
  lib     : LibraryPtr;
  n       : CARDINAL;

BEGIN
  ReadArgs ("LIB/A,FORCE/S", args);

  lib := OpenLibrary (args.lib, NIL);
  IF = THEN
    FORGET VPrintf ("Could not find %s."+&10, ANYPTR (args.lib));
    RAISE (ScriptError);
  OR_IF (lib.openCnt > 1) AND NOT args.force THEN
    (* Call RemLibrary first, because lib is invalid after CloseLibrary *)
    RemLibrary (lib);
    CloseLibrary (lib);
    FORGET VPrintf ("%s is still opened by someone else."+&10+
                    "Quit other programs using this library or try FORCE."+&10,
                    ANYPTR (args.lib));
    RAISE (ScriptError);
  ELSE
    RemLibrary (lib);
    n := lib.openCnt;
    (* Do not use lib.openCnt as loop counter,
       the pointer lib isn't valid after the last CloseLibrary *)
    WHILE n>0 DO
      CloseLibrary (lib);
      DEC (n);
    END;
  END;
END RemoveLibrary.
