MODULE BGUIScrollWindow;

(*
****************************************************************************
**
**  $VER: BGUIScrollWin.c 0.6 (01.02.96)
**
**  Example code which shows how to correctly create a screen resolution
**  sensitive window with scrollbars and arrows.
**
**  Write *ADPAPTIVE* software!  Get *RID* of hard coded values!
**
****************************************************************************
**
**  Original ScrollerWindow.c (nearly completely rewritten), V0.3 had:
**
**  Copyright © 1994 Christoph Feck, TowerSystems.  You may use methods
**  and code provided in this example in executables for Commodore-Amiga
**  computers.  All other rights reserved.
**
**  The rewritten Version is (C) 1996 Reinhard Katzmann. It is Freeware
**  and is provided in the same manner as above. It may _not_ be used
**  for the research, development, testing or production of weapons or
**  other military applications. Else it may be used in any Software be
**  they Commercial, Shareware, Freeware or Public Domain.
**
**  NOTE:  This file is provided "AS-IS" and subject to change without
**  prior notice; no warranties are made.  All use is at your own risk.
**  No liability or responsibility is assumed.
**
****************************************************************************
**
**  Compilation notes:
**
**  - Needs V39 or newer includes and amiga.lib (Fred Fish CD or CATS NDK).
**  - Needs at least V40.5 of BGUI library and corresponding header files.
**  - This has to be compiled with stack checking off (NOSTACKCHECK for SAS/C)!
**  - You need to compile it with a automatic BGUI library open/close init or
**    else you need to open the Library by your own! (SAS/C: lib=lib:bgui.lib)
**
**  I compiled it like this:
**  sc link BGUIScrollWind.c nostackcheck ign=88 lib lib:bgui.lib
**
*****************************************************************************
**
**   Oberon Conversion - Larry Kuhns  12/01/96
**
**   Bugs: Bitmap does not redisplay on resizing. Next action
**         ( horiz scroll, vert scroll, etc. ) redisplays screen
**         correctly.  The "C" demo does the same thing.
**
*)

IMPORT
  b   := Bgui,
  bm  := BguiMacro,
  dc  := DemoCode,
  e   := Exec,
  g   := Graphics,
  i   := Intuition,
  ie  := InputEvent,
  u   := Utility,
  y   := SYSTEM;


CONST
  idQuit =  7;

(***************************************************************************
**
**  Pepo's peculiarities.
**
****************************************************************************)

  PROCEDURE NEW( VAR type : e.APTR; size : LONGINT );
    BEGIN
      type:= e.AllocMem( size, LONGSET{ e.memClear, e.public });
    END NEW;

  PROCEDURE DISPOSE( VAR stuff : e.APTR; size : LONGINT );
    BEGIN
      e.FreeMem( stuff, size)   (* By original Author, very bad code in my opinion *)
    END DISPOSE;

  PROCEDURE MAX( x, y : LONGINT ) : LONGINT;
    BEGIN
      IF x > y THEN RETURN x ELSE RETURN y END;
    END MAX;

  PROCEDURE MIN( x, y : LONGINT ) : LONGINT;
    BEGIN
      IF  x < y THEN RETURN x ELSE RETURN y END;
    END MIN;


(***************************************************************************
**
**  Global variables.
**
****************************************************************************)
VAR
  screen : i.ScreenPtr;
  dri    : i.DrawInfoPtr;
  v39    : BOOLEAN;

  (* The bitmap we want to display *)
  bitmap : g.BitMapPtr;

  (* If TRUE, we can't draw into the window
  ** (size verification).
  *)
  frozen : BOOLEAN;

  (* All gadgets for scroller window and their IDs.
  ** Note that we assume they get initialized to NULL.
  *)
  horizgadget, vertgadget : b.Object;   (* Scroller have Slider + arrow buttons *)
  woWindow, goQuit        : b.Object;
  idcmpHook               : u.Hook;

CONST
  horizGID  = 1;
  vertGID   = 2;

VAR
  window : i.WindowPtr;

  (* Cached model info *)
  htotal   : LONGINT;
  vtotal   : LONGINT;
  hvisible : LONGINT;
  vvisible : LONGINT;
  rc       : LONGINT;

