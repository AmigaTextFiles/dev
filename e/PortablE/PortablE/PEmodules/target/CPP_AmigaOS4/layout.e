/* $VER: layout.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec', 'target/exec/interfaces', 'target/intuition/intuition', 'target/intuition/classes', 'target/gadgets/layout'
MODULE 'target/PEalias/exec', 'target/exec/libraries', 'target/graphics/text', 'target/intuition/classusr', 'target/utility/tagitem'
{
#include <proto/layout.h>
}
{
struct Library * LayoutBase = NULL;
struct LayoutIFace *ILayout = NULL;
}
NATIVE {CLIB_LAYOUT_PROTOS_H} CONST
NATIVE {PROTO_LAYOUT_H} CONST
NATIVE {PRAGMA_LAYOUT_H} CONST
NATIVE {INLINE4_LAYOUT_H} CONST
NATIVE {LAYOUT_INTERFACE_DEF_H} CONST

NATIVE {LayoutBase} DEF layoutbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {ILayout}    DEF

PROC new()
	InitLibrary('gadgets/layout.gadget', NATIVE {(struct Interface **) &ILayout} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {LAYOUT_GetClass} PROC
PROC Layout_GetClass() IS NATIVE {ILayout->LAYOUT_GetClass()} ENDNATIVE !!PTR TO iclass
->NATIVE {ActivateLayoutGadget} PROC
PROC ActivateLayoutGadget(gadget:PTR TO gadget, window:PTR TO window, requester:PTR TO requester, object:ULONG) IS NATIVE {-ILayout->ActivateLayoutGadget(} gadget {,} window {,} requester {,} object {)} ENDNATIVE !!INT
->NATIVE {FlushLayoutDomainCache} PROC
PROC FlushLayoutDomainCache(gadget:PTR TO gadget) IS NATIVE {ILayout->FlushLayoutDomainCache(} gadget {)} ENDNATIVE
->NATIVE {RethinkLayout} PROC
PROC RethinkLayout(gadget:PTR TO gadget, window:PTR TO window, requester:PTR TO requester, refresh:INT) IS NATIVE {-ILayout->RethinkLayout(} gadget {,} window {,} requester {, -} refresh {)} ENDNATIVE !!INT
->NATIVE {LayoutLimits} PROC
PROC LayoutLimits(gadget:PTR TO gadget, limits:PTR TO layoutlimits, font:PTR TO textfont, screen:PTR TO screen) IS NATIVE {ILayout->LayoutLimits(} gadget {,} limits {,} font {,} screen {)} ENDNATIVE
->NATIVE {PAGE_GetClass} PROC
PROC Page_GetClass() IS NATIVE {ILayout->PAGE_GetClass()} ENDNATIVE !!PTR TO iclass
->NATIVE {SetPageGadgetAttrsA} PROC
PROC SetPageGadgetAttrsA(gadget:PTR TO gadget, object:PTR TO INTUIOBJECT, window:PTR TO window, requester:PTR TO requester, tags:PTR TO tagitem) IS NATIVE {ILayout->SetPageGadgetAttrsA(} gadget {,} object {,} window {,} requester {,} tags {)} ENDNATIVE !!ULONG
->NATIVE {SetPageGadgetAttrs} PROC
PROC SetPageGadgetAttrs(gadget:PTR TO gadget, object:PTR TO INTUIOBJECT, window:PTR TO window, requester:PTR TO requester, requester2=0:ULONG, ...) IS NATIVE {ILayout->SetPageGadgetAttrs(} gadget {,} object {,} window {,} requester {,} requester2 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {RefreshPageGadget} PROC
PROC RefreshPageGadget(gadget:PTR TO gadget, object:PTR TO INTUIOBJECT, window:PTR TO window, requester:PTR TO requester) IS NATIVE {ILayout->RefreshPageGadget(} gadget {,} object {,} window {,} requester {)} ENDNATIVE
