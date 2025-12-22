
; *************************************
;
;  PTModule example file for PureBasic
;
;     © 2001 - Fantaisie Software -
;
; *************************************


Structure PTModule
  Status.w
  Mod_Nr.w
  Name.s
EndStructure

NewList Module.PTModule()


 Nr_Args.w=NumberOfCLIArgs()
 ptmods.l=Nr_Args.w-1

 If InitAudio() AND InitPTModule(ptmods.l) AND Nr_Args.w

   If AllocateAudioChannels(15)

     PrintN("All channels Allocated...")
     UseAsPTModuleChannels(15)

     For c.l=0 To ptmods.l
       AddElement(Module())
       name$=GetCLIArg(c.l+1)

       If LoadPTModule(c.l,name$)
         Module()\Mod_Nr=c.l
         Module()\Name=GetFilePart(name$)+"."
         At_Least_One_Module.w=1
       Else
         Module()\Status=-1
       EndIf
     Next


     If At_Least_One_Module.w

       FirstElement(Module())

       While Module()\Status = -1
         NextElement(Module())
       Wend

       Module()\Status=1
       PlayPTModule(Module()\Mod_Nr)

       Repeat

         VWait() : VWait()
         mb.w=MouseButtons()

         pos.w=GetPTModulePos()
         row.w=GetPTModuleRow()
         Print(" - Pos ") : PrintNumber(pos.w)
         Print(" - Row ") : PrintNumberN(row.w)

         If mb.w = 1

           PrintN("")
           PrintN(" - Pause Module: LMB  - Stop Module: RMB")
           Delay(15)

           Repeat
             VWait() : VWait()
             mb.w=MouseButtons()
           Until mb.w

           If mb.w = 1
             PausePTModule()
             VWait() : VWait()
           EndIf

           If mb.w = 2
             StopPTModule()
             Module()\Status=0
             VWait() : VWait()
           EndIf

           Repeat
             If NextElement(Module()) = 0
               FirstElement(Module())
             EndIf
           Until Module()\Status > -1

           s.w=0

           If Module()\Status = 0
             s.w=1 : Module()\Status=1
             PlayPTModule(Module()\Mod_Nr)
             PrintN("   Play "+Module()\Name)
           EndIf

           If Module()\Status = 1 AND s.w = 0
             ResumePTModule(Module()\Mod_Nr)
             PrintN("   Resume "+Module()\Name)
           EndIf

           PrintN("")
           Delay(20)
         EndIf

         If mb.w = 3
           QUIT.w=1
         EndIf

       Until QUIT.w

     EndIf

   Else
     PrintN("Can't Allocate Channels.")
   EndIf

 EndIf

 PrintN("End of Program.")
 End

; MainProcessor=0
; Optimizations=0
; CommentedSource=0
; CreateIcon=0
; NoCliOutput=0
; Executable=PureBasic:Examples/Sources/
; Debugger=1
