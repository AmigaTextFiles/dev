/*
 * Copyright (c) 1998 Miloslaw Smyk
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *      This product includes software developed by Miloslaw Smyk
 * 4. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <string.h>
#include "5600x_disasm.h"

typedef unsigned char BOOL;

#if defined (BIGENDIAN)

#define	SWAP_LONG(x)	(x)
#define SWAP_WORD(x)	(x)

#else

#define SWAP_LONG(x) \
        ((unsigned long int)((((unsigned long int)(x) & 0x000000ffU) << 24) | \
                             (((unsigned long int)(x) & 0x0000ff00U) <<  8) | \
                             (((unsigned long int)(x) & 0x00ff0000U) >>  8) | \
                             (((unsigned long int)(x) & 0xff000000U) >> 24)))

#define SWAP_WORD(x) \
        ((unsigned short int)((((unsigned short int)(x) & 0x00ffU) <<  8) | \
                              (((unsigned short int)(x) & 0xff00U) >>  8)))

#endif

#define FALSE 0
#define TRUE (!FALSE)

#define PUT(x) d->line_ptr += strlen((char *)strcpy(d->line_ptr, (x)))
#define PUTC(x) {*d->line_ptr++ = (x); *d->line_ptr = '\0';}
#define FUNCS_COUNT 5
#define F_SWITCH (BOOL(*)(struct disasm_data *, int))0xffffffff


struct opcode
{
	char name[10];
	char recog[25];
	struct funcs
	{
		BOOL (*func)(struct disasm_data *, int);
		int mask;
		int shift;
	} funcs[FUNCS_COUNT];
	unsigned int mask;
	unsigned int value;
};

struct par_move
{
	char recog[17];
	struct funcs funcs[FUNCS_COUNT];
	unsigned short mask;
	unsigned short value;
};

BOOL D_ff(struct disasm_data *d, int value, int reg_bank);
BOOL D_d(struct disasm_data *d, int value);
BOOL D_dddd(struct disasm_data *d, int value);
BOOL D_ddddd(struct disasm_data *d, int value);
BOOL S_ddddd(struct disasm_data *d, int value);
BOOL SD_d(struct disasm_data *d, int value);
BOOL SD_Jd(struct disasm_data *d, int value);
BOOL SD_JJd(struct disasm_data *d, int value);
BOOL SD_JJJd(struct disasm_data *d, int value);
BOOL SS_JJJd(struct disasm_data *d, int value);
BOOL S_xi(struct disasm_data *d, int value);
BOOL D_xih(struct disasm_data *d, int value);
BOOL S_xih(struct disasm_data *d, int value);
BOOL D_EE(struct disasm_data *d, int value);
BOOL D_DDDDD(struct disasm_data *d, int value);
BOOL D_RRR(struct disasm_data *d, int value);
BOOL S_RRR(struct disasm_data *d, int value);
BOOL D_MMRRR_XY(struct disasm_data *d, int value);
BOOL D_MMRRR(struct disasm_data *d, int value);
BOOL S_MMRRR(struct disasm_data *d, int value);
BOOL D_mMMMRRR(struct disasm_data *d, int value);
BOOL S_mMMMRRR(struct disasm_data *d, int value);
BOOL D_pppppp(struct disasm_data *d, int value);
BOOL S_pppppp(struct disasm_data *d, int value);
BOOL D_DDDDDD(struct disasm_data *d, int value);
BOOL S_DDDDDD(struct disasm_data *d, int value);
BOOL S_QQQ(struct disasm_data *d, int value);
BOOL D_LLL(struct disasm_data *d, int value);
BOOL decode_XY_R_mem(struct disasm_data *d, int value);
BOOL AAE(struct disasm_data *d, int value);
BOOL AA(struct disasm_data *d, int value);
BOOL CCCC(struct disasm_data *d, int value);
BOOL sign(struct disasm_data *d, int value);
BOOL space(struct disasm_data *d, int value);
BOOL P_type(struct disasm_data *d, int value);
BOOL mem_type(struct disasm_data *d, int value);
BOOL run_functions(struct disasm_data *d, int entry, int start, int end);

char *hextable = "0123456789ABCDEF";

void byte2hex(char *cp, unsigned char value)
{
	cp[0] = hextable[value >> 4];
	cp[1] = hextable[value & 0x0f];
}

BOOL D_EE(struct disasm_data *d, int value)
{
	char *regs[] = {"MR", "CCR", "OMR"};

	if(value == 3)
		return(FALSE);

	PUT(regs[value]);

	return(TRUE);
}

BOOL D_DDDDD(struct disasm_data *d, int value)
{
	char *regs[] = {"M", "SR", "OMR", "SP", "SSH", "SSL", "LA", "LC"};

	if(value < 8)
	{
		PUT(regs[0]);
		PUTC(hextable[value & 0x07]);
	}
	else
		PUT(regs[value & 0x07]);


	return(TRUE);
}

BOOL D_ff(struct disasm_data *d, int value, int reg_bank)
{
	char *regs = "01AB";

	if(value < 2)
	{
		if(reg_bank)
			PUTC('Y')
		else
			PUTC('X');
	}

	PUTC(regs[value]);

	return(TRUE);
}

BOOL D_df(struct disasm_data *d, int value, int reg_bank)
{
	PUTC(value & 0x02 ? 'B' : 'A');
	PUTC(',');

	if(reg_bank)
			PUTC('X')
		else
			PUTC('Y');

	PUTC(value & 0x01 ? '1' : '0');

	return(TRUE);
}

BOOL S_xi(struct disasm_data *d, int value)
{
	char buf[5] = "#$";

	byte2hex(buf + 2, value);
	buf[4] = '\0';

	PUT(buf);
	PUT(",");

	return(TRUE);
}

BOOL D_xih(struct disasm_data *d, int value)
{
	char buf[3];

	PUT("#$");

	PUTC(hextable[value & 0xf]);

	byte2hex(buf, value >> 8);
	buf[2] = '\0';

	PUT(buf);

	return(TRUE);
}

BOOL S_xih(struct disasm_data *d, int value)
{
	if(D_xih(d, value) == TRUE)
	{
		PUTC(',');
		return(TRUE);
	}

	return(FALSE);
}


BOOL SD_d(struct disasm_data *d, int value)
{
	PUT(value == 0 ? "B,A": "A,B");

	return(TRUE);
}

BOOL SD_JJd(struct disasm_data *d, int value)
{
	static char *regs[] = {"X0,", "Y0,", "X1,", "Y1,"};

	PUT(regs[value >> 1]);

	return(D_d(d, value & 0x01));
}

BOOL SS_JJJd(struct disasm_data *d, int value)
{
	static char *regs[] = {"X0,", "Y0,", "X1,", "Y1,"};

	if(value > 1 && value < 8)
		return(FALSE);

	switch(value >> 1)
	{
		case 0:
			return(SD_d(d, value & 0x01));

		default:
			PUT(regs[(value >> 1) - 4]);
			break;
	}

	PUT(value & 0x01 ? "B" : "A");

	return(TRUE);
}


BOOL SD_JJJd(struct disasm_data *d, int value)
{
	static char *regs[] = {"X,", "Y,", "X0,", "Y0,", "X1,", "Y1,"};

	switch(value >> 1)
	{
		case 0:
			return(FALSE);

		case 1:
			return(SD_d(d, value & 0x01));

		default:
			PUT(regs[(value >> 1) - 2]);
			break;
	}

	PUT(value & 0x01 ? "B" : "A");

	return(TRUE);
}


BOOL SD_Jd(struct disasm_data *d, int value)
{
	static char *regs[] = {"X,A", "X,B", "Y,A", "Y,B"};

	PUT(regs[value]);

	return(TRUE);
}

BOOL D_d(struct disasm_data *d, int value)
{
	PUT(value == 0 ? "A" : "B");

	return(TRUE);
}

BOOL D_dddd(struct disasm_data *d, int value)
{
	if(value & 0x8)
		PUTC('N')
	else
		PUTC('R')

	PUTC(hextable[value & 0x0f]);

	return(TRUE);
}

BOOL S_ddddd(struct disasm_data *d, int value)
{
	if(D_ddddd(d, value) == TRUE)
	{
		PUT(",");
		return(TRUE);
	}

	return(FALSE);
}

BOOL D_ddddd(struct disasm_data *d, int value)
{
	static char *regs[] = {"X0", "X1", "Y0", "Y1", "A0", "B0", "A2", "B2", "A1", "B1", "A", "B"};

	if(value >= 4)
	{
		if(value < 16)
			PUT(regs[value - 4]);
		else
		{
			if(value < 24)
				PUTC('R')
			else
				PUTC('N')

			PUTC(hextable[value & 0x07]);
		}

		return(TRUE);
	}

	return(FALSE);
}

BOOL D_LLL(struct disasm_data *d, int value)
{
	static char *regs[] = {"A10", "B10", "X", "Y", "A", "B", "AB", "BA"};

	PUT(regs[value]);

	return(TRUE);
}

BOOL S_MMRRR(struct disasm_data *d, int value)
{
	if(D_MMRRR(d, value) == TRUE)
	{
		PUTC(',');
		return(TRUE);
	}

	return(FALSE);
}


BOOL D_MMRRR(struct disasm_data *d, int value)
{
	static char *regs[] = {")-N", ")+N", ")-", ")+"};

	PUT("(R");

	PUTC(hextable[value & 0x07]);

	PUT(regs[value >> 3]);

	if((value >> 3) < 2)
		PUTC(hextable[value & 0x07]);

	return(TRUE);
}


BOOL D_MMRRR_XY(struct disasm_data *d, int value)
{
	static char *regs[] = {")", ")+N", ")-", ")+"};

	PUT("(R");

	PUTC(hextable[value & 0x07]);

	PUT(regs[value >> 3]);

	if((value >> 3) == 1)
		PUTC(hextable[value & 0x07]);

	return(TRUE);
}


BOOL S_pppppp(struct disasm_data *d, int value)
{
	if(D_pppppp(d, value) == TRUE)
	{
		PUTC(',');
		return(TRUE);
	}

	return(FALSE);
}


BOOL D_pppppp(struct disasm_data *d, int value)
{
	char buf[8] = "<<$";

	value = 0xffc0 + value;

	byte2hex(buf + 3, value >> 8);
	byte2hex(buf + 5, value);

	buf[7] = '\0';
	PUT(buf);

	return(TRUE);
}

BOOL S_DDDDDD(struct disasm_data *d, int value)
{
	if(D_DDDDDD(d, value) == TRUE)
	{
		PUTC(',');
		return(TRUE);
	}

	return(FALSE);
}

BOOL D_DDDDDD(struct disasm_data *d, int value)
{
	static char *regs[] = {"A0", "B0", "A2", "B2", "A1", "B1", "A", "B",
													"X0", "X1", "Y0", "Y1", "*", "*", "*", "*",
													"M0", "M1", "M2", "M3", "M4", "M5", "M6", "M7",
													"N0", "N1", "N2", "N3", "N4", "N5", "N6", "N7",
													"R0", "R1", "R2", "R3", "R4", "R5", "R6", "R7",
													"*", "SR", "OMR", "SP", "SSH", "SSL", "LA", "LC"};

	switch(value >> 3)
	{
		case 0:
			if(!(value & 0x04))
				return(FALSE);

			PUT(regs[1 * 8 + (value & 0x03)]);
			break;

		case 1:
			PUT(regs[0 * 8 + (value & 0x07)]);
			break;

		case 2:
			PUT(regs[4 * 8 + (value & 0x07)]);
			break;

		case 3:
			PUT(regs[3 * 8 + (value & 0x07)]);
			break;

		case 4:
			PUT(regs[2 * 8 + (value & 0x07)]);
			break;

		case 7:
			PUT(regs[5 * 8 + (value & 0x07)]);
			break;

		default:
			return(FALSE);
	}

	return(TRUE);
}

BOOL D_RRR(struct disasm_data *d, int value)
{
	PUTC('R');
	PUTC(hextable[value]);

	return(TRUE);
}

BOOL S_RRR(struct disasm_data *d, int value)
{
	PUTC('R');
	PUTC(hextable[value]);
	PUTC(',');

	return(TRUE);
}


BOOL S_mMMMRRR(struct disasm_data *d, int value)
{
	if(D_mMMMRRR(d, value) == TRUE)
	{
		PUTC(',');
		return(TRUE);
	}

	return(FALSE);
}

BOOL D_mMMMRRR(struct disasm_data *d, int value)
{
	if(!(value & 0x40))
	{
		PUT("<$");
		PUTC(hextable[(value >> 4) & 0x03]);
		PUTC(hextable[value & 0x0f]);

		return(TRUE);
	}

	value &= ~0x40;
	
	if(value < 32)
		return(D_MMRRR(d, value));

	switch(value >> 3)
	{
		case 4:
			PUT("(R");
			PUTC(hextable[value & 0x07]);
			PUT(")");
			return(TRUE);

		case 5:
			PUT("(R");
			PUTC(hextable[value & 0x07]);
			PUT("+N");
			PUTC(hextable[value & 0x07]);
			PUT(")");
			return(TRUE);

		case 7:
			PUT("-(R");
			PUTC(hextable[value & 0x07]);
			PUT(")");
			return(TRUE);

		case 6:
		{
			char buf[9] = "#$";

			byte2hex(buf + 2, *(d->memory + 3));
			byte2hex(buf + 4, *(d->memory + 4));
			byte2hex(buf + 6, *(d->memory + 5));

			buf[8] = '\0';

			if(value & 0x4)
			{
				d->line_ptr -= 2;
				PUT(buf);
			}
			else
				PUT(buf + 1);
				
			d->words = 2;

			return(TRUE);
		}
	}
}


BOOL P_type(struct disasm_data *d, int value)
{
	PUT("P:");

	return(TRUE);
}

BOOL mem_type(struct disasm_data *d, int value)
{
	if(value == 1)
		PUT("Y:");
	else
		PUT("X:");

	return(TRUE);
}

BOOL space(struct disasm_data *d, int value)
{
	PUTC('\t');

	return(TRUE);
}

BOOL sign(struct disasm_data *d, int value)
{
	if(value == 1)
		PUTC('-');

	return(TRUE);
}

BOOL AAE(struct disasm_data *d, int value)
{
	char buf[9] = "$";

	byte2hex(buf + 1, *(d->memory + 4));
	byte2hex(buf + 3, *(d->memory + 5));

	buf[5] = '\0';

	PUT(buf);
			
	d->words = 2;

	return(TRUE);
}


BOOL AA(struct disasm_data *d, int value)
{
	char buf[3];

	PUT("<$");

	PUTC(hextable[(value >> 8) & 0xf]);

	byte2hex(buf, value);
	buf[2] = '\0';

	PUT(buf);

	return(TRUE);
}


BOOL CCCC(struct disasm_data *d, int value)
{
	static char *regs[] = {"cc", "ge", "ne", "pl", "nn", "ec", "lc", "gt", 
													"cs", "lt", "eq", "mi", "nr", "es", "ls", "le"};

	d->line_ptr--;
	*d->line_ptr = '\0';

	PUT(regs[value & 0x0f]);
	PUTC('\t');

	return(TRUE);
}

BOOL S_QQQ(struct disasm_data *d, int value)
{
	static char *regs[] = {"X0,X0", "Y0,Y0", "X1,X0", "Y1,Y0",
													"X0,Y1", "Y0,X0", "X1,Y0", "Y1,X1"};

	PUT(regs[value & 0x07]);
	PUTC(',');

	return(TRUE);
}


struct par_move pmoves[] = {
	{"0010000000000000"},
	{"001dddddiiiiiiii" , S_xi,    0x00ff, 0, D_ddddd, 0x1f00},
	{"001000eeeeeddddd" , S_ddddd, 0x03e0, 0, D_ddddd, 0x001f},
	{"00100000010MMRRR" , D_MMRRR, 0x001f}
};

struct opcode table[] = {
	{"andi",    "00000000iiiiiiii101110EE", S_xi,     0x00ff00, 0, D_EE, 0x03},
	{"bchg",    "000010110mMMMRRR0S0bbbbb", S_xi,     0x00001f, 0, mem_type, 0x40, 0, D_mMMMRRR, 0x7f00},
	{"bchg",    "0000101110pppppp0S0bbbbb", S_xi,     0x00001f, 0, mem_type, 0x40, 0, D_pppppp, 0x3f00},
	{"bchg",    "0000101111DDDDDD010bbbbb", S_xi,     0x00001f, 0, D_DDDDDD, 0x3f00},
	{"bclr",    "000010100mMMMRRR0S0bbbbb", S_xi,     0x00001f, 0, mem_type, 0x40, 0, D_mMMMRRR, 0x7f00},
	{"bclr",    "0000101010pppppp0S0bbbbb", S_xi,     0x00001f, 0, mem_type, 0x40, 0, D_pppppp, 0x3f00},
	{"bclr",    "0000101011DDDDDD010bbbbb", S_xi,     0x00001f, 0, D_DDDDDD, 0x3f00},
	{"bset",    "000010100mMMMRRR0S1bbbbb", S_xi,     0x00001f, 0, mem_type, 0x40, 0, D_mMMMRRR, 0x7f00},
	{"bset",    "0000101010pppppp0S1bbbbb", S_xi,     0x00001f, 0, mem_type, 0x40, 0, D_pppppp, 0x3f00},
	{"bset",    "0000101011DDDDDD011bbbbb", S_xi,     0x00001f, 0, D_DDDDDD, 0x3f00},
	{"btst",    "000010110mMMMRRR0S1bbbbb", S_xi,     0x00001f, 0, mem_type, 0x40, 0, D_mMMMRRR, 0x7f00},
	{"btst",    "0000101110pppppp0S1bbbbb", S_xi,     0x00001f, 0, mem_type, 0x40, 0, D_pppppp, 0x3f00},
	{"btst",    "0000101111DDDDDD011bbbbb", S_xi,     0x00001f, 0, D_DDDDDD, 0x3f00},
	{"div",     "000000011000000001JJd000", SD_JJd,   0x000038},
	{"do",      "000001100mMMMRRR0S000000", mem_type, 0x000040, 0, S_mMMMRRR, 0x007f00, 0, AAE, 0x0},
	{"do",      "00000110iiiiiiii1000hhhh", S_xih,    0x00ffff, 0, AAE, 0x0},
	{"do",      "0000011011DDDDDD00000000", S_DDDDDD, 0x003f00, 0, AAE, 0x0},
	{"enddo",   "000000000000000010001100"},
	{"illegal", "000000000000000000000101"},
	{"j",       "00001110CCCCaaaaaaaaaaaa", CCCC,     0x00f000, 0, AA,  0x0fff},
	{"j",       "0000101011MMMRRR1010CCCC", CCCC,     0x00000f, 0, D_mMMMRRR,  0x7f00},
	{"jclr",    "000010100mMMMRRR1S0bbbbb", S_xi,     0x00001f, 0, mem_type, 0x40, 0, S_mMMMRRR, 0x7f00, 0, AAE, 0x0},
	{"jclr",    "0000101010pppppp1S0bbbbb", S_xi,     0x00001f, 0, mem_type, 0x40, 0, S_pppppp, 0x7f00, 0, AAE, 0x0},
	{"jclr",    "0000101011DDDDDD000bbbbb", S_xi,     0x00001f, 0, S_DDDDDD, 0x3f00, 0, AAE, 0x0},
	{"jmp",     "0000101011MMMRRR10000000", D_mMMMRRR,0x007f00},
	{"js",      "00001111CCCCaaaaaaaaaaaa", CCCC,     0x00f000, 0, AA,  0x0fff},
	{"js",      "0000101111MMMRRR1010CCCC", CCCC,     0x00000f, 0, D_mMMMRRR,  0x7f00},
	{"jsclr",   "000010110mMMMRRR1S0bbbbb", S_xi,     0x00001f, 0, mem_type, 0x40, 0, S_mMMMRRR, 0x7f00, 0, AAE, 0x0},
	{"jsclr",   "0000101110pppppp1S0bbbbb", S_xi,     0x00001f, 0, mem_type, 0x40, 0, S_pppppp, 0x7f00, 0, AAE, 0x0},
	{"jsclr",   "0000101111DDDDDD000bbbbb", S_xi,     0x00001f, 0, S_DDDDDD, 0x3f00, 0, AAE, 0x0},
	{"jset",    "000010100mMMMRRR1S1bbbbb", S_xi,     0x00001f, 0, mem_type, 0x40, 0, S_mMMMRRR, 0x7f00, 0, AAE, 0x0},
	{"jset",    "0000101010pppppp1S1bbbbb", S_xi,     0x00001f, 0, mem_type, 0x40, 0, S_pppppp, 0x7f00, 0, AAE, 0x0},
	{"jset",    "0000101011DDDDDD001bbbbb", S_xi,     0x00001f, 0, S_DDDDDD, 0x3f00, 0, AAE, 0x0},
	{"jsr",     "000011010000aaaaaaaaaaaa", AA,       0x000fff},
	{"jsr",     "0000101111MMMRRR10000000", D_mMMMRRR,0x007f00},
	{"jsset",   "000010110mMMMRRR1S1bbbbb", S_xi,     0x00001f, 0, mem_type, 0x40, 0, S_mMMMRRR, 0x7f00, 0, AAE, 0x0},
	{"jsset",   "0000101110pppppp1S1bbbbb", S_xi,     0x00001f, 0, mem_type, 0x40, 0, S_pppppp, 0x7f00, 0, AAE, 0x0},
	{"jsset",   "0000101111DDDDDD001bbbbb", S_xi,     0x00001f, 0, S_DDDDDD, 0x3f00, 0, AAE, 0x0},
	{"lua",     "00000100010MMRRR0001dddd", S_MMRRR,  0x001f00, 0, D_dddd, 0x0f},
	{"movec",		"00000101WmMMMRRR0s1ddddd", F_SWITCH,	0x008000, 0, mem_type, 0x40, 0, D_mMMMRRR, 0x7f00, 0, D_DDDDD, 0x1f},
	{"movec",		"00000100W1eeeeee101ddddd", F_SWITCH,	0x008000, 0, D_DDDDDD, 0x3f00, 0, 0, 0, 0, D_DDDDD, 0x1f},
	{"movec",		"00000101iiiiiiii101ddddd", S_xi,			0x00ff00, 0, D_DDDDD, 0x1f},
	{"movem",		"00000111WmMMMRRR10dddddd", F_SWITCH,	0x008000, 0, P_type, 0, 0, D_mMMMRRR, 0x7f00, 0, D_DDDDDD, 0x3f},
	{"movep",		"0000100sW1MMMRRR1spppppp", F_SWITCH,	0x008000, 0, mem_type, 0x40, 0, D_mMMMRRR, 0x7f00, 0, mem_type, 0x10000, 0, D_pppppp, 0x3f},
	{"movep",		"0000100SW1MMMRRR01pppppp", F_SWITCH,	0x008000, 0, P_type, 0, 0, D_mMMMRRR, 0x7f00, 0, mem_type, 0x10000, 0, D_pppppp, 0x3f},
	{"movep",		"0000100SW1dddddd00pppppp", F_SWITCH,	0x008000, 0, D_DDDDDD, 0x3f00, 0, 0, 0, 0, mem_type, 0x10000, 0, D_pppppp, 0x3f},
	{"nop",     "000000000000000000000000"},
	{"norm",    "0000000111011RRR0001d101", S_RRR,    0x000700, 0, D_d, 0x08},
	{"ori",     "00000000iiiiiiii111110EE", S_xi,     0x00ff00, 0, D_EE, 0x03},
	{"rep",     "000001100mMMMRRR0S100000", mem_type, 0x000040, 0, D_mMMMRRR, 0x007f00},
	{"rep",     "00000110iiiiiiii1010hhhh", D_xih,    0x00ffff},
	{"rep",     "0000011011dddddd00100000", D_DDDDDD, 0x003f00},
	{"reset",   "000000000000000010000100"},
	{"rti",     "000000000000000000000100"},
	{"rts",     "000000000000000000001100"},
	{"stop",    "000000000000000010000111"},
	{"swi",     "000000000000000000000110"},
	{"t",       "00000010CCCC00000JJJD000", CCCC,     0x00f000, 0, SS_JJJd,  0x0078},
	{"t",       "00000011CCCC0ttt0JJJDTTT", CCCC,     0x00f000, 0, SS_JJJd,  0x0078, 0, space, 0, 0, S_RRR, 0x0700, 0, D_RRR, 0x07},
	{"wait",    "000000000000000010000110"},

	{"abs",                     "0010d110", D_d,     0x000008},
	{"adc",                     "001Jd001", SD_Jd,   0x000018},
	{"add",                     "0JJJd000", SD_JJJd, 0x000078},
	{"addl",                    "0001d010", SD_d,    0x000008},
	{"addr",                    "0000d010", SD_d,    0x000008},
	{"and",                     "01JJd110", SD_JJd,  0x000038},
	{"asl",                     "0011d010", D_d,     0x000008},
	{"asr",                     "0010d010", D_d,     0x000008},
	{"clr",                     "0001d011", D_d,     0x000008},
	{"cmp",                     "0JJJd101", SS_JJJd, 0x000078},
	{"cmpm",                    "0JJJd111", SS_JJJd, 0x000078},
	{"eor",                     "01JJd011", SD_JJd,  0x000038},
	{"lsl",                     "0011d011", D_d,     0x000008},
	{"lsr",                     "0010d011", D_d,     0x000008},
	{"mac",                     "1QQQdk10", sign,    0x000004, 0, S_QQQ, 0x70, 0, D_d, 0x08},
	{"macr",                    "1QQQdk11", sign,    0x000004, 0, S_QQQ, 0x70, 0, D_d, 0x08},
	{"move",                    "00000000"},
	{"mpy",                     "1QQQdk00", sign,    0x000004, 0, S_QQQ, 0x70, 0, D_d, 0x08},
	{"mpyr",                    "1QQQdk01", sign,    0x000004, 0, S_QQQ, 0x70, 0, D_d, 0x08},
	{"neg",                     "0011d110", D_d,     0x000008},
	{"not",                     "0001d111", D_d,     0x000008},
	{"or",                      "01JJd010", SD_JJd,  0x000038},
	{"rnd",                     "0001d001", D_d,     0x000008},
	{"rol",                     "0011d111", D_d,     0x000008},
	{"ror",                     "0010d111", D_d,     0x000008},
	{"sbc",                     "001Jd101", SD_Jd,   0x000018},
	{"sub",                     "0JJJd100", SD_JJJd, 0x000078},
	{"subl",                    "0001d110", SD_d,    0x000008},
	{"subr",                    "0000d110", SD_d,    0x000008},
	{"tfr",                     "0JJJd001", SS_JJJd, 0x000078},
	{"tst",                     "0000d011", D_d,     0x000008},
};


void make_masks(void)
{
	int i, j, b;

	for(i = 0; i < sizeof(table)/ sizeof(struct opcode); i++)
	{
		for(b = 0; b < strlen(table[i].recog); b++)
		{
			table[i].value <<= 1;
			table[i].mask <<= 1;

			if(table[i].recog[b] == '1' || table[i].recog[b] == '0')
				table[i].mask++;

			if(table[i].recog[b] == '1')
				table[i].value++;
		}

		for(j = 0; j < FUNCS_COUNT; j++)
		{
			if(table[i].funcs[j].func)
			{
				for(b = 0; b < 24; b++)
				{
					if(table[i].funcs[j].mask & (1 << b))
						break;
					else
						table[i].funcs[j].shift++;
				}
			}
		}
	}
}

void make_masks2(void)
{
	int i, j, b;

	for(i = 0; i < sizeof(pmoves)/ sizeof(struct par_move); i++)
	{
		for(b = 0; b < 16; b++)
		{
			pmoves[i].value <<= 1;
			pmoves[i].mask <<= 1;

			if(pmoves[i].recog[b] == '1' || pmoves[i].recog[b] == '0')
				pmoves[i].mask++;

			if(pmoves[i].recog[b] == '1')
				pmoves[i].value++;
		}

		for(j = 0; j < FUNCS_COUNT; j++)
		{
			if(pmoves[i].funcs[j].func)
			{
				for(b = 0; b < 16; b++)
				{
					if(pmoves[i].funcs[j].mask & (1 << b))
						break;
					else
						pmoves[i].funcs[j].shift++;
				}
			}
		}
	}
}


BOOL disassemble_parallel_move(struct disasm_data *d, int i, int value)
{
	int j;

	PUTC('\t');

	for(j = 0; j < FUNCS_COUNT; j++)
	{
		if(pmoves[i].funcs[j].func)
			pmoves[i].funcs[j].func(d, (value & pmoves[i].funcs[j].mask) >> pmoves[i].funcs[j].shift);
	}

	return(TRUE);
}


BOOL decode_XY_R_mem(struct disasm_data *d, int value)
{
	/* order of operands depends on whether we are writing or reading */

	if(value & 0x0080)
	{
		mem_type(d, (value >> 6) & 0x01);

		D_mMMMRRR(d, (value & 0x3f) | 0x40);
		PUTC(',');

		if(value & 0x40)
			D_ff(d, (value >> 8) & 0x03, value & 0x40);
		else
			D_ff(d, (value >> 10) & 0x03, value & 0x40);
	}
	else
	{
		if(value & 0x40)
			D_ff(d, (value >> 8) & 0x03, value & 0x40);
		else
			D_ff(d, (value >> 10) & 0x03, value & 0x40);
		PUTC(',');

		mem_type(d, (value >> 6) & 0x01);

		D_mMMMRRR(d, (value & 0x3f) | 0x40);
	}

	return(TRUE);
}


