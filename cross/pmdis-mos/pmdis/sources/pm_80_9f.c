//
//
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "pm.h"


int decode_80_9f( struct tlcs900d *dd ) {
	unsigned char *b = dd->buffer + dd->pos;
	char buf1[8], buf2[8];
	unsigned char c;
	int ra = getra(b);
	int len = 0;
	enum opcodes op = INVALID;
	int base;


	c = b[len++];

	// 
	// incb rb               |  80+rb             |  rb <- rb + 1                |
	// incb [NN+ofs8]        |  85:ofs8           | ar <- HL[23:16]<<16+NN+ofs8  |
	//                   |                    | mem8[ar] <- mem8[ar] + 1     |
	// decb rb               |  88+rb             |  rb <- rb - 1                |
	// decb [NN+ofs8]        |  8D:ofs8           | ar <- HL[23:16]<<16+NN+ofs8  |
	//                   |                    | mem8[ar] <- mem8[ar] - 1     |
	// incw rw               |  90+rw             |  rw <- rw + 1                |
	// testb A,B             |  94                |  temp <- A and B             |
	//                   |                    | update flags but don't store |
	// testb [HL],imm8       |  95:imm8           |  temp <- mem8[HL] and imm8   |
    //                   |                    | update flags but don't store |
	// testb A,imm8          |  96:imm8           |  temp <- A and imm8          |
    //                       |                    | update flags but don't store |
	// testb B,imm8          |  97:imm8           |  temp <- B and imm8          |
    //                       |                    | update flags but don't store |
	// decw rw               |  98+rw             |  rw <- rw - 1                |
	// andb FLAGS,imm8       |  9C:imm8           |  FLAGS <- FLAGS and imm8     |
	// orb FLAGS,imm8        |  9D:imm8           |  FLAGS <- FLAGS or imm8      |
	// xorb FLAGS,imm8       |  9E:imm8           |  FLAGS <- FLAGS xor imm8     |
	// movb FLAGS,imm8       |  9F:imm8           |  FLAGS <- imm8               |
	//


	switch (c) {
	case 0x80: case 0x81: case 0x82: case 0x83:		// INC ra
		op = INC;
		dd->opt = OPT_1_0_0;
		len += retr8(b,dd->ops,ra);
		break;
	case 0x85:										// INC (NN+offs8)
		op = INC;
		dd->opt = OPT_1_1_0;
		len += retr8(b,dd->ops,ra);
		break;
	case 0x88: case 0x89: case 0x8a: case 0x8b:			// DEC ra
		op = DEC;
		dd->opt = OPT_1_0_0;
		len += retr8(b,dd->ops,ra);	
		break;
	case 0x8D:										// DEC (NN+offs8)
		op = DEC;
		dd->opt = OPT_1_1_0;
		len += retr8(b,dd->ops,ra);
		break;
	case 0x90: case 0x91: case 0x92: case 0x93:		// INCW rw
		op = INCW;
		dd->opt = OPT_1_0_0;
		len += retr16(b,dd->ops,ra);
		break;
	case 0x94:										// TEST A,B
		op = TEST;
		dd->opt = OPT_1_0_0;
		sprintf(dd->ops,"A,B");
		break;
	case 0x95:										// TEST (HL),imm8
		op = TEST;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"(HL),%02XH",b[len++]);
		break;
	case 0x96:										// TEST A,imm8
		op = TEST;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"A,%02XH",b[len++]);
		break;
	case 0x97:										// TEST B,imm8
		op = TEST;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"B,%02XH",b[len++]);
		break;
	case 0x98: case 0x99: case 0x9a: case 0x9b:			// DECW rw
		op = DECW;
		dd->opt = OPT_1_0_0;
		len += retr16(b,dd->ops,ra);
		break;
	case 0x9c:										// AND F,imm8
		op = AND;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"F,%02XH",b[len++]);
		break;
	case 0x9d:										// OR F,imm8
		op = OR;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"F,%02XH",b[len++]);
		break;
	case 0x9e:										// XOR F,imm8
		op = XOR;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"F,%02XH",b[len++]);
		break;
	case 0x9f:										// LD F,imm8
		op = LD;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"F,%02XH",b[len++]);
		break;
	defaut:
		return 0;
	}


	//

	dd->opf = opcode_names[op];
	return len;
}

