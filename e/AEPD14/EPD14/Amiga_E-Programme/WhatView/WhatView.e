/*******************************************************************************************/
/* Source code generate by Gui2E v0.1 © 1994 NasGûl                                        */
/*******************************************************************************************/
/********************************************************************************
 * << EUTILS HEADER >>
 ********************************************************************************
 ED               "EDG"
 EC               "EC"
 PREPRO           "EPP -t"
 SOURCE           "WV.e"
 EPPDEST          "WV_EPP.e"
 EXEC             "WhatView"
 ISOURCE          "WVPrefs.i"
 HSOURCE          " "
 ERROREC          " "
 ERROREPP         " "
 VERSION          "0"
 REVISION         "12"
 NAMEPRG          "WhatView"
 NAMEAUTHOR       "NasGûl"
 ********************************************************************************
 * HISTORY :
 *******************************************************************************/

OPT OSVERSION=37

MODULE 'intuition/intuition','gadtools','libraries/gadtools',
       'intuition/gadgetclass','intuition/screens',
       'graphics/text','exec/lists','exec/nodes',
       'exec/ports','eropenlib','utility/tagitem',
       'wvprefs','whatis','reqtools','libraries/reqtools',
       'wb','utility','workbench/workbench','icon','rexxsyslib','workbench/startup',
       'dos/dos','wbmessage','dos/dostags','dos/dosextens','dos/notify','dos/datetime',
       'exec/libraries'

ENUM ER_NONE,ER_LOCKSCREEN,ER_VISUAL,ER_CONTEXT,ER_MENUS,ER_GADGET,ER_WINDOW,
     ER_NOICON,ER_BADARGS,ER_PORT,ER_APPWIN,ER_NOPREFS,ER_APPITEM,ER_PORTEXIST,
     ER_SIG

CONST WI_DEEP=$800000CB,WI_BUFFER=$800000CC,WI_BUFLEN=$800000CD
ENUM ACT_WHATVIEW,ACT_INFO,ACT_ADDICON,ACT_EXECUTE
CONST DEBUG=FALSE
DEF screen:PTR TO screen,visual=NIL,tattr:PTR TO textattr,reelquit=FALSE,offy
/****************************************
 * wv Definitions
 ****************************************/
