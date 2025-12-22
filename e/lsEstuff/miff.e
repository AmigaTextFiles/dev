
OBJECT miff OF nmIList
   PRIVATE
   value
   miffs:PTR TO nmIList
ENDOBJECT

PROC get(elist=NIL) OF miff
   DEF elen
   DEF elcopy:PTR TO LONG
   DEF a
   DEF m:PTR TO miff
   IF elist = NIL THEN RETURN self
   elen := ListLen(elist)
   IF (elen < 1) THEN RETURN self
   elcpoy := List(elen)
   ListCopy(elcopy, elist)
   FOR a := 1 TO elen-1
      elcopy[a-1] := elcopy[a]
   ENDFOR
   SetList(elcopy, elen-1)
   m := self.miffs.find(elcopy[0])
   IF m = NIL THEN RETURN NIL





