/* $VER: radiobutton.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec', 'target/exec/interfaces', 'target/intuition/intuition', 'target/intuition/classes'
MODULE 'target/PEalias/exec', 'target/exec/libraries', 'target/utility/tagitem'
{
#include <proto/radiobutton.h>
}
{
struct Library * RadioButtonBase = NULL;
struct RadioButtonIFace *IRadioButton = NULL;
}
NATIVE {CLIB_RADIOBUTTON_PROTOS_H} CONST
NATIVE {PROTO_RADIOBUTTON_H} CONST
NATIVE {PRAGMA_RADIOBUTTON_H} CONST
NATIVE {INLINE4_RADIOBUTTON_H} CONST
NATIVE {RADIOBUTTON_INTERFACE_DEF_H} CONST

NATIVE {RadioButtonBase} DEF radiobuttonbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IRadioButton}    DEF

PROC new()
	InitLibrary('gadgets/radiobutton.gadget', NATIVE {(struct Interface **) &IRadioButton} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {RADIOBUTTON_GetClass} PROC
PROC RadioButton_GetClass() IS NATIVE {IRadioButton->RADIOBUTTON_GetClass()} ENDNATIVE !!PTR TO iclass
->NATIVE {AllocRadioButtonNodeA} PROC
PROC AllocRadioButtonNodeA(columns:UINT, tags:PTR TO tagitem) IS NATIVE {IRadioButton->AllocRadioButtonNodeA(} columns {,} tags {)} ENDNATIVE !!PTR TO ln
->NATIVE {AllocRadioButtonNode} PROC
PROC AllocRadioButtonNode(columns:UINT, columns2=0:ULONG, ...) IS NATIVE {IRadioButton->AllocRadioButtonNode(} columns {,} columns2 {,} ... {)} ENDNATIVE !!PTR TO ln
->NATIVE {FreeRadioButtonNode} PROC
PROC FreeRadioButtonNode(node:PTR TO ln) IS NATIVE {IRadioButton->FreeRadioButtonNode(} node {)} ENDNATIVE
->NATIVE {SetRadioButtonNodeAttrsA} PROC
PROC SetRadioButtonNodeAttrsA(node:PTR TO ln, tags:PTR TO tagitem) IS NATIVE {IRadioButton->SetRadioButtonNodeAttrsA(} node {,} tags {)} ENDNATIVE
->NATIVE {SetRadioButtonNodeAttrs} PROC
PROC SetRadioButtonNodeAttrs(node:PTR TO ln, node2=0:ULONG, ...) IS NATIVE {IRadioButton->SetRadioButtonNodeAttrs(} node {,} node2 {,} ... {)} ENDNATIVE
->NATIVE {GetRadioButtonNodeAttrsA} PROC
PROC GetRadioButtonNodeAttrsA(node:PTR TO ln, tags:PTR TO tagitem) IS NATIVE {IRadioButton->GetRadioButtonNodeAttrsA(} node {,} tags {)} ENDNATIVE
->NATIVE {GetRadioButtonNodeAttrs} PROC
PROC GetRadioButtonNodeAttrs(node:PTR TO ln, node2=0:ULONG, ...) IS NATIVE {IRadioButton->GetRadioButtonNodeAttrs(} node {,} node2 {,} ... {)} ENDNATIVE
