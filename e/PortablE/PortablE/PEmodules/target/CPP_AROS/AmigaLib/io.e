OPT NATIVE, INLINE
/*PUBLIC*/ MODULE 'target/amigalib'
MODULE 'exec/io', 'exec/memory', 'exec/nodes', 'exec/ports'
MODULE 'exec/types'

PROC beginIO(ioReq:PTR TO io) IS NATIVE {BeginIO(} ioReq {)} ENDNATIVE
PROC createStdIO(port:PTR TO mp) IS NATIVE {CreateStdIO(} port {)} ENDNATIVE !!PTR TO iostd
PROC deleteStdIO(ioreq:PTR TO iostd) IS NATIVE {DeleteStdIO(} ioreq {)} ENDNATIVE
PROC createExtIO(port:PTR TO mp, iosize:ULONG) IS NATIVE {CreateExtIO(} port {,} iosize {)} ENDNATIVE !!PTR TO io
PROC deleteExtIO(ioreq:PTR TO io) IS NATIVE {DeleteExtIO(} ioreq {)} ENDNATIVE