DEF wv_window=NIL:PTR TO window
DEF wv_glist=NIL
/* Gadgets */
ENUM GA_G_WHATVIEW,GA_G_INFO,GA_G_ADDICON,GA_G_EXECUTE,GA_G_PREFS,GA_G_QUIT
/* Gadgets labels of wv */
DEF g_whatview,g_info,g_addicon,g_execute,g_prefs,g_quit
/*********************************/
/* Application def               */
/*********************************/
DEF myw=NIL:PTR TO wvbase
DEF wvdisk:PTR TO diskobject
DEF prgport=NIL:PTR TO mp
DEF dummyport=NIL:PTR TO mp
DEF publicport=NIL:PTR TO mp
DEF appicon=NIL,appitem=NIL,appwindow=NIL,baselock
DEF addicondir[256]:STRING,defprefsdir[256]:STRING,defaultdir[256]:STRING
DEF wb_handle
DEF nreqsig=-1
DEF prgsig=NIL
DEF nreq:PTR TO notifyrequest
DEF maxarg=10
DEF winx=10,winy=10
PMODULE 'WVDATA'
/*********************************/
/* Message proc                  */
/*********************************/
PROC p_LookAllMessage() HANDLE /*"p_LookAllMessage()"*/
    DEF sigreturn
    DEF wvport:PTR TO mp
    IF wv_window THEN wvport:=wv_window.userport ELSE wvport:=NIL
    dWriteF(['p_LookAllMessage()\n'],0)
    sigreturn:=Wait(Shl(1,wvport.sigbit) OR
                    Shl(1,prgport.sigbit) OR Shl(1,nreqsig) OR Shl(1,publicport.sigbit) OR $F000)
    IF (sigreturn AND Shl(1,wvport.sigbit))
        IF p_LookwvMessage()=TRUE THEN p_CloseWindow()
    ENDIF
    IF (sigreturn AND Shl(1,prgport.sigbit))
        p_LookAppMessage()
        IF wv_window=NIL THEN Raise(p_OpenWindow())
    ENDIF
    IF (sigreturn AND Shl(1,nreqsig))
        p_ReadPrefsFile('Env:Whatview.prefs')
    ENDIF
    IF (sigreturn AND Shl(1,publicport.sigbit))
        p_LookPublicMessage()
    ENDIF
    IF (sigreturn AND $F000)
        reelquit:=TRUE
    ENDIF
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_LookPublicMessage() /*"p_LookPublicMessage()"*/
    DEF mymsg:PTR TO wvmsg
    DEF stract[256]:STRING
    DEF doit=-1
    IF mymsg:=GetMsg(publicport)
        StringF(stract,'\s',mymsg.name)
        IF mymsg.lock=0
            IF StrCmp(stract,'WHATVIEW',8) THEN doit:=ACT_WHATVIEW
            IF StrCmp(stract,'INFO',4) THEN doit:=ACT_INFO
            IF StrCmp(stract,'ADDICON',7) THEN doit:=ACT_ADDICON
            IF StrCmp(stract,'EXECUTE',7) THEN doit:=ACT_EXECUTE
            IF StrCmp(stract,'QUIT',4) THEN reelquit:=TRUE
            IF StrCmp(stract,'FLUSH',5)
                p_FlushWhatis()
                JUMP allok
            ENDIF
            IF StrCmp(stract,'PREFS',5)
                p_CLIRun('WVprefs',defprefsdir,4000,0)
                JUMP allok
            ENDIF
        ENDIF
        IF doit<>-1
            IF p_EmptyList(myw.adremptylist)<>-1
                p_WriteFArgList(myw.adremptylist,doit)
            ELSE
                IF p_WVFileRequester()
                    p_WriteFArgList(myw.adremptylist,doit)
                ENDIF
            ENDIF
            p_RemoveArgList(myw.adremptylist,FALSE)
            p_CleanArgActionList(myw.adractionlist)
            JUMP allok
        ELSE
            p_AjouteArgNode(myw.adremptylist,mymsg.name,mymsg.lock)
        ENDIF
        allok:
        ReplyMsg(mymsg)
    ENDIF
ENDPROC
PROC p_LookAppMessage() HANDLE /*"p_LookAppMessage()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Parse Msg on App.
 *******************************************************************************/
    DEF appmsg:PTR TO appmessage
    DEF b
    DEF apparg:PTR TO wbarg
    IF appmsg:=GetMsg(prgport)
        apparg:=appmsg.arglist
        FOR b:=0 TO appmsg.numargs-1
            p_AjouteArgNode(myw.adremptylist,apparg[b].name,apparg[b].lock)
        ENDFOR
        ReplyMsg(appmsg)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_LookwvMessage() /*"p_LookwvMessage()"*/
   DEF mes:PTR TO intuimessage
   DEF g:PTR TO gadget
   DEF type=0,infos=NIL,ret=FALSE
   /*DEF pv[256]:STRING*/
   WHILE (mes:=Gt_GetIMsg(wv_window.userport))
   /*IF mes:=Gt_GetIMsg(wv_window.userport)*/
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
                  CASE GA_G_WHATVIEW
                      ret:=TRUE
                      IF p_EmptyList(myw.adremptylist)<>-1
                          p_WriteFArgList(myw.adremptylist,ACT_WHATVIEW)
                      ELSE
                          IF p_WVFileRequester()
                              p_WriteFArgList(myw.adremptylist,ACT_WHATVIEW)
                          ENDIF
                      ENDIF
                      p_RemoveArgList(myw.adremptylist,FALSE)
                      p_CleanArgActionList(myw.adractionlist)
                  CASE GA_G_INFO
                      ret:=TRUE
                      IF p_EmptyList(myw.adremptylist)<>-1
                          p_WriteFArgList(myw.adremptylist,ACT_INFO)
                      ELSE
                          IF p_WVFileRequester()
                              p_WriteFArgList(myw.adremptylist,ACT_INFO)
                          ENDIF
                      ENDIF
                      p_RemoveArgList(myw.adremptylist,FALSE)
                      p_CleanArgActionList(myw.adractionlist)
                  CASE GA_G_ADDICON
                      ret:=TRUE
                      IF p_EmptyList(myw.adremptylist)<>-1
                          p_WriteFArgList(myw.adremptylist,ACT_ADDICON)
                      ELSE
                          IF p_WVFileRequester()
                              p_WriteFArgList(myw.adremptylist,ACT_ADDICON)
                          ENDIF
                      ENDIF
                      p_RemoveArgList(myw.adremptylist,FALSE)
                      p_CleanArgActionList(myw.adractionlist)
                  CASE GA_G_EXECUTE
                      ret:=TRUE
                      IF p_EmptyList(myw.adremptylist)<>-1
                          p_WriteFArgList(myw.adremptylist,ACT_EXECUTE)
                      ELSE
                          IF p_WVFileRequester()
                              p_WriteFArgList(myw.adremptylist,ACT_EXECUTE)
                          ENDIF
                      ENDIF
                      p_RemoveArgList(myw.adremptylist,FALSE)
                      p_CleanArgActionList(myw.adractionlist)
                  CASE GA_G_PREFS
                      ret:=TRUE
                      p_CLIRun('WVprefs',defprefsdir,4000,0)
                  CASE GA_G_QUIT
                      ret:=TRUE
                      reelquit:=TRUE
              ENDSELECT
       ENDSELECT
       Gt_ReplyIMsg(mes)
   ENDWHILE
   /*ENDIF*/
   WHILE (mes:=Gt_GetIMsg(wv_window.userport)) DO Gt_ReplyIMsg(mes)
   RETURN ret
