/* $Id: gadtools_protos.h,v 1.8 2005/11/10 15:30:32 hjfrieden Exp $ */
OPT NATIVE
PUBLIC MODULE 'target/libraries/gadtools'
MODULE 'target/exec/libraries', 'target/intuition/intuition', 'target/utility/tagitem', 'target/libraries/gadtools'
MODULE 'target/PEalias/exec', 'target/exec/ports', 'target/graphics/rastport', 'target/exec/types'
{
#include <proto/gadtools.h>
}
{
struct Library* GadToolsBase = NULL;
struct GadToolsIFace* IGadTools = NULL;
}
NATIVE {CLIB_GADTOOLS_PROTOS_H} CONST
NATIVE {PROTO_GADTOOLS_H} CONST
NATIVE {PRAGMA_GADTOOLS_H} CONST
NATIVE {INLINE4_GADTOOLS_H} CONST
NATIVE {GADTOOLS_INTERFACE_DEF_H} CONST

NATIVE {GadToolsBase} DEF gadtoolsbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IGadTools}    DEF

PROC new()
	InitLibrary('gadtools.library', NATIVE {(struct Interface **) &IGadTools} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

/*--- functions in V36 or higher (Release 2.0) ---*/

/* Gadget Functions */

->NATIVE {CreateGadgetA} PROC
PROC CreateGadgetA( kind:ULONG, gad:PTR TO gadget, ng:PTR TO newgadget, taglist:ARRAY OF tagitem ) IS NATIVE {IGadTools->CreateGadgetA(} kind {,} gad {,} ng {,} taglist {)} ENDNATIVE !!PTR TO gadget
->NATIVE {CreateGadget} PROC
PROC CreateGadget( kind:ULONG, gad:PTR TO gadget, ng:PTR TO newgadget, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IGadTools->CreateGadget(} kind {,} gad {,} ng {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO gadget
->NATIVE {FreeGadgets} PROC
PROC FreeGadgets( gad:PTR TO gadget ) IS NATIVE {IGadTools->FreeGadgets(} gad {)} ENDNATIVE
->NATIVE {GT_SetGadgetAttrsA} PROC
PROC Gt_SetGadgetAttrsA( gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, taglist:ARRAY OF tagitem ) IS NATIVE {IGadTools->GT_SetGadgetAttrsA(} gad {,} win {,} req {,} taglist {)} ENDNATIVE
->NATIVE {GT_SetGadgetAttrs} PROC
PROC Gt_SetGadgetAttrs( gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IGadTools->GT_SetGadgetAttrs(} gad {,} win {,} req {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE

/* Menu functions */

->NATIVE {CreateMenusA} PROC
PROC CreateMenusA( newmenu:PTR TO newmenu, taglist:ARRAY OF tagitem ) IS NATIVE {IGadTools->CreateMenusA(} newmenu {,} taglist {)} ENDNATIVE !!PTR TO menu
->NATIVE {CreateMenus} PROC
PROC CreateMenus( newmenu:PTR TO newmenu, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IGadTools->CreateMenus(} newmenu {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!PTR TO menu
->NATIVE {FreeMenus} PROC
PROC FreeMenus( menu:PTR TO menu ) IS NATIVE {IGadTools->FreeMenus(} menu {)} ENDNATIVE
->NATIVE {LayoutMenuItemsA} PROC
PROC LayoutMenuItemsA( firstitem:PTR TO menuitem, vi:APTR2, taglist:ARRAY OF tagitem ) IS NATIVE {-IGadTools->LayoutMenuItemsA(} firstitem {,} vi {,} taglist {)} ENDNATIVE !!INT
->NATIVE {LayoutMenuItems} PROC
PROC LayoutMenuItems( firstitem:PTR TO menuitem, vi:APTR2, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {-IGadTools->LayoutMenuItems(} firstitem {,} vi {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!INT
->NATIVE {LayoutMenusA} PROC
PROC LayoutMenusA( firstmenu:PTR TO menu, vi:APTR2, taglist:ARRAY OF tagitem ) IS NATIVE {-IGadTools->LayoutMenusA(} firstmenu {,} vi {,} taglist {)} ENDNATIVE !!INT
->NATIVE {LayoutMenus} PROC
PROC LayoutMenus( firstmenu:PTR TO menu, vi:APTR2, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {-IGadTools->LayoutMenus(} firstmenu {,} vi {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!INT

/* Misc Event-Handling Functions */

->NATIVE {GT_GetIMsg} PROC
PROC Gt_GetIMsg( iport:PTR TO mp ) IS NATIVE {IGadTools->GT_GetIMsg(} iport {)} ENDNATIVE !!PTR TO intuimessage
->NATIVE {GT_ReplyIMsg} PROC
PROC Gt_ReplyIMsg( imsg:PTR TO intuimessage ) IS NATIVE {IGadTools->GT_ReplyIMsg(} imsg {)} ENDNATIVE
->NATIVE {GT_RefreshWindow} PROC
PROC Gt_RefreshWindow( win:PTR TO window, req:PTR TO requester ) IS NATIVE {IGadTools->GT_RefreshWindow(} win {,} req {)} ENDNATIVE
->NATIVE {GT_BeginRefresh} PROC
PROC Gt_BeginRefresh( win:PTR TO window ) IS NATIVE {IGadTools->GT_BeginRefresh(} win {)} ENDNATIVE
->NATIVE {GT_EndRefresh} PROC
PROC Gt_EndRefresh( win:PTR TO window, complete:VALUE ) IS NATIVE {IGadTools->GT_EndRefresh(} win {,} complete {)} ENDNATIVE
->NATIVE {GT_FilterIMsg} PROC
PROC Gt_FilterIMsg( imsg:PTR TO intuimessage ) IS NATIVE {IGadTools->GT_FilterIMsg(} imsg {)} ENDNATIVE !!PTR TO intuimessage
->NATIVE {GT_PostFilterIMsg} PROC
PROC Gt_PostFilterIMsg( imsg:PTR TO intuimessage ) IS NATIVE {IGadTools->GT_PostFilterIMsg(} imsg {)} ENDNATIVE !!PTR TO intuimessage
->NATIVE {CreateContext} PROC
PROC CreateContext( glistptr:ARRAY OF PTR TO gadget) IS NATIVE {IGadTools->CreateContext(} glistptr {)} ENDNATIVE !!PTR TO gadget

/* Rendering Functions */

->NATIVE {DrawBevelBoxA} PROC
PROC DrawBevelBoxA( rport:PTR TO rastport, left:VALUE, top:VALUE, width:VALUE, height:VALUE, taglist:ARRAY OF tagitem ) IS NATIVE {IGadTools->DrawBevelBoxA(} rport {,} left {,} top {,} width {,} height {,} taglist {)} ENDNATIVE
->NATIVE {DrawBevelBox} PROC
PROC DrawBevelBox( rport:PTR TO rastport, left:VALUE, top:VALUE, width:VALUE, height:VALUE, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IGadTools->DrawBevelBox(} rport {,} left {,} top {,} width {,} height {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE

/* Visuals Functions */

->NATIVE {GetVisualInfoA} PROC
PROC GetVisualInfoA( screen:PTR TO screen, taglist:ARRAY OF tagitem ) IS NATIVE {IGadTools->GetVisualInfoA(} screen {,} taglist {)} ENDNATIVE !!APTR2
->NATIVE {GetVisualInfo} PROC
PROC GetVisualInfo( screen:PTR TO screen, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IGadTools->GetVisualInfo(} screen {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!APTR2
->NATIVE {FreeVisualInfo} PROC
PROC FreeVisualInfo( vi:APTR2 ) IS NATIVE {IGadTools->FreeVisualInfo(} vi {)} ENDNATIVE

/*--- functions in V39 or higher (Release 3) ---*/

->NATIVE {GT_GetGadgetAttrsA} PROC
PROC Gt_GetGadgetAttrsA( gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, taglist:ARRAY OF tagitem ) IS NATIVE {IGadTools->GT_GetGadgetAttrsA(} gad {,} win {,} req {,} taglist {)} ENDNATIVE !!VALUE
->NATIVE {GT_GetGadgetAttrs} PROC
PROC Gt_GetGadgetAttrs( gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IGadTools->GT_GetGadgetAttrs(} gad {,} win {,} req {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!VALUE
