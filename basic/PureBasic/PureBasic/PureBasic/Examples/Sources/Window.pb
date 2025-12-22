
; ***********************************
;
;  Window example file for PureBasic
;
;    © 2001 - Fantaisie Software -
;
; ***********************************


#WFLGS=#WFLG_CLOSEGADGET|#WFLG_DEPTHGADGET|#WFLG_DRAGBAR

WBStartup()                 ; This program could be launched from workbench
InitTagList(4)

ScreenTitle$ = "PureBasic..."
WindowTitle$ = "Demo Window Example"

ResetTagList(#WA_ScreenTitle, ScreenTitle$)
SetWindowTagList(TagListID())

If OpenWindow(0, 10, 80, 200, 150, #WFLGS, WindowTitle$)

  H = WindowHeight()        ; Get some window informations
  W = WindowWidth()         ;
  X = WindowX()             ;
  Y = WindowY()             ;

  PrintN("Height:"+Str(H)+", Width:"+Str(W)+", Coords(X,Y): ("+Str(X)+","+Str(Y)+")")

  Delay(50)

  MoveWindow(100,0)

  Delay(50)

  SizeWindow(200,200)

  ; Wait for the user press the close gadget
  ;
  Repeat
    IDCMP.l = WindowEvent()
    Delay(1)
  Until IDCMP = #IDCMP_CLOSEWINDOW

EndIf

End
; MainProcessor=0
; Optimizations=0
; CommentedSource=0
; CreateIcon=0
; NoCliOutput=0
; Executable=Ram Disk:test
; Debugger=1
; EnableASM=0
