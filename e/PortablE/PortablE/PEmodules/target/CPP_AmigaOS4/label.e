/* $VER: label.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec', 'target/exec/interfaces', 'target/intuition/intuition', 'target/intuition/classes'
MODULE 'target/PEalias/exec', 'target/exec/libraries'
{
#include <proto/label.h>
}
{
struct Library * LabelBase = NULL;
struct LabelIFace *ILabel = NULL;
}
NATIVE {CLIB_LABEL_PROTOS_H} CONST
NATIVE {PROTO_LABEL_H} CONST
NATIVE {PRAGMA_LABEL_H} CONST
NATIVE {INLINE4_LABEL_H} CONST
NATIVE {LABEL_INTERFACE_DEF_H} CONST

NATIVE {LabelBase} DEF labelbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {ILabel}    DEF

PROC new()
	InitLibrary('images/label.image', NATIVE {(struct Interface **) &ILabel} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {LABEL_GetClass} PROC
PROC Label_GetClass() IS NATIVE {ILabel->LABEL_GetClass()} ENDNATIVE !!PTR TO iclass
