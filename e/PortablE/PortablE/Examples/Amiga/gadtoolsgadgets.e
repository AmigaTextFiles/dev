/* An old E example converted to PortablE.
   From Src/Rkrm/GadTools/, and originally converted to E by Jason R. Hulance. */

-> gadtoolsgadgets.e
-> Simple example of using a number of gadtools gadgets.

OPT POINTER
MODULE 'gadtools'
MODULE 'exec/ports'
MODULE 'graphics/text'
MODULE 'intuition/intuition'
MODULE 'intuition/screens'
MODULE 'libraries/gadtools'
MODULE 'exec', 'graphics', 'intuition', 'utility/tagitem'

ENUM ERR_NONE, ERR_FONT, ERR_GAD, ERR_KICK, ERR_LIB, ERR_PUB, ERR_VIS, ERR_WIN

RAISE ERR_FONT IF OpenFont()=NIL,
      ERR_GAD  IF CreateGadgetA()=NIL,
      ERR_KICK IF KickVersion()=FALSE,
      ERR_LIB  IF OpenLibrary()=NIL,
      ERR_PUB  IF LockPubScreen()=NIL,
      ERR_VIS  IF GetVisualInfoA()=NIL,
      ERR_WIN  IF OpenWindowTagList()=NIL

-> Gadget ENUM to be used as GadgetIDs and also as the indexes into the
-> gadget array my_gads[].
ENUM MYGAD_SLIDER, MYGAD_STRING1, MYGAD_STRING2, MYGAD_STRING3, MYGAD_BUTTON

-> Range for the slider:
CONST SLIDER_MIN=1, SLIDER_MAX=20

DEF topaz80:PTR TO textattr

-> Function to handle a GADGETUP or GADGETDOWN event.  For GadTools gadgets,
-> it is possible to use this function to handle MOUSEMOVEs as well, with
-> little or no work.
-> E-Note: slider_level is not a 'PTR TO INT', but 'PTR TO LONG'
PROC handleGadgetEvent(win:PTR TO window, gad:PTR TO gadget, code,
                       slider_level:ARRAY OF VALUE, my_gads:ARRAY OF PTR TO gadget)
  DEF id
  id:=gad.gadgetid
  SELECT id
  CASE MYGAD_SLIDER
    -> Sliders report their level in the IntuiMessage Code field:
    Print('Slider at level \d\n', code)
    slider_level[0]:=code
  CASE MYGAD_STRING1
    -> String gadgets report GADGETUP's
    Print('String gadget 1: "\s".\n', gad.specialinfo::stringinfo.buffer)
  CASE MYGAD_STRING2
    -> String gadgets report GADGETUP's
    Print('String gadget 2: "\s".\n', gad.specialinfo::stringinfo.buffer)
  CASE MYGAD_STRING3
    -> String gadgets report GADGETUP's
    Print('String gadget 3: "\s".\n', gad.specialinfo::stringinfo.buffer)
  CASE MYGAD_BUTTON
    -> Buttons report GADGETUP's (button resets slider to 10)
    Print('Button was pressed, slider reset to 10.\n')
    slider_level[0]:=10
    Gt_SetGadgetAttrsA(my_gads[MYGAD_SLIDER], win, NIL,
                      [GTSL_LEVEL, slider_level[0], NIL]:tagitem)
  ENDSELECT
ENDPROC

-> Function to handle vanilla keys.
-> E-Note: slider_level is not a 'PTR TO INT', but 'PTR TO LONG'
PROC handleVanillaKey(win:PTR TO window, code, slider_level:ARRAY OF VALUE, my_gads:ARRAY OF PTR TO gadget)
  SELECT 128 OF code
  CASE "v"
    -> Increase slider level, but not past maximum
    slider_level[0]:=Min(slider_level[0]+1, SLIDER_MAX)
    Gt_SetGadgetAttrsA(my_gads[MYGAD_SLIDER], win, NIL,
                      [GTSL_LEVEL, slider_level[0], NIL]:tagitem)
  CASE "V"
    -> Decrease slider level, but not past maximum
    slider_level[0]:=Max(slider_level[0]-1, SLIDER_MIN)
    Gt_SetGadgetAttrsA(my_gads[MYGAD_SLIDER], win, NIL,
                      [GTSL_LEVEL, slider_level[0], NIL]:tagitem)
  CASE "c", "C"
    -> Button resets slider to 10
    slider_level[0]:=10
    Gt_SetGadgetAttrsA(my_gads[MYGAD_SLIDER], win, NIL,
                      [GTSL_LEVEL, slider_level[0], NIL]:tagitem)
  CASE "f", "F"
    ActivateGadget(my_gads[MYGAD_STRING1], win, NIL)
  CASE "s", "S"
    ActivateGadget(my_gads[MYGAD_STRING2], win, NIL)
  CASE "t", "T"
    ActivateGadget(my_gads[MYGAD_STRING3], win, NIL)
  ENDSELECT
