MODULE Palette;

(*
** TESTPALETTE.C
**
** (C) Copyright 1995 Jaba Development.
** (C) Copyright 1995 Jan van den Baard.
**     All Rights Reserved.
**
**     Oberon Conversion - Larry Kuhns  12/01/96
*)

IMPORT
  b   := Bgui,
  bm  := BguiMacro,
  clf := Classface,
  dc  := DemoCode,
  e   := Exec,
  g   := Graphics,
  i   := Intuition,
  u   := Utility,
  y   := SYSTEM;


CONST
(*
** Object ID's.
*)
  idQuit *= 1;
  idFrame *= 2;
  idSFrame *= 3;
  idLabel *= 4;
  idSLabel *= 5;

(*
** Map-lists.
*)
TYPE
  long3 = ARRAY 3 OF LONGINT;
  int4  = ARRAY 4 OF INTEGER;
CONST
  p2f  = long3( b.paletteCurrentColor, b.frmBackPen,         u.done );
  p2fs = long3( b.paletteCurrentColor, b.frmSelectedBackPen, u.done );
  p2l  = long3( b.paletteCurrentColor, b.labPen,             u.done );
  p2ls = long3( b.paletteCurrentColor, b.labSelectedPen,     u.done );

  pens = int4( 0,3,1,1 );

(*
** Info gadget text.
*)
  InfoTxt = "\ecAs you can see the colors of the below button\nare normal but when you change the colors with\nthe palette objects the colors of the button change.\n\nYou can also pickup the color and drop it onto the\nbutton. \ebDragNDrop\en in action.";

TYPE
  msgs = ARRAY 5 OF e.LSTRPTR;
CONST
  error = msgs( y.ADR("Come back soon"),
                y.ADR("Error creating button class"),
                y.ADR("Error creating BGUI window Object"),
                y.ADR("Error opening Palette window"),
                NIL );


VAR
  window        : i.WindowPtr;
  woWindow      : b.Object;
  goQuit        : b.Object;
  goB           : b.Object;
  goPal         : ARRAY 4 OF b.Object;
  signal        : LONGSET;
  rc, tmp       : LONGINT;
  running       : BOOLEAN;
  myButtonClass : i.IClassPtr;


PROCEDURE Terminate( win : i.WindowPtr; msg : INTEGER );
  (* $CopyArrays- *)
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
    IF myButtonClass # NIL THEN ok:= i.FreeClass( myButtonClass ) END;
    IF msg = 0 THEN HALT( 0 ) ELSE HALT( 20 ) END;
  END Terminate;


(*
** The button we use is a very simple subclass from the
** BGUI buttonclass to accept only drops from the four
** paletteclass objects in this demo or from other palette
** class objects from another task or window when they have
** the same ID as we use here.
**
** SAS users remember! NOSTACKCHECK or __interrupt for class
** dispatchers, hook routines or anything else which may get
** called by a task other than your own.
*)

