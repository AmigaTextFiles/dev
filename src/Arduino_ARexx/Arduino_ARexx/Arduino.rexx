
/* ----------------------------------------------- */
/*       Arduino access using standard ARexx.      */
/*            (C)2009, B.Walker, G0LCU.            */
/* ----------------------------------------------- */
/* Use ECHO for printing to the screen and SAY for */
/*      printing any variables to the screen.      */
/* ----------------------------------------------- */
/*   IMPORTANT!!!, run ONLY from a SHELL or CLI.   */
/* From the SHELL type:-   RX Arduino.rexx<RETURN> */
/* ----------------------------------------------- */


/* Show my version number and (C) for one line only. */
/* Issued as Public Domain. */
    ECHO 'c'x
    ECHO '$VER: Arduino.rexx_Version_1.00.00_(C)01-06-2009_B.Walker_G0LCU.'
    ECHO ''
    ECHO 'Press ~Ctrl-C~ to stop...'
    ECHO ''
/* Set up any variables. */
    ArduinoByte = ''
    MyByte = ''


/* Set the signal for breaking the script, ~Ctrl C~. */
    SIGNAL ON BREAK_C


/* ------------------------------------------------------------------- */
/* This is the main working loop for accessing the ~serial~ port. */
    DO FOREVER

/* Open up a channel for reading from the ~serial~ port. */
    OPEN(ArduinoByte, 'SER:', 'R')

/* Read a single binary character from the port. */
    MyByte = READCH(ArduinoByte, 1)

/* If MyByte is a NULL then this corresponds to the EOF, 0, so correct */
/* it by making sure ALL NULLs are given the value of 0. */
    IF MyByte = '' THEN MyByte = 0

/* All major data access done, NOW IMMEDIATELY close the channel. */
    CLOSE(ArduinoByte)

/* Print the character onto the screen. */
/* This binary character ~MyByte~ can now be manipulated by all */
/* of the normal methods available under ARexx. */
    SAY 'Byte at Serial/USB port is decimal value '||C2D(MyByte)'.    '
    END
/* ------------------------------------------------------------------- */


/* Cleanup and exit from the script. */
Break_C:
    EXIT
