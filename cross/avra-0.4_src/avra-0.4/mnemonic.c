/***********************************************************************
 *  avra - Assembler for the Atmel AVR microcontroller series
 *  Copyright (C) 1998-1999 Jon Anders Haugum
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; see the file COPYING.  If not, write to
 *  the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 *  Boston, MA 02111-1307, USA.
 *
 *
 *  Author of avra can be reached at:
 *     email: jonah@omegav.ntnu.no
 *     www: http://www.omegav.ntnu.no/~jonah/el/avra.html
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "misc.h"
#include "avra.h"
#include "device.h"

enum
	{
	MNEMONIC_NOP = 0,  //          0000 0000 0000 0000
	MNEMONIC_SEC,      //          1001 0100 0000 1000
	MNEMONIC_CLC,      //          1001 0100 1000 1000
	MNEMONIC_SEN,      //          1001 0100 0010 1000
	MNEMONIC_CLN,      //          1001 0100 1010 1000
	MNEMONIC_SEZ,      //          1001 0100 0001 1000
	MNEMONIC_CLZ,      //          1001 0100 1001 1000
	MNEMONIC_SEI,      //          1001 0100 0111 1000
	MNEMONIC_CLI,      //          1001 0100 1111 1000
	MNEMONIC_SES,      //          1001 0100 0100 1000
	MNEMONIC_CLS,      //          1001 0100 1100 1000
	MNEMONIC_SEV,      //          1001 0100 0011 1000
	MNEMONIC_CLV,      //          1001 0100 1011 1000
	MNEMONIC_SET,      //          1001 0100 0110 1000
	MNEMONIC_CLT,      //          1001 0100 1110 1000
	MNEMONIC_SEH,      //          1001 0100 0101 1000
	MNEMONIC_CLH,      //          1001 0100 1101 1000
	MNEMONIC_SLEEP,    //          1001 0101 100X 1000
	MNEMONIC_WDR,      //          1001 0101 101X 1000
	MNEMONIC_IJMP,     //          1001 0100 XXXX 1001
	MNEMONIC_ICALL,    //          1001 0101 XXXX 1001
	MNEMONIC_RET,      //          1001 0101 0XX0 1000
	MNEMONIC_RETI,     //          1001 0101 0XX1 1000
	MNEMONIC_LPM,      //          1001 0101 1100 1000
	MNEMONIC_ELPM,     //          1001 0101 1101 1000
	MNEMONIC_BSET,     // s        1001 0100 0sss 1000
	MNEMONIC_BCLR,     // s        1001 0100 1sss 1000
	MNEMONIC_SER,      // Rd       1110 1111 dddd 1111
	MNEMONIC_COM,      // Rd       1001 010d dddd 0000
	MNEMONIC_NEG,      // Rd       1001 010d dddd 0001
	MNEMONIC_INC,      // Rd       1001 010d dddd 0011
	MNEMONIC_DEC,      // Rd       1001 010d dddd 1010
	MNEMONIC_LSR,      // Rd       1001 010d dddd 0110
	MNEMONIC_ROR,      // Rd       1001 010d dddd 0111
	MNEMONIC_ASR,      // Rd       1001 010d dddd 0101
	MNEMONIC_SWAP,     // Rd       1001 010d dddd 0010
	MNEMONIC_PUSH,     // Rr       1001 001r rrrr 1111
	MNEMONIC_POP,      // Rd       1001 000d dddd 1111
	MNEMONIC_TST,      // Rd       0010 00dd dddd dddd
	MNEMONIC_CLR,      // Rd       0010 01dd dddd dddd
	MNEMONIC_LSL,      // Rd       0000 11dd dddd dddd
	MNEMONIC_ROL,      // Rd       0001 11dd dddd dddd
	MNEMONIC_BREQ,     // k        1111 00kk kkkk k001
	MNEMONIC_BRNE,     // k        1111 01kk kkkk k001
	MNEMONIC_BRCS,     // k        1111 00kk kkkk k000
	MNEMONIC_BRCC,     // k        1111 01kk kkkk k000
	MNEMONIC_BRSH,     // k        1111 01kk kkkk k000
	MNEMONIC_BRLO,     // k        1111 00kk kkkk k000
	MNEMONIC_BRMI,     // k        1111 00kk kkkk k010
	MNEMONIC_BRPL,     // k        1111 01kk kkkk k010
	MNEMONIC_BRGE,     // k        1111 01kk kkkk k100
	MNEMONIC_BRLT,     // k        1111 00kk kkkk k100
	MNEMONIC_BRHS,     // k        1111 00kk kkkk k101
	MNEMONIC_BRHC,     // k        1111 01kk kkkk k101
	MNEMONIC_BRTS,     // k        1111 00kk kkkk k110
	MNEMONIC_BRTC,     // k        1111 01kk kkkk k110
	MNEMONIC_BRVS,     // k        1111 00kk kkkk k011
	MNEMONIC_BRVC,     // k        1111 01kk kkkk k011
	MNEMONIC_BRIE,     // k        1111 00kk kkkk k111
	MNEMONIC_BRID,     // k        1111 01kk kkkk k111
	MNEMONIC_RJMP,     // k        1100 kkkk kkkk kkkk
	MNEMONIC_RCALL,    // k        1101 kkkk kkkk kkkk
	MNEMONIC_JMP,      // k        1001 010k kkkk 110k + 16k
	MNEMONIC_CALL,     // k        1001 010k kkkk 111k + 16k
	MNEMONIC_BRBS,     // s, k     1111 00kk kkkk ksss
	MNEMONIC_BRBC,     // s, k     1111 01kk kkkk ksss
	MNEMONIC_ADD,      // Rd, Rr   0000 11rd dddd rrrr
	MNEMONIC_ADC,      // Rd, Rr   0001 11rd dddd rrrr
	MNEMONIC_SUB,      // Rd, Rr   0001 10rd dddd rrrr
	MNEMONIC_SBC,      // Rd, Rr   0000 10rd dddd rrrr
	MNEMONIC_AND,      // Rd, Rr   0010 00rd dddd rrrr
	MNEMONIC_OR,       // Rd, Rr   0010 10rd dddd rrrr
	MNEMONIC_EOR,      // Rd, Rr   0010 01rd dddd rrrr
	MNEMONIC_CP,       // Rd, Rr   0001 01rd dddd rrrr
	MNEMONIC_CPC,      // Rd, Rr   0000 01rd dddd rrrr
	MNEMONIC_CPSE,     // Rd, Rr   0001 00rd dddd rrrr
	MNEMONIC_MOV,      // Rd, Rr   0010 11rd dddd rrrr
	MNEMONIC_MUL,      // Rd, Rr   1001 11rd dddd rrrr
	MNEMONIC_ADIW,     // Rd, K    1001 0110 KKdd KKKK
	MNEMONIC_SBIW,     // Rd, K    1001 0111 KKdd KKKK
	MNEMONIC_SUBI,     // Rd, K    0101 KKKK dddd KKKK
	MNEMONIC_SBCI,     // Rd, K    0100 KKKK dddd KKKK
	MNEMONIC_ANDI,     // Rd, K    0111 KKKK dddd KKKK
	MNEMONIC_ORI,      // Rd, K    0110 KKKK dddd KKKK
	MNEMONIC_SBR,      // Rd, K    0110 KKKK dddd KKKK
	MNEMONIC_CPI,      // Rd, K    0011 KKKK dddd KKKK
	MNEMONIC_LDI,      // Rd, K    1110 KKKK dddd KKKK
	MNEMONIC_CBR,      // Rd, K    0111 KKKK dddd KKKK ~K
	MNEMONIC_SBRC,     // Rr, b    1111 110r rrrr Xbbb
	MNEMONIC_SBRS,     // Rr, b    1111 111r rrrr Xbbb
	MNEMONIC_BST,      // Rr, b    1111 101d dddd Xbbb
	MNEMONIC_BLD,      // Rd, b    1111 100d dddd 0bbb
	MNEMONIC_IN,       // Rd, P    1011 0PPd dddd PPPP
	MNEMONIC_OUT,      // P, Rr    1011 1PPr rrrr PPPP
	MNEMONIC_SBIC,     // P, b     1001 1001 PPPP Pbbb
	MNEMONIC_SBIS,     // P, b     1001 1011 PPPP Pbbb
	MNEMONIC_SBI,      // P, b     1001 1010 PPPP Pbbb
	MNEMONIC_CBI,      // P, b     1001 1000 PPPP Pbbb
	MNEMONIC_LDS,      // Rd, k    1001 000d dddd 0000 + 16k
	MNEMONIC_STS,      // k, Rr    1001 001d dddd 0000 + 16k
	MNEMONIC_LD,       // Rd, __   dummy
	MNEMONIC_ST,       // __, Rr   dummy
	MNEMONIC_LDD,      // Rd, _+q  dummy
	MNEMONIC_STD,      // _+q, Rr  dummy
	MNEMONIC_COUNT,
	MNEMONIC_LD_X,     // Rd, X    1001 000d dddd 1100
	MNEMONIC_LD_XP,    // Rd, X+   1001 000d dddd 1101
	MNEMONIC_LD_MX,    // Rd, -X   1001 000d dddd 1110
	MNEMONIC_LD_Y,     // Rd, Y    1000 000d dddd 1000
	MNEMONIC_LD_YP,    // Rd, Y+   1001 000d dddd 1001
	MNEMONIC_LD_MY,    // Rd, -Y   1001 000d dddd 1010
	MNEMONIC_LD_Z,     // Rd, Z    1000 000d dddd 0000
	MNEMONIC_LD_ZP,    // Rd, Z+   1001 000d dddd 0001
	MNEMONIC_LD_MZ,    // Rd, -Z   1001 000d dddd 0010
	MNEMONIC_ST_X,     // X, Rr    1001 001d dddd 1100
	MNEMONIC_ST_XP,    // X+, Rr   1001 001d dddd 1101
	MNEMONIC_ST_MX,    // -X, Rr   1001 001d dddd 1110
	MNEMONIC_ST_Y,     // Y, Rr    1000 001d dddd 1000
	MNEMONIC_ST_YP,    // Y+, Rr   1001 001d dddd 1001
	MNEMONIC_ST_MY,    // -Y, Rr   1001 001d dddd 1010
	MNEMONIC_ST_Z,     // Z, Rr    1000 001d dddd 0000
	MNEMONIC_ST_ZP,    // Z+, Rr   1001 001d dddd 0001
	MNEMONIC_ST_MZ,    // -Z, Rr   1001 001d dddd 0010
	MNEMONIC_LDD_Y,    // Rd, Y+q  10q0 qq0d dddd 1qqq
	MNEMONIC_LDD_Z,    // Rd, Z+q  10q0 qq0d dddd 0qqq
	MNEMONIC_STD_Y,    // Y+q, Rr  10q0 qq1r rrrr 1qqq
	MNEMONIC_STD_Z,    // Z+q, Rr  10q0 qq1r rrrr 0qqq
	};

struct instruction
	{
	char *mnemonic;
	int opcode;
	};

struct instruction instruction_list[] =
	{
	{"nop",   0x0000},
	{"sec",   0x9408},
	{"clc",   0x9488},
	{"sen",   0x9428},
	{"cln",   0x94a8},
	{"sez",   0x9418},
	{"clz",   0x9498},
	{"sei",   0x9478},
	{"cli",   0x94f8},
	{"ses",   0x9448},
	{"cls",   0x94c8},
	{"sev",   0x9438},
	{"clv",   0x94b8},
	{"set",   0x9468},
	{"clt",   0x94e8},
	{"seh",   0x9458},
	{"clh",   0x94d8},
	{"sleep", 0x9588},
	{"wdr",   0x95a8},
	{"ijmp",  0x9409},
	{"icall", 0x9509},
	{"ret",   0x9508},
	{"reti",  0x9518},
	{"lpm",   0x95c8},
	{"elpm",  0x95d8},
	{"bset",  0x9408},
	{"bclr",  0x9488},
	{"ser",   0xef0f},
	{"com",   0x9400},
	{"neg",   0x9401},
	{"inc",   0x9403},
	{"dec",   0x940a},
	{"lsr",   0x9406},
	{"ror",   0x9407},
	{"asr",   0x9405},
	{"swap",  0x9402},
	{"push",  0x920f},
	{"pop",   0x900f},
	{"tst",   0x2000},
	{"clr",   0x2400},
	{"lsl",   0x0c00},
	{"rol",   0x1c00},
	{"breq",  0xf001},
	{"brne",  0xf401},
	{"brcs",  0xf000},
	{"brcc",  0xf400},
	{"brsh",  0xf400},
	{"brlo",  0xf000},
	{"brmi",  0xf002},
	{"brpl",  0xf402},
	{"brge",  0xf404},
	{"brlt",  0xf004},
	{"brhs",  0xf005},
	{"brhc",  0xf405},
	{"brts",  0xf006},
	{"brtc",  0xf406},
	{"brvs",  0xf003},
	{"brvc",  0xf403},
	{"brie",  0xf007},
	{"brid",  0xf407},
	{"rjmp",  0xc000},
	{"rcall", 0xd000},
	{"jmp",   0x940c},
	{"call",  0x940e},
	{"brbs",  0xf000},
	{"brbc",  0xf400},
	{"add",   0x0c00},
	{"adc",   0x1c00},
	{"sub",   0x1800},
	{"sbc",   0x0800},
	{"and",   0x2000},
	{"or",    0x2800},
	{"eor",   0x2400},
	{"cp",    0x1400},
	{"cpc",   0x0400},
	{"cpse",  0x1000},
	{"mov",   0x2c00},
	{"mul",   0x9c00},
	{"adiw",  0x9600},
	{"sbiw",  0x9700},
	{"subi",  0x5000},
	{"sbci",  0x4000},
	{"andi",  0x7000},
	{"ori",   0x6000},
	{"sbr",   0x6000},
	{"cpi",   0x3000},
	{"ldi",   0xe000},
	{"cbr",   0x7000},
	{"sbrc",  0xfc00},
	{"sbrs",  0xfe00},
	{"bst",   0xfa00},
	{"bld",   0xf800},
	{"in",    0xb000},
	{"out",   0xb800},
	{"sbic",  0x9900},
	{"sbis",  0x9b00},
	{"sbi",   0x9a00},
	{"cbi",   0x9800},
	{"lds",   0x9000},
	{"sts",   0x9200},
	{"ld",    0},
	{"st",    0},
	{"ldd",   0},
	{"std",   0},
	{"count", 0},
	{"ld",    0x900c},
	{"ld",    0x900d},
	{"ld",    0x900e},
	{"ld",    0x8008},
	{"ld",    0x9009},
	{"ld",    0x900a},
	{"ld",    0x8000},
	{"ld",    0x9001},
	{"ld",    0x9002},
	{"st",    0x920c},
	{"st",    0x920d},
	{"st",    0x920e},
	{"st",    0x8208},
	{"st",    0x9209},
	{"st",    0x920a},
	{"st",    0x8200},
	{"st",    0x9201},
	{"st",    0x9202},
	{"ldd",   0x8008},
	{"ldd",   0x8000},
	{"std",   0x8208},
	{"std",   0x8200}
	};


int parse_mnemonic(struct prog_info *pi, int pass)
	{
	int mnemonic, i, opcode, opcode2, instruction_long = False;
	char *operand1, *operand2;
	struct macro *macro;

	operand1 = get_next_token(pi->fi->scratch, TERM_SPACE);
	for(i = 0; pi->fi->scratch[i] != '\0'; i++)
		pi->fi->scratch[i] = tolower(pi->fi->scratch[i]);
	mnemonic = get_mnemonic_type(pi->fi->scratch);
	if(mnemonic == -1)
		{
		macro = get_macro(pi, pi->fi->scratch);
		if(macro)
			{
			return(expand_macro(pi, macro, operand1, pass));
			}
		else
			{
			print_msg(pi, MSGTYPE_ERROR, "Unknown mnemonic/macro: %s", pi->fi->scratch);
			return(True);
			}
		}
	if(pass == PASS_2)
		{
		if(mnemonic <= MNEMONIC_ELPM)
			{
			// No operand
			opcode = 0;
			}
		else
			{
			if(!operand1)
				{
				print_msg(pi, MSGTYPE_ERROR, "%s needs an operand", instruction_list[mnemonic].mnemonic);
				return(True);
				}
			operand2 = get_next_token(operand1, TERM_COMMA);
			if(mnemonic >= MNEMONIC_BRBS)
				{
				if(!operand2)
					{
					print_msg(pi, MSGTYPE_ERROR, "%s needs a second operand", instruction_list[mnemonic].mnemonic);
					return(True);
					}
				get_next_token(operand2, TERM_END);
				}
			if(mnemonic <= MNEMONIC_BCLR)
				{
				if(!get_bitnum(pi, operand1, &i))
					return(False);
				opcode = i << 4;
				}
			else if(mnemonic <= MNEMONIC_ROL)
				{
				i = get_register(pi, operand1);
				if((mnemonic == MNEMONIC_SER) && (i < 16))
					{
					print_msg(pi, MSGTYPE_ERROR, "%s can only use a high register (r16 - r31)", instruction_list[mnemonic].mnemonic);
					i &= 0x0f;
					}
				opcode = i << 4;
				if(mnemonic >= MNEMONIC_TST)
					opcode |= ((i & 0x10) << 5) | (i & 0x0f);
				}
			else if(mnemonic <= MNEMONIC_RCALL)
				{
				if(!get_expr(pi, operand1, &i))
					return(False);
				i -= pi->cseg_addr + 1;
				if(mnemonic <= MNEMONIC_BRID)
					{
					if((i < -64) || (i > 63))
						print_msg(pi, MSGTYPE_ERROR, "Branch out of range (-64 <= k <= 63)");
					opcode = (i & 0x7f) << 3;
					}
				else
					{
					if((i < -2048) || (i > 2047))
						print_msg(pi, MSGTYPE_ERROR, "Relative address out of range (-2048 <= k <= 2047)");
					opcode = i & 0x0fff;
					}
				}
			else if(mnemonic <= MNEMONIC_CALL)
				{
				if(!get_expr(pi, operand1, &i))
					return(False);
				if((i < 0) || (i > 4194303))
					print_msg(pi, MSGTYPE_ERROR, "Address out of range (0 <= k <= 4194303)");
				opcode = ((i & 0x3e0000) >> 13) | ((i & 0x01000) >> 16);
				opcode2 = i & 0xffff;
				instruction_long = True;
				}
			else if(mnemonic <= MNEMONIC_BRBC)
				{
				if(!get_bitnum(pi, operand1, &i))
					return(False);
				opcode = i;
				if(!get_expr(pi, operand2, &i))
					return(False);
				i -= pi->cseg_addr + 1;
				if((i < -64) || (i > 63))
					print_msg(pi, MSGTYPE_ERROR, "Branch out of range (-64 <= k <= 63)");
				opcode |= i << 3;
				}
			else if(mnemonic <= MNEMONIC_MUL)
				{
				if((mnemonic == MNEMONIC_MUL) && (pi->device->flag & DF_NO_MUL))
					print_msg(pi, MSGTYPE_ERROR, "MUL instruction is not supported on %s", pi->device->name);
				i = get_register(pi, operand1);
				opcode = i << 4;
				i = get_register(pi, operand2);
				opcode |= ((i & 0x10) << 5) | (i & 0x0f);
				}
			else if(mnemonic <= MNEMONIC_SBIW)
				{
				i = get_register(pi, operand1);
				if(!((i == 24) || (i == 26) || (i == 28) || (i == 30)))
					print_msg(pi, MSGTYPE_ERROR, "%s can only use registers R24, R26, R28 or R30", instruction_list[mnemonic].mnemonic);
				opcode = ((i - 24) / 2) << 4;
				if(!get_expr(pi, operand2, &i))
					return(False);
				if((i < 0) || (i > 63))
					print_msg(pi, MSGTYPE_ERROR, "Constant out of range (0 <= k <= 63)");
				opcode |= ((i & 0x30) << 2) | (i & 0x0f);
				}
			else if(mnemonic <= MNEMONIC_CBR)
				{
				i = get_register(pi, operand1);
				if(i < 16)
					print_msg(pi, MSGTYPE_ERROR, "%s can only use a high register (r16 - r31)", instruction_list[mnemonic].mnemonic);
				opcode = (i & 0x0f) << 4;
				if(!get_expr(pi, operand2, &i))
					return(False);
				if((i < -128) || (i > 255))
					print_msg(pi, MSGTYPE_ERROR, "Constant out of range (-128 <= k <= 255)");
				if(mnemonic == MNEMONIC_CBR)
					i = ~i;
				opcode |= ((i & 0xf0) << 4) | (i & 0x0f);
				}
			else if(mnemonic <= MNEMONIC_BLD)
				{
				i = get_register(pi, operand1);
				opcode = i << 4;
				if(!get_bitnum(pi, operand2, &i))
					return(False);
				opcode |= i;
				}
			else if(mnemonic == MNEMONIC_IN)
				{
				i = get_register(pi, operand1);
				opcode = i << 4;
				if(!get_expr(pi, operand2, &i))
					return(False);
				if((i < 0) || (i > 63))
					print_msg(pi, MSGTYPE_ERROR, "I/O out of range (0 <= P <= 63)");
				opcode |= ((i & 0x30) << 5) | (i & 0x0f);
				}
			else if(mnemonic == MNEMONIC_OUT)
				{
				if(!get_expr(pi, operand1, &i))
					return(False);
				if((i < 0) || (i > 63))
					print_msg(pi, MSGTYPE_ERROR, "I/O out of range (0 <= P <= 63)");
				opcode = ((i & 0x30) << 5) | (i & 0x0f);
				i = get_register(pi, operand2);
				opcode |= i << 4;
				}
			else if(mnemonic <= MNEMONIC_CBI)
				{
				if(!get_expr(pi, operand1, &i))
					return(False);
				if((i < 0) || (i > 31))
					print_msg(pi, MSGTYPE_ERROR, "I/O out of range (0 <= P <= 31)");
				opcode = i << 3;
				if(!get_bitnum(pi, operand2, &i))
					return(False);
				opcode |= i;
				}
			else if(mnemonic == MNEMONIC_LDS)
				{
				i = get_register(pi, operand1);
				opcode = i << 4;
				if(!get_expr(pi, operand2, &i))
					return(False);
				if((i < 0) || (i > 65535))
					print_msg(pi, MSGTYPE_ERROR, "SRAM out of range (0 <= k <= 65535)");
				opcode2 = i;
				instruction_long = True;
				}
			else if(mnemonic == MNEMONIC_STS)
				{
				if(!get_expr(pi, operand1, &i))
					return(False);
				if((i < 0) || (i > 65535))
					print_msg(pi, MSGTYPE_ERROR, "SRAM out of range (0 <= k <= 65535)");
				opcode2 = i;
				i = get_register(pi, operand2);
				opcode = i << 4;
				instruction_long = True;
				}
			else if(mnemonic == MNEMONIC_LD)
				{
				i = get_register(pi, operand1);
				opcode = i << 4;
				mnemonic = MNEMONIC_LD_X + get_indirect(pi, operand2);
				}
			else if(mnemonic == MNEMONIC_ST)
				{
				mnemonic = MNEMONIC_ST_X + get_indirect(pi, operand1);
				i = get_register(pi, operand2);
				opcode = i << 4;
				}
			else if(mnemonic == MNEMONIC_LDD)
				{
				i = get_register(pi, operand1);
				opcode = i << 4;
				if(tolower(operand2[0]) == 'z')
					mnemonic = MNEMONIC_LDD_Z;
				else if(tolower(operand2[0]) == 'y')
					mnemonic = MNEMONIC_LDD_Y;
				else
					print_msg(pi, MSGTYPE_ERROR, "Garbage in second operand (%s)", operand2);
				i = 1;
				while((operand2[i] != '\0') && (operand2[i] != '+')) i++;
				if(operand2[i] == '\0')
					{
					print_msg(pi, MSGTYPE_ERROR, "Garbage in second operand (%s)", operand2);
					return(False);
					}
				if(!get_expr(pi, &operand2[i + 1], &i))
					return(False);
				if((i < 0) || (i > 63))
					print_msg(pi, MSGTYPE_ERROR, "Displacement out of range (0 <= q <= 63)");
				opcode |= ((i & 0x20) << 8) | ((i & 0x18) << 7) | (i & 0x07);
				}
			else if(mnemonic == MNEMONIC_STD)
				{
				if(tolower(operand1[0]) == 'z')
					mnemonic = MNEMONIC_STD_Z;
				else if(tolower(operand1[0]) == 'y')
					mnemonic = MNEMONIC_STD_Y;
				else
					print_msg(pi, MSGTYPE_ERROR, "Garbage in first operand (%s)", operand1);
				i = 1;
				while((operand1[i] != '\0') && (operand1[i] != '+')) i++;
				if(operand1[i] == '\0')
					{
					print_msg(pi, MSGTYPE_ERROR, "Garbage in first operand (%s)", operand1);
					return(False);
					}
				if(!get_expr(pi, &operand1[i + 1], &i))
					return(False);
				if((i < 0) || (i > 63))
					print_msg(pi, MSGTYPE_ERROR, "Displacement out of range (0 <= q <= 63)");
				opcode = ((i & 0x20) << 8) | ((i & 0x18) << 7) | (i & 0x07);
				i = get_register(pi, operand2);
				opcode |= i << 4;
				}
			else
				print_msg(pi, MSGTYPE_ERROR, "Shit! Missing opcode check [%d]...", mnemonic);
			}
		opcode |= instruction_list[mnemonic].opcode;
		if(pi->list_on && pi->list_line)
			{
			if(instruction_long)
				fprintf(pi->list_file, "%06x %04x %04x %s", pi->cseg_addr, opcode, opcode2, pi->list_line);
			else
				fprintf(pi->list_file, "%06x %04x      %s", pi->cseg_addr, opcode, pi->list_line);
			pi->list_line = NULL;
			}
		if(pi->hfi)
			{
			write_prog_word(pi, pi->cseg_addr, opcode);
			if(instruction_long)
				write_prog_word(pi, pi->cseg_addr + 1, opcode2);
			}
		if(instruction_long)
			pi->cseg_addr += 2;
		else
			pi->cseg_addr++;
		}
	else
		{
		if((mnemonic == MNEMONIC_JMP) || (mnemonic == MNEMONIC_CALL) || (mnemonic == MNEMONIC_LDS) || (mnemonic == MNEMONIC_STS))
			{
			pi->cseg_addr += 2;
			pi->cseg_count += 2;
			}
		else
			{
			pi->cseg_addr++;
			pi->cseg_count++;
			}
		}
	return(True);
	}


int get_mnemonic_type(char *mnemonic)
	{
	int i;

	for(i = 0; i < MNEMONIC_COUNT; i++)
		if(!strcmp(mnemonic, instruction_list[i].mnemonic))
			return(i);
	return(-1);
	}


int get_register(struct prog_info *pi, char *data)
	{
	int reg = 0;
	struct def *def;

	for(def = pi->first_def; def; def = def->next)
		if(!nocase_strcmp(def->name, data))
			{
			reg = def->reg;
			return(reg);
			}
	if((tolower(data[0]) == 'r') && isdigit(data[1]))
		{
		reg = atoi(&data[1]);
		if(reg > 31)
			print_msg(pi, MSGTYPE_ERROR, "R%d is not a valid register", reg);
		}
	else
		print_msg(pi, MSGTYPE_ERROR, "No register associated with %s", data);
	return(reg);
	}


int get_bitnum(struct prog_info *pi, char *data, int *ret)
	{
	if(!get_expr(pi, data, ret))
		return(False);
	if((*ret < 0) || (*ret > 7))
		{
		print_msg(pi, MSGTYPE_ERROR, "Operand out of range (0 <= s <= 7)");
		return(False);
		}
	return(True);
	}


int get_indirect(struct prog_info *pi, char *operand)
	{
	int i = 1;

	switch(tolower(operand[0]))
		{
		case '-':
			while(IS_HOR_SPACE(operand[i])) i++;
			if(operand[i + 1] != '\0')
				print_msg(pi, MSGTYPE_ERROR, "Garbage in operand (%s)", operand);
			switch(tolower(operand[i]))
				{
				case 'x':
					return(2);
				case 'y':
					return(5);
				case 'z':
					return(8);
				default:
					print_msg(pi, MSGTYPE_ERROR, "Garbage in operand (%s)", operand);
					return(0);
				}
		case 'x':
			while(IS_HOR_SPACE(operand[i])) i++;
			if(operand[i] == '+')
				{
				if(operand[i + 1] != '\0')
					print_msg(pi, MSGTYPE_ERROR, "Garbage in operand (%s)", operand);
				return(1);
				}
			else if(operand[i] == '\0')
				return(0);
			else
				print_msg(pi, MSGTYPE_ERROR, "Garbage after operand (%s)", operand);
			return(0);
		case 'y':
			while(IS_HOR_SPACE(operand[i])) i++;
			if(operand[i] == '+')
				{
				if(operand[i + 1] != '\0')
					print_msg(pi, MSGTYPE_ERROR, "Garbage in operand (%s)", operand);
				return(4);
				}
			else if(operand[i] == '\0')
				return(3);
			else
				print_msg(pi, MSGTYPE_ERROR, "Garbage after operand (%s)", operand);
			return(0);
		case 'z':
			while(IS_HOR_SPACE(operand[i])) i++;
			if(operand[i] == '+')
				{
				if(operand[i + 1] != '\0')
					print_msg(pi, MSGTYPE_ERROR, "Garbage in operand (%s)", operand);
				return(7);
				}
			else if(operand[i] == '\0')
				return(6);
			else
				print_msg(pi, MSGTYPE_ERROR, "Garbage after operand (%s)", operand);
			return(0);
		default:
			print_msg(pi, MSGTYPE_ERROR, "Garbage in operand (%s)", operand);
		}
	return(0);
	}
