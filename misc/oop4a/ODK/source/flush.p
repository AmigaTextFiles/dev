    {* Include sys:coder/preass/Options.p *}
    {* String: Version="$VER: flush (C) CYBORG 2001"*}
    {* Array[Long]: Temp_Array,0,0,0,0,0,0*}

GetSigs[]:
    Signals=SetSignal(0,0)
    Signals==Signals&#$F000
    {* Return Signals*}

Start:
    If (Args=Readargs("seconds/N/A",&TemP_array,0))=0
     {  
       Printf("Usage: seconds/N/A\n")
       {* Return *}
     }
    seconds==Temp_array[0]
    seconds==(Seconds)
    FreeArgs(Args)
    ifelse seconds#0
     {
        While Getsigs()=0 
         {
            delay(seconds*50)
            execute("flushlibs >nil:",0,0)
         }
     }
     {
        printf("No timevalue given!\n")
     }
    {* Return *}
