/*

  $VER: RawKey Demo V1.00 - By Fabio Rotondo

        Part of the EasyPLUGINs package

  V1.00 - Inital Release


*/

OPT PREPROCESS

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  MODULE 'tools/easygui_os12', 'easyplugins/rawkey_os12'
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui', 'easyplugins/rawkey'
#endif

MODULE 'tools/exceptions'

PROC main() HANDLE
  DEF n=NIL:PTR TO rawkey

  NEW n.init()

  n.setattrs([PLA_KEY_UP, {up}, PLA_KEY_CONTROL, {control}, NIL, NIL])

  easyguiA('Test RawKey', [ROWS,
                            [TEXT, 'Press Cursor Up OR CTRL keys', NIL, TRUE, 10],
                            [SBUTTON,1, 'Quit!'],
                            [PLUGIN, 0, n]
                          ]
          )

EXCEPT DO
  report_exception()
  END n
ENDPROC

PROC up() IS WriteF('You pressed Cursor Up!\n')

PROC control() IS WriteF('You Pressed Control Key!!\n')

