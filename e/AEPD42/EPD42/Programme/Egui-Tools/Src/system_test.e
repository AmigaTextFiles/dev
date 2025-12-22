/* 
 *  Testing the >system.m<
 * -======================-
 * 
 */

MODULE  'tools/system'          -> The system-Module in this dir...

PROC main()                     -> The main-Procedure
 DEF    config:PTR TO syskonfig -> Variabledefinition
  NEW config.check()            -> INIT the Object and Check the Config
   WriteF(' System-Config:\n\n')-> Headline for the Config-Report
    WriteF(' CPU : \d\n',config.cpu)    -> Our Cpu-Type
     WriteF(' FPU : \d\n',config.fpu)   -> Our Fpu-Type
      WriteF(' Kick: \d\n',config.kick)   -> Our Kick-Version
   IF config.gfx=TRUE           -> Get the graphic-Mode...
    WriteF(' Gfx : OCS/ECS\n')  -> We have an OCS/ECS-Amiga...
   ELSE
    WriteF(' Gfx : AGA\n')      -> We have an AA-Machine...
   ENDIF
  END config                    -> Free the Memory for the Module
ENDPROC

