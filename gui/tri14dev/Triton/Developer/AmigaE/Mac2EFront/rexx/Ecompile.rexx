/* Ecompile.rexx: run E compiler from ced.
   thanks to Rick Younie for improvements. */

epath = 'e:bin/'					/* homedir of EC */

OPTIONS RESULTS
ADDRESS COMMAND

IF ~EXISTS('ram:copy') THEN 'copy c:copy ram:'			/* the copy command */
/*IF ~EXISTS('ram:ec') THEN 'ram:copy 'epath'ec ram:'		/* for slow sys: devices */*/
IF ~EXISTS('ram:delete') THEN 'copy c:delete ram:'		/* the delete command */

ADDRESS 'rexx_ced'

'status 19'						/* ask ced filename */
file = result

'status 18'
IF result ~= 0 THEN DO				/* save if changed */
  'save' file                           /* we're saving file.e */
  SAY 'saving changes of file 'file
END
ELSE SAY 'no changes..'

SAY 'invoking Mac2EFront with'file
ADDRESS
OPTIONS FAILAT 10000
'E:bin/flushcache'
'delete t:tmp_SPP.e QUIET'
'copy 'file' t:tempsource'

comm = 'e:bin/mac2efront t:tmp_SPP.e t:tempsource'

SAY comm							/* echo what we're doing */
comm								/* and then do it.. */

IF ~EXISTS('t:tmp_SPP.e') THEN 'copy 'file' t:tmp_SPP.e'
'delete t:tempsource QUIET'

PARSE VAR file comparg '.e'			/* strip the extension */

SAY 'invoking E compiler with (t:tmp_SPP.e of) file ' comparg'.e '

'e:bin/ec IGNORECACHE WB REG=3 t:tmp_SPP'			/* compile file  t:tmp_SPP.e */
eline=rc

'ram:copy t:tmp_SPP 'comparg' QUIET'

SAY 'running the executable 'comparg
IF EXISTS(comparg) THEN comparg		/* run exe */
SAY 'returnvalue of 'comparg' : 'rc

'ram:delete t:tmp_SPP QUIET'			/* delete the temporary files */
/*'ram:delete t:tmp_SPP.e QUIET'          /* source can be found while running */
*/

ADDRESS
pull								/* wait for a <cr> */
ADDRESS 'rexx_ced'
'cedtofront'
IF eline>0 THEN 'jump to line' eline 	/* jump to spot of error */
exit 0
