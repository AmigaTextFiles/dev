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

/* File: word-help-guide.rexx
 * Author: (C) Copyright 2008 by Michael "Clyde Radcliffe" Jurisch
 * Description: Looks for the word under the cursor in the Hollywood help file
 * Version: 1.0
 * TODO: handle ; $, Repeat and so on (see guide index)
 */

'QUERY WORD VAR=WORD' /* get the word under the cursor */

/* handle preprocessor commands */
if (substr(RESULT, 1, 1) = "@") then do /* find out, whether first char of word is @ */
    WORD = "at" || substr(RESULT, 2) /* ignore @ and add "at" for correct guide parsing*/
end

/* handle OBSOLETE preprocessor commands */
if (substr(RESULT, 1, 1) = "%") then do /* find out, whether first char of word is % */
    WORD = substr(RESULT, 2) /* ignore % for correct guide parsing*/
end

if (RESULT = "") then do /* if nothing is under the cursor open Main section */
    'HELP CATALOG="hollywood:Help/hollywood.guide" TOPIC="Main"'
end
else do /* open the correct help section for the word */
    'HELP CATALOG="hollywood:Help/hollywood.guide" TOPIC="' || WORD || '"'
end
/* ---------------------------- END OF YOUR CODE --------------------- */

'UNLOCK' /* VERY important: unlock GUI */

exit

SYNTAX:

SAY "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("

'UNLOCK'

exit
