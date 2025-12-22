/*
    MGUI Example

    MGUI_ADDEXTERNAL tag example

    (C)Copyright 1996/97 Amiga Foundation Classes

    See: http://www.intercom.it/~fsoft/afc.html

         FOR more info about AFC AND more modules

*/

OPT OSVERSION=37

MODULE 'afc/mgui_oo',
       'exec/ports',
       'intuition/intuition',
       'tools/easygui'

DEF times=0

PROC main() HANDLE
  DEF mg=NIL:PTR TO mgui
  DEF win=NIL:PTR TO window
  DEF sig

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

  IF (win:=OpenWindowTagList(NIL, [WA_WIDTH, 200,
                               WA_HEIGHT, 100,
                               WA_TITLE, 'Click Inside!',
                               WA_IDCMP, IDCMP_MOUSEBUTTONS,
                               NIL, NIL]))=NIL THEN Raise("win")

  sig:=win.userport::mp.sigbit
  sig:=Shl(1, sig)

  mg.setattrs([MGUI_ADDEXTERNAL, [{click}, sig, [win, win.userport, mg, sig, {win}]],
             0,0])

  WHILE (mg.empty() = FALSE)
    mg.message()
  ENDWHILE

EXCEPT DO
  IF exception THEN WriteF('Exception:\z\h[8]\n', exception)
  END mg
  IF win THEN CloseWindow(win)
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

PROC click(t:PTR TO LONG)
  DEF x:PTR TO LONG

  x:=GetMsg(t[1])
  ReplyMsg(x)
  WriteF('Win Clicked: \d Times!\n', times++)
ENDPROC

