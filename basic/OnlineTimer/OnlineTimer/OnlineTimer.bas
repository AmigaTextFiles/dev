REM Online Timer in Hisoft BASIC by Simon Goodwin
REM For Amiga Format's BANGING THE METAL series
REM
REM This code monitors bit 5 of CIAB port A, pin
REM 8 of the RS-232 port, which IS clear (0) when
REM the modem sends a 'carrier detect' signal.

REM $INCLUDE dos.bh
LIBRARY OPEN "dos.library" ' For Delay routine

WINDOW 1,"  Hisoft BASIC Online Timer", _
	(200,16)-(240,56),1+2+4+16+256

CIAA_PRA&=12570624
ver$="$VER: OnlineTimer 1.2 (23.3.1999)"

Timing%=0
LOCATE 2,4
PRINT "Seconds on line: 0";

REPEAT check

  CD%=(PEEK(CIAA_PRA&) AND 32)
  IF CD%
      Timing%=1 : Start!=TIMER
    ELSE
    IF Timing%
      LOCATE 2,20
      PRINT TIMER-Start!;"     ";
    END IF
  END IF
    
  Delay &30 ' Update periodically
  
END REPEAT check

REM This is just a very simple example.
REM Suggested updates: keep a log file?
REM
REM Convert times to hours and minutes?
REM
REM Check the real time with TIME$ and
REM display running call costs according
REM to the date and time of day?
REM
REM Adjust to monitor the CD bit on other
REM serial ports (IOBLIX, GVP, MFC etc)?
