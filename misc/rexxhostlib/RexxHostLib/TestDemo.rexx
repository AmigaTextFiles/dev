/* A test program for the fancy demo.  To run, issue  */
/* the command testdemo from fancy's command window   */
arg code

address 'FancyDemo'

'good'   /* a command */
say 'rc=' rc 'result=' result

'BAD'    /* another command */
say 'rc=' rc 'result=' result

/* now request a result string (an extension in ARexx) */
options results
say 'Requesting results'

'good'   /* the good command again */
say 'rc=' rc 'result=' result


/* try it with three arguments. */
good job man

exit 10   /* return the argument */
