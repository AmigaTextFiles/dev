MODULE '*bits'

PROC main()
   DEF a:PTR TO LONG, b, c
   a:=FastNew(500)
   /*
   FOR b:=0 TO 99
      WriteF('bit \d = \d\n', b, bigbitget(a, b))
      bigbitset(a, b)
      WriteF('bit \d after set = \d\n', b, bigbitget(a, b))
      bigbitclr(a, b)
      WriteF('bit \d after clr = \d\n', b, bigbitget(a, b))
   ENDFOR
   */
   SystemTagList('date', NIL)
   FOR b:=0 TO 100000
      FOR c:=0 TO 31
         bitset(10, c)
      ENDFOR
   ENDFOR
   SystemTagList('date', NIL)
   FOR b:=0 TO 100000
      FOR c:=0 TO 31
         bigbitset(a, c)
      ENDFOR
   ENDFOR
   SystemTagList('date', NIL)
ENDPROC

