-> This one shows the use of multi-window GUIs with PLUGINs, and multiple,
-> pseudo-asynchronous activities.
MODULE 'tools/easygui', 'tools/exceptions',
       'graphics/text', 'intuition/intuition',
       'plugins/led'

-> Global for multiforall().
DEF gh:PTR TO guihandle

-> Number of GUIs counting.
DEF counting=0

CONST NUM_VALUES=2

-> Store all the GUI data in one place.
OBJECT mygui
  -> In particular, keep PLUGIN references here.
  ledplug:PTR TO led
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
  -> Now we can try opening a GUI.
  gui.gh:=addmultiA(mh,'BOOPSI in EasyGUI!',
                   g:=NEW [ROWS,
                     t:=NEW [TEXT,'LED Boopsi image tester...',NIL,TRUE,16],
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
    END gui.ledplug
    END gui
  ENDIF
ENDPROC

-> The action function creates a new GUI in the group.
PROC spawn(info:PTR TO mygui) IS create(info.gh.mh)

-> The run/stop action.
PROC runaction(info:PTR TO mygui)
  IF info.going
    settext(info.gh,info.title,'You stopped me!')
    stop(info)
  ELSE
    settext(info.gh,info.title,'Started counting...')
    Delay(10)
    settext(info.gh,info.title,'Counting...')
    run(info)
  ENDIF
ENDPROC

PROC stop(info:PTR TO mygui)
  -> Going, so stop.
  info.going:=FALSE
  -> One less is counting.
  DEC counting
ENDPROC

PROC run(info:PTR TO mygui)
  DEF mh
  -> Stopped, so go.
  info.going:=TRUE
  -> One more counting.
  INC counting
  -> We're the first so we're the loop.
  IF counting=1
    mh:=info.gh.mh
    -> While there is someone counting
    WHILE counting
      -> Tick each GUI that's going.
      multiforall({gh},mh,`next(gh.info))
      checkmulti(mh)
      Delay(10)
    ENDWHILE
  ENDIF
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
        DEC counting
        settext(info.gh,info.title,'Finished!')
      ENDIF
      l.values[]:=h
    ENDIF
    l.values[1]:=m
    l.redisplay()
  ENDIF
ENDPROC

-> Close function.
PROC close(info:PTR TO mygui)
  -> Stop if running.
  IF info.going THEN stop(info)
  -> Destroy window.
  cleangui(info.gh)
ENDPROC
