OPT MODULE

MODULE '*xli'

EXPORT OBJECT collectionX OF xli
ENDOBJECT

EXPORT OBJECT xniv OF xni
   value
ENDOBJECT

EXPORT OBJECT collectionX_CPObj OF xli_CPObj
ENDOBJECT

PROC private_Methods_From_Here() OF collectionX IS EMPTY

PROC collectionX() OF collectionX IS TRUE

PROC countX() OF collectionX
   DEF n:REG PTR TO xniv
   DEF count:REG
   count := NIL
   n := self.first()
   WHILE n
      IF n.value <> NIL THEN INC count
      n := n.next
   ENDWHILE
ENDPROC count

PROC absVals() OF collectionX
   DEF n:PTR TO xniv
   DEF useful=NIL
   n := self.first()
   WHILE n
      IF n.value < 0
         n.value := Abs(n.value)
         INC useful
      ENDIF
      n := n.next
   ENDWHILE
ENDPROC useful

PROC getSumVals() OF collectionX
   DEF n:REG PTR TO xniv
   DEF sum:REG
   sum := NIL
   n := self.first()
   WHILE n
      sum := sum + n.value
      n := n.next
   ENDWHILE
ENDPROC sum

PROC getAveVals() OF collectionX
   DEF sum:REG
   DEF count:REG
   DEF n:REG PTR TO xniv
   sum := NIL
   count := NIL
   n := self.first()
   WHILE n
      INC count
      sum := sum + n.value
      n := n.next
   ENDWHILE
   IF count = NIL THEN RETURN NIL
ENDPROC sum / count

PROC getMaxVal() OF collectionX
   DEF n:REG PTR TO xniv
   DEF val:REG
   val:=$80000000
   n := self.first()
   WHILE n
      val := IF val < n.id THEN n.id ELSE val
      n := n.next
   ENDWHILE
ENDPROC val

PROC getMinVal() OF collectionX
   DEF n:REG PTR TO xniv
   DEF val:REG
   val:=$40000000
   n := self.first()
   WHILE n
      val := IF val > n.id THEN n.id ELSE val
      n := n.next
   ENDWHILE
ENDPROC val

EXPORT PROC createIVN(id, value)
   DEF n:PTR TO xniv
   n := FastNew(SIZEOF xniv)
   n.id := id
   n.value := value
ENDPROC n

EXPORT PROC deleteIVN(n:PTR TO xniv)
   FastDispose(n, SIZEOF xniv)
ENDPROC

/* needs sorted lists ! */
PROC applyExistsFrom(collectionX:PTR TO collectionX) OF collectionX
   DEF thisnode:REG PTR TO xniv
   DEF thatnode:REG PTR TO xniv
   DEF useful:REG
   useful := NIL
   thisnode := self.first()
   thatnode := collectionX.first()
   WHILE (thisnode AND thatnode)
      IF thisnode.id = thatnode.id
         thisnode.value := thatnode.value
         thisnode := thisnode.next
         thatnode := thatnode.next
         INC useful
      ELSEIF thisnode.id > thatnode.id
         thatnode := thatnode.next
      ELSE
         thisnode := thisnode.next
      ENDIF
   ENDWHILE
ENDPROC useful

PROC applyANDFrom(collectionX:PTR TO collectionX) OF collectionX
   DEF thisnode:REG PTR TO xniv
   DEF thatnode:REG PTR TO xniv
   DEF useful:REG
   useful := NIL
   thisnode := self.first()
   thatnode := collectionX.first()
   WHILE (thisnode AND thatnode)
      IF thisnode.id = thatnode.id
         thisnode.value := thatnode.value AND thisnode.value
         thisnode := thisnode.next
         thatnode := thatnode.next
         INC useful
      ELSEIF thisnode.id > thatnode.id
         thatnode := thatnode.next
      ELSE
         thisnode := thisnode.next
      ENDIF
   ENDWHILE
ENDPROC useful

PROC applyNewFrom(collectionX:PTR TO collectionX) OF collectionX
   DEF thisnode:PTR TO xniv
   DEF thatnode:PTR TO xniv
   DEF newnode:PTR TO xniv
   DEF hits=NIL
   thisnode := self.first()
   thatnode := collectionX.first()
   WHILE thatnode
      IF thisnode.id > thatnode.id
         newnode := FastNew(SIZEOF xniv)
         newnode.id := thatnode.id
         newnode.value := thatnode.value
         self.ordInsert(newnode)
         thatnode := thatnode.next
         INC hits
      ELSEIF thisnode.id < thatnode.id
         thisnode := thisnode.next
      ELSE
         thisnode := thisnode.next
         thatnode := thatnode.next
      ENDIF
   ENDWHILE
