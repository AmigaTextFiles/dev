/* setf.e -- a SnoopDos-like program to monitor calls to OpenLibrary() */

OPT OSVERSION=37

MODULE 'dos/dos', 'exec/ports', 'exec/tasks', 'exec/nodes', 'exec/memory'

CONST OFFSET=$fdd8  /* execbase offset of OpenLibrary() */

/* "mymsg" must begin with the standard message object "mn", followed by
   any kind of data (in this case, two pointers [to strings]).
*/
OBJECT mymsg
  msg:mn
  s, t
ENDOBJECT

/* "port" will be used from the patched routine, too, so it's global */
DEF port:PTR TO mp

/* You can change the library function to be patched by changing OFFSET
   and the "execbase" in the *two* calls to SetFunction().  If you want to
   patch a library other than dos, exec, graphics and intuition you need
   to OpenLibrary() it first.
   (Note: some [old?] libraries cannot be patched in this way.  Also, some
   functions in some libraries can't be patched like this either!  Even the
   RKRM's aren't too clear about this...)
*/
PROC main()
  DEF ps, us, loop, sig, oldf
  IF port:=CreateMsgPort()
    Forbid()     /* Don't let anyone mess things up... */
    IF oldf:=SetFunction(execbase, OFFSET, {newf})
      PutLong({patch}, oldf)
      Permit()    /* Now we can let everyone else back in */
      LEA store(PC), A0
      MOVE.L A4, (A0)    /* Store the A4 register... */
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
      SetFunction(execbase, OFFSET, oldf)
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
    WriteF('Task \l\s[25] wants \r\s[20]\n',
           IF msg.t THEN msg.t ELSE '*unnamed*',
           IF msg.s THEN msg.s ELSE '*unnamed library*')
    ReplyMsg(msg)
    DisposeLink(msg.s)
    DisposeLink(msg.t)
    Dispose(msg)
  ENDWHILE
ENDPROC

/* Send a message to the patching process */
PROC sendmsg()
  DEF m:PTR TO mymsg, s, tsk:tc, l:ln
  MOVE.L A1, s
  /* Allocate a new message */
  m:=New(SIZEOF mymsg)
  IF s
    m.s:=String(StrLen(s))
    StrCopy(m.s,s,ALL)
  ENDIF
  tsk:=FindTask(NIL)   /* Find out who we are */
  m.t:=NIL
  IF tsk
    l:=tsk.ln
    IF l AND l.name
      m.t:=String(StrLen(l.name))
      StrCopy(m.t, l.name, ALL)
    ENDIF
  ENDIF
  PutMsg(port, m)
ENDPROC

/* Place to store A4 register */
store:  LONG 0
/* Place to store real call */
patch:  LONG 0

/* The new routine which will replace the original library function */
newf:
  MOVEM.L D0-D7/A0-A6, -(A7)
  LEA store(PC), A0
  MOVE.L (A0), A4 /* Reinstate the A4 register so we can use E code */
  sendmsg()
  MOVEM.L (A7)+, D0-D7/A0-A6
  MOVE.L patch(PC), -(A7)
  RTS
