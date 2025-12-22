//
//
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "pm.h"


int decode_ce_cf( struct tlcs900d *dd ) {
	unsigned char *b = dd->buffer + dd->pos;
	char buf1[8], buf2[8];
	unsigned char c;
	int ra;
	int len = 0;
	enum opcodes op = INVALID;
	int base;

	// 
	// movb A, N             |  CE:C0             |  A <- NN[15:8]               |
	// movb A, FLAGS         |  CE:C1             |  A <- FLAGS                  |
	// movb N, A             |  CE:C2             |  NN[15:8] <- A               |
	// movb FLAGS, A         |  CE:C3             |  FLAGS <- A                  |
	// movx HL,imm8          |  CE:C5:imm8        |  HL[23:16] <- imm8           |
	// movx X1,imm8          |  CE:C6:imm8        |  X1[23:16] <- imm8           |
	// movx X2,imm8          |  CE:C7:imm8        |  X2[23:16] <- imm8           |
	// movx A,HL             |  CE:C9             |  A <- HL[23:16]              |
	// movx A,X1             |  CE:CA             |  A <- X1[23:16]              |
	// movx A,X2             |  CE:CB             |  A <- X2[23:16]              |
	// movx HL,A             |  CE:CD             |  HL[23:16] <- A              |
	// movx X1,A             |  CE:CE             |  X1[23:16] <- A              |
	// movx X2,A             |  CE:CF             |  X2[23:16] <- A              |
	//
	// movw SP,imm16         |  CF:6E:im16L:im16H |  SP <- imm16                 |
	// addw HL,rw            |  CF:20+rw          |  HL <- HL + rw               |
	// subw HL,rw            |  CF:28+rw          |  HL <- HL - rw               |
	// movw rw1,rw2          |  CF:E0+rw1<<2+rw2  |  rw1 <- rw2                  |	// 
	//

	dd->opt = OPT_2_0_0;
	c = b[len++];
	ra = getra(b+len);

	if (c == 0xce) {
		c = b[len++];

		switch (c) {
		case 0x24:					// AND (HL),A
			op = AND;
			sprintf(dd->ops,"(HL),A");
			break;
		case 0x25:					// AND (HL),imm8
			op = AND;
			sprintf(dd->ops,"(hl),%02XH",b[len++]);
			dd->opt = OPT_2_1_0;
			break;
		case 0x26:					// AND (HL),(IX)
			op = AND;
			sprintf(dd->ops,"(HL),(IX)");
			break;
		case 0x27:					// AND (HL),(IY)
			op = AND;
			sprintf(dd->ops,"(HL),(IY)");
			break;
		case 0x2c:					// OR (HL),A
			op = OR;
			sprintf(dd->ops,"(HL),A");
			break;
		case 0x2d:					// OR (HL),imm8
			op = OR;
			sprintf(dd->ops,"(hl),%02XH",b[len++]);
			dd->opt = OPT_2_1_0;
			break;
		case 0x2e:					// OR (HL),(IX)
			op = OR;
			sprintf(dd->ops,"(HL),(IX)");
			break;
		case 0x2f:					// OR (HL),(IY)
			op = OR;
			sprintf(dd->ops,"(HL),(IY)");
			break;


		case 0x40:					// LD A,(IX+off8)
			op = LD;
			sprintf(dd->ops,"A,(IX+%02XH)",((char*)b)[len++]);
			dd->opt = OPT_2_1_0;
			break;
		case 0x41:					// LD A,(IY+off8)
			op = LD;
			sprintf(dd->ops,"A,(IY+%02XH)",((char*)b)[len++]);
			dd->opt = OPT_2_1_0;
			break;
		case 0x42:					// LD A,(IX+L)
			op = LD;
			sprintf(dd->ops,"A,(IX+L)");
			break;
		case 0x43:					// LD A,(IY+L)
			op = LD;
			sprintf(dd->ops,"A,(IY+L)");
			break;
		case 0x44:					// LD (IX+off8),A
			op = LD;
			sprintf(dd->ops,"(IX+%02XH),A",((char*)b)[len++]);
			dd->opt = OPT_2_1_0;
			break;
		case 0x45:					// LD (IY+off8),A
			op = LD;
			sprintf(dd->ops,"(IY+%02XH),A",((char*)b)[len++]);
			dd->opt = OPT_2_1_0;
			break;
		case 0x46:					// LD (IX+L),A
			op = LD;
			sprintf(dd->ops,"(IX+L),A");
			break;
		case 0x47:					// LD (IY+L),A
			op = LD;
			sprintf(dd->ops,"(IY+L),A");
			break;

		case 0x48:					// LD B,(IX+off8)
			op = LD;
			sprintf(dd->ops,"B,(IX+%02XH)",((char*)b)[len++]);
			dd->opt = OPT_2_1_0;
			break;
		case 0x49:					// LD B,(IY+off8)
			op = LD;
			sprintf(dd->ops,"B,(IY+%02XH)",((char*)b)[len++]);
			dd->opt = OPT_2_1_0;
			break;
		case 0x4a:					// LD B,(IX+L)
			op = LD;
			sprintf(dd->ops,"B,(IX+L)");
			break;
		case 0x4b:					// LD B,(IY+L)
			op = LD;
			sprintf(dd->ops,"B,(IY+L)");
			break;
		case 0x4c:					// LD (IX+off8),B
			op = LD;
			sprintf(dd->ops,"(IX+%02XH),B",((char*)b)[len++]);
			dd->opt = OPT_2_1_0;
			break;
		case 0x4d:					// LD (IY+off8),B
			op = LD;
			sprintf(dd->ops,"(IY+%02XH),B",((char*)b)[len++]);
			dd->opt = OPT_2_1_0;
			break;
		case 0x4e:					// LD (IX+L),B
			op = LD;
			sprintf(dd->ops,"(IX+L),B");
			break;
		case 0x4f:					// LD (IY+L),B
			op = LD;
			sprintf(dd->ops,"(IY+L),B");
			break;



		case 0x84:					// SHL A
			op = SHL;
			sprintf(dd->ops,"A");
			break;
		case 0x85:					// SHL B
			op = SHL;
			sprintf(dd->ops,"B");
			break;
		case 0x88:					// ROR A
			op = ROR;
			sprintf(dd->ops,"A");
			break;
		case 0x89:					// ROR B
			op = ROR;
			sprintf(dd->ops,"B");
			break;
		case 0x8c:					// SHR A
			op = SHR;
			sprintf(dd->ops,"A");
			break;
		case 0x8d:					// SHR B
			op = SHR;
			sprintf(dd->ops,"B");
			break;

		case 0xa0:					// NOT A
			op = NOT;
			sprintf(dd->ops,"A");
			break;
		case 0xa1:					// NOT B
			op = NOT;
			sprintf(dd->ops,"B");
			break;
		case 0xa2:					// NOT (NN+offs8)
			op = NOT;
			dd->opt = OPT_2_1_0;
			sprintf(dd->ops,"(NN+%02X)",b[len++]);
			break;
		case 0xa3:					// NOT (HL)
			op = NOT;
			sprintf(dd->ops,"(HL)");
			break;


		case 0xb0:					// AND (HL),A
			op = AND;
			sprintf(dd->ops,"B,%02XH");
			dd->opt = OPT_2_1_0;
			break;
		case 0xb1:					// AND (HL),A
			op = AND;
			sprintf(dd->ops,"L,%02XH");
			dd->opt = OPT_2_1_0;
			break;
		case 0xb2:					// AND (HL),A
			op = AND;
			sprintf(dd->ops,"H,%02XH");
			dd->opt = OPT_2_1_0;
			break;

		case 0xb4:					// OR (HL),A
			op = OR;
			sprintf(dd->ops,"B,%02XH");
			dd->opt = OPT_2_1_0;
			break;
		case 0xb5:					// OR (HL),A
			op = OR;
			sprintf(dd->ops,"");
			sprintf(dd->ops,"L,%02XH");
			dd->opt = OPT_2_1_0;
			break;
		case 0xb6:					// OR (HL),A
			op = OR;
			sprintf(dd->ops,"H,%02XH");
			dd->opt = OPT_2_1_0;
			break;

		case 0xb8:					// XOR (HL),A
			op = XOR;
			sprintf(dd->ops,"B,%02XH");
			dd->opt = OPT_2_1_0;
			break;
		case 0xb9:					// XOR (HL),A
			op = XOR;
			sprintf(dd->ops,"L,%02XH");
			dd->opt = OPT_2_1_0;
			break;
		case 0xba:					// XOR (HL),A
			op = XOR;
			sprintf(dd->ops,"H,%02XH");
			dd->opt = OPT_2_1_0;
			break;



		case 0xbc:					// CMP B,imm8
			op = CMP;
			dd->opt = OPT_2_1_0;
			sprintf(dd->ops,"B,%02XH",b[len++]);
			break;
		case 0xbd:					// CMP L,imm8
			op = CMP;
			dd->opt = OPT_2_1_0;
			sprintf(dd->ops,"L,%02XH",b[len++]);
			break;
		case 0xbe:					// CMP H,imm8
			op = CMP;
			dd->opt = OPT_2_1_0;
			sprintf(dd->ops,"H,%02XH",b[len++]);
			break;
		case 0xbf:					// CMP N,imm8
			op = CMP;
			dd->opt = OPT_2_1_0;
			sprintf(dd->ops,"N,%02XH",b[len++]);
			break;

		case 0xc0:
			op = LD;
			sprintf(dd->ops,"A,N");
			break;
		case 0xc1:
			op = LD;
			sprintf(dd->ops,"A,F");
			break;
		case 0xc2:
			sprintf(dd->ops,"N,A");
			break;
			op = LD;
		case 0xc3:
			op = LD;
			sprintf(dd->ops,"F,A");
			break;
		case 0xc4:		// FIX ME!!!
			op = LD;
			sprintf(dd->ops,"????,%02XH",b[len++]);
			break;

		case 0xc5:
			op = LDX;
			sprintf(dd->ops,"HL,%02XH",b[len++]);
			dd->opt = OPT_2_1_0;
			break;
		case 0xc6:
			op = LDX;
			sprintf(dd->ops,"IX,%02XH",b[len++]);
			dd->opt = OPT_2_1_0;
			break;
		case 0xc7:
			op = LDX;
			sprintf(dd->ops,"IY,%02XH",b[len++]);
			dd->opt = OPT_2_1_0;
			break;
		case 0xc9:
			op = LDX;
			sprintf(dd->ops,"A,HL");
			break;
		case 0xca:
			op = LDX;
			sprintf(dd->ops,"A,IX");
			break;
		case 0xcb:
			op = LDX;
			sprintf(dd->ops,"A,IY");
			break;
		case 0xcd:
			op = LDX;
			sprintf(dd->ops,"HL,A");
			break;
		case 0xce:
			op = LDX;
			sprintf(dd->ops,"IX,A");
			break;
		case 0xcf:
			op = LDX;
			sprintf(dd->ops,"IY,A");
			break;

		case 0xd0:					// LD rb,(offs16)
		case 0xd1: case 0xd2: case 0xd3:
			op = LD;
			dd->opt = OPT_2_2_0;
			sprintf(dd->ops,"%s,(%04XH)",r8_24_names[ra & 3],get16u(b+2));
			len += 2;		
			break;
		case 0xd4:					// LD (offs16),rb
		case 0xd5: case 0xd6: case 0xd7:
			op = LD;
			dd->opt = OPT_2_2_0;
			sprintf(dd->ops,"(%04XH),%s",get16u(b+2),r8_24_names[ra & 3]);
			len += 2;		
			break;
		case 0xd8:				// MUL L,A
			op = MUL;
			sprintf(dd->ops,"L,A");
			break;
		case 0xd9:				// DIV HL,A
			op = DIV;
			sprintf(dd->ops,"HL,A");
			break;

		default:
			return 0;
		}

	} else {	// c == 0xcf
		c = b[len++];
		switch (c) {
		case 0x68:				// ADDW sp,imm16
			op = ADDW;
			sprintf(dd->ops,"SP,%04XH",get16u(b+len));
			len += 2;
			dd->opt = OPT_2_2_0;
			break;
		case 0x6A:				// SUBW sp,imm16
			op = SUBW;
			sprintf(dd->ops,"SP,%04XH",get16u(b+len));
			len += 2;
			dd->opt = OPT_2_2_0;
			break;
		case 0x6C:				// CMPW sp,imm16
			op = CMPW;
			sprintf(dd->ops,"SP,%04XH",get16u(b+len));
			len += 2;
			dd->opt = OPT_2_2_0;
			break;


		case 0x40:				// ADDW IX,BA
			op = ADDW;
			sprintf(dd->ops,"IX,BA");
			break;
		case 0x41:				// ADDW IX,HL
			op = ADDW;
			sprintf(dd->ops,"IX,HL");
			break;
		case 0x42:				// ADDW IY,BA
			op = ADDW;
			sprintf(dd->ops,"IY,BA");
			break;
		case 0x43:				// ADDW IY,HL
			op = ADDW;
			sprintf(dd->ops,"IY,HL");
			break;
		case 0x44:				// ADDW SP,BA
			op = ADDW;
			sprintf(dd->ops,"SP,BA");
			break;
		case 0x45:				// ADDW SP,HL
			op = ADDW;
			sprintf(dd->ops,"SP,HL");
			break;
		case 0x48:				// SUBW IX,BA
			op = SUBW;
			sprintf(dd->ops,"IX,BA");
			break;
		case 0x49:				// SUBW IX,HL
			op = SUBW;
			sprintf(dd->ops,"IX,HL");
			break;
		case 0x4a:				// SUBW IY,BA
			op = SUBW;
			sprintf(dd->ops,"IY,BA");
			break;
		case 0x4b:				// SUBW IY,HL
			op = SUBW;
			sprintf(dd->ops,"IY,HL");
			break;
		case 0x4c:				// SUBW SP,BA
			op = SUBW;
			sprintf(dd->ops,"SP,BA");
			break;
		case 0x4d:				// SUBW SP,HL
			op = SUBW;
			sprintf(dd->ops,"SP,BA");
			break;
	

		case 0x6e:
			op = LDW;
			dd->opt = OPT_2_2_0;
			sprintf(dd->ops,"SP,%04XH",get16u(b+2));
			len += 2;
			break;
		case 0x20: case 0x21: case 0x22: case 0x23:
			op = ADDW;
			len += retr16(b+1,buf1,getra(b+1));
			sprintf(dd->ops,"HL,%s",buf1);
			break;
		case 0x28: case 0x29: case 0x2a: case 0x2b:		
			op = SUBW;
			len += retr16(b+1,buf1,getra(b+1));
			sprintf(dd->ops,"HL,%s",buf1);
			break;
		case 0xb0: case 0xb1: case 0xb2: case 0xb3:
			op = PUSH;
			sprintf(dd->ops,"%s",r8_24_names[ra & 3]);
			break;
		case 0xb4: case 0xb5: case 0xb6: case 0xb7:
			op = POP;
			sprintf(dd->ops,"%s",r8_24_names[ra & 3]);
			break;
		case 0xb8:
			op = PUSHA;
			break;
		case 0xb9:
			op = PUSHAX;
			break;
		case 0xbc:
			op = POPA;
			break;
		case 0xbd:
			op = POPAX;
			break;
		case 0xe0: case 0xe1: case 0xe2: case 0xe3:
		case 0xe4: case 0xe5: case 0xe6: case 0xe7:
		case 0xe8: case 0xe9: case 0xea: case 0xeb:
		case 0xec: case 0xed: case 0xee: case 0xef:
			op = LDW;
			sprintf(dd->ops,"%s,%s",r16_24_names[(c >> 2) & 3],r16_24_names[c & 3]);
			break;
		case 0xd0: case 0xd1: case 0xd2: case 0xd3:	// LDW rw,(IX)
			op = LDW;
			sprintf(dd->ops,"%s,(IX)",r16_24_names[c & 3]);
			break;
		case 0xd4: case 0xd5: case 0xd6: case 0xd7:	// LDW (IX),rw
			op = LDW;
			sprintf(dd->ops,"(IX),%s",r16_24_names[c & 3]);
			break;
		case 0xd8: case 0xd9: case 0xda: case 0xdb:	// LDW rw,(IY)
			op = LDW;
			sprintf(dd->ops,"%s,(IY)",r16_24_names[c & 3]);
			break;
		case 0xdc: case 0xdd: case 0xde: case 0xdf:	// LDW (IY),rw
			op = LDW;
			sprintf(dd->ops,"(IY),%s",r16_24_names[c & 3]);
			break;

		default:
			return 0;
		}
	}



	dd->opf = opcode_names[op];
	return len;
}

