-> gadtoolsgadgets.e
-> Simple example of using a number of gadtools gadgets.

MODULE 'gadtools'
MODULE 'exec/ports'
MODULE 'graphics/text'
MODULE 'intuition/intuition'
MODULE 'intuition/screens'
MODULE 'libraries/gadtools'

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

DEF gadtoolsbase

DEF topaz80

-> Function to handle a GADGETUP or GADGETDOWN event.  For GadTools gadgets,
-> it is possible to use this function to handle MOUSEMOVEs as well, with
-> little or no work.
-> E-Note: slider_level is not a 'PTR TO INT', but 'PTR TO LONG'
PROC handleGadgetEvent(win, gad:PTR TO gadget, code,
                       slider_level:PTR TO LONG, my_gads:PTR TO LONG)
  DEF id
  id:=gad.gadgetid
  SELECT id
  CASE MYGAD_SLIDER
    -> Sliders report their level in the IntuiMessage Code field:
    WriteF('Slider at level \d\n', code)
    slider_level[]:=code
  CASE MYGAD_STRING1
    -> String gadgets report GADGETUP's
    WriteF('String gadget 1: \q\s\q.\n', gad.specialinfo::stringinfo.buffer)
  CASE MYGAD_STRING2
    -> String gadgets report GADGETUP's
    WriteF('String gadget 2: \q\s\q.\n', gad.specialinfo::stringinfo.buffer)
  CASE MYGAD_STRING3
    -> String gadgets report GADGETUP's
    WriteF('String gadget 3: \q\s\q.\n', gad.specialinfo::stringinfo.buffer)
  CASE MYGAD_BUTTON
    -> Buttons report GADGETUP's (button resets slider to 10)
    WriteF('Button was pressed, slider reset to 10.\n')
    slider_level[]:=10
    GT_SetGadgetAttrsA(my_gads[MYGAD_SLIDER], win, NIL,
                      [GTSL_LEVEL, slider_level[], NIL])
  ENDSELECT
ENDPROC

-> Function to handle vanilla keys.
-> E-Note: slider_level is not a 'PTR TO INT', but 'PTR TO LONG'
PROC handleVanillaKey(win, code, slider_level:PTR TO LONG, my_gads:PTR TO LONG)
  SELECT code
  CASE "v"
    -> Increase slider level, but not past maximum
    slider_level[]:=Min(slider_level[]+1, SLIDER_MAX)
    GT_SetGadgetAttrsA(my_gads[MYGAD_SLIDER], win, NIL,
                      [GTSL_LEVEL, slider_level[], NIL])
  CASE "V"
    -> Decrease slider level, but not past maximum
    slider_level[]:=Max(slider_level[]-1, SLIDER_MIN)
    GT_SetGadgetAttrsA(my_gads[MYGAD_SLIDER], win, NIL,
                      [GTSL_LEVEL, slider_level[], NIL])
  CASE "c", "C"
    -> Button resets slider to 10
    slider_level[]:=10
    GT_SetGadgetAttrsA(my_gads[MYGAD_SLIDER], win, NIL,
                      [GTSL_LEVEL, slider_level[], NIL])
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
PROC createAllGadgets(glistptr:PTR TO LONG, vi, topborder,
                      slider_level, my_gads:PTR TO LONG)
  DEF gad, ng:PTR TO newgadget
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
  ng:=[140, (20+topborder), 200, 12, '_Volume:   ', topaz80,
       MYGAD_SLIDER, NG_HIGHLABEL, vi, 0]:newgadget

  my_gads[MYGAD_SLIDER]:=(gad:=CreateGadgetA(SLIDER_KIND, gad, ng,
                                    [GTSL_MIN,         SLIDER_MIN,
                                     GTSL_MAX,         SLIDER_MAX,
                                     GTSL_LEVEL,       slider_level,
                                  /* yaec-note: use format of the function */
                                     GTSL_LEVELFORMAT, '%ld',
                                     GTSL_MAXLEVELLEN, 2,
                                     GT_UNDERSCORE,    "_",
                                     NIL]))
 

  ng.topedge    := ng.topedge+20
  ng.height     := 14
  ng.gadgettext := '_First:'
  ng.gadgetid   := MYGAD_STRING1
  my_gads[MYGAD_STRING1]:=(gad:=CreateGadgetA(STRING_KIND, gad, ng,
                                     [GTST_STRING,   'Try pressing',
                                      GTST_MAXCHARS, 50,
                                      GT_UNDERSCORE, "_",
                                      NIL]))

  ng.topedge    := ng.topedge+20
  ng.gadgettext := '_Second:'
  ng.gadgetid   := MYGAD_STRING2
  my_gads[MYGAD_STRING2]:=(gad:=CreateGadgetA(STRING_KIND, gad, ng,
                                     [GTST_STRING,   'TAB or Shift-TAB',
                                      GTST_MAXCHARS, 50,
                                      GT_UNDERSCORE, "_",
                                      NIL]))

  ng.topedge    := ng.topedge+20
  ng.gadgettext := '_Third:'
  ng.gadgetid   := MYGAD_STRING3
  my_gads[MYGAD_STRING3]:=(gad:=CreateGadgetA(STRING_KIND, gad, ng,
                                     [GTST_STRING,   'To see what happens!',
                                      GTST_MAXCHARS, 50,
                                      GT_UNDERSCORE, "_",
                                      NIL]))
  ng.leftedge   := 50
  ng.topedge    := 20
  ng.width      := 100
  ng.height     := 12
  ng.gadgettext := '_Click Here'
  ng.gadgetid   := MYGAD_BUTTON
  ng.flags      := 0
  gad:=CreateGadgetA(BUTTON_KIND, gad, ng,
                    [GT_UNDERSCORE, "_", NIL])
