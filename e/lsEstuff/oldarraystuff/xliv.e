OPT MODULE

MODULE '*xli'

-> alla newArray#? behöver denna!!

EXPORT OBJECT xliv OF xli
ENDOBJECT

EXPORT OBJECT xniv OF xni
   value
ENDOBJECT

->OBJECT xnivMem




PROC create_xniv(id) OF xliv
   DEF xniv:PTR TO xniv
   xniv := self.addTailFastNew(SIZEOF xniv)
   xniv.id := id
ENDPROC xniv

PROC delete_xniv(xniv:PTR TO xniv) OF xliv
   self.fastDispose(xniv, SIZEOF xniv)
ENDPROC

PROC getMaxVal() OF xliv
   DEF n:PTR TO xniv, val=$80000000
   n := self.first()
   WHILE n
      val := Max(val, n.value)
      n := n.next
   ENDWHILE
ENDPROC val

PROC getMinVal() OF xliv
   DEF n:PTR TO xniv, val=$40000000
   n := self.first()
   WHILE n
      val := Min(val, n.value)
      n := n.next
   ENDWHILE
ENDPROC val


PROC getSumVal() OF xliv
   DEF n:REG PTR TO xniv, val:REG
   val:=NIL
   n := self.first()
   WHILE n
      val := val + n.value
      n := n.next
   ENDWHILE
ENDPROC val

PROC exchangeVal(id1, id2) OF xliv
   DEF cn:REG PTR TO xniv
   DEF n1:REG PTR TO xniv
   DEF n2:REG PTR TO xniv
   DEF temp
   cn := self.first()
   n1 := NIL
   n2 := NIL
   WHILE cn
      IF cn.id = id1 THEN n1 := cn
      IF cn.id = id2 THEN n2 := cn
      IF n1
       IF n2
          temp := n1.value
          n1.value := n2.value
          n2.value := temp
          RETURN 1
       ENDIF
      ENDIF
      cn := cn.next
   ENDWHILE
ENDPROC NIL

PROC absAllVals() OF xliv
   DEF n:REG PTR TO xniv
   n := self.first()
   WHILE n
      n.value := Abs(n.value)
      n := n.next
   ENDWHILE
ENDPROC

PROC notAllVals() OF xliv
   DEF n:REG PTR TO xniv
   n := self.first()
   WHILE n
      n.value := Not(n.value)
      n := n.next
   ENDWHILE
ENDPROC

/* typically it could be called from a */
/* background task periodically.. at LOW pri..*/
PROC removeNILValueNodes() OF xliv
   DEF n:REG PTR TO xniv
   n := self.first()
   WHILE n
      IF n.value = NIL THEN self.delete_xniv(n)
      n := n.next
   ENDWHILE
ENDPROC


/* nodes in self gets its values from */
/* nodes with the same id from the list supplied */
/* nodes not present in this list but in the other */
/* gets created ... it ofcource skips possible NIL nodes..*/
PROC applyAllValuesFromXLIV(xliv:PTR TO xliv) OF xliv
   DEF thisnode:REG PTR TO xniv
   DEF thatnode:REG PTR TO xniv
   thisnode
   thatnode := xliv.first()
   WHILE (thatnode)
      IF thatnode.value <> NIL
         thisnode := self.find(thatnode.id)
         IF thisnode = NIL THEN thisnode := self.create_xniv(thatnode.id)
         thisnode.value := thatnode.value
      ENDIF
      thatnode := thatnode.next
   ENDWHILE
ENDPROC

/* same as above, except only nodes with id:s */
/* not found in self gets their value-field copied */
PROC applyNewValuesFromXLIV(xliv:PTR TO xliv) OF xliv
   DEF thisnode:REG PTR TO xniv
   DEF thatnode:REG PTR TO xniv
   thisnode
   thatnode := xliv.first()
   WHILE (thatnode)
      IF thatnode.value <> NIL
         thisnode := self.find(thatnode.id)
         IF thisnode = NIL
            thisnode := self.create_xniv(thatnode.id)
            thisnode.value := thatnode.value
         ENDIF
      ENDIF
      thatnode := thatnode.next
   ENDWHILE
ENDPROC

/* just adds amount to every nodes id-field */
/* amount may ofcource be negative */
PROC scrollAllNodeIDs(amount) OF xliv
   DEF n:REG PTR TO xniv
   DEF v:REG
   v := amount
   n := self.first()
   WHILE n
      n.id := (n.id) + v
      n := n.next
   ENDWHILE
ENDPROC

/* positions not existing in self but */
/* in the other list gets created and cpoied */
/* ofcource ..:) */
PROC valueAdditionFromXLIV(xliv:PTR TO xliv) OF xliv
   DEF thisnode:REG PTR TO xniv
   DEF thatnode:REG PTR TO xniv
   thisnode
   thatnode := xliv.first()
   WHILE (thatnode)
      IF thatnode.value <> NIL
         thisnode := self.find(thatnode.id)
         IF thisnode = NIL
            thisnode := self.create_xniv(thatnode.id)
            thisnode.value := thatnode.value
         ELSE
            thisnode.value := (thisnode.value) + thatnode.value
         ENDIF
      ENDIF
      thatnode := thatnode.next
   ENDWHILE
ENDPROC

PROC valueSubtractionFromXLIV(xliv:PTR TO xliv) OF xliv
   DEF thisnode:REG PTR TO xniv
   DEF thatnode:REG PTR TO xniv
   thisnode
   thatnode := xliv.first()
   WHILE (thatnode)
      IF thatnode.value <> NIL
         thisnode := self.find(thatnode.id)
         IF thisnode = NIL
            thisnode := self.create_xniv(thatnode.id)
            thisnode.value := thatnode.value
         ELSE
            thisnode.value := (thisnode.value) - thatnode.value
         ENDIF
      ENDIF
      thatnode := thatnode.next
   ENDWHILE
ENDPROC

EXPORT OBJECT xlivProcArgObj
   pos
   value
ENDOBJECT

/* I LIKE IT!! := */
PROC callProcForEachNode(proc, obj:PTR TO xlivProcArgObj) OF xliv
   DEF n:PTR TO xniv
   n := self.first()
   WHILE n
      obj.pos := n.id
      obj.value := n.value
      proc(obj)
      n := n.next
   ENDWHILE
ENDPROC

/* moves (changes the id-field) */
/* of a node. If new id already exists */
/* the node of that will dissapear! */
/* steps may be negative */
PROC moveNodeByID(id, steps) OF xliv
   DEF n:PTR TO xniv
   DEF myself=NIL:PTR TO xniv
   DEF newID
   IF steps = NIL THEN RETURN NIL
   newID := id + steps
   n := self.first()
   WHILE n
      IF n.id = newID THEN self.delete_xniv(n)
      IF n.id = id THEN myself := n
      n := n.next
   ENDWHILE
   IF myself = NIL THEN RETURN NIL
   myself.id := newID  
ENDPROC myself

PROC scrollIDsFromNodeID(nodeID, steps) OF xliv
   DEF n:REG PTR TO xniv
   DEF id:REG
   IF steps = NIL THEN RETURN NIL
   id := nodeID
   n := self.first()
   IF steps < 0
      WHILE n
         IF n.id <= id THEN n.id := (n.id) + steps
         n := n.next
      ENDWHILE
   ELSE
      WHILE n
         IF n.id >= id THEN n.id := (n.id) + steps
         n := n.next
      ENDWHILE
   ENDIF
ENDPROC

