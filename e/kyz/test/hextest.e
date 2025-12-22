MODULE '*hex'

PROC main()
  DEF val, ok, str, tests:PTR TO LONG

  tests := [
			-> the correct answers should be:
    'bAd',		-> ok, value $BAD
    'g00d',		-> fail - 'g' isn't a hex char
    '  1234',		-> ok, value $1234 (preceeding spaces OK are allowed)
    '-20',		-> fail - '-' isn't a hex char
    '1234 5678',	-> ok, value $1234 (spaces are allowed to terminate)
    'fAke',		-> fail - 'k' isn't a hex char
    '123456789101112',	-> ok, value $12345678 (stops after 8 successful chars)
    '0x',		-> fail - '0x' is OK, but there are no hex chars
    '0x$112',		-> fail - '0x' is OK, but '$' isn't a hex char
    '$0',		-> ok, value $0
    '$0x0',		-> fail - 'x' isn't a hex char
    '',			-> fail - no hex chars
    '0xDeADbEEf',	-> ok, value $DEADBEEF
    'Ca5cAdE',		-> ok, value $CA5CADE
    'b16b00b5',		-> ok, value $B16B00B5
    'ACEBA51C',		-> ok, value $ACEBA51C
    'c007c0de',		-> ok, value $C007CODE
    NIL
  ]

  WHILE str := tests[]++
    val, ok := hex(str)
    Vprintf('$\z\h[8], \d[2] := hex(''\s'')\n', [val, ok, str])
  ENDWHILE
ENDPROC
