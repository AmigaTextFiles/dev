OPT MODULE

MODULE  'oomodules/library/exec/port',

        'exec/ports',
        'exec/nodes',

        'rexx/storage',

        'rexxsyslib',
        'gadtools'

EXPORT OBJECT arexxPort OF port
/****** port/arexxPort ******************************

    NAME
        arexxPort() of port --

    SYNOPSIS
        port.arexxPort(LONG, LONG)

        port.arexxPort(result1, result2)

    FUNCTION

    INPUTS
        result1:LONG -- 

        result2:LONG -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        port

********/
  result1
  result2
ENDOBJECT

PROC replyMsg(mode="exec") OF arexxPort
/****** arexxPort/replyMsg ******************************

    NAME
        replyMsg() of arexxPort --

    SYNOPSIS
        arexxPort.replyMsg(LONG="exec")

        arexxPort.replyMsg(mode)

    FUNCTION

    INPUTS
        mode:LONG -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        arexxPort

********/
DEF msg:PTR TO rexxmsg

  IF self.lastMessage = NIL THEN RETURN

  msg := self.lastMessage

  msg.result1:= self.result1
  msg.result2:= self.result2

  IF msg.action AND RXFF_RESULT AND (self.result1=0) AND (self.result2<>NIL)
    msg.result2:=CreateArgstring(self.result2,StrLen(self.result2))
  ENDIF

  ReplyMsg(msg)

ENDPROC

PROC setResults(result1, result2) OF arexxPort
/****** arexxPort/setResults ******************************

    NAME
        setResults() of arexxPort --

    SYNOPSIS
        arexxPort.setResults(LONG, LONG)

        arexxPort.setResults(result1, result2)

    FUNCTION

    INPUTS
        result1:LONG -- 

        result2:LONG -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        arexxPort

********/

  self.result1 := result1
  self.result2 := result2

ENDPROC

PROC getArgStr(number) OF arexxPort
/****** arexxPort/getArgStr ******************************

    NAME
        getArgStr() of arexxPort --

    SYNOPSIS
        arexxPort.getArgStr(LONG)

        arexxPort.getArgStr(number)

    FUNCTION

    INPUTS
        number:LONG -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        arexxPort

********/

  RETURN self.lastMessage::rexxmsg.args[number]

ENDPROC

