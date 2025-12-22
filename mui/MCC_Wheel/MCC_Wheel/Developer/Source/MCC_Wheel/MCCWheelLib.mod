|##########|
|#MAGIC   #|GMGMEJLC
|#PROJECT #|"MCCWheelLib"
|#PATHS   #|"StdProject"
|#LINK    #|""
|#GUIDE   #|""
|#STACK   #|"4096"
|#FLAGS   #|xx---x--xxx-xxx-x---------------
|#USERSW  #|--------------------------------
|#USERMASK#|--------------------------------
|#SWITCHES#|---x-x----------
|##########|

$$Library := TRUE
MODULE MCCWheelLib;

FROM System        AS y   IMPORT Regs, EndBEGIN, PROC;
FROM MuiO                 IMPORT CustomClassPtr;
FROM MCCWheelDispatcher   IMPORT wheelMCC;
FROM MCCLibrary           IMPORT All;

CONST
  Name     = "Wheel.mcc";   | can't be imported from MCCWheel.def, because the constant has to be right here
  IdString = "$VER: Wheel.mcc 19.000 (29.12.1999) © 1999 Lemming of PiNuts";
  Table    = TableType;


PROCEDURE GetClass (which IN D0 : LONGCARD) : CustomClassPtr;
$$EntryCode := FALSE
BEGIN
  PUSH (SavedRegs);
  SETREG (REG(A6), A4);
  IF which = 0 THEN
    SETREG (wheelMCC, D0);
  ELSE
    SETREG (0, D0);
  END;
  POP (SavedRegs);
END GetClass;

CONST
  Table = TableType : (Open, Close, Expunge, Reserved, GetClass, PROC(-1));

BEGIN
  ASSEMBLE (jmp EndBEGIN);
END MCCWheelLib.

