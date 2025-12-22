OPT PREPROCESS

MODULE  'oomodules/object'

PROC main()
DEF o:PTR TO object


#ifdef LOCALE_SUPPORT

  WriteF('locale support is ')
  WriteF('enabled.\n')

#endif

  NEW o.new()

  o.derivedClassResponse()

  END o

ENDPROC
