
-> a list is a collection with fixed order.
-> Elements can occur any number of times.
-> Time complexity for data adding is O(1).
-> Time complexity for data searching is O(n).
-> Space complexity is O(n).

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE

MODULE 'fw/bag'

EXPORT OBJECT list OF bag
  last:PTR TO bag
ENDOBJECT

-> Add an element to the list.
PROC add(e:PTR TO bag) OF list
  IF self.next=NIL THEN self.next:=e
  IF self.last THEN self.last.next:=e
  self.last:=e
ENDPROC

-> Find i-th list item (from 1).
PROC item(i:LONG) OF list
  DEF n
  FOR n:=0 TO i
    self:=self.next
    IF self=NIL THEN RETURN NIL
  ENDFOR
ENDPROC self

