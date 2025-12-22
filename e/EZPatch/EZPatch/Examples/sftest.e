-> This patches DisplayBeep() and then does some tests

MODULE 'tools/patch'
MODULE 'intuition'

    -> I recommend using the format CONST {FUNCTION}_OFFSET={OFFSET}
    -> for your values so that you can easily see what's going on.
    -> If you just called it DISPLAYBEEP, it might be an address
    -> instead of an offset.
    -> If you have pipe's installed, you can easily find an offset by
    -> saying showmodule emodules:(libname) | search in: (function)
    -> If I've included getoff, it'll do this for you, but it uses a
    -> temporary file, so it'll work without pipe's.
CONST DISPLAYBEEP_OFFSET=-96

    -> These should be global so your functions can access them
DEF displaybeep1:patch
DEF displaybeep2:patch

PROC main() HANDLE
    -> Allocate and initialise the patches
	NEW displaybeep1
	NEW displaybeep2
    displaybeep1.init(intuitionbase, -96, {newbeep1})
    displaybeep2.init(intuitionbase, -96, {newbeep2})

	WriteF('\nPre-test\n\n')
	Delay(25)
	DisplayBeep(NIL)
	Delay(25)

    -> Install patch 1 and test
    WriteF('Patch #1:\nInstalling\n')
    displaybeep1.install()
	Delay(25)
    WriteF('Testing\n')
	Delay(25)
	DisplayBeep(NIL)
	Delay(25)
    WriteF('Removing\n')
    displaybeep1.remove()
    WriteF('Done.\n\n')
    Delay(75)
	
	-> Install Patch 2 and test
	WriteF('Patch #2:\nInstalling\n')
	displaybeep2.install()
	WriteF('Testing\n')
	Delay(25)
	DisplayBeep(NIL)
	Delay(25)
	WriteF('Removing\n')
	displaybeep2.remove()
	WriteF('Done\n\n')

	-> Install patch one, then patch two, and test
	WriteF('Double patch:\n')
	WriteF('Installing Patch #2\n')
	displaybeep2.install()
	WriteF('Testing\n')
	Delay(25)
	DisplayBeep(NIL)
	Delay(25)	
	WriteF('Installing patch #1\n')
	displaybeep1.install()
	WriteF('Testing\n')
	Delay(25)
	DisplayBeep(NIL)
	Delay(25)
	WriteF('Removing patch #2\n')
	displaybeep2.remove()
	WriteF('Testing again\n')
	Delay(25)
	DisplayBeep(NIL)
	Delay(25)
	WriteF('Removing patch #1\n')
	displaybeep1.remove()
	WriteF('Done.\n\n')
	
	WriteF('Post-testing\n\n')
	Delay(25)
	DisplayBeep(NIL)
	Delay(25)
	
    WriteF('Tests completed.\n')
EXCEPT DO
    -> I'd better de-allocate them myself, just for safety
    WriteF('Deallocating patches...')
    END displaybeep1
    END displaybeep2
    WriteF('Done.\n')
	WriteF('Errors:')
	SELECT exception
		CASE NIL
			WriteF('    none.\n')
		CASE MEMORY_ERROR
			WriteF('    Out of memory.\n')
		CASE PATCH_IN_USE
			WriteF('    Patch already in use.\n')
		CASE NOT_INITIALISED
			WriteF('    Forgot to init.\n')
		DEFAULT
			WriteF('	Not handled.\n')
	ENDSELECT
ENDPROC

PROC newbeep1(old, pat)
	WriteF('Beep!\n')
ENDPROC

PROC newbeep2(old, patch:PTR TO patch)
	DEF value
	MOVE.L A0, value
    EasyRequestArgs(NIL, [20, 0, 'Beep Request', 'Beep Received!\nArg was %d',
                                 'Okay|So What?|Go Away!'], NIL, {value})
ENDPROC
