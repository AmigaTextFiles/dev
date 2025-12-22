MODULE '*dynamic_array'

PROC main() HANDLE
   DEF a, b, da:PTR TO dynamic_array
   NEW da
   da.dynamic_array(DAVS_INT, 256)
   WriteF('dynamic ARRAY OF INT, speedval=256\n')
   Execute('run date', NIL, NIL)
   WriteF('getting 5 000 empty points\n')
   FOR a:=0 TO 4999
      b:=da.get(a)
   ENDFOR
   Execute('run date', NIL, NIL)
   WriteF('setting 5 000 points\n')
   FOR a:=0 TO 4999
      da.set(a, a)
   ENDFOR
   Execute('run date', NIL, NIL)
   WriteF('counting points : \d\n', da.count())
   Execute('run date', NIL, NIL)
   WriteF('setting the same 5 000 points again\n')
   FOR a:=4999 TO 0 STEP -1
      da.set(a, a)
   ENDFOR
   Execute('run date', NIL, NIL)
   WriteF('getting 5 000 points\n')
   FOR a:=0 TO 4999
      b:=da.get(a)
      IF b<>a THEN WriteF('\d=\d\n', a, b)
   ENDFOR
   Execute('run date', NIL, NIL)
   WriteF('memory available now : \d\n', AvailMem(NIL))
   Execute('run date', NIL, NIL)
   WriteF('unsetting 5 000 points\n')
   FOR a:=0 TO 4999
      da.unset(a)
   ENDFOR
   Execute('run date', NIL, NIL)
   WriteF('memory available now : \d\n', AvailMem(NIL))
   WriteF('counting values (should be 0) : \d\n', da.count())
   WriteF('finnished!\n')

EXCEPT DO
   IF exception="MEM" THEN WriteF('memerror!\n')
   IF exception="NIL" THEN WriteF('NIL at line : \d\n', exceptioninfo)
   END da
ENDPROC

