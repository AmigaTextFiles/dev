/* This module contain linked-list support stuff. */
/* By Eric Sauvageau */

OPT MODULE

MODULE 'exec/nodes', 'exec/lists'


-> +--------------------------------+
-> | Initialize an Exec linked list.|
-> +--------------------------------+
EXPORT PROC lh_newList()
DEF l:PTR TO mlh
  l:=NewR(SIZEOF mlh)
  l.head:=l+4
  l.tail:=NIL
  l.tailpred:=l
ENDPROC l


-> +------------------------------------------------+
-> | Create a new node of size "size" named "name". |
-> +------------------------------------------------+
EXPORT PROC lh_newnode(name,size)
DEF l:PTR TO ln
  l:=NewR(size)
  l.name:=String(StrLen(name))
  StrCopy(l.name,name,ALL)
ENDPROC l


->  ------------------------------------------------------
->  Add a node to a given list, keeping the list sorted.
->  Returns position inserted, or -1 if an error occured.
->  ------------------------------------------------------

EXPORT PROC lh_addNodeSorted(list:PTR TO mlh,node:PTR TO ln)
DEF compareResult, done=FALSE, current_node:PTR TO ln, position = 0

  IF node = NIL THEN RETURN -1
  current_node:=list.head
  IF list.tailpred=list
     AddHead(list, node)
  ELSEIF (compareResult:=OstrCmp(current_node.name,node.name)) <> 0
     IF compareResult = -1
       AddHead(list, node)
     ELSEIF current_node=list.tailpred
       AddTail(list, node)
     ELSE
       WHILE done=FALSE
         current_node:=current_node.succ
         position := position +1
         IF current_node.succ=NIL
           done:=TRUE
         ELSEIF (compareResult:=OstrCmp(current_node.name,node.name)) <= 0
           IF compareResult=0 THEN done:=10 ELSE done := TRUE
         ENDIF
       ENDWHILE
       IF (done <> 10)
          Insert(list, node, current_node.pred)
       ELSE
          position := -1
       ENDIF
     ENDIF
  ENDIF
ENDPROC position


->  +-----------------------------------------------+
->  | Free all memory for this list                 |
->  | Must be a standard list with "ln" nodes!      |
->  +-----------------------------------------------+

EXPORT PROC lh_freeList(list:PTR TO mlh,deallocate=FALSE)
DEF node:PTR TO ln
    IF list = NIL THEN RETURN     /* already de-allocated */

    REPEAT
       node := RemHead(list)
       IF node <> 0
          DisposeLink(node.name)
          Dispose(node)
       ENDIF
    UNTIL node = 0
    IF deallocate = TRUE THEN Dispose(list)
ENDPROC


->  +----------------------------------------------+
->  | Returns the position of node "name", or -1.  |
->  +----------------------------------------------+

EXPORT PROC lh_getPosition(list:PTR TO mlh,name)
DEF position=0, node: PTR TO ln

  IF list.tailpred = list THEN RETURN (-1)

  node:=list.head
  REPEAT
     IF StrCmp(node.name,name) THEN RETURN position
     node:=node.succ
     position := position +1
  UNTIL (node.succ = NIL)
ENDPROC (-1)


->  +---------------------------------------+
->  | Inputs a position number and a list.  |
->  | Return a PTR to the wanted node.      |
->  +---------------------------------------+
EXPORT PROC lh_getNode(list:PTR TO mlh,position)
DEF node: PTR TO ln,i
  node:=list.head
  FOR i:=1 TO position DO node:=node.succ
ENDPROC (node)


->  +----------------------------------------------+
->  | Returns the number of node linked to "list". |
->  +----------------------------------------------+

EXPORT PROC lh_itemsTotal(list:PTR TO mlh)
DEF items=0, node:PTR TO ln

  IF list.tailpred=list THEN RETURN 0
  node := list.head
  REPEAT
     items := items +1
     node:=node.succ
  UNTIL node.succ = NIL
ENDPROC items

CHAR 'listhandling.m 1.0 (9.11.95)',0

