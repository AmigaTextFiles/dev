/*=========================================================================================*/
/* Source code generate by Gui2E v0.1 © 1994 NasGûl                                        */
/*=========================================================================================*/
/*======<<< Peps Header >>>======
 PRGVERSION '0'
 ================================
 PRGREVISION '4'
 ================================
 AUTHOR      'NasGûl'
 ===============================*/
/*======<<<   History   >>>======
 ===============================*/
OPT OSVERSION=37


MODULE 'intuition/intuition','gadtools','libraries/gadtools','intuition/gadgetclass','intuition/screens',
       'graphics/text','exec/lists','exec/nodes','exec/ports','eropenlib','utility/tagitem'
MODULE 'reqtools','libraries/reqtools'
MODULE 'dos/dostags','wbmessage','dos/dosextens'
MODULE 'wb','workbench/workbench','workbench/startup'
MODULE 'dos/notify'
MODULE 'commodities'
MODULE 'libraries/commodities'
MODULE 'intuition/intuitionbase'
MODULE 'icon','mheader','utility'
MODULE 'dos/dos'
MODULE 'dos/rdargs'


CONST EVT_HOTKEY=1

CONST DEBUG=FALSE

CONST FMODE_WB=1,
      FMODE_CLI=2


ENUM ER_NONE,ER_LOCKSCREEN,ER_VISUAL,ER_CONTEXT,ER_MENUS,ER_GADGET,ER_WINDOW,ER_MEM,
     ER_CX,ER_PORT,ER_NOPREFS,ER_BADARGS,ER_NOICONS,ER_APPWIN
/*"Window Defs"*/
DEF screen:PTR TO screen,
    visual=NIL,
    tattr:PTR TO textattr,
    reelquit=FALSE,
    offy,offx
/*=======================================
 = cr Definitions
 =======================================*/
DEF cr_window=NIL:PTR TO window
DEF cr_glist=NIL
/*==================*/
/*     Gadgets      */
/*==================*/
CONST GA_GLIST=0
CONST GA_GEDIT=1
CONST GA_G4=2
CONST GA_G_WB=3
CONST GA_G_CLI=4
CONST GA_G_INFO=5
/*=============================
 = Gadgets labels of cr
 =============================*/
DEF glist
DEF gedit
DEF g4
DEF g_wb
DEF g_cli
DEF g_info
/**/
/*"App Defs"*/

OBJECT apparg
    numargs:LONG
    arglist:LONG
ENDOBJECT

OBJECT xarg
  node:ln
  predlist:LONG   /* 14 */
  curdir:LONG     /* 18 */
  mode:LONG       /* 22 */
  args:LONG       /* 26 */
  stack:LONG
  pri:LONG
  noclosew:LONG
ENDOBJECT

OBJECT xblock
  node:ln
  predlist:LONG
  numlist:LONG
  list:LONG
ENDOBJECT

OBJECT xdatabase
  listxblock:LONG         /* exec list */
  nreq:LONG               /* PTR TO notifyrequest */
  nreqsigflag:LONG        /* For Wait() */
  prgport:LONG            /* PTR TO mp */
  appwindow:LONG          /**/
  prgsigflag:LONG         /* For Wait() */
  broker:LONG             /**/
  cxport:LONG             /* PTR TO mp */
  cxsigflag:LONG          /* For Wait() */
  cxhotkey:LONG           /* STRING */
  cxpri:LONG
  wbhandle:LONG
  allscreen:LONG
  defdir:LONG
  zoomed:LONG
  editcmd:LONG
ENDOBJECT

DEF mb:PTR TO xdatabase
DEF baselock
DEF currentnode=-1,currentlist:PTR TO lh
DEF popup=FALSE
DEF autocmd[256]:STRING
/**/
PMODULE 'PModules:PlistNoSort'
PMODULE 'PModules:dWriteF'
PMODULE 'PModules:PMHeader'
PMODULE 'PModules:pListView'
PMODULE 'ClickCxWindows'
/*"Message Proc"*/
/*"p_LookAllMessage()"*/
PROC p_LookAllMessage() 
    DEF sigreturn=NIL
    DEF crport:PTR TO mp
    IF cr_window THEN crport:=cr_window.userport ELSE crport:=NIL
    sigreturn:=Wait(Shl(1,crport.sigbit) OR
                        mb.nreqsigflag OR
                    mb.prgsigflag OR
                    mb.cxsigflag OR
                    $F000)
    IF (sigreturn AND Shl(1,crport.sigbit))
        IF (p_LookcrMessage())=TRUE THEN p_CloseWindow()
    ENDIF
    IF (sigreturn AND mb.nreqsigflag)
        IF cr_window<>NIL THEN p_LockListView(glist,cr_window)
        p_CleanPrgList(mb.listxblock)
        p_ReadFile('Env:ClickCx.Prefs')
        currentlist:=mb.listxblock
        currentnode:=0
        IF cr_window<>NIL THEN p_UnLockListView(glist,cr_window,mb.listxblock)
        IF cr_window<>NIL THEN p_RendercrWindow()
    ENDIF
    IF (sigreturn AND mb.prgsigflag)
        IF (p_LookAppMessage())=TRUE THEN p_CloseWindow()
    ENDIF
    IF (sigreturn AND mb.cxsigflag)
        p_LookCxMessage()
    ENDIF
    IF (sigreturn AND $F000)
        reelquit:=TRUE
    ENDIF
