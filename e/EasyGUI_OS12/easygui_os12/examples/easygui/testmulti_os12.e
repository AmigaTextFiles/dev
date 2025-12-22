-> testmulti.e - Simple (recursive) use of multi-window GUI support.
-> (Note: Intuition gets a bit weird with lots of windows -- lockups or
-> crashes with huge numbers of windows are not EasyGUI's fault...)

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

MODULE 'tools/exceptions'

RAISE "MEM" IF String()=NIL

DEF guis=1

PROC main() HANDLE
  DEF mh=NIL
  mh:=multiinit()
  -> Start at level 0.
  create(mh,0)
  multiloop(mh)
EXCEPT DO
  cleanmulti(mh)
  report_exception()
ENDPROC

-> Add a new window to the group mh at level i.
PROC add(level,gh:PTR TO guihandle) IS create(gh.mh,level)

-> Add a new window to the group mh at level i.
PROC create(mh,level)
  DEF s
  -> Next level.
  INC level
  s:=StringF(String(10),'GUI \d',guis)
  -> Got to NEW the gui since the same one is being used multiple times.
  addmultiA(mh, s,
            NEW [ROWS,
              NEW [TEXT,'Multi GUI Test',NIL,TRUE,10],
              NEW [COLS,
                NEW [NUM,level,'Level:',0,1],
                NEW [NUM,guis,'GUI:',0,1]
                  ],
              NEW [COLS,
                    -> Recursive call to create() via add()!
                NEW [BUTTON,{add},'_Add',level,"a"],
                NEW [SPACE],
                    -> Pressing the Quit button quits multiloop() and so
                    -> then all windows are closed.
                NEW [BUTTON,0,'_Quit',0,"q"]
                  ]
                ],
            -> Open at a random position, with level as info.
            [EG_LEFT,Rnd(400), EG_TOP,Rnd(400), EG_CLOSE,{close}, NIL])
  -> Now another GUI.
  INC guis
ENDPROC

-> This function is called when the GUI close gadget is hit.
-> (Hitting the close gadget closes only that window, unless it is the last.)
PROC close(mh:PTR TO multihandle,info)
  WriteF('GUIs left with open windows = \d\n',mh.opencount)
  -> Is this the last open window?
  IF mh.opencount=1 THEN quitgui(0) ELSE closewin(info)
ENDPROC
