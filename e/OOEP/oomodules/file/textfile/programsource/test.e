MODULE 'oomodules/file/textfile/programSource'

PROC main()
DEF source:PTR TO programSource,
		start,end

  NEW source.new(["suck", 'ram:textfile'])

  start,end := source.findBlock('PROC', 'ENDPROC')
	WriteF('PROC found from \d to \d.\n', start, end)

  start,end := source.findBlock('PROC', 'ENDPROC',end)
	WriteF('PROC found from \d to \d.\n', start, end)

  start,end := source.findBlock('PROC', 'ENDPROC',end)
	WriteF('PROC found from \d to \d.\n', start, end)

  start,end := source.findBlock('PROC', 'ENDPROC',end)
	WriteF('PROC found from \d to \d.\n', start, end)

ENDPROC
