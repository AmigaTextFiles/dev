/*
 * Commodité
 *
 * Test des modules argarray & astartup (portage amiga.lib: argc & argv, tooltypes)
 *
 * $VER: Commodité 1.0 (18.04.94) © Roger Delille - Amiga Revue n° 59
 *
 * Adaptation au E: Frantz BALINSKI
 *
 */

PMODULE 'PMODULES:User/argarray' /* astartup inclus */

MODULE	'commodities','libraries/commodities','exec/ports','dos/dos',
	'intuition/intuition','intuition/intuitionbase','intuition/screens',
	'icon','workbench/startup','workbench/workbench'

CONST	OK_HOTKEY=-1

DEF mp=NIL:PTR TO mp,
    broker=NIL,filter=NIL,sender=NIL,translate=NIL

PROC main()
  DEF ttypes,hotkey,newBroker:PTR TO newbroker
  newBroker:=[NB_VERSION,0,'Commodité','Exemple de Commodité',
             'Roger Delille - Amiga Revue n°59',NBU_UNIQUE+NBU_NOTIFY,
             COF_SHOW_HIDE,0,NIL,0,NIL]:newbroker
  iconbase:=NIL; cxbase:=NIL

  IF _astartup()<>NIL THEN _exit(20)	/* _argc et _argv initialisations */

  /*
   * ouvrir les library nécessaires
   */
  IF (iconbase:=OpenLibrary('icon.library',37))
    IF (cxbase:=OpenLibrary('commodities.library',37))
      /*
       * Crée le MsgPort
       */
      IF (mp:=CreateMsgPort())
        newBroker.port:=mp
        ttypes:=_argarrayinit(_argc,_argv)
        newBroker.pri:=_argint(ttypes,'CX_PRIORITY',0)
        hotkey:=_argstring(ttypes,'CX_POPKEY','help')
        /*
         * Crée notre Broker.
         */
        IF (broker:=CxBroker(newBroker,NIL))
          /*
           * Crée notre Filter et l'attache au Broker.
           */
          IF (filter:=cxFilter(hotkey))
            AttachCxObj(broker,filter)
            /*
             * Crée notre Sender
             */
            IF (sender:=cxSender(mp,-1))
              AttachCxObj(filter,sender)
              /*
               * Crée un CxObject de type Translate
               */
              IF (translate:=cxTranslate(NIL))
                AttachCxObj(filter,translate)
                IF CxObjError(filter)=NIL
                  ActivateCxObj(broker,TRUE)
                  cxMain()
                ENDIF
              ENDIF
            ENDIF
          ENDIF
          DeleteCxObjAll(broker)
        ENDIF
	_argarraydone()
        deleteMsgPort({mp})
      ENDIF
      CloseLibrary(cxbase)
    ENDIF
    CloseLibrary(iconbase)
  ENDIF
  _exit(0)
ENDPROC

PROC deleteMsgPort(mpPtr) /* pointer to mp, not mp */
  DEF msg
  IF (^mpPtr<>NIL)
    WHILE (msg:=GetMsg(^mpPtr))<>NIL DO ReplyMsg(msg)
    DeleteMsgPort(^mpPtr)
    ^mpPtr:=NIL
  ENDIF
ENDPROC

/* C macros commodities.h */
PROC cxFilter(d) RETURN CreateCxObj(CX_FILTER,d,0)
PROC cxSender(port,id) RETURN CreateCxObj(CX_SEND,port,id)
PROC cxTranslate(ie) RETURN CreateCxObj(CX_TRANSLATE,ie,0)


PROC cxMain()
  DEF fini=FALSE,msg,type,id
  WHILE fini=FALSE
    /*
     * Attends qu'un message arrive sur notre port.
     */
    WaitPort(mp)
    WHILE (msg:=GetMsg(mp))
      type:=CxMsgType(msg)
      id  :=CxMsgID(msg)
      ReplyMsg(msg)

      SELECT type
        CASE CXM_IEVENT
          IF id=OK_HOTKEY THEN fini:=cxPopUp('Hotkey reçue!\nQuitter ?','Oui|Non')
        CASE CXM_COMMAND
          SELECT id
            CASE CXCMD_DISABLE   ; ActivateCxObj(broker,FALSE)
            CASE CXCMD_ENABLE    ; ActivateCxObj(broker,TRUE)
            CASE CXCMD_KILL      ; fini:=TRUE
            CASE CXCMD_APPEAR    ; cxPopUp('On me demande ?\nMe voilà !','Atchao!')
            CASE CXCMD_DISAPPEAR ; NOP
            CASE CXCMD_UNIQUE
              fini:=cxPopUp('Je suis déjà là!\nVous voulez quitter ?','Oui|Non')
          ENDSELECT
      ENDSELECT
    ENDWHILE
  ENDWHILE
ENDPROC

PROC cxPopUp(text,gads)
ENDPROC EasyRequestArgs(NIL,
	[SIZEOF easystruct,NIL,'Commodité',text,gads]:easystruct,NIL,NIL)

/* Fin Commodité */
