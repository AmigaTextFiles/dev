
/* ----------------------------------------------- */
/* PAR: used as a ~volume~ for binary data access. */
/*            (C)2005, B.Walker, G0LCU.            */
/* ----------------------------------------------- */
/* Use ECHO for printing to the screen and SAY for */
/*      printing any variables to the screen.      */
/* ----------------------------------------------- */
/*   IMPORTANT!!!, run ONLY from a SHELL or CLI.   */
/* From the SHELL/CLI, type:-  RX PAR.rexx<RETURN> */
/* ----------------------------------------------- */


/* Show my version number and (C) for one line only. */
/* (Note these two lines can be omitted.) */
    ECHO 'c'x
    ECHO '$VER: PAR.rexx_Version_1.00.00_(C)22-04-2006_B.Walker_G0LCU.'


/* Set up any variables. */
    ParaByte = ''
    MyByte = ''


/* Set the signal for breaking the script, ~Ctrl C~. */
    SIGNAL ON BREAK_C


/* ------------------------------------------------------------------- */
/* This is the main working loop for accessing the parallel port. */
    DO FOREVER

/* Open up a channel for reading from the parallel port. */
    OPEN(ParaByte, 'PAR:', 'R')

/* Read a single binary character from the port. */
    MyByte = READCH(ParaByte, 1)

/* If MyByte is a NULL then this corresponds to the EOF, 0, so correct */
/* it by making sure ALL NULLs are given the value of 0. */
    IF MyByte = '' THEN MyByte = 0

/* All major data access done, NOW IMMEDIATELY close the channel. */
    CLOSE(ParaByte)

/* Print the character onto the screen. */
/* This binary character ~MyByte~ can now be manipulated by all */
/* of the normal methods available under ARexx. */
    SAY 'Byte at parallel port is decimal value '||C2D(MyByte)'.    '
    END
/* ------------------------------------------------------------------- */


/* Cleanup and exit from the script. */
Break_C:
    EXIT
