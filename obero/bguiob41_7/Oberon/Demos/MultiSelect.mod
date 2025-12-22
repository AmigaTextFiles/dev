MODULE MultiSelect;

(*
 *      MULTISELECT.C
 *
 *      (C) Copyright 1995 Jaba Development.
 *      (C) Copyright 1995 Jan van den Baard.
 *          All Rights Reserved.
 *
 *          Oberon Conversion - Larry Kuhns 12/01/96
 *)

(* #include "democode.h" *)
IMPORT
  b   := Bgui,
  bd  := DemoCode,
  bm  := BguiMacro,
  e   := Exec,
  i   := Intuition,
  u   := Utility,
  y   := SYSTEM;

(*
**      The entries shown in the list.
**)
TYPE
  array12 = ARRAY 12 OF e.LSTRPTR;
  aptrArray = UNTRACED POINTER TO ARRAY MAX(INTEGER) OF e.APTR;

CONST
  ListEntries = array12( y.ADR( "\ecThis listview object has multi-" ),
                         y.ADR( "\ecselection turned on. You can" ),
                         y.ADR( "\ecmulti-select the items by holding" ),
                         y.ADR( "\ecdown the SHIFT-key while clicking" ),
                         y.ADR( "\econ the different items or by clicking" ),
                         y.ADR( "\econ an entry and dragging the mouse" ),
                         y.ADR( "\ecup or down." ),
                         y.ADR( "" ),
                         y.ADR( "\ecIf you check the \"No SHIFT\" checbox" ),
                         y.ADR( "\ecyou can multi-select the items without" ),
                         y.ADR( "\ecusing the SHIFT key" ),
                         NIL );



(*
**      Map-list.
**)
TYPE
  intArray3 = ARRAY 3 OF LONGINT;

CONST
  CheckToList = intArray3( i.gaSelected, b.listvMultiSelectNoShift, u.end );

(*
**      Object ID's.
**)
CONST
  idShow   = 1;
  idQuit   = 2;
  idAll    = 3;
  idNone   = 4;

VAR
    window    : i.WindowPtr;
    woWindow,
    goQuit,
    goShow,
    goList,
    goShift,
    goAll,
    goNone    : b.Object;
    signal    : LONGSET;
    sigMask   : LONGINT;
    rc, tmp   : LONGINT;
    running   : BOOLEAN;
    str       : e.LSTRPTR;
    gad       : i.GadgetPtr;

PROCEDURE BuildGUI;
  VAR
    mg            : b.Object;
    vg1           : b.Object;
    hg1, hg2, hg3 : b.Object;
    sp1, sp2      : b.Object;
  BEGIN
    running:= TRUE;
    tmp:= 0;
    (*
     *      Create the window object.
     *)
    goList:= bm.ListviewObject( b.listvEntryArray,  y.ADR( ListEntries ),
                                b.listvMultiSelect, e.true,
                                u.done );

    goAll := bm.PrefButton( y.ADR("_All"),  idAll );
    goNone:= bm.PrefButton( y.ADR("N_one"), idNone );

    hg1:= bm.HGroupObject( b.groupMember, goAll,  u.done, 0,
                           b.groupMember, goNone, u.done, 0,
                           u.done );

    vg1:= bm.VGroupObject( b.groupHorizOffset, b.grSpaceNormal,    (* NormalOffset *)
                           b.groupVertOffset,  b.grSpaceNormal,
                           b.frmType,          b.frTypeButton,
                           b.frmRecessed,      e.true,
                           b.groupMember,      goList, u.done, 0,
                           b.groupMember,      hg1,    b.lgoFixMinHeight, e.true, u.done, 0,
                           u.done );

    goShift:= bm.PrefCheckBox( y.ADR("_No SHIFT:"), e.false, 0 );

    hg2:= bm.HGroupObject( b.groupHorizOffset, b.grSpaceNormal,    (* NormalOffset *)
                           b.groupVertOffset,  b.grSpaceNormal,
                           b.frmType,          b.frTypeButton,
                           b.frmRecessed,      e.true,
                           b.groupSpaceObject, b.defaultWeight,    (* VarSpace(defaultWeight) *)
                           b.groupMember     , goShift, b.lgoFixMinWidth,  e.true,
                                                        b.lgoFixMinHeight, e.true,
                                                        u.done, 0,
                           b.groupSpaceObject, b.defaultWeight,    (* VarSpace(defaultWeight) *)
                           u.done );

    goShow:= bm.PrefButton( y.ADR("_Show"), idShow );
    goQuit:= bm.PrefButton( y.ADR("_Quit"), idQuit );

    hg3:= bm.HGroupObject( b.groupSpacing,     b.grSpaceNormal, (* Normal Spacing *)
                           b.groupMember,      goShow, u.done, 0,
                           b.groupSpaceObject, b.defaultWeight, (* VarSpace(defaultWeight) *)
                           b.groupMember,      goQuit, u.done, 0,
                           u.done );

    mg:= bm.VGroupObject( b.groupHorizOffset, b.grSpaceNormal,   (* NormalOffset  *)
                          b.groupVertOffset,  b.grSpaceNormal,
                          b.groupSpacing,     b.grSpaceNormal,   (* NormalSpacing *)
                          b.groupBackfill,    b.shineRaster,
                          b.groupMember,      vg1, u.done, 0,
                          b.groupMember,      hg2, b.lgoFixMinHeight, e.true, u.done, 0,
                          b.groupMember,      hg3, b.lgoFixMinHeight, e.true, u.done, 0,
                          u.done );

    woWindow:= bm.WindowObject( b.windowTitle,           y.ADR( "Multi-Selection Demo" ),
                                b.windowAutoAspect,      e.true,
                                b.windowAutoKeyLabel,    e.true,
                                b.windowSmartRefresh,    e.true,
                                b.windowRMBTrap,         e.true,
                                b.windowScaleWidth,      30,
                                b.windowScaleHeight,     30,
                                b.windowMasterGroup,     mg,
                                u.done );
  END BuildGUI;

BEGIN

  BuildGUI;

  (*
  **      Object created OK?
  *)

  IF woWindow # NIL THEN

    (*  Add notification. **)
    IF bm.AddMapA( goShift, goList, y.ADR( CheckToList )) # NIL THEN

      (* try to open the window. **)
      window:= bm.WindowOpen( woWindow );
      IF window # NIL THEN

        (* Obtain it's wait mask. **)
        sigMask:= i.GetAttr( b.windowSigMask, woWindow, signal );

        (*  Event loop... *)
        WHILE running DO
          y.SETREG( 0, e.Wait( signal ));

          (*  Handle events. *)
          LOOP
            (* Evaluate return code. *)
            CASE bm.HandleEvent( woWindow ) OF
            | b.wmhiNoMore       : EXIT;

            | b.wmhiCloseWindow,
              idQuit             : running:= FALSE;

            | idAll              :
                gad:= y.VAL( i.GadgetPtr, goList );
                tmp:= i.SetGadgetAttrs( gad^, window, NIL, b.listvSelectMulti, b.listvSelectAll, u.end );

            | idNone             :
                gad:= y.VAL( i.GadgetPtr, goList );
                tmp:= i.SetGadgetAttrs( gad^, window, NIL, b.listvDeselect, -1, u.end );

            | idShow             :
                str:= bm.FirstSelected( goList );
                IF str # NIL THEN
                  LOOP
                    bd.Tell( window, str^ );
                    str:= bm.NextSelected( goList, y.VAL( e.APTR, str ));
                    IF str = NIL THEN EXIT END;
                  END;
                ELSE
                  (* Oops. There are no selected entries. **)
                  bd.Tell( window, "No selections made!\n" );
                END;
            ELSE
            END; (* CASE rc *)

          END; (* LOOP *)
        END; (* WHILE running *)

      ELSE
        bd.Tell( NIL, "Could not open the window" );
      END; (* IF window # NIL *)

    ELSE
      bd.Tell( NIL, "Unable to add notification" );
    END; (* IF AddMap *)

    (*
    **      Disposing of the window object will
    **      also close the window if it is
    **      already opened and it will dispose of
    **      all objects attached to it.
    **)

    i.DisposeObject( woWindow );

  ELSE
    bd.Tell( NIL, "Could not create the window object" );
  END; (* IF woWindow # NIL *)

END MultiSelect.
