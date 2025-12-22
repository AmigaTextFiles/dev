/*===================================================*/
/* Source code generate by Gui2E v0.1 © 1994 NasGûl  */
/*===================================================*/
/*"Peps Header"*/
/*======<<< Peps Header >>>======
 PRGVERSION '0'
 ================================
 PRGREVISION '185'
 ================================
 AUTHOR      'NasGûl'
 ===============================*/
/*===============================
 16/09/94 - Rectification de la procedure p_CloseLibraries()
 17/09/94 - Conflit Avec ToolManager (grosse configuration) ,
            quand WhatView et ToolManager sont dans dans le dossier WBStartup.
            maintenant Whatview lance le WBStart-Handler lors de sa première utilisation,
            et non lors de l'initialisation.
 18/09/94 - Ajout de la fenêtre informations (qui replace le défilement interminable des requesters).
 20/09/94 - la fonte du titre de la fenêtre est maintenant la même que celle de l'ecran.
 05/10/94 - ajout des SubTypes.
 30/01/95 - bug quand l'ENV: n'est pas assigné corigé.
 15/02/95 - WhatView ouvre ses fenêtres sur l'écran public actif (ajout de l'option UNDERMOUSE).
 02/03/95 - Ajout du gadget Cancel dans le requester avant les préférences.
 26/03/95 - Ajout de EditIcon dans WVPrefs,Ajout de la commande associée dans le requester d'EXECUTE (v0.175) + PAT_GAD dans filerequester.
 02/04/95 - Localisation (v 0.185).
 ===============================*/
/**/
OPT OSVERSION=37
OPT LARGE
CONST DEBUG=FALSE
/*"Modules"*/
/*= Modules =*/
MODULE 'intuition/intuition','gadtools','libraries/gadtools',
       'intuition/gadgetclass','intuition/screens','intuition/intuitionbase',
       'graphics/text','exec/lists','exec/nodes',
       'exec/ports','eropenlib','utility/tagitem',
       'wvprefs','whatis','reqtools','libraries/reqtools',
       'wb','utility','workbench/workbench','icon','rexxsyslib','workbench/startup',
       'dos/dos','wbmessage','dos/dostags','dos/dosextens','dos/notify','dos/datetime',
       'exec/libraries',
       'commodities','libraries/commodities',
       'utility',
       'mheader','dos/var'
/**/
/*"Globals Definitions"*/
/*= Erreurs =*/
ENUM ER_NONE,ER_LOCKSCREEN,ER_VISUAL,ER_CONTEXT,ER_MENUS,ER_GADGET,ER_WINDOW,
     ER_NOICON,ER_BADARGS,ER_PORT,ER_APPWIN,ER_NOPREFS,ER_APPITEM,ER_PORTEXIST,
     ER_SIG,ER_CX

/*= Constantes Whatis.library =*/
CONST WI_DEEP=$800000CB,WI_BUFFER=$800000CC,WI_BUFLEN=$800000CD
/*= Constantes pour les listes */
CONST LIST_CLEAN=0,
      LIST_REMOVE=1

CONST DISP=0,
      DISL=1,
      DISE=-1

ENUM ACT_WHATVIEW,ACT_INFO,ACT_ADDICON,ACT_EXECUTE


DEF i_screen:PTR TO screen,
    i_visual

DEF screen:PTR TO screen,
    visual=NIL,
    tattr:PTR TO textattr,
    reelquit=FALSE,
    offx,offy
/*======================================
 = wv Definitions
 ======================================*/
DEF wv_window=NIL:PTR TO window
DEF wv_glist=NIL
/* Gadgets */
ENUM GA_G_WHATVIEW,GA_G_INFO,GA_G_ADDICON,GA_G_EXECUTE,GA_G_PREFS,GA_G_QUIT
/* Gadgets labels of wv */
DEF g_whatview,g_info,g_addicon,g_execute,g_prefs,g_quit
/*=======================================
 = info Definitions
 =======================================*/
