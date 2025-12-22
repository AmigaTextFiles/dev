Am 29-Mai-98 schrieb David Lidström:


>Hm... it might got optimized a bit, but I didn't notice it cuz' of 
>the still very slow GUI...
>I liked that talk about shared msg ports - but I, still, don't
>know how on earth I shall use it... 

To make Windows share their Message-Ports you have to do it
like that:

I don`t know if you could compile it (because i had written it now
in 3 Minutes and the Modules are missing), but it shows how Message-
portSharing (and IDCMP-Sharing, because it is needed here!) is done!

---8<-----8<-----8<-----8<-----8<-CUT-8<-8<-----8<-----8<-----8<

CONST   WINDOW_IDCMP = IDCMP_xxx OR IDCMP_yyy...
                                        -> Our IDCMP-Flags for
                                        -> the Window...

PROC main() HANDLE
DEF     sharedmp:PTR TO mp,             -> Message Port
        win1:PTR TO window,             -> First Window
        win2:PTR TO window,             -> Second Window
        win3:PTR TO window              -> Third Window
  sharedmp:=openSharedPort()            -> Open Shared MsgPort
   win1:=openWindowShared(sharedmp)     -> Open Window 1
    win2:=openWindowShared(sharedmp)    -> Open Window 2
     win3:=openWindowShared(sharedmp)   -> Open Window 3
->    ...

       handleShared(sharedport)         -> Handle Shared MsgPort

EXCEPT DO

->    ...
     closeSharedWindow(win3)            -> Close Window 3
    closeSharedWindow(win2)             -> Close Window 3
   closeSharedWindow(win1)              -> Close Window 3
  closeSharedPort(sharedmp)             -> Close Shared MsgPort
 CleanUp(exception)                     -> CleanUp...
ENDPROC

PROC openSharedPort()                   -> Opens a MspPort Shared
 DEF    port:PTR TO mp
  IF (port:=CreateMsgPort())=NIL THEN Raise(ERR_MSGPORT)
                                        -> Open the Port
ENDPROC port                            -> Returning MsgPort-PTR

PROC closeSharedPort(port)              -> Closes a SharedMsgPort
 IF (port<>NIL) THEN DeleteMsgPort(port)
ENDPROC

PROC openWindowShared(port:PTR TO mp)   -> Opens a Window with
 DEF    win:PTR TO window               -> shared MsgPort
  IF (win:=OpenWindowTagList(NIL,[...Tags...    
                                        -> Open the Window
         WA_IDCMP,              NIL,    -> IMPORTANT! IDCMP = NIL!
         TAG_END,               NIL]))  -> Because we use SharedIDCMP!
    win.userport:=port                  -> IMPORTANT!! (SharedMsgPort!)
   ModifyIDCMP(win,WINDOW_IDCMP)        -> Set our IDCMP-Flags
  ENDIF
ENDPROC win

PROC closeWindowShared(win:PTR TO window)
                                        -> Closes a Window with
                                        -> Shared MsgPort
 IF (win<>NIL)
  Forbid()                              -> Must be in Forbid()/Permit()
   removemsgs(win.userport,win)         -> Remode our Msgs out of the
                                        -> Msg-Queue!
    win.userport:=NIL                   -> To prevent the MsgPort
                                        -> from closing!
     ModifyIDCMP(win,NIL)               -> To Prevent from Closing
  Permit()                              -> Allow the forbiden thing again
   CloseWindow(win)                     -> And now close the Window...
  win:=NIL
 ENDIF
ENDPROC

PROC removemsgs(port:PTR TO mp,win:PTR TO window)
                                        -> Removes all Msgs for our 
  DEF   msg:PTR TO intuimessage         -> Window out of the Msg-List!
   Forbid()                             -> Not necessary, but safer :-)
    msg:=port.msglist.head              -> Get the first Msg from the List
     WHILE (msg<>NIL)                   -> Get every Message
      next:=msg.ln.succ                 -> Get PTR to the next Msg
       IF msg.idcmpwindow=win           -> If the Msg is from our Window...
        Remove(msg)                     -> remove it out of the Msg-List
        ReplyMsg(msg)                   -> Reply it so it could be freed
                                        -> by Exec... MUST HAPPEN!
       ENDIF
      msg:=next                         -> Set the PTR to the next Msg...
     ENDWHILE
   Permit()                             -> Allow it again...
ENDPROC

PROC handleShared(port:PTR TO mp)       -> Handles the Events...
 DEF    quit=FALSE,                     -> used to end the Loop...
        msg=NIL:PTR TO intuimessage,    -> The Message for a window...
        win=NIL:PTR TO window,          -> PTR to the Window, where the Msg
                                        -> came from
        class,                          -> intuimessage.class
        code,                           -> intuimessage.code
        qual,                           -> intuimessage.qualifier (UNSIGNED!)
        gad:PTR TO gadget               -> intuimessage.iadress

  WHILE (quit=FALSE)                    -> Repeat `till we want to quit...
   Wait(Shl(1,port.sigbit))             -> Wait for a Message..!
    WHILE (msg:=GetMsg(port))           -> Another loop, because it is
                                        -> Possible to get more than one
                                        -> Message at one sigal-Time!!!
     class:=msg.class                   -> IDCMP_xxx
      code:=msg.code                    -> specific!
       gad:=msg.iadress                 -> specific!
      qual:=((msg.qualifier) AND $FFFF) -> Unsign the Qualifier!!!
       win:=msg.idcmpwindow             -> PTR TO our Window!!!
     ReplyMsg(msg)                      -> Reply the Msg again (should be
                                        -> done as quickly as possible to
                                        -> slow down the system as less
                                        -> as possible!
      SELECT    class                   -> Get the Type of Message
        CASE    IDCMP_CLOSEWINDOW       -> Close the Window!
         IF (win=win1)                  -> If it is the main-Window, which
                                        -> should closed, then...
          quit:=TRUE                    -> Close all Windows...!!
         ELSE                           -> If it was another window, then
          closeWindowShared(win)        -> Close the specific Window!
         ENDIF
->      CASE    IDCMP_xxx               -> Other IDCMP-Types...

      ENDSELECT
    ENDWHILE
  ENDWHILE
ENDPROC

---8<-----8<-----8<-----8<-----8<-CUT-8<-8<-----8<-----8<-----8<

I hope i could help...

If you have questions.. just ask!

-- 
 ________                     ______
/__    __\ __________()_____ _\    / /\    turrican@starbase.inka.de
   \  //\/\\  _/\  _//\\ __//_\\   \/  \       THE DARK FRONTIER
    \//____\\/   \/ /__\\_//___\\/\_____\  Softwareentwicklung PD+Share
