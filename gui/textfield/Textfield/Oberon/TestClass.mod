MODULE TestClass;

(* This is just a small example, no prefwindow yet...
** I had no time to improve it.
**
** Stefan
**
** slbrbbbh@w250zrz.zrz.TU-Berlin.de
**    StElb@IRC
*)


IMPORT
  y := SYSTEM,

  d := Dos,
  e := Exec,
  g := Graphics,
  IP := IFFParse,
  I := Intuition,
  TF := TextField,
  u := Utility;

CONST
  versionString = "$VER: TestClass.mod 0.4 (18.09.94)";

VAR
  window: I.WindowPtr;
  dri: I.DrawInfoPtr;
  pens: I.DRIPenArrayPtr;
  edit, prop, up, down: I.GadgetPtr;
  upi, downi: I.ImagePtr;
  cliphandle, undohandle: IP.ClipboardHandlePtr;
  textbuffer, mybuffer: e.LSTRPTR;
  length: LONGINT;

CONST
  initialtext = "Sample text placed immediatly into the "
                "object.\nOr try AMIGA-[, AMIGA-=, AMIGA-]"
                "or AMIGA-\\. \n";
  moretext = "I think the gadget looks best withe the double-bevel border"
             "and a medium cursor speed.";
  prop2edit = u.Tags2(I.pgaTop, TF.top, u.done, 0);
  edit2prop = u.Tags4(TF.top, I.pgaTop,
                      TF.visible, I.pgaVisible,
                      TF.lines, I.pgaTotal,
                      u.done, 0);
  up2edit = u.Tags2(I.gaID, TF.up, u.done, 0);
  down2edit = u.Tags2(I.gaID, TF.down, u.done, 0);



PROCEDURE Init():BOOLEAN;

