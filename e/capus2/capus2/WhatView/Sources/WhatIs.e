/*======<<< Peps Header >>>======
 PRGVERSION '0'
 ================================
 PRGREVISION '1'
 ================================
 AUTHOR      'NasGûl'
 ===============================*/

OPT OSVERSION=37

CONST MAXPATH=250

ENUM ER_NONE,ER_BADARGS,ER_NOPORT,ER_PORT,ER_ARG

MODULE 'dos/dos','dos/dosasl','utility'
MODULE 'eropenlib','exec/ports','exec/nodes','wvprefs'
DEF whatviewport:PTR TO mp
DEF dummyport:PTR TO mp
DEF action[256]:STRING
DEF file=FALSE
/*"main()"*/
PROC main() HANDLE 
    DEF myarg:PTR TO LONG,rdargs=NIL
    DEF dirw[100]:STRING,fib:fileinfoblock
    DEF lock
    VOID {banner}
    myarg:=[0,0,0,0]
    IF (utilitybase:=OpenLibrary('utility.library',37))=NIL THEN Raise(ER_UTILITYLIB)
    IF (whatviewport:=FindPort('WhatViewPort'))=NIL THEN Raise(ER_NOPORT)
    IF (dummyport:=CreateMsgPort())=NIL THEN Raise(ER_PORT)
    IF rdargs:=ReadArgs('DOSSIER,ACT/K,FLUSH/S,PREFS/S',myarg,NIL)
        IF myarg[2]
            p_SendWhatviewMessage('FLUSH',0)
            Raise(ER_NONE)
        ENDIF
        IF myarg[3]
            p_SendWhatviewMessage('PREFS',0)
            Raise(ER_NONE)
        ENDIF
        IF myarg[1] 
            StrCopy(action,myarg[1],ALL)
            UpperStr(action)
        ELSE
            StrCopy(action,'WHATVIEW',ALL)
        ENDIF
        IF StrCmp(action,'QUIT',4)
            p_SendWhatviewMessage('QUIT',0)
            Raise(ER_NONE)
        ENDIF
        IF myarg[0]
            StrCopy(dirw,myarg[0],ALL)
        ELSE
            Raise(ER_ARG)
        ENDIF
        IF lock:=Lock(dirw,-2)
            IF Examine(lock,fib)
                IF fib.direntrytype>0
                    IF myarg[4] THEN NOP ELSE AddPart(dirw,'#?',100)
                    file:=FALSE
                ELSE
                    file:=TRUE
                ENDIF
            ENDIF
            UnLock(lock)
            p_RecDir(dirw)
            Raise(ER_NONE)
        ELSE
            p_RecDir(dirw)
            Raise(ER_BADARGS)
        ENDIF
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
/**/
/*"p_RecDir(dirr)"*/
PROC p_RecDir(dirr) HANDLE
  DEF er,i:PTR TO fileinfoblock,size=0,anchor=NIL:PTR TO anchorpath,fullpath
  DEF rdir[100]:STRING,reelname[256]:STRING
  DEF ma:PTR TO achain,ii:PTR TO fileinfoblock
      anchor:=New(SIZEOF anchorpath+MAXPATH)
      anchor.breakbits:=4096
      anchor.strlen:=MAXPATH-1
      er:=MatchFirst(dirr,anchor)                   /* collect all strings */
      IF er=ERROR_NO_MORE_ENTRIES THEN JUMP exit
      WHILE er=0
        IF CtrlC() THEN JUMP exit
        fullpath:=anchor+SIZEOF anchorpath
        i:=anchor.info
        ma:=anchor.base
        ii:=ma.info
        NameFromLock(ma.lock,rdir,256)
        /*
        WriteF('*********** \s \d\n',ii.filename,ii.direntrytype)
        WriteF('DirEntryType: \d RDir \s ReelName \s\n',i.direntrytype,rdir,i.filename)
        */
        StringF(reelname,'\s',i.filename)
        p_SendWhatviewMessage(reelname,rdir)
        er:=MatchNext(anchor)
    ENDWHILE
  exit:
  p_DoAction()
  IF er<>ERROR_NO_MORE_ENTRIES THEN Raise(er)
  MatchEnd(anchor)
  Dispose(anchor)
  anchor:=NIL
  Raise(ER_NONE)
EXCEPT                                  /* nested exception handlers! */
  IF anchor THEN MatchEnd(anchor)
  Raise(exception)  /* this way, we call _all_ handlers in the recursion  */
ENDPROC size        /* and thus calling MatchEnd() on all hanging anchors */
/**/
/*"p_SendWhatviewMessage(name,curdir)"*/
PROC p_SendWhatviewMessage(name,curdir) HANDLE 
    DEF execmsg:PTR TO mn
    DEF mymsg:PTR TO wvmsg
    DEF node:PTR TO ln
    DEF rmsg
    mymsg:=New(SIZEOF wvmsg)
    execmsg:=mymsg
    node:=execmsg
    node.type:=NT_MESSAGE
    node.pri:=0
    execmsg.replyport:=dummyport
    mymsg.name:=name
    IF curdir<>0 THEN mymsg.lock:=Lock(curdir,-2)
    Forbid()
    IF whatviewport
        PutMsg(whatviewport,mymsg)
    ENDIF
    Permit()
    IF whatviewport
        WaitPort(dummyport)
        rmsg:=GetMsg(dummyport)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    IF curdir<>0
        IF mymsg.lock THEN UnLock(mymsg.lock)
    ENDIF
    IF mymsg THEN Dispose(mymsg)
ENDPROC
/**/
/*"p_DoAction()"*/
PROC p_DoAction()
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
ENDPROC
/**/

