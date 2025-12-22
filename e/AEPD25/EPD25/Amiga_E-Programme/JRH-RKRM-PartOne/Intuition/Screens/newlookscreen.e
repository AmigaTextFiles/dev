-> PrArgs.e - This program prints all Workbench or Shell (CLI) arguments.
-> E-Note: ignore all the rubbish (in the C version) about start-ups

MODULE 'other/split',
       'workbench/startup'

PROC main()
  DEF argmsg:PTR TO wbstartup, wb_arg:PTR TO wbarg, ktr, olddir,
      argv:PTR TO LONG
  -> wbmessage is non-NIL when run from the Workbench, NIL when run from the CLI
  IF wbmessage
    -> E-Note: WriteF opens its own output window, if necessary
    -> wbmessage contains a pointer to the WBStartup message
    argmsg:=wbmessage
    wb_arg:=argmsg.arglist  -> Head of the arg list

    WriteF('Run from the Workbench, \d args.\n', argmsg.numargs)

    FOR ktr:=0 TO argmsg.numargs-1
      IF wb_arg.lock<>NIL
        -> Locks supported, change to the proper directory
        olddir:=CurrentDir(wb_arg.lock)

        -> Process the file.
        -> If you have done the CurrentDir() above, then you can access the file
        -> by its name.  Otherwise, you have to examine the lock to get a
        -> complete path to the file.
        WriteF('\tArg \d[2] (w/ lock): "\s".\n', ktr, wb_arg.name)

        -> Change back to the original directory when done.  Be sure to change
        -> back before you exit.
        CurrentDir(olddir)
      ELSE
        -> Something that does not support locks
        WriteF('\tArg \d[2] (no lock): "\s".\n', ktr, wb_arg.name)
      ENDIF
      wb_arg++
    ENDFOR
    -> E-Note: no need to wait: output window closes after a RETURN press
  ELSE
    -> E-Note: WriteF opens its own output window, if necessary
    -> E-Note: argSplit() splits arg into a NIL-terminated E-list, which can be
    ->         used like C's argv (except that the first element of the list is
    ->         the first argument, not the program n