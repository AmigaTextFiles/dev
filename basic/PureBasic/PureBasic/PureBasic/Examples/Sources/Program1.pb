;
; Example program for the PureBasic programming langage
;
; Coded by AlphaSND - © 2001 Fantaisie Software
;
;

WbStartup()             ; This program can be started from the Workbench

InitGadget (10)         ;
InitScreen (0)          ;

FindScreen(0,"")        ; Catch the frontmost screen..

Dim texts.s(4)

; Now, create our window layout, fully font sensitive. To achieve that,
; we have 3 variables:
;
;   HFont   : To have the height of used gadget font
;   HGadget : Our default gadget height
;   DistGad : Our default distance between 2 gadgets (height only)
;
; With these, we can manipulate the gadget position very easely.
;

HFont   = ScreenFontHeight()
HGadget = HFont+6

If OpenWindow(0,100,100,215, HGadget*8+16, #WFLG_DRAGBAR | #WFLG_CLOSEGADGET, "PureBasic - Example")

  CreateGadgetList()

  DistGad = HGadget+4
  HG = 6

  ButtonGadget(3, 6, HG, 200, HGadget, "File Requester"  ) : HG = HG+DistGad
  ButtonGadget(4, 6, HG, 200, HGadget, "Font Requester"  ) : HG = HG+DistGad
  ButtonGadget(5, 6, HG, 200, HGadget, "Screen Requester") : HG = HG+DistGad+HFont+3

  PaletteGadget(2,6, HG, 200, HGadget, "", 2) : HG = HG+DistGad
  
  texts(0) = "This is"
  texts(1) = "A cool"
  texts(2) = "PureBasic"
  texts(3) = "Example"
  
  CycleGadget(6, 6, HG, 100, HGadget, "Test :", texts()) : HG = HG+DistGad+4
  
  ButtonGadget(0, 6, HG, 96, HGadget, "Ok")
  ButtonGadget(1, 115, HG, 96, HGadget, "Cancel") : HG+HFont

  RefreshGadget(-1)
  
  Repeat
    Event.l = WaitWindowEvent()

    If Event = #IDCMP_GADGETUP

      Select EventGadgetID()

        Case 0
          Event = #IDCMP_CLOSEWINDOW

        Case 1
          Event = #IDCMP_CLOSEWINDOW

        Case 2
          PrintN("Palette gadget: "+Str(EventCode()))

        Case 3
          PrintN("File Requester: '"+FileRequester(0)+"'")

        Case 4
          If FontRequester(0)
            PrintN("Requester OK")
          Else
            PrintN("Requester cancelled")
          EndIf

        Case 5
          If ScreenRequester(0)
            PrintN("Requester OK")
          Else
            PrintN("Requester cancelled")
          EndIf
          

        case 6
          PrintN("Cycle gadget: "+Str(EventCode()))

          If EventCode() = 2
            Gosub Surprise
          Endif

      EndSelect

    Endif

  Until Event = #IDCMP_CLOSEWINDOW
Else
  PrintN("Error, I can't open the window")
Endif

End


Surprise:

  If OpenWindow(1,200,200,200,30,#WFLG_DRAGBAR | #WFLG_CLOSEGADGET, "Hidden Window Found !")

    Repeat
      Event.l = WaitWindowEvent()
    Until Event = #IDCMP_CLOSEWINDOW

    CloseWindow(1)
    Event = 0
  Endif
  UseWindow(0)

Return
; MainProcessor=0
; Optimizations=0
; CommentedSource=1
; CreateIcon=0
; NoCliOutput=0
; Executable=Ram Disk:ess.exe
; Debugger=1
; EnableASM=0
