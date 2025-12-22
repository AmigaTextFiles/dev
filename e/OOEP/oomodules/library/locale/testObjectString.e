MODULE  'oomodules/library/locale',
        'oomodules/object',
        'oomodules/sort/string'

PROC main()
DEF locale:PTR TO locale,
    object:PTR TO object,
    string:PTR TO string

  NEW string.new()

  NEW object.new()

 /*
  * Open the term catalog with builtin language english
  */

  NEW locale.new(["ctlg", 'term.catalog'])

  IF locale.catalog

    WriteF('Here are some strings from term\as catalog:\n\n')
    WriteF('\s\n\s\n\s\n', locale.getString(1,'bla'),
      locale.getString(2,'bla'),
      locale.getString(3,'bla'))
  ELSE

    RETURN

  ENDIF

  WriteF('\n\n')
  WriteF('Now you\all get a string from the object\as catalog:\n\n')
 /*
  * Get a string from the object's catalog
  */

  locale.getObjectString(object,string, 1,'bla')
  WriteF('\s\n', string.write())

  WriteF('\n\n')
  WriteF('Here are some strings from term\as catalog again:\n\n')
  WriteF('\s\n\s\n\s\n', locale.getString(1,'bla'),
    locale.getString(2,'bla'),
    locale.getString(3,'bla'))

ENDPROC
