/* cAmiga_Timer.e 06-09-2012
	An OOP class which provides a simple way to be informed of a one-off timed event.
	Copyright (c) 2012 Christopher Steven Handley ( http://cshandley.co.uk/email )
*/
OPT POINTER
MODULE 'exec', 'timer'

PROC main()
	DEF timer:OWNS PTR TO cTimer, signal, events, i
	
	Print('Test started\n')
	NEW timer.new()
	signal := timer.infoSignal()
	FOR i := 1 TO 3
		Print('Timer started\n')
		timer.start(1*1000000)
		REPEAT
			events := Wait(signal)
		UNTIL events AND signal
		timer.finished()
		Print('Timer finished\n')
	ENDFOR
	END timer
	Print('Test finished\n')
FINALLY
	PrintException()
	
	END timer
ENDPROC


CLASS cTimer PRIVATE
	port:PTR TO mp			->allocated port for timerequest
	tr  :PTR TO timerequest	->allocated timerequest
	started:BOOL
ENDCLASS

->NOTE: If periodInMicroSeconds is supplied, then it calls start() for you.
PROC new(periodInMicroSeconds=0) OF cTimer
	->use check
	IF periodInMicroSeconds < 0 THEN Throw("EMU", 'cTimer.new(); periodInMicroSeconds<=0')
	
	->initialise object so end() does nothing
	self.port := NIL
	self.tr   := NIL
	self.started := FALSE
	
	->create the timer
	self.port := CreateMsgPort()
	IF self.port = NIL THEN Throw("MEM", 'cTimer.new(); failed to allocate port')
	
	self.tr := CreateIORequest(self.port, SIZEOF timerequest) !!VALUE!!PTR
	IF self.tr = NIL THEN Throw("MEM", 'cTimer.new(); failed to allocate IO request')
	
	IF OpenDevice('timer.device', UNIT_MICROHZ, self.tr.io, 0) <> 0 THEN Throw("RES", 'cTimer.new(); failed to open timer.device')
	
	->start the timer, if requested
	IF periodInMicroSeconds <> 0 THEN self.start(periodInMicroSeconds)
ENDPROC

->Start the timer.
PROC start(periodInMicroSeconds) OF cTimer
	->use check
	IF periodInMicroSeconds <= 0 THEN Throw("EMU", 'cTimer.start(); periodInMicroSeconds<=0')
	IF self.started THEN Throw("EMU", 'cTimer.start(); the timer was already running')
	
	->initialise timer
	self.tr.io.command := TR_ADDREQUEST		->Initial iorequest to start
	self.tr.time.secs  := 0
	self.tr.time.micro := periodInMicroSeconds !!LONG ->MICRO_DELAY
	
	->start the timer
	SendIO(self.tr.io)
	self.started := TRUE
ENDPROC

->Call this after start(), if you don't want to wait for it to finish.
PROC halt() OF cTimer
	IF self.started = FALSE THEN Throw("EMU", 'cTimer.halt(); the timer was not running')
	AbortIO(self.tr.io)
	WaitIO( self.tr.io)
	SetSignal(0, self.infoSignal())	->clear the signal, since WaitIO() may not
	self.started := FALSE
ENDPROC

->Call this after start(), to wait for the timer to finish.
PROC wait() OF cTimer
	IF self.started = FALSE THEN Throw("EMU", 'cTimer.wait(); the timer was not running')
	WaitIO(self.tr.io)
	SetSignal(0, self.infoSignal())	->clear the signal, since WaitIO() may not
	self.started := FALSE
ENDPROC

->Call this after receiving a signal indicating the timer has finished.
PROC finished() OF cTimer
	IF self.started = FALSE THEN Throw("EMU", 'cTimer.finished(); the timer was not running')
	->AbortIO(self.tr.io)	->could call this, to be safe?
	WaitIO(self.tr.io)
	SetSignal(0, self.infoSignal())	->clear the signal, since WaitIO() may not
	self.started := FALSE
ENDPROC

->This returns TRUE if the timer was started() & has not been halt()ed or finished().
PROC infoIsRunning() OF cTimer RETURNS isRunning:BOOL IS self.started

->The signal you need to Wait() on.
PROC infoSignal() OF cTimer RETURNS signal IS 1 SHL self.port.sigbit

PROC infoSignalNum() OF cTimer RETURNS signal IS self.port.sigbit

PROC end() OF cTimer
	IF self.started THEN self.halt()
	IF self.tr
		CloseDevice(    self.tr.io)
		DeleteIORequest(self.tr.io)
	ENDIF
	IF self.port THEN DeleteMsgPort(self.port)
	SUPER self.end()
ENDPROC
