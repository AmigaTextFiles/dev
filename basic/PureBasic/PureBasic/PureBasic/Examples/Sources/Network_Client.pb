;
; Network support for PureBasic
;


If InitNetwork() = 0
  EasyRequester("Error", "Launch a TCP/IP stack before (Miami, AmiTCP...)", "Ok")
  End
EndIf

If OpenNetworkConnection("127.0.0.1", 2030)
  PrintN ("Server found.")

  SendNetworkString(0, "PureBasic is great...")  ; '0' is always is the client.

  SendNetworkFile(0, "Sys:disk.info")

  EasyRequester("","Hello", "OK")

  Repeat
    Delay(1)
  Until MouseButtons() = 2

  CloseNetworkConnection()  ; To notify the server than we quit...
                           ; If this function is not executed, the
                           ; shutdown message isn't send to the server
                           ; Could be useful sometimes..
Else
  EasyRequester("Error", "Server not found.", "Ok")
Endif

End
