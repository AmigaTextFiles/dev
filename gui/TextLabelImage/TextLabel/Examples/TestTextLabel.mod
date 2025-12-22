(*(*(*********************************************************************

:Program.    TestTextLabel.mod
:Contents.   test module for textlabel.image
:Author.     hartmut Goebel [hG]
:Address.    Aufseßplatz 5, D-90459 Nürnberg
:Address.    UseNet: hartmut@oberon.nbg.sub.org
:Copyright.  Copyright © 1993,1994 by hartmut Goebel
:Language.   Oberon-2
:Translator. Amiga Oberon 3.11
:Version.    $VER: TestTextLabel.mod 2.1 (18.7.95)

(* $StackChk- $NilChk- $RangeChk- $CaseChk- $OvflChk- $ReturnChk- $ClearVars- *)
*********************************************************************)*)*)

MODULE TestTextLabel;

IMPORT
  TL := TextLabel,
  e := Exec,
  I := Intuition,
  NoGuru,
  CF := Classface,
  u := Utility,
  y := SYSTEM;

VAR
  win : I.WindowPtr;
  scr: I.ScreenPtr;
  drawinfo: I.DrawInfoPtr;

CONST
  versionString = "$VER: TestTextLabel 2.1 (18.7.95)";

  numImages = 5;

TYPE
  ImageTypes = ARRAY numImages OF INTEGER;
  Labels = ARRAY numImages OF e.STRPTR;
  LabelTags = ARRAY numImages OF u.Tags2;
CONST
  leftOffset = 20; rightOffset = 20;
  labelHeight = 20;
  imageDistance = 4;

  labels = Labels(y.ADR("_yellow submarine"),
                  y.ADR("M_MMassivholz"),
                  y.ADR("Te$Telefon"),
                  y.ADR("Logik und Berechenbar_keit"),
                  y.ADR("Shortcut is __")
                  );

  labelTags = LabelTags(TL.aAdjustment, TL.adjustHLeft,
                        u.done, 0,

                        I.iaFGPen, I.textPen,
                        u.done, 0,

                        TL.aUnderscore, ORD("$"),
                        u.done, 0,

                        TL.aUnderscore, ORD(CHR(0)),
                        u.done, 0,

                        TL.aUnderscore, ORD("_"),
                        u.done, 0);


PROCEDURE MakeImage(VAR image: I.ImagePtr; num: INTEGER);
BEGIN
  image := I.NewObject(TL.base.class, NIL,
                       I.iaData, labels[num],
                       I.iaLeft, leftOffset,
                       I.iaTop,  num*labelHeight+50,
                       I.sysiaDrawInfo, drawinfo,
                       u.more, y.ADR(labelTags[num]));
  IF image = NIL THEN HALT(20); END;
END MakeImage;


PROCEDURE WaitClose();
VAR
  msg: I.IntuiMessagePtr;
  class: LONGSET;
BEGIN
  LOOP
    e.WaitPort(win.userPort);
    msg := e.GetMsg(win.userPort);
    WHILE msg # NIL DO
      class := msg.class;
      e.ReplyMsg(msg);
      IF class = LONGSET{I.closeWindow} THEN RETURN END;
      msg := e.GetMsg(win.userPort);
    END;
  END;
END WaitClose;


VAR
  images: ARRAY numImages OF I.ImagePtr;
  i: INTEGER; width: INTEGER;
  gadget: I.GadgetPtr;
  frame : I.ImagePtr;

BEGIN
  IF I.int.libNode.version < 37 THEN HALT(20) END;
  IF TL.base.lib.version < 2 THEN HALT(20) END;

  scr := I.LockPubScreen(NIL);

  drawinfo :=I.GetScreenDrawInfo(scr);
  IF drawinfo # NIL THEN

    width := 0;
    FOR i := 0 TO numImages-1 DO
      MakeImage(images[i],i);
      IF width < images[i].width THEN width := images[i].width; END;
    END;

    frame := I.NewObject(NIL,I.frameIClass,
                             I.iaFrameType, I.frameButton,
                             u.done);

    gadget := I.NewObject(NIL,I.frButtonClass,
                              I.gaTop,       (i+1)*labelHeight+50,
                              I.gaLeft,      leftOffset,
                              I.gaImage,     frame,
                              I.gaLabelImage,images[0],
                              u.done);

    IF width < gadget.width THEN width := gadget.width; END;

    win := I.OpenWindowTagsA(NIL,
             I.waPubScreen,scr,
             I.waInnerWidth, width+leftOffset-scr.wBorLeft+rightOffset-scr.wBorRight,
             I.waInnerHeight, 200,
             I.waTitle, y.ADR(versionString),
             I.waFlags, LONGSET{I.windowDepth,I.windowDrag,I.windowClose},
             I.waIDCMP, LONGSET{I.closeWindow},
             I.waGadgets, gadget,
             u.end);

    I.UnlockPubScreen(NIL,scr);

    IF win # NIL THEN

      FOR i := 0 TO numImages-1 DO
        I.DrawImageState(win.rPort,images[i]^,0,0,I.idsNormal,drawinfo);
      END;

      WaitClose();

    END;
      I.FreeScreenDrawInfo(win.wScreen, drawinfo);
  END;

CLOSE
  FOR i := numImages-1 TO 0 BY -1 DO
    I.DisposeObject(images[i]);
  END;
  I.DisposeObject(gadget);
  I.DisposeObject(frame);
  IF win# NIL THEN I.CloseWindow(win); END;

END TestTextLabel.
