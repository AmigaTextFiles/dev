MODULE AllInOne;

(*
 *  Source generated with GadToolsBox V1.4
 *  which is (c) Copyright 1991,92 Jaba Development
 *  Oberon-Sourcecode-Generator by Kai Bolay (AMOK)
 *)

IMPORT
  e: Exec, I: Intuition, gt: GadTools, g: Graphics, u: Utility, gf: GetFile, y: SYSTEM;

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
  GDGadget120                        = 12;
  GDGadget130                        = 13;
  GDGadget140                        = 14;
  GDGadget150                        = 15;
  GDGadget160                        = 16;
  GDGadget170                        = 17;

CONST
  Project0CNT = 18;
  Project0Left = 0;
  Project0Top = 0;
  Project0Width = 640;
  Project0Height = 256;
  Project1CNT = 0;
  Project1Left = 0;
  Project1Top = 0;
  Project1Width = 640;
  Project1Height = 27;
VAR
  Scr*: I.ScreenPtr;
  VisualInfo*: e.APTR;
  Project0Wnd*: I.WindowPtr;
  Project1Wnd*: I.WindowPtr;
  Project0GList*: I.GadgetPtr;
  Project0Menus*: I.MenuPtr;
  Project0Gadgets*: ARRAY Project0CNT OF I.GadgetPtr;
  GetImage: I.ObjectPtr;

TYPE
  Gadget800LArray = ARRAY     4 OF e.STRPTR;
CONST
  Gadget800Labels = Gadget800LArray (
    y.ADR ("Mutually"),
    y.ADR ("Exclusive"),
    y.ADR ("Gadgets"),
    NIL );

TYPE
  Gadget1000LArray = ARRAY     6 OF e.STRPTR;
CONST
  Gadget1000Labels = Gadget1000LArray (
    y.ADR ("This"),
    y.ADR ("Is"),
    y.ADR ("A"),
    y.ADR ("Cycle"),
    y.ADR ("Gadget"),
    NIL );

VAR
  Gadget300List: e.MinList;
  Gadget300Nodes: ARRAY 2 OF e.Node;
  Gadget400List: e.MinList;
  Gadget400Nodes: ARRAY 2 OF e.Node;
  Gadget500List: e.MinList;
  Gadget500Nodes: ARRAY 2 OF e.Node;
  Gadget700List: e.MinList;
  Gadget700Nodes: ARRAY 2 OF e.Node;
CONST
  topaz8 = g.TextAttr (y.ADR ("topaz.font"), 8, y.VAL (SHORTSET, 000H), y.VAL (SHORTSET, 001H) );

VAR
  Project0IText: ARRAY 6 OF I.IntuiText;
  Project1IText: ARRAY 1 OF I.IntuiText;
TYPE
  Project0MArray = ARRAY     5 OF gt.NewMenu;
CONST
  Project0NewMenu = Project0MArray (
    gt.title, y.ADR ("This is a Menu!"), NIL, {}, y.VAL (LONGSET, 0), NIL,
    gt.item, gt.barLabel, NIL, {}, LONGSET {}, NIL,
    gt.item, y.ADR ("^^ BarLabels are supported too ^^"), NIL, {}, y.VAL (LONGSET, 0), NIL,
    gt.sub, y.ADR ("And (ofcourse) sub-items are too !!"), NIL, {}, y.VAL (LONGSET, 0), NIL,
    gt.end, NIL, NIL, {}, LONGSET {}, NIL);
TYPE
  Project0GTypesArray = ARRAY Project0CNT OF INTEGER;
CONST
  Project0GTypes = Project0GTypesArray (
    gt.buttonKind,
    gt.checkBoxKind,
    gt.integerKind,
    gt.listViewKind,
    gt.listViewKind,
    gt.listViewKind,
    gt.stringKind,
    gt.listViewKind,
    gt.mxKind,
    gt.numberKind,
    gt.cycleKind,
    gt.paletteKind,
    gt.scrollerKind,
    gt.sliderKind,
    gt.stringKind,
    gt.textKind,
    gt.genericKind,
    gt.genericKind
  );