PROCEDURE myButtonDispatch( cl : i.IClassPtr; obj : b.Object; msg : i.MsgPtr ): LONGINT;
  VAR
    rc  : LONGINT;
    pen : LONGINT;
    tag : LONGINT;
  BEGIN
    CASE msg.methodID OF
      | b.baseDragQuery :
         (*
         ** We only accept drops from our paletteclass objects.
         ** The test here is a bit simple but this way it does
         ** allow for drops from another task. Just run this demo
         ** twice and DragNDrop from one window to another.
         *)
         IF (( y.VAL( i.GadgetPtr, msg(b.mDragPoint).source).gadgetID >= idFrame  )  AND
             ( y.VAL( i.GadgetPtr, msg(b.mDragPoint).source).gadgetID <= idSLabel )) THEN
           rc:= b.bqrAccept;
         ELSE
           rc:= b.bqrReject;
         END;

      | b.baseDropped   :
         (*
         ** Get the pen from the object.
         *)
         rc:= i.GetAttr( b.paletteCurrentColor,  msg(b.mDragMsg).source, pen );

         (*
         ** Let's see what has been dropped...
         *)
         CASE y.VAL( i.GadgetPtr, msg(b.mDragMsg).source).gadgetID OF
           | idFrame  : tag:= b.frmBackPen;
           | idSFrame : tag:= b.frmSelectedBackPen;
           | idLabel  : tag:= b.labPen;
           | idSLabel : tag:= b.labSelectedPen;
         ELSE
         END;
         (*
          * Set the pen. The superclass will force
          * a refresh on the object when the drop has
          * been made.
          *)
         rc:= i.SetAttrs( obj, tag, pen, u.done );
         rc:= 1;

      ELSE
         rc:= clf.DoSuperMethodA( cl, obj, msg^ );
      END; (* CASE msg.methodID OF *)

    RETURN rc;

  END myButtonDispatch;

  (*
  ** Setup our button class.
  *)
  PROCEDURE MakeMyButtonClass( ) : i.IClassPtr;
  VAR
    cl    : i.IClassPtr;
    super : i.IClassPtr;
  BEGIN
    cl:= NIL;

    (*
    ** Get a pointer to our superclass.
    *)
    super:= b.GetClassPtr( b.buttonGadget );
    IF super # NIL THEN
      (*
      ** Make our class.
      *)
      cl:= i.MakeClass( NIL, NIL, super, 0, LONGSET{} );
      IF cl # NIL THEN
        (*
        ** Setup our dispatcher.
        *)
        u.InitHook( cl, y.VAL( u.HookFunc, myButtonDispatch ));
      END;
    END;

    RETURN cl;

  END MakeMyButtonClass;


  PROCEDURE BuildGUI;
    VAR
      a       : LONGINT;
      defPens : int4;
      in1, hg2, hg3, hg4 : b.Object;
      vg3a, vg3b         : b.Object;
      vg                 : b.Object;
    BEGIN
      defPens:= pens;
      woWindow:= NIL;
      (*
       * I assume a depth of four
       * (16 colors) here for simplicity.
       *)
      FOR a:= 0 TO 3 DO
         goPal[a]:= bm.PaletteObject( b.frmType,             b.frTypeButton,
                                      b.frmRecessed,         e.true,
                                      b.paletteDepth,        4,
                                      b.paletteCurrentColor, defPens[a],
                                      i.gaID,                a + 2,
                                      b.btDragObject,        e.true,
                                      u.done );
      END;

      (*
      ** Create the window object.
      *)
      in1:= bm.InfoFixed( NIL, y.ADR(InfoTxt), NIL, 6);

      goB:= i.NewObject( myButtonClass,  NIL,
                         b.frmType,      b.frTypeButton,
                         b.labLabel,     y.ADR("Palette Demo"),
                         b.btDropObject,  e.true,
                         u.done );

      hg2:= bm.HGroupObject( b.groupHorizOffset, 4,              (* HOffset(4) *)
                             b.groupVertOffset,  4,              (* VOffset(4) *)
                             b.groupSpacing,     4,              (* Spacing(4) *)
                             b.frmType,          b.frTypeButton,
                             b.frmRecessed,      e.true,
                             b.groupMember, goB, u.done, 0,
                             u.done );

      vg3a:= bm.VGroupObject( b.groupSpacing, 4,                  (* Spacing(4) *)
                              b.labLabel,     y.ADR("Background:"),
                              b.labPlace,     b.placeAbove,
                              b.groupMember,  goPal[0], u.done, 0,
                              b.groupMember,  goPal[1], u.done, 0,
                              u.done );

      vg3b:= bm.VGroupObject( b.groupSpacing, 4,                 (* Spacing(4) *)
                              b.labLabel,     y.ADR("Label:"),
                              b.labPlace,     b.placeAbove,
                              b.groupMember,  goPal[2], u.done, 0,
                              b.groupMember,  goPal[3], u.done, 0,
                              u.done );

      hg3:= bm.HGroupObject( b.groupHorizOffset, 4,               (* HOffset(4) *)
                             b.groupVertOffset,  4,               (* VOffset(4) *)
                             b.groupSpacing,     4,               (* Spacing(4) *)
                             b.frmType,          b.frTypeButton,
                             b.frmRecessed,      e.true,
                             b.groupMember, vg3a, u.done, 0,
                             b.groupMember, vg3b, u.done, 0,
                             u.done );

      goQuit:= bm.KeyButton( y.ADR("_Quit"), idQuit );

      hg4:= bm.HGroupObject( b.groupSpaceObject, b.defaultWeight,  (* VarSpace(b.defaultWeight) *)
                             b.groupMember, goQuit, u.done, 0,
                             b.groupSpaceObject, b.defaultWeight,  (* VarSpace(b.defaultWeight) *)
                             u.done );

      vg:= bm.VGroupObject( b.groupHorizOffset, b.grSpaceNormal,   (* NormalOffset *)
                            b.groupVertOffset,  b.grSpaceNormal,
                            b.groupSpacing,     b.grSpaceNormal,   (* NormalSpacing *)
                            b.groupBackfill,    b.shineRaster,
                            b.groupMember, in1, u.done, 0,
                            b.groupMember, hg2,
                                           b.lgoFixMinHeight, e.true, (* FixMinHeight *)
                                           u.done, 0,
                            b.groupMember, hg3, u.done, 0,
                            b.groupMember, hg4,
                                           b.lgoFixMinHeight, e.true, (* FixMinHeight *)
                                           u.done, 0,
                            u.done );

      woWindow:=bm. WindowObject( b.windowTitle,        y.ADR("PaletteClass Demo"),
                                  b.windowAutoAspect,   e.true,
                                  b.windowSmartRefresh, e.true,
                                  b.windowRMBTrap,      e.true,
                                  b.windowIDCMP,        i.mouseMove,
                                  b.windowMasterGroup,  vg,
                                  u.done );

    END BuildGUI;

(*
** Here we go...
*)

BEGIN
  running:= TRUE;
  tmp:= 0;
  (*
  ** Initialize our drop-button class.
  *)
  myButtonClass:= MakeMyButtonClass();
  IF myButtonClass = NIL THEN Terminate( NIL, 1 ) END;

  BuildGUI;

  (*
  * Object created OK?
  *)
  IF woWindow = NIL THEN Terminate( NIL, 2 ) END;

  bm.GadgetKey( woWindow, goQuit, y.ADR('q'));
  bm.AddMap( goPal[0], goB, y.ADR( p2f  ));
  bm.AddMap( goPal[1], goB, y.ADR( p2fs ));
  bm.AddMap( goPal[2], goB, y.ADR( p2l  ));
  bm.AddMap( goPal[3], goB, y.ADR( p2ls ));

  window:= bm.WindowOpen( woWindow );
  IF window = NIL THEN Terminate( NIL, 3 ) END;

  rc:= i.GetAttr( b.windowSigMask, woWindow, signal );
  WHILE running DO
    y.SETREG( 0, e.Wait( signal ));
    LOOP
      CASE bm.HandleEvent( woWindow) OF
        | b.wmhiNoMore        : EXIT;
        | b.wmhiCloseWindow,
          idQuit              : running:= FALSE;
      ELSE
      END;
    END;
  END;

  Terminate( NIL, 0 );

END Palette.
