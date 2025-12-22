
MODULE 'exec/ports' , 'exec/io'
MODULE 'devices/timer'
MODULE 'grio/time'

PROC main()

   DEF t:PTR TO time , sec=0 , sig , break=$1000 , quit=FALSE 

   NEW t

   IF t.new()
      REPEAT
         t.delay(1,0)
         sig:=Wait(t.signal OR break)
         SELECT sig
            CASE break
               WriteF('***break\n')
               quit:=TRUE
            DEFAULT
               INC sec
               WriteF('second \d\n',sec)
               IF sec=10 THEN quit:=TRUE
         ENDSELECT
      UNTIL quit
   ENDIF
   
   END t

ENDPROC



