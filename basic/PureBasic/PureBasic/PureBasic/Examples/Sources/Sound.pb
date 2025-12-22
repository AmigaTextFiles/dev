
; **********************************
;
;  Sound example file for PureBasic
;
;   © 2000 - Fantaisie Software -
;
; **********************************


  If InitAudio() AND InitSound(3)

    If AllocateAudioChannels(15)
      chan.w=15
    Else
      chan_mask.w=1
      For c.l=0 To 3
        tmp_chan.w=AllocateAudioChannels(chan_mask.w)
        chan.w|tmp_chan.w : chan_mask.w << 1
      Next
    EndIf

    If chan.w

      UseAsSoundChannels(chan.w)

      If LoadSound(0,"PureBasic:Examples/Data/Bump.IFF")
        PrintN("Loading Sound...")

        PrintN("Playing Sound 0...")
        PlaySound(0,-1)
        Gosub Wait
      EndIf

      If DecodeSound(1,?sound)
        PrintN("Decode Sound...")

        PrintN("Playing Sound 1...")
        PlaySound(1,5)
        Gosub Wait
      EndIf

      If CreateSound(2,100)
        PrintN("Create Sound...")
        len.l=GetSoundLength(2) : c.l=0

        Repeat
          If c.l & 1
            PokeSoundData(2,c.l,127)
          Else
            PokeSoundData(2,c.l,128)
          EndIf
          c.l+1
        Until c.l = len.l

        PrintN("")
        For c.l=0 To 99 Step 11
          Print ("Sound data nr.") : PrintNumber(c.l)
          Print(" = ") : PrintNumberN(PeekSoundData(2,c.l))
          Delay(5)
        Next
        PrintN("")

        SetSoundPeriod(2,550)
        SetSoundVolume(2,64)
        SetSoundChannels(2,15)

        If CopySound(2,3)
          PrintN("Copy Sound...")

          PrintN("Playing Sound 3...")
          PlaySound(3,-1) 
          Gosub Wait

          PrintN("Changeing Period...")
          per.w=550 : tmp.w=15

          For c.l=0 To 99
            VWait()
            per+tmp
            If per > 1300
              tmp=-15
            EndIf
            ChangeSoundPeriod(3,per)
          Next

          Gosub Wait
          PrintN("Changeing Volume...")
          vol.w=64 : tmp=-1

          For c.l=0 To 127
            VWait()
            vol+tmp
            If vol < 1
              VWait() : VWait()
              tmp=1
            EndIf
            ChangeChannelVolume(chan.w,vol)
          Next

          Delay(50)
          StopSound(3)
       
          If SaveSound(3,"Ram:Test.IFF")
            PrintN("Saving Sound to RamDisk...")
          EndIf

          For c.l=2 To 3
            FreeSound(c.l)
            Print("Delete Sound nr.") : PrintNumberN(c.l)
          Next

        EndIf

      EndIf

    Else
      PrintN("Can't allocate channels.")
    EndIf

  EndIf

  PrintN("End of Program.")
  End


Wait:
  Delay.l=0

  Repeat
    VWait() : VWait()
    Delay.l+1
  Until Delay.l = 75

  Return


sound: IncludeBinary "PureBasic:Examples/Data/Jump.IFF"