TYPE
  Project0NGadArray = ARRAY Project0CNT OF gt.NewGadget;
CONST
  Project0NGad = Project0NGadArray (
    7, 19, 285, 12, y.ADR ("_Disabled Button Gadget"), NIL, GDGadget00, LONGSET {gt.placeTextIn} ,NIL, NIL,
    7, 33, 26, 11, y.ADR ("CheckBox Gadget"), NIL, GDGadget10, LONGSET {gt.placeTextRight} ,NIL, NIL,
    7, 46, 122, 14, y.ADR ("Integer Gadget"), NIL, GDGadget20, LONGSET {gt.placeTextRight} ,NIL, NIL,
    7, 62, 284, 40, NIL, NIL, GDGadget30, LONGSET {} ,NIL, NIL,
    7, 104, 284, 28, NIL, NIL, GDGadget40, LONGSET {} ,NIL, NIL,
    7, 134, 284, 28, NIL, NIL, GDGadget50, LONGSET {} ,NIL, NIL,
    7, 205, 283, 12, NIL, NIL, GDGadget60, LONGSET {} ,NIL, NIL,
    7, 164, 283, 40, NIL, NIL, GDGadget70, LONGSET {} ,NIL, NIL,
    8, 207, 17, 9, NIL, NIL, GDGadget80, LONGSET {gt.placeTextRight} ,NIL, NIL,
    298, 19, 119, 12, y.ADR ("A ReadOnly Number Gadget"), NIL, GDGadget90, LONGSET {gt.placeTextRight} ,NIL, NIL,
    298, 33, 333, 12, NIL, NIL, GDGadget100, LONGSET {} ,NIL, NIL,
    297, 47, 333, 39, NIL, NIL, GDGadget110, LONGSET {} ,NIL, NIL,
    296, 87, 334, 12, NIL, NIL, GDGadget120, LONGSET {} ,NIL, NIL,
    297, 101, 301, 11, NIL, NIL, GDGadget130, LONGSET {} ,NIL, NIL,
    297, 114, 333, 12, NIL, NIL, GDGadget140, LONGSET {} ,NIL, NIL,
    297, 128, 332, 12, NIL, NIL, GDGadget150, LONGSET {} ,NIL, NIL,
    298, 190, 20, 14, NIL, NIL, GDGadget160, LONGSET {} ,NIL, NIL,
    461, 190, 20, 14, NIL, NIL, GDGadget170, LONGSET {} ,NIL, NIL
  );

TYPE
  Project0GTagsArray = ARRAY    90 OF u.Tag;
CONST
  Project0GTags = Project0GTagsArray (
    gt.underscore, y.ADR ('_'), I.gaDisabled, I.LTRUE, u.done,
    gt.cbChecked, I.LTRUE, u.done,
    gt.inNumber, 0, gt.inMaxChars, 10, u.done,
    gt.lvLabels, NIL, gt.lvShowSelected, NIL, u.done,
    gt.lvLabels, NIL, gt.lvReadOnly, I.LTRUE, u.done,
    gt.lvLabels, NIL, u.done,
    gt.stMaxChars, 256, u.done,
    gt.lvLabels, NIL, gt.lvShowSelected, 1, u.done,
    gt.mxLabels, y.ADR (Gadget800Labels[0]), gt.mxSpacing, 3, u.done,
    gt.nmNumber, 666, gt.nmBorder, I.LTRUE, u.done,
    gt.cyLabels, y.ADR (Gadget1000Labels[0]), gt.inNumber, 0, gt.inMaxChars, 5, u.done,
    gt.paDepth, 4, gt.paIndicatorWidth, 50, u.done,
    gt.scTotal, 50, gt.scArrows, 16, I.pgaFreedom, I.lorientHoriz, I.gaRelVerify, I.LTRUE, u.done,
    gt.slMaxLevelLen, 2, gt.slLevelFormat, y.ADR ("%2ld"), gt.slLevelPlace, y.VAL (y.ADDRESS, LONGSET {gt.placeTextRight}), I.pgaFreedom, I.lorientHoriz, I.gaRelVerify, I.LTRUE, u.done,
    gt.stString, y.ADR ("This is a String Gadget"), gt.stMaxChars, 256, u.done,
    gt.txText, y.ADR ("This is a ReadOnly Text Gadget"), gt.txBorder, I.LTRUE, u.done,
    u.done,
    I.gaDisabled, I.LTRUE, u.done
  );

