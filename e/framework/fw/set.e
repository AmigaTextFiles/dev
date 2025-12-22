
-> a set is an unordered collection of elements.
-> Elements can only occur one time.
-> Time complexity for data adding is O(1).
-> Time complexity for data searching is O(n).
-> Space complexity is O(n).

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT EXPORT

MODULE 'fw/bag'

OBJECT set OF bag
ENDOBJECT

-> Add an element to the set.
PROC add(e:PTR TO set) OF set
  IF self.find(e) THEN RETURN
  e.next:=self.next
  self.next:=e
ENDPROC

