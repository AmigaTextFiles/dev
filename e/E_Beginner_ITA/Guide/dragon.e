MODULE 'intuition/intuition', 'graphics/view'

/* Dimensione schermo, usa SIZEY=512 per uno schermo PAL */
CONST SIZEX=640, SIZEY=400

/* Valori exception */
ENUM WIN=1, SCRN, STK, BRK

/* Direzioni (DIRECTIONS dà un numero alle direzioni) */
ENUM NORTH, EAST, SOUTH, WEST, DIRECTIONS

RAISE WIN  IF OpenW()=NIL,
      SCRN IF OpenS()=NIL

/* Inizia a puntare a WEST */
DEF state=WEST, x, y, t

/* Fronte sinistro */
PROC left()
  state:=Mod(state-1+DIRECTIONS, DIRECTIONS)
ENDPROC

/* Muove a destra, cambiando state */
PROC right()
  state:=Mod(state+1, DIRECTIONS)
ENDPROC

/* Muove nella direzione del fronte attuale */
PROC move()
  SELECT state
  CASE NORTH; draw(0,t)
  CASE EAST;  draw(t,0)
  CASE SOUTH; draw(0,-t)
  CASE WEST;  draw(-t,0)
  ENDSELECT
ENDPROC

/* Disegna e muove nella relativa posizione specificata */
PROC draw(dx, dy)
  /* Controlla che la linea venga disegnata nei limiti della window */
  IF (x>=Abs(dx)) AND (x<=SIZEX-Abs(dx)) AND
     (y>=Abs(dy)) AND (y<=SIZEY-10-Abs(dy))
    Line(x, y, x+dx, y+dy, 2)
  ENDIF
  x:=x+dx
  y:=y+dy
ENDPROC

PROC main() HANDLE
  DEF sptr=NIL, wptr=NIL, i, m
  /* Legge gli argomenti   :        [m [t [x  [y]]]] */
  /* così possiamo scrivere: dragon  16              */
  /*                      o: dragon  16 1            */
  /*                      o: dragon  16 1 450        */
  /*                      o: dragon  16 1 450 100    */
  /* m è il depth del dragon, t è la lunghezza delle linee */
  /* (x,y) è la posizione di partenza */
  m:=Val(arg, {i})
  t:=Val(arg:=arg+i, {i})
  x:=Val(arg:=arg+i, {i})
  y:=Val(arg:=arg+i, {i})
  /* Se m o t è zero usa un default più logico */
  IF m=0 THEN m:=5
  IF t=0 THEN t:=5
  sptr:=OpenS(SIZEX,SIZEY,4,V_HIRES OR V_LACE,'Dragon Curve Screen')
  wptr:=OpenW(0,10,SIZEX,SIZEY-10,
              IDCMP_CLOSEWINDOW,WFLG_CLOSEGADGET,
              'Dragon Curve Window',sptr,$F,NIL)
  /* Disegna la dragon curve */
  dragon(m)
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
    WriteF('Non posso aprire lo schermo\n')
  CASE STK
    WriteF('Stack non sufficiente per la ricorsione\n')
  CASE BRK
    WriteF('L''utente abbandona\n')
  ENDSELECT
ENDPROC

/* Disegna la dragon curve (da sinistra) */
PROC dragon(m)
  /* Controlla lo stack e ctrl-C prima della ricorsione */
  IF FreeStack()<1000 THEN Raise(STK)
  IF CtrlC() THEN Raise(BRK)
  IF m>0
    dragon(m-1)
    left()
    nogard(m-1)
  ELSE
    move()
  ENDIF
ENDPROC

/* Disegna la dragon curve (da destra) */
PROC nogard(m)
  IF m>0
    dragon(m-1)
    right()
    nogard(m-1)
  ELSE
    move()
  ENDIF
ENDPROC
