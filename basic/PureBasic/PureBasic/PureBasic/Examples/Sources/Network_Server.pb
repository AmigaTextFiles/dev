;
; Network support for PureBasic
;
; Very easy server application. 
;

WBStartup()

if InitNetwork() = 0
  EasyRequester("Error", "The TCP/IP stack is not initialized...", "Ok")
  End
EndIf

Port.l = 2030

OpenExecLibrary_(36)

*Buffer = AllocVec_(10000, 0)

If CreateNetworkServer(Port)

  PrintN("Server created (Port: "+Str(Port)+").")

  Repeat
    Delay(1)
   
    Event.l = NetworkServerEvent()

    If Event
      Client$  = Str(NetworkClientID())
      ClientID = NetworkClientID()

      Select Event            

        Case 1
          PrintN("New client connected (ID = "+Client$+").")

        Case 2
          PrintN("Raw data received (Client "+Client$+").")
          ReceiveNetworkData(ClientID, *Buffer, 10)

        Case 3
          PrintN("File received (Client "+Client$+").")
          ReceiveNetworkFile(ClientID, "Ram:Test.net")

        Case 4
          PrintN("Client "+Client$+" deconnected")

        Case 5
          PrintN("String received (Client "+Client$+").")
          String$ = ReceiveNetworkString(ClientID)
          PrintN("String Content = "+String$)

      EndSelect
    Endif
  
  Until MouseButtons() = 3
Else
  EasyRequester("Error", "Server can't be created (another server is running)", "Ok")
EndIf

FreeVec_ *Buffer

End
