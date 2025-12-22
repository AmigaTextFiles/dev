pattern AllocMiscResource(_unitNum,_name) is
	push a6;
	safe d0.l:=_unitNum; a1:=_name;;
	a6:=MiscBase; jsr [a6-6];
	pop a6;
endp;															# ALLOCMISCRESOURCE

pattern FreeMiscResource(_unitNum) is
	push a6;
	d0.l:=_unitNum;
	a6:=MiscBase; jsr [a6-12];
	pop a6;
endp;															# FREEMISCRESOURCE

