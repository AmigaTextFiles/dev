/* $VER: potgo_protos.h 40.1 (17.5.1996) */
OPT NATIVE
MODULE 'target/exec/types'
MODULE 'target/exec/libraries'
{
#include <clib/potgo_protos.h>
struct Library *PotgoBase = NULL;
}
NATIVE {CLIB_POTGO_PROTOS_H} CONST

NATIVE {PotgoBase} DEF potgobase:PTR TO lib

NATIVE {AllocPotBits} PROC
PROC allocPotBits( bits:ULONG ) IS NATIVE {AllocPotBits(} bits {)} ENDNATIVE !!UINT
NATIVE {FreePotBits} PROC
PROC freePotBits( bits:ULONG ) IS NATIVE {FreePotBits(} bits {)} ENDNATIVE
NATIVE {WritePotgo} PROC
PROC writePotgo( word:ULONG, mask:ULONG ) IS NATIVE {WritePotgo(} word {,} mask {)} ENDNATIVE
