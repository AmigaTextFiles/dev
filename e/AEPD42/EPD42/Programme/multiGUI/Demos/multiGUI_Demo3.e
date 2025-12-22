-> This example show how to use the module 'multiGUI'
-> Note: multiGUI is an module which enable you to use several easyGUIs
->       at the same time (user could use every window at any time).
->       Shows how to use dynamic-created GUIs and adds CtrlC() handling.
->       This only demonstrates how to overwrite some methods. Of course
->       the CtrlC()-check can also be done in the mainloop.

OPT OSVERSION=37
MODULE 'dos/dos'
MODULE 'tools/EasyGUI',
       'tools/exceptions',
       'tools/multiGUI'

ENUM RID_CloseAll=1,
     RID_Cancel,
     RID_Save,
     RID_CtrlC


OBJECT multiGUI_CC OF multiGUI
ENDOBJECT

PROC waitSignal(sigs) OF multiGUI_CC IS Wait(sigs OR SIGBREAKF_CTRL_C)

PROC unknownSignal(sig) OF multiGUI_CC
  IF (sig=SIGBREAKF_CTRL_C) THEN self.removeAll(RID_CtrlC)
ENDPROC -1


PROC main() HANDLE
RAISE "SCR" IF LockPubScreen()=NIL,
      "MEM" IF String()=NIL

DEF mg:PTR TO multiGUI_CC,
    i,
    gl,gh:PTR TO guihandle,
    pubscreen=NIL

  NEW mg.multiGUI()
  mg.setStdScreen(pubscreen:=LockPubScreen(NIL))
  ScreenToFront(pubscreen)

  PrintF('5 easyGUI-GUIs with multiGUI!\n'+
         'This time dynamical created.\n\n'+
         'Also try CtrlC here\n\n')

  -> Open 5 GUIs with remove-functions 'winclose' and 'std_disposegui'
  -> and winnumber as GUI-info
  FOR i:=1 TO 5
    gl:=mg.addGUI(StringF(String(30),'Win #\d',i),
      NEW [ROWS,
         ->NEW [TEXT,'Also Try Ctrl-C',NIL,TRUE,RESIZEX],
         NEW [SBUTTON,RID_CloseAll,'Close GUIs'],
         NEW [EQCOLS,
            NEW [SBUTTON,RID_Save,'Save'],
            NEW [SBUTTON,RID_Cancel,'Cancel']
         ]
      ],i)

    -> Install Procs for this gui. winclose() is called before the
    -> gui is closed (easygui/cleangui()) and std_disposegui() after
    -> this.
    mg.setGUIProcs(gl,{winclose},{std_disposegui})

    -> Displace windows
      gh:=mg.getGUIHandle(gl)
      MoveWindow(gh.wnd,Rnd(200)-100,Rnd(100)-50)
  ENDFOR

  -> Wait for user-action. Stop when all gui's are closed.
  WHILE mg.getCounter()>0 DO mg.wait()

EXCEPT DO

  END mg
  IF pubscreen THEN UnlockPubScreen(NIL,pubscreen)

  report_exception()

ENDPROC

-> Print out some Informations about the closed gui.
-> If a special button is pressed, all gui's are removed.
PROC winclose(mg:PTR TO multiGUI,gl,res)

  PrintF('window \d closed; reason : ',mg.getGUIInfo(gl))
  SELECT res
    CASE RID_CloseAll
      PrintF('Someone hit the >Close GUIs<-Button\n')
      mg.removeAll(RID_CloseAll)
    CASE RID_Save   ; PrintF('>Save< pressed\n')
    CASE RID_Cancel ; PrintF('>Cancel< pressed\n')
    CASE RID_CtrlC  ; PrintF('CtrlC pressed\n')
    DEFAULT         ; PrintF('Unknown\n')
  ENDSELECT

ENDPROC

-> Disposes a dynamical created gui.
PROC std_disposegui(mg:PTR TO multiGUI,gl,res) IS
  disposegui(mg.getGUIDescription(gl))

