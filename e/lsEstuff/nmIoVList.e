OPT MODULE

->
-> was : xliv, newarrayX, collectionX.. :)
-> this is a listclass ..hmm.. or..
-> its a class that uses nodes that have a value
-> (besides id field ofcource)
-> the class does things with the values .. :)
-> alot arraylike functions
-> and list <> list functions...
-> order in the list, please!
-> well.. automatically this list is ordered..
-> alot functions to manipulate values depends on that
-> and it makes that functions faaaster .. :)

MODULE 'leifoo/nm'
MODULE '*nmIoList'

EXPORT OBJECT nmIoVList OF nmIoList
ENDOBJECT


EXPORT OBJECT nmIoVList_CPObj OF nmIoList_CPObj
ENDOBJECT

PROC private_Methods_From_Here() OF nmIoVList IS self.o_bla('private_Methods_From_Here()')

PROC countNoNIL() OF nmIoVList
   DEF n:REG PTR TO nmIV
   DEF count:REG
   count := NIL
   n := self.first()
   WHILE n
      IF n.value <> NIL THEN INC count
      n := n.next
   ENDWHILE
ENDPROC count

PROC absVals() OF nmIoVList
   DEF n:PTR TO nmIV
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

PROC getSumVals() OF nmIoVList
   DEF n:REG PTR TO nmIV
   DEF sum:REG
   sum := NIL
   n := self.first()
   WHILE n
      sum := sum + n.value
      n := n.next
   ENDWHILE
ENDPROC sum

PROC getAveVals() OF nmIoVList
   DEF sum:REG
   DEF count:REG
   DEF n:REG PTR TO nmIV
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

PROC getMaxVal() OF nmIoVList
   DEF n:REG PTR TO nmIV
   DEF val:REG
   val:=$80000000
   n := self.first()
   WHILE n
      val := IF val < n.id THEN n.id ELSE val
      n := n.next
   ENDWHILE
ENDPROC val

PROC getMinVal() OF nmIoVList
   DEF n:REG PTR TO nmIV
   DEF val:REG
   val:=$40000000
   n := self.first()
   WHILE n
      val := IF val > n.id THEN n.id ELSE val
      n := n.next
   ENDWHILE
ENDPROC val


/* needs sorted lists ! */
PROC applyExistsFrom(nmIoVList:PTR TO nmIoVList) OF nmIoVList
   DEF thisnode:REG PTR TO nmIV
   DEF thatnode:REG PTR TO nmIV
   DEF useful:REG
   useful := NIL
   thisnode := self.first()
   thatnode := nmIoVList.first()
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

PROC applyANDFrom(nmIoVList:PTR TO nmIoVList) OF nmIoVList
   DEF thisnode:REG PTR TO nmIV
   DEF thatnode:REG PTR TO nmIV
   DEF useful:REG
   useful := NIL
   thisnode := self.first()
   thatnode := nmIoVList.first()
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

PROC applyNewFrom(nmIoVList:PTR TO nmIoVList) OF nmIoVList
   DEF thisnode:PTR TO nmIV
   DEF thatnode:PTR TO nmIV
   DEF newnode:PTR TO nmIV
   DEF hits=NIL
   thisnode := self.first()
   thatnode := nmIoVList.first()
   WHILE thatnode
      IF thisnode.id > thatnode.id
         NEW newnode
         newnode.id := thatnode.id
         newnode.value := thatnode.value
         self.oInsert(newnode)
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

PROC applyAllFrom(nmIoVList:PTR TO nmIoVList) OF nmIoVList
   DEF thisnode:PTR TO nmIV
   DEF thatnode:PTR TO nmIV
   DEF newnode:PTR TO nmIV
   thisnode := self.first()
   thatnode := nmIoVList.first()
   WHILE thatnode
      IF thisnode.id > thatnode.id
         NEW newnode
         newnode.id := thatnode.id
         newnode.value := thatnode.value
         self.oInsert(newnode)
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

PROC applyAveFrom(nmIoVList:PTR TO nmIoVList) OF nmIoVList
   DEF thisnode:PTR TO nmIV
   DEF thatnode:PTR TO nmIV
   DEF newnode:PTR TO nmIV
   thisnode := self.first()
   thatnode := nmIoVList.first()
   WHILE thatnode
      IF thisnode.id > thatnode.id
         NEW newnode
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

PROC applyORFrom(nmIoVList:PTR TO nmIoVList) OF nmIoVList
   DEF thisnode:PTR TO nmIV
   DEF thatnode:PTR TO nmIV
   DEF newnode:PTR TO nmIV
   thisnode := self.first()
   thatnode := nmIoVList.first()
   WHILE thatnode
      IF thisnode.id > thatnode.id
         NEW newnode
         newnode.id := thatnode.id
         newnode.value := thatnode.value
         self.oInsert(newnode)
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

PROC set(id, value) OF nmIoVList
   DEF n:PTR TO nmIV
   n := self.oFind(id)
   IF n = NIL
      ->IF value = NIL THEN RETURN NIL
      NEW n
      n.id := id
      n := self.oInsert(n)
   ENDIF
   n.value := value