(***************************************************************************
 *
 *  V37 compatible BitMap functions.
 *
 ***************************************************************************
 *)

  PROCEDURE CreateBitMap( width, height, depth : LONGINT; flags : LONGSET; friend : g.BitMapPtr ): g.BitMapPtr;
    VAR
      bm       : g.BitMapPtr;
      memflags : LONGSET;
      i        : LONGINT;
      tmp      : LONGINT;
    BEGIN

      IF v39 THEN
        bm:= g.AllocBitMap( width, height, depth, flags, friend );
      ELSE
        memflags:= LONGSET{ e.chip };
        NEW( bm, SIZE( bm^ ));
        IF bm # NIL THEN
          g.InitBitMap( bm^, SHORT(depth), SHORT(width), SHORT(height) );

          IF ( flags * LONGSET{ g.bmbClear } # LONGSET{} ) THEN
             memflags:= memflags + LONGSET{ e.memClear };
          END;

          (* For simplicity, we allocate all planes in one big chunk *)
          bm.planes[0]:= e.AllocVec( depth * g.RASSIZE( SHORT(width), SHORT(height)), memflags);
          IF bm.planes[0] # NIL THEN
            i:= 1;
            WHILE i < depth DO
              tmp:= y.VAL( LONGINT, bm.planes[i-1] ) + g.RASSIZE(SHORT(width), SHORT(height));
              bm.planes[i]:= y.VAL( g.PLANEPTR , tmp );
              INC( i );
            END;
          ELSE
            DISPOSE( bm, SIZE(bm^));
            bm:= NIL;
          END;
        END;
      END;
      RETURN bm;
    END CreateBitMap;


  PROCEDURE DeleteBitMap( bm : g.BitMapPtr );
    BEGIN
      IF bm # NIL THEN
        IF v39 THEN
          g.FreeBitMap( bm );
        ELSE
          e.FreeVec( bm.planes[0] );
          DISPOSE( bm, SIZE( bm^ ));
        END;
      END;
    END DeleteBitMap;


  PROCEDURE BitMapDepth( bm : g.BitMapPtr ): LONGINT;
    BEGIN
      IF v39 THEN
        RETURN g.GetBitMapAttr( bm, g.bmaDepth );
      ELSE
        RETURN bm.depth;
      END;
    END BitMapDepth;


TYPE
  msgs = ARRAY 7 OF e.STRPTR;
CONST
  error = msgs( y.ADR("\ec\ebBGUIScrollWindow\en demo ended Successfully\nCome back soon!!\n"),
                y.ADR("\ecCould not lock public screen\n"),
                y.ADR("\ecCould not allocate memory to capture\nan image of the public screen\n"),
                y.ADR("\ecCould not open window for \ebBGUIScroolWindow\en Demo\n"),
                y.ADR("\ecError creating \ebBGUI\en window object\n"),
                y.ADR("\ecError assigning gadget keys\n"),
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
      IF woWindow # NIL THEN i.DisposeObject( woWindow ) END;
      IF bitmap   # NIL THEN
         g.WaitBlit();
         DeleteBitMap( bitmap );
      END;

      IF msg = 0 THEN HALT( 0 ) ELSE HALT( 20 ) END;
    END Terminate;


(***************************************************************************
 *
 *  Our scroller window.
 *
 ***************************************************************************)

  (* Copy our BitMap into the window *)
  PROCEDURE CopyBitMap;
    VAR
      srcx : LONGINT;
      srcy : LONGINT;
      addy : LONGINT;
      rc   : LONGINT;
      h, v : INTEGER;
    BEGIN
      addy:= screen.font.ySize + 16;  (* + VOffset+Spacing :-) *)

      (* Do not render while in size verification *)
      IF ~frozen THEN
        (* Get right place *)
        rc:= i.GetAttr( i.pgaTop, horizgadget, srcx );
        rc:= i.GetAttr( i.pgaTop, vertgadget,  srcy );
        IF htotal < hvisible THEN h:= SHORT(htotal) ELSE h:= SHORT(hvisible) END;
        IF vtotal < vvisible THEN v:= SHORT(vtotal) ELSE v:= SHORT(vvisible) END;
        g.BltBitMapRastPort( bitmap, SHORT(srcx), SHORT(srcy), window.rPort, window.borderLeft + 1,
                             SHORT( window.borderTop + addy + 1 ),
                             h - 2, v - 2, y.VAL( e.BYTE, 0C0H ));
      END;
    END CopyBitMap;


  (* Calculate visible region based on window size.
   *
   * Can't use global 'window' variable, because our layout
   * method calls this before OpenWindow() returns.
   *
   * GZZWidth/GZZHeight are the inner dimensions even for non GZZ windows.
   *)

  PROCEDURE UpdateScrollerWindow;
    (* Major rewrite: Thus we no longer use an own Boopsi Gadget, we must always *)
    (* Recalc The visible part of the Bitmap in the window in this function *)
    VAR
      tmp : i.GadgetPtr;
      rc  : LONGINT;
    BEGIN
      hvisible:= window.gzzWidth;
      tmp:= y.VAL( i.GadgetPtr, horizgadget );
      rc:= i.SetGadgetAttrs( tmp^, window, NIL, i.pgaVisible, hvisible );
      vvisible:= window.gzzHeight - ( screen.font.ySize + 16 );
      tmp:= y.VAL( i.GadgetPtr, vertgadget );
      rc:= i.SetGadgetAttrs( tmp^, window, NIL, i.pgaVisible, vvisible );
      CopyBitMap();
    END UpdateScrollerWindow;


  PROCEDURE ScrollerLeft( amount : LONGINT );
    VAR
      oldtop : LONGINT;
      rc     : LONGINT;
      tmp    : i.GadgetPtr;
    BEGIN
      rc:= i.GetAttr( i.pgaTop, horizgadget, oldtop );
      IF oldtop > 0 THEN
        tmp:= y.VAL( i.GadgetPtr, horizgadget );
        rc:= i.SetGadgetAttrs( tmp^, window, NIL, i.pgaTop, MAX( 0, oldtop - amount ));
        CopyBitMap;
      END;
    END ScrollerLeft;


  PROCEDURE ScrollerRight( amount : LONGINT );
    VAR
      oldtop : LONGINT;
      rc     : LONGINT;
      tmp    : i.GadgetPtr;
    BEGIN
      rc:= i.GetAttr( i.pgaTop, horizgadget, oldtop );
      IF oldtop < ( htotal - hvisible) THEN
        tmp:= y.VAL( i.GadgetPtr, horizgadget );
        rc:= i.SetGadgetAttrs( tmp^, window, NIL, i.pgaTop,
                               MIN( htotal - hvisible, oldtop + amount ));
        CopyBitMap;
      END;
    END ScrollerRight;


  PROCEDURE ScrollerUp( amount : LONGINT );
    VAR
      oldtop : LONGINT;
      rc     : LONGINT;
      tmp    : i.GadgetPtr;
    BEGIN
      rc:=i.GetAttr( i.pgaTop, vertgadget, oldtop );
      IF oldtop > 0 THEN
        tmp:= y.VAL( i.GadgetPtr, vertgadget );
        rc:= i.SetGadgetAttrs( tmp^, window, NIL, i.pgaTop, MAX( 0, oldtop - amount ));
        CopyBitMap();
      END;
    END ScrollerUp;


  PROCEDURE ScrollerDown( amount : LONGINT );
    VAR
      oldtop : LONGINT;
      rc     : LONGINT;
      tmp    : i.GadgetPtr;
    BEGIN
      rc:= i.GetAttr( i.pgaTop, vertgadget, oldtop );
      IF oldtop < ( vtotal - vvisible ) THEN
        tmp:= y.VAL( i.GadgetPtr, vertgadget );
        rc:= i.SetGadgetAttrs( tmp^, window, NIL, i.pgaTop,
                               MIN( vtotal - vvisible, oldtop + amount ));
        CopyBitMap();
      END;
    END ScrollerDown;


  PROCEDURE HandleIDCMPUpdate( attrs : u.TagListPtr );
    BEGIN
      (* We are only interested in the ID of the involved gadget. *)
      CASE u.GetTagData( i.gaID, 0, attrs ) OF
      | horizGID,
        vertGID  : CopyBitMap();
      ELSE
      END;
    END HandleIDCMPUpdate;


CONST
  qualShift  =  SET{ ie.lShift, ie.rShift };
  qualAlt    =  SET{ ie.lAlt, ie.rAlt };
  qualCtrl   =  SET{ ie.control };


  PROCEDURE HandleRawKey( msg : i.IntuiMessagePtr );
    BEGIN
          CASE msg.code OF

          | i.cursorLeft:
              IF ( msg.qualifier * qualCtrl ) # SET{} THEN
                (* total *)
                ScrollerLeft( htotal );
              ELSIF ( msg.qualifier * qualShift ) # SET{} THEN
                (* visible (minus 1 for 'overlap' to match propgclass) *)
                ScrollerLeft( hvisible - 1 );
              ELSIF ( msg.qualifier * qualAlt ) # SET{} THEN
                (* big step *)
                ScrollerLeft( 16 );
              ELSE
                (* small step *)
                ScrollerLeft( 1 );
              END;

          | i.cursorRight:
              IF    (msg.qualifier * qualCtrl)  # SET{} THEN ScrollerRight( htotal );
              ELSIF (msg.qualifier * qualShift) # SET{} THEN ScrollerRight( hvisible - 1 );
              ELSIF (msg.qualifier * qualAlt)   # SET{} THEN ScrollerRight( 16 );
              ELSE                                           ScrollerRight( 1 ) END;

          | i.cursorUp:
              IF    (msg.qualifier * qualCtrl)  # SET{} THEN ScrollerUp( vtotal );
              ELSIF (msg.qualifier * qualShift) # SET{} THEN ScrollerUp( vvisible - 1 );
              ELSIF (msg.qualifier * qualAlt)   # SET{} THEN ScrollerUp( 16 );
              ELSE                                           ScrollerUp( 1 ) END;

          | i.cursorDown:
              IF    (msg.qualifier * qualCtrl)  # SET{} THEN ScrollerDown( vtotal );
              ELSIF (msg.qualifier * qualShift) # SET{} THEN ScrollerDown( vvisible - 1 );
              ELSIF (msg.qualifier * qualAlt)   # SET{} THEN ScrollerDown( 16 );
              ELSE                                           ScrollerDown( 1 ) END;

          ELSE
          END; (* CASE msg.code *)
    END HandleRawKey;


  (*
  ** This Hook function is the replacement for the OLD HandleScrollerWindow()
  ** The new one only reacts on BGUI Gadgets & CloseWindow
  *)
  PROCEDURE HookFunc( hook : u.HookPtr; obj : b.Object; imsg : i.IntuiMessagePtr ): LONGINT;
    BEGIN
      IF imsg.class = LONGSET{ i.sizeVerify } THEN
        (* Do not draw until window has been resized. *)
        frozen:= TRUE;
      ELSIF imsg.class = LONGSET{ i.newSize } THEN
        frozen:= FALSE;
        UpdateScrollerWindow;
      ELSIF imsg.class = LONGSET{ i.refreshWindow } THEN
        i.BeginRefresh( window );
        CopyBitMap;
        i.EndRefresh( window, e.true );
      ELSIF imsg.class = LONGSET{ i.rawKey } THEN
        HandleRawKey( imsg );
      ELSIF imsg.class = LONGSET{ i.idcmpUpdate } THEN
        (* IAddress is a pointer to a taglist with new attributes. *)
        HandleIDCMPUpdate( y.VAL( u.TagListPtr, imsg.iAddress ));
      END;
    END HookFunc;


  PROCEDURE OpenScrollerWindow;
    VAR
      tmp : LONGINT;
      vg1, vg2, vg3 : b.Object;
      hg1a          : b.Object;
    BEGIN

      horizgadget:= bm.PropObject(
         i.pgaTop,        0,
         i.pgaTotal,      htotal,
         i.pgaVisible,    hvisible,
         i.gaRightBorder, e.true,
         i.gaID,          vertGID,
         (* PGA_Borderless, FALSE, *)
         i.pgaFreedom,    LONGSET{i.freeHoriz},
         b.pgaArrows,     e.true,
         i.pgaNewLook,    e.true,
         u.done );

      vertgadget:= bm.PropObject(
         i.pgaTop,         0,
         i.pgaTotal,       vtotal,
         i.pgaVisible,     vvisible,
         i.gaBottomBorder, e.true,
         i.gaID,           horizGID,
         (* PGA_Borderless, FALSE, *)
         b.pgaArrows,      e.true,
         i.pgaNewLook,     e.true,
         u.done );

      (* There is a demo "Quit" Gadget added and the BitMap functions are recalculated corresponding *)

      goQuit:= bm.ButtonObject(
         b.labLabel,      y.ADR("_Quit"),
         b.labUnderscore, y.VAL( LONGINT, ORD('_')),
         i.gaID,          idQuit,
         b.frmType,       b.frTypeButton,            (* ButtonFrame *)
         b.frmFlags,      LONGSET{b.frfEdgesOnly},
         u.done );

      hg1a:= bm.HGroupObject(
         b.groupMember, goQuit,
                        b.lgoFixMinWidth,  e.true,     (* FixMinWidth  *)
                        b.lgoFixMinHeight, e.true,     (* FixMinHeight *)
                        u.done, 0,
         u.done );

      vg1:= bm.VGroupObject(
         b.groupHorizOffset, 4,        (* HOffset(4) *)
         b.groupVertOffset,  4,        (* VOffset(4) *)
         b.groupSpacing,     4,        (* Spacing(4) *)
         b.groupMember, hg1a, u.done, 0,
         u.done );

      vg2:= bm.VGroupObject(
         i.gaRightBorder, e.true,
         b.groupMember, vertgadget,
                        b.lgoFixMinWidth,  e.true,     (* FixMinWidth  *)
                        u.done, 0,
         u.done );

      vg3:= bm.VGroupObject(
         i.gaBottomBorder, e.true,
         b.groupMember, horizgadget,
                        b.lgoFixMinHeight, e.true,     (* FixMinHeight *)
                        u.done, 0,
         u.done );

      woWindow:= bm.WindowObject(
         b.windowTitle,         y.ADR("BGUI Scroller Window V0.6 (02.01.96)"),
         b.windowScaleWidth,    100,
         b.windowScaleHeight,   95,
         b.windowSizeRight,     e.true,
         b.windowScreenTitle,   y.ADR("BGUI Scroller Window Demonstration V0.6"),
         b.windowIDCMP,         LONGSET{ i.newSize,   i.sizeVerify,   i.refreshWindow,
                                         i.mouseMove, i.mouseButtons, i.intuiTicks },
         b.windowIDCMPHookBits, LONGSET{ i.newSize,   i.sizeVerify,   i.refreshWindow,
                                         i.mouseMove, i.mouseButtons, i.intuiTicks,
                                         i.rawKey,    i.idcmpUpdate },
         b.windowIDCMPHook,     y.ADR( idcmpHook ),
         b.windowAutoAspect,    e.true,
         b.windowMasterGroup,   vg1,
         b.windowRBorderGroup,  vg2,
         b.windowBBorderGroup,  vg3,
         u.done );

      IF woWindow = NIL THEN
        Terminate( NIL, 4 );
        RETURN;
      END;

      tmp:= bm.GadgetKeyA( woWindow, goQuit, y.ADR("q"));
      IF tmp = NIL THEN
        Terminate( NIL, 5 );
        RETURN;
      END;

      tmp:= i.SetAttrs( goQuit, b.btNoRecessed, e.true, u.done );
      window:= bm.WindowOpen( woWindow );

    END OpenScrollerWindow;


(***************************************************************************
 *
 *  Main program and IDCMP handling.
 *
 ***************************************************************************)

  PROCEDURE HandleScrollerWindow;
    VAR
      signal  : LONGSET;
      running : BOOLEAN;
      rc      : LONGINT;
    BEGIN
      signal:= LONGSET{};
      running:= TRUE;

      rc:= i.GetAttr( b.windowSigMask, woWindow, signal);
      WHILE running DO
        y.SETREG( 0, e.Wait( signal ));
        LOOP
          CASE bm.HandleEvent( woWindow ) OF
          | b.wmhiNoMore      : EXIT;
          | idQuit,
            b.wmhiCloseWindow : running:= FALSE;
          ELSE
          END;
        END;
      END;
    END HandleScrollerWindow;


(***************************************************************************
 *
 *  Startup.
 *
 ***************************************************************************)

BEGIN
  frozen  := FALSE;
  woWindow:= NIL;

  u.InitHook( y.ADR( idcmpHook ), y.VAL( u.HookFunc, HookFunc ));

  (* Do we run V39? *)
  v39:= y.VAL( e.LibraryPtr, i.base).version >= 39;

  screen:= i.LockPubScreen( NIL );
  IF screen = NIL THEN Terminate( NIL, 1 ) END;

  (* We clone the screen bitmap *)
  hvisible:= screen.width;  htotal:= screen.width;
  vvisible:= screen.height; vtotal:= screen.height;
  bitmap:= CreateBitMap( htotal, vtotal,
                         BitMapDepth( screen.rastPort.bitMap ),
                         LONGSET{}, screen.rastPort.bitMap );
  IF bitmap = NIL THEN Terminate( NIL, 2 ) END;

  (* Copy it over *)
  rc:= g.BltBitMap( screen.rastPort.bitMap, 0, 0,
                    bitmap, 0, 0, SHORT(htotal), SHORT(vtotal),
                    y.VAL( e.BYTE, 0C0H ), y.VAL( SHORTSET, -1 ), NIL);

  OpenScrollerWindow;

  IF window = NIL THEN Terminate( NIL, 3 ) END;

  UpdateScrollerWindow;
  HandleScrollerWindow;

  (* release lock on public scrreen *)
  i.UnlockPubScreen( NIL, screen );

  Terminate( NIL, 0 );

END BGUIScrollWindow.
