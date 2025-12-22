-> Datatype by Marco Talamelli 2-4-95

MODULE 'datatypes','datatypes/datatypes','datatypes/datatypesclass','dos/dos'

DEF 	lock:PTR TO CHAR,
	dth:PTR TO datatypeheader,
	dtn:PTR TO datatype,
	tdesc,
	gdesc,
	ttype:PTR TO INT,id

PROC main()

IF (lock:=Lock(arg,ACCESS_READ))
	IF (datatypesbase:=OpenLibrary('datatypes.library',0))
		IF (dtn:=ObtainDataTypeA(DTST_FILE,lock,NIL))
dth:=dtn.header
ttype:=dth.flags AND DTF_TYPE_MASK
tdesc:=GetDTString(ttype+DTMSG_TYPE_OFFSET)
gdesc:=GetDTString(dth.groupid)
id:=[dth.id]
WriteF('	       File:\s\n',arg)
WriteF('	Descrizione:\s\n',dth.name)
WriteF('	   Basename:\s\n',dth.basename)
WriteF('	       Tipo:\d - \s\n',ttype,tdesc)
WriteF('	     Gruppo:\s\n',gdesc)
WriteF('		 ID:\c\c\c\c',id[0],id[1],id[2],id[3])
WriteF('\n')
ReleaseDataType(dtn)
ENDIF
CloseLibrary(datatypesbase)
ENDIF
UnLock(lock)
ENDIF
RETURN
ENDPROC