BOOL recognize_parallel_move(struct disasm_data *d, int value)
{
	int index = -1;


	if((value == 0x2000))
		index = 0;	/* NOP */
	else
		if(((value & 0xe000) == 0x2000) && (((value >> 8) & 0x1f) >= 4))
			index = 1;	/* I */
		else
			if(((value >> 10) == 0x08) && (((value >> 5) & 0x1f) >= 4) && ((value & 0x1f) >= 4))
				index = 2;	/* R */
			else
				if((value >> 5) == 0x102)
					index = 3;	/* U */
				else
					if(((value & 0xc000) == 0x4000) && (((value >> 8) & 0x37) >= 4))
					{
						PUTC('\t');

						if(value & 0x0080)
						{
							mem_type(d, (value >> 11) & 0x01);
							D_mMMMRRR(d, value & 0x7f);
							PUTC(',');
							D_ddddd(d, ((value >> 8) & 0x07) | ((value >> 9) & 0x18));
						}
						else
						{
							D_ddddd(d, ((value >> 8) & 0x07) | ((value >> 9) & 0x18));
							PUTC(',');
							mem_type(d, (value >> 11) & 0x01);
							D_mMMMRRR(d, value & 0x7f);
						}

						return(TRUE);
					}
					else
						if((value & 0xf000) == 0x1000)	/* class I */
						{						
							PUTC('\t');

							if(value & 0x40)	/* Y:R */
							{
								D_df(d, (value >> 10) & 0x03, value & 0x40);
								PUTC('\t');
								decode_XY_R_mem(d, value);
							}
							else							/* X:R */
							{
								decode_XY_R_mem(d, value);
								PUTC('\t');
								D_df(d, (value >> 8) & 0x03, value & 0x40);
							}

							return(TRUE);
						}
						else
							if((value & 0xfe40) == 0x0800)	/* class II */
							{
								PUTC('\t');

								if(value & 0x0080)	/* Y:R */
								{
									if(value & 0x0100)
										PUT("Y0,B");
									else
										PUT("Y0,A");

									PUTC('\t');

									D_d(d, (value >> 8) & 0x01);
									PUT(",Y:");
									D_mMMMRRR(d, (value & 0x3f) | 0x40);
								}
								else								/* X:R */
								{
									D_d(d, (value >> 8) & 0x01);
									PUT(",X:");
									D_mMMMRRR(d, (value & 0x3f) | 0x40);

									if(value & 0x0100)
										PUT("\tX0,B");
									else
										PUT("\tX0,A");
								}

								return(TRUE);
							}
							else
								if((value & 0xf400) == 0x4000)	/* L: */
								{
									PUTC('\t');

									if(value & 0x0080)
									{
										PUT("L:");
										D_mMMMRRR(d, value & 0x7f);
										PUTC(',');
										D_LLL(d, ((value & 0x0800) >> 9) | ((value & 0x0300) >> 8));
									}
									else
									{
										D_LLL(d, ((value & 0x0800) >> 9) | ((value & 0x0300) >> 8));
										PUT(",L:");
										D_mMMMRRR(d, value & 0x7f);
									}

									return(TRUE);
								}
								else
									if(value & 0x8000)	/* X: Y: */
									{
										PUTC('\t');

										/* X: */
										if(value & 0x0080)
										{
											PUT("X:");
											D_MMRRR_XY(d, value & 0x1f);
											PUTC(',');
											D_ff(d, (value >> 10) & 0x3, FALSE);
										}
										else
										{
											D_ff(d, (value >> 10) & 0x3, FALSE);
											PUT(",X:");
											D_MMRRR_XY(d, value & 0x1f);
										}

										PUTC('\t');

										/* Y: */
										if(value & 0x4000)
										{
											PUT("Y:");
											D_MMRRR_XY(d, ((value >> 5) & 0x03) | (~value & 0x04) | ((value >> 9) & 0x18));
											PUTC(',');
											D_ff(d, (value >> 8) & 0x3, TRUE);
										}
										else
										{
											D_ff(d, (value >> 8) & 0x3, TRUE);
											PUT(",Y:");
											D_MMRRR_XY(d, ((value >> 5) & 0x03) | (~value & 0x04) | ((value >> 9) & 0x18));
										}

										return(TRUE);
									}

					
	if(index != -1)
		return(disassemble_parallel_move(d, index, value));
}

