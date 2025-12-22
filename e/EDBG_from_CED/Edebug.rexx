/* Ecompile.rexx: run E compiler from ced.
   thanks to Rick Younie for improvements. */

epath = 'run:'					/* homedir of EC */

OPTIONS RESULTS
ADDRESS COMMAND

ADDRESS 'rexx_ced'

'wbtofront'

'status 19'					/* ask ced filename */
file = result

'status 20'					/* ask ced filepath */
path = result

'status 18'
IF result ~= 0 THEN DO				/* save if changed */
  'save' file
  SAY 'saving changes..'
END
ELSE SAY 'no changes..'

PARSE VAR file comparg '.e'			/* strip the extension */
SAY 'invoking E compiler with file' comparg'.e'

ADDRESS
OPTIONS FAILAT 1000000
'run:ec ' comparg ' DEBUG WB ERRBYTE'			/* run compiler */
ebyte = rc
SAY 'error at 'rc

'execute e:rexx/cd_and_run_EDBG' path comparg

ADDRESS
'cedtofront'
IF ebyte>0 THEN 'jump to byte' ebyte		/* jump to spot of error */
exit 0
