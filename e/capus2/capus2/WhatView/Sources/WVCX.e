/*********************
 * Def Commodities
 *********************/
CONST EVT_HOTKEY_WV=1
CONST EVT_HOTKEY_PREFS=2
DEF my_newbroker:PTR TO newbroker
DEF broker_mp:PTR TO mp
DEF broker,filter,sender,translate
DEF cxsigflag
DEF hotkey[80]:STRING
DEF hotkeyprefs[80]:STRING
DEF msg=NIL
DEF cxpri=0
/*"cxFilter(d:LONG)"*/
PROC cxFilter(d:LONG) 
    DEF r=NIL
    r:=CreateCxObj(CX_FILTER,d,NIL)
    RETURN r
ENDPROC
/**/
/*"cxSender(port:LONG,id:LONG)"*/
PROC cxSender(port:LONG,id:LONG) 
    DEF r=NIL
    r:=CreateCxObj(CX_SEND,port,id)
    RETURN r
ENDPROC
/**/
/*"cxTranslate(ie:LONG)"*/
PROC cxTranslate(ie:LONG) 
    DEF r=NIL
    r:=CreateCxObj(CX_TRANSLATE,ie,NIL)
    RETURN r
ENDPROC
/**/
/*"p_InitCx()"*/
PROC p_InitCx() HANDLE 
    DEF errorcx=NIL
    DEF txt[80]:STRING
    StringF(txt,'MultiViewers (\s/\s)',hotkey,hotkeyprefs)
    /*=== Initialisation de la commodité ===*/
    my_newbroker:=[NB_VERSION,0,
                   'WhatView',
                   'WhatView v0.17 © 1994 NasGûl',
                   txt,
                   NBU_UNIQUE,
                   COF_SHOW_HIDE,
                   0,0,NIL,0]:newbroker
    IF (broker_mp:=CreateMsgPort())=NIL THEN Raise(ER_PORT)
    my_newbroker.port:=broker_mp
    cxsigflag:=Shl(1,broker_mp.sigbit)
    my_newbroker.pri:=cxpri
    IF (broker:=CxBroker(my_newbroker,NIL))=NIL THEN Raise(ER_CX)
    /* HotKey WhatView */
    filter:=cxFilter(hotkey)
    IF (errorcx:=CxObjError(filter))<>0 THEN Raise(ER_CX)
    AttachCxObj(broker,filter)
    sender:=cxSender(broker_mp,EVT_HOTKEY_WV)
    AttachCxObj(filter,sender)
    translate:=cxTranslate(NIL)
    AttachCxObj(filter,translate)
    IF (errorcx:=CxObjError(filter))=0
        ActivateCxObj(broker,1)
    ELSE
        Raise(ER_CX)
    ENDIF
    /* HotKeyPrefs */
    filter:=cxFilter(hotkeyprefs)
    IF (errorcx:=CxObjError(filter))<>0 THEN Raise(ER_CX)
    AttachCxObj(broker,filter)
    sender:=cxSender(broker_mp,EVT_HOTKEY_PREFS)
    AttachCxObj(filter,sender)
    translate:=cxTranslate(NIL)
    AttachCxObj(filter,translate)
    IF (errorcx:=CxObjError(filter))=0
        ActivateCxObj(broker,1)
    ELSE
        Raise(ER_CX)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RemCx()"*/
PROC p_RemCx() 
    IF broker THEN DeleteCxObjAll(broker)
    IF broker_mp THEN DeleteMsgPort(broker_mp)
ENDPROC
/**/
