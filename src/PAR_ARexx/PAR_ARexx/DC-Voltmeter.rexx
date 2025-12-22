
/* ---------------------------------------- */
/* Voltmeter.rexx, (C)2005 B.Walker, G0LCU. */
/* ---------------------------------------- */
/*    Released as Public Domain Software.   */
/* ---------------------------------------- */
/* It uses a Workbench window size 640x180 using the IconX project icon. */


/* Set up any constants or variables. */
  Copyright='9'x'$VER: DC-Voltmeter.rexx_Version_0.72.18_01-09-2005_(C)G0LCU.'
  ParaByte = ''
  MyByte = ''


/* Set the signal for breaking the script, ~Ctrl C~. */
  SIGNAL ON BREAK_C


/* Use ECHO for ordinary printing to the screen and SAY for printing results. */
/* Set up the parallel port voltmeter screen. */
  ECHO 'c'x
  ECHO 'd'x'9'x'9'x'9'x'Press ~Ctrl C~ together to Quit.'
  ECHO 'a'x'9'x'9'x'  DC Voltmeter from 0.00 Volts to 5.10 Volts.'
  ECHO 'a'x'a'x'9'x'9'x'9'x'     DC Voltage is:- 0.00V.                    '


/* ------------------------------------------------------------------- */
/* Parallel port reading 8 bits. */
/* The -STROBE line is automatically clocked by the system when the port */
/* is accessed, so there is NO need to generate it. */
/* This is the main working loop for accessing the parallel port. */
  DO FOREVER

/* Open up a channel for reading from the parallel port. */
  OPEN(ParaByte, 'PAR:', 'R')

/* Read a single binary character from the port. */
  MyByte = READCH(ParaByte, 1)

/* If MyByte is a NULL then this corresponds to the EOF, 0, so correct */
/* it by making sure ALL NULLs are given the value of 0. */
  IF MyByte = '' THEN MyByte = 0

/* All major data access done, NOW immediately close the channel. */
  CLOSE(ParaByte)

/* Do the necessary calculation(s) and then print the correct */
/* voltage in the window. */
  ECHO 'b'x'9'x'9'x'9'x'     DC Voltage is:- 0.00V.                    '
  SAY 'b'x'9'x'9'x'9'x'     DC Voltage is:- '||C2D(MyByte) * 0.02

/* Generate a simple delay line to slow down the access. */
/* These two lines are NOT required at all but are in to make the */
/* parallel port access more usable as a simple voltmeter. */
/* This gives a sample time of about 1 Second on an A1200 with 4MB */
/* of trapdoor ~FastRam~ fitted. */
    DO FOR 2000
    END
  END
/* ------------------------------------------------------------------- */


/* Cleanup and exit from the script. */
Break_C:
  ECHO 'c'x
  SAY Copyright
  ECHO 'a'x'a'x'a'x'd'x'7'x'9'x'9'x'9'x'Click on CLOSE gadget to Quit.'
  EXIT
