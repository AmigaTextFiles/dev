MODULE 'workbench/startup'

PROC main()
  DEF startup:PTR TO WBStartup, args:PTR TO WBArg, i, oldlock, len
  IF (startup:=wbmessage)=NIL
    WriteF('Started from Shell/CLI\n \d  Arguments: "\s"\n', FileLength(arg),arg)
  ELSE
    WriteF('Started from Workbench\n')
    args:=startup.ArgList
    FOR i:=1 TO startup.NumArgs  /* Loop through the arguments */
      IF args[].Lock=NIL
        WriteF('  Argument \d: "\s" (no lock)\n', i, args[].Name)
      ELSE
        oldlock:=CurrentDir(args[].Lock)
        len:=FileLength(args[].Name)  /* Do something with file */
        IF len=-1
          WriteF('  Argument \d: "\s" (file does not exist)\n',
                 i, args[].Name)
        ELSE
          WriteF('  Argument \d: "\s", file length is \d bytes\n',
                 i, args[].Name, len)
        ENDIF
        CurrentDir(oldlock) /* Important: restore current dir */
      ENDIF
      args++
    ENDFOR
  ENDIF
ENDPROC

