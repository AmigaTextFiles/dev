OPT MULTITHREADED
MODULE 'CSH/cAmiga_ReliableTimerSignal', 'exec'

PROC main()
	test()
ENDPROC

PROC test()
	DEF timer:OWNS PTR TO cReliableTimerSignal, signal, i, events
	NEW timer.new()
	
	Print('Starting timer\n')
	signal := timer.infoSignal()
	timer.start(1*1000000)
	
	i := 0
	REPEAT
		events := Wait(signal)
		IF events AND signal
			Print('Timer event\n')
			i++
		ENDIF
	UNTIL i >= 4
	
	Print('Stopping timer\n')
	timer.halt()
FINALLY
	PrintException()
	END timer
	Print('Finished successfully\n')
ENDPROC
