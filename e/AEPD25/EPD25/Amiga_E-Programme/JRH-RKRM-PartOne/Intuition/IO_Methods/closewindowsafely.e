-> closeWindowSafely
->
-> These functions close an Intuition window that shares a port with other
-> Intuition windows.
->
-> We are careful to set the UserPort to NIL before closing, and to free any
-> messages that it might have been sent.

OPT MODULE  -> E-Note: create a module for re-use

MODULE 'exec/lists',
       'exec/nodes',
       'exec/ports',
       'intuition/intuition'

-> Function to remove and reply all IntuiMessages on a port that have been
-> sent to a particular window (note that we don't rely on the succ pointer
-> of a message after we have replied it)
PROC stripIntuiMessages(mp:PTR TO mp, win)
  DEF msg:PTR TO intuimessage, succ
  msg:=mp.msglist.head
  WHILE succ:=msg.execmessage.ln.succ
    IF msg.idcmpwindow=win
      -> Intuition is about to free this message.
      -> Make sure that we have politely sent it back.
      Remove(msg)
      ReplyMsg(msg)
    ENDIF
    msg:=succ
  ENDWHILE
ENDPROC

-> Entry point to closeWindowSafely().
-> Strip all IntuiMessages from an IDCMP which are waiting for a specific
-> window.  When the messages are gone, set the UserPort of the window to NIL
-> and call ModifyIDCMP(win,0).  This will free the Intuition parts of the IDCMP
-> and turn off messages to this port without changing the original UserPort
-> (which may be in use by other windows).
-> E-Note: this is the function we want to export from the module
EXPORT PROC closeWindowSafely(win:PTR TO window)
  -> We forbid here to keep out of race conditions with Intuition
  Forbid()

  -> Send back any messages for this window  that have not yet been processed
  stripIntuiMessages(win.userport, win)

  -> Clear UserPort so Intuition will not free it
  win.userport:=NIL

  -> Tell Intuition to stop sending more messages
  ModifyIDCMP(win, 0)

  -> Turn multitasking back on
  Permit()

  -> Now it's safe to really close the window
  CloseWindow(win)
ENDPROC
