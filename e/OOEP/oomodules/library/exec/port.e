OPT MODULE

MODULE  'oomodules/object',

        'exec/ports',
        'exec/nodes',

        'gadtools'

EXPORT OBJECT port OF object
/****** object/port ******************************

    NAME
        port() of object --

    SYNOPSIS
        object.port(PTR TO mp, PTR TO mn)

        object.port(mp, lastMessage)

    FUNCTION

    INPUTS
        mp:PTR TO mp -- 

        lastMessage:PTR TO mn -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        object

********/
  mp:PTR TO mp
  lastMessage:PTR TO mn
ENDOBJECT

PROC init() OF port
/****** port/init ******************************

    NAME
        init() of port --

    SYNOPSIS
        port.init()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        port

********/

  self.mp := CreateMsgPort()

  IF self.mp = NIL THEN Throw("port",'Unable to create message port.')

ENDPROC

PROC select(opts,i) OF port
/****** port/select ******************************

    NAME
        select() of port --

    SYNOPSIS
        port.select(LONG, LONG)

        port.select(opts, i)

    FUNCTION

    INPUTS
        opts:LONG -- 

        i:LONG -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        port

********/
DEF item

  item:=ListItem(opts,i)


  SELECT item

    CASE "name"

      INC i
      self.mp::ln.name := ListItem(opts,i)

    CASE "add"

      self.addToSystem()

  ENDSELECT

ENDPROC i

PROC getSignalMask() OF port IS Shl(1,self.mp.sigbit)
/****** port/getSignalMask ******************************

    NAME
        getSignalMask() of port --

    SYNOPSIS
        port.getSignalMask()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        port

********/

PROC getMsg(mode="exec") OF port
/****** port/getMsg ******************************

    NAME
        getMsg() of port --

    SYNOPSIS
        port.getMsg(LONG="exec")

        port.getMsg(mode)

    FUNCTION

    INPUTS
        mode:LONG -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        port

********/

  SELECT mode

    CASE "gadt"

      IF gadtoolsbase

        self.lastMessage := Gt_GetIMsg(self.mp)
        RETURN self.lastMessage

      ENDIF

    DEFAULT

      self.lastMessage := GetMsg(self.mp)
      RETURN self.lastMessage

  ENDSELECT

ENDPROC

PROC replyMsg(mode="exec") OF port
/****** port/replyMsg ******************************

    NAME
        replyMsg() of port --

    SYNOPSIS
        port.replyMsg(LONG="exec")

        port.replyMsg(mode)

    FUNCTION

    INPUTS
        mode:LONG -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        port

********/

  IF self.lastMessage = NIL THEN RETURN

  SELECT mode

    CASE "gadt"

      IF gadtoolsbase THEN Gt_ReplyIMsg(self.lastMessage)

    DEFAULT

      ReplyMsg(self.lastMessage)

  ENDSELECT

ENDPROC

PROC waitForSignalMask(mask) OF port IS Wait(mask)
/****** port/waitForSignalMask ******************************

    NAME
        waitForSignalMask() of port --

    SYNOPSIS
        port.waitForSignalMask(LONG)

        port.waitForSignalMask(mask)

    FUNCTION

    INPUTS
        mask:LONG -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        port

********/

PROC wait() OF port IS Wait(self.getSignalMask())
/****** port/wait ******************************

    NAME
        wait() of port --

    SYNOPSIS
        port.wait()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        port

********/

PROC end() OF port
/****** port/end ******************************

    NAME
        end() of port --

    SYNOPSIS
        port.end()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        port

********/

  IF self.mp = NIL THEN RETURN

  self.removeFromSystem()
  DeleteMsgPort(self.mp)

ENDPROC

PROC addToSystem() OF port
/****** port/addToSystem ******************************

    NAME
        addToSystem() of port --

    SYNOPSIS
        port.addToSystem()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        port

********/

  AddPort(self.mp)

ENDPROC

PROC removeFromSystem() OF port
/****** port/removeFromSystem ******************************

    NAME
        removeFromSystem() of port --

    SYNOPSIS
        port.removeFromSystem()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        port

********/

  RemPort(self.mp)

ENDPROC

EXPORT PROC wrapPort(p:PTR TO mp)
/****** /wrapPort ******************************

    NAME
        wrapPort() --

    SYNOPSIS
        wrapPort(PTR TO mp)

        wrapPort(p)

    FUNCTION

    INPUTS
        p:PTR TO mp -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO

********/
DEF port:PTR TO port

  NEW port.new()
  DeleteMsgPort(port.mp)
  port.mp := p

  RETURN port

ENDPROC