ENDPROC
/*********************************/
/* Application proc              */
/*********************************/
PROC p_InitWVAPP() HANDLE /*"p_InitWVAPP()"*/
    dWriteF(['p_InitWVAPP()\n'],0)
    IF (prgsig:=AllocSignal(-1))=NIL THEN Raise(ER_SIG)
    myw:=New(SIZEOF wvbase)
    myw.adremptylist:=p_InitList()
    myw.adractionlist:=p_InitList()
    IF (prgport:=CreateMsgPort())=NIL THEN Raise(ER_PORT)
    IF (dummyport:=CreateMsgPort())=NIL THEN Raise(ER_PORT)
    IF (publicport:=p_CreatePublicPort('WhatViewPort',0))=NIL THEN Raise(ER_PORT)
    p_InitPositionIcon(wvdisk)
    IF (appitem:=AddAppMenuItemA(0,0,'WhatView',prgport,[MTYPE_APPMENUITEM,TAG_DONE]))=NIL THEN Raise(ER_APPITEM)
    IF (appicon:=AddAppIconA(0,0,'WhatView',prgport,NIL,wvdisk,
                             [MTYPE_APPICON,MTYPE_ICONPUT,wvdisk,TAG_DONE,0]))=NIL THEN Raise(ER_NOICON)
    IF wvdisk THEN FreeDiskObject(wvdisk)
    p_InitLockConfigFile()
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_RemWVAPP() /*"p_RemWVAPP()"*/
    dWriteF(['p_RemWVAPP()\n'],0)
    p_RemLockConfigFile()
    IF appicon THEN RemoveAppIcon(appicon)
    IF appitem THEN RemoveAppMenuItem(appitem)
    IF publicport THEN p_DeletePublicPort(publicport)
    IF dummyport THEN DeleteMsgPort(dummyport)
    IF prgport THEN DeleteMsgPort(prgport)
    IF myw.adremptylist THEN p_RemoveArgList(myw.adremptylist,TRUE)
    IF myw.adractionlist THEN p_RemoveActionList(myw.adractionlist,TRUE)
    IF myw THEN Dispose(myw)
    IF prgsig THEN FreeSignal(prgsig)
