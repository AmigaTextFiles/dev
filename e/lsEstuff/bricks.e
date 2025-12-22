
OBJECT robj
   next:PTR TO robj
   prev:PTR TO robj
   id
ENDOBJECT

PROC find(id) OF robj
   IF self.id = id THEN RETURN self
   IF self.next = NIL THEN RETURN NIL
   self.next.find(id)
ENDPROC