ENDPROC hits

PROC applyAllFrom(collectionX:PTR TO collectionX) OF collectionX
   DEF thisnode:PTR TO xniv
   DEF thatnode:PTR TO xniv
   DEF newnode:PTR TO xniv
   thisnode := self.first()
   thatnode := collectionX.first()
   WHILE thatnode
      IF thisnode.id > thatnode.id
         newnode := FastNew(SIZEOF xniv)
         newnode.id := thatnode.id
         newnode.value := thatnode.value
         self.ordInsert(newnode)
         thatnode := thatnode.next
      ELSEIF thisnode.id < thatnode.id
         thisnode := thisnode.next
      ELSE
         thisnode.value := thatnode.value
         thisnode := thisnode.next
         thatnode := thatnode.next
      ENDIF
   ENDWHILE
ENDPROC

PROC applyAveFrom(collectionX:PTR TO collectionX) OF collectionX
   DEF thisnode:PTR TO xniv
   DEF thatnode:PTR TO xniv
   DEF newnode:PTR TO xniv
   thisnode := self.first()
   thatnode := collectionX.first()
   WHILE thatnode
      IF thisnode.id > thatnode.id
         newnode := FastNew(SIZEOF xniv)
         newnode.id := thatnode.id
         newnode.value := (thatnode.value) / 2
         self.ordInsert(newnode)
         thatnode := thatnode.next
      ELSEIF thisnode.id < thatnode.id
         thisnode := thisnode.next
      ELSE
         thisnode.value := ((thatnode.value) + (thisnode.value)) / 2
         thisnode := thisnode.next
         thatnode := thatnode.next
      ENDIF
   ENDWHILE
ENDPROC

PROC applyORFrom(collectionX:PTR TO collectionX) OF collectionX
   DEF thisnode:PTR TO xniv
   DEF thatnode:PTR TO xniv
   DEF newnode:PTR TO xniv
   thisnode := self.first()
   thatnode := collectionX.first()
   WHILE thatnode
      IF thisnode.id > thatnode.id
         newnode := FastNew(SIZEOF xniv)
         newnode.id := thatnode.id
         newnode.value := thatnode.value
         self.ordInsert(newnode)
         thatnode := thatnode.next
      ELSEIF thisnode.id < thatnode.id
         thisnode := thisnode.next
      ELSE
         thisnode.value := thatnode.value OR thisnode.value
         thisnode := thisnode.next
         thatnode := thatnode.next
      ENDIF
   ENDWHILE
ENDPROC

PROC set(id, value) OF collectionX
   DEF n:PTR TO xniv
   n := self.ordFind(id)
   IF n = NIL
      ->IF value = NIL THEN RETURN NIL
      n := FastNew(SIZEOF xniv)
      n.id := id
      n := self.ordInsert(n)
   ENDIF
   n.value := value
ENDPROC n

PROC get(id) OF collectionX
   DEF n:PTR TO xniv
   n := self.ordFind(id)
   IF n = NIL THEN RETURN NIL
ENDPROC n.value

PROC unSet(id) OF collectionX
   DEF n:PTR TO xniv
   n := self.ordFind(id)
   IF n = NIL THEN RETURN NIL
   self.removeFastDispose(n, SIZEOF xniv)
ENDPROC

PROC clear() OF collectionX
   self.removeFastDisposeAll(SIZEOF xniv)
ENDPROC

PROC cleanUp() OF collectionX
   DEF n:PTR TO xniv
   n := self.first()
   WHILE n
      IF n.value = NIL THEN n := self.removeFastDispose(n, SIZEOF xniv)
      n := n.next
   ENDWHILE
ENDPROC

OBJECT blahaj OF collectionX_CPObj
   arrayptr
ENDOBJECT

PROC wblahaL(blahaj:PTR TO blahaj)
   DEF l:PTR TO LONG
   DEF n:PTR TO xniv
   l := blahaj.arrayptr
   n := blahaj.node
   l[] := n.value
   blahaj.arrayptr := (blahaj.arrayptr) + 4
ENDPROC

PROC wblahaI(blahaj:PTR TO blahaj)
   DEF l:PTR TO INT
   DEF n:PTR TO xniv
   l := blahaj.arrayptr
   n := blahaj.node
   l[] := n.value
   blahaj.arrayptr := (blahaj.arrayptr) + 2
ENDPROC

PROC wblahaC(blahaj:PTR TO blahaj)
   DEF l:PTR TO CHAR
   DEF n:PTR TO xniv
   l := blahaj.arrayptr
   n := blahaj.node
   l[] := n.value
   blahaj.arrayptr := (blahaj.arrayptr) + 1
