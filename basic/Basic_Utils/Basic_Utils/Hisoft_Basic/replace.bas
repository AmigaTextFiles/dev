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

DIM Arg$(127)

DECLARE FUNCTION NumArgs&

DECLARE FUNCTION replace$(satz$, wort$, neu$)

ArgCount& = NumArgs&

ver$="$VER: replace 36.1 (07.10.97) "

IF (Arg$(1)="?")
  PRINT "Usage: replace filename search replace"
  PRINT
  PRINT "replace replaces all occurances of 'search' in 'filename' by 'replace'."
  PRINT
  PRINT "The whole file will be loaded into memory."
  END
END IF

IF (ArgCount& <2)
  PRINT "replace: Required argument missing"
  END
END IF

datei$=Arg$(1)
such$=Arg$(2)
ersatz$=Arg$(3)

IF FEXISTS(datei$)
	OPEN "i",1,datei$
	t$=INPUT$(LOF(1),1)
	CLOSE 1
  OPEN "o",2,datei$
  PRINT #2,replace$(t$,such$,ersatz$)
  CLOSE 2	
ELSE
  PRINT "replace: File not found"
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

FUNCTION replace$(BYVAL satz$, wort$, neu$)
	DO 
	  t% = INSTR(satz$, wort$)
	  IF (t% <> 0) 
	    satz$ = LEFT$(satz$, t% - 1) + neu$ + MID$(satz$, t% + LEN(wort$))
	  END IF
	LOOP UNTIL (t% = 0)
	replace$ = satz$
END FUNCTION
