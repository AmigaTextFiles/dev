/* $VER: space.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec', 'target/exec/interfaces', 'target/intuition/intuition', 'target/intuition/classes'
MODULE 'target/PEalias/exec', 'target/exec/libraries'
{
#include <proto/space.h>
}
{
struct Library * SpaceBase = NULL;
struct SpaceIFace *ISpace = NULL;
}
NATIVE {CLIB_SPACE_PROTOS_H} CONST
NATIVE {PROTO_SPACE_H} CONST
NATIVE {PRAGMA_SPACE_H} CONST
NATIVE {INLINE4_SPACE_H} CONST
NATIVE {SPACE_INTERFACE_DEF_H} CONST

NATIVE {SpaceBase} DEF spacebase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {ISpace}    DEF

PROC new()
	InitLibrary('gadgets/space.gadget', NATIVE {(struct Interface **) &ISpace} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {SPACE_GetClass} PROC
PROC Space_GetClass() IS NATIVE {ISpace->SPACE_GetClass()} ENDNATIVE !!PTR TO iclass
