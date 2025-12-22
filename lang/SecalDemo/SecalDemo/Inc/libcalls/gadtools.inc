pattern CreateGadgetA(_kind,_gad,_ng,_taglist) is
	push a2\a6;
	safe d0.l:=_kind; a0:=_gad; a1:=_ng; a2:=_taglist;;
	a6:=GadToolsBase; jsr [a6-30];
	pop a2\a6;
endp;															# CREATEGADGETA

pattern FreeGadgets(_gad) is
	push a6;
	a0:=_gad;
	a6:=GadToolsBase; jsr [a6-36];
	pop a6;
endp;															# FREEGADGETS

pattern GT_SetGadgetAttrsA(_gad,_win,_req,_taglist) is
	push a2\a3\a6;
	safe a0:=_gad; a1:=_win; a2:=_req; a3:=_taglist;;
	a6:=GadToolsBase; jsr [a6-42];
	pop a2\a3\a6;
endp;															# GT_SETGADGETATTRSA

pattern CreateMenusA(_newmenu,_taglist) is
	push a6;
	safe a0:=_newmenu; a1:=_taglist;;
	a6:=GadToolsBase; jsr [a6-48];
	pop a6;
endp;															# CREATEMENUSA

pattern FreeMenus(_menu) is
	push a6;
	a0:=_menu;
	a6:=GadToolsBase; jsr [a6-54];
	pop a6;
endp;															# FREEMENUS

pattern LayoutMenuItemsA(_firstitem,_vi,_taglist) is
	push a2\a6;
	safe a0:=_firstitem; a1:=_vi; a2:=_taglist;;
	a6:=GadToolsBase; jsr [a6-60];
	pop a2\a6;
endp;															# LAYOUTMENUITEMSA

pattern LayoutMenusA(_firstmenu,_vi,_taglist) is
	push a2\a6;
	safe a0:=_firstmenu; a1:=_vi; a2:=_taglist;;
	a6:=GadToolsBase; jsr [a6-66];
	pop a2\a6;
endp;															# LAYOUTMENUSA

pattern GT_GetIMsg(_iport) is
	push a6;
	a0:=_iport;
	a6:=GadToolsBase; jsr [a6-72];
	pop a6;
endp;															# GT_GETIMSG

pattern GT_ReplyIMsg(_imsg) is
	push a6;
	a1:=_imsg;
	a6:=GadToolsBase; jsr [a6-78];
	pop a6;
endp;															# GT_REPLYIMSG

pattern GT_RefreshWindow(_win,_req) is
	push a6;
	safe a0:=_win; a1:=_req;;
	a6:=GadToolsBase; jsr [a6-84];
	pop a6;
endp;															# GT_REFRESHWINDOW

pattern GT_BeginRefresh(_win) is
	push a6;
	a0:=_win;
	a6:=GadToolsBase; jsr [a6-90];
	pop a6;
endp;															# GT_BEGINREFRESH

pattern GT_EndRefresh(_win,_complete) is
	push a6;
	safe a0:=_win; d0.l:=_complete;;
	a6:=GadToolsBase; jsr [a6-96];
	pop a6;
endp;															# GT_ENDREFRESH

pattern GT_FilterIMsg(_imsg) is
	push a6;
	a1:=_imsg;
	a6:=GadToolsBase; jsr [a6-102];
	pop a6;
endp;															# GT_FILTERIMSG

pattern GT_PostFilterIMsg(_imsg) is
	push a6;
	a1:=_imsg;
	a6:=GadToolsBase; jsr [a6-108];
	pop a6;
endp;															# GT_POSTFILTERIMSG

pattern CreateContext(_glistptr) is
	push a6;
	a0:=_glistptr;
	a6:=GadToolsBase; jsr [a6-114];
	pop a6;
endp;															# CREATECONTEXT

pattern DrawBevelBoxA(_rport,_left,_top,_width,_height,_taglist) is
	push d2\d3\a6;
	safe a0:=_rport; d0.l:=_left; d1.l:=_top; d2.l:=_width; d3.l:=_height; a1:=_taglist;;
	a6:=GadToolsBase; jsr [a6-120];
	pop d2\d3\a6;
endp;															# DRAWBEVELBOXA

pattern GetVisualInfoA(_screen,_taglist) is
	push a6;
	safe a0:=_screen; a1:=_taglist;;
	a6:=GadToolsBase; jsr [a6-126];
	pop a6;
endp;															# GETVISUALINFOA

pattern FreeVisualInfo(_vi) is
	push a6;
	a0:=_vi;
	a6:=GadToolsBase; jsr [a6-132];
	pop a6;
endp;															# FREEVISUALINFO

pattern gadtoolsPrivate1 is
	push a6;
	a6:=GadToolsBase; jsr [a6-138];
	pop a6;
endp;															# GADTOOLSPRIVATE1

pattern gadtoolsPrivate2 is
	push a6;
	a6:=GadToolsBase; jsr [a6-144];
	pop a6;
endp;															# GADTOOLSPRIVATE2

pattern gadtoolsPrivate3 is
	push a6;
	a6:=GadToolsBase; jsr [a6-150];
	pop a6;
endp;															# GADTOOLSPRIVATE3

pattern gadtoolsPrivate4 is
	push a6;
	a6:=GadToolsBase; jsr [a6-156];
	pop a6;
endp;															# GADTOOLSPRIVATE4

pattern gadtoolsPrivate5 is
	push a6;
	a6:=GadToolsBase; jsr [a6-162];
	pop a6;
endp;															# GADTOOLSPRIVATE5

pattern gadtoolsPrivate6 is
	push a6;
	a6:=GadToolsBase; jsr [a6-168];
	pop a6;
endp;															# GADTOOLSPRIVATE6

pattern GT_GetGadgetAttrsA(_gad,_win,_req,_taglist) is
	push a2\a3\a6;
	safe a0:=_gad; a1:=_win; a2:=_req; a3:=_taglist;;
	a6:=GadToolsBase; jsr [a6-174];
	pop a2\a3\a6;
endp;															# GT_GETGADGETATTRSA

