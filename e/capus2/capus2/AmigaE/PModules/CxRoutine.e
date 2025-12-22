/*"cxFilter(d:LONG)"*/
PROC cxFilter(d:LONG) 
    DEF r=NIL
    r:=CreateCxObj(CX_FILTER,d,NIL)
    RETURN r
ENDPROC
/**/
/*"cxBroker(d:LONG,pad:LONG)"*/
PROC cxBroker(d:LONG,pad:LONG) 
    DEF r=NIL
    r:=CreateCxObj(CX_BROKER,d,pad)
    RETURN r
ENDPROC
/**/
/*"cxTypeFilter(type:LONG)"*/
PROC cxTypeFilter(type:LONG) 
    DEF r=NIL
    r:=CreateCxObj(CX_TYPEFILTER,type,0)
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
/*"cxSignal(task:LONG,sig:LONG)"*/
PROC cxSignal(task:LONG,sig:LONG) 
    DEF r=NIL
    r:=CreateCxObj(CX_SIGNAL,task,sig)
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
/*"cxDebug(id:LONG)"*/
PROC cxDebug(id:LONG) 
    DEF r=NIL
    r:=CreateCxObj(CX_DEBUG,id,0)
    RETURN r
ENDPROC
/**/
/*"cxAction(action:LONG,id:LONG)"*/
PROC cxCustom(action:LONG,id:LONG) 
    DEF r=NIL
    r:=CreateCxObj(CX_CUSTOM,action,id)
    RETURN r
ENDPROC
/**/

