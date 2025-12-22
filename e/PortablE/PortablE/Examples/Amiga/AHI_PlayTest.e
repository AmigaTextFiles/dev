/* A C example converted to PortablE.
   From http://aminet.net/driver/audio/m68k-amigaos-ahidev.lha/Developer/Examples/Device/PlayTest/PlayTest.c */
/*
** This program uses the device interface to play a sampled sound.
** The input is read from THE DEFAULT INPUT, make sure you
** start it with "PlayTest pri < mysample.raw" !
** Where pri is a number from -128 to +127 (may be omitted)
** The sample should be 8 bit signed, mono (see TYPE).
**
** PLEASE NOTE that earlier versions of this example contained a bug
** that sometimes DeleteIORequest'ed a pointer that was AllocMem'ed!
*/

OPT POINTER
MODULE 'dos', 'exec'
MODULE 'devices/ahi'
MODULE 'std/pShell'

CONST FREQUENCY  = 8000
CONST TYPE       = AHIST_M8S
CONST BUFFERSIZE = 20000

DEF ahiMP:PTR TO mp
DEF ahiIOs[2]:ARRAY OF PTR TO ahirequest
DEF ahiIO    :PTR TO ahirequest
DEF ahiIOcopy:PTR TO ahirequest
DEF ahiDevice=-1

DEF buffer1[BUFFERSIZE]:ARRAY OF BYTE
DEF buffer2[BUFFERSIZE]:ARRAY OF BYTE

PROC main()
	DEF p1:ARRAY OF BYTE, p2:ARRAY OF BYTE
	DEF tmp:ARRAY
	DEF signals, length
	DEF link:PTR TO ahirequest, reply:PTR TO ahirequest
	DEF pri:BYTE
	
	ahiIOs[0] := ahiIOs[1] := NIL
	p1 := buffer1 ; p2 := buffer2
	
	pri := Val(ShellArgs()) !!BYTE		->defaults to 0
	Print('Sound priority: \d\n', pri)
	
	IF ahiMP := CreateMsgPort()
		IF ahiIO := CreateIORequest(ahiMP, SIZEOF ahirequest)
			ahiIO.version := 4
			ahiDevice := OpenDevice(ahiname, 0, ahiIO !!PTR!!PTR TO io, NIL)
		ENDIF
	ENDIF
	
	IF ahiDevice
		Print('Unable to open \s/0 version 4\n', ahiname)
		cleanup(RETURN_FAIL)
	ENDIF
	
	->Make a copy of the request (for double buffering)
	NEW ahiIOcopy
	MemCopy(ahiIOcopy, ahiIO, SIZEOF ahirequest)
	ahiIOs[0] := ahiIO
	ahiIOs[1] := ahiIOcopy
	
	SetIoErr(0)
	LOOP
		->Fill buffer
		length := Read(Input(), p1, BUFFERSIZE)
		
		->Play buffer
		ahiIOs[0].iostd.mn.ln.pri := pri
		ahiIOs[0].iostd.command   := CMD_WRITE
		ahiIOs[0].iostd.data      := p1
		ahiIOs[0].iostd.length    := length
		ahiIOs[0].iostd.offset    := 0
		ahiIOs[0].frequency     := FREQUENCY
		ahiIOs[0].type          := TYPE
		ahiIOs[0].volume        := $10000          ->Full volume
		ahiIOs[0].position      := $8000           ->Centered
		ahiIOs[0].link          := link
		SendIO(ahiIOs[0] !!PTR!!PTR TO io)
		
		IF link
			->Wait until the last buffer is finished (== the new buffer is started)
			signals := Wait(1 SHL ahiMP.sigbit OR SIGBREAKF_CTRL_C)
			
			->Check for Ctrl-C and abort if pressed
			IF signals AND SIGBREAKF_CTRL_C
				SetIoErr(ERROR_BREAK)
				Raise("BRK")
			ENDIF
			
			->Remove the reply and abort on error
			WHILE reply := GetMsg(ahiMP) !!PTR!!PTR TO ahirequest
				IF reply.iostd.error
					SetIoErr(ERROR_WRITE_PROTECTED)
					Raise("ERR")
				ENDIF
			ENDWHILE
		ENDIF
		
		->Check for end-of-sound, and wait until it is finished before aborting
		IF length <> BUFFERSIZE
			WaitIO(ahiIOs[0] !!PTR!!PTR TO io)
			Raise(0)
		ENDIF
		
		link := ahiIOs[0]
		
		->Swap buffer and request pointers, and restart
		tmp    := p1
		p1     := p2
		p2     := tmp
		
		tmp    := ahiIOs[0]
		ahiIOs[0] := ahiIOs[1]
		ahiIOs[1] := tmp
	ENDLOOP
FINALLY
	IF ahiDevice = 0
		->Abort any pending iorequests
		AbortIO(ahiIOs[0] !!PTR!!PTR TO io)
		WaitIO( ahiIOs[0] !!PTR!!PTR TO io)
		
		IF link
			->Only if the second request was started
			AbortIO(ahiIOs[1] !!PTR!!PTR TO io)
			WaitIO( ahiIOs[1] !!PTR!!PTR TO io)
		ENDIF
	ENDIF
	
	IF IoErr()
		PrintFault(IoErr(), ProgramName())
		cleanup(RETURN_ERROR)
	ENDIF
	
	cleanup(RETURN_OK)
ENDPROC

PROC cleanup(rc)
	IF ahiDevice = 0
		CloseDevice(    ahiIO !!PTR!!PTR TO io)
		DeleteIORequest(ahiIO !!PTR!!PTR TO io)
		END ahiIOcopy
		DeleteMsgPort(ahiMP)
		CleanUp(rc)
	ENDIF
ENDPROC
