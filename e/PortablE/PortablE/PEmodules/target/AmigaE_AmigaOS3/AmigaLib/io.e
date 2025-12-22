OPT NATIVE, INLINE
MODULE 'exec/io', 'exec/memory', 'exec/nodes', 'exec/ports'
{MODULE 'amigalib/io'}

NATIVE {beginIO} PROC
PROC beginIO( ioReq:PTR TO io ) IS NATIVE {beginIO(} ioReq {)} ENDNATIVE
NATIVE {createStdIO} PROC
PROC createStdIO( port:PTR TO mp ) IS NATIVE {createStdIO(} port {)} ENDNATIVE !!PTR TO iostd
NATIVE {deleteStdIO} PROC
PROC deleteStdIO( ioReq:PTR TO iostd ) IS NATIVE {deleteStdIO(} ioReq {)} ENDNATIVE
NATIVE {createExtIO} PROC
PROC createExtIO( port:PTR TO mp, ioSize:VALUE ) IS NATIVE {createExtIO(} port {,} ioSize {)} ENDNATIVE !!PTR TO io
NATIVE {deleteExtIO} PROC
PROC deleteExtIO( ioReq:PTR TO io ) IS NATIVE {deleteExtIO(} ioReq {)} ENDNATIVE
