UNIT GATEWAY;

INTERFACE
USES Exec;

VAR GatewayBase : pLibrary;

FUNCTION GateRequest(title_d1 : pCHAR; body : pCHAR; gadgets : pCHAR) : CARDINAL;
PROCEDURE trim(trptr : pCHAR);
PROCEDURE rtrim(trptr : pCHAR);
PROCEDURE trim_include(trptr : pCHAR);
PROCEDURE mail_trim(trptr : pCHAR; fkt : LONGINT);
PROCEDURE set(lbuff : pCHAR; slen : LONGINT);
PROCEDURE lset(lbuff : pCHAR; slen : LONGINT);
PROCEDURE lsetmin(lbuff : pCHAR; slen : LONGINT);
FUNCTION instr(sa : pCHAR; sb : pCHAR) : LONGINT;
PROCEDURE midstr(mstr : pCHAR; pos : LONGINT; laenge : LONGINT);
PROCEDURE newstr(istr : pCHAR; nstr : pCHAR; pos : LONGINT; len : LONGINT);
FUNCTION wordwrp(line : pCHAR; rest : pCHAR; len : LONGINT) : LONGINT;
PROCEDURE kill_ansi(buffer : pCHAR);
FUNCTION fn_splitt(src : pSHORTINT; drive : pSHORTINT; path : pSHORTINT; name : pSHORTINT; ext : pSHORTINT) : pSHORTINT;
FUNCTION fn_build(dst : pSHORTINT; drive : pSHORTINT; path : pSHORTINT; name : pSHORTINT; ext : pSHORTINT) : pSHORTINT;
FUNCTION time_to_zahl(ti : pCHAR) : CARDINAL;
FUNCTION date_to_zahl(da : pCHAR) : CARDINAL;
FUNCTION date_to_day(date : CARDINAL) : CARDINAL;
PROCEDURE addval(str : pCHAR; m : CARDINAL);
FUNCTION ltofa(tx_d1 : pSHORTINT; l : CARDINAL) : pSHORTINT;
PROCEDURE string(spstr : pCHAR; num : LONGINT; ch : LONGINT);
FUNCTION newer(d1 : pCHAR; t1 : pCHAR; d2 : pCHAR; t2 : pCHAR) : BOOLEAN;
PROCEDURE upstr(trptr : pCHAR);
PROCEDURE lowstr(trptr : pCHAR);
FUNCTION StrCaseCmp(s1 : pSHORTINT; s2 : pSHORTINT) : LONGINT;
FUNCTION strdup(CONST s : pSHORTINT) : pSHORTINT;
PROCEDURE swapmem(src : pSHORTINT; dst : pSHORTINT; n : LONGINT);
FUNCTION memncmp(a : pSHORTINT; b : pSHORTINT; lenght : LONGINT) : LONGINT;
FUNCTION index(str : pSHORTINT; c : LONGINT) : pSHORTINT;
PROCEDURE trim_cr(trptr : pCHAR);
FUNCTION instr_pat(sa : pCHAR; sb : pCHAR) : LONGINT;

IMPLEMENTATION

FUNCTION GateRequest(title_d1 : pCHAR; body : pCHAR; gadgets : pCHAR) : CARDINAL;
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	title_d1,D1
	MOVE.L	body,D2
	MOVE.L	gadgets,D3
	MOVEA.L	GatewayBase,A6
	JSR	-030(A6)
	MOVEA.L	(A7)+,A6
	MOVE.L	D0,@RESULT
  END;
END;

PROCEDURE trim(trptr : pCHAR);
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	trptr,D1
	MOVEA.L	GatewayBase,A6
	JSR	-036(A6)
	MOVEA.L	(A7)+,A6
  END;
END;

PROCEDURE rtrim(trptr : pCHAR);
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	trptr,D1
	MOVEA.L	GatewayBase,A6
	JSR	-042(A6)
	MOVEA.L	(A7)+,A6
  END;
END;

PROCEDURE trim_include(trptr : pCHAR);
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	trptr,D1
	MOVEA.L	GatewayBase,A6
	JSR	-048(A6)
	MOVEA.L	(A7)+,A6
  END;
END;

PROCEDURE mail_trim(trptr : pCHAR; fkt : LONGINT);
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	trptr,D1
	MOVE.L	fkt,D2
	MOVEA.L	GatewayBase,A6
	JSR	-054(A6)
	MOVEA.L	(A7)+,A6
  END;
