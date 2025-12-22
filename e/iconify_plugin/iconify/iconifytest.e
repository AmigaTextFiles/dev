OPT OSVERSION=37
OPT REG=5


MODULE 'tools/Easygui'
MODULE 'intuition/intuition'
MODULE 'easygui/plugins/iconify','tools/exceptions'


/*
 * File:         iconifytest.e
 * Description:  window iconify button plugin test
 *
 * © 1998, Piotr Gapiïski
 *
 */


PROC main() HANDLE
  DEF ig:PTR TO iconify

  easyguiA('akt3',
    [ROWS,
      [COLS,
        [SBUTTON,{dummy},'(0)',NIL],
        [BUTTON,{dummy}, '(1)',NIL],
        [BUTTON,{dummy}, '(2)',NIL],
        [SBUTTON,{dummy},'(3)',NIL]
      ],
      [PLUGIN,NIL,NEW ig.create('TEST')]
    ])
EXCEPT DO
  report_exception()
  END ig
ENDPROC
PROC dummy(a1=NIL, a2=NIL, a3=NIL) IS NIL
