; 
; 
; (c) 2001 Cyborg 

    {* Include sys:coder/preass/Options.p *}

    {* String: Version="$VER: view++ (C) CYBORG 2001"*}

    {* Array[Long]: Temp_Array,0,0,0,0,0,0*}

    {* String: TemplateString="Name/A"*}

    Include sys:coder/include/Datatypes/datatypes.i
    Include sys:coder/include/intuition/icclass.i


    {* Structure Window,NextWindow(APTR),LeftEdge(WORD),TopEdge(WORD),Width(WORD)
                 Height(WORD),MouseY(WORD),MouseX(WORD),MinWidth(WORD),MinHeight(WORD)
                 MaxWidth(WORD),MaxHeight(WORD),Flags(LONG),MenuStrip(APTR),Title(APTR)
                 FirstRequest(APTR),DMRequest(APTR),ReqCount(WORD),WScreen(APTR)
                 RPort(APTR),BorderLeft(BYTE),BorderTop(BYTE),BorderRight(BYTE)
                 BorderBottom(BYTE),BorderRPort(APTR),FirstGadget(APTR),Parent(APTR)
                 Descendant(APTR),Pointer(APTR),PtrHeight(BYTE),PtrWidth(BYTE),XOffset(BYTE)
                 YOffset(BYTE),IDCMPFlags(ULONG),UserPort(APTR),WindowPort(APTR)
                 MessageKey(APTR),DetailPen(BYTE),BlockPen(BYTE),CheckMark(APTR)
                 ScreenTitle(APTR),GZZMouseX(WORD),GZZMouseY(WORD),GZZWidth(WORD)
                 GZZHeight(WORD),ExtData(APTR),UserData(APTR),WLayer(APTR),IFont(APTR)
                 MoreFlags(ULONG)*}