ENDPROC n

PROC get(id) OF nmIoVList
   DEF n:PTR TO nmIV
   n := self.oFind(id)
   IF n = NIL THEN RETURN NIL
ENDPROC n.value

PROC unSet(id) OF nmIoVList
   DEF n:PTR TO nmIV
   n := self.oFind(id)
   IF n = NIL THEN RETURN NIL
   self.delete(n)
ENDPROC

PROC cleanUp() OF nmIoVList
   DEF n:PTR TO nmIV
   DEF next
   n := self.first()
   WHILE n
      next := n.next
      IF n.value = NIL THEN self.delete(n)
      n := next
   ENDWHILE
ENDPROC

/* some shit for supporting the bulk getting.. */
OBJECT blahaj OF nmIoVList_CPObj
   arrayptr
ENDOBJECT

PROC wblahaL(blahaj:PTR TO blahaj)
   DEF l:PTR TO LONG
   DEF n:PTR TO nmIV
   l := blahaj.arrayptr
   n := blahaj.node
   l[] := n.value
   blahaj.arrayptr := (blahaj.arrayptr) + 4
ENDPROC

PROC wblahaI(blahaj:PTR TO blahaj)
   DEF l:PTR TO INT
   DEF n:PTR TO nmIV
   l := blahaj.arrayptr
   n := blahaj.node
   l[] := n.value
   blahaj.arrayptr := (blahaj.arrayptr) + 2
ENDPROC

PROC wblahaC(blahaj:PTR TO blahaj)
   DEF l:PTR TO CHAR
   DEF n:PTR TO nmIV
   l := blahaj.arrayptr
   n := blahaj.node
   l[] := n.value
   blahaj.arrayptr := (blahaj.arrayptr) + 1
ENDPROC

/* bulk set */
PROC cBSet(array:PTR TO CHAR, startid, stopid) OF nmIoVList
   WHILE startid <> (stopid + 1) DO self.set(startid++, array[]++)
ENDPROC

PROC iBSet(array:PTR TO INT, startid, stopid) OF nmIoVList
   WHILE startid <> (stopid + 1) DO self.set(startid++, array[]++)
ENDPROC

PROC lBSet(array:PTR TO LONG, startid, stopid) OF nmIoVList
   WHILE startid <> (stopid + 1) DO self.set(startid++, array[]++)
ENDPROC

/* bulk get */
/* *optmised* skips the get() method */
/* more code.. damn..*/
PROC cBGet(array:PTR TO CHAR, startid, stopid) OF nmIoVList
   DEF b:PTR TO blahaj
   b.arrayptr := array
   self.travArray({wblahaC}, b, startid, stopid)
ENDPROC

PROC iBGet(array:PTR TO CHAR, startid, stopid) OF nmIoVList
   DEF b:PTR TO blahaj
   b.arrayptr := array
   self.travArray({wblahaI}, b, startid, stopid)
ENDPROC

PROC lBGet(array:PTR TO CHAR, startid, stopid) OF nmIoVList
   DEF b:PTR TO blahaj
   b.arrayptr := array
   self.travArray({wblahaL}, b, startid, stopid)
ENDPROC

/* this one is pretty clever :) */
/* should be pretty faast, comparing to set()/get():ing.. */
PROC swapV(id1, id2) OF nmIoVList
   DEF n1:REG PTR TO nmIV
   DEF n2:REG PTR TO nmIV
   DEF n:REG PTR TO nmIV
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
      self.oInsert(n1)
   ENDIF
   IF n2 = NIL
      n2 := createIVN(id2, 0)
      self.oInsert(n2)
   ENDIF
   temp := n1.value
   n1.value := n2.value
   n2.value := temp
ENDPROC

/* simple bubblesorting of values.. */
PROC sortV() OF nmIoVList
   DEF n:REG PTR TO nmIV
   DEF nnext:REG PTR TO nmIV
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
/* like it was a real array, not a list :) */
PROC indexTraverse(proc, cpobj:PTR TO nmIoList_CPObj, startid, endid) OF nmIoVList
   DEF n:PTR TO xni
   DEF id
   DEF defnode:nmIV
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

PROC cloneContentsTo(nax:PTR TO nmIoVList) OF nmIoVList
   nax.clear()
   self.cloneFastNew(nax, nax.getObjectSize())
ENDPROC self.first()

PROC scrollX(amount) OF nmIoVList IS self.scroll(amount)

PROC cmpMapX(nax:PTR TO nmIoVList) OF nmIoVList IS self.cmpMap(nax)

PROC getMaxX() OF nmIoVList IS self.oGetMaxID()

PROC getMinX() OF nmIoVList IS self.oGetMinID()


/*EE folds
-1
5 1 7 2 9 1 15 8 18 10 21 8 24 12 27 8 30 8 33 4 36 1 40 18 43 18 46 21 49 20 52 20 55 20 58 9 61 3 64 4 67 1 70 6 73 2 75 6 78 6 81 6 84 1 87 1 90 1 93 3 96 3 99 3 102 24 105 22 110 26 113 2 
EE folds*/
