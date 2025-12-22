/**/
OPTIONS RESULTS
OPTIONS FAILAT 10

PARSE ARG filename

IF filename="" THEN
DO
  SAY 'USAGE: INSERTFILE filename'
  RETURN
END

ADDRESS 'EE.0'

LockWindow

?InsertMode; insertState=RESULT
IF insertState THEN InsertMode

?JustifyNewline; justifyState=RESULT
IF justifyState THEN JustifyNewline

IF Open(inputFile, filename, 'R') THEN DO UNTIL eof
  inputLine=Readln(inputFile)
  eof=Eof(inputfile)
  IF eof=0 THEN PutLine inputline
END
ELSE SAY 'Could not open file.'

IF insertState  THEN InsertMode
IF justifyState THEN JustifyNewline
UnlockWindow
