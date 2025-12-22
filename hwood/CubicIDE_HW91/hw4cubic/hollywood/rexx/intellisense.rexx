/* remember that the first line of every Rexx script must be a comment */

options results                             /* enable return codes     */

if (left(address(), 6) ~= "GOLDED") then    /* not started by GoldEd ? */

    address 'GOLDED.1'

'LOCK CURRENT RELEASE=4'                    /* lock GUI, gain access   */

if (RC ~= 0) then

    exit

options failat 6                            /* ignore warnings         */

signal on syntax                            /* ensure clean exit       */

/* ------------------------ INSERT YOUR CODE HERE: ------------------- */

/* File: intellisense.rexx
 * Author: (C) Copyright 2008 - 2012 by Michael "Clyde Radcliffe" Jurisch
 * Description: Realizes a better intellisense than the standard in Cubic IDE with ESC
 * Version: 1.2
 * TODO:
 */
'QUERY SCREEN VAR=SCREEN' /* get screen which is used for Cubic in order to show requester on the same screen */

'RUN ASYNC CMD="Hollywood golded:add-ons/hollywood/tools/intellisense.hwa -quiet -pubscreen ' || SCREEN || '" WAITPORT="NX_01_ENTERPRISE"'

'LEFT' /* move cursor one colon to left, so a word is under the cursor; Fehler, falls man auf _erstem_ Zeichen ist*/
'QUERY WORD VAR=WORD' /* the wanted word */

/* the port of Hollywood script under golded:add-ons/hollywood/tools/intellisense */
ADDRESS NX_01_ENTERPRISE

/* send the word under the cursor to the Hollywood script */
DummyFunc_1 WORD

ADDRESS /* switch to Cubic address env */
if (WORDS(RESULT) = 1) then do /* word count is 1, when just one Hollywood command was found; that is "ENTRY=HwCommand" */
    POSITION = POS("=", RESULT) /* find the position, where the = occurs; use that to determine HwCommand */

    COMPWORD = SUBSTR(RESULT, POSITION + 1) /* No list dialog is necessary then, just insert the one command found */

    'DELETE WORD' /* delete the word under the cursor before ... */
    'TEXT T="' || COMPWORD || '"' /* ... inserting the choosen function/word */

end

/*'DELETE WORD' /* delete the word under the cursor before ... */
'TEXT T="' || COMPWORD || '"' /* ... inserting the choosen function/word */
*/
/* ---------------------------- END OF YOUR CODE --------------------- */

'UNLOCK' /* VERY important: unlock GUI */

exit

SYNTAX:

SAY "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("

'UNLOCK'

exit
