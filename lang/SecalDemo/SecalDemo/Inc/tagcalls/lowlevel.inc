pattern SetJoyPortAttrs(_portNumber, ...) is
	push a6;
	push.l ...;
	safe d0.l:=_portNumber; a1:=sp;;
	a6:=LowLevelBase; jsr [a6-132];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# SETJOYPORTATTRS

pattern SystemControl( ...) is
	push a6;
	push.l ...;
	a1:=sp;
	a6:=LowLevelBase; jsr [a6-72];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# SYSTEMCONTROL

