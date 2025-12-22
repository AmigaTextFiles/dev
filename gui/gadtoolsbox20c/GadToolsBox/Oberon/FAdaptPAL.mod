MODULE FAdaptPAL;

(*
 *  Source generated with GadToolsBox V1.4
 *  which is (c) Copyright 1991,92 Jaba Development
 *  Oberon-Sourcecode-Generator by Kai Bolay (AMOK)
 *)

IMPORT
  e: Exec, I: Intuition, gt: GadTools, g: Graphics, u: Utility, y: SYSTEM;

CONST
  GDGadget00                         = 0;
  GDGadget10                         = 1;
  GDGadget20                         = 2;
  GDGadget30                         = 3;
  GDGadget40                         = 4;
  GDGadget50                         = 5;
  GDGadget60                         = 6;
  GDGadget70                         = 7;
  GDGadget80                         = 8;
  GDGadget90                         = 9;
  GDGadget100                        = 10;
  GDGadget110                        = 11;

CONST
  Project0CNT = 12;
  Project0Left = 67;
  Project0Top = 37;
  Project0Width = 463;
  Project0Height = 103;
VAR
  Scr*: I.ScreenPtr;
  VisualInfo*: e.APTR;
  Project0Wnd*: I.WindowPtr;
  Project0GList*: I.GadgetPtr;
  Project0Zoom*: ARRAY 4 OF INTEGER;
  Project0Gadgets*: ARRAY Project0CNT OF I.GadgetPtr;
  Font*: g.TextAttrPtr;
  Attr*: g.TextAttr;
  FontX, FontY: INTEGER;
  OffX, OffY: INTEGER;

TYPE
  Gadget500LArray = ARRAY     6 OF e.STRPTR;
CONST
  Gadget500Labels = Gadget500LArray (
    y.ADR ("This"),
    y.ADR ("Is"),
    y.ADR ("A"),
    y.ADR ("Cycle"),
    y.ADR ("Gadget"),
    NIL );

VAR
VAR
TYPE
  Project0GTypesArray = ARRAY Project0CNT OF INTEGER;
CONST
  Project0GTypes = Project0GTypesArray (
    gt.buttonKind,
    gt.buttonKind,
    gt.buttonKind,
    gt.integerKind,
    gt.numberKind,
    gt.cycleKind,
    gt.paletteKind,
    gt.scrollerKind,
    gt.sliderKind,
    gt.stringKind,
    gt.textKind,
    gt.buttonKind
  );

TYPE
  Project0NGadArray = ARRAY Project0CNT OF gt.NewGadget;
CONST
  Project0NGad = Project0NGadArray (
    5, 87, 129, 14, y.ADR ("Save First"), NIL, GDGadget00, LONGSET {gt.placeTextIn} ,NIL, NIL,
    166, 87, 129, 14, y.ADR ("Continue"), NIL, GDGadget10, LONGSET {gt.placeTextIn} ,NIL, NIL,
    329, 87, 129, 14, y.ADR ("Cancel"), NIL, GDGadget20, LONGSET {gt.placeTextIn} ,NIL, NIL,
    131, 5, 164, 14, y.ADR ("Integer Gadget"), NIL, GDGadget30, LONGSET {gt.placeTextLeft} ,NIL, NIL,
    132, 21, 163, 14, y.ADR ("Number Gadget "), NIL, GDGadget40, LONGSET {gt.placeTextLeft} ,NIL, NIL,
    12, 37, 283, 14, NIL, NIL, GDGadget50, LONGSET {} ,NIL, NIL,
    13, 53, 282, 28, NIL, NIL, GDGadget60, LONGSET {} ,NIL, NIL,
    298, 5, 21, 76, NIL, NIL, GDGadget70, LONGSET {} ,NIL, NIL,
    323, 5, 21, 76, NIL, NIL, GDGadget80, LONGSET {} ,NIL, NIL,
    347, 5, 105, 14, NIL, NIL, GDGadget90, LONGSET {} ,NIL, NIL,
    348, 21, 104, 14, NIL, NIL, GDGadget100, LONGSET {} ,NIL, NIL,
    348, 37, 104, 44, y.ADR ("Big Button"), NIL, GDGadget110, LONGSET {gt.placeTextIn} ,NIL, NIL
  );

