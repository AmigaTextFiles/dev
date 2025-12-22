(* Converted from example in 3.1 native developers update *)
MODULE DoubleBuffer ;

IMPORT
      S := SYSTEM,
      D := Dos{37},
   SLib := StdLib,
      E := Exec,
      U := Utility,
     GT := GadTools{39},
    MID := ModeKeys,
      G := Graphics{39},
      I := Intuition{39} ;

(*----------------------------------------------------------------------------*)

(* Some constants to handle the rendering of the animated face *)
CONST
  BM_WIDTH	= 120 ;
  BM_HEIGHT	=  60 ;
  BM_DEPTH	=   2 ;

(* Odd numbers to give a non-repeating bounce *)
  CONTROLSC_TOP	 = 191 ;
  SC_ID		 = MID.HIRES_KEY ;

(* User interface constants and variables *)

  GAD_HORIZ	= 1 ;
  GAD_VERT	= 2 ;

  MENU_RUN	= 1 ;
  MENU_STEP	= 2 ;
  MENU_QUIT	= 3 ;
  MENU_HSLOW	= 4 ;
  MENU_HFAST	= 5 ;
  MENU_VSLOW	= 6 ;
  MENU_VFAST	= 7 ;

  OK_REDRAW = 1	; (* Buffer fully detached, ready for redraw *)
  OK_SWAPIN = 2 ; (* Buffer redrawn, ready for swap-in	     *)

(*----------------------------------------------------------------------------*)

VAR
  Topaz80	: G.TextAttr ;
  vctags	: ARRAY [0..1] OF U.TagItem ;
  pens		: ARRAY [0..12] OF CARDINAL ;
  demomenu	: ARRAY [0..11] OF GT.NewMenu ;

  canvassc	: I.ScreenPtr ;
  controlsc	: I.ScreenPtr ;
  controlwin	: I.WindowPtr ;
  canvaswin	: I.WindowPtr ;
  glist		: I.GadgetPtr ;
  horizgad	: I.GadgetPtr ;
  vertgad	: I.GadgetPtr ;
  menu		: I.MenuPtr   ;
  canvasvi	: S.ADDRESS   ;
  controlvi	: S.ADDRESS   ;

  dbufport	: E.MsgPortPtr ;
  userport	: E.MsgPortPtr ;

  status	: ARRAY [ 0..1 ] OF LONGINT ;
  rport		: ARRAY [ 0..1 ] OF G.RastPort ;
  count		: LONGINT ;
  face		: G.BitMapPtr ;

  scbuf		: ARRAY [0..1] OF I.ScreenBufferPtr ;
  prevx		: ARRAY [0..1] OF LONGINT ;
  prevy		: ARRAY [0..1] OF LONGINT ;

  buf_current, buf_nextdraw, buf_nextswap : LONGINT ;
  x, y, xstep, xdir, ystep, ydir : LONGINT ;

(*----------------------------------------------------------------------------*)

PROCEDURE init_all( ) : S.STRING ; FORWARD ;
PROCEDURE error_exit( errorstring : S.STRING ) ; FORWARD ;
PROCEDURE createAllGadgets( VAR glistptr : I.GadgetPtr ;
				      vi : S.ADDRESS ) : I.GadgetPtr ; FORWARD ;
PROCEDURE handleIntuiMessage( imsg : I.IntuiMessagePtr ) : BOOLEAN ; FORWARD ;
PROCEDURE handleDBufMessage( dbmsg : E.MessagePtr ) ; FORWARD ;
PROCEDURE handleBufferSwap( ) : LONGINT ; FORWARD ;
PROCEDURE makeImageBM( ) : G.BitMapPtr ; FORWARD ;
PROCEDURE CloseWindowSafely( win : I.WindowPtr ) ; FORWARD ;
PROCEDURE StripIntuiMessages( mp : E.MsgPortPtr ; win : I.WindowPtr ); FORWARD ;

(*----------------------------------------------------------------------------*)

PROCEDURE main( ) ;
  VAR
    errorstring : S.STRING ;
    sigs	: LONGSET ;
    terminated	: BOOLEAN ;
    imsg	: I.IntuiMessagePtr ;
    dbmsg	: E.MessagePtr ;
    held_off	: LONGINT ;
