/* Execute any Arexx command with max 2 arguments        */
/* usage:                                                */
/* rx ADR_Command <command_name> <argument1> <argument2> */

ADDRESS "ADR.1"

/* get arguments   */

PARSE ARG COMMAND " " PAR1 " " PAR2

/* execute command */

COMMAND PAR1 PAR2

EXIT
