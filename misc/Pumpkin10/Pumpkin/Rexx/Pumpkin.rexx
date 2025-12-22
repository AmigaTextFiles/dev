/***************************************************************************
**                         Pumpkin startup script.                        **
***************************************************************************/

/*
** We want results
*/
Options results

/*
** Make CygnusEd screen public
*/
menu 1 15 2

/*
** Move CygnusEd screen to front
*/
cedtofront

/*
** Get the filename from CygnusEd (placed in result)
*/
status 19

/*
** Start Pumpkin
*/
address command 'Run >NIL:' 'DH0:C/Pumpkin' 'CX_POPKEY' '"alt p"' 'CX_PRIORITY' 1 'FILE' result

RETURN