TYPE
  ColorArray = ARRAY     9 OF I.ColorSpec;
CONST
  ScreenColors = ColorArray (
     0, 005H, 005H, 005H,
     1, 000H, 000H, 000H,
     2, 00BH, 00BH, 00BH,
     3, 008H, 008H, 008H,
     4, 00FH, 000H, 000H,
     5, 000H, 000H, 00FH,
     6, 000H, 00FH, 000H,
     7, 00DH, 00DH, 00AH,
    -1, 000H, 000H, 000H);

TYPE
  DriPenArray = ARRAY    10 OF INTEGER;
CONST
  DriPens = DriPenArray (0,1,1,2,1,7,1,3,2,-1);

PROCEDURE SetupScreen* (): INTEGER;
BEGIN
  Scr := I.OpenScreenTagsA (NIL, I.saLeft,          0,
            I.saTop,           0,
            I.saWidth,         640,
            I.saHeight,        256,
            I.saDepth,         4,
            I.saColors,        y.ADR (ScreenColors[0]),
            I.saFont,          y.ADR (topaz8),
            I.saType,          LONGSET {0..3} (* I.customScreen *),
            I.saDisplayID,     g.palMonitorID+g.hiresKey,
            I.saPens,          y.ADR (DriPens[0]),
            I.saTitle,         y.ADR ("GadToolsBox v1.4 © 1991,92 "),
            u.done);
  IF Scr = NIL THEN RETURN 1 END;

  VisualInfo := gt.GetVisualInfo (Scr, u.done);
  IF VisualInfo = NIL THEN RETURN 2 END;

  GetImage := I.NewObject (gf.GetFileClass, NIL, gt.visualInfo, VisualInfo, u.done);
  IF GetImage = NIL THEN RETURN 4 END;

  RETURN 0;
END SetupScreen;

PROCEDURE CloseDownScreen*;
BEGIN
  IF GetImage # NIL THEN
    I.DisposeObject (GetImage);
    GetImage := NIL;
  END;
  IF VisualInfo # NIL THEN
    gt.FreeVisualInfo (VisualInfo);
    VisualInfo := NIL;
  END;
  IF Scr # NIL THEN
    IF I.CloseScreen (Scr) THEN END;
    Scr := NIL;
  END;
END CloseDownScreen;

PROCEDURE Project0Render*;
VAR
  offx, offy: INTEGER;
BEGIN
  offx := 0;
  offy := Scr^.wBorTop + Scr^.rastPort.txHeight + 1;

  Project0IText[0] := I.IntuiText (4, 7, g.jam2+SHORTSET {}, 121, 6, y.ADR (topaz8), y.ADR (" This shows about all features of the program ! "), NIL);
  Project0IText[0].nextText := y.ADR (Project0IText[1]);
  Project0IText[1] := I.IntuiText (7, 0, g.jam1+SHORTSET {}, 393, 142, y.ADR (topaz8), y.ADR ("Some BevelBoxes"), NIL);
  Project0IText[1].nextText := y.ADR (Project0IText[2]);
  Project0IText[2] := I.IntuiText (6, 0, g.jam1+SHORTSET {}, 287, 211, y.ADR (topaz8), y.ADR ("Even some menus are added !!! Check it out."), NIL);
  Project0IText[2].nextText := y.ADR (Project0IText[3]);
  Project0IText[3] := I.IntuiText (4, 0, g.jam1+SHORTSET {}, 176, 227, y.ADR (topaz8), y.ADR ("And last but not least.... Another window is present too."), NIL);
  Project0IText[3].nextText := y.ADR (Project0IText[4]);
  Project0IText[4] := I.IntuiText (5, 0, g.jam1+SHORTSET {}, 322, 193, y.ADR (topaz8), y.ADR ("< GetFile gadget"), NIL);
  Project0IText[4].nextText := y.ADR (Project0IText[5]);
  Project0IText[5] := I.IntuiText (1, 0, g.jam1+SHORTSET {}, 487, 193, y.ADR (topaz8), y.ADR ("< Disabled"), NIL);
  Project0IText[5].nextText := NIL;

  I.PrintIText (Project0Wnd^.rPort, Project0IText[0], offx, offy);

  gt.DrawBevelBox (Project0Wnd^.rPort, offx + 470, offy + 154, 159, 23, gt.visualInfo, VisualInfo, gt.bbRecessed, I.LTRUE, u.done);
  gt.DrawBevelBox (Project0Wnd^.rPort, offx + 297, offy + 154, 168, 23, gt.visualInfo, VisualInfo, u.done);
  gt.DrawBevelBox (Project0Wnd^.rPort, offx + 0, offy + 2, 640, 243, gt.visualInfo, VisualInfo, gt.bbRecessed, I.LTRUE, u.done);
