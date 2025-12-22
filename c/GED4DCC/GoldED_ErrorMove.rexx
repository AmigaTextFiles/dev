/*
** $VER: GoldED_ErrorMove.rexx 1.001 (07.01.95) © Gian Maria Calzolari
**
**
**  FUNCTION:
**      DICE Error Parsing Script, must be called from within GoldEd and goes
**          through the errors. Script for GoldEd © Dietemar Eilert
**
**      Commands:
**          Current
**          First
**          Next
**          Prev
**
** Notes: Add this to a Function key (i.e. F1) as an Arexx cmd to always have
**          it ready to use!
**
**        This assumes that your DCC:Config/DCC.Config file contains the
**         following line:
**
**  cmd= rx DCC:Rexx/GoldED_ErrorParse.rexx %e "%c" "%f" "%0"
**
** $HISTORY:
**
** 07 Jan 1995 : 001.001 : First release. Created by Gian Maria Calzolari
**                          (2:332/502.11 2:332/801.19)
**
*/

OPTIONS RESULTS

parse upper arg COMMAND

portname = 'DICE_ERROR_PARSER'  /* DICEHelp's port name */

/*
** do nothing if the error parser isn't loaded!
*/

if ~show('p',portname) then exit

if (LEFT(ADDRESS(), 6) ~= "GOLDED") then address 'GOLDED.1'

'LOCK CURRENT'                              /* lock GUI, gain access   */
OPTIONS FAILAT 6                            /* ignore warnings         */
SIGNAL ON SYNTAX                            /* ensure clean exit       */

/* ------------------------ INSERT YOUR CODE HERE: ------------------- */

/*
** Get info on the next error
*/

ADDRESS DICE_ERROR_PARSER COMMAND E

IF rc ~= 0 THEN DO
    'REQUEST PROBLEM="No More Errors"'
    'UNLOCK' /* VERY important: unlock GUI */
    EXIT
END

IF E.LINE = 0 THEN DO

    IF LEFT(E.TEXT, 5) = 'DLINK' THEN DO
        /* This is a DLINK error, we need to handle it special */
        TT = TRANSLATE(E.STRING, '-', '"')
        'REQUEST PROBLEM="There were DLINK Errors' TT '"'
        'UNLOCK' /* VERY important: unlock GUI */
        EXIT
    END

END

'QUERY DOC'

if (result ~= E.FPATH) then 'OPEN NAME' E.FPATH SMART

'GOTO LINE'     E.LINE              /* Jump straight to the line number. */
'GOTO COLUMN'   E.COL               /* Jump straight to the column number. */

'REQUEST PROBLEM="' || E.ERRNO E.STRING || '"'

/* ---------------------------- END OF YOUR CODE --------------------- */

'UNLOCK' /* VERY important: unlock GUI */
EXIT

SYNTAX:

SAY "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("
'UNLOCK'
EXIT

