|##########|
|#MAGIC   #|GMGMEEHB
|#PROJECT #|"MCPWheelLib"
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
MODULE MCPWheelLib;

FROM System        AS y   IMPORT Regs, EndBEGIN, PROC;
FROM MuiO                 IMPORT CustomClassPtr, NewObject, AreaObject, cBitmap;
FROM MCPWheelDispatcher   IMPORT wheelMCP;
FROM MCCLibrary           IMPORT All;

CONST
  Name     = "Wheel.mcp";
  IdString = "$VER: Wheel.mcp 19.000 (09.01.2000) © 2000 Lemming of PiNuts";
  Table    = TableType;

PROCEDURE MCPImage () : AreaObject;
FROM MCPWheelImage IMPORT bitmap, palette, width, height;
FROM Graphics39    IMPORT PenPrecisions;
BEGIN
  RETURN NewObject (cBitmap,
    bitmapBitmap       : bitmap'PTR,
    bitmapWidth        : width,
    bitmapHeight       : height,
    bitmapPrecision    : icon,
    bitmapSourceColors : palette'PTR,
    bitmapTransparent  : 0,
    fixWidth           : width,
    fixHeight          : height,
  DONE);
END MCPImage;

|$$PushRegs  := TRUE
$$EntryCode := FALSE
PROCEDURE GetClass () : CustomClassPtr;
BEGIN
  PUSH (SavedRegs);
  SETREG (REG(A6), A4);
  IF KEY REG(D0) | which
    OF 1 THEN
      SETREG (wheelMCP, D0);
    END;
    OF 2 THEN
      FORGET MCPImage ();  | result is already in D0
    END;
  ELSE
    SETREG (0, D0);
    |RETURN NIL;
  END;
  POP (SavedRegs);
END GetClass;

CONST
  Table = TableType : (Open, Close, Expunge, Reserved, GetClass, PROC(-1));

BEGIN
  ASSEMBLE (jmp EndBEGIN);
END MCPWheelLib.