END Project0Render;

PROCEDURE OpenProject0Window* (): INTEGER;
TYPE
  TagArrayPtr = UNTRACED POINTER TO ARRAY MAX (INTEGER) OF u.TagItem;
VAR
  ng: gt.NewGadget;
  gad: I.GadgetPtr;
  tmp: u.TagItemPtr;
  help: TagArrayPtr;
  lc, tc, lvc, offx, offy: INTEGER;
BEGIN
  offx := 0; offy := Scr^.wBorTop + Scr^.rastPort.txHeight + 1;

  Gadget300Nodes[0].succ := y.ADR (Gadget300Nodes[1]);
  Gadget300Nodes[0].pred := y.ADR (Gadget300List.head);
  Gadget300Nodes[0].type := 0;
  Gadget300Nodes[0].pri  := 0;
  Gadget300Nodes[0].name := y.ADR ("ListView");

  Gadget300Nodes[1].succ := y.ADR (Gadget300List.tail);
  Gadget300Nodes[1].pred := y.ADR(Gadget300Nodes[0]);
  Gadget300Nodes[1].type := 0;
  Gadget300Nodes[1].pri  := 0;
  Gadget300Nodes[1].name := y.ADR ("Show Selected");

  Gadget300List.head     := y.ADR (Gadget300Nodes[0]);
  Gadget300List.tail     := NIL;
  Gadget300List.tailPred := y.ADR (Gadget300Nodes[1]);

  Gadget400Nodes[0].succ := y.ADR (Gadget400Nodes[1]);
  Gadget400Nodes[0].pred := y.ADR (Gadget400List.head);
  Gadget400Nodes[0].type := 0;
  Gadget400Nodes[0].pri  := 0;
  Gadget400Nodes[0].name := y.ADR ("ListView");

  Gadget400Nodes[1].succ := y.ADR (Gadget400List.tail);
  Gadget400Nodes[1].pred := y.ADR(Gadget400Nodes[0]);
  Gadget400Nodes[1].type := 0;
  Gadget400Nodes[1].pri  := 0;
  Gadget400Nodes[1].name := y.ADR ("Read Only");

  Gadget400List.head     := y.ADR (Gadget400Nodes[0]);
  Gadget400List.tail     := NIL;
  Gadget400List.tailPred := y.ADR (Gadget400Nodes[1]);

  Gadget500Nodes[0].succ := y.ADR (Gadget500Nodes[1]);
  Gadget500Nodes[0].pred := y.ADR (Gadget500List.head);
  Gadget500Nodes[0].type := 0;
  Gadget500Nodes[0].pri  := 0;
  Gadget500Nodes[0].name := y.ADR ("ListView");

  Gadget500Nodes[1].succ := y.ADR (Gadget500List.tail);
  Gadget500Nodes[1].pred := y.ADR(Gadget500Nodes[0]);
  Gadget500Nodes[1].type := 0;
  Gadget500Nodes[1].pri  := 0;
  Gadget500Nodes[1].name := y.ADR ("No Show Selected");

  Gadget500List.head     := y.ADR (Gadget500Nodes[0]);
  Gadget500List.tail     := NIL;
  Gadget500List.tailPred := y.ADR (Gadget500Nodes[1]);

  Gadget700Nodes[0].succ := y.ADR (Gadget700Nodes[1]);
  Gadget700Nodes[0].pred := y.ADR (Gadget700List.head);
  Gadget700Nodes[0].type := 0;
  Gadget700Nodes[0].pri  := 0;
  Gadget700Nodes[0].name := y.ADR ("ListView");

  Gadget700Nodes[1].succ := y.ADR (Gadget700List.tail);
  Gadget700Nodes[1].pred := y.ADR(Gadget700Nodes[0]);
  Gadget700Nodes[1].type := 0;
  Gadget700Nodes[1].pri  := 0;
  Gadget700Nodes[1].name := y.ADR ("Joined");

  Gadget700List.head     := y.ADR (Gadget700Nodes[0]);
  Gadget700List.tail     := NIL;
  Gadget700List.tailPred := y.ADR (Gadget700Nodes[1]);

  gad := gt.CreateContext (Project0GList);
  IF gad = NIL THEN RETURN 1 END;

  lc := 0; tc := 0; lvc := 0;
  WHILE lc < Project0CNT DO
    e.CopyMem (Project0NGad[lc], ng, y.SIZE (gt.NewGadget));
    ng.visualInfo := VisualInfo;
    ng.textAttr   := y.ADR (topaz8);
    INC (ng.leftEdge, offx);
    INC (ng.topEdge, offy);
    help := u.CloneTagItems (y.VAL (TagArrayPtr, y.ADR (Project0GTags[tc]))^);
    IF help = NIL THEN RETURN 8 END;
    IF Project0GTypes[lc] = gt.listViewKind THEN
      tmp := u.FindTagItem (gt.lvShowSelected, help^);
      IF tmp # NIL THEN
        IF tmp^.data # NIL THEN tmp^.data := gad END;
      END; (* IF *)
      tmp := u.FindTagItem (gt.lvLabels, help^);
      IF tmp # NIL THEN
        CASE lvc OF
        | 0: tmp^.data := y.ADR (Gadget300List);
        | 1: tmp^.data := y.ADR (Gadget400List);
        | 2: tmp^.data := y.ADR (Gadget500List);
        | 3: tmp^.data := y.ADR (Gadget700List);
        END; (* CASE *)
        INC (lvc);
      END; (* IF *)
    END; (* IF *)
    gad := gt.CreateGadgetA (Project0GTypes[lc], gad, ng, help^ );
    u.FreeTagItems (help^);
    IF gad = NIL THEN RETURN 2 END;
    Project0Gadgets[lc] := gad;

    IF Project0GTypes[lc] = gt.genericKind THEN
      INCL (gad^.flags, I.gadgImage);
      INCL (gad^.flags, I.gadgHImage);
      INCL (gad^.activation, I.relVerify);
      gad^.gadgetRender := GetImage;
      gad^.selectRender := GetImage;
    END; (* IF *)

    WHILE Project0GTags[tc]# u.done DO INC (tc, 2) END;
    INC (tc);

    INC (lc);
  END; (* WHILE *)
  Project0Menus := gt.CreateMenus (Project0NewMenu, gt.mnFrontPen, 0, u.done);
  IF Project0Menus = NIL THEN RETURN 3 END;

  IF NOT gt.LayoutMenus (Project0Menus, VisualInfo, gt.mnTextAttr, y.ADR (topaz8), u.done) THEN RETURN 4 END;

  Project0Wnd := I.OpenWindowTagsA ( NIL,
                    I.waLeft,          Project0Left,
                    I.waTop,           Project0Top,
                    I.waWidth,         Project0Width,
                    I.waHeight,        Project0Height + offy,
                    I.waIDCMP,         gt.buttonIDCMP+gt.checkBoxIDCMP+gt.integerIDCMP+gt.listViewIDCMP+gt.stringIDCMP+gt.mxIDCMP+gt.numberIDCMP+gt.cycleIDCMP+gt.paletteIDCMP+gt.scrollerIDCMP+gt.arrowIDCMP+gt.sliderIDCMP+gt.textIDCMP+LONGSET {I.gadgetUp}+LONGSET {I.menuPick,I.closeWindow,I.rawKey,I.refreshWindow},
                    I.waFlags,         LONGSET {I.backDrop,I.borderless},
                    I.waGadgets,       Project0GList,
                    I.waScreenTitle,   y.ADR ("GadToolsBox v1.3 © 1991,92"),
                    I.waCustomScreen,  Scr,
                    u.done);
  IF Project0Wnd = NIL THEN RETURN 20 END;

  IF NOT I.SetMenuStrip (Project0Wnd, Project0Menus^) THEN RETURN 5 END;
  gt.RefreshWindow (Project0Wnd, NIL);

  Project0Render;

  RETURN 0;
