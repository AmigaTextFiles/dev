pattern SPFix(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathBase; jsr [a6-30];
	pop a6;
endp;															# SPFIX

pattern SPFlt(_integer) is
	push a6;
	d0.l:=_integer;
	a6:=MathBase; jsr [a6-36];
	pop a6;
endp;															# SPFLT

pattern SPCmp(_leftParm,_rightParm) is
	push a6;
	safe d1.l:=_leftParm; d0.l:=_rightParm;;
	a6:=MathBase; jsr [a6-42];
	pop a6;
endp;															# SPCMP

pattern SPTst(_parm) is
	push a6;
	d1.l:=_parm;
	a6:=MathBase; jsr [a6-48];
	pop a6;
endp;															# SPTST

pattern SPAbs(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathBase; jsr [a6-54];
	pop a6;
endp;															# SPABS

pattern SPNeg(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathBase; jsr [a6-60];
	pop a6;
endp;															# SPNEG

pattern SPAdd(_leftParm,_rightParm) is
	push a6;
	safe d1.l:=_leftParm; d0.l:=_rightParm;;
	a6:=MathBase; jsr [a6-66];
	pop a6;
endp;															# SPADD

pattern SPSub(_leftParm,_rightParm) is
	push a6;
	safe d1.l:=_leftParm; d0.l:=_rightParm;;
	a6:=MathBase; jsr [a6-72];
	pop a6;
endp;															# SPSUB

pattern SPMul(_leftParm,_rightParm) is
	push a6;
	safe d1.l:=_leftParm; d0.l:=_rightParm;;
	a6:=MathBase; jsr [a6-78];
	pop a6;
endp;															# SPMUL

pattern SPDiv(_leftParm,_rightParm) is
	push a6;
	safe d1.l:=_leftParm; d0.l:=_rightParm;;
	a6:=MathBase; jsr [a6-84];
	pop a6;
endp;															# SPDIV

pattern SPFloor(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathBase; jsr [a6-90];
	pop a6;
endp;															# SPFLOOR

pattern SPCeil(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathBase; jsr [a6-96];
	pop a6;
endp;															# SPCEIL

