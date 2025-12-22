
; *************************************
;
; Commodity example file for Pure Basic
;
; © 1999 - Fantaisie Software -
;
; *************************************


; This example show the basic idea of how
; a Commodity should be built, with the
; eventloop and how to react on commands
; from Commodities Exchange.



  name$="Pure Basic Commodity" ; this text is what..
  title$="Commodity V1.00"     ; Commodities Exchange..
  disc$="Testing"              ; show in it's window


  PrintN("")
  PrintN("/////////////////////////////////////////////")
  PrintN("Press F1, F2 or open Commodities Exchange and")
  PrintN("see what could be done on a Commodity there.")
  PrintN("Press Ctrl C or start the Commodity a second")
  PrintN("time to quit.")
  PrintN("/////////////////////////////////////////////")
  PrintN("")


  If InitCommodity(1,name$,title$,disc$,4,0)   ;* this call is really a must

    txt$="f1"
    err.b=CreateCommodityObject(0,txt$,0)      ;* Object 0 is tied to f1 key

    err=CreateCommodityObject(1,"f9",0) | err  ;* Object 1 is tied to f9 key

    err=ChangeCommodityFilter(1,"f2") | err    ;* change Object 1 to f2 key


    If err = 0             ;* if there is no error on the filters..

      ActivateCommodity(1) ;* then it's time to activate the Commodity
  

      Repeat                       ;* here starts the eventloop

      WaitCommodityEvent()         ;* wait until some event occur


      If CommoditySignal()         ;* is the event a Commodity signal..

        msgtype.w=CommodityType()  ;* then get the Message Type..
        msgid.w=CommodityID()      ;* and the Message ID

        Select msgtype

         Case #CXM_IEVENT                  ;* is Message of event Type

           Print("IEvent: ID=") : PrintNumber(msgid)

           Select msgid                    ;* the event was caused..

            Case 0                         ;* by Object 0
              PrintN("  F1 was pressed..")

            Case 1                         ;* by Object 1
              PrintN("  F2 was pressed..")

           EndSelect
  

         Case #CXM_COMMAND                 ;* is Message of command Type
           Print("Command: ")

           Select msgid                    ;* the command is a..

            Case #CXCMD_ENABLE             ;* Enable command
              PrintN("Enable")
              ActivateCommodity(1)         ;* then enable the Commodity

            Case #CXCMD_DISABLE            ;* Disable command
              PrintN("Disable")
              ActivateCommodity(0)         ;* then disable the Commodity

            Case #CXCMD_APPEAR             ;* Appear command
              PrintN("Appear")             ;* then let the GUI appear

            Case #CXCMD_DISAPPEAR          ;* Disappear command
              PrintN("DisAppear")          ;* then let the GUI disappear

            Case #CXCMD_KILL               ;* Kill command
              PrintN("Kill")
              quit=1                       ;* kill the Commodity

            Case #CXCMD_UNIQUE             ;* Unique command
              PrintN("Unique")             ;* time for Commodity to quit if
              quit=1                       ;* it has no GUI else show the GUI

           EndSelect

        EndSelect
  
      EndIf
  

      If CommodityCtrlCSignal()  ;* is the event a Ctrl C break signal
        quit=1                   ;* time for commodity to quit
      EndIf
  

      Until quit = 1             ;* here ends the eventloop

    EndIf

  EndIf
  PrintN("End of Program.")

  End

