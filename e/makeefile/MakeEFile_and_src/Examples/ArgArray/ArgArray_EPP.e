/*
 * ArgArray_EPP.e
 *
 * Test pour module EPP argarray.e
 *
 */

PMODULE 'PMODULES:User/argarray'
MODULE	'icon'

PROC main() HANDLE
  DEF ttypes:PTR TO LONG, i=0,name,numb
  iconbase:=NIL
  IF (iconbase:=OpenLibrary('icon.library',39))=NIL THEN Raise("ICON")
  IF _astartup()<>NIL THEN Raise("STRT")	/* erreur -> _exit(20) */
  ttypes:=_argarrayinit(_argc,_argv)		/* do not Raise() if none */

  /*IF _argc=0 /* wb */
    WHILE ttypes[i]<>NIL DO WriteF('tooltype[\d]=\s\n',i,ttypes[i++])
  ELSE
    WHILE ttypes[i]<>NIL DO WriteF('DOS arg[\d]=\s\n',i,ttypes[i++])
  ENDIF*/
  name:=_argstring(ttypes,'NAME','<nom>')
  numb:=_argint(ttypes,'NUMBER',"FRAN")
  WriteF('name=\s\n',name)
  WriteF('number=0x\h\n',numb)

  Raise(NIL)	/* Close All */
  EXCEPT
  _argarraydone()
  IF (iconbase<>NIL); CloseLibrary(iconbase); iconbase:=NIL; ENDIF
  IF exception=NIL THEN _exit(0) ELSE _exit(20)
ENDPROC
