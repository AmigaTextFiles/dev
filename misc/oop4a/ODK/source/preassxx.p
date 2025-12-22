; Preass++ Präprozessor
;
; This software is freely copy&useable , but remains my propertie. 
;
; You are allowed to use this source to build other preprocessors 
; for the OOP4A Project. 
;
; http://www.geocities.com/SiliconValley/Bridge/5737
;
; You are not allowed to use the routines used within to build commercial
; products without my permission.
;
; I`m not responsible for any damage that's done to any piece of soft/hardware
; if you use any of this source or the resulting executable.
; 
; (c) 2001 Cyborg 

    {* Include sys:coder/preass/Options.p *}
    {* Include sys:coder/preass/Prozeduren.p *}
    {* Include sys:coder/Module/SPrintF.p *}

    {* String: Version="$VER: Preass++ 0.4 1 Dezember (C) CYBORG 2001"*}

    {* String: Leerzeile=" "*}

    {* Structure RDArgs(),CS_Buffer(APTR),CS_Lenght(LONG),CS_CurChr(LONG)
                      RDA_DAList(APTR),RDA_Buffer(LONG),RDA_BufSiz(LONG)
                      RDA_ExtHelp(APTR),RDA_Flags(LONG)*}


    {* Structure VarRoot,Name(APTR),type(LONG),ID(APTR),Public(LONG),next(APTR)*}
    {* Structure MethodeRoot,Name(APTR),Invalid(LONG),Counter(LONG),sync(LONG),static(LONG),abstract(LONG),public(LONG),private(LONG),protected(LONG),next(APTR)*}
    {* Structure LineRoot,Name(APTR),MethodeID(LONG),next(APTR)*}
    {* Structure ObjectRoot,Name(APTR),Klasse(APTR),ID(LONG),next(APTR)*}
    {* Structure ConstructorRoot,Name(APTR),Klasse(APTR),next(APTR)*}
    {* Structure StringRoot,Name(APTR),next(APTR)*}

    {* Incblock: Buffer,1025*}
    {* IncBlock: Classname,100*}
    {* IncBlock: Classname_2,100*}
    {* IncBlock: Extensename,100*}
    {* IncBlock: Store,1000*}
    {* IncBlock: StoreArgs,1000*}
    {* IncBlock: ClassStoreMem,1000*}

    {* Array[Long]: RDArgs_Array,0,0,0,0,0,0,0,0,0,0,0*}

    {* Array[String]: Registers,"keins","d0","d1","d2","d3","d4","d5","d6","d7","a0","a1","a2","a3","a4","a5",0*}

    {* NewProc=LineAnalyse[][a0,a1]*}

    {* IncVar: returnbefehl,IsComment,OldStack,Taglistennr,Variablen,Extense,Char,lena,Array,zeiger,abstract,public,private,protected,Methode,StaticStatus*}


; converts com.amiga.system.doswrapper -> com/amiga/system/doswrapper

BuildClassString[a0]:
    cmpi.b #".",(a0)
    bne .l1
    move.b #"/",(a0)
.l1:cmpi.b #$00,(a0)+
    bne BuildClassString
    RTS

; converts com/amiga/system/doswrapper -> com.amiga.system.doswrapper 

ReBuildClassString[a0]:
    cmpi.b #"/",(a0)
    bne .l1
    move.b #".",(a0)
.l1:cmpi.b #$00,(a0)+
    bne ReBuildClassString
    RTS

; removes LF at end of line 

RemoveLF[a0]:
    cmpi.b #$00,(a0)+
    bne RemoveLF
    cmpi.b #$0a,-2(a0)
    bne .rts1
    move.b #$00,-2(a0)
.rts1:
    cmpi.b #$0a,-1(a0)
    bne .rts
    move.b #$00,-1(a0)
.rts:
    RTS

;  AddObject(RootEntry,ObjectName,ClassName,MethodeID)
;  
;  Structure ObjectRoot,Name(APTR),Klasse(APTR),ID(LONG),next(APTR)
; 
;  adds a new objectentry to the end of the chained list of
;  objectentries. 
;
;  Each entry looks like the rootentry.
;
;  This routine is *highly* recursible. 
;

addObject[a0,A1,a2,D0]:
    {* StackFrame Root=a0,name=A1,classnames=a2,MethodeID=d0,next,zeiger,zeiger2=#0,len*}
    next=.lObjectRoot.next(Root)
    if Next=0
     {
        len=Strlen(Name)
        lena==len+1
        Next=malloc(sizeof(ObjectRoot),#MEMF_FAST!MEMF_CLEAR)
        zeiger=malloc(lena,#MEMF_FAST!MEMF_CLEAR)
        copymem(name,zeiger,len)

        if classnames#0
         {
            len=Strlen(Classnames)
            lena==len+1
            zeiger2=malloc(lena,#MEMF_FAST!MEMF_CLEAR)
            copymem(Classnames,zeiger2,len)
         }

        Zeiger=>Next.ObjectRoot.Name
        Zeiger2=>Next.ObjectRoot.Klasse
        MethodeID=>Next.ObjectRoot.ID
        0=>Next.ObjectRoot.Next
        Next=>Root.ObjectRoot.Next
        {* UnFrameReturn *}
     }
    AddObject(Next,name,Classnames,MethodeID)
    {* UnframeReturn *}  

;  AddConstructor(RootEntry,ObjectName,ClassName)
;  
;  Structure ConstructorRoot,Name(APTR),Klasse(APTR),next(APTR)
; 
;  adds a new constructorentry to the end of the chained list of
;  constructorentries. 
;
;  Each entry looks like the rootentry.
;
;  This routine is *highly* recursible. 
;

addConstructor[a0,A1,a2]:
    {* StackFrame Root=a0,name=A1,classnames=a2,next,zeiger,zeiger2=#0,len*}
    next=.lConstructorRoot.next(Root)
    if Next=0
     {
        len=Strlen(Name)
        lena==len+1
        Next=malloc(sizeof(ConstructorRoot),#MEMF_FAST!MEMF_CLEAR)
        zeiger=malloc(lena,#MEMF_FAST!MEMF_CLEAR)
        copymem(name,zeiger,len)

        if classnames#0
         {
            len=Strlen(Classnames)
            lena==len+1
            zeiger2=malloc(lena,#MEMF_FAST!MEMF_CLEAR)
            copymem(Classnames,zeiger2,len)
         }

        Zeiger=>Next.ConstructorRoot.Name
        Zeiger2=>Next.ConstructorRoot.Klasse
        0=>Next.ConstructorRoot.Next
        Next=>Root.ConstructorRoot.Next
        {* UnFrameReturn *}
     }
    AddConstructor(Next,name,Classnames)
    {* UnframeReturn *}  

;  makeSubString(from,to,length)
;
;  copies from to length bytes and adds a NULL at the end to make 
;  a Null-terminated-String out of it.

makeSubString[a0,a1,d0]:
    {* StackFrame a=a0,b=a1,c=d0*}
    copymem(a,b,c)
    copymem("\$00",b+c,1)
    {* UnFrameReturn *}

;  CalcOBS(VarRoot)
;
;  calculates the size thats been used when this object is
;  constructed.
;
;  This routine is *highly* recursible. 

calcOBS[d0]:
    {* StackFrame Root=d0,next,name,ID,res*}
    name=.lVarRoot.name(root)
    ID=.lVarRoot.ID(root)
    next=.lVarRoot.next(Root)
    
    if next=0 
     {
       {* UnFrameReturn 4*}
     }
    if next#0 
     {
       res=calcOBS(next)
       if ID=0
        {
          res==Res+4
        }
     }
    {* UnFrameReturn Res*}

; Stringfind2(String)
;
; seek "," , ")" , "\$00" in the String
;
;


Stringfind2[a0]:
    move.l #0,d2
.l0:cmpi.b #$22,(a0)
    beq .klammer
    cmpi.b #",",(a0)
    beq .ok
    cmpi.b #")",(a0)
    beq .ok
    cmpi.b #0,(a0)
    beq .ok2
    cmpi.b #"+",(a0)
    beq .l3
    cmpi.b #"-",(a0)
    beq .l3
    cmpi.b #"*",(a0)
    beq .l3
    cmpi.b #"/",(a0)
    beq .l3
.l2:lea 1(a0),a0
    bra .l0
.l3:move.b (a0),d2
    bra.s .l2
.ok:move.l a0,d0
    clr.l d1
    move.b (a0),d1
    rts
.ok2:move.l #0,d0
     move.l d0,d1
     rts
.klammer:
    lea 1(a0),a0
.l1:cmpi.b #$22,(a0)+
    bne .l1
    bra .l0

; SeekClosingbracket(String)
;
; seek ")" in the String
;
;


SeekClosingbracket[a0]:
    move.l #0,d2
.l0:cmpi.b #$22,(a0)
    beq .klammer
    cmpi.b #")",(a0)
    beq .ok
    cmpi.b #$00,(a0)
    beq .ok2
    lea 1(a0),a0
    bra .l0
.ok:move.l a0,d0
    clr.l d1
    move.b (a0),d1
    rts
.ok2:move.l #0,d0
     move.l d0,d1
     rts
.klammer:
    lea 1(a0),a0
.l1:cmpi.b #$22,(a0)+
    bne .l1
    bra .l0


;  PrintPublicMethoden(MethodeRoot,OutputMode)
; 
;  generates the jumptableentries for the librarypart in Mode = 0,
;  the functionnames in the PublicFunctionStringArray in Mode = 1
;                           and the MethodeSignatures in Mode = 2.
;
;  This routine is *highly* recursible. 


PrintPublicMethoden[d0,d1]:
    {* StackFrame Root=d0,mode=d1,next,name,public,pos,mypos,char,counter*}
    name=.lMethodeRoot.name(root)
    public=.lMethodeRoot.public(root)
    next=.lMethodeRoot.next(Root)
    counter=.lMethodeRoot.Counter(Root)
    
    if public#0
     {
        pos=Stringfind(name,"(")
        makeSubString(name,&buffer,pos-name)
        if mode=0
         {
           printf("    dc.l %s_%ld\n",Buffer,*Counter)
         }
        if mode=1
         {
           printf(",\$22%s\$22",Buffer)
         }
        if mode=2
         {
           pos==pos+1
           char=.b0(pos)
           printf(",\$22")
           while char#$29
            { 
                if (mypos=Stringfind(pos," "))=0 breakwhile
                makeSubString(pos,&buffer,mypos-pos)
                printf("%s",Buffer)
                if (pos=Stringfind(mypos,","))=0 breakwhile
            }
           printf("\$22")

         }
     }
    if next#0 
     {
       PrintPublicMethoden(next,mode)
     }
    {* UnFrameReturn *}

;  PrintAbstractMethoden(MethodeRoot)
;
;  prints out all abstract methodes, which are left after compiling
;  the source, to let the programmer know WHY he couldn`t compile 
;  the class. 
;
;  This routine is *highly* recursible


