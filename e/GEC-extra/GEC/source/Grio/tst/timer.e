
MODULE 'exec/ports' , 'exec/io'
MODULE 'devices/timer'

PROC main()

   DEF tr:PTR TO timerequest
   DEF port:PTR TO mp
   DEF sec=0

   IF (port:=CreateMsgPort())
      IF (tr:=CreateIORequest(port,SIZEOF timerequest))
         IF OpenDevice('timer.device',UNIT_MICROHZ,tr,0)=NIL
            tr.io.command:=TR_ADDREQUEST
            tr.time.secs:=1
            tr.time.micro:=0
            SendIO(tr)
            REPEAT
               INC sec
               WriteF('second \d\n',sec)
               Wait(Shl(1,port.sigbit))
               tr.time.secs:=1
               tr.time.micro:=0
               SendIO(tr)
            UNTIL sec=20
            AbortIO(tr)
            WaitIO(tr)
            CloseDevice(tr)
         ENDIF
         DeleteIORequest(tr)
      ENDIF
      DeleteMsgPort(port)
   ENDIF


ENDPROC



