
-> a stack is a LIFO (last-in first-out) collection.
-> Time complexity for data adding is O(1).
-> Time complexity for data searching is O(1).
-> Space complexity is O(n).

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT EXPORT

MODULE 'fw/bag'

OBJECT stack OF bag
ENDOBJECT

-> Push an element to the stack.
PROC push(e:PTR TO stack) OF stack IS self.add(e)

-> Pop an element from the stack.
PROC pop() OF stack
  DEF b:PTR TO bag
  IF b:=self.next
    self.next:=b.next
    END b
  ELSE
    Raise("estk")
  ENDIF
ENDPROC

-> Top element of the stack.
PROC top() OF stack IS self.next

