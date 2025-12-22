MODULE 'openurl', 'libraries/openurl', 'utility/tagitem'

PROC main()

IF arg[]<1
  WriteF('not enough arguments\n')
  RETURN
ENDIF

WriteF('\s\n',arg)

IF openurlbase:=OpenLibrary('openurl.library',0)

  use_url()
  
  CloseLibrary(openurlbase)
ELSE
  WriteF('couldnt open library\n')
ENDIF

ENDPROC

PROC use_url()
  UrL_OpenA(arg,[URL_Launch,1,URL_Show,1]:tagitem)
ENDPROC

