pattern AddAppIcon(_id,_userdata,_text,_msgport,_lock,_diskobj, ...) is
	push a2\a3\a4\a6;
	push.l ...;
	safe d0.l:=_id; d1.l:=_userdata; a0:=_text; a1:=_msgport; a2:=_lock; a3:=_diskobj; a4:=sp;;
	a6:=WorkbenchBase; jsr [a6-60];
	sp:=sp+countof(...)<<2;
	pop a2\a3\a4\a6;
endp;															# ADDAPPICON

pattern AddAppMenuItem(_id,_userdata,_text,_msgport, ...) is
	push a2\a6;
	push.l ...;
	safe d0.l:=_id; d1.l:=_userdata; a0:=_text; a1:=_msgport; a2:=sp;;
	a6:=WorkbenchBase; jsr [a6-72];
	sp:=sp+countof(...)<<2;
	pop a2\a6;
endp;															# ADDAPPMENUITEM

pattern AddAppWindow(_id,_userdata,_window,_msgport, ...) is
	push a2\a6;
	push.l ...;
	safe d0.l:=_id; d1.l:=_userdata; a0:=_window; a1:=_msgport; a2:=sp;;
	a6:=WorkbenchBase; jsr [a6-48];
	sp:=sp+countof(...)<<2;
	pop a2\a6;
endp;															# ADDAPPWINDOW

