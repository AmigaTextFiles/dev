/* An old E example converted to PortablE.
  From Jason R Hulance's "A Beginner's Guide to Amiga E". */

OPT POINTER
OPT STACK=10000
MODULE 'intuition/intuition', 'graphics/view'
MODULE 'dos', 'exec', 'graphics', 'intuition'

/* Screen size, use SIZEY=512 for a PAL screen */
CONST SIZEX=640, SIZEY=400

/* Exception values */
ENUM WIN=1, SCRN, STK, BRK

/* Directions (DIRECTIONS gives number of directions) */
ENUM NORTH, EAST, SOUTH, WEST, DIRECTIONS

RAISE WIN  IF OpenW()=NIL,
      SCRN IF OpenS()=NIL

/* Start off pointing WEST */
DEF state=WEST, x, y, t

/* Face left */
PROC left()
  state:=Mod(state-1+DIRECTIONS, DIRECTIONS)
ENDPROC

/* Move right, changing the state */
PROC right()
  state:=Mod(state+1, DIRECTIONS)
ENDPROC

/* Move in the direction we're facing */
PROC move()
  SELECT state
  CASE NORTH; draw(0,t)
  CASE EAST;  draw(t,0)
  CASE SOUTH; draw(0,-t)
  CASE WEST;  draw(-t,0)
  ENDSELECT
ENDPROC

/* Draw and move to specified relative position */
PROC draw(dx, dy)
  /* Check the line will be drawn within the window bounds */
  IF (x>=Abs(dx)) AND (x<=SIZEX-Abs(dx)) AND (y>=Abs(dy)) AND (y<=SIZEY-10-Abs(dy))
    Line(x, y, x+dx, y+dy, 2)
  ENDIF
  x:=x+dx
  y:=y+dy
ENDPROC

PROC main()
  DEF sptr:PTR TO screen, wptr:PTR TO window, i:LONG, m
  /* Read arguments:        [m [t [x  [y]]]] */
  /* so you can say: dragon  16              */
  /*             or: dragon  16 1            */
  /*             or: dragon  16 1 450        */
  /*             or: dragon  16 1 450 100    */
  /* m is depth of dragon, t is length of lines */
  /* (x,y) is the start position */
  m:=Val(arg, ADDRESSOF i)
  t:=Val(arg:=arg+i, ADDRESSOF i)
  x:=Val(arg:=arg+i, ADDRESSOF i)
  y:=Val(arg:=arg+i, ADDRESSOF i)
  /* If m or t is zero use a more sensible default */
  IF m=0 THEN m:=5
  IF t=0 THEN t:=5
  sptr:=OpenS(SIZEX,SIZEY,4,V_HIRES OR V_LACE !!VALUE!!INT,'Dragon Curve Screen')
  wptr:=OpenW(0,10,SIZEX,SIZEY-10,
              IDCMP_CLOSEWINDOW,WFLG_CLOSEGADGET,
              'Dragon Curve Window',sptr,$F,NIL)
  /* Draw the dragon curve */
  dragon(m)
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
  CASE STK
    Print('Ran out of stack in recursion\n')
  CASE BRK
    Print('User aborted\n')
  ENDSELECT
ENDPROC

/* Draw the dragon curve (with left) */
PROC dragon(m)
  /* Check stack and ctrl-C before recursing */
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

/* Draw the dragon curve (with right) */
PROC nogard(m)
  IF m>0
    dragon(m-1)
    right()
    nogard(m-1)
  ELSE
    move()
  ENDIF
ENDPROC