ENDPROC
/**/
/*"p_LookAppMessage()"*/
PROC p_LookAppMessage() 
    DEF appmsg:PTR TO appmessage
    DEF n:PTR TO ln
    DEF na=NIL:PTR TO xarg
    DEF ret=TRUE
    dWriteF(['p_LookAppMessage()\n'],0)
    p_LockListView(glist,cr_window)
    WHILE appmsg:=GetMsg(mb.prgport)
        n:=p_GetAdrNode(currentlist,currentnode)
        IF n<>-1
            IF StrCmp(n.name,'»» ',3)
                NOP
                ret:=FALSE
            ELSE
                p_StartProgram(currentlist,currentnode,0,appmsg)
                na:=n
            ENDIF
        ENDIF
        ReplyMsg(appmsg)
    ENDWHILE
    p_UnLockListView(glist,cr_window,currentlist)
    IF na<>NIL
        IF na.noclosew THEN ret:=FALSE
    ENDIF
    RETURN ret
ENDPROC
/**/
/*"p_LookCxMessage()"*/
PROC p_LookCxMessage() 
    DEF msgid=NIL,msgtype=NIL
    DEF returnvalue=TRUE,msg
    dWriteF(['p_LookCxMessage()\n'],0)
    WHILE msg:=GetMsg(mb.cxport)
        msgid:=CxMsgID(msg)
        msgtype:=CxMsgType(msg) 
        SELECT msgtype 
            CASE CXM_IEVENT 
                SELECT msgid 
                    CASE EVT_HOTKEY 
                        IF cr_window=NIL 
                            p_OpenWindow() 
                        ELSE
                            p_CloseWindow() 
                        ENDIF 
                ENDSELECT 
            CASE CXM_COMMAND 
                SELECT msgid
                    CASE CXCMD_KILL 
                        reelquit:=TRUE 
                        returnvalue:=FALSE 
                    CASE  CXCMD_DISABLE 
                        ActivateCxObj(mb.broker,0)
                    CASE CXCMD_ENABLE
                        ActivateCxObj(mb.broker,1)
                    CASE CXCMD_APPEAR 
                        IF cr_window=NIL
                            p_OpenWindow() 
                        ELSE 
                            WindowToFront(cr_window) 
                        ENDIF 
                    CASE CXCMD_DISAPPEAR 
                        IF cr_window<>NIL 
                            p_CloseWindow() 
                        ENDIF 
                ENDSELECT
        ENDSELECT
        ReplyMsg(msg)
    ENDWHILE
