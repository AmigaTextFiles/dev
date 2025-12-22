OPT NATIVE, FORCENATIVE, POINTER
MODULE 'target/wb'

DEF wbmessage=NIL:PTR TO wbstartup

PROC new()
	IF PrivateGetMainArgc() = 0
		wbmessage := PrivateGetMainArgv() !!VALUE!!PTR TO wbstartup
	ENDIF
ENDPROC
