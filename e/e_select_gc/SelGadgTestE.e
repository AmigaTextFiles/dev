

/*  Select.gadget test (25.5.98)  */
/*  Written for SAS/C             */
/*  Compile: SC LINK SelGadgTest  */
/*  © 1998 Massimo Tantignone     */
/*  E Translation by Victor Ducedre*/

MODULE 'exec/types', 'exec/ports', 'dos/dos', 'intuition/intuition',
       'intuition/gadgetclass', 'libraries/gadtools',
       'utility/tagitem', 'intuition/screens', 'libraries/gadtools'

MODULE 'gadgets/select', 'selectgadget'

RAISE "gadg" IF NewObjectA()=NIL,
      "draw" IF GetScreenDrawInfo()=NIL,
      "win"  IF OpenWindowTagList()=NIL

PROC main() HANDLE
DEF scr:PTR TO screen, win:PTR TO window, imsg:PTR TO intuimessage,
    dri:PTR TO drawinfo, class, code, fine=TRUE,
    width=640, height=200,
    gad1:PTR TO gadget, gad2:PTR TO gadget,
    gad3:PTR TO gadget, gad4:PTR TO gadget,
    iaddress:PTR TO gadget, labels1:PTR TO LONG, labels2:PTR TO LONG

  labels1:= ['First option', 'Second option', 'Third option', 'Fourth option', NIL]

  labels2:= ['This is an', 'example of', 'my BOOPSI', 'pop-up', 'gadget class.',NIL]

  /* Let's try to open the "select.gadget" library any way we can */
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
      /* A standard pop-up gadget, with some attributes overridden */
  gad1:= NewObjectA(NIL,'selectgclass',[GA_LEFT,40,
                                        GA_TOP, win.bordertop+40,
                                        GA_RELVERIFY,TRUE,
                                        GA_DRAWINFO,dri,
                                        GA_TEXT,'Click me',
                                        GA_ID,1,
                                        SGA_TEXTPLACE, PLACETEXT_ABOVE,
                                        SGA_LABELS,labels1,
                                        SGA_SEPARATOR,FALSE,
                                        SGA_ITEMSPACING,2,
                                        SGA_FOLLOWMODE,SGFM_FULL,
                                        SGA_MINTIME,200,
                                        SGA_MAXTIME,200,
                                        SGA_PANELMODE,SGPM_DIRECT_NB,
                                        TAG_DONE])

  /* A "quiet" pop-up gadget, which could be attached to another one */

  gad2:= NewObjectA(NIL,'selectgclass',[GA_PREVIOUS,gad1,
                                        GA_TOP, win.bordertop+80,
                                        GA_RELVERIFY,TRUE,
                                        GA_DRAWINFO,dri,
                                        GA_TEXT,'Me, too!',
                                        GA_ID,2,
                                        SGA_LABELS,labels2,
                                        SGA_POPUPPOS,SGPOS_RIGHT,
                                        SGA_QUIET,TRUE,
                                        SGA_SEPARATOR,FALSE,
                                        SGA_REPORTALL,TRUE,
                                        SGA_BORDERSIZE,8,
                                        SGA_FULLPOPUP,TRUE,
                                        SGA_POPUPDELAY,1,
                                        SGA_DROPSHADOW,TRUE,
                                        SGA_LISTJUSTIFY,SGJ_LEFT,
                                        TAG_DONE])

  /* Let's make it perfectly square, and place it correctly */

  SetAttrsA(gad2,[GA_LEFT,gad1.leftedge + gad1.width - gad2.height,
                  GA_WIDTH,gad2.height,
                  TAG_DONE])

  /* A "sticky" list-type pop-up gadget */

  gad3:= NewObjectA(NIL,'selectgclass',[GA_PREVIOUS,gad2,
                                        GA_TOP,(40 + win.bordertop),
                                        GA_RELVERIFY,TRUE,
                                        GA_DRAWINFO,dri,
                                        GA_TEXT,'Sticky b_utton',
                                        GA_ID,3,
                                        SGA_UNDERSCORE,"_",
                                        SGA_LABELS,labels1,
                                        SGA_ACTIVE,3,
                                        SGA_ITEMSPACING,4,
                                        SGA_SYMBOLONLY,TRUE,
                                        SGA_SYMBOLWIDTH,-21,
                                        SGA_STICKY,TRUE,
                                        SGA_POPUPPOS,SGPOS_BELOW,
                                        SGA_BORDERSIZE,4,
                                        SGA_POPUPDELAY,1,
                                        TAG_DONE])

  /* Let's place it correctly */
  SetAttrsA(gad3,[GA_LEFT,win.width - gad3.width - 40,TAG_DONE])

  /* A pop-up gadget which simply reflects the global user settings */
  gad4:= NewObjectA(NIL,'selectgclass',[GA_PREVIOUS,gad3,
                                        GA_TOP,(80 + win.bordertop),
                                        GA_RELVERIFY,TRUE,
                                        GA_DRAWINFO,dri,
                                        GA_TEXT,'S_imple',
                                        GA_ID,4,
                                        SGA_UNDERSCORE,"_",
                                        SGA_LABELS,labels1,
                                        TAG_DONE])

  /* Let's place it correctly */

  SetAttrsA(gad4,[GA_LEFT,win.width-gad4.width-40,TAG_DONE])

  /* If all went ok, add the gadgets to the window and display them */

  AddGList(win,gad1,-1,-1,NIL)
  RefreshGList(gad1,win,NIL,-1)

  /* Now let's handle the events until the window gets closed */

  WHILE fine
    Wait(Shl(1, win.userport.sigbit))
    WHILE imsg:= GetMsg(win.userport)
      class:= imsg.class
      code:= imsg.code
      iaddress:= imsg.iaddress
      ReplyMsg(imsg)
      SELECT class
        CASE IDCMP_CLOSEWINDOW
          fine:=FALSE
        CASE IDCMP_GADGETUP
          PrintF('Gadget: \d, Item: \d\n', iaddress.gadgetid, code)
        CASE IDCMP_REFRESHWINDOW
          BeginRefresh(win)
          EndRefresh(win,TRUE)
      ENDSELECT
    ENDWHILE
  ENDWHILE

  /* If the gadgets were added, remove them */
EXCEPT DO
  IF gad4 THEN RemoveGList(win,gad1,4)
  /* Dispose the gadgets; DisposeObject() ignores NULL arguments */
  DisposeObject(gad1)
  DisposeObject(gad2)
  DisposeObject(gad3)
  DisposeObject(gad4)

  /* Release the DrawInfo structure */
  IF dri THEN FreeScreenDrawInfo(win.wscreen,dri)

  /* Say good-bye to the window... */
  IF win THEN CloseWindow(win)

  /* ... and to the library */
  IF selectgadgetbase THEN CloseLibrary(selectgadgetbase)

  /* We did our job, now let's go home :-) */

ENDPROC RETURN_OK

