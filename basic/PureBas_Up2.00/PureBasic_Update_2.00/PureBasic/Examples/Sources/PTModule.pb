;
; ********************************************
;
; Protracker Module example file for PureBasic
;
;       © 2000 - Fantaisie Software -
;
; ********************************************
;
;

Structure PTModule
 Status.w : Mod_Nr.w
 Name.s
EndStructure

 NewList Module.PTModule()


 nr_args.w=NumberOfCLIArgs()

 If nr_args.w

   ptmods.l=nr_args.w-1

   If InitAudio() AND InitPTModule(ptmods.l) AND InitSound(0)

     If AllocateAudioChannels(15)

       For c.l=0 To ptmods.l
         AddElement(Module())
         name$=GetCLIArg$(c.l+1)

         CLR.l  d2 

         If LoadPTModule(c.l,name$)
           Module()\Mod_Nr=c.l
           Module()\Name="Module " + Str(c.l) + "."
         EndIf

       Next c.l

       LoadSound(0,"PureBasic:Examples/Data/Bump.IFF")

       pt_chan.w=15
       FirstElement(Module())
       UseAsPTModuleChannels(pt_chan.w)

       Module()\Status=1
       mod.w=Module()\Mod_Nr
       PlayPTModule(mod.w)

       Repeat

         VWait() : VWait()
         mb.w=MouseButtons()

         pos.w=GetPTModulePos()
         row.w=GetPTModuleRow()
         Print(" - Pos ") : PrintNumber(pos.w)
         Print(" - Row ") : PrintNumberN(row.w)


         If mb.w = 1

           PrintN("")
           PrintN(" - Module: LMB  - Sound: RMB")
           Delay(15)

           Repeat
             VWait() : VWait()
             mb.w=MouseButtons()
           Until mb.w

           If mb.w = 1

             PausePTModule()
             MOVE.w #15,$dff096

             If NextElement(Module()) = 0
               FirstElement(Module())
             EndIf

             mod.w=Module()\Mod_Nr

             If Module()\Status = 0
               PlayPTModule(mod.w)
               Module()\Status=1
               PrintN(" - Play "+Module()\Name)
             Else
               ResumePTModule(mod.w)
               PrintN(" - Resume "+Module()\Name)
             EndIf

           EndIf

           If mb.w = 2
             chan.w=PlaySound(0,1)
             If chan.w
               PrintN(" - Playing Sound...")
             Else
               PrintN(" - No channels...")
             EndIf
           EndIf

           mb.w=0 : Delay(25) 
         EndIf


         If mb.w = 2

           PrintN("")
           PrintN(" - Channel + 1: LMB  - Channel LSL 1: RMB")
           Delay(15)

           Repeat
             VWait() : VWait()
             mb.w=MouseButtons()
           Until mb.w

           If mb.w = 1
             (pt_chan.w+1) & 15
           EndIf


           If mb.w = 2
             pt_chan.w LSL 1 & 15
           EndIf

           s_chan.w=pt_chan.w & 15

           Print(" - PTModuleChannels=") : PrintNumber(pt_chan.w)
           UseAsPTModuleChannels(pt_chan.w)

           Print(" SoundChannels=") : PrintNumberN(s_chan.w)
           UseAsSoundChannels(s_chan.w)

           Delay(50)
         EndIf

       Until mb.w = 3


     Else
       PrintN("Can't Allocate Channels.")
     EndIf

   EndIf

 EndIf

 PrintN("End of Program.")
 End

