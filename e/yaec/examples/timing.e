->OPT LARGE

MODULE 'dos/dos'

CONST TICKS_PER_MINUTE=TICKS_PER_SECOND*60, LOTS_OF_TIMES=5000000

DEF x:PTR TO LONG, y, offset, str[100]:STRING

PROC fred(n)
  DEF i
  i:=n+x
ENDPROC

/* Repeat evaluation of an expression */
PROC repeat(exp)
  DEF i
  FOR i:=0 TO LOTS_OF_TIMES
    Eval(exp) /* Evaluate the expresssion */
  ENDFOR
ENDPROC

/* Time an expression, and set-up offset if not done already */
PROC test(exp, message)
  DEF t
  IF offset=0 THEN offset:=time(`0)  /* Calculate offset */
  t:=time(exp)
  WriteF('\s:\t\d ticks\n', message, t-offset)  
ENDPROC

/* Time the repeated calls, and calculate number of ticks */
PROC time(x)
  DEF ds1:datestamp, ds2:datestamp
  Forbid()
  DateStamp(ds1)
  repeat(x)
  DateStamp(ds2)
  Permit()
  IF CtrlC() THEN Raise(1)
ENDPROC ((ds2.minute-ds1.minute)*TICKS_PER_MINUTE)+ds2.tick-ds1.tick

PROC main()
  x:=9999
  y:=1717

  test(`x+y,     'Addition')
  test(`y-x,     'Subtraction')
  test(`x*y,     'Multiplication')
  test(`x/y,     'Division')
  test(`x OR y,  'Bitwise OR')
  test(`x AND y, 'Bitwise AND')
  test(`x=y,     'Equality')
  test(`x<y,     'Less than')
  test(`x<=y,    'Less than or equal')
  test(`y:=1,    'Assignment of 1')
  test(`y:=x,    'Assignment of x')
  test(`y++,     'Increment')
  test(`IF x = FALSE THEN y ELSE x, 'IF x = FALSE')
  test(`IF x = TRUE THEN y ELSE x,  'IF x = TRUE')
  test(`IF x THEN y ELSE x,     'IF x')
  test(`fred(2),  'fred(2)')

  /* some more tests.. */
  test(`Mul(10,20), 'Mul(10,20)')
  test(`Div(10,20), 'Div(10,20)')
  test(`Char({x}),  'Char({x})')
  test(`x!+100.0-(10.0*(x+y!)),  'x!+100.0-(10.0*(x+y!))')
  test(`(x := FastNew(100)) BUT FastDispose(x, 100) BUT NIL,  'x:=FastNew(100) BUT FastDispose(x, 100)')
  test(`Eval(`x++),  'Eval(`x++)')
  ->test(`StringF(str, '\d[10] \s \h[5] \c', x, 'NIL', y, "b"), 
  ->      'StringF(str, \a\d[10] \s \h[5] \c\a, x, \aNIL\a, y, \qb\q)')
  test(`bla(),  'bla()')
  

ENDPROC

PROC bla() HANDLE
   DEF s[100]:STRING
EXCEPT
ENDPROC s
