OPT NATIVE, INLINE
/*PUBLIC*/ MODULE 'target/amigalib'
MODULE 'exec/io', 'exec/memory', 'exec/nodes', 'exec/ports'

PROC beginIO( ioReq:PTR TO io ) IS NATIVE {BeginIO(} ioReq {)} ENDNATIVE
PROC createStdIO( port:PTR TO mp ) IS NATIVE {CreateStdIO(} port {)} ENDNATIVE !!PTR TO iostd
PROC deleteStdIO( ioReq:PTR TO iostd ) IS NATIVE {DeleteStdIO(} ioReq {)} ENDNATIVE
PROC createExtIO( port:PTR TO mp, ioSize:VALUE ) IS NATIVE {CreateExtIO(} port {,} ioSize {)} ENDNATIVE !!PTR TO io
PROC deleteExtIO( ioReq:PTR TO io ) IS NATIVE {DeleteExtIO(} ioReq {)} ENDNATIVE
