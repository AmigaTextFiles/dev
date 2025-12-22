/* $VER: speedbar.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec', 'target/exec/interfaces', 'target/intuition/intuition', 'target/intuition/classes'
MODULE 'target/PEalias/exec', 'target/exec/libraries', 'target/utility/tagitem'
{
#include <proto/speedbar.h>
}
{
struct Library * SpeedBarBase = NULL;
struct SpeedBarIFace *ISpeedBar = NULL;
}
NATIVE {CLIB_SPEEDBAR_PROTOS_H} CONST
NATIVE {PROTO_SPEEDBAR_H} CONST
NATIVE {PRAGMA_SPEEDBAR_H} CONST
NATIVE {INLINE4_SPEEDBAR_H} CONST
NATIVE {SPEEDBAR_INTERFACE_DEF_H} CONST

NATIVE {SpeedBarBase} DEF speedbarbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {ISpeedBar}    DEF

PROC new()
	InitLibrary('gadgets/speedbar.gadget', NATIVE {(struct Interface **) &ISpeedBar} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {SPEEDBAR_GetClass} PROC
PROC SpeedBar_GetClass() IS NATIVE {ISpeedBar->SPEEDBAR_GetClass()} ENDNATIVE !!PTR TO iclass
->NATIVE {AllocSpeedButtonNodeA} PROC
PROC AllocSpeedButtonNodeA(number:UINT, tags:PTR TO tagitem) IS NATIVE {ISpeedBar->AllocSpeedButtonNodeA(} number {,} tags {)} ENDNATIVE !!PTR TO ln
->NATIVE {AllocSpeedButtonNode} PROC
PROC AllocSpeedButtonNode(number:UINT, number2=0:ULONG, ...) IS NATIVE {ISpeedBar->AllocSpeedButtonNode(} number {,} number2 {,} ... {)} ENDNATIVE !!PTR TO ln
->NATIVE {FreeSpeedButtonNode} PROC
PROC FreeSpeedButtonNode(node:PTR TO ln) IS NATIVE {ISpeedBar->FreeSpeedButtonNode(} node {)} ENDNATIVE
->NATIVE {SetSpeedButtonNodeAttrsA} PROC
PROC SetSpeedButtonNodeAttrsA(node:PTR TO ln, tags:PTR TO tagitem) IS NATIVE {ISpeedBar->SetSpeedButtonNodeAttrsA(} node {,} tags {)} ENDNATIVE
->NATIVE {SetSpeedButtonNodeAttrs} PROC
PROC SetSpeedButtonNodeAttrs(node:PTR TO ln, node2=0:ULONG, ...) IS NATIVE {ISpeedBar->SetSpeedButtonNodeAttrs(} node {,} node2 {,} ... {)} ENDNATIVE
->NATIVE {GetSpeedButtonNodeAttrsA} PROC
PROC GetSpeedButtonNodeAttrsA(node:PTR TO ln, tags:PTR TO tagitem) IS NATIVE {ISpeedBar->GetSpeedButtonNodeAttrsA(} node {,} tags {)} ENDNATIVE
->NATIVE {GetSpeedButtonNodeAttrs} PROC
PROC GetSpeedButtonNodeAttrs(node:PTR TO ln, node2=0:ULONG, ...) IS NATIVE {ISpeedBar->GetSpeedButtonNodeAttrs(} node {,} node2 {,} ... {)} ENDNATIVE
