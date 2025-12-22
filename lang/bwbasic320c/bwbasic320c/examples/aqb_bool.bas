REM --------------------------------
REM -  bool.b                      -
REM -  MaxonBASIC/ACE source file  -
REM --------------------------------

DEFINT a - z

JA = 1 
NEIN = 0

REM SHELL "CLS"

PRINT "---------------------"
PRINT "-- BOOLEAN Checker --"
PRINT "---------------------"
PRINT

PRINT "Internal TRUE  = ";
PRINT (1 = 1)
PRINT "Internal FALSE = "; 
PRINT (1 = 0)
PRINT

REM Jump Mark
AGAIN: 

INPUT "Gimme some value: ", value
PRINT

IF (value = JA) OR (value = NEIN) THEN 
    PRINT "That's indeed a BOOL value, thanks!"
ELSE
    PRINT "You did not enter a BOOL value (0 or 1)!"
END IF
IF value = JA THEN
    PRINT "Value evaluates to TRUE"
END IF
IF value = NEIN THEN
    PRINT "Value evaluates to FALSE"
END IF

INPUT "Another run (Y/N?) ", run$
IF (run$ = "Y") OR (run$ = "y") THEN
    GOTO AGAIN
END IF
PRINT
END

