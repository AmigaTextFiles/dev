/* Open any file */
/* usage:                      */
/* rx ADR_FileOpen <file_name> */

ADDRESS "ADR.1"

/* get filename */

PARSE ARG PAR1

/* execute command */

ADR_FileOpen PAR1

EXIT
