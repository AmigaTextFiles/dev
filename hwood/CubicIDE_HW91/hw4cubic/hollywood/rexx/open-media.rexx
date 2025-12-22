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

/* File: open-media.rexx
 * Author: (C) Copyright 2008 by Michael "Clyde Radcliffe" Jurisch
 * Description: Shows pictures etc. with multiview after right clicking
 *              at file name
 * Version: 1.0
 * TODO:
 */

'EXTRACT VAR=FILENAME' /* the filename under the cursor */

POS = lastpos(".", FILENAME) /* at which position starts the file ending/suffix? */

SUFFIX = upper(substr(FILENAME, POS)) /* extract the suffix an make it upper case */

NAME = STRIP(FILENAME, 'B', ',') /* delete commas, if they are part of filename (could happen, if cursor is over the closing " of the filename */
NAME = STRIP(NAME, 'B', '"') /* delete ", if they are part of filename (could happen, if cursor is over the closing " of the filename */

'RUN ASYNC CMD="multiview FILE=*"' || NAME || '*""'

/* ---------------------------- END OF YOUR CODE --------------------- */

'UNLOCK' /* VERY important: unlock GUI */

exit

SYNTAX:

SAY "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("

'UNLOCK'

exit
