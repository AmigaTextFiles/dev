MODULE 'dos/rdargs', 'dos/var', 'dos/dos', 'dos/dostags'

OBJECT next
  wz:PTR TO LONG
ENDOBJECT

OBJECT myargs
  file
  wizard
ENDOBJECT

PROC main()
  DEF rdargs=NIL, args:PTR TO myargs, str[200]:STRING,
      rda:PTR TO rdargs, i=0, nargs:PTR TO next, nnargs:PTR TO LONG,
      rrdargs:PTR TO rdargs

  args:=[0,0,0,0,0,0,0,0,0,0]
  IF rdargs:=ReadArgs( 'FILE/A,WIZARD=WZ/F', args, NIL )
    StrCopy( str, args.wizard )
    FreeArgs(rdargs)

    StrAdd( str, '\n' )
    IF rda:=AllocDosObject( DOS_RDARGS, NIL )

      rda.source.buffer := str
      rda.source.length := StrLen( str )
      rda.source.curchr := NIL
      rda.buffer        := NIL

      IF rdargs := ReadArgs( 'WZ/M/A', nargs:=[0], rda)
        WHILE nargs.wz[i]
          StringF( str, '\s\n', nargs.wz[i] )
          rda.source.buffer := str
          rda.source.length := StrLen( str )
          rda.source.curchr := NIL
          rda.buffer        := NIL
          IF rrdargs := ReadArgs( 'FILE/A,ARGS/F', nnargs:=[0,0], rda)
            PrintF('Wizard: \s   Args: \s\n', nnargs[0], nnargs[1])
            FreeArgs(rrdargs)
          ENDIF
          INC i
        ENDWHILE
        FreeArgs(rdargs)
      ENDIF
      FreeDosObject(DOS_RDARGS, rda)
    ENDIF

  ENDIF

ENDPROC
