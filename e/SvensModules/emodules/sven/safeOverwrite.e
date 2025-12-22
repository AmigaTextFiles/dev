/* enables save overwriting of files by creating an backup (*.bak).
**
** Usage:
**
**   IF initSafeOverwrite(filename)
**
**     error:=safeMyNewFile(filename)
**
**     endSafeOverwrite(filename,error=NO_ERROR)
**
**   ELSEIF request('Could not make backup. Proceed anyway?','Yes|No')
**
**     IF smartDeleteFile(filename)
**
**       error:=safeMyNewFile(filename)
**
**     ELSE
**       error:=ERROR_Delete
**     ENDIF
**
**   ENDIF
**   report_error(error)
*/

OPT MODULE

MODULE 'dos/dos'
MODULE 'sven/existsFile',
       'sven/smartDeleteFile'


/* call this proc to rename an existing file.
** returns TRUE on sucess.
**
** Note: An already existing backup-file is deleted (even if it is
**       delete protected)!!
*/
EXPORT PROC initSafeOverwrite(name:PTR TO CHAR)
DEF newname[256]:STRING

  /* check if there is already an file named 'name'
  */
  IF existsFile(name)

    /* add the backup extension to the file name
    */
    addBackupExt(newname,name)

    /* delete the old backup file (if there is any).
    */
    IF smartDeleteFile(newname,TRUE)=FALSE THEN RETURN FALSE

    /* rename the file
    */
    IF Rename(name,newname)=DOSFALSE THEN RETURN FALSE

  ENDIF

ENDPROC TRUE


/* call this proc to end an safe overwriting.
** Depending on 'success' the backup-file is deleted (TRUE)
** or the old file is restored (FALSE).
** returns TRUE on sucess.
**
** Note: An already existing file/backup-file is deleted (even if it is
**       delete protected)!!
*/
EXPORT PROC endSafeOverwrite(name:PTR TO CHAR,success=TRUE)
DEF newname[256]:STRING

  addBackupExt(newname,name)

  IF success

    /* everythink went ok. So check if an backup file exists
    ** and try to delete it.
    */
    IF smartDeleteFile(newname,TRUE)=FALSE THEN RETURN FALSE

  ELSE

    /* an error occured. So delete the file and rename the
    ** backup file. If there is no backup file, do nothing.
    */
    IF existsFile(newname)

      IF smartDeleteFile(name,TRUE)=FALSE THEN RETURN FALSE

      IF Rename(newname,name)=DOSFALSE THEN RETURN FALSE

    ENDIF

  ENDIF

ENDPROC TRUE


PROC addBackupExt(newstr,name) IS StrAdd(StrCopy(newstr,name),'.bak')

