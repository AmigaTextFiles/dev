OPT PREPROCESS

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  MODULE 'tools/easygui_os12', 'plugins/ticker_os12'
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui', 'plugins/ticker'
#endif

MODULE 'tools/exceptions'

PROC main() HANDLE
  DEF t=NIL:PTR TO ticker
  NEW t
  easyguiA('Ticker!',
    [ROWS,
      [TEXT,'Ticker test:',NIL,TRUE,10],
      [PLUGIN,{tickaction},t]
    ])
EXCEPT DO
  END t
  report_exception()
ENDPROC

PROC tickaction(i,t)
  WriteF('Tick!\n')
ENDPROC
