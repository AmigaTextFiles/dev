(********************************************************************************

Name         : Flash.MOD
Version      : 1.0
Purpose      : Modula 2 version of Color Art by Rick Wirch
               With extra touches my the author
Author       : Jonas S Green
Modified     : 3.22.87  JSG

********************************************************************************)

MODULE Flash;

FROM Breaks     IMPORT DetectBreak,BreakFlags;
FROM Terminal   IMPORT WriteString, WriteLn;
FROM SYSTEM     IMPORT ADDRESS, ADR, BYTE, LONG;
FROM AMIGADos   IMPORT Delay;
FROM Graphic    IMPORT Move,SetAPen,SetBPen,Text,SetRGB4,Draw,SetRast,
                       RectFill;
FROM Intuition  IMPORT OpenScreen,CloseScreen,OpenWindow,CloseWindow,
                       ViewPortAddress,
                       NewWindow,NewScreen,Window,WindowPtr,
                       CLOSEWINDOW,WINDOWCLOSE,ACTIVATE,WINDOWDRAG,
                       WINDOWDEPTH,WINDOWSIZING,BORDERLESS,NOCAREREFRESH,
                       CUSTOMSCREEN,WBSCREEN,HIRES,INTERLACE,BACKDROP;

FROM MathLib0   IMPORT SIN,COS;


CONST RA = 1.5807;

PROCEDURE Flash1(rast,x,y:LONGINT;i:REAL);

VAR x1,y1 : LONGINT;
    neg : BOOLEAN;
    temp : LONGINT;

BEGIN
  y1 := TRUNC(90.0*SIN(RA*i,neg));
  IF neg THEN y1 := -y1 END;
  y1 := y1 + 96D;
  x1 := TRUNC(150.0*COS(i,neg));
  IF neg THEN x1 := -x1 END;
  x1 := x1 + 160D;

  IF x1<x THEN
    temp := x1;
    x1 := x;
    x := temp;
  END;

  IF y1<y THEN
     temp := y1;
     y1 := y;
     y := temp;
  END;

  RectFill(rast,x,y,x1,y1);

END Flash1;


PROCEDURE Flash2(rast,x,y : LONGINT);

BEGIN
  RectFill(rast,0,0,x,y);
END Flash2;

PROCEDURE Flash3(rast: LONGINT;x,y: LONGINT;VAR xo,yo : LONGINT);

BEGIN
  Move(rast,160D,99D);
  Draw(rast,xo,yo);
  Draw(rast,x,y);
  Draw(rast,160D,99D);
  xo := x;  yo := y;
END Flash3;


VAR
    nw: NewWindow;
    ns: NewScreen;
    w: WindowPtr;
    s: LONGINT;
    st, wt: ARRAY [0..31] OF CHAR;
    fg,bg,rast : LONGINT;
    p: LONGINT;
    xo,yo,x,y : LONGINT;
    Times : CARDINAL;
    vpa : ADDRESS;
      i : REAL;
    neg : BOOLEAN;
    continue : BOOLEAN;

BEGIN
  WriteString("Flashy Graphics"); WriteLn;
  WriteString("===============");
  WriteLn; WriteLn;
  WriteString("By Jonas S. Green"); WriteLn;
  WriteString("Based on Color Art by Rich Wirch"); WriteLn;
  WriteString("Hit Cntrl-C to Exit"); WriteLn;
  Delay(30);
    st:='Flashy';
    WITH ns DO
      leftEdge:=0;
      topEdge:=0;
      width:=320;
      height:=200 (* 400 *);
      depth:=4;
      detailPen:=BYTE(0);
      blockPen:=BYTE(0);
      viewModes:=0D;
      type:=CUSTOMSCREEN;
      font:=0D;
      title:=ADR(st);
      gadget:=0D;
      bitMap:=0D
    END;
    s:=OpenScreen(ns);
    IF s=0D THEN
      WriteString('Error: screen not opend'); WriteLn;
      RETURN
    END;
    wt:='Flashy Window';
    WITH nw DO
      leftEdge:=0;
      topEdge:=0;
      width:=320;
      height:=200;
      detailPen:=BYTE(0);
      blockPen:=BYTE(0);
      IDCMPFlags:=CLOSEWINDOW;
      flags:=WINDOWCLOSE  + NOCAREREFRESH + BORDERLESS +
             BACKDROP;

      firstGadget:=0D;
      checkMark:=0D;
      title:=ADR(wt);
      screen:=ADDRESS(s);
      bitMap:=0D;
      minWidth:=320;
      minHeight:=200;
      maxWidth:=320;
      maxHeight:=200;
      type:=CUSTOMSCREEN 
    END; (* declaring first window *)

    w:=OpenWindow(nw);
    IF LONGINT(w)=0D THEN
      WriteString(' Error: OpenWindow Failed');
    ELSE
      rast := LONGINT(w^.Rport);
      vpa := ViewPortAddress(w);
      SetRGB4(vpa,0D,0D,1D,1D);
      SetRGB4(vpa,1D,0D,1D,1D);
      SetRGB4(vpa,2D,0D,1D,1D);
      fg := 0D;
      LOOP
      FOR Times := 1 TO 3 DO
         SetRast(rast,0D);
         xo := 160D;
         yo := 99D;
         i := 0.0;
         WHILE i<=18.0  DO
            x := TRUNC(150.0 * SIN(i,neg));
            IF neg THEN x := -x END;
            x := x + 160D;
            y := TRUNC(90.0*COS(RA*i,neg));
            IF neg THEN y := -y END;
            y := y + 96D;
            IF Times = 1 THEN Flash1(rast,x,y,i) END;
            IF Times = 2 THEN Flash2(rast,x,y) END;
            IF Times = 3 THEN Flash3(rast,x,y,xo,yo) END;
            IF DetectBreak(breakC) THEN EXIT END;
            fg := (fg + 1D) MOD 13D;
            p := 3D;
            WHILE p <= 15D DO
               bg := ((p+fg) MOD 12D) + 3D;
               SetRGB4(vpa,bg,5D,p,p);
               p := p + 1D;
            END; (* WHILE *)
            bg := fg + 3D;
            SetAPen(rast,bg);
            i := i + 0.05;
          END; (* WHILE i *)
      END;  (* FOR Times *)
      END; (* LOOP *)
    CloseWindow(w);
    CloseScreen(s);
  END;
END Flash.
