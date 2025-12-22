-> FOLD OPTS
OPT MODULE
-> ENDFOLD
-> FOLD CONSTS
EXPORT CONST NUM_MSG=4
CONST MSG_MAXSIZE=256
-> ENDFOLD
-> FOLD OBJECTS
EXPORT OBJECT messages PRIVATE
  message[NUM_MSG]:ARRAY OF LONG
ENDOBJECT
-> ENDFOLD

-> FOLD new
EXPORT PROC new() OF messages

  -> set messages
  self.set(0,'InfraFace %lu.%lu © 1995-%lu by %s')
  self.set(1,'%lu times per second')

ENDPROC
-> ENDFOLD
-> FOLD end
EXPORT PROC end() OF messages IS EMPTY
-> ENDFOLD
-> FOLD format
EXPORT PROC format() OF messages
  DEF string[MSG_MAXSIZE]:STRING

  -> make filled-in strings
  self.set(0,cloneStr(StringF(string,self.get(0),1,6,1995,'Leon Woestenberg')))

ENDPROC
-> ENDFOLD
-> FOLD set
EXPORT PROC set(messagenum,message) OF messages
  self.message[messagenum]:=message
ENDPROC
-> ENDFOLD
-> FOLD get
EXPORT PROC get(messagenum) OF messages IS self.message[messagenum]
-> ENDFOLD

-> FOLD cloneStr
PROC cloneStr(string)
  DEF newstring
  AstrCopy(newstring:=String(StrLen(string)+SIZEOF CHAR),string)
ENDPROC newstring
-> ENDFOLD

