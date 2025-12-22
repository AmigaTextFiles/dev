/*======<<< Peps Header >>>======
 PRGVERSION '0'
 ================================
 PRGREVISION '0'
 ================================
 AUTHOR      'NasGûl'
 ===============================*/
/*======<<<   History   >>>======
 ReqStartup
 ===============================*/

OPT OSVERSION=37

MODULE 'reqtools','libraries/reqtools'
MODULE 'exec/lists','exec/nodes'
MODULE 'dos/dos','dos/dosasl','dos/dosextens','dos/dostags'
MODULE 'exec/ports','intuition/screens','graphics/displayinfo','graphics/text'

ENUM ER_NONE,ER_ONLYCLI,ER_BADARGS,ER_REQTOOLSLIB,ER_LIST,ER_INITENV,ER_SCREEN

DEF reqtexte[2000]:STRING
DEF reqgad[80]:STRING
DEF screen=NIL:PTR TO screen
DEF cmd[256]:STRING
DEF defs[256]:STRING
DEF dorun=FALSE,test=FALSE,openscreen=FALSE

DEF slist:PTR TO lh

PMODULE 'ReqUserStartupList'

/*"main()"*/
PROC main() HANDLE
    DEF r
    DEF n:PTR TO ln
    DEF rdargs=NIL,myargs:PTR TO LONG
    VOID {banner}
    myargs:=[0,0,0,0]
    IF rdargs:=ReadArgs('DefaultStartup,Run/S,Test/S,Screen/S',myargs,NIL)
        IF myargs[0] THEN StrCopy(defs,myargs[0],ALL)
        IF myargs[1] THEN dorun:=TRUE
        IF myargs[2] THEN test:=TRUE
        IF myargs[3] THEN openscreen:=TRUE
        IF initEnv()
            IF reqtoolsbase:=OpenLibrary('reqtools.library',37)
                IF slist:=p_InitList()
                    makeFileList()
                    makeRequest()
                    IF openscreen
                        IF openScreen()<>ER_NONE THEN Raise(ER_SCREEN)
                    ENDIF
                    r:=RtEZRequestA(reqtexte,reqgad,0,0,[RTEZ_REQTITLE,'ReqUserStartup v0.1 © NasGûl',RT_SCREEN,screen,RT_PUBSCRNAME,'ReqUserStartupScreen',RT_UNDERSCORE,"_",NIL])
                    IF r<>0
                        n:=p_GetAdrNode(slist,r-1)
                        StringF(cmd,'S:\s',n.name)
                    ELSE
                        StringF(cmd,'S:\s',defs)
                    ENDIF
                ELSE
                    Raise(ER_LIST)
                ENDIF
            ELSE
                Raise(ER_REQTOOLSLIB)
            ENDIF
            remENV()
        ELSE
            Raise(ER_INITENV)
        ENDIF
    ELSE
        Raise(ER_BADARGS)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    IF openscreen
        IF screen THEN CloseScreen(screen)
    ENDIF
    IF rdargs THEN FreeArgs(rdargs)
    IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
    SELECT exception
        CASE ER_ONLYCLI;        WriteF('seulement en cli..\n')
        CASE ER_BADARGS;        WriteF('Mauvais arguments..\n')
        CASE ER_REQTOOLSLIB;    WriteF('retools.library v37 ??..\n')
        CASE ER_LIST;           WriteF('Erreur de création de la liste..\n')
        CASE ER_INITENV;        WriteF('''makedir ram:env'' ou ''assign env: ram:env'' impossible..\n')
    ENDSELECT
    IF test=TRUE
        WriteF('Executing \s\n',cmd)
    ELSE
        IF dorun=FALSE
            Execute(cmd,0,stdout)
        ELSE
            myExecute(cmd,'S:')
        ENDIF
    ENDIF
ENDPROC
/**/
/*"initEnv()"*/
PROC initEnv()
    DEF r,lock,d,dl
    IF test=FALSE
        lock:=CreateDir('Ram:ENV')
        IF lock=0 THEN RETURN FALSE
        UnLock(lock)
        IF d:=Lock('Ram:ENV',-2)
            dl:=DupLock(d)
            UnLock(d)
            r:=AssignLock('ENV',dl)
            RETURN TRUE
        ELSE
            RETURN FALSE
        ENDIF
    ELSE
        RETURN TRUE
    ENDIF
ENDPROC
/**/
/*"remENV()"*/
PROC remENV()
    IF test=FALSE
        AssignLock('ENV',NIL)
        DeleteFile('Ram:ENV')
    ENDIF
ENDPROC
/**/
/*"makeFileList()"*/
PROC makeFileList()
    DEF er
    DEF i:PTR TO fileinfoblock
    DEF anchor=NIL:PTR TO anchorpath
    DEF name[256]:STRING
    slist:=p_InitList()
    anchor:=New(SIZEOF anchorpath+250)
    anchor.strlen:=249
    er:=MatchFirst('S:startup#?',anchor)
    WHILE er=0
        i:=anchor.info
        StringF(name,'\s',i.filename)
        IF EstrLen(name)<>16
            p_AjouteNode(slist,name,0)
        ENDIF
        er:=MatchNext(anchor)
    ENDWHILE
    MatchEnd(anchor)
    Dispose(anchor)
ENDPROC
/**/
/*"makeRequest()"*/
PROC makeRequest()
    DEF n:PTR TO ln,c=1
    DEF pv[256]:STRING
    n:=slist.head
    WHILE n
        IF n.succ<>0
            StringF(pv,'(\d[2]) ->\l\s[32]\n',c,n.name)
            StrAdd(reqtexte,pv,ALL)
            StringF(pv,'_\d|',c)
            StrAdd(reqgad,pv,ALL)
            c:=c+1
        ENDIF
        n:=n.succ
    ENDWHILE
    StrAdd(reqgad,'_By NasGûl',ALL)
ENDPROC
/**/
/*"myExecute(cmd,dir)"*/
PROC myExecute(cmd,dir) HANDLE
    DEF ofh:PTR TO filehandle
    DEF ifh:PTR TO filehandle
    DEF newct=NIL:PTR TO mp
    DEF oldct:PTR TO mp
    DEF oldcd=NIL
    DEF newcd=NIL
    DEF test
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
                         NP_STACKSIZE,4096,
                         NP_PRIORITY,0,
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
/*"openScreen()"*/
PROC openScreen() HANDLE
    DEF ps:PTR TO screen
    IF (ps:=OpenScreenTagList(NIL,          /* get ourselves a public screen */
                                 [SA_TOP,0,
                                  SA_DEPTH,3,             /*                         */
                                  SA_FONT,['topaz.font',8,0,0]:textattr,              /*                         */
                                  SA_DISPLAYID,HIRES_KEY,          /* le champ SA_DISPLAYID           */
                                  SA_PUBNAME,'ReqUserStartupScreen',
                                  SA_TITLE,'ReqUserStartup v0.1 © 1995 NasGûl',
                                  SA_AUTOSCROLL,TRUE,
                                  SA_TYPE,CUSTOMSCREEN+PUBLICSCREEN,
                                  SA_OVERSCAN,OSCAN_TEXT,
                                  SA_PENS,[0,1,1,2,1,3,1,0,2,1,2,1]:INT,    /* Répartition de couleurs WB 2.0 */
                                  SA_DETAILPEN,1,            /* Detailpen */
                                  SA_BLOCKPEN,2,             /* BlockPen  */
                                  0,0]))=NIL THEN Raise(ER_SCREEN)
    screen:=ps
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
