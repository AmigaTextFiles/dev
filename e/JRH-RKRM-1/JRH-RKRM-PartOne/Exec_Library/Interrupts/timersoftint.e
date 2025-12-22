-> timersoftint.e - Timer device software interrupt message port example.

-> E-Note: we need eCodeSoftInt() in order to execute E code as an interrupt
MODULE 'amigalib/io',
       'amigalib/lists',
       'other/ecode',
       'devices/timer',
       'dos/dos',
       'exec/interrupts',
       'exec/io',
       'exec/memory',
       'exec/nodes',
       'exec/ports'

ENUM ERR_NONE, ERR_DEVICE, ERR_ECODE, ERR_TIMER

RAISE ERR_DEVICE IF OpenDevice()<>0

CONST MICRO_DELAY=1000

ENUM OFF, ON, STOPPED

OBJECT tsiData
  counter
  flag
  port:PTR TO mp
ENDOBJECT

DEF tsidata=NIL:PTR TO tsiData

PROC main() HANDLE
  DEF port=NIL:PTR TO mp, softint=NIL:PTR TO is, tr:PTR TO timerequest,
      endcount, code

  -> Allocate message port, data and interrupt objects.  Don't use createPort()
  -> or CreateMsgPort() since they allocate a signal (don't need that) for a
  -> PA_SIGNAL type port.  We need PA_SOFTINT.
  tsidata:=NewM(SIZEOF tsiData, MEMF_PUBLIC OR MEMF_CLEAR)
  port:=NewM(SIZEOF mp, MEMF_PUBLIC OR MEMF_CLEAR)
  newList(port.msglist)  -> Initialise message list
  softint:=NewM(SIZEOF is, MEMF_PUBLIC OR MEMF_CLEAR)

  -> Set up the (software) interrupt structure.  Note that this task runs at
  -> priority 0.  Software interrupts may only be priority -32, -16, 0, +16,
  -> +32. Also not that the correct node type for a software interrupt is
  -> NT_INTERRUPT.  (NT_SOFTINT is an internal Exec flag).  This is the same
  -> setup as that for a software interrupt which you Cause().
  -> E-Note: We can initialise data here to contain a pointer to shared data
  ->         structures.  The interrupt routine will receive the data in A1.
  -> E-Note: eCodeSoftInt() protects an E function and preserves non-scratch
  ->         registers so you can call it from, for instance, interrupts.
  IF NIL=(code:=eCodeSoftInt({tsoftcode})) THEN Raise(ERR_ECODE)
  softint.code:=code  -> The software interrupt routine
  softint.data:=tsidata
  softint.ln.pri:=0

  port.ln.type:=NT_MSGPORT  -> Set up the PA_SOFTINT message port (no need to
  port.flags:=PA_SOFTINT    -> make this port public).
  port.sigtask:=softint  -> Pointer to interrupt object

  -> Allocate timerequest
  IF NIL=(tr:=createExtIO(port, SIZEOF timerequest)) THEN Raise(ERR_TIMER)

  -> Open timer.device.  0 is success
  OpenDevice('timer.device', UNIT_MICROHZ, tr, 0)
  tsidata.flag:=ON  -> Init data structure to share globally.
  tsidata.port:=port

  -> Send of the first timerequest to start.  IMPORTANT: Do NOT beginIO() to
  -> any device other than audio or timer from within a software or hardware
  -> interrupt.  The beginIO() code may allocate memory, wait or perform other
  -> functions which are illegal or dangerous during interrupts.
  WriteF('starting softint.  CTRL-C to break...\n')

  tr.io.command:=TR_ADDREQUEST  -> Initial iorequest to start
  tr.time.micro:=MICRO_DELAY    -> software interrupt
  beginIO(tr)

  Wait(SIGBREAKF_CTRL_C)
  endcount:=tsidata.counter
  WriteF('timer softint counted \d milliseconds.\n', endcount)

  WriteF('Stopping timer...\n')
  tsidata.flag:=OFF

  WHILE tsidata.flag<>STOPPED DO Delay(10)
  CloseDevice(tr)

EXCEPT DO
  IF tr THEN deleteExtIO(tr)
  IF softint THEN Dispose(softint)
  IF port THEN Dispose(port)
  IF tsidata THEN Dispose(tsidata)
  SELECT exception
  CASE ERR_DEVICE;  WriteF('Couldn''t open timer.device\n')
  CASE ERR_ECODE;   WriteF('Ran out of memory in eCodeSoftInt()\n')
  CASE ERR_TIMER;   WriteF('Couldn''t create timerequest\n')
  CASE "MEM";       WriteF('Ran out of memory\n')
  ENDSELECT
ENDPROC

PROC tsoftcode(data)
  DEF tr:PTR TO timerequest
  -> E-Note: thanks to eCodeSoftInt() we get the softint.data as an argument,
  ->         so we could use that instead of the global tsidata.  This means
  ->         that tsidata could be made local to main()...

  -> Remove the message from the port.
  tr:=GetMsg(tsidata.port)

  -> Keep on going if main() hasn't set flag to OFF.
  IF tr AND (tsidata.flag=ON)
    -> Increment counter and re-send timerequest -- IMPORTANT: This
    -> self-perpetuating technique of calling beginIO() during a software
    -> interrupt may only be used with the audio and timer device.
    tsidata.counter:=tsidata.counter+1
    tr.io.command:=TR_ADDREQUEST
    tr.time.micro:=MICRO_DELAY
    beginIO(tr)
  ELSE
    -> Tell main() we're out of here.
    tsidata.flag:=STOPPED
  ENDIF
ENDPROC
