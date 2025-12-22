MODULE '*newarrayx'

PROC main()
   DEF na:PTR TO newArrayX, a, stop
   NEW na.newArrayX()
   stop:=10000
   SystemTagList('date', NIL)

   FOR a:=0 TO stop
      na.setE(a, a)
      na.getE(a)
      na.setE(a, a)
      na.getE(a)
      na.setE(a, a)
      na.getE(a)
      na.setE(a, a)
      na.getE(a)
      ->na.setE(a, a)
      ->na.getE(a)
      ->na.setE(a, a)
      ->na.getE(a)
      ->na.setE(a, a)
      ->na.getE(a)
      ->na.setE(a, a)
      ->na.getE(a)
   ENDFOR

   SystemTagList('date', NIL)                     
   WriteF('counting nodes..\d\n', na.countX())
   WriteF('sum of values..\d\n', na.getSumA())
   WriteF('average of values..\d\n', na.getAveA())
   SystemTagList('date', NIL)
  

   END na
ENDPROC
