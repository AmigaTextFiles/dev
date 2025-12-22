/* global routine enabling to pass strings as exceptioninfos even
** if they are local.
** Just do Throw("ANY",StrCopy(getExceptionString(),'Exception info'))
** or write an PROC throwExceptionString(exception, string)
*/

OPT MODULE
OPT PREPROCESS

DEF exceptionstri:PTR TO CHAR

RAISE "MEM" IF String()=NIL

EXPORT PROC getExceptionString()
  IF exceptionstri=NIL THEN exceptionstri:=String(256)
ENDPROC exceptionstri

