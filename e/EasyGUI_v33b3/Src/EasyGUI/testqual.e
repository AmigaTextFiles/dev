MODULE 'tools/easygui', 'devices/inputevent'

PROC main()
  easyguiA('Qualifier Test',
          [SBUTTON,{buttonaction},'Press Me! (With/Without Shift)'])
ENDPROC

PROC buttonaction(qual,data,info)
  IF qual AND (IEQUALIFIER_LSHIFT OR IEQUALIFIER_RSHIFT)
    PrintF('You were pressing a shift key when you clicked on me!\n')
  ELSE
    PrintF('Nope, no shift key this time...\n')
  ENDIF
ENDPROC
