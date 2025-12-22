' identify-example 4
' Version : $Id: identify_4.bas V0.3, based on MyExp.c by Richard Koerber
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
REM $INCLUDE expansion.bh
REM $INCLUDE identify.bh

LIBRARY OPEN "exec.library", 37&
LIBRARY OPEN "identify.library"

'******************************************************************************

DIM tags&(20%), buf&(2%)
	

FOR z% = 0% TO 2%
	buf&(z%) = AllocVec&(IDENTIFYBUFLEN&, MEMF_ANY& OR MEMF_CLEAR&)
NEXT z%

expans& = AllocVec&(ConfigDev_sizeof%, MEMF_ANY& OR MEMF_CLEAR&)
tags& = AllocVec&(64&, MEMF_ANY& OR MEMF_CLEAR&)



IF buf&(0%) AND buf&(1%) AND buf&(2%) AND expans& AND tags&

	PRINT "Nr Address  Size Description"
	PRINT "----------------------------------------------------------"

	TAGLIST tags&, _
		IDTAG_ManufStr&,	buf&(0%), _
		IDTAG_ProdStr&,		buf&(1%), _
		IDTAG_ClassStr&,	buf&(2%), _
		IDTAG_Expansion&,	expans&, _
	TAG_END&

	cnt% = 0%

	WHILE IdExpansion&(tags&) = NULL&
		
		boardsize& = PEEKL(PEEKL(expans&) + cd_BoardSize%) >> 10&
		IF boardsize& >= 1024%
			size$ = FORMATL$(boardsize& >> 10, "###") + "M"
		ELSE
			size$ = FORMATL$(boardsize&, "###") + "K"
		END IF
		
		INCR cnt%
		
		addr$ = HEX$(PEEKL(PEEKL(expans&) + cd_BoardAddr%))
		
		PRINT FORMATI$(cnt%,"##"); " "; _
			  STRING$(8 - LEN(addr$),"0"); addr$; " "; _
			  size$; " "; _
			  PEEK$(buf&(1%)); " "; _
			  PEEK$(buf&(2%)); " ("; _
			  PEEK$(buf&(0%)); ")"
  
	WEND
	
	FOR z% = 0% TO 3%
		FreeVec buf&(z%)
	NEXT z%

	FreeVec expans&
	FreeVec tags&
	
ELSE
	PRINT "Not enough Memory!"
END IF

LIBRARY CLOSE

SYSTEM RETURN_OK&

'******************************************************************************

DATA "$VER: identify_4 V0.3 (22-08-99) "