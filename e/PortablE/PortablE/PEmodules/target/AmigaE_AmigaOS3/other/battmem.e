/* $VER: battmem_protos.h 40.1 (17.5.1996) */
OPT NATIVE
MODULE 'target/exec/types'
MODULE 'target/exec/libraries'
{MODULE 'other/battmem'}

NATIVE {battmembase} DEF battmembase:PTR TO lib

NATIVE {obtainBattSemaphore} PROC
PROC obtainBattSemaphore( ) IS NATIVE {obtainBattSemaphore()} ENDNATIVE
NATIVE {releaseBattSemaphore} PROC
PROC releaseBattSemaphore( ) IS NATIVE {releaseBattSemaphore()} ENDNATIVE
NATIVE {readBattMem} PROC
PROC readBattMem( buffer:APTR, offset:ULONG, length:ULONG ) IS NATIVE {readBattMem(} buffer {,} offset {,} length {)} ENDNATIVE !!ULONG
NATIVE {writeBattMem} PROC
PROC writeBattMem( buffer:APTR, offset:ULONG, length:ULONG ) IS NATIVE {writeBattMem(} buffer {,} offset {,} length {)} ENDNATIVE !!ULONG
