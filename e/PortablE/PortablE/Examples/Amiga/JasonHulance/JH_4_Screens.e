/* An old E example converted to PortablE.
  From Jason R Hulance's "A Beginner's Guide to Amiga E". */

OPT POINTER
MODULE 'intuition/intuition', 'graphics/view'
MODULE 'intuition', 'graphics'

ENUM WIN=1, SCRN

RAISE WIN  IF OpenW()=NIL,
      SCRN IF OpenS()=NIL

PROC main()
  DEF sptr:PTR TO screen, wptr:PTR TO window, i
  sptr:=OpenS(640,200,4,V_HIRES !!VALUE!!INT,'Screen demo')
  wptr:=OpenW(0,20,640,180,IDCMP_CLOSEWINDOW,
              WFLG_CLOSEGADGET OR WFLG_ACTIVATE,
              'Graphics demo window',sptr,$F,NIL)
  TextF(20,20,'Hello World')
  FOR i:=0 TO 15  /* Draw a line and box in each colour */
    Line(20,30,620,30+(7*i),i)
    Box(10+(40*i),140,30+(40*i),170,1)
    Box(11+(40*i),141,29+(40*i),169,i)
  ENDFOR
  WHILE WaitIMessage(wptr)<>IDCMP_CLOSEWINDOW
  ENDWHILE
FINALLY
  IF wptr THEN CloseW(wptr)
  IF sptr THEN CloseS(sptr)
  SELECT exception
  CASE 0
    Print('Program finished successfully\n')
  CASE WIN
    Print('Could not open window\n')
  CASE SCRN
    Print('Could not open screen\n')
  ENDSELECT
ENDPROC
