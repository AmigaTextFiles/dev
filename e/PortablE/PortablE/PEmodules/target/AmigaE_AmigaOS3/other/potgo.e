/* $VER: potgo_protos.h 40.1 (17.5.1996) */
OPT NATIVE
MODULE 'target/exec/types'
MODULE 'target/exec/libraries'
{MODULE 'other/potgo'}

NATIVE {potgobase} DEF potgobase:PTR TO lib

NATIVE {allocPotBits} PROC
PROC allocPotBits( bits:ULONG ) IS NATIVE {allocPotBits(} bits {)} ENDNATIVE !!UINT
NATIVE {freePotBits} PROC
PROC freePotBits( bits:ULONG ) IS NATIVE {freePotBits(} bits {)} ENDNATIVE
NATIVE {writePotgo} PROC
PROC writePotgo( word:ULONG, mask:ULONG ) IS NATIVE {writePotgo(} word {,} mask {)} ENDNATIVE
