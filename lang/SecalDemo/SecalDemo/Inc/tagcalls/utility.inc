pattern AllocNamedObject(_name, ...) is
	push a6;
	push.l ...;
	safe a0:=_name; a1:=sp;;
	a6:=UtilityBase; jsr [a6-228];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# ALLOCNAMEDOBJECT

