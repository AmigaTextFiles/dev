OPT MODULE
OPT REG=5

MODULE 'exec/memory','exec/tasks','exec/ports',
       'exec/tasks','exec/execbase'
MODULE 'dos/dos','dos/dosextens'
MODULE 'grio/taskname'


OBJECT idata
signal:LONG
task:LONG
next:PTR TO idata
ENDOBJECT

OBJECT segdata
procaddr,argdata,inuse,loop,maintask,launched
idata:PTR TO idata,launchertask:PTR TO process
ENDOBJECT


OBJECT thread
next:PTR TO thread
segptr:LONG
segdata:PTR TO segdata
name:PTR TO CHAR
pri:LONG
stack:LONG
ident:LONG
freeze:LONG
task:PTR TO process
ENDOBJECT


EXPORT OBJECT threads
PRIVATE
thlist:PTR TO thread
count:LONG
launched:LONG
ENDOBJECT



PROC makeseg(procadr)
DEF code,size,data,segsize,tc
size:={endfakeseg}-{fakeseg}
segsize:=(size+SIZEOF segdata+8+2) AND -4
IF (code:=New(segsize))
   tc:=FindTask(NIL)
   MOVEA.L  code,A0
   MOVE.L   segsize,(A0)+
   MOVE.L   A0,D0
   LSR.L    #2,D0
   MOVE.L   D0,code
   CLR.L    (A0)+
   MOVE.L   size,D1
   SUBQ.L   #4,D1   -> copy and stop before a4store
   LSR.L    #1,D1
   SUBQ.L   #1,D1
   LEA      fakeseg(PC),A1
copyloop:
   MOVE.W   (A1)+,(A0)+
   DBF      D1,copyloop
   MOVE.L   A4,(A0)+
   MOVE.L   A0,data     ->  save segdata
   MOVE.L   procadr,(A0)+
   CLR.L    (A0)+       -> argdata
   CLR.L    (A0)+       -> inuse
   CLR.L    (A0)+       -> loop
   MOVE.L   tc,(A0)+    -> maintask
   CLR.L    (A0)+       -> launched
   CLR.L    (A0)        -> idata
ENDIF
ENDPROC code,data


PROC fakeseg()
MOVEA.L   a4store(PC),A4
MOVE.L    execbase,A6
MOVE.L    #SIGBREAKF_CTRL_F,D0
JSR       Wait(A6)
LEA       endfakeseg(PC),A1
MOVEA.L   28(A1),A1      -> launchertask
MOVE.L    #SIGBREAKF_CTRL_F,D0
JSR       Signal(A6)
fakesegloop:
LEA       endfakeseg(PC),A0
MOVE.L    (A0)+,D0        -> procaddr
BEQ.S     clrfakeseg
MOVE.L    (A0)+,-(A7)     -> argdata
MOVEA.L   D0,A1
MOVEQ     #-1,D0
MOVE.L    D0,(A0)
JSR       (A1)
ADDQ.L    #4,A7
LEA       endfakeseg(PC),A1
TST.L     12(A1)          -> loopmode
BNE.S     fakesegloop
clrfakeseg:
LEA       endfakeseg(PC),A1
CLR.L     8(A1)          -> inuse
MOVE.L    24(A1),D1      -> idata
BEQ.S     noidata
MOVEA.L   execbase,A6
loopidata:
MOVEA.L   D1,A2
MOVE.L    (A2)+,D0       -> signal
MOVEA.L   (A2)+,A1       -> task
JSR       Signal(A6)
MOVE.L    (A2),D1
BNE.S     loopidata
LEA       endfakeseg(PC),A1
noidata:
MOVEA.L   20(A1),A1
SUBQ.L    #1,(A1)
ENDPROC D0
a4store:
          LONG   0
endfakeseg:



PROC freeseg(seg)
IF seg
   MOVE.L seg,D0
   LSL.L  #2,D0
   SUBQ.L #4,D0
   MOVE.L D0,seg
   Dispose(seg)
ENDIF
ENDPROC D0




/*
PROC segData(seg)
MOVE.L  seg,D0
LSL.L   #2,D0
MOVE.L  D0,A0
MOVE.L  -4(A0),D0
MOVEQ   #SIZEOF segdata+4,D1
SUB.L   D1,D0
ADD.L   A0,D0
ENDPROC D0
*/





PROC init(procaddr,name=NIL,pri=0,stack=8192,loop=FALSE) OF threads
DEF th:PTR TO thread,sdata:PTR TO segdata,seg=NIL,s=NIL,tname
IF (th:=New(SIZEOF thread))
   seg,sdata:=makeseg(procaddr)
   IF seg
      th.segptr:=seg
      th.segdata:=sdata
      sdata.launched:={self.launched}
      sdata.loop:=loop
      IF (s:=String(StrLen(IF name THEN name ELSE tname:=taskName())+4))
         th.name:=s
         self.count:=self.count+1
         th.ident:=self.count
         StringF(s,IF name THEN '\s' ELSE '\s.\d',IF name THEN name ELSE tname,th.ident)
         th.next:=self.thlist
         self.thlist:=th
         th.pri:=pri
         th.stack:=stack
         RETURN th.ident
      ENDIF
   ENDIF
ENDIF
Dispose(th)
freeseg(seg)
ENDPROC NIL


