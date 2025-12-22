MODULE hitMe;
(* This is the program published in AmigaWorld's March/April 1987 Issue.
 * Playing with Intuition by William B. Catchings and mark L. Van Name.
 * Ported to M2Amiga by Markus Schaub and Rene Degen.
 *)
(* Sorry, the program is too big for the demo compiler, I removed all
 * inits to 0 of global data, done by Amiga Loader and switch all checks
 * off $R- range check $V- overflow check $S- stack check $F- function return
 *)
FROM SYSTEM IMPORT
 ADDRESS,ADR,INLINE,LONGSET,SHIFT;
FROM Exec IMPORT
 GetMsg,ReplyMsg,Wait;
FROM Graphics IMPORT
 Move,PolyDraw,SetAPen,Text;
FROM Intuition IMPORT
 selectUp,
 IDCMPFlagSet,IDCMPFlags,IntuiMessagePtr,NewWindow,ScreenFlags,ScreenFlagSet,
 WindowPtr,WindowFlags,WindowFlagSet,
 ClearPointer,CloseWindow,CurrentTime,ModifyIDCMP,OpenWindow,
 SetPointer,SetWindowTitles;

CONST
 accuracy=3;

VAR
 myWindow: WindowPtr;
 message: IntuiMessagePtr;
 class: IDCMPFlagSet;
 code: CARDINAL;
 ptrX, ptrY, boxX, boxY: INTEGER;
 rand: INTEGER;
 millis, oldMillis, score, total: LONGINT;
 numHit: INTEGER;
 corners: ARRAY [0..7] OF INTEGER;
 waitMask, wom: LONGSET;
 defWindow: NewWindow;

PROCEDURE WindCreate(VAR w: WindowPtr): BOOLEAN;
BEGIN
 WITH defWindow DO
  leftEdge:=40; topEdge:=40;
  width:=300; height:=100;
  (*detailPen:=0;*) blockPen:=1;
  (*title:=NIL;*)
  flags:=WindowFlagSet{activate,windowClose,windowDrag,
   windowSizing,windowDepth};
  idcmpFlags:=IDCMPFlagSet{closeWindow};
  type:=ScreenFlagSet{wbenchScreen};
(*firstGadget:=NIL;
  checkMark:=NIL;
  screen:=NIL;
  bitMap:=NIL; *)
  minWidth:=100;
  minHeight:=40;
  maxWidth:=640;
  maxHeight:=200
 END;
 w:=OpenWindow(defWindow);
 RETURN w#NIL;
END WindCreate;

PROCEDURE PtrData;
(* $E- no Entry/Exit Code (of course not) *)
BEGIN
 INLINE(
  0,0,
  0FFFEH,0FFFEH,
  0E10EH,0E00EH,
  0E10EH,0E00EH,
  0E10EH,0E00EH,
  0E10EH,0E00EH,
  0E10EH,0E00EH,
  0FFFEH,0E00EH,
  0E10EH,0E00EH,
  0E10EH,0E00EH,
  0E10EH,0E00EH,
  0E10EH,0E00EH,
  0E10EH,0E00EH,
  0FFFEH,0FFFEH,
  0,0)
END PtrData;  

PROCEDURE WriteScore(w: WindowPtr; total,score,hits: LONGINT);
VAR
 st: ARRAY [0..15] OF CHAR;
 i,l: INTEGER;
BEGIN
 st:="Hits:           "; i:=15; l:=hits;
 IF l<0 THEN  st[i]:="-"; DEC(i); l:=-l END;
 REPEAT
  st[i]:=CHR(l MOD 10+48); l:=l DIV 10; DEC(i)
 UNTIL (i=6) OR (l=0);
 Move(w^.rPort, 10, 20);
 Text(w^.rPort, ADR(st), 16);
 st:="Score:          "; i:=15; l:=total;
 IF l<0 THEN  st[i]:="-"; DEC(i); l:=-l END;
 REPEAT
  st[i]:=CHR(l MOD 10+48); l:=l DIV 10; DEC(i)
 UNTIL (i=6) OR (l=0);
 Move(w^.rPort, 10, 29);
 Text(w^.rPort, ADR(st), 16);
