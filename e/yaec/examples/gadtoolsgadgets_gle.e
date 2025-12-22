-> gadtoolsgadgets.e
-> Simple example of using a number of gadtools gadgets.

-> rewritten to use gle.library, 000513, 29  - leif_salomonsson@swipnet.se
-> added a button just for fun :)
-> 011024 : yaec2.4b : rewritten for gle.b

MODULE 'gadtools',
       'exec/ports',
       'graphics/text',
       'intuition/intuition',
       'intuition/screens',
       'libraries/gadtools',
       '*gle'


RAISE "FONT" IF OpenFont()=NIL,
      "KICK" IF KickVersion()=FALSE,
      "LIB"  IF OpenLibrary()=NIL,
      "PUB"  IF LockPubScreen()=NIL

-> Gadget ENUM to be used as GadgetIDs and also as the indexes into the
-> gadget array my_gads[].
ENUM MYGAD_SLIDER, MYGAD_STRING1, MYGAD_STRING2, MYGAD_STRING3, MYGAD_BUTTON

-> Range for the slider:
CONST SLIDER_MIN=1, SLIDER_MAX=20

DEF gadtoolsbase
DEF gle:PTR TO gle
DEF my_gads[5]:ARRAY OF LONG
DEF my_gads_h[5]:ARRAY OF LONG

PROC handleString1(gle, gad, gadval)
    WriteF('String gadget 1: \"\s\".\n', gadval)
ENDPROC

PROC handleSlider(gle, gad, gadval)
    WriteF('Slider at level \d\n', gadval)
ENDPROC

PROC handleString2(gle, gad, gadval)
    WriteF('String gadget 2: \"\s\".\n', gadval)
ENDPROC

PROC handleString3(gle, gad, gadval)
    WriteF('String gadget 3: \"\s\".\n', gadval)
ENDPROC

PROC handleButton(gle, gad, gadval)
    WriteF('Button gadget Was pressed\n')
ENDPROC

PROC createAllGadgets()

   gle.placing(GP_UNDER)

   gle.spaceXY(2,2)

   gle.mRight(10)

   gle.addGad(SLIDER_KIND,
          MYGAD_SLIDER,
          16,
          1,
          '_Volume:   ',
          [GTSL_MIN,         SLIDER_MIN,
           GTSL_MAX,         SLIDER_MAX,
           GTSL_LEVELFORMAT, '\d[2]',
           GTSL_MAXLEVELLEN, 2,
           NIL
          ])

   gle.eEventHandler({handleSlider}, MYGAD_SLIDER)



   gle.addGad(STRING_KIND, MYGAD_STRING1, 12, 1, '_First:',
                                    [GTST_STRING,   'Try pressing',
                                        NIL])
   gle.eEventHandler({handleString1}, MYGAD_STRING1)


   gle.addGad(STRING_KIND, MYGAD_STRING2, 16, 1, '_Second:',
                                      [GTST_STRING,   'TAB or Shift-TAB',
                                                  NIL])
   gle.eEventHandler({handleString2}, MYGAD_STRING2)


   gle.addGad(STRING_KIND, MYGAD_STRING3, 20, 1, '_Third:',
        [GTST_STRING,   'To see what happens!',
                                      NIL])
   gle.eEventHandler({handleString3}, MYGAD_STRING3)


   gle.addGad(BUTTON_KIND, MYGAD_BUTTON, -1, 1, 'Min Knapp', NIL)
   gle.eEventHandler({handleButton}, MYGAD_BUTTON)

ENDPROC 

PROC process_window_events()
  DEF imsg:PTR TO intuimessage, imsgClass, imsgcpy:intuimessage 
  DEF terminated=FALSE
  DEF mywin:PTR TO window
  mywin := gle.getWin()
   REPEAT
    Wait(Shl(1, mywin.userport.sigbit))

    WHILE (terminated=FALSE) AND (imsg:=GT_GetIMsg(mywin.userport))
      copyIMessage(imsg, imsgcpy)
      GT_ReplyIMsg(imsg)

      imsgClass:=imsgcpy.class
      
      SELECT imsgClass
      CASE IDCMP_GADGETDOWN ; gle.eHandleEvent(imsgcpy)
      CASE IDCMP_MOUSEMOVE  ; gle.eHandleEvent(imsgcpy)
      CASE IDCMP_GADGETUP   ; gle.eHandleEvent(imsgcpy)
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


PROC gadtoolsWindow() HANDLE
  DEF mysc=NIL:PTR TO screen, mywin=NIL

  mysc:=LockPubScreen(NIL)

  WriteF('Locked screen\n')

  NEW gle.gle(mysc,my_gads,my_gads_h)

  WriteF('Created gle\n')

  createAllGadgets()

  WriteF('Created gads\n')

  mywin := gle.openWin(
                       [WA_SIMPLEREFRESH,TRUE,
                        WA_DRAGBAR,      TRUE,
                        WA_DEPTHGADGET,  TRUE,
                        WA_ACTIVATE,     TRUE,
                        WA_CLOSEGADGET,  TRUE,
                        WA_IDCMP,IDCMP_CLOSEWINDOW OR
                                 IDCMP_REFRESHWINDOW OR
                                 IDCMP_VANILLAKEY OR
                                 SLIDERIDCMP OR
                                 STRINGIDCMP OR
                                 BUTTONIDCMP,
                        NIL]
                      )

  gle.setGad(MYGAD_SLIDER, 10)
  process_window_events()

EXCEPT DO
  END gle
  IF mysc THEN UnlockPubScreen(mysc, NIL)
  ReThrow()  -> E-Note: pass on exception if it was an error
ENDPROC

PROC main() HANDLE
  KickVersion(37)
  gadtoolsbase:=OpenLibrary('gadtools.library', 37)
  gadtoolsWindow()
EXCEPT DO
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  SELECT exception
  CASE "KICK"; WriteF('Error: Requires V37\n')
  CASE "LIB";  WriteF('Error: could not open library\n')
  CASE "PUB";  WriteF('Error: Couldn\'t lock default public screen\n')
  CASE "MEM" ;  WriteF('Error: NEW\n')
  CASE GLE_ERR_VISUAL  ; WriteF('Error: Couldn\'t get visual info\n')
  CASE GLE_ERR_CONTEXT ; WriteF('Error: Couldn\'t create context\n')
  CASE GLE_ERR_WIN ; WriteF('Error: Couldn\'t open window\n')
  CASE "PTR" ; WriteF('Error: low PTR at line \d!\n', exceptioninfo)
  CASE "INDX" ; WriteF('Error: out of INDX on line \d!\n', exceptioninfo)
  CASE "STCK" ; WriteF('Error: out of STCK on line \d!\n', exceptioninfo)
  ENDSELECT
ENDPROC
