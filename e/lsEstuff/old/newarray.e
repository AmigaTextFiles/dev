OPT MODULE

MODULE 'LeifOO/xl'

CONST VALUES=128

OBJECT xnode OF xni
   values[VALUES]:ARRAY OF LONG
ENDOBJECT


EXPORT OBJECT newarray
   PRIVATE
   xlist:PTR TO xli
ENDOBJECT

PROC newarray() OF newarray
   NEW self.xlist
ENDPROC

PROC end() OF newarray
   self.clear()
   END self.xlist
ENDPROC

PROC set(x, value) OF newarray
   DEF nodenum,
       nodevaluenum,
       xnode:PTR TO xnode

   nodenum := x / VALUES
   nodevaluenum := x - (nodenum * VALUES)

   xnode := self.xlist.find(nodenum)

   IF xnode = NIL
      xnode := AllocMem(SIZEOF xnode, NIL)
      xnode.id := nodenum
      self.xlist.addtail(xnode)
   ENDIF

   setxnodeval(xnode, nodevaluenum, value)
ENDPROC

PROC unset(x) OF newarray
   DEF nodenum,
       nodevaluenum,
       xnode:PTR TO xnode

   nodenum := x / VALUES
   nodevaluenum := x - (nodenum * VALUES)

   xnode := self.xlist.find(nodenum)
 
   IF xnode = NIL THEN RETURN NIL

   setxnodeval(xnode, nodevaluenum, NIL)

   IF xnodeisNIL(xnode)
      self.xlist.remove(xnode)
      FreeMem(xnode, SIZEOF xnode)
   ENDIF
ENDPROC

PROC get(x) OF newarray
   DEF nodenum,
   nodevaluenum,
   xnode:PTR TO xnode
 
   nodenum := x / VALUES
   nodevaluenum := x - (nodenum * VALUES)

   xnode := self.xlist.find(nodenum)
 
   IF xnode <> NIL
      RETURN getxnodeval(xnode, nodevaluenum)
   ENDIF
ENDPROC NIL

PROC count() OF newarray
   DEF xnode:PTR TO xnode, c=NIL, a, stop
   xnode:=self.xlist.first()
   stop:=VALUES
   stop--
      WHILE xnode
         FOR a:=0 TO stop
            IF getxnodeval(xnode, a) THEN c++
         ENDFOR
         xnode:=xnode.next
      ENDWHILE
ENDPROC c

PROC clear() OF newarray
   freememall(self.xlist, SIZEOF xnode)
ENDPROC

PROC freememall(xl:PTR TO xl, nodesize)
   DEF xn:PTR TO xn
   xn:=xl.first()
   WHILE xn
      xl.remove(xn)
      FreeMem(xn, nodesize)
      xn:=xn.next
   ENDWHILE
ENDPROC


PROC xnodeisNIL(xnode:PTR TO xnode)
   DEF a:REG, ptr:REG PTR TO LONG, stop:REG
   stop := VALUES
   stop--
   ptr := xnode.values
   FOR a := 0 TO stop
      IF ptr[a] <> NIL THEN RETURN FALSE
   ENDFOR
ENDPROC TRUE

PROC getxnodeval(xnode:PTR TO xnode, valuenum)
   DEF ptr:PTR TO LONG, value
   ptr := (xnode.values) + (valuenum * 4)
   value := ptr[]
ENDPROC value

PROC setxnodeval(xnode:PTR TO xnode, valuenum, value)
   DEF ptr:PTR TO LONG
   ptr := (xnode.values) + (valuenum * 4)
   ptr[] := value
ENDPROC

 

