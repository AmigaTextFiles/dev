; DirectDos Support : repos - one window mode
;
; (c) 1998-2001 Cyborg

    {* Include sys:coder/preass/Options.p *}

    {* String: Version="$VER: repos demo source (C) CYBORG 1998-2001"*}

; First we setup some structures we need:

; Datastructure is used to comunicate with the different DirectDostasks

    {* Structure Datastructure,TargetTask(LONG),SendTask(LONG),Data(LONG)*}

; used to comunicate with the directdos window , we set here the new position
; where the window has to move

    {* Structure Position(),X(LONG),Y(LONG),W(LONG),H(LONG)*}

; defines a window structure.

    {* Structure Window,NextWindow(APTR),LeftEdge(WORD),TopEdge(WORD),Width(WORD)
                 Height(WORD),MouseY(WORD),MouseX(WORD),MinWidth(WORD),MinHeight(WORD)
                 MaxWidth(WORD),MaxHeight(WORD),Flags(LONG),MenuStrip(APTR),Title(APTR)
                 FirstRequest(APTR),DMRequest(APTR),ReqCount(WORD),WScreen(APTR)
                 RPort(APTR),BorderLeft(BYTE),BorderTop(BYTE),BorderRight(BYTE)
                 BorderBottom(BYTE),BorderRPort(APTR),FirstGadget(APTR),Parent(APTR)
                 Descendant(APTR),Pointer(APTR),PtrHeight(BYTE),PtrWidth(BYTE),XOffset(BYTE)
                 YOffset(BYTE),IDCMPFlags(LONG),UserPort(APTR),WindowPort(APTR)
                 MessageKey(APTR),DetailPen(BYTE),BlockPen(BYTE),CheckMark(APTR)
                 ScreenTitle(APTR),GZZMouseX(WORD),GZZMouseY(WORD),GZZWidth(WORD)
                 GZZHeight(WORD),ExtData(APTR),UserData(APTR),WLayer(APTR),IFont(APTR)
                 MoreFlags(LONG)*}

; some const which Drag`n`Drop and DirectDos use.

    {* Const DND_Base=Tag_User
             DND_SendTask=DND_Base+1
             DND_ID=DND_Base+2
             DND_DragX=DND_Base+3
             DND_DragY=DND_Base+4
             DND_Pointer=DND_Base+5
             DND_Dirlock=DND_Base+6
             DND_Reply=DND_Base+7
             DND_Mode=DND_Base+8
             DND_Type=DND_Base+9
             DND_Action=DND_Base+10*}

