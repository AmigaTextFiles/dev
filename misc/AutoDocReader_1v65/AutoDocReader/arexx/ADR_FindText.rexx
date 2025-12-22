/* Find any text in all files in ADR database          */
/* usage:                                              */
/* rx ADR_FindFunction <any_text> <database_file_name> */

ADDRESS "ADR.1"

/* get arguments */

PARSE ARG PAR1 " " PAR2

/* execute command */

ADR_FindText PAR1 PAR2

EXIT
