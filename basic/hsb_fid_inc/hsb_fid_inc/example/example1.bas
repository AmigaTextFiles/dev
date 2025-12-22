' example 1
' Version : $Id: example1.bas V0.1
' Compiler:	HBC 2.0+
' Includes:	3.1
' Author:   steffen.leistner@styx.in-chmenitz.de
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

REM $INCLUDE dos.bh
REM $INCLUDE utility.bh
REM $INCLUDE fileid.bh

LIBRARY OPEN "FileID.library", MIN_FIDLIB_VER&

IF PEEKL(SYSTAB + 8)		'Workbench
	WINDOW 1,"FileID.library Example 1",,23
ELSE						'CLI
	PRINT : PRINT "- FileID.library Example 1 -" : PRINT
END IF

IF LEN(COMMAND$) > NULL&
	file$ = COMMAND$
ELSE
	INPUT "Filename: ", file$
END IF

IF NOT FEXISTS(file$)
	PRINT "File not exists."
	IF PEEKL(SYSTAB + 8)
		SLEEP
		WINDOW CLOSE 1
	END IF
	SYSTEM RETURN_WARN&
END IF

finf& = FIAllocFileInfo&
IF finf&
	res& = FIIdentifyFromName&(finf&, SADD(file$ + CHR$(0%)))
	SELECT CASE res&
		CASE NULL&
			PRINT "            File: "; file$
			PRINT "     Description: "; PEEK$(PEEKL(finf& + FI_Description%))
			PRINT "              ID:"; PEEKW(finf& + FI_ID%)
			PRINT " GlobalFileClass:"; PEEKW(finf& + FI_GlobalFileClass%)
			PRINT
		CASE < NULL&
			PRINT "Error: "; PEEK$(PEEKL(finf& + FI_Description%))
			PRINT
	END SELECT
	FIFreeFileInfo finf&
END IF

IF PEEKL(SYSTAB + 8)
	SLEEP
	WINDOW CLOSE 1
END IF

SYSTEM RETURN_OK&

'******************************************************************************

DATA "$VER: example1 V0.1 (01-01-99) "