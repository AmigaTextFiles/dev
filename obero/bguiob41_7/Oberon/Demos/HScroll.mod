MODULE HScroll;

(*
**   Oberon Conversion - Larry Kuhns 12/01/96
*)

IMPORT
  b   := Bgui,
  bm  := BguiMacro,
  dc  := DemoCode,
  e   := Exec,
  g   := Graphics,
  i   := Intuition,
  st  := Strings,
  u   := Utility,
  y   := SYSTEM;

(*
**      Just some strings...
*)
TYPE
  str29 = ARRAY 29 OF e.STRPTR;

CONST
  Entries = str29 ( y.ADR(".backdrop                         18     ----rw-d 26-dec-94"),
                    y.ADR("classes.info                    1233     ----rw-d 30-sep-95"),
                    y.ADR("disk.info                       2128     ----rw-- 04-jan-95"),
                    y.ADR("T                                Dir     ----rwed 01-sep-94"),
                    y.ADR("Prefs                            Dir     ----rwed dinsdag  "),
                    y.ADR("Fonts                            Dir     ----rwed 22-oct-95"),
                    y.ADR("Expansion                        Dir     ----rwed 02-sep-92"),
                    y.ADR("WBStartup                        Dir     ----rwed 27-maa-95"),
                    y.ADR("Locale                           Dir     ----rwed 11-apr-95"),
                    y.ADR("Classes                          Dir     ----rwed 14-oct-95"),
                    y.ADR("Devs                             Dir     ----rwed dinsdag  "),
                    y.ADR("Storage                          Dir     ----rwed 02-sep-94"),
                    y.ADR("Storage.info                    1233     ----rw-d 02-sep-94"),
                    y.ADR("System                           Dir     ----rwed 01-sep-94"),
                    y.ADR("Rexxc                            Dir     ----rwed 02-sep-92"),
                    y.ADR("Utilities                        Dir     ----rwed Yesterday"),
                    y.ADR("L                                Dir     ----rwed maandag  "),
                    y.ADR("S                                Dir     ----rwed Yesterday"),
                    y.ADR("Devs.info                       1233     ----rw-d 01-sep-94"),
                    y.ADR("Expansion.info                  1233     ----rw-d 01-sep-94"),
                    y.ADR("Prefs.info                      1233     ----rw-d 25-jun-95"),
                    y.ADR("System.info                     1233     ----rw-d 01-sep-94"),
                    y.ADR("Utilities.info                  1233     ----rw-d 01-sep-94"),
                    y.ADR("WBStartup.info                  1233     ----rw-d 04-jan-95"),
                    y.ADR("C                                Dir     ----rwed 25-jun-95"),
                    y.ADR("Libs                             Dir     ----rwed 14-oct-95"),
                    y.ADR("Tools                            Dir     ----rwed 18-nov-94"),
                    y.ADR("Tools.info                      1233     ----rw-d 01-sep-94"),
                    NIL );

(*
**      We use the system fixed width font for this example because the
**      rendering hook _requires_ a fixed width font.
*)
TYPE
  str32 = ARRAY 32 OF CHAR;

VAR
  window : i.WindowPtr;
  woWindow : b.Object;
  list     : b.Object;
  prop     : b.Object;
  signal   : LONGSET;
  rc       : LONGINT;
  running  : BOOLEAN;
  FName    : str32;
  FFont    : g.TextAttr;
  HSRender : u.Hook;

(* Horizontal scroller position. *)

  HPos, OHPos : LONGINT;


TYPE
  msgs = ARRAY 4 OF e.STRPTR;
