
-> fastDictionary is a VERY efficient data structure for named objects.
-> Time complexity for data adding is O(log n).
-> Time complexity for data searching is also O(log n).
-> Space complexity is O(n) + little extra penalty compared to dictionary.

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT EXPORT

MODULE 'fw/dictionary'

OBJECT fastDictionary OF dictionary
  hashCode:INT
ENDOBJECT

-> Creation method.
-> MUST precede any call to a method, str MUST be non NULL.
PROC create(str:PTR TO CHAR) OF fastDictionary
  self.name:=str
  self.hashCode:=self.hash(str)
ENDPROC

-> Is object less than other.
PROC isLessThan(other:PTR TO fastDictionary) OF fastDictionary
ENDPROC self.hashCode<other.hashCode

-> Is object egal to other.
PROC isEqualTo(other:PTR TO fastDictionary) OF fastDictionary
  IF self.hashCode<>other.hashCode THEN RETURN FALSE
ENDPROC StrCmp(other.name,self.name,ALL)

-> Is object greater than other.
PROC isGreaterThan(other:PTR TO fastDictionary) OF fastDictionary
ENDPROC self.hashCode>other.hashCode

-> Find an element in the tree.
-> The first matching element is returned.
-> Use continu() to find next occurrences.
PROC find(key:PTR TO CHAR) OF fastDictionary
  DEF hashValue:LONG
  hashValue:=self.hash(key)
  LOOP
    IF self=NIL THEN RETURN NIL
    IF hashValue<self.hashCode
      self:=self.left
    ELSEIF hashValue>self.hashCode
      self:=self.right
    ELSEIF StrCmp(key,self.name,ALL)
      RETURN self
    ELSE
      self:=self.right
    ENDIF
  ENDLOOP
ENDPROC

-> Hash function.
PROC hash(key:PTR TO CHAR) OF fastDictionary
  DEF hashValue=0:LONG
  WHILE key[] DO hashValue:=hashValue+hashValue+key[]++
ENDPROC hashValue

