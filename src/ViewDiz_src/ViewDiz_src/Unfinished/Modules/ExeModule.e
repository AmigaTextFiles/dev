OBJECT myargs
  file, cmd, dir, desc
ENDOBJECT
->cmd: read, write, delete, info, execute

PROC main()
  DEF args:PTR TO myargs, rdargs=NIL
  args:=New( SIZEOF myargs )
  IF rdargs:=ReadArgs( 'FILE/A,CMD/A,DIR/A,DESC/K', args, NIL)
    UpperStr(args.cmd)

    IF InStr(args.cmd,'READ')<>-1
    ENDIF

    IF InStr(args.cmd,'WRITE')<>-1
    ENDIF

    IF InStr(args.cmd,'DELETE')<>-1
    ENDIF

    IF InStr(args.cmd,'EXECUTE')<>-1
    ENDIF

    IF InStr(args.cmd,'INFO')<>-1
    ENDIF
    FreeArgs(rdargs)
  ENDIF
ENDPROC
