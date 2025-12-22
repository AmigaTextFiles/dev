/*
*/
MODULE 'intuition/intuition'

PROC main()
  DEF wptr, i
  wptr:=OpenW(20,50,200,100,IDCMP_CLOSEWINDOW,
              WFLG_CLOSEGADGET OR WFLG_ACTIVATE,
              'Graphics demo window',NIL,1,NIL)
  IF wptr  /* Check to see we opened a window */
    Colour(1,3)
    TextF(20,30,'Hello World')
    SetTopaz(11)
    TextF(20,60,'Hello World')
    FOR i:=10 TO 150 STEP 8  /* Plot a few points */
      Plot(i,40,1)
    ENDFOR
    Line(160,40,160,70,3)
    Line(160,70,170,40,2)
    Ellipse(60,70,40,10,2)
    Circle(60,90,20)
    Box(10,75,160,85,1)
    WHILE WaitIMessage(wptr)<>IDCMP_CLOSEWINDOW
    ENDWHILE
    CloseW(wptr)
  ELSE
    WriteF('Error -- could not open window!\n')
  ENDIF
ENDPROC
