pattern AddAmigaGuideHost(_h,_name, ...) is
	push a6;
	push.l ...;
	safe a0:=_h; d0.l:=_name; a1:=sp;;
	a6:=AmigaGuideBase; jsr [a6-138];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# ADDAMIGAGUIDEHOST

pattern OpenAmigaGuide(_nag, ...) is
	push a6;
	push.l ...;
	safe a0:=_nag; a1:=sp;;
	a6:=AmigaGuideBase; jsr [a6-54];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# OPENAMIGAGUIDE

pattern OpenAmigaGuideAsync(_nag, ...) is
	push a6;
	push.l ...;
	safe a0:=_nag; d0.l:=sp;;
	a6:=AmigaGuideBase; jsr [a6-60];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# OPENAMIGAGUIDEASYNC

pattern RemoveAmigaGuideHost(_hh, ...) is
	push a6;
	push.l ...;
	safe a0:=_hh; a1:=sp;;
	a6:=AmigaGuideBase; jsr [a6-144];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# REMOVEAMIGAGUIDEHOST

pattern SendAmigaGuideCmd(_cl,_cmd, ...) is
	push a6;
	push.l ...;
	safe a0:=_cl; d0.l:=_cmd; d1.l:=sp;;
	a6:=AmigaGuideBase; jsr [a6-102];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# SENDAMIGAGUIDECMD

pattern SendAmigaGuideContext(_cl, ...) is
	push a6;
	push.l ...;
	safe a0:=_cl; d0.l:=sp;;
	a6:=AmigaGuideBase; jsr [a6-96];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# SENDAMIGAGUIDECONTEXT

pattern SetAmigaGuideAttrs(_cl, ...) is
	push a6;
	push.l ...;
	safe a0:=_cl; a1:=sp;;
	a6:=AmigaGuideBase; jsr [a6-108];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# SETAMIGAGUIDEATTRS

pattern SetAmigaGuideContext(_cl,_id, ...) is
	push a6;
	push.l ...;
	safe a0:=_cl; d0.l:=_id; d1.l:=sp;;
	a6:=AmigaGuideBase; jsr [a6-90];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# SETAMIGAGUIDECONTEXT

