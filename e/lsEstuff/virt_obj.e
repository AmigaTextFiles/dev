OPT MODULE

->
-> helloo!
-> first attemt at a 'virtual object'
-> kind of a multidimensional array of LONG .
-> 991029
->


MODULE '*nm'
MODULE '*nmList'

EXPORT OBJECT virtObj OF nmList ; ENDOBJECT

OBJECT vo_node OF nm
   value
   elist
ENDOBJECT

PROC new(elist) OF vo_node
   self.elist := List(ListLen(elist))
   ListCopy(self.elist, elist)
ENDPROC

PROC end() OF vo_node IS DisposeLink(self.elist)

PROC find(vo:PTR TO virtObj, elist)
   DEF n:PTR TO vo_node
   n := vo.first()
   WHILE n
      IF ListCmp(elist, n.elist) THEN RETURN n
      n := n.next
   ENDWHILE
ENDPROC NIL

PROC private_Methods_From_Here() OF virtObj IS EMPTY

/* set[x, y]), set[x, y, z]) set([x, y, z, a, b, c,,,]) etc*/
/* MIX freely, above exaples is like different arrays in the same:) */
PROC set(elist, value) OF virtObj
   DEF n:PTR TO vo_node
   n := find(self, elist)
   IF n = NIL
      NEW n.new(elist)
      self.addLast(n)
   ENDIF
   n.value := value
ENDPROC

PROC get(elist) OF virtObj
   DEF n:PTR TO vo_node
   n := find(self, elist)
   IF n = NIL THEN RETURN NIL
ENDPROC n.value

PROC unset(elist) OF virtObj
   DEF n:PTR TO vo_node
   n := find(self, elist)
   IF n = NIL THEN RETURN NIL
   self.delete(n)
ENDPROC


