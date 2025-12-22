MODULE 'intuition', 'dos/dos'
MODULE 'fabio/rxobj_oo'
MODULE 'tools/patch'

DEF rexx:PTR TO rxobj

PROC main()
	DEF openwindow:PTR TO patch
	DEF rxsig
	
	NEW openwindow.init(intuitionbase, -606, {newopenwin})
	NEW rexx.rxobj('WinNoise')

	openwindow.install()

	rxsig := rexx.signal()
	Wait(rxsig OR SIGBREAKF_CTRL_C)

	WriteF('Exiting...\n')
	openwindow.remove()
	
	END openwindow
	END rexx
ENDPROC

PROC newopenwin(old, pat)
	DEF nw, lib, res
	rexx.send('PLAY', 'id open_window', NIL, NIL)
ENDPROC
		
