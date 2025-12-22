// simple asl.library example

OPT	DOSONLY

MODULE	'libraries/asl',
			'asl'

DEF	ASLBase

PROC main()
	DEF	req:PTR TO FileRequester,name[256]:CHAR
	IF ASLBase:=OpenLibrary('asl.library',37)
		IF req:=AllocFileRequest()
			IF RequestFile(req)
				StrCopy(name,req.Drawer)
				AddPart(name,req.File,256)
				PrintF('You entered: \s\n',name)
				FreeFileRequest(req)
			ENDIF
		ENDIF
		CloseLibrary(ASLBase)
	ENDIF
ENDPROC

