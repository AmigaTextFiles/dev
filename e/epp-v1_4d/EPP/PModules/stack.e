OPT TURBO

OBJECT st_stackType
  top, count
ENDOBJECT

OBJECT st_stackNodeType
  pred, data
ENDOBJECT

PROC st_init(theStack:PTR TO st_stackType)
/* Simply declare the stack variable as st_stackType.   The status */
/* of the stack can be checked by testing stackname.count.         */
  theStack.top:=NIL
  theStack.count:=0
ENDPROC
  /* st_init */


PROC st_push(theStack:PTR TO st_stackType, addr)
  DEF newNode:PTR TO st_stackNodeType
  IF (newNode:=New(SIZEOF st_stackNodeType))=NIL THEN Raise("MEM")
  newNode.data:=addr
  newNode.pred:=theStack.top
  theStack.top:=newNode
  theStack.count:=theStack.count+1
ENDPROC
  /* st_push */


PROC st_pop(theStack:PTR TO st_stackType)
  DEF node:PTR TO st_stackNodeType, addr=NIL
  IF theStack.count
    node:=theStack.top
    addr:=node.data
    theStack.top:=node.pred
    Dispose(node)
    theStack.count:=theStack.count-1
  ENDIF
ENDPROC addr
  /* st_pop */