DEF info_window=NIL:PTR TO window
DEF info_glist=NIL
/*==================*/
/*     Gadgets      */
/*==================*/
CONST GA_G_INFORM=0
/*=============================
 = Gadgets labels of info
 =============================*/
DEF g_inform
/*===============================*/
/* Application def               */
/*===============================*/
DEF myw=NIL:PTR TO wvbase                       /* PTR base */
DEF wvdisk:PTR TO diskobject                    /* for AppIcon */
DEF prgport=NIL:PTR TO mp                       /* Program port */
DEF dummyport=NIL:PTR TO mp                     /* reply port of the WBstart-Handler Port */
DEF publicport=NIL:PTR TO mp                    /* Public Port of prg */
DEF appicon=NIL,                                /* Appicon */
    appitem=NIL,                                /* AppItem */
    appwindow=NIL,                              /* AppWindow */
    baselock                                    /* lock of current dir */
DEF addicondir[256]:STRING,                     /* path of the icons by def */
    defprefsdir[256]:STRING,                    /* path of WVPrefs */
    defaultdir[256]:STRING,                     /* path for filrrequester */
    defact=-1                                   /* default action (Open Win by def.) */
DEF wb_handle                                   /* address of WBStart-Handler Port */
DEF nreqsig=-1                                  /* Signal to lock env:Whatview.prefs */
DEF prgsig=NIL                                  /* prg signal */
DEF nreq:PTR TO notifyrequest                   /* notifyrequest to lock env:whatview.prefs */
DEF maxarg=20                                   /* max of args by def */
DEF winx=10,winy=10                             /* Winx and Winy */
DEF oktext:PTR TO LONG                          /* text ok gadget (filerequester) */
DEF wtxt[80]:STRING                             /* title of window */
DEF infolist:PTR TO lh                          /* list for info window */
DEF undermouse=FALSE                            /* Open whatview window under the mouse pointer (TRUE/FALSE) */
/**/
/*"Pmodules"*/
PMODULE 'WVDATA'
PMODULE 'WVCX'
PMODULE 'PModules:Plist/p_CleanList'
PMODULE 'PModules:Plist/p_AjouteNode'
PMODULE 'PModules:PMHeader'
PMODULE 'PModules:Plist/p_WriteFList'
PMODULE 'WhatView_Cat'
PMODULE 'WhatViewMessage'
/**/
/*"p_InitWVAPP()"*/
PROC p_InitWVAPP() HANDLE 
/*===============================================================================
 = Para         : NONE
 = Return       : ER_NONE if ok,else the error.
 = Description  : Init all list,ports,appicon and appitem.
 ==============================================================================*/
    DEF txt[80]:STRING
    DEF test
    dWriteF(['p_InitWVAPP()\n'],0)
    StringF(txt,'WhatView <\s>',hotkey)
    StrCopy(wtxt,txt,ALL)
    oktext:=[get_WhatView_string(MSG_GAD_WHATVIEW),get_WhatView_string(MSG_GAD_INFO),get_WhatView_string(MSG_GAD_ADDICON),get_WhatView_string(MSG_GAD_EXECUTE)]
    IF (prgsig:=AllocSignal(-1))=NIL THEN Raise(ER_SIG)
    myw:=New(SIZEOF wvbase)
    myw.adremptylist:=p_InitList()
    myw.adractionlist:=p_InitList()
    infolist:=p_InitList()
    IF (prgport:=CreateMsgPort())=NIL THEN Raise(ER_PORT)
    IF (dummyport:=CreateMsgPort())=NIL THEN Raise(ER_PORT)
    IF (publicport:=p_CreatePublicPort('WhatViewPort',0))=NIL THEN Raise(ER_PORT)
    p_InitPositionIcon(wvdisk)
    IF (appitem:=AddAppMenuItemA(0,0,'WhatView',prgport,[MTYPE_APPMENUITEM,TAG_DONE]))=NIL THEN Raise(ER_APPITEM)
    IF (appicon:=AddAppIconA(0,0,'WhatView',prgport,NIL,wvdisk,
                             [MTYPE_APPICON,MTYPE_ICONPUT,wvdisk,TAG_DONE]))=NIL THEN Raise(ER_NOICON)
    IF wvdisk THEN FreeDiskObject(wvdisk)
    IF (test:=p_InitLockConfigFile())=NIL THEN Raise(ER_NOPREFS)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_RemWVAPP()"*/
