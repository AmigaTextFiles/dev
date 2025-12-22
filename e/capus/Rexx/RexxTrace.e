/********************************************************************************
 * << EUTILS HEADER >>
 ********************************************************************************
 ED         "edg"
 EC         "ec -e"
 PREPRO     "epp -t"
 SOURCE     "RexxTrace.e"
 EPPDEST    "R_EPP.e"
 EXEC       "RexxTRace"
 ISOURCE    ""
 VERSION    "0"
 REVISION   "0"
 NAMEPRG    "RexxTRace"
 NAMEAUTHOR "NasGûl"
 ********************************************************************************
 * HISTORY :
 *******************************************************************************/

MODULE 'exec/ports','exec/nodes','exec/lists'
MODULE 'rexxsyslib','rexx/rxslib','rexx/storage','rexx/errors'
MODULE 'eropenlib','verslib'
ENUM ER_NONE,ER_BADARGS,ER_PORT
DEF action
DEF myport:PTR TO mp
PROC main() HANDLE /*"main()"*/
    DEF myargs:PTR TO LONG,rdargs=NIL
    myargs:=[0,0]
    IF ReadArgs('OPEN/S,CLOSE/S',myargs,NIL)
        IF myargs[0] THEN action:=RXTCOPN
        IF myargs[1] THEN action:=RXTCCLS
        FreeArgs(rdargs)
    ELSE
        Raise(ER_BADARGS)
    ENDIF
    IF (rexxsysbase:=OpenLibrary('rexxsyslib.library',VERS_REXXSYSLIB))=NIL THEN Raise(ER_REXXSYSLIBLIB)
    IF (myport:=CreateMsgPort())=NIL THEN Raise(ER_PORT)
    p_SendRexxMsg()
    Raise(ER_NONE)
EXCEPT
    IF myport THEN DeleteMsgPort(myport)
    IF rexxsysbase THEN CloseLibrary(rexxsysbase)
ENDPROC
PROC p_SendRexxMsg() /*"p_SendRexxMsg()"*/
    DEF rc=FALSE
    DEF rxmsg:PTR TO rexxmsg
    DEF ap:PTR TO mp
    DEF test:PTR TO LONG
    DEF execmsg:PTR TO mn
    DEF node:PTR TO ln
    IF rxmsg:=CreateRexxMsg(myport,NIL,NIL)
        execmsg:=rxmsg
        node:=execmsg
        node.name:='RexxTRace'
        node.type:=NT_MESSAGE
        node.pri:=0
        execmsg.replyport:=myport
        IF test:=CreateArgstring('',EstrLen(''))
            CopyMem({test},rxmsg.args,4)
            rxmsg.action:=action
            rxmsg.passport:=myport
            rxmsg.stdin:=Input()
            rxmsg.stdout:=Output()
            Forbid()
            ap:=FindPort('REXX')
            IF ap
                PutMsg(ap,rxmsg)
            ENDIF
            Permit()
            IF ap
                WaitPort(myport)
                GetMsg(myport)
                rc:=rxmsg.result1
                IF rc<>0
                    WriteF('RETURN Code \d \d\n',rc,rxmsg.result2)
                ENDIF
            ELSE
                WriteF('REXX not Actif.\n')
            ENDIF
            ClearRexxMsg(rxmsg,16)
        ENDIF
        DeleteRexxMsg(rxmsg)
    ENDIF
ENDPROC



