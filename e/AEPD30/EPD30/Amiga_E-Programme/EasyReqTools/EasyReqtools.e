/*	E-MODULE für Reqtools-Requester

	exception		exceptioninfo
	-----------------------------
		"MEM"		FOR_REQWINDOW
*/


OPT MODULE


MODULE 'reqtools','libraries/reqtools','exec/memory','graphics/text',
	   'utility/tagitem','intuition/intuition'



EXPORT ENUM FOR_REQWINDOW=1

DEF	reqtattr

EXPORT PROC openReqTools()
	DEF att:PTR TO textattr

	reqtattr:=['topaz.font',8,0,0]:textattr
	att:=reqtattr

	IF (reqtoolsbase:=OpenLibrary('reqtools.library',38))=NIL
		AutoRequest(getProcWindow(),
			[0,1,0,10,att.ysize+2,att,'Benötige Reqtools.library V38+',
			[0,1,0,10,(att.ysize+2)*2,att,'im Verzeichnis "libs:" !',NIL]:intuitext]:intuitext,
			[2,1,0,6,3,att,'OK',NIL]:intuitext,
			[2,1,0,6,3,att,'OK',NIL]:intuitext,
			0,0,320,70)

		RETURN FALSE
	ENDIF
ENDPROC TRUE


EXPORT PROC closeReqTools()
	IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
ENDPROC


EXPORT PROC request(body,gad=NIL,args=NIL,title=NIL,alttattr=NIL)
	DEF result

	IF AvailMem(MEMF_CHIP)<50 THEN Throw("MEM",FOR_REQWINDOW)

	result:=RtEZRequestA(body,IF gad=NIL THEN 'OK' ELSE gad,NIL,args,
			[RT_UNDERSCORE,"_",
			RT_REQPOS,REQPOS_POINTER,
			RT_TEXTATTR,IF alttattr=NIL THEN reqtattr ELSE alttattr,
			RTEZ_FLAGS,EZREQF_CENTERTEXT,
			RTEZ_REQTITLE,IF title=NIL THEN 'Information' ELSE title,
			TAG_DONE])
ENDPROC result


EXPORT PROC getProcWindow()			
	DEF process:REG,processwindow

	process:=FindTask(0)
	MOVE.L	process,A0
	MOVE.L	184(A0),processwindow
ENDPROC processwindow 			-> Fenster, in dem Requester erscheinen


EXPORT PROC setProcWindow(newwindow)	-> anderes Fenster setzen
	DEF process:REG,save

	save:=getProcWindow()

	process:=FindTask(0)
	MOVE.L	process,A0
	MOVE.L	newwindow,184(A0)
ENDPROC save					-> altes Fenster zurück
