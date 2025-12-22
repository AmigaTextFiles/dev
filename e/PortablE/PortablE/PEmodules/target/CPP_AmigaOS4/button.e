/* $VER: button.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec', 'target/exec/interfaces', 'target/intuition/intuition', 'target/intuition/classes'
MODULE 'target/PEalias/exec', 'target/exec/libraries'
{
#include <proto/button.h>
}
{
struct Library * ButtonBase = NULL;
struct ButtonIFace *IButton = NULL;
}
NATIVE {CLIB_BUTTON_PROTOS_H} CONST
NATIVE {PROTO_BUTTON_H} CONST
NATIVE {PRAGMA_BUTTON_H} CONST
NATIVE {INLINE4_BUTTON_H} CONST
NATIVE {BUTTON_INTERFACE_DEF_H} CONST

NATIVE {ButtonBase} DEF buttonbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IButton}    DEF

PROC new()
	InitLibrary('gadgets/button.gadget', NATIVE {(struct Interface **) &IButton} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {BUTTON_GetClass} PROC
PROC Button_GetClass() IS NATIVE {IButton->BUTTON_GetClass()} ENDNATIVE !!PTR TO iclass
