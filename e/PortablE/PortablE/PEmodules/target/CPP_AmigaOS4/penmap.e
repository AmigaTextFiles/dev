/* $VER: penmap.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec', 'target/exec/interfaces', 'target/intuition/intuition', 'target/intuition/classes'
MODULE 'target/PEalias/exec', 'target/exec/libraries'
{
#include <proto/penmap.h>
}
{
struct Library * PenMapBase = NULL;
struct PenMapIFace *IPenMap = NULL;
}
NATIVE {CLIB_PENMAP_PROTOS_H} CONST
NATIVE {PROTO_PENMAP_H} CONST
NATIVE {PRAGMA_PENMAP_H} CONST
NATIVE {INLINE4_PENMAP_H} CONST
NATIVE {PENMAP_INTERFACE_DEF_H} CONST

NATIVE {PenMapBase} DEF penmapbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IPenMap}    DEF

PROC new()
	InitLibrary('images/penmap.image', NATIVE {(struct Interface **) &IPenMap} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {PENMAP_GetClass} PROC
PROC PenMap_GetClass() IS NATIVE {IPenMap->PENMAP_GetClass()} ENDNATIVE !!PTR TO iclass
