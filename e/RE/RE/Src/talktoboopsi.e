/* Talk2Boopsi.e - free translation of Talk2Boopsi.c from RKRM libraries */
MODULE 'intuition/intuition', 'intuition/gadgetclass', 'intuition/icclass'

PROC main()
  DEF w:PTR TO Window, prop:PTR TO Gadget, integer:PTR TO Gadget

  IF w:=OpenWindowTagList(NIL,[WA_Flags,$E,WA_IDCMP,$200,WA_Width,120,
    WA_Height,150,0])
    IF prop:=NewObjectA(NIL,'propgclass',[GA_ID,1,GA_Top,w.BorderTop+5,
      GA_Left,w.BorderLeft+5,GA_Width,10,GA_Height,80,ICA_MAP,[PGA_Top,
      STRINGA_LongVal,0],PGA_Total,100,PGA_Top,25,PGA_Visible,10,
      PGA_NewLook,TRUE,0])
      IF integer:=NewObjectA(NIL,'strgclass',[GA_ID,2,GA_Top,w.BorderTop+5,
        GA_Left,w.BorderLeft+30,GA_Width,40,GA_Height,18,ICA_MAP,
        [STRINGA_LongVal,PGA_Top,0],ICA_TARGET,prop,GA_Previous,prop,
        STRINGA_LongVal,25,STRINGA_MaxChars,3,0])
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
