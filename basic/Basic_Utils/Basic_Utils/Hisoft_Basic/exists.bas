DECLARE FUNCTION exists%(filnam$)

REM *** Test ******************
PRINT exists%("S:User-startup")
PRINT exists%("RAM:R.DAT")
REM ***************************

FUNCTION exists%(filnam$)
'Checks if file filnam$ exists
  OPEN "A",205,filnam$
  IF (LOF(205) <1)
    CLOSE 205
    KILL filnam$
    exists%=0
  ELSE
    CLOSE 205
    exists%=-1
  END IF
END FUNCTION