PrintAbstractMethoden[d0]:
    {* StackFrame Root=d0,next,mname,public,abstract,protected,private,static*}
    next=.lMethodeRoot.next(Root)
    mname=.lMethodeRoot.name(root)
    static=.lMethodeRoot.static(root)
    public=.lMethodeRoot.public(root)
    private=.lMethodeRoot.private(root)
    abstract=.lMethodeRoot.abstract(root)
    Protected=.lMethodeRoot.protected(root)
    if abstract#0
     {
        printf("abstract ")
        if static#0
         {
            printf("static ")
         }
        if public#0
         {
            printf("public ")
         }
        if protected#0
         {
            printf("protected ")
         }
        if private#0
         {
            printf("private ")
         }
        printf("%s\n",*mname)
     }
    if next#0 
     {
       PrintAbstractMethoden(next)
     }
    {* UnFrameReturn *}

PrintVar[d0,d1,d2,d3]:
    {* StackFrame Root=d0,Handle=d1,givenID=d2,mode=d3,public,next,mname,type,id*}
    next=.lVarRoot.next(Root)
    mname=.lVarRoot.name(root)
    type=.lVarRoot.type(root)
    id=.lvarRoot.id(Root)
    public=.lvarRoot.Public(root)

    if public#0
     {
       if id=givenid
        {
           if mode=0 
            {
              Fputs(Handle,",")
            }
           if mode=1
            {
              Fputs(Handle,"\$09")
            }
           if type=1
            {
               Fputs(Handle,"long ")
            }
           if type=2
            {
               Fputs(Handle,"long_p ")
            }
           Fputs(Handle,mname)
           if mode=1 
            {
              Fputs(Handle,"\n")
            }
        }
     }

    if next#0 
     {
       PrintVar(next,Handle,givenID,mode)
     }
    {* UnFrameReturn *}

PrintObject[d0,d1,d2,d3]:
    {* StackFrame Root=d0,Handle=d1,givenID=d2,mode=d3,next,mname,Klasse,id*}
    next=.lObjectRoot.next(Root)
    mname=.lObjectRoot.name(root)
    Klasse=.lObjectRoot.Klasse(root)
    id=.lObjectRoot.id(Root)    

    if id=givenid
     {
       if Klasse#0
        {
          if mode=0
           {
               Fputs(Handle,",Object ")
               ReBuildClassString(Klasse)
               Fputs(Handle,Klasse)
               Fputs(Handle," ")
               Fputs(Handle,mname)
           }
          if mode=1
           {
               Fputs(Handle,"\$09Object ")
               ReBuildClassString(Klasse)
               Fputs(Handle,Klasse)
               Fputs(Handle," ")
               Fputs(Handle,mname)
               Fputs(Handle,"\n")
           }
        }
     }

    if next#0 
     {
       PrintObject(next,Handle,givenID,Mode)
     }
    {* UnFrameReturn *}

PrintMethoden[d0,d1]:
    {* StackFrame Root=d0,Handle=d1,next,mname,public,abstract,protected,private,static*}
    next=.lMethodeRoot.next(Root)
    mname=.lMethodeRoot.name(root)
    static=.lMethodeRoot.static(root)
    public=.lMethodeRoot.public(root)
    private=.lMethodeRoot.private(root)
    abstract=.lMethodeRoot.abstract(root)
    Protected=.lMethodeRoot.protected(root)
    if mname#0
     {
        if static#0
         {
            Fputs(Handle,"static ")
         }
        if abstract#0
         {
            Fputs(Handle,"abstract ")
         }
        if public#0
         {
            Fputs(Handle,"public ")
         }
        if protected#0
         {
            Fputs(Handle,"protected ")
         }
        if private#0
         {
            Fputs(Handle,"private ")
         }
        Fputs(Handle,mname)
        Fputs(Handle,"\$09 { Object This")
        printObject(ObjectRoot,Handle,Root,0)
        printVar(VarRoot,Handle,Root,0)
        Fputs(Handle," }\n")
      }
    if next#0 
     {
       PrintMethoden(next,Handle)
     }
    {* UnFrameReturn *}


