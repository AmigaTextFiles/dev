
; *************************************
;
; Commodity example file for Pure Basic
;
; © 1999 - Fantaisie Software -
;
; *************************************


; This example show some more advanced
; stuff for a Commodity, it's good to
; know the basics from Example 1.
;
; Open Execute Command and have the
; string gadget active when testing
; this example.


Define.InputXpression  ix1

  ix1\ix_Version   = #IX_VERSION  ;*  It's recommended that the section
  ix1\ix_Class     = 2            ;*  in RKRM Libraries that describe
  ix1\ix_Code      = 255          ;*  this structure is read befor it's
  ix1\ix_CodeMask  = 0            ;*  used with other inputevents.
  ix1\ix_Qualifier = 0
  ix1\ix_QualMask  = 0
  ix1\ix_QualSame  = 0


Define.InputEvent  ie1, ie2, ie3

  ie1\ie_NextEvent = ie2 ;        ;* Here is the 3 diffrent inputevent
  ie1\ie_Class     = 1   ;        ;* that is used and added to the input
  ie1\ie_Code      = 53  ; = b    ;* eventstream.

  ie2\ie_NextEvent = ie3 ;
  ie2\ie_Class     = 1   ;
  ie2\ie_Code      = 54  ; = n

  ie3\ie_NextEvent = 0   ;
  ie3\ie_Class     = 1   ;
  ie3\ie_Code      = 55  ; = m


  name$="Pure Basic Commodity"
  title$="Commodity V1.00"
  disc$="Testing"


  PrintN("")
  PrintN("////////////////////////////////////////////////")
  PrintN("Open Execute Command in WorkBench menu.")
  PrintN("Press F1 to add a new inputevent.")
  PrintN("Press F2 to delete all Objects.")
  PrintN("Press F3 to turn on/off Translater for Object 4.")
  PrintN("Press F4 to turn on/off Object 4.")
  PrintN("Mouse is Object 4, move it around a bit.")
  PrintN("////////////////////////////////////////////////")
  PrintN("")


  If InitCommodity(4,name$,title$,disc$,0,0)


    err.b=CreateCommodityObject(0,"f1",0)     ;* Object 0 is tied to f1 key

    err=CreateCommodityObject(1,"f2",0) | err ;* Object 1 is tied to f2 key

    err=CreateCommodityObject(2,"f3",0) | err ;* Object 2 is tied to f3 key

    err=CreateCommodityObject(3,"f4",0) | err ;* Object 3 is tied to f4 key

    err=CreateCommodityObject(4,"f9",0) | err ;* Object 4 is tied to f9 key


    err=ChangeCommodityFilterIX(4,@ix1) | err  ;* Object 4 is changed to mouse
                                              ;* with an InputXpression

    ActivateCommodityObject(4,0)              ;* Object 4 is deativated..
    ChangeCommodityTranslater(4,@ie1)          ;* the translater is changed..
    ActivateCommodityTranslater(4,0)          ;* and also deactivated


    If err = 0

      ActivateCommodity(1)
  

      Repeat

      WaitCommodityEvent()
  
      If CommoditySignal()

        msgtype.w=CommodityType()
        msgid.w=CommodityID()

        Select msgtype

         Case #CXM_IEVENT
           Print("IEvent: ID=") : PrintNumber(msgid)

           Select msgid

            Case 0
              PrintN("  F1 was pressed.. A new input event is added.")
              AddCommodityInputEvent(@ie3) ;* a new inputevent is added to
                                          ;* the input eventstream
            Case 1
              Print("  F2 was pressed..")

              For c=0 to 4
                FreeCommodityObject(c)    ;* all Objects is deleted here
              Next

              PrintN (" All Objects are deleted.")

            Case 2
              Print("  F3 was pressed..")

              active2=1-active2

              If active2
                PrintN(" Translater for Object 4 is ON.")
              Else
                PrintN(" Translater for Object 4 is OFF.")
              EndIf

              ActivateCommodityTranslater(4,active2) ;* the translater for
                                                     ;* Object 4 is turned
            Case 3                                   ;* on or off here
              Print("  F4 was pressed..")

              active1=1-active1

              If active1
                PrintN(" Object 4, Mouse, is ON.")
              Else
                PrintN(" Object 4, Mouse, is OFF.")
              EndIf

              ActivateCommodityObject(4,active1)     ;* Object 4 is turned
                                                     ;* on or off here
            Case 4
              PrintN("  Mouse was used.")

           EndSelect
  

         Case #CXM_COMMAND

           Select msgid

            Case #CXCMD_KILL
              quit=1

            Case #CXCMD_UNIQUE
              quit=1

           EndSelect

        EndSelect

      EndIf
  

      If CommodityCtrlCSignal()
        quit=1
      EndIf
  

      Until quit = 1

    EndIf

  EndIf
  PrintN("End of Program.") 

  End
