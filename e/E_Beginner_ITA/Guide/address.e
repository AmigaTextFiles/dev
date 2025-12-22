DEF x

PROC main()
  fred(2)
ENDPROC

PROC fred(y)
  DEF z
  WriteF('x è all''indirizzo \d\n', {x})
  WriteF('y è all''indirizzo \d\n', {y})
  WriteF('z è all''indirizzo \d\n', {z})
  WriteF('fred è all''indirizzo \d\n', {fred})
ENDPROC
