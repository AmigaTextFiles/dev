MODULE '*datestring', 'dos/datetime'

PROC main()
  DEF d:PTR TO datestring

  NEW d.new()
  WriteF('\s \s \s\n', d.day, d.date, d.time)
  END d

  Delay(50)

  NEW d.new(FORMAT_INT)
  WriteF('\s \s \s\n', d.day, d.date, d.time)
  END d

  Delay(50)

  NEW d.new(FORMAT_USA)
  WriteF('\s \s \s\n', d.day, d.date, d.time)
  END d

  Delay(50)

  NEW d.new(FORMAT_CDN)
  WriteF('\s \s \s\n', d.day, d.date, d.time)
  END d

ENDPROC
