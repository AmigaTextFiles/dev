OPT PREPROCESS

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  MODULE 'tools/easygui_os12','plugins/windowify_os12'
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui',  'plugins/windowify'
#endif

MODULE 'tools/exceptions'

PROC main() HANDLE
  DEF p=NIL:PTR TO windowify
  NEW p.windowify('Windowify','Hello from Windowify',TRUE)
  easyguiA('GadTools in EasyGUI!',
    [ROWS,
      [TEXT,'Windowify test...',NIL,TRUE,1],
      [SPACE],
      [PLUGIN,0,p,TRUE],
      [SPACE],
      [BUTTON,{toggle_enabled},'Toggle Enabled',p]
    ])
EXCEPT DO
  END p
  report_exception()
ENDPROC

PROC toggle_enabled(p:PTR TO windowify,i)
  p.setdisabled(p.disabled=FALSE)
ENDPROC
