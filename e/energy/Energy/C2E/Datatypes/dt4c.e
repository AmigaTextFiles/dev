-> DT4C batatypes by M. Talamelli


MODULE 'datatypes/datatypes','datatypes',
	'datatypes/datatypesclass',
	'utility/tagitem',
	'dos/stdio'

DEF dto

PROC main()

	IF (datatypesbase:=OpenLibrary('datatypes.library',0))
		IF (dto:=NewDTObjectA(arg,TAG_DONE))
			doquery(arg)
			DisposeDTObject(dto)
		ENDIF
		CloseLibrary(datatypesbase)
	ENDIF
ENDPROC


PROC doquery(nome:PTR TO CHAR)

DEF n,m:PTR TO dtmethod

PrintF('Metodi disponibili per \s.\n',nome)

PrintF('\nMetodi:\n')
  IF (GetDTAttrsA(dto,[DTA_METHODS,{n},TAG_DONE]))

	WHILE (^n<>-1)
			PrintF('\z\h[8]        ',^n++)
	ENDWHILE

		PrintF('\nMetodi Trigger:\n')
    IF (GetDTAttrsA(dto,[DTA_TRIGGERMETHODS,{m},TAG_DONE]))
	IF (m)
	   WHILE (m.label)
			PrintF('Label \s Command \s Method \z\h[8]\n',
			m.label,m.command,m.method)
			m++
	   ENDWHILE
	ENDIF
    
			PrintF('Nessuno.\n')
    ENDIF
ENDIF
ENDPROC
