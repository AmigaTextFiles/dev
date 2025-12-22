    1 REM -------------------------
    2 REM -  bool.bas             -
    3 REM -  bwBASIC source file  -
    4 REM -------------------------
    5 REM
   10 TRUE = 1
    : FALSE =0
   11 REM
   16 REM
   20 PRINT "---------------------"
   21 PRINT "-- BOOLEAN Checker --"
   22 PRINT "---------------------"
   23 PRINT
   26 REM
   27 PRINT "Internal TRUE = ";
    : PRINT (1 = 1)
   28 PRINT "Internal FALSE = ";
    : PRINT (1 = 0)
   29 PRINT
   30 INPUT "Gimme some BOOL value: ", value
   31 PRINT
   32 REM
   40 IF (value = TRUE) OR (value = FALSE) THEN
    :   PRINT "That's indeed a BOOL value, thanks!"
      ELSE
    :   PRINT "You did not enter a BOOL value (0 or 1)!"
    : END IF
   50 IF value = TRUE THEN
    :   PRINT "Value evaluates to TRUE"
    : END IF
   60 IF value = FALSE THEN
    :   PRINT "Value evaluates to FALSE"
    : END IF
   61 REM
   70 INPUT "Another run (Y/N?) ", run$
   71 IF (run$ = "Y") OR (run$ = "y") THEN
    :   GOTO 30
    : END IF
   80 PRINT
  100 END

