/*
** $VER: GoldED_ErrorParse.rexx 1.009 (23 Oct 1995) © Stefan Berendes
**
**  FUNCTION:
**      DICE error parsing. Call GoldED on error.
**
**      This assumes that your DCC:Config/DCC.Config file contains the
**      following line:
**
**  cmd= rx DCC:Rexx/GoldED_ErrorParse.rexx %e "%c" "%f" "%0"
**
** $HISTORY:
**
** 23 Oct 1995 : 001.009 : DLINK error window handling improved
** 23 Oct 1995 : 001.008 : improved DLINK error support
** 20 Sep 1995 : 001.007 : hide requester when looking for errfile
** 14 Sep 1995 : 001.006 : redrawn windows hide requesters
** 11 Sep 1995 : 001.005 : GoldEDs status messages did overwrite error message
** 10 Sep 1995 : 001.004 : Improved errorfile handling
** 10 Sep 1995 : 001.003 : Improved window handling
** 10 Sep 1995 : 001.002 : Arrange Soucefile Window
** 18 Jun 1995 : 001.001 : initial release
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

DLINK = FALSE

IF E.LINE = 0 THEN DO
    IF LEFT(E.TEXT, 5) = 'DLINK' THEN DO
        say "There where DLink errors"
        /* This is a DLINK error, we need to handle it special */
        TT = TRANSLATE(E.STRING, '-', '"')
        DLINK = TRUE
    END
    else do
        say "unknown error"
        exit 4
    end
END

if ~show('p', 'GOLDED.DICE') then do
    address COMMAND 'RUN >NIL: <NIL: golded:golded config golded:config/golded_dice.prefs arexx GoldED.DICE'

    IF RC ~= 0 THEN DO
      Say 'Unable to open GoldED'
      exit 0
    END
end
 
if (LEFT(ADDRESS(), 6) ~= "GOLDED") then address 'GOLDED.DICE'

'LOCK CURRENT'                              /* lock GUI, gain access   */
OPTIONS FAILAT 6                            /* ignore warnings         */
SIGNAL ON SYNTAX                            /* ensure clean exit       */

/* ------------------------ INSERT YOUR CODE HERE: ------------------- */

IF DLINK = TRUE THEN DO
    'QUERY DOC VAR ACTFILENAME'

    'REQUEST STAY STATUS="There were DLINK Errors' TT '"'

    ERRFILENAME = "T:DCC_errorfile"

    'REQUEST HIDE=TRUE'
    'WINDOW QUIET USE' ERRFILENAME
    FOUND = RESULT
    'REQUEST HIDE=FALSE'

    IF FOUND = 0 THEN DO
        'OPEN NAME' EFile
        'NAME NEW' ERRFILENAME
    end
    else do
        'REQUEST STAY STATUS="No errorlist loaded"'
        'REQUEST BODY="There were errors.||Load complete list?" BUTTON="_NO|_Yes"'

        if (result= 0) THEN DO
           'OPEN NAME' EFile SMART             /* Open the file with all the errors. */
           'NAME NEW' ERRFILENAME
        end
    end

    'WINDOW USE' ACTFILENAME          /* OK, update & arrange the source file window */
    'WINDOW ARRANGE 0'

    'UNLOCK'
    exit 0
END

'WINDOW FORCE USE' E.FPATH          /* We need GoldEDs QUERY FILENAME */

'GOTO LINE'     E.LINE

if E.COL > 0 then
    'GOTO COLUMN'   E.COL
  else
    'GOTO COLUMN'   1

/* OK., check if the error win already exists. If so, don't ask if to open,
** but just update it... */

ERRFILENAME = "T:DCC_errorfile"

'REQUEST HIDE=TRUE'
'WINDOW QUIET USE' ERRFILENAME
FOUND = RESULT
'REQUEST HIDE=FALSE'

IF FOUND = 0 THEN DO
    'OPEN NAME' EFile
    'NAME NEW' ERRFILENAME
end
else do
    'REQUEST STAY STATUS="No errorlist loaded"'
    'REQUEST BODY="There were errors.||Load complete list?" BUTTON="_NO|_Yes"'

    if (result= 0) THEN DO
       'OPEN NAME' EFile SMART
       'NAME NEW' ERRFILENAME
    end
end

'WINDOW USE' E.FPATH          /* OK, update & arrange the source file window */
'WINDOW ARRANGE 0'
'REQUEST STAY STATUS="' || E.ERRNO E.STRING || '"'


/* ---------------------------- END OF YOUR CODE --------------------- */

'UNLOCK' /* VERY important: unlock GUI */
EXIT

SYNTAX:

SAY "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("
'UNLOCK'
EXIT

