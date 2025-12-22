/* $VER: clicktab.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec', 'target/exec/interfaces', 'target/intuition/intuition', 'target/intuition/classes'
MODULE 'target/PEalias/exec', 'target/exec/libraries', 'target/utility/tagitem'
{
#include <proto/clicktab.h>
}
{
struct Library * ClickTabBase = NULL;
struct ClickTabIFace *IClickTab = NULL;
}
NATIVE {CLIB_CLICKTAB_PROTOS_H} CONST
NATIVE {PROTO_CLICKTAB_H} CONST
NATIVE {PRAGMA_CLICKTAB_H} CONST
NATIVE {INLINE4_CLICKTAB_H} CONST
NATIVE {CLICKTAB_INTERFACE_DEF_H} CONST

NATIVE {ClickTabBase} DEF clicktabbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IClickTab}    DEF

PROC new()
	InitLibrary('gadgets/clicktab.gadget', NATIVE {(struct Interface **) &IClickTab} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {CLICKTAB_GetClass} PROC
PROC ClickTab_GetClass() IS NATIVE {IClickTab->CLICKTAB_GetClass()} ENDNATIVE !!PTR TO iclass
->NATIVE {AllocClickTabNodeA} PROC
PROC AllocClickTabNodeA(tags:PTR TO tagitem) IS NATIVE {IClickTab->AllocClickTabNodeA(} tags {)} ENDNATIVE !!PTR TO ln
->NATIVE {AllocClickTabNode} PROC
PROC AllocClickTabNode(param:ULONG, param2=0:ULONG, ...) IS NATIVE {IClickTab->AllocClickTabNode(} param {,} param2 {,} ... {)} ENDNATIVE !!PTR TO ln
->NATIVE {FreeClickTabNode} PROC
PROC FreeClickTabNode(node:PTR TO ln) IS NATIVE {IClickTab->FreeClickTabNode(} node {)} ENDNATIVE
->NATIVE {SetClickTabNodeAttrsA} PROC
PROC SetClickTabNodeAttrsA(node:PTR TO ln, tags:PTR TO tagitem) IS NATIVE {IClickTab->SetClickTabNodeAttrsA(} node {,} tags {)} ENDNATIVE !!VALUE
->NATIVE {SetClickTabNodeAttrs} PROC
PROC SetClickTabNodeAttrs(node:PTR TO ln, node2=0:ULONG, ...) IS NATIVE {IClickTab->SetClickTabNodeAttrs(} node {,} node2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {GetClickTabNodeAttrsA} PROC
PROC GetClickTabNodeAttrsA(node:PTR TO ln, tags:PTR TO tagitem) IS NATIVE {IClickTab->GetClickTabNodeAttrsA(} node {,} tags {)} ENDNATIVE !!VALUE
->NATIVE {GetClickTabNodeAttrs} PROC
PROC GetClickTabNodeAttrs(node:PTR TO ln, node2=0:ULONG, ...) IS NATIVE {IClickTab->GetClickTabNodeAttrs(} node {,} node2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {FreeClickTabList} PROC
PROC FreeClickTabList(list:PTR TO lh) IS NATIVE {IClickTab->FreeClickTabList(} list {)} ENDNATIVE
