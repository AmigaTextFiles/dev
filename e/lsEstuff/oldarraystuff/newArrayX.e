OPT MODULE

MODULE '*smartList'

EXPORT OBJECT newArrayX
   PRIVATE
   xlist:PTR TO smartList
ENDOBJECT

PROC newArrayX() OF newArrayX IS NEW self.xlist.smartList()

PROC setE(x, value) OF newArrayX
   DEF sn:PTR TO smartNode
   sn := self.xlist.findSN(x)
   IF sn = NIL
      sn := self.xlist.newSN(x)
   ENDIF
   sn.value := value
ENDPROC

PROC getE(x) OF newArrayX
   DEF sn:PTR TO smartNode
   sn := self.xlist.findSN(x)
   IF sn = NIL THEN RETURN NIL
ENDPROC sn.value

PROC unsetE(x) OF newArrayX
   DEF sn:PTR TO smartList
   sn := self.xlist.findSN(x)
   IF sn
      self.xlist.endSN(sn)
   ENDIF
ENDPROC

PROC countX() OF newArrayX IS self.xlist.countSN()

PROC clearA() OF newArrayX IS self.xlist.clear()

PROC end() OF newArrayX
   END self.xlist
ENDPROC
   

PROC readAOL(array:PTR TO LONG, startX, endX) OF newArrayX
   DEF a
   FOR a := startX TO endX
      self.setE(a, array[])
      array++
   ENDFOR
ENDPROC

PROC writeAOL(array:PTR TO LONG, startX, endX) OF newArrayX
   DEF a
   FOR a := startX TO endX
      array[] := self.getE(a)
      array++
   ENDFOR
ENDPROC

PROC getSumA() OF newArrayX IS self.xlist.getSumValSL()

PROC getAveA() OF newArrayX IS self.xlist.getAveValSL()

