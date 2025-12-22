MODULE 'intuition/intuition'

PROC main()
  DEF wptr, i
  wptr:=OpenW(20,50,200,100,IDCMP_CLOSEWINDOW,
              WFLG_CLOSEGADGET OR WFLG_ACTIVATE,
              'Finestra per grafica demo',NIL,1,NIL)
  IF wptr  /* Controlla se abbiamo aperto una window */
    Colour(1,3)
    TextF(20,30,'Hello World')
    SetTopaz(11)
    TextF(20,60,'Hello World')
    FOR i:=10 TO 150 STEP 8  /* Traccia alcuni punti */
      Plot(i,40,2)
    ENDFOR
    Line(160,40,160,70,3)
    Line(160,70,170,40,2)
    Box(10,75,160,85,1)
    WHILE WaitIMessage(wptr)<>IDCMP_CLOSEWINDOW
    ENDWHILE
    CloseW(wptr)
  ELSE
    WriteF('Errore -- non posso aprire la window!\n')
  ENDIF
ENDPROC
