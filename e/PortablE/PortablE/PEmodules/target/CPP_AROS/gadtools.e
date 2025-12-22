OPT NATIVE
PUBLIC MODULE 'target/libraries/gadtools'
MODULE 'target/aros/libcall', 'target/intuition/intuition', 'target/intuition/screens', 'target/utility/tagitem', 'target/libraries/gadtools'
MODULE 'target/exec/ports', 'target/graphics/rastport', 'target/exec/types', 'target/exec/libraries'
{
#include <proto/gadtools.h>
}
{
struct Library* GadToolsBase = NULL;
}
NATIVE {CLIB_GADTOOLS_PROTOS_H} CONST
NATIVE {PROTO_GADTOOLS_H} CONST

NATIVE {GadToolsBase} DEF gadtoolsbase:PTR TO lib		->AmigaE does not automatically initialise this

NATIVE {GetVisualInfo} PROC
PROC GetVisualInfo(param1:PTR TO screen, param2:TAG, param22=0:ULONG, ...) IS NATIVE {GetVisualInfo(} param1 {,} param2 {,} param22 {,} ... {)} ENDNATIVE !!APTR2
NATIVE {CreateGadget} PROC
PROC CreateGadget(param1:ULONG, param2:PTR TO gadget, param3:PTR TO newgadget, param4:TAG, param42=0:ULONG, ...) IS NATIVE {CreateGadget(} param1 {,} param2 {,} param3 {,} param4 {,} param42 {,} ... {)} ENDNATIVE !!PTR TO gadget
NATIVE {DrawBevelBox} PROC
PROC DrawBevelBox(param1:PTR TO rastport, param2:INT, param3:INT, param4:INT, param5:INT, param6:TAG, param62=0:ULONG, ...) IS NATIVE {DrawBevelBox(} param1 {,} param2 {,} param3 {,} param4 {,} param5 {,} param6 {,} param62 {,} ... {)} ENDNATIVE
NATIVE {GT_SetGadgetAttrs} PROC
PROC Gt_SetGadgetAttrs(param1:PTR TO gadget, param2:PTR TO window, param3:PTR TO requester, param4:TAG, param42=0:ULONG, ...) IS NATIVE {GT_SetGadgetAttrs(} param1 {,} param2 {,} param3 {,} param4 {,} param42 {,} ... {)} ENDNATIVE
NATIVE {GT_GetGadgetAttrs} PROC
PROC Gt_GetGadgetAttrs(param1:PTR TO gadget, param2:PTR TO window, param3:PTR TO requester, param4:TAG, param42=0:ULONG, ...) IS NATIVE {GT_GetGadgetAttrs(} param1 {,} param2 {,} param3 {,} param4 {,} param42 {,} ... {)} ENDNATIVE !!VALUE
NATIVE {CreateMenus} PROC
PROC CreateMenus(param1:PTR TO newmenu, param2:TAG, param22=0:ULONG, ...) IS NATIVE {CreateMenus(} param1 {,} param2 {,} param22 {,} ... {)} ENDNATIVE !!PTR TO menu
NATIVE {LayoutMenus} PROC
PROC LayoutMenus(param1:PTR TO menu, param2:APTR2, param3:TAG, param32=0:ULONG, ...) IS NATIVE {-LayoutMenus(} param1 {,} param2 {,} param3 {,} param32 {,} ... {)} ENDNATIVE !!INT

