OPT TURBO

PROC cSkipNonWhite(pos:PTR TO CHAR)
  DEF c
  WHILE (c:=pos[])
    SELECT c
      CASE 32; RETURN pos    /* SPACE */
      CASE  9; RETURN pos    /* TAB */
      CASE 10; RETURN pos    /* LF */
      CASE 13; RETURN pos    /* CR */
      DEFAULT; INC pos
    ENDSELECT
  ENDWHILE
ENDPROC pos
  /* cSkipNonWhite */
