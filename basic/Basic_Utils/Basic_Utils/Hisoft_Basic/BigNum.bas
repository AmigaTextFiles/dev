DECLARE FUNCTION add$(a$,b$)
DECLARE FUNCTION sub$(a$,b$)
DECLARE FUNCTION mul$(a$,b$)
DECLARE FUNCTION div$(a$,b$)

FUNCTION add$(a$,b$)
  of& = 0
  l& = MAX(LEN(a$),LEN(b$))
  a$=RIGHT$(SPACE$(l&+1)+a$,l&)
  b$=RIGHT$(SPACE$(l&+1)+b$,l&)
  FOR t& = l& TO 1 STEP -1
    erg& = VAL(MID$(a$,t&,1)) + VAL(MID$(b$,t&,1)) + of&
    MID$(a$,t&,1)=CHR$(48+ (erg& MOD 10))
    of& =INT(erg& / 10)
  NEXT t&
  IF (of& <> 0) THEN a$=CHR$(48+of&)+a$
  a$=LTRIM$(RTRIM$(a$))
  WHILE LEFT$(a$,1)="0"
    a$=MID$(a$,2)
  WEND
  IF a$="" THEN a$="0"
  add$=a$
END FUNCTION

FUNCTION sub$(a$,b$)
  of& = 0
  l& = MAX(LEN(a$),LEN(b$))
  a$=RIGHT$(SPACE$(l&+1)+a$,l&)
  b$=RIGHT$(SPACE$(l&+1)+b$,l&)
  FOR t& = l& TO 1 STEP -1
    erg& = VAL(MID$(a$,t&,1)) - VAL(MID$(b$,t&,1)) - of&
    IF erg& < 0
      erg& = erg& + 10
      of& = 1
    ELSE
      of& = 0
    END IF
    MID$(a$,t&,1)=CHR$(48 + erg&)
  NEXT t&
  IF (of& <> 0) THEN a$=CHR$(48+of&)+a$
  a$=LTRIM$(RTRIM$(a$))
  WHILE LEFT$(a$,1)="0"
    a$=MID$(a$,2)
  WEND
  IF a$="" THEN a$="0"
  sub$=a$
END FUNCTION

FUNCTION mul$(a$,b$)
  IF (a$="0" OR b$="0")
    mul$="0"
  ELSE
    q$ = a$
    WHILE (b$ <> "1")
      a$=add$(a$,q$)
      b$=sub$(b$,"1")
    WEND
    mul$=LTRIM$(RTRIM$(a$))
  END IF
END FUNCTION

FUNCTION div$(a$,b$)
  IF (LEN(a$) < LEN(b$))
    div$="0"
  ELSE
    IF (a$=b$)
      c$="1"
    ELSE
      c$ = "0"
      abbruch = 0
      WHILE (abbruch = 0)
        a$=sub$(a$,b$)
        c$=add$(c$,"1")
        a$=LTRIM$(RTRIM$(a$))
        b$=LTRIM$(RTRIM$(b$))
        IF (LEN(a$) < LEN(b$)) THEN abbruch = 1
        IF (LEN(a$)=LEN(b$) AND (a$ < b$)) THEN abbruch = 1
      WEND
    END IF
    div$=LTRIM$(RTRIM$(c$))
  END IF
END FUNCTION

REM *** Test ***************************************************************

' These functions process only integer values. The length of the numbers
' is only limited by the available memory.

w$="Y"
WHILE (w$ <> "N")
  CLS
	PRINT "Enter two integer numbers and one operator, please!"
	PRINT
	PRINT "Number #1: ";
	LINE INPUT z1$
	PRINT "Number #2: ";
	LINE INPUT z2$
	PRINT "Operator:  ";
	LINE INPUT op$
	IF ((LEFT$(z1$,1) <> "+") AND (LEFT$(z1$,1) <> "-")) THEN z1$="+"+z1$
	IF ((LEFT$(z2$,1) <> "+") AND (LEFT$(z2$,1) <> "-")) THEN z2$="+"+z2$
	sgn1$=LEFT$(z1$,1)
	sgn2$=LEFT$(z2$,1)
	z1$=MID$(z1$,2)
	z2$=MID$(z2$,2)
	PRINT "Result:    ";
	WHILE (op$ <> "")
		IF op$="/"
		  IF (sgn1$ <> sgn2$) THEN PRINT "-";
		  PRINT div$(z1$,z2$)
		  op$=""
		END IF
		IF op$="*"
		  IF (sgn1$ <> sgn2$) THEN PRINT "-";
		  PRINT mul$(z1$,z2$)
		  op$=""
		END IF
		IF op$="+"
		  IF (sgn1$ <> sgn2$)
		    sgn1$="+"
		    sgn2$="+"
		    op$="-"
		  ELSE
		    PRINT sgn1$;add$(z1$,z2$)
		    op$=""
		  END IF
		END IF
		IF op$="-"
		  IF (sgn1$ <> sgn2$)
	      op$="+"
	      sgn2$=sgn1$
	    ELSE
	      IF (LEN(z1$) < LEN(z2$)) 
	        IF sgn1$="+"
	          sgn1$="-"
	        ELSE
	          sgn1$="+"
	        END IF
	        SWAP z1$,z2$
	      END IF
	      IF ((LEN(z1$) = LEN(z2$)) AND (LEFT$(z1$,1) < LEFT$(z2$,1)))
	        IF sgn1$="+"
	          sgn1$="-"
	        ELSE
	          sgn1$="+"
	        END IF
	        SWAP z1$,z2$
	      END IF
	      PRINT sgn1$;sub$(z1$,z2$)
	      op$=""
		  END IF
		END IF
	WEND
	PRINT
	PRINT "Continue (Y|N)";
	w$=UCASE$(INPUT$(1))
WEND
END

REM ************************************************************************
