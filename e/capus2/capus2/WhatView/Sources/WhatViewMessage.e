/*"p_LookAllMessage()"*/
PROC p_LookAllMessage() HANDLE 
/*===============================================================================
 = Para         : NONE
 = Return       : ER_NONE if ok,else the error.
 = Description  : Look all Messages
 ==============================================================================*/
    DEF sigreturn
    DEF wvport:PTR TO mp
    DEF tp
    DEF infoport:PTR TO mp
    IF info_window THEN infoport:=info_window.userport ELSE infoport:=NIL
    IF wv_window THEN wvport:=wv_window.userport ELSE wvport:=NIL
    dWriteF(['p_LookAllMessage()\n'],0)
    sigreturn:=Wait(Shl(1,wvport.sigbit) OR
                    Shl(1,prgport.sigbit) OR 
                    Shl(1,nreqsig) OR 
                    Shl(1,publicport.sigbit) OR 
                    Shl(1,infoport.sigbit) OR
                    Shl(1,dummyport.sigbit) OR
                    cxsigflag OR $F000)
    IF (sigreturn AND Shl(1,wvport.sigbit))
        IF p_LookwvMessage()=TRUE THEN p_CloseWindow()
    ENDIF
    IF (sigreturn AND Shl(1,prgport.sigbit))
        p_LookAppMessage()
        IF defact=-1
            IF wv_window=NIL 
                Raise(p_OpenWindow()) 
            ELSE 
                ActivateWindow(wv_window)
                WindowToFront(wv_window)
            ENDIF
        ELSE
            p_DoAction(defact)
            IF wv_window<>NIL THEN p_CloseWindow()
        ENDIF
    ENDIF
    IF (sigreturn AND Shl(1,nreqsig))
        p_ReadPrefsFile('Env:Whatview.prefs')
    ENDIF
    IF (sigreturn AND Shl(1,publicport.sigbit))
        p_LookPublicMessage()
    ENDIF
    IF (sigreturn AND cxsigflag)
        p_LookCxMessage()
    ENDIF
    IF (sigreturn AND $F000)
        reelquit:=TRUE
    ENDIF
    IF (sigreturn AND Shl(1,infoport.sigbit))
        IF p_LookinfoMessage()=TRUE THEN p_CloseInfoWindow()
    ENDIF
    IF (sigreturn AND Shl(1,dummyport.sigbit))
        dWriteF(['Reponse WBSart-Handler\n'],[0])
    ENDIF
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_LookPublicMessage()"*/
PROC p_LookPublicMessage() 
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Parse Message on public port
 ==============================================================================*/
    DEF mymsg:PTR TO wvmsg
    DEF stract[256]:STRING
    DEF doit=-1
    DEF l=NIL,ret
    dWriteF(['p_LookPublicMessage()\n'],0)
    WHILE mymsg:=GetMsg(publicport)
        StringF(stract,'\s',mymsg.name)
        l:=mymsg.lock
        dWriteF(['Lock \h\n'],[l])
        IF l=0
            IF StrCmp(stract,'WHATVIEW',8) THEN doit:=ACT_WHATVIEW
            IF StrCmp(stract,'INFO',4) THEN doit:=ACT_INFO
            IF StrCmp(stract,'ADDICON',7) THEN doit:=ACT_ADDICON
            IF StrCmp(stract,'EXECUTE',7) THEN doit:=ACT_EXECUTE
            IF StrCmp(stract,'QUIT',4) 
                reelquit:=TRUE
                JUMP allok
            ENDIF
            IF StrCmp(stract,'FLUSH',5)
                p_FlushWhatis()
                JUMP allok
            ENDIF
            IF StrCmp(stract,'PREFS',5)
                ret:=p_MakeWVRequest('Préférences','WV_Prefs|What_IsPrefs|_Cancel',0)
                SELECT ret
                    CASE 1
                        p_CLIRun('WVprefs',defprefsdir,4000,0)
                    CASE 2
                        p_CLIRun('WhatIsPrefs',defprefsdir,4000,0)
                ENDSELECT
                JUMP allok
            ENDIF
        ENDIF
        IF doit<>-1
            p_DoAction(doit)
            JUMP allok
        ELSE
            /*p_AjouteArgNode(myw.adremptylist,mymsg.name,mymsg.lock)*/
            p_AjouteArgNode(myw.adremptylist,mymsg.name,l)
        ENDIF
        allok:
        ReplyMsg(mymsg)
    ENDWHILE