PROC rem(ident,force=FALSE) OF threads
DEF th:PTR TO thread,id:PTR TO idata,next
th:=self.get(ident)
IF th
   Forbid()
   IF th.segdata.inuse
      IF FindTask(th.name)=NIL
         th.segdata.inuse:=FALSE
      ELSE
         IF force
            RemTask(th.task)
            th.segdata.inuse:=FALSE
         ENDIF
      ENDIF
   ENDIF
   Permit()
   IF th.segdata.inuse=FALSE
      id:=th.segdata.idata
      WHILE id
         next:=id.next
         Dispose(id)
         id:=next
      ENDWHILE
      RETURN TRUE
   ENDIF
ENDIF
ENDPROC FALSE


PROC del(ident,force=FALSE) OF threads
DEF th:PTR TO thread,last:PTR TO thread
th,last:=self.get(ident)
IF th
   IF self.rem(ident,force)
      IF last
         last.next:=th.next
      ELSE
         self.thlist:=th.next
      ENDIF
      DisposeLink(th.name)
      freeseg(th.segptr)
      Dispose(th)
      RETURN TRUE
   ENDIF
ENDIF
ENDPROC FALSE


PROC get(ident) OF threads PRIVATE
DEF th=NIL:PTR TO thread,last=NIL,x
IF ident
   th:=self.thlist
   FOR x:=0 TO self.count
      EXIT th=NIL
      EXIT th.ident=ident
      last:=th
      th:=th.next
   ENDFOR
ENDIF
ENDPROC th,last


PROC launch(ident,argdata=NIL,loop=FALSE) OF threads
DEF th:PTR TO thread,pr:PTR TO process,next,id:PTR TO idata
th:=self.get(ident)
IF th
   IF th.segdata.inuse=FALSE
      id:=th.segdata.idata
      WHILE id
         next:=id.next
         Dispose(id)
         id:=next
      ENDWHILE
      th.segdata.argdata:=argdata
      th.segdata.loop:=loop
      th.segdata.launchertask:=FindTask(NIL)
      Forbid()
      IF (pr:=CreateProc(th.name,th.pri,th.segptr,th.stack))
         th.task:=pr-SIZEOF tc
         Signal(th.task,SIGBREAKF_CTRL_F)
      ENDIF
      Permit()
      IF pr
         Wait(SIGBREAKF_CTRL_F)
         self.launched:=self.launched+1
         RETURN TRUE
      ENDIF
   ENDIF
ENDIF
ENDPROC FALSE


PROC islaunched(ident=NIL) OF threads
DEF th:PTR TO thread
IF ident=NIL
   RETURN self.launched
ENDIF
th:=self.get(ident)
IF th
   RETURN th.segdata.inuse
ENDIF
ENDPROC FALSE



PROC freeze(ident,mode) OF threads
DEF th:PTR TO thread
th:=self.get(ident)
IF th
   mode:=mode<>FALSE
   IF th.freeze<>mode
      Forbid()
      IF th.segdata.inuse
         Remove(th.task)
         th.freeze:=mode
         IF mode
            th.task::tc.flags:=TF_ETASK
            AddTail(execbase::execbase.taskwait,th.task)
         ELSE
            th.task::tc.flags:=TS_READY
            AddTail(execbase::execbase.taskready,th.task)
         ENDIF
      ENDIF
      Permit()
   ENDIF
ENDIF
ENDPROC mode


PROC isfreezed(ident) OF threads
DEF th:PTR TO thread
th:=self.get(ident)
IF th THEN RETURN th.freeze
ENDPROC FALSE      


PROC numberofthreads() OF threads
DEF th:PTR TO thread,num=NIL
th:=self.thlist
WHILE th
    INC num
    th:=th.next
ENDWHILE
ENDPROC num


PROC findident(name) OF threads
DEF th:PTR TO thread
th:=self.thlist
WHILE th
    IF StrCmp(th.name,name)
       RETURN th.ident
    ENDIF
    th:=th.next
ENDWHILE
ENDPROC 0

PROC task(ident) OF threads
DEF th:PTR TO thread
IF (th:=self.get(ident))
    RETURN th.task
ENDIF
ENDPROC NIL


PROC wait4end(ident) OF threads
DEF th:PTR TO thread
IF (th:=self.get(ident))
   WHILE th.segdata.inuse DO Delay(5)
ENDIF
ENDPROC D0


PROC signalonend(ident,signal=SIGBREAKF_CTRL_F,task=NIL) OF threads
DEF th:PTR TO thread,id:PTR TO idata
IF (th:=self.get(ident))
   IF (id:=New(SIZEOF idata))
      id.next:=th.segdata.idata
      th.segdata.idata:=id
      id.signal:=signal
      id.task:=IF task=NIL THEN FindTask(NIL) ELSE task
      RETURN TRUE
   ENDIF
ENDIF
ENDPROC FALSE


PROC setname(ident,name) OF threads
DEF th:PTR TO thread,s
th:=self.get(ident)
IF th
   IF (s:=String(StrLen(name)))
      StrCopy(s,name)
      DisposeLink(th.name)
      th.name:=s
      RETURN TRUE
   ENDIF
ENDIF
ENDPROC FALSE


PROC setloop(ident,mode) OF threads
DEF th:PTR TO thread
th:=self.get(ident)
IF th
   th.segdata.loop:=mode
   RETURN TRUE
ENDIF
ENDPROC FALSE

/*
PROC setproc(ident,procaddr,argdata=NIL) OF threads
DEF th:PTR TO thread
IF (th:=self.get(ident))
   th.segdata.procaddr:=procaddr
   th.segdata.argdata:=argdata
   RETURN TRUE
ENDIF
ENDPROC FALSE
*/


PROC end() OF threads
WHILE self.thlist
    self.del(self.thlist.ident,TRUE)
ENDWHILE
ENDPROC D0