ENDPROC

PROC cBSet(array:PTR TO CHAR, startid, stopid) OF collectionX
   WHILE startid <> (stopid + 1) DO self.set(startid++, array[]++)
ENDPROC

PROC iBSet(array:PTR TO INT, startid, stopid) OF collectionX
   WHILE startid <> (stopid + 1) DO self.set(startid++, array[]++)
ENDPROC

PROC lBSet(array:PTR TO LONG, startid, stopid) OF collectionX
   WHILE startid <> (stopid + 1) DO self.set(startid++, array[]++)
ENDPROC

PROC cBGet(array:PTR TO CHAR, startid, stopid) OF collectionX
   DEF b:PTR TO blahaj
   b.arrayptr := array
   self.travArray({wblahaC}, b, startid, stopid)
ENDPROC

PROC iBGet(array:PTR TO CHAR, startid, stopid) OF collectionX
   DEF b:PTR TO blahaj
   b.arrayptr := array
   self.travArray({wblahaI}, b, startid, stopid)
ENDPROC

PROC lBGet(array:PTR TO CHAR, startid, stopid) OF collectionX
   DEF b:PTR TO blahaj
   b.arrayptr := array
   self.travArray({wblahaL}, b, startid, stopid)
ENDPROC

PROC swapV(id1, id2) OF collectionX
   DEF n1:REG PTR TO xniv
   DEF n2:REG PTR TO xniv
   DEF n:REG PTR TO xniv
   DEF temp
   n1 := NIL
   n2 := NIL
   n := self.first()
   WHILE n
      IF n.id = id1 THEN n1 := n
      IF n.id = id2 THEN n2 := n
      n := IF (n1 AND n2) THEN NIL ELSE n.next
   ENDWHILE
   IF (n1 = NIL) AND (n2 = NIL) THEN RETURN NIL
   IF n1 = NIL
      n1 := createIVN(id1, 0)
      self.ordInsert(n1)
   ENDIF
   IF n2 = NIL
      n2 := createIVN(id2, 0)
      self.ordInsert(n2)
   ENDIF
   temp := n1.value
   n1.value := n2.value
   n2.value := temp
ENDPROC

PROC sortV() OF collectionX
   DEF n:REG PTR TO xniv
   DEF nnext:REG PTR TO xniv
   DEF useful:REG
   DEF temp:REG
   REPEAT
      n := self.first()
      useful := FALSE
      WHILE n
         nnext := n.next
         IF nnext
            IF n.value > nnext.value
               temp := n.value
               n.value := nnext.value
               nnext.value := temp
               useful := TRUE
            ENDIF
            n := n.next
         ELSE
            n := NIL
         ENDIF
      ENDWHILE
   UNTIL useful = FALSE
ENDPROC

/* this one is clever! :) */
/* fakes nodes that doesnt exist */
PROC indexTraverse(proc, cpobj:PTR TO xli_CPObj, startid, endid) OF collectionX
   DEF n:PTR TO xni
   DEF id
   DEF defnode:xniv
   defnode.next := NIL
   defnode.prev := NIL
   defnode.value := NIL
   cpobj.list := self
   id := startid
   INC endid
   n := self.first()
   WHILE id < endid
      IF (n = NIL) OR (n.id > id)
         defnode.id := id
         cpobj.node := defnode
         proc(cpobj)
         INC id
      ELSE
         IF n.id < id
            n := n.next
         ELSE -> n.id = id
            cpobj.node := n
            proc(cpobj)
            INC id
         ENDIF
      ENDIF
   ENDWHILE
ENDPROC

PROC cloneContentsTo(nax:PTR TO collectionX) OF collectionX
   nax.clear()
   self.cloneFastNew(nax, SIZEOF xniv)
ENDPROC self.first()

PROC scrollX(amount) OF collectionX IS self.scroll(amount)

PROC cmpMapX(nax:PTR TO collectionX) OF collectionX IS self.cmpMap(nax)

PROC getMaxX() OF collectionX IS self.getMaxID()

PROC getMinX() OF collectionX IS self.getMinID()

PROC end() OF collectionX IS self.clear()

/*EE folds
-1
5 1 7 2 9 1 15 8 18 10 21 8 24 12 27 8 30 8 33 4 36 1 40 18 43 18 46 21 49 20 52 20 55 20 58 9 61 3 64 4 67 1 70 6 73 2 75 6 78 6 81 6 84 1 87 1 90 1 93 3 96 3 99 3 102 24 105 22 110 26 113 2 
EE folds*/
