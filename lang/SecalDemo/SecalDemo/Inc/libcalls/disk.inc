pattern AllocUnit(_unitNum) is
	push a6;
	d0.l:=_unitNum;
	a6:=DiskBase; jsr [a6-6];
	pop a6;
endp;															# ALLOCUNIT

pattern FreeUnit(_unitNum) is
	push a6;
	d0.l:=_unitNum;
	a6:=DiskBase; jsr [a6-12];
	pop a6;
endp;															# FREEUNIT

pattern GetUnit(_unitPointer) is
	push a6;
	a1:=_unitPointer;
	a6:=DiskBase; jsr [a6-18];
	pop a6;
endp;															# GETUNIT

pattern GiveUnit is
	push a6;
	a6:=DiskBase; jsr [a6-24];
	pop a6;
endp;															# GIVEUNIT

pattern GetUnitID(_unitNum) is
	push a6;
	d0.l:=_unitNum;
	a6:=DiskBase; jsr [a6-30];
	pop a6;
endp;															# GETUNITID

pattern ReadUnitID(_unitNum) is
	push a6;
	d0.l:=_unitNum;
	a6:=DiskBase; jsr [a6-36];
	pop a6;
endp;															# READUNITID