ENDPROC
/**/
/*"p_LookcrMessage()"*/
PROC p_LookcrMessage() 
   DEF mes:PTR TO intuimessage
   DEF g:PTR TO gadget
   DEF pvn,cnn
   DEF type=0,infos=NIL,ret=FALSE,pivz
   DEF curnode:PTR TO ln,ca:PTR TO xarg
   DEF curx:PTR TO xblock
   dWriteF(['p_LookcrMessage()\n'],0)
   WHILE mes:=Gt_GetIMsg(cr_window.userport)
       type:=mes.class
       SELECT type
            CASE IDCMP_CLOSEWINDOW; ret:=TRUE
            CASE IDCMP_MOUSEBUTTONS
                IF Mouse()=2
                    curnode:=p_GetAdrNode(currentlist,currentnode)
                    curx:=curnode
                    currentlist:=curx.predlist
                    currentnode:=0
                    p_RendercrWindow()
                ENDIF
            CASE IDCMP_GADGETDOWN
                type:=IDCMP_GADGETUP
            CASE IDCMP_REFRESHWINDOW
                IF mb.zoomed=FALSE THEN pivz:=TRUE ELSE pivz:=FALSE
                mb.zoomed:=pivz
                p_RendercrWindow()
            CASE IDCMP_GADGETUP
                g:=mes.iaddress
                infos:=g.gadgetid
                SELECT infos
                    CASE GA_GLIST
                        currentnode:=mes.code
                        donewlist:
                        IF p_EmptyList(currentlist)<>-1
                            curnode:=p_GetAdrNode(currentlist,currentnode)
                            IF StrCmp(curnode.name,'»» ',3)
                                curx:=curnode
                                currentlist:=curx.list
                                currentnode:=0
                                p_RendercrWindow()
                            ENDIF
                        ENDIF
                    CASE GA_GEDIT
                        doedit:
                        p_CLIRun(mb.editcmd,'ENV:',4000,0)
                    CASE GA_G4
                        reelquit:=TRUE
                    CASE GA_G_WB
                        dowbrun:
                        curnode:=p_GetAdrNode(currentlist,currentnode)
                        curx:=curnode
                        IF StrCmp(curnode.name,'»» ',3) 
                            NOP
                        ELSE
                            p_StartProgram(currentlist,currentnode,FMODE_WB,0)
                            ca:=curnode
                            IF ca.noclosew THEN ret:=FALSE ELSE ret:=TRUE
                        ENDIF
                    CASE GA_G_CLI
                        doclirun:
                        curnode:=p_GetAdrNode(currentlist,currentnode)
                        curx:=curnode
                        IF StrCmp(curnode.name,'»» ',3) 
                            NOP
                        ELSE
                            p_StartProgram(currentlist,currentnode,FMODE_CLI,0)
                            ca:=curnode
                            IF ca.noclosew THEN ret:=FALSE ELSE ret:=TRUE
                        ENDIF
                    CASE GA_G_INFO
                ENDSELECT
            CASE IDCMP_RAWKEY
                infos:=mes.code
                SELECT infos
                    CASE 18 /* Edit */
                        JUMP doedit
                    CASE 69 /* Esc */
                        curnode:=p_GetAdrNode(currentlist,currentnode)
                        curx:=curnode
                        currentlist:=curx.predlist
                        currentnode:=0
                        p_RendercrWindow()
                    CASE 49 /* W */
                        curnode:=p_GetAdrNode(currentlist,currentnode)
                        curx:=curnode
                        IF StrCmp(curnode.name,'»» ',3) 
                            NOP
                        ELSE
                            JUMP dowbrun
                        ENDIF
                    CASE 51 /* C */
                        curnode:=p_GetAdrNode(currentlist,currentnode)
                        curx:=curnode
                        IF StrCmp(curnode.name,'»» ',3) 
                            NOP
                        ELSE
                            JUMP doclirun
                        ENDIF
                    CASE 32; reelquit:=TRUE
                    CASE 68 /* RETURN */
                        curnode:=p_GetAdrNode(currentlist,currentnode)
                        curx:=curnode
                        IF StrCmp(curnode.name,'»» ',3) 
                            JUMP donewlist
                        ELSE
                            p_StartProgram(currentlist,currentnode,0,0)
                            ca:=curnode
                            IF ca.noclosew THEN ret:=FALSE ELSE ret:=TRUE
                        ENDIF
                    CASE 76 /* UP */
                        pvn:=currentnode-1
                        IF pvn=-1 THEN currentnode:=0 ELSE currentnode:=pvn
                        p_RendercrWindow()
                    CASE 77 /* DOWN */
                        pvn:=currentnode+1
                        cnn:=p_CountNodes(currentlist)
                        cnn:=cnn-1
                        IF pvn>=cnn THEN currentnode:=cnn ELSE currentnode:=pvn
                        p_RendercrWindow()
                ENDSELECT
        ENDSELECT
        Gt_ReplyIMsg(mes)
    ENDWHILE
    /*WHILE mes:=Gt_GetIMsg(cr_window.userport) DO Gt_ReplyIMsg(mes)*/
    RETURN ret
ENDPROC
/**/
/*"p_WriteFWBMessage(numa,lisa:PTR TO LONG)"*/
PROC p_WriteFWBMessage(numa,lisa:PTR TO LONG) 
   DEF b
   DEF fullname[256]:STRING
   DEF tw:PTR TO wbarg,ml=NIL
   WriteF('NumArgs:\d\n',numa)
   FOR b:=0 TO numa-1
      tw:=lisa[b*2]
      ml:=DupLock(lisa[b*2])
      NameFromLock(ml,fullname,256)
      WriteF('Name :\s Lock:\h FullName:\s\n',lisa[(b*2)+1],ml,fullname)
      IF ml THEN UnLock(ml)
   ENDFOR
