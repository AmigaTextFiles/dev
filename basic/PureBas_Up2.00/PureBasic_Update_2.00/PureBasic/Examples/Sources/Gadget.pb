;
; Gadget example program for the PureBasic programming langage
;
; Coded by AlphaSND - © 2000 Fantaisie Software
;
;
; 31/12/2000
;   First version
;

WbStartup()             ; This program can be started from the Workbench

InitWindow (1)          ; All init stuffs
InitTagList(0)          ;
InitGadget (0)          ;
InitScreen (0)          ;

FindFrontScreen(0)      ; Catch the frontmost screen..

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

If CreateGadgetList(0,ScreenID())

  HFont   = ScreenFontHeight()
  HGadget = HFont+6
  DistGad = HGadget+4

  HG = HFont+10

  ButtonGadget(3, 10, HG, 200, HGadget, "Button Gadget 1"  , 0) : HG = HG+DistGad

  PaletteGadget(2, 10, HG, 200, HGadget, "", 2, 0) : HG = HG+DistGad
  
  texts(0) = "This is"
  texts(1) = "A cool"
  texts(2) = "PureBasic"
  texts(3) = "Example"
  
  CycleGadget(4, 100, HG, 100, HGadget, "Test :", texts(), 0) : HG = HG+DistGad+4
  
  ; Now it's a bit tricky to change the Gadget font. It will change in the future.
  ; Just change the name and the size to get another font...
  ;

  FontName$ = "topaz.font"
  ta.TextAttr\ta_Name = @FontName$
  ta\ta_YSize = 8

  SetGadgetFont(@ta)

  ButtonGadget(0,  10, HG, 96, HGadget, "Ok", 0)
  ButtonGadget(1, 115, HG, 96, HGadget, "Cancel", 0) : HG+HFont

endif

Title.s = "PureBasic Gadget !"

ResetTagList(#WA_Title,Title)
If OpenWindow(0,100,100,215, HG+4, #WFLG_DRAGBAR | #WFLG_CLOSEGADGET, TagListID())

  AttachGadgetList(0, WindowID())

  Repeat
    Repeat
      VWait()
      Event.l = WindowEvent()

    Until Event<>0

    If Event = #IDCMP_GADGETUP

      Select EventGadget()

        Case 0
          Event = #IDCMP_CLOSEWINDOW

        Case 1
          Event = #IDCMP_CLOSEWINDOW

        Case 2
          PrintN("Palette gadget: "+Str(EventCode()))

        Case 3
          PrintN("Button gadget 1")

        case 4
          PrintN("Cycle gadget: "+Str(EventCode()))

      EndSelect

    Endif

  Until Event = #IDCMP_CLOSEWINDOW
Else
  PrintN("Error, I can't open the window")
Endif

End