CONST
  error = msgs( y.ADR("I hope you liked it!!\n"),
                y.ADR("Error creating window object"),
                y.ADR("Error opening window"),
                NIL );

  PROCEDURE Min( n1, n2 : INTEGER ) : INTEGER;
    BEGIN
      IF n1 < n2 THEN RETURN n1 ELSE RETURN n2 END;
    END Min;


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


  (*
  **      This hook will scroll the entries and only
  **      re-render the part which is necessary.
  *)
  PROCEDURE DisplayHookFunc( hook : u.HookPtr; obj : b.Object; lvr : b.Args ) : LONGINT;
    VAR
      te           : g.Textextent;
      rp           : g.RastPortPtr;
      str          : e.LSTRPTR;
      numc         : INTEGER;
      pens         : i.DRIPenArrayPtr;
      elen         : INTEGER;
      l, t, r, x   : INTEGER;
      dip,max,
      numf, strpos : INTEGER;
      pen          : INTEGER;
      dif          : INTEGER;
    BEGIN
      rp  := lvr(b.Render).rPort;
      str := lvr(b.Render).entry;
      pens:= lvr(b.Render).drawInfo.pens;

      (*  Pick up the bounds. *)

      l:= lvr(b.Render).bounds.minX;
      t:= lvr(b.Render).bounds.minY;
      r:= lvr(b.Render).bounds.maxX;
      x:= lvr(b.Render).bounds.maxY;

      (*  The total length of the entry. *)

      elen:= SHORT( st.Length( str^ ));

      (*  Preset the drawmode. *)

      g.SetDrMd( rp, g.jam1 );

      (*
      **      Did the position of the horizontal scroller
      **      change from the previous position? If so we
      **      scroll the entry, otherwise we re-render it.
      *)

      IF OHPos # HPos THEN
        (*
        **      Yes. Figure out the difference of the old and new
        **      horizontal position in pixels.
        *)
        dip:= SHORT( HPos - OHPos ) * rp.txWidth;
        (*
        **      Here we compute the maximum number of
        **      characters we have in the view area,
        **      and the width in pixels.
        *)
        max:= r - l + 1;              (* View area width.         *)
        numf:= max  DIV rp.txWidth;      (* Number of characters.    *)
        (*
        **      When we have scrolled more than a view we
        **      simply re-render the whole entry.
        *)
        IF ABS(dip) <= max  THEN
          (*
          **      Scroll the entry left or right. When "dip"
          **      is positive (new position larger then the
          **      old) the entry is scrolled left, otherwise
          **      it is scrolled right.
          **
          **      We need to set the BPen because ScrollRaster
          **      uses it to fill the gap. This saves us from
          **      having to do a RectFill() ;)
          *)
          IF lvr(b.Render).state = b.lvrsSelected THEN pen:= i.fillPen ELSE pen:= i.backGroundPen END;
          g.SetBPen( rp, pens[ pen ] );
(*
          g.SetBPen( rp, lvr->lvr_State == lvrsSelected ? pens[ fillPen ] : pens[ backgroundPen ] );
*)
          g.ScrollRaster( rp, dip, 0, l, t, l + ( numf * rp.txWidth ) - 1, x );

          (*     Compute the maximum amount of characters to re-render. *)

          numc:= SHORT( ABS( HPos - OHPos ));

          (*     Did we scroll the entry to the left or to the right? *)
          IF dip > 0 THEN
            (*
            **      if "dip" is positive it means we have scrolled the
            **      entry "dip" pixels to the left leaving a gap at the
            **      right side of the view.
            **
            **      Compute the number of characters on the left side of
            **      the created gap.
            **
            **      This is the amount of characters that fit in the view
            **      minus the amount of characters scrolled away.
            *)
            strpos:= SHORT( HPos ) + ( numf - numc );
            (*
            **      Now check to see if there are any characters left
            **      at this position in the entry to print.
            **)
            IF elen > strpos THEN
              (*
              **     Yes. How many? This will never be
              **     more than the amount of characters
              **     we shifted or the amount of characters
              **     left in the entry. Whichever is smaller.
              *)
              numc:= Min( elen - strpos, numc );

              (* Move, set the pen and render. *)

              g.Move( rp, l + (( strpos - SHORT(HPos)) * rp.txWidth ), t + rp.txBaseline );
              IF lvr(b.Render).state = b.lvrsSelected THEN pen:= i.textPen ELSE pen:= i.fillTextPen END;
              g.SetAPen( rp, pens[ pen ] );
(*
              g.SetAPen( rp, lvr->lvrState == lvrsSelected ? pens[ textPen ] : pens[ fillTextPen ] );
*)
              g.Text( rp, y.VAL( e.LSTRPTR, y.ADR(str[ strpos ]))^, numc );
            END;  (* IF elen > strpos *)

          ELSE
            (*
            **     if "dip" is negative it means we have scrolled the
            **     entry "dip" pixels to the right leaving a gap at the
            **     left side of the view.
            **
            **     Are there characters left to print?
            *)
            IF elen > HPos THEN
              (*
              **     Yes. How many? This will never be
              **     more than the amount of characters
              **     we shifted or the amount of characters
              **     left in the entry. Whichever is smaller.
              *)
              numc:= Min( elen - SHORT(HPos), numc );

              (*     Move, set the pen and render. *)

              g.Move( rp, l, t + rp.txBaseline );

              IF lvr(b.Render).state = b.lvrsSelected THEN pen:= i.textPen ELSE pen:= i.fillTextPen END;
              g.SetAPen( rp, pens[ pen ] );