ENDPROC

-> Here is where all the initialisation and creation of GadTools gadgets take
-> place.  This function requires a pointer to a NIL-initialised gadget list
-> pointer.  It returns a pointer to the last created gadget.
-> E-Note: exceptions raised by CreateGadgetA() will be handled by caller
PROC createAllGadgets(glistptr:ARRAY OF PTR TO gadget, vi:ARRAY, topborder,
                      slider_level, my_gads:ARRAY OF PTR TO gadget)
  DEF gad:PTR TO gadget, ng:PTR TO newgadget
  -> All the gadget creation calls accept a pointer to the previous gadget, and
  -> link the new gadget to that gadget's NextGadget field.  Also, they exit
  -> gracefully, returning NIL, if any previous gadget was NIL.  This limits
  -> the amount of checking for failure that is needed.  You only need to check
  -> before you tweak any gadget structure or use any of its fields, and
  -> finally once at the end, before you add the gadgets.

  -> The following operation is required of any program that uses GadTools.
  -> It gives the toolkit a place to stuff context data.
  gad:=CreateContext(glistptr)

  -> Since the NewGadget structure is unmodified by any of the CreateGadgetA()
  -> calls, we need only change those fields which are different.
  ng:=[140, (20+topborder) !!INT,  200, 12, '_Volume:   ', topaz80,
       MYGAD_SLIDER, NG_HIGHLABEL, vi, NILA]:newgadget

  my_gads[MYGAD_SLIDER]:=(gad:=CreateGadgetA(SLIDER_KIND, gad, ng,
                                    [GTSL_MIN,         SLIDER_MIN,
                                     GTSL_MAX,         SLIDER_MAX,
                                     GTSL_LEVEL,       slider_level,
                                     GTSL_LEVELFORMAT, '%ld',
                                     GTSL_MAXLEVELLEN, 2,
                                     GT_UNDERSCORE,    "_",
                                     NIL]:tagitem))
 

  ng.topedge    := ng.topedge+20
  ng.height     := 14
  ng.gadgettext := '_First:'
  ng.gadgetid   := MYGAD_STRING1
  my_gads[MYGAD_STRING1]:=(gad:=CreateGadgetA(STRING_KIND, gad, ng,
                                     [GTST_STRING,   'Try pressing',
                                      GTST_MAXCHARS, 50,
                                      GT_UNDERSCORE, "_",
                                      NIL]:tagitem))

  ng.topedge    := ng.topedge+20
  ng.gadgettext := '_Second:'
  ng.gadgetid   := MYGAD_STRING2
  my_gads[MYGAD_STRING2]:=(gad:=CreateGadgetA(STRING_KIND, gad, ng,
                                     [GTST_STRING,   'TAB or Shift-TAB',
                                      GTST_MAXCHARS, 50,
                                      GT_UNDERSCORE, "_",
                                      NIL]:tagitem))

  ng.topedge    := ng.topedge+20
  ng.gadgettext := '_Third:'
  ng.gadgetid   := MYGAD_STRING3
  my_gads[MYGAD_STRING3]:=(gad:=CreateGadgetA(STRING_KIND, gad, ng,
                                     [GTST_STRING,   'To see what happens!',
                                      GTST_MAXCHARS, 50,
                                      GT_UNDERSCORE, "_",
                                      NIL]:tagitem))
  ng.leftedge   := 50
  ng.topedge    := ng.topedge+20
  ng.width      := 100
  ng.height     := 12
  ng.gadgettext := '_Click Here'
  ng.gadgetid   := MYGAD_BUTTON
  ng.flags      := 0
  gad:=CreateGadgetA(BUTTON_KIND, gad, ng,
                    [GT_UNDERSCORE, "_", NIL]:tagitem)
ENDPROC gad