ENDPROC
PROC p_CreatePublicPort(name,priority) /*"p_CreatePublicPort(name,priority)"*/
/********************************************************************************
 * Para         : name (STRING),pri.
 * Return       : address of the port if ok,else NIL
 * Description  : Create a Public Message Port.
 *******************************************************************************/
    DEF p_node:PTR TO ln
    DEF myport:PTR TO mp
    dWriteF(['p_CreatePublicPort()\n'],0)
    myport:=CreateMsgPort()
    IF myport=0 THEN RETURN NIL
    p_node:=myport.ln
    p_node.name:=name
    p_node.pri:=priority
    p_node.type:=NT_MSGPORT
    myport.flags:=PA_SIGNAL
    AddPort(myport)
    RETURN myport
ENDPROC
PROC p_DeletePublicPort(adr_port:PTR TO mp) /*"p_DeletePublicPort(adr_port)"*/
/********************************************************************************
 * Para         : Address of a public port.
 * Return       : NONE
 * Description  : Delete a public message port.
 *******************************************************************************/
    dWriteF(['p_DeletePublicPort()\n'],0)
    IF adr_port THEN RemPort(adr_port)
    IF adr_port THEN DeleteMsgPort(adr_port)
ENDPROC
PROC p_ReadPrefsFile(source) /*"p_ReadPrefsFile(source)"*/
    DEF len,a,adr,buf,handle,flen=TRUE,pos
    DEF chunk
    DEF pv[256]:STRING
    DEF node:PTR TO ln
    DEF addact:PTR TO actionnode
    DEF list:PTR TO lh,nn=NIL
    dWriteF(['p_ReadPrefsFile()\n'],0)
    IF (flen:=FileLength(source))=-1 THEN RETURN FALSE
    IF (buf:=New(flen+1))=NIL THEN RETURN FALSE
    IF (handle:=Open(source,1005))=NIL THEN RETURN FALSE
    len:=Read(handle,buf,flen)
    Close(handle)
    IF len<1 THEN RETURN FALSE
    adr:=buf
    chunk:=Long(adr)
    IF chunk<>ID_WVPR
        Dispose(buf)
        RETURN FALSE
    ENDIF
    p_RemoveActionList(myw.adractionlist,FALSE)
    FOR a:=0 TO len-1
        pos:=adr++
        chunk:=Long(pos)
        SELECT chunk
            CASE ID_WVAC
                pos:=pos+4
                node:=New(SIZEOF ln)
                addact:=New(SIZEOF actionnode)
                addact.exectype:=Int(pos)
                addact.stack:=Long(pos+2)
                addact.priority:=Int(pos+6)
                StringF(pv,'\s',pos+8)
                node.name:=String(EstrLen(pv))
                node.succ:=0
                StrCopy(node.name,pv,ALL)
                pos:=pos+8+EstrLen(pv)+1
                StringF(pv,'\s',pos)
                addact.command:=String(EstrLen(pv))
                StrCopy(addact.command,pv,ALL)
                pos:=pos+EstrLen(pv)+1
                StringF(pv,'\s',pos)
                addact.currentdir:=String(EstrLen(pv))
                StrCopy(addact.currentdir,pv,ALL)
                pos:=pos+EstrLen(pv)+1
                CopyMem(node,addact.node,SIZEOF ln)
                AddTail(myw.adractionlist,addact.node)
                nn:=p_GetNumNode(myw.adractionlist,addact.node)
                IF nn=0
                    list:=myw.adractionlist
                    list.head:=addact.node
                    node.pred:=0
                ENDIF
                addact.numarg:=0
                addact.cmd:=0
                IF node THEN Dispose(node)
        ENDSELECT
    ENDFOR
    Dispose(buf)
    RETURN TRUE
ENDPROC
PROC p_InitLockConfigFile() /*"p_InitLockConfigFile()"*/
    dWriteF(['p_InitLockConfig()\n'],0)
    nreq:=New(SIZEOF notifyrequest)
    nreq.name:='Env:WhatView.prefs'
    nreq.flags:=NRF_SEND_SIGNAL
    nreq.port:=FindTask(0)
    nreq.signalnum:=AllocSignal(nreqsig)
    nreqsig:=nreq.signalnum
    StartNotify(nreq)
