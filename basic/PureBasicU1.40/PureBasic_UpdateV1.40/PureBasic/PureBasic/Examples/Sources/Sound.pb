
; *********************************
;
; Sound example file for PureBasic
;
; © 1999 - Fantaisie Software -
;
; *********************************


#SOUNDS=3


  If InitSound(#SOUNDS)

    PrintN("4 Sound Object is Allocated.")

    If LoadSound(0,"PureBasic:Examples/Data/Bump.IFF")
      PrintN("Loading Sound.")
    Else
      PrintN("Can't find 'PureBasic:Examples/Data/Bump.IFF'")
    EndIf


    If DecodeSound(1,?sound)
      PrintN("Decode Sound.")
    EndIf


    If CreateSound(2,100)
      PrintN("Create Sound.")

      len.l=GetSoundLength(2) : c=0

      Repeat

        If c & 1
          PokeSoundData(2,c,127)
        Else
          PokeSoundData(2,c,128)
        EndIf

        c=c+1
      Until c = len

      For c=0 To 99 Step 11
        Print ("Sound data nr.") : PrintNumber(c)
        Print(" = ") : PrintNumberN(PeekSoundData(2,c))
      Next

      PrintN("")

      SetSoundPeriod(2,5000)
      SetSoundVolume(2,64)
      SetSoundChannels(2,15)

      If CopySound(2,3)
        PrintN("Copy Sound.")
      EndIf

    EndIf


    chan.w=AllocateSoundChannels(15)
    Print("Allocated channels = ") : PrintNumberN(chan)

    If chan

      PrintN("Playing Sound 0.")
      PlaySound(0,-1)
      Gosub LMB

      PrintN("Playing Sound 1.")
      PlaySound(1,5)
      Gosub LMB

      PrintN("Playing Sound 3.")
      PlaySound(3,-1)
      Gosub LMB

      PrintN("Changeing Period.")
      per.w=5000 : tmp.w=100

      For c=0 To 99

        VWait()
        per=per+tmp

        If per > 9900
          tmp=-100
        EndIf

        ChangeSoundPeriod(3,per)
      Next

      Gosub LMB
      PrintN("Changeing Volume.")
      vol.w=64 : tmp=-1

      For c=0 To 99

        VWait()
        vol=vol+tmp

        If vol < 15
          tmp=1
        EndIf

        ChangeSoundVolume(3,vol)
      Next

      Gosub LMB
      StopSound(3)

    EndIf

    If SaveSound(3,"Ram:Test.IFF")
      PrintN("Saving Sound to RamDisk.")
    EndIf

    For c.w=0 To #SOUNDS
      FreeSound(c)
      Print("Deleting Sound Object nr.") : PrintNumberN(c)
    Next c

  EndIf

  PrintN("End of Program.")
  End


LMB:
  PrintN(">> Press LMB to Continue <<")

  For c=0 to 24
    VWait()
  Next

  MouseWait()
  Return


sound: IncludeBinary "PureBasic:Examples/Data/Jump.IFF"