PROC p_RemWVAPP() 
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Remove all lists,ports and Appicon,appitem.
 ==============================================================================*/
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
    IF infolist THEN p_CleanList(infolist,FALSE,0,LIST_REMOVE)
    IF prgsig THEN FreeSignal(prgsig)
ENDPROC
/**/
/*"p_CreatePublicPort(name,priority)"*/
PROC p_CreatePublicPort(name,priority) 
/*===============================================================================
 = Para         : name (STRING),pri.
 = Return       : address of port if ok,else NIL.
 = Description  : Create a public port.
 ==============================================================================*/
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
/**/
/*"p_DeletePublicPort(adr_port)"*/
PROC p_DeletePublicPort(adr_port:PTR TO mp) 
/*===============================================================================
 = Para         : address of a public port.
 = Return       : NONE.
 = Description  : Delete a public message port.
 ==============================================================================*/
    dWriteF(['p_DeletePublicPort()\n'],0)
    IF adr_port THEN RemPort(adr_port)
    IF adr_port THEN DeleteMsgPort(adr_port)
ENDPROC
/**/
/*"p_ReadPrefsFile(source)"*/
PROC p_ReadPrefsFile(source) 
/*===============================================================================
 = Para         : the prefs file source.
 = Return       : TRUE if ok,else FALSE
 = Description  : Read the prefs file.
 ==============================================================================*/
    DEF len,a,adr:PTR TO CHAR,buf,handle,flen=TRUE,pos
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
        IF Even(adr+a)
            chunk:=Long(adr+a)
            pos:=adr+a
            SELECT chunk
                CASE ID_WVAC
                    pos:=pos+4
                    node:=New(SIZEOF ln)
                    addact:=New(SIZEOF actionnode)
                    addact.exectype:=Int(pos)
                    addact.stack:=Long(pos+2)
                    addact.priority:=Int(pos+6)
                    addact.usesubtype:=Int(pos+8)
                    StringF(pv,'\s',pos+10)
                    node.name:=String(EstrLen(pv))
                    node.succ:=0
                    StrCopy(node.name,pv,ALL)
                    IF Even(EstrLen(pv))
                        pos:=pos+10+EstrLen(pv)+2
                    ELSE
                        pos:=pos+10+EstrLen(pv)+1
                    ENDIF
                    StringF(pv,'\s',pos)
                    addact.command:=String(EstrLen(pv))
                    StrCopy(addact.command,pv,ALL)
                    IF Even(EstrLen(pv))
                        pos:=pos+EstrLen(pv)+2
                    ELSE
                        pos:=pos+EstrLen(pv)+1
                    ENDIF
                    StringF(pv,'\s',pos)
                    addact.currentdir:=String(EstrLen(pv))
                    StrCopy(addact.currentdir,pv,ALL)
                    IF Even(EstrLen(pv))
                        pos:=pos+EstrLen(pv)+2
                    ELSE
                        pos:=pos+EstrLen(pv)+1
                    ENDIF
                    CopyMem(node,addact.node,SIZEOF ln)
                    AddTail(myw.adractionlist,addact.node)
                    nn:=p_GetNumNode(myw.adractionlist,addact.node)
                    IF nn=-1
                        list:=myw.adractionlist
                        list.head:=addact.node
                        node.pred:=0
                    ENDIF
                    addact.numarg:=0
                    addact.cmd:=0
                    IF node THEN Dispose(node)
                CASE ID_DEFA
                    pos:=pos+4
                    defact:=Long(pos)
            ENDSELECT
        ENDIF
    ENDFOR
    Dispose(buf)
    RETURN TRUE
