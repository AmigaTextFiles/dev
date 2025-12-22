
/* ************************************************************ */
/*                                                              */
/* Simple ARexx code to WRITE characters to a parallel printer. */
/* This is Public Domain to show that PAR: is easily written to */
/* without the need for complex coding. Notice that PRT: is not */
/* used at all, but could be substituted for PAR: instead.      */
/* A parallel port printer IS needed, and, MUST be connected to */
/* show this idea working properly.                             */
/*                                                              */
/* ************************************************************ */

ECHO 'This will WRITE ASCII chahracters to the PAR: device.'

somestring = '(C)2008, B.Walker, G0LCU.'

ADDRESS COMMAND 'Echo > PAR: ' || somestring

EXIT
