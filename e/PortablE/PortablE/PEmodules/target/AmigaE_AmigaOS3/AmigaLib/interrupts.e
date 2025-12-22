OPT NATIVE, INLINE
MODULE 'graphics/graphint', 'exec/types'
{MODULE 'amigalib/interrupts'}

NATIVE {addTOF} PROC
PROC addTOF( i:PTR TO isrvstr, p:PTR, a:APTR ) IS NATIVE {addTOF(} i {,} p {,} a {)} ENDNATIVE
NATIVE {remTOF} PROC
PROC remTOF( i:PTR TO isrvstr ) IS NATIVE {remTOF(} i {)} ENDNATIVE
NATIVE {waitbeam} PROC
PROC waitbeam( b:VALUE ) IS NATIVE {waitbeam(} b {)} ENDNATIVE
