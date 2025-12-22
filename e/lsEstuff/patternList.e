OPT MODULE

->hmm.. dont know what the fuck to call this now.. :)
-> was : virtObj

MODULE '*nm'
MODULE '*nmList'

EXPORT OBJECT patternList OF nmList ; ENDOBJECT

EXPORT OBJECT pL_travObj
   node:PTR TO vo_node
   list:PTR TO patternList
   value
ENDOBJECT

OBJECT vo_node OF nm
   pattern
ENDOBJECT

PROC new(pattern) OF vo_node
   self.pattern := List(ListLen(pattern))
   ListCopy(self.pattern, pattern)
ENDPROC

PROC setpattern(pattern) OF vo_node
   DEF newlen
   newlen := ListLen(pattern)
   IF newlen > ListLen(self.pattern)
      DisposeLink(self.pattern)
      self.pattern := List(newlen)
   ENDIF
   ListCopy(self.pattern, pattern)
ENDPROC

PROC end() OF vo_node IS DisposeLink(self.pattern)

PROC find(vo:PTR TO patternList, pattern)
   DEF n:PTR TO vo_node
   n := vo.first()
   WHILE n
      IF ListCmp(pattern, n.pattern) THEN RETURN n
      n := n.next
   ENDWHILE
ENDPROC NIL
                                                        
PROC chngPat(pattern, pattern2) OF patternList
   DEF n:PTR TO vo_node
   n := find(self, pattern)
   IF n THEN n.setpattern(pattern2)
ENDPROC

PROC addPat(pattern) OF patternList
   DEF n:PTR TO vo_node
   n := find(self, pattern)
   IF n = NIL
      NEW n.new(pattern)
      self.addLast(n)
      RETURN TRUE
   ENDIF
ENDPROC NIL

PROC remPat(pattern) OF patternList
   DEF n:PTR TO vo_node
   n := find(self, pattern)
   IF n = NIL THEN RETURN NIL
   self.delete(n)
ENDPROC

/* calls proc for each nodes pattern that matches */
/* pattern, the nodes pattern ofcource can be longer, */
/* thats the hole point.. :) */
PROC pathTrav(pattern, obj:PTR TO pL_travObj, proc) OF patternList
   DEF n:PTR TO vo_node
   DEF elsize
   obj.list := self
   elsize := ListLen(pattern)
   n := self.first()
   WHILE n
      IF ListCmp(pattern, n.pattern, elsize)
         obj.node := n
         proc(obj)
      ENDIF
      n := n.next
   ENDWHILE
ENDPROC

/* more traverse methods here... */

PROC private_Methods_From_Here() OF patternList IS EMPTY


