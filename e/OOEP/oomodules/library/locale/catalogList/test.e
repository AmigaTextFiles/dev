MODULE  'oomodules/library/locale/catalogList'

PROC main()
DEF cl:PTR TO catalogList, index

 /*
  * Open the term catalog with builtin language english
  */

  NEW cl.new(["ctlg", 'term.catalog', "ctlg", 'oomodules/object.catalog'])

->  WriteF('number of catalogs open: \d\n', cl.length())

  cl.setCurrentCatalog(NIL,'term.catalog')
  IF cl.catalog

    WriteF('\s\n\s\n\s\n', cl.getString(1,'bla'),
      cl.getString(2,'bla'),
      cl.getString(3,'bla'))

  ENDIF

->  WriteF('number of catalogs open: \d\n', cl.length())

  cl.setCurrentCatalog(NIL,'oomodules/object.catalog')
  IF cl.catalog

    WriteF('\s\n\s\n\s\n', cl.getString(1,'bla'),
      cl.getString(2,'bla'),
      cl.getString(3,'bla'))

  ENDIF

->  WriteF('number of catalogs open: \d\n', cl.length())

  cl.setCurrentCatalog(NIL,'term.catalog')
  IF cl.catalog

    WriteF('\s\n\s\n\s\n', cl.getString(1,'bla'),
      cl.getString(2,'bla'),
      cl.getString(3,'bla'))

  ENDIF


->  FOR index:=0 TO cl.length()-1
->
->    cl.write(index)
->
->  ENDFOR

ENDPROC
