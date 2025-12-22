REM $STACK
REM $NOEVENT
REM $NOBREAK
REM $NOAUTODIM
REM $NOLINES
REM $NODEBUG
REM $OVERFLOW
REM $ADDICON
REM $ERRORS
REM $INCPATH MB_INCLUDES:BH
REM $LIBPATH MB_INCLUDES:BMAP
REM $NOLIBRARY
REM $NOWINDOW
REM MAXONBASIC3

ver$="$VER: grep 36.1 (07.10.97) "

DIM Arg$(127)

DECLARE FUNCTION NumArgs&

IF (NumArgs&=0)
  PRINT "grep: Required argument missing"
  END
END IF

datei$=Arg$(1)
such$=Arg$(2)

IF datei$="?"
  PRINT "Usage: grep filename search"
  PRINT
  PRINT "grep processes 'filename' and displays the positions where 'search' has been"
  PRINT "found."
  PRINT
  PRINT "The whole file will be loaded into memory."
  PRINT
  PRINT "Example: grep grep.bas DIM will give 1."
  END
END IF

IF FEXISTS(datei$)
	  WIDTH 76
	  OPEN "i",1,datei$
	t$=INPUT$(LOF(1),1)
	h& = 0
	DO
	  h& = INSTR(h&+1,t$,such$)
	  IF (h& <> 0) 
	    PRINT h&,
	  END IF
	LOOP UNTIL h& = 0
	CLOSE 1
  IF POS(0) <> 1 THEN PRINT
ELSE
  PRINT "grep: File not found"
END IF
END

FUNCTION NumArgs&
  SHARED Arg$()
  FOR t& = 1 TO 127
    arg$(t&)=""
  NEXT t&
  dummy&=0
  quote%=0
  arg$=" "+COMMAND$
  FOR t&=2 TO LEN(arg$)
    a$=MID$(arg$,t&,1)
    IF a$=CHR$(34)
      IF (quote%=0)
        quote%=-1
        dummy&=dummy&+1
      ELSE
        quote%=0
      END IF
    ELSE
      IF ((a$=" ") AND (quote%=0)) THEN a$=""
      IF ((MID$(arg$,t&-1,1)=" ") AND (quote%=0)) THEN dummy&=dummy&+1
      IF a$<>CHR$(34) THEN arg$(dummy&)=arg$(dummy&)+a$
    END IF
  NEXT t&
  NumArgs&=dummy&
END FUNCTION
