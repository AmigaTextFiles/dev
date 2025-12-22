/* $VER: cia_protos.h 40.1 (17.5.1996) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/interrupts', 'target/exec/libraries'
{#include <clib/cia_protos.h>}
NATIVE {CLIB_CIA_PROTOS_H} CONST

NATIVE {AddICRVector} PROC
PROC addICRVector( resource:PTR TO lib, iCRBit:VALUE, interrupt:PTR TO is ) IS NATIVE {AddICRVector(} resource {,} iCRBit {,} interrupt {)} ENDNATIVE !!PTR TO is
NATIVE {RemICRVector} PROC
PROC remICRVector( resource:PTR TO lib, iCRBit:VALUE, interrupt:PTR TO is ) IS NATIVE {RemICRVector(} resource {,} iCRBit {,} interrupt {)} ENDNATIVE
NATIVE {AbleICR} PROC
PROC ableICR( resource:PTR TO lib, mask:VALUE ) IS NATIVE {AbleICR(} resource {,} mask {)} ENDNATIVE !!INT
NATIVE {SetICR} PROC
PROC setICR( resource:PTR TO lib, mask:VALUE ) IS NATIVE {SetICR(} resource {,} mask {)} ENDNATIVE !!INT
