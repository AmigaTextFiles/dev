/* An old E example converted to PortablE.
  From Jason R Hulance's "A Beginner's Guide to Amiga E". */

OPT POINTER
MODULE 'intuition/intuition'
MODULE 'intuition', 'graphics'

PROC main()
  DEF wptr:PTR TO window, i
  wptr:=OpenW(20,50,200,100,IDCMP_CLOSEWINDOW,
              WFLG_CLOSEGADGET OR WFLG_ACTIVATE,
              'Graphics demo window',NIL,1,NIL)
  IF wptr  /* Check to see we opened a window */
    Colour(1,3)
    TextF(20,30,'Hello World')
    SetTopaz(11)
    TextF(20,60,'Hello World')
    FOR i:=10 TO 150 STEP 8  /* Plot a few points */
      Plot(i,40,2)
    ENDFOR
    Line(160,40,160,70,3)
    Line(160,70,170,40,2)
    Box(10,75,160,85,1)
    WHILE WaitIMessage(wptr)<>IDCMP_CLOSEWINDOW
    ENDWHILE
    CloseW(wptr)
  ELSE
    Print('Error -- could not open window!\n')
  ENDIF
ENDPROC