ENDPROC gad

-> Standard message handling loop with GadTools message handling functions
-> used (Gt_GetIMsg() and Gt_ReplyIMsg()).
-> E-Note: slider_level is not a 'PTR TO INT', but 'PTR TO LONG'
PROC process_window_events(mywin:PTR TO window, slider_level:PTR TO LONG,
                           my_gads:PTR TO LONG)
  DEF imsg:PTR TO intuimessage, imsgClass, imsgCode, gad, terminated=FALSE
  REPEAT
    Wait(Shl(1, mywin.userport.sigbit))

    -> Gt_GetIMsg() returns an IntuiMessage with more friendly information for
    -> complex gadget classes.  Use it wherever you get IntuiMessages where
    -> using GadTools gadgets.
    WHILE (terminated=FALSE) AND imsg:=GT_GetIMsg(mywin.userport)
      -> Presuming a gadget, of course, but no harm...  Only dereference this
      -> value (gad) where the Class specifies that it is a gadget event.
      gad:=imsg.iaddress

      imsgClass:=imsg.class
      imsgCode:=imsg.code

      -> Use the toolkit message-replying function here...
      GT_ReplyIMsg(imsg)

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
        GT_BeginRefresh(mywin)
        GT_EndRefresh(mywin, TRUE)
      ENDSELECT
    ENDWHILE
  UNTIL terminated
ENDPROC

-> Prepare for using GadTools, set up gadgets and open window.
-> Clean up and when done or on error.
PROC gadtoolsWindow() HANDLE
  DEF font=NIL, mysc=NIL:PTR TO screen, mywin=NIL, glist=NIL
  DEF my_gads[4]:ARRAY OF LONG, vi, slider_level=5, topborder
  -> Open topaz 8 font, so we can be sure it's openable when we later
  -> set ng.textattr to Topaz80:
  topaz80:=['topaz.font', 8, 0, 0]:textattr
  font:=OpenFont(topaz80)
  mysc:=LockPubScreen(NIL)
  vi:=GetVisualInfoA(mysc, [NIL])

  -> Here is how we can figure out ahead of time how tall the window's
  -> title bar will be:
  topborder:=mysc.wbortop+mysc.font.ysize+1

  createAllGadgets({glist}, vi, topborder, slider_level, my_gads)

  mywin:=OpenWindowTagList(NIL,
                     [WA_TITLE, 'GadTools Gadget Demo',
                      WA_GADGETS,   glist,  WA_AUTOADJUST,    TRUE,
                      WA_WIDTH,       400,  WA_MINWIDTH,        50,
                      WA_INNERHEIGHT, 140,  WA_MINHEIGHT,       50,
                      WA_DRAGBAR,    TRUE,  WA_DEPTHGADGET,   TRUE,
                      WA_ACTIVATE,   TRUE,  WA_CLOSEGADGET,   TRUE,
                      WA_SIZEGADGET, TRUE,  WA_SIMPLEREFRESH, TRUE,
                      WA_IDCMP, IDCMP_CLOSEWINDOW OR IDCMP_REFRESHWINDOW OR
                                IDCMP_VANILLAKEY OR SLIDERIDCMP OR
                                STRINGIDCMP OR BUTTONIDCMP,
                      WA_PUBSCREEN, mysc,
                      NIL])
  -> After window is open, gadgets must be refreshed with a call to the
  -> GadTools refresh window function.
  GT_RefreshWindow(mywin, NIL)

  process_window_events(mywin, {slider_level}, my_gads)

EXCEPT DO
  IF mywin THEN CloseWindow(mywin)
  -> FreeGadgets() even if createAllGadgets() fails, as some of the gadgets may
  -> have been created...  If glist is NIL then FreeGadgets() will do nothing.
  FreeGadgets(glist)
  IF vi THEN FreeVisualInfo(vi)
  IF mysc THEN UnlockPubScreen(mysc, NIL)
  IF font THEN CloseFont(font)
  ReThrow()  -> E-Note: pass on exception if it was an error
ENDPROC

-> Open all libraries and run.  Clean up when finished or on error..
PROC main() HANDLE
  KickVersion(37)
  gadtoolsbase:=OpenLibrary('gadtools.library', 37)
  gadtoolsWindow()
EXCEPT DO
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  SELECT exception
  CASE ERR_FONT; WriteF('Error: Failed to open Topaz 80\n')
  CASE ERR_GAD;  WriteF('Error: createAllGadgets() failed\n')
  CASE ERR_KICK; WriteF('Error: Requires V37\n')
  CASE ERR_LIB;  WriteF('Error: Requires V37 gadtools.library\n')
  CASE ERR_PUB;  WriteF('Error: Couldn\at lock default public screen\n')
  CASE ERR_VIS;  WriteF('Error: GetVisualInfoA() failed\n')
  CASE ERR_WIN;  WriteF('Error: OpenWindow() failed\n')
  ENDSELECT
ENDPROC


