/* $VER: battmem_protos.h 40.1 (17.5.1996) */
OPT NATIVE
MODULE 'target/exec/types'
MODULE 'target/exec/libraries'
{
#include <clib/battmem_protos.h>
struct Library *BattMemBase = NULL;
}
NATIVE {CLIB_BATTMEM_PROTOS_H} CONST

NATIVE {BattMemBase} DEF battmembase:PTR TO lib

NATIVE {ObtainBattSemaphore} PROC
PROC obtainBattSemaphore( ) IS NATIVE {ObtainBattSemaphore()} ENDNATIVE
NATIVE {ReleaseBattSemaphore} PROC
PROC releaseBattSemaphore( ) IS NATIVE {ReleaseBattSemaphore()} ENDNATIVE
NATIVE {ReadBattMem} PROC
PROC readBattMem( buffer:APTR, offset:ULONG, length:ULONG ) IS NATIVE {ReadBattMem(} buffer {,} offset {,} length {)} ENDNATIVE !!ULONG
NATIVE {WriteBattMem} PROC
PROC writeBattMem( buffer:APTR, offset:ULONG, length:ULONG ) IS NATIVE {WriteBattMem(} buffer {,} offset {,} length {)} ENDNATIVE !!ULONG
