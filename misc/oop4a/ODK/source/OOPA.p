; 
; 
; (c) 2001 Cyborg 

    {* Include sys:coder/preass/Options.p *}

    {* String: Version="$VER: OOPA (C) CYBORG 2001"*}

    {* Array[Long]: Temp_Array,0,0,0,0,0,0*}

    {* String: TemplateString="Name/A,args/K/F"*}

Start:
    If (Args=Readargs(&Templatestring,&TemP_array,0))=0
     {  
       Printf("Usage: %s\n",Templatestring)
       {* Return *}
     }
    Name_p==Temp_array[0]
    args_p==Temp_array[1]
    if name_P#0
     {
        if (Object=new(name_p,0))#0
         {
           res=Domethode(Object,"Main",>Tag:*args_P,0)
           if Res=-1
            {
              printf("%s does not contain methode Main()\n",*name_P)
            }
           del(object)
         }
        if object=0
         {
           printf("can not invoke methode %s.Main(\$22%s\$22)\nObject could not be created\n",*name_P,*args_p)
         }
     }
    {* Flush *}
    FreeArgs(Args)
    {* Return *}
