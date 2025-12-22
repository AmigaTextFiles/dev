OPT MODULE
OPT EXPORT

PROC realval(string,xrealptr:PTR TO LONG)
DEF l,xwert=0,count,xneg=1,k,dezflag=FALSE,bigflag=FALSE
DEF fraktcount=0,xrealold,xreal=0,endflag=FALSE
xrealptr[]:=0.0
k:=0;count:=0
IF string[k]="-"
  xneg:=-1
  k++
ELSEIF string[k]="+"
  k++
ENDIF
IF ((string[k]>="0") AND (string[k]<="9")) OR (string[k]=".")
  REPEAT
    IF (string[k]>="0") AND (string[k]<="9")
      IF Not(bigflag)
        xwert:=(string[k]-"0")
        xrealold:=xreal
        xreal:=Mul(10,xreal)+xwert
        IF xreal>=$7FFFFF         -> MaxInt does fit in 23 Bit
          xreal:=xrealold
          bigflag:=TRUE
        ELSE
          IF dezflag THEN fraktcount--
        ENDIF
      ELSE
        IF Not(dezflag) THEN fraktcount++
      ENDIF
    ELSEIF string[k]="."
      dezflag:=TRUE
    ELSEIF (string[k]="E") OR (string[k]="e")
      endflag:=TRUE
      k++
      IF string[k]="+" THEN k++   -> Val can't understand +
      count,l:=Val(string+k)
      k:=k+l
      fraktcount:=fraktcount+count
    ELSE
      endflag:=TRUE
    ENDIF
    k++
  UNTIL endflag
  xrealptr[]:=!(xreal!)*Fpow(fraktcount!,10.0)*(xneg!)
  k--
ELSE
  k:=0
ENDIF
ENDPROC k

