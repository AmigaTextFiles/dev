MODULE '*StringEdit'

PROC main()
	DEF str:STRING, list:LIST, i, len
	Print('"\s"\n', str := makeBin(%10101, -1, TRUE)) ; END str
	Print('"\s"\n', str := makeBin(%10101,  9, TRUE)) ; END str
	Print('"\s"\n', str := makeBin(%10101,  9, FALSE)) ; END str
	
	list := splitStr('cool 2 "Here I come!"', 6)
	len := ListLen(list)
	FOR i := 0 TO len-1 DO Print('Word \d = "\s"\n', i+1, list[i])
FINALLY
	PrintException()
ENDPROC
