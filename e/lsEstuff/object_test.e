MODULE '*object'

PROC main()
   DEF o:PTR TO object
   NEW o
   WriteF('\s\n', o.getObjectName())
   o := o.endFastDispose()
ENDPROC