END;

PROCEDURE set(lbuff : pCHAR; slen : LONGINT);
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	lbuff,D1
	MOVE.L	slen,D2
	MOVEA.L	GatewayBase,A6
	JSR	-060(A6)
	MOVEA.L	(A7)+,A6
  END;
END;

PROCEDURE lset(lbuff : pCHAR; slen : LONGINT);
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	lbuff,D1
	MOVE.L	slen,D2
	MOVEA.L	GatewayBase,A6
	JSR	-066(A6)
	MOVEA.L	(A7)+,A6
  END;
END;

PROCEDURE lsetmin(lbuff : pCHAR; slen : LONGINT);
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	lbuff,D1
	MOVE.L	slen,D2
	MOVEA.L	GatewayBase,A6
	JSR	-072(A6)
	MOVEA.L	(A7)+,A6
  END;
END;

FUNCTION instr(sa : pCHAR; sb : pCHAR) : LONGINT;
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	sa,D1
	MOVE.L	sb,D2
	MOVEA.L	GatewayBase,A6
	JSR	-078(A6)
	MOVEA.L	(A7)+,A6
	MOVE.L	D0,@RESULT
  END;
END;

PROCEDURE midstr(mstr : pCHAR; pos : LONGINT; laenge : LONGINT);
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	mstr,D1
	MOVE.L	pos,D2
	MOVE.L	laenge,D3
	MOVEA.L	GatewayBase,A6
	JSR	-084(A6)
	MOVEA.L	(A7)+,A6
  END;
END;

PROCEDURE newstr(istr : pCHAR; nstr : pCHAR; pos : LONGINT; len : LONGINT);
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	istr,D1
	MOVE.L	nstr,D2
	MOVE.L	pos,D3
	MOVE.L	len,D4
	MOVEA.L	GatewayBase,A6
	JSR	-090(A6)
	MOVEA.L	(A7)+,A6
  END;
END;

FUNCTION wordwrp(line : pCHAR; rest : pCHAR; len : LONGINT) : LONGINT;
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	line,D1
	MOVE.L	rest,D2
	MOVE.L	len,D3
	MOVEA.L	GatewayBase,A6
	JSR	-096(A6)
	MOVEA.L	(A7)+,A6
	MOVE.L	D0,@RESULT
  END;
END;

PROCEDURE kill_ansi(buffer : pCHAR);
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	buffer,D1
	MOVEA.L	GatewayBase,A6
	JSR	-102(A6)
	MOVEA.L	(A7)+,A6
  END;
END;

FUNCTION fn_splitt(src : pSHORTINT; drive : pSHORTINT; path : pSHORTINT; name : pSHORTINT; ext : pSHORTINT) : pSHORTINT;
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	src,D1
	MOVE.L	drive,D2
	MOVE.L	path,D3
	MOVE.L	name,D4
	MOVE.L	ext,D5
	MOVEA.L	GatewayBase,A6
	JSR	-108(A6)
	MOVEA.L	(A7)+,A6
	MOVE.L	D0,@RESULT
  END;
END;

FUNCTION fn_build(dst : pSHORTINT; drive : pSHORTINT; path : pSHORTINT; name : pSHORTINT; ext : pSHORTINT) : pSHORTINT;
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	dst,D1
	MOVE.L	drive,D2
	MOVE.L	path,D3
	MOVE.L	name,D4
	MOVE.L	ext,D5
	MOVEA.L	GatewayBase,A6
	JSR	-114(A6)
	MOVEA.L	(A7)+,A6
	MOVE.L	D0,@RESULT
  END;
END;

FUNCTION time_to_zahl(ti : pCHAR) : CARDINAL;
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	ti,D1
	MOVEA.L	GatewayBase,A6
	JSR	-120(A6)
	MOVEA.L	(A7)+,A6
	MOVE.L	D0,@RESULT
  END;
END;

FUNCTION date_to_zahl(da : pCHAR) : CARDINAL;
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	da,D1
	MOVEA.L	GatewayBase,A6
	JSR	-126(A6)
	MOVEA.L	(A7)+,A6
	MOVE.L	D0,@RESULT
  END;
END;

FUNCTION date_to_day(date : CARDINAL) : CARDINAL;
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	date,D1
	MOVEA.L	GatewayBase,A6
	JSR	-132(A6)
	MOVEA.L	(A7)+,A6
	MOVE.L	D0,@RESULT
  END;
