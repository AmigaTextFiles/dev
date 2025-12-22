REM --------------------------------
REM -  bool.b                      -
REM -  MaxonBASIC/ACE source file  -
REM --------------------------------
REM
TRUE = 1 : FALSE =0
REM
REM
PRINT "---------------------"
PRINT "-- BOOLEAN Checker --"
PRINT "---------------------"
PRINT
REM
PRINT "Internal TRUE = ";: PRINT (1 = 1)
PRINT "Internal FALSE = ";: PRINT (1 = 0)
PRINT
REM Jump Mark
REM AGAIN:
REM
PRINT "Gimme some value: ";
REM INPUT value
PRINT
REM
IF (value = TRUE) OR (value = FALSE) THEN 
    PRINT "That's indeed a BOOL value, thanks!"
ELSE
    PRINT "You did not enter a BOOL value (0 or 1)!"
End IF
IF value = TRUE THEN
   PRINT "Value evaluates to TRUE"
END IF
IF value = FALSE THEN
    PRINT "Value evaluates to FALSE"
END IF
REM
INPUT "Another run (Y/N?) ", run$
IF (run$ = "Y") OR (run$ = "y") THEN
   GOTO AGAIN
END IF
PRINT
END

