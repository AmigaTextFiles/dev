OPT INLINE
MODULE 'muimaster', 'exec/libraries', 'exec/types', 'intuition/classes'

PROC eMui_CreateCustomClass(base:PTR TO lib, supername:ARRAY OF CHAR, supermcc:PTR TO mui_customclass, datasize:VALUE, dispfunc:PTR) RETURNS mcc:PTR TO mui_customclass
	DEF iclass:PTR TO iclass, data:PTR TO data
	
	NEW data
	
	mcc := Mui_CreateCustomClass(base, supername, supermcc, datasize, dispfunc)
	IF mcc = NIL THEN RETURN
	
	iclass := mcc.mcc_class
	iclass.userdata := PASS data
FINALLY
	END data
	/*IF exception
		exception := 0
		mcc := NIL
	ENDIF*/
ENDPROC

PRIVATE
OBJECT data
	user:LONG         -> for userdata (use iclass.userdata[] instead of iclass.userdata)
ENDOBJECT
PUBLIC