ENDPROC
PROC p_RemLockConfigFile() /*"p_RemLockConfigFile()"*/
    dWriteF(['p_RemLockConfig()\n'],0)
    IF nreqsig THEN FreeSignal(nreqsig)
    EndNotify(nreq)
ENDPROC
PROC p_StartCli() HANDLE /*"p_StartCli()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : ER_NONE if ok,else the error.
 * Description  : Get .info and lock the currentdir.
 *******************************************************************************/
    DEF myargs:PTR TO LONG,rdargs=NIL
    DEF prgname[256]:STRING
    DEF pro:PTR TO process
    dWriteF(['p_StartCli()\n'],0)
    myargs:=[0]
    IF rdargs:=ReadArgs('ICON',myargs,NIL)
        IF myargs[0] THEN StrCopy(prgname,myargs[0],ALL) ELSE GetProgramName(prgname,256)
        IF (wvdisk:=GetDiskObject(prgname))=NIL THEN Raise(ER_NOICON)
        pro:=FindTask(0)
        baselock:=CurrentDir(pro.currentdir)
    ELSE
        Raise(ER_BADARGS)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    IF rdargs THEN FreeArgs(rdargs)
    RETURN exception
ENDPROC
PROC p_StartWb() HANDLE /*"p_StartWb()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : ER_NONE if ok,else the error.
 * Description  : Get .info and lock cureentdir.
 *******************************************************************************/
    DEF wb:PTR TO wbstartup
    DEF args:PTR TO wbarg
    DEF prgname[256]:STRING
    dWriteF(['p_StartWb()\n'],0)
    wb:=wbmessage
    args:=wb.arglist
    FindTask(0)
    StrCopy(prgname,args[0].name,ALL)
    baselock:=CurrentDir(args[0].lock)
    IF (wvdisk:=GetDiskObject(prgname))=NIL THEN Raise(ER_NOICON)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_InitPositionIcon(s_d_o:PTR TO diskobject) /*"p_InitPositionIcon(s_d_o)"*/
/********************************************************************************
 * Para         : address of a diskobject structure
 * Return       : NONE
 * Description  : Look for POSX/POSY and DEFDIR (for icons) tooltypes.
 *******************************************************************************/
    DEF defdir[256]:STRING
    DEF max
    dWriteF(['p_InitPositionIcon()\n'],0)
    s_d_o.currentx:=Val(FindToolType(s_d_o.tooltypes,'POSX'),NIL)
    s_d_o.currenty:=Val(FindToolType(s_d_o.tooltypes,'POSY'),NIL)
    IF defdir:=FindToolType(s_d_o.tooltypes,'DEFDIR')
        IF defdir THEN StrCopy(addicondir,defdir,ALL)
    ENDIF
    IF defdir:=FindToolType(s_d_o.tooltypes,'DEFPREFSDIR')
        IF defdir THEN StrCopy(defprefsdir,defdir,ALL)
    ENDIF
    IF max:=FindToolType(s_d_o.tooltypes,'MAXARG')
        IF max THEN maxarg:=Val(max,NIL)
        IF maxarg>20 THEN maxarg:=20
    ENDIF
ENDPROC
PROC p_WBRun(com,dir,st,pr,num_arg,arg_list:PTR TO LONG) HANDLE /*"p_WBRun(com,di,st,pr,num_arg,arg_list)"*/
    DEF execmsg:PTR TO mn
    DEF wbsm:wbstartmsg
    DEF rc=FALSE
    DEF node:PTR TO ln
    DEF oldcd
    wbsm:=New(SIZEOF wbstartmsg)
    execmsg:=wbsm
    node:=execmsg
    node.type:=NT_MESSAGE
    node.pri:=0
    execmsg.replyport:=dummyport
    wbsm.name:=com
    wbsm.dirlock:=Lock(dir,-2)
    wbsm.stack:=st
    wbsm.prio:=pr
    wbsm.numargs:=num_arg
    wbsm.arglist:=arg_list
    oldcd:=CurrentDir(wbsm.dirlock)
    Forbid()
    IF wb_handle
        PutMsg(wb_handle,wbsm)
    ENDIF
    Permit()
    IF wb_handle
        WaitPort(dummyport)
        GetMsg(dummyport)
        rc:=wbsm.stack
    ENDIF
    IF rc=0 THEN p_MakeWVRequest('WBRun Failed.','Ok',NIL)
    Raise(ER_NONE)
