OPT MODULE

MODULE '*/mymods/bits'
MODULE '*xli'

EXPORT OBJECT dBMapX_CPObj
   x
   bit:INT
ENDOBJECT

OBJECT bitnode OF xni
   bits
ENDOBJECT

EXPORT OBJECT dBMapX OF xli
ENDOBJECT

PROC private_Methods_From_Here() OF dBMapX IS EMPTY

PROC dBMapX() OF dBMapX IS NIL

PROC set(x) OF dBMapX
   DEF n:PTR TO bitnode
   DEF nodenum
   DEF nodebitnum
   nodenum := x / 32
   nodebitnum := x - (32 * nodenum)
   n := self.find(nodenum)
   IF n = NIL
      n := FastNew(SIZEOF bitnode)
      self.ordInsert(n)
      n.id := nodenum
   ENDIF
   n.bits := bitSet(n.bits, nodebitnum)
ENDPROC

PROC clr(x) OF dBMapX
   DEF n:PTR TO bitnode
   DEF nodenum
   DEF nodebitnum
   nodenum := x / 32
   nodebitnum := x - (32 * nodenum)
   n := self.find(nodenum)
   IF n = NIL
      n := FastNew(SIZEOF bitnode)
      self.ordInsert(n)
      n.id := nodenum
   ENDIF
   n.bits := bitClr(n.bits, nodebitnum)
   IF n.bits = NIL THEN self.removeFastDispose(n, SIZEOF bitnode)
ENDPROC

PROC get(x) OF dBMapX
   DEF n:PTR TO bitnode
   DEF nodenum
   DEF nodebitnum
   nodenum := x / 32
   nodebitnum := x - (32 * nodenum)
   n := self.find(nodenum)
   IF n = NIL THEN RETURN NIL
ENDPROC bitGet(n.bits, nodebitnum)

PROC count() OF dBMapX
   DEF n:PTR TO bitnode
   DEF a
   DEF count=NIL
   n := self.first()
   WHILE n
      FOR a := 0 TO 31
         IF bitGet(n.bits, a) THEN INC count
      ENDFOR
      n := n.next
   ENDWHILE
ENDPROC count

PROC getMaxX() OF dBMapX
   DEF lastnode:PTR TO bitnode
   DEF long
   DEF a=NIL
   lastnode := self.last()
   IF lastnode = NIL THEN RETURN NIL
   long := lastnode.bits
   WHILE long
      long := bitClr(long, a)
      INC a
   ENDWHILE
ENDPROC ((lastnode.id) * 32) + a - 1

PROC getMinX() OF dBMapX
   DEF firstnode:PTR TO bitnode
   DEF long
   DEF a=31
   firstnode := self.first()
   IF firstnode = NIL THEN RETURN NIL
   long := firstnode.bits
   WHILE long
      long := bitClr(long, a)
      DEC a
   ENDWHILE
ENDPROC ((firstnode.id) * 32) + a + 1

PROC cmp(dbm:PTR TO dBMapX) OF dBMapX
   DEF n:REG PTR TO bitnode
   DEF n2:REG PTR TO bitnode
   n := self.first()
   n2 := dbm.first()
   WHILE n OR n2
      IF n.bits <> n2.bits THEN RETURN FALSE
      n := n.next
      n2 := n2.next
   ENDWHILE
ENDPROC TRUE

PROC or(dbm:PTR TO dBMapX) OF dBMapX
   DEF n1:PTR TO bitnode
   DEF n2:PTR TO bitnode
   DEF newnode:PTR TO bitnode
   n1 := self.first()
   n2 := dbm.first()
   WHILE n2
      IF n1.id < n2.id
         n1 := n1.next
      ELSEIF n1.id = n2.id
         n1.bits := n1.bits OR n2.bits
         n1 := n1.next
         n2 := n2.next
      ELSE 
         newnode := FastNew(SIZEOF bitnode)
         newnode.id := n2.id
         newnode.bits := n2.bits
         self.ordInsert(newnode)
         n2 := n2.next
      ENDIF
   ENDWHILE
ENDPROC

PROC xor(dbm:PTR TO dBMapX) OF dBMapX
   DEF n1:PTR TO bitnode
   DEF n2:PTR TO bitnode
   DEF newnode:PTR TO bitnode
   n1 := self.first()
   n2 := dbm.first()
   WHILE n2
      IF n1.id < n2.id
         n1 := n1.next
      ELSEIF n1.id = n2.id
         n1.bits := Eor(n1.bits, n2.bits)
         n1 := n1.next
         n2 := n2.next
      ELSE
         newnode := FastNew(SIZEOF bitnode)
         newnode.id := n2.id
         newnode.bits := n2.bits
         self.ordInsert(newnode)
         n2 := n2.next
      ENDIF
   ENDWHILE
ENDPROC

PROC and(dbm:PTR TO dBMapX) OF dBMapX
   DEF n1:REG PTR TO bitnode
   DEF n2:REG PTR TO bitnode
   n1 := self.first()
   n2 := dbm.first()
   WHILE n1
      IF n1.id < n2.id
         n1 := n1.next
      ELSEIF n1.id = n2.id
         n1.bits := n1.bits AND n2.bits
         n1 := n1.next
         n2 := n2.next
      ELSE
         n2 := n2.next
      ENDIF
   ENDWHILE
ENDPROC

PROC clear() OF dBMapX IS self.removeFastDisposeAll(SIZEOF bitnode)

PROC cloneContentsTo(d:PTR TO dBMapX) OF dBMapX
   self.cloneFastNew(d, SIZEOF bitnode)
ENDPROC d

PROC indexTraverse(proc, obj:PTR TO dbmapX_travObj, startid, endid)
   DEF a
   FOR a := startid TO stopid
      obj.x := a
      obj.bit := self.get(a)
      proc(obj)
   ENDFOR
ENDPROC

PROC forEach1CallProc(proc, obj:PTR TO dBMapX_CPObj)
   DEF node:PTR TO bitnode
   DEF a
   node := self.first()
   WHILE node
      FOR a := 0 TO 31
         IF bitGet(node.bits, a)
            obj.bit := 1
            obj.x := (node.id * 32) + a
            proc(obj)
         ENDIF
      ENDFOR
      node := node.next
   ENDWHILE
ENDPROC

PROC end() OF dBMapX IS self.clear()