ENDPROC
/**/
/**/
/*"APP Proc"*/
/*"p_InitWBHandler()"*/
PROC p_InitWBHandler() HANDLE 
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
/**/
/*"p_StartProgram(list:PTR TO lh,numnode,numa,lisa:PTR TO LONG)"*/
PROC p_StartProgram(list:PTR TO lh,numnode,forcemode,apm:PTR TO appmessage)
    DEF rnode:PTR TO xarg,n:PTR TO ln
    DEF str[256]:STRING,pv[256]:STRING
    DEF cs[256]:STRING,r,cmd[512]:STRING,cps[50]:STRING
    DEF preds[256]:STRING,succs[256]:STRING,pos
    DEF mwbarg:PTR TO wbarg
    dWriteF(['p_StartProgram()\n'],0)
    rnode:=p_GetAdrNode(list,numnode)
    n:=rnode
    IF forcemode=0 THEN StrCopy(cps,rnode.mode,ALL)
    IF forcemode=FMODE_WB THEN StrCopy(cps,'WB',2)
    IF forcemode=FMODE_CLI THEN StrCopy(cps,'CLI',3)
    IF StrCmp(cps,'WB',2)
        p_WBRun(n.name,rnode.curdir,rnode.stack,rnode.pri,apm)
    ELSEIF StrCmp(cps,'CLI',3)
        StringF(str,'\s',rnode.curdir)
        AddPart(str,'',512)
        StringF(cmd,'\s\s ',str,n.name)
        IF EstrLen(rnode.args)<>0
            pos:=InStr(rnode.args,'[]',0)
            IF pos<>-1
                IF pos<>0
                    MidStr(preds,rnode.args,0,pos-2)
                ELSE
                    StrCopy(preds,'',1)
                ENDIF
                MidStr(succs,rnode.args,pos+3,ALL)
                StrAdd(cmd,preds,ALL)
            ENDIF
        ENDIF
        IF apm<>0
            mwbarg:=apm.arglist
            FOR r:=0 TO apm.numargs-1
                NameFromLock(mwbarg[r].lock,pv,256)
                AddPart(pv,'',256)
                StringF(cs,' "\s\s" ',pv,mwbarg[r].name)
                StrAdd(cmd,cs,ALL)
            ENDFOR
            IF EstrLen(rnode.args)<>0 THEN StrAdd(cmd,succs,ALL)
            p_CLIRun(cmd,rnode.curdir,rnode.stack,rnode.pri)
        ELSE
            IF EstrLen(rnode.args)<>0 THEN StrAdd(cmd,succs,ALL)
            p_CLIRun(cmd,rnode.curdir,rnode.stack,rnode.pri)
        ENDIF
    ENDIF
    RETURN r
ENDPROC
/**/
/*"p_WBRun(com,di,st,pr,num_arg,arg_list)"*/
PROC p_WBRun(com,dir,st,pr,apmh:PTR TO appmessage) HANDLE
    DEF execmsg:PTR TO mn
    DEF wbsm:wbstartmsg
    DEF rc=FALSE
    DEF node:PTR TO ln
    dWriteF(['wb_WBRun()\n'],0)
    /*=== Init Handler ===*/
    Forbid()
    mb.wbhandle:=FindPort('WBStart-Handler Port')
    Permit()
    IF mb.wbhandle=0 THEN mb.wbhandle:=p_InitWBHandler()
    wbsm:=New(SIZEOF wbstartmsg)
    execmsg:=wbsm
    node:=execmsg
    node.type:=NT_MESSAGE
    node.pri:=0
    execmsg.replyport:=mb.prgport
    wbsm.name:=com
    wbsm.dirlock:=Lock(dir,-2)
    wbsm.stack:=st
    wbsm.prio:=pr
    wbsm.numargs:=IF apmh<>0 THEN apmh.numargs ELSE 0
    wbsm.arglist:=IF apmh<>0 THEN apmh.arglist ELSE 0
    Forbid()
    IF mb.wbhandle
        PutMsg(mb.wbhandle,wbsm)
    ENDIF
    Permit()
    IF mb.wbhandle
        WaitPort(mb.prgport)
        GetMsg(mb.prgport)
        rc:=wbsm.stack
    ENDIF
    IF rc=0 
        p_Alert('WBRun Failed.')
        p_CLIRun(com,dir,st,pr)
        p_Alert('CLIRun.')
    ENDIF
    Raise(ER_NONE)
EXCEPT
    IF wbsm.dirlock THEN UnLock(wbsm.dirlock)
    IF wbsm THEN Dispose(wbsm)
    RETURN exception
