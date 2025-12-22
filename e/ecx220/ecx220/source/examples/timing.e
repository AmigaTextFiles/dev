OPT PREPROCESS
/* LS 2004: some modifications to be a bit more correct on powerpc */

MODULE 'dos/dos'
CONST TICKS_PER_MINUTE=TICKS_PER_SECOND*60,
   #ifdef __PPC__
   LOTS_OF_TIMES=8000000
   #else
   LOTS_OF_TIMES=800000
   #endif

DEF x, y, offset

PROC fred(n)
  DEF i
  i:=n+x
ENDPROC

PROC fredE(n) HANDLE
  DEF i
  i:=n+x
EXCEPT DO
   NOP
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
  /* do it twice, cpu cashes might influence result */
  t:=time(exp)
  WriteF('\s:\t\d ticks\n', message, t-offset)
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
ENDPROC (ds2.minute-ds1.minute * TICKS_PER_MINUTE)+(ds2.tick-ds1.tick)

PROC main()

  x:=9999
  y:=1717

  /* calculate offset twice, use first result */
  offset:=time(`0)
  time(`0)

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
  test(`IF FALSE THEN y ELSE x, 'IF FALSE THEN y ELSE x')
  test(`IF TRUE THEN y ELSE x,  'IF TRUE THEN y ELSE x')
  test(`IF x THEN y ELSE x,     'IF x THEN y ELSE x')
  test(`fred(2),  'fred(2)')
  test(`fredE(2),  'fredE(2)')
ENDPROC


