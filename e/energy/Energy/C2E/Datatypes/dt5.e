->dt5

OPT OSVERSION=37

MODULE 'datatypes/datatypes','datatypes',
	'datatypes/datatypesclass',
	'utility/tagitem','dos/dos',
	'dos/stdio'

PROC main()

  DEF myargs:PTR TO LONG,rdargs,dto,r=-1,fh:PTR TO CHAR
 
  myargs:=[0,0]
  IF rdargs:=ReadArgs('OLDFILE/A,NEWFILE/A',myargs,NIL)
 IF (datatypesbase:=OpenLibrary('datatypes.library',0))
	IF (dto:=NewDTObjectA(myargs[0],TAG_DONE))
	
		IF (fh:=Open(myargs[1],MODE_NEWFILE))
			r:=DoDTMethodA(dto,NIL,NIL,[DTM_WRITE,NIL,fh,DTWM_IFF,NIL])
			 Close(fh)
		ENDIF
		PrintF('Risultati: \d\n',r)
		DisposeDTObject(dto)
	ENDIF
    FreeArgs(rdargs)
	CloseLibrary(datatypesbase)
ENDIF
  ELSE
    PrintF('Bad Args! USE OLDFILE/A,NEWFILE/A \n')
  ENDIF
ENDPROC