END;

PROCEDURE addval(str : pCHAR; m : CARDINAL);
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	str,D1
	MOVE.L	m,D2
	MOVEA.L	GatewayBase,A6
	JSR	-138(A6)
	MOVEA.L	(A7)+,A6
  END;
END;

FUNCTION ltofa(tx_d1 : pSHORTINT; l : CARDINAL) : pSHORTINT;
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	tx_d1,D1
	MOVE.L	l,D2
	MOVEA.L	GatewayBase,A6
	JSR	-144(A6)
	MOVEA.L	(A7)+,A6
	MOVE.L	D0,@RESULT
  END;
END;

PROCEDURE string(spstr : pCHAR; num : LONGINT; ch : LONGINT);
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	spstr,D1
	MOVE.L	num,D2
	MOVE.L	ch,D3
	MOVEA.L	GatewayBase,A6
	JSR	-150(A6)
	MOVEA.L	(A7)+,A6
  END;
END;

FUNCTION newer(d1 : pCHAR; t1 : pCHAR; d2 : pCHAR; t2 : pCHAR) : BOOLEAN;
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	d1,D1
	MOVE.L	t1,D2
	MOVE.L	d2,D3
	MOVE.L	t2,D4
	MOVEA.L	GatewayBase,A6
	JSR	-156(A6)
	MOVEA.L	(A7)+,A6
	TST.W	D0
	BEQ.B	@end
	MOVEQ	#1,D0
  @end:	MOVE.B	D0,@RESULT
  END;
END;

PROCEDURE upstr(trptr : pCHAR);
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	trptr,D1
	MOVEA.L	GatewayBase,A6
	JSR	-162(A6)
	MOVEA.L	(A7)+,A6
  END;
END;

PROCEDURE lowstr(trptr : pCHAR);
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	trptr,D1
	MOVEA.L	GatewayBase,A6
	JSR	-168(A6)
	MOVEA.L	(A7)+,A6
  END;
END;

FUNCTION StrCaseCmp(s1 : pSHORTINT; s2 : pSHORTINT) : LONGINT;
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	s1,D1
	MOVE.L	s2,D2
	MOVEA.L	GatewayBase,A6
	JSR	-174(A6)
	MOVEA.L	(A7)+,A6
	MOVE.L	D0,@RESULT
  END;
END;

FUNCTION strdup(CONST s : pSHORTINT) : pSHORTINT;
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	s,D1
	MOVEA.L	GatewayBase,A6
	JSR	-180(A6)
	MOVEA.L	(A7)+,A6
	MOVE.L	D0,@RESULT
  END;
END;

PROCEDURE swapmem(src : pSHORTINT; dst : pSHORTINT; n : LONGINT);
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	src,D1
	MOVE.L	dst,D2
	MOVE.L	n,D3
	MOVEA.L	GatewayBase,A6
	JSR	-186(A6)
	MOVEA.L	(A7)+,A6
  END;
END;

FUNCTION memncmp(a : pSHORTINT; b : pSHORTINT; lenght : LONGINT) : LONGINT;
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	a,D1
	MOVE.L	b,D2
	MOVE.L	lenght,D3
	MOVEA.L	GatewayBase,A6
	JSR	-192(A6)
	MOVEA.L	(A7)+,A6
	MOVE.L	D0,@RESULT
  END;
END;

FUNCTION index(str : pSHORTINT; c : LONGINT) : pSHORTINT;
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	str,D1
	MOVE.L	c,D2
	MOVEA.L	GatewayBase,A6
	JSR	-198(A6)
	MOVEA.L	(A7)+,A6
	MOVE.L	D0,@RESULT
  END;
END;

PROCEDURE trim_cr(trptr : pCHAR);
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	trptr,D1
	MOVEA.L	GatewayBase,A6
	JSR	-204(A6)
	MOVEA.L	(A7)+,A6
  END;
END;

FUNCTION instr_pat(sa : pCHAR; sb : pCHAR) : LONGINT;
BEGIN
  ASM
	MOVE.L	A6,-(A7)
	MOVE.L	sa,D1
	MOVE.L	sb,D2
	MOVEA.L	GatewayBase,A6
	JSR	-210(A6)
	MOVEA.L	(A7)+,A6
	MOVE.L	D0,@RESULT
  END;
END;

END. (* UNIT GATEWAY *)