ENDPROC
/**/
/*"p_InitLockConfigFile()"*/
PROC p_InitLockConfigFile() 
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Lock the prefs file.
 ==============================================================================*/
    DEF flen
    dWriteF(['p_InitLockConfig()\n'],0)
    IF (flen:=FileLength('ENV:WhatView.prefs'))=-1 THEN RETURN 0
    nreq:=New(SIZEOF notifyrequest)
    nreq.name:='Env:WhatView.prefs'
    nreq.flags:=NRF_SEND_SIGNAL
    nreq.port:=FindTask(0)
    nreq.signalnum:=AllocSignal(nreqsig)
    nreqsig:=nreq.signalnum
    StartNotify(nreq)
    RETURN 1
ENDPROC
/**/
/*"p_RemLockConfigFile()"*/
PROC p_RemLockConfigFile() 
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Unlock the prefs file.
 ==============================================================================*/
    dWriteF(['p_RemLockConfig()\n'],0)
    IF nreqsig THEN FreeSignal(nreqsig)
    IF nreq THEN EndNotify(nreq)
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
    DEF prgname[256]:STRING
    DEF pro:PTR TO process
    dWriteF(['p_StartCli()\n'],0)
    myargs:=[0,0,0]
    IF rdargs:=ReadArgs('HK=CX_POPKEY/K,PRI=CX_PRIORITY/N,HKP=HotKeyPrefs/K',myargs,NIL)
        GetProgramName(prgname,256)
        IF myargs[0] THEN StrCopy(hotkey,myargs[0],ALL) ELSE StrCopy(hotkey,'ralt help',ALL)
        IF myargs[1] THEN cxpri:=Long(myargs[1]) ELSE cxpri:=0
        IF myargs[2] THEN StrCopy(hotkeyprefs,myargs[2],ALL) ELSE StrCopy(hotkeyprefs,'shift ralt help',ALL)
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
    dWriteF(['p_StartWb()\n'],0)
    wb:=wbmessage
    args:=wb.arglist
    /*FindTask(0)*/
    StrCopy(prgname,args[0].name,ALL)
    baselock:=CurrentDir(args[0].lock)
    IF (wvdisk:=GetDiskObject(prgname))=NIL THEN Raise(ER_NOICON)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_InitPositionIcon(s_d_o)"*/
PROC p_InitPositionIcon(s_d_o:PTR TO diskobject) 
/*===============================================================================
 = Para         : address of diskobject structure.
 = Return       : NONE.
 = Description  : look for POSX,POSY and the default dirs.
 ==============================================================================*/
    DEF defdir[256]:STRING
    DEF max=NIL
    dWriteF(['p_InitPositionIcon()\n'],0)
    s_d_o.currentx:=Val(FindToolType(s_d_o.tooltypes,'POSX'),NIL)
    s_d_o.currenty:=Val(FindToolType(s_d_o.tooltypes,'POSY'),NIL)
    IF defdir:=FindToolType(s_d_o.tooltypes,'DEFDIR')
        IF defdir THEN StrCopy(addicondir,defdir,ALL)
    ELSE
        StrCopy(addicondir,'Env:Sys',ALL)
    ENDIF
    IF defdir:=FindToolType(s_d_o.tooltypes,'DEFPREFSDIR')
        IF defdir THEN StrCopy(defprefsdir,defdir,ALL)
    ELSE
        StrCopy(defprefsdir,'Sys:Prefs',ALL)
    ENDIF
    IF max:=FindToolType(s_d_o.tooltypes,'MAXARG')
        IF max THEN maxarg:=Val(max,NIL)
        IF maxarg>20 THEN maxarg:=20
    ENDIF
    IF defdir:=FindToolType(s_d_o.tooltypes,'UNDERMOUSE') THEN undermouse:=TRUE
    IF wbmessage<>NIL
        IF defdir:=FindToolType(s_d_o.tooltypes,'CX_POPKEY')
            IF defdir THEN StrCopy(hotkey,defdir,ALL)
        ELSE
            StrCopy(hotkey,'ralt help',ALL)
        ENDIF
        IF defdir:=FindToolType(s_d_o.tooltypes,'CX_POPKEYPREFS')
            IF defdir THEN StrCopy(hotkeyprefs,defdir,ALL)
        ELSE
            StrCopy(hotkeyprefs,'shift ralt help',ALL)
        ENDIF
        IF defdir:=FindToolType(s_d_o.tooltypes,'CX_PRIORITY')
            cxpri:=Val(defdir,NIL)
        ELSE
            cxpri:=0
        ENDIF
    ENDIF
