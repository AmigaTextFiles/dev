pattern ObtainEngine is
	push a6;
	a6:=DTClassBase; jsr [a6-30];
	pop a6;
endp;															# OBTAINENGINE

