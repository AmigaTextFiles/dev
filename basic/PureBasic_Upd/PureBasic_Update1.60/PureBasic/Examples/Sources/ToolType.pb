
; *************************************
;
; ToolType example file for Pure Basic
;
;     © 2000 - Fantaisie Software -
;
; *************************************


; This example show almost everything
; that could be done on ToolTypes.
;
; It examins all standard Commodities
; for WB3.0


Dim  commodity.s(7)

   commodity(0)="AutoPoint"
   commodity(1)="CrossDos"
   commodity(2)="FKey"
   commodity(3)="Blanker"
   commodity(4)="Exchange"
   commodity(5)="MouseBlanker"
   commodity(6)="ClickToFront"
   commodity(7)="NoCapsLock"


Dim  ToolArray.s(3)

   ToolArray(0)="Amiga1=1000"
   ToolArray(1)="Amiga2=2000"
   ToolArray(2)="Amiga3=3000"
   ToolArray(3)="Amiga4=4000"


   path$="SYS:Tools/Commodities/"
   tool$="CX_POPUP"


  If InitToolType(0)

    PrintN("")

    For c.w=0 To 7

      If ReadToolTypeDiskInfo(0,path$+commodity(c))

        nrtools=GetNumberOfToolTypes(0)
                                       
        If nrtools

          Print(">> "+commodity(c)+" <<  have ")
          PrintNumber(nrtools)
          PrintN(" ToolTypes.")

          If MatchToolType(0,tool$,"") >= 0 
            PrintN("CX_POPUP is present.")
          Else
            PrintN("CX_POPUP is not present.")
          EndIf

          Str$=GetToolTypeValue(0,"CX_POPKEY") 
          If Str$ <> ""                        
            PrintN("CX_POPKEY is set to "+Str$)
          Else
            PrintN("CX_POPKEY is not present.")
          EndIf

          PrintN("")
          PrintN("Here is all ToolTypes from top to bottom.")

          For x=1 To nrtools

            ToolStr$=GetNextToolTypeString(0) 
            Print(ToolStr$)

            If MatchToolTypeString(ToolStr$,"CX_POPUP","") >= 0 
               PrintN("  << Okey, here is CX_POPUP.")  
            Else                                       
               PrintN("")
            EndIf

          Next x
  
        Else
          PrintN(">> "+commodity(c)+" <<  have no ToolTypes at all.")
        EndIf
  
        PrintN("")

        If c = 7
          If WriteToolTypeDiskInfo(0,ToolArray(),"ram:Test")
            PrintN("Test.info was successfuly writed to RamDisk.") 
          EndIf                              
        EndIf

        FreeToolType(0)

      Else
        PrintN("Can't find >> "+commodity(c)+" <<")
      EndIf

      PrintN("")
      PrintN("Press LMB to Continue...")

      MouseWait() : PrintN("")

    Next c

  EndIf

  PrintN("End of Program.")
  End

