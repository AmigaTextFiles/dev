/*  Select.gadget test 2 (25.5.98)              */
/*  Originally Written for SAS/C                */
/*  Compile: SC LINK SGCustomTest               */
/*  © 1998 Massimo Tantignone                   */
/*  Translated (30.05.98) to AmigaE by:         */
/*  THE DARK FRONTIER Softwareentwicklungen     */
/*  Grundler Mathias                            */
/*  frontier@starbase.inka.de                   */

MODULE  'exec/ports'
MODULE  'graphics/text'
MODULE  'graphics/rastport'
MODULE  'intuition/intuition'
MODULE  'intuition/screens'
MODULE  'intuition/gadgetclass'
MODULE  'libraries/gadtools'
MODULE  'gadtools'
MODULE  'gadgets/select'
MODULE  'selectgadget'

ENUM    ERR_GADTOOLS=1,
        ERR_GADGET,
        ERR_WIN

PROC main()     HANDLE
 DEF    scr=NIL:PTR TO screen,
        win=NIL:PTR TO window,
        imsg=NIL:PTR TO intuimessage,
        dri=NIL:PTR TO drawinfo,
        vi=NIL,
        class,
        code,
        fine=FALSE,
        width=640,
        height=200,
        one=FALSE,
        two=FALSE,
        ng:newgadget,           -> staticly created!!!
        gad1=NIL:PTR TO gadget,
        gad2=NIL:PTR TO gadget,
        glist=NIL:PTR TO gadget,
        iaddress=NIL:PTR TO gadget,
        labels1=NIL,
        labels2=NIL

   labels1:=[   'First option',
                'Second option',
                'Third option',
                'Fourth option',
                NIL]
   labels2:=[  'This is a',
               'GadTools gadget',
               'which was made',
               'pop-up',
               'by the support',
               'functions of',
               'the select.gadget',
               'library.',
               NIL]

-> The original Source doesn`t open the GadTools-Library !!!

  IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ERR_GADTOOLS)
   selectgadgetbase:=OpenLibrary('select.gadget',40)
   IF (selectgadgetbase=NIL) THEN selectgadgetbase := OpenLibrary('Gadgets/select.gadget',40)
   IF (selectgadgetbase=NIL) THEN selectgadgetbase := OpenLibrary('Classes/Gadgets/select.gadget',40)

   IF (selectgadgetbase=NIL) THEN Raise(ERR_GADGET)

   IF (scr := LockPubScreen(NIL))
    width := scr.width
     height := scr.height
    UnlockPubScreen(NIL,scr)
   ENDIF

   IF (win := OpenWindowTagList(NIL,[WA_LEFT,(width - 500) / 2,
                                 WA_TOP,(height - 160) / 2,
                                 WA_WIDTH,500,WA_HEIGHT,160,
                                 WA_MINWIDTH,100,WA_MINHEIGHT,100,
                                 WA_CLOSEGADGET,TRUE,
                                 WA_SIZEGADGET,TRUE,
                                 WA_DEPTHGADGET,TRUE,
                                 WA_DRAGBAR,TRUE,
                                 WA_SIMPLEREFRESH,TRUE,
                                 WA_ACTIVATE,TRUE,
                                 WA_TITLE,'select.gadget custom gadget test in E',
                                 WA_IDCMP,IDCMP_CLOSEWINDOW OR
                                          IDCMP_GADGETUP OR
                                          IDCMP_REFRESHWINDOW,
                                 NIL,NIL]))
      IF (dri := GetScreenDrawInfo(win.wscreen))

         IF (vi := GetVisualInfoA(win.wscreen,NIL))

            glist := CreateContext({glist}) -> Importat! Take care of the {}!!!

            ng.leftedge := 40;
            ng.topedge  := win.bordertop + 40
            ng.width    := (win.wscreen.rastport.font.xsize * 18) + 30
            ng.height   := win.wscreen.font.ysize + 6
            ng.gadgettext := 'G_adTools 1'
            ng.textattr := win.wscreen.font
            ng.gadgetid := 1
            ng.flags    := NIL
            ng.visualinfo := vi

-> The original Source makes use of the Arg-Version and not of the Tag-Version from
-> CreateGadget!!

            gad1 := CreateGadgetA(GENERIC_KIND,glist,ng,[GT_UNDERSCORE,'_',NIL,NIL])

            ng.leftedge := win.width - 40 - ng.width
            ng.topedge  := ng.topedge + 40
            ng.gadgettext := 'Ga_dTools 2'
            ng.gadgetid := 2

            gad2 := CreateGadgetA(GENERIC_KIND,gad1,ng,[GT_UNDERSCORE,'_',NIL,NIL])

            IF (gad2)
               one := InitSelectGadgetA(gad1,NIL,[GA_DRAWINFO,  dri,
                                              SGA_TEXTPLACE,    PLACETEXT_RIGHT,
                                              SGA_LABELS,       labels1,
                                              SGA_DROPSHADOW,   TRUE,
                                              SGA_FOLLOWMODE,   SGFM_KEEP,
                                              NIL,NIL])

               two := InitSelectGadgetA(gad2,NIL,[GA_DRAWINFO,  dri,
                                              SGA_TEXTPLACE,    PLACETEXT_LEFT,
                                              SGA_LABELS,       labels2,
                                              SGA_ACTIVE,       3,
                                              SGA_ITEMSPACING,  2,
                                              SGA_POPUPPOS,     SGPOS_BELOW,
                                              SGA_SYMBOLWIDTH,  -21,
                                              NIL,NIL])
               AddGList(win,glist,-1,-1,NIL)
               RefreshGList(glist,win,NIL,-1)
               Gt_RefreshWindow(win,NIL)
            ENDIF

            WHILE (fine=0)
               Wait(Shl(1,win.userport.sigbit))

               WHILE (imsg := Gt_GetIMsg(win.userport))
                class := imsg.class
                code  := imsg.code
                iaddress := imsg.iaddress
                 Gt_ReplyIMsg(imsg)

-> The original Source uses a lot of IF`s, i use SELECT for a cleaner Source!

                  SELECT        class
                    CASE        IDCMP_CLOSEWINDOW
                        fine := TRUE
                    CASE        IDCMP_GADGETUP
                        WriteF('Gadget: \d, Item: \d\n',iaddress.gadgetid,code)
                    CASE        IDCMP_REFRESHWINDOW
                     Gt_BeginRefresh(win)
                     Gt_EndRefresh(win,TRUE)
                  ENDSELECT
               ENDWHILE
            ENDWHILE

            IF (gad2) THEN RemoveGList(win,glist,-1)

            IF (one) THEN ClearSelectGadget(gad1)
            IF (two) THEN ClearSelectGadget(gad2)

            FreeGadgets(glist)

            FreeVisualInfo(vi);
         ENDIF

         FreeScreenDrawInfo(win.wscreen,dri)
      ENDIF

      CloseWindow(win)
   ELSE
    Raise(ERR_WIN)
   ENDIF

-> E-Note! I use Exception-Handling for Error-Parsing, instead of pure
-> IF`s and RETURN-Values!

EXCEPT DO
 IF (selectgadgetbase<>NIL) THEN CloseLibrary(selectgadgetbase)

-> Now close the gadtools.library again, the original Source doesn`t do this!

 IF (gadtoolsbase<>NIL)     THEN CloseLibrary(gadtoolsbase)
 CleanUp(exception)     -> Leave with exception as Returncode
ENDPROC
