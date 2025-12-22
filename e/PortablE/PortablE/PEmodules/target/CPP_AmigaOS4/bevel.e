/* $VER: bevel.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec', 'target/exec/interfaces', 'target/intuition/intuition', 'target/intuition/classes'
MODULE 'target/PEalias/exec', 'target/exec/libraries'
{
#include <proto/bevel.h>
}
{
struct Library * BevelBase = NULL;
struct BevelIFace *IBevel = NULL;
}
NATIVE {CLIB_BEVEL_PROTOS_H} CONST
NATIVE {PROTO_BEVEL_H} CONST
NATIVE {PRAGMA_BEVEL_H} CONST
NATIVE {INLINE4_BEVEL_H} CONST
NATIVE {BEVEL_INTERFACE_DEF_H} CONST

NATIVE {BevelBase} DEF bevelbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IBevel}    DEF

PROC new()
	InitLibrary('images/bevel.image', NATIVE {(struct Interface **) &IBevel} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {BEVEL_GetClass} PROC
PROC Bevel_GetClass() IS NATIVE {IBevel->BEVEL_GetClass()} ENDNATIVE !!PTR TO iclass
->NATIVE {Reserved1} PROC
->PROC Reserved1() IS NATIVE {IBevel->Reserved1()} ENDNATIVE
->NATIVE {Reserved2} PROC
->PROC Reserved2() IS NATIVE {IBevel->Reserved2()} ENDNATIVE
->NATIVE {NewBevelPrefs} PROC
PROC NewBevelPrefs() IS NATIVE {IBevel->NewBevelPrefs()} ENDNATIVE
