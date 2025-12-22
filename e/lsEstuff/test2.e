MODULE '*dynamic_array'

PROC main()
   DEF da:PTR TO dynamic_array, e, v
   NEW da
   da.dynamic_array(DAVS_CHAR, 1024)
   WriteF('dynamic array of char, allocvalue=1024\n')
   WriteF('setting elements 512 times with values [0-255]\n')
   WriteF('thats 128 000 set():s ! \n')
   SystemTagList('date', NIL)
   FOR v:=0 TO 255
      FOR e:=0 TO 99
         da.set(e, v)
         da.set(e, v)
         da.set(e, v)
         da.set(e, v)
         da.set(e, v)
      ENDFOR
   ENDFOR
   SystemTagList('date', NIL)
   WriteF('finnished!\n')
   END da
   NEW da
   da.dynamic_array(DAVS_INT, 1024)
   WriteF('dynamic array of INT, allocvalue=1024\n')
   WriteF('setting elements 500 times with values [0-255]\n')
   WriteF('thats 128 000 set():s ! \n')
   SystemTagList('date', NIL)
   FOR v:=0 TO 255
      FOR e:=0 TO 99
         da.set(e, v)
         da.set(e, v)
         da.set(e, v)
         da.set(e, v)
         da.set(e, v)
      ENDFOR
   ENDFOR
   SystemTagList('date', NIL)
   WriteF('finnished!\n')
   END da
ENDPROC

