OPT TURBO

PROC cSkipToEDelim(pos:PTR TO CHAR)
  DEF c
  /* Finds the next E delimiter in a string and returns its position. */
  WHILE (c:=pos[])
    IF c>122 THEN RETURN pos      /* "z" */
    IF c<95                       /* "_" */
      IF c>90 THEN RETURN pos     /* "Z" */
      IF c<65                     /* "A" */
        IF c>57 THEN RETURN pos   /* "9" */
        IF c<48 THEN RETURN pos   /* "0" */
      ENDIF
    ENDIF
    INC pos
  ENDWHILE
ENDPROC pos
  /* cSkipToEDelim */

