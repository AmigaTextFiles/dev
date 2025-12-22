OPT NATIVE, INLINE
/*PUBLIC*/ MODULE 'target/amigalib'
MODULE 'graphics/graphint', 'exec/types'

->Not supported for some reason: PROC addTOF( i:PTR TO isrvstr, p:PTR /*LONG (*p)(APTR args)*/, a:APTR ) IS NATIVE {AddTOF(} i {, (LONG (*)(APTR)) } p {,} a {)} ENDNATIVE
->Not supported for some reason: PROC remTOF( i:PTR TO isrvstr ) IS NATIVE {RemTOF(} i {)} ENDNATIVE
->Not supported for some reason: PROC waitbeam( b:VALUE ) IS NATIVE {waitbeam(} b {)} ENDNATIVE