EXCEPT
    CurrentDir(oldcd)
    IF wbsm.dirlock THEN UnLock(wbsm.dirlock)
    IF wbsm THEN Dispose(wbsm)
    RETURN exception
ENDPROC
PROC p_CLIRun(cmd,dir,sta,pp) HANDLE /*"p_CLIRun(cmd,dir,sta,pp)"*/
    DEF ofh:PTR TO filehandle
    DEF ifh:PTR TO filehandle
    DEF newct=NIL:PTR TO mp
    DEF oldct:PTR TO mp
    DEF oldcd
    DEF newcd
    IF ofh:=Open('NIL:',1006)
        IF IsInteractive(ofh)
            newct:=ofh.type
            oldct:=SetConsoleTask(newct)
            ifh:=Open('CONSOLE:',1005)
            SetConsoleTask(oldct)
        ELSE
            ifh:=Open('NIL:',1005)
        ENDIF
    ENDIF
    newcd:=Lock(dir,-2)
    oldcd:=CurrentDir(newcd)
    IF SystemTagList(cmd,[SYS_OUTPUT,NIL,
                         SYS_INPUT,NIL,
                         SYS_ASYNCH,TRUE,
                         SYS_USERSHELL,TRUE,
                         NP_STACKSIZE,sta,
                         NP_PRIORITY,pp,
                         NP_PATH,NIL,
                         NP_CONSOLETASK,newct,
                         0])
    ENDIF
    CurrentDir(oldcd)
    IF newcd THEN UnLock(newcd)
    IF ofh THEN Close(ofh)
    IF ifh THEN Close(ifh)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_InitWBHandler() HANDLE /*"p_InitWBHandler()"*/
    DEF ifh
    DEF ofh
    DEF wbh
    dWriteF(['p_InitWBHandler()\n'],0)
    IF (ifh:=Open('NIL:',1006))=NIL THEN Raise(NIL)
    IF (ofh:=Open('NIL:',1005))=NIL THEN Raise(NIL)
    SystemTagList('L:WBStart-Handler',[SYS_INPUT,ifh,
                                      SYS_OUTPUT,ofh,
                                      SYS_ASYNCH,TRUE,
                                      SYS_USERSHELL,TRUE,
                                      NP_CONSOLETASK,NIL,
                                      NP_WINDOWPTR,NIL])
    Delay(25)
    wbh:=FindPort('WBStart-Handler Port')
    Raise(wbh)
EXCEPT
    IF Not(wbh)
        IF ifh THEN Close(ifh)
        IF ofh THEN Close(ofh)
    ENDIF
    RETURN wbh
ENDPROC
PROC p_MakeWVRequest(bodytext,gadgettext,the_arg) /*"p_MakeWVRequest(bodytext,gadgettext,the_arg)"*/
/********************************************************************************
 * Para         : text (STRING), gadget (STRING), arg PTR TO LONG
 * Return       : FALSE if cancel selected,else TRUE
 * Description  : PopUp a Requester.
 *******************************************************************************/
    DEF ret
    DEF taglist
    IF wv_window<>NIL
        taglist:=[RT_WINDOW,wv_window,RT_LOCKWINDOW,TRUE,RTEZ_REQTITLE,'WhatView v0.15 © NasGûl',RT_UNDERSCORE,"_",0]
    ELSE
        taglist:=[RTEZ_REQTITLE,'WhatView v0.15 © NasGûl',RT_UNDERSCORE,"_",0]
    ENDIF
    ret:=RtEZRequestA(bodytext,gadgettext,0,the_arg,taglist)
    RETURN ret
