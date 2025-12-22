MODULE 'leifoo/multidim'

PROC main()
   DEF md:PTR TO multidim
   NEW md
   md.set([1, 2, 3, 4], 10)
   ->WriteF('\d\n', md.get([1, 2, 3, 4, 5]))
   md.printObject()
   md.unset([1])
   md.printObject()
   END md
ENDPROC

