PROC itoa (str, int)
  /*-----------------------------------------------------------------*/
  /* Converts an integer to an estring.  str must be large enough to */
  /* accomodate int, otherwise this function returns NIL.            */
  /*-----------------------------------------------------------------*/
  DEF len,
      power = 0,
      c = 0,
      i
  IF (len := StrMax (str)) = 0 THEN RETURN NIL
  IF int = 0  /* Zero is a special case. */
    str [c++] := "0"
  ELSE        /* Non-zero is a typical case. */
    IF int < 0
      str [c++] := "-"  /* Negative number. */
      int := Abs (int)
    ENDIF
    WHILE exp (10, power) <= int DO INC power
    WHILE (power > 0)
      IF c >= len THEN RETURN NIL
      DEC power
      i := Div (int, (exp (10, power)))
      str [c++] := i + "0"
      int := int - (i * exp (10, power))
    ENDWHILE
  ENDIF
  SetStr (str, c)
ENDPROC  str
  /* itoa */
