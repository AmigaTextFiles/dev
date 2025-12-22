
OPT MODULE



MODULE 'exec/ports' , 'exec/io'
MODULE 'devices/timer'

MODULE 'grio/ports','grio/io'


EXPORT OBJECT time
   signal  : LONG
   port    : LONG
   trio    : LONG
   PRIVATE
   devopen : LONG
ENDOBJECT



PROC new(unit=UNIT_MICROHZ) OF time

 DEF port:PTR TO mp , tr:PTR TO timerequest

 IF port:=createPort()
    self.port:=port
    IF tr:=createExtIO(port,SIZEOF timerequest)
       self.trio:=tr
       IF OpenDevice('timer.device',unit,tr,0)=NIL
          self.devopen:=TRUE
          self.signal:=Shl(1,port.sigbit)
	  RETURN self.signal
       ENDIF
    ENDIF
 ENDIF

ENDPROC FALSE



PROC end() OF time

 DEF tr

 IF tr:=self.trio
    IF self.devopen
       self.break()
       CloseDevice(tr)
    ENDIF
    deleteExtIO(tr)
 ENDIF
 deletePort(self.port)

ENDPROC



PROC delay(sec,mic) OF time

 DEF tr:PTR TO timerequest

 self.break()
 tr:=self.trio
 tr::io.command:=TR_ADDREQUEST
 tr.time.secs:=sec
 tr.time.micro:=mic
 beginIO(tr)

ENDPROC


PROC break() OF time

 IF CheckIO(self.trio)=NIL
    AbortIO(self.trio)
    WaitIO(self.trio)
 ENDIF

ENDPROC