ENDPROC
/**/
/*"p_CLIRun(cmd,dir,sta,pp)"*/
PROC p_CLIRun(cmd,dir,sta,pp) HANDLE
    DEF ofh:PTR TO filehandle
    DEF ifh:PTR TO filehandle
    DEF newct=NIL:PTR TO mp
    DEF oldct:PTR TO mp
    DEF oldcd=NIL
    DEF newcd=NIL
    DEF test
    dWriteF(['wb_CLIRun() \s\n'],[cmd])
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
    IF test:=SystemTagList(cmd,[SYS_OUTPUT,NIL,
                         SYS_INPUT,NIL,
                         SYS_ASYNCH,TRUE,
                         SYS_USERSHELL,FALSE,
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
/**/
/*"p_Alert(texte)"*/
PROC p_Alert(texte) 
        Gt_SetGadgetAttrsA(g_info,cr_window,NIL,[GTTX_BORDER,TRUE,GTTX_TEXT,texte,TAG_DONE,0])
ENDPROC
/**/
/*"p_InitAPP()"*/
PROC p_InitAPP() HANDLE
    DEF r:PTR TO notifyrequest
    DEF p:PTR TO mp
    DEF myb:PTR TO newbroker,errorcx,filter,sender,translate,pv
    DEF txt[256]:STRING
    mb.listxblock:=p_InitList()
    mb.zoomed:=FALSE
    StringF(txt,'HotKey=\s.',mb.cxhotkey)
    IF mb.listxblock<>NIL
        IF r:=New(SIZEOF notifyrequest)
            IF FileLength('Env:ClickCx.Prefs')=-1 THEN Raise(ER_NOPREFS)
            mb.nreq:=r
            r.name:='Env:ClickCx.Prefs'
            r.flags:=NRF_SEND_SIGNAL
            r.port:=FindTask(0)
            r.signalnum:=AllocSignal(-1)
            mb.nreqsigflag:=Shl(1,r.signalnum)
            StartNotify(mb.nreq)
            IF p:=CreateMsgPort()
                mb.prgport:=p
                mb.prgsigflag:=Shl(1,p.sigbit)
                myb:=[NB_VERSION,0,
                      'ClickCx',
                      txt,
                      'Application Window © 1995 NasGûl',
                      NBU_UNIQUE,
                      COF_SHOW_HIDE,
                      0,0,NIL,0]:newbroker
                IF p:=CreateMsgPort()
                    mb.cxport:=p
                    mb.cxsigflag:=Shl(1,p.sigbit)
                    myb.port:=mb.cxport
                    myb.pri:=0
                    IF pv:=CxBroker(myb,NIL)
                        mb.broker:=pv
                        filter:=CreateCxObj(CX_FILTER,mb.cxhotkey,NIL)
                        errorcx:=CxObjError(filter)
                        IF errorcx=0
                            AttachCxObj(mb.broker,filter)
                            sender:=CreateCxObj(CX_SEND,mb.cxport,EVT_HOTKEY)
                            AttachCxObj(filter,sender)
                            translate:=CreateCxObj(CX_TRANSLATE,NIL,NIL)
                            AttachCxObj(filter,translate)
                            IF (errorcx:=CxObjError(filter))=0
                                ActivateCxObj(mb.broker,1)
                            ELSE
                                Raise(ER_CX)
                            ENDIF
                        ELSE
                            Raise(ER_CX)
                        ENDIF
                    ELSE
                        Raise(ER_CX)
                    ENDIF
                ELSE
                    Raise(ER_PORT)
                ENDIF
            ELSE
                Raise(ER_PORT)
            ENDIF
        ELSE
            Raise(ER_MEM)
        ENDIF
    ELSE
        Raise(ER_MEM)
    ENDIF
    Forbid()
    p_ReadFile('Env:ClickCx.Prefs')
    Permit()
    currentnode:=0
    currentlist:=mb.listxblock
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RemAPP()"*/
PROC p_RemAPP()
    DEF r:PTR TO notifyrequest
    dWriteF(['p_RemAPP()\n'],0)
    r:=mb.nreq
    IF r
        IF r.signalnum THEN FreeSignal(r.signalnum)
        IF r THEN EndNotify(r)
    ENDIF
    IF EstrLen(mb.cxhotkey)<>0 THEN DisposeLink(mb.cxhotkey)
    IF mb.prgport THEN DeleteMsgPort(mb.prgport)
    IF mb.broker THEN DeleteCxObjAll(mb.broker)
    IF mb.cxport THEN DeleteMsgPort(mb.cxport)
ENDPROC
/**/
/*"p_CleanPrgList(list:PTR TO lh)"*/
PROC p_CleanPrgList(list:PTR TO lh)
    DEF n:PTR TO ln
    DEF nx:PTR TO xblock
    dWriteF(['p_CleanPrgList() \h\n'],[list])
    n:=list.head
    WHILE n
        IF n.succ<>0
            IF StrCmp(n.name,'»» ',3)
                nx:=n
                p_EnleveNode(list,p_GetNumNode(list,n),FALSE,0)
                p_CleanPrgList(nx.list)
            ELSE
                p_EnleveNode(list,p_GetNumNode(list,n),TRUE,[18,DISL,22,DISL,26,DISL,DISE])
            ENDIF
        ENDIF
        n:=n.succ
    ENDWHILE
ENDPROC
/**/
/*"p_ReadFile(str)"*/
PROC p_ReadFile(str)
    DEF fh,buf[1000]:ARRAY,numline=1
    DEF nom[256]:STRING,rn[256]:STRING
    DEF m:PTR TO LONG
    DEF test
    DEF end
    DEF str_type[80]:STRING
    DEF str_name[80]:STRING
    DEF str_dir[256]:STRING
    DEF str_mode[10]:STRING,st,pri
    DEF str_args[80]:STRING
    DEF mx:PTR TO xblock
    DEF ma:PTR TO xarg,ncw
    DEF lt[100]:ARRAY OF LONG,numlist=0,rnumlist=0
    dWriteF(['p_ReadFile() \s\n'],[str])
    lt[numlist]:=mb.listxblock
    IF fh:=Open(str,OLDFILE)
        m:=[0,0,0,0,0,0,0,0,0]
        WHILE test:=Fgets(fh,buf,1000)
                StringF(nom,'\s',test)
                StrCopy(rn,test,(StrLen(test)-1))
                IF Not(StrCmp(rn,'#',1))
                    IF EstrLen(rn)=0 THEN JUMP sk
                    IF StrLen(test)=1 THEN JUMP sk
                    IF getArg(rn,'StartBlock/K,Name/K,Dir/K,Mode/K,Stack/K/N,Pri/K/N,Args/K,EndBlock/S,NoCloseWindow/S',m)
                        /*
                        StringF(str_type,'»» \s',m[0])
                        StringF(str_name,'\s',m[1])
                        StringF(str_dir,'\s',m[2])
                        */
                        StringF(str_type,'»» \s',m[0])
                        StrCopy(str_name,m[1],ALL)
                        StrCopy(str_dir,m[2],ALL)

                        StringF(str_mode,'\s',m[3]);UpperStr(str_mode)
                        StringF(str_args,'\s',m[6])
                        IF m[4] THEN st:=Long(m[4]) ELSE st:=4000
                        IF m[5] THEN pri:=Long(m[5]) ELSE pri:=0
                        end:=m[7]
                        ncw:=m[8]
                        IF end
                            numlist:=numlist-1
                            JUMP sk
                        ENDIF
                        IF EstrLen(str_type)<>3 /* StartBlock */
                            IF mx:=New(SIZEOF xblock)
                                mx.list:=p_InitList()
                                IF mx.list<>NIL
                                    IF numlist=0 THEN mx.predlist:=mb.listxblock ELSE mx.predlist:=lt[numlist-1]
                                    Forbid()
                                    p_AjouteNode(lt[numlist],str_type,mx)
                                    Permit()
                                    /*WriteF('Block -> p_AjouteNode() \s CurList : \h IntiList:\h NumList:\d PredList:\h\n',str_type,lt[numlist],mx.list,numlist,mx.predlist)*/
                                    numlist:=numlist+1
                                    mx.numlist:=rnumlist
                                    lt[numlist]:=mx.list
                                    JUMP sk
                                ENDIF
                            ENDIF
                        ELSEIF str_name
                            IF ma:=New(SIZEOF xarg)
                                IF numlist=0 THEN ma.predlist:=mb.listxblock ELSE ma.predlist:=lt[numlist-1]
                                ma.curdir:=String(EstrLen(str_dir))
                                StrCopy(ma.curdir,str_dir,EstrLen(str_dir))
                                ma.mode:=String(EstrLen(str_mode))
                                StrCopy(ma.mode,str_mode,EstrLen(str_mode))
                                ma.args:=String(EstrLen(str_args))
                                StrCopy(ma.args,str_args,EstrLen(str_args))
                                ma.stack:=st
                                ma.pri:=pri
                                ma.noclosew:=IF ncw THEN TRUE ELSE FALSE
                                Forbid()
                                p_AjouteNode(lt[numlist],str_name,ma)
                                Permit()
                                /*WriteF('Command -> p_AjouteNode() \s CurList : \h PredList:\h\n',str_name,mx.list,ma.predlist)*/
                                JUMP sk
                            ENDIF
                        ENDIF
                    ELSE
                        EasyRequestArgs(0,[20,0,0,'Error in Line \d\n\s[40]','Merci'],0,[numline,rn])
                        JUMP fin
                    ENDIF
                    sk:
                    m[0]:=0;m[1]:=0;m[2]:=0;m[3]:=0;m[4]:=0;m[5]:=0;m[6]:=0;m[7]:=0;m[8]:=0
                ENDIF
                numline:=numline+1
        ENDWHILE
        fin:
        Close(fh)
        IF numlist<>0 THEN EasyRequestArgs(0,[20,0,0,'(Start+End)*Block Error (list look strange..) [\d]','Merci'],0,[numlist])
    ENDIF
ENDPROC
/**/
/*"getArg(argu,temp,a:PTR TO LONG)"*/
PROC getArg(argu,temp,a:PTR TO LONG)
    DEF myc:PTR TO csource
    DEF ma:PTR TO rdargs
    DEF rdarg=NIL
    DEF argstr[256]:STRING
    DEF ret=NIL
    StrCopy(argstr,argu,ALL)
    StrAdd(argstr,'\n',1)
    IF ma:=AllocDosObject(DOS_RDARGS,NIL)
        myc:=New(SIZEOF csource)
        myc.buffer:=argstr
        myc.length:=EstrLen(argstr)
        ma.flags:=4
        CopyMem(myc,ma.source,SIZEOF csource)
        IF rdarg:=ReadArgs(temp,a,ma)
            ret:=a
            IF rdarg THEN FreeArgs(rdarg)
        ELSE
        ENDIF
        FreeDosObject(DOS_RDARGS,ma)
    ELSE
        WriteF('AllocDosObject failed !!\n')
    ENDIF
    RETURN ret
ENDPROC
/**/
/*"p_WriteFReelList(list:PTR TO lh)"*/
PROC p_WriteFReelList(list:PTR TO lh)
    DEF n:PTR TO ln
    DEF x:PTR TO xblock
    DEF a:PTR TO xarg,test,str[80]:STRING
    n:=list.head
    WHILE n
        IF n.succ<>0
            StrCopy(str,n.name,ALL)
            IF test:=StrCmp(str,'»» ',3)
                x:=n
                WriteF('XBlock : \h Name : \s Adr List: \h Adr PredList :\h\n',x,n.name,x.list,x.predlist)
                /*p_WriteFList(x.list)*/
                p_WriteFReelList(x.list)
            ELSE
                a:=n
                WriteF('Xarg : \h Name : \s Dir : \s Mode : \s Stack : \d Pri : \d Args: \s\n',
                a,n.name,a.curdir,a.mode,a.stack,a.pri,a.args)
            ENDIF
        ENDIF
        n:=n.succ
        IF CtrlC() THEN JUMP fini
    ENDWHILE
    fini:
ENDPROC
/**/
/*"p_StartCli()"*/
PROC p_StartCli() HANDLE 
/*===============================================================================
 = Para         : NONE.
 = Return       : ER_NONE if ok,else the error.
 = Description  : Get .info and lock current dir.
 ==============================================================================*/
    DEF myargs:PTR TO LONG,rdargs=NIL
    DEF editcmd[256]:STRING
    dWriteF(['p_StartCli()\n'],0)
    myargs:=[0,0,0,0,0]
    IF rdargs:=ReadArgs('HotKey/K,Priority/N,EditorName/K,AllScreen/S',myargs,NIL)
        IF myargs[0] 
            mb.cxhotkey:=String(EstrLen(myargs[0]))
            StrCopy(mb.cxhotkey,myargs[0],ALL) 
        ELSE
            mb.cxhotkey:=String(EstrLen('shift ctrl esc'))
            StrCopy(mb.cxhotkey,'shift ctrl esc',ALL)
        ENDIF
        IF myargs[1] THEN mb.cxpri:=Long(myargs[1]) ELSE mb.cxpri:=0
        IF myargs[2]
            StringF(editcmd,'\s "\s"',myargs[2],'ClickCx.Prefs')
        ELSE
            StrCopy(editcmd,'C:ed "ClickCx.Prefs"',ALL)
        ENDIF
        mb.editcmd:=String(EstrLen(editcmd))
        StrCopy(mb.editcmd,editcmd,ALL)
        IF myargs[3]
            StrCopy(autocmd,myargs[3],ALL)
        ELSE
            StrCopy(autocmd,'',ALL)
        ENDIF
        IF myargs[4] THEN mb.allscreen:=TRUE ELSE mb.allscreen:=FALSE
    ELSE
        Raise(ER_BADARGS)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    IF rdargs THEN FreeArgs(rdargs)
    RETURN exception
ENDPROC
/**/
/*"p_StartWb()"*/
PROC p_StartWb() HANDLE
/*===============================================================================
 = Para         : NONE
 = Return       : ER_NONE if ok,else the error.
 = Description  : Get .info and lock current dir.
 ==============================================================================*/
    DEF wb:PTR TO wbstartup
    DEF args:PTR TO wbarg
    DEF prgname[256]:STRING
    DEF disk=NIL:PTR TO diskobject
    DEF str[256]:STRING,hk[80]:STRING,en[80]:STRING
    dWriteF(['p_StartWb()\n'],0)
    wb:=wbmessage
    args:=wb.arglist
    /*FindTask(0)*/
    StrCopy(prgname,args[0].name,ALL)
    baselock:=CurrentDir(args[0].lock)
    IF (disk:=GetDiskObject(prgname))=NIL THEN Raise(ER_NOICONS)
    IF str:=FindToolType(disk.tooltypes,'CX_POPKEY')
        StrCopy(hk,str,ALL)
    ELSE
        StrCopy(hk,'shift ctrl esc',ALL)
    ENDIF
    mb.cxhotkey:=String(EstrLen(hk))
    StrCopy(mb.cxhotkey,hk,ALL)
    IF str:=FindToolType(disk.tooltypes,'EDITORNAME')
        StringF(en,'\s "ClickCx.Prefs"',str)
    ELSE
        StrCopy(en,'C:ed "ClickCx.Prefs"',ALL)
    ENDIF
    mb.editcmd:=String(EstrLen(en))
    StrCopy(mb.editcmd,en,ALL)
    IF str:=FindToolType(disk.tooltypes,'CX_PRIORITY')
        mb.cxpri:=Val(str,NIL)
    ELSE
        mb.cxpri:=0
    ENDIF
    IF str:=FindToolType(disk.tooltypes,'ALLSCREEN') THEN mb.allscreen:=TRUE ELSE mb.allscreen:=FALSE
    IF str:=FindToolType(disk.tooltypes,'CX_POPUP')
        StrCopy(hk,str,ALL)
        UpperStr(hk)
        IF StrCmp(hk,'NO',2) THEN popup:=FALSE ELSE popup:=TRUE
    ENDIF
    IF str:=FindToolType(disk.tooltypes,'COMMAND')
        StrCopy(autocmd,str,ALL)
    ELSE
        StrCopy(autocmd,'',ALL)
    ENDIF
    IF disk THEN FreeDiskObject(disk)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/**/
/*"main()"*/
PROC main() HANDLE 
    DEF testmain
    tattr:=['topaz.font',8,0,0]:textattr
    p_DoReadHeader({banner})
    IF (testmain:=p_OpenLibraries())<>ER_NONE THEN Raise(testmain)
    IF (mb:=New(SIZEOF xdatabase))=NIL THEN Raise(ER_MEM)
    IF wbmessage<>NIL
        IF (testmain:=p_StartWb())<>ER_NONE THEN Raise(testmain)
    ELSE
        IF (testmain:=p_StartCli())<>ER_NONE THEN Raise(testmain)
    ENDIF
    IF (testmain:=p_InitAPP())<>ER_NONE THEN Raise(testmain)
    IF popup
        IF (testmain:=p_OpenWindow())<>ER_NONE THEN Raise(testmain)
    ENDIF
    IF EstrLen(autocmd)<>0 THEN p_CLIRun(autocmd,'Sys:',4000,0)
    REPEAT
        p_LookAllMessage()
    UNTIL reelquit=TRUE
    Raise(ER_NONE)
EXCEPT
    IF cr_window THEN p_CloseWindow()
    IF mb THEN p_RemAPP()
    IF baselock<>NIL THEN UnLock(baselock)
    p_CloseLibraries()
    SELECT exception
        CASE ER_LOCKSCREEN; WriteF('Lock Screen Failed.\n')
        CASE ER_VISUAL;     WriteF('Error Visual.\n')
        CASE ER_CONTEXT;    WriteF('Error Context.\n')
        CASE ER_MENUS;      WriteF('Error Menus.\n')
        CASE ER_GADGET;     WriteF('Error Gadget.\n')
        CASE ER_WINDOW;     WriteF('Error Window.\n')
        CASE ER_MEM;        WriteF('Error Mem.\n')
        CASE ER_PORT;       WriteF('Error Port.\n')
        CASE ER_NOPREFS;    WriteF('Error NoPrefs.\n')
        CASE ER_CX;         WriteF('Error Commodities.\n')
        CASE ER_BADARGS;    WriteF('Error Bad Args.\n')
        CASE ER_NOICONS;    WriteF('Error No Icon.\n')
        CASE ER_APPWIN;     WriteF('Error AppWindow.\n')
    ENDSELECT
ENDPROC
/**/
