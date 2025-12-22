MODULE '*nm'

PROC main()
   DEF nmI:PTR TO nmI
   NEW nmI
   WriteF('nmI.getObjectName()=\s\n', nmI.getObjectName())
   WriteF('nmI.getObjectSize()=\d\n', nmI.getObjectSize())
   WriteF('nmI.new()=\s\n', nmI.new(NIL))
   WriteF('nmI.end()=\s\n', nmI.end())
   END nmI
ENDPROC

