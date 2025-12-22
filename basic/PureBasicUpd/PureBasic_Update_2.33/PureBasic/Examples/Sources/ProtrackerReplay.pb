;
; Protracker module & sound player...
;
;   (c) 2001 - Fantaisie Software
;

WbStartup()

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

ChannelMask = 15

HF = ScreenFontHeight()+6

If OpenWindow(0, 100, 100, 410, HF*8+20, #WFLG_DRAGBAR | #WFLG_CLOSEGADGET | #WFLG_DEPTHGADGET, "PureBasic - Protracker Example")

  ; BevelBox(WindowBorderLeft(), WindowBorderTop(), WindowInnerWidth(), WindowInnerHeight(), 0)
    
  HG = 6
  
  CreateGadgetList()

  StringGadget(1, 100, HG, 280, HF, "Module :", "")
  ButtonGadget(6, 380, HG, 20 , HF, "?") : HG+HF+4 

  ButtonGadget(#GADGET_Rewind, 100, HG, 30, HF, "|<")
  ButtonGadget(#GADGET_Stop  , 140, HG, 30, HF, "S")
  ButtonGadget(#GADGET_Pause , 180, HG, 30, HF, "||")
  ButtonGadget(#GADGET_Play  , 220, HG, 30, HF, ">") : HG+HF+4

  StringGadget(7, 100, HG, 280, HF, "Sound :", "")
  ButtonGadget(8, 380, HG, 20, HF, "?") : HG+HF+4 
 
  Dim Choice.s(2)
  Choice(0) = "On"
  Choice(1) = "Off"

  CycleGadget ( 9, 100, HG,  60, HF, "Channel 1 :", Choice())
  ButtonGadget(10, 170, HG, 100, HF, "Play sound") : HG+HF+4

  Dim Filter.s(2)
  Filter(0) = "Audio Filter"
  Filter(1) = "No Filter"
  OptionGadget(20, 280, HG, 100, HF*4, Filter())

  CycleGadget (11, 100, HG,  60, HF, "Channel 2 :", Choice())
  ButtonGadget(12, 170, HG, 100, HF, "Play sound") : HG+HF+4

  CycleGadget (13, 100, HG,  60, HF, "Channel 3 :", Choice())
  ButtonGadget(14, 170, HG, 100, HF, "Play sound") : HG+HF+4

  CycleGadget (15, 100, HG,  60, HF, "Channel 4 :", Choice())
  ButtonGadget(16, 170, HG, 100, HF, "Play sound") : HG+HF+4
 
  RefreshGadget(-1)
 
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

      Select EventGadgetID()

        Case#GADGET_Rewind

          SongPos.w=GetPTModulePos()
          If SongPos > 0
            SetPTModulePos(SongPos-1)
          EndIf


        Case #GADGET_Stop

          StopPTModule()
          Pause = 0


        Case #GADGET_Pause
         
          If Pause = 0
            PausePTModule()
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
            SetGadgetText(1, Module$)

            If WasAnotherModule
              FreePTModule(0)
            EndIf

            If LoadPTModule(0, Module$)

              WasAnotherModule = 1

              For k=2 To 5
                DisableGadget(k, 0)
              Next
            Else
              EasyRequester("Error", "Not a Protacker module !", "Ok")
            EndIf
          EndIf


        Case 8 ; Choose a Sound

          Sound$ = FileRequester(0)

          If Sound$
            SetGadgetText(7, Sound$)

            For k=0 to 3
              LoadSound(k, Sound$)
              SetSoundChannels(k, 1 << k)
              SoundLoaded = 1
            Next
          EndIf


        Case 9 ; Channel 1: Enable/Disable

          If SoundLoaded : DisableGadget(10, 1-GadgetCode) : EndIf

          If GadgetCode = 0
            ChannelMask | 1
          Else
            ChannelMask & (2+4+8)
          EndIf

          ChangeChannels = 1


        Case 11 ; Channel 1: Enable/Disable

          If SoundLoaded : DisableGadget(12, 1-GadgetCode) : EndIf

          If GadgetCode = 0
            ChannelMask | 2
          Else
            ChannelMask & (1+4+8)
          EndIf

          ChangeChannels = 1


        Case 13 ; Channel 1: Enable/Disable
       
          If SoundLoaded : DisableGadget(14, 1-GadgetCode) : EndIf
     
          If GadgetCode = 0
            ChannelMask | 4
          Else
            ChannelMask & (1+2+8)
          EndIf

          ChangeChannels = 1


        Case 15
        
         If SoundLoaded : DisableGadget(16, 1-GadgetCode) : EndIf

         If GadgetCode = 0
           ChannelMask | 8
         Else
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
        UseAsSoundChannels(15-ChannelMask)

      EndIf

    EndIf

    If IDCMP = #IDCMP_GADGETDOWN
     
      GadgetCode = EventCode()

      If EventGadgetID() = 20
        SoundFilter(1-GadgetCode)
      EndIf
    EndIf

  Until IDCMP = #IDCMP_CLOSEWINDOW

EndIf

End
; MainProcessor=0
; Optimizations=0
; CommentedSource=1
; CreateIcon=0
; NoCliOutput=0
; Executable=Ram Disk:ess.exe
; Debugger=1
; EnableASM=0
