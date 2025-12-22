
-> a queue is a FIFO collection.
-> Time complexity for data adding is O(1).
-> Time complexity for data searching is O(1).
-> Space complexity is O(n).

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT EXPORT

MODULE 'fw/bag','fw/list'

OBJECT queue OF list
ENDOBJECT

-> First element of the queue.
PROC first() OF queue IS self.next

-> Remove first element of the queue.
PROC removeFirst() OF queue
  DEF b:PTR TO bag
  IF b:=self.next
    self.next:=b.next
    END b
  ENDIF
ENDPROC

