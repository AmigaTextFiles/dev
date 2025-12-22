OPT MODULE, REG = 5

MODULE 'exec/lists', 'exec/nodes', 'amigalib/lists'

CONST DATASIZE = 512

OBJECT nameNode
  ln:ln
  data[DATASIZE]:ARRAY
ENDOBJECT

CONST NAMENODE_ID=100

EXPORT PROC addName(list:PTR TO lh, name, prednode = NIL:PTR TO ln)
  DEF namenode:PTR TO nameNode
  NEW namenode
  -> E-Note: copy *safely* to namenode.data
  AstrCopy(namenode.data, name, DATASIZE)
  namenode.ln.name := namenode.data
  namenode.ln.type := NAMENODE_ID
  namenode.ln.pri  := 0
  IF prednode
    Insert(list, namenode, prednode)
  ELSE
    AddTail(list, namenode)
  ENDIF
ENDPROC

EXPORT PROC removeNode(list:PTR TO lh,num)
  DEF node:PTR TO ln
  IF node := getNode(list, num) THEN Remove(node)
ENDPROC num


EXPORT PROC freeNameNodes(list:PTR TO lh)
  DEF worknode:PTR TO nameNode, nextnode
  worknode := list.head
  WHILE nextnode := worknode.ln.succ
    END worknode
    worknode := nextnode
  ENDWHILE
  newList(list)
ENDPROC

EXPORT PROC findNodeNumber(list:PTR TO lh, str)
  DEF node:PTR TO ln, count = 0, found = FALSE

  IF list.tailpred <> list
    node  := list.head
    WHILE (found = FALSE) AND (node.succ)
      IF StrCmp(node.name, str)
        found := TRUE
      ELSE
        node := node.succ
        INC count
      ENDIF
    ENDWHILE
  ENDIF
ENDPROC IF found THEN count ELSE -1

EXPORT PROC findNodeName(list:PTR TO lh, number)
  DEF node:PTR TO ln
  node := getNode(list, number)
ENDPROC IF node THEN node.name ELSE NIL

EXPORT PROC movelistnode2(l1:PTR TO lh, pos1, l2:PTR TO lh, pos2)
  DEF newnode:PTR TO ln, prednode:PTR TO ln

  IF newnode := getNode(l1, pos1)
    IF (l1 = l2) AND (pos1 < pos2) THEN INC pos2

    IF pos2 < 1
      Remove(newnode)
      AddHead(l2, newnode)

      RETURN
    ELSEIF prednode := getNode(l2, pos2 - 1)

      IF newnode <> prednode
        Remove(newnode)
        Insert(l2, newnode, prednode)

        IF (pos1 < pos2)
          RETURN (pos2 - 1)
        ELSE
          RETURN (pos2)
        ENDIF
      ENDIF
    ELSE
      RETURN (pos2 - 2)
    ENDIF

  ENDIF
ENDPROC


EXPORT PROC replacenode(list:PTR TO lh, str, num)
  DEF node:PTR TO ln
  IF countnodes(list) >= num
    node := getNode(list, num)
    addName(list, str, node)
    Remove(node)
  ELSE
    addName(list, str)
  ENDIF
ENDPROC

EXPORT PROC countnodes(list:PTR TO lh)
  DEF node:PTR TO ln, count = 0

  IF list.tailpred <> list
    node  := list.head
    WHILE (node.succ)
      node := node.succ
      INC count
    ENDWHILE
  ENDIF
ENDPROC count

EXPORT PROC getNode(list:PTR TO lh, num)
DEF node:PTR TO ln

  IF (list.tailpred <> list) AND (num >= 0)
    node := list.head

    WHILE (num-- >= 0) AND (node.succ <> NIL)
      node := node.succ
    ENDWHILE

    IF node.succ THEN RETURN node
  ENDIF
ENDPROC
