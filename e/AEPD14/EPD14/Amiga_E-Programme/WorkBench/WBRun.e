
ENUM ER_NONE,ER_ONLYCLI,ER_BADARGS,ER_PORT,ER_NOPORT,ER_NOINFO

MODULE 'exec/ports','exec/nodes','wbmessage'
MODULE 'dos/dostags','dos/dosextens'

DEF comm[256]:STRING
DEF stack=4000,pri=0
DEF pro:PTR TO process
PROC main() HANDLE /*"main()"*/
    DEF myargs:PTR TO LONG,rdargs=NIL
    IF wbmessage<>NIL THEN Raise(ER_ONLYCLI)
    myargs:=[0,0,0]
    pro:=FindTask(0)
    IF rdargs:=ReadArgs('Commande/A,S=Stack/N,P=Priorité/N',myargs,NIL)
        StrCopy(comm,myargs[0],ALL)
        IF myargs[1] THEN stack:=Long(myargs[1])
        IF myargs[2] THEN pri:=Long(myargs[2])
        IF stack<4000 THEN stack:=4000
        IF ((pri<-10) OR (pri>10)) THEN pri:=0
        Raise(wb_WBRun(comm,stack,pri))
    ELSE
        Raise(ER_BADARGS)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    IF rdargs THEN FreeArgs(rdargs)
    SELECT exception
        CASE ER_ONLYCLI;    WriteF('Du CLi Uniquement.\n')
        CASE ER_BADARGS;    WriteF('Mauvais argument(s).\n')
        CASE ER_PORT;       WriteF('Impossible de créer le port de message.\n')
        CASE ER_NOPORT;     WriteF('Impossible de trouver le "WBStart-Handler Port".\n')
        CASE ER_NOINFO;     WriteF('Pas d\aicone pour le fichier \s.\n',comm)
    ENDSELECT
ENDPROC
PROC wb_WBRun(com,st,pr) HANDLE /*"wb_WBrun(com,st,pr)"*/
    DEF execmsg:PTR TO mn
    DEF wbsm:wbstartmsg
    DEF rc=FALSE
    DEF node:PTR TO ln
    DEF dummyport:PTR TO mp
    DEF hp
    DEF pv[256]:STRING,flen
    StringF(pv,'\s.info',com)
    IF (flen:=FileLength(pv))=-1 THEN Raise(wb_CLIRun(com))
    IF (dummyport:=CreateMsgPort())=NIL THEN Raise(ER_PORT)
    wbsm:=New(SIZEOF wbstartmsg)
    execmsg:=wbsm
    node:=execmsg
    node.type:=NT_MESSAGE
    node.pri:=0
    execmsg.replyport:=dummyport
    wbsm.name:=com
    wbsm.dirlock:=Lock(com,-2)
    wbsm.stack:=st
    wbsm.prio:=pr
    wbsm.numargs:=0
    wbsm.arglist:=0
    Forbid()
    IF (hp:=FindPort('WBStart-Handler Port'))=NIL  /* THEN Raise(ER_NOPORT)  */
        hp:=wb_InitWBHandler()
    ENDIF
    IF hp
        PutMsg(hp,wbsm)
    ENDIF
    Permit()
    IF hp
        WaitPort(dummyport)
        GetMsg(dummyport)
        rc:=wbsm.stack
    ENDIF
    IF rc=0 THEN WriteF('WBRun Failed.\n')
    Raise(ER_NONE)
EXCEPT
    IF wbsm.dirlock THEN UnLock(wbsm.dirlock)
    IF wbsm THEN Dispose(wbsm)
    IF dummyport THEN DeleteMsgPort(dummyport)
    RETURN exception
ENDPROC
PROC wb_CLIRun(cmd) HANDLE /*"wv_CLIRun(cmd)"*/
    DEF ofh:PTR TO filehandle
    DEF ifh:PTR TO filehandle
    DEF newct=NIL:PTR TO mp
    DEF oldct:PTR TO mp
    DEF oldcd
    DEF newcd
    DEF er,cli:PTR TO commandlineinterface
    IF ofh:=Open('NIL:',1006)
        IF IsInteractive(ofh)
            WriteF('IsInteractive Ok\n')
            newct:=ofh.type
            oldct:=SetConsoleTask(newct)
            ifh:=Open('CONSOLE:',1005)
            SetConsoleTask(oldct)
        ELSE
            ifh:=Open('NIL:',1005)
        ENDIF
    ENDIF
    newcd:=Lock(cmd,-2)
    oldcd:=CurrentDir(newcd)
    IF SystemTagList(cmd,[SYS_OUTPUT,stdout,
                         SYS_INPUT,pro.cis,
                         SYS_ASYNCH,FALSE,
                         SYS_USERSHELL,FALSE,
                         NP_STACKSIZE,4000,
                         NP_PRIORITY,0,
                         NP_PATH,NIL,
                         NP_CONSOLETASK,newct,
                         NP_CLI,conout,
                         0])
        er:=IoErr()
    ENDIF
    cli:=stdout
    WriteF('Error \d \d \d\n',er,pro.result2,cli.returncode)
    CurrentDir(oldcd)
    IF ofh THEN Close(ofh)
    IF ifh THEN Close(ifh)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC wb_InitWBHandler() HANDLE /*"wb_InitWBHandler()"*/
    DEF ifh
    DEF ofh
    DEF wbh
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


