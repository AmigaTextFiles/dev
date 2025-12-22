OPT NATIVE, INLINE, POINTER
/*PUBLIC*/ MODULE /*'target/amigalib',*/ 'target/exec'
MODULE 'exec/io', 'exec/memory', 'exec/nodes', 'exec/ports'

PROC beginIO(ioReq:PTR TO io) IS NATIVE {IExec->BeginIO(} ioReq {)} ENDNATIVE

PROC createStdIO(port:PTR TO mp) IS CreateIORequest(port, SIZEOF iostd) !!VALUE!!PTR TO iostd

PROC deleteStdIO(ioReq:PTR TO iostd) IS DeleteIORequest(ioReq !!VALUE!!APTR)

PROC createExtIO(port:PTR TO mp, ioSize:VALUE) IS CreateIORequest(port, ioSize) !!VALUE!!PTR TO io

PROC deleteExtIO(ioReq:PTR TO io) IS DeleteIORequest(ioReq !!VALUE!!APTR)