ENDPROC
/**/
/*"p_LookAppMessage()"*/
PROC p_LookAppMessage() HANDLE 
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Parse Msg on App
 ==============================================================================*/
    DEF appmsg:PTR TO appmessage
    DEF b
    DEF apparg:PTR TO wbarg
    DEF reelname[80]:STRING,reellock
    dWriteF(['p_LookAppMessage()\n'],0)
    WHILE appmsg:=GetMsg(prgport)
        apparg:=appmsg.arglist
        FOR b:=0 TO appmsg.numargs-1
            StringF(reelname,'\s',apparg[b].name)
            reellock:=apparg[b].lock
            /*p_AjouteArgNode(myw.adremptylist,apparg[b].name,apparg[b].lock)*/
            p_AjouteArgNode(myw.adremptylist,reelname,reellock)
        ENDFOR
        ReplyMsg(appmsg)
    ENDWHILE
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_LookwvMessage()"*/
PROC p_LookwvMessage() 
/*===============================================================================
 = Para         : NONE
 = Return       : TRUE when window is closed,else false.
 = Description  : Look message on Window
 ==============================================================================*/
   DEF mes:PTR TO intuimessage
   DEF g:PTR TO gadget
   DEF type=0,infos=NIL,ret=FALSE,r
   WHILE mes:=Gt_GetIMsg(wv_window.userport)
       type:=mes.class
       dWriteF(['p_LookwvMessage() \d\n'],[type])
       SELECT type
           CASE IDCMP_MENUPICK
              infos:=mes.code
              SELECT infos
              ENDSELECT
           CASE IDCMP_CLOSEWINDOW
              ret:=TRUE
           CASE IDCMP_GADGETUP
              g:=mes.iaddress
              infos:=g.gadgetid
              dWriteF(['p_LookwvMessage() Gad \d\n'],[infos])
              SELECT infos
                  CASE GA_G_WHATVIEW
                      ret:=TRUE
                      p_DoAction(ACT_WHATVIEW)
                  CASE GA_G_INFO
                      ret:=TRUE
                      p_DoAction(ACT_INFO)
                  CASE GA_G_ADDICON
                      ret:=TRUE
                      p_DoAction(ACT_ADDICON)
                  CASE GA_G_EXECUTE
                      ret:=TRUE
                      p_DoAction(ACT_EXECUTE)
                  CASE GA_G_PREFS
                      ret:=TRUE
                      r:=p_MakeWVRequest('Préférences','WV_Prefs|What_IsPrefs|_Cancel',0)
                      SELECT r
                        CASE 1
                            p_CLIRun('WVprefs',defprefsdir,4000,0)
                        CASE 2
                          p_CLIRun('WhatIsPrefs',defprefsdir,4000,0)
                      ENDSELECT
                  CASE GA_G_QUIT
                      ret:=TRUE
                      reelquit:=TRUE
              ENDSELECT
           CASE IDCMP_RAWKEY
               infos:=mes.code
               SELECT infos
                   CASE $31 /* WHATVIEW */
                       ret:=TRUE
                       p_DoAction(ACT_WHATVIEW)
                    CASE $17 /* INFO */
                       ret:=TRUE
                       p_DoAction(ACT_INFO)
                    CASE $10 /* ADDICON */
                       ret:=TRUE
                       p_DoAction(ACT_ADDICON)
                    CASE $12 /* EXECUTE */
                       ret:=TRUE
                       p_DoAction(ACT_EXECUTE)
                    CASE $19 /* PREFS */
                       ret:=TRUE
                       r:=p_MakeWVRequest('Préférences','WVPrefs|WhatIsPrefs|Cancel',0)
                       SELECT r
                            CASE 1
                                p_CLIRun('WVprefs',defprefsdir,4000,0)
                            CASE 2
                                p_CLIRun('WhatIsPrefs',defprefsdir,4000,0)
                       ENDSELECT
                    CASE $20 /* QUIT */
                       reelquit:=TRUE
               ENDSELECT
       ENDSELECT
       Gt_ReplyIMsg(mes)
   ENDWHILE
   RETURN ret
ENDPROC
/**/
/*"p_LookCxMessage()"*/
PROC p_LookCxMessage() 
    DEF sigrcvd=NIL,msgid=NIL,msgtype=NIL
    DEF returnvalue=TRUE,ret
    WHILE msg:=GetMsg(broker_mp) 
        msgid:=CxMsgID(msg)
        msgtype:=CxMsgType(msg) 
        SELECT msgtype 
            CASE CXM_IEVENT 
                SELECT msgid 
                    CASE EVT_HOTKEY_WV
                        IF wv_window=NIL
                            p_OpenWindow() 
                        ELSE
                            p_CloseWindow() 
                        ENDIF 
                    CASE EVT_HOTKEY_PREFS
                        ret:=p_MakeWVRequest('Préférences','WV_Prefs|What_IsPrefs|_Cancel',0)
                        SELECT ret
                            CASE 1
                                p_CLIRun('WVprefs',defprefsdir,4000,0)
                            CASE 2
                                p_CLIRun('WhatIsPrefs',defprefsdir,4000,0)
                        ENDSELECT
                ENDSELECT 
            CASE CXM_COMMAND 
                SELECT msgid
                    CASE CXCMD_KILL 
                        reelquit:=TRUE 
                        returnvalue:=FALSE 
                    CASE  CXCMD_DISABLE 
                        ActivateCxObj(broker,0) 
                    CASE CXCMD_ENABLE
                        ActivateCxObj(broker,1) 
                    CASE CXCMD_APPEAR 
                        IF wv_window=NIL
                            p_OpenWindow() 
                        ELSE 
                            WindowToFront(wv_window)
                        ENDIF 
                    CASE CXCMD_DISAPPEAR 
                        IF wv_window<>NIL
                            p_CloseWindow() 
                        ENDIF 
                ENDSELECT
        ENDSELECT
        ReplyMsg(msg)
    ENDWHILE
ENDPROC
/**/
/*"p_LookinfoMessage()"*/
PROC p_LookinfoMessage() 
   DEF mes:PTR TO intuimessage
   DEF g:PTR TO gadget
   DEF gstr:PTR TO stringinfo
   DEF type=0,infos=NIL,ret=FALSE
   dWriteF(['p_LookinfoMessage() \d\n'],[type])
   WHILE mes:=Gt_GetIMsg(info_window.userport)
       type:=mes.class
       SELECT type
           CASE IDCMP_MENUPICK
              infos:=mes.code
              SELECT infos
              ENDSELECT
           CASE IDCMP_CLOSEWINDOW
               ret:=TRUE
           CASE IDCMP_GADGETUP
              g:=mes.iaddress
              infos:=g.gadgetid
              SELECT infos
                  /*CASE GA_G_INFORM*/
              ENDSELECT
           CASE IDCMP_RAWKEY
               infos:=mes.code
               SELECT infos
               ENDSELECT
       ENDSELECT
       Gt_ReplyIMsg(mes)
   ENDWHILE
   RETURN ret
ENDPROC
/**/