ENDPROC
PROC p_MakeWVStringReq(t_reelname,t_idstr,t_size) /*"p_MakeWVStringReq(t_reelname,t_idstr,t_size)"*/
/********************************************************************************
 * Para         : reelname (STRING),id string (STRING) ,size (LONG)
 * Return       : The result string of the request or NIL if cancel selected.
 * Description  : PopUp a StringRequester to choose a command for a file.
 *******************************************************************************/
    DEF my_sreq:PTR TO rtfilerequester
    DEF bodyreq[256]:STRING
    DEF buffer[256]:STRING
    DEF return_string[256]:STRING
    DEF ret,taglist
    StringF(bodyreq,'Execution d\aune commande pour:\nFichier :\s\nType    :\s\nSize    :\d',t_reelname,t_idstr,t_size)
    StrCopy(buffer,'',ALL)
    IF wv_window<>NIL
        taglist:=[RT_WINDOW,wv_window,RT_LOCKWINDOW,TRUE,RTEZ_REQTITLE,'WhatView v0.15 © NasGûl',RTGS_GADFMT,'_Execute|_Cancel',RTGS_TEXTFMT,bodyreq,RT_UNDERSCORE,"_",0]
    ELSE
        taglist:=[RTEZ_REQTITLE,'WhatView v0.15 © NasGûl',RTGS_GADFMT,'_Execute|_Cancel',RTGS_TEXTFMT,bodyreq,RT_UNDERSCORE,"_",0]
    ENDIF
    IF my_sreq:=RtAllocRequestA(RT_REQINFO,NIL)
        ret:=RtGetStringA(buffer,200,'WhatView v0.12',my_sreq,taglist)
        IF ret
            NOP
        ELSE
            buffer:=NIL
        ENDIF
        StringF(return_string,'\s',buffer)
        IF my_sreq THEN RtFreeRequest(my_sreq)
    ELSE
        RETURN NIL
    ENDIF
    RETURN return_string
ENDPROC
PROC p_WVFileRequester() /*"p_WVFileRequester()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : FALSE if Cancel selected.
 * Description  : PopUp a MultiFileRequester,Build the Wv_Arglist.
 *******************************************************************************/
    DEF reqfile:PTR TO rtfilerequester
    DEF liste:PTR TO rtfilelist
    DEF buffer[120]:STRING
    DEF add_liste
    DEF ret=TRUE
    DEF the_reelname[256]:STRING
    DEF lock
    IF reqfile:=RtAllocRequestA(RT_FILEREQ,NIL)
        buffer[0]:=0
        RtChangeReqAttrA(reqfile,[RTFI_DIR,defaultdir])
        add_liste:=RtFileRequestA(reqfile,buffer,'Whatview v0.15 © NasGûl',
                                  [RTFI_FLAGS,FREQF_MULTISELECT,RTFI_OKTEXT,'_Whatview',RTFI_HEIGHT,200,
                                   RT_UNDERSCORE,"_",TAG_DONE,0])
        StrCopy(defaultdir,reqfile.dir,ALL)
        IF reqfile THEN RtFreeRequest(reqfile)
    ELSE
        ret:=FALSE
    ENDIF
    liste:=add_liste
    IF buffer[0]<>0
        WHILE liste
            StringF(the_reelname,'\s',liste.name)
            IF lock:=Lock(defaultdir,-2)
                p_AjouteArgNode(myw.adremptylist,the_reelname,lock)
                UnLock(lock)
            ENDIF
            liste:=liste.next
        ENDWHILE
        IF add_liste THEN RtFreeFileList(add_liste)
    ELSE
        ret:=FALSE
    ENDIF
    RETURN ret
