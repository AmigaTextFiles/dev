MODULE NLMenu ; (* Converted from example in 3.1 native developers update *)

(* Demo shows off the new look menu features of V39. *)

IMPORT
  S    := SYSTEM,
  SLib := StdLib,
  M2   := M2Lib,
  E    := Exec,
  U    := Utility,
  G    := Graphics{39},
  I    := Intuition{39},
  CL   := Classes,
  GT   := GadTools{39},
  DF   := DiskFont{37},
  Dos  := Dos{37} ;

VAR
  mynewmenu	: ARRAY [0..20] OF GT.NewMenu ;
  customtattr	: G.TextAttr ;
  tattr		: G.TextAttrPtr ;
  mysc		: I.ScreenPtr ;
  menu		: I.MenuPtr ;
  mywin		: I.WindowPtr ;
  customfont	: G.TextFontPtr  ;
  vi		: S.ADDRESS ;
  dri		: I.DrawInfoPtr ;
  checkimage	: I.ImagePtr ;
  amigakeyimage : I.ImagePtr ;
  terminated	: BOOLEAN ;

(*------------------------------------------------------------------------*)

PROCEDURE bail_out( int : LONGINT ) ; FORWARD ;
PROCEDURE HandleMenuEvent( UWORD : CARDINAL ) : BOOLEAN ; FORWARD ;

(*------------------------------------------------------------------------*)

PROCEDURE MoreTags( ) : U.Tag ;
BEGIN
  IF customfont = NIL THEN RETURN U.TAG_END
  ELSE RETURN U.TAG_MORE
  END ;
END MoreTags ;

PROCEDURE main( ) ;
  VAR
    imsg      : I.IntuiMessagePtr ;
    imsgClass : LONGSET ;
    imsgCode  : CARDINAL ;
    moretags  : ARRAY [0..2] OF U.TagItem ;