TYPE
  Project0GTagsArray = ARRAY    52 OF u.Tag;
CONST
  Project0GTags = Project0GTagsArray (
    u.done,
    u.done,
    u.done,
    gt.inNumber, 0, gt.inMaxChars, 666, u.done,
    gt.nmBorder, I.LTRUE, u.done,
    gt.cyLabels, y.ADR (Gadget500Labels[0]), gt.inNumber, 0, gt.inMaxChars, 5, u.done,
    gt.paDepth, 2, gt.paIndicatorWidth, 40, u.done,
    gt.scTotal, 20, gt.scArrows, 16, I.pgaFreedom, I.lorientVert, I.gaRelVerify, I.LTRUE, u.done,
    gt.slMaxLevelLen, 2, gt.slLevelFormat, y.ADR (""), I.pgaFreedom, I.lorientVert, I.gaRelVerify, I.LTRUE, u.done,
    gt.stString, y.ADR ("String"), gt.stMaxChars, 256, u.done,
    gt.txText, y.ADR ("Text"), gt.txBorder, I.LTRUE, u.done,
    u.done
  );

PROCEDURE ComputeX (value: INTEGER): INTEGER;
BEGIN
  RETURN ((FontX * value) + 4 ) DIV 8;
END ComputeX;

PROCEDURE ComputeY (value: INTEGER): INTEGER;
BEGIN
  RETURN ((FontY * value)  + 4 ) DIV 8;
END ComputeY;

