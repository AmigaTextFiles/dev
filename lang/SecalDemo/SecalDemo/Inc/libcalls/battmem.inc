pattern ObtainBattSemaphore is
	push a6;
	a6:=BattMemBase; jsr [a6-6];
	pop a6;
endp;															# OBTAINBATTSEMAPHORE

pattern ReleaseBattSemaphore is
	push a6;
	a6:=BattMemBase; jsr [a6-12];
	pop a6;
endp;															# RELEASEBATTSEMAPHORE

pattern ReadBattMem(_buffer,_offset,_length) is
	push a6;
	safe a0:=_buffer; d0.l:=_offset; d1.l:=_length;;
	a6:=BattMemBase; jsr [a6-18];
	pop a6;
endp;															# READBATTMEM

pattern WriteBattMem(_buffer,_offset,_length) is
	push a6;
	safe a0:=_buffer; d0.l:=_offset; d1.l:=_length;;
	a6:=BattMemBase; jsr [a6-24];
	pop a6;
endp;															# WRITEBATTMEM

