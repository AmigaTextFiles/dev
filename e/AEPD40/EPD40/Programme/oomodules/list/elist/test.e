MODULE  'oomodules/list/elist'

PROC main()
DEF l:PTR TO elist,
    index, ll

  NEW l.new()

  WriteF('list at \d\n', l.list)
  WriteF('hunk size is \d\n', l.hunkSize)

  ll := l.list

  WriteF('list size is \d\n', ListLen(ll))
  WriteF('count is \d\n', l.itemCount)

  FOR index := 0 TO 20
    l.add(index)
  ENDFOR

  l.putAt(26,24)

  FOR index := 1 TO 24
    WriteF('\d\n', l.getFrom(index))
  ENDFOR

  END l

ENDPROC
