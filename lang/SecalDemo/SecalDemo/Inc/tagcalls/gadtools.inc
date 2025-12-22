pattern CreateGadget(_kind,_gad,_ng, ...) is
	push a2\a6;
	push.l ...;
	safe d0.l:=_kind; a0:=_gad; a1:=_ng; a2:=sp;;
	a6:=GadToolsBase; jsr [a6-30];
	sp:=sp+countof(...)<<2;
	pop a2\a6;
endp;															# CREATEGADGET

pattern CreateMenus(_newmenu, ...) is
	push a6;
	push.l ...;
	safe a0:=_newmenu; a1:=sp;;
	a6:=GadToolsBase; jsr [a6-48];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# CREATEMENUS

pattern DrawBevelBox(_rport,_left,_top,_width,_height, ...) is
	push d2\d3\a6;
	push.l ...;
	safe a0:=_rport; d0.l:=_left; d1.l:=_top; d2.l:=_width; d3.l:=_height; a1:=sp;;
	a6:=GadToolsBase; jsr [a6-120];
	sp:=sp+countof(...)<<2;
	pop d2\d3\a6;
endp;															# DRAWBEVELBOX

pattern GetVisualInfo(_screen, ...) is
	push a6;
	push.l ...;
	safe a0:=_screen; a1:=sp;;
	a6:=GadToolsBase; jsr [a6-126];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# GETVISUALINFO

pattern GT_GetGadgetAttrs(_gad,_win,_req, ...) is
	push a2\a3\a6;
	push.l ...;
	safe a0:=_gad; a1:=_win; a2:=_req; a3:=sp;;
	a6:=GadToolsBase; jsr [a6-174];
	sp:=sp+countof(...)<<2;
	pop a2\a3\a6;
endp;															# GT_GETGADGETATTRS

pattern GT_SetGadgetAttrs(_gad,_win,_req, ...) is
	push a2\a3\a6;
	push.l ...;
	safe a0:=_gad; a1:=_win; a2:=_req; a3:=sp;;
	a6:=GadToolsBase; jsr [a6-42];
	sp:=sp+countof(...)<<2;
	pop a2\a3\a6;
endp;															# GT_SETGADGETATTRS

pattern LayoutMenuItems(_firstitem,_vi, ...) is
	push a2\a6;
	push.l ...;
	safe a0:=_firstitem; a1:=_vi; a2:=sp;;
	a6:=GadToolsBase; jsr [a6-60];
	sp:=sp+countof(...)<<2;
	pop a2\a6;
endp;															# LAYOUTMENUITEMS

pattern LayoutMenus(_firstmenu,_vi, ...) is
	push a2\a6;
	push.l ...;
	safe a0:=_firstmenu; a1:=_vi; a2:=sp;;
	a6:=GadToolsBase; jsr [a6-66];
	sp:=sp+countof(...)<<2;
	pop a2\a6;
endp;															# LAYOUTMENUS

