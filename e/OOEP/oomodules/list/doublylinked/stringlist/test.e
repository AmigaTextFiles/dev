MODULE 'oomodules/list/doublylinked/stringlist'

PROC main()
DEF stringList:PTR TO stringList,
    sortedList,
    index


  NEW stringList.new()


  stringList.fromList(['fire','walk','with','me'])
  sortedList := stringList.asList()


  FOR index := 0 TO ListLen(sortedList)-1

    WriteF('\s\n', ListItem(sortedList,index))

  ENDFOR


  Dispose(sortedList)

ENDPROC
