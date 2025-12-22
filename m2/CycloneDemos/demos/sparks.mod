MODULE sparks;

(* Ported from oberon source to modula-2 *)

FROM SYSTEM IMPORT
 ADDRESS,LONGSET,ADR,SETREG,ASSEMBLE;

FROM ExecL IMPORT
 SetSignal;

FROM GraphicsD IMPORT
 RastPortPtr,jam1,ViewPortPtr,ViewModes,ViewModeSet;

FROM GraphicsL IMPORT
 LoadRGB4,Move,Draw,SetAPen,SetDrMd;

FROM IntuitionD IMPORT
 customScreen,stdScreenHeight,
 IDCMPFlags,IDCMPFlagSet,NewScreen,NewWindow,
 ScreenFlags,ScreenFlagSet,ScreenPtr,WindowFlags,WindowFlagSet,WindowPtr;

FROM IntuitionL IMPORT 
 CloseScreen,CloseWindow,OpenScreen,OpenWindow,ShowTitle;

FROM Random IMPORT
 RND;

CONST
 maxx=640;
 maxLines=256;
 erase=0;

VAR
 screen: ScreenPtr;
 window: WindowPtr;
 drawRP: RastPortPtr;
 maxy: INTEGER;

PROCEDURE Cleanup;
BEGIN
 IF window#NIL THEN
  CloseWindow(window)
 END;
 IF screen#NIL THEN
  CloseScreen(screen)
 END
END Cleanup;

PROCEDURE colors;
(*$ EntryExitCode- *)
BEGIN
 ASSEMBLE(
  DC.W $0000,$035A,$0FFF,$0F60,$0E30,$0FB0,$0FF2,$0BF0,
       $05D0,$000F,$036F,$077F,$0C0E,$0F2E,$0ABC,$0DB8
 END);
END colors;

PROCEDURE AdjustX(VAR x,deltax: INTEGER);
VAR
 junk: INTEGER;
BEGIN
 junk:=x+deltax;
 IF (junk<1) OR (junk>=maxx) THEN
  junk:=x;
  deltax:=-deltax;
 END;
 x:=junk
END AdjustX;

PROCEDURE AdjustY(VAR y,deltay: INTEGER);
VAR
 junk: INTEGER;
BEGIN
 junk:=y+deltay;
 IF (junk<1) OR (junk>maxy) THEN
  junk:=y;
  deltay:=-deltay
 END;
 y:=junk
END AdjustY;

PROCEDURE SelectDelta(VAR dx1,dy1,dx2,dy2: INTEGER);
BEGIN
 dx1:=2*(RND(7)-3);
 dy1:=2*(RND(7)-3);
 dx2:=2*(RND(7)-3);
 dy2:=2*(RND(7)-3);
END SelectDelta;

PROCEDURE DrawLine(x1,y1,x2,y2,color: INTEGER);
BEGIN
 SetAPen(drawRP,color);
 SetDrMd(drawRP,jam1);
 Move(drawRP,x1,y1);
 Draw(drawRP,x2,y2);
END DrawLine;

PROCEDURE DoDemo;
VAR
 lx1,lx2: ARRAY [0..maxLines-1] OF INTEGER;
 ly1,ly2: ARRAY [0..maxLines-1] OF INTEGER;
 x1,x2: INTEGER;
 y1,y2: INTEGER;
 cl: INTEGER;
 color: INTEGER;
 deltax1,deltay1,deltax2,deltay2: INTEGER;
 frames: INTEGER;
BEGIN
 FOR x1:=0 TO maxLines - 1 DO
  lx1[x1]:=0;
  ly1[x1]:=0;
  lx2[x1]:=0;
  ly2[x1]:=0;
 END;
 color:=2;
 x1:=maxx DIV 2;
 x2:=maxx DIV 2;
 y1:=100;
 y2:=100;
 cl:=0;
 SelectDelta(deltax1,deltay1,deltax2,deltay2);
 WHILE NOT (window^.userPort^.sigBit IN SetSignal(LONGSET{},LONGSET{})) DO
  (* main loop *)
  DrawLine(lx1[cl],ly1[cl],lx2[cl],ly2[cl],erase);
  IF RND(7)=0 THEN
   color:=RND(16)
  END;
  IF RND(16)=0 THEN
   SelectDelta(deltax1,deltay1,deltax2,deltay2)
  END;
  AdjustX(x1,deltax1);
  AdjustY(y1,deltay1);
  AdjustX(x2,deltax2);
  AdjustY(y2,deltay2);
  DrawLine(x1,y1,x2,y2,color);
  lx1[cl]:=x1;
  lx2[cl]:=x2;
  ly1[cl]:=y1;
  ly2[cl]:=y2;
  INC(cl);
  IF cl>=maxLines THEN cl:=0 END;
 END
END DoDemo;

PROCEDURE CreateScreen(w,h,d: INTEGER;t: ADDRESS): ScreenPtr;
VAR
 ns: NewScreen;
BEGIN
 WITH ns DO
  leftEdge:=0;topEdge:=0;width:=w;height:=h;depth:=d;
  detailPen:=0;blockPen:=1;
  viewModes:=ViewModeSet{lace,hires};
  type:=customScreen;
  font:=NIL;
  defaultTitle:=t;
  gadgets:=NIL;
  customBitMap:=NIL
 END;
 RETURN OpenScreen(ns)
END CreateScreen;

PROCEDURE CreateWindow(x,y,w,h: INTEGER; if: IDCMPFlagSet; wf: WindowFlagSet;
                       g,s,t: ADDRESS): WindowPtr;
VAR
 nw: NewWindow;
BEGIN
 WITH nw DO
  leftEdge:=x;topEdge:=y;width:=w;height:=h; detailPen:=0;blockPen:=1;
  idcmpFlags:=if; flags:=wf; firstGadget:=g; checkMark:=NIL;
  title:=t;screen:=s;bitMap:=NIL;minWidth:=w;minHeight:=h;
  maxWidth:=w;maxHeight:=h; type:=customScreen
 END;
 RETURN OpenWindow(nw)
END CreateWindow;

BEGIN
 window:=NIL; screen:=NIL;
 screen:=CreateScreen(640,stdScreenHeight,4,NIL);
 ShowTitle(screen,FALSE);
 maxy:=screen^.height-1;
 window:=CreateWindow(0,0,640,maxy+1,
                      IDCMPFlagSet{mouseButtons},
                      WindowFlagSet{borderless,backDrop,activate},
                      NIL,screen,NIL);
 drawRP:=window^.rPort;
 LoadRGB4(ADR(screen^.viewPort),ADR(colors),16);
 DoDemo
CLOSE
 Cleanup;
END sparks.
