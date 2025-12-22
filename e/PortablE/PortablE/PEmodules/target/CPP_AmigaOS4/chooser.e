/* $VER: chooser.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec', 'target/exec/interfaces', 'target/intuition/intuition', 'target/intuition/classes'
MODULE 'target/PEalias/exec', 'target/exec/libraries', 'target/utility/tagitem'
{
#include <proto/chooser.h>
}
{
struct Library * ChooserBase = NULL;
struct ChooserIFace *IChooser = NULL;
}
NATIVE {CLIB_CHOOSER_PROTOS_H} CONST
NATIVE {PROTO_CHOOSER_H} CONST
NATIVE {PRAGMA_CHOOSER_H} CONST
NATIVE {INLINE4_CHOOSER_H} CONST
NATIVE {CHOOSER_INTERFACE_DEF_H} CONST

NATIVE {ChooserBase} DEF chooserbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IChooser}    DEF

PROC new()
	InitLibrary('gadgets/chooser.gadget', NATIVE {(struct Interface **) &IChooser} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {CHOOSER_GetClass} PROC
PROC Chooser_GetClass() IS NATIVE {IChooser->CHOOSER_GetClass()} ENDNATIVE !!PTR TO iclass
->NATIVE {AllocChooserNodeA} PROC
PROC AllocChooserNodeA(tags:PTR TO tagitem) IS NATIVE {IChooser->AllocChooserNodeA(} tags {)} ENDNATIVE !!PTR TO ln
->NATIVE {AllocChooserNode} PROC
PROC AllocChooserNode(param:ULONG, param2=0:ULONG, ...) IS NATIVE {IChooser->AllocChooserNode(} param {,} param2 {,} ... {)} ENDNATIVE !!PTR TO ln
->NATIVE {FreeChooserNode} PROC
PROC FreeChooserNode(node:PTR TO ln) IS NATIVE {IChooser->FreeChooserNode(} node {)} ENDNATIVE
->NATIVE {SetChooserNodeAttrsA} PROC
PROC SetChooserNodeAttrsA(node:PTR TO ln, tags:PTR TO tagitem) IS NATIVE {IChooser->SetChooserNodeAttrsA(} node {,} tags {)} ENDNATIVE
->NATIVE {SetChooserNodeAttrs} PROC
PROC SetChooserNodeAttrs(node:PTR TO ln, param:ULONG, param2=0:ULONG, ...) IS NATIVE {IChooser->SetChooserNodeAttrs(} node {,} param {,} param2 {,} ... {)} ENDNATIVE
->NATIVE {GetChooserNodeAttrsA} PROC
PROC GetChooserNodeAttrsA(node:PTR TO ln, tags:PTR TO tagitem) IS NATIVE {IChooser->GetChooserNodeAttrsA(} node {,} tags {)} ENDNATIVE
->NATIVE {GetChooserNodeAttrs} PROC
PROC GetChooserNodeAttrs(node:PTR TO ln, param:ULONG, param2=0:ULONG, ...) IS NATIVE {IChooser->GetChooserNodeAttrs(} node {,} param {,} param2 {,} ... {)} ENDNATIVE
