
OPT OSVERSION=37

CONST MAXPATH=250

ENUM ER_NONE,ER_BADARGS,ER_NOPORT,ER_PORT,ER_ARG

MODULE 'dos/dos','dos/dosasl','utility'
MODULE 'eropenlib','exec/ports','exec/nodes','wvprefs'
DEF whatviewport:PTR TO mp
DEF dummyport:PTR TO mp
DEF action[256]:STRING
DEF currentdir[256]:STRING
DEF file=FALSE
PROC main() HANDLE /*"main()"*/
    DEF myarg:PTR TO LONG,rdargs=NIL
    DEF dirw[100]:STRING,fib:fileinfoblock
    DEF lock
    WriteF('WhatIs v0.1 © 1994 NasGûl.\n')
    myarg:=[0,0,0,0]
    IF (utilitybase:=OpenLibrary('utility.library',37))=NIL THEN Raise(ER_UTILITYLIB)
    IF (whatviewport:=FindPort('WhatViewPort'))=NIL THEN Raise(ER_NOPORT)
    IF (dummyport:=CreateMsgPort())=NIL THEN Raise(ER_PORT)
    IF rdargs:=ReadArgs('DOSSIER,ACT/K,FLUSH/S,PREFS/S',myarg,NIL)
        IF myarg[0] 
            StrCopy(dirw,myarg[0],ALL)
        ELSE
            Raise(ER_ARG)
        ENDIF
        IF myarg[1] 
            StrCopy(action,myarg[1],ALL)
            UpperStr(action)
        ELSE
            StrCopy(action,'WHATVIEW',ALL)
        ENDIF
        IF myarg[2]
            p_SendWhatviewMessage('FLUSH','SYS:')
            Raise(ER_NONE)
        ENDIF
        IF myarg[3]
            p_SendWhatviewMessage('PREFS','SYS:')
            Raise(ER_NONE)
        ENDIF
        IF lock:=Lock('',-2)
            NameFromLock(lock,currentdir,256)
            UnLock(lock)
        ENDIF
        IF lock:=Lock(dirw,-2)
            IF Examine(lock,fib)
                IF fib.direntrytype>0
                    AddPart(dirw,'#?',100)
                    file:=FALSE
                ELSE
                    file:=TRUE
                ENDIF
            ENDIF
            UnLock(lock)
        ENDIF
        p_RecDir(dirw)
        Raise(ER_NONE)
    ELSE
        Raise(ER_BADARGS)
    ENDIF
EXCEPT
    IF rdargs THEN FreeArgs(rdargs)
    IF dummyport THEN DeleteMsgPort(dummyport)
    IF utilitybase THEN CloseLibrary(utilitybase)
    SELECT exception
        CASE ER_BADARGS;    WriteF('Mauvais Arguments.\n')
        CASE ER_UTILITYLIB; WriteF('Utility.library v37+ ?.\n')
        CASE ER_NOPORT;     WriteF('Port WhatViewPort inexistant.\n')
        CASE ER_PORT;       WriteF('Impossible de créer un port de message.\n')
        CASE ER_ARG;        WriteF('1 Argument manquant (Dossier ou Fichier ou Pattern).\n')
    ENDSELECT
ENDPROC
PROC p_RecDir(dirr) HANDLE /*"p_RecDir(dirr)"*/
  DEF er,i:PTR TO fileinfoblock,size=0,anchor=NIL:PTR TO anchorpath,fullpath
  DEF pos,rdir[100]:STRING,reelname[256]:STRING
  anchor:=New(SIZEOF anchorpath+MAXPATH)
  anchor.breakbits:=4096
  anchor.strlen:=MAXPATH-1
  er:=MatchFirst(dirr,anchor)                   /* collect all strings */
  WHILE er=0
    fullpath:=anchor+SIZEOF anchorpath
    i:=anchor.info
    pos:=InStr(fullpath,i.filename,0)
    IF pos<>0
        MidStr(rdir,fullpath,0,pos)
    ELSE
        StrCopy(rdir,currentdir,ALL)
    ENDIF
    StringF(reelname,'\s',i.filename)
    p_SendWhatviewMessage(reelname,rdir)
    er:=MatchNext(anchor)
  ENDWHILE
  IF StrCmp(action,'WHATVIEW',8)
      p_SendWhatviewMessage('WHATVIEW',0)
  ELSEIF StrCmp(action,'INFO',4)
      p_SendWhatviewMessage('INFO',0)
  ELSEIF StrCmp(action,'ADDICON',7)
      p_SendWhatviewMessage('ADDICON',0)
  ELSEIF StrCmp(action,'EXECUTE',7)
      p_SendWhatviewMessage('EXECUTE',0)
  ELSEIF StrCmp(action,'QUIT',4)
      p_SendWhatviewMessage('QUIT',0)
  ENDIF
  IF er<>ERROR_NO_MORE_ENTRIES THEN Raise(er)
  MatchEnd(anchor)
  Dispose(anchor)
  anchor:=NIL
  Raise(ER_NONE)
EXCEPT                                  /* nested exception handlers! */
  IF anchor THEN MatchEnd(anchor)
  Raise(exception)  /* this way, we call _all_ handlers in the recursion  */
ENDPROC size        /* and thus calling MatchEnd() on all hanging anchors */
PROC p_SendWhatviewMessage(name,curdir) HANDLE /*"p_SendWhatviewMessage(name,curdir)"*/
    DEF execmsg:PTR TO mn
    DEF mymsg:PTR TO wvmsg
    DEF node:PTR TO ln
    mymsg:=New(SIZEOF wvmsg)
    execmsg:=mymsg
    node:=execmsg
    node.type:=NT_MESSAGE
    node.pri:=0
    execmsg.replyport:=dummyport
    mymsg.name:=name
    mymsg.lock:=Lock(curdir,-2)
    Forbid()
    IF whatviewport
        PutMsg(whatviewport,mymsg)
    ENDIF
    Permit()
    IF whatviewport
        WaitPort(dummyport)
        GetMsg(dummyport)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    IF mymsg.lock THEN UnLock(mymsg.lock)
    IF mymsg THEN Dispose(mymsg)
ENDPROC

