MODULE AddButtons;

(*
**      ADDBUTTONS.C
**
**      (C) Copyright 1994 Paul Weterings.
**          All Rights Reserved.
**
**      Modified by Ian J. Einman, 4/26/96
**
**      Oberon Conversion by Larry Kuhns 12/01/96
*)

IMPORT
  b   := Bgui,
  bm  := BguiMacro,
  dc  := DemoCode,
  e   := Exec,
  g   := Graphics,
  gt  := GadTools,
  i   := Intuition,
  u   := Utility,
  y   := SYSTEM;

(*
**      Object ID's. Please note that the ID's are shared
**      between the menus and the gadget objects.
*)

CONST
  idAdd  = 21;
  idQuit = 22;
  idIns  = 23;
  idRem  = 24;

(*
**      Simple menu strip.
*)
TYPE
  menu7 = ARRAY 7 OF gt.NewMenu;
CONST
  SimpleMenu = menu7(
    gt.title, y.ADR("Project"),    NIL,        {}, LONGSET{}, 0,
    gt.item,  y.ADR("Add"),        y.ADR('A'), {}, LONGSET{}, idAdd,
    gt.item,  y.ADR("Insert"),     y.ADR('I'), {}, LONGSET{}, idIns,
    gt.item,  y.ADR("Remove all"), y.ADR('R'), {}, LONGSET{}, idRem,
    gt.item,  gt.barLabel,         NIL,        {}, LONGSET{}, NIL,
    gt.item,  y.ADR("Quit"),       y.ADR('Q'), {}, LONGSET{}, idQuit,
    0,        NIL,                 NIL,        {}, LONGSET{}, 0        );

(*
**      Simple button creation macros.
*)

PROCEDURE  AddButton() : b.Object;
  BEGIN
    RETURN bm.ButtonObject( b.labLabel, y.ADR( "Added" ),
                            b.labStyle, LONGSET{ g.bold },
                            u.done, 0 );
  END AddButton;

PROCEDURE  InsButton() : b.Object;
  BEGIN
    RETURN bm.ButtonObject( b.labLabel, y.ADR( "Inserted" ),
                            b.labStyle, LONGSET{ g.bold },
                            u.done, 0 );
  END InsButton;


PROCEDURE StartDemo;
  VAR
    window   : i.WindowPtr;
    woWindow : b.Object;
    goAdd    : b.Object;
    goQuit   : b.Object;
    goIns    : b.Object;
    goRem    : b.Object;
    addObj   : ARRAY 20 OF b.Object;
    base     : b.Object;
    signal   : LONGSET;
    sigMask  : LONGINT;
    rc, tmp  : LONGINT;
    running  : BOOLEAN;
    ok       : LONGINT;
    x, xx    : INTEGER;

  BEGIN

    signal:= LONGSET{};
    tmp:= 0;
    running:= TRUE;
    ok:= 0;
    x:= 0;

   (*
   **      Create window object.
   *)

   goAdd := bm.PrefButton( y.ADR("_Add"),        idAdd );
   goIns := bm.PrefButton( y.ADR("_Insert"),     idIns );
   goRem := bm.PrefButton( y.ADR("_Remove all"), idRem );
   goQuit:= bm.PrefButton( y.ADR("_Quit"),       idQuit );

   base:= bm.HGroupObject( b.groupMember, goAdd,  u.done, 0,
                           b.groupMember, goIns,  u.done, 0,
                           b.groupMember, goRem,  u.done, 0,
                           b.groupMember, goQuit, u.done, 0,
                           u.done, 0 );

   woWindow:= bm.WindowObject( b.windowTitle,        y.ADR( "Add/Insert Demo" ),
                               b.windowMenuStrip,    y.ADR( SimpleMenu ),
                               b.windowLockHeight,   e.true,
                               b.windowAutoAspect,   e.true,
                               b.windowAutoKeyLabel, e.true,
                               b.windowMasterGroup,  base,
                               u.done, 0 );

   (*
   **      OK?
   *)
   IF woWindow # NIL THEN
     (*
     **      Open window.
     *)
     window:= bm.WindowOpen( woWindow );
     IF window # NIL THEN
       (*
       **      Get signal mask.
       *)
       sigMask:= i.GetAttr( b.windowSigMask, woWindow, signal );
       WHILE running DO
         (*
         **      Poll messages.
         *)
         y.SETREG( 0, e.Wait( signal ));
         LOOP
           CASE bm.HandleEvent( woWindow ) OF
           | b.wmhiNoMore     : EXIT;

           | b.wmhiCloseWindow,    (* Bye now!!  *)
             idQuit           :
               running:= FALSE;

           | idAdd :
               IF x = 19  THEN
                 dc.Tell( window, "Max Nr. of gadgets\n" );
                 EXIT;
               END;
               INC( x );
               addObj[x]:= AddButton();
               ok:= b.DOMethod( base, b.grmAddMember, addObj[ x ],
                                b.lgoFixMinHeight,    e.false,
                                b.lgoWeight,          b.defaultWeight,
                                u.done );
               IF ok = NIL THEN
                  b.DoMethod( base, b.grmRemMember, addObj[ x ] );
                  DEC( x );
                  dc.Tell( window, "Last object did not fit!\n" );
               END
               (*
               ** No clue why this check is made !!
               ** if ( ! window )
               **    goto error;
               *)

           | idRem :
               IF x > 0 THEN
                 xx:= 1;
                 WHILE xx <= x DO
                   b.DoMethod( base, b.grmRemMember, addObj[ xx ] );
                   INC( xx );
                 END;
                 x:= 0;
               ELSE
                 dc.Tell( window, "We're out of gadgets!\n");
               END;

           | idIns :
               IF x = 19 THEN
                 dc.Tell( window, "Max Nr. of gadgets\n" );
               ELSE
                 INC( x );
                 addObj[ x ]:= InsButton();
                 ok:= b.DOMethod( base, b.grmInsertMember, addObj[ x ], goRem,
                                  b.lgoFixMinHeight,       e.false,
                                  b.lgoWeight,             b.defaultWeight,
                                  u.done );
                 IF ok = NIL THEN
                   b.DoMethod( base, b.grmRemMember, addObj[ x ] );
                   DEC( x );
                   dc.Tell( window, "Last object did not fit!\n" );
                 END;
               END;

               (* And again, see above !!!
               ** if ( ! window )
               **   goto error;
               *)
           ELSE
           END; (* CASE rc OF *)

         END; (* LOOP *)

       END; (* WHILE running *)

     ELSE
        dc.Tell( NIL, "Could not open the window\n" );
     END;  (* IF window # NIL *)

     i.DisposeObject( woWindow );

   ELSE
     dc.Tell( NIL, "Could not create the window object\n" );
   END; (* IF woObject # NIL *)

END StartDemo;

BEGIN
  StartDemo;
END AddButtons.
