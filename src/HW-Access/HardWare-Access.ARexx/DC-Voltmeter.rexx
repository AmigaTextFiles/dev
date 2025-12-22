/* ---------------------------------------- */
/* Voltmeter.rexx, (C)2004 B.Walker, G0LCU. */
/* ---------------------------------------- */
/*    Released as Public Domain Software.   */
/* ---------------------------------------- */

/* It uses a Workbench window size 640x180 and standard topaz fonts via */
/* the IconX project icon. Read the ~HW-Access.readme~ file for more info'. */

/* Set up any constants or variables. */
  mousetrap=1
  portvalue=0
  copyright='9'x'$VER: DC-Voltmeter.rexx_Version_0.84.02_14-01-2005_(C)G0LCU.'

/* Use ECHO for ordinary printing to the screen and SAY for printing results. */
/* Set up the parallel port voltmeter screen. */
  ECHO 'c'x
  ECHO 'd'x'9'x'9'x'9'x'Click left mouse button to Quit.'
  ECHO 'a'x'9'x'9'x'  DC Voltmeter from 0.00 Volts to 5.10 Volts.'
  ECHO 'a'x'a'x'9'x'9'x'9'x'     DC Voltage is:- 0.00V.                    '

/* Set the parallel port for read only. */
  EXPORT('00BFE301'x,'00'x,1)

/* Parallel port reading 8 bits. */
/* The -STROBE line is automatically clocked by the system when the port */
/* is accessed, so there is NO need to generate it. */
/* Also the -STROBE line is the same as the -DRDY line. */
  DO FOREVER
    portvalue=IMPORT('00BFE101'x,1)
/* Ensure that there is always a decimal point and noughts after any whole */
/* number generated, so that the display looks balanced. */
    ECHO 'b'x'9'x'9'x'9'x'     DC Voltage is:- 0.00V.                    '
    SAY 'b'x'9'x'9'x'9'x'     DC Voltage is:- '||C2D(portvalue) * 0.02
/* Click left mouse button to exit. */
/* Also slows down the ADC sample rate to about one sample per second. */
    DO FOR 400
      mousetrap=IMPORT('00BFE001'x,1)
      IF BITTST(mousetrap,6)=0 THEN CALL getout
    END
  END

/* Exit the program safely. */
getout:
  EXPORT('00BFE301'x,'FF'x,1)
  EXPORT('00BFE201'x,'03'x,1)
  EXPORT('00BFE101'x,'FF'x,1)
  EXPORT('00BFE001'x,'FC'x,1)
  ECHO 'c'x
  SAY copyright
  ECHO 'a'x'a'x'a'x'd'x'7'x'9'x'9'x'9'x'Click on CLOSE gadget to Quit.'
  EXIT(0)
