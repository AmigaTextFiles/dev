-> This one shows the use of multi-window GUIs with PLUGINs.  A ticker is
-> used, so the counting stops when none of the windows in the group is
-> active!
MODULE 'tools/easygui', 'tools/exceptions',
       'graphics/text', 'intuition/intuition',
       'plugins/led', 'plugins/ticker'

-> Global for multiforall().
DEF gh:PTR TO guihandle

CONST NUM_VALUES=2

-> Store all the GUI data in one place.
OBJECT mygui
  -> In particular, keep PLUGIN references here.
  ledplug:PTR TO led
  ticker:PTR TO ticker
  gh:PTR TO guihandle
  gui
  title
  going
  values[NUM_VALUES]:ARRAY OF INT
ENDOBJECT

-> The main loop: create one window to start with.
PROC main() HANDLE
  DEF mh=NIL
  mh:=multiinit()
  create(mh)
  multiloop(mh)
EXCEPT DO
  cleanmulti(mh)
  report_exception()
ENDPROC

-> Create a new GUI.
PROC create(mh) HANDLE
  DEF t, g, gui=NIL:PTR TO mygui
  NEW gui
  -> Allocate all PLUGINs for the GUI like this.
  NEW gui.ledplug.led(NUM_VALUES,gui.values,TRUE)
  NEW gui.ticker
  -> Now we can try opening a GUI.
  gui.gh:=addmultiA(mh,'BOOPSI in EasyGUI!',
                   g:=NEW [ROWS,
                     t:=NEW [TEXT,'LED Boopsi image tester...',NIL,TRUE,16],
                     NEW [PLUGIN,{tick},gui.ticker],
                     NEW [COLS,
                        NEW [EQROWS,
                          NEW [BUTTON,{runaction},'Run/Stop'],
                          NEW [BUTTON,{spawn},'Spawn'],
                          NEW [BUTTON,0,'Quit']
                        ],
                        NEW [PLUGIN,0,gui.ledplug]
                     ]
                   ],
                   [EG_INFO,gui, EG_LEFT,Rnd(400), EG_TOP,Rnd(400),
                    -> The cleanup routine will deallocate the PLUGINs used.
                    EG_CLEAN,{cleanmygui}, EG_CLOSE,{close}, NIL])
  gui.gui:=g
  gui.title:=t
EXCEPT
  -> If there was any problem then it may have been the creation of PLUGINs
  -> or addmultiA().  Luckily, addmultiA() (and guiinitA()) will *not* call
  -> the EG_CLEAN function if they caused the problem, so we can (safely).
  cleanmygui(gui)
  ReThrow()
ENDPROC

-> The custom clean up code for each GUI.
PROC cleanmygui(gui:PTR TO mygui)
  IF gui
    disposegui(gui.gui)
    END gui.ticker
    END gui.ledplug
    END gui
  ENDIF
ENDPROC

-> The action function creates a new GUI in the group.
PROC spawn(info:PTR TO mygui) IS create(info.gh.mh)

-> The run/stop action.
PROC runaction(info:PTR TO mygui)
  IF info.going
    -> Going, so stop.
    info.going:=FALSE
    settext(info.gh,info.title,'You stopped me!')
  ELSE
    -> Stopped, so go.
    info.going:=TRUE
    settext(info.gh,info.title,'Started counting...')
    Delay(10)
    settext(info.gh,info.title,'Counting...')
  ENDIF
ENDPROC

-> Tick!
PROC tick(info:PTR TO mygui,t)
  -> Go to next count for all open windows.
  multiforall({gh},info.gh.mh,`IF gh.wnd THEN next(gh.info) ELSE 0)
ENDPROC

-> Next count.
PROC next(info:PTR TO mygui)
  DEF l:PTR TO led,h,m
  IF info.going
    l:=info.ledplug
    l.colon:=(l.colon=FALSE)
    m:=info.values[1]+1
    IF m=60
      m:=0
      h:=info.values[]+1
      IF h=13
        h:=0
        info.going:=FALSE
        settext(info.gh,info.title,'Finished!')
      ENDIF
      l.values[]:=h
    ENDIF
    l.values[1]:=m
    l.redisplay()
  ENDIF
ENDPROC

-> Close function.
PROC close(info:PTR TO mygui) IS cleangui(info.gh)
