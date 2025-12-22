/* runs an external program asynchronly.
** You pass the command and the extra tags (SystemTagList-Tags or CreateNewProc-Tags).
**
** Returns TRUE or FALSE
**
** Eq.: IF runback(StringF(hstri,'c:more \s',filename))=FALSE
**        DisplayBeep(NIL)
**      ENDIF
*/

OPT MODULE
OPT PREPROCESS

MODULE 'dos/dos','dos/dostags',
       'utility/tagitem'

EXPORT PROC runback(command:PTR TO CHAR,tags=NIL) IS
  SystemTagList(command,
                [SYS_ASYNCH, TRUE,
                 SYS_INPUT,  NIL,  -> never forget!!
                 SYS_OUTPUT, NIL,
                 TAG_MORE,   tags])<>DOSTRUE

