/* Talk2Boopsi.e - free translation of Talk2Boopsi.c from RKRM libraries */

MODULE 'intuition/intuition', 'intuition/gadgetclass', 'intuition/icclass'

DEF w:PTR TO window, prop:PTR TO gadget, integer:PTR TO gadget

PROC main()
  IF w:=OpenWindowTagList(NIL,[WA_FLAGS,$E,WA_IDCMP,$200,WA_WIDTH,120,
    WA_HEIGHT,150,0])
    IF prop:=NewObjectA(NIL,'propgclass',[GA_ID,1,GA_TOP,w.bordertop+5,
      GA_LEFT,w.borderleft+5,GA_WIDTH,10,GA_HEIGHT,80,ICA_MAP,[PGA_TOP,
      STRINGA_LONGVAL,0],PGA_TOTAL,100,PGA_TOP,25,PGA_VISIBLE,10,
      PGA_NEWLOOK,TRUE,0])
      IF integer:=NewObjectA(NIL,'strgclass',[GA_ID,2,GA_TOP,w.bordertop+5,
        GA_LEFT,w.borderleft+30,GA_WIDTH,40,GA_HEIGHT,18,ICA_MAP,
        [STRINGA_LONGVAL,PGA_TOP,0],ICA_TARGET,prop,GA_PREVIOUS,prop,
        STRINGA_LONGVAL,25,STRINGA_MAXCHARS,3,0])
        SetGadgetAttrsA(prop,w,NIL,[ICA_TARGET,integer,0])
        AddGList(w,prop,-1,-1,NIL)
        RefreshGList(prop,w,NIL,-1)
        WaitIMessage(w)
        RemoveGList(w,prop,-1)
        DisposeObject(integer)
      ENDIF
      DisposeObject(prop)
    ENDIF
    CloseWindow(w)
  ENDIF
ENDPROC
