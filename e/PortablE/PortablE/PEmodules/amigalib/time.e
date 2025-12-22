OPT MODULE, POINTER

MODULE 'amigalib/io',
       'amigalib/ports',
       'devices/timer',
       'exec/io'
MODULE 'exec/ports', 'exec'

PROC timeDelay(unit, seconds, micros)
	DEF port:PTR TO mp, io:PTR TO io, tr:PTR TO timerequest, error:BOOL
	error := TRUE
	IF port:=createPort(NILA, 0)
		IF io:=createExtIO(port, SIZEOF timerequest)
			tr := io !!PTR!!PTR TO timerequest
			IF OpenDevice('timer.device', unit, io, 0)=0
				tr.time.secs:=seconds !!LONG
				tr.time.micro:=micros !!LONG
				tr.io.command:=TR_ADDREQUEST
				DoIO(io)
				CloseDevice(io)
				error:=FALSE
			ENDIF
			deleteExtIO(io)
		ENDIF
		deletePort(port)
	ENDIF
ENDPROC error
