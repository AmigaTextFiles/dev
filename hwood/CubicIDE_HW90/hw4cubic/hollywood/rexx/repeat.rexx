/* rexx macro */

options results                             /* enable return codes     */

if (left(address(), 6) ~= "GOLDED") then    /* not started by GoldEd ? */

    address 'GOLDED.1'

'LOCK CURRENT RELEASE=4'                    /* lock GUI, gain access   */

if (RC ~= 0) then

    exit

options failat 6                            /* ignore warnings         */

signal on syntax                            /* ensure clean exit       */

/* ------------------------ INSERT YOUR CODE HERE: ------------------- */

'INSERT LINE'
'TEXT STAY T="Repeat"'
'DOWN'

'INSERT LINE'
'PING SLOT 0'
'TEXT STAY T="     "'

'DOWN'
'INSERT LINE'
/*'DOWN'*/

'INSERT LINE'
'TEXT STAY T="Until"'
'DOWN'

'PONG SLOT=0'
'LEFT'

/* ---------------------------- END OF YOUR CODE --------------------- */

'UNLOCK' /* VERY important: unlock GUI */

exit

SYNTAX:

SAY "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("

'UNLOCK'

exit
