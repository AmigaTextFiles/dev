/* Find function in ADR database                            */
/* usage:                                                   */
/* rx ADR_FindFunction <function_name> <database_file_name> */

ADDRESS "ADR.1"

/* get arguments */

PARSE ARG PAR1 " " PAR2

/* execute command */

ADR_FindFunction PAR1 PAR2

EXIT
