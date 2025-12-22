DEF	text[32]:STRING

PROC main()

	// ukazka A
	PrintF('napis nejaky text, a ja ho napisu 2x\n')
	ReadEStr(stdin,text)
	PrintF('poprve:  "\s"\npodruhe: "\s"\n',text,text)

	// ukazka B
	WriteF('napis nejaky text: ')
	ReadEStr(stdin,text)
	PrintF('napsal jsi: "\s"\n',text)

	// ukazka C
	PrintF('napis nejaky text: MarK je nejlepsi!\b')
	WriteF('napis nejaky text: ')
	ReadEStr(stdin,text)
	IF StrLen(text)=0 THEN StrCopy(text,'MarK je nejlepsi!')
	PrintF('napsal jsi: "\s"\n',text)
ENDPROC

