OPT PREPROCESS, POINTER
MODULE 'CSH/cAmiga_ReliableTimerSignal', 'intuition', 'graphics', 'exec', 'dos'

PROC main()
	DEF vblankSignal:OWNS PTR TO testReliableTimerSignal
	DEF fps[9]:STRING, i
	DEF signal
	
	RealF(fps, 1000000.0 / screenRefreshDelay(), 2)
	Print('Monitor refresh rate = \s Hz\n', fps)
	
	NEW vblankSignal.new(screenRefreshDelay())
	
	FOR i := 1 TO 5
		Delay(10 * 50 * screenRefreshDelay() / 1000000)
		Print('count = \d\n', vblankSignal.count)		->expect count~=10 due to Delay()
		vblankSignal.count := 0
	ENDFOR
	
	Print('Press Ctrl-C to quit\n')
	i := 1000000 / screenRefreshDelay()
	REPEAT
		signal := Wait(vblankSignal.infoSignal() OR SIGBREAKF_CTRL_C)
		IF signal AND vblankSignal.infoSignal()
			i--
			IF i <= 0
				i := 1000000 / screenRefreshDelay()
				Print('Received \d signals.\n', i)		->expect this to roughly equal the refresh rate.
			ENDIF
		ENDIF
	UNTIL signal AND SIGBREAKF_CTRL_C
	
	Print('Quit!\n')
FINALLY
	PrintException()
	END vblankSignal
ENDPROC

->NOTE: Want 16639 ms (60.10Hz)) from tcc=55 & tr=1066.
PROC screenRefreshDelay() RETURNS microSeconds
#ifdef pe_TargetOS_AROS
	microSeconds := 1000000 / 60
#else
	DEF scr:PTR TO screen, modeId, handle:ARRAY, monitor:monitorinfo
	
	scr := LockPubScreen(NILA)
	modeId := GetVPModeID(scr.viewport)
	handle := FindDisplayInfo(modeId)
	IF GetDisplayInfoData(handle, monitor, SIZEOF monitorinfo, DTAG_MNTR, modeId) = 0 THEN Throw("RES", 'game; screenRefreshDelay(); failed to query display')
	UnlockPubScreen(NILA, scr) ; scr := NIL
	
	microSeconds := 0.2838 * (monitor.totalcolorclocks) * monitor.totalrows + 0.5 !!VALUE
	
	->DEF vfreqint
	->vfreqint := 1000000000 / (monitor.totalcolorclocks!!ULONG * 280 * monitor.totalrows / 1000) + 5
	->microSeconds := 1000000.0 / vfreqint * 1000.0 + 0.5 !!VALUE
#endif
ENDPROC


CLASS testReliableTimerSignal OF cReliableTimerSignal PUBLIC
	count
ENDCLASS

PROC init() OF testReliableTimerSignal
	self.count := 0
ENDPROC

PROC event() OF testReliableTimerSignal
	self.count++
ENDPROC
