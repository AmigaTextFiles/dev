OPT AMIGAOS4, MODULE, EXPORT, PREPROCESS

-> amigalib/io.e

MODULE 'exec/io',
       'exec/memory',
       'exec/nodes',
       'exec/ports'

PROC beginIO(ioreq) IS BeginIO(ioreq)

PROC createStdIO(port) IS CreateIORequest(port, SIZEOF iostd)
PROC deleteStdIO(ioReq) IS DeleteIORequest(ioReq)
PROC createExtIO(port, ioSize) IS CreateIORequest(port, ioSize)
PROC deleteExtIO(ioReq) IS DeleteIORequest(ioReq)











