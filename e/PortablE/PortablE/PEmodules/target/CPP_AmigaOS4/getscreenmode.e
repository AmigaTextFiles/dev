/* $VER: getscreenmode.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec', 'target/exec/interfaces', 'target/intuition/intuition', 'target/intuition/classes'
MODULE 'target/PEalias/exec', 'target/exec/libraries'
{
#include <proto/getscreenmode.h>
}
{
struct Library * GetScreenModeBase = NULL;
struct GetScreenModeIFace *IGetScreenMode = NULL;
}
NATIVE {CLIB_GETSCREENMODE_PROTOS_H} CONST
NATIVE {PROTO_GETSCREENMODE_H} CONST
NATIVE {PRAGMA_GETSCREENMODE_H} CONST
NATIVE {INLINE4_GETSCREENMODE_H} CONST
NATIVE {GETSCREENMODE_INTERFACE_DEF_H} CONST

NATIVE {GetScreenModeBase} DEF getscreenmodebase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IGetScreenMode}    DEF

PROC new()
	InitLibrary('gadgets/getscreenmode.gadget', NATIVE {(struct Interface **) &IGetScreenMode} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {GETSCREENMODE_GetClass} PROC
PROC GetScreenMode_GetClass() IS NATIVE {IGetScreenMode->GETSCREENMODE_GetClass()} ENDNATIVE !!PTR TO iclass
