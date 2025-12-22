/* _Very_ simple customscreen-demo */

PROC main()
  DEF screen,sx,sy
  IF screen:=OpenS(800,600,8,0,'My Screen')
     FOR sx:=0 TO 799
        FOR sy:=0 TO 599 DO Plot(sx,sy,sx*sy+1)
        EXIT Mouse()
     ENDFOR
     Delay(300)
     CloseS(screen)
  ENDIF
ENDPROC
