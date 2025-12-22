MODULE 'grio/gadtools','libraries/gadtools',
       'intuition/intuition','gadtools'


PROC main()
DEF gt:PTR TO gadtools,win:PTR TO window,g
NEW gt
IF gt.new()=GTERR_NO
   gt.gadget(BUTTON_KIND,6,5,50,10,'fuck/',PLACETEXT_IN)
   IF win:=gt.openWin(50,100,200,50,IDCMP_CLOSEWINDOW,
                      WFLG_CLOSEGADGET + WFLG_DEPTHGADGET +
                      WFLG_DRAGBAR,'Gadget Window')
      g:=gt.gadget(BUTTON_KIND,60,5,10,10,'dupa',PLACETEXT_IN)
      gt.bevelBox(3,3,110,14,FALSE)
      Delay(50)
      gt.refreshGads()
      WaitPort(win.userport)
      Gt_ReplyIMsg(Gt_GetIMsg(win.userport))
      CloseWindow(win)
   ENDIF
ENDIF
END gt
ENDPROC

