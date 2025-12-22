MODULE  'oomodules/list/doublylinked/stringlist',
        'oomodules/list/execList',
        'oomodules/list/eList',
        'exec/lists',
        'exec/nodes'



PROC main()
DEF stringList:PTR TO stringList,
    sortedList,
    index,
    execlist:PTR TO execlist,
    elist:PTR TO elist


  NEW stringList.new()

  stringList.fromList(['fire','walk','with','me'])

  NEW elist.new()

  elist.set(stringList.asList())
  NEW execlist.new(["list", elist.list])

  dumpExeclist(execlist.list)

ENDPROC

PROC dumpExeclist(list:PTR TO lh)
DEF node:PTR TO ln,
    nextnode:PTR TO ln

  node := list.head

  WHILE node.succ

    WriteF('\s\n', node.name)

    nextnode := node.succ

    node := nextnode

  ENDWHILE

ENDPROC
