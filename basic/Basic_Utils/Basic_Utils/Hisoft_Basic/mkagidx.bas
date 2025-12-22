REM $STACK
REM $NOEVENT
REM $BREAK
REM $NOAUTODIM
REM $NOLINES
REM $NODEBUG
REM $NOOVERFLOW
REM $NOADDICON
REM $NOERRORS
REM $INCPATH MB_INCLUDES:BH
REM $LIBPATH MB_INCLUDES:BMAP
REM $NOWINDOW
REM $NOLIBRARY
REM MAXONBASIC3

LIBRARY "dos.library"
DECLARE FUNCTION Execute&(c&,i&,o&) LIBRARY
LIBRARY OPEN "dos.library"

DECLARE SUB shell(BYVAL cmd$)
DECLARE FUNCTION replace$(satz$, wort$, neu$)
DECLARE FUNCTION NumArgs&

ver$=CHR$(0)+"$VER: mkagidx 36.1 (06.10.97) "

DIM Arg$(127)

b$="T:Temp.guide"
c$="T:Index"
d$=""

IF (NumArgs& = 0)
  PRINT "mkagidx: Required argument missing"
  END
ELSE
  a$=Arg$(1)
END IF

IF a$="?"
  PRINT "Usage: mkagidx filename.guide [newname.guide]"
  PRINT
  PRINT "mkagidx creates the index of a given AmigaGuide document. An existing"
  PRINT "index will be updated."
  PRINT
  PRINT "If the second filename is omitted, the resulting AmigaGuide document"
  PRINT "will replace the original file."
  END
END IF

IF (NumArgs& > 1)
  k$=Arg$(2)
ELSE
  k$=a$
END IF

IF FEXISTS(a$)
  POKE SYSTAB+33,0
  PRINT "Examining document..."
	OPEN "i",1,a$
	OPEN "o",2,b$
	DO
	  LINE INPUT #1,x$
	  IF UCASE$(LEFT$(x$,7))="@INDEX " THEN d$=LTRIM$(RTRIM$(MID$(x$,8)))
	  IF ((UCASE$(LEFT$(x$,10))="@NODE MAIN" OR UCASE$(LEFT$(x$,12))="@NODE "+CHR$(34)+"MAIN"+CHR$(34)) AND (d$=""))
	    d$="TheIndex"
	    PRINT #2,"@Index "+d$
	  END IF
	  IF d$ <> ""
	    e$ = "@NODE "+d$
	    e = LEN(e$)
	    IF UCASE$(LEFT$(x$,e))=UCASE$(e$)
	      DO
	        LINE INPUT #1,x$
	      LOOP UNTIL UCASE$(x$)="@ENDNODE"
	    ELSE
	      PRINT #2,x$
	    END IF
	  ELSE
	    PRINT #2,x$
	  END IF
	LOOP UNTIL EOF(1)
	CLOSE #1
	CLOSE #2
  PRINT "Creating index..."
  r$ = ""
	OPEN "i",1,b$
	OPEN "o",2,c$
	DO
	  LINE INPUT #1,x$
	  t = 0
	  DO 
	    t = t + 1
	    y$ = MID$(x$,t,1)
	    IF y$ = "{"
	      DO
	        t = t + 1
	        z$ = MID$(x$,t,1)
	        y$ = y$ + z$
	      LOOP UNTIL (z$ = "}")
	      w$=CHR$(160)
	      n$=" "
	      y$ = replace$(y$,w$,n$)
	      w$ = "  "
	      n$ = " "
	      y$ = replace$(y$,w$,n$)
	      w$ = "{"+CHR$(34)+" "
	      n$ = "{"+CHR$(34)
	      y$ = replace$(y$,w$,n$)
	      w$ = " "+CHR$(34)+" "
	      n$ = CHR$(34)+" "
	      y$ = replace$(y$,w$,n$)
	      w$ = CHR$(34)+"link "
	      n$ = CHR$(34)+" link "
	      y$ = replace$(y$,w$,n$)
	      IF ((INSTR(y$, "link") <> 0) AND (r$ <> y$))
	        PRINT #2,"@"+y$
	        r$ = y$
	      END IF
	    END IF
	  LOOP UNTIL (t >= LEN(x$))
	LOOP UNTIL EOF(1)
	CLOSE 1
	CLOSE 2
  IF FEXISTS(c$)
    PRINT "Sorting index..."
  	shell "SORT "+c$+" "+c$
  ELSE
    PRINT "mkagidx: Error creating index"
    END
  END IF
  t$=""
  IF FEXISTS(c$)
    PRINT "Formatting index..."
		OPEN "i",1,c$
		OPEN "a",2,b$
		PRINT #2,"@node "+d$+" Index"
		PRINT #2,"@remark Index created with 'mkagidx' (C) Captain CrossBones"
		r$ = ""
		DO
		  LINE INPUT #1,x$
		  IF (UCASE$(MID$(x$,4,1)) <> t$)
		    IF t$ <> "" THEN PRINT #2
		    t$ = UCASE$(MID$(x$,4,1))
		    PRINT #2,t$
		    PRINT #2
		  END IF
		  IF x$ <> r$
  		  PRINT #2,x$
  		  r$ = x$
  		END IF
		LOOP UNTIL EOF(1)
		PRINT #2,"@endnode"
		CLOSE 1
		CLOSE 2
		PRINT "Linking index to document..."
		shell "copy "+b$+" "+k$
		IF (a$ <> k$)
		  shell "copy "+a$+".info "+k$+".info >NIL:"
		END IF
		PRINT "Deleting temporary files..."
		KILL c$
		KILL b$
	ELSE
	  PRINT "mkagidx: Error linking index"
	  END
	END IF
ELSE
  PRINT "mkagidx: File not found"
END IF
END

SUB shell(BYVAL cmd$)
  cmd$=cmd$+CHR$(0)
  cmd&=SADD(cmd$)
  s&=Execute&(cmd&,0,0)
END SUB

FUNCTION replace$(BYVAL satz$, wort$, neu$)
	DO 
	  t% = INSTR(satz$, wort$)
	  IF (t% <> 0) 
	    satz$ = LEFT$(satz$, t% - 1) + neu$ + MID$(satz$, t% + LEN(wort$))
	  END IF
	LOOP UNTIL (t% = 0)
	replace$ = satz$
END FUNCTION

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
