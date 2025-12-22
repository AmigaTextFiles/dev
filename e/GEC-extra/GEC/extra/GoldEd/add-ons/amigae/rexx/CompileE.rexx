/* $VER: CompileE.ged v0.6 (1.2.98)
   by Leon Woestenberg (leon@stack.urc.tue.nl)
   Update by Grio

   Function: Invokes the EC v3 compiler on the source in the active window,
   and reports back success, or error. Upon error, the cursor pinpoints to
   the exact spot of error, and the status bar shows the error description.

   Usage: Call from GoldED menu as ARexx script, and set output to 'NIL:'
*/

PARSE ARG ec

OPTIONS RESULTS
OPTIONS FAILAT 200000000



IF (ec=='?') THEN DO
  SAY 'USAGE: < EC full path >'
  EXIT
END
IF (ec=='') THEN DO
   ename=0
   IF OPEN(fh,'ENV:EC_NAME','Read')~=0 THEN DO
      ename=READLN(fh)
      ok=CLOSE(fh)
   END
   IF (ename==0) | (ename=='') THEN DO
      SAY 'USAGE: < EC full path >'
      SAY 'OR Set env-variable "EC_NAME"'
      EXIT
   END
   ec='E:BIN/'||ename
END
IF (LEFT(ADDRESS(),6)~="GOLDED") THEN ADDRESS 'GOLDED.1'

'LOCK CURRENT RELEASE=4'

IF ~(rc==0) THEN EXIT


'DIR CURRENT'


SIGNAL ON SYNTAX


options='ERRLINE' 'QUIET'

'QUERY ELARGE VAR RESULT'
IF (result='TRUE') THEN options=options 'LARGE'
'QUERY EDEBUG VAR RESULT'
IF (result='TRUE') THEN options=options 'DEBUG'
'QUERY ESYM VAR RESULT'
IF (result='TRUE') THEN options=options 'SYM'
'QUERY ELDEBUG VAR RESULT'
IF (result='TRUE') THEN options=options 'LINEDEBUG'
'QUERY EICACHE VAR RESULT'
IF (result='TRUE') THEN options=options 'IGNORECACHE'
'QUERY EOPTI VAR RESULT'
IF (result='TRUE') THEN options=options 'OPTI'


'QUERY ANYTEXT'
IF (result='TRUE') THEN DO
  'QUERY DOC VAR FILEPATH'
  IF (UPPER(RIGHT(result,2))='.E') THEN DO
    'QUERY MODIFY'
    IF (result='TRUE') THEN DO
      'REQUEST STATUS="Saving changes..."'
      'SAVE ALL'
    END
    'REQUEST STATUS="Compiling source..."'
    IF (ename=='CreativE') THEN
       echopar='"FailAt 2147483647*nStack 50000*n' || ec filepath options || ' >T:EC_Report"'
    ELSE
       echopar='"FailAt 2147483647*n' || ec filepath options || ' >T:EC_Report"'
    ADDRESS COMMAND 'Echo >T:EC_Execute' echopar
   /*  ADDRESS COMMAND ec filepath options '>T:EC_Report' */
    ADDRESS COMMAND 'Execute T:EC_Execute'
    errorbyte=rc
    IF errorbyte>0 THEN DO
      'FOLD OPEN=TRUE ALL'
      'GOTO UNFOLD=TRUE LINE=' || errorbyte
      /* 'PING 9' */
    END
    IF OPEN(filehandle,'T:EC_Report','Read')~=0 THEN DO
      importance=0
      message=''
      DO WHILE ~EOF(filehandle) & importance~='ERROR'
         lastline=READLN(filehandle)
         /* messages ordered in accending importance */
         IF (INDEX(lastline,'UNREFERENCED:')~=0) & (importance<1) THEN DO
           importance=1
           message=message||lastline
         END
         IF (INDEX(lastline,'WARNING:')~=0) & (importance<2) THEN DO
           importance=2
           message=message||lastline
         END
         IF (INDEX(lastline,'ERROR:')~=0) & (importance<3) THEN DO
           importance=3
           message=message||lastline
         END
         IF (INDEX(lastline,'EC INTERNAL ERROR')~=0) & (importance<4) THEN DO
           importance=4
           message=message||lastline
         END
      END
      ok=CLOSE(filehandle)
      IF importance=0 THEN message='Compilation succesful.'
      IF importance>=3 THEN 'BEEP'
      message=TRANSLATE(message,'''','"')
      'FIX VAR message'
      'REQUEST STATUS="' || message ||'"'
    END
  END
  ELSE
    'REQUEST STATUS="Source has no .e extension!"'
END
ELSE
  'REQUEST STATUS="Say what?! Try typing some e source first :)"'

SYNTAX:
'UNLOCK'
EXIT




