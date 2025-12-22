pattern AddTime(_dest,_src) is
	push a6;
	safe a0:=_dest; a1:=_src;;
	a6:=TimerBase; jsr [a6-42];
	pop a6;
endp;															# ADDTIME

pattern SubTime(_dest,_src) is
	push a6;
	safe a0:=_dest; a1:=_src;;
	a6:=TimerBase; jsr [a6-48];
	pop a6;
endp;															# SUBTIME

pattern CmpTime(_dest,_src) is
	push a6;
	safe a0:=_dest; a1:=_src;;
	a6:=TimerBase; jsr [a6-54];
	pop a6;
endp;															# CMPTIME

pattern ReadEClock(_dest) is
	push a6;
	a0:=_dest;
	a6:=TimerBase; jsr [a6-60];
	pop a6;
endp;															# READECLOCK

pattern GetSysTime(_dest) is
	push a6;
	a0:=_dest;
	a6:=TimerBase; jsr [a6-66];
	pop a6;
endp;															# GETSYSTIME

