REM ***********************************************************************
REM
REM Parallel Port and Games Port access using STANDARD BASIC only.
REM
REM (C)1996 B.Walker, (G0LCU).
REM
REM Checked against AmigaBASIC, ACE Basic Compiler, Cursor Basic Compiler,
REM and HiSoft Basic Compiler. Some modifications may be required for the
REM ancient ABasiC Intepreter of Pre-Workbench 1.3x.
REM
REM This is ready for ~ACE Basic Compiler~, (C) David Benn.
REM
REM ***********************************************************************

REM Open a standard window.
REM Remove the ~WINDOW~ statement IF required.
  WINDOW 1,"                    Port Access, (C)2003 B.Walker, G0LCU.                    ",(0,11)-(640,200),6

REM Set up any string variables.
  LET a$="(C)2003 B.Walker, G0LCU."
REM Set up any numerical variables.
  LET n=0
  LET byteval=0

REM ~CIAA~ address for register ~pra~.
  LET pra=12574721
REM ~CIAA~ address for register ~prb~.
  LET prb=12574977
REM ~CIAA~ address for direction of port ~pra~, (1=OUTPUT).
  LET ddra=12575233
REM ~CIAA~ address for direction of port ~prb~, (1=OUTPUT).
  LET ddrb=12575489

REM Store single byte values of these addresses for future use.
  LET valpra=PEEK(pra)
  LET valprb=PEEK(prb)
  LET valddra=PEEK(ddra)
  LET valddrb=PEEK(ddrb)
REM Bit 0 of port ~ddra~ DO NOT CHANGE...
REM Bit 1 of port ~ddra~ switches the ~LED~ ON or OFF, (1=ON).
REM Bits 2 to 5 inclusive of port ~ddra~ DO NOT CHANGE...
REM Bits 6 and 7 of port ~ddra~ alter PIN 6 of the mouse/games ports, (1=OUTPUT).
REM Port ~ddrb~ controls the parallel port, all bits, (1=OUTPUT).
  LET newvalpra=valpra
  IF newvalpra>=128 THEN LET newvalpra=newvalpra-128
  LET newvalddra=valddra
  IF newvalddra>=128 THEN LET newvalddra=newvalddra-128

REM Initial copyright line.
  CLS
  COLOR 1,0
  LOCATE 2,28
  PRINT a$
  GOTO start1:

REM Simple setup screen.
start:
  CLS
start1:
  LOCATE 5,10
  PRINT "Press ~w~ or ~W~ for writing data bytes to the parallel port."
  LOCATE 7,10
  PRINT "Press ~r~ or ~R~ for reading data bytes from the parallel port."
  LOCATE 9,10
  PRINT "Press ~g~ to read from PIN 6 of the games port only."
  LOCATE 11,10
  PRINT "Press ~G~ to write to PIN 6 of the games port only."
  LOCATE 13,10
  PRINT "Press ~l~ to turn the power light UP or ON."
  LOCATE 15,10
  PRINT "Press ~L~ to turn the power light DOWN or OFF."
  LOCATE 17,10
  PRINT "Press ~q~ or ~Q~ to quit."
  
REM This is the main loop.
mainloop:
  LET a$=INKEY$
  IF a$="w" OR a$="W" THEN GOTO parallelwrite:
  IF a$="r" OR a$="R" THEN GOTO parallelread:
  IF a$="G" THEN GOTO gamesportwrite:
  IF a$="g" THEN GOTO gamesportread:
  IF a$="l" THEN GOSUB lightup:
  IF a$="L" THEN GOSUB lightdown:
  IF a$="q" OR a$="Q" THEN GOTO getout:
  GOTO mainloop:

REM Write byte values to the parallel port.
parallelwrite:
  CLS
  LET n=0
REM Set all bits to outputs.
  POKE ddrb,255
loop1:
  POKE prb,n
  LET byteval=PEEK(prb)
  LOCATE 10,19
  PRINT "Decimal value at the parallel port is";byteval;CHR$(8);".   "
  LOCATE 12,26
  PRINT "Press ~SPACE BAR~ to exit."
  LET a$=INKEY$
  IF a$=" " THEN GOTO start:
  LET n=n+1
  IF n>255 THEN LET n=0
  GOTO loop1:

REM Read byte values from the parallel port.
parallelread:
  CLS
REM Set all bits to inputs.
  POKE ddrb,0
loop2:
  LET byteval=PEEK(prb)
  LOCATE 10,19
  PRINT "Decimal value at the parallel port is";byteval;CHR$(8);".   "
  LOCATE 12,26
  PRINT "Press ~SPACE BAR~ to exit."
  LET a$=INKEY$
  IF a$=" " THEN GOTO start:
  GOTO loop2:

REM Write ~1~s and ~0~s to PIN 6 of the games port.
gamesportwrite:
  CLS
REM Force bit 7 of ~pra~ as an output.
  POKE ddra,(newvalddra+128)
REM Set bit 7 of ~pra~ to a value ~1~.
loop3:
  POKE pra,(newvalpra+128)
  LET n=PEEK(pra)
  LOCATE 8,19
  PRINT "Value should be greater than ~127~:-";n;CHR$(8);".   "
REM Set bit 7 of ~pra~ to a value ~0~.
  POKE pra,newvalpra
  LET n=PEEK(pra)
  LOCATE 10,21
  PRINT "Value should be less than ~128~:-";n;CHR$(8);".   "
  LOCATE 12,26
  PRINT "Press ~SPACE BAR~ to exit."
  LET a$=INKEY$
  IF a$=" " THEN GOTO start:
  GOTO loop3:

REM Read the state of PIN 6 of the games port.
gamesportread:
  CLS
  POKE pra,valpra
  POKE ddra,valddra
loop4:
  LET n=PEEK(pra)
  LOCATE 10,9
  PRINT "Less than ~128~ when PIN 6 of the games port pulled LOW:-";n;CHR$(8);".   "
  LOCATE 12,26
  PRINT "Press ~SPACE BAR~ to exit."
  LET a$=INKEY$
  IF a$=" " THEN GOTO start:
  GOTO loop4:

REM Turn the POWER light UP or ON.
lightup:
  POKE ddra,valddra
  POKE pra,252
  RETURN

REM Turn the POWER light DOWN or OFF.
lightdown:
  POKE ddra,valddra
  POKE pra,254
  RETURN

REM Exit routine.
REM Reset all of the ports back to their original state.
getout:
  POKE pra,valpra
  POKE prb,valprb
  POKE ddra,valddra
  POKE ddrb,valddrb
REM Remove the ~WINDOW CLOSE~ statement if required.
  WINDOW CLOSE 1
  END
