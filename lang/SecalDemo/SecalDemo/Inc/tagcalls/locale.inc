pattern OpenCatalog(_locale,_name, ...) is
	push a2\a6;
	push.l ...;
	safe a0:=_locale; a1:=_name; a2:=sp;;
	a6:=LocaleBase; jsr [a6-150];
	sp:=sp+countof(...)<<2;
	pop a2\a6;
endp;															# OPENCATALOG

