/* $Id: battmem_protos.h,v 1.7 2005/11/10 15:30:32 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types'
MODULE 'target/exec/libraries', 'target/exec', 'target/resources/battmem'
MODULE 'target/other/battclock'		->a hack for OpenResource()
{
#include <proto/battmem.h>
}
{
struct Library *BattMemBase = NULL;
struct BattMemIFace* IBattMem = NULL;
}
NATIVE {CLIB_BATTMEM_PROTOS_H} CONST
NATIVE {PROTO_BATTMEM_H} CONST
NATIVE {PRAGMA_BATTMEM_H} CONST
->NATIVE {INLINE4_BATTMEM_H} CONST
NATIVE {BATTMEM_INTERFACE_DEF_H} CONST

NATIVE {BattMemBase} DEF battmembase:PTR TO lib
NATIVE {IBattMem}    DEF

PROC OpenResource(resName:ARRAY OF CHAR) REPLACEMENT
	DEF ret:APTR
	ret := SUPER OpenResource(resName)
	NATIVE {
	if(}ret{!=NULL && strcasecmp(}resName{, BATTMEMNAME)==0) \{
		if (IBattMem == NULL) \{
			//get global interface for "battmem.resource"
			IBattMem = (struct BattMemIFace *) IExec->GetInterface( (struct Library *) } ret{, "main", 1, NULL);
		\}
	\}
	} ENDNATIVE
ENDPROC ret


NATIVE {ObtainBattSemaphore} PROC
PROC obtainBattSemaphore( ) IS NATIVE {IBattMem->ObtainBattSemaphore()} ENDNATIVE
NATIVE {ReleaseBattSemaphore} PROC
PROC releaseBattSemaphore( ) IS NATIVE {IBattMem->ReleaseBattSemaphore()} ENDNATIVE
NATIVE {ReadBattMem} PROC
PROC readBattMem( buffer:APTR, offset:ULONG, length:ULONG ) IS NATIVE {IBattMem->ReadBattMem(} buffer {,} offset {,} length {)} ENDNATIVE !!ULONG
NATIVE {WriteBattMem} PROC
PROC writeBattMem( buffer:APTR, offset:ULONG, length:ULONG ) IS NATIVE {IBattMem->WriteBattMem(} buffer {,} offset {,} length {)} ENDNATIVE !!ULONG