-> Standard message handling loop with GadTools message handling functions
-> used (Gt_GetIMsg() and Gt_ReplyIMsg()).
-> E-Note: slider_level is not a 'PTR TO INT', but 'PTR TO LONG'
PROC process_window_events(mywin:PTR TO window, slider_level:ARRAY OF VALUE,
                           my_gads:ARRAY OF PTR TO gadget)
  DEF imsg:PTR TO intuimessage, imsgClass, imsgCode, gad:PTR TO gadget, terminated
  terminated:=FALSE
  REPEAT
    Wait(Shl(1, mywin.userport.sigbit))

    -> Gt_GetIMsg() returns an IntuiMessage with more friendly information for
    -> complex gadget classes.  Use it wherever you get IntuiMessages where
    -> using GadTools gadgets.
    WHILE (terminated=FALSE) AND (imsg:=Gt_GetIMsg(mywin.userport))
      -> Presuming a gadget, of course, but no harm...  Only dereference this
      -> value (gad) where the Class specifies that it is a gadget event.
      gad:=imsg.iaddress

      imsgClass:=imsg.class
      imsgCode:=imsg.code

      -> Use the toolkit message-replying function here...
      Gt_ReplyIMsg(imsg)

      SELECT imsgClass
        ->  --- WARNING --- WARNING --- WARNING --- WARNING --- WARNING ---
        -> GadTools puts the gadget address into IAddress of IDCMP_MOUSEMOVE
        -> messages.  This is NOT true for standard Intuition messages,
        -> but is an added feature of GadTools.
      CASE IDCMP_GADGETDOWN
        handleGadgetEvent(mywin, gad, imsgCode, slider_level, my_gads)
      CASE IDCMP_MOUSEMOVE
        handleGadgetEvent(mywin, gad, imsgCode, slider_level, my_gads)
      CASE IDCMP_GADGETUP
        handleGadgetEvent(mywin, gad, imsgCode, slider_level, my_gads)

      CASE IDCMP_VANILLAKEY
        handleVanillaKey(mywin, imsgCode, slider_level, my_gads)
      CASE IDCMP_CLOSEWINDOW
        terminated:=TRUE
      CASE IDCMP_REFRESHWINDOW
        -> With GadTools, the application must use Gt_BeginRefresh()
        -> where it would normally have used BeginRefresh()
        Gt_BeginRefresh(mywin)
        Gt_EndRefresh(mywin, TRUE)
      ENDSELECT
    ENDWHILE
  UNTIL terminated
ENDPROC

-> Prepare for using GadTools, set up gadgets and open window.
-> Clean up and when done or on error.
PROC gadtoolsWindow()
  DEF font:PTR TO textfont, mysc:PTR TO screen, mywin:PTR TO window, glist:PTR TO gadget
  DEF my_gads[4]:ARRAY OF PTR TO gadget, vi:ARRAY, slider_level, topborder
  
  font:=NIL
  mywin:=NIL
  glist := NIL
  slider_level := 5
  
  -> Open topaz 8 font, so we can be sure it's openable when we later
  -> set ng.textattr to Topaz80:
  topaz80:=['topaz.font', 8, 0, 0]:textattr
  font:=OpenFont(topaz80)
  mysc:=LockPubScreen(NILA)
  vi:=GetVisualInfoA(mysc, [NIL]:tagitem)

  -> Here is how we can figure out ahead of time how tall the window's
  -> title bar will be:
  topborder:=mysc.wbortop+mysc.font.ysize+1

  createAllGadgets(ADDRESSOF glist, vi, topborder, slider_level, my_gads)

  mywin:=OpenWindowTagList(NIL,
                     [WA_TITLE, 'GadTools Gadget Demo',
                      WA_GADGETS,   glist,  WA_AUTOADJUST,    TRUE,
                      WA_WIDTH,       400,  WA_MINWIDTH,        50,
                      WA_INNERHEIGHT, 140,  WA_MINHEIGHT,       50,
                      WA_DRAGBAR,    TRUE,  WA_DEPTHGADGET,   TRUE,
                      WA_ACTIVATE,   TRUE,  WA_CLOSEGADGET,   TRUE,
                      WA_SIZEGADGET, TRUE,  WA_SIMPLEREFRESH, TRUE,
                      WA_IDCMP, IDCMP_CLOSEWINDOW OR IDCMP_REFRESHWINDOW OR IDCMP_VANILLAKEY OR SLIDERIDCMP OR STRINGIDCMP OR BUTTONIDCMP,
                      WA_PUBSCREEN, mysc,
                      TAG_DONE]:tagitem)
  -> After window is open, gadgets must be refreshed with a call to the
  -> GadTools refresh window function.
  Gt_RefreshWindow(mywin, NIL)

  process_window_events(mywin, ADDRESSOF slider_level, my_gads)

FINALLY
  IF mywin THEN CloseWindow(mywin)
  -> FreeGadgets() even if createAllGadgets() fails, as some of the gadgets may
  -> have been created...  If glist is NIL then FreeGadgets() will do nothing.
  FreeGadgets(glist)
  IF vi THEN FreeVisualInfo(vi)
  IF mysc THEN UnlockPubScreen(NILA, mysc)
  IF font THEN CloseFont(font)
ENDPROC

-> Open all libraries and run.  Clean up when finished or on error..
PROC main()
  KickVersion(37)
  gadtoolsbase:=OpenLibrary('gadtools.library', 37)
  gadtoolsWindow()
FINALLY
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  SELECT exception
  CASE ERR_FONT; Print('Error: Failed to open Topaz 80\n')
  CASE ERR_GAD;  Print('Error: createAllGadgets() failed\n')
  CASE ERR_KICK; Print('Error: Requires V37\n')
  CASE ERR_LIB;  Print('Error: Requires V37 gadtools.library\n')
  CASE ERR_PUB;  Print('Error: Couldn\'t lock default public screen\n')
  CASE ERR_VIS;  Print('Error: GetVisualInfoA() failed\n')
  CASE ERR_WIN;  Print('Error: OpenWindow() failed\n')
  ENDSELECT
ENDPROC


