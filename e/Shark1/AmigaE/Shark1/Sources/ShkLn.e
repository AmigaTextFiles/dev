OPT MODULE
OPT EXPORT

MODULE 'amigalib/lists',
       'exec/lists',
       'exec/nodes'

CONST NAMENODE_ID=100

OBJECT nameNode
  ln:ln
  data[2999]:ARRAY
ENDOBJECT

PROC addName(list, name, datasize=62)
  DEF namenode:PTR TO nameNode
  NEW namenode
  AstrCopy(namenode.data, name, datasize)
  namenode.ln.name:=namenode.data
  namenode.ln.type:=NAMENODE_ID
  namenode.ln.pri:=0
  AddTail(list, namenode)
ENDPROC

PROC headName(list, name, datasize=62)
  DEF namenode:PTR TO nameNode
  NEW namenode
  AstrCopy(namenode.data, name, datasize)
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
