/* $VER: battclock_protos.h 40.1 (17.5.1996) */
OPT NATIVE
MODULE 'target/exec/types'
MODULE 'target/exec/libraries'
{MODULE 'other/battclock'}

NATIVE {battclockbase} DEF battclockbase:PTR TO lib

NATIVE {resetBattClock} PROC
PROC resetBattClock( ) IS NATIVE {resetBattClock()} ENDNATIVE
NATIVE {readBattClock} PROC
PROC readBattClock( ) IS NATIVE {readBattClock()} ENDNATIVE !!ULONG
NATIVE {writeBattClock} PROC
PROC writeBattClock( time:ULONG ) IS NATIVE {writeBattClock(} time {)} ENDNATIVE
