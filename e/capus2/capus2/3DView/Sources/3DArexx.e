DEF arexxport:PTR TO mp
DEF arexxportname[80]:STRING
/*"p_CreateArexxPort(nom,pri)"*/
PROC p_CreateArexxPort(nom,pri) HANDLE
/*===============================================================================
 = Para         : name (STRING),pri (NUM).
 = Return       : the address of the port if ok,else NIL.
 = Description  : Create a public port.
 ==============================================================================*/
    DEF dat_port:PTR TO ln
    IF FindPort(nom)<>0 THEN Raise(ER_PORTEXIST)
    arexxport:=CreateMsgPort()
    IF arexxport=0
        Raise(ER_CREATEPORT)
    ENDIF
    dat_port:=arexxport.ln
    dat_port.name:=nom
    dat_port.pri:=pri
    dat_port.type:=NT_MSGPORT
    arexxport.flags:=PA_SIGNAL
    IF nom<>NIL
        AddPort(arexxport)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_DeleteArexxPort(adr_port:PTR TO mp)"*/
PROC p_DeleteArexxPort(adr_port:PTR TO mp)
/*===============================================================================
 = Para         : Address of port.
 = Return       : NONE
 = Description  : Remove a public port.
 ==============================================================================*/
    DEF data_port:PTR TO ln
    data_port:=adr_port.ln
    IF data_port.name<>NIL THEN RemPort(adr_port)
    IF adr_port THEN DeleteMsgPort(adr_port)
ENDPROC
/**/
/*"p_LookArexxMessage()"*/
PROC p_LookArexxMessage()
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Process arexx Messge.
 ==============================================================================*/
    DEF mess_rexx:PTR TO rexxmsg
    DEF commande:PTR TO LONG
    DEF retstr[256]:STRING
    DEF pv[256]:STRING
    DEF varpv
    DEF pvobj:PTR TO object3d
    DEF pvn:PTR TO ln
    dWriteF(['p_LookArexxMessge()\n'],0)
    WHILE mess_rexx:=GetMsg(arexxport)
        commande:=mess_rexx.args
        /*=== Commande LISTOBJ : retourne les noms des objets <nom1> <nom2> ===*/
        IF StrCmp(commande[0],'LISTOBJ',7)
            mess_rexx.result1:=0
            retstr:=p_MakeArexxListObject(mybase.objlist)
            mess_rexx.result2:=String(EstrLen(retstr))
            StrCopy(mess_rexx.result2,retstr,EstrLen(retstr))
        /*=== Commande NBRSOBJ : retourne le nombres d'objets de la base ===*/
        ELSEIF StrCmp(commande[0],'NBRSOBJ',7)
            StringF(retstr,'\d',mybase.nbrsobjs)
            mess_rexx.result1:=0
            mess_rexx.result2:=String(EstrLen(retstr))
            StrCopy(mess_rexx.result2,retstr,EstrLen(retstr))
        /*=== Commande NBRSTOTALPTS: retourne le nombres totals de points. ===*/
        ELSEIF StrCmp(commande[0],'NBRSTOTALPTS',12)
            StringF(retstr,'\d',mybase.totalpts)
            mess_rexx.result1:=0
            mess_rexx.result2:=String(EstrLen(retstr))
            StrCopy(mess_rexx.result2,retstr,EstrLen(retstr))
        /*=== Commande NBRSTOTALFCS: retourne le nombres totals de faces. ===*/
        ELSEIF StrCmp(commande[0],'NBRSTOTALFCS',12)
            StringF(retstr,'\d',mybase.totalfcs)
            mess_rexx.result1:=0
            mess_rexx.result2:=String(EstrLen(retstr))
            StrCopy(mess_rexx.result2,retstr,EstrLen(retstr))
        /*=== Commande GETNUMINFOOBJ: retourne les informations sur l'objet ===*/
        /*=== NAME NRSPTS NBRSFCS ADRDATAPTS ADRDATAFCS TYPE                ===*/
        ELSEIF StrCmp(commande[0],'GETNUMINFOOBJ',13)
            MidStr(pv,commande[0],14,ALL)
            pv:=TrimStr(pv)
            varpv:=Val(pv,NIL)
            IF pvn:=p_GetAdrNode(mybase.objlist,varpv)
                pvobj:=pvn
                StringF(retstr,'\s \d \d \d \d \s',pvn.name,pvobj.nbrspts,pvobj.nbrsfcs,pvobj.datapts,pvobj.datafcs,data_objtype[pvobj.typeobj])
                mess_rexx.result1:=0
                mess_rexx.result2:=String(EstrLen(retstr))
                StrCopy(mess_rexx.result2,retstr,EstrLen(retstr))
            ELSE
                mess_rexx.result1:=20
                mess_rexx.result2:=String(EstrLen(''))
                StrCopy(mess_rexx.result2,retstr,EstrLen(''))
            ENDIF
        /*=== Commande GETNAMEINFOOBJ : retourne les informations sur l'objet. ===*/
        ELSEIF StrCmp(commande[0],'GETNAMEINFOOBJ',14)
            MidStr(pv,commande[0],15,ALL)
            pv:=TrimStr(pv)
            IF pvobj:=FindName(mybase.objlist,pv)
                pvn:=pvobj
                StringF(retstr,'\s \d \d \d \d \s',pvn.name,pvobj.nbrspts,pvobj.nbrsfcs,pvobj.datapts,pvobj.datafcs,data_objtype[pvobj.typeobj])
                mess_rexx.result1:=0
                mess_rexx.result2:=String(EstrLen(retstr))
                StrCopy(mess_rexx.result2,retstr,EstrLen(retstr))
            ELSE
                mess_rexx.result1:=20
                mess_rexx.result2:=String(EstrLen(''))
                StrCopy(mess_rexx.result2,retstr,EstrLen(''))
            ENDIF
        ELSE
            mess_rexx.result1:=20
            mess_rexx.result2:=String(EstrLen(''))
            StrCopy(mess_rexx.result2,retstr,EstrLen(''))
        ENDIF
        dWriteF(['Commande :\s\n'],[commande[0]])
        IF mess_rexx THEN ReplyMsg(mess_rexx)
        IF mess_rexx.result2 THEN DisposeLink(mess_rexx.result2)
    ENDWHILE
    WHILE mess_rexx:=GetMsg(arexxport) DO ReplyMsg(arexxport)
