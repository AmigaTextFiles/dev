'
' QUOTE
'
' 1995 by Ingo Nyhues
'
'Please report any bugs, hints and suggestions via EMail.
'My EMail Adress is: ingony@f-1.de.contrib.net
'

DEFINT a-z

CONST null = 0&

ADDRESS fh

SUB usage

	PRINT "QUOTE - quotes a file and removes empty lines"
	PRINT
	PRINT "Usage: quote  file.in  file.out"
	PRINT
	PRINT "1995 Ingo Nyhues"
	PRINT

END SUB

SUB transfer

	WHILE NOT EOF(1)
		LINE INPUT #1,x$
		IF LEN(x$) > 0 THEN
			PRINT #2,"> ";x$
		END IF
	WEND

END SUB

SUB quoteit

	OPEN "I",1,ARG$(1)
	IF HANDLE(1) = 0 THEN
		PRINT "Couldn't open Input file. Stopping!'
		STOP
	END IF

	OPEN "O",2,ARG$(2)
	IF HANDLE(2) = 0 THEN
		PRINT "Couldn't open Output file. Stopping!'
		STOP
	ELSE
		transfer
		CLOSE #2
	END IF
	CLOSE #1

END SUB


' Main

a = ARGCOUNT

IF a <> 2 THEN
	usage
	STOP
END IF

quoteit

PRINT "Done."
