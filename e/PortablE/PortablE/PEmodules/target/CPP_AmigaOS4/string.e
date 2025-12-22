/* $VER: string.h 53.21 (29.9.2013) */ 
OPT NATIVE
MODULE 'target/exec/types', 'target/exec', 'target/exec/interfaces', 'target/intuition/intuition', 'target/intuition/classes'
MODULE 'target/PEalias/exec', 'target/exec/libraries'
{
#include <proto/string.h>
}
{
struct Library * StringBase = NULL;
struct StringIFace *IString = NULL;
}
NATIVE {CLIB_STRING_PROTOS_H} CONST
NATIVE {PROTO_STRING_H} CONST
NATIVE {PRAGMA_STRING_H} CONST
NATIVE {INLINE4_STRING_H} CONST
NATIVE {STRING_INTERFACE_DEF_H} CONST

NATIVE {StringBase} DEF stringbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IString}    DEF

PROC new()
	InitLibrary('gadgets/string.gadget', NATIVE {(struct Interface **) &IString} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {STRING_GetClass} PROC
PROC String_GetClass() IS NATIVE {IString->STRING_GetClass()} ENDNATIVE !!PTR TO iclass
