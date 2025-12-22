-> discovers offsets of standard E globals
-> Use this to create eglobs.i, or such.

PROC main()
  DEF a4, n:PTR TO LONG
  MOVE.L A4,a4

  n:=[
  'stdout',	{stdout},
  'conout',	{conout},
  'stdin',	{stdin},
  'arg',	{arg},
  'stdrast',    {stdrast},
  'wbmessage',	{wbmessage},
  'execbase',	{execbase},
  'dosbase',	{dosbase},
  'intuibase',	{intuitionbase},
  'gfxbase',	{gfxbase},
  NIL]

  WHILE n[] DO WriteF('\s=\d\n', n[]++, n[]++ - a4)
ENDPROC
