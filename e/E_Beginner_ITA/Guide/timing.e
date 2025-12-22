OPT LARGE

MODULE 'dos/dos'

CONST TICKS_PER_MINUTE=TICKS_PER_SECOND*60, LOTS_OF_TIMES=500000

DEF x, y, offset

PROC fred(n)
  DEF i
  i:=n+x
ENDPROC

/* Ripete la valutazione di un'espressione */
PROC repeat(exp)
  DEF i
  FOR i:=0 TO LOTS_OF_TIMES
    Eval(exp) /* Valuta l'espressione */
  ENDFOR
ENDPROC

/* Misura un'espressione e assegna l'offset se non è stato già fatto */
PROC test(exp, message)
  DEF t
  IF offset=0 THEN offset:=time(`0)  /* Calcola l'offset */
  t:=time(exp)
  WriteF('\s:\t\d ticks\n', message, t-offset)
ENDPROC

/* Misura le chiamate ripetute, e calcola il numero di ticks */
PROC time(x)
  DEF ds1:datestamp, ds2:datestamp
  Forbid()
  DateStamp(ds1)
  repeat(x)
  DateStamp(ds2)
  Permit()
  IF CtrlC() THEN CleanUp(1)
ENDPROC ((ds2.minute-ds1.minute)*TICKS_PER_MINUTE)+ds2.tick-ds1.tick

PROC main()
  x:=9999
  y:=1717
  test(`x+y,     'Addizione')
  test(`y-x,     'Sottrazione')
  test(`x*y,     'Moltiplicazione')
  test(`x/y,     'Divisione')
  test(`x OR y,  'Bitwise OR')
  test(`x AND y, 'Bitwise AND')
  test(`x=y,     'Uguaglianza')
  test(`x<y,     'Minore di')
  test(`x<=y,    'Minore di o uguale a')
  test(`y:=1,    'Assegnazione di 1')
  test(`y:=x,    'Assegnazione di x')
  test(`y++,     'Incremento')
  test(`IF FALSE THEN y ELSE x, 'IF FALSE')
  test(`IF TRUE THEN y ELSE x,  'IF TRUE')
  test(`IF x THEN y ELSE x,     'IF x')
  test(`fred(2),  'fred(2)')
ENDPROC