ENDPROC
/**/
/*"p_DoAction(a)"*/
PROC p_DoAction(a) 
    DEF tt
    IF p_EmptyList(myw.adremptylist)<>-1
        p_WriteFArgList(myw.adremptylist,a)
    ELSE
        IF (tt:=p_WVFileRequester(a))
            p_WriteFArgList(myw.adremptylist,a)
        ENDIF
    ENDIF
    p_RemoveArgList(myw.adremptylist,FALSE)
    p_CleanArgActionList(myw.adractionlist)
ENDPROC
/**/
/*"p_WBRun(com,di,st,pr,num_arg,arg_list)"*/
PROC p_WBRun(com,dir,st,pr,num_arg,arg_list:PTR TO LONG) HANDLE 
/*===============================================================================
 = Para         : command (STRING),current dir of the command,the stack,the pri,the num of args,the args
 = Return       : ER_NONE if ok,else the error.
 = Description  : Start a command with the WBStart-Handler port.
 ==============================================================================*/
    DEF execmsg:PTR TO mn
    DEF wbsm:wbstartmsg
    DEF rc=FALSE
    DEF node:PTR TO ln
    DEF oldcd
    DEF b,t
    Forbid()
    wb_handle:=FindPort('WBStart-Handler Port')
    Permit()
    IF wb_handle=0 THEN wb_handle:=p_InitWBHandler()
    dWriteF(['p_WBRun() NumArg:\d ','Commande:\s\n'],[num_arg,com])
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
    IF rc=0 THEN p_MakeWVRequest(get_WhatView_string(MSGWHATVIEW_WBRUN_FAILED),get_WhatView_string(MSGWHATVIEW_COMASS_GAD),NIL)
    Raise(ER_NONE)
EXCEPT
    CurrentDir(oldcd)
    IF wbsm.dirlock THEN UnLock(wbsm.dirlock)
    IF wbsm THEN Dispose(wbsm)
    RETURN exception
ENDPROC
/**/
/*"p_CLIRun(cmd,dir,sta,pp)"*/
PROC p_CLIRun(cmd,dir,sta,pp) HANDLE 
/*===============================================================================
 = Para         : command line,current dir of command,the stack,the pri.
 = Return       : ER_NONE if ok,else the error.
 = Description  : Start a Cli program.
 ==============================================================================*/
    DEF ofh:PTR TO filehandle
    DEF ifh:PTR TO filehandle
    DEF newct=NIL:PTR TO mp
    DEF oldct:PTR TO mp
    DEF oldcd
    DEF newcd
    DEF test
    dWriteF(['p_CLIRun() cmd:\s\n'],[cmd])
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
/**/
/*"p_InitWBHandler()"*/
PROC p_InitWBHandler() HANDLE 
/*===============================================================================
 = Para         : NONE
 = Return       : ER_NONE if ok,else the error.
 = Description  : Init the WBStart-Handler Port.
 ==============================================================================*/
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
/*"p_AddIcon(t_fullname,t_reelname,t_lock,t_size,t_idstr)"*/
PROC p_AddIcon(t_fullname,t_reelname,t_size,t_idstr) 
/*===============================================================================
 = Para         : t_fullname (STRING),t_size (LONG),t_idstr (STRING)
 = Return       : NONE.
 = Description  : Add Def icons to a file(s) or/and dir(s).
 ==============================================================================*/
    DEF id_type
    DEF id_icon[80]:STRING
    DEF piv_str[256]:STRING
    DEF fichier_source[256]:STRING
    DEF fichier_destin[256]:STRING
    DEF csdo:PTR TO diskobject
    DEF fn[256]:STRING
    StringF(fn,'\s',t_fullname)
    dWriteF(['p_AddIcon()\s',' \s',' \d',' \s\n'],[t_fullname,t_reelname,t_size,t_idstr])
    StrCopy(piv_str,addicondir,ALL)
    id_type:=WhatIs(fn,[WI_DEEP,1])
    id_icon:=GetIconName(id_type)
    AddPart(piv_str,id_icon,256)
    StringF(fichier_source,'\s',piv_str)
    IF id_icon<>NIL
        StringF(fichier_destin,'\s',t_fullname)
        Forbid()
        IF csdo:=GetDiskObject(fichier_source)
            csdo.currentx:=NO_ICON_POSITION
            csdo.currenty:=NO_ICON_POSITION
            PutDiskObject(fichier_destin,csdo)
            IF csdo THEN FreeDiskObject(csdo)
        ELSE
            p_MakeWVRequest(get_WhatView_string(MSGWHATVIEW_ADDICON),get_WhatView_string(MSGWHATVIEW_COMASS_GAD),[t_reelname,t_idstr,t_size])
        ENDIF
        Permit()
    ELSE
        p_MakeWVRequest(get_WhatView_string(MSGWHATVIEW_ADDICON),get_WhatView_string(MSGWHATVIEW_COMASS_GAD),[t_reelname,t_idstr,t_size])
    ENDIF
