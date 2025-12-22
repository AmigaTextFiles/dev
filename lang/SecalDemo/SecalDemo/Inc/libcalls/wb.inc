pattern wbPrivate1 is
	push a6;
	a6:=WorkbenchBase; jsr [a6-30];
	pop a6;
endp;															# WBPRIVATE1

pattern wbPrivate2 is
	push a6;
	a6:=WorkbenchBase; jsr [a6-36];
	pop a6;
endp;															# WBPRIVATE2

pattern wbPrivate3 is
	push a6;
	a6:=WorkbenchBase; jsr [a6-42];
	pop a6;
endp;															# WBPRIVATE3

pattern AddAppWindowA(_id,_userdata,_window,_msgport,_taglist) is
	push a2\a6;
	safe d0.l:=_id; d1.l:=_userdata; a0:=_window; a1:=_msgport; a2:=_taglist;;
	a6:=WorkbenchBase; jsr [a6-48];
	pop a2\a6;
endp;															# ADDAPPWINDOWA

pattern RemoveAppWindow(_appWindow) is
	push a6;
	a0:=_appWindow;
	a6:=WorkbenchBase; jsr [a6-54];
	pop a6;
endp;															# REMOVEAPPWINDOW

pattern AddAppIconA(_id,_userdata,_text,_msgport,_lock,_diskobj,_taglist) is
	push a2\a3\a4\a6;
	safe d0.l:=_id; d1.l:=_userdata; a0:=_text; a1:=_msgport; a2:=_lock; a3:=_diskobj; a4:=_taglist;;
	a6:=WorkbenchBase; jsr [a6-60];
	pop a2\a3\a4\a6;
endp;															# ADDAPPICONA

pattern RemoveAppIcon(_appIcon) is
	push a6;
	a0:=_appIcon;
	a6:=WorkbenchBase; jsr [a6-66];
	pop a6;
endp;															# REMOVEAPPICON

pattern AddAppMenuItemA(_id,_userdata,_text,_msgport,_taglist) is
	push a2\a6;
	safe d0.l:=_id; d1.l:=_userdata; a0:=_text; a1:=_msgport; a2:=_taglist;;
	a6:=WorkbenchBase; jsr [a6-72];
	pop a2\a6;
endp;															# ADDAPPMENUITEMA

pattern RemoveAppMenuItem(_appMenuItem) is
	push a6;
	a0:=_appMenuItem;
	a6:=WorkbenchBase; jsr [a6-78];
	pop a6;
endp;															# REMOVEAPPMENUITEM

pattern wbPrivate4 is
	push a6;
	a6:=WorkbenchBase; jsr [a6-84];
	pop a6;
endp;															# WBPRIVATE4

pattern WBInfo(_lock,_name,_screen) is
	push a2\a6;
	safe a0:=_lock; a1:=_name; a2:=_screen;;
	a6:=WorkbenchBase; jsr [a6-90];
	pop a2\a6;
endp;															# WBINFO

