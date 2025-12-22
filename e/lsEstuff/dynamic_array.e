OPT MODULE

->
-> fast dynamic array of CHAR/INT/LONG
-> not as flexible/much functions as collextionX.
-> but much faster when using it not-so-randomly :)
-> and its ofcource alot smaller and simler..
->

MODULE 'LeifOO/xli'

EXPORT CONST DAVS_CHAR=1, DAVS_INT=2, DAVS_LONG=4

OBJECT xnode OF xni
   values[4]:ARRAY OF CHAR
ENDOBJECT


EXPORT OBJECT dynamic_array
   PRIVATE
   xlist:PTR TO xli
   valuesize:CHAR ->1/2/4, (CHAR/INT/LONG)
   valuespernode:INT 
   storagesize:INT
ENDOBJECT

PROC dynamic_array(valuesize=1, alloc=64) OF dynamic_array
   IF (valuesize < 1) OR (valuesize > 4) THEN RETURN NIL
   IF alloc > 8000 THEN RETURN NIL
   self.valuesize := valuesize
   self.valuespernode := alloc * 4
   self.storagesize := valuesize * self.valuespernode
   NEW self.xlist
ENDPROC self.valuesize

PROC end() OF dynamic_array
   self.clear()
   END self.xlist
ENDPROC

PROC set(x, value) OF dynamic_array
   DEF nodenum,
       nodevaluenum,
       xnode:PTR TO xnode

   nodenum := x / self.valuespernode
   nodevaluenum := x - (nodenum * self.valuespernode)

   xnode := self.xlist.find(nodenum)

   IF xnode = NIL
      xnode := AllocMem( (SIZEOF xnode) - 4 + self.storagesize, NIL)
      xnode.id := nodenum
      self.xlist.addTail(xnode)
   ENDIF

   setxnodeval(self, xnode, nodevaluenum, value)
ENDPROC

PROC unset(x) OF dynamic_array
   DEF nodenum,
       nodevaluenum,
       xnode:PTR TO xnode

   nodenum := x / self.valuespernode
   nodevaluenum := x - (nodenum * self.valuespernode)

   xnode := self.xlist.find(nodenum)
 
   IF xnode = NIL THEN RETURN NIL

   setxnodeval(self, xnode, nodevaluenum, NIL)

   IF xnodeisNIL(self, xnode)
      self.xlist.remove(xnode)
      FreeMem(xnode, (SIZEOF xnode) - 4 + self.storagesize)
   ENDIF
ENDPROC

PROC get(x) OF dynamic_array
   DEF nodenum,
   nodevaluenum,
   xnode:PTR TO xnode
 
   nodenum := x / self.valuespernode
   nodevaluenum := x - (nodenum * self.valuespernode)

   xnode := self.xlist.find(nodenum)
 
   IF xnode <> NIL
      RETURN getxnodeval(self, xnode, nodevaluenum)
   ENDIF
ENDPROC NIL

PROC count() OF dynamic_array
   DEF xnode:PTR TO xnode, c=NIL, a, stop
   xnode:=self.xlist.first()
   stop:=self.valuespernode
   stop--
      WHILE xnode
         FOR a:=0 TO stop
            IF getxnodeval(self, xnode, a) THEN c++
         ENDFOR
         xnode:=xnode.next
      ENDWHILE
ENDPROC c

PROC clear() OF dynamic_array
   freememall(self.xlist, (SIZEOF xnode) - 4 + self.storagesize)
ENDPROC

PROC freememall(xli:PTR TO xli, nodesize)
   DEF xni:PTR TO xni
   xni:=xli.first()
   WHILE xni
      xli.remove(xni)
      FreeMem(xni, nodesize)
      xni:=xni.next
   ENDWHILE
ENDPROC


PROC xnodeisNIL(da:PTR TO dynamic_array, xnode:PTR TO xnode)
   DEF a:REG, ptr:REG PTR TO LONG, stop:REG
   stop := (da.storagesize) / 4
   stop--
   ptr := xnode.values
   FOR a := 0 TO stop
      IF ptr[a] <> NIL THEN RETURN FALSE
   ENDFOR
ENDPROC TRUE

PROC getxnodeval(da:PTR TO dynamic_array, xnode:PTR TO xnode, valuenum)
   DEF ptr:PTR TO CHAR, valuesize, value,
       iptr:PTR TO INT, lptr:PTR TO LONG
   valuesize := da.valuesize
   ptr := (xnode.values) + (valuenum * valuesize)
   SELECT valuesize
   CASE DAVS_CHAR
      value := ptr[]
   CASE DAVS_INT
      iptr := ptr
      value := iptr[]
   CASE DAVS_LONG
      lptr := ptr
      value := lptr[]
   ENDSELECT
ENDPROC value

PROC setxnodeval(da:PTR TO dynamic_array, xnode:PTR TO xnode, valuenum, value)
   DEF ptr:PTR TO CHAR, valuesize, iptr:PTR TO INT, lptr:PTR TO LONG
   valuesize := da.valuesize
   ptr := (xnode.values) + (valuenum * valuesize)
   SELECT valuesize
   CASE DAVS_CHAR
      ptr[] := value
   CASE DAVS_INT
      iptr := ptr
      iptr[] := value
   CASE DAVS_LONG
      lptr := ptr
      lptr[] := value
   ENDSELECT
ENDPROC

OBJECT parse_point
   value
   x
   PRIVATE
   c_xnode:PTR TO xnode
   c_valuenum:LONG
ENDOBJECT
 

