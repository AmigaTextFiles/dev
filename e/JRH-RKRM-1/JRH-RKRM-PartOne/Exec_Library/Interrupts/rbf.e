-> rbf.e - Serial receive buffer full interrupt handler example.
->
-> To receive characters, this example requires ASCII serial input at your
-> Amiga's current serial hardware baud rate (i.e., 9600 after reboot, else
-> last baud rate used).

-> E-Note: E does not (as of v3.1a) support Resources in the conventional way
MODULE 'other/ecode',
       'other/misc',
       'dos/dos',
       'exec/execbase',
       'exec/interrupts',
       'exec/nodes',
       'exec/memory',
       'hardware/custom',
       'hardware/intbits',
       'resources/misc'

ENUM ERR_NONE, ERR_BITS, ERR_ECODE, ERR_PORT, ERR_SIG

RAISE ERR_SIG IF AllocSignal()=-1

CONST BUFFERSIZE=256, NAMESIZE=32
CONST ALLOCEDBUFFER=BUFFERSIZE+2

OBJECT rbfData
  task
  signal
  bufferCount  -> E-Note: C version disagrees with Assembly handler!
  charBuffer[ALLOCEDBUFFER]:ARRAY
  flagBuffer[ALLOCEDBUFFER]:ARRAY
  name[NAMESIZE]:ARRAY
ENDOBJECT

-> E-Note: set-up "custom"
DEF custom=CUSTOMADDR:PTR TO custom

PROC main() HANDLE
  -> E-Note: to help with cleaning up, currentuser has been replaced by
  ->         portuser and bitsuser, both initialised to non-zero
  DEF allocname, rbfdata=NIL:PTR TO rbfData, portuser=-1, bitsuser=-1,
      signr=-1, serdevice, rbfint=NIL:PTR TO is, priorint:PTR TO is,
      priorenable, signal, exec:PTR TO execbase
  -> E-Note: get the right type for execbase
  exec:=execbase

  allocname:='rbf-example'

  miscbase:=OpenResource('misc.resource')

  -> Allocate the serial port registers.
  IF portuser:=allocMiscResource(MR_SERIALPORT, allocname)
    -> Hey! Someone's got it!
    WriteF('serial hardware allocated by \s. Trying to remove it\n', portuser)

    Forbid()
    IF serdevice:=FindName(exec.devicelist, portuser) THEN RemDevice(serdevice)
    Permit()

    IF portuser:=allocMiscResource(MR_SERIALPORT, allocname)  -> And try again
      -> E-Note: error if still allocated
      Raise(ERR_PORT)
    ENDIF
  ENDIF

  -> Get the serial control bits.  (Give up if allocated.)
  IF bitsuser:=allocMiscResource(MR_SERIALBITS, allocname) THEN Raise(ERR_BITS)
  -> Got them both
  WriteF('serial hardware allocated\n')

  -> Allocate a signal bit for the interrupt handler to signal us.
  signr:=AllocSignal(-1)

  rbfint:=NewM(SIZEOF is, MEMF_PUBLIC OR MEMF_CLEAR)
  rbfdata:=NewM(SIZEOF rbfData, MEMF_PUBLIC OR MEMF_CLEAR)
  rbfdata.task:=FindTask(NIL)   -> Init rbfdata object
  rbfdata.signal:=Shl(1, signr)

  rbfint.ln.type:=NT_INTERRUPT  -> Init interrupt node.
  -> E-Note: copy *safely* to rbfdata.name
  AstrCopy(rbfdata.name, allocname, NAMESIZE)
  rbfint.ln.name:=rbfdata.name
  rbfint.data:=rbfdata
  rbfint.code:=eCodeIntHandler({rbfHandler})
  IF rbfint.code=NIL THEN Raise(ERR_ECODE)

  -> Save state of RBF and interrupt disable it.
  priorenable:=custom.intenar AND INTF_RBF
  custom.intena:=INTF_RBF
  IF priorint:=SetIntVector(INTB_RBF, rbfint)
    WriteF('replaced the \s RBF interrupt handler\n', priorint.ln.name)
  ENDIF

  WriteF('enabling RBF interrupt\n')
  custom.intena:=INTF_SETCLR OR INTF_RBF

  WriteF('waiting for buffer to fill up. Use CTRL-C to break\n')
  signal:=Wait(Shl(1, signr) OR SIGBREAKF_CTRL_C)

  IF signal AND SIGBREAKF_CTRL_C THEN WriteF('>break<\n')
  WriteF('Character buffer contains:\n\s\n', rbfdata.charBuffer)

  custom.intena:=INTF_RBF  -> Restore previous handler.
  SetIntVector(INTB_RBF, priorint)  -> Enable it if it was enabled before.
  IF priorenable THEN custom.intena:=INTF_SETCLR OR INTF_RBF

EXCEPT DO
  -> E-Note: these next two aren't really necessary
  IF rbfdata THEN Dispose(rbfdata)
  IF rbfint THEN Dispose(rbfint)
  IF signr<>-1 THEN FreeSignal(signr)
  -> Release serial hardware
  IF bitsuser=NIL THEN freeMiscResource(MR_SERIALBITS)
  IF portuser=NIL THEN freeMiscResource(MR_SERIALPORT)
  -> There is no 'CloseResource()' function
  SELECT exception
  CASE ERR_BITS;   WriteF('Serial control already allocated by \s\n', bitsuser)
  CASE ERR_ECODE;  WriteF('Ran out of memory in eCodeIntHandler()\n')
  CASE ERR_PORT;   WriteF('Serial hardware already allocated by \s\n', portuser)
  CASE ERR_SIG;    WriteF('Can''t allocate signal\n')
  CASE "MEM";      WriteF('Ran out of memory\n')
  ENDSELECT
ENDPROC

-> Note - This simple handler just receives one buffer full of serial
-> input data, signals main, then ignores all subsequent serial data.

-> E-Note: we could use Assembly, but we'll show how to use an E PROC
-> E-Note: you get rbfint.data as first arg, interrupt flags as second
PROC rbfHandler(data:PTR TO rbfData, intflags)
  DEF input
  IF data.bufferCount<BUFFERSIZE
    input:=custom.serdatr
    data.charBuffer[data.bufferCount]:=input AND $FF
    data.flagBuffer[data.bufferCount]:=Shr(input, 8) AND $FF
    data.bufferCount:=data.bufferCount+1
    IF data.bufferCount=BUFFERSIZE THEN Signal(data.task, data.signal)
  ENDIF
  custom.intreq:=INTF_RBF
ENDPROC
