
; ***********************************
;
;  Gadget example file for PureBasic
;
;    © 2001 - Fantaisie Software -
;
; ***********************************


Structure ListView
  Pad.w
  String.s
EndStructure

NewList MyListView.ListView()


WBStartup()  

If InitTagList(9) AND InitScreen(0) AND InitGadget(19)

  Title.s="PureBasic Gadget !"

  If OpenWindow(0,100,80,426,130,#WFLG_DRAGBAR|#WFLG_CLOSEGADGET,Title.s)

    If CreateGadgetList() AND LoadFont(0,"topaz.font",8)

      FindScreen(0,"")
      SetGadgetFont(FontID())
 
      GadgetBevelBox(2,1,422,128,0)
      PaletteGadget(0,8,4,200,12,0,4)
      StringGadget(1,278,4,140,12,"Name:  ","Donald Duck")

      Dim texts.s(4)
      texts(0) = "This is"
      texts(1) = "A cool"
      texts(2) = "PureBasic"
      texts(3) = "Example"
 
      CycleGadget(2,78,24,100,12,"Test :",texts())

      StringGadget(3,278,16,140,12,"Rank:  ","Quack Attack" )
      IntegerGadget(4,278,28,60,12,"Number:",1)

      For c.l=0 To 11
        AddElement(MyListView())
        MyListView()\String="Label "+Str(c.l)
      Next 

      ListViewGadget(5,30,56,120,50,"ListView",ListBase(MyListView()))

      Dim Lables.s(3)
      Lables(0)="Choose"
      Lables(1)="one of"
      Lables(2)="these."

      GadgetBevelBox(176,54,218,48,1)
      OptionGadget(6,186,66,0,0,Lables())
 
      NumberGadget(7,334,54,16,12,0,0)
      SliderGadget(8,308,66,60,9,0,0,9)

      ResetTagList(#GTTX_Border,1)
      SetGadgetTagList(TagListID())
      sctxt$="This is another cool PureBasic Gadget Example..."
      TextGadget(9,300,78,80,12,0,sctxt$)

      ResetTagList(#GTSC_Arrows,16)
      SetGadgetTagList(TagListID())
      ScrollerGadget(10,300,90,80,9,0,47,10) 
 
      ButtonGadget(11,8,112,168,12,"I want to Quit NOW..")
      CheckBoxGadget(12,188,113,26,16,0)

      ResetTagList(#GTTX_Border,1)
      SetGadgetTagList(TagListID())
      TextGadget(13,236,112,180,12,0,"PureBasic V2.30")
      
      RefreshGadget(-1)

      Repeat

        Event.l = WaitWindowEvent()

        If Event = #IDCMP_GADGETDOWN OR Event = #IDCMP_GADGETUP

          EventGadget.l=EventGadgetID()
          GadgetState.l=GetGadgetState(EventGadget)

          Select EventGadget

           Case 0
             New$="Palette gadget: "+Str(GadgetState)

           Case 1
             New$=GetGadgetText(1)

           Case 2
             New$="Cycle gadget: "+Str(GadgetState)

           Case 3
             New$=GetGadgetText(3)

           Case 4
             New$="Integer gadget: "+Str(GadgetState)

           Case 5
             New$="ListView gadget: "+Str(GadgetState)
             SetGadgetState(5,-1)
             
           Case 6
             New$="Option gadget: "+Str(GadgetState)

           Case 8
             New$="Slider gadget: "+Str(GadgetState)
             SetGadgetState(7,GadgetState)

           Case 10
             New$="Scroller gadget: "+Str(GadgetState)
             newtxt$=Mid(sctxt$,GadgetState+1,10)
             SetGadgetText(9,newtxt$)

           Case 11
             Event=#IDCMP_CLOSEWINDOW

           Case 12
             New$="Checkbox gadget: "+Str(GadgetState)
             DisableGadget(11,GadgetState)

          EndSelect

          If New$ <> ""
            Text$=New$
            SetGadgetText(13,Text$)
            New$=""
          EndIf

        Endif

      Until Event = #IDCMP_CLOSEWINDOW

      SetGadgetText(13,"End of Program.")
      Delay(50)
    EndIf

  Else
    PrintN("Error, can't open window")
  Endif

EndIf

End
; MainProcessor=0
; Optimizations=0
; CommentedSource=0
; CreateIcon=0
; NoCliOutput=0
; Executable=Ram Disk:test
; Debugger=0
; EnableASM=0
