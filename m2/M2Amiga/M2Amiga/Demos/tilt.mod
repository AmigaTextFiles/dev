MODULE tilt;
(*
 * original source Leo L. Schwab, thanx for all these screen hacks
 * adapted to M2Amiga 16.9.87/ms
 *)
FROM SYSTEM IMPORT
 ADDRESS,ADR,SETREG,SHIFT;
FROM Arts IMPORT
 Assert,TermProcedure;
FROM Dos IMPORT
 Delay;
FROM Graphics IMPORT
 BitMapPtr,RastPortPtr,ViewModes,ViewModeSet,
 BltBitMap,ScrollRaster;
FROM Intuition IMPORT
 recoveryAlert,IDCMPFlagSet,NewWindow,NewScreen,ScreenFlags,ScreenFlagSet,
 ScreenPtr,WindowFlags,WindowFlagSet,WindowPtr,
 CloseScreen,CloseWindow,DisplayAlert,OpenScreen,OpenWindow,ScreenToBack,
 ScreenToFront;


PROCEDURE CreateScreen(x, y, w, h: INTEGER; v: ViewModeSet): ScreenPtr;
 VAR
  ns: NewScreen;
 BEGIN
  WITH ns DO
   leftEdge:=x; topEdge:=y; width:=w; height:=h; depth:=2;
   detailPen:=255; blockPen:=255;
   viewModes:=v;
   type:=ScreenFlagSet{};
   font:=NIL; defaultTitle:=NIL; gadgets:=NIL; customBitMap:=NIL
  END;
  RETURN OpenScreen(ns)
 END CreateScreen;


PROCEDURE CreateWindow(x, y, w, h: INTEGER;
                       if: IDCMPFlagSet;
                       wf: WindowFlagSet;
                       g, s, t: ADDRESS): WindowPtr;
 VAR
  nw: NewWindow;
 BEGIN
  WITH nw DO
   leftEdge:=x; topEdge:=y; width:=w; height:=h;
   detailPen:=0; blockPen:=1;
   idcmpFlags:=if; flags:=wf; firstGadget:=g; checkMark:=NIL;
   title:=t; screen:=s; bitMap:=NIL; minWidth:=w; minHeight:=h;
   maxWidth:=w; maxHeight:=h; type:=ScreenFlagSet{wbenchScreen}
  END;
  RETURN OpenWindow(nw)
 END CreateWindow;


VAR
 scr, wb: ScreenPtr;
 win: WindowPtr;
 rp: RastPortPtr;
 wbm,mbm: BitMapPtr;
 x, y, n: LONGINT;
 i: INTEGER;

PROCEDURE Cleanup;
 BEGIN
  IF scr#NIL THEN CloseScreen(scr) END;
  IF win#NIL THEN CloseWindow(win) END
 END Cleanup;

VAR
 msg: RECORD
  x1: CARDINAL; s1: ARRAY [0..59] OF CHAR; (* even number of chars !! *)
  x2: CARDINAL; s2: ARRAY [0..37] OF CHAR
 END;
BEGIN
 scr:=NIL; win:=NIL;
 msg.s1:="*Software Failure.   Press left mouse button to continue. ";
 msg.x1:=96; msg.s1[0]:=CHAR(15); msg.s1[59]:=CHAR(1);
 msg.s2:="* Guru Meditation #00019987.000JR000";
 msg.x2:=176; msg.s2[0]:=CHAR(28); msg.s2[37]:=CHAR(0);
 TermProcedure(Cleanup);
 win:=CreateWindow(0, 30, 100, 10, IDCMPFlagSet{},
                   WindowFlagSet{windowDrag, windowDepth, activate},
                   NIL, NIL, ADR("Tilt!"));
 Assert(win#NIL, ADR("Fehler beim Öffnen des Fensters"));
 wb:=win^.wScreen;(* Workbench Screen  *)
 WITH wb^ DO
  scr:=CreateScreen(leftEdge, topEdge, width, height, viewPort.modes)
 END;
 Assert(scr#NIL, ADR("Fehler beim Öffnen des Screens"));
 ScreenToBack(scr);
 rp:=ADR(scr^.rastPort);
 mbm:=rp^.bitMap;
 wbm:=win^.wScreen^.rastPort.bitMap;
 SETREG(0, BltBitMap(wbm, 0, 0, mbm, 0, 0,
                     scr^.width,scr^.height, 0C0H, 0FFH, NIL));
 y:=scr^.height-1;
 FOR i:=0 TO 39 DO x:=16*i; ScrollRaster(rp,0,i-20,x,0,x+15,y) END; 
 x:=scr^.width-1;
 n:=scr^.height DIV 50;
 FOR i:=0 TO 49 DO y:=i*n; ScrollRaster(rp,25-i,0,0,y,x,y+n-1) END;
 ScreenToFront(scr);
 Delay(50);
 IF DisplayAlert(recoveryAlert, ADR(msg), 40) THEN END;
END tilt.mod
