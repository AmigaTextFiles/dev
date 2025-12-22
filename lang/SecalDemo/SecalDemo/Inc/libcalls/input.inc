pattern PeekQualifier is
	push a6;
	a6:=InputBase; jsr [a6-42];
	pop a6;
endp;															# PEEKQUALIFIER

