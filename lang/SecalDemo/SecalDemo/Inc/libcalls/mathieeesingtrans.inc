pattern IEEESPAtan(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathIeeeSingTransBase; jsr [a6-30];
	pop a6;
endp;															# IEEESPATAN

pattern IEEESPSin(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathIeeeSingTransBase; jsr [a6-36];
	pop a6;
endp;															# IEEESPSIN

pattern IEEESPCos(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathIeeeSingTransBase; jsr [a6-42];
	pop a6;
endp;															# IEEESPCOS

pattern IEEESPTan(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathIeeeSingTransBase; jsr [a6-48];
	pop a6;
endp;															# IEEESPTAN

pattern IEEESPSincos(_cosptr,_parm) is
	push a6;
	safe a0:=_cosptr; d0.l:=_parm;;
	a6:=MathIeeeSingTransBase; jsr [a6-54];
	pop a6;
endp;															# IEEESPSINCOS

pattern IEEESPSinh(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathIeeeSingTransBase; jsr [a6-60];
	pop a6;
endp;															# IEEESPSINH

pattern IEEESPCosh(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathIeeeSingTransBase; jsr [a6-66];
	pop a6;
endp;															# IEEESPCOSH

pattern IEEESPTanh(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathIeeeSingTransBase; jsr [a6-72];
	pop a6;
endp;															# IEEESPTANH

pattern IEEESPExp(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathIeeeSingTransBase; jsr [a6-78];
	pop a6;
endp;															# IEEESPEXP

pattern IEEESPLog(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathIeeeSingTransBase; jsr [a6-84];
	pop a6;
endp;															# IEEESPLOG

pattern IEEESPPow(_exp,_arg) is
	push a6;
	safe d1.l:=_exp; d0.l:=_arg;;
	a6:=MathIeeeSingTransBase; jsr [a6-90];
	pop a6;
endp;															# IEEESPPOW

pattern IEEESPSqrt(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathIeeeSingTransBase; jsr [a6-96];
	pop a6;
endp;															# IEEESPSQRT

pattern IEEESPTieee(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathIeeeSingTransBase; jsr [a6-102];
	pop a6;
endp;															# IEEESPTIEEE

pattern IEEESPFieee(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathIeeeSingTransBase; jsr [a6-108];
	pop a6;
endp;															# IEEESPFIEEE

pattern IEEESPAsin(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathIeeeSingTransBase; jsr [a6-114];
	pop a6;
endp;															# IEEESPASIN

pattern IEEESPAcos(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathIeeeSingTransBase; jsr [a6-120];
	pop a6;
endp;															# IEEESPACOS

pattern IEEESPLog10(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathIeeeSingTransBase; jsr [a6-126];
	pop a6;
endp;															# IEEESPLOG10