END OpenProject0Window;

PROCEDURE CloseProject0Window*;
BEGIN
  IF Project0Menus # NIL THEN
    I.ClearMenuStrip (Project0Wnd);
    gt.FreeMenus (Project0Menus);
    Project0Menus := NIL;
  END;
  IF Project0Wnd # NIL THEN
    I.CloseWindow (Project0Wnd);
    Project0Wnd := NIL;
  END;
  IF Project0GList # NIL THEN
    gt.FreeGadgets (Project0GList);
    Project0GList := NIL;
  END;
END CloseProject0Window;

PROCEDURE Project1Render*;
VAR
  offx, offy: INTEGER;
BEGIN
  offx := Project1Wnd^.borderLeft;
  offy := Project1Wnd^.borderTop;

  Project1IText[0] := I.IntuiText (4, 0, g.jam1+SHORTSET {}, 198, 3, y.ADR (topaz8), y.ADR ("This is the other window !!!"), NIL);
  Project1IText[0].nextText := NIL;

  I.PrintIText (Project1Wnd^.rPort, Project1IText[0], offx, offy);
END Project1Render;

PROCEDURE OpenProject1Window* (): INTEGER;
TYPE
  TagArrayPtr = UNTRACED POINTER TO ARRAY MAX (INTEGER) OF u.TagItem;