ENDPROC
/**/
/*"p_FlushWhatis()"*/
PROC p_FlushWhatis() 
/*===============================================================================
 = Para         : NONE
 = Return       : NONE
 = Description  : Close Open and Flush the whatis.library.
 ==============================================================================*/
    DEF library:PTR TO lib
    dWriteF(['p_FlushWhatIs()\n'],[0])
    IF whatisbase
        library:=whatisbase
        CloseLibrary(whatisbase)
        IF library.opencnt>0
            p_MakeWVRequest(get_WhatView_string(MSGWHATVIEW_FLUSHLIB_BAD),get_WhatView_string(MSGWHATVIEW_COMASS_GAD),[library.opencnt])
        ELSE
            p_MakeWVRequest(get_WhatView_string(MSGWHATVIEW_FLUSHLIB_GOOD),get_WhatView_string(MSGWHATVIEW_COMASS_GAD),NIL)
        ENDIF
        whatisbase:=OpenLibrary('whatis.library',3)
    ENDIF
    AskReparse($01)
ENDPROC
/**/
/*"main()"*/
PROC main() HANDLE 
/*===============================================================================
 = Para         : NONE
 = Return       : ER_NONE if ok,else the error.
 = Description  : Main Procédure.
 ==============================================================================*/
    DEF testmain
    localebase:=OpenLibrary('locale.library',0)
    open_WhatView_catalog(NIL,NIL)
    tattr:=['topaz.font',8,0,0]:textattr
    IF (testmain:=p_OpenLibraries())<>ER_NONE THEN Raise(testmain)
    IF wbmessage<>NIL
        IF (testmain:=p_StartWb())<>ER_NONE THEN Raise(testmain)
    ELSE
        IF (testmain:=p_StartCli())<>ER_NONE THEN Raise(testmain)
    ENDIF
    p_DoReadHeader({banner})
    testmain:=FindPort('WhatViewPort') 
    IF testmain THEN Raise(ER_PORTEXIST)
    IF (testmain:=p_InitWVAPP())<>ER_NONE THEN Raise(testmain)
    SetVar('WVICDEF',addicondir,EstrLen(addicondir),GVF_GLOBAL_ONLY)
    IF (testmain:=p_ReadPrefsFile('Env:WhatView.prefs'))=FALSE THEN Raise(ER_NOPREFS)
    IF (testmain:=p_InitCx())<>ER_NONE THEN Raise(testmain)
    /* l'initialisation du WBstart-handler est maintenant dans la procédure p_WBRun() */
    REPEAT
        p_LookAllMessage()
    UNTIL reelquit=TRUE
    Raise(ER_NONE)
