/* like dos.library/DeleteFile() but returns only FALSE if the
** file exists but could not be deleted.
*/

OPT MODULE

MODULE 'dos/dos'
MODULE 'sven/existsFile'

/* name  - name of the file
** force - if set to TRUE also delete protected files are deleted.
*/
EXPORT PROC smartDeleteFile(name:PTR TO CHAR,force=FALSE)

  /* if the file exists, try to delete it.
  */
  IF existsFile(name)

    /* clear protection flags
    */
    IF force THEN SetProtection(name,0)
    IF DeleteFile(name)=DOSFALSE THEN RETURN FALSE

  ENDIF

ENDPROC TRUE

