/* $VER: gadtools_protos.h 40.1 (17.5.1996) */
OPT NATIVE, FORCENATIVE
PUBLIC MODULE 'target/libraries/gadtools'
MODULE 'target/exec/types', 'target/intuition/intuition', 'target/utility/tagitem'->, 'target/libraries/gadtools'
MODULE 'target/exec/ports', 'target/graphics/rastport', 'target/exec/libraries'
{MODULE 'gadtools'}

NATIVE {gadtoolsbase} DEF gadtoolsbase:NATIVE {LONG} PTR TO lib		->AmigaE does not automatically initialise this

/*--- functions in V36 or higher (Release 2.0) ---*/

/* Gadget Functions */

NATIVE {CreateGadgetA} PROC
PROC CreateGadgetA( kind:ULONG, gad:PTR TO gadget, ng:PTR TO newgadget, taglist:ARRAY OF tagitem ) IS NATIVE {CreateGadgetA(} kind {,} gad {,} ng {,} taglist {)} ENDNATIVE !!PTR TO gadget
->NATIVE {CreateGadget} PROC
->PROC CreateGadget( kind:ULONG, gad:PTR TO gadget, ng:PTR TO newgadget, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {CreateGadget(} kind {,} gad {,} ng {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!PTR TO gadget
NATIVE {FreeGadgets} PROC
PROC FreeGadgets( gad:PTR TO gadget ) IS NATIVE {FreeGadgets(} gad {)} ENDNATIVE
NATIVE {Gt_SetGadgetAttrsA} PROC
PROC Gt_SetGadgetAttrsA( gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, taglist:ARRAY OF tagitem ) IS NATIVE {Gt_SetGadgetAttrsA(} gad {,} win {,} req {,} taglist {)} ENDNATIVE
->NATIVE {Gt_SetGadgetAttrs} PROC
->PROC Gt_SetGadgetAttrs( gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {Gt_SetGadgetAttrs(} gad {,} win {,} req {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE

/* Menu functions */

NATIVE {CreateMenusA} PROC
PROC CreateMenusA( newmenu:PTR TO newmenu, taglist:ARRAY OF tagitem ) IS NATIVE {CreateMenusA(} newmenu {,} taglist {)} ENDNATIVE !!PTR TO menu
->NATIVE {CreateMenus} PROC
->PROC CreateMenus( newmenu:PTR TO newmenu, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {CreateMenus(} newmenu {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!PTR TO menu
NATIVE {FreeMenus} PROC
PROC FreeMenus( menu:PTR TO menu ) IS NATIVE {FreeMenus(} menu {)} ENDNATIVE
NATIVE {LayoutMenuItemsA} PROC
PROC LayoutMenuItemsA( firstitem:PTR TO menuitem, vi:APTR2, taglist:ARRAY OF tagitem ) IS NATIVE {LayoutMenuItemsA(} firstitem {,} vi {,} taglist {)} ENDNATIVE !!INT
->NATIVE {LayoutMenuItems} PROC
->PROC LayoutMenuItems( firstitem:PTR TO menuitem, vi:APTR2, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {LayoutMenuItems(} firstitem {,} vi {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!INT
NATIVE {LayoutMenusA} PROC
PROC LayoutMenusA( firstmenu:PTR TO menu, vi:APTR2, taglist:ARRAY OF tagitem ) IS NATIVE {LayoutMenusA(} firstmenu {,} vi {,} taglist {)} ENDNATIVE !!INT
->NATIVE {LayoutMenus} PROC
->PROC LayoutMenus( firstmenu:PTR TO menu, vi:APTR2, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {LayoutMenus(} firstmenu {,} vi {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!INT

/* Misc Event-Handling Functions */

NATIVE {Gt_GetIMsg} PROC
PROC Gt_GetIMsg( iport:PTR TO mp ) IS NATIVE {Gt_GetIMsg(} iport {)} ENDNATIVE !!PTR TO intuimessage
NATIVE {Gt_ReplyIMsg} PROC
PROC Gt_ReplyIMsg( imsg:PTR TO intuimessage ) IS NATIVE {Gt_ReplyIMsg(} imsg {)} ENDNATIVE
NATIVE {Gt_RefreshWindow} PROC
PROC Gt_RefreshWindow( win:PTR TO window, req:PTR TO requester ) IS NATIVE {Gt_RefreshWindow(} win {,} req {)} ENDNATIVE
NATIVE {Gt_BeginRefresh} PROC
PROC Gt_BeginRefresh( win:PTR TO window ) IS NATIVE {Gt_BeginRefresh(} win {)} ENDNATIVE
NATIVE {Gt_EndRefresh} PROC
PROC Gt_EndRefresh( win:PTR TO window, complete:VALUE ) IS NATIVE {Gt_EndRefresh(} win {,} complete {)} ENDNATIVE
NATIVE {Gt_FilterIMsg} PROC
PROC Gt_FilterIMsg( imsg:PTR TO intuimessage ) IS NATIVE {Gt_FilterIMsg(} imsg {)} ENDNATIVE !!PTR TO intuimessage
NATIVE {Gt_PostFilterIMsg} PROC
PROC Gt_PostFilterIMsg( imsg:PTR TO intuimessage ) IS NATIVE {Gt_PostFilterIMsg(} imsg {)} ENDNATIVE !!PTR TO intuimessage
NATIVE {CreateContext} PROC
PROC CreateContext( glistptr:ARRAY OF PTR TO gadget) IS NATIVE {CreateContext(} glistptr {)} ENDNATIVE !!PTR TO gadget

/* Rendering Functions */

NATIVE {DrawBevelBoxA} PROC
PROC DrawBevelBoxA( rport:PTR TO rastport, left:VALUE, top:VALUE, width:VALUE, height:VALUE, taglist:ARRAY OF tagitem ) IS NATIVE {DrawBevelBoxA(} rport {,} left {,} top {,} width {,} height {,} taglist {)} ENDNATIVE
->NATIVE {DrawBevelBox} PROC
->PROC DrawBevelBox( rport:PTR TO rastport, left:VALUE, top:VALUE, width:VALUE, height:VALUE, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {DrawBevelBox(} rport {,} left {,} top {,} width {,} height {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE

/* Visuals Functions */

NATIVE {GetVisualInfoA} PROC
PROC GetVisualInfoA( screen:PTR TO screen, taglist:ARRAY OF tagitem ) IS NATIVE {GetVisualInfoA(} screen {,} taglist {)} ENDNATIVE !!APTR2
->NATIVE {GetVisualInfo} PROC
->PROC GetVisualInfo( screen:PTR TO screen, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {GetVisualInfo(} screen {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!APTR2
NATIVE {FreeVisualInfo} PROC
PROC FreeVisualInfo( vi:APTR2 ) IS NATIVE {FreeVisualInfo(} vi {)} ENDNATIVE

/*--- functions in V39 or higher (Release 3) ---*/

NATIVE {Gt_GetGadgetAttrsA} PROC
PROC Gt_GetGadgetAttrsA( gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, taglist:ARRAY OF tagitem ) IS NATIVE {Gt_GetGadgetAttrsA(} gad {,} win {,} req {,} taglist {)} ENDNATIVE !!VALUE
->NATIVE {Gt_GetGadgetAttrs} PROC
->PROC Gt_GetGadgetAttrs( gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {Gt_GetGadgetAttrs(} gad {,} win {,} req {,} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE !!VALUE
