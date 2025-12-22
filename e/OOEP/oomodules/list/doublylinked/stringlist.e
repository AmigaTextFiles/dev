/*

This module contains the code of the original example program of Barry's
doubly linked list module.

Gregor Goldbach September 10 1995


Just added a new method. It takes an elist and builds a alpha sorted string
list from it. The elist's entries are copied. Named the proc after queuestack's
asQueuestack() asStringList().

Gregor Goldbach September 29 1995


  April 10 1996 Gregor Goldbach
    Removed the method asExecList for we have the execList object to convert
    an elist. To get an execList from a stringList do this:

      /*
       *  A stringList has already been built, set elist to stringList'
       *  contents:
       */

      elist.set(stringList.asList())


      /*
       *  Get execList from elist:
       */

      NEW execList.new(["list", elist.list])


    Renamed asStringList() to fromList().

*/

OPT MODULE
OPT EXPORT

MODULE 'oomodules/list/doublylinked'

OBJECT stringNode OF dlln
  string
ENDOBJECT

OBJECT stringList OF dllh
ENDOBJECT


PROC select(optionlist,index) OF stringNode
->  TODO: error check: len-o'-list!
DEF item, value,
    len

  item := ListItem(optionlist, index)

  SELECT item
    CASE "set"
      INC index

      self.string:=StrCopy(String(len:=StrLen(ListItem(optionlist,index))), ListItem(optionlist,index), len)

  ENDSELECT

ENDPROC index

PROC end() OF stringNode
  DisposeLink(self.string)
ENDPROC

PROC clear() OF stringList
  DEF node:PTR TO stringNode
  WHILE self.isEmpty()=FALSE
    node:=self.remHead()
    END node
  ENDWHILE
ENDPROC

PROC insertAlphaSorted(node:PTR TO stringNode) OF stringList
  DEF listnode:PTR TO stringNode, done=FALSE
  listnode:=self.firstNode() ->returns lastnode or tail
  REPEAT
    IF listnode=self.tail
      done:=TRUE
    ELSEIF OstrCmp(node.string, listnode.string)>=0
      done:=TRUE
    ELSE
      listnode:=listnode.succ
    ENDIF
  UNTIL done
  self.insert(node, listnode.pred)
ENDPROC

PROC printAll() OF stringList
  DEF node:PTR TO stringNode
  IF self.isEmpty()
    WriteF('*** List is empty\n')
    RETURN
  ENDIF
  node:=self.firstNode()
  WHILE node<>self.tail
    WriteF('\s\n', node.string)
    node:=node.succ
  ENDWHILE
ENDPROC


PROC asList() OF stringList
/*

  NAME

    asList() of stringList

  FUNCTION

    Returns an elist with the names as items.

*/

DEF index,
    list:PTR TO LONG,
    len,
    actualNode:PTR TO stringNode

  len := self.length()
  IF len=0 THEN RETURN
  IF (list := List(len)) = NIL THEN RETURN


  actualNode := self.firstNode()


  FOR index := 0 TO len-1
    list[index] := actualNode.string
    actualNode := actualNode.succ
  ENDFOR

  SetList(list,len)

  RETURN list

ENDPROC

EXPORT PROC fromList(list) OF stringList
DEF n:PTR TO stringNode,
    index

  FOR index := 0 TO ListLen(list)-1

    self.insertAlphaSorted(NEW n.new(["set",ListItem(list,index)]))

  ENDFOR

ENDPROC

/*

the following method asExecList() is removed from this object because of
the execList object. To get an execList from a stringList one has to do
this:

  /* a stringList has already been built */

  elist.set(stringList.asList())
  NEW execList.new(["list", elist.list])



PROC asExecList() OF stringList
/*

  NAME

    asExecList() of stringList

  FUNCTION

    Returns an execlist with the names as items. Note that the
    names are NOT copied.

*/

DEF index,
    list:PTR TO LONG,
    len,
    actualNode:PTR TO stringNode,

    execlist:PTR TO lh,
    execnode:PTR TO ln

  execlist := newlist()

  len := self.length()
  IF len=0 THEN RETURN
  IF (list := List(len)) = NIL THEN RETURN


  actualNode := self.firstNode()


  FOR index := 0 TO len-1
    execnode := newnode(NIL, actualNode.string)
    AddTail(execlist,execnode)
    actualNode := actualNode.succ
  ENDFOR

  RETURN execlist

ENDPROC

*/
