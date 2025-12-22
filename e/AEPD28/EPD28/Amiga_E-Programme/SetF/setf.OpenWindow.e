/* setf.OpenWindow.e -- a program to monitor Intuition OpenWindow calls */

OPT OSVERSION=37

MODULE 'dos/dos', 'exec/ports', 'exec/tasks', 'exec/nodes', 'exec/memory',
       'intuition/intuition'

CONST OFFSET=$fda2  /* intuitionbase offset of OpenWindowTagList() */

OBJECT mymsg
  msg:mn
  s, t
ENDOBJECT

DEF port:PTR TO mp

PROC main()
  DEF ps, us, loop, sig, oldf
  IF port:=CreateMsgPort()
    Forbid()     /* Don't let anyone mess things up... */
    IF oldf:=SetFunction(intuitionbase, OFFSET, {newf})
      PutLong({patch}, oldf)
      LEA store(PC), A0
      MOVE.L A4, (A0)    /* Store the A4 register... */
      Permit()    /* Now we can let everyone else back in */
      ps:=Shl(1,port.sigbit)   /* Set up port and user signal bits */
      us:=SIGBREAKF_CTRL_C
      loop:=TRUE
      WHILE loop
        sig:=Wait(ps OR us)
        IF sig AND ps
          printmsgs()
        ENDIF
        IF sig AND us
          loop:=FALSE
        ENDIF
      ENDWHILE
      Forbid()   /* Paranoid... */
      SetFunction(intuitionbase, OFFSET, oldf)
    ENDIF
    Permit()
    printmsgs()   /* Make sure the port is empty */
    DeleteMsgPort(port)
  ENDIF
ENDPROC

/* Nicely (?) print the messages out... */
PROC printmsgs()
  DEF msg:PTR TO mymsg
  WHILE msg:=GetMsg(port)
    WriteF('Task \l\s[25] opened window \r\s[20]\n',
           IF msg.t THEN msg.t ELSE '*unnamed*',
           IF msg.s THEN msg.s ELSE '*unnamed*')
    ReplyMsg(msg)
    DisposeLink(msg.s)
    DisposeLink(msg.t)
    Dispose(msg)
  ENDWHILE
ENDPROC

/* Send a message to the patching process */
PROC sendmsg()
  DEF msg:PTR TO mymsg, w:PTR TO nw, tsk:tc, l:ln
  MOVE.L A0, w
  MOVE.L A1, tsk
  /* Allocate a new message */
  msg:=New(SIZEOF mymsg)
  IF w.title
    msg.s:=String(StrLen(w.title))
    StrCopy(msg.s, w.title, ALL)
  ENDIF
  tsk:=FindTask(NIL)   /* Find out who we are */
  msg.t:=NIL
  IF tsk
    l:=tsk.ln
    IF l AND l.name
      msg.t:=String(StrLen(l.name))
      StrCopy(msg.t, l.name, ALL)
    ENDIF
  ENDIF
  PutMsg(port, msg)
ENDPROC

/* Place to store A4 register */
store:  LONG 0
/* Place to store real call */
patch:  LONG 0

/* The new routine which will replace the original library function */
newf:
  MOVEM.L D0-D7/A0-A6, -(A7)
  LEA store(PC), A4
  MOVE.L (A4), A4 /* Reinstate the A4 register so we can use E code */
  sendmsg()
  MOVEM.L (A7)+, D0-D7/A0-A6
  MOVE.L patch(PC), -(A7)
  RTS
