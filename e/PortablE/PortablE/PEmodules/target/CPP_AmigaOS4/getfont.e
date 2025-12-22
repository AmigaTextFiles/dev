/* $VER: getfont.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec', 'target/exec/interfaces', 'target/intuition/intuition', 'target/intuition/classes'
MODULE 'target/PEalias/exec', 'target/exec/libraries'
{
#include <proto/getfont.h>
}
{
struct Library * GetFontBase = NULL;
struct GetFontIFace *IGetFont = NULL;
}
NATIVE {CLIB_GETFONT_PROTOS_H} CONST
NATIVE {PROTO_GETFONT_H} CONST
NATIVE {PRAGMA_GETFONT_H} CONST
NATIVE {INLINE4_GETFONT_H} CONST
NATIVE {GETFONT_INTERFACE_DEF_H} CONST

NATIVE {GetFontBase} DEF getfontbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IGetFont}    DEF

PROC new()
	InitLibrary('gadgets/getfont.gadget', NATIVE {(struct Interface **) &IGetFont} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {GETFONT_GetClass} PROC
PROC GetFont_GetClass() IS NATIVE {IGetFont->GETFONT_GetClass()} ENDNATIVE !!PTR TO iclass
