
MODULE 'other/stderr'

PROC main() HANDLE
DEF fh, file
file:='RAM:test.txt'
err_Name('StdErrTest')
err_WriteF('StdErr test.\nLook in \s\n',[file]) -> NOTE: argument passing.
fh := Open('RAM:',0)
IF fh = NIL
 err_WriteF() -> You don't HAVE to say anything.
ELSE
 Close(fh)
ENDIF
err_New(file)
err_WriteF('I can print errors to a file, too!\n')
err_New(stdout)
err_WriteF('Redirectable stdout text.\n')
err_New()  -> Without options, will go to StdErr port
err_WriteF('Non-redirectable stderr text.\n')
err_Dispose()
EXCEPT
 SELECT exception
  CASE "MEM"
   WriteF('Not enough memory.\n')
  CASE "FILE"
   WriteF('File i/o error.\n')
  CASE "OPEN"
   WriteF('Open file error.\n')
  DEFAULT
   WriteF('SOME kind of error occured.\n')
 ENDSELECT

ENDPROC
/*EE folds
-1
EE folds*/
