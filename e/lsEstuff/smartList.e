OPT MODULE

MODULE '*xli'

CONST MAX_SUBLIST_NODES=100

OBJECT sublist OF xli
ENDOBJECT

OBJECT mainlist OF xli
ENDOBJECT

EXPORT OBJECT smartList OF xni
   PRIVATE
   ml:PTR TO mainlist
ENDOBJECT

PROC oAdd(node:PTR TO xni, id=NIL) OF smartList
   DEF sl:PTR TO sublist
   DEF slnum
   IF id THEN node.id := id
   slnum := node.id / MAX_SUBLIST_NODES
   sl := self.ml.find(slnum)
   IF sl = NIL
      NEW sl
      sl.id := slnum
      self.ml.ordInsert(sl)
   ENDIF
   sl.ordInsert(node)
ENDPROC node

PROC add(node:PTR TO xni, id=NIL) OF smartList
   DEF sl:PTR TO sublist
   DEF slnum
   IF id THEN node.id := id
   slnum := node.id / MAX_SUBLIST_NODES
   sl := self.ml.find(slnum)
   IF sl = NIL
      NEW sl
      sl.id := slnum
      self.ml.addLast(sl)
   ENDIF
   sl.addLast(node)
ENDPROC node

PROC rem(node:PTR TO xni) OF smartList
   DEF sl:PTR TO sublist
   DEF slnum
   slnum := node.id / MAX_SUBLIST_NODES
   sl := self.ml.find(slnum)
   IF sl = NIL THEN RETURN NIL
   sl.remove(node)
   IF sl.count() = NIL
      self.ml.remove(sl)
      END sl
   ENDIF
ENDPROC node

PROC first() OF smartList
   DEF sl:PTR TO sublist
   sl := self.ml.first()
ENDPROC sl.first()

PROC last() OF smartList
   DEF sl:PTR TO sublist
   sl := self.ml.last()
ENDPROC sl.last()

/* must use theese ! */
PROC next(node:PTR TO xni) OF smartList
   DEF sl:PTR TO sublist
   DEF slnum
   IF node.next THEN RETURN node.next
   slnum := node.id / MAX_SUBLIST_NODES
   sl := self.ml.find(slnum)
   sl := sl.next
   IF sl = NIL THEN RETURN NIL
ENDPROC sl.first()

PROC prev(node:PTR TO xni) OF smartList
   DEF sl:PTR TO sublist
   DEF slnum
   IF node.prev THEN RETURN node.prev
   slnum := node.id / MAX_SUBLIST_NODES
   sl := self.ml.find(slnum)
   sl := sl.prev
   IF sl = NIL THEN RETURN NIL
ENDPROC sl.last()

PROC find(id) OF smartList
   DEF sl:PTR TO sublist
   DEF slnum
   slnum := id / MAX_SUBLIST_NODES
   sl := self.ml.find(slnum)
   IF sl = NIL THEN RETURN NIL
ENDPROC sl.find(id)

