MODULE 'amigalib/lists',
       'shark/ShkLn',
       'exec/nodes',
       'exec/lists'

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

