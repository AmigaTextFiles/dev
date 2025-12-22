/* $Id: timer_protos.h,v 1.8 2005/11/10 15:30:32 hjfrieden Exp $ */
OPT NATIVE, INLINE
PUBLIC MODULE 'target/devices/timer'
MODULE 'target/devices/timer'
MODULE 'target/exec/devices', 'target/exec'
{
#include <proto/timer.h>
}
{
struct Device* TimerBase = NULL;
struct TimerIFace* ITimer = NULL;
}
NATIVE {CLIB_TIMER_PROTOS_H} CONST
NATIVE {PROTO_TIMER_H} CONST
NATIVE {PRAGMA_TIMER_H} CONST
NATIVE {INLINE4_TIMER_H} CONST
NATIVE {TIMER_INTERFACE_DEF_H} CONST

NATIVE {TimerBase} DEF timerbase:PTR TO dd		->AmigaE does not automatically initialise this
NATIVE {ITimer}    DEF

PRIVATE
CONST ITIMER_SIZE = 20
DEF itimer_ioRequest[ITIMER_SIZE]:ARRAY OF PTR TO io
DEF itimer_count = 0
PUBLIC

PROC OpenDevice(devName:ARRAY OF CHAR, unit:ULONG, ioRequest:PTR TO io, flags:ULONG) REPLACEMENT
	DEF ret:BYTE
	ret := SUPER OpenDevice(devName, unit, ioRequest, flags)
	IF (ret = 0) AND StrCmpNoCase(devName, timername)
		->get global interface for "timer.device"
		NATIVE {
		if (ITimer == NULL) \{
			ITimer = (struct TimerIFace *) IExec->GetInterface((struct Library *)} ioRequest{->io_Device, "main", 1, NULL);
		\}
		} ENDNATIVE
		
		->add ioRequest to list
		IF itimer_count >= ITIMER_SIZE THEN Throw("BUG", 'OpenDevice("timer.device") called too many times for OS4 wrapper to handle')
		itimer_ioRequest[itimer_count++] := ioRequest;
	ENDIF
ENDPROC ret

PROC CloseDevice(ioRequest:PTR TO io) REPLACEMENT
	DEF i, found:BOOL
	
	->see if this ioRequest matches any used to open "timer.device"
	found := FALSE
	FOR i := 0 TO itimer_count-1
		IF itimer_ioRequest[i] = ioRequest THEN found := TRUE
	ENDFOR IF found
	
	IF found
		->remove ioRequest from list
		itimer_count--
		itimer_ioRequest[i] := itimer_ioRequest[itimer_count]
		
		->drop interface for "timer.device"
		IF itimer_count = 0
			NATIVE {
				IExec->DropInterface((struct Interface *) ITimer);
				ITimer = NULL;
			} ENDNATIVE
		ENDIF
	ENDIF
	SUPER CloseDevice(ioRequest)
ENDPROC

->NATIVE {AddTime} PROC
PROC AddTime( dest:PTR TO timeval, src:PTR TO timeval ) IS NATIVE {ITimer->AddTime(} dest {,} src {)} ENDNATIVE
->NATIVE {SubTime} PROC
PROC SubTime( dest:PTR TO timeval, src:PTR TO timeval ) IS NATIVE {ITimer->SubTime(} dest {,} src {)} ENDNATIVE
->NATIVE {CmpTime} PROC
PROC CmpTime( dest:PTR TO timeval, src:PTR TO timeval ) IS NATIVE {ITimer->CmpTime(} dest {,} src {)} ENDNATIVE !!VALUE
->NATIVE {ReadEClock} PROC
PROC ReadEClock( dest:PTR TO eclockval ) IS NATIVE {ITimer->ReadEClock(} dest {)} ENDNATIVE !!ULONG
->NATIVE {GetSysTime} PROC
PROC GetSysTime( dest:PTR TO timeval ) IS NATIVE {ITimer->GetSysTime(} dest {)} ENDNATIVE
/* New in V50 */
->NATIVE {GetUpTime} PROC
PROC GetUpTime( dest:PTR TO timeval ) IS NATIVE {ITimer->GetUpTime(} dest {)} ENDNATIVE