PROCEDURE ComputeFont (width, height: INTEGER);
BEGIN
  Font := y. ADR (Attr);
  Font^.name := Scr^.rastPort.font^.message.node.name;
  FontY := Scr^.rastPort.font^.ySize;
  Font^.ySize := FontY;
  FontX := Scr^.rastPort.font^.xSize;

  OffX := Scr^.wBorLeft;
  OffY := Scr^.rastPort.txHeight + Scr^.wBorTop + 1;

  IF (width # 0) AND (height # 0) AND
     (ComputeX (width) + OffX + Scr^.wBorRight > Scr^.width) OR
     (ComputeY (height) + OffY + Scr^.wBorBottom > Scr^.height) THEN
    Font^.name := y.ADR ("topaz.font");
    Font^.ySize := 8;
    FontY := Font^.ySize;
    FontX := Font^.ySize;
  END;
END ComputeFont;

PROCEDURE SetupScreen* (): INTEGER;
BEGIN
  Scr := I.LockPubScreen ("Workbench");  IF Scr = NIL THEN RETURN 1 END;

  ComputeFont (0, 0);

  VisualInfo := gt.GetVisualInfo (Scr, u.done);
  IF VisualInfo = NIL THEN RETURN 2 END;

  RETURN 0;
END SetupScreen;

PROCEDURE CloseDownScreen*;
BEGIN
  IF VisualInfo # NIL THEN
    gt.FreeVisualInfo (VisualInfo);
    VisualInfo := NIL;
  END;
  IF Scr # NIL THEN
    I.UnlockPubScreen (NIL, Scr);
    Scr := NIL;
  END;
END CloseDownScreen;

PROCEDURE Project0Render*;
BEGIN
  ComputeFont (Project0Width, Project0Height);

  gt.DrawBevelBox(Project0Wnd^.rPort, OffX + ComputeX (5),
                  OffY + ComputeY (2),
                  ComputeX (453),
                  ComputeY (82),
                  gt.visualInfo, VisualInfo, u.done);
END Project0Render;

PROCEDURE OpenProject0Window* (): INTEGER;
TYPE
  TagArrayPtr = UNTRACED POINTER TO ARRAY MAX (INTEGER) OF u.TagItem;
VAR
  ng: gt.NewGadget;
  gad: I.GadgetPtr;
  help: TagArrayPtr;
  lc, tc, lvc, offx, offy: INTEGER;
  wleft, wtop, ww, wh: INTEGER;
BEGIN
  wleft := Project0Left; wtop := Project0Top;

  ComputeFont (Project0Width, Project0Height);

  ww := ComputeX (Project0Width);
  wh := ComputeY (Project0Height);

  IF wleft + ww + OffX + Scr^.wBorRight > Scr^.width THEN
    wleft := Scr^.width - ww;
  END;
  IF wtop + wh + OffY + Scr^.wBorBottom > Scr^.height THEN
    wtop := Scr^.height - wh;
  END;
  gad := gt.CreateContext (Project0GList);
  IF gad = NIL THEN RETURN 1 END;

  lc := 0; tc := 0; lvc := 0;
  WHILE lc < Project0CNT DO
    ng := Project0NGad[lc];
    ng.visualInfo := VisualInfo;
    ng.textAttr   := Font;
    ng.leftEdge   := OffX + ComputeX (ng.leftEdge);
    ng.topEdge    := OffY + ComputeY (ng.topEdge);
    ng.width      := ComputeX (ng.width);
    ng.height     := ComputeY (ng.height);

    help := u.CloneTagItems (y.VAL (TagArrayPtr, y.ADR (Project0GTags[tc]))^);
    IF help = NIL THEN RETURN 8 END;
    gad := gt.CreateGadgetA (Project0GTypes[lc], gad, ng, help^ );
    u.FreeTagItems (help^);
    IF gad = NIL THEN RETURN 2 END;
    Project0Gadgets[lc] := gad;

    WHILE Project0GTags[tc] # u.done DO INC (tc, 2) END;
    INC (tc);

    INC (lc);
  END; (* WHILE *)
  Project0Zoom[0] := 0;
  Project0Zoom[1] := 0;
  Project0Zoom[2] := g.TextLength (y.ADR (Scr^.rastPort), "Font Adapt Test...", 18) + 80;
  Project0Zoom[3] := Scr^.wBorTop + Scr^.rastPort.txHeight + 1;

  Project0Wnd := I.OpenWindowTagsA ( NIL,
                    I.waLeft,          wleft,
                    I.waTop,           wtop,
                    I.waWidth,         ww + OffX + Scr^.wBorRight,
                    I.waHeight,        wh + OffY + Scr^.wBorBottom,
                    I.waIDCMP,         gt.buttonIDCMP+gt.integerIDCMP+gt.numberIDCMP+gt.cycleIDCMP+gt.paletteIDCMP+gt.scrollerIDCMP+gt.arrowIDCMP+gt.sliderIDCMP+gt.stringIDCMP+gt.textIDCMP+LONGSET {I.menuPick,I.closeWindow,I.refreshWindow},
                    I.waFlags,         LONGSET {I.windowDrag,I.windowDepth,I.windowClose,I.sizeBRight,I.sizeBBottom},
                    I.waGadgets,       Project0GList,
                    I.waTitle,         y.ADR ("Font Adapt Test..."),
                    I.waZoom,          y.ADR (Project0Zoom),
                    u.done);
  IF Project0Wnd = NIL THEN RETURN 20 END;

  Project0Zoom[0] := Project0Wnd^.leftEdge;
  Project0Zoom[1] := Project0Wnd^.topEdge;
  Project0Zoom[2] := Project0Wnd^.width;
  Project0Zoom[3] := Project0Wnd^.height;

  gt.RefreshWindow (Project0Wnd, NIL);

  Project0Render;

  RETURN 0;
END OpenProject0Window;

PROCEDURE CloseProject0Window*;
BEGIN
  IF Project0Wnd # NIL THEN
    I.CloseWindow (Project0Wnd);
    Project0Wnd := NIL;
  END;
  IF Project0GList # NIL THEN
    gt.FreeGadgets (Project0GList);
    Project0GList := NIL;
  END;
END CloseProject0Window;


END FAdaptPAL.
