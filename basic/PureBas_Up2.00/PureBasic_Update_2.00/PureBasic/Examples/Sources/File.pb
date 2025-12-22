;
; ********************************
;
; File example file for Pure Basic
;
;  © 2000 - Fantaisie Software -
;
; ********************************
;
;

InitFile(0)

If CreateFile(0,"ram:PureBasic.test")      ; Create a file and put some text in it.
                                           ;
  WriteStringN("Hello I'm Pure Basic")      ;
  WriteStringN("What do you think of me ?") ;

  WriteLong(120000)
  WriteWord(-1500)
  WriteByte(-10)
             
  CloseFile(0)
Endif


If ReadFile(0,"ram:PureBasic.test")

  PrintN("Displaying file 'Ram:PureBasic.test'")

  PrintN(ReadString())
  PrintN(ReadString())

  PrintNumberN(ReadLong())
  PrintNumberN(ReadWord())
  PrintNumberN(ReadByte())
Endif

MouseWait()

End   ; File is automagically closed at the end.
