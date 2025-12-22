
-> dictionary is an efficient data structure for named objects.
-> Time complexity for data adding is O(log n).
-> Time complexity for data searching is also O(log n).
-> Space complexity is O(n).

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT EXPORT

MODULE 'fw/sortedTree'

OBJECT dictionary OF sortedTree
  name:PTR TO CHAR
ENDOBJECT

-> Creation method.
-> MUST precede any call to a method, str MUST be non NULL.
PROC create(str) OF dictionary
  self.name:=str
ENDPROC

-> Is object less than other.
PROC isLessThan(other:PTR TO dictionary) OF dictionary
ENDPROC OstrCmp(other.name,self.name,ALL)=-1

-> Is object egal to other.
PROC isEqualTo(other:PTR TO dictionary) OF dictionary
ENDPROC StrCmp(other.name,self.name,ALL)

-> Is object greater than other.
PROC isGreaterThan(other:PTR TO dictionary) OF dictionary
ENDPROC OstrCmp(other.name,self.name,ALL)=1

-> Find an element in the tree.
-> The first matching element is returned.
-> Use continu() to find next occurrences.
PROC find(key:PTR TO CHAR) OF dictionary
  DEF c
  LOOP
    IF self=NIL THEN RETURN NIL
    c:=OstrCmp(self.name,key,ALL)
    IF c=-1
      self:=self.left
    ELSEIF c=1
      self:=self.right
    ELSE
      RETURN self
    ENDIF
  ENDLOOP
ENDPROC

-> Find next element in the tree that has same name.
-> Usually this is used on element returned by find.
PROC continu() OF dictionary
  DEF more:PTR TO dictionary
  IF (more:=self.right)=NIL THEN RETURN NIL
ENDPROC more.find(self.name)

-> Print a readeable form of the object to standard output.
PROC out() OF dictionary
  VfPrintf(stdout,'\s ',[self.name])
ENDPROC

-> NEVER call this method. Use loadObject() instead.
PROC load() OF dictionary
  IF self.name  THEN self.name :=self.loadString()
  IF self.left  THEN self.left :=self.loadObject()
  IF self.right THEN self.right:=self.loadObject()
ENDPROC

-> NEVER call this method. Use storeObject() instead.
PROC store() OF dictionary
  IF self.name  THEN self.storeString(self.name)
  IF self.left  THEN self.left.storeObject()
  IF self.right THEN self.right.storeObject()
ENDPROC

