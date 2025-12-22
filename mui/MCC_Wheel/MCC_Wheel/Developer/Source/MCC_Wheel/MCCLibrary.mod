|##########|
|#MAGIC   #|GMGFGFAD
|#PROJECT #|"MCCTableGroupLib"
|#PATHS   #|"StdProject"
|#LINK    #|"muinp:libs/mui/TableGroup.mcc"
|#GUIDE   #|""
|#STACK   #|"4096"
|#FLAGS   #|xx---x--xxx-xxx-----------------
|#USERSW  #|--------------------------------
|#USERMASK#|--------------------------------
|#SWITCHES#|---x-x----------
|##########|

IMPLEMENTATION MODULE MCCLibrary;

FROM System        AS y   IMPORT Regs, OwnLibBase, CloseProc;
FROM Exec                 IMPORT SemaphoreGrp;

VAR
  countLock : SignalSemaphore;

PROCEDURE Open;
$$EntryCode := FALSE
BEGIN
  PUSH (SavedRegs);
  SETREG (REG(A6), A4);

  ObtainSemaphore (countLock'PTR);
  INC (OwnLibBase.openCnt);
  EXCL (OwnLibBase.flags, 3);
  ReleaseSemaphore (countLock'PTR);

  SETREG (REG(A4), D0);
  POP (SavedRegs);
END Open;

PROCEDURE Close;
$$EntryCode := FALSE
BEGIN
  PUSH (SavedRegs);
  SETREG (REG(A6), A4);

  ObtainSemaphore (countLock'PTR);
  DEC (OwnLibBase.openCnt);
  IF = AND (3 IN OwnLibBase.flags) THEN
    ReleaseSemaphore (countLock'PTR);
    ASSEMBLE (move.l CloseProc, a0
              jmp    (a0));
  ELSE
    ReleaseSemaphore (countLock'PTR);
  END;

  SETREG (0, D0);
  POP (SavedRegs);
END Close;

PROCEDURE Expunge;
$$EntryCode := FALSE
BEGIN
  PUSH (SavedRegs);
  SETREG (REG(A6), A4);

  ObtainSemaphore (countLock'PTR);
  IF OwnLibBase.openCnt = 0 THEN
    ReleaseSemaphore (countLock'PTR);
    ASSEMBLE (move.l CloseProc, a0
              jmp    (a0));
  ELSE
    INCL (OwnLibBase.flags, 3);
    ReleaseSemaphore (countLock'PTR);
  END;

  SETREG (0, D0);
  POP (SavedRegs);
END Expunge;

PROCEDURE Reserved;
$$EntryCode := FALSE
BEGIN
  SETREG (0, D0);
END Reserved;

BEGIN
  InitSemaphore (countLock'PTR);
END MCCLibrary.
