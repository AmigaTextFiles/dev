/*
 *	File:					Sort.rexx
 *	Description:	A small script to show the usage of REQUEST and SORT.
 *
 *	(C) 1995, Ketil Hunn
 *
 */

OPTIONS RESULTS

REQUEST '"Sort message" "Sort commands or arguments?" "Commands|Arguments|Cancel"'
IF RESULT==1 THEN
	SORT COMMANDS
ELSE IF RESULT==2 THEN
	SORT ARGUMENTS
