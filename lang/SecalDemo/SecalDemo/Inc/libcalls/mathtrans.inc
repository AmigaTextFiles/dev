pattern SPAtan(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathTransBase; jsr [a6-30];
	pop a6;
endp;															# SPATAN

pattern SPSin(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathTransBase; jsr [a6-36];
	pop a6;
endp;															# SPSIN

pattern SPCos(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathTransBase; jsr [a6-42];
	pop a6;
endp;															# SPCOS

pattern SPTan(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathTransBase; jsr [a6-48];
	pop a6;
endp;															# SPTAN

pattern SPSincos(_cosResult,_parm) is
	push a6;
	safe d1.l:=_cosResult; d0.l:=_parm;;
	a6:=MathTransBase; jsr [a6-54];
	pop a6;
endp;															# SPSINCOS

pattern SPSinh(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathTransBase; jsr [a6-60];
	pop a6;
endp;															# SPSINH

pattern SPCosh(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathTransBase; jsr [a6-66];
	pop a6;
endp;															# SPCOSH

pattern SPTanh(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathTransBase; jsr [a6-72];
	pop a6;
endp;															# SPTANH

pattern SPExp(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathTransBase; jsr [a6-78];
	pop a6;
endp;															# SPEXP

pattern SPLog(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathTransBase; jsr [a6-84];
	pop a6;
endp;															# SPLOG

pattern SPPow(_power,_arg) is
	push a6;
	safe d1.l:=_power; d0.l:=_arg;;
	a6:=MathTransBase; jsr [a6-90];
	pop a6;
endp;															# SPPOW

pattern SPSqrt(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathTransBase; jsr [a6-96];
	pop a6;
endp;															# SPSQRT

pattern SPTieee(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathTransBase; jsr [a6-102];
	pop a6;
endp;															# SPTIEEE

pattern SPFieee(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathTransBase; jsr [a6-108];
	pop a6;
endp;															# SPFIEEE

pattern SPAsin(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathTransBase; jsr [a6-114];
	pop a6;
endp;															# SPASIN

pattern SPAcos(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathTransBase; jsr [a6-120];
	pop a6;
endp;															# SPACOS

pattern SPLog10(_parm) is
	push a6;
	d0.l:=_parm;
	a6:=MathTransBase; jsr [a6-126];
	pop a6;
endp;															# SPLOG10

