MODULE  'oomodules/file/textfile/programsource/esource',
        'oomodules/sort/string'

PROC main()
DEF eSource:PTR TO eSource,
    string:PTR TO string

  NEW string.new()
  NEW eSource.new()

  eSource.suck('ram:textfile')
  eSource.getInfo()
  eSource.getModules()

  eSource.getAutodocString(string)

  WriteF('\s\n', string.write())

ENDPROC
