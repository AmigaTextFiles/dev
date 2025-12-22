MODULE 'tools/easygui', 'tools/exceptions',
       'plugins/ticker'

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
