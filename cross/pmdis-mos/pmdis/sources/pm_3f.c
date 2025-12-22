//
//
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "pm.h"


int decode_3f( struct tlcs900d *dd ) {
	unsigned char *b = dd->buffer + dd->pos;
	unsigned char c;
	int r = getra(b);
	int len = 0;
	enum opcodes op = INVALID;
	int base;

	//
	// andb A,[NN+ofs8]  24:ofs8           |  A <- A and                  |
	//                                     |    mem8[HL[23:16]+NN+ofs8]   |
	// andb A,[ofs16]    25:ofs16L:ofs16H  |  A <- A and                  |
	//                                     |  mem8[HL[23:16]<<16+ofs16] 
	// orb A,[NN+ofs8]   2C:ofs8           |  A <- A or                   |
	//                                     |    mem8[HL[23:16]+NN+ofs8]   |
	// cmpb A,imm8       32:imm8           |  temp <- A - imm8            |
	//                                     | update flags but don't store |
	// cmpb A,[NN+ofs8]  34:ofs8           |  temp <- A -                 |
	//                                     |  mem8[HL[23:16]<<16+NN+ofs8] |
	// cmpb A,[ofs16]    35:ofs16L:ofs16H  |  temp <- A -                 |
	//                                     |  mem8[HL[23:16]<<16+ofs16]   |
	// xorb A,[NN+ofs8]  3C:ofs8           |  A <- A xor                  |
	//                   |                    |    mem8[HL[23:16]+NN+ofs8]   |
	// xorb A,[ofs16]    3D:ofs16L:ofs16H  |  A <- A xor                  |
	//                |                    |  mem8[HL[23:16]<<16+ofs16]   |
	//

	c = b[len++];

	switch (c) {
	case 0x02:
		op = ADD;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"A,%02XH",b[len++]);
		break;
	case 0x04:
		op = ADD;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"A,(NN+%02XH)",b[len++]);
		break;
	case 0x05:
		op = ADD;
		dd->opt = OPT_1_2_0;
		sprintf(dd->ops,"A,(%04XH)",get16(b+len));
		len += 2;
		break;
	case 0x0a:
		op = ADC;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"A,%02XH",b[len++]);
		break;
	case 0x0c:
		op = ADC;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"A,(NN+%02XH)",b[len++]);
		break;
	case 0x0d:
		op = ADC;
		dd->opt = OPT_1_2_0;
		sprintf(dd->ops,"A,(%04XH)",get16(b+len));
		len += 2;
		break;
	case 0x12:
		op = SUB;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"A,%02XH",b[len++]);
		break;
	case 0x14:
		op = SUB;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"A,(NN+%02XH)",b[len++]);
		break;
	case 0x15:
		op = SUB;
		dd->opt = OPT_1_2_0;
		sprintf(dd->ops,"A,(%04XH)",get16u(b+len));
		len += 2;
		break;
	case 0x1a:
		op = SBC;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"A,%02XH",b[len++]);
		break;
	case 0x1c:
		op = SBC;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"A,(NN+%02XH)",b[len++]);
		break;
	case 0x1d:
		op = SBC;
		dd->opt = OPT_1_2_0;
		sprintf(dd->ops,"A,(%04XH)",get16(b+len));
		len += 2;
		break;



	case 0x22:	// AND A,imm8
		op = AND;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"A,%02XH",b[len++]);
		break;
	case 0x24:	// AND A,(NN+offs8)
		op = AND;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"A,(NN+%02XH)",b[len++]);
		break;
	case 0x25:	// AND A,(offs16)
		op = AND;
		dd->opt = OPT_1_2_0;
		sprintf(dd->ops,"A,(%04XH)",get16u(b+len));
		len++;
		break;
	case 0x2a:	// OR A,imm8
		op = OR;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"A,%02XH",b[len++]);
		break;
	case 0x2c:	// OR A,(NN+offs8)
		op = OR;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"A,(NN+%02XH)",b[len++]);
		break;
	case 0x2d:	// OR A,(offs16)
		op = OR;
		dd->opt = OPT_1_2_0;
		sprintf(dd->ops,"A,(%04XH)",get16(b+len));
		len++;
		break;
	case 0x32:	// CMP A,imm8
		op = CMP;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"A,%02XH",b[len++]);
		break;
	case 0x34:	// CMP A,(NN+offs8)
		op = CMP;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"A,(NN+%02XH)",b[len++]);
		break;
	case 0x35:	// CMP A,(offs16)
		op = CMP;
		dd->opt = OPT_1_2_0;
		sprintf(dd->ops,"A,(%04XH)",get16(b+len));
		len++;
		break;
	case 0x3a:	// XOR A,imm8
		op = XOR;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"A,%02XH",b[len++]);
		break;
	case 0x3c:	// XOR A,(NN+offs8)
		op = XOR;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"A,(NN+%02XH)",b[len++]);
		break;
	case 0x3d:	// XOR A,(offs16)
		op = XOR;
		dd->opt = OPT_1_2_0;
		sprintf(dd->ops,"A,(%04XH)",get16(b+len));
		len++;
		break;
	default:
		return 0;
	}


	dd->opf = opcode_names[op];
	return len;
}