BOOL run_functions(struct disasm_data *d, int entry, int start, int end)
{
	int j;

	for(j = start; j <= end; j++)
	{
		if(table[entry].funcs[j].func)
		{
			if(FALSE == table[entry].funcs[j].func(d, ((SWAP_LONG(*(int *)d->memory) >> 8) & table[entry].funcs[j].mask) >> table[entry].funcs[j].shift))
				return(FALSE);
		}
		else
			break;
	}

	return(TRUE);
}

int disassemble_opcode(struct disasm_data *d)
{
	unsigned int val;
	int i;
	int first, second;
	BOOL found = FALSE;


	val = SWAP_LONG((*(unsigned int *)d->memory)) >> 8;

	for(i = 0; i < sizeof(table)/ sizeof(struct opcode); i++)
	{
		if((val & table[i].mask) == table[i].value)
		{
			d->line_ptr = d->line_buf;
			d->words = 1;

			PUT(table[i].name);
			PUT("\t");

			if(table[i].funcs[0].func == F_SWITCH)
			{
				if(((SWAP_LONG(*(int *)d->memory) >> 8) & table[i].funcs[0].mask) >> table[i].funcs[0].shift)
				{
					first = 1;
					second = 3;
				}
				else
				{
					first = 3;
					second = 1;
				}

				if(run_functions(d, i, first, first + 1))
				{
					PUTC(',');
					if(!run_functions(d, i, second, second + 1))
						continue;
				}
				else
					continue;
			}
			else
				if(!run_functions(d, i, 0, FUNCS_COUNT - 1))
					continue;

			if(strlen(table[i].recog) == 8)
			{
				val = SWAP_WORD(*(unsigned short *)d->memory);

				recognize_parallel_move(d, val);
			}

			found = TRUE;
			break;
		}
	}

	if(!found)
	{
		PUT("????");
	}

	return(d->words);
}
