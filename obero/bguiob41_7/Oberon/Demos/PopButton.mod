MODULE PopButton;

(*
** POPBUTTON.C
**
** (C) Copyright 1995 Jaba Development.
** (C) Copyright 1995 Jan van den Baard.
**     All Rights Reserved.
**
** NMC (12.12.95): Added another menu to demonstrate enabling
**       and disabling.
**
**     Oberon Conversion - Larry Kuhns  12/01/96
*)

IMPORT
  b   := Bgui,
  bm  := BguiMacro,
  dc  := DemoCode,
  e   := Exec,
  i   := Intuition,
  u   := Utility,
  y   := SYSTEM;


CONST
(*
** Object ID.
*)
  idQuit     *= 1;
  idPopMenu1 *= 2;
  idPopMenu2 *= 3;
  idPopMenu3 *= 4;
  idPopMenu4 *= 5; (* NMC *)

(*
** Menu entries.
*)
TYPE
  menu13 = ARRAY 13 OF b.PopMenu;
  menu6  = ARRAY 6  OF b.PopMenu;
  menu7  = ARRAY 7  OF b.PopMenu;
  menu3  = ARRAY 3  OF b.PopMenu;

CONST
  Project = menu13( y.ADR("New"),         SET{}, LONGSET{},
                    y.ADR("Open..."),     SET{}, LONGSET{},
                    b.pmbBarLabel,        SET{}, LONGSET{},
                    y.ADR("Save"),        SET{}, LONGSET{},
                    y.ADR("Save As..."),  SET{}, LONGSET{},
                    b.pmbBarLabel,        SET{}, LONGSET{},
                    y.ADR("Print"),       SET{}, LONGSET{},
                    y.ADR("Print As..."), SET{}, LONGSET{},
                    b.pmbBarLabel,        SET{}, LONGSET{},
                    y.ADR("About..."),    SET{}, LONGSET{},
                    b.pmbBarLabel,        SET{}, LONGSET{},
                    y.ADR("Quit"),        SET{}, LONGSET{},
                    NIL,                  SET{}, LONGSET{} );

  Edit    = menu6( y.ADR("Cut"),   SET{}, LONGSET{},
                   y.ADR("Copy"),  SET{}, LONGSET{},
                   y.ADR("Paste"), SET{}, LONGSET{},
                   b.pmbBarLabel,  SET{}, LONGSET{},
                   y.ADR("Erase"), SET{}, LONGSET{},
                   NIL,            SET{}, LONGSET{} );

(*
** This menu has checkable items and mutual exclusion.
**
** The first item will mutually-exclude the last
** four items and any of the last four items will
** mutually-exclude the first item.
*)
  Exclude = menu7( y.ADR("Uncheck below"), SET{b.pmfCheckIt},              LONGSET{2,3,4,5},
                   b.pmbBarLabel,          SET{},                          LONGSET{},
                   y.ADR("Item 1"),        SET{b.pmfCheckIt,b.pmfChecked}, LONGSET{0},
                   y.ADR("Item 2"),        SET{b.pmfCheckIt,b.pmfChecked}, LONGSET{0},
                   y.ADR("Item 3"),        SET{b.pmfCheckIt,b.pmfChecked}, LONGSET{0},
                   y.ADR("Item 4"),        SET{b.pmfCheckIt,b.pmfChecked}, LONGSET{0},
                   NIL,                    SET{},                          LONGSET{}   );

(*
** This menu has two items that enable the other
** when selected. (NMC)
*)
  Able = menu3( y.ADR("Enable below"), SET{},             LONGSET{},
                y.ADR("Enable above"), SET{b.pmfDisabled}, LONGSET{},
                NIL,                   SET{},             LONGSET{} );