NATIVE {CreateGadgetA} PROC
PROC CreateGadgetA(kind:ULONG, previous:PTR TO gadget, ng:PTR TO newgadget, taglist:ARRAY OF tagitem) IS NATIVE {CreateGadgetA(} kind {,} previous {,} ng {,} taglist {)} ENDNATIVE !!PTR TO gadget
NATIVE {FreeGadgets} PROC
PROC FreeGadgets(glist:PTR TO gadget) IS NATIVE {FreeGadgets(} glist {)} ENDNATIVE
NATIVE {GT_SetGadgetAttrsA} PROC
PROC Gt_SetGadgetAttrsA(gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, tagList:ARRAY OF tagitem) IS NATIVE {GT_SetGadgetAttrsA(} gad {,} win {,} req {,} tagList {)} ENDNATIVE
NATIVE {CreateMenusA} PROC
PROC CreateMenusA(newmenu:PTR TO newmenu, tagList:ARRAY OF tagitem) IS NATIVE {CreateMenusA(} newmenu {,} tagList {)} ENDNATIVE !!PTR TO menu
NATIVE {FreeMenus} PROC
PROC FreeMenus(menu:PTR TO menu) IS NATIVE {FreeMenus(} menu {)} ENDNATIVE
NATIVE {LayoutMenuItemsA} PROC
PROC LayoutMenuItemsA(menuitem:PTR TO menuitem, vi:APTR2, tagList:ARRAY OF tagitem) IS NATIVE {-LayoutMenuItemsA(} menuitem {,} vi {,} tagList {)} ENDNATIVE !!INT
NATIVE {LayoutMenusA} PROC
PROC LayoutMenusA(menu:PTR TO menu, vi:APTR2, tagList:ARRAY OF tagitem) IS NATIVE {-LayoutMenusA(} menu {,} vi {,} tagList {)} ENDNATIVE !!INT
NATIVE {GT_GetIMsg} PROC
PROC Gt_GetIMsg(intuiport:PTR TO mp) IS NATIVE {GT_GetIMsg(} intuiport {)} ENDNATIVE !!PTR TO intuimessage
NATIVE {GT_ReplyIMsg} PROC
PROC Gt_ReplyIMsg(imsg:PTR TO intuimessage) IS NATIVE {GT_ReplyIMsg(} imsg {)} ENDNATIVE
NATIVE {GT_RefreshWindow} PROC
PROC Gt_RefreshWindow(win:PTR TO window, req:PTR TO requester) IS NATIVE {GT_RefreshWindow(} win {,} req {)} ENDNATIVE
NATIVE {GT_BeginRefresh} PROC
PROC Gt_BeginRefresh(win:PTR TO window) IS NATIVE {GT_BeginRefresh(} win {)} ENDNATIVE
NATIVE {GT_EndRefresh} PROC
PROC Gt_EndRefresh(win:PTR TO window, complete:INT) IS NATIVE {GT_EndRefresh(} win {, -} complete {)} ENDNATIVE
NATIVE {GT_FilterIMsg} PROC
PROC Gt_FilterIMsg(imsg:PTR TO intuimessage) IS NATIVE {GT_FilterIMsg(} imsg {)} ENDNATIVE !!PTR TO intuimessage
NATIVE {GT_PostFilterIMsg} PROC
PROC Gt_PostFilterIMsg(modimsg:PTR TO intuimessage) IS NATIVE {GT_PostFilterIMsg(} modimsg {)} ENDNATIVE !!PTR TO intuimessage
NATIVE {CreateContext} PROC
PROC CreateContext(glistpointer:ARRAY OF PTR TO gadget) IS NATIVE {CreateContext(} glistpointer {)} ENDNATIVE !!PTR TO gadget
NATIVE {DrawBevelBoxA} PROC
PROC DrawBevelBoxA(rport:PTR TO rastport, left:INT, top:INT, width:INT, height:INT, taglist:ARRAY OF tagitem) IS NATIVE {DrawBevelBoxA(} rport {,} left {,} top {,} width {,} height {,} taglist {)} ENDNATIVE
NATIVE {GetVisualInfoA} PROC
PROC GetVisualInfoA(screen:PTR TO screen, tagList:ARRAY OF tagitem) IS NATIVE {GetVisualInfoA(} screen {,} tagList {)} ENDNATIVE !!APTR2
NATIVE {FreeVisualInfo} PROC
PROC FreeVisualInfo(vi:APTR2) IS NATIVE {FreeVisualInfo(} vi {)} ENDNATIVE
NATIVE {GT_GetGadgetAttrsA} PROC
PROC Gt_GetGadgetAttrsA(gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, taglist:ARRAY OF tagitem) IS NATIVE {GT_GetGadgetAttrsA(} gad {,} win {,} req {,} taglist {)} ENDNATIVE !!VALUE
