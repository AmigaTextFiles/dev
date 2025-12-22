OPT NOHEAD,NOEXE,CPU='WUP'
PROC Val(s:PTR TO CHAR,read=0:PTR TO LONG)
  DEF  num=0,sign=1,running=TRUE,n
  
  n := s ->store address
  WHILE (s[]="\t") OR (s[]=" ") OR (s[]="+") DO s++
  IF s[]="-"
    sign:=-1
    s++
  ENDIF
  IF (s[]="0") THEN s++
  IF (s[]="%") OR (s[]="b")            // BINARY number
    s++
    WHILE (s[]="0") OR (s[]="1")
      num<<=1
      num|=s[]-"0"
      s++
    ENDWHILE
  ELSEIF (s[]="$") OR (s[]="x")        // HEXADECIMAL number
    WHILE running
      s++
      SELECT s[]
        CASE "0" TO "9"
          num<<= 4
          num |= s[]-"0"
        CASE "a" TO "f"
          num<<= 4
          num |= s[]-"a"+10
        CASE "A" TO "F"
          num<<= 4
          num |= s[]-"A"+10
        DEFAULT
          running:=FALSE
      ENDSELECT
    ENDWHILE
  ELSE                                // DECIMAL number
    WHILE (s[]>="0") AND (s[]<="9")
      num*=10
      num+=s[]-"0"
      s++
    ENDWHILE
  ENDIF
  n:=s-n
  IF read THEN read[] := n
ENDPROC num*sign,n
