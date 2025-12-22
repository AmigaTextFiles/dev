//
//
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "pm.h"


int decode_e0_ff( struct tlcs900d *dd ) {
	unsigned char *b = dd->buffer + dd->pos;
	char buf1[8], buf2[8];
	unsigned char c;
	int len = 0;
	enum opcodes op = INVALID;
	int base = dd->base + dd->pos;

	// 
	// jc disp8              |  E4:disp8          |  if CF = 1 then              |
	//                   |                    |       PC <- PC + disp8 - 1   |
	// jnc disp8             |  E5:disp8          |  if CF = 0 then              |
	//                   |                    |       PC <- PC + disp8 - 1   |
	// jz disp8              |  E6:disp8          |  if ZF = 1 then              |
	//                   |                    |       PC <- PC + disp8 - 1   |
	// jnz disp8             |  E7:disp8          |  if ZF = 0 then              |
	//                   |                    |       PC <- PC + disp8 - 1   |
	// jmp disp8             |  F1:disp8          |  PC <- PC + disp8 - 1        |
	// call disp16           |  F2:dispL:dispH    |  LR <- PC                    |
	//                   |                    |  PC <- PC + disp16 - 1       |
	// jmp disp16            |  F3:dispL:dispH    |  PC <- PC + disp16 - 1       |	// 

	c = b[len++];
	
	switch (c) {
	case 0xe4:
		op = JC;
		base += get8(b+1) + 1;
		dd->opt = OPT_1_1_0;
		len++;
		break;
	case 0xe5:
		op = JNC;
		base += get8(b+1) + 1;
		dd->opt = OPT_1_1_0;
		len++;
		break;
	case 0xe6:
		op = JZ;
		base += get8(b+1) + 1;
		dd->opt = OPT_1_1_0;
		len++;
		break;
	case 0xe7:
		op = JNZ;
		base += get8(b+1) + 1;
		dd->opt = OPT_1_1_0;
		len++;
		break;
	case 0xec:	// JC
		op = JC;
		base += get16(b+1) + 2;
		dd->opt = OPT_1_2_0;
		len += 2;
		break;
	case 0xed:	// JNC
		op = JNC;
		base += get16(b+1) + 2;
		dd->opt = OPT_1_2_0;
		len += 2;
		break;
	case 0xee:	// JZ
		op = JZ;
		base += get16(b+1) + 2;
		dd->opt = OPT_1_2_0;
		len += 2;
		break;
	case 0xef:	// JNZ
		op = JNZ;
		base += get16(b+1) + 2;
		dd->opt = OPT_1_2_0;
		len += 2;
		break;
	case 0xf0:	// CALR
		op = CALR;
		base += get8(b+1) + 1;
		dd->opt = OPT_1_1_0;
		len += 1;
		break;
	case 0xf5:	// DJNZ
		op = DJNZ;
		base += get8(b+1) + 1;
		dd->opt = OPT_1_1_0;
		len += 1;
		break;
	case 0xf1:
		op = JP;
		base += get8(b+1) + 1;
		dd->opt = OPT_1_1_0;
		len++;
		break;
	case 0xf2:
		op = CALR;
		base += get16(b+1) + 2;
		dd->opt = OPT_1_2_0;
		len += 2;
		break;
	case 0xf3:
		op = JP;
		base += get16(b+1) + 2;
		dd->opt = OPT_1_2_0;
		len += 2;
		break;
	case 0xfC:				// INT nn
		op = INT;
		dd->opt = OPT_1_1_0;
		sprintf(dd->ops,"%02XH",b[len++]);
		dd->opf = opcode_names[op];
		return len;
	case 0xfD:				// JINT
		op = JINT;
		sprintf(dd->ops,"%02XH",b[len++]);
		dd->opt = OPT_1_1_0;
		dd->opf = opcode_names[op];
		return len;
	case 0xff:				// NOP
		op = NOP;
		dd->opt = OPT_1_0_0;
		dd->opf = opcode_names[op];
		return len;
	default:
		return 0;
	}

	sprintf(dd->ops,"%08X",base);
	dd->opf = opcode_names[op];
	return len;
}

