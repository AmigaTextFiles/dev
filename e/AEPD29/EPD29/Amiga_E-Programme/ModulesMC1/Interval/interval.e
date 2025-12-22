
OPT MODULE
OPT EXPORT
DEF currentsecs, currentmicros

/* To initialize, or to reset time to 0, call interval(TRUE).
   To display interval, call interval(). Calling interval()
   again will display elapsed time since previous call.  */

PROC interval(start=FALSE)
DEF oldsecs, oldmicros
  IF start=FALSE
    oldsecs:=currentsecs; oldmicros:=currentmicros
    CurrentTime({currentsecs},{currentmicros})
    IF currentmicros<oldmicros
      oldsecs:=oldsecs+1; oldmicros:=oldmicros-1000000
    ENDIF
    WriteF('Elapsed time \d.\z\d[6]\n',currentsecs-oldsecs,
				       currentmicros-oldmicros)
  ELSE
    CurrentTime({currentsecs},{currentmicros})

  ENDIF
ENDPROC
