OPT MODULE

MODULE  'oomodules/list/associativeArray',
        'oomodules/library/exec/port',

        'exec/ports'

EXPORT OBJECT portList OF associativeArray
/****** associativeArray/portList ******************************

    NAME
        portList() of associativeArray --

    SYNOPSIS
        associativeArray.portList(LONG)

        associativeArray.portList(signalMask)

    FUNCTION

    INPUTS
        signalMask:LONG -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        associativeArray

********/
  signalMask
ENDOBJECT

PROC add(p:PTR TO mp,key) OF portList
/****** portList/add ******************************

    NAME
        add() of portList --

    SYNOPSIS
        portList.add(PTR TO mp, LONG)

        portList.add(p, key)

    FUNCTION

    INPUTS
        p:PTR TO mp -- 

        key:LONG -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        portList

********/
DEF port:PTR TO port

  port := wrapPort(p)

  SUPER self.set(key, port)
  self.signalMask := self.signalMask OR port.getSignalMask()

ENDPROC

PROC delete(port:PTR TO port) OF portList
/****** portList/delete ******************************

    NAME
        delete() of portList --

    SYNOPSIS
        portList.delete(PTR TO port)

        portList.delete(port)

    FUNCTION

    INPUTS
        port:PTR TO port -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        portList

********/

  IF port = NIL THEN RETURN

  self.remove(port)
  END port

ENDPROC

PROC wait() OF portList IS Wait(self.signalMask)
/****** portList/wait ******************************

    NAME
        wait() of portList --

    SYNOPSIS
        portList.wait()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        portList

********/

PROC waitAndGet(mode="exec") OF portList
/****** portList/waitAndGet ******************************

    NAME
        waitAndGet() of portList --

    SYNOPSIS
        portList.waitAndGet(LONG="exec")

        portList.waitAndGet(mode)

    FUNCTION

    INPUTS
        mode:LONG -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        portList

********/
DEF signal,
    port:PTR TO port,
    index=-1

  IF self.tail = 0 THEN RETURN

  signal := self.wait()

  REPEAT

    INC index
    port := self.val[index]

  UNTIL (signal AND port.getSignalMask())

->  WriteF('Message arrived at port \d.\n', port)

  RETURN port.getMsg(mode), self.key[index], port

ENDPROC