VAR
  window    : i.WindowPtr;
  woWindow,
  goQuit,
  goPmb,
  goPmb1,
  goPmb2,
  goPmb3    : b.Object; (* NMC *)
  signal    : LONGSET;
  rc, tmp   : LONGINT;
  txt       : e.STRPTR;
  running   : BOOLEAN;


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
      IF str = "" THEN HALT( 0 ) ELSE HALT( 20 ) END;

    END Terminate;


  PROCEDURE BuildGUI;
    VAR
      vg, hg1, in2, hg3  : b.Object;
      vs1, vs2, vs3, vs4 : b.Object;
    BEGIN
      woWindow:= NIL;
        (*
        ** Create the popmenu buttons.
        *)

      goPmb:= bm.PopButtonObject( b.pmbMenuEntries, y.ADR( Project ),
                                  (*
                                  **         Let this one activate
                                  **         the About item.
                                  *)
                                  b.pmbPopPosition, 9,
                                  b.labLabel,       y.ADR("_Project"),
                                  b.labUnderscore,  y.VAL( LONGINT, ORD('_')),
                                  i.gaID,           idPopMenu1,
                                  u.done );

      goPmb1:= bm.PopButtonObject( b.pmbMenuEntries, y.ADR( Edit ),
                                   b.labLabel,       y.ADR("_Edit"),
                                   b.labUnderscore,  y.VAL( LONGINT, ORD('_')),
                                   i.gaID,           idPopMenu2,
                                   u.done );

      goPmb2:= bm.PopButtonObject( b.pmbMenuEntries, y.ADR( Exclude ),
                                   b.labLabel,       y.ADR("E_xclude"),
                                   b.labUnderscore,  y.VAL( LONGINT, ORD('_')),
                                   i.gaID,           idPopMenu3,
                                   u.done );


      goPmb3:= bm.PopButtonObject( b.pmbMenuEntries, y.ADR( Able ),   (* NMC *)
                                   (*
                                   **         Make this menu always
                                   **         appear below the label
                                   *)
                                   b.pmbPopPosition, -1,
                                   b.labLabel,       y.ADR("E_nable"),
                                   b.labUnderscore,  y.VAL( LONGINT, ORD('_')),
                                   i.gaID,           idPopMenu4,
                                   u.done );

        (*
        ** Create the window object.
        *)

      vs1:= bm.VertSeparator();
      vs2:= bm.VertSeparator();
      vs3:= bm.VertSeparator();
      vs4:= bm.VertSeparator();

      hg1:= bm.HGroupObject( b.groupSpacing,     4,             (* Spacing(4) *)
                             b.groupHorizOffset, 6,             (* HOffset(6) *)
                             b.groupVertOffset,  4,             (* VOffset(4) *)
                             b.frmType,          b.frTypeNext,  (* NeXTFrame *)
                             b.frmBackDriPen,    i.fillPen,
                             b.groupMember, goPmb,
                                            b.lgoFixMinWidth, e.true,
                                            u.done, 0,
                             b.groupMember, vs1,
                                            b.lgoFixMinWidth, e.true,
                                            u.done, 0,
                             b.groupMember, goPmb1,
                                            b.lgoFixMinWidth, e.true,
                                            u.done, 0,
                             b.groupMember, vs2,
                                            b.lgoFixMinWidth, e.true,
                                            u.done, 0,
                             b.groupMember, goPmb2,
                                            b.lgoFixMinWidth, e.true,
                                            u.done, 0,
                             b.groupMember, vs3,
                                            b.lgoFixMinWidth, e.true,
                                            u.done, 0,
                             b.groupMember, goPmb3,
                                            b.lgoFixMinWidth, e.true,
                                            u.done, 0,                 (* NMC *)
                             b.groupMember, vs4,
                                            b.lgoFixMinWidth, e.true,
                                            u.done, 0,                 (* NMC *)
                             u.done );

      in2:= bm.InfoFixed( NIL,
                          y.ADR("\ecThis demonstrates the usage of the \ebPopButtonClass.\en\nWhen you click inside the above popmenu buttons a small\npopup-menu will appear which you can choose from.\n\nYou can also key-activate the menus and browse though the\nitems using the cursor up and down keys. Return or Enter\nacknowledges the selection and escape cancels it."),
                          NIL, 7 );

      goQuit:= bm.PrefButton( y.ADR("_Quit"), idQuit );

      hg3:= bm.HGroupObject( b.groupSpaceObject, b.defaultWeight,    (* VarSpace(defaultWeight) *)
                             b.groupMember, goQuit, u.done, 0,
                             b.groupSpaceObject, b.defaultWeight,    (* VarSpace(defaultWeight) *)
                             u.done );

      vg:= bm.VGroupObject( b.groupVertOffset, 4,                   (* HOffset(4) *)
                            b.groupVertOffset, 4,                   (* VOffset(4) *)
                            b.groupSpacing,    4,                   (* Spacing(4) *)
                            b.groupBackfill,   b.shineRaster,
                            b.groupMember, hg1,
                                           b.lgoFixMinHeight, e.true,  (* FixMinHeight *)
                                           u.done, 0,
                            b.groupMember, in2, u.done, 0,
                            b.groupMember, hg3,
                                           b.lgoFixMinHeight, e.true,  (* FixMinHeight *)
                                           u.done, 0,
                            u.done );

      woWindow:= bm.WindowObject( b.windowTitle,        y.ADR("PopButtonClass Demo"),
                                  b.windowAutoAspect,   e.true,
                                  b.windowSmartRefresh, e.true,
                                  b.windowRMBTrap,      e.true,
                                  b.windowMasterGroup,  vg,
                                  u.done );

    END BuildGUI;


  PROCEDURE DoRequest( num : LONGINT; txt : e.STRPTR );
    VAR
      req : b.request;
      rc  : LONGINT;
    BEGIN
      req:= dc.defaultReq;
      req.textFormat:= y.ADR("\ecSelected Item %ld <\eb%s\en>");
      rc:= b.Request( window, y.ADR( req ), tmp, txt );
      (*
      Req( window, "*OK", "\ecSelected Item %ld <\eb%s\en>", tmp, txt );
      *)
    END DoRequest;


