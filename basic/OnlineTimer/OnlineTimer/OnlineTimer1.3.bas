REM Online Timer in Hisoft BASIC by Simon Goodwin
REM For Amiga Format's BANGING THE METAL series
REM
REM This code monitors bit 5 of CIAB port A, pin
REM 8 of the RS-232 port, which IS clear (0) when
REM the modem sends a 'carrier detect' signal.
REM
REM V 1.3 - Times in hours, minutes and seconds
REM
REM Should use fixed font, or be font adaptive.
REM
REM $INCLUDE dos.bh
LIBRARY OPEN "dos.library" ' For Delay routine

CIAA_PRA&=12570624
ver$="$VER: OnlineTimer 1.3 (24.3.1999)"
HB$=" HiSoft BASIC "

WINDOW 1," "+HB$+MID$(ver$,7,16),(160,16)-(320,60),1+2+4+16+256


Timing%=0
Start!=TIMER
LOCATE 2,4
PRINT "Time on line  0 : 0 : 0";

REPEAT check

  CD%=(PEEK(CIAA_PRA&) AND 32)
  IF CD%
    Timing%=1 : Start!=TIMER
  ELSE
    IF Timing%
      
      secs&=INT(TIMER-Start!+.5)
      minutes&=secs&\60
      hours&=minutes&\60
      secs&=secs&-(60*(minutes&+hours&*60))
      minutes&=minutes&-hours&*60

      LOCATE 2,17
      PRINT hours&;":";minutes&;":";secs&;"     ";

    END IF
  END IF
    
  Delay &30 ' Update periodically
  
END REPEAT check

REM This is just a very simple example.
REM Suggested updates: keep a log file?
REM
REM Check the real time with TIME$ and
REM display running call costs according
REM to the date and time of day?
REM
REM Adjust to monitor the CD bit on other
REM serial ports (IOBLIX, GVP, MFC etc)?
