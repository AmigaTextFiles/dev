OPT REG=5

MODULE 'dos/dos'

ENUM ERR_NONE,ERR_OS,ERR_ARGS,ERR_LOCK,ERR_STACK,ERR_BREAK,ERR_MEM

RAISE ERR_OS    IF KickVersion()=NIL
RAISE ERR_ARGS  IF ReadArgs()=NIL
RAISE ERR_LOCK  IF Lock()=NIL
RAISE ERR_STACK IF FreeStack()<1000
RAISE ERR_BREAK IF CtrlC()<>NIL
RAISE ERR_MEM   IF String()=NIL

ENUM APATH,AEXT,ADEEP

DEF args[3]:LONG,exlen

PROC main() HANDLE
  DEF rdargs=NIL
  KickVersion(36)
  args[ADEEP]:=NIL
  rdargs:=ReadArgs('PATH/A,EXT/A,DEEP/S',args,NIL)
  exlen:=StrLen(args[AEXT])
  extjob(args[APATH])
EXCEPT DO
  IF rdargs THEN FreeArgs(rdargs)
  IF exception
     SELECT exception
        CASE ERR_OS
            WriteF('kick v36 required\n')
        CASE ERR_ARGS
            WriteF('bad args\n')
        CASE ERR_BREAK
            WriteF('***break\n')
     ENDSELECT
  ENDIF
ENDPROC

PROC extjob(name) HANDLE
  DEF lock=0,cd=0,fib:fileinfoblock,dir[30]:STRING,file[30]:STRING,l
  DEF hd,hf,str[30]:STRING,s
  FreeStack()
  lock:=Lock(name,SHARED_LOCK)
  Examine(lock,fib)
  IF fib.direntrytype>0
     hd:=dir ; hf:=file
     WHILE ExNext(lock,fib)
          EXIT IoErr()=ERROR_NO_MORE_ENTRIES
          CtrlC()
          l:=StrLen(fib.filename)
          IF fib.direntrytype<0
             IF StriCmp(fib.filename+l-exlen,args[AEXT],ALL)
                Link(hf,s:=StrCopy(String(l),fib.filename,ALL))
                hf:=s
             ENDIF
          ELSEIF fib.direntrytype>0
             IF args[ADEEP]
                Link(hd,s:=StrCopy(String(l),fib.filename,ALL))
                hd:=s
             ENDIF
          ENDIF
     ENDWHILE
     cd:=CurrentDir(lock)
     hf:=file
     WHILE hf:=Next(hf)
         CtrlC()
         StrCopy(str,hf,EstrLen(hf)-exlen)
         s:=Rename(hf,str)
         WriteF('Renaming "\s" as "\s" ---> \s\n',hf,str,
                  IF s THEN 'success' ELSE 'failed')
     ENDWHILE
     hd:=dir
     IF Next(hd)
        WHILE hd:=Next(hd) DO extjob(hd)
     ENDIF
  ENDIF
EXCEPT DO
  IF cd   THEN CurrentDir(cd)
  IF lock THEN  UnLock(lock)
  DisposeLink(file)
  DisposeLink(dir)
  IF exception
     SELECT exception
        CASE ERR_LOCK
            WriteF('failed Lock() "\s" dir\n',name)
        CASE ERR_STACK
            WriteF('stack overflow\n')
        CASE ERR_MEM
            WriteF('no enought mem\n')
     ENDSELECT
     ReThrow()
  ENDIF
ENDPROC


CHAR '$VER: CutExt 1.0 (03.05.2000) by Grio!',$D,$A,0


