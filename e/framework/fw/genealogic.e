
-> genealogic is a VERY efficient data structure for named objects linked
-> with single or multiple inheritance (just like OO classes).
-> Time complexity for data adding is O(log n).
-> Time complexity for data searching is also O(log n).
-> Time complexity for inheritance criteria is O(1).
-> Space complexity is O(n).

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE

MODULE 'fw/primeStream','fw/fastDictionary'

DEF primes:PTR TO primeStream

EXPORT OBJECT genealogic OF fastDictionary
  parents:LONG
ENDOBJECT

-> Creation method.
PROC create(str:PTR TO CHAR) OF genealogic
  IF primes=NIL THEN NEW primes.create()
  self.name:=str
  self.hashCode:=self.hash(str)
  self.parents:=primes.next()
ENDPROC

-> Creation method of an entity from which every other entities inherit.
PROC allHeirs(str:PTR TO CHAR) OF genealogic
  self.name:=str
  self.hashCode:=self.hash(str)
  self.parents:=1
ENDPROC

-> Creation method of an entity which inherits from all other entities.
PROC allParents(str:PTR TO CHAR) OF genealogic
  self.name:=str
  self.hashCode:=self.hash(str)
  self.parents:=0
ENDPROC

-> Add a parent to this entity.
PROC addParent(parent:PTR TO genealogic) OF genealogic
  self.parents:=Mul(self.parents,parent.parents)
ENDPROC

-> Is object a parent of 'other'.
-> Note that an object is a parent of itself.
PROC isParentOf(other:PTR TO genealogic) OF genealogic
  IF self.parents=0 THEN RETURN other.parents=0
ENDPROC Mod(other.parents,self.parents)=0

-> Is object an heir of 'other'.
-> Note that an object is an heir of itself.
PROC isHeirOf(other:PTR TO genealogic) OF genealogic
  IF other.parents=0 THEN RETURN self.parents=0
ENDPROC Mod(self.parents,other.parents)=0

