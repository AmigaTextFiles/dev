(********************************************************************************

Name         : GraphicDemo1.MOD
Version      : 1.0
Purpose      : Demo from AMIGA ROM Kernel Manual p. 8-29
Authors      : ms
Modified     : 1.4.86  12:35  ms

********************************************************************************)

MODULE GraphicDemo1;

FROM SYSTEM    IMPORT ADR, ADDRESS, BYTE, INLINE;
FROM System    IMPORT Allocate;
FROM Terminal  IMPORT WriteString, WriteLn, Write, Read, BusyRead;
FROM Graphics  IMPORT View, ViewPort, RasInfo, BitMap,
                      OffDisplay, OnDisplay, InitView, InitBitMap, InitVPort,
                      MakeVPort, MrgCop, LoadView;
               IMPORT InOut;

CONST depth  =   5;
      width  = 320;
      height = 200;

TYPE PlanePtr = POINTER TO ARRAY [0..7999] OF BYTE;

VAR v:   View;
    vp:  ViewPort;
    ri:  RasInfo;
    b:   BitMap;
    i:   CARDINAL;
    j0, j1, j2, j3, j4:   PlanePtr;

PROCEDURE AllocRaster(w, h: CARDINAL): ADDRESS;
VAR p: ADDRESS;  size: CARDINAL;
BEGIN
  size:=SHIFT(w, -3)*h;
  InOut.WriteHex(size, 8);
  Allocate(p, SHIFT(w, -3)*h);
  RETURN p
END AllocRaster;

BEGIN  (* create and show a 320 by 200 by 5 display *)
  OffDisplay;       (* turn things off while we are creating *)

  InitView(v);                         (* init view *)
  v.viewPort:=ADR(vp);                 (* link viewport *)

  InitBitMap(b, depth, width, height); (* init bitmap *)

  FOR i:=0 TO depth-1 DO
    b.planes[i]:=AllocRaster(width, height); WriteLn;
    IF b.planes[i]=NIL THEN
      WriteString('no memory for display'); WriteLn;
      HALT
    END
  END;

  ri.bitMap:=ADR(b);
  ri.rxOffset:=0;
  ri.ryOffset:=0;
  ri.next:=NIL;

  InitVPort(vp);

  vp.dWidth:=width;
  vp.dHeight:=height;
  vp.rasInfo:=ADR(ri);

  MakeVPort(v, vp);

  MrgCop(v);

  LoadView(v);

  OnDisplay;

  j0:=PlanePtr(b.planes[0]);
  j1:=PlanePtr(b.planes[1]);
  j2:=PlanePtr(b.planes[2]);
  j3:=PlanePtr(b.planes[3]);
  j4:=PlanePtr(b.planes[4]);
  FOR i:=0 TO 1999 DO
    j0^[i]:=BYTE(-1);
    j1^[i]:=BYTE(0);
    j2^[i]:=BYTE(0);
    j3^[i]:=BYTE(0);
    j4^[i]:=BYTE(0);
  END;

  FOR i:=2000 TO 3999 DO
    j0^[i]:=BYTE(0);
    j1^[i]:=BYTE(-1);
    j2^[i]:=BYTE(0);
    j3^[i]:=BYTE(0);
    j4^[i]:=BYTE(0);
  END;

END GraphicDemo1.

