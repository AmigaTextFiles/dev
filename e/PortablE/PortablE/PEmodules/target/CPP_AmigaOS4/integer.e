/* $VER: integer.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec', 'target/exec/interfaces', 'target/intuition/intuition', 'target/intuition/classes'
MODULE 'target/PEalias/exec', 'target/exec/libraries'
{
#include <proto/integer.h>
}
{
struct Library * IntegerBase = NULL;
struct IntegerIFace *IInteger = NULL;
}
NATIVE {CLIB_INTEGER_PROTOS_H} CONST
NATIVE {PROTO_INTEGER_H} CONST
NATIVE {PRAGMA_INTEGER_H} CONST
NATIVE {INLINE4_INTEGER_H} CONST
NATIVE {INTEGER_INTERFACE_DEF_H} CONST

NATIVE {IntegerBase} DEF integerbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IInteger}    DEF

PROC new()
	InitLibrary('gadgets/integer.gadget', NATIVE {(struct Interface **) &IInteger} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {INTEGER_GetClass} PROC
PROC Integer_GetClass() IS NATIVE {IInteger->INTEGER_GetClass()} ENDNATIVE !!PTR TO iclass
