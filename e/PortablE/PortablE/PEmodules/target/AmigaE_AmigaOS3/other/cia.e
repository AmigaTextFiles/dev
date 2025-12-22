/* $VER: cia_protos.h 40.1 (17.5.1996) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/interrupts', 'target/exec/libraries'
{MODULE 'other/cia'}

NATIVE {addICRVector} PROC
PROC addICRVector( resource:PTR TO lib, iCRBit:VALUE, interrupt:PTR TO is ) IS NATIVE {addICRVector(} resource {,} iCRBit {,} interrupt {)} ENDNATIVE !!PTR TO is
NATIVE {remICRVector} PROC
PROC remICRVector( resource:PTR TO lib, iCRBit:VALUE, interrupt:PTR TO is ) IS NATIVE {remICRVector(} resource {,} iCRBit {,} interrupt {)} ENDNATIVE
NATIVE {ableICR} PROC
PROC ableICR( resource:PTR TO lib, mask:VALUE ) IS NATIVE {ableICR(} resource {,} mask {)} ENDNATIVE !!INT
NATIVE {setICR} PROC
PROC setICR( resource:PTR TO lib, mask:VALUE ) IS NATIVE {setICR(} resource {,} mask {)} ENDNATIVE !!INT
