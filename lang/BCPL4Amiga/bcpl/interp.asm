double	macro
	dad h
	endm
stvar	macro	var,val
	lxi h,val ! shld var
	endm
memr	macro	index
	lhld index ! double
	xchg ! lhld mem ! dad d
	endm
stih	macro	dest
	mov a,m ! inx h ! mov h,m ! mov l,a ! shld dest
	endm
binop	macro op
	lhld @b ! xchg ! lhld @a ! call op
	endm
comhl	macro
	mov a,l ! cma ! mov l,a ! mov a,h ! cma ! mov h,a
	endm
neghl	macro
	local	neg
	mov a,l ! cma ! inr a ! mov l,a ! mov a,h ! cma
	jnc neg ! inr a
neg:	mov h,a
	endm
logop	macro op
	lhld @b ! xchg ! lhld @a
	mov a,h ! op d ! mov h,a
	mov a,l ! op e ! mov l,a
	endm
;int interpret()
;{
	extrn	mem,progvec,gp,pp,cycleco

;	register int	a, b, c, d, w;
	dseg
@a:	dw	0
@b:	dw	0
@c:	dw	0
@d:	dw	0
@w:	dw	0

	cseg
	public	interpret
interpret:
;	c = progvec;
	lhld progvec ! shld @c
;	cyclecount = 0;
	stvar cycleco,0
;fetch:
fetch:
;	cyclecount++;
	lhld cycleco ! inx h ! shld cycleco
;	w = mem[c];
;	c++
	lhld @c ! inx h ! shld @c ! dcx h ! double
	xchg ! lhld mem ! dad d ! stih @w
;
;	if (w & DBIT)
; save a copy of w in bc
	mov b,h ! mov c,l ! mov a,h ! ora a ! jp @1
;	{
;		d = mem[c];
;		c++;
	lhld @c ! inx h ! shld @c ! dcx h ! double
	xchg ! lhld mem ! dad d ! stih @d
	jmp @2
;	}
;	else
@1:
;		d = w & ABITS;
	mov l,c ! mvi h,0 ! shld @d
@2:
;
;#ifdef	DEBUG
;	fprintf(stderr, "%04x: %04x %05d\n", c - progvec - 1, w, d);
;#endif	DEBUG
;
; hl contains @d at this point
; b contains a copy of whi at this point
	mov a,b ! rar
;	if (w & PBIT)
	jnc @3
;		d += pp;
	xchg ! lhld pp ! dad d ! shld @d
@3:	rar
;	if (w & GBIT)
	jnc @4
;		d += gp;
	xchg ! lhld gp ! dad d ! shld @d
@4:	rar
;	if (w & IBIT)
	jnc	@5
;		d = mem[d];
	double
	xchg ! lhld mem ! dad d
	mov b,a ! stih @d
	mov a,b
;
;	switch ((w >> FSHIFT) & 07)
@5:	ani 0eh ! jz op@l ! mov e,a ! mvi d,0 ! lxi h,@tab1 ! dad d
	mov a,m ! inx h ! mov h,m ! mov l,a ! pchl
@tab1:	dw	op@l
	dw	op@s
	dw	op@a
	dw	op@j
	dw	op@t
	dw	op@f
	dw	op@k
	dw	op@x
;	{
;	case OP_L:
op@l:
;		b = a;
;		a = d;
;		goto fetch;
	lhld @a ! shld @b ! lhld @d ! shld @a ! jmp fetch
;
;	case OP_S:
op@s:
;		mem[d] = a;
;		goto fetch;
	memr @d
	lda @a ! mov m,a ! lda @a+1 ! inx h ! mov m,a ! jmp fetch
;
;	case OP_A:
op@a:
;		a += d;
;		goto fetch;
	lhld @d ! xchg ! lhld @a ! dad d ! shld @a ! jmp fetch
;
;	case OP_J:
op@j:
;		c = d;
;		goto fetch;
	lhld @d ! shld @c ! jmp fetch
;
;	case OP_T:
op@t:
;		if (a)
;			c = d;
;		goto fetch;
	lhld @a ! mov a,h ! ora l ! jnz op@j ! jmp fetch
;
;	case OP_F:
op@f:
;		if (!;a)
;			c = d;
;		goto fetch;
	lhld @a ! mov a,h ! ora l ! jz op@j ! jmp fetch
;
;	case OP_K:
op@k:
;		d += pp;
	lhld pp ! xchg ! lhld @d ! dad d ! shld @d
;		mem[d] = pp;
	double
	xchg ! lhld mem ! dad d
	lda pp ! mov m,a ! inx h ! lda pp+1 ! mov m,a ! inx h
;		mem[d+1] = c;
	lda @c ! mov m,a ! inx h ! lda @c+1 ! mov m,a
;		pp = d;
	lhld @d ! shld pp
;		c = a;
	lhld @a ! shld @c
;		goto fetch;
	jmp fetch
;
;	case OP_X:
op@x:
;		switch (d)
	lhld @d ! double
	lxi d,@tab2 ! dad d
	mov a,m ! inx h ! mov h,m ! mov l,a ! pchl
@tab2:	dw	fetch
	dw	x1
	dw	x2
	dw	x3
	dw	x4
	dw	x5
	dw	x6
	dw	x7
	dw	x8
	dw	x9
	dw	x10
	dw	x11
	dw	x12
	dw	x13
	dw	x14
	dw	x15
	dw	x16
	dw	x17
	dw	x18
	dw	x19
	dw	x20
	dw	x21
	dw	x22
	dw	x23
	dw	x24
	dw	x25
	dw	x26
	dw	x27
	dw	x28
	dw	x29
	dw	x30
	dw	x31
	dw	x32
	dw	x33
	dw	x34
	dw	x35
	dw	x36
	dw	x37
;		{
;		case 1:
x1:
;			a = mem[a];
	memr @a
	stih @a
	jmp fetch
;			goto fetch;
;		case 2:
x2:
;			a = -a;
	lhld @a ! neghl
	shld @a ! jmp fetch
;			goto fetch;
;		case 3:
x3:
;			a = ~a;
	lhld @a ! comhl
	shld @a ! jmp fetch
;			goto fetch;
;		case 4:
x4:
;			c = mem[pp+1];
;			pp = mem[pp];
	lhld pp ! inx h ! inx h ! double
	xchg ! lhld mem ! dad d
	dcx h ! mov a,m ! sta @c+1 ! dcx h ! mov a,m ! sta @c
	dcx h ! mov a,m ! sta pp+1 ! dcx h ! mov a,m ! sta pp ! jmp fetch
;			goto fetch;
;		case 5:
x5:
;			a *= b;
	extrn c@mult
	binop c@mult
	shld @a ! jmp fetch
;			goto fetch;
;		case 6:
x6:
;			a = b / a;
	extrn c@div
	binop c@div
	shld @a ! jmp fetch
;			goto fetch;
;		case 7:
x7:
;			a = b % a;
	binop c@div
	xchg ! shld @a ! jmp fetch
;			goto fetch;
;		case 8:
x8:
;			a += b;
	lhld @b ! xchg ! lhld @a ! dad d ! shld @a ! jmp fetch
;			goto fetch;
;		case 9:
x9:
;			a = b - a;
	lhld @a ! neghl
	xchg ! lhld @b ! dad d ! shld @a ! jmp fetch
;			goto fetch;
;		case 10:
x10:
;			a = b == a ? ~0 : 0;
	lhld @b ! xchg ! lhld @a
	mov a,l ! cmp e ! jnz false
	mov a,h ! cmp d ! jnz false
	stvar @a,-1
	jmp fetch
false:	stvar @a,0
	jmp fetch
;			goto fetch;
;		case 11:
x11:
;			a = b !;= a ? ~0 : 0;
	lhld @b ! xchg ! lhld @a
	mov a,l ! cmp e ! jnz true
	mov a,h ! cmp d ! jz false
true:	stvar @a,-1
	jmp fetch
;			goto fetch;
;		case 12:
x12:
;			a = b < a ? ~0 : 0;
	extrn c@lt
	binop c@lt
	jz false
	stvar @a,-1
	jmp fetch
;			goto fetch;
;		case 13:
x13:
;			a = b >= a ? ~0 : 0;
	extrn c@ge
	binop c@ge
	jz false
	stvar @a,-1
	jmp fetch
;			goto fetch;
;		case 14:
x14:
;			a = b > a ? ~0 : 0;
	extrn c@gt
	binop c@gt
	jz false
	stvar @a,-1
	jmp fetch
;			goto fetch;
;		case 15:
x15:
;			a = b <= a ? ~0 : 0;
	extrn c@le
	binop c@le
	jz false
	stvar @a,-1
	jmp fetch
;			goto fetch;
;		case 16:
x16:
;			a = b << a;
	extrn c@asl
	binop c@asl
	shld @a ! jmp fetch
;			goto fetch;
;		case 17:
x17:
;			a = b >> a;
	extrn c@asr
	binop c@asr
	shld @a ! jmp fetch
;			goto fetch;
;		case 18:
x18:
;			a &= b;
	logop ana
	shld @a ! jmp fetch
;			goto fetch;
;		case 19:
x19:
;			a |= b;
	logop ora
	shld @a ! jmp fetch
;			goto fetch;
;		case 20:
x20:
;			a ^= b;
	logop xra
	shld @a ! jmp fetch
;			goto fetch;
;		case 21:
x21:
;			a ^= ~b;
	lhld @b ! comhl
	xchg ! lhld @a
	mov a,h ! xra d ! mov h,a
	mov a,l ! xra e ! mov l,a
	shld @a ! jmp fetch
;			goto fetch;
;
;		case 22:
x22:
;			return (0); 		/* finish */
	lxi h,0 ! ret
;
;		case 23:
x23:
;			b = mem[c++];
;			d = mem[c++];	/* switchon */
	lhld @c ! double
	xchg ! lhld mem ! dad d
	mov a,m ! sta @b ! inx h ! mov a,m ! sta @b+1 ! inx h
	mov a,m ! sta @d ! inx h ! mov a,m ! sta @d+1 ! inx h
while:	xchg ! lhld @b ! mov a,l ! ora h ! jz endwhile
;			while (b !;= 0)
;			{
;				b--;
	dcx h ! shld @b ! xchg
;				if (a == mem[c++])
	lda @a ! cmp m ! inx h ! jnz skip3
	lda @a+1 ! cmp m ! inx h ! jnz skip2
;				{
;					c = mem[c];
;					goto fetch;
;				}
	stih @c
	jmp fetch
skip2:	inx h ! inx h ! jmp while
skip3:	inx h ! inx h ! inx h ! jmp while
;				c++;
;			}
endwhile:
;			c = d;
	lhld @d ! shld @c ! jmp fetch
;			goto fetch;
;
;/*
;// cases 24 upwards are only called from the following
;// hand written intcode library - iclib:
;
;//    11 lip2 x24 x4 g11l11 /selectinput
;//    12 lip2 x25 x4 g12l12 /selectoutput
;//    13 x26 x4      g13l13 /rdch
;//    14 lip2 x27 x4 g14l14 /wrch
;//    42 lip2 x28 x4 g42l42 /findinput
;//    41 lip2 x29 x4 g41l41 /findoutput
;//    30 lip2 x30 x4 g30l30 /stop
;//    31 x31 x4 g31l31 /level
;//    32 lip3 lip2 x32 g32l32 /longjump
;//    46 x33 x4 g46l46 /endread
;//    47 x34 x4 g47l47 /endwrite
;//    40 lip3 lip2 x35 g40l40 /aptovec
;//    85 lip3 lip2 x36 x4 g85l85 / getbyte
;//    86 lip3 lip2 x37 x4 g86l86 / putbyte
;//    z
;*/
;
;		case 24:
x24:
;			slctinput(a);
	extrn slctinp
	lhld @a ! push h ! call slctinp ! pop b ! jmp fetch
;			goto fetch;
;		case 25:
x25:
;			slctoutput(a);
	extrn slctout
	lhld @a ! push h ! call slctout ! pop b ! jmp fetch
;			goto fetch;
;		case 26:
x26:
;			a = rdch();
	extrn rdch
	call rdch ! shld @a ! jmp fetch
;			goto fetch;
;		case 27:
x27:
;			wrch(a);
	extrn wrch
	lhld @a ! push h ! call wrch ! pop b ! jmp fetch
;			goto fetch;
;		case 28:
x28:
;			a = findinput(a);
	extrn findinp
	lhld @a ! push h ! call findinp ! pop b ! shld @a ! jmp fetch
;			goto fetch;
;		case 29:
x29:
;			a = findoutput(a);
	extrn findout
	lhld @a ! push h ! call findout ! pop b ! shld @a ! jmp fetch
;			goto fetch;
;		case 30:
x30:
;			return (a);		/* stop(a) */
	lhld @a ! ret
;		case 31:
x31:
;			a = mem[pp];
	memr pp
	stih @a
	jmp fetch
;			goto fetch;		/* used in level() */
;		case 32:
x32:
;			pp = a;
;			c = b;			/* used in longjump(p,l) */
	lhld @a ! shld pp ! lhld @b ! shld @c ! jmp fetch
;			goto fetch;
;		case 33:
x33:
;			endread();
	extrn endread
	call endread ! jmp fetch
;			goto fetch;
;		case 34:
x34:
;			endwrite();
	extrn endwrit
	call endwrit ! jmp fetch
;			goto fetch;
;		case 35:
x35:
;			d = pp+b+1;		/* used in aptovec(f, n) */
	lhld pp ! xchg ! lhld @b ! dad d ! inx h ! shld @d
;			mem[d] = mem[pp];
	double
	xchg ! lhld mem ! dad d ! push h
	lhld pp ! double
	xchg ! lhld mem ! dad d
	mov c,l ! mov b,h ! pop h
	ldax b ! inx b ! mov m,a ! inx h
	ldax b ! inx b ! mov m,a ! inx h
;			mem[d+1] = mem[pp+1];
	ldax b ! inx b ! mov m,a ! inx h
	ldax b ! mov m,a ! inx h
;			mem[d+2] = pp;
	lda pp ! mov m,a ! inx h ! lda pp+1 ! mov m,a ! inx h
;			mem[d+3] = b;
	lda @b ! mov m,a ! inx h ! lda @b+1 ! mov m,a
;			pp = d;
	lhld @d ! shld pp
;			c = a;
	lhld @a ! shld @c ! jmp fetch
;			goto fetch;
;		case 36:
x36:
;			a = icgetbyte(a, b);	/* getbyte(s, i) */
	extrn icgetby
	lhld @a ! push h ! lhld @b ! push h ! call icgetby ! pop b ! pop b
	shld @a ! jmp fetch
;			goto fetch;
;		case 37:
x37:
;			icputbyte(a, b, mem[pp+4]);	/* putbyte(s, i, ch) */
	extrn icputby
	lhld @a ! push h ! lhld @b ! push h ! lhld pp ! lxi d,4
	dad d ! double
	xchg ! lhld mem ! dad d ! mov c,m ! inx h ! mov b,m ! push b
	call icputby ! pop b ! pop b ! pop b ! jmp fetch
;			goto fetch;
;		}
;	}
;}