InitNotify[d0,a0]:
    {* StackFrame FileLock,Port=d0,zeiger=a0,mem*}
    Filelock=Lock(zeiger,#Access_read)
    mem=malloc(2500,#MEMF_FAST)
    NameFromLock(Filelock,mem,250)
    Unlock(Filelock)
    move.l MEM,NotifyRequest
    move.l Port,Nport
    Move.l #0,NSig
    {* UnFrameReturn *}

CopyFile[a0,a1]:
    {* StackFrame File1=a0,File2=a1,IN,OUT,ANZ*}
    
    If (IN=Open(File1,#MODE_OLD))#0
     {
        If (OUT=Open(File2,#MODE_NEW))#0
         {
            While (anz=Read(In,Speicher,10000))#0
             {
               Write(Out,Speicher,anz)
             }
           Close(Out)
         }
        Close(IN)
     }
    {* UNFrameReturn *}

Hook:
    {* StackFrame msgclass*}
    msgclass=.l36(gui)
    If MsgClass=#IDCMP_NewSize
     {
         RemoveDTObject(Window,NewObject)
         DisposeDTObject(NewObject)
         width=.wWindow.width(Window)
         height=.wWindow.height(Window)
         TB=.bWindow.Bordertop(Window)
         LB=.bWindow.Borderleft(Window)
         width==width-lb
         height==height-TB
         NewObject=NewDTObjectA("t:workfile.class",>NewX2DTTAGS:GA_Left,*LB|GA_TOP,*TB|GA_Width,*width|GA_Height,*height|GA_ID,1|
                                                            ICA_Target,ICTARGET_IDCMP|
                                                            Tag_done,Null)
         AddDTObject(Window,0,NewObject,-1)
        {* UnFrameReturn -1*}
     }
    {* UnFrameReturn 0*}


               
GetSigs[]:
    Signals=SetSignal(0,0)
    Signals==Signals&#$F000
    {* Return Signals*}

Rotiere[d0]:
    ror.l #8,d0
    RTS

Start:
    Speicher=malloc(10000,#MEMF_FAST))
    If (Args=Readargs(&Templatestring,&TemP_array,0))=0
     {  
       Printf("Usage: %s\n",Templatestring)
       {* Return *}
     }
    Name_p==Temp_array[0]

    msgport=PortUp("NotifyPort")
    InitNotify(MsgPort,name_p)
    StartNotify(#NotifyRequest)

	Window=OpenGuiWindowA(0,11,640,110,"ODK p++ source viewer",
			#IDCMP_newsize!IDCMP_IDCMPUpdate!IDCMP_GADGETDOWN!IDCMP_GADGETUP!IDCMP_CLOSEWINDOW!IDCMP_MENUPICK!IDCMP_VANILLAKEY!IDCMP_RAWKEY,
			#WFLG_SIMPLE_REFRESH!WFLG_SIZEGADGET!WFLG_CLOSEGADGET!WFLG_DRAGBAR!WFLG_DEPTHGADGET,0,
        	 >Windowtags2:WA_Minwidth,640|WA_MinHeight,100|WA_MAxwidth,1024|
		                  WA_MaxHeight,768|Tag_done,0)

    if Window=0
     {
        ENDNotify(#NotifyRequest)
        PortDown(MsgPort)
        FreeArgs(Args)
        {* return *}
     }

	GUI=CreateGuiInfoA(Window,>GuiTags:GUI_HandleMsgAHook,Hook|Tag_Done,Null)
    CopyFile(name_P,"t:workfile.class")

    width=.wWindow.width(Window)
    height=.wWindow.height(Window)
    TB=.bWindow.Bordertop(Window)
    LB=.bWindow.Borderleft(Window)
    width==width-lb
    height==height-TB
    WRP=.l50(window)

;    SetAPen(WRP,2)
;    RectFill(WRP,LB,TB,Width+LB,height+TB)

    if (mylock=lock("t:workfile.class",#access_read))#0
     {
        Unlock(Mylock)
        NewObject=NewDTObjectA("t:workfile.class",>NewXDTTAGS:GA_Left,*LB|GA_TOP,*TB|GA_Width,*width|GA_Height,*height|GA_ID,1|
                                                              ICA_Target,ICTARGET_IDCMP|
                                                              Tag_done,Null)
        AddDTObject(Window,0,NewObject,-1)
        
        While Getsigs()=0
         {
           If (getGuiMsg(gui))#0
            {
               MsgClass=.l36(Gui)
               If MsgClass=#IDCMP_Vanillakey
                {
                   MsgChar=.b43(Gui)
                   char=Rotiere(MsgChar)
                   if MsgChar=#$1b
                    {
                      MsgClass==#IDCMP_Closewindow
                    }
                }
               if MsgClass=#IDCMP_Closewindow 
                {
                    RemoveDTObject(Window,NewObject)
                    DisposeDTObject(NewObject)
                    CloseGuiWindow(Window)
                    ENDNotify(#NotifyRequest)
                    PortDown(MsgPort)
                    FreeArgs(Args)
                    {* Return *}
                }
               If MsgClass=#IDCMP_IDCMPUpdate 
                {
                    RefreshDTObjectA(NewObject,Window,0,0)
                    RefreshWindowFrame(Window)
                }
            } 

           If (Msg=GetMsg(msgport))#0 
            {
                ReplyMsg(Msg)
                RemoveDTObject(Window,NewObject)
                DisposeDTObject(NewObject)
                CopyFile(name_P,"t:workfile.class")
                width=.wWindow.width(Window)
                height=.wWindow.height(Window)
                TB=.bWindow.Bordertop(Window)
                LB=.bWindow.Borderleft(Window)
                width==width-lb
                height==height-TB
                NewObject=NewDTObjectA("t:workfile.class",>NewX1DTTAGS:GA_Left,*LB|GA_TOP,*TB|GA_Width,*width|GA_Height,*height|GA_ID,1|
                                                                       ICA_Target,ICTARGET_IDCMP|
                                                                       Tag_done,Null)
                AddDTObject(Window,0,NewObject,-1)
             }
           delay(12)
         }
     }
    RemoveDTObject(Window,NewObject)
    DisposeDTObject(NewObject)
   	CloseGuiWindow(Window)
    ENDNotify(#NotifyRequest)
    PortDown(MsgPort)
    FreeArgs(Args)
    {* Return *}



cnop 0,4
NotifyRequest:
        dc.l 0
name1:  dc.l 0
        dc.l 0
Nflag:  dc.l $1
Nport:  dc.l 0
nSig:   dc.b 0
        dc.b 0,0,0
        dc.l 0,0,0,0
        dc.l 0,0