; WaitMailReply:
;
; We wait for the reply message that has to send from a directdos window
; to say : "did it" . We have to check if the window was closed, this is
; possible , because DirectDos makes multitasking.
; our id is "-1" , so we have to wait for new data for id -1. If no 
; data(message) arrived, it`s not ok, but it could be come later.
;

WaitMailReply[a0]:
    {* Stackframe HitWindow=a0,Taskdata=#0*}
    While TaskData##DND_Reply
     {
       If DND_IsOnline(Hitwindow)=0 breakwhile
       While (Result=DND_Getdata(-1))=-1
        {
          Delay(5)
          If DND_IsOnline(Hitwindow)=0 breakwhile
        }
       If result#-1
        {
           TaskData=.lDataStructure.Data(Result)
           DND_FreeData(Result)
        }
     }

;    If DND_IsOnline(Hitwindow)#0
;     {
;       while (Result=DND_Getdata(-1))#-1
;        {
;           DND_FreeData(Result)
;        }
;     }
    {* unframeReturn *}

; SendRePos:
;
; if the window is still existing , we send a message to the windowtask.
; we have to activate the window to signal , that the task checks it messagequeue.
; At last we have to wait for the replymessage.

SendRePos[a0,d0,d1,d2,d3]:
    {* Stackframe HitWindow=a0,X=d0,Y=d1,w=d2,h=d3*}
    If DND_IsOnline(Hitwindow)#0 
     {
        X=>position.X
        Y=>position.Y
        W=>position.W
        H=>position.H
        Result=DND_GiveData(HitWindow,0,>Drag3Tags:DND_SendTask,-1|
                                                   DND_ID,"TOOL"|
                                                   DND_Mode,"REPO"|
                                                   DND_Pointer,Position|
                                                   Tag_Done,Null)
        ActivateWindow(HitWindow)
        WaitMailReply(Hitwindow)
     }
    {* UnFrameReturn *}


; SendNoReFresh:
;
; works like SendRePos. But it sends not a reposition message , instead we
; turn off the auto refresh. Normally a directdos window will refresh after 
; moving or changing size. To avoid this while moving , we turn it off.
; 

SendNORefresh[a0]:
    {* Stackframe HitWindow=a0*}
    If DND_IsOnline(Hitwindow)#0 
     {
        Result=DND_GiveData(HitWindow,0,>Drag2Tags:DND_SendTask,-1|
                                                   DND_ID,"TOOL"|
                                                   DND_Mode,"NORF"|
                                                   Tag_Done,Null)
        ActivateWindow(HitWindow)
        WaitMailReply(HitWindow)
     }
    {* UnFrameReturn *}

; SendReFresh:
;
; works like SendRePos. But it sends not a reposition message , instead we
; turn on the auto refresh. Normally a directdos window will refresh after 
; moving or changing size. 
; 

SendRefresh[a0]:
    {* Stackframe HitWindow=a0*}
    If DND_IsOnline(Hitwindow)#0 
     {
        Result=DND_GiveData(HitWindow,0,>Drag1Tags:DND_SendTask,-1|
                                                   DND_ID,"TOOL"|
                                                   DND_Mode,"RFRS"|
                                                   Tag_Done,Null)
        ActivateWindow(HitWindow)
        WaitMailReply(Hitwindow)
     }
    {* UnFrameReturn *}

SendNOSave[a0]:
    {* Stackframe HitWindow=a0*}
    If DND_IsOnline(Hitwindow)#0 
     {
        Result=DND_GiveData(HitWindow,0,>Drag4Tags:DND_SendTask,-1|
                                                   DND_ID,"TOOL"|
                                                   DND_Mode,"NOSV"|
                                                   Tag_Done,Null)
        ActivateWindow(HitWindow)
        WaitMailReply(HitWindow)
     }
    {* UnFrameReturn *}

SendSave[a0]:
    {* Stackframe HitWindow=a0*}
    If DND_IsOnline(Hitwindow)#0 
     {
        Result=DND_GiveData(HitWindow,0,>Drag5Tags:DND_SendTask,-1|
                                                   DND_ID,"TOOL"|
                                                   DND_Mode,"SAVE"|
                                                   Tag_Done,Null)
        ActivateWindow(HitWindow)
        WaitMailReply(HitWindow)
     }
    {* UnFrameReturn *}

start:
    {* IncVar: window*}

; we get some memory to store the different windowids ( max. 250 ) 

    mem=malloc(1000,#MEMF_CLEAR)

; we need the screensize to get the borders set.

    Screen=.l60(IntuitionBase)
    MaxW=.w12(Screen)
    MaxH=.w14(Screen)

; Get the informations from the drag`n`drop-queue.

    DND_WhoisOnline(mem,1000)

; for each window we got, we have to do some inits

    Zeiger==mem
    Zeiger->(Window)
    if window#0
     {

; prevent window from refreshing

        SendNORefresh(Window)
        SendNOSave(Window)

; bring to front, so everyone can see it.

        WindowtoFront(Window)

; get the windowinformation 

          Left=.wWindow.Leftedge(Window)
           Top=.wWindow.Topedge(Window)
         Width=.wWindow.Width(Window)
        Height=.wWindow.height(Window)
        posx==Left
        posy==Top
        dx==1
        dy==1

; this is an endless loop which could be canceld by pressing CTRL-C
; of the closing of one window.

        While posx=posx
         {

; ask if the have to break in case someone pressed CTRL-C

                sigs=SetSignal(0,0)
                If Sigs&$f000#0 breakwhile

; if a window is no longer present , skip it.

                If DND_IsOnline(Window)=0 breakwhile

; Send new position to window

                SendRePos(Window,posx,posy,Width,Height)

; calculate new position

                posx==posx+dx
                posy==posy+dy

; border check , we reverse the direction if we hit one border
; this is be done, by negate the delta of X and Y , which is added above
; to the old position. The following calculation corrects the border overrun.

                if posx<=0 or posx+width>maxW 
                 {
                   dx==-dx
                   posx==posx+dx
                 }
                if posy<=0 or posy+height>maxH 
                 {
                   dy==-dy
                   posy==posy+dy
                 }

; the new position has to be stored in the chained list.
; get next window from array.

         }

; if we got a break from the inner while , we have to break the outer while
; to.

; the next lines will reposition the window at it`s old place and
; sets it back to REFRESH mode.

        while (Result=DND_Getdata(-1))#-1
         {
           DND_FreeData(Result)
         }
        SendRePos(Window,left,top,Width,Height)

        SendSave(Window)
        SendRefresh(Window)

    }
    printf("test ends\n")
    {* Return *}
