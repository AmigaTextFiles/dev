MODULE 'workbench/startup'

PROC main()
  DEF startup:PTR TO wbstartup, args:PTR TO wbarg, i, oldlock, len
  IF (startup:=wbmessage)=NIL
    WriteF('Lanciato dalla Shell/CLI\n   Argomenti: "\s"\n', arg)
  ELSE
    WriteF('Lanciato dal Workbench\n')
    args:=startup.arglist
    FOR i:=1 TO startup.numargs  /* Loop del numero di argomenti */
      IF args[].lock=NIL
        WriteF('  Argomento \d: "\s" (no lock)\n', i, args[].name)
      ELSE
        oldlock:=CurrentDir(args[].lock)
        len:=FileLength(args[].name)  /* Fa qualcosa con il file */
        IF len=-1
          WriteF('  Argomento \d: "\s" (il file non esiste)\n',
                 i, args[].name)
        ELSE
          WriteF('  Argomento \d: "\s", la lunghezza del file è \d bytes\n',
                 i, args[].name, len)
        ENDIF
        CurrentDir(oldlock) /* Importante: ripristinare dir corrente */
      ENDIF
      args++
    ENDFOR
  ENDIF
ENDPROC
