/* returns TRUE if an file already exists.
*/

OPT MODULE

MODULE 'dos/dos'

EXPORT PROC existsFile(name:PTR TO CHAR)
DEF fh

  IF fh:=Open(name,MODE_OLDFILE)
    Close(fh)
    RETURN TRUE
  ENDIF

ENDPROC FALSE

