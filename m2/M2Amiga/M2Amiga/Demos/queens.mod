MODULE queens;

FROM SYSTEM IMPORT
 ADDRESS,LONGSET,ADR;
FROM Arts IMPORT
 Assert,Terminate,TermProcedure;
FROM Dos IMPORT
 Delay;
FROM Exec IMPORT
 MsgPortPtr,GetMsg;
FROM Graphics IMPORT
 RastPortPtr,RectFill,SetAPen,SetRGB4;
FROM Intuition IMPORT
 NewWindow,IDCMPFlags,IDCMPFlagSet,ScreenFlags,ScreenFlagSet,
 WindowPtr,WindowFlags,WindowFlagSet,OpenWindow,CloseWindow,SetWindowTitles,
 gadgHNone,Gadget,GadgetPtr,GadgetFlags,GadgetFlagSet,AddGadget,
 propGadget,PropInfo,PropInfoPtr,PropInfoFlags,PropInfoFlagSet,
 Image,ActivationFlags,ActivationFlagSet,IntuiMessagePtr;

CONST
 WIDTH=260; HEIGHT=148;
 WHITE=1; BLACK=2; GREEN=3; BLUE=0;
 FW=30; FH=15; BW=8*FW; BH=8*FH;

VAR
 a: ARRAY [1..8] OF BOOLEAN;
 b: ARRAY [2..16] OF BOOLEAN;
 c: ARRAY [-7..7] OF BOOLEAN;
 upOffset, leftOffset: CARDINAL;
 delay: CARDINAL;
 rp: RastPortPtr;
 wp: WindowPtr;
 up: MsgPortPtr;
 gp: GadgetPtr;
 propInfo: PropInfo;
 gadget: Gadget;
 image: Image;

PROCEDURE CreateGadget(): GadgetPtr;
BEGIN
 WITH propInfo DO
  flags:=PropInfoFlagSet{autoKnob,freeHoriz};
  horizPot:=8092; vertPot:=0;
  horizBody:=BW; vertBody:=10;
 END;
 WITH gadget DO
  nextGadget:=NIL;
  leftEdge:=(WIDTH-BW) DIV 2; topEdge:=12; width:=BW; height:=10;
  flags:=GadgetFlagSet{};
  activation:=ActivationFlagSet{relVerify,gadgImmediate};
  gadgetType:=propGadget;
  gadgetRender:=ADR(image);
  selectRender:=NIL; gadgetText:=NIL; mutualExclude:=LONGSET{};
  specialInfo:=ADR(propInfo);
  gadgetID:=0; userData:=NIL
 END;
 RETURN ADR(gadget)
END CreateGadget;

PROCEDURE Rect(x,y,color: CARDINAL);
BEGIN
 x:=(x-1)*FW; y:=y*FH;
 INC(x,leftOffset);
 INC(y,upOffset);
 SetAPen(rp,color);
 RectFill(rp,x,y,x+FW-1,y+FH-1);
END Rect;

PROCEDURE PlaceQueen(c,r: CARDINAL);
BEGIN
 Rect(c,r,GREEN);
END PlaceQueen;

PROCEDURE DrawSquare(c, r: CARDINAL);
BEGIN
 IF ODD(c+r) THEN
  Rect(c,r,WHITE)
 ELSE
  Rect(c,r,BLACK)
 END;
END DrawSquare;

PROCEDURE CreateWindow(gp: GadgetPtr): WindowPtr;
VAR
 nw: NewWindow;
BEGIN
 WITH nw DO
  leftEdge:=60; topEdge:=30; width:=WIDTH; height:=HEIGHT;
  detailPen:=0; blockPen:=1;
  idcmpFlags:=IDCMPFlagSet{closeWindow,gadgetUp};
  flags:=WindowFlagSet{windowClose,windowDepth,windowDrag,activate};
  firstGadget:=gp; checkMark:=NIL;
  title:=NIL;
  screen:=NIL; bitMap:=NIL; type:=ScreenFlagSet{wbenchScreen}
 END;
 RETURN OpenWindow(nw)
END CreateWindow;

PROCEDURE ClearAndDrawBoard;
VAR
 i,j: INTEGER;
BEGIN
 FOR i:= 1 TO 8  DO a[i]:=TRUE END;
 FOR i:= 2 TO 16 DO b[i]:=TRUE END;
 FOR i:=-7 TO 7  DO c[i]:=TRUE END;
 gp:=CreateGadget();
 wp:=CreateWindow(gp);
 Assert(wp#NIL,ADR("Error Opening Window"));
 SetWindowTitles(wp,ADR("Eight Queens"),
  ADR("Eight Queens, programmed with M2Amiga, 4-Nov-87, © AMSoft"));
 up:=wp^.userPort;
 upOffset:=22+(HEIGHT-BH-22) DIV 2 -FH;
 leftOffset:=(WIDTH-BW) DIV 2;
 rp:=wp^.rPort;
 (* Draw Squares *)
 FOR i:=1 TO 8 DO
  FOR j:=1 TO 8 DO
   DrawSquare(i,j)
  END
 END
END ClearAndDrawBoard;

PROCEDURE TryCol(i: INTEGER);
VAR
 j: INTEGER;
 im: IntuiMessagePtr;
BEGIN
 FOR j:=1 TO 8 DO
  LOOP
   im:=GetMsg(up);
   IF im=NIL THEN
    EXIT
   ELSIF closeWindow IN im^.class THEN
    Terminate(0)
   ELSE
    delay:=propInfo.horizPot DIV 256;
   END;
   im:=GetMsg(up)
  END;
  IF a[j] & b[i+j] & c[i-j] THEN
   PlaceQueen(i,j);
   a[j]:=FALSE; b[i+j]:=FALSE; c[i-j]:=FALSE;
   IF i<8 THEN
    TryCol(i+1)
   ELSE
    Delay(delay)
   END;
   a[j]:=TRUE; b[i+j]:=TRUE; c[i-j]:=TRUE;
   DrawSquare(i,j)
  END
 END
END TryCol;

PROCEDURE Cleanup;
BEGIN
 CloseWindow(wp)
END Cleanup;

BEGIN (* main *)
 ClearAndDrawBoard;
 TermProcedure(Cleanup);
 delay:=32;
 LOOP
  TryCol(1)
 END
END queens.
