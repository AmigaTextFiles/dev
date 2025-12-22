MODULE FrameLessInfo;

(*
**  Oberon Conversion - Larry Kuhns 12/01/96
*)

IMPORT
  b   := Bgui,
  bm  := BguiMacro,
  dc  := DemoCode,
  e   := Exec,
  i   := Intuition,
  u   := Utility,
  y   := SYSTEM;

VAR
  win     : b.Object;
  run     : BOOLEAN;
  sig     : LONGSET;
  rc      : LONGINT;

TYPE
  msgs = ARRAY 4 OF e.STRPTR;
CONST
  error = msgs( y.ADR("FrameLessInfo demo ending\n"),
                y.ADR("Error creating window object\n"),
                y.ADR("Could not open the window\n"),
                NIL );


  PROCEDURE Terminate( w : i.WindowPtr; msg : INTEGER );
    VAR
      ok : BOOLEAN;
    BEGIN
      dc.Tell( w, error[msg]^ );
      (*
      **  Disposing of the window object will
      **  also close the window if it is
      **  already opened and it will dispose of
      **  all objects attached to it.
      *)
      IF win # NIL THEN i.DisposeObject( win ) END;
      IF msg = 0 THEN HALT( 0 ) ELSE HALT( 20 ) END;
    END Terminate;


  PROCEDURE BuildGUI;
    VAR
      in, hg : b.Object;
    BEGIN
      in:= bm.InfoObject(
         b.infoTextFormat,   y.ADR("\ecThis text appears without\nany frame around it"),
         b.infoMinLines,     2,
         b.infoHorizOffset,  0,
         b.infoVertOffset,   0,
         b.infoFixTextWidth, e.true,
         b.frmType         , b.frTypeNone,     (* Added for V40+ tomake frameless *)
         u.done );

      hg:= bm.HGroupObject(
         b.groupHorizOffset, 4,         (* HOffset(4) *)
         b.groupVertOffset,  4,         (* VOffset(4) *)
         b.groupMember, in, u.done, 0,
         u.done );

      win:= bm.WindowObject(
         b.windowMasterGroup, hg,
         u.done );

    END BuildGUI;

BEGIN
  win:= NIL;
  run:= TRUE;

  BuildGUI;
  IF win = NIL THEN Terminate( NIL, 1) END;
  IF bm.WindowOpen( win ) = NIL THEN Terminate( NIL, 2 ) END;
  rc:= i.GetAttr( b.windowSigMask, win, sig );
  WHILE run DO
    y.SETREG( 0, e.Wait( sig ));
    LOOP
      CASE bm.HandleEvent( win ) OF
      | b.wmhiNoMore      : EXIT;
      | b.wmhiCloseWindow : run:= FALSE;
      END;
    END;
  END;

  Terminate( NIL, 0 );

END FrameLessInfo.