ENDPROC
PROC p_AddIcon(t_fullname,t_reelname,t_size,t_idstr) /*"p_AddIcon(t_fullname,t_reelname,t_lock,t_size,t_idstr)"*/
/********************************************************************************
 * Para         : fullname,reelname,id string,size.
 * Return       : NONE
 * Description  : Add a def icon to files or dirs.
 *******************************************************************************/
    DEF id_type
    DEF id_icon[80]:STRING
    DEF piv_str[256]:STRING
    DEF fichier_source[256]:STRING
    DEF fichier_destin[256]:STRING
    DEF csdo:PTR TO diskobject
    StrCopy(piv_str,addicondir,ALL)
    id_type:=WhatIs(t_fullname,[WI_DEEP,1])
    id_icon:=GetIconName(id_type)
    AddPart(piv_str,id_icon,256)
    StringF(fichier_source,'\s',piv_str)
    IF id_icon<>NIL
        StringF(fichier_destin,'\s',t_fullname)
        csdo:=GetDiskObject(fichier_source)
        IF csdo
            PutDiskObject(fichier_destin,csdo)
            IF csdo THEN FreeDiskObject(csdo)
        ELSE
            p_MakeWVRequest('Pas d\aicone par défaut pour:\nFichier :\s\nType    :\s\nSize    :\d','_Merci',[t_reelname,t_idstr,t_size])
        ENDIF
    ELSE
        p_MakeWVRequest('Pas d\aicone par défaut pour:\nFichier :\s\nType    :\s\nSize    :\d','_Merci',[t_reelname,t_idstr,t_size])
    ENDIF
ENDPROC
PROC p_FlushWhatis() /*"p_FlushWhatis()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Close/Open/Flush.
 *******************************************************************************/
    DEF library:PTR TO lib
    IF whatisbase
        library:=whatisbase
        CloseLibrary(whatisbase)
        IF library.opencnt>0
            p_MakeWVRequest('Flush impossible \d programme(s)\nutilise(nt) la WhatIs.library','_Merci',[library.opencnt])
        ELSE
            p_MakeWVRequest('Flush de la WhatIs.library ok.','_Merci',NIL)
        ENDIF
        whatisbase:=OpenLibrary('whatis.library',3)
    ENDIF
    AskReparse($01)
ENDPROC
/*********************************/
/* Main proc                     */
/*********************************/
PROC main() HANDLE /*"main()"*/
    DEF testmain
    tattr:=['topaz.font',8,0,0]:textattr
    VOID '$VER:WhatView v0.15 © NasGûl (15/04/94)'
    IF (testmain:=p_OpenLibraries())<>ER_NONE THEN Raise(testmain)
    IF wbmessage<>NIL
        IF (testmain:=p_StartWb())<>ER_NONE THEN Raise(testmain)
    ELSE
        IF (testmain:=p_StartCli())<>ER_NONE THEN Raise(testmain)
    ENDIF
    Forbid()
    testmain:=FindPort('WhatViewPort') 
    Permit()
    IF testmain THEN Raise(ER_PORTEXIST)
    Forbid()
    wb_handle:=FindPort('WBStart-Handler Port')
    Permit()
    IF wb_handle=0 THEN wb_handle:=p_InitWBHandler()
    IF (testmain:=p_InitWVAPP())<>ER_NONE THEN Raise(testmain)
    IF p_ReadPrefsFile('Env:WhatView.prefs')=FALSE THEN Raise(ER_NOPREFS)
    REPEAT
        IF (testmain:=p_LookAllMessage())<>ER_NONE THEN Raise(testmain)
    UNTIL reelquit=TRUE
    Raise(ER_NONE)
EXCEPT
    IF myw THEN p_RemWVAPP()
    CurrentDir(baselock)
    p_CloseLibraries()
    SELECT exception
        CASE ER_LOCKSCREEN; WriteF('Lock Screen Failed.\n')
        CASE ER_VISUAL;     WriteF('Error Visual.\n')
        CASE ER_CONTEXT;    WriteF('Error Context.\n')
        CASE ER_MENUS;      WriteF('Error Menus.\n')
        CASE ER_GADGET;     WriteF('Error Gadget.\n')
        CASE ER_WINDOW;     WriteF('Error Window.\n')
        CASE ER_NOICON;     WriteF('no icon.\n')
        CASE ER_BADARGS;    WriteF('Bad Args.\n')
        CASE ER_NOPREFS;    WriteF('env:whatview.prefs ?\n')
        CASE ER_APPWIN;     WriteF('Error AppWinidow.\n')
        CASE ER_APPITEM;    WriteF('Error AppItem.\n')
        CASE ER_PORT;       WriteF('Error Public port.\n')
        CASE ER_PORTEXIST;  WriteF('WhatViewPort exist.\n')
        CASE ER_SIG;        WriteF('Error Alloc signal.\n')
    ENDSELECT
ENDPROC
