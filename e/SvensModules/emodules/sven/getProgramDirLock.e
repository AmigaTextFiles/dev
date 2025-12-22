/* returns a lock to the directory where the program resides.
** No matter if it was started from workbench or from cli.
*/

OPT MODULE

MODULE 'workbench/startup'

EXPORT PROC getProgramDirLock()
DEF wb:PTR TO wbstartup

  IF wb:=wbmessage
    -> started from WB? then return the lock from the startup message
    RETURN wb.arglist.lock
  ENDIF
  -> call dos.library to get the lock if started from cli
ENDPROC GetProgramDir()

