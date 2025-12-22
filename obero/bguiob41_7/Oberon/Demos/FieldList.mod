MODULE FieldList;

(*
**  FIELDLIST.C
**
**  (C) Copyright 1995-1996 Jaba Development.
**  (C) Copyright 1995-1996 Jan van den Baard.
**      All Rights Reserved.
**
**      Oberon Conversion - Larry Kuhns  12/01/96
**
**  This example is a bit more complicated. It will
**  open a window with two listviews. The left-one
**  is a sortable listview which will automatically
**  sort the entries which are dropped on it.
**
**  The right listview allows you to position the
**  dropped entries.
**
**  This demonstration uses the listview subclass
**  as defined in the "fieldlist.h" file.
*)

IMPORT
  b   := Bgui,
  bm  := BguiMacro,
  dc  := DemoCode,
  e   := Exec,
  fl  := FieldListH,
  g   := Graphics,
  i   := Intuition,
  u   := Utility,
  y   := SYSTEM;


(*
**  Just a bunch of entries like the
**  ones found in the SnoopDos 3.0
**  Format Editor.
**
**  This does not have to be sorted since the
**  class will do this for us.
*)
TYPE
  fldArray = ARRAY 13 OF e.LSTRPTR;

CONST
  entries = fldArray(
  y.ADR("CallAddr\t%c"),
  y.ADR("Date\t%d"),
  y.ADR("Hunk:Offset\t%h"),
  y.ADR("Task ID\t%i"),
  y.ADR("Segment Name\t%s"),
  y.ADR("Time\t%t"),
  y.ADR("Count\t%u"),
  y.ADR("Process Name\t%p"),
  y.ADR("Action\t%a"),
  y.ADR("Target Name\t%n"),
  y.ADR("Options\t%o"),
  y.ADR("Res.\t%r"),
  NIL );

(* Object ID's *)

CONST
  idQuit *= 1;

VAR
  window       : i.WindowPtr;
  fixed        : g.TextAttr;
  fname        : ARRAY 32 OF CHAR;
  woWindow     : b.Object;
  goListSorted : b.Object;
  goListPlace  : b.Object;
  signal       : LONGSET;
  sigMask   : LONGINT;
  rc           : LONGINT;
  class        : i.IClassPtr;
  running      : BOOLEAN;
  weights      : ARRAY 2 OF LONGINT;

(* Here we go... *)


PROCEDURE BuildGUI;
  VAR
    mg       : b.Object;
    hg1, hg2 : b.Object;
    bt       : b.Object;
    in       : b.Object;
  BEGIN

    in:= bm.InfoFixed( NIL, y.ADR("\ecField selection using\nListview Drag-n-Drop."), NIL, 2 );

    goListSorted:= i.NewObject( class, NIL,
                                b.labLabel,            y.ADR("Available Fields"),
                                b.labPlace,            b.placeAbove,
                                b.listvShowDropSpot,   e.true,
                                b.listvEntryArray,     y.ADR(entries),
                                b.listvSortEntryArray, e.true,
                                b.listvColumns,        2,
                                b.listvColumnWeights,  y.ADR(weights),
                                (*
                                ** b.listvListFont,      y.ADR(fixed),
                                *)
                                fl.flSortDrops,        e.true,
                                b.btDragObject,        e.true,
                                b.btDropObject,        e.true,
                                u.done );

    goListPlace:= i.NewObject( class, NIL,
                               b.labLabel,            y.ADR("Current Format"),
                               b.labPlace,            b.placeAbove,
                               b.listvShowDropSpot,   e.true,
                               b.listvColumns,        2,
                               b.listvColumnWeights,  y.ADR(weights),
                               (*
                               ** listvListFont,      y.ADR(fixed),
                               *)
                               b.btDragObject,        e.true,
                               b.btDropObject,        e.true,
                               u.done );

    hg1:= bm.HGroupObject( b.groupSpacing, 6,        (* Spacing(6) *)
                           b.groupMember,  goListSorted, u.done, 0,
                           b.groupMember,  goListPlace, u.done, 0,
                           u.done );

    bt:= bm.FuzzButton( y.ADR("_Quit"), idQuit );

    hg2:= bm.HGroupObject( b.groupSpaceObject, b.defaultWeight, (* VarSpace(defaultWeight) *)
                           b.groupMember,      bt, u.done, 0,
                           b.groupSpaceObject, b.defaultWeight, (* VarSpace(defaultWeight) *)
                           u.done );

    mg:= bm.VGroupObject( b.groupHorizOffset, 6,   (* HOffset(6) *)
                          b.groupVertOffset,  6,   (* VOffset(6) *)
                          b.groupSpacing,     6,   (* Spacing(6) *)
                          b.groupMember,      in, b.lgoFixMinHeight, e.true, u.done, 0,
                          b.groupMember,      hg1, u.done, 0,
                          b.groupMember,      hg2, b.lgoFixMinHeight, e.true, u.done, 0,
                          u.done );

    woWindow:= bm.WindowObject( b.windowTitle,        y.ADR("Listview Drag-n-Drop"),
                                b.windowScaleWidth,   25,
                                b.windowScaleHeight,  15,
                                b.windowRMBTrap,      e.true,
                                b.windowAutoAspect,   e.true,
                                b.windowAutoKeyLabel, e.true,
                                b.windowMasterGroup,  mg,
                                u.done );
  END BuildGUI;


BEGIN
  running:= TRUE;
  weights[0]:= 50; weights[1]:= 5;

  (*
  **  Close your eyes! This is very ugly code and should
  **  not be regarded as good programming practice!
  **
  **  Do not use this kind of code in serious programs. I
  **  just did this to keep it simple.
  **

  Forbid();
  strcpy( fname, GfxBase->DefaultFont->tfMessage.mnNode.lnName );
  fixed.ta_Name = fname;
  fixed.taYsize  = GfxBase->DefaultFont->tfYsize;
  fixed.taStyle  = GfxBase->DefaultFont->tfStyle;
  fixed.taFlags  = GfxBase->DefaultFont->tfFlags;
  Permit();

  *)

  (* Initialize the class. *)

  class:= fl.InitClass();
  IF class # NIL THEN
    (* Build the window object tree. *)

    BuildGUI;

    (* Window object tree OK? *)

    IF woWindow # NIL THEN
      (* Tell the FL class objects to accept drops from eachother. *)

      rc:= i.SetAttrs( goListSorted, fl.flAcceptDrop, goListPlace,  u.done );
      rc:= i.SetAttrs( goListPlace,  fl.flAcceptDrop, goListSorted, u.done );

      (* Open the window. *)

      window:= bm.WindowOpen( woWindow );
      IF window # NIL THEN
        (* Get signal wait mask. *)

        sigMask:= i.GetAttr( b.windowSigMask, woWindow, signal );

        WHILE running DO
          y.SETREG( 0, e.Wait( signal ));
          (* Handle messages. *)
          LOOP
            CASE bm.HandleEvent( woWindow ) OF
              | b.wmhiNoMore       : EXIT;

              | b.wmhiCloseWindow,
                idQuit             : running:= FALSE;
            ELSE
            END;
          END;
        END;
      ELSE
        dc.Tell( NIL, "Unable to open the window.\n" );
      END; (* IF window # NIL *)

      i.DisposeObject( woWindow );

    ELSE
      dc.Tell( NIL, "Unable to create the window object.\n" );
    END; (* IF woWindow # NIL *)

    IF i.FreeClass( class ) THEN END;

  ELSE
    dc.Tell( NIL, "Unable to initialize the FieldList class.\n" );
  END; (* IF class # NIL *)

END FieldList.
