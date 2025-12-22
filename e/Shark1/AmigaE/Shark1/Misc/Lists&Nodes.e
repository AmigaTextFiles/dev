MODULE 'amigalib/lists',
       'exec/lists',
       'exec/nodes'

CONST DATASIZE=62

OBJECT nameNode
  ln:ln
  data[DATASIZE]:ARRAY
ENDOBJECT

CONST NAMENODE_ID=100

PROC main()
  DEF nameList=NIL:PTR TO lh
  NEW nameList
  newList(nameList)

  addName(nameList, 'Name7');  addName(nameList, 'Name6')
  addName(nameList, 'Name5');  addName(nameList, 'Name4')
  addName(nameList, 'Name2');  addName(nameList, 'Name0')

  addName(nameList, 'Name7');  addName(nameList, 'Name5')
  addName(nameList, 'Name3');  addName(nameList, 'Name1')

WriteF('location name5 to $\h\n',displayName(nameList, 'Name5'))
WriteF('\s\n',displayNameList(nameList,1))

freeNameNodes(nameList)
ENDPROC

PROC addName(list, name)
  DEF namenode:PTR TO nameNode
  NEW namenode
  AstrCopy(namenode.data, name, DATASIZE)
  namenode.ln.name:=namenode.data
  namenode.ln.type:=NAMENODE_ID
  namenode.ln.pri:=0
  AddTail(list, namenode)
ENDPROC

PROC headName(list, name)
  DEF namenode:PTR TO nameNode
  NEW namenode
  AstrCopy(namenode.data, name, DATASIZE)
  namenode.ln.name:=namenode.data
  namenode.ln.type:=NAMENODE_ID
  namenode.ln.pri:=0
  AddHead(list, namenode)
ENDPROC

PROC freeNameNodes(list:PTR TO lh)
  DEF worknode:PTR TO nameNode, nextnode
  worknode:=list.head
  WHILE nextnode:=worknode.ln.succ
    END worknode
    worknode:=nextnode
  ENDWHILE
ENDPROC

PROC displayNameList(list:PTR TO lh,numer)
  DEF node:PTR TO ln,retrn,a
  IF list.tailpred=list
    RETURN -1
  ELSE
    node:=list.head
   FOR a:=0 TO numer
      retrn:=node.name
      node:=node.succ
   ENDFOR
  ENDIF
ENDPROC retrn

PROC displayName(list, name)
  DEF node:PTR TO ln,retrn
  IF node:=FindName(list,name)
    WHILE node
      retrn:=node
      node:=FindName(node, name)
    ENDWHILE
  ELSE
    RETURN -1
  ENDIF
ENDPROC retrn