BEGIN

  tmp:= 0;
  running:= TRUE;

  BuildGUI;

  (*
  ** Object created OK?
  *)
  IF woWindow = NIL THEN Terminate( NIL, "Could not create the window object\n" ) END;
  (*
  ** NMC: Amended to not rely on return from
  ** GadgetKey == 1 exactly. Yes, Jan, I know
  ** you know it will be 1 - you wrote it! :-)
  **)
  IF ( bm.GadgetKeyA( woWindow, goQuit,  y.ADR('q')) = 0 ) OR
     ( bm.GadgetKeyA( woWindow, goPmb,   y.ADR('p')) = 0 ) OR
     ( bm.GadgetKeyA( woWindow, goPmb1,  y.ADR('e')) = 0 ) OR
     ( bm.GadgetKeyA( woWindow, goPmb2,  y.ADR('x')) = 0 ) OR
     ( bm.GadgetKeyA( woWindow, goPmb3,  y.ADR('n')) = 0 ) THEN
    Terminate( NIL, "Could not assign menu keys\n" )
  END;

  window:= bm.WindowOpen( woWindow );
  IF window = NIL THEN Terminate( NIL, "Could not open window\n" ) END;

  rc:= i.GetAttr( b.windowSigMask, woWindow, signal );
  WHILE running DO
    y.SETREG( 0,  e.Wait( signal ));
    LOOP
      CASE bm.HandleEvent( woWindow ) OF
        | b.wmhiNoMore : EXIT;

        | b.wmhiCloseWindow,
          idQuit :
            running:= FALSE;

        | idPopMenu4:
            rc:= i.GetAttr( b.pmbMenuNumber, goPmb3, tmp );
            rc:= tmp;
            IF rc = 0 THEN rc:= 1 ELSE rc:= 0 END;
            b.DoMethod( goPmb3, b.pmbmDisableItem, tmp );
            b.DoMethod( goPmb3, b.pmbmEnableItem,  rc );
            txt:= Able[tmp].label;
            DoRequest( tmp, txt );

        | idPopMenu3:
            rc:= i.GetAttr( b.pmbMenuNumber, goPmb2, tmp );
            txt:= Exclude[tmp].label;
            DoRequest( tmp, txt );

        | idPopMenu2:
            rc:= i.GetAttr( b.pmbMenuNumber, goPmb1, tmp );
            txt:= Edit[tmp].label;
            DoRequest( tmp, txt );

        | idPopMenu1:
            rc:= i.GetAttr( b.pmbMenuNumber, goPmb, tmp );
            CASE tmp OF
              | 9  :
                  dc.Tell( window,
                           "\ec\ebPopButtonClass DEMO\n\en(C) Copyright 1995 Jaba Development." );

              | 11 :
                running:= FALSE;

            ELSE
              txt:= Project[tmp].label;
              DoRequest( tmp, txt );
            END; (* END CASE 2 *)

      ELSE
      END; (* CASE 1 *)
    END; (* LOOP *)
  END; (* WHILE *)

  Terminate( window, "" );

END PopButton.
