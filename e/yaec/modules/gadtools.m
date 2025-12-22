OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
-> 
-> --- functions in V36 or higher (Release 2.0) ---
-> 
->  Gadget Functions
-> 
MACRO CreateGadgetA(kind,gad,ng,taglist) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(gadtoolsbase,kind,gad,ng,taglist) BUT Loads(A6,D0,A0,A1,A2) BUT ASM ' jsr -30(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO FreeGadgets(gad) IS (A0:=gad) BUT (A6:=gadtoolsbase) BUT ASM ' jsr -36(a6)'
MACRO GT_SetGadgetAttrsA(gad,win,req,taglist) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(gadtoolsbase,gad,win,req,taglist) BUT Loads(A6,A0,A1,A2,A3) BUT ASM ' jsr -42(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
-> 
->  Menu functions
-> 
MACRO CreateMenusA(newmenu,taglist) IS Stores(gadtoolsbase,newmenu,taglist) BUT Loads(A6,A0,A1) BUT ASM ' jsr -48(a6)'
MACRO FreeMenus(menu) IS (A0:=menu) BUT (A6:=gadtoolsbase) BUT ASM ' jsr -54(a6)'
MACRO LayoutMenuItemsA(firstitem,vi,taglist) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(gadtoolsbase,firstitem,vi,taglist) BUT Loads(A6,A0,A1,A2) BUT ASM ' jsr -60(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO LayoutMenusA(firstmenu,vi,taglist) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(gadtoolsbase,firstmenu,vi,taglist) BUT Loads(A6,A0,A1,A2) BUT ASM ' jsr -66(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
-> 
->  Misc Event-Handling Functions
-> 
MACRO GT_GetIMsg(iport) IS (A0:=iport) BUT (A6:=gadtoolsbase) BUT ASM ' jsr -72(a6)'
MACRO GT_ReplyIMsg(imsg) IS (A1:=imsg) BUT (A6:=gadtoolsbase) BUT ASM ' jsr -78(a6)'
MACRO GT_RefreshWindow(win,req) IS Stores(gadtoolsbase,win,req) BUT Loads(A6,A0,A1) BUT ASM ' jsr -84(a6)'
MACRO GT_BeginRefresh(win) IS (A0:=win) BUT (A6:=gadtoolsbase) BUT ASM ' jsr -90(a6)'
MACRO GT_EndRefresh(win,complete) IS Stores(gadtoolsbase,win,complete) BUT Loads(A6,A0,D0) BUT ASM ' jsr -96(a6)'
MACRO GT_FilterIMsg(imsg) IS (A1:=imsg) BUT (A6:=gadtoolsbase) BUT ASM ' jsr -102(a6)'
MACRO GT_PostFilterIMsg(imsg) IS (A1:=imsg) BUT (A6:=gadtoolsbase) BUT ASM ' jsr -108(a6)'
MACRO CreateContext(glistptr) IS (A0:=glistptr) BUT (A6:=gadtoolsbase) BUT ASM ' jsr -114(a6)'
-> 
->  Rendering Functions
-> 
MACRO DrawBevelBoxA(rport,left,top,width,height,taglist) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(gadtoolsbase,rport,left,top,width,height,taglist) BUT Loads(A6,A0,D0,D1,D2,D3,A1) BUT ASM ' jsr -120(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
-> 
->  Visuals Functions
-> 
MACRO GetVisualInfoA(screen,taglist) IS Stores(gadtoolsbase,screen,taglist) BUT Loads(A6,A0,A1) BUT ASM ' jsr -126(a6)'
MACRO FreeVisualInfo(vi) IS (A0:=vi) BUT (A6:=gadtoolsbase) BUT ASM ' jsr -132(a6)'
-> 
-> --- functions in V39 or higher (Release 3) ---
-> 
MACRO GT_GetGadgetAttrsA(gad,win,req,taglist) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(gadtoolsbase,gad,win,req,taglist) BUT Loads(A6,A0,A1,A2,A3) BUT ASM ' jsr -174(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
-> 
