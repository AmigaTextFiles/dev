pattern ObtainInfo(_glyphEngine, ...) is
	push a6;
	push.l ...;
	safe a0:=_glyphEngine; a1:=sp;;
	a6:=BulletBase; jsr [a6-48];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# OBTAININFO

pattern ReleaseInfo(_glyphEngine, ...) is
	push a6;
	push.l ...;
	safe a0:=_glyphEngine; a1:=sp;;
	a6:=BulletBase; jsr [a6-54];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# RELEASEINFO

pattern SetInfo(_glyphEngine, ...) is
	push a6;
	push.l ...;
	safe a0:=_glyphEngine; a1:=sp;;
	a6:=BulletBase; jsr [a6-42];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# SETINFO

