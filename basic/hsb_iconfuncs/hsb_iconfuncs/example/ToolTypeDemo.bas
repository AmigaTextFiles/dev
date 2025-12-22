' ToolTypeDemo.bas
' Author:    steffen.leistner@styx.in-chemnitz.de
' Compiler:  HBC 2.0
' Includes:  3.1
' Kickstart: 39+
' Tabwidth:  4

DEFLNG a-z

REM $NOLIBRARY
REM $NOWINDOW

REM $INCLUDE workbench.bh
REM $INCLUDE icon.bh
REM $INCLUDE intuition.bh
REM $INCLUDE exec.bh
REM $INCLUDE dos.bh
REM $INCLUDE utility.bh
REM $INCLUDE BLib/IconFuncs.bas

LIBRARY OPEN "workbench.library", 39
LIBRARY OPEN "icon.library"
LIBRARY OPEN "intuition.library"
LIBRARY OPEN "exec.library"
LIBRARY OPEN "dos.library"



'***** Set Standardsizes ******************************************************

l% = 20
t% = 20
w% = 300
h% = 100
t$ = "Using Tooltypes..."

DIM tt$(4)

WINDOW 1,t$,(l%,t%)-(w%,h%),31
PRINT "Set Tooltypes to default."

tt$(0) = "WINDOWTOP=" + LTRIM$(RTRIM$(STR$(l%)))
tt$(1) = "WINDOWLEFT=" + LTRIM$(RTRIM$(STR$(t%)))
tt$(2) = "WINDOWWIDTH=" + LTRIM$(RTRIM$(STR$(w%)))
tt$(3) = "WINDOWHEIGHT=" + LTRIM$(RTRIM$(STR$(h%)))
tt$(4) = "WINDOWTITLE=" + t$

SaveToolTypes FullProgramName$, "", tt$()



'***** Edit the Icon **********************************************************


PRINT "Please edit the Window-Parameter:"

EditIcon WINDOW(7), FullProgramName$



'***** Read new ToolTypes *****************************************************

PRINT "Now reading the new Tooltypes."

tt$(0) = "WINDOWTITLE"
tt$(1) = "WINDOWLEFT"
tt$(2) = "WINDOWTOP"
tt$(3) = "WINDOWWIDTH"
tt$(4) = "WINDOWHEIGHT"

DIM res$(4)
IF ReadToolTypes (FullProgramName$, tt$(), res$())

	WINDOW CLOSE 1
	WINDOW 1,res$(0),(VAL(res$(1)),VAL(res$(2)))-(VAL(res$(3)),VAL(res$(4))), 31
	
	PRINT "This ist the new Size."

ELSE
	
	PRINT "PANIC: Can't read the Icon!!"

END IF

SLEEP

LIBRARY CLOSE
SYSTEM

DATA "$VER: ToolTypeDemo1 V0.8 © by Ironbyte 1997 "