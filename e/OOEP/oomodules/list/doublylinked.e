/****** doublylinked/--background-- ******************************************

       PURPOSE
         no hassle, flexible, doubly-linked list base class

       NOTES

          1. head and tail are dummy nodes which are part of the list header.
          They cannot be removed, nor can your data be stored in them!
          Crashes will occur if you attempt to circumvent the methods.  All
          your data nodes are stored AFTER list.head and BEFORE list.tail.
          This is to simplify the algorithms.

          2. The following macros are provided for speed and work precisely
          the same as their OO counterparts, except they require the argument
          'list': LISTISEMPTY(list), FIRSTNODE(list), LASTNODE(list).

          3. (Gregor Goldbach) Ported the module to the OOEP of the AEE.
          Thus I had to add the methods select(), init() and end(). Made a
          minor change to the dllh object, the attributes are now pointers.

          For additional information about modification read the doc of every
          proc.

       CREATION
          early September 1995 Gregor Goldbach

       HISTORY
          September 10 1995 Gregor Goldbach
            Added length() to dllh.

******************************************************************************

History


*/
    new()
      - constructor. ALWAYS call it when NEWing the object!

    isEmpty()
      - test if list is empty

    firstNode()
      - return first node, list.tail if list is empty

    lastNode()
      - return last node, list.head if list is empty

    insert(node:PTR TO dlln, listNode:PTR TO dlln)
      - insert node after listnode

    addHead(node:PTR TO dlln)
      - add node to front of list

    addTail(node:PTR TO dlln)
      - add node to end of list

    remove(node:PTR TO dlln)
      - remove node from list, return node

    remHead()
      - remove first node from list, return node

    remTail()
      - remove last node from list, return node

    end()

      - automatically called when you END the object. Frees alls resources
        allocated.


*----------------------------------------------------------------------------*/

OPT MODULE
OPT EXPORT,
    REG=5,
    PREPROCESS

MODULE 'oomodules/object'

OBJECT dlln OF object
/****** dlln/--dlln-- ******************************************

       NAME
         dlln -- doubly linked list node

       ATTRIBUTES
         pred:PTR TO dlln -- Predecessor

         succ:PTR TO dlln -- Successor

       SEE ALSO
         doublylinked/--dllh--
******************************************************************************

History


*/
  pred:PTR TO dlln
  succ:PTR TO dlln
ENDOBJECT

PROC name() OF dlln IS 'doubly linked list node'
/****** dlln/name ******************************************

       NAME
         name() -- Return 'doubly linked list node'

       SYNOPSIS
         dlln.name()

       FUNCTION
         Returns name of object.

******************************************************************************

History


*/
PROC size() OF dlln IS 12
/****** dlln/size ******************************************

       NAME
         size() -- Return size of dlln

       SYNOPSIS
         dlln.size()

       FUNCTION
         Gets you the size of the object.

******************************************************************************

History


*/

PROC select(optionlist,index) OF dlln
/****** dlln/select ******************************************

       NAME
         select() -- Selection of action on initialization

       SYNOPSIS
         dlln.select(otionslist,index)

       FUNCTION
         Recognizes the following items:
           "pred" -- next item is predecessor

           "succ" -- next item is successor

       INPUTS
         optionlist -- optionlist

         index -- index of optionlist

       SEE ALSO
         object/select()
******************************************************************************

History


*/
->  TODO: error check: len-o'-list!
DEF item, value

  item := ListItem(optionlist, index)

  SELECT item
    CASE "pred"
      INC index
      self.pred := ListItem(optionlist,index)

    CASE "succ"
      INC index
      self.succ := ListItem(optionlist,index)

  ENDSELECT

ENDPROC index

OBJECT dllh OF object
/****** dllh/--dllh-- ******************************************

       NAME
         dllh -- doubly linked list header

       ATTRIBUTES
         head:PTR TO dlln -- The head of the list

         tail:PTR TO dlln -- The tail of the list

       SEE ALSO
         doublylinked/--dlln--
******************************************************************************

History


*/
  head:PTR TO dlln
  tail:PTR TO dlln
ENDOBJECT

PROC name() OF dllh IS 'doubly linked list header'
/****** dllh/name ******************************************

       NAME
         name() -- Return 'doubly linked list header'

       SYNOPSIS
         dllh.name()

       FUNCTION
         Returns the name of the object.

******************************************************************************

History


*/
PROC size() OF dllh IS 28 ->12+12+4
/****** dllh/size ******************************************

       NAME
         size() -- Get size of object

       SYNOPSIS
         dllh.size()

       FUNCTION
         Gets you the size of the object.

******************************************************************************

History


*/

PROC select(optionlist,index) OF dllh
/****** dllh/select ******************************************

       NAME
         select() -- Select actionon initialization.

       SYNOPSIS
         dllh.select()

       FUNCTION
         Recognizes no items.

******************************************************************************

History


*/
->  TODO: error check: len-o'-list!
DEF item, value

->  item := ListItem(optionlist, index)

ENDPROC index

PROC init() OF dllh
/****** dllh/init ******************************************

       NAME
         init() -- Initialization of object.

       SYNOPSIS
         dllh.init()

       FUNCTION
         Initializes the object that way that an empty list is created.
******************************************************************************

History


*/
DEF n:PTR TO dlln

  NEW n.new()
  self.head := n

  NEW n.new()
  self.tail := n

  self.head.succ:=self.tail
  self.tail.pred:=self.head
  self.head.pred:=NIL
  self.tail.succ:=NIL
ENDPROC

PROC end() OF dllh
/****** dllh/end ******************************************

       NAME
         end() -- Global destructor.

       SYNOPSIS
         dllh.end()

       FUNCTION
         Frees allocated resources. This does NOT mean that the list is
         automatically cleared.

******************************************************************************

History


*/
DEF n

  n := self.tail
  Dispose(n)

  n := self.head
  Dispose(n)

ENDPROC


#define LISTISEMPTY(list) (list::dllh.head.succ=list::dllh.tail)
/****** dllh/LISTISEMPTY ******************************************

       NAME
         LISTISEMPTY

       SYNOPSIS
         LISTISEMPTY(list:PTR TO dllh)

       FUNCTION
         Test if the list is empty.

       INPUTS
         list:PTR TO dllh -- The list to test

       RESULT
         TRUE if the list is empty, FALSE otherwise

******************************************************************************

History


*/
#define FIRSTNODE(list)   (list::dllh.head.succ)
/****** dllh/FIRSTNODE ******************************************

       NAME
         FIRSTNODE -- Get first node of list.

       SYNOPSIS
         FIRSTNODE(list:PTR TO dllh)

       FUNCTION
         Get the first node of the list.

       INPUTS
         list:PTR TO dllh -- The list to get the first node of.

       RESULT
         PTR TO dlln -- The first node of the list

******************************************************************************

History


*/
#define LASTNODE(list)    (list::dllh.tail.pred)
/****** dllh/LASTNODE ******************************************

       NAME
         LASTNODE -- Get first node of list.

       SYNOPSIS
         LASTNODE(list:PTR TO dllh)

       FUNCTION
         Get the last node of the list.

       INPUTS
         list:PTR TO dllh -- The list to get the last node of.

       RESULT
         PTR TO dlln -- The last node of the list

******************************************************************************

History


*/

PROC isEmpty() OF dllh   IS self.head.succ=self.tail
/****** dllh/isEmpty ******************************************

       NAME
         isEmpty() -- Is the list empty?

       SYNOPSIS
         dllh.isEmpty()

       FUNCTION
         Test if the list is empty.

       RESULT
         TRUE if the list is empty, FALSE otherwise

******************************************************************************

History


*/
PROC firstNode() OF dllh IS self.head.succ
/****** dllh/firstNode ******************************************

       NAME
         firstNode() -- Get first node of list.

       SYNOPSIS
         dllh.firstNode()

       FUNCTION
         Get the first node of the list.

       RESULT
         PTR TO dlln -- The first node of the list

******************************************************************************

History


*/
PROC lastNode() OF dllh  IS self.tail.pred
/****** dllh/lastNode ******************************************

       NAME
         lastNode() -- Get first node of list.

       SYNOPSIS
         dllh.lastNode()

       FUNCTION
         Get the last node of the list.

       RESULT
         PTR TO dlln -- The last node of the list

******************************************************************************

History


*/

