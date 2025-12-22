;
; Joypad example for PureBasic !
;

If InitJoypad() = 0
  PrintN("Can't use the joypads... Exit !")
  End
EndIf

a = 0
Repeat
  VWait()
 
  Result = JoypadMovement(1)

  If Result
    PrintNumberN(Result)
  Endif

  Buttons.l = JoypadButtons(1)

  If Buttons

    PrintNumber(10000)

    If Buttons & #PB_JOYPAD_BUTTON1
      Print("Button 1 ")
    EndIf

    If Buttons & #PB_JOYPAD_BUTTON3
      Print("Button 2")
    EndIf

    PrintN("")

  EndIf

  b.l = PressedRawKey()

  If b
    PrintNumberN(b)
  EndIf

  a+1
Until a>500

End

