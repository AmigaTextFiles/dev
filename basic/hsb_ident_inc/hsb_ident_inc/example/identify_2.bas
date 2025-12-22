' identify-example 2
' Version : $Id: identify_2.bas V0.9
' Compiler:	HBC 2.0+
' Includes:	3.1
' Author:   steffen@styx.muc.de
' Status:   Freeware

'******************************************************************************

DEFLNG a-z

REM $JUMPS
REM $NOWINDOW
REM $NOLIBRARY
REM $NOSTACK
REM $NOARRAY
REM $NOLINES
REM $NOVARCHECKS
REM $NOAUTODIM
 
REM $INCLUDE utility.bh
REM $INCLUDE identify.bh

LIBRARY OPEN "identify.library"

'******************************************************************************

PRINT "Force FPU:"
PRINT

fpu& = IdHardwareNum&(IDHW_FPU&, NULL&)
SELECT CASE fpu&
	CASE IDFPU_NONE& 
		usesub& = VARPTRS(NonOptimisedCode)
	CASE IDFPU_68881& TO IDFPU_68060&
		usesub& = VARPTRS(FPUOptimisedCode)
		proc$ = PEEK$(IdHardware&(IDHW_FPU&, NULL&))
	CASE REMAINDER
		usesub& = VARPTRS(FPUOptimisedCode)
		proc$ = "unknown"
END SELECT


CALLS usesub&


'******************************************************************************

SYSTEM 0

'******************************************************************************

SUB NonOptimisedCode
	PRINT "No FPU. No Fun."
END SUB

SUB FPUOptimisedCode
	SHARED proc$
	PRINT "Using FloatingPoint-Processor: ";proc$
END SUB

DATA "$VER: identify_2 V0.9 (05-08-98) "