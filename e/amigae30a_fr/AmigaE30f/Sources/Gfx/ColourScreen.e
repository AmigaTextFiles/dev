/* Très simple démo d'ouverture d'un écran personnel */

PROC main()
  DEF screen,sx,sy
  IF screen:=OpenS(321,257,5,0,'Ecran Amiga E')
    LOOP
      FOR sx:=0 TO 320
        FOR sy:=0 TO 256 DO Plot(sx,sy,sx*sy+1)
        IF Mouse()=1 THEN RETURN CloseS(screen) AND 0
      ENDFOR
    ENDLOOP
  ENDIF
ENDPROC
