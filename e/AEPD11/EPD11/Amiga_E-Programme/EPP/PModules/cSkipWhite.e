OPT TURBO

PROC cSkipWhite(pos:PTR TO CHAR)
  DEF c
  WHILE (c:=pos[])
    SELECT c
      CASE 32; INC pos  /* SPACE */
      CASE  9; INC pos  /* TAB */
      CASE 10; INC pos  /* LF */
      DEFAULT; RETURN pos
    ENDSELECT
  ENDWHILE
ENDPROC pos
  /* cSkipWhite */

