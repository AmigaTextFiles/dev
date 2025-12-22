pattern OpenEngine is
	push a6;
	a6:=BulletBase; jsr [a6-30];
	pop a6;
endp;															# OPENENGINE

pattern CloseEngine(_glyphEngine) is
	push a6;
	a0:=_glyphEngine;
	a6:=BulletBase; jsr [a6-36];
	pop a6;
endp;															# CLOSEENGINE

pattern SetInfoA(_glyphEngine,_tagList) is
	push a6;
	safe a0:=_glyphEngine; a1:=_tagList;;
	a6:=BulletBase; jsr [a6-42];
	pop a6;
endp;															# SETINFOA

pattern ObtainInfoA(_glyphEngine,_tagList) is
	push a6;
	safe a0:=_glyphEngine; a1:=_tagList;;
	a6:=BulletBase; jsr [a6-48];
	pop a6;
endp;															# OBTAININFOA

pattern ReleaseInfoA(_glyphEngine,_tagList) is
	push a6;
	safe a0:=_glyphEngine; a1:=_tagList;;
	a6:=BulletBase; jsr [a6-54];
	pop a6;
endp;															# RELEASEINFOA

pattern bulletPrivate1 is
	push a6;
	a6:=BulletBase; jsr [a6-60];
	pop a6;
endp;															# BULLETPRIVATE1