BEGIN
  cliphandle := IP.OpenClipboard(0);
  undohandle := IP.OpenClipboard(255);

  window := I.OpenWindowTagsA(NIL,
                    I.waFlags, LONGSET{I.windowDepth, I.windowDrag, I.windowClose, I.windowSizing,
                                       I.sizeBBottom, I.sizeBRight},
                    I.waActivate, e.LTRUE,
                    I.waIDCMP, LONGSET{I.closeWindow},
                    I.waWidth, 320,
                    I.waHeight, 200,
                    I.waNoCareRefresh, e.LTRUE,
                    I.waTitle, y.ADR("This is just a small example..."),
                    I.waScreenTitle, y.ADR("Testing textfield.gadget"),
                    u.done);
  IF window = NIL THEN RETURN FALSE END;
  dri := I.GetScreenDrawInfo(window.wScreen);
  IF dri = NIL THEN RETURN FALSE END;
  pens := dri.pens;
  IF I.WindowLimits(window, 160, window.borderTop + window.borderBottom +
                                 window.wScreen.rastPort.txHeight + 46, -1, -1) THEN END;
  prop := I.NewObject(NIL, "propgclass",
                    I.gaID, 2,
                    I.gaTop, window.borderTop,
                    I.gaRelRight, -(window.borderRight - 5),
                    I.gaWidth, window.borderRight - 8,
                    I.gaRelHeight, -(window.borderTop + 3*(window.borderBottom)) - 2,
                    I.gaRightBorder, e.LTRUE,
                    I.icaMap, y.ADR(prop2edit),
                    I.pgaNewLook, e.LTRUE,
                    I.pgaBorderless, e.LTRUE,
                    I.gaBorder, e.LTRUE,
                    I.pgaVisible, 50,
                    I.pgaTotal, 50,
                    u.done);
  upi := I.NewObject(NIL, "sysiclass",
                    I.sysiaDrawInfo, dri,
                    I.sysiaWhich, I.upImage,
                    I.iaWidth, window.borderRight,
                    I.iaHeight, window.borderBottom,
                    u.done);
  downi := I.NewObject(NIL, "sysiclass",
                    I.sysiaDrawInfo, dri,
                    I.sysiaWhich, I.downImage,
                    I.iaWidth, window.borderRight,
                    I.iaHeight, window.borderBottom,
                    u.done);
  up := I.NewObject(NIL, "buttongclass",
                    I.gaRelBottom, -(3 * window.borderBottom) - 1,
                    I.gaRelRight, -(window.borderRight - 1),
                    I.gaHeight, window.borderBottom,
                    I.gaWidth, window.borderRight,
                    I.gaImage, upi,
                    I.gaRightBorder, e.LTRUE,
                    I.gaRelVerify, e.LTRUE,
                    I.gaPrevious, prop,
                    I.icaMap, y.ADR(up2edit),
                    u.done);
  down := I.NewObject(NIL, "buttongclass",
                    I.gaRelBottom, -(2 * window.borderBottom),
                    I.gaRelRight, -(window.borderRight - 1),
                    I.gaHeight, window.borderBottom,
                    I.gaWidth, window.borderRight,
                    I.gaImage, downi,
                    I.gaRightBorder, e.LTRUE,
                    I.gaRelVerify, e.LTRUE,
                    I.gaPrevious, up,
                    I.icaMap, y.ADR(down2edit),
                    u.done);
  edit := I.NewObject(TF.textFieldClass, NIL,
                    I.gaID, 1,
                    I.gaTop, window.borderTop + 20,
                    I.gaLeft, window.borderLeft + 20,
                    I.gaRelWidth, -(window.borderLeft + window.borderRight + 40),
                    I.gaRelHeight, -(window.borderTop + window.borderBottom + 40),
                    I.gaPrevious, down,
                    I.icaMap, y.ADR(edit2prop),
                    I.icaTarget, prop,
                    TF.text, y.ADR(initialtext),
                    TF.border, TF.doubleBevel,
                    TF.userAlign, e.LTRUE,
                    TF.clipStream, cliphandle,
                    TF.clipStream2, undohandle,
                    TF.cursorPos, 10,
                    u.done);
  RETURN (edit # NIL) & (prop # NIL) & (upi # NIL) & (downi # NIL) & (up # NIL) & (down # NIL);
END Init;



PROCEDURE Connect();
VAR
  d: LONGINT;

BEGIN
  d := I.SetGadgetAttrs(prop^, window, NIL, I.icaTarget, edit, u.done);
  d := I.SetGadgetAttrs(up^, window, NIL, I.icaTarget, edit, u.done);
  d := I.SetGadgetAttrs(down^, window, NIL, I.icaTarget, edit, u.done);
  d := I.AddGList(window, prop, -1, -1, NIL);
  I.RefreshGadgets(prop, window, NIL);
END Connect;



PROCEDURE MainLoop();
VAR
  signal: LONGSET;
  imsg: I.IntuiMessagePtr;
  going: BOOLEAN;

BEGIN
  going := TRUE;
  WHILE going DO
    signal := e.Wait(LONGSET{window.userPort.sigBit, d.ctrlC});
    IF d.ctrlC IN signal THEN going := FALSE END;
    REPEAT
      imsg := e.GetMsg(window.userPort);
      IF imsg # NIL THEN
        IF (I.closeWindow IN imsg.class) THEN going := FALSE;
        (*ELSIF etc. pp. *)
        END;
        e.ReplyMsg(imsg);
      END;
    UNTIL imsg = NIL;
  END; (* WHILE going *)
END MainLoop;

BEGIN
  IF Init() THEN END;
  Connect();
  MainLoop();
CLOSE
  IF dri # NIL THEN I.FreeScreenDrawInfo(window.wScreen, dri) END;
  IF window # NIL THEN I.CloseWindow(window) END;
  IF prop # NIL THEN IF I.RemoveGList(window, prop, -1) = 0 THEN END END;
  I.DisposeObject(prop);
  I.DisposeObject(up);
  I.DisposeObject(down);
  I.DisposeObject(edit);
  I.DisposeObject(upi);
  I.DisposeObject(downi);
  IP.CloseClipboard(cliphandle);
  IP.CloseClipboard(undohandle);
END TestClass.
