' identify-example 5
' Version : $Id: identify_5.bas V0.3
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
 
REM $INCLUDE exec.bh
REM $INCLUDE dos.bh
REM $INCLUDE utility.bh
REM $INCLUDE identify.bh

LIBRARY OPEN "exec.library", 37&
LIBRARY OPEN "identify.library"

'******************************************************************************

sys$ = "Your CPU is a $CPU$ with $CPUCLOCK$" + CHR$(0%)

blen& = IdEstimateFormatSize&(SADD(sys$), NULL&)

buf& = AllocVec&(blen&, MEMF_ANY& OR MEMF_CLEAR&)

IF buf&
	length& = IdFormatString&(SADD(sys$), buf&, blen&, NULL&)
	
	PRINT PEEK$(buf&)
	
	FreeVec buf&
END IF

LIBRARY CLOSE

SYSTEM RETURN_OK&

'******************************************************************************

DATA "$VER: identify_5 V0.3 (22-08-99) "