(********************************************************************************

Name         : ReqDemo.MOD
Version      : 1.0
Purpose      : Demo for use of Requesters   ( AutoRequest )
Author       : ms
Modified     : 2.4.86  11:00  ms

********************************************************************************)

MODULE ReqDemo;

FROM SYSTEM    IMPORT ADDRESS, BYTE, ADR, TSIZE;
FROM Terminal  IMPORT WriteString, WriteLn;
FROM System    IMPORT Allocate, Deallocate;
FROM AMIGADos  IMPORT Delay;
FROM AMIGABase IMPORT Regs, LibCall, ExecBase, ExecOpenLib;

CONST JAM2          =      1;
      ACTIVATE      =  4096D;
      WINDOWDRAG    =     2D;
      WINDOWDEPTH   =     4D;
      WINDOWSIZING  =     1D;
      NOCAREREFRESH =131072D;
      WBSCREEN      =    01H; 

TYPE StringPtr = POINTER TO ARRAY [0..29999] OF CHAR;
     NewWindow = RECORD
                   leftEdge,
                   topEdge,
                   width,
                   height: CARDINAL;
                   detailPen,
                   blockPen: BYTE;
                   IDCMPFlags,
                   flags: LONGINT;
                   firstGadget,
                   checkMark: LONGINT;
                   title: StringPtr;
                   screen,
                   bitMap: ADDRESS;
                   minWidth,
                   minHeight,
                   maxWidth,
                   maxHeight: CARDINAL;
                   type: CARDINAL
                 END;
  IntuiTextPtr = POINTER TO IntuiText;
     IntuiText = RECORD
                   frontPen, backPen, drawMode: BYTE;
                   leftEdge, topEdge: INTEGER;
                   iTextFont, iText: ADDRESS;
                   nextText: IntuiTextPtr;
                 END;
(*   dummy types for window data structure *)
     Window    = ARRAY [0..63] OF CARDINAL;
     WindowPtr = POINTER TO Window;

VAR nw: NewWindow;
    w: WindowPtr;
    intuibase: LONGINT;
    bodyTextPtr, pTextPtr, nTextPtr, dummy: IntuiTextPtr;

PROCEDURE AllocString(VAR p: ADDRESS; st: ARRAY OF CHAR);
VAR i, j: CARDINAL;
    s: StringPtr;
BEGIN i:=0;
  WHILE (i<=HIGH(st)) & (st[i]#0C) DO INC(i) END;
  Allocate(p, i);
  IF p#NIL THEN
    s:=StringPtr(p);
    FOR j:=0 TO i-1 DO s^[j]:=st[j] END;
    s^[i]:=0C;
  END
END AllocString;
   
PROCEDURE OpenLibrary(st: ARRAY OF CHAR): LONGINT;
VAR r: Regs; p: ADDRESS;
BEGIN
  AllocString(p, st);
  r.a[1]:=p;
  r.d[0]:=0D;
  LibCall(ExecBase(), ExecOpenLib(), r);
  Deallocate(p);
  RETURN r.d[0]  
END OpenLibrary;

PROCEDURE OpenWindow(VAR nw: NewWindow): WindowPtr;
VAR r: Regs;
BEGIN
  r.a[0]:=ADR(nw);
  LibCall(intuibase, -204D, r);
  RETURN WindowPtr(r.d[0]);
END OpenWindow;

PROCEDURE CloseWindow(w: WindowPtr);
VAR r: Regs;
BEGIN
  r.a[0]:=LONGINT(w);
  LibCall(intuibase, -72D, r);
END CloseWindow;

PROCEDURE AutoRequest(win: WindowPtr; bodyText, pText, nText: IntuiTextPtr;
                      pFlag, nFlag, w, h: LONGINT): BOOLEAN;
VAR r: Regs;
BEGIN
  r.a[0]:=LONGINT(win);
  r.a[1]:=LONGINT(bodyText);
  r.a[2]:=LONGINT(pText);
  r.a[3]:=LONGINT(nText);
  r.d[0]:=pFlag;
  r.d[1]:=nFlag;
  r.d[2]:=w;
  r.d[3]:=h;
  LibCall(intuibase, -348, r);
  RETURN r.d[0]#0D
END AutoRequest;

PROCEDURE NewIText(text: ARRAY OF CHAR; left, top: INTEGER): IntuiTextPtr;
VAR newText: IntuiTextPtr;
BEGIN
  Allocate(newText, TSIZE(IntuiText));
  WITH newText^ DO
    AllocString(iText, text);
    frontPen:=BYTE(0); backPen:=BYTE(1);
    drawMode:=BYTE(JAM2);
    leftEdge:=left; topEdge:=top;
    iTextFont:=NIL;
    nextText:=NIL
  END;
  RETURN newText
END NewIText;

PROCEDURE AddIText(VAR intuiText: IntuiTextPtr;
                   text: ARRAY OF CHAR): IntuiTextPtr;
VAR newtext: IntuiTextPtr;
BEGIN
  Allocate(newtext, TSIZE(IntuiText));
  WITH newtext^ DO
    AllocString(iText, text);
    frontPen:=intuiText^.frontPen;
    backPen:=intuiText^.backPen;
    drawMode:=intuiText^.drawMode;
    leftEdge:=intuiText^.leftEdge;
    topEdge:=intuiText^.topEdge+11;
    iTextFont:=intuiText^.iTextFont;
    nextText:=NIL;
  END;
  intuiText^.nextText:=newtext;
  RETURN newtext
END AddIText;

PROCEDURE DisposeIText(VAR intuiText: IntuiTextPtr);
VAR save: IntuiTextPtr;
BEGIN
  WHILE intuiText#NIL DO    
    save:=intuiText^.nextText;
    Deallocate(intuiText);
    intuiText:=save
  END
END DisposeIText;

BEGIN
  WriteString('Requster Demo'); WriteLn;
  WriteString('============='); WriteLn; WriteLn;
  intuibase:=OpenLibrary('intuition.library');
  IF intuibase=0D THEN
    WriteString('Error: library not opened'); WriteLn
  ELSE
    WITH nw DO
      leftEdge:=300;
      topEdge:=100;
      width:=200;
      height:=50;
      detailPen:=BYTE(0);
      blockPen:=BYTE(1);
      IDCMPFlags:=0;
      flags:=WINDOWDRAG + WINDOWDEPTH + WINDOWSIZING + NOCAREREFRESH;
      firstGadget:=NIL;
      checkMark:=NIL;
      AllocString(title, "Requester Demo ");
      screen:=NIL;
      bitMap:=NIL;
      minWidth:=150;
      minHeight:=25;
      maxWidth:=200;
      maxHeight:=50;
      type:=WBSCREEN 
    END;
    w:=OpenWindow(nw);
    IF w#NIL THEN
      bodyTextPtr:=NewIText("Requester brought up by ", 12, 5);
      dummy:=AddIText(bodyTextPtr, "a Modula 2 Program.");
      dummy:=AddIText(dummy, "True or False ???");
      nTextPtr:=NewIText("FALSE", 6, 3);
      pTextPtr:=NewIText("TRUE", 6, 3);
      REPEAT
        Delay(50);
      UNTIL AutoRequest(w, bodyTextPtr, pTextPtr, nTextPtr, 0, 0, 296, 76);
      DisposeIText(bodyTextPtr);
      DisposeIText(pTextPtr);
      DisposeIText(nTextPtr);
      CloseWindow(w)
    ELSE
      WriteString('Error: Window not opend'); WriteLn
    END;
  END;
  WriteString("You got it! Yes it's true"); WriteLn; WriteLn
END ReqDemo.
