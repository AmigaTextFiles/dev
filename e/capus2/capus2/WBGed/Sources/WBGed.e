/*"Peps Header"*/
/*======<<< Peps Header >>>======
 PRGVERSION '0'
 ================================
 PRGREVISION '2'
 ================================
 AUTHOR      'NasGûl'
 ===============================*/
/*======<<<   History   >>>======
 QuickStarter for GoldED.
 (use of the WBstart-Handler for the first call).
 ===============================*/
 /**/
CONST DEBUG=FALSE
/*"Modules Lists"*/
MODULE 'exec/ports','exec/nodes','exec/lists','exec/ports'
MODULE 'dos/dosextens','dos/dostags'
MODULE 'rexxsyslib','rexx/rxslib','rexx/storage','rexx/errors'
MODULE 'eropenlib','verslib'
MODULE 'workbench/startup','wbmessage'
MODULE 'utility/tagitem'
ENUM ER_NONE,ER_BADARGS,ER_PORT,ER_NOGOLDED,ER_ONLYCLI,
     ER_WB
/**/
/*"Objects lists"*/
OBJECT goldarg
    node:ln
    lock:LONG
ENDOBJECT
/**/
/*"Pmodules"*/
PMODULE 'WBGoldEDList'
PMODULE 'PModules:dWriteF'
/**/
/*"Globals def"*/
DEF my_port:PTR TO mp
DEF goldport:PTR TO mp
DEF goldedportname[80]:STRING
DEF arglist:PTR TO lh
DEF currentdir[256]:STRING
DEF newg=FALSE
DEF ask=FALSE
DEF new=FALSE
DEF hide
DEF winv=FALSE,winh=FALSE
DEF commande[256]:STRING
/**/
/*"p_OpenLibraries()"*/
PROC p_OpenLibraries() HANDLE
    IF (rexxsysbase:=OpenLibrary('rexxsyslib.library',VERS_REXXSYSLIB))=NIL THEN Raise(ER_REXXSYSLIBLIB)
    Raise(ER_NONE)
EXCEPT
    dWriteF(['p_OpenLibraries() -> \d\n'],[exception])
    RETURN exception
ENDPROC
/**/
/*"p_CloseLibraires()"*/
PROC p_CloseLibraries()
    IF rexxsysbase THEN CloseLibrary(rexxsysbase)
ENDPROC
/**/
/*"p_StartCli()"*/
PROC p_StartCli() HANDLE 
    DEF myargs:PTR TO LONG,rdargs=NIL
    DEF marg:PTR TO LONG,b=20
    DEF n[256]:STRING
    DEF lock
    DEF ga:PTR TO goldarg
    DEF pro:PTR TO process
    myargs:=[0,0,0,0,0,0,0,0]
    IF rdargs:=ReadArgs('Files/M,NewGold/S,Ask/S,New/S,WinV/S,WinH/S,Hide/S,C=Command/F',myargs,NIL)
        IF myargs[0]
            marg:=myargs[0]
            FOR b:=0 TO 19
                IF marg[b]<>0
                    IF b=0 THEN StrCopy(n,Long(myargs[0]),ALL) ELSE StrCopy(n,marg[b],ALL)
                    IF ((FileLength(n)<>-1) AND (EstrLen(n)<>0))
                        IF lock:=Lock(n,-2)
                            ga:=New(SIZEOF goldarg)
                            ga.lock:=DupLock(lock)
                            p_AjouteNode(arglist,n,ga)
                            IF lock THEN UnLock(lock)
                        ENDIF
                    ENDIF
                ENDIF
            ENDFOR
        ENDIF
        IF myargs[1] THEN newg:=TRUE
        IF myargs[2] THEN ask:=TRUE
        IF myargs[3] THEN new:=TRUE
        IF myargs[4] THEN winv:=TRUE
        IF myargs[5] THEN winh:=TRUE
        IF myargs[6] THEN hide:=TRUE
        IF myargs[7] THEN StrCopy(commande,myargs[7],ALL) ELSE StrCopy(commande,'',ALL)
    ELSE
        Raise(ER_BADARGS)
    ENDIF
    pro:=FindTask(0)
    NameFromLock(pro.currentdir,currentdir,256)
    Raise(ER_NONE)
