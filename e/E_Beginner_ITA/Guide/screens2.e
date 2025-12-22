MODULE 'intuition/intuition', 'graphics/view'

ENUM WIN=1, SCRN

RAISE WIN  IF OpenW()=NIL,
      SCRN IF OpenS()=NIL

PROC main() HANDLE
  DEF sptr=NIL, wptr=NIL, i
  sptr:=OpenS(640,200,4,V_HIRES,'Screen demo')
  wptr:=OpenW(0,20,640,180,IDCMP_CLOSEWINDOW,
              WFLG_CLOSEGADGET OR WFLG_ACTIVATE,
              'Finestra per grafica demo',sptr,$F,NIL)
  TextF(20,20,'Hello World')
  FOR i:=0 TO 15  /* Disegna una linea e un box per ogni colore */
    Line(20,30,620,30+(7*i),i)
    Box(10+(40*i),140,30+(40*i),170,1)
    Box(11+(40*i),141,29+(40*i),169,i)
  ENDFOR
  WHILE WaitIMessage(wptr)<>IDCMP_CLOSEWINDOW
  ENDWHILE
EXCEPT DO
  IF wptr THEN CloseW(wptr)
  IF sptr THEN CloseS(sptr)
  SELECT exception
  CASE 0
    WriteF('Programma terminato con successo\n')
  CASE WIN
    WriteF('Non posso aprire la window\n')
  CASE SCRN
    WriteF('Non posso aprire lo screen\n')
  ENDSELECT
ENDPROC
