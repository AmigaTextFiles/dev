-> This example show how to use the module 'multiGUI'
-> Note: multiGUI is an module which enable you to use several easyGUIs
->       at the same time (user could use every window at any time).
->       Shows how to use dynamic-created GUIs.

OPT OSVERSION=37
MODULE 'tools/EasyGUI',
       'tools/exceptions',
       'tools/multiGUI'

PROC main() HANDLE
RAISE "SCR" IF LockPubScreen()=NIL,
      "MEM" IF String()=NIL

DEF mg:PTR TO multiGUI,
    i,
    gl,gh:PTR TO guihandle,
    pubscreen=NIL

  NEW mg.multiGUI()
  mg.setStdScreen(pubscreen:=LockPubScreen(NIL))
  ScreenToFront(pubscreen)

  PrintF('8 easyGUI-GUIs with multiGUI!\n'+
         'This time dynamical created.\n\n')

  -> Open 8 GUIs with remove-functions 'winclose' and 'std_disposegui'
  -> and winnumber as GUI-info
  FOR i:=1 TO 8
    gl:=mg.addGUI(StringF(String(30),'Win #\d',i),
      NEW [ROWS,
         NEW [SBUTTON,2,'Close GUIs'],
         NEW [EQCOLS,
            NEW [SBUTTON,1,'Save'],
            NEW [SBUTTON,0,'Cancel']
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
  IF (res=2)
    PrintF('Someone hit the >Close GUIs<-Button\n')
    mg.removeAll(2)
  ELSE
    PrintF('>\s< pressed\n',IF res THEN 'Save' ELSE 'Cancel')
  ENDIF

ENDPROC

-> Disposes a dynamical created gui.
PROC std_disposegui(mg:PTR TO multiGUI,gl,res) IS
  disposegui(mg.getGUIDescription(gl))

