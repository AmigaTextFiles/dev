MODULE 'other/split',
       'workbench/startup'

DEF argv:PTR TO LONG,a
PROC main()
    IF argv:=argSplit()
      WriteF('\d arguments.\n', ListLen(argv))
      FOR a:=0 TO ListLen(argv)-1
        WriteF('Argument \d: "\s".\n', a+1, argv[a])
      ENDFOR
    ELSE
      WriteF('Argument is "\s".\n', arg)
    ENDIF
ENDPROC
