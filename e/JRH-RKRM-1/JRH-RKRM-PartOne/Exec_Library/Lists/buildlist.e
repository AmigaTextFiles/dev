-> buildlist.e - Example which uses an application-specific Exec list

MODULE 'amigalib/lists',
       'exec/lists',
       'exec/nodes'

CONST DATASIZE=62

OBJECT nameNode
  ln:ln               -> System Node structure
  data[DATASIZE]:ARRAY  -> Node-specific data
ENDOBJECT

CONST NAMENODE_ID=100  -> The type of 'nameNode'

PROC main() HANDLE
  DEF nameList=NIL:PTR TO lh  -> Note that a mlh would also work
  NEW nameList
  newList(nameList)  -> Important: prepare header for use

  addName(nameList, 'Name7');  addName(nameList, 'Name6')
  addName(nameList, 'Name5');  addName(nameList, 'Name4')
  addName(nameList, 'Name2');  addName(nameList, 'Name0')

  addName(nameList, 'Name7');  addName(nameList, 'Name5')
  addName(nameList, 'Name3');  addName(nameList, 'Name1')

  displayName(nameList, 'Name5')
  displayNameList(nameList)

EXCEPT DO
  IF nameList
    -> E-Note: none of this is necessary, since the program is terminating
    ->         and the memory will be freed automatically
    freeNameNodes(nameList)
    END nameList  -> Free list header
  ENDIF
  SELECT exception
  CASE "MEM"; WriteF('Error: Out of memory\n')
  ENDSELECT
ENDPROC

-> Allocate a NameNode structure, copy the given name into the structure, then
-> add it the specified list.  This example does not provide an error return
-> for the out of memory condition.
-> E-Note: ...instead it raises an exception which is handled by the caller
PROC addName(list, name)
  DEF namenode:PTR TO nameNode
  NEW namenode
  -> E-Note: copy *safely* to namenode.data
  AstrCopy(namenode.data, name, DATASIZE)
  namenode.ln.name:=namenode.data
  namenode.ln.type:=NAMENODE_ID
  namenode.ln.pri:=0
  AddHead(list, namenode)
ENDPROC

-> Free the entire list, including the header.  The header is not updated as
-> the list is freed.  This function demonstrates how to avoid referencing
-> freed memory when deallocating nodes.
PROC freeNameNodes(list:PTR TO lh)
  DEF worknode:PTR TO nameNode, nextnode
  worknode:=list.head  -> First node
  WHILE nextnode:=worknode.ln.succ
    END worknode
    worknode:=nextnode
  ENDWHILE
ENDPROC

-> Print the names of each node in a list.
PROC displayNameList(list:PTR TO lh)
  DEF node:PTR TO ln
  IF list.tailpred=list
    WriteF('List is empty.\n')
  ELSE
    node:=list.head
    WHILE node.succ
      WriteF('$\h -> \s\n', node, node.name)
      node:=node.succ
    ENDWHILE
  ENDIF
ENDPROC

-> Print the location of all nodes with a specified name.
PROC displayName(list, name)
  DEF node:PTR TO ln
  IF node:=FindName(list,name)
    WHILE node
      WriteF('Found a \s at location $\h\n', node.name, node)
      node:=FindName(node, name)
    ENDWHILE
  ELSE
    WriteF('No node with name \s found.\n', name)
  ENDIF
ENDPROC
