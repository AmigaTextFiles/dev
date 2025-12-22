SUB STRING Trim(a$)
{Deletes leading / trailing blanks and control characters}
  t$=""
  STRING x SIZE 2
  FOR q% = 1 TO LEN(a$)
    x = MID$(a$,q%,1)
    if ((ASC(x) AND 127) > 32) THEN
      t$ = t$ + x
    END IF
  NEXT q%
  Trim = t$
END SUB