VAR
  ng: gt.NewGadget;
  gad: I.GadgetPtr;
  tmp: u.TagItemPtr;
  help: TagArrayPtr;
  lc, tc, lvc, offx, offy: INTEGER;
BEGIN
  offx := 0; offy := Scr^.wBorTop + Scr^.rastPort.txHeight + 1;

  Project1Wnd := I.OpenWindowTagsA ( NIL,
                    I.waLeft,          Project1Left,
                    I.waTop,           Project1Top,
                    I.waWidth,         Project1Width,
                    I.waHeight,        Project1Height + offy,
                    I.waIDCMP,         LONGSET {I.closeWindow,I.rawKey,I.refreshWindow},
                    I.waFlags,         LONGSET {I.windowSizing,I.windowDrag,I.windowDepth,I.windowClose},
                    I.waTitle,         y.ADR ("Work Window"),
                    I.waScreenTitle,   y.ADR ("GadToolsBox v1.2 © 1991 "),
                    I.waCustomScreen,  Scr,
                    I.waMinWidth,      67,
                    I.waMinHeight,     21,
                    I.waMaxWidth,      640,
                    I.waMaxHeight,     256,
                    u.done);
  IF Project1Wnd = NIL THEN RETURN 20 END;

  gt.RefreshWindow (Project1Wnd, NIL);

  Project1Render;

  RETURN 0;
END OpenProject1Window;

PROCEDURE CloseProject1Window*;
BEGIN
  IF Project1Wnd # NIL THEN
    I.CloseWindow (Project1Wnd);
    Project1Wnd := NIL;
  END;
END CloseProject1Window;


END AllInOne.
