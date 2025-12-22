MODULE  'oomodules/library/locale'

PROC main()
DEF locale:PTR TO locale

 /*
  * Open the term catalog with builtin language english
  */

  NEW locale.new(["ctlg", 'term.catalog'])

  IF locale.catalog

    WriteF('\s\n\s\n\s\n', locale.getString(1,'bla'),
      locale.getString(2,'bla'),
      locale.getString(3,'bla'))

  ENDIF

ENDPROC