(*
              g.SetAPen( rp, lvr->lvrState == lvrsSelected ? pens[ textPen ] : pens[ fillTextPen ] );
*)
              g.Text( rp, y.VAL( e.LSTRPTR, y.ADR(str[ HPos ]))^, numc );
            END; (* IF elen > HPos *)
          END; (* IF dip > 0 *)

          (* Don't let the listview class render. *)

          RETURN NIL;

        END (* ABS(dip) <= max *)
      END; (* IF OHPos # HPos *)

      (*
      **      Entry point when we scrolled more
      **      than a view or the position of the
      **      scroller did not change.
      **
      **      Preset the pen/drawmode we use for
      **      backfilling the entry. We need to
      **      do backfilling here because we have
      **      not scrolled.
      *)

      IF lvr(b.Render).state = b.lvrsSelected THEN pen:= i.fillPen ELSE pen:= i.backGroundPen END;
      g.SetAPen( rp, pens[ pen ] );
(*
      g.SetAPen( rp, lvr(b.Render).state == lvrsSelected ? pens[ fillPen ] : pens[ backgroundPen ] );
*)
      (*  Backfill it. *)

      g.RectFill( rp, l, t, r, x );

      (* Any characters at this offset to print?  *)

      IF elen > HPos THEN

        (*  How many will fit? *)
        dif:= lvr(b.Render).bounds.maxX - lvr(b.Render).bounds.minX + 1;
        numc:= SHORT( g.TextFit( rp, y.VAL( e.LSTRPTR, y.ADR(str[ HPos ]))^, elen - HPos,
                                 y.ADR( te ), NIL, 0,
                                 dif, rp.txHeight ));
        IF numc # 0 THEN

          (* Move, set pen and render. *)

          g.Move( rp, l, t + rp.txBaseline );
          IF lvr(b.Render).state = b.lvrsSelected THEN pen:= i.textPen ELSE pen:= i.fillTextPen END;
          g.SetAPen( rp, pens[ pen ] );
(*
          SetAPen( rp, lvr->lvr_State == LVRS_SELECTED ? pens[ TEXTPEN ] : pens[ FILLTEXTPEN ] );
*)
          g.Text( rp, y.VAL( e.LSTRPTR, y.ADR( str[HPos] ))^, numc );
        END;
      END;

      (*  Don't let the listview class render. *)

      RETURN NIL;

    END DisplayHookFunc;


  PROCEDURE BuildGUI;
    VAR
      vg : b.Object;
    BEGIN
      woWindow:= NIL;

      list:= bm.ListviewObject( b.listvEntryArray,  y.ADR( Entries ),
                                b.listvDisplayHook, y.ADR( HSRender ),
                                b.listvListFont,    y.ADR( FFont ),
                                u.done );

      prop:= bm.HorizScroller( NIL, 0, 100, 5, 1 );

      vg:= bm.VGroupObject( b.groupHorizOffset, 4,   (* HOffset(4) *)
                            b.groupLeftOffset, 4,    (* VOffset(4) *)
                            b.groupMember, list, u.done, 0,
                            b.groupMember, prop,
                                           b.lgoFixMinHeight, e.true,   (* FixMinHeight *)
                                           u.done, 0,
                            u.done );

      woWindow:= bm.WindowObject( b.windowNoBufferRP,   e.true,
                                  b.windowSmartRefresh, e.true,
                                  b.windowCloseOnEsc,   e.true,
                                  b.windowScaleWidth,   20,
                                  b.windowScaleHeight,  20,
                                  b.windowMasterGroup,  vg,
                                  u.done );
    END BuildGUI;


BEGIN
  running:= TRUE;

  (*
   *      Steal the system default font. Please
   *      note that this is not a very elegant
   *      way to do this.
   *)

  COPY( g.base.defaultFont.message.node.name^, FName );
  FFont.name:= y.ADR(FName);
  FFont.ySize:= g.base.defaultFont.ySize;
  FFont.flags:= g.base.defaultFont.flags;
  FFont.style:= g.normal;

  b.MakeHook( HSRender, DisplayHookFunc );

  BuildGUI;

  IF woWindow = NIL THEN Terminate( NIL, 1 ) END;
  window:= bm.WindowOpen( woWindow );
  IF window = NIL THEN Terminate( NIL, 2 ) END;

  rc:= i.GetAttr( b.windowSigMask, woWindow, signal );
  WHILE running DO
    y.SETREG( 0, e.Wait( signal ));
    LOOP
      CASE bm.HandleEvent( woWindow ) OF
        | b.wmhiNoMore      : EXIT;
        | b.wmhiCloseWindow : running:= FALSE;

        | 1 :
          (*  Get scroller position. *)
          rc:= i.GetAttr( i.pgaTop, prop, HPos );

          (*  Did it change? *)
          IF HPos # OHPos THEN

            (* Show the change.*)
            rc:= b.DoGadgetMethod( list, window, NIL, b.lvmRedraw, NIL );

            (* Set old position to the  new position.  *)
            OHPos:= HPos;
          END;
      ELSE
      END; (* CASE *)
    END; (* LOOP *)
  END; (* While running *)

  Terminate( NIL, 0 );

END HScroll.
