-> This example show how to use the module 'multiGUI'
-> Note: multiGUI is an module which enable you to use several easyGUIs
->       at the same time (user could use every window at any time)
->       This is a somewhat bad example. It shows only how to use
->       multiGUI. But it use a _static list_ for GUI-description.
->       If you really want to use the multiGUI-feature you should use
->       _dynamic lists_. See easyGUI.doc, section "Multiple copies of a GUI"
->       if you don't know how to do this.

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

  PrintF('4 easyGUI-GUIs with multiGUI!\n\n')

  -> Open 4 GUIs with remove-function 'winclose' and winnumber as GUI-info
  FOR i:=1 TO 4
    gl:=mg.addGUI(StringF(String(30),'Win #\d',i),
      [ROWS,
         [SBUTTON,2,'Close GUIs'],
         [EQCOLS,
            [SBUTTON,1,'Save'],
            [SBUTTON,0,'Cancel']
         ]
      ],i)

    -> Install Procs for this gui. winclose() is called before the
    -> gui is closed (easygui/cleangui()).
    mg.setGUIProcs(gl,{winclose},NIL)

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
  IF res=2
    PrintF('Someone hit the >Close GUIs<-Button\n')
    mg.removeAll(2)
  ELSE
    PrintF('>\s< pressed\n',IF res THEN 'Save' ELSE 'Cancel')
  ENDIF

ENDPROC

