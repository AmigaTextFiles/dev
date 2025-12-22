OPT MODULE

MODULE 'grio/partutils','dos/dos','grio/str/sprintf'


EXPORT PROC setupLHA(temppath,cmdfile)
 DEF buf
 MOVE.L  cmd(PC),D0
 BNE.S   clean
 MOVE.L  path(PC),D0
 BEQ.S   begin
 clean:
  cleanLHA()
 begin:
 IF Open({nil},OLDFILE)
    LEA    in(PC),A0
    MOVE.L D0,(A0)
    IF Open({nil},NEWFILE)
       LEA    out(PC),A0
       MOVE.L D0,(A0)
       IF (buf:=AllocMem(258,1))
	  AstrCopy(buf,temppath,ALL)
	  addpart(buf,'LHA-Temp',256)
	  LEA    path(PC),A0
	  MOVE.L buf,(A0)+
	  MOVE.L cmdfile,(A0)
	  RETURN TRUE
       ENDIF
    ENDIF
 ENDIF
ENDPROC cleanLHA()

path:
   LONG 0
cmd:
   LONG 0
in:
   LONG 0
out:
   LONG 0
nil:
   CHAR  'NIL:',0,0


EXPORT PROC unArchLHA(name)
 DEF bufcmd[320]:ARRAY,cmdf,pathf,lock
 MOVE.L  cmd(PC),cmdf
 BEQ     quitunarch
 MOVE.L  path(PC),pathf
 BEQ     quitunarch
 sprintf(bufcmd,'\s "\s" "\s/"',[cmdf,name,pathf])
 IF (lock:=Lock(pathf,SHARED_LOCK))=NIL
    lock:=CreateDir(pathf)
 ENDIF
 IF lock
    UnLock(lock)
    MOVE.L  D3,-(A7)
    MOVE.L  bufcmd,D1
    MOVE.L  in(PC),D2
    MOVE.L  out(PC),D3
    MOVEA.L dosbase,A6
    JSR     Execute(A6)
    MOVE.L  (A7)+,D3
    RETURN D0
 ENDIF
 quitunarch:
ENDPROC NIL


EXPORT PROC clearTempLHA()
DEF dir
 MOVE.L path(PC),dir
 BEQ.S  quitclear
 deleteindir(dir)
quitclear:
ENDPROC

PROC deleteindir(dir)
DEF lock,fib:fileinfoblock,cd
 IF (lock:=Lock(dir,SHARED_LOCK))
    cd:=CurrentDir(lock)
    Examine(lock,fib)
    WHILE ExNext(lock,fib)
	  EXIT IoErr()=ERROR_NO_MORE_ENTRIES
	  IF fib.direntrytype>0
	     deleteindir(fib.filename)
	  ELSE
	     SetProtection(fib.filename,NIL)
	  ENDIF
	  DeleteFile(fib.filename)
    ENDWHILE
    CurrentDir(cd)
    UnLock(lock)
 ENDIF
ENDPROC



EXPORT PROC cleanLHA()
 clearTempLHA()
 MOVE.L  path(PC),D1
 BEQ.S   skipdel
 MOVEA.L dosbase,A6
 JSR     DeleteFile(A6)
 MOVE.L  in(PC),D1
 JSR     Close(A6)
 MOVE.L  out(PC),D1
 JSR     Close(A6)
 MOVEA.L path(PC),A1
 MOVE.L  #258,D0
 MOVEA.L execbase,A6
 JSR     FreeMem(A6)
 skipdel:
 LEA     path(PC),A0
 CLR.L   (A0)+
 CLR.L   (A0)+
 CLR.L   (A0)+
 CLR.L   (A0)
ENDPROC NIL


EXPORT PROC getNameLHA(buf,pos)
 DEF lock,fib:fileinfoblock,pathg,x=0,y=-1
 MOVE.L  path(PC),pathg
 IF (lock:=Lock(pathg,-2))
    Examine(lock,fib)
    INC pos
    REPEAT
      DEC pos
      y:=ExNext(lock,fib)
      IF (y=0) OR (IoErr()=ERROR_NO_MORE_ENTRIES)
	 x:=0
	 JUMP exitloop
      ENDIF
    UNTIL pos=0
    x:=fib.direntrytype
    AstrCopy(buf,pathg,ALL)
    addpart(buf,fib.filename,512)
    exitloop:
    UnLock(lock)
 ENDIF
ENDPROC x


