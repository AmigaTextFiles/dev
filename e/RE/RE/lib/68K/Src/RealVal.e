OPT NOHEAD,NOEXE
PROC  RealVal(str)
  DEF divider=1.0,fraction=0.0,sign=1.0
  DEF x=0
  DEF pre=TRUE,n,oldstr

  oldstr:=str
  WHILE (str[]=" ") OR (str[]="\n") OR (str[]="\t") OR (str[]="+") DO str++
  IF str[]="-"
    sign:=-1.0
    str++
  ENDIF
  WHILE str[]
    SELECT str[]
      CASE "0" TO "9"
        n:=(str[]-"0")
        IF pre
          x:=x*10+n
        ELSE
          fraction:=!fraction*10.0+(n!)
          divider:=!divider*10.0
        ENDIF
      CASE "."
        pre:=FALSE
    ENDSELECT
    str++
  ENDWHILE
  x:=!(x!)+(!fraction/divider) ->FIXME: do use double precision
ENDPROC !x*sign,str-oldstr
