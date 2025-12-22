pattern AllocAslRequestTags(_reqType, ...) is
	push a6;
	push.l ...;
	safe d0.l:=_reqType; a0:=sp;;
	a6:=AslBase; jsr [a6-48];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# ALLOCASLREQUESTTAGS

pattern AslRequestTags(_requester, ...) is
	push a6;
	push.l ...;
	safe a0:=_requester; a1:=sp;;
	a6:=AslBase; jsr [a6-60];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# ASLREQUESTTAGS

