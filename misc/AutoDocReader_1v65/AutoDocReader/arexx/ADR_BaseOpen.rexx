/* Open ADR database file      */
/* usage:                      */
/* rx ADR_BaseOpen <file_name> */

ADDRESS "ADR.1"

/* get filename */

PARSE ARG PAR1

/* execute command */

ADR_BaseOpen PAR1

EXIT