END WriteScore;

PROCEDURE Rand(): INTEGER;
CONST
 m=1024; a=57; c=6999;
BEGIN
 rand:=INTEGER((CARDINAL(a)*CARDINAL(rand)+CARDINAL(c)) MOD CARDINAL(m));
 RETURN rand
END Rand;

PROCEDURE PutBox(w: WindowPtr; VAR x,y: INTEGER; VAR millis: LONGINT);
VAR
 mic,sec: LONGCARD;
 tmp: INTEGER;
BEGIN
 WITH w^ DO
  IF millis=0 THEN
   CurrentTime(ADR(sec),ADR(mic));
   rand:=mic MOD 1024;
  ELSE
   SetAPen(rPort,0);
   Move(rPort,corners[6],corners[7]);
   PolyDraw(rPort,4,ADR(corners))
  END;
  SetAPen(rPort, 1);
  REPEAT tmp:=Rand() UNTIL (tmp+20<width);  x:=tmp+10;
  REPEAT tmp:=Rand() UNTIL (tmp+30<height); y:=tmp+20;
  corners[0]:=x-4; corners[6]:=corners[0];
  corners[1]:=y-3; corners[3]:=corners[1];
  corners[2]:=x+4; corners[4]:=corners[2];
  corners[5]:=y+3; corners[7]:=corners[5];
  Move(rPort, corners[6], corners[7]);
  PolyDraw(rPort,4,ADR(corners));
  CurrentTime(ADR(sec), ADR(mic));
  millis:=SHIFT(sec,10)+SHIFT(mic,-10)
 END
END PutBox;

PROCEDURE Hit(x1,y1,x2,y2: INTEGER): BOOLEAN;
BEGIN
 RETURN (ABS(x1-x2)<accuracy) & (ABS(y1-y2)<accuracy)
END Hit;

BEGIN (*
 millis:=0; oldMillis:=0; score:=0; total:=0; numHit:=0; *)
 boxX:=50; boxY:=50;
 IF WindCreate(myWindow) THEN
  SetWindowTitles(myWindow, ADR('hitMe'), ADR('hitMe, 2.1, 4-Nov-87'));
  ModifyIDCMP(myWindow, IDCMPFlagSet{mouseButtons, closeWindow, newSize});
  SetPointer(myWindow, ADR(PtrData), 13, 16, -8, -6);
  PutBox(myWindow, boxX, boxY, oldMillis);
  WriteScore(myWindow, total, score, numHit);
  waitMask:=LONGSET{myWindow^.userPort^.sigBit};
  LOOP
   wom:=Wait(waitMask);
   message:=IntuiMessagePtr(GetMsg(myWindow^.userPort));
   WHILE message#NIL DO
    class:=message^.class;
    code:=message^.code;
    ptrX:=message^.mouseX;
    ptrY:=message^.mouseY;
    millis:=SHIFT(message^.seconds,10)+SHIFT(message^.micros,-10);
    ReplyMsg(ADDRESS(message));
    IF closeWindow IN class THEN
     ClearPointer(myWindow);
     CloseWindow(myWindow);
     EXIT
    ELSIF newSize IN class THEN
     PutBox(myWindow,boxX,boxY,oldMillis);
    ELSIF mouseButtons IN class THEN
     IF code=selectUp THEN
      IF Hit(ptrX,ptrY,boxX,boxY) THEN
       score:=6000-(millis-oldMillis);
       IF score<0 THEN score:=0 END;
       score:=SHIFT(score,-4);
       INC(total,score); INC(numHit);
       WriteScore(myWindow,total,score,numHit);
       PutBox(myWindow,boxX,boxY,oldMillis)
      END
     END
    END; 
    message:=IntuiMessagePtr(GetMsg(myWindow^.userPort));
   END
  END
 END
END hitMe.
