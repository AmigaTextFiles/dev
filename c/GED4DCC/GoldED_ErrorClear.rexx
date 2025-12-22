/*
** $VER: GoldED_ErrorClear.rexx 1.001 (07.01.95) © Gian Maria Calzolari
**
**
**  FUNCTION:
**      DICE Error Parsing Script, must be called from within GoldEd. Clear
**          all the errors. Script for GoldEd © Dietemar Eilert
**
** Notes: Add this to a Function key as an Arexx cmd to always have it
**          ready to use!
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

ADDRESS DICE_ERROR_PARSER Clear

'REQUEST PROBLEM="All errors have been cleared!"'

/* ---------------------------- END OF YOUR CODE --------------------- */

'UNLOCK' /* VERY important: unlock GUI */
EXIT

SYNTAX:

SAY "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("
'UNLOCK'
EXIT

