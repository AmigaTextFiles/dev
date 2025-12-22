(********************************************************************************

Name         : HelloWorld.MOD
Version      : 1.0
Purpose      : Demo For Screen And Windows From Intuition Manual
Author       : ms
Modified     : 1.4.86  23:48  ms

********************************************************************************)

MODULE HelloWorld;

FROM Terminal   IMPORT WriteString, WriteLn;
FROM SYSTEM     IMPORT ADDRESS, ADR, BYTE, LONG;
FROM AMIGADos   IMPORT Delay;
FROM AMIGABase  IMPORT ExecBase, ExecOpenLib, LibCall, Regs;

CONST CLOSEWINDOW   =   512D;
      WINDOWCLOSE   =     8D;
      ACTIVATE      =  4096D;
      WINDOWDRAG    =     2D;
      WINDOWDEPTH   =     4D;
      WINDOWSIZING  =     1D;
      BORDERLESS    =  2048D;
      NOCAREREFRESH =131072D;
      CUSTOMSCREEN  =    0FH;
      WBSCREEN      =    01H; 
      HIRES         =  8000H;
      INTERLACE     =    04H;
      RPORTOFFSET   =     25;
      USERPORTOFS   =     43;

TYPE NewWindow = RECORD
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
                   title,
                   screen,
                   bitMap: ADDRESS;
                   minWidth,
                   minHeight,
                   maxWidth,
                   maxHeight: CARDINAL;
                   type: CARDINAL
                 END;

     NewScreen = RECORD
                   leftEdge,
                   topEdge,
                   width,
                   height,
                   depth: CARDINAL;
                   detailPen,
                   blockPen: BYTE;
                   viewModes,
                   type: CARDINAL;
                   font,
                   title,
                   gadget,
                   bitMap: ADDRESS
                 END;

     MsgPort   = RECORD
                   mpNode: ARRAY [0..13] OF BYTE;    (* TSIZE(Node) = 14  *)
                   mpFlags,
                   mpSigBit: BYTE;
                   mpSigTask: ADDRESS;
                   mpMsgList: ARRAY [0..13] OF BYTE  (* TSIZE(List) = 14 *)
                 END;

(*   dummy types for window data structure *)

     Window    = ARRAY [0..63] OF CARDINAL;

     WindowPtr = POINTER TO Window;

PROCEDURE OpenLibrary(st: ARRAY OF CHAR): LONGINT;
VAR r: Regs;
BEGIN
  r.a[1]:=ADR(st);
  r.d[0]:=0D;
  LibCall(ExecBase(), ExecOpenLib(), r);
  RETURN r.d[0]
END OpenLibrary;

VAR nw: NewWindow;
    ns: NewScreen;
    w: WindowPtr;
    up: POINTER TO MsgPort;
    s, len: LONGINT;
    i, intuibase, gfxbase: LONGINT;
    st, wt: ARRAY [0..31] OF CHAR;
    t: ARRAY [0..99] OF CHAR;

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

PROCEDURE OpenScreen(VAR ns: NewScreen): LONGINT;
VAR r: Regs;
BEGIN
  r.a[0]:=ADR(ns);
  LibCall(intuibase, -198D, r);
  RETURN r.d[0]
END OpenScreen;  

PROCEDURE CloseScreen(s: LONGINT);
VAR r: Regs;
BEGIN
  r.a[0]:=s;
  LibCall(intuibase, -66D,r);
END CloseScreen;

PROCEDURE Move(rP: ADDRESS; x, y: LONGINT);
VAR r: Regs;
BEGIN
  r.a[1]:=rP;
  r.d[0]:=x;
  r.d[1]:=y;
  LibCall(gfxbase, -240D, r);
END Move;

PROCEDURE Wait(signalSet: LONGINT);
VAR r: Regs;
BEGIN
  r.d[0]:=signalSet;
  LibCall(ExecBase(), -318D, r);
END Wait;

PROCEDURE Text(rP: ADDRESS; VAR st: ARRAY OF CHAR; len: LONGINT);
VAR r: Regs;
BEGIN
  r.a[1]:=rP;
  r.a[0]:=ADR(st);
  r.d[0]:=len;
  LibCall(gfxbase, -60D, r);
END Text;

BEGIN
  WriteString("Hello World, Screen and Window Demo from Intuition Manual"); WriteLn;
  WriteString("=========================================================");
  WriteLn; WriteLn;
  Delay(25);
  st:='intuition.library';
  intuibase:=OpenLibrary(st);
  st:='graphics.library';
  gfxbase:=OpenLibrary(st);
  IF (intuibase=0D) OR (gfxbase=0D) THEN
    WriteString('Error: libraries not opened'); WriteLn
  ELSE
    st:='My Own Screen';
    WITH ns DO
      leftEdge:=0;
      topEdge:=100;
      width:=640;
      height:=200 (* 400 *);
      depth:=2;
      detailPen:=BYTE(0);
      blockPen:=BYTE(1);
      viewModes:=HIRES (* + INTERLACE *) ;
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
    wt:='A Simple Window';
    WITH nw DO
      leftEdge:=20;
      topEdge:=20;
      width:=600;
      height:=150;
      detailPen:=BYTE(0);
      blockPen:=BYTE(1);
      IDCMPFlags:=CLOSEWINDOW;
      flags:=WINDOWCLOSE + ACTIVATE + WINDOWDRAG + WINDOWDEPTH
             + WINDOWSIZING + NOCAREREFRESH;
      firstGadget:=0D;
      checkMark:=0D;
      title:=ADR(wt);
      screen:=ADDRESS(s);
      bitMap:=0D;
      minWidth:=130;
      minHeight:=25;
      maxWidth:=640;
      maxHeight:=200;
      type:=CUSTOMSCREEN 
    END;
    w:=OpenWindow(nw);
    IF LONGINT(w)#0D THEN
      Move(LONG(w^[RPORTOFFSET], w^[RPORTOFFSET+1]), 10D, 20D);
      t:='Hello World'; len:=11D;
      Text(LONG(w^[RPORTOFFSET], w^[RPORTOFFSET+1]), t, len);

      up:=ADDRESS(LONG(w^[USERPORTOFS], w^[USERPORTOFS+1]));
      Wait(SHIFT(1D, CARDINAL(up^.mpSigBit)));
    ELSE
      WriteString('Error: OpenWindow not done '); WriteLn
    END;
    CloseWindow(w);
    CloseScreen(s);
  END;
END HelloWorld.
