;
; *******************************
;
; App example file for Pure Basic
;
;  © 2001 - Fantaisie Software -
;
; *******************************
;
;

WBStartup()     ; Can be started from Workbench


InitApp(1)      ; 2 apps object (one for the window and the other for the menu)

;
; Add our AppMenu here...
;
AppMenu$ = "PureBasic RuleZ !"
AddAppMenu(0, AppMenu$)

If OpenWindow(0, 300, 140, 200, 100, #WFLG_CLOSEGADGET | #WFLG_DRAGBAR | #WFLG_DEPTHGADGET | #WFLG_ACTIVATE | #WFLG_RMBTRAP, "Drop me some icons")

  AddAppWindow(1, WindowID()) ; Add the app feature to our window

  Repeat
    Delay(2)

    AppID     = AppEvent()    ; Get the app & window events
    EventID.l = WindowEvent() ;

    If AppID > -1
      Select AppID

        Case 0
          PrintN("Tools Menu Item is pushed")

        Case 1
          PrintN("Some icons has been dropped on the window:")

          For k=1 To AppNumFiles()
            PrintN(NextAppFile())
          Next

        Default
          PrintN("Warning, unknow APP message.")

      EndSelect
    EndIf

  Until EventID = #PB_EventCloseWindow

  RemoveAppWindow(1)  ; Do forget them...

  CloseWindow(0)
EndIf                 ; The library don't free them at end -> crash.
                      ;
RemoveAppMenu(0)      ;

End
; MainProcessor=0
; Optimizations=0
; CommentedSource=0
; CreateIcon=0
; NoCliOutput=0
; Executable=PureBasic:Examples/Sources/
; Debugger=1
; EnableASM=0
