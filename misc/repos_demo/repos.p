; DirectDos Support : repos
;
; (c) 1998-2001 Cyborg

    {* Include sys:coder/preass/Options.p *}

    {* String: Version="$VER: repos demo source (C) CYBORG 1998-2001"*}

; First we setup some structures we need:

; Datastructure is used to comunicate with the different DirectDostasks

    {* Structure Datastructure,TargetTask(LONG),SendTask(LONG),Data(LONG)*}

; here we store some informations about the windows and chain/store them

    {* Structure Position1,Left(LONG),Top(LONG),Width(LONG),Height(LONG),POSX(LONG)
                           POSY(LONG),DX(LONG),DY(LONG),Window(LONG),NEXT(LONG)*}

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
; data(message) arrived , wait a bit and then retry it.
;
; It is possible to change this routine to a simpler construct, which returns
; immediatly, if no data arrived. This won`t matter that much , because 
; the arriving messages will be stored in a queue . You had to add a routine
; to empty the queue!


WaitMailReply[a0]:
    {* Stackframe HitWindow=a0,Taskdata=#0*}
    While TaskData##DND_Reply
     {
       If DND_IsOnline(Hitwindow)=0 breakwhile
       While (Result=DND_Getdata(-1))=-1
        {
          Delay(4)
          If DND_IsOnline(Hitwindow)=0 breakwhile
        }
       If result#-1
        {
           TaskData=.lDataStructure.Data(Result)
           DND_FreeData(Result)
        }
     }
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

; InsertNewWindow:
;
; Chain new windowdata to the list , which starts with the second entry. The real
; root entry is empty and unused.
; 
; If the nextfield in the entry is empty, we allocate a new entrystructure and
; store the data in it and chain it the last entry.

InsertNewWindow[a0,d0,d1,d2,d3,d4,d5,d6,d7]:
    {* Stackframe last,Window=a0,Window1,left=d0,top=d1,width=d2,height=d3,posx=d4,posy=d5,dx=d6,dy=d7,next*}

    Next=.lPosition1.next(Root)
    Last==Root
    While Next#0
     {
        Last==Next
        Next=.lPosition1.next(Next)
     }
    next=malloc(sizeof(position1))
      next=>Last.Position1.next
      posx=>next.Position1.posx
      posy=>next.Position1.posy
        dx=>next.Position1.dx
        dy=>next.Position1.dy
    window=>next.Position1.window
      left=>next.Position1.left
       top=>next.Position1.top
     width=>next.Position1.width
    height=>next.Position1.height
         0=>next.Position1.next

    {* UnframeReturn *}

; GetWindowData:
;
; the parse throu all entries and compare the given windowid with the stored
; one. if it matchs , we give the needed informations back.

GetWindowData[a0]:
    {* Stackframe Window=a0,Window1,left,top,width,height,next*}

    Next=.lPosition1.next(Root)
    While Next#0
     {
        window1=.lPosition1.Window(Next)
        
        if window1=window 
         {
              left=.lPosition1.left(Next)
               top=.lPosition1.top(Next)
             Width=.lPosition1.width(Next)
            Height=.lPosition1.height(Next)
            {* UnframeReturnM Left,Top,Width,Height*}      
         }
        Next=.lPosition1.next(Next)
     }
    {* UnframeReturnM 0,0,0,0*}

; UpdateWindow:
;
; the parse throu all entries and compare the given windowid with the stored
; one. if it matchs , we update the important fields.

UpdateWindow[a0,d0,d1,d2,d3]:
    {* Stackframe Window=a0,Window1,posx=d0,posy=d1,dx=d2,dy=d3,next*}

    Next=.lPosition1.next(Root)
    While Next#0
     {
        window1=.lPosition1.Window(Next)
        
        if window1=window 
         {
              posx=>Next.Position1.posx
              posy=>Next.Position1.posy
                dx=>Next.Position1.dx
                dy=>next.Position1.dy
              {* UnframeReturn *}            
         }
        Next=.lPosition1.next(Next)
     }
    {* UnframeReturn *}

; GetPosData:
;
; the parse throu all entries and compare the given windowid with the stored
; one. if it matchs , we give the needed informations back.

GetPosData[a0]:
    {* Stackframe Window=a0,Window1,posx,posy,dx,dy,width,height,next*}

    Next=.lPosition1.next(Root)
    While Next#0
     {
        window1=.lPosition1.Window(Next)
        
        if window1=window 
         {
              posx=.lPosition1.posx(Next)
              posy=.lPosition1.posy(Next)
                dx=.lPosition1.dx(Next)
                dy=.lPosition1.dy(Next)
             Width=.lPosition1.width(Next)
            Height=.lPosition1.height(Next)
            {* UnframeReturnM posx,posy,dx,dy,Width,Height*}            
         }
        Next=.lPosition1.next(Next)
     }
    {* UnframeReturnM 0,0,0,0,0,0*}

start:
    {* IncVar: window*}

; we get some memory to store the different windowids ( max. 250 ) 

    mem=malloc(1000,#MEMF_CLEAR)

; we need the screensize to get the borders set.

    Screen=.l60(IntuitionBase)
    MaxW=.w12(Screen)
    MaxH=.w14(Screen)

; the first ( dummy ) entry of our chained list is allocated here

    root=malloc(sizeof(position1))

; Make sure its safe to use.

    0=>root.Position1.next
    0=>root.Position1.Window

; Get the informations from the drag`n`drop-queue.

    DND_WhoisOnline(mem,1000)

; for each window we got, we have to do some inits

    Zeiger==mem
    Zeiger->(Window)
    While window#0
     {

; prevent window from refreshing

        SendNORefresh(Window)

; bring to front, so everyone can see it.

        WindowtoFront(Window)

; get the windowinformation 

          Left=.wWindow.Leftedge(Window)
           Top=.wWindow.Topedge(Window)
         Width=.wWindow.Width(Window)
        Height=.wWindow.height(Window)
        dx==4
        dy==2

; sort data in

        InsertNewWindow(Window,Left,Top,Width,Height,Left,Top,dx,dy)
        Zeiger->(Window)
     }                
    Zeiger==mem
    Zeiger->(Window)

; if we have at least one window we can start

    if window#0
     {     

; this is an endless loop which could be canceld by pressing CTRL-C
; of the closing of one window.

        While posx=posx
         {

            Zeiger==mem
            Zeiger->(Window)
            While window#0    
             {

; ask if the have to break in case someone pressed CTRL-C

                sigs=SetSignal(0,0)
                If Sigs&$f000#0 breakwhile

; if a window is no longer present , skip it.

                If DND_IsOnline(Window)#0
                 {

; Get window data from chained list
            
                    (posx,posy,dx,dy,width,height)=GetPosData(window)

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

                    UpdateWindow(window,posx,posy,dx,dy)
                 }

; get next window from array.

                Zeiger->(Window)
             }

; if we got a break from the inner while , we have to break the outer while
; to.

           If Sigs&$f000#0 breakwhile
         }

     }

; the next lines will reposition the window at it`s old place and
; sets it back to REFRESH mode.

    Zeiger==mem
    Zeiger->(Window)
    While window#0
     {
        (Left,Top,width,height)=GetWindowdata(window)
        SendRePos(Window,left,top,Width,Height)
        SendRefresh(Window)
        Zeiger->(Window)
     }                
    {* Return *}
