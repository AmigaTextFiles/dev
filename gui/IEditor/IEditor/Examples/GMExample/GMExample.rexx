/*
** $VER: GMExample.rexx 0.002 (08.02.96) © Gian Maria Calzolari
**
**
**  FUNCTION:
**      Let's try the two GMExample's ARexx cmds...
**
** $HISTORY:
**
** 08 Feb 1996 : 000.002 : Corrected a few errors and adapted to the latest
**                          executable!
** 10 Dec 1995 : 000.001 : First version!
**
*/

OPTIONS RESULTS

SIGNAL ON ERROR

ADDRESS GMEXAMPLE.1

/* Let's see what's into the string gadget... */
GetTheString
StringText = result

say "The string gadget contains <" || StringText || ">"

/* Let's put something into the string gadget... */
'PutTheString' 'Dummy!'

/* Let's see what's into the string gadget... */
GetTheString
StringText = result

say "...now the string gadget contains <" || StringText || ">!"

'GimmeFive' '"Each parameters (up to two)" "are between square brackets"'

/* the parm will be traslated to uppercase */
'GimmeFive' 1st_parameter

'GimmeFive' '"1st parameter with more than one single word" 2nd_parameter'

/* the parms won't be traslated to uppercase */
'GimmeFive' '1st_parameter' '2nd_parameter'

Quit

EXIT

ERROR:
    say 'Error' RC 'on line' SIGL
    EXIT RC
