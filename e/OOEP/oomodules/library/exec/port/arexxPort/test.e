MODULE  'oomodules/library/exec/port/arexxport'

PROC main()
DEF a:PTR TO arexxPort,
    quit=FALSE

  NEW a.new(["name", 'gregor', "add"])

  REPEAT

    a.wait()
    a.getMsg()

    WriteF('\s\n', a.getArgStr(0))

    IF OstrCmp(a.getArgStr(0), 'QUIT')=0 THEN quit := TRUE

    a.replyMsg()

  UNTIL quit

  END a

ENDPROC
