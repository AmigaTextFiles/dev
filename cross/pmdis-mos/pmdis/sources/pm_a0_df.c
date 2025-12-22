//
//
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "pm.h"


int decode_a0_df( struct tlcs900d *dd ) {
	unsigned char *b = dd->buffer + dd->pos;
	char buf1[8], buf2[8];
	unsigned char c;
	int ra = getra(b);
	int rb = getra(b);
	int len = 0;
	enum opcodes op = INVALID;
	int base;

	// 
	// pushw rw              A0+rw             |  SP <- SP - 2                |
	//                                         |  mem8[SP] <- (rwLOW)         |
	//                                         |  mem8[SP+1] <- (rwHIGH)      |
	// popw rw               A8+rw             |  rwLOW <- mem[SP]            |
	//                                         |  rwHIGH <- mem[SP+1]         |
	//                                         |  SP <- SP + 2                |
	// movb rb,imm8          B0+rb:imm8        |  rb <- imm8                  |
	// movw NN,imm16         B4:imm16H         |  NN <- imm16 and 0xFF00      |
	// movw rw,imm16         C4+rw:imm16L:imm16H|  rw <- imm16                 |
	// andb [NN+ofs8],imm8   D8:ofs8:imm8      | ar <- HL[23:16]+NN+ofs8      | 
	//                                         | mem8[ar]<- mem8[ar] and imm8 |
	// orb [NN+ofs8],imm8    D9:ofs8:imm8      | ar <- HL[23:16]+NN+ofs8      | 
	//                                         | mem8[ar]<- mem8[ar] or imm8  |
	// movb [NN+ofs8],imm8   DD:ofs8:imm8      | ar <- HL[23:16]+NN+ofs8      | 
	//                                         | mem8[ar]<- imm8              |
	// 

	c = b[len++];

	switch (c) {
	case 0xa0: case 0xa1: case 0xa2: case 0xa3:	// PUSHW rw
		op = PUSHW;
		dd->opt = OPT_1_0_0;
		sprintf(dd->ops,r16_24_names[ra]);
		break;
	case 0xa8: case 0xa9: case 0xaa: case 0xab:	// POPW rw
		op = POPW;
		dd->opt = OPT_1_0_0;
		sprintf(dd->ops,r16_24_names[ra]);
		break;
	case 0xb0: case 0xB1: case 0xb2: case 0xb3:	// LD rb,imm8
		op = LD;
		sprintf(dd->ops,"%s,%02XH",r8_24_names[ra],b[len++]);
		dd->opt = OPT_1_1_0;
		break;
	case 0xb4:									// LDW NN,imm16
		op = LDW;
		sprintf(dd->ops,"NN,%04XH",get16u(b+len) & 0xff00);
		dd->opt = OPT_1_2_0;
		len += 2;
		break;
	case 0xb5: case 0xb6: case 0xb7:			// LD (rw),imm8
		op = LD;
		sprintf(dd->ops,"(%s),%02XH",r16_24_names[ra],b[len++]);
		dd->opt = OPT_1_1_0;
		break;
	case 0xb8: case 0x89: case 0xba: case 0xbb:	// LDW rw,(offs16)
		op = LDW;
		sprintf(dd->ops,"%s,(%04XH)",r16_24_names[ra],get16(b+len));
		dd->opt = OPT_1_2_0;
	case 0xbc: case 0x8d: case 0xbe: case 0xbf:	// LDW (offs16),rw
		op = LDW;
		sprintf(dd->ops,"(%04XH),%s",get16(b+len),r16_24_names[ra & 3]);
		dd->opt = OPT_1_2_0;
		break;
	case 0xc0: case 0xC1: case 0xC2: case 0xC3:	// ADDW rb,imm16
		op = ADDW;
		sprintf(dd->ops,"%s,%04XH",r16_24_names[ra],get16u(b+len));
		dd->opt = OPT_1_2_0;
		len += 2;
		break;

	case 0xc4: case 0xc5: case 0xc6: case 0xc7:	// LDW rw,imm16
		op = LDW;
		sprintf(dd->ops,"%s,%04XH",r16_24_names[ra],get16u(b+len));
		dd->opt = OPT_1_2_0;
		len += 2;
		break;
	case 0xd0: case 0xd1: case 0xd2: case 0xd3:	// SUBW rw,imm16
		op = SUBW;
		sprintf(dd->ops,"%s,%04XH",r16_24_names[ra],get16u(b+len));
		dd->opt = OPT_1_2_0;
		len += 2;
		break;
	case 0xd4: case 0xd5: case 0xd6: case 0xd7:	// CMPW rw,imm16
		op = CMPW;
		sprintf(dd->ops,"%s,%04XH",r16_24_names[ra],get16u(b+len));
		dd->opt = OPT_1_2_0;
		len += 2;
		break;
	case 0xd8:									// AND (NN+offs8),imm8
		op = AND;
		sprintf(dd->ops,"(NN+%02XH),%02XH",b[1],b[2]);
		len += 2;
		dd->opt = OPT_1_1_1;
		break;
	case 0xd9:									// OR (NN+offs8),imm8
		op = OR;
		sprintf(dd->ops,"(NN+%02XH),%02XH",b[1],b[2]);
		len += 2;
		dd->opt = OPT_1_1_1;
		break;
	case 0xda:									// XOR (NN+offs8),imm8
		op = XOR;
		sprintf(dd->ops,"(NN+%02XH),%02XH",b[1],b[2]);
		len += 2;
		dd->opt = OPT_1_1_1;
		break;
	case 0xdc:									// TEST (NN+offs8),imm8
		op = TEST;
		sprintf(dd->ops,"(NN+%02XH),%02XH",b[1],b[2]);
		len += 2;
		dd->opt = OPT_1_1_1;
		break;
	case 0xdd:									// LD (NN+offs8),imm8
		op = LD;
		sprintf(dd->ops,"(NN+%02XH),%02XH",b[1],b[2]);
		len += 2;
		dd->opt = OPT_1_1_1;
		break;
	default: 
		return 0;
	}


	dd->opf = opcode_names[op];
	return len;
}

