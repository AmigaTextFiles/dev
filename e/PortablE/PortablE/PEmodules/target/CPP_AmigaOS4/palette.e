/* $VER: palette.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec', 'target/exec/interfaces', 'target/intuition/intuition', 'target/intuition/classes'
MODULE 'target/PEalias/exec', 'target/exec/libraries'
{
#include <proto/palette.h>
}
{
struct Library * PaletteBase = NULL;
struct PaletteIFace *IPalette = NULL;
}
NATIVE {CLIB_PALETTE_PROTOS_H} CONST
NATIVE {PROTO_PALETTE_H} CONST
NATIVE {PRAGMA_PALETTE_H} CONST
NATIVE {INLINE4_PALETTE_H} CONST
NATIVE {PALETTE_INTERFACE_DEF_H} CONST

NATIVE {PaletteBase} DEF palettebase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IPalette}    DEF

PROC new()
	InitLibrary('gadgets/palette.gadget', NATIVE {(struct Interface **) &IPalette} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {PALETTE_GetClass} PROC
PROC Palette_GetClass() IS NATIVE {IPalette->PALETTE_GetClass()} ENDNATIVE !!PTR TO iclass
