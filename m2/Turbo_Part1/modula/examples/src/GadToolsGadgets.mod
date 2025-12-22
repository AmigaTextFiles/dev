MODULE GadToolsGadgets ; (* RKRM example *)

FROM SYSTEM IMPORT STRING,ADR ;

IMPORT
  G  := Graphics{37},
  I  := Intuition{37},
  GT := GadTools{37},
  D  := Dos{37},
  E  := Exec,
  U  := Utility,
  SL := StdLib ;

PROCEDURE DisableBreak( ) : LONGINT ;
BEGIN RETURN 0
END DisableBreak ;

(* Gadget defines of our choosing, to be used as GadgetID's,	*)
(* also used as the index into the gadget array my_gads[].	*)

CONST
  MYGAD_SLIDER    = 0 ;
  MYGAD_STRING1   = 1 ;
  MYGAD_STRING2   = 2 ;
  MYGAD_STRING3   = 3 ;
  MYGAD_BUTTON    = 4 ;

(* Range for the slider: *)
  SLIDER_MIN	  =  1 ;
  SLIDER_MAX	  = 20 ;

VAR
  Topaz80 : G.TextAttr ;

(* Print any error message.  We could do more fancy handling	*)
(* (like an EasyRequest()), but this is only a demo.		*)

PROCEDURE errorMessage( error : STRING ) ;
BEGIN IF error # NIL THEN D.Printf("Error: %s\n", error) END
END errorMessage ;

(* Function to handle a GADGETUP or GADGETDOWN event.  For GadTools gadgets,  *)
(* it is possible to use this function to handle MOUSEMOVEs as well, with     *)
(* little or no work.							      *)

PROCEDURE handleGadgetEvent( win  : I.WindowPtr ;
			     gad  : I.GadgetPtr ;
			     code : CARDINAL ;
			     VAR slider_level : INTEGER ;
			     VAR my_gads : ARRAY OF I.GadgetPtr ) ;
BEGIN
  CASE gad^.GadgetID OF
  | MYGAD_SLIDER: (*Sliders report their level in the IntuiMessage Code field:*)
    D.Printf( "Slider at level %ld\n", code ) ;
               slider_level := code

  | MYGAD_STRING1: (* String gadgets report GADGETUP's *)

    D.Printf( "String gadget 1: '%s'.\n",
               gad^.SpecialInfo(I.StringInfoPtr)^.Buffer )

  | MYGAD_STRING2: (* String gadgets report GADGETUP's *)

    D.Printf( "String gadget 2: '%s'.\n",
                gad^.SpecialInfo(I.StringInfoPtr)^.Buffer )

  | MYGAD_STRING3: (* String gadgets report GADGETUP's *)

    D.Printf( "String gadget 3: '%s'.\n",
		gad^.SpecialInfo(I.StringInfoPtr)^.Buffer )

  | MYGAD_BUTTON: (* Buttons report GADGETUP's (button resets slider to 10) *)

    D.Printf("Button was pressed, slider reset to 10.\n");
    slider_level := 10 ;
    GT.GT_SetGadgetAttrs( my_gads[MYGAD_SLIDER], win, NIL,
                          GT.GTSL_Level, slider_level,
                          U.TAG_END )
  ELSE
  END
END handleGadgetEvent ;


(* Function to handle vanilla keys *)

PROCEDURE handleVanillaKey( win		 : I.WindowPtr ;
			    code	 : CARDINAL ;
    			VAR slider_level : INTEGER ;
    			VAR my_gads	 : ARRAY OF I.GadgetPtr ) ;
BEGIN
  CASE CHR( code ) OF

  | 'v': (* increase slider level, but not past maximum *)

         INC( slider_level ) ;
         IF slider_level > SLIDER_MAX THEN slider_level := SLIDER_MAX END ;
         GT.GT_SetGadgetAttrs( my_gads[MYGAD_SLIDER], win, NIL,
                               GT.GTSL_Level, slider_level, U.TAG_END )

  | 'V': (* decrease slider level, but not past minimum *)

         DEC( slider_level ) ;
         IF slider_level < SLIDER_MIN THEN slider_level := SLIDER_MIN END ;
         GT.GT_SetGadgetAttrs( my_gads[MYGAD_SLIDER], win, NIL,
                               GT.GTSL_Level, slider_level, U.TAG_END )

  | 'c','C': (* button resets slider to 10 *)

             slider_level := 10 ;
             GT.GT_SetGadgetAttrs( my_gads[MYGAD_SLIDER], win, NIL,
                                   GT.GTSL_Level, slider_level, U.TAG_END )

  |'f','F': I.ActivateGadget( my_gads[MYGAD_STRING1], win, NIL )
  |'s','S': I.ActivateGadget( my_gads[MYGAD_STRING2], win, NIL )
  |'t','T': I.ActivateGadget( my_gads[MYGAD_STRING3], win, NIL )
  ELSE
  END
END handleVanillaKey ;


(* Here is where all the initialization and creation of GadTools gadgets  *)
(* take place.  This function requires a pointer to a NIL-initialized     *)
(* gadget list pointer.  It returns a pointer to the last created gadget, *)
(* which can be checked for success/failure.				  *)

PROCEDURE createAllGadgets( VAR glistptr     : I.GadgetPtr ;
				vi	     : GT.VisualInfoPtr ;
		                topborder    : CARDINAL ;
				slider_level : INTEGER ;
		            VAR my_gads      : ARRAY OF I.GadgetPtr
		          ) : I.GadgetPtr;
  VAR
    ng  : GT.NewGadget ;
    gad : I.GadgetPtr ;

(* All the gadget creation calls accept a pointer to the previous gadget, and *)
(* link the new gadget to that gadget's NextGadget field.  Also, they exit    *)
(* gracefully, returning NIL, if any previous gadget was NIL.  This limits    *)
(* the amount of checking for failure that is needed.  You only need to check *)
(* before you tweak any gadget structure or use any of its fields,and finally *)
(* once at the end, before you add the gadgets.				      *)

(* The following operation is required of any program that uses GadTools. *)
(* It gives the toolkit a place to stuff context data.			  *)

BEGIN
  gad := GT.CreateContext( glistptr ) ;

(* Since the NewGadget structure is unmodified by any of the CreateGadget() *)
(* calls, we need only change those fields which are different.		    *)

  ng.ng_LeftEdge   := 140 ;
  ng.ng_TopEdge    := 20+topborder ;
  ng.ng_Width      := 200 ;
  ng.ng_Height     := 12 ;
  ng.ng_GadgetText := "_Volume:   " ;
  ng.ng_TextAttr   := ADR( Topaz80 ) ;
  ng.ng_VisualInfo := vi ;
  ng.ng_GadgetID   := MYGAD_SLIDER ;
  ng.ng_Flags      := GT.NG_HIGHLABEL ;

  gad := GT.CreateGadget( GT.SLIDER_KIND, gad, ng,
			  GT.GTSL_Min,         SLIDER_MIN,
			  GT.GTSL_Max,         SLIDER_MAX,
			  GT.GTSL_Level,       slider_level,
			  GT.GTSL_LevelFormat, "%2ld",
			  GT.GTSL_MaxLevelLen, 2,
			  GT.GT_Underscore,    '_',
			  U.TAG_END ) ;

  my_gads[MYGAD_SLIDER] := gad ;

  INC( ng.ng_TopEdge, 20 ) ;
  ng.ng_Height     := 14 ;
  ng.ng_GadgetText := "_First:" ;
  ng.ng_GadgetID   := MYGAD_STRING1 ;

  gad := GT.CreateGadget( GT.STRING_KIND, gad, ng,
			  GT.GTST_String,   "Try pressing",
			  GT.GTST_MaxChars, 50,
			  GT.GT_Underscore, '_',
			  U.TAG_END ) ;

  my_gads[MYGAD_STRING1] := gad ;

  INC( ng.ng_TopEdge, 20 ) ;

  ng.ng_GadgetText := "_Second:" ;
  ng.ng_GadgetID   := MYGAD_STRING2 ;

  gad := GT.CreateGadget( GT.STRING_KIND, gad, ng,
			  GT.GTST_String,   "TAB or Shift-TAB",
			  GT.GTST_MaxChars, 50,
			  GT.GT_Underscore, '_',
			  U.TAG_END ) ;

  my_gads[MYGAD_STRING2] := gad ;

  INC( ng.ng_TopEdge, 20 ) ;
  ng.ng_GadgetText := "_Third:";
  ng.ng_GadgetID   := MYGAD_STRING3;

  gad := GT.CreateGadget( GT.STRING_KIND, gad, ng,
			  GT.GTST_String,   "To see what happens!",
			  GT.GTST_MaxChars, 50,
			  GT.GT_Underscore, '_',
			  U.TAG_END ) ;

  my_gads[MYGAD_STRING3] := gad ;

  INC( ng.ng_LeftEdge, 50 );
  INC( ng.ng_TopEdge, 20 ) ;
  ng.ng_Width      := 100 ;
  ng.ng_Height     := 12 ;
  ng.ng_GadgetText := "_Click Here" ;
  ng.ng_GadgetID   := MYGAD_BUTTON ;
  ng.ng_Flags      := { } ;
  gad := GT.CreateGadget( GT.BUTTON_KIND, gad, ng,
  			  GT.GT_Underscore, '_',
  			  U.TAG_END ) ;
  RETURN gad
END createAllGadgets ;


(* Standard message handling loop with GadTools message handling functions *)
(* used (GT_GetIMsg() and GT_ReplyIMsg()).				   *)

PROCEDURE process_window_events( mywin : I.WindowPtr ;
				 slider_level : INTEGER ;
				 VAR my_gads : ARRAY OF I.GadgetPtr ) ;

  VAR
    imsg	: I.IntuiMessagePtr ;
    imsgClass	: LONGSET ;
    imsgCode	: CARDINAL ;
    gad		: I.GadgetPtr ;
    terminated	: BOOLEAN ;

BEGIN
  terminated := FALSE ;

  WHILE ~terminated DO
    E.Wait({mywin^.UserPort^.mp_SigBit}) ;

    (* GT_GetIMsg()returns an IntuiMessage with more friendly information for *)
    (* complex gadget classes.  Use it wherever you get IntuiMessages where   *)
    (* using GadTools gadgets.						      *)

    LOOP
      IF terminated THEN EXIT END ;
      imsg := GT.GT_GetIMsg( mywin^.UserPort ) ;
      IF imsg = NIL THEN EXIT END ;

      (* Presuming a gadget, of course, but no harm...			*)
      (* Only dereference this value (gad) where the Class specifies	*)
      (* that it is a gadget event.					*)

      gad := imsg^.IAddress;

      imsgClass := imsg^.Class ;
      imsgCode := imsg^.Code ;

      (* Use the toolkit message-replying function here... *)
      GT.GT_ReplyIMsg( imsg ) ;

      (* GadTools puts the gadget address into IAddress of IDCMP_MOUSEMOVE   *)
      (* messages.  This is NOT true for standard Intuition messages,	     *)
      (* but is an added feature of GadTools.				     *)

      IF imsgClass <= I.IDCMP_GADGETDOWN+I.IDCMP_MOUSEMOVE+I.IDCMP_GADGETUP THEN
	handleGadgetEvent( mywin, gad, imsgCode, slider_level, my_gads )

      ELSIF imsgClass = I.IDCMP_VANILLAKEY THEN
	handleVanillaKey( mywin, imsgCode, slider_level, my_gads )

      ELSIF imsgClass = I.IDCMP_CLOSEWINDOW THEN
        terminated := TRUE

      ELSIF imsgClass = I.IDCMP_REFRESHWINDOW THEN

	(* With GadTools, the application must use GT_BeginRefresh() *)
	(* where it would normally have used BeginRefresh()	     *)

	GT.GT_BeginRefresh( mywin ) ;
	GT.GT_EndRefresh( mywin , TRUE )
      ELSE HALT
      END
    END
  END
END process_window_events ;


(* Prepare for using GadTools, set up gadgets and open window.	*)
(* Clean up and when done or on error.				*)

PROCEDURE gadtoolsWindow( ) ;

  CONST
    winIDCMP = I.IDCMP_CLOSEWINDOW + I.IDCMP_REFRESHWINDOW+I.IDCMP_VANILLAKEY
    	       +GT.SLIDERIDCMP+GT.STRINGIDCMP+GT.BUTTONIDCMP ;
  VAR
    font	 : G.TextFontPtr ;
    mysc	 : I.ScreenPtr ;
    mywin	 : I.WindowPtr ;
    glist	 : I.GadgetPtr ;
    my_gads	 : ARRAY [0..3] OF I.GadgetPtr ;
    vi	         : GT.VisualInfoPtr ;
    slider_level : INTEGER ;
    topborder    : CARDINAL ;

(* Open topaz 8 font, so we can be sure it's openable	*)
(* when we later set ng_TextAttr to &Topaz80:		*)

BEGIN
  slider_level := 5 ;
  font := G.OpenFont( ADR( Topaz80 ) ) ;
  IF font = NIL THEN errorMessage( "Failed to open Topaz 80")
  ELSE mysc := I.LockPubScreen( NIL ) ;
    IF mysc = NIL THEN errorMessage( "Couldn't lock default public screen")
    ELSE
      vi := GT.GetVisualInfo( mysc, U.TAG_END ) ;
      IF vi = NIL THEN errorMessage( "GetVisualInfo() failed")
      ELSE
        (* Here is how we can figure out ahead of time how tall the  *)
        (* window's title bar will be:                               *)
        topborder := mysc^.WBorTop + (mysc^.Font^.ta_YSize + 1) ;

        IF createAllGadgets( glist,vi,topborder,slider_level,my_gads) = NIL THEN
          errorMessage( "createAllGadgets() failed")
        ELSE
          mywin := I.OpenWindowTags( NIL,
				     I.WA_Title,	 "GadTools Gadget Demo",
				     I.WA_Gadgets,	 glist,
				     I.WA_AutoAdjust,	 TRUE,
				     I.WA_Width,	 400,
				     I.WA_MinWidth,	 50,
				     I.WA_InnerHeight,	 140,
				     I.WA_MinHeight,	 50,
				     I.WA_DragBar,	 TRUE,
				     I.WA_DepthGadget,	 TRUE,
				     I.WA_Activate,	 TRUE,
				     I.WA_CloseGadget,	 TRUE,
				     I.WA_SizeGadget,	 TRUE,
				     I.WA_SimpleRefresh, TRUE,
				     I.WA_IDCMP,	 winIDCMP,
				     I.WA_PubScreen,	 mysc,
				     U.TAG_END ) ;

          IF mywin = NIL THEN errorMessage( "OpenWindow() failed")
          ELSE
            (* After window is open, gadgets must be refreshed with a *)
            (* call to the GadTools refresh window function.          *)

            GT.GT_RefreshWindow( mywin, NIL ) ;
	    process_window_events( mywin, slider_level, my_gads ) ;
	    I.CloseWindow( mywin )
          END
        END ;
        (* FreeGadgets() even if createAllGadgets() fails, as some  *)
        (* of the gadgets may have been created...If glist is NIL   *)
        (* then FreeGadgets() will do nothing.			    *)

        GT.FreeGadgets( glist ) ;
        GT.FreeVisualInfo( vi )
      END ;
      I.UnlockPubScreen( NIL, mysc )
    END ;
    G.CloseFont( font )
  END
END gadtoolsWindow ;

BEGIN
  SL.onbreak( DisableBreak ) ;
  Topaz80 := ["topaz.font",8] ;
  gadtoolsWindow( ) ;
END GadToolsGadgets.
