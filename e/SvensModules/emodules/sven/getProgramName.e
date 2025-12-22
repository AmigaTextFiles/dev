/* returns a name of program (filename).
** No matter if it was started from workbench or from cli.
*/

OPT MODULE

MODULE 'workbench/startup'

/* copies the program name in 'estri' (must be large enough).
** returns 'estri'.
*/
EXPORT PROC getProgramName(estri)
DEF wb:PTR TO wbstartup

  IF wb:=wbmessage
    -> started from wb. Get the name from the startup message
    StrCopy(estri,wb.arglist.name)
  ELSE
    -> cli-started. Ask dos.library about the name
    GetProgramName(estri,StrMax(estri))
  ENDIF
ENDPROC estri

