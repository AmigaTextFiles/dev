pattern IEEESPFix(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathIeeeSingBasBase; jsr [a6-30];
	pop a6;
endp;															# IEEESPFIX

pattern IEEESPFlt(_integer) is
	push a6;
	d0.l:=_integer;
	a6:=MathIeeeSingBasBase; jsr [a6-36];
	pop a6;
endp;															# IEEESPFLT

pattern IEEESPCmp(_leftParm,_rightParm) is
	push a6;
	safe d0.l:=_leftParm; d1.l:=_rightParm;;
	a6:=MathIeeeSingBasBase; jsr [a6-42];
	pop a6;
endp;															# IEEESPCMP

pattern IEEESPTst(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathIeeeSingBasBase; jsr [a6-48];
	pop a6;
endp;															# IEEESPTST

pattern IEEESPAbs(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathIeeeSingBasBase; jsr [a6-54];
	pop a6;
endp;															# IEEESPABS

pattern IEEESPNeg(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathIeeeSingBasBase; jsr [a6-60];
	pop a6;
endp;															# IEEESPNEG

pattern IEEESPAdd(_leftParm,_rightParm) is
	push a6;
	safe d0.l:=_leftParm; d1.l:=_rightParm;;
	a6:=MathIeeeSingBasBase; jsr [a6-66];
	pop a6;
endp;															# IEEESPADD

pattern IEEESPSub(_leftParm,_rightParm) is
	push a6;
	safe d0.l:=_leftParm; d1.l:=_rightParm;;
	a6:=MathIeeeSingBasBase; jsr [a6-72];
	pop a6;
endp;															# IEEESPSUB

pattern IEEESPMul(_leftParm,_rightParm) is
	push a6;
	safe d0.l:=_leftParm; d1.l:=_rightParm;;
	a6:=MathIeeeSingBasBase; jsr [a6-78];
	pop a6;
endp;															# IEEESPMUL

pattern IEEESPDiv(_dividend,_divisor) is
	push a6;
	safe d0.l:=_dividend; d1.l:=_divisor;;
	a6:=MathIeeeSingBasBase; jsr [a6-84];
	pop a6;
endp;															# IEEESPDIV

pattern IEEESPFloor(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathIeeeSingBasBase; jsr [a6-90];
	pop a6;
endp;															# IEEESPFLOOR

pattern IEEESPCeil(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathIeeeSingBasBase; jsr [a6-96];
	pop a6;
endp;															# IEEESPCEIL

