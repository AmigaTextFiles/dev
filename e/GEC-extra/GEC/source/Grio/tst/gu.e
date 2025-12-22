
MODULE 'gadutil','libraries/gadutil','libraries/gadtools'
MODULE 'intuition/intuition','utility/tagitem','exec/ports'
MODULE 'intuition/screens','graphics/rastport'
MODULE 'grio/time'


CONST GD_BUTT=1,GD_BOX=2,GD_PROG=3



PROC main()
DEF butt,box,prog:PTR TO progressgad,gads,glist,ginfo
DEF win:PTR TO window,scr:PTR TO screen,x=0,y=1
DEF imsg:PTR TO intuimessage,class
DEF t:PTR TO time,tsig=0,sig,wsig,z=0


IF (gadutilbase:=OpenLibrary('gadutil.library',36))
   IF (scr:=LockPubScreen(NIL))
       butt:=[GU_GADGETKIND,BUTTON_KIND,
              GU_GADGETTEXT,'Button',
              GU_LEFT,60,
              GU_TOP,8,
              GU_AUTOHEIGHT,5,
              GU_AUTOWIDTH,20,
              TAG_DONE]
       box:=[GU_GADGETKIND,BEVELBOX_KIND,
             GU_GADGETTEXT,'BevelBox',
             GU_LEFT,30,
             GU_TOP,34,
             GU_AUTOWIDTH,70,
             GU_AUTOHEIGHT,30,
             GUBB_FRAMETYPE,BFT_RIDGE,
             GUBB_RECESSED,1,
             GUBB_FLAGS,BB_SUNAT_UL OR BB_3DTEXT,
             GUBB_TEXTCOLOR,2,
             TAG_DONE]
       prog:=[GU_GADGETKIND,PROGRESS_KIND,
              GU_GADGETTEXT,'Progress',
              GU_LEFT,30,
              GU_TOP,94,
              GU_HEIGHT,20,
              GUPR_TOTAL,100,
              GUPR_CURRENT,0,
              GUPR_FILLCOLOR,1,
              GU_FLAGS,PLACETEXT_ABOVE,
              TAG_DONE]
       gads:=[GD_BUTT,butt,NIL,NIL,
              GD_BOX, box, NIL,NIL,
              GD_PROG,prog,NIL,NIL,
              -1]:layoutgadget

       IF (ginfo:=Gu_LayoutGadgetsA({glist},gads,scr,NIL))
          prog:=Gu_GetGadgetPtr(GD_PROG,gads)
          IF (win:=OpenWindowTagList(NIL,[
             WA_LEFT,50,
             WA_TOP,30,
             WA_WIDTH,200,
             WA_HEIGHT,150,
             WA_IDCMP,IDCMP_CLOSEWINDOW OR
                      IDCMP_REFRESHWINDOW,
             WA_FLAGS,WFLG_CLOSEGADGET OR
                      WFLG_RMBTRAP OR
                      WFLG_DEPTHGADGET OR
                      WFLG_DRAGBAR OR
                      WFLG_ACTIVATE,
             WA_TITLE,'GRIO window',
             WA_GADGETS,glist,
             WA_ZOOM,[50,30,200,scr.wbortop+scr.rastport.txheight+1]:INT,
             TAG_DONE]))
           Gu_RefreshWindow(win,ginfo)
           NEW t
           wsig:=Shl(1,win.userport.sigbit)
           IF (tsig:=t.new()) THEN t.delay(0,2000)
           REPEAT
               REPEAT
                     sig:=Wait(wsig OR tsig)
                     IF y THEN INC x ELSE DEC x
                     prog.current:=x
                     Gu_UpdateProgress(win,ginfo,prog)
                     IF x=100
                        Delay(3)
                        y:=0
                     ENDIF
                     IF x=0
                        y:=1
                        IF z
                           prog.fillcolor:=1
                           z:=0
                        ELSE
                           prog.fillcolor:=3
                           z:=1
                        ENDIF
                     ENDIF
                     IF tsig THEN t.delay(0,3000)
               UNTIL sig=tsig
               imsg:=Gu_GetIMsg(win.userport)
               class:=imsg.class
               Gu_ReplyIMsg(imsg)
               IF (IDCMP_REFRESHWINDOW=class) THEN Gu_RefreshBoxes(win,ginfo)
           UNTIL (IDCMP_CLOSEWINDOW=class)
           END t
           CloseWindow(win)
       ENDIF
       Gu_FreeLayoutGadgets(ginfo)
       ENDIF
       UnlockPubScreen(NIL,scr)
   ENDIF
   CloseLibrary(gadutilbase)
ENDIF

ENDPROC