EXCEPT
    IF rdargs THEN FreeArgs(rdargs)
    dWriteF(['p_StartCli() ->\d\n'],[exception])
    RETURN exception
ENDPROC
/**/
/*"p_FindGoldedPort()"*/
PROC p_FindGoldedPort() HANDLE
    DEF a=1,portname[80]:STRING,gedport
    FOR a:=1 TO 9
        StringF(portname,'GOLDED.\d',a)
        Forbid()
        gedport:=FindPort(portname)
        Permit()
        IF gedport<>0 THEN JUMP found
    ENDFOR
    Raise(ER_NOGOLDED)
    found:
    StrCopy(goldedportname,portname,ALL)
    Raise(gedport)
EXCEPT
    dWriteF(['p_FindGoldedPort() ->\d\n'],[exception])
    RETURN exception
ENDPROC
/**/
/*"main()"*/
PROC main() HANDLE
    DEF tm
    DEF cmd[256]:STRING
    IF (tm:=p_OpenLibraries())<>ER_NONE THEN Raise(tm)
    IF (my_port:=CreateMsgPort())=NIL THEN Raise(ER_PORT)
    arglist:=p_InitList()
    IF wbmessage=NIL
        IF (tm:=p_StartCli())<>ER_NONE THEN Raise(tm)
        /*JUMP exit*/
    ELSE
        Raise(ER_ONLYCLI)
    ENDIF
    IF ((winv=TRUE) OR (winh=TRUE) OR (ask=TRUE) OR (EstrLen(commande)<>0))
        IF (p_FindGoldedPort())<>ER_NOGOLDED
            IF EstrLen(commande)<>0
                p_InterpretWithArexx(commande)
                JUMP exit
            ENDIF
            IF winh=TRUE
                p_InterpretWithArexx('WINDOW ARRANGE 0')
                JUMP exit
            ENDIF
            IF winv=TRUE
                p_InterpretWithArexx('WINDOW ARRANGE 1')
                JUMP exit
            ENDIF
            IF ask=TRUE
                IF new=TRUE
                    StringF(cmd,'OPEN NEW ASK PATH \s',currentdir)
                ELSE
                    StringF(cmd,'OPEN ASK PATH \s',currentdir)
                ENDIF
                p_InterpretWithArexx(cmd)
                JUMP exit
            ENDIF
        ELSE
            WriteF('Need GOLDED.1 Port for this..\n')
        ENDIF
        JUMP exit
    ENDIF
    IF newg=TRUE
        IF (tm:=p_CLIRunGoldED())<>ER_NONE THEN Raise(tm)
        JUMP exit
    ENDIF
    IF (goldport:=p_FindGoldedPort())=ER_NOGOLDED
        IF (tm:=p_CLIRunGoldED())<>ER_NONE THEN Raise(tm)
        JUMP exit
    ENDIF
    p_ArexxLoadFile()
    exit:
    Raise(ER_NONE)
EXCEPT
    IF arglist THEN p_CleanList(arglist,TRUE,[DISE],LIST_REMOVE)
    IF my_port THEN DeleteMsgPort(my_port)
    p_CloseLibraries()
    SELECT exception
        CASE ER_REXXSYSLIBLIB; WriteF('Rexxsyslib.library ??.\n')
        CASE ER_BADARGS;       WriteF('Bad Aregs\n')
        CASE ER_PORT;          WriteF('Can\at create port.\n')
        CASE ER_ONLYCLI;       WriteF('Only Cli.\n')
        CASE ER_WB;            WriteF('Could\ant launch GoldED:GoldED .\n')
    ENDSELECT
