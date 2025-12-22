MODULE 'dos/dos'

PROC main()
  x:=9999
  y:=1717
  test(`x+y,     'Addition')
  test(`y-x,     'Subtraction')
  test(`x*y,     'Multiplication')
  test(`x/y,     'Division')
  test(`x | y,   'Bitwise OR')
  test(`x & y,   'Bitwise AND')
  test(`x=y,     'Equality')
  test(`x<y,     'Less than')
  test(`x<=y,    'Less than or equal')
  test(`y:=1,    'Assignment of 1')
  test(`y:=x,    'Assignment of x')
  test(`y++,     'Increment')
  test(`IF FALSE THEN y ELSE x, 'IF FALSE')
  test(`IF TRUE THEN y ELSE x,  'IF TRUE')
  test(`IF x THEN y ELSE x,     'IF x')
  test(`fred(2), 'fred(2)')
ENDPROC

CONST TICKS_PER_MINUTE=TICKS_PER_SECOND*60, LOTS_OF_TIMES=500000

DEF x, y, offset

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
  PrintF('\s:\t\d ticks\n', message, t-offset)	
ENDPROC

/* Time the repeated calls, and calculate number of ticks */
PROC time(x)(LONG)
  DEF ds1:DateStamp, ds2:DateStamp
  Forbid()
  DateStamp(ds1)
  repeat(x)
  DateStamp(ds2)
  Permit()
  IF CtrlC() THEN Exit(1)
ENDPROC ((ds2.Minute-ds1.Minute)*TICKS_PER_MINUTE)+ds2.Tick-ds1.Tick
