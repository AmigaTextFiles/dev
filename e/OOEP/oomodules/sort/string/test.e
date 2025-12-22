MODULE  'oomodules/sort/string'

PROC main()
DEF string:PTR TO string

  NEW string.new()

  string.cat('blue')
  string.cat(' in the ')
  string.cat('face.')

  WriteF('\s\n', string.write())

  string.set(' hi there.\n')

  WriteF('\s\n', string.write())


  END string

ENDPROC
