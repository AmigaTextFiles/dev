MODULE 'oomodules/resource'

PROC main()
DEF resource:PTR TO resource

  NEW resource.new()

  WriteF('\d',resourceQS)
ENDPROC
