DECLARE FUNCTION Name$(a$)

REM *** Test ***
a$="aber hallo!"
PRINT Name$(a$)
INPUT a$
END
REM ************

FUNCTION Name$(a$)
'This function formats a string like a name. "A sample text" becomes
'"A Sample Text", for instance. You should convert the string to lower
'case before using this function.
	tvc$=UCASE$(LEFT$(a$,1))
	FOR tvc%=2 TO LEN(a$)
	tvi$=MID$(a$,tvc%,1)
	IF MID$(a$,tvc%-1,1)=" "
	  tvc$=tvc$+UCASE$(tvi$)
	ELSE
	  tvc$=tvc$+tvi$
	END IF
	NEXT tvc%
	Name$=tvc$
	tvc$=""
	tvi$=""
END FUNCTION