ENDPROC
/**/
/*"p_MakeArexxListObject(list:PTR TO lh)"*/
PROC p_MakeArexxListObject(list:PTR TO lh)
    DEF n:PTR TO ln
    DEF str[256]:STRING
    DEF rstr[256]:STRING
    StrCopy(str,'',ALL)
    n:=list.head
    WHILE n
        IF n.succ<>0
            StrAdd(str,n.name,ALL)
            StrAdd(str,' ',1)
        ENDIF
        n:=n.succ
    ENDWHILE
    RETURN str
ENDPROC
/**/
/*"p_WriteFObject(num)"*/
PROC p_WriteFObject(num) 
    DEF ob:PTR TO object3d
    DEF dpts,dfcs,b
    DEF node:PTR TO ln
    ob:=p_GetAdrNode(mybase.objlist,num)
    dpts:=ob.datapts
    dfcs:=ob.datafcs
    node:=ob.node
    WriteF('Object Name:\s \d \d\n',node.name,ob.datapts,ob.datafcs)
    /*
    FOR b:=0 TO ob.nbrspts-1
        WriteF('x:\d y:\d z:\d\n',Long(dpts),Long(dpts+4),Long(dpts+8))
        dpts:=dpts+12
    ENDFOR
    FOR b:=0 TO ob.nbrsfcs-1
        WriteF('v1:\d v2:\d v3:\d\n',Long(dfcs),Long(dfcs+4),Long(dfcs+8))
        dfcs:=dfcs+12
    ENDFOR
    */
ENDPROC
/**/

