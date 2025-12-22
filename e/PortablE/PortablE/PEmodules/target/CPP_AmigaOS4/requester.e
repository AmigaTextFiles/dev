/* $VER: requester.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec', 'target/exec/interfaces', 'target/intuition/intuition', 'target/intuition/classes'
MODULE 'target/PEalias/exec', 'target/exec/libraries'
{
#include <proto/requester.h>
}
{
struct Library * RequesterBase = NULL;
struct RequesterIFace *IRequester = NULL;
}
NATIVE {CLIB_REQUESTER_PROTOS_H} CONST
NATIVE {PROTO_REQUESTER_H} CONST
NATIVE {PRAGMA_REQUESTER_H} CONST
NATIVE {INLINE4_REQUESTER_H} CONST
NATIVE {REQUESTER_INTERFACE_DEF_H} CONST

NATIVE {RequesterBase} DEF requesterbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IRequester}    DEF

PROC new()
	InitLibrary('requester.class', NATIVE {(struct Interface **) &IRequester} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {REQUESTER_GetClass} PROC
PROC Requester_GetClass() IS NATIVE {IRequester->REQUESTER_GetClass()} ENDNATIVE !!PTR TO iclass
