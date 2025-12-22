;
; *******************************
;
; App example file for Pure Basic
;
;  © 2000 - Fantaisie Software -
;
; *******************************
;
;

WBStartup()     ; Can be started from Workbench

InitWindow(0)   ; We need one window
InitApp(1)      ; 2 apps object (one for the window and the other for the menu)
InitTagList(0)  ; A little taglist for our window (3 tags max)


;
; Add our AppMenu here...
;
AppMenu$ = "PureBasic RuleZ !"
AddAppMenu(0, AppMenu$)

Title$ = "Drop me some icons !"
ResetTagList(#WA_Title, Title$)

If OpenWindow(0, 300, 140, 200, 100, #WFLG_CLOSEGADGET | #WFLG_DRAGBAR | #WFLG_DEPTHGADGET | #WFLG_ACTIVATE | #WFLG_RMBTRAP, TagListID())

  AddAppWindow(1, WindowID()) ; Add the app feature to our window

  Repeat
    VWait()

    AppID   = AppEvent()    ; Get the app & window events
    IDCMP.l = WindowEvent() ;

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

  Until IDCMP = #IDCMP_CLOSEWINDOW

  RemoveAppWindow(1)  ; Do forget them...
EndIf                 ; The library don't free them at end -> crash.
                      ;
RemoveAppMenu(0)      ;

End
