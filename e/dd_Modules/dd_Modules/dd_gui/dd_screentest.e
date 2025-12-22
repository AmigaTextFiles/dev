MODULE 'dd_gui/dd_screen'
MODULE 'gadtools'

PROC main()
  DEF screen:PTR TO dd_screen
  IF gadtoolsbase:=OpenLibrary('gadtools.library',37)
    NEW screen.clonepubscreen('GOLDED.1','Title')
    Delay(250)
    END screen
    CloseLibrary(gadtoolsbase)
    gadtoolsbase:=0
  ENDIF
ENDPROC
