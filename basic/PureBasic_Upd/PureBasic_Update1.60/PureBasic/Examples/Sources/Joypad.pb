;
; Joypad example for PureBasic !
;

If InitJoypad() = 0
  PrintN("Can't use the joypads... Exit !")
  End
EndIf

PrintN("Move the joypad around, and push the buttons !")

a = 0
Repeat
  VWait()

  Printed = 0  ; To know if something is printed to the CLI.
 
  Result = JoypadMovement(1)

  If Result

    Select Result
      Case 1
        Print("Up ")

      Case 2
        Print("Up-Left ")
       
      Case 3
        Print("Left ")

      Case 4
        Print("Down-Left ")

      Case 5
        Print("Down ")

      Case 6         
        Print("Down-Right ")

      Case 7
        Print("Right ")

      Case 8
        Print("Up-Right ")

    EndSelect

    Printed = 1
  Endif

  Buttons.l = JoypadButtons(1)

  If Buttons

    If Buttons & #PB_JOYPAD_BUTTON1
      Print("Button 1 ")
      Printed = 1
    EndIf

    If Buttons & #PB_JOYPAD_BUTTON2
      Print("Button 2 ")
      Printed = 1
    EndIf
  EndIf

  PressedKey = PressedRawKey()

  If PressedKey
    Print("Keyboard has been pressed : ")
    PrintNumber(PressedKey)
    Printed = 1
  EndIf

  If Printed    ; If something has been printed to the CLI, finish the line..
    PrintN("")
  EndIf

  a+1
Until a>500

End

