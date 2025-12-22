OPT NATIVE, INLINE
/*PUBLIC*/ MODULE 'target/amigalib'
MODULE 'graphics/graphint', 'exec/types'

PROC addTOF( i:PTR TO isrvstr, p:PTR /*LONG (*p)(APTR args)*/, a:APTR ) IS AddTOF(i, p, a)
PROC remTOF( i:PTR TO isrvstr ) IS RemTOF(i)
->Not currently available: PROC waitbeam( b:VALUE ) IS Waitbeam(b)
