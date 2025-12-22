MODULE  'oomodules/list/elist'

PROC main()
DEF l:PTR TO elist,
    index


  NEW l.new()

  WriteF('Created an elist; ')
  WriteF('list at \d, ', l.list)
  WriteF('hunk size is \d\n', l.hunkSize)

  WriteF('list size is \d\n', ListLen(l.list))
  WriteF('count is \d\n', l.itemCount)

  WriteF('\nAdding twenty items.\n')
  FOR index := 0 TO 20
    l.add(index)
  ENDFOR

  WriteF('list size is \d\n', ListLen(l.list))

  WriteF('\nPut 26 at slot 24.\n')
  l.putAt(26,24)
  WriteF('count is \d\n', l.itemCount)
  l.setNextFreeSlotAt(25)
  WriteF('count is \d\n', l.itemCount)

  WriteF('list size is \d\n', ListLen(l.list))

  WriteF('\nDump all items.\n')
  FOR index := 0 TO l.itemCount-1
    WriteF('\d\n', l.getFrom(index))
  ENDFOR

  WriteF('\nRemove items 10 and 19.\n')
  l.remove(10)
  l.remove(19)

  WriteF('list size is \d\n', ListLen(l.list))
  WriteF('count is \d\n', l.itemCount)

  WriteF('\nDump all items.\n')
  FOR index := 0 TO l.itemCount-1
    WriteF('\d\n', l.getFrom(index))
  ENDFOR

  END l

ENDPROC
