pattern KillRAD0 is
	push a6;
	a6:=RamdriveDevice; jsr [a6-42];
	pop a6;
endp;															# KILLRAD0

pattern KillRAD(_unit) is
	push a6;
	d0.l:=_unit;
	a6:=RamdriveDevice; jsr [a6-48];
	pop a6;
endp;															# KILLRAD

