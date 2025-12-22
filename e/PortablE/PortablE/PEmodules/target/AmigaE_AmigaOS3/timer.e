/* AmigaE module, for $VER: timer_protos.h 40.1 (17.5.1996) */
OPT NATIVE, INLINE
PUBLIC MODULE 'target/devices/timer'
MODULE 'target/devices/timer'
MODULE 'target/exec/devices', 'target/exec'
{MODULE 'timer'}

NATIVE {timerbase} DEF timerbase:NATIVE {LONG} PTR TO dd		->AmigaE does not automatically initialise this

NATIVE {AddTime} PROC
PROC AddTime( dest:PTR TO timeval, src:PTR TO timeval ) IS NATIVE {AddTime(} dest {,} src {)} ENDNATIVE
NATIVE {SubTime} PROC
PROC SubTime( dest:PTR TO timeval, src:PTR TO timeval ) IS NATIVE {SubTime(} dest {,} src {)} ENDNATIVE
NATIVE {CmpTime} PROC
PROC CmpTime( dest:PTR TO timeval, src:PTR TO timeval ) IS NATIVE {CmpTime(} dest {,} src {)} ENDNATIVE !!VALUE
NATIVE {ReadEClock} PROC
PROC ReadEClock( dest:PTR TO eclockval ) IS NATIVE {ReadEClock(} dest {)} ENDNATIVE !!ULONG
NATIVE {GetSysTime} PROC
PROC GetSysTime( dest:PTR TO timeval ) IS NATIVE {GetSysTime(} dest {)} ENDNATIVE
