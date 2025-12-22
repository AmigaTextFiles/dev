pattern AllocPotBits(_bits) is
	push a6;
	d0.l:=_bits;
	a6:=PotgoBase; jsr [a6-6];
	pop a6;
endp;															# ALLOCPOTBITS

pattern FreePotBits(_bits) is
	push a6;
	d0.l:=_bits;
	a6:=PotgoBase; jsr [a6-12];
	pop a6;
endp;															# FREEPOTBITS

pattern WritePotgo(_word,_mask) is
	push a6;
	safe d0.l:=_word; d1.l:=_mask;;
	a6:=PotgoBase; jsr [a6-18];
	pop a6;
endp;															# WRITEPOTGO

