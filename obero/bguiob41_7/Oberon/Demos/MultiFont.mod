MODULE MultiFont;

(*
** MULTIFONT.C
**
** (C) Copyright 1995 Jaba Development.
** (C) Copyright 1995 Jan van den Baard.
**     All Rights Reserved.
**
**     Oberon Conversion - Larry Kuhns  12/01/96
*)

IMPORT
  b    : Bgui,
  bm   : BguiMacro,
  d    : Dos,
  dc   : DemoCode,
  df   : DiskFont,
  e    : Exec,
  g    : Graphics,
  i    : Intuition,
  u    : Utility,
  y    : SYSTEM;


CONST
  (*
  ** Fonts used in the code.
  *)
  ButtonFont = g.TextAttr( y.ADR("helvetica.font"), 13, g.normal, SHORTSET{g.diskFont} );
  Info1Font  = g.TextAttr( y.ADR("helvetica.font"), 24, g.normal, SHORTSET{g.diskFont} );
  Info2Font  = g.TextAttr( y.ADR("times.font"),     13, g.normal, SHORTSET{g.diskFont} );

  (*
  ** Object ID's
  *)
  idQuit *= 1;

  (*
  ** Info texts.
  *)
  IText1 = "\ec\ed8MultiFont";
  IText2 = "\ecThis demo shows you how you\ncan use different fonts inside a\nsingle window.";

VAR
  Button   : g.TextFontPtr;
  Info1    : g.TextFontPtr;
  Info2    : g.TextFontPtr;
  window   : i.WindowPtr;
  woWindow : b.Object;
  goQuit   : b.Object;
  signal   : LONGSET;
  rc       : LONGINT;
  running  : BOOLEAN;

PROCEDURE Terminate( win : i.WindowPtr; str : ARRAY OF CHAR );
  (* $CopyArrays- *)
  VAR
  BEGIN
    IF str # "" THEN dc.Tell( win, str ) END;
    (*
    **  Disposing of the window object will
    **  also close the window if it is
    **  already opened and it will dispose of
    **  all objects attached to it.
    *)
    IF woWindow # NIL THEN i.DisposeObject( woWindow ) END;
    IF Button   # NIL THEN g.CloseFont( Button ) END;
    IF Info1    # NIL THEN g.CloseFont( Info1 )  END;
    IF Info2    # NIL THEN g.CloseFont( Info2 )  END;
    IF str = "" THEN HALT( 0 ) ELSE HALT( 20 ) END;

  END Terminate;

PROCEDURE BuildGUI;
  VAR
    vg               : b.Object;
    vg1, hg2         : b.Object;
    in1a, hs1b, in1c : b.Object;
  BEGIN

    in1a:= bm.InfoObject( b.infoTextFormat,   y.ADR( IText1 ),
                          b.infoHorizOffset,  0,
                          b.infoVertOffset,   0,
                          b.infoFixTextWidth, e.true,
                          b.infoMinLines,     1,
                          b.btTextAttr,       y.ADR( Info1Font ),
                          u.done );

    hs1b:= bm.HorizSeparator();

    in1c:= bm.InfoObject( b.infoTextFormat,   y.ADR( IText2 ),
                          b.infoHorizOffset,  0,
                          b.infoVertOffset,   0,
                          b.infoFixTextWidth, e.true,
                          b.infoMinLines,     3,
                          b.btTextAttr,       y.ADR( Info2Font ),
                          u.done );

    vg1:= bm.VGroupObject( b.groupHorizOffset, 4,  (* HOffset(4) *)
                           b.groupVertOffset,  4,  (* VOffset(4) *)
                           b.groupSpacing,     2,  (* Spacing(2) *)
                           b.frmType,          b.frTypeButton,
                           b.frmRecessed,      e.true,
                           b.groupMember, in1a, u.done, 0,
                           b.groupMember, hs1b,
                                          b.lgoFixMinHeight, e.true,
                                          u.done, 0,
                           b.groupMember, in1c, u.done, 0,
                           u.done );

    goQuit:= bm.ButtonObject( b.labLabel,      y.ADR( "_Quit" ),
                              b.labUnderscore, y.VAL( LONGINT, ORD('_')),
                              i.gaID,          idQuit,
                              b.btTextAttr,    y.ADR( ButtonFont ),
                              u.done );

    hg2:= bm.HGroupObject( b.groupSpaceObject, 50,             (* VarSpace(50) *)
                           b.groupMember, goQuit, u.done, 0,
                           b.groupSpaceObject, 50,             (* VarSpace(50) *)
                           u.done );

    vg:= bm.VGroupObject( b.groupHorizOffset, 4,            (* HOffset(4) *)
                          b.groupVertOffset,  4,            (* VOffset(4) *)
                          b.groupSpacing,     4,            (* Spacing(4) *)
                          b.groupBackfill, b.shineRaster,
                          b.groupMember,   vg1, u.done, 0,
                          b.groupMember,   hg2,
                                           b.lgoFixMinHeight, e.true,  (* FixMinHeight *)
                                           u.done, 0,
                          u.done );

    woWindow:= bm.WindowObject( b.windowTitle,       y.ADR("Multi-Font Demo"),
                                b.windowAutoAspect,  e.true,
                                b.windowLockHeight,  e.true,
                                b.windowRMBTrap,     e.true,
                                b.windowMasterGroup, vg,
                                u.done );


  END BuildGUI;

BEGIN
  running:= TRUE;

  (*
  ** Disfont library automatically opened in Oberon
  **
  ** We open the fonts ourselves since BGUI
  ** opens all fonts with OpenFont() which
  ** means that they have to be resident
  ** in memory.
  *)
  Button:= df.OpenDiskFont( ButtonFont );
  IF Button = NIL THEN Terminate( NIL, "Could not open Helvetica 13 font\n" ) END;

  Info1:= df.OpenDiskFont( Info1Font );
  IF Info1 = NIL THEN Terminate( NIL, "Could not open Helvetica 24 font\n" ) END;

  Info2:= df.OpenDiskFont( Info2Font );
  IF Info1 = NIL THEN Terminate( NIL, "Could not open Times 13 font\n" ) END;

  (* Create the window object. *)
  BuildGUI;

  (* Object created OK? *)
  IF woWindow = NIL THEN Terminate( NIL, "Could not create the window object\n" ) END;

  (* Assign the key to the button. *)
  IF bm.GadgetKeyA( woWindow, goQuit, y.ADR("q")) = 0 THEN
    Terminate( NIL, "Could not assign gadget keys\n" )
  END;

  (* try to open the window. *)
  window:= bm.WindowOpen( woWindow );
  IF window = NIL THEN Terminate( NIL, "Could not open the window\n" ) END;

  (* Obtain it's wait mask. *)
  rc:= i.GetAttr( b.windowSigMask, woWindow, signal );

  (* Event loop... *)
  WHILE running DO
    y.SETREG( 0, e.Wait( signal ));
    (* Handle events. *)
    LOOP
      (* Evaluate return code.*)
      CASE bm.HandleEvent( woWindow ) OF
        | b.wmhiNoMore       : EXIT;
        | b.wmhiCloseWindow,
          idQuit             : running:= FALSE;
      ELSE
      END;
    END;
  END;

  (* Normal Termination *)

  Terminate( window, "" );

END MultiFont.