BEGIN
  terminated := FALSE ;
  (* Let's get everything initialized *)
  errorstring := init_all( ) ;
  IF errorstring # NIL THEN error_exit( errorstring ) END ;

  count		:=  0  ;
  buf_current	:=  0  ;
  buf_nextdraw	:=  1  ;
  buf_nextswap	:=  1  ;
  sigs		:= { } ;

  WHILE ~terminated DO
    (* Check for and handle any IntuiMessages *)
    IF userport^.mp_SigBit IN sigs THEN
      LOOP
	imsg := GT.GT_GetIMsg( userport ) ;
	IF imsg = NIL THEN EXIT END ;
	terminated := terminated OR handleIntuiMessage( imsg ) ;
	GT.GT_ReplyIMsg( imsg ) ;
      END ;
    END ;

    (* Check for and handle any double-buffering messages.  *)
    (* Note that double-buffering messages are "replied" to *)
    (* us, so we don't want to reply them to anyone.	    *)

    IF dbufport^.mp_SigBit IN sigs THEN
      LOOP
	dbmsg := E.GetMsg( dbufport ) ;
	IF dbmsg = NIL THEN EXIT END ;
	handleDBufMessage( dbmsg );
      END ;
    END ;

    IF ~terminated THEN
      held_off := 0;
      (* Only handle swapping buffers if count is non-zero *)
      IF count # 0 THEN held_off := handleBufferSwap( ) END ;
	IF held_off # 0 THEN
	  (* If were held-off at ChangeScreenBuffer() time, then we	*)
	  (* need to try ChangeScreenBuffer() again, without awaiting	*)
	  (* a signal.  We WaitTOF() to avoid busy-looping.		*)
	  G.WaitTOF( ) ;
	ELSE
	  (* If we were not held-off, then we're all done		*)
	  (* with what we have to do.  We'll have no work to do		*)
	  (* until some kind of signal arrives.  This will normally	*)
	  (* be the arrival of the dbi_SafeMessage from the ROM		*)
	  (* double-buffering routines, but it might also be an		*)
	  (* IntuiMessage.						*)
	  sigs := E.Wait( {dbufport^.mp_SigBit,userport^.mp_SigBit} );
	END ;
      END ;
    END ;

    error_exit( NIL ) ;
END main ;

(*----------------------------------------------------------------------------*)

(* Handle the rendering and swapping of the buffers *)

PROCEDURE handleBufferSwap( ) : LONGINT ;
  VAR held_off : LONGINT ;
BEGIN

  held_off := 0 ;

  (* 'buf_nextdraw' is the next buffer to draw into.			*)
  (* The buffer is ready for drawing when we've received the		*)
  (* dbi_SafeMessage for that buffer.  Our routine to handle		*)
  (* messaging from the double-buffering functions sets the		*)
  (* OK_REDRAW flag when this message has appeared.			*)
  (*									*)
  (* Here, we set the OK_SWAPIN flag after we've redrawn		*)
  (* the imagery, since the buffer is ready to be swapped in.		*)
  (* We clear the OK_REDRAW flag, since we're done with redrawing	*)

  IF status[ buf_nextdraw ] = OK_REDRAW THEN
    INC( x , xstep*xdir ) ;
    IF x < 0 THEN x := 0 ; xdir := 1;
    ELSIF x > canvassc^.Width - BM_WIDTH THEN
      x := canvassc^.Width - BM_WIDTH - 1 ; xdir := -1
    END ;
    INC( y , ystep*ydir ) ;
    IF y < canvassc^.BarLayer^.Height THEN
      y := canvassc^.BarLayer^.Height ; ydir := 1
    ELSIF y >= CONTROLSC_TOP - BM_HEIGHT THEN
      y := CONTROLSC_TOP - BM_HEIGHT - 1 ; ydir := -1
    END ;

    G.SetAPen( S.ADR( rport[ buf_nextdraw ] ) , 0 );
    G.RectFill( S.ADR( rport[ buf_nextdraw ] ) ,
	    prevx[ buf_nextdraw ], prevy[ buf_nextdraw ],
	    prevx[ buf_nextdraw ] + BM_WIDTH - 1, prevy[ buf_nextdraw ]
	    + BM_HEIGHT - 1 ) ;
    prevx[buf_nextdraw] := x ;
    prevy[buf_nextdraw] := y ;

    G.BltBitMapRastPort( face, 0, 0, S.ADR( rport[ buf_nextdraw ] ), x, y,
	    BM_WIDTH, BM_HEIGHT, 0C0H );

    G.WaitBlit( ) ; (* Gots to let the BBMRP finish *)

    status[ buf_nextdraw ] := OK_SWAPIN;

    (* Toggle which the next buffer to draw is.		  *)
    (* If you're using multiple ( >2 ) buffering, you	  *)
    (* would use					  *)
    (*							  *)
    (*   buf_nextdraw = ( buf_nextdraw+1 ) % NUMBUFFERS ; *)

    buf_nextdraw := ORD( ~VAL(BOOLEAN,buf_nextdraw) ) ;
  END ;

  (* Let's make sure that the next frame is rendered before we swap... *)

  IF status[buf_nextswap] = OK_SWAPIN THEN

    scbuf[buf_nextswap]^.sb_DBufInfo^.dbi_SafeMessage.mn_ReplyPort:= dbufport;

    IF I.ChangeScreenBuffer( canvassc, scbuf[ buf_nextswap ] ) # 0 THEN
      status[buf_nextswap] := 0 ;
      buf_current := buf_nextswap ;

      (* Toggle which the next buffer to swap in is.		*)
      (* If you're using multiple ( >2 ) buffering, you		*)
      (* would use						*)
      (*							*)
      (* buf_nextswap = ( buf_nextswap+1 ) % NUMBUFFERS;	*)

      buf_nextswap := ORD( ~VAL(BOOLEAN,buf_nextswap) ) ;
      DEC( count ) ;
    ELSE held_off := 1 ;
    END ;
  END ;
  RETURN( held_off )
END handleBufferSwap ;

(*----------------------------------------------------------------------------*)

(* Handle Intuition messages *)

PROCEDURE handleIntuiMessage( imsg : I.IntuiMessagePtr ) : BOOLEAN ;
  VAR
    code	: CARDINAL      ;
    terminated	: BOOLEAN       ;
    item	: I.MenuItemPtr ;
BEGIN
  terminated := FALSE ;
  code := imsg^.Code ;
  IF    imsg^.Class = I.IDCMP_GADGETDOWN THEN
  ELSIF imsg^.Class = I.IDCMP_GADGETUP   THEN
  ELSIF imsg^.Class = I.IDCMP_MOUSEMOVE  THEN
    CASE imsg^.IAddress(I.GadgetPtr)^.GadgetID OF
    | GAD_HORIZ: xstep := code ;
    | GAD_VERT : ystep := code ;
    END ;

  ELSIF imsg^.Class = I.IDCMP_VANILLAKEY THEN
    CASE CHR( code ) OF
    | 'S' , 's': count :=  1 ;
    | 'R' , 'r': count := -1 ;
    | 'Q' , 'q': count :=  0 ; terminated := TRUE ;
    ELSE
    END ;

  ELSIF imsg^.Class = I.IDCMP_MENUPICK THEN
    WHILE code # I.MENUNULL DO
      item := I.ItemAddress( menu , code ) ;
      CASE GT.GTMENUITEM_USERDATA( item ) OF
      | MENU_RUN  : count := -1 ;
      | MENU_STEP : count :=  1 ;
      | MENU_QUIT : count :=  0 ; terminated := TRUE ;

      | MENU_HSLOW: IF xstep > 0  THEN DEC( xstep ) END ;
        GT.GT_SetGadgetAttrs( horizgad, controlwin, NIL, GT.GTSL_Level, xstep,
        		      U.TAG_DONE )

      | MENU_HFAST: IF xstep < 9 THEN INC( xstep ) END ;
	GT.GT_SetGadgetAttrs( horizgad, controlwin, NIL, GT.GTSL_Level, xstep,
			      U.TAG_DONE )

      | MENU_VSLOW: IF ystep > 0 THEN DEC( ystep ) END ;
        GT.GT_SetGadgetAttrs( vertgad, controlwin, NIL, GT.GTSL_Level, ystep,
        		      U.TAG_DONE )

      | MENU_VFAST: IF ystep < 9 THEN INC( ystep ) END ;
	GT.GT_SetGadgetAttrs( vertgad, controlwin, NIL, GT.GTSL_Level, ystep,
			      U.TAG_DONE )
      END ;
      code := item^.NextSelect
    END
  END ;
  RETURN terminated ;
END handleIntuiMessage ;

(*----------------------------------------------------------------------------*)

PROCEDURE handleDBufMessage( dbmsg : E.MessagePtr ) ;
  TYPE
    AdrPtrPtr = POINTER TO POINTER TO S.ADDRESS ;

  VAR
    buffer : LONGINT ;
    adr	   : S.ADDRESS ;
BEGIN
  (* dbi_SafeMessage is followed by an APTR dbi_UserData1, which  *)
  (* contains the buffer number.  This is an easy way to extract  *)
  (* it.							  *)
  (* The dbi_SafeMessage tells us that it's OK to redraw the	  *)
  (* in the previous buffer.					  *)

  adr    := SIZE( E.Message ) + S.ADDRESS( dbmsg ) ;
  buffer := LONGINT( adr( AdrPtrPtr)^ ) ;

  (* Mark the previous buffer as OK to redraw into.	*)
  (* If you're using multiple ( >2 ) buffering, you	*)
  (* would use						*)
  (*							*)
  (*    ( buffer + NUMBUFFERS - 1 ) % NUMBUFFERS	*)

  status[ORD(~VAL(BOOLEAN,buffer))] := OK_REDRAW
END handleDBufMessage ;

(*----------------------------------------------------------------------------*)

(* Get the resources and objects we need *)

PROCEDURE init_all( ) : S.STRING ;
BEGIN

  dbufport := E.CreateMsgPort( ) ;
  IF dbufport = NIL THEN RETURN "Failed to create port\n" END ;

  userport := E.CreateMsgPort( ) ;
  IF userport = NIL THEN RETURN "Failed to create port\n" END ;

  canvassc := I.OpenScreenTags( NIL,
	I.SA_DisplayID, SC_ID,
	I.SA_Overscan, I.OSCAN_TEXT,
	I.SA_Depth, 2,
	I.SA_AutoScroll, 1,
	I.SA_Pens, pens,
	I.SA_ShowTitle, TRUE,
	I.SA_Title, "Intuition double-buffering example",
	I.SA_VideoControl, vctags,
	I.SA_SysFont, 1,
	U.TAG_DONE ) ;
  IF canvassc = NIL THEN RETURN "Couldn't open screen\n" END ;

  canvasvi := GT.GetVisualInfo( canvassc, U.TAG_DONE ) ;
  IF canvasvi = NIL THEN RETURN "Couldn't get VisualInfo\n" END ;

  canvaswin := I.OpenWindowTags( NIL,
	I.WA_NoCareRefresh, TRUE,
	I.WA_Activate, TRUE,
	I.WA_Borderless, TRUE,
	I.WA_Backdrop, TRUE,
	I.WA_CustomScreen, canvassc,
	I.WA_NewLookMenus, TRUE,
	U.TAG_DONE ) ;
  IF canvaswin = NIL THEN RETURN "Couldn't open window\n" END ;

  canvaswin^.UserPort := userport ;

  I.ModifyIDCMP( canvaswin, I.IDCMP_MENUPICK+I.IDCMP_VANILLAKEY ) ;

  controlsc := I.OpenScreenTags( NIL,
	I.SA_DisplayID, SC_ID,
	I.SA_Overscan, I.OSCAN_TEXT,
	I.SA_Depth, 2,
	I.SA_Pens, pens,
	I.SA_Top, CONTROLSC_TOP,
	I.SA_Height, 28,
	I.SA_Parent, canvassc,
	I.SA_ShowTitle, FALSE,
	I.SA_Draggable, FALSE,
	I.SA_VideoControl, vctags,
	I.SA_Quiet, TRUE,
	I.SA_SysFont, 1,
	U.TAG_DONE ) ;
  IF controlsc = NIL THEN RETURN "Couldn't open screen\n" END ;

  controlvi := GT.GetVisualInfo( controlsc, U.TAG_DONE ) ;
  IF controlvi = NIL THEN RETURN "Couldn't get VisualInfo\n" END ;

  menu := GT.CreateMenus( demomenu, U.TAG_DONE ) ;
  IF menu = NIL THEN RETURN "Couldn't create menus\n" END ;

  IF ~GT.LayoutMenus( menu,canvasvi,GT.GTMN_NewLookMenus,TRUE,U.TAG_DONE ) THEN
    RETURN "Couldn't layout menus\n" ;
  END ;

  IF createAllGadgets( glist, controlvi ) = NIL THEN
    RETURN "Couldn't create gadgets\n"
  END ;

  (* A borderless backdrop window so we can get input *)
  controlwin := I.OpenWindowTags( NIL,
	I.WA_NoCareRefresh, TRUE,
	I.WA_Activate, TRUE,
	I.WA_Borderless, TRUE,
	I.WA_Backdrop, TRUE,
	I.WA_CustomScreen, controlsc,
	I.WA_NewLookMenus, TRUE,
	I.WA_Gadgets, glist,
	U.TAG_DONE ) ;

  IF controlwin = NIL THEN RETURN "Couldn't open window\n" END ;

  controlwin^.UserPort := userport ;
  I.ModifyIDCMP( controlwin,
    		   GT.SLIDERIDCMP+I.IDCMP_MENUPICK+I.IDCMP_VANILLAKEY ) ;

  GT.GT_RefreshWindow( controlwin, NIL ) ;
  I.SetMenuStrip( canvaswin, menu ) ;
  I.LendMenus( controlwin, canvaswin ) ;

  scbuf[0] := I.AllocScreenBuffer( canvassc, NIL, I.SB_SCREEN_BITMAP ) ;
  IF scbuf[0] = NIL THEN RETURN "Couldn't allocate ScreenBuffer 1\n" END ;

  scbuf[1] := I.AllocScreenBuffer( canvassc, NIL, I.SB_COPY_BITMAP ) ;
  IF scbuf[1] = NIL THEN RETURN "Couldn't allocate ScreenBuffer 2\n" END ;

  (* Let's use the UserData to store the buffer number, for	*)
  (* easy identification when the message comes back.		*)
  scbuf[0]^.sb_DBufInfo^.dbi_UserData1 := 0 ;
  scbuf[1]^.sb_DBufInfo^.dbi_UserData1 := 1 ;
  status[0] := OK_REDRAW ;
  status[1] := OK_REDRAW ;

  face := makeImageBM( ) ;
  IF face = NIL THEN RETURN "Couldn't allocate image bitmap\n" END ;
  G.InitRastPort( rport[0] ) ;
  G.InitRastPort( rport[1] ) ;
  rport[0].BitMap := scbuf[0]^.sb_BitMap ;
  rport[1].BitMap := scbuf[1]^.sb_BitMap ;

  x	:= 50 ;
  y	:= 70 ;
  xstep :=  1 ;
  xdir  :=  1 ;
  ystep :=  1 ;
  ydir  := -1 ;

  (* All is OK *)
  RETURN NIL
END init_all ;

(*----------------------------------------------------------------------------*)

(* Draw a crude "face" for animation *)

CONST
  MAXVECTORS = 10 ;

PROCEDURE makeImageBM( ) : G.BitMapPtr ;
  VAR
    bm	       : G.BitMapPtr ;
    rport      : G.RastPort ;
    area       : G.AreaInfo ;
    tmpRas     : G.TmpRas ;
    planePtr   : G.PLANEPTR ;
    areabuffer : ARRAY [0..(MAXVECTORS*5-1)] OF SHORTINT ;
BEGIN
  bm := G.AllocBitMap( BM_WIDTH,BM_HEIGHT,BM_DEPTH,G.BMF_CLEAR,NIL ) ;
  IF bm # NIL THEN
     planePtr := G.AllocRaster( BM_WIDTH, BM_HEIGHT ) ;
     IF planePtr # NIL THEN
	G.InitRastPort( rport ) ;
	rport.BitMap := bm ;

	G.InitArea( area, S.ADR( areabuffer ) , MAXVECTORS ) ;
	rport.AreaInfo := S.ADR( area ) ;

	G.InitTmpRas( tmpRas, planePtr, G.RASSIZE( BM_WIDTH, BM_HEIGHT ) );
	rport.TmpRas := S.ADR( tmpRas ) ;

	G.SetABPenDrMd( S.ADR( rport ) , 3 , 0 , G.JAM1 ) ;
	G.AreaEllipse( S.ADR( rport ) , BM_WIDTH/2, BM_HEIGHT/2,
		BM_WIDTH/2-4, BM_HEIGHT/2-4 );
	G.AreaEnd( S.ADR( rport ) ) ;

	G.SetAPen( S.ADR( rport ) , 2 ) ;
	G.AreaEllipse( S.ADR( rport ) , 5*BM_WIDTH/16 , BM_HEIGHT/4 ,
		BM_WIDTH/9, BM_HEIGHT/9 );
	G.AreaEllipse( S.ADR( rport ), 11*BM_WIDTH/16, BM_HEIGHT/4,
		BM_WIDTH/9, BM_HEIGHT/9 ) ;
	G.AreaEnd( S.ADR( rport ) ) ;

	G.SetAPen( S.ADR( rport ) , 1 );
	G.AreaEllipse( S.ADR( rport ) , BM_WIDTH/2, 3*BM_HEIGHT/4,
		BM_WIDTH/3, BM_HEIGHT/9 );
	G.AreaEnd( S.ADR( rport ) ) ;

	G.FreeRaster( planePtr, BM_WIDTH, BM_HEIGHT ) ;
      ELSE
	G.FreeBitMap( bm ) ;
	bm := NIL ;
      END ;
    RETURN bm ;
  END ;
END makeImageBM ;

(*----------------------------------------------------------------------------*)

(* Make a pair of slider gadgets to control horiz and vertical speed of motion*)

PROCEDURE createAllGadgets( VAR glistptr : I.GadgetPtr ;
			              vi : S.ADDRESS ) : I.GadgetPtr ;
  VAR
    ng  : GT.NewGadget ;
    gad : I.GadgetPtr  ;
BEGIN
  gad := GT.CreateContext( glistptr ) ;

  ng.ng_LeftEdge   := 100 ;
  ng.ng_TopEdge	   := 1 ;
  ng.ng_Width	   := 100 ;
  ng.ng_Height	   := 12 ;
  ng.ng_GadgetText := "Horiz:  " ;
  ng.ng_TextAttr   := S.ADR( Topaz80 ) ;
  ng.ng_VisualInfo := vi ;
  ng.ng_GadgetID   := GAD_HORIZ ;
  ng.ng_Flags	   := { } ;

  gad := GT.CreateGadget( GT.SLIDER_KIND, gad, ng ,
	GT.GTSL_Min, 0,
	GT.GTSL_Max, 9,
	GT.GTSL_Level, 1,
	GT.GTSL_MaxLevelLen, 1,
	GT.GTSL_LevelFormat, "%ld",
	U.TAG_DONE ) ;

  horizgad := gad ;

  INC( ng.ng_LeftEdge, 200 ) ;
  ng.ng_GadgetID := GAD_VERT;
  ng.ng_GadgetText := "Vert:  ";
  vertgad := GT.CreateGadget( GT.SLIDER_KIND, gad, ng ,
	GT.GTSL_Min, 0,
	GT.GTSL_Max, 9,
	GT.GTSL_Level, 1,
	GT.GTSL_MaxLevelLen, 1,
	GT.GTSL_LevelFormat, "%ld",
	U.TAG_DONE );

  gad := vertgad ;
  RETURN gad  ;
END createAllGadgets ;

(*----------------------------------------------------------------------------*)

(* Clean up everything and exit, printing the errorstring if any *)
PROCEDURE error_exit( errorstring : S.STRING ) ;
BEGIN
  IF controlwin # NIL THEN
    I.ClearMenuStrip( controlwin ) ;
    CloseWindowSafely( controlwin ) ;
  END ;

  IF canvaswin # NIL THEN
    I.ClearMenuStrip( canvaswin ) ;
    CloseWindowSafely( canvaswin ) ;
  END ;

  IF controlsc # NIL THEN I.CloseScreen( controlsc ) END ;

  IF canvassc # NIL THEN
    I.FreeScreenBuffer( canvassc, scbuf[1] ) ;
    I.FreeScreenBuffer( canvassc, scbuf[0] ) ;
    I.CloseScreen( canvassc ) ;
  END ;

  IF dbufport # NIL THEN E.DeleteMsgPort( dbufport ) END ;
  IF userport # NIL THEN E.DeleteMsgPort( userport ) END ;

  GT.FreeGadgets( glist ) ;
  GT.FreeMenus( menu ) ;
  GT.FreeVisualInfo( canvasvi ) ;
  GT.FreeVisualInfo( controlvi ) ;

  IF face # NIL THEN G.FreeBitMap( face ) END ;

  IF errorstring # NIL THEN D.Printf( "%s",errorstring ) ; SLib.exit(20) END ;

  SLib.exit( 0 ) ;
END error_exit ;

(*----------------------------------------------------------------------------*)

(* these functions close an Intuition window	*)
(* that shares a port with other Intuition	*)
(* windows or IPC customers.			*)
(*						*)
(* We are careful to set the UserPort to	*)
(* null before closing, and to free		*)
(* any messages that it might have been		*)
(* sent.					*)

PROCEDURE CloseWindowSafely( win : I.WindowPtr ) ;
BEGIN
  E.Forbid(); (* we forbid here to keep out of race conditions with Intuition *)

  (* send back any messages for this window that have not yet been processed *)
  StripIntuiMessages( win^.UserPort, win );

  (* clear UserPort so Intuition will not free it *)
  win^.UserPort := NIL ;

  (* tell Intuition to stop sending more messages *)
  I.ModifyIDCMP( win , { } ) ;

  (* turn multitasking back on *)
  E.Permit() ;

  (* and really close the window *)
  I.CloseWindow( win ) ;

END CloseWindowSafely ;

(* remove and reply all IntuiMessages on a port that	*)
(* have been sent to a particular window		*)
(* ( note that we don't rely on the ln_Succ pointer	*)
(*  of a message after we have replied it )		*)

PROCEDURE StripIntuiMessages( mp : E.MsgPortPtr ; win : I.WindowPtr ) ;
  VAR
    msg  : I.IntuiMessagePtr ;
    succ : E.NodePtr ;
BEGIN
  msg := I.IntuiMessagePtr( mp^.mp_MsgList.lh_Head ) ;
  LOOP
    succ :=  msg^.ExecMessage.mn_Node.ln_Succ ;
    IF succ = NIL THEN EXIT END ;
    IF msg^.IDCMPWindow = win THEN
      (* Intuition is about to free this message.	*)
      (* Make sure that we have politely sent it back.	*)
      E.Remove( E.NodePtr( msg ) ) ;
      E.ReplyMsg( msg ) ;
    END ;
    msg := I.IntuiMessagePtr( succ ) ;
  END ;
END StripIntuiMessages ;

(*----------------------------------------------------------------------------*)

BEGIN
  scbuf    := [NIL,NIL] ;
  prevx    := [ 50, 50] ;
  prevy    := [ 50, 50] ;
  Topaz80  := ["topaz.font",8,{},{}];
  vctags   := [[G.VTAG_BORDERSPRITE_SET,TRUE],[U.TAG_DONE,0]] ;
  pens	   := [0,1,1,2,1,3,1,0,2,1,2,1,MAX(CARDINAL)] ;
  demomenu :=
       [
        [ GT.NM_TITLE,"Project" ],
	[ GT.NM_ITEM, "Run", 		   "R", {}, 0, MENU_RUN   ],
	[ GT.NM_ITEM, "Step", 		   "S", {}, 0, MENU_STEP  ],
	[ GT.NM_ITEM, GT.NM_BARLABEL ],
	[ GT.NM_ITEM, "Slower Horizontal", "1", {}, 0, MENU_HSLOW ],
	[ GT.NM_ITEM, "Faster Horizontal", "2", {}, 0, MENU_HFAST ],
	[ GT.NM_ITEM, "Slower Vertical",   "3", {}, 0, MENU_VSLOW ],
	[ GT.NM_ITEM, "Faster Vertical",   "4", {}, 0, MENU_VFAST ],
	[ GT.NM_ITEM, GT.NM_BARLABEL],
	[ GT.NM_ITEM, "Quit", 		   "Q", {}, 0, MENU_QUIT  ],
	[ GT.NM_END ]
       ] ;
  main( )
END DoubleBuffer.