ENDPROC
/**/
/*"p_CLIRunGoldED()"*/
PROC p_CLIRunGoldED()
    DEF cmd[1024]:STRING,f[256]:STRING
    DEF l:PTR TO lh
    DEF n:PTR TO ln
    DEF a:PTR TO goldarg
    l:=arglist
    n:=l.head
    StrCopy(cmd,'GoldED ',ALL)
    WHILE n
        IF n.succ<>0
            a:=n
            NameFromLock(a.lock,f,256)
            StrAdd(cmd,f,ALL)
            StrAdd(cmd,' ',ALL)
            IF a.lock THEN UnLock(a.lock)
        ENDIF
        n:=n.succ
    ENDWHILE
    IF hide=TRUE THEN StrAdd(cmd,'HIDE',ALL)
    p_CLIRun(cmd,'GoldED:',10000,0)
ENDPROC
/**/

/*"p_ArexxLoadFile()"*/
PROC p_ArexxLoadFile()
    DEF n:PTR TO ln
    DEF wn:PTR TO goldarg
    DEF cmd[256]:STRING
    DEF p[256]:STRING
    DEF fullname[256]:STRING
    n:=arglist.head
    IF p_EmptyList(arglist)<>0
        p_InterpretWithArexx('LOCK CURRENT')
        StringF(p,'DIR NEW \s',currentdir)
        p_InterpretWithArexx(p)
        StrCopy(cmd,'OPEN ',ALL)
        WHILE n
            wn:=n
            IF n.succ<>0
                NameFromLock(wn.lock,fullname,256)
                IF wn.lock THEN UnLock(wn.lock)
                StringF(p,'OPEN "\s" SMART',fullname)
                p_InterpretWithArexx(p)
            ENDIF
            n:=n.succ
        ENDWHILE
        StrAdd(cmd,'SMART',ALL)
    ELSE
        StrCopy(cmd,'OPEN NEW',ALL)
    ENDIF
    p_InterpretWithArexx('UNLOCK')
    dWriteF(['p_ArexxLoadFile()\n'],[0])
ENDPROC
/**/
/*"p_InterpretWithArexx(command)"*/
PROC p_InterpretWithArexx(command)
    DEF rc=FALSE
    DEF rarg:PTR TO rexxarg
    DEF rxmsg:PTR TO rexxmsg
    DEF retxmsg:PTR TO rexxmsg
    DEF ap:PTR TO mp
    DEF test:PTR TO LONG
    DEF execmsg:PTR TO mn
    DEF node:PTR TO ln
    IF rxmsg:=CreateRexxMsg(my_port,NIL,NIL)
        execmsg:=rxmsg
        node:=execmsg
        node.name:='AZERTY'
        node.type:=NT_MESSAGE
        node.pri:=0
        execmsg.replyport:=my_port
        IF test:=CreateArgstring(command,EstrLen(command))
            CopyMem({test},rxmsg.args,4)
            rxmsg.action:=RXCOMM+RXFF_RESULT+RXFF_STRING
            rxmsg.passport:=my_port
            rxmsg.stdin:=Input()
            rxmsg.stdout:=Output()
            Forbid()
            ap:=FindPort(goldedportname)
            IF ap
                PutMsg(ap,rxmsg)
            ENDIF
            Permit()
            IF ap
                WaitPort(my_port)
                IF retxmsg:=GetMsg(my_port)
                    rc:=rxmsg.result1        /* return code */
                    rarg:=rxmsg.result2
                ENDIF
            ENDIF
            IF test THEN ClearRexxMsg(rxmsg,16)
        ENDIF
        IF rxmsg THEN DeleteRexxMsg(rxmsg)
    ENDIF
    dWriteF(['p_InterpretWithArexx() ->\d\n'],[rc])
    RETURN rc
ENDPROC
/**/
/*"p_CLIRun()"*/
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

