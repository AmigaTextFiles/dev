OPT TURBO

OBJECT st_stackType
  top, count
ENDOBJECT

PROC st_init (theStack : PTR TO st_stackType)
/* Simply declare the stack variable as st_stackType.   The status of the */
/* stack can be checked by testing stackname.count.                       */
  theStack.top := NIL
  theStack.count := 0
ENDPROC
  /* st_init */


PROC st_push (theStack : PTR TO st_stackType, addr)
  DEF newList, tempList
  newList := List (1)
  ListCopy (newList, [addr], ALL)
  tempList := Link (newList, theStack.top)
  theStack.top := tempList
  theStack.count := theStack.count + 1
ENDPROC
  /* st_push */


PROC st_pop (theStack : PTR TO st_stackType)
  DEF list, addr = NIL
  IF theStack.count
    list := theStack.top
    addr := ^list
    theStack.top := Next (list)
    theStack.count := theStack.count - 1
  ENDIF
ENDPROC  addr
  /* st_pop */

