OPT MODULE
OPT REG=5

MODULE 'dos/dosasl' , 'dos/dos'




EXPORT PROC fileinpathlist(filename)

  DEF lock , pthlst , duplock=NIL


   Lock(filename,SHARED_LOCK)
   MOVE.L  D0,lock
   BEQ.S   start
   UnLock(lock)
   lock:=CurrentDir(NIL)
   duplock:=DupLock(lock)
   CurrentDir(lock)
   BRA.S  quit
   
start:
   Cli()
   MOVEA.L   D0,A0
   MOVE.L    8(A0),D0
   BEQ.B     ccheck
loop:
   LSL.L     #2,D0         -> PathList
   MOVE.L    D0,pthlst
   MOVE.L    D0,A0
   MOVE.L    4(A0),lock
   fileinlock(lock,filename)
   TST.L     D0
   BNE.B     getname
   
   MOVEA.L   pthlst,A0
   MOVE.L    (A0),D0 
   BNE.B     loop
  
ccheck:

   lock:=fileinassign('C:',filename)

getname:

   IF lock THEN duplock:=DupLock(lock)

quit:

ENDPROC duplock


EXPORT PROC fileinlock(lock,filename)

 DEF fib:fileinfoblock ,cd , id=FALSE , file
   
 IF (cd:=CurrentDir(lock))
    IF (file:=Lock(filename,SHARED_LOCK))
        Examine(file,fib)
        IF fib.direntrytype<0 THEN id:=TRUE
        UnLock(file)
    ENDIF
    CurrentDir(cd)
 ENDIF
   
ENDPROC id



EXPORT PROC fileinassign(assignname,filename)

  DEF dp=NIL , lock

   IF (lock:=Lock(assignname,SHARED_LOCK))
      UnLock(lock)
      testnext:
      IF (dp:=GetDeviceProc(assignname,dp))
          MOVEA.L  dp,A0
          MOVE.L   4(A0),lock       
          IF fileinlock(lock,filename)=FALSE
             MOVEA.L  dp,A0
             TST.L    8(A0)
             BNE.B    testnext
             lock:=NIL
          ENDIF
          FreeDeviceProc(dp)
      ELSE
          lock:=NIL
      ENDIF
   ENDIF

ENDPROC lock





