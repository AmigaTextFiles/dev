/*
** $VER: GoldED_ErrorParse.rexx 1.002 (03.02.95) © Gian Maria Calzolari
**
**
**  FUNCTION:
**      DICE Error Parsing Script.  Script for GoldEd © Dietemar Eilert
**
**  Notes: This assumes that your DCC:Config/DCC.Config file contains the
**         following line:
**  cmd= rx DCC:Rexx/GoldED_ErrorParse.rexx %e "%c" "%f" "%0"
**
** $HISTORY:
**
** 03 Feb 1995 : 001.002 : It wasn't able to handle an erron in 'column 0'
** 07 Jan 1995 : 001.001 : First not-beta release. Now it goes also to the
**                          column with the error
** 19 Nov 1994 : 000.003 : ...also the error(s) file will be loaded
** 18 Nov 1994 : 000.002 : Now it will open a new window only if the current
**                          one is not empty and the file isn't already loaded
** 12 Nov 1994 : 000.001 : Created by Gian Maria Calzolari (2:332/502.11
**                          2:332/801.19), derives from CED_ErrorParse.rexx
**
*/

OPTIONS RESULTS

PARSE ARG EFile '"' Fn '" "' CurDir '" "' CFile '" "' VPort '"'

IF VPort = '?' THEN VPort = ''

portname = 'DICE_ERROR_PARSER'  /* DICEHelp's port name */

if ~show('p',portname) then do
    address COMMAND 'RUN >NIL: <NIL: DError REXXSTARTUP'

    do i = 1 to 6

        if ~show('p',portname) then address COMMAND 'wait 1'

        if ~show('p',portname) then do
            say "Dice Error Parser (DERROR) program not found!"
            address COMMAND 'type' EFile
            exit
        end
    end
end

/**
 ** Get the error messages loaded in.
 ** This will return a list of lines within the file that have
 ** errors associated with them (if any)
 **/

ADDRESS DICE_ERROR_PARSER LOAD EFile '"'CurDir'" "'Fn'" "'VPort'"'
LINES = RESULT

/**
 ** Get info on the current error
 **/

ADDRESS DICE_ERROR_PARSER Current E

IF rc ~= 0 THEN DO
    SAY 'No More Errors'
    exit 0
END

IF E.LINE = 0 THEN DO

    IF LEFT(E.TEXT, 5) = 'DLINK' THEN DO
        /* This is a DLINK error, we need to handle it special */
        SAY 'There were DLINK Errors'
        ADDRESS COMMAND TYPE EFILE
        exit 0
    END
END

if ~show('p', 'GOLDED.1') then do
    address COMMAND 'RUN >NIL: <NIL: ed'

    IF RC ~= 0 THEN DO
      Say 'Unable to open GoldED'
      exit 0
    END
end
 
if (LEFT(ADDRESS(), 6) ~= "GOLDED") then address 'GOLDED.1'

'LOCK CURRENT'                              /* lock GUI, gain access   */
OPTIONS FAILAT 6                            /* ignore warnings         */
SIGNAL ON SYNTAX                            /* ensure clean exit       */

/* ------------------------ INSERT YOUR CODE HERE: ------------------- */

'QUERY DOC'

if (result ~= E.FPATH) then 'OPEN NAME' E.FPATH SMART

'GOTO LINE'     E.LINE              /* Jump straight to the line number. */

if E.COL > 0 then
    'GOTO COLUMN'   E.COL               /* Jump straight to the column number. */
  else
    'GOTO COLUMN'   1

'OPEN NAME' EFile SMART             /* Open the file with all the errors. */

'WINDOW ARRANGE 0'

'REQUEST PROBLEM="' || E.ERRNO E.STRING || '"'

/* ---------------------------- END OF YOUR CODE --------------------- */

'UNLOCK' /* VERY important: unlock GUI */
EXIT

SYNTAX:

SAY "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("
'UNLOCK'
EXIT

