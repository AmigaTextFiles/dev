/* $Id: battclock_protos.h,v 1.7 2005/11/10 15:30:32 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types'
MODULE 'target/exec/libraries', 'target/exec', 'target/resources/battclock'
{
#include <proto/battclock.h>
}
{
struct Library *BattClockBase = NULL;
struct BattClockIFace* IBattClock = NULL;
}
NATIVE {CLIB_BATTCLOCK_PROTOS_H} CONST
NATIVE {PROTO_BATTCLOCK_H} CONST
NATIVE {PRAGMA_BATTCLOCK_H} CONST
->NATIVE {INLINE4_BATTCLOCK_H} CONST
NATIVE {BATTCLOCK_INTERFACE_DEF_H} CONST

NATIVE {BattClockBase} DEF battclockbase:PTR TO lib
NATIVE {IBattClock}    DEF

PROC OpenResource(resName:ARRAY OF CHAR) REPLACEMENT
	DEF ret:APTR
	ret := SUPER OpenResource(resName)
	NATIVE {
	if(}ret{!=NULL && strcasecmp(}resName{, BATTCLOCKNAME)==0) \{
		if (IBattClock == NULL) \{
			//get global interface for "battclock.resource"
			IBattClock = (struct BattClockIFace *) IExec->GetInterface( (struct Library *) } ret{, "main", 1, NULL);
		\}
	\}
	} ENDNATIVE
ENDPROC ret


NATIVE {ResetBattClock} PROC
PROC resetBattClock( ) IS NATIVE {IBattClock->ResetBattClock()} ENDNATIVE
NATIVE {ReadBattClock} PROC
PROC readBattClock( ) IS NATIVE {IBattClock->ReadBattClock()} ENDNATIVE !!ULONG
NATIVE {WriteBattClock} PROC
PROC writeBattClock( time:ULONG ) IS NATIVE {IBattClock->WriteBattClock(} time {)} ENDNATIVE
