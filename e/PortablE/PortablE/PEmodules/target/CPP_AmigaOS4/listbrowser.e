/* $VER: listbrowser.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec', 'target/exec/interfaces', 'target/intuition/intuition', 'target/intuition/classes', 'target/gadgets/listbrowser'
MODULE 'target/PEalias/exec', 'target/exec/libraries', 'target/utility/tagitem'
{
#include <proto/listbrowser.h>
}
{
struct Library * ListBrowserBase = NULL;
struct ListBrowserIFace *IListBrowser = NULL;
}
NATIVE {CLIB_LISTBROWSER_PROTOS_H} CONST
NATIVE {PROTO_LISTBROWSER_H} CONST
NATIVE {PRAGMA_LISTBROWSER_H} CONST
NATIVE {INLINE4_LISTBROWSER_H} CONST
NATIVE {LISTBROWSER_INTERFACE_DEF_H} CONST

NATIVE {ListBrowserBase} DEF listbrowserbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IListBrowser}    DEF

PROC new()
	InitLibrary('gadgets/listbrowser.gadget', NATIVE {(struct Interface **) &IListBrowser} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {LISTBROWSER_GetClass} PROC
PROC ListBrowser_GetClass() IS NATIVE {IListBrowser->LISTBROWSER_GetClass()} ENDNATIVE !!PTR TO iclass
->NATIVE {AllocListBrowserNodeA} PROC
PROC AllocListBrowserNodeA(columns:UINT, tags:PTR TO tagitem) IS NATIVE {IListBrowser->AllocListBrowserNodeA(} columns {,} tags {)} ENDNATIVE !!PTR TO ln
->NATIVE {AllocListBrowserNode} PROC
PROC AllocListBrowserNode(columns:UINT, columns2=0:ULONG, ...) IS NATIVE {IListBrowser->AllocListBrowserNode(} columns {,} columns2 {,} ... {)} ENDNATIVE !!PTR TO ln
->NATIVE {FreeListBrowserNode} PROC
PROC FreeListBrowserNode(node:PTR TO ln) IS NATIVE {IListBrowser->FreeListBrowserNode(} node {)} ENDNATIVE
->NATIVE {SetListBrowserNodeAttrsA} PROC
PROC SetListBrowserNodeAttrsA(node:PTR TO ln, tags:PTR TO tagitem) IS NATIVE {IListBrowser->SetListBrowserNodeAttrsA(} node {,} tags {)} ENDNATIVE
->NATIVE {SetListBrowserNodeAttrs} PROC
PROC SetListBrowserNodeAttrs(node:PTR TO ln, node2=0:ULONG, ...) IS NATIVE {IListBrowser->SetListBrowserNodeAttrs(} node {,} node2 {,} ... {)} ENDNATIVE
->NATIVE {GetListBrowserNodeAttrsA} PROC
PROC GetListBrowserNodeAttrsA(node:PTR TO ln, tags:PTR TO tagitem) IS NATIVE {IListBrowser->GetListBrowserNodeAttrsA(} node {,} tags {)} ENDNATIVE
->NATIVE {GetListBrowserNodeAttrs} PROC
PROC GetListBrowserNodeAttrs(node:PTR TO ln, node2=0:ULONG, ...) IS NATIVE {IListBrowser->GetListBrowserNodeAttrs(} node {,} node2 {,} ... {)} ENDNATIVE
->NATIVE {ListBrowserSelectAll} PROC
PROC ListBrowserSelectAll(list:PTR TO lh) IS NATIVE {IListBrowser->ListBrowserSelectAll(} list {)} ENDNATIVE
->NATIVE {ShowListBrowserNodeChildren} PROC
PROC ShowListBrowserNodeChildren(node:PTR TO ln, depth:INT) IS NATIVE {IListBrowser->ShowListBrowserNodeChildren(} node {,} depth {)} ENDNATIVE
->NATIVE {HideListBrowserNodeChildren} PROC
PROC HideListBrowserNodeChildren(node:PTR TO ln) IS NATIVE {IListBrowser->HideListBrowserNodeChildren(} node {)} ENDNATIVE
->NATIVE {ShowAllListBrowserChildren} PROC
PROC ShowAllListBrowserChildren(list:PTR TO lh) IS NATIVE {IListBrowser->ShowAllListBrowserChildren(} list {)} ENDNATIVE
->NATIVE {HideAllListBrowserChildren} PROC
PROC HideAllListBrowserChildren(list:PTR TO lh) IS NATIVE {IListBrowser->HideAllListBrowserChildren(} list {)} ENDNATIVE
->NATIVE {FreeListBrowserList} PROC
PROC FreeListBrowserList(list:PTR TO lh) IS NATIVE {IListBrowser->FreeListBrowserList(} list {)} ENDNATIVE
->NATIVE {AllocLBColumnInfoA} PROC
PROC AllocLBColumnInfoA(columns:UINT, tags:PTR TO tagitem) IS NATIVE {IListBrowser->AllocLBColumnInfoA(} columns {,} tags {)} ENDNATIVE !!PTR TO columninfo
->NATIVE {AllocLBColumnInfo} PROC
PROC AllocLBColumnInfo(columns:UINT, columns2=0:ULONG, ...) IS NATIVE {IListBrowser->AllocLBColumnInfo(} columns {,} columns2 {,} ... {)} ENDNATIVE !!PTR TO columninfo
->NATIVE {SetLBColumnInfoAttrsA} PROC
PROC SetLBColumnInfoAttrsA(columninfo:PTR TO columninfo, tags:PTR TO tagitem) IS NATIVE {IListBrowser->SetLBColumnInfoAttrsA(} columninfo {,} tags {)} ENDNATIVE !!VALUE
->NATIVE {SetLBColumnInfoAttrs} PROC
PROC SetLBColumnInfoAttrs(columninfo:PTR TO columninfo, columninfo2=0:ULONG, ...) IS NATIVE {IListBrowser->SetLBColumnInfoAttrs(} columninfo {,} columninfo2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {GetLBColumnInfoAttrsA} PROC
PROC GetLBColumnInfoAttrsA(columninfo:PTR TO columninfo, tags:PTR TO tagitem) IS NATIVE {IListBrowser->GetLBColumnInfoAttrsA(} columninfo {,} tags {)} ENDNATIVE !!VALUE
->NATIVE {GetLBColumnInfoAttrs} PROC
PROC GetLBColumnInfoAttrs(columninfo:PTR TO columninfo, columninfo2=0:ULONG, ...) IS NATIVE {IListBrowser->GetLBColumnInfoAttrs(} columninfo {,} columninfo2 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {FreeLBColumnInfo} PROC
PROC FreeLBColumnInfo(columninfo:PTR TO columninfo) IS NATIVE {IListBrowser->FreeLBColumnInfo(} columninfo {)} ENDNATIVE
->NATIVE {ListBrowserClearAll} PROC
PROC ListBrowserClearAll(list:PTR TO lh) IS NATIVE {IListBrowser->ListBrowserClearAll(} list {)} ENDNATIVE
