;
; Protracker & sound module player...
;
;   (c) 2000 - Fantaisie Software
;
;
; 25/07/2000
;   First version
;
;

WbStartup()

InitWindow(10)
InitTagList(20)
InitGadget(20)
InitScreen(10)
InitRequester()
InitAudio()
InitPTModule(10)

If AllocateAudioChannels(15) = 0
  PrintN("Audio not ready for sound replay...")
  End
EndIf

InitSound(10)


FindScreen(0, "")

#GADGET_Rewind = 2
#GADGET_Stop   = 3
#GADGET_Pause  = 4
#GADGET_Play   = 5


If CreateGadgetList(1, ScreenID())

  HF = 20
  HG = 20

  StringGadget(1, 100, HG, 280, HF, "Module :", "", 0)
  ButtonGadget(6, 380, HG, 20, HF, "?", 0) : HG+HF+4 

  ButtonGadget(#GADGET_Rewind, 100, HG, 30, HF, "|<", 0)
  ButtonGadget(#GADGET_Stop  , 140, HG, 30, HF, "S", 0)
  ButtonGadget(#GADGET_Pause , 180, HG, 30, HF, "||", 0)
  ButtonGadget(#GADGET_Play  , 220, HG, 30, HF, ">", 0) : HG+HF+4

  StringGadget(7, 100, HG, 280, HF, "Sound :", "", 0)
  ButtonGadget(8, 380, HG, 20, HF, "?", 0) : HG+HF+4 
 
  Dim Choice.s(2)
  Choice(0) = "On"
  Choice(1) = "Off"

  CycleGadget ( 9, 100, HG,  60, HF, "Channel 1 :", Choice(), 0)
  ButtonGadget(10, 170, HG, 100, HF, "Play sound", 0) : HG+HF+4

  Dim Filter.s(2)
  Filter(0) = "Audio Filter"
  Filter(1) = "No Filter"
  OptionGadget(20, 280, HG, 100, HF*4, Filter(), 0)

  CycleGadget (11, 100, HG,  60, HF, "Channel 2 :", Choice(), 0)
  ButtonGadget(12, 170, HG, 100, HF, "Play sound", 0) : HG+HF+4

  CycleGadget (13, 100, HG,  60, HF, "Channel 3 :", Choice(), 0)
  ButtonGadget(14, 170, HG, 100, HF, "Play sound", 0) : HG+HF+4

  CycleGadget (15, 100, HG,  60, HF, "Channel 4 :", Choice(), 0)
  ButtonGadget(16, 170, HG, 100, HF, "Play sound", 0) : HG+HF+4
EndIf


ChannelMask = 15

a$ = "PureBasic"
ResetTagList(#WA_Title, a$)
If OpenWindow(0, 100, 100, 410, 178, #WFLG_DRAGBAR | #WFLG_CLOSEGADGET | #WFLG_DEPTHGADGET, TagListID())

  BevelBox(WindowBorderLeft(), WindowBorderTop(), WindowInnerWidth(), WindowInnerHeight(), 0)

  AttachGadgetList(1, WindowID())

  For k=2 To 5
    DisableGadget(k, 1)
  Next

  DisableGadget(10, 1)
  DisableGadget(12, 1)
  DisableGadget(14, 1)
  DisableGadget(16, 1)

  UseAsPTModuleChannels(ChannelMask)

  Repeat
    Delay(1)

    IDCMP.l = WindowEvent()

    If IDCMP = #IDCMP_GADGETUP

      GadgetCode.l   = EventCode()
      ChangeChannels = 0

      Select EventGadget()


        Case#GADGET_Rewind

         

        Case #GADGET_Stop

          StopPTModule()
          MOVE.w #15,$dff096 
          Pause = 0


        Case #GADGET_Pause
         
          If Pause = 0
            PausePTModule()
            MOVE.w #15,$dff096 
            Pause = 1
          EndIf


        Case #GADGET_Play

          If Pause
            ResumePTModule(0)
            Pause = 0
          Else
            PlayPTModule(0)
          EndIf


        Case 6 ; Choose a Module

          Module$ = FileRequester(0)

          If Module$
            SetStringText(1, Module$)
            RefreshGadget(1)

            FreePTModule(0)

            CLR.l  d2
          
            If LoadPTModule(0, Module$)

              For k=2 To 5
                DisableGadget(k, 0)
              Next
            Else
            
            EndIf
          EndIf


        Case 8 ; Choose a Sound

          Sound$ = FileRequester(0)

          If Sound$
            SetStringText(7, Sound$)
            RefreshGadget(7)

            For k=0 to 3
              LoadSound(k, Sound$)
              SetSoundChannels(k, 1 LSL k)
            Next
          EndIf


        Case 9 ; Channel 1: Enable/Disable

          If GadgetCode = 0
            DisableGadget (10, 1)
            ChannelMask | 1
          Else
            DisableGadget (10, 0)
            ChannelMask & (2+4+8)
          EndIf

          ChangeChannels = 1


        Case 11 ; Channel 1: Enable/Disable

          If GadgetCode = 0
            DisableGadget (12, 1)
            ChannelMask | 2
          Else
            DisableGadget (12, 0)
            ChannelMask & (1+4+8)
          EndIf

          ChangeChannels = 1


        Case 13 ; Channel 1: Enable/Disable

          If GadgetCode = 0
            DisableGadget (14, 1)
            ChannelMask | 4
          Else
            DisableGadget (14, 0)
            ChannelMask & (1+2+8)
          EndIf

          ChangeChannels = 1


        Case 15

         If GadgetCode = 0
           DisableGadget (16, 1)
           ChannelMask | 8
         Else
           DisableGadget (16, 0)
           ChannelMask & (1+2+4)
         EndIf

         ChangeChannels = 1


        Case 10
          PlaySound(0, 1)

        Case 12
          PlaySound(1, 1)

        Case 14
          PlaySound(2, 1)

        Case 16
          PlaySound(3, 1)


        Case 20  ; OptionGadget
          

      EndSelect

     
      If ChangeChannels

        UseAsPTModuleChannels(ChannelMask)
        MOVE.w ChannelMask,$dff096
        UseAsSoundChannels   (15-ChannelMask)

      EndIf

    EndIf

    If IDCMP = #IDCMP_GADGETDOWN
     
      GadgetCode = EventCode()

      If EventGadget() = 20
        SoundFilter(1-GadgetCode)
      EndIf
    EndIf

  Until IDCMP = #IDCMP_CLOSEWINDOW

EndIf

End
