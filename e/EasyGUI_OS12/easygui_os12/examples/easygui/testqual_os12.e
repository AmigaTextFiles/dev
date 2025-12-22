
OPT PREPROCESS

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  MODULE 'tools/easygui_os12'
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui'
#endif

MODULE 'devices/inputevent'

PROC main()
  easyguiA('Qualifier Test',
          [SBUTTON,{buttonaction},'Press Me! (With/Without Shift)'])
ENDPROC

PROC buttonaction(qual,data,info)
  IF qual AND (IEQUALIFIER_LSHIFT OR IEQUALIFIER_RSHIFT)
    WriteF('You were pressing a shift key when you clicked on me!\n')
  ELSE
    WriteF('Nope, no shift key this time...\n')
  ENDIF
ENDPROC
