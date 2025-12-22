DECLARE FUNCTION valc%(q$)

REM *** Test **********
WHILE a$<>"q"
  LINE INPUT a$
  a$=LTRIM$(RTRIM$(a$))
  PRINT valc%(a$)
WEND
REM *******************

FUNCTION valc%(valc$)
'This function counts the numerical characters at the beginning of the
'given string. valc%("12a") would return 2, for example.
  valc2$=LTRIM$(RTRIM$(STR$(VAL(valc$))))
  IF (LEN(valc2$)<LEN(valc$))
    valc%=LEN(valc2$)
  ELSE
    valc%=LEN(valc$)
  END IF
END FUNCTION
