;
; ***********************************
;
; Screen example file for PureBasic
;
;   © 1999 - Fantaisie Software -
;
; ***********************************
;
;

InitScreen(1) ; We will need 2 screens

If FindScreen(0,"") ; Find de default public screen

  Print("Screen address: ") : PrintNumberN(ScreenID())

  HideScreen() ; Hide it

  Delay(10)    ; Wait a little bit...

  ShowScreen() ; and show it !

  PrintN("Screen dimensions: "+Str(ScreenWidth())+"x"+Str(ScreenHeight())+"x"+Str(ScreenDepth()))

  PrintN("MouseX: "+Str(ScreenMouseX())+", MouseY: "+Str(ScreenMouseY())+", ScreenBar height: "+Str(ScreenBarHeight()))

  If OpenScreen(1,320,200,3,0)  ; Open a new screen, 320*200 - 8 colours

    Delay(50)

    CloseScreen(1)
  EndIf

  UseScreen(0)

  a = ObtainBestPen(255,255,255,0)  ; Get the index of the pure white colour and lock it

  PrintN("Pure White colour found at colour: "+Str(a))

  ReleasePen(a)                     ; Release it to the system

  If FindScreen(1,"Workbench")      ; Find the WB Screen
    PrintN("Workbench screen found !")
    Print("Screen RastPort: ") : PrintNumber(ScreenRastPort())
    Print(", Screen ViewPort: ") : PrintNumberN(ScreenViewPort())

    Delay(10)                       ; Flash the workbench screen !
    FlashScreen()
  Else
    PrintN("Workbench screen isn't found ?!")
  Endif

EndIf

PrintN("Press the mouse to quit")

MouseWait()

End

