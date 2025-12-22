OPT MODULE
OPT REG=5


MODULE 'exec/ports','exec/nodes','exec/interrupts',
       'exec/memory','exec/io','devices/timer'


MODULE 'grio/io','amigalib/lists','grio/taskname'



EXPORT OBJECT timersoftint
  intserv:PTR TO is
  iotime:PTR TO timerequest
  port:PTR TO mp
  PRIVATE
  secs,mics,devopen
  procedure,argdata
ENDOBJECT



PROC init(procedure,unit=UNIT_MICROHZ,pri=0) OF timersoftint
 DEF port:PTR TO mp,io:PTR TO timerequest,is:PTR TO is,name:PTR TO CHAR
 port:=io:=is:=NIL
 self.procedure:=procedure
 LEA    a4base(PC),A0
 MOVE.L A4,(A0)
 IF is:=AllocMem(SIZEOF is,MEMF_CLEAR OR MEMF_PUBLIC)
    self.intserv:=is
    is.code:={softintcode}
    is.data:=self
    is.ln.pri:=pri
    port:=taskName()
    IF name:=String(StrLen(port)+2)
       is.ln.name:=name
       StrCopy(name,port)
       IF port:=AllocMem(SIZEOF mp,MEMF_CLEAR OR MEMF_PUBLIC)
          self.port:=port
          newList(port.msglist)
          port.ln.type:=NT_MSGPORT
          port.flags:=PA_SOFTINT
          port.sigtask:=is    -> signal softinterrupt
          IF io:=createExtIO(port,SIZEOF timerequest)
             self.iotime:=io
             IF OpenDevice('timer.device',unit,io,NIL)=NIL
                self.devopen:=TRUE
                RETURN D0
             ENDIF
          ENDIF
       ENDIF
    ENDIF
 ENDIF
 self.end()
ENDPROC FALSE

a4base:
   LONG   0

PROC SAFE softintcode()
  DEF tsi:PTR TO timersoftint
  ->MOVEM.L  D2-D7/A2-A4/A6,-(A7)
  MOVE.L   A1,tsi   ->   A1 = is.data
  MOVEA.L  a4base(PC),A4
  IF GetMsg(tsi.port)
     IF tsi.secs=NIL
        VOID tsi.mics
        BEQ  skipproc
     ENDIF
     tsi.iotime::timerequest.time.secs:=tsi.secs
     tsi.iotime::timerequest.time.micro:=tsi.mics
     tsi.iotime::io.command:=TR_ADDREQUEST
     beginIO  (tsi.iotime)
     VOID     tsi.argdata
     MOVE.L   D0,-(A7)
     VOID     tsi.procedure
     MOVEA.L  D0,A0
     JSR      (A0)
     ADDQ.W   #4,A7
     skipproc:
  ENDIF
  ->MOVEM.L  (A7)+,D2-D7/A2-A4/A6
ENDPROC D0


PROC setinterval(micro,secs) OF timersoftint
  self.secs:=secs
  self.mics:=micro
ENDPROC D0


PROC start(data=0) OF timersoftint
  IF self.devopen
     IF self.mics=0
        IF self.secs=0 THEN RETURN FALSE
     ENDIF
     self.iotime::io.command:=TR_ADDREQUEST
     self.iotime::timerequest.time.secs:=self.secs
     self.iotime::timerequest.time.micro:=self.mics
     self.argdata:=data
     beginIO(self.iotime)
  ENDIF
ENDPROC TRUE


PROC stop() OF timersoftint
  IF self.devopen
     self.setinterval(0,0)
     IF CheckIO(self.iotime)=NIL
        AbortIO(self.iotime)
        WaitIO(self.iotime)
     ENDIF
  ENDIF
ENDPROC D0


PROC end() OF timersoftint
  IF self.devopen
     self.stop()
     CloseDevice(self.iotime)
     self.devopen:=FALSE
  ENDIF
  IF self.iotime
     deleteExtIO(self.iotime)
     self.iotime:=NIL
  ENDIF
  IF self.port
     FreeMem(self.port,SIZEOF mp)
     self.port:=NIL
  ENDIF
  IF self.intserv
     DisposeLink(self.intserv::ln.name)
     self.intserv::ln.name:=NIL
     FreeMem(self.intserv,SIZEOF is)
     self.intserv:=NIL
  ENDIF
ENDPROC D0




