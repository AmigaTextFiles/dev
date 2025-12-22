#include	"icint.h"

int interpret()
{
#ifdef	cware
	static int	a, b, c, d, w, p;
	static word	*wp;
#else
	register int	a, b, c, d, w, p;
	register word	*wp;
#endif
#ifdef	unix
	register word	*rmem = mem;
#define	mem	rmem
#endif

	p = pp;
	c = progvec;
	cyclecount = 0;
fetch:
	cyclecount++;
#ifndef	cware
	w = mem[c++];

	if (w & DBIT)
		d = mem[c++];
	else
		d = w & ABITS;

#ifdef	DEBUG
	fprintf(stderr, "%04x: %04x %05d\n", c - progvec - 1, w, d);
#endif	DEBUG

	if (w & PBIT)
		d += p;
	if (w & GBIT)
		d += gp;
	if (w & IBIT)
		d = mem[d];

#ifdef	profiling
	++majinstr[(w >> FSHIFT) & 07];
#endif

	switch ((w >> FSHIFT) & 07)
#else
#asm
 MOV SI,WORD interpret_c_
 INC WORD interpret_c_
 SHL SI,1
 ADD SI,WORD mem_
 MOV AX,WORD [SI]
 OR AX,AX
 JGE _L1_
 INC WORD interpret_c_
 ADD SI,2
 MOV DI,WORD [SI]
 JMP _L2_
_L1_:
 MOV BH,0
 MOV BL,AL
 MOV DI,BX
_L2_:
 MOV AL,AH
 ROR AX,1
 JNC _L3_
 ADD DI,WORD interpret_p_
_L3_:
 ROR AX,1
 JNC _L4_
 ADD DI,WORD gp_
_L4_:
 ROR AX,1
 JNC _L5_
 SHL DI,1
 ADD DI,WORD mem_
 MOV DI,WORD [DI]
_L5_:
 MOV WORD interpret_d_,DI
 AND AX,14
 MOV BX,AX
 JMP BYTE _L6_[BX]
_L6_:
 DW OP_L
 DW OP_S
 DW OP_A
 DW OP_J
 DW OP_T
 DW OP_F
 DW OP_K
 DW OP_X
#
#endif
	{
#ifndef	cware
	case OP_L:
#else
#asm
OP_L:
#
#endif
		b = a;
		a = d;
		goto fetch;

#ifndef	cware
	case OP_S:
#else
#asm
OP_S:
#
#endif
		mem[d] = a;
		goto fetch;

#ifndef	cware
	case OP_A:
#else
#asm
OP_A:
#
#endif
		a += d;
		goto fetch;

#ifndef	cware
	case OP_J:
#else
#asm
OP_J:
#
#endif
		c = d;
		goto fetch;

#ifndef	cware
	case OP_T:
#else
#asm
OP_T:
#
#endif
		if (a)
			c = d;
		goto fetch;

#ifndef	cware
	case OP_F:
#else
#asm
OP_F:
#
#endif
		if (!a)
			c = d;
		goto fetch;

#ifndef	cware
	case OP_K:
#else
#asm
OP_K:
#
#endif
		d += p;
		mem[d] = p;
		mem[d+1] = c;
		p = d;
		c = a;
		goto fetch;

#ifndef	cware
	case OP_X:
#ifdef	profiling
		++mininstr[d];
#endif
#else
#asm
OP_X:
#
#endif
		switch (d)
		{
		case 0:
		default:

			fprintf(stderr, "Bad minor opcode %d at %d\n",
				d, c - progvec - 1);
			return (-1);

		case 1:
			a = mem[a];
			goto fetch;
		case 2:
			a = -a;
			goto fetch;
		case 3:
			a = ~a;
			goto fetch;
		case 4:
			c = mem[p+1];
			p = mem[p];
			goto fetch;
		case 5:
			a *= b;
			goto fetch;
		case 6:
			a = b / a;
			goto fetch;
		case 7:
			a = b % a;
			goto fetch;
		case 8:
			a += b;
			goto fetch;
		case 9:
			a = b - a;
			goto fetch;
		case 10:
			a = b == a ? ~0 : 0;
			goto fetch;
		case 11:
			a = b != a ? ~0 : 0;
			goto fetch;
		case 12:
			a = b < a ? ~0 : 0;
			goto fetch;
		case 13:
			a = b >= a ? ~0 : 0;
			goto fetch;
		case 14:
			a = b > a ? ~0 : 0;
			goto fetch;
		case 15:
			a = b <= a ? ~0 : 0;
			goto fetch;
		case 16:
			a = b << a;
			goto fetch;
		case 17:
			a = b >> a;
			goto fetch;
		case 18:
			a &= b;
			goto fetch;
		case 19:
			a |= b;
			goto fetch;
		case 20:
			a ^= b;
			goto fetch;
		case 21:
			a ^= ~b;
			goto fetch;

		case 22:
			return (0); 		/* finish */

		case 23:
			wp = &mem[c];
			b = *wp++;
			d = *wp++;	/* switchon */
			while (b-- != 0)
			{
				if (a == *wp++)
				{
					c = *wp++;
					goto fetch;
				}
				wp++;
			}
			c = d;
			goto fetch;

/*
// cases 24 upwards are only called from the following
// hand written intcode library - iclib:

//    11 lip2 x24 x4 g11l11 /selectinput
//    12 lip2 x25 x4 g12l12 /selectoutput
//    13 x26 x4      g13l13 /rdch
//    14 lip2 x27 x4 g14l14 /wrch
//    42 lip2 x28 x4 g42l42 /findinput
//    41 lip2 x29 x4 g41l41 /findoutput
//    30 lip2 x30 x4 g30l30 /stop
//    31 x31 x4 g31l31 /level
//    32 lip3 lip2 x32 g32l32 /longjump
//    46 x33 x4 g46l46 /endread
//    47 x34 x4 g47l47 /endwrite
//    40 lip3 lip2 x35 g40l40 /aptovec
//    85 lip3 lip2 x36 x4 g85l85 / getbyte
//    86 lip3 lip2 x37 x4 g86l86 / putbyte
//    z
*/

		case 24:
			slctinput(a);
			goto fetch;
		case 25:
			slctoutput(a);
			goto fetch;
		case 26:
			a = rdch();
			goto fetch;
		case 27:
			wrch(a);
			goto fetch;
		case 28:
			a = findinput(a);
			goto fetch;
		case 29:
			a = findoutput(a);
			goto fetch;
		case 30:
			return (a);		/* stop(a) */
		case 31:
			a = mem[p];
			goto fetch;		/* used in level() */
		case 32:
			p = a;
			c = b;			/* used in longjump(p,l) */
			goto fetch;
		case 33:
			endread();
			goto fetch;
		case 34:
			endwrite();
			goto fetch;
		case 35:
			d = p+b+1;		/* used in aptovec(f, n) */
			mem[d] = mem[p];
			mem[d+1] = mem[p+1];
			mem[d+2] = p;
			mem[d+3] = b;
			p = d;
			c = a;
			goto fetch;
		case 36:
			a = icgetbyte(a, b);	/* getbyte(s, i) */
			goto fetch;
		case 37:
			icputbyte(a, b, mem[p+4]);	/* putbyte(s, i, ch) */
			goto fetch;
		}
	}
}