findAbstractMethoden[d0]:
    {* StackFrame Root=d0,next,abstract,res=#0*}
    next=.lMethodeRoot.next(Root)
    abstract=.lMethodeRoot.abstract(root)
    if next#0 
     {
       res=FindAbstractMethoden(next)
     }
    if abstract#0
     {
       res==Res+1
     }
    {* UnFrameReturn Res*}


addLine2[a0,A1,D0]:
    {* StackFrame Root=a0,name=A1,MethodeID=d0,next,zeiger,len*}
    next=.lLineRoot.next(Root)
    if Next=0
     {
        removeLF(Name)
        len=Strlen(Name)
        lena==len+1
        Next=malloc(sizeof(LineRoot),#MEMF_FAST!MEMF_CLEAR)
        zeiger=malloc(lena,#MEMF_FAST!MEMF_CLEAR)
        copymem(name,zeiger,len)

        Zeiger=>Next.LineRoot.Name
        MethodeID=>Next.LineRoot.MethodeID
        0=>Next.LineRoot.Next
        Next=>Root.LineRoot.Next
        {* UnFrameReturn *}
     }
    AddLine2(Next,name,MethodeID)
    {* UnframeReturn *}  

isSync[d0,d1]:
    {* StackFrame MethodeID=d1,Sync,res,ID,Root=d0,next*}
    
    sync=.lMethodeRoot.sync(root)
    next=.lMethodeRoot.next(Root)
    
    if Root=methodeid and sync#0
     {
        {* unFrameReturn 1*}    
     } 
    if Next#0
     {
        res=isSync(next,MethodeID)
        {* Unframereturn res*}
     }
    {* UnFrameReturn 0*}   


SpeichereInstanzVariablen[a0]:
    {* StackFrame root=a0,id,next,name*}
    if root=0 
     {
        {* UnFrameReturn *}
     }
    name=.lVarRoot.Name(root)
    id=.lVarRoot.ID(root)
    next=.lVarRoot.Next(Root)
    if id=0
     {
       if name#0 and strlen(name)#0
        {
           Sprintf(&store,"\$09%s=>this.%s.%s",>spfSIV:*name,Classname,*name,0)
           AddLine2(LineRoot,&Store,MethodeID)
        }
     }
    if next=0 and isSync(MethodeRoot,methodeID)#0
     {
           AddLine2(LineRoot,"\$09ReleaseSemaphore(&syncronizationstruct)\n",MethodeID)
     }
    if next#0
     {
       SpeichereInstanzVariablen(next)
     }
    {* UnFrameReturn *}

PrintInstanzVariablen[a0,d0]:
    {* StackFrame root=a0,MethodeID=d0,id,next,name*}
    if root=0 
     {
        {* UnFrameReturn *}
     }
    name=.lVarRoot.Name(root)
    id=.lVarRoot.ID(root)
    next=.lVarRoot.Next(Root)
    if id=0
     {
       if name#0 and strlen(name)#0
        {
          printf("\$09%s=>this.%s.%s\n",*name,Classname,*name)
        }
     }
    if next#0
     {
       PrintInstanzVariablen(next,MethodeID)
     }
    {* UnFrameReturn *}

getInstanzVariablen[a0]:
    {* StackFrame root=a0,next,name*}
    if root=0 
     {
        {* UnFrameReturn *}
     }
    name=.lVarRoot.Name(root)
    id=.lVarRoot.ID(root)
    next=.lVarRoot.Next(Root)
    if id=0
     {
       if name#0 and strlen(name)#0
        {
           printf(",%s",*name)
        }
     }
    if next#0
     {
       getInstanzVariablen(next)
     }
    {* UnFrameReturn *}
    

LadeInstanzVariablen[a0,d0]:
    {* StackFrame root=a0,methodeID=d0,next,name,id*}
    if root=0 
     {
        {* UnFrameReturn *}
     }
    name=.lVarRoot.Name(root)
    id=.lVarRoot.ID(root)
    next=.lVarRoot.Next(Root)
    if id=0
     {
       if name#0 and strlen(name)#0
        {
           printf("\$09%s=.l%s.%s(this)\n",*name,Classname,*name)
        }
     }
    if next=0 and isSync(MethodeRoot,methodeID)#0
     {
       printf("\$09ObtainSemaphore(&syncronizationstruct)\n")
     }

    if next#0
     {
       LadeInstanzVariablen(next,MethodeID)
     }
    {* UnFrameReturn *}


checkvar[a0,A1,d1]:
    {* StackFrame Root=a0,name=A1,MethodeID=d1,next,zeiger,res,id*}

    zeiger=.lVarRoot.name(Root)
    id=.lVarRoot.id(Root)
        
    if zeiger#0
     {
        res=CompareString(Name,Zeiger,0,#Mode_NoCase)
        if Res=0 or id#MethodeID 
         {
            next=.lvarRoot.next(Root)
            if next=0
             {
                {* UnFrameReturn 0*}
             }
            res=CheckVar(Next,name,MethodeID)
            {* UnFrameReturn Res*}
         }
     }  
    {* UnframeReturn 1*}  


istZahl[a0]:
	clr.l d0
	move.b (a0),d1			; Check ob es eine Zahl
	cmpi.b #`$`,d1			; ist(kann auch mit $xxx anfangen)
	beq.b .label1b			; wenn ja automatisch ein # setzen!
	cmpi.b #`-`,d1
	beq.b .label1b
	cmpi.b #`#`,d1
	beq.b .label1b
	subi.b #$30,d1
	cmpi.b #9,d1
	bgt.b .label2
	cmpi.b #0,d1
	blt.b .label2
.label1b:
	move.l #1,d0
.label2:
    rts


addString[a0,d0,d1]:
    {* StackFrame Root=a0,von=d0,bis=d1,next,zeiger,len,name1*}
    next=.lStringRoot.next(Root)
    if Next=0
     {
        len==bis-von
        lena==len+1
        Next=malloc(sizeof(StringRoot),#MEMF_FAST!MEMF_CLEAR)
        zeiger=malloc(lena,#MEMF_FAST!MEMF_CLEAR)
        copymem(von,zeiger,len)

        Zeiger=>Next.StringRoot.Name
        0=>Next.StringRoot.Next
        Next=>Root.StringRoot.Next
        {* UnFrameReturn 1*}
     }
    len=AddString(Next,von,bis)
    len==Len+1
    {* UnframeReturn len*}

addvar[a0,A1,D0,d1,d2]:
    {* StackFrame Root=a0,name=A1,type=d0,MethodeID=d1,public=d2,next,zeiger,len*}
    next=.lvarRoot.next(Root)
    if Next=0
     {
        len=Strlen(Name)
        lena==len+1
        Next=malloc(sizeof(VarRoot),#MEMF_FAST!MEMF_CLEAR)
        zeiger=malloc(lena,#MEMF_FAST!MEMF_CLEAR)
        copymem(name,zeiger,len)

        Zeiger=>Next.varRoot.Name
        Type=>Next.varRoot.Type
        MethodeID=>Next.varRoot.ID
        Public=>Next.varRoot.Public
        0=>Next.varRoot.Next
        Next=>Root.varRoot.Next
        {* UnFrameReturn *}
     }
    AddVar(Next,name,type,MethodeID,Public)
    {* UnframeReturn *}  

GetObjectArgs[a0,a1,d0,d1,d2]:
    {* StackFrame von=a0,nach=a1,len=d0,mode=d2,pos,char,nummer,methodeID=d1*}

    if (pos=Stringfind(von,"\n"))#0
     {
        copymem("\$00",pos,1)
     }
    fillbuffer(&StoreArgs,0,len+2)    
    copymem(von,&storeArgs,len+1)
    von==#StoreArgs
    
    While Strlen(von)>0
     {    
        char=.b0(von)
        if char=#$22
         {
           Fillbuffer(&store,0,200)
           pos=Stringfind(von+1,"\$22")
           Nummer=AddString(Stringroot,von+1,pos-1)
           Copymem(von+1,&store,pos-von-1)
           printf("\$09{* String: Preassxx%ld=\$22%s\$22*}\n",*nummer,store)
           if mode=0
            {
              AddLine2(LineRoot,&ObjectPuffer,MethodeID)
            }
           sprintf(nach,"Preassxx%ld,",>spfgoa2:*nummer,0)
           nummer=strlen(nach)
           nach==nach+nummer
           von==pos+2
           {* UnCase *}
         }
        if (pos=stringfind(von,","))=0
         {
           if (pos=stringfind(von,"\$29"))=0
            {
                        {* UnFrameReturn 0*}
            }
         }

        if IstZahl(von)=1
         {
           char=.b0(von)
           if char=#"#" 
            {
              von==von+1
            }
           Copymem(von,nach,pos-von)
           nach==Nach+pos-von
           von==pos+1
           if strlen(von)>0
            {
              Copymem(",",nach,1)
              nach==nach+1
            }
           {* UnCase *}
         }
        Copymem("*",nach,1)
        Copymem(von,nach+1,pos-von)
        nach==Nach+pos-von+1
        von==pos+1
        if strlen(von)>0
         {
           Copymem(",",nach,1)
           nach==nach+1
         }
      } 
    char=.b-1(nach)
    if char=#$2c
     {
       nach==nach-1
       (#0)->nach
     }
    {* UnFrameReturn -1*}
      

CopyOverlay[a0,a1]:
    move.l a1,d7
    sub.l a0,d7
    subq.l #1,d7
    move.l a0,a2
.l0:cmpi.b #$0,(a2)+
    bne .l0
    move.l a2,d6
    sub.l a0,d6
    add.l d6,a1
.l2:move.b (a2),d0
    move.b d0,(a1)
    lea -1(a2),a2
    lea -1(a1),a1
    cmpa.l a0,a2
    bne .l2
    RTS

PreProcessDoMethode[d0,a1,a2,a3]:
    {* Stackframe MethodeID=d0,pos,len,lenv,lens,von,operand,char,punkt=a1,klammer=a2,klammer2=a3,nextarg,char*}

    While Stringfind(klammer2,".")#0
     {
       if klammer+1#Klammer2
        {
          nextarg==1
          While NextArg#0
          {  
           (nextarg,char,Operand)=Stringfind2(Klammer+1)
           if char#0
            {
              if operand#0
               {
                 len==nextarg-Klammer-1

                 makeSubString(Klammer+1,&Store,len)
                 Sprintf(&Objectpuffer,"\$09var%ld==%s",>spfPPDM1:*TaglistenNr,Store,0)
                 AddLine2(LineRoot,&ObjectPuffer,MethodeID)
                 Sprintf(&Store,"var%ld",>spfPPDM2:*TaglistenNr,0)
                 lenv=Strlen(&Store)
                 lens=Strlen(nextarg)
                 Ifelse lenv>len
                  {
                    CopyOverlay(nextarg,nextarg+lenv-len)
                  }
                  {
                    Copymem(nextarg,klammer+1+lenv,lens)
                    nextarg==klammer
                  }
                 Copymem(&Store,klammer+1,lenv)
                 Taglistennr==Taglistennr+1
                 AddVar(VarRoot,&Store,1,MethodeID,0)
               }
              klammer==nextarg
              if char=#$29
               {
                         nextarg==0
               }
            }  
               
          }
        }
        punkt=Stringfind(Klammer2,".")
        klammer=Stringfind(klammer2,"(")
        klammer2=seekClosingBracket(klammer)
      }
     if klammer+1#Klammer2
      {
          nextarg==1
          While NextArg#0
          {  
           (nextarg,char,Operand)=Stringfind2(Klammer+1)
           if char#0
            {
              if operand#0
               {
                 len==nextarg-Klammer-1

                 makeSubString(Klammer+1,&Store,len)
                 Sprintf(&Objectpuffer,"\$09var%ld==%s",>spfPPDM3:*TaglistenNr,Store,0)
                 AddLine2(LineRoot,&ObjectPuffer,MethodeID)
                 Sprintf(&Store,"var%ld",>spfPPDM4:*TaglistenNr,0)
                 lenv=Strlen(&Store)
                 lens=Strlen(nextarg)
                 Ifelse lenv>len
                  {
                    CopyOverlay(nextarg,nextarg+lenv-len)
                  }
                  {
                    Copymem(nextarg,klammer+1+lenv,lens)
                    nextarg==klammer
                  }
                 Copymem(&Store,klammer+1,lenv)
                 Taglistennr==Taglistennr+1
                 AddVar(VarRoot,&Store,1,MethodeID,0)
               }
              klammer==nextarg
              if char=#$29
               {
                 nextarg==0
               }
            }  
               
          }
      }

    {* UnFrameReturn *}

Praeprozessor[a0,d0]:
    {* incBlock: Objectpuffer,1000*}
    {* incBlock: Objectmethode,200*}
    {* incBlock: Objectargs,200*}
    {* incBlock: ObjectPre,200*}
    {* StackFrame Zeile=a0,MethodeID=d0,Args,Return,punkt,klammer,klammer2,Pos,pos1,pos2,gleichpos,mem,next,Object*}
    
    mem==#Store

    Fillbuffer(mem,0,1000)

    (args,return)=LineAnalyse(&Buffer,"return/K/A")
    if args#0
     {
       if Return#0
        {
          next=.lVarRoot.next(SecondvarRoot)
          SpeichereInstanzVariablen(next)
          Sprintf(mem,"\$09{* UnFrameReturn %s *}",>spft2:*return,0)
          FreeArgs(Args)
          {* UnFrameReturn mem*}
        }
       FreeArgs(Args)
     }
    
    Object=.lObjectRoot.next(ObjectRoot)
    While Object#0
     {
       name=.lObjectRoot.name(Object)
       Sprintf(&ObjectPuffer,"=%s.",>spfot1:*name,0)
       pos=StringFind(&Buffer,&ObjectPuffer))#0
       Sprintf(&ObjectPuffer," %s.",#spfot1)
       pos1=StringFind(&Buffer,&ObjectPuffer)
       Sprintf(&ObjectPuffer,"\$09%s.",#spfot1)
       pos2=StringFind(&Buffer,&ObjectPuffer)

       if pos!pos1!pos2#0
        {
          punkt=Stringfind(&Buffer,".")
          klammer=Stringfind(&Buffer,"(")
          klammer2=SeekClosingbracket(&Buffer)

          PreProcessDoMethode(MethodeID,punkt,klammer,klammer2)

          Sprintf(&Objectpuffer,"\$09move.l %s,d0",>spfmethods1:*name,0)
          Addline2(LineRoot,&ObjectPuffer,MethodeID)
          
          Fillbuffer(&Objectmethode,0,200)
          Fillbuffer(&Objectargs,0,200)
          Fillbuffer(&Objectpre,0,200)

          While Stringfind(klammer2,".")#0
           {
              Fillbuffer(&Objectmethode,0,200)
              Fillbuffer(&Objectargs,0,200)
              Copymem(punkt+1,&Objectmethode,klammer-punkt-1)
              if klammer+1=Klammer2
               {
                 Sprintf(&Objectpuffer,"\$09Domethode(d0,\$22%s\$22,0)",>spfmethods2:ObjectMethode,0)
               }    
              if klammer+1#Klammer2
               {
                 getObjectArgs(klammer+1,&Objectargs,klammer2-klammer-1,MethodeID,0)
                 Sprintf(&Objectpuffer,"\$09Domethode(d0,\$22%s\$22,>obtl%ld:%s,0)",>spfmethods3:ObjectMethode,*TaglistenNr,Objectargs)
                 Taglistennr==Taglistennr+1
               }
              AddLine2(LineRoot,&ObjectPuffer,MethodeID)
              punkt=Stringfind(Klammer2,".")
              klammer=Stringfind(klammer2,"(")
              klammer2=SeekClosingbracket(klammer)
            }
           Fillbuffer(&Objectmethode,0,200)
           Fillbuffer(&Objectargs,0,200)
           Copymem(punkt+1,&Objectmethode,klammer-punkt-1)
           If Pos#0
            {
              Copymem(&buffer,&ObjectPre,pos-#buffer+1)
            }
           if klammer+1=Klammer2
            {
              Sprintf(&Objectpuffer,"\$09%sDomethode(d0,\$22%s\$22,0)",>spfmethods4:ObjectPre,ObjectMethode)
            }
           if klammer+1#Klammer2
            {
              getObjectArgs(klammer+1,&Objectargs,klammer2-klammer-1,MethodeID,0)
              Sprintf(&Objectpuffer,"\$09%sDomethode(d0,\$22%s\$22,>obtl%ld:%s,0)",>spfmethods5:ObjectPre,ObjectMethode,*TaglistenNr,Objectargs)
              Taglistennr==Taglistennr+1
            }
           AddLine2(LineRoot,&ObjectPuffer,MethodeID)
           Zeile==#LeerZeile
        } 
       Object=.lObjectRoot.next(Object)
     }

    {* UnFrameReturn Zeile*} 

addLine[a0,A1,D0]:
    {* StackFrame Root=a0,name=A1,MethodeID=d0,next,zeiger,len,name1*}
    next=.lLineRoot.next(Root)
    if Next=0
     {
        name1=Praeprozessor(name,MethodeID)
        if name1#name
         {
           next=.lLineRoot.next(Root)
           while next#0
            {
              root==Next
              next=.lLineRoot.next(next)
            }
           name==name1
         }
        removeLF(Name)
           
        len=Strlen(Name)
        lena==len+1
        Next=malloc(sizeof(LineRoot),#MEMF_FAST!MEMF_CLEAR)
        zeiger=malloc(lena,#MEMF_FAST!MEMF_CLEAR)
        copymem(name,zeiger,len)

        Zeiger=>Next.LineRoot.Name
        MethodeID=>Next.LineRoot.MethodeID
        0=>Next.LineRoot.Next
        Next=>Root.LineRoot.Next
        {* UnFrameReturn *}
     }
    AddLine(Next,name,MethodeID)
    {* UnframeReturn *}  

AddConstructoren[a0,d0]:
    {* StackFrame Root=a0,name,class,next,zeiger,zeiger2,ID=d0,len*}
    name=.lConstructorRoot.name(Root)
    if name#0
     {
        class=.lConstructorRoot.Klasse(Root)
        Sprintf(&Objectpuffer,"\$09%s=new(\$22%s\$22,0)",>spfac1:*name,*Class,0)
        AddLine2(LineRoot,&Objectpuffer,ID)
     }
    next=.lConstructorRoot.next(Root)
    if Next#0
     {
        AddConstructoren(Next,ID)
     }
    {* UnframeReturn *}  

PrintConstructoren[a0,d0]:
    {* StackFrame Root=a0,name,class,next,zeiger,zeiger2,ID=d0,len,von*}
    next=.lConstructorRoot.next(Root)
    if next=0 
     {
       {* UnFrameReturn *}
     }
    Name=.lConstructorRoot.name(next)
    von==#ObjectPuffer
    SPrintf(&Objectpuffer,"\$09if ",0)
    len=Strlen(&ObjectPuffer)
    von==len+#ObjectPuffer
        
    While next#0
     {    
        Name=.lConstructorRoot.name(next)
        Class=.lConstructorRoot.Klasse(next)
        SPrintf(von,"%s&",>spfpc1:*name,0)
        len=Strlen(&ObjectPuffer)
        von==len+#ObjectPuffer
        next=.lConstructorRoot.next(next)
     }
    von==von-1
    SPrintf(von,"=0\n\$09{",0)

    AddLine2(LineRoot,&Objectpuffer,ID)
    next=.lConstructorRoot.next(Root)
    While next#0
     {    
        Name=.lConstructorRoot.name(next)
        Class=.lConstructorRoot.Klasse(next)
        SPrintf(&Objectpuffer,"\$09  del(%s)   ",>spfpc3:*name,0)
        next=.lConstructorRoot.next(Next)
        AddLine2(LineRoot,&Objectpuffer,ID)
     }
    SPrintf(&ObjectPuffer,"\$09\$7b* UnFrameReturn -1*\$7d\n",>spfpc4:*name,0)
    AddLine2(LineRoot,&Objectpuffer,ID)
    AddLine2(LineRoot,"\$09}\n",ID)       ; *** DON`t REMOVE THIS !!!! ***
    {* UnframeReturn *}  

AddDeConstructoren[a0,d0]:
    {* StackFrame Root=a0,name,class,next,zeiger,zeiger2,ID=d0,len*}
    name=.lConstructorRoot.name(Root)
    if name#0
     {
        class=.lConstructorRoot.Klasse(Root)
        Sprintf(&Objectpuffer,"\$09  %s=del(%s)    ",>spfad1:*name,*name,0)
        AddLine2(LineRoot,&Objectpuffer,ID)
     }
    next=.lConstructorRoot.next(Root)
    if Next#0
     {
        AddDeConstructoren(Next,ID)
     }
    {* UnframeReturn *}  

CompareStringKlammerauf[a0,a1]:
    clr.l d0
    clr.l d1
    tst.l a0
    beq .error
    tst.l a1
    beq .error
.l1:
    move.b (a0)+,d0
    move.b (a1)+,d1
    cmpi.b d0,d1
    bne .error
    cmpi.b #"(",d0
    beq .ende
    cmpi.b #$00,d0
    beq .error
    bra.s .l1
.error:
    moveq.l #0,d0
    rts
.ende:
    moveq.l #-1,d0
    rts


addMethode[a0,A1,D0,d1,d2,d3,d4,d5,d6]:
    {* StackFrame Root=a0,name=A1,public=d0,private=d1,protected=d2,abstract=d3,static=d4,sync=d5,counter=d6,next,zeiger,len,return,isabstract*}
    zeiger=.lMethodeRoot.Name(Root)
    isabstract=.lMethodeRoot.abstract(Root)
    if isabstract#0 and abstract=0 
     {
       if comparestring(name,zeiger,0,#MODE_CASE)#0
        {
          0=>Root.MethodeRoot.abstract
          {* UnFrameReturn Root*}
        }
     }
    if comparestringKlammerauf(name,zeiger)#0
     {
        Counter==Counter+1
     }
    if CompareString(Name,zeiger,0,#MODE_CASE)#0
     {
        1=>Root.MethodeRoot.invalid
     }
    next=.lMethodeRoot.next(Root)
    if Next=0
     {
        len=Strlen(Name)
        lena==len+1
        Next=malloc(sizeof(MethodeRoot),#MEMF_FAST!MEMF_CLEAR)
        zeiger=malloc(lena,#MEMF_FAST!MEMF_CLEAR)
        copymem(name,zeiger,len)

        0=>Next.MethodeRoot.invalid
        sync=>Next.MethodeRoot.sync
        Zeiger=>Next.MethodeRoot.Name
        public=>Next.MethodeRoot.public
        static=>Next.MethodeRoot.static
        counter=>Next.MethodeRoot.Counter
        private=>Next.MethodeRoot.private
        abstract=>Next.MethodeRoot.abstract
        protected=>Next.MethodeRoot.protected
        0=>Next.MethodeRoot.Next
        Next=>Root.MethodeRoot.Next

        {* UnFrameReturn Next*}
     }
    return=AddMethode(Next,name,public,private,protected,abstract,static,sync,Counter)
    {* UnframeReturn Return*}  

FoundMethode[a0,A1]:
    {* StackFrame Root=a0,name=A1,next,zeiger,res*}
    next=.lMethodeRoot.next(Root)
    zeiger=.lMethodeRoot.name(Root)
    if zeiger#0
     {
        if StrCmp(zeiger,name)=0
         {
           {* UnFrameReturn Root*}
         }
     }
    if Next=0
     {
        {* UnFrameReturn 0*}
     }
    Res=FoundMethode(Next,name)
    {* UnframeReturn Res*}  

myStringfind[a0,a1,d0]:
    {* StackFrame arg1=a0,arg2=a1,skip=d0,res*}
    res=Stringfind(arg1,arg2)
    if Res=0
     {
           {* UnFramereturn 0*}
     }
    if skip>0
     {
           {* UnFramereturn 0*}
     }
    {* UnFrameReturn 1*}

DeComment[a0,d1]:
    nop
.l0:cmpi.w #"//",(a0)
    beq .treffer
    cmpi.w #"/*",(a0)
    bne .l1
    add.l #1,d1
.l1:cmpi.w #"*/",(a0)
    bne .l2
    sub.l #1,d1
    move.w #$2020,(a0)
.l2:
    cmpi.b #$22,(a0)
    beq .hacken
    cmpi.b #$00,(a0)
    beq .ende
    cmpi.b #$0a,(a0)
    beq .l3
    cmpi.l #0,d1
    beq .l3
    move.b #$20,(a0)
.l3:lea 1(a0),a0
    bra .l0
.ende:
    move.l d1,d0
    RTS    
.hacken:
    cmpi.l #0,d1
    beq .l4
    move.b #$20,(a0)
.l4:lea 1(a0),a0
    cmpi.b #$22,(a0)
    bne .hacken
    cmpi.l #0,d1
    beq .l5
    move.b #$20,(a0)
.l5:lea 1(a0),a0
    bra .l0
.treffer:
    cmpi.b #$0,(a0)
    beq .ende
    cmpi.b #$A,(a0)
    beq .ende
    move.b #$20,(a0)+
    bra.s .treffer

ClassBodyAnalyse[d0]:
    {* StackFrame Classhandle=d0,args,Nummer,Class,String,sync,static,Objecte,skip=#1,A=#0,mem*}

    if Fgets(Classhandle,&Buffer,1024)#0
     {
       IsComment=DeComment(&Buffer,IsComment)
       if stringfind(&Buffer,"\$7b")=0
        {
          {* UnFrameReturn 1*}
        } 
       While A=0
        {
          if FGets(Classhandle,&Buffer,1024)=0 breakwhile
          
          IsComment=DeComment(&Buffer,IsComment)

          (args,variablen,Array,Public,Static)=LineAnalyse(&Buffer,"variablen/M,long/S,public/S,static/S")
          if args#0
           {
             if array#0
              {
                if static#0
                 {
                   printf("\$09\$7b* incvar: ")
                 }

                variablen->(zeiger)
                repeat
                    ifelse static#0
                     {
                       printf("%s,",*zeiger)
                     }
                     {
                       AddVar(VarRoot,zeiger,1,MethodeID,public)
                     }
                    variablen->(zeiger)
                until zeiger=0
                FreeArgs(Args)
                if static#0
                 {
                   printf("xcyxxdzzyzx *\$7d\n")
                 }
                {* UnCase *}
              }
             FreeArgs(Args)
           }
          (args,String,Static,variablen)=LineAnalyse(&Buffer,"string/K,static/S,variablen/F")
          if args#0
           {
             if String#0
              {
                if static#0
                 {
                   printf("\$09\$7b* String: %s=\$22%s\$22*\$7d\n",*String,*variablen)
                 }
                if static=0
                 {
                    AddVar(VarRoot,String,1,MethodeID,0)
                    AddObject(ObjectRoot,String,"system/string",MethodeID)
                    AddConstructor(ConstructorRoot,String,"system/string")

                    len=strlen(Variablen)
                    Nummer=AddString(Stringroot,Variablen,Variablen+len)
                    printf("\$09{* String: Preassxx%ld=\$22%s\$22*}\n",*nummer,*Variablen)
                    Sprintf(&Objectpuffer,"\$09Domethode(%s,\$22addString\$22,>obtl%ld:Preassxx%ld,0)",>spfmethodsf1:*String,*TaglistenNr,*nummer,0)
                    Taglistennr==Taglistennr+1
                    if CID=0 
                     {
                       CID=AddMethode(MethodeRoot,"Constructor()",1,0,0,0,0,0,0)
                     }
                    AddLine2(LineRoot,&ObjectPuffer,CID)
                 }
                FreeArgs(Args)
                {* UnCase *}
              }
             FreeArgs(Args)
           }
          (args,Class,Objecte,Array)=LineAnalyse(&Buffer,"class/K,variablen/M,Object/S")
          if args#0
           {
             if array#0
              {
                BuildClassString(Class)
                Objecte->(zeiger)
                repeat
                    AddVar(VarRoot,zeiger,1,MethodeID,0)
                    AddObject(ObjectRoot,zeiger,Class,MethodeID)
                    If Class#0
                     {
                       Sprintf(&objectpuffer,"%s",>spfacmain:*Class,0)
                       AddConstructor(ConstructorRoot,zeiger,&Objectpuffer)
                     }
                    Objecte->(zeiger)
                until zeiger=0
                FreeArgs(Args)
                {* UnCase *}
              }
             FreeArgs(Args)
           }
          (args,Class,Objecte)=LineAnalyse(&Buffer,"new/K,variablen/M")
          if args#0
           {
             if Objecte#0 and class#0 
              {
                if (pos=Stringfind(Class,"("))#0
                 {
                    myPos=seekClosingBracket(pos)
                    getObjectArgs(pos+1,&Objectargs,myPos-Pos-1,MethodeID,1)
                    len==pos-Class+1
                    mem=malloc(Len,#MEMF_CLEAR!MEMF_FAST)
                    Copymem(Class,mem,len-1)
                    Class==mem
                 }
                BuildClassString(Class)
                Objecte->(zeiger)
                repeat
                    AddVar(VarRoot,zeiger,1,MethodeID,0)
                    AddObject(ObjectRoot,zeiger,Class,MethodeID)
                    Ifelse pos#0
                     {
                       Sprintf(&Objectpuffer,"\$09%s=new(\$22%s\$22,>obtl%ld:%s,0)",>spfmain1a:*zeiger,*Class,*TaglistenNr,Objectargs)
                       Taglistennr==Taglistennr+1
                     }
                     { 
                       Sprintf(&objectpuffer,"\$09%s=new(\$22%s\$22,0)",>spfacmain1:*zeiger,*Class,0)
                     }
                    AddLine2(LineRoot,&ObjectPuffer,MethodeID)
                    Objecte->(zeiger)
                until zeiger=0
                FreeArgs(Args)
                {* UnCase *}
              } 
             FreeArgs(Args)
           }
          (args,sync,static,abstract,public,private,protected,Methode)=LineAnalyse(&Buffer,"syncronized/S,static/S,abstract/S,public/S,private/S,protected/S,name/F")
          if args#0
           {
             if abstract!private!protected!public#0
              { 
                 MethodeID=AddMethode(methodeRoot,Methode,public,private,protected,abstract,static,sync,0)
                 FreeArgs(Args)
                 If Abstract=0 
                  {
                    ClassBodyAnalyse(Classhandle)
                  }
                 if FGets(Classhandle,&Buffer,1024)=0 breakwhile
                 IsComment=DeComment(&Buffer,IsComment)
                 {* UnCase *}
              }         
             FreeArgs(Args)
           }
          if stringfind(&Buffer,"\$7b")#0
           {
              skip==Skip+1
           } 
          if stringfind(&Buffer,"\$7d")#0
           {
              If skip>0
               {
                 skip==Skip-1
                 if skip#0
                  {
                    AddLine(LineRoot,&Buffer,MethodeID)
                    AddLine(LineRoot,"\$09\$7b* Flush *\$7d",MethodeID)
                  }
                 {* unCase *}
               }
              a==2
              {* UnframeReturn 0*}
           }
          AddLine(LineRoot,&Buffer,MethodeID)
        } 
     }
    {* UnframeReturn 0*}

countchars[a0,d1]:
    moveq.l #0,d0
.l1:cmpi.b #0,(a0)
    beq .ende
    cmpi.b (a0),d1
    bne .l2
    addq.l #1,d0
.l2:lea 1(a0),a0
    bra .l1
.ende:
    rts    


LowerCase[a0]:
    clr.l d0
.l1:move.b (a0),d0
    cmpi.b #"A",d0
    blt .skip
    cmpi.b #"z",d0
    bgt .skip
    bset.l #5,d0
.skip:
    move.b d0,(a0)+
    bne .l1
    rts

NeueKlasse[a0]:
    {* Incvar: ext_p,ext_pp,Incarnations,CSMem_p,NK_Return*}
    {* Stackframe Filename=a0,Classhandle,args,class_p,mem,errors,res*}
    Incarnations==Incarnations+1
    MethodeID==0
    If (Classhandle=Open(Filename,#Mode_Old))#0
     {
      while Fgets(classhandle,&Buffer,1024)#0
      {
       IsComment=DeComment(&Buffer,IsComment)
       (args,ext_p)=LineAnalyse(&Buffer,"include/K/A")
       if args#0
        {
             printf("%s\n",*ext_p)
             FreeArgs(Args)
        }
       (args,ext_p)=LineAnalyse(&Buffer,"include_p/K/A")
       if args#0
        {
             printf("{* include %s *}\n",*ext_p)
             FreeArgs(Args)
        }
       (args,ext_p)=LineAnalyse(&Buffer,"usefd/K/A")
       if args#0
        {
             printf("  {* usefd:%s *}\n",*ext_p)
             FreeArgs(Args)
        }
       (args,abstract,class_p,ext_p)=LineAnalyse(&Buffer,"abstract/S,Class/K/A,extends/K")
       if args#0
        {
          if abstract#0 and Incarnations=1 
           {
             Close(Classhandle)
             FreeArgs(Args)
             printf("Abstracted Classes can not be compiled, they have to be extended!\n")
             {* UnFrameReturn -1*}
           }

          if Class_P#0 and Incarnations=1
           {
             Fillbuffer(&Classname,0,100)
             Fillbuffer(&Classname_2,0,100)
             copymem(Class_P,&Classname_2,100)
             LowerCase(Class_p)
             len=strlen(class_P)
             Copymem(class_p,&Classname,len)
             Sprintf(&ClassStoreMem,"Class %s ",>csm0:classname,0)
             len=strlen(&ClassStoreMem)
             CSMem_p==len+#ClassStoreMem
           }
          if ext_P#0
           {
             Sprintf(CSMem_p,"--> %s ",>csm1:*ext_p,0)
             len=strlen(CSMem_p)
             CSMem_p==CSMem_p+len

             BuildClassString(ext_P)
             if Stringfind(ext_p,".class")=0
              {
                Len=strlen(ext_p)
                len==len+7
                ext_PP=malloc(len,#MEMF_FAST!MEMF_CLEAR)
                len==len-7
                Copymem(ext_P,ext_PP,len)
                Copymem(".class",ext_PP+len,?)
                ext_p==Ext_PP
              }
             if Stringfind(ext_p,"classes/")=0
              {
                Len=strlen(ext_p)
                len==len+13
                ext_PP=malloc(len,#MEMF_FAST!MEMF_CLEAR)
                len==len-13
                Copymem("odk:classes/",ext_PP,?)
                Copymem(ext_P,ext_PP+12,len)
                ext_p==Ext_PP
              }
             

             len=strlen(class_P)
             len==len+1
             mem=malloc(len)
             Copymem(class_p,mem,len)
             push mem
             push len
            
             res=NeueKlasse(ext_p)
             NK_Return==NK_Return!res
             
             pop len
             pop mem
             
             Copymem(mem,&Classname,len)
             
             MethodeID==0

           }
          FreeArgs(args)
          ClassBodyAnalyse(Classhandle)
        }
     }
     {* Flush *}
     Close(Classhandle)
    }
    NK_Return==NK_Return!ClassHandle
    {* UnFrameReturn NK_Return*}

Chain[A0,A1]:
    {* StackFrame Root=a0,Tail=A1,next*}
    next=.lLineRoot.next(Root)
    if Next=0
     {
        Tail=>root.LineRoot.next
        {* UnFrameReturn *}
     }
    Chain(Next,Tail)
    {* UnframeReturn *}  

SkipLine[a0]:
    cmpi.b #$00,(a0)
    beq .ende
    cmpi.b #$0A,(a0)
    beq .ok
    cmpi.b #$09,(a0)
    beq .ok
    cmpi.b #$20,(a0)
    beq .ok
    cmpi.b #";",(a0)
    beq .ok
    moveq.l #0,d0
    RTS
.ende:
    moveq.l #-1,d0
    RTS
.ok:lea 1(a0),a0
    bra.w SkipLine



BuildBody[staticstatus]:

    MethodeID=.lMethodeRoot.next(methodeRoot)
    while MethodeID#0
     {
        fillbuffer(&Store,0,1000)

        name=.lMethodeRoot.name(MethodeID)
        static=.lMethodeRoot.static(MethodeID)
        Counter=.lMethodeRoot.Counter(MethodeID)
        invalid=.lMethodeRoot.Invalid(MethodeID)
        if Invalid=1
         {
           MethodeID=.lMethodeRoot.next(MethodeID) 
           {* UnCase *}
         }

        if static#0
         {
           static==1
         }

        if static=staticStatus
         {

            char==0
            anz==0
            pos=Stringfind(name,"(")
            if pos#0
             {
               len==pos-name
               copymem(name,&store,len)
               printf("%s_%ld[",store,*Counter)
               char=.w0(pos)
               anz=countchars(pos,#$2c)
               begin==1
               if static#0
                {
                  begin==2
                }
               i==begin
               if char##$2829 
                {
                   anz==anz+1
                   for I=Begin to anz
                     Register==Registers[i]
                     printf("%s,",*register)
                   Next I
                }
               Register==Registers[i]
               printf("%s]:\n",*register)
             }
        
            if static#0
             {        
                printf("\$09\$7b* Stackframe this=#0")
             }
            if static=0
             {        
                printf("\$09\$7b* Stackframe this=d0")
             }
            oldpos==pos+1
            next=.lVarRoot.next(VarRoot)
            if anz#0
             {
                anz==anz+1
                for I1=2 to anz
    
                  Register==Registers[i1]
                  if (pos=Stringfind(oldpos,","))=0
                   {
                      pos=Stringfind(oldpos,")")
                   }
                  if pos#0
                   {
                      if (mypos=Stringfind(oldpos," "))#0
                       {
                          oldpos==mypos+1
                       }
                      makeSubString(oldpos,&buffer,pos-oldpos)
                      printf(",%s=%s",buffer,*register)
                   }
                  oldpos==pos+1
        
                Next I1
             }
            while next#0
             {
                 Id=.lVarRoot.id(next)
                 name=.lVarRoot.name(Next)
                 next=.lVarRoot.next(Next)
                 if id=MethodeID
                  {
                    if name#0 and strlen(name)#0
                     {
                       printf(",%s",*name)
                     }
                  }
             }
         
            GetInstanzVariablen(SecondVarRoot)
            printf("*\$7d\n")
            LadeInstanzVariablen(SecondVarRoot,MethodeID)
            next=.lLineRoot.next(LineRoot)
            while next#0
             {
                 Id=.lLineRoot.Methodeid(next)
                 name=.lLineRoot.name(Next)
                 next=.lLineRoot.next(Next)
                 if id=MethodeID
                  {
                    If skipLine(name)=0
                     {
                        returnwert==0
                        (args,returnbefehl)=LineAnalyse(name,"return/K/A")
                        if args#0
                         {
                            returnwert==returnbefehl
                            FreeArgs(args)
                         }
                        returnbefehl=Stringfind(name,"\$7b* UnFrameReturn")
                        if returnbefehl#-1
                         {
                            returnwert==returnwert!returnbefehl
                         }
                     }
                    name=PraeProzessor(name,MethodeID)
                    printf("%s\n",*name)
                  }
                 if next=0 and returnwert=0
                  {
                    PrintInstanzVariablen(SecondVarRoot)
                    printf("\$09\$7b* UnFrameReturn *\$7d\n\n")
                  }
             }
         }
       MethodeID=.lMethodeRoot.next(MethodeID) 
     }
    {* Return *}

Start:
    Stackmem=malloc(100000,#MEMF_FAST!MEMF_CLEAR)
    move.l a7,oldstack
    move.l Stackmem,a7
    add.l #100000,a7

    VarRoot=malloc(sizeof(VarRoot),#MEMF_FAST!MEMF_CLEAR)
    MethodeRoot=malloc(sizeof(MethodeRoot),#MEMF_FAST!MEMF_CLEAR)
    LineRoot=malloc(sizeof(LineRoot),#MEMF_FAST!MEMF_CLEAR)
    ObjectRoot=malloc(sizeof(ObjectRoot),#MEMF_FAST!MEMF_CLEAR)
    ConstructorRoot=malloc(sizeof(ConstructorRoot),#MEMF_FAST!MEMF_CLEAR)
    StringRoot=malloc(sizeof(StringRoot),#MEMF_FAST!MEMF_CLEAR)

    AddVar(VarRoot,"FuncArray",2,0,0)
    AddVar(VarRoot,"SizeofObject",1,0,0)
    AddVar(VarRoot,"SIG",1,0,0)
    AddVar(VarRoot,"LibraryBase",1,0,0)

    AddObject(ObjectRoot,"this","this",-1)

    SecondVarRoot=.lVarRoot.Next(VarRoot)
    SecondVarRoot=.lVarRoot.Next(SecondVarRoot)
    SecondVarRoot=.lVarRoot.Next(SecondVarRoot)
    SecondVarRoot=.lVarRoot.Next(SecondVarRoot)

    If (Args=Readargs("filename/A",&RDArgs_array,&RDArgs))=0
     {
       printf("Preass++ : no filename given\n")
       move.l oldstack,a7
       error==10
       {* return *}
     }
    res==RDArgs_array[0]
    copymem(res,&Filename,200)
    FreeArgs(args)
   
    if (res=NeueKlasse(&filename))=0
     {
       printf("Class error\n")
       move.l oldstack,a7
       error==20
       {* return 20*}
     }
    if Res=-1
     {
       printf("Class processing returned an error\n")
       move.l oldstack,a7
       error==20
       {* return 20*}
     }

    If (res=findAbstractMethoden(MethodeRoot))#0
     {
       printf("oh oh, %ld Methode(s) left abstract. I can not compile this!\n",*res)
       PrintAbstractMethoden(methodeRoot)
       error==20
       {* Return 20*}
     }

    printf("\$09\$7b* Include odk:misc/Konstanten_new.inc *\$7d\n")
    printf("\$09\$7b* Delayaus *\$7d\n")
    printf("\$09\$7b* KillFD ")
    next=.lMethodeRoot.next(MethodeRoot)
    while next#0
     {
       name=.lMethodeRoot.name(next)
       pos=Stringfind(name,"(")
       makeSubString(name,&buffer,pos-name)
       printf("%s",Buffer)
       next=.lMethodeRoot.next(next)
       if next#0
        {
          printf(",")
        }
     }

    printf("*\$7d\n\n\$09moveq.l #0,d0\n\$09rts\n\n\$09{* Error: RTS\n *}\n\n")

    printf("\$7b* structure %s,FuncArray(APTR),SizeofObject(LONG),SIG(LONG),LibraryBase(LONG)",Classname)

    next=.lVarRoot.next(SecondvarRoot)

    While next#0
     {
       name=.lVarRoot.name(Next)
       type=.lVarRoot.type(Next)
       id=.lvarRoot.id(Next)
       public=.lVarRoot.Public(Next)
       if ID=0 and public#0
        {
           If type=1 
            {
              printf(",%s(LONG)",*name)
            }
           If type=2 
            {
              printf(",%s(APTR)",*name)
            }
        }
       next=.lVarRoot.next(Next)
     }

    next=.lVarRoot.next(SecondvarRoot)

    While next#0
     {
       name=.lVarRoot.name(Next)
       type=.lVarRoot.type(Next)
       id=.lvarRoot.id(Next)
       public=.lVarRoot.Public(Next)
       if ID=0 and public=0 
        {
           If type=1 
            {
              printf(",%s(LONG)",*name)
            }
           If type=2 
            {
              printf(",%s(APTR)",*name)
            }
        } 
       next=.lVarRoot.next(Next)
     }
    printf("*\$7d\n\n")
    SecondVarRoot=.lVarRoot.Next(SecondVarRoot)

    CID=foundMethode(MethodeRoot,"Constructor()")
    ifelse CID=0
     {
       CID=AddMethode(MethodeRoot,"Constructor()",1,0,0,0,0,0,0)
       AddConstructoren(ConstructorRoot,CID)
       PrintConstructoren(ConstructorRoot,CID)
     }
     {
       OldLineRoot==LineRoot
       LineRoot=malloc(sizeof(LineRoot),#MEMF_FAST!MEMF_CLEAR)
       
       AddConstructoren(ConstructorRoot,CID)
       PrintConstructoren(ConstructorRoot,CID)
       Chain(LineRoot,OldLineRoot)
     }
    DID=foundMethode(MethodeRoot,"DeConstructor()")
    if DID=0
     {
       DID=AddMethode(methodeRoot,"DeConstructor()",1,0,0,0,0,0,0)
     }

    AddDeConstructoren(ConstructorRoot,DID)

; Build Static Routines first

    BuildBody(1)
    BuildBody(0)
    
    printf("%s",include1)
    sprintf(&Buffer,"classname:  dc.b \$22%s\$22,0\ncnop 0,2\n",>spficl1a:classname_2,0)
    
    printf(&buffer)

    sprintf(&Buffer,"Libname:    dc.b \$22%s.library\$22,0\ncnop 0,2\n",>spficl1:classname,0)
    
    printf(&buffer)
                                                                        
    sprintf(&Buffer,"idstring:   dc.b \$22oop runtime %s.library\$22,13,10,0\ncnop 0,2\n",>spficl2:classname,0)

    printf(&buffer)                                                     

    printf("%s",include2)
    PrintPublicMethoden(MethodeRoot,0)
    printf("    dc.l -1\n\nPubfuncarray:\n")
    PrintPublicMethoden(MethodeRoot,0)
    printf("    dc.l 0\n\n    {* Array[String]: StringfuncArray")
    PrintPublicMethoden(MethodeRoot,1)
    printf("*}\n     ")                              
    printf("\n    {* Array[String]: Signaturen")
    PrintPublicMethoden(MethodeRoot,2)
    printf("*}\n     ")                              

    printf("%s",include3)                               

    sizeofObject=calcOBS(VarRoot)
    printf("    move.l #%ld,ml_sizeofobject(a5)\n",*sizeofobject)
    printf("    move.l #PubFuncarray,ml_funcs(a5)\n")
    printf("    move.l #StringFuncarray,ml_funcsStr(a5)\n")
    printf("%s",include4)                               


    Sprintf(&Filename,"odk:docs/classes/%s.desc",>spfpm1:Classname,0)
    if (mh=open(&Filename,#Mode_new))#0
     {
        Fputs(mh,&ClassStoreMem)
        Fputs(mh,"\n\n")
        ObjectRoot=.lObjectRoot.Next(ObjectRoot)
        PrintObject(ObjectRoot,mh,0,1)
        printVar(SecondVarRoot,mh,0,1)
        Fputs(mh,"\n")
        PrintMethoden(methodeRoot,mh)
        close(MH)
     }

    move.l oldstack,a7
    {* Return *}

           
LineAnalyse[a0,a1]:
    {* StackFrame zeiger=a0,char,len,Template=a1,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg0,args*}

       fillbuffer(&RdArgs_array,0,40)
       char=.b0(zeiger)
       if char=#`#` 
        {
          {* UnFrameReturn 0*}
        }
       if char=#`;` 
        {
          {* UnFrameReturn 0*}
        }

       len=strlen(Zeiger)
       Zeiger=>RDArgs.CS_Buffer
          Len=>RDArgs.CS_Lenght
            0=>RDArgs.CS_CurChr
            0=>RDArgs.RDA_DAList
            0=>RDArgs.RDA_Buffer
            0=>RDArgs.RDA_BufSiz
            0=>RDArgs.RDA_ExtHelp
            0=>RDArgs.RDA_Flags

       If (Args=Readargs(Template,&RDArgs_array,&RDArgs))=0
        {
           {* UnFrameReturn 0*}
        }

       arg1==RDArgs_array[0]
       arg2==RDArgs_array[1]
       arg3==RDArgs_array[2]
       arg4==RDArgs_array[3]
       arg5==RDArgs_array[4]
       arg6==RDArgs_array[5]
       arg7==RDArgs_array[6]
       arg8==RDArgs_array[7]
       arg9==RDArgs_array[8]
       arg0==RDArgs_array[9]

    {* UnFrameReturnM args,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg0*}
    {* NoFrame *}


include1:   incbin odk:source/preassxx.incl1
            dc.b 0

include2:   incbin odk:source/preassxx.incl2
            dc.b 0

include3:   incbin odk:source/preassxx.incl3
            dc.b 0

include4:   incbin odk:source/preassxx.incl4
            dc.b 0
cnop 0,4


