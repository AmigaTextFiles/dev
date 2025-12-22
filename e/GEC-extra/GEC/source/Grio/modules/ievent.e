OPT MODULE
OPT REG=5

MODULE 'exec/ports','exec/io','exec/nodes'
MODULE 'devices/input','devices/inputevent'
MODULE 'grio/ports'


EXPORT OBJECT ievent
  PRIVATE
  io:iostd
  ie:inputevent
  dev
ENDOBJECT


PROC new() OF ievent
IF (self.io.mn.replyport:=createPort())
   self.io.length:=SIZEOF inputevent
   self.io.data:=self.ie
   self.io.flags:=IOB_QUICK
   IF OpenDevice('input.device',0,self.io,0)=NIL
      RETURN self.dev:=TRUE
   ENDIF
ENDIF
ENDPROC FALSE

PROC break() OF ievent PRIVATE
IF CheckIO(self.io)=NIL
   AbortIO(self.io)
   WaitIO(self.io)
ENDIF
ENDPROC D0

PROC end() OF ievent
IF self.dev
   self.break()
   CloseDevice(self.io)
ENDIF
IF self.io.mn.replyport
   deletePort(D0)
ENDIF
ENDPROC D0

PROC setEvent() OF ievent PRIVATE
self.break()
self.io.command:=IND_WRITEEVENT
DoIO(self.io)
ENDPROC D0


PROC getMouse(adrx=0,adry=0) OF ievent
DEF x,y
self.setEvent()
x:=self.ie.x
y:=self.ie.y
IF adrx THEN ^adrx:=x
IF adry THEN ^adry:=y
ENDPROC x,y


PROC getQualifier(adrqual=0) OF ievent
DEF qual
self.setEvent()
qual:=self.ie.qualifier
IF adrqual THEN ^adrqual:=qual
ENDPROC qual


PROC getCode(adrcode=0) OF ievent
DEF code
self.setEvent()
code:=self.ie.code
IF adrcode THEN ^adrcode:=code
ENDPROC code


PROC getClass(adrclass=0) OF ievent
DEF class
self.setEvent()
class:=self.ie.class
IF adrclass THEN ^adrclass:=class
ENDPROC class

/*
PROC getIEvent() OF ievent
ENDPROC D0
*/