PROC insert(node:PTR TO dlln, listNode:PTR TO dlln) OF dllh
/****** dllh/insert ******************************************

       NAME
         insert() -- Insert node in list.

       SYNOPSIS
         dllh.insert(node:PTR TO dlln, listNode:PTR TO dlln)

       FUNCTION
         Inserts a node after another.

       INPUTS
         node:PTR TO dlln -- Node to insert.

         listNode:PTR TO dlln -- Node after which the first node will be
             inserted.

******************************************************************************

History


*/
  node.pred:=listNode
  node.succ:=listNode.succ
  listNode.succ:=node
  listNode:=node.succ
  listNode.pred:=node
ENDPROC

PROC addHead(node:PTR TO dlln) OF dllh
/****** dllh/addHead ******************************************

       NAME
         addHead() -- Insert node at the head of the list.

       SYNOPSIS
         dllh.addHead(node:PTR TO dlln)

       FUNCTION
         Inserts a node at the head of the list.

       INPUTS
         node:PTR TO dlln -- Node to insert.

******************************************************************************

History


*/
  self.insert(node, self.head)
ENDPROC

PROC addTail(node:PTR TO dlln) OF dllh
/****** dllh/addTail ******************************************

       NAME
         addTail() -- Insert a node at the tail of the list.

       SYNOPSIS
         dllh.addTail(node:PTR TO dlln)

       FUNCTION
         Inserts a node at the tail of the list.

       INPUTS
         node:PTR TO dlln -- Node to insert.

******************************************************************************

History


*/
  self.insert(node, self.tail.pred)
ENDPROC

PROC remove(node:PTR TO dlln) OF dllh
/****** dllh/remove ******************************************

       NAME
         remove() -- Removes a node from the list.

       SYNOPSIS
         dllh.remove(node:PTR TO dlln)

       FUNCTION
         Removes a node from the list it's in.

       INPUTS
         node:PTR TO dlln -- Node to remove.

       RESULT
         PTR TO dlln -- The node that was removed.

******************************************************************************

History


*/
  IF self.head.succ=self.tail THEN RETURN NIL
  node.pred.succ:=node.succ
  node.succ.pred:=node.pred
  node.succ:=NIL
  node.pred:=NIL
ENDPROC node

PROC remHead() OF dllh IS self.remove(self.head.succ)
/****** dllh/remHead ******************************************

       NAME
         remHead() -- Remove the head of the list.

       SYNOPSIS
         dllh.remHead()

       FUNCTION
         Removes it's head.

       RESULTS
         PTR TO dlln -- The ex-head.

******************************************************************************

History


*/

PROC remTail() OF dllh IS self.remove(self.tail.succ)
/****** dllh/remTail ******************************************

       NAME
         remTail() -- Remove the tail of the list.

       SYNOPSIS
         dllh.remTail()

       FUNCTION
         Removes it's tail.

       RESULT
         PTR TO dlln -- The ex-tail.

******************************************************************************

History


*/

PROC length() OF dllh
/****** dllh/length ******************************************

       NAME
         length() -- Get the length of the list.

       SYNOPSIS
         dllh.length()

       FUNCTION
         Gets the number of nodes in this list. 0 means the list is empty.

       RESULT
         The number of nodes in this list.

******************************************************************************

History


*/
DEF actualNode:PTR TO dlln,
    lastNode:PTR TO dlln,
    count=1

  IF self.isEmpty() THEN RETURN 0

  actualNode := self.firstNode()
  lastNode := self.lastNode()


  WHILE (actualNode<>lastNode)
    actualNode := actualNode.succ
    count++
  ENDWHILE

ENDPROC count
/*EE folds
-1
83 21 122 43 125 21 164 22 167 28 170 26 311 28 314 21 317 21 320 28 367 35 
EE folds*/
