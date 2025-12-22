/*
    MGUI Example

    Simple Example

    (C)Copyright 1996/97 Amiga Foundation Classes

    See: http://www.intercom.it/~fsoft/afc.html

         FOR more info about AFC AND more modules

*/

OPT OSVERSION=37

MODULE 'afc/mgui_oo',
       'tools/easygui'

PROC main() HANDLE
  DEF mg=NIL:PTR TO mgui

  NEW mg.mgui()

  mg.add('MGUI Main', [ROWS,
                            [SBUTTON, {kill_all}, 'Kill ALL'],
                            [SBUTTON, {msg}, 'Msg'],
                            [SBUTTON, {newgui}, 'NEW GUI!']
                         ], mg)

  mg.setattrs(NEW [MGUI_MAIN, TRUE,0,0])

  test(mg)

  test(mg)

  test(mg)


  WHILE (mg.empty() = FALSE)
    mg.message()
  ENDWHILE

EXCEPT DO
  IF exception THEN WriteF('Exception:\z\h[8]\n', exception)
  END mg
  CleanUp(0)
ENDPROC

PROC newgui(mg:PTR TO mgui) IS test(mg)


PROC kill_all(mg:PTR TO mgui) IS mg.clear()

PROC msg() IS WriteF('Message!\n')

PROC test(mg:PTR TO mgui)
  DEF gui:PTR TO LONG

  gui:=NEW [ROWS,
       NEW   [SBUTTON, {msg}, 'Msg']
           ]

  mg.add('NEW Window', gui)
ENDPROC

