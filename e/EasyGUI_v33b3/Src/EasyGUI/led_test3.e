-> This one shows the use of multi-window GUIs with PLUGINs, and multiple,
-> real asynchronous activities (by creating tasks).
MODULE 'tools/easygui', 'tools/exceptions',
       'graphics/text', 'intuition/intuition',
       'plugins/led',
       'amigalib/tasks', 'amigalib/time', 'other/ecode',
       'devices/timer', 'exec/tasks'

-> Global for multiexists().
DEF gh:PTR TO guihandle

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
  task
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
                          NEW [BUTTON,{quit},'Quit']
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

PROC quit(info) IS quitgui(0)

-> The custom clean up code for each GUI.
PROC cleanmygui(gui:PTR TO mygui)
  IF gui
    -> Stop and destroy task, if necessary.
    stop(gui)
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
  -> Temporarily make it high priority to die quicker.
  Forbid()
  IF info.task THEN SetTaskPri(info.task,5)
  Permit()
  -> Wait for task to die.
  WHILE info.task DO Delay(1)
ENDPROC

PROC run(info:PTR TO mygui)
  DEF taskcode
  IF info.task=NIL
    IF taskcode:=eCodeTask({taskloop})
      -> Make new Counter task, low priority.
      info.task:=createTask('Counter',-5,taskcode,1000,info)
    ENDIF
  ENDIF
ENDPROC

-> The loop the task will execute.
PROC taskloop()
  DEF task:PTR TO tc, info:PTR TO mygui, error=FALSE
  task:=FindTask(NIL)
  info:=task.userdata
  info.going:=TRUE
  -> While there is something to do.
  WHILE next(info)
    -> Cannot Delay() since this code is run by a Task (not a Process).
    -> (200000 is a fifth of a second, or 10 ticks)
  EXIT error:=timeDelay(UNIT_MICROHZ,0,200000)
  ENDWHILE
  -> Kill ourself safely.
  Forbid()
  -> This GUI update is safe, since within Forbid()/Permit().
  IF error THEN settext(info.gh,info.title,'Timer error!')
  info.task:=NIL
  deleteTask(task)
  Permit()
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
        -> Must Forbid()/Permit() since we're a different task to the GUI.
        Forbid()
        settext(info.gh,info.title,'Finished!')
        Permit()
        RETURN FALSE
      ENDIF
      l.values[]:=h
    ENDIF
    l.values[1]:=m
    -> Must Forbid()/Permit() since we're a different task to the GUI.
    Forbid()
    l.redisplay()
    Permit()
    RETURN TRUE
  ENDIF
ENDPROC FALSE

-> Close function.
PROC close(info:PTR TO mygui) IS cleangui(info.gh)
