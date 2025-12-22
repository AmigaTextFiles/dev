MODULE Borders;

(*
**      BORDERS.C
**
**      (C) Copyright 1996 Jaba Development.
**      (C) Copyright 1996 Jan van den Baard.
**          All Rights Reserved.
**
**          Oberon Conversion - Larry Kuhns  12/01/96
*)

IMPORT
  b  := Bgui,
  bm := BguiMacro,
  dc := DemoCode,
  e  := Exec,
  i  := Intuition,
  u  := Utility,
  y  := SYSTEM;

CONST

(*
**      Object ID.
**)
  idQuit *= 1;

VAR
  window : i.WindowPtr;
  woWindow : b.Object;
  goQuit   : b.Object;
  signal   : LONGSET;
  rc       : LONGINT;
  running  : BOOLEAN;

TYPE
  msgs = ARRAY 5 OF e.STRPTR;
CONST
  error = msgs( y.ADR("Borders demo ending\n"),
                y.ADR("Error creating window object\n"),
                y.ADR("Could not assign gadget key\n"),
                y.ADR("Could not open the window\n"),
                NIL );


  PROCEDURE Terminate( win : i.WindowPtr; msg : INTEGER );
    VAR
      ok : BOOLEAN;
    BEGIN
      dc.Tell( win, error[msg]^ );
      (*
      **  Disposing of the window object will
      **  also close the window if it is
      **  already opened and it will dispose of
      **  all objects attached to it.
      *)
      IF woWindow      # NIL THEN i.DisposeObject( woWindow ) END;
      IF msg = 0 THEN HALT( 0 ) ELSE HALT( 20 ) END;
    END Terminate;


  PROCEDURE BuildGUI;
    VAR
      vg1, in1a : b.Object;
      hg1       : b.Object;
      vg2, pr2a : b.Object;
      vg3, sl3a : b.Object;
      vg4, in4a : b.Object;
    BEGIN
      (*
      **      A simple vertical group
      **      containing a descriptive text
      *)
      in1a:= bm.InfoFixed(
         NIL, y.ADR("\ecThis small demo shows the possibility\nto add BGUI groups to the window borders"),
         NIL, 2 );

      vg1:= bm.VGroupObject(
         b.groupHorizOffset, 4,              (* HOffset(4) *)
         b.groupHorizOffset, 4,              (* VOffset(4) *)
         b.groupSpacing,     4,              (* Spacing(4) *)
         b.groupBackfill,    b.shineRaster,
         b.groupMember, in1a, u.done, 0,
         u.done );

      (*
      **      NOTE: All objects which are located inside a group
      **            in a window border must have their GA_xxxBorder
      **            flag set. This also means the groups themselves.
      *)

      (*
      **      A horizontal group which will show a
      **      quit button just left of the system
      **      gadgets in the top border.
      *)

      goQuit:= bm.ButtonObject(
         b.frmType,            b.frTypeBorder,
         b.labLabel,           y.ADR("Quit"),
         (*
         **      This tag will make the object
         **      as small as possible making it
         **      fit well in the top-border.
         *)
         b.buttonEncloseImage, e.true,
         i.gaTopBorder,        e.true,
         i.gaID,               idQuit,
         u.done );

      hg1:= bm.HGroupObject(
         i.gaTopBorder,      e.true,
         b.groupSpaceObject, b.defaultWeight,  (* VarSpace(defaultWeight) *)
         b.groupMember, goQuit,
                        b.lgoFixMinWidth, e.true, (* FixMinWidth *)
                        u.done, 0,
         u.done );

      (*
      **      A vertical group containing a
      **      proportional object in the right border.
      *)
      pr2a:= bm.PropObject(
         i.pgaNewLook,    e.true,
         i.pgaBorderless, e.false,
         i.pgaTotal,      10,
         i.pgaVisible,    1,
         i.gaRightBorder, e.true,
         u.done );

      vg2:= bm.VGroupObject(
         i.gaRightBorder, e.true,
         b.groupMember, pr2a, u.done, 0,
         u.done );

      (*
      **      A vertical group containing a slider
      **      object in the left border.
      *)
      sl3a:= bm.SliderObject(
         i.pgaFreedom,            LONGSET{i.freeVert},
         i.pgaNewLook,            e.true,
         i.pgaBorderless,         e.false,
         i.gaLeftBorder,          e.true,
         u.done );

      vg3:= bm.VGroupObject(
         i.gaLeftBorder, e.true,
         b.groupMember, sl3a, u.done, 0,
         u.done );

      (*
      **      A horizontal group containing a info
      **      object in the bottom border.
      *)
      in4a:= bm.InfoObject(
         b.frmType,          b.frTypeBorder,
         b.infoHorizOffset,  2,
         b.infoVertOffset,   2,
         b.infoTextFormat,   y.ADR("\ec\eb\ed8Zippedidooda..."),
         b.infoFixTextWidth, e.true,
         i.gaBottomBorder,   e.true,
         u.done );

      vg4:= bm.VGroupObject(
         i.gaBottomBorder, e.true,
         b.groupMember, in4a, u.done, 0,
         u.done );

      (*
      **      Create the window object.
      *)
      woWindow:= bm.WindowObject(
         b.windowTitle,        y.ADR("Borders Demo"),
         b.windowSizeGadget,   e.true,
         b.windowRMBTrap,      e.true,
         b.windowAutoAspect,   e.true,
         b.windowSizeRight,    e.true,
         b.windowMasterGroup,  vg1,
         b.windowTBorderGroup, hg1,
         b.windowRBorderGroup, vg2,
         b.windowLBorderGroup, vg3,
         b.windowBBorderGroup, vg4,
         u.done );


  END BuildGUI;

BEGIN
  window:= NIL;
  running:= TRUE;
  BuildGUI;
  (*
  **      Object created OK?
  **)
  IF woWindow = NIL THEN Terminate( NIL, 1 ) END;
  (*
  **      Assign a key to the button.
  **)
  IF bm.GadgetKeyA( woWindow, goQuit, y.ADR("q")) = 0 THEN Terminate( NIL, 2 ) END;
  (*
  **      try to open the window.
  **)
  window:= bm.WindowOpen( woWindow );
  IF window = NIL THEN Terminate( NIL, 3 ) END;
  (*
  **      Obtain it's wait mask.
  **)
  rc:= i.GetAttr( b.windowSigMask, woWindow, signal );
  (*
  **      Event loop...
  **)
  WHILE running DO
    y.SETREG( 0, e.Wait( signal ));
    (*
    **      Handle events.
    **)
    LOOP
      (*
      **      Evaluate return code.
      *)
      CASE bm.HandleEvent( woWindow ) OF
      | b.wmhiNoMore        : EXIT;
      | b.wmhiCloseWindow,
        idQuit              : running:= FALSE;
      ELSE
      END;
    END;
  END;

  Terminate( window, 0 );

END Borders.