BEGIN
  terminated := FALSE ;

  IF M2.argc = 2 THEN
    Dos.Printf("Usage:\n\tnlmenu\nor\n\tnlmenu fontname.font fontsize\n");
    Dos.Printf("Example:\n\tnlmenu courier.font 15\n");
    bail_out(0);
  END ;

  mysc := I.LockPubScreen( NIL ) ;
  IF mysc = NIL THEN bail_out(0) END;

  vi := GT.GetVisualInfo( mysc, U.TAG_DONE ) ;
  IF vi = NIL THEN bail_out(0) END;

  dri := I.GetScreenDrawInfo( mysc ) ;
  IF dri = NIL THEN bail_out(0) END;

  IF M2.argc < 3 THEN (* Default to screen's font *)
    tattr := mysc^.Font
  ELSE
    customtattr.ta_Style := { } ;
    customtattr.ta_Flags := { } ;

    (* Attempt to use the font specified on the command line: *)
    customtattr.ta_Name := M2.argv^[1] ;

    (* Convert decimal size to long *)
    customtattr.ta_YSize := SLib.atol(M2.argv^[2]) ;
    tattr := S.ADR( customtattr ) ;

    customfont := DF.OpenDiskFont( tattr ) ;
    IF customfont = NIL THEN
      Dos.Printf("Could not open font %s %ld\n", customtattr.ta_Name,
      customtattr.ta_YSize);
      bail_out(20);
    END ;

    (* Generate a custom checkmark whose size matches our custom font *)
    checkimage := CL.NewObject(
        NIL, "sysiclass",
        CL.SYSIA_DrawInfo, dri,
        CL.SYSIA_Which, CL.MENUCHECK,
        CL.SYSIA_ReferenceFont, customfont, (* If NIL, uses dri_Font *)
        U.TAG_DONE ) ;

    IF checkimage = NIL THEN bail_out(20) END ;

    (* Generate a custom Amiga-key image whose size matches our custom font*)

    amigakeyimage := CL.NewObject(
        NIL, "sysiclass",
        CL.SYSIA_DrawInfo, dri,
        CL.SYSIA_Which, CL.AMIGAKEY,
        CL.SYSIA_ReferenceFont, customfont, (* If NIL, uses dri_Font *)
        U.TAG_DONE ) ;
    IF amigakeyimage = NIL THEN bail_out(20) END ;
  END ;

  (* Build and layout menus using the right font: *)
  menu := GT.CreateMenus( mynewmenu , U.TAG_DONE ) ;
  IF menu = NIL THEN bail_out( 20 ) END ;

  (* These are only necessary if a custom font was supplied... *)
  moretags := [[GT.GTMN_Checkmark,checkimage],
    	       [GT.GTMN_AmigaKey,amigakeyimage],
    	       [U.TAG_DONE]];

  IF ~GT.LayoutMenus(  menu, vi,
		       GT.GTMN_TextAttr, tattr,
		       GT.GTMN_NewLookMenus, TRUE,
		       MoreTags( ) , moretags ) THEN bail_out(20) END ;

  (* These are only necessary if a custom font was supplied...	*)
  (* Note: we re-use some of the tag-array initializations from above *)

  moretags[0].ti_Tag := I.WA_Checkmark;
  moretags[1].ti_Tag := I.WA_AmigaKey;

  mywin := I.OpenWindowTags( NIL,
	I.WA_Width, 500,
	I.WA_InnerHeight, 100,
	I.WA_Top, 50,

	I.WA_Activate, TRUE,
	I.WA_DragBar, TRUE,
	I.WA_DepthGadget, TRUE,
	I.WA_CloseGadget, TRUE,
	I.WA_SizeGadget, TRUE,
	I.WA_SmartRefresh, TRUE,

	(* NOTE: NOCAREREFRESH is not allowed if you use GadTools Gadgets! *)
	I.WA_NoCareRefresh, TRUE,

	I.WA_IDCMP, I.CLOSEWINDOW+I.MENUPICK,

	I.WA_MinWidth, 50,
	I.WA_MinHeight, 50,
	I.WA_Title, "GadTools Menu Demo",
	I.WA_NewLookMenus, TRUE,
	MoreTags( ) , moretags ) ;

  IF mywin = NIL THEN bail_out( 20 ) END ;

  I.SetMenuStrip( mywin , menu ) ;

  WHILE ~terminated DO
    E.Wait( {mywin^.UserPort^.mp_SigBit} ) ;

    (* NOTE:  If you use GadTools gadgets, you must use GT_GetIMsg( ) *)
    (* and GT_ReplyIMsg() instead of GetMsg() and ReplyMsg( ).	      *)
    (* Regular GetMsg() and ReplyMsg() are safe if the only part      *)
    (* of GadTools you use are menus...				      *)

    LOOP
      IF terminated THEN EXIT END ;
      imsg := E.GetMsg( mywin^.UserPort ) ;
      IF imsg = NIL THEN EXIT END ;
      imsgClass := imsg^.Class ;
      imsgCode := imsg^.Code ;
      E.ReplyMsg( imsg ) ;
      IF imsgClass = I.MENUPICK THEN
	terminated := HandleMenuEvent( imsgCode )
      ELSIF imsgClass = I.CLOSEWINDOW THEN
	Dos.Printf("CLOSEWINDOW.\n") ;
	terminated := TRUE
      END
    END
  END ;
  bail_out( 0 ) ;
END main ;

(*------------------------------------------------------------------------*)

PROCEDURE bail_out( code : LONGINT );
(* Function to close down or free any opened or allocated stuff, and then exit*)
BEGIN
  IF mywin # NIL THEN I.ClearMenuStrip( mywin ) ; I.CloseWindow( mywin ) END ;

  (* None of these two calls mind a NIL parameter, so it's not *)
  (* necessary to check for non-NIL before calling.	       *)

  GT.FreeMenus( menu ) ;
  GT.FreeVisualInfo( vi ) ;

  IF dri # NIL THEN I.FreeScreenDrawInfo( mysc , dri ) END ;
  IF customfont # NIL THEN
    CL.DisposeObject( amigakeyimage ) ;
    CL.DisposeObject( checkimage ) ;
    G.CloseFont( customfont ) ;
  END ;
  IF mysc # NIL THEN I.UnlockPubScreen( NIL , mysc ) END ;
  SLib.exit( code )
END bail_out ;

(*------------------------------------------------------------------------*)

PROCEDURE HandleMenuEvent( code : CARDINAL ) : BOOLEAN ;
(* This function handles IntuiMessage events of type MENUPICK.*)
BEGIN RETURN FALSE
  (* Your code goes here *)
END HandleMenuEvent ;

(*------------------------------------------------------------------------*)

CONST
  Not1 = -2 ; (* ~1 *)
  Not2 = -3 ; (* ~2 *)
  Not4 = -5 ; (* ~4 *)

BEGIN
(* Here we specify what we want our menus to contain: *)
 mynewmenu :=
       [[ GT.NM_TITLE, "Project",	NIL,{ }, 0, 0],
	[ GT.NM_ITEM , "Open...",	"O",{ }, 0, 0],
	[ GT.NM_ITEM , "Save",	  	NIL,{ }, 0, 0],
	[ GT.NM_ITEM , GT.NM_BARLABEL,  NIL,{ }, 0, 0],
	[ GT.NM_ITEM , "Print",	  	NIL,{ }, 0, 0],
	[ GT.NM_SUB  , "Draft",	  	NIL, I.CHECKIT+I.CHECKED, Not1, 0],
	[ GT.NM_SUB  , "NLQ",	  	NIL, I.CHECKIT, Not2, 0],
	[ GT.NM_SUB  , "Laser",	  	NIL, I.CHECKIT, Not4, 0],
	[ GT.NM_ITEM , GT.NM_BARLABEL,  NIL,{ }, 0, 0],
	[ GT.NM_ITEM , "Quit...",	"Q",{ }, 0, 0],

	[ GT.NM_TITLE, "Edit",	  	NIL,{ }, 0, 0],
	[ GT.NM_ITEM , "Cut",	 	"X",{ }, 0, 0],
	[ GT.NM_ITEM , "Copy",	 	"C",{ }, 0, 0],
	[ GT.NM_ITEM , "Paste",	 	"V",{ }, 0, 0],
	[ GT.NM_ITEM , GT.NM_BARLABEL,  NIL,{ }, 0, 0],
	[ GT.NM_ITEM , "Undo",	 	"Z",{ }, 0, 0],

	[ GT.NM_END  , NIL,		NIL,{ }, 0, 0]] ;

  customtattr	:= []  ;
  tattr		:= NIL ;
  mysc		:= NIL ;
  menu		:= NIL ;
  mywin		:= NIL ;
  customfont	:= NIL ;
  vi		:= NIL ;
  dri		:= NIL ;
  checkimage	:= NIL ;
  amigakeyimage := NIL ;
  terminated	:= FALSE ;

  main( ) ;
END NLMenu.
