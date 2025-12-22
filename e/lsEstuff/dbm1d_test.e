MODULE '*dbmapX'


PROC main() HANDLE
   DEF a
   DEF dbm:PTR TO dbmapX

   NEW dbm.dbmapX()

   SystemTagList('date', NIL)
   FOR a := 0 TO 39999
      dbm.set(a)
   ENDFOR
   SystemTagList('date', NIL)
   FOR a := 0 TO 39999
      dbm.set(a)
   ENDFOR
   SystemTagList('date', NIL)
   FOR a := 0 TO 39999
      IF dbm.get(a) <> 1 THEN Raise(1)
   ENDFOR
   SystemTagList('date', NIL)
   FOR a := 0 TO 39999
      dbm.clr(a)
   ENDFOR
   SystemTagList('date', NIL)
   WriteF('\d\n', dbm.count())
   WriteF('max=\d min=\d\n', dbm.getMax(), dbm.getMin())
EXCEPT DO
   IF exception THEN WriteF('er : \d\n', exception)
   END dbm
ENDPROC
