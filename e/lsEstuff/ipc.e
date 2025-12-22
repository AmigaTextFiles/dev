OPT MODULE

MODULE 'exec/ports'
MODULE 'exec/nodes'
MODULE 'dos/dos'

EXPORT OBJECT waitSigs
   PRIVATE
   alloced_sigs
   added_sigs
   received_sigs
ENDOBJECT

EXPORT OBJECT newPort
   PRIVATE
   mp:PTR TO mp
   active:INT
ENDOBJECT

OBJECT rajraj
   private:mn
ENDOBJECT

OBJECT newMsg OF rajraj
   PRIVATE
   sendertask
   type
   cmnd
   data
   reply
ENDOBJECT

PROC getType() OF newMsg IS self.type

PROC getCmnd() OF newMsg IS self.cmnd

PROC getData() OF newMsg IS self.data

PROC do(newPort:PTR TO newPort, type=NIL, cmnd=NIL, data=NIL) OF newMsg
   self.private.ln.type := NT_MESSAGE
   self.private.length := SIZEOF newMsg
   self.type := IF type = NIL THEN self.sendertask ELSE type
   self.cmnd := cmnd
   self.data := data
   IF newPort.isActive() = FALSE THEN RETURN -1
   PutMsg(newPort.mp, self)
   Wait(SIGBREAKF_CTRL_F)
ENDPROC self.reply

PROC doName(portname, type=NIL, cmnd=NIL, data=NIL) OF newMsg
   DEF newPort:newPort
   newPort.mp := FindPort(portname)
   IF newPort.mp THEN self.do(newPort, type, cmnd, data)
ENDPROC newPort.mp

PROC reply(reply=NIL) OF newMsg
   self.reply := reply
   Signal(self.sendertask, SIGBREAKF_CTRL_F)
ENDPROC

PROC newMsg() OF newMsg
   self.sendertask:=FindTask(0)
ENDPROC

PROC getReply() OF newMsg IS self.reply

PROC end() OF newMsg IS NIL

->----------NEWMSG---------

/* msg TYPES */
EXPORT CONST NMT_CTRL=-10, NMT_STREAM=-20, NMT_MISC=-30, NMT_ERRORS=-40

EXPORT PROC doMsgQ(newPort, type=NIL, command=NIL, data=NIL)
   DEF msg:PTR TO newMsg, er
   NEW msg.newMsg()
   er := msg.do(newPort, type, command, data)
   END msg
ENDPROC er
 

->-------NEWPORT------------------

PROC newPort(name=NIL, pri=NIL) OF newPort
   self.mp := CreateMsgPort()
   IF self.mp = NIL THEN RETURN NIL
   self.mp.ln.name := name
   self.mp.ln.pri := pri
   IF name THEN AddPort(self.mp)
   self.active := TRUE
ENDPROC self.mp

PROC end() OF newPort
   self.active := FALSE
   IF self.mp.ln.name THEN RemPort(self.mp)
   self.clear()
   DeleteMsgPort(self.mp)
ENDPROC

PROC mp() OF newPort IS self.mp

PROC clear() OF newPort
   DEF newMsg:PTR TO newMsg
   WHILE newMsg:=self.collect()
      IF newMsg THEN newMsg.reply(NIL)
   ENDWHILE
ENDPROC

PROC isActive() OF newPort IS self.active

PROC wait() OF newPort
ENDPROC WaitPort(self.mp)

PROC collect() OF newPort
ENDPROC GetMsg(self.mp)

PROC collectlast() OF newPort
   DEF msg, lastmsg=NIL:PTR TO newMsg
   WHILE (msg:=self.collect())
      IF lastmsg THEN lastmsg.reply()
      lastmsg:=msg
   ENDWHILE
ENDPROC lastmsg

PROC getSigF() OF newPort
ENDPROC Shl(1, self.mp.sigbit)


->----------SIGNALS---------------------

PROC waitSigs(signalnum=NIL) OF waitSigs
   DEF signum
   IF signum THEN signum := self.allocSigN(signalnum)
ENDPROC signum

PROC allocSigN(signalnum) OF waitSigs
   DEF signum
   signum := AllocSignal(signalnum)
   IF signum = -1 THEN RETURN -1
   self.alloced_sigs := self.alloced_sigs OR Shl(1, signum)
ENDPROC signum

PROC freeSigN(signalnum) OF waitSigs
   DEF bits
   bits := Shl(1, signalnum)
   bits := Not(bits)
   self.alloced_sigs := self.alloced_sigs AND bits
   FreeSignal(signalnum)
ENDPROC

PROC addSigF(sigf) OF waitSigs
   self.added_sigs := self.added_sigs OR sigf
ENDPROC

PROC remSigF(sigf) OF waitSigs
   sigf := Not(sigf)
   self.added_sigs := self.added_sigs AND sigf
ENDPROC

PROC addSigN(signum) OF waitSigs
   self.added_sigs := self.added_sigs OR Shl(1, signum)
ENDPROC

PROC remSigN(signum) OF waitSigs
   self.added_sigs := self.added_sigs AND Not(Shl(1, signum))
ENDPROC

PROC wait() OF waitSigs
   self.received_sigs := Wait(self.alloced_sigs OR self.added_sigs)
ENDPROC self.received_sigs

PROC getSigF() OF waitSigs IS self.alloced_sigs OR self.added_sigs

PROC end() OF waitSigs
   DEF sigbitcount=NIL, sig
   WHILE self.alloced_sigs
      sig:=Shl(1, sigbitcount)
      IF sig AND self.alloced_sigs
         FreeSignal(sigbitcount)
         self.alloced_sigs := self.alloced_sigs AND Not(sig)
      ENDIF
      sigbitcount ++
   ENDWHILE
ENDPROC

