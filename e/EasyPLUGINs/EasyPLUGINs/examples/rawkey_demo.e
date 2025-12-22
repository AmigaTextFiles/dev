/*

  $VER: RawKey Demo V1.00 - By Fabio Rotondo

        Part of the EasyPLUGINs package

  V1.00 - Inital Release


*/

OPT OSVERSION=37

MODULE 'tools/EasyGUI', 'tools/exceptions',
       'easyplugins/rawkey'

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