EXCEPT
    IF wv_window THEN p_CloseWindow()
    IF info_window THEN p_CloseInfoWindow()
    p_RemCx()
    IF myw THEN p_RemWVAPP()
    IF baselock THEN CurrentDir(baselock)
    p_CloseLibraries()
    SELECT exception
        CASE ER_LOCKSCREEN; WriteF(get_WhatView_string(MSGERWHATVIEW_ER_LOCKSCREEN))
        CASE ER_VISUAL;     WriteF(get_WhatView_string(MSGERWHATVIEW_ER_VISUAL))
        CASE ER_CONTEXT;    WriteF(get_WhatView_string(MSGERWHATVIEW_ER_CONTEXT))
        CASE ER_MENUS;      WriteF(get_WhatView_string(MSGERWHATVIEW_ER_MENUS))
        CASE ER_GADGET;     WriteF(get_WhatView_string(MSGERWHATVIEW_ER_GADGET))
        CASE ER_WINDOW;     WriteF(get_WhatView_string(MSGERWHATVIEW_ER_WINDOW))
        CASE ER_NOICON;     WriteF(get_WhatView_string(MSGERWHATVIEW_ER_NOICON))
        CASE ER_BADARGS;    WriteF(get_WhatView_string(MSGERWHATVIEW_ER_BADARGS))
        CASE ER_NOPREFS;    WriteF(get_WhatView_string(MSGERWHATVIEW_ER_NOPREFS))
        CASE ER_APPWIN;     WriteF(get_WhatView_string(MSGERWHATVIEW_ER_APPWIN))
        CASE ER_APPITEM;    WriteF(get_WhatView_string(MSGERWHATVIEW_ER_APPITEM))
        CASE ER_PORT;       WriteF(get_WhatView_string(MSGERWHATVIEW_ER_PORT))
        CASE ER_PORTEXIST;  WriteF(get_WhatView_string(MSGERWHATVIEW_ER_PORTEXIST))
        CASE ER_SIG;        WriteF(get_WhatView_string(MSGERWHATVIEW_ER_SIG))
        CASE ER_CX;         WriteF(get_WhatView_string(MSGERWHATVIEW_ER_CX))
        CASE ER_INTUITIONLIB; WriteF(get_WhatView_string(MSGERWHATVIEW_ER_INTUITIONLIB))
        CASE ER_GADTOOLSLIB;  WriteF(get_WhatView_string(MSGERWHATVIEW_ER_GADTOOLSLIB))
        CASE ER_GRAPHICSLIB;  WriteF(get_WhatView_string(MSGERWHATVIEW_ER_GRAPHICSLIB))
        CASE ER_WHATISLIB;    WriteF(get_WhatView_string(MSGERWHATVIEW_ER_WHATISLIB))
        CASE ER_REQTOOLSLIB;  WriteF(get_WhatView_string(MSGERWHATVIEW_ER_REQTOOLSLIB))
        CASE ER_EXECLIB;      WriteF(get_WhatView_string(MSGERWHATVIEW_ER_EXECLIB))
        CASE ER_WORKBENCHLIB; WriteF(get_WhatView_string(MSGERWHATVIEW_ER_WORKBENCHLIB))
        CASE ER_UTILITYLIB;   WriteF(get_WhatView_string(MSGERWHATVIEW_ER_UTILITYLIB))
        CASE ER_DOSLIB;       WriteF(get_WhatView_string(MSGERWHATVIEW_ER_DOSLIB))
        CASE ER_ICONLIB;      WriteF(get_WhatView_string(MSGERWHATVIEW_ER_ICONLIB))
        CASE ER_REXXSYSLIBLIB; WriteF(get_WhatView_string(MSGERWHATVIEW_ER_REXXSYSLIBLIB))
        CASE ER_COMMODITIESLIB; WriteF(get_WhatView_string(MSGERWHATVIEW_ER_COMMODITIESLIB))
    ENDSELECT
    close_WhatView_catalog()
    IF localebase THEN CloseLibrary(localebase)
    CleanUp(exception)
ENDPROC
/**/
