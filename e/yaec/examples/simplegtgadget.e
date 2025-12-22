-> simplegtgadget.e - Simple example of a GadTools gadget.

OPT OSVERSION=37

MODULE 'gadtools',
       'exec/ports',
       'graphics/text',
       'intuition/intuition',
       'intuition/screens',
       'libraries/gadtools'

ENUM ERR_NONE, ERR_GAD, ERR_LIB, ERR_PUB, ERR_VIS, ERR_WIN

RAISE ERR_GAD IF CreateGadgetA()=NIL,
      ERR_LIB IF OpenLibrary()=NIL,
      ERR_PUB IF LockPubScreen()=NIL,
      ERR_VIS IF GetVisualInfoA()=NIL,
      ERR_WIN IF OpenWindowTagList()=NIL

CONST MYGAD_BUTTON=4

DEF gadtoolsbase

-> Open all libraries and run.  Clean up when finished or on error..
PROC main() HANDLE
  gadtoolsbase:=OpenLibrary('gadtools.library', 37)
  gadtoolsWindow()
EXCEPT DO
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  SELECT exception
  CASE ERR_GAD; WriteF('Error: Could not create gadget\n')
  CASE ERR_LIB; WriteF('Error: Could not open gadtools.library\n')
  CASE ERR_PUB; WriteF('Error: Could not lock public screen\n')
  CASE ERR_VIS; WriteF('Error: Could not get visual info\n')
  CASE ERR_WIN; WriteF('Error: Could not open window\n')
  ENDSELECT
ENDPROC

-> Prepare for using GadTools, set up gadgets and open window.
-> Clean up and when done or on error.
PROC gadtoolsWindow() HANDLE
  DEF mysc=NIL:PTR TO screen, mywin=NIL, glist=NIL, gad, vi=NIL
  mysc:=LockPubScreen(NIL)
  vi:=GetVisualInfoA(mysc, [NIL])
  -> GadTools gadgets require this step to be taken
  gad:=CreateContext({glist})

  -> Create a button gadget centered below the window title
  gad:=CreateGadgetA(BUTTON_KIND, gad,
                    [150, (20+mysc.wbortop+mysc.font.ysize+1),
                     100, 12,
                     'Click Here', ['topaz.font', 8, 0, 0]:textattr,
                     MYGAD_BUTTON, 0,
                     vi, NIL]:newgadget,
                    [NIL])
  mywin:=OpenWindowTagList(NIL,
                          [WA_TITLE,     'GadTools Gadget Demo',
                           WA_GADGETS,   glist, WA_AUTOADJUST,    TRUE,
                           WA_WIDTH,     400,   WA_INNERHEIGHT,    100,
                           WA_DRAGBAR,   TRUE,  WA_DEPTHGADGET,   TRUE,
                           WA_ACTIVATE,  TRUE,  WA_CLOSEGADGET,   TRUE,
                           WA_IDCMP, IDCMP_CLOSEWINDOW OR
                                     IDCMP_REFRESHWINDOW OR BUTTONIDCMP,
                           WA_PUBSCREEN, mysc,
                           NIL])
  GT_RefreshWindow(mywin, NIL)
  process_window_events(mywin)
EXCEPT DO
  IF mywin THEN CloseWindow(mywin)
  -> FreeGadgets() must be called after the context has been created.
  -> It does nothing if glist is NIL
  FreeGadgets(glist)
  IF vi THEN FreeVisualInfo(vi)
  IF mysc THEN UnlockPubScreen(NIL, mysc)
  ReThrow()  -> E-Note: pass on exception if it is an error
ENDPROC

-> Standard message handling loop with GadTools message handling functions
-> used (Gt_GetIMsg() and Gt_ReplyIMsg()).
PROC process_window_events(mywin:PTR TO window)
  DEF imsg:PTR TO intuimessage, gad:PTR TO gadget, terminated=FALSE, class
  REPEAT
    Wait(Shl(1, mywin.userport.sigbit))

    -> Use Gt_GetIMsg() and Gt_ReplyIMsg() for handling IntuiMessages
    -> with GadTools gadgets.
    WHILE (terminated=FALSE) AND (imsg:=GT_GetIMsg(mywin.userport))
      -> Gt_ReplyIMsg() at end of loop
      class:=imsg.class
      SELECT class
      CASE IDCMP_GADGETUP  -> Buttons only report GADGETUP
        gad:=imsg.iaddress
        IF gad.gadgetid=MYGAD_BUTTON THEN WriteF('Button was pressed\n')
      CASE IDCMP_CLOSEWINDOW
        terminated:=TRUE
      CASE IDCMP_REFRESHWINDOW
        -> This handling is REQUIRED with GadTools.
        GT_BeginRefresh(mywin)
        GT_EndRefresh(mywin, TRUE)
      ENDSELECT
      -> Use the toolkit message-replying function here...
      GT_ReplyIMsg(imsg)
    ENDWHILE
  UNTIL terminated
ENDPROC
