/* $VER: checkbox.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec', 'target/exec/interfaces', 'target/intuition/intuition', 'target/intuition/classes'
MODULE 'target/PEalias/exec', 'target/exec/libraries'
{
#include <proto/checkbox.h>
}
{
struct Library * CheckBoxBase = NULL;
struct CheckBoxIFace *ICheckBox = NULL;
}
NATIVE {CLIB_CHECKBOX_PROTOS_H} CONST
NATIVE {PROTO_CHECKBOX_H} CONST
NATIVE {PRAGMA_CHECKBOX_H} CONST
NATIVE {INLINE4_CHECKBOX_H} CONST
NATIVE {CHECKBOX_INTERFACE_DEF_H} CONST

NATIVE {CheckBoxBase} DEF checkboxbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {ICheckBox}    DEF

PROC new()
	InitLibrary('gadgets/checkbox.gadget', NATIVE {(struct Interface **) &ICheckBox} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {CHECKBOX_GetClass} PROC
PROC CheckBox_GetClass() IS NATIVE {ICheckBox->CHECKBOX_GetClass()} ENDNATIVE !!PTR TO iclass
