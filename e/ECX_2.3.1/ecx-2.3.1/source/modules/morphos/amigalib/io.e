OPT MORPHOS, MODULE, EXPORT, PREPROCESS

-> aboxlib/io.e

MODULE 'exec/io',
       'exec/memory',
       'exec/nodes',
       'exec/ports',
       'morphos/emul/emulinterface',
       'morphos/emul/emulregs'

PROC beginIO(ioreq)
  LWZ R0, .device(R3:io)
  STW R0, REG_A6 -> base
  STW R3, REG_A1 -> ioreq
  LWZ R0, .emulcalldirectos(R2:emulhandle)
  MTSPR 9, R0
  ADDI R3, R0, -30   -> offset
  BCCTRL 20, 0 -> call function
ENDPROC NIL -> no return value

PROC createStdIO(port) IS CreateIORequest(port, SIZEOF iostd)
PROC deleteStdIO(ioReq) IS DeleteIORequest(ioReq)
PROC createExtIO(port, ioSize) IS CreateIORequest(port, ioSize)
PROC deleteExtIO(ioReq) IS DeleteIORequest(ioReq)











