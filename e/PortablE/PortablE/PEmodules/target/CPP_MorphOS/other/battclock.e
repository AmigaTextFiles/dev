/* $VER: battclock_protos.h 40.1 (17.5.1996) */
OPT NATIVE
MODULE 'target/exec/types'
MODULE 'target/exec/libraries'
{
#include <clib/battclock_protos.h>
struct Library *BattClockBase = NULL;
}
NATIVE {CLIB_BATTCLOCK_PROTOS_H} CONST

NATIVE {BattClockBase} DEF battclockbase:PTR TO lib

NATIVE {ResetBattClock} PROC
PROC resetBattClock( ) IS NATIVE {ResetBattClock()} ENDNATIVE
NATIVE {ReadBattClock} PROC
PROC readBattClock( ) IS NATIVE {ReadBattClock()} ENDNATIVE !!ULONG
NATIVE {WriteBattClock} PROC
PROC writeBattClock( time:ULONG ) IS NATIVE {WriteBattClock(} time {)} ENDNATIVE
