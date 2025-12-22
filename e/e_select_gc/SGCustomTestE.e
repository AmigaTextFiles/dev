

/*  Select.gadget test 2 (25.5.98)  */
/*  Written for SAS/C               */
/*  Compile: SC LINK SGCustomTest   */
/*  © 1998 Massimo Tantignone       */
/*  E Translation by Victor Ducedre*/

MODULE 'exec/types', 'exec/ports', 'dos/dos', 'intuition/intuition',
       'intuition/gadgetclass', 'libraries/gadtools',
       'utility/tagitem', 'intuition/screens', 'libraries/gadtools',
       'gadtools', 'graphics/rastport', 'graphics/text'

MODULE 'gadgets/select', 'selectgadget'

RAISE "gadg" IF CreateGadgetA()=NIL,
      "draw" IF GetScreenDrawInfo()=NIL,
      "win"  IF OpenWindowTagList()=NIL,
      "vis"  IF GetVisualInfoA()=NIL

PROC main() HANDLE
DEF scr:PTR TO screen, win:PTR TO window, imsg:PTR TO intuimessage,
    vi, dri:PTR TO drawinfo, class, code, fine=TRUE,
    width=640, height=200,
    one=FALSE, two=FALSE,
    gad1:PTR TO gadget, gad2:PTR TO gadget, glist=NIL:PTR TO gadget,
    iaddress:PTR TO gadget, labels1:PTR TO LONG, labels2:PTR TO LONG

  labels1:= ['First option', 'Second option', 'Third option', 'Fourth option', NIL]

  labels2:= ['This is a', 'GadTools gadget',  'which was made', 'pop-up',
             'by the support', 'functions of', 'the select.gadget', 'library.',NIL]

  /* Let's try to open the "select.gadget" library any way we can */

  IF (gadtoolsbase:=OpenLibrary('gadtools.library', 39))=0 THEN Raise("lib")

  IF (selectgadgetbase:= OpenLibrary('select.gadget',40))=0
    IF (selectgadgetbase:=OpenLibrary('Gadgets/select.gadget',40))=0
      IF (selectgadgetbase:=OpenLibrary('Classes/Gadgets/select.gadget',40))=0
        /* Really not found? Then quit (and complain a bit) */
        Raise("lib")
      ENDIF
    ENDIF
  ENDIF

  /* Inquire about the real screen size */
  IF scr:= LockPubScreen(NIL)
    width:= scr.width
    height:= scr.height
    UnlockPubScreen(NIL,scr)
  ENDIF

  /* Open a window on the default public screen */

  win:= OpenWindowTagList(NIL,[WA_LEFT,(width - 500) / 2,
                               WA_TOP,(height - 160) / 2,
                               WA_WIDTH,500,WA_HEIGHT,160,
                               WA_MINWIDTH,100,WA_MINHEIGHT,100,
                               WA_MAXWIDTH,-1,WA_MAXHEIGHT,-1,
                               WA_CLOSEGADGET,TRUE,
                               WA_SIZEGADGET,TRUE,
                               WA_DEPTHGADGET,TRUE,
                               WA_DRAGBAR,TRUE,
                               WA_SIMPLEREFRESH,TRUE,
                               WA_ACTIVATE,TRUE,
                               WA_TITLE,'select.gadget test',
                               WA_IDCMP,IDCMP_CLOSEWINDOW OR
                                        IDCMP_GADGETUP OR
                                        IDCMP_REFRESHWINDOW,
                               TAG_DONE])
  /* Get the screen's DrawInfo, it will be useful... */
  dri:=GetScreenDrawInfo(win.wscreen)

  /* Same for the VisualInfo */

  vi:= GetVisualInfoA(win.wscreen,NIL)

  /* Create two gadgets, the GadTools way */

  glist:= CreateContext({glist})

  /* The width isn't very accurate, but this is just an example */


  gad1:= CreateGadgetA(GENERIC_KIND,glist,
                        [40, win.bordertop+40, win.wscreen.rastport.font.xsize*18+30,
                         win.wscreen.font.ysize + 6, 'G_adTools 1', win.wscreen.font,
                         1, 0, vi, NIL]:newgadget,
                        [GT_UNDERSCORE,"_",TAG_DONE])

  gad2:= CreateGadgetA(GENERIC_KIND,gad1,
                        [win.width -70 -(win.wscreen.rastport.font.xsize*18),
                         win.bordertop+80, win.wscreen.rastport.font.xsize*18+30,
                         win.wscreen.font.ysize + 6, 'Ga_dTools 2', win.wscreen.font,
                         2, 0, vi, NIL]:newgadget,
                        [GT_UNDERSCORE,"_",TAG_DONE])


  /* If all went ok, transform the gadgets and use them */

  one:= InitSelectGadgetA(gad1,0,[GA_DRAWINFO,dri,
                                 SGA_TEXTPLACE,PLACETEXT_RIGHT,
                                 SGA_LABELS,labels1,
                                 SGA_DROPSHADOW,TRUE,
                                 SGA_FOLLOWMODE,SGFM_KEEP,
                                 TAG_DONE])

  two:= InitSelectGadgetA(gad2,0,[GA_DRAWINFO,dri,
                                 SGA_TEXTPLACE,PLACETEXT_LEFT,
                                 SGA_LABELS,labels2,
                                 SGA_ACTIVE,3,
                                 SGA_ITEMSPACING,2,
                                 SGA_POPUPPOS,SGPOS_BELOW,
                                 SGA_SYMBOLWIDTH,-21,
                                 TAG_DONE])


  /* Add the gadgets to the window and display them */

  AddGList(win,glist,-1,-1,NIL)
  RefreshGList(glist,win,NIL,-1)
  Gt_RefreshWindow(win,NIL)

  /* Now let's handle the events until the window gets closed */

  WHILE fine
    Wait(Shl(1, win.userport.sigbit))
    WHILE imsg:= Gt_GetIMsg(win.userport)
      class:= imsg.class
      code:= imsg.code
      iaddress:= imsg.iaddress
      Gt_ReplyIMsg(imsg)
      SELECT class
        CASE IDCMP_CLOSEWINDOW
          fine:=FALSE
        CASE IDCMP_GADGETUP
          PrintF('Gadget: \d, Item: \d\n', iaddress.gadgetid, code)
        CASE IDCMP_REFRESHWINDOW
          Gt_BeginRefresh(win)
          Gt_EndRefresh(win,TRUE)
      ENDSELECT
    ENDWHILE
  ENDWHILE
EXCEPT DO
  IF gad2 THEN RemoveGList(win,glist,-1)

  /* Strip the gadgets of additional "select" information */
  IF one THEN ClearSelectGadget(gad1)
  IF two THEN ClearSelectGadget(gad2)

  /* Dispose the gadgets; FreeGadgets() ignores NULL arguments */
  IF glist THEN FreeGadgets(glist)

  /* Free the VisualInfo */
  IF vi THEN FreeVisualInfo(vi)

  /* Release the DrawInfo structure */
  IF dri THEN FreeScreenDrawInfo(win.wscreen,dri)

  /* Say good-bye to the window... */
  IF win THEN CloseWindow(win)

  /* ... and to the library */
  IF selectgadgetbase THEN CloseLibrary(selectgadgetbase)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)

  /* We did our job, now let's go home :-) */
ENDPROC RETURN_OK

