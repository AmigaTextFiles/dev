/*
    GoldEd version.

    Load 'filename' and goes to 'line'
*/

OPTIONS RESULTS                             /* enable return codes     */

if (LEFT(ADDRESS(), 6) ~= "GOLDED") then    /* not started by GoldEd ? */
    address 'GOLDED.1'

'LOCK CURRENT RELEASE=4'                    /* lock GUI, gain access   */

if (RC ~= 0) then
    exit

OPTIONS FAILAT 6                            /* ignore warnings         */

SIGNAL ON SYNTAX                            /* ensure clean exit       */

/* ------------------------ INSERT YOUR CODE HERE: ------------------- */

PARSE ARG filename line

'OPEN NAME 'FILENAME' SMART QUIET'
'GOTO LINE 'LINE' UNFOLD TRUE'
/* ---------------------------- END OF YOUR CODE --------------------- */

'UNLOCK' /* VERY important: unlock GUI */
EXIT

SYNTAX:

SAY "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("
'UNLOCK'
EXIT

