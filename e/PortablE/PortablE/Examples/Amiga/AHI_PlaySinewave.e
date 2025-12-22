/* AHI_PlaySinewave.e 22-07-2013
	Put in the Public Domain by Christopher Steven Handley.
*/
/*
This is an extremely simple example of how to open an AHI device, and send it
one message.  It does not check for errors, send multiple messages, nor handle
the case where the program wants to quit before AHI has finished.  For a more
complete example, please see "AHI_PlayTest.e" .


NOTE:  The "!!PTR!!PTR TO io" casts are required because AHI requests contain
the "iostd" object, while Amiga procedures expect plain "io" objects, and for
some strange reason it doesn't define "iostd" as containing "io".

You CAN use the much shorter "!!PTR" casts, and let PortablE automagically pick
the right pointer type, but I don't recommend this as it makes your code less
clear as to what your cast is doing.
*/
MODULE 'exec', 'exec/io', 'devices/ahi'

PROC main()
	DEF ahiMP:PTR TO mp, ahiIO:PTR TO ahirequest, ahiDevice, ahiIOmsg:PTR TO mn
	DEF sample:ARRAY OF BYTE, length, rate, freq, i
	
	->open AHI safely
	ahiDevice := 1
	IF ahiMP := CreateMsgPort()
		IF ahiIO := CreateIORequest(ahiMP, SIZEOF ahirequest)
			ahiIO.version := 4
			ahiDevice := OpenDevice(ahiname, 0, ahiIO !!PTR!!PTR TO io, NIL)
		ENDIF
	ENDIF
	IF ahiDevice THEN Throw("RES", 'Failed to open AHI device')
	
	->create a sinewave sound sample
	rate := 44100		->sample rate
	freq :=  4000		->sinewave frequency
	length := rate*1	->1 second length
	NEW sample[length]
	FOR i := 0 TO length-1 DO sample[i] := Fsin(2*3.141*i*freq/rate)+1/2*255-128 !!BYTE	->maths magic
	
	->create an AHI request
	ahiIO.iostd.mn.ln.pri := 0
	ahiIO.iostd.command   := CMD_WRITE
	ahiIO.iostd.data      := sample
	ahiIO.iostd.length    := length * SIZEOF BYTE
	ahiIO.iostd.offset    := 0
	ahiIO.frequency := rate
	ahiIO.type      := ahiType(8, FALSE)
	ahiIO.volume    := ahiVolume(100)
	ahiIO.position  := ahiPosition(0)
	ahiIO.link      := NIL
	
	->send AHI request(s)
	SendIO(ahiIO !!PTR!!PTR TO io)
	
	->wait for IO completion/error message from AHI
	REPEAT
		ahiIOmsg := GetMsg(ahiMP)
	UNTIL ahiIOmsg = ahiIO
FINALLY
	PrintException()
	
	IF ahiDevice = 0
		->clean-up
		CloseDevice(ahiIO !!PTR!!PTR TO io)
		DeleteIORequest(ahiIO !!PTR!!PTR TO io)
		DeleteMsgPort(ahiMP)
	ENDIF
	END sample
ENDPROC

PROC ahiType(bitsPerSample, stereo:BOOL) RETURNS ahiType
	IF stereo = FALSE
		SELECT bitsPerSample
		CASE  8 ; ahiType := AHIST_M8S
		CASE 16 ; ahiType := AHIST_M16S
		CASE 32 ; ahiType := AHIST_M32S
		DEFAULT ; Throw("BUG", 'ahiType(); unknown size')
		ENDSELECT
	ELSE
		SELECT bitsPerSample
		CASE  8 ; ahiType := AHIST_S8S
		CASE 16 ; ahiType := AHIST_S16S
		CASE 32 ; ahiType := AHIST_S32S
		DEFAULT ; Throw("BUG", 'ahiType(); unknown size')
		ENDSELECT
	ENDIF
ENDPROC

PROC ahiVolume(percentage:RANGE 0 TO 100) IS $10000*percentage/100

PROC ahiPosition(position:RANGE -100 TO 100) IS $8000*position/100 + $8000
