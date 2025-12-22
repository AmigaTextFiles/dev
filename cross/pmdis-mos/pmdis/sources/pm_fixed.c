/*
 *
 *
 *
 */

#include <stdio.h>
#include <string.h>
#include "pm.h"

/*
 *
 *
 *
 */

int decode_fixed( struct tlcs900d *dd ) {
	unsigned char *b = dd->buffer + dd->pos;
	unsigned char c;
 	int len = 0;
	enum opcodes op;
	int d;

	*dd->ops = '\0';
	dd->opt = OPT_1_0_0;
	op = INVALID;
	c = b[len++];

	switch (*b) {
	case 0x00:			// ADD A,A
		op = ADD;
		sprintf(dd->ops,"A,A");
		break;
	case 0x01:			// ADD A,B
		op = ADD;
		sprintf(dd->ops,"A,B");
		break;
	case 0x03:			// ADD A,(HL)
		op = ADD;
		sprintf(dd->ops,"A,(HL)");
		break;
	case 0x06:			// ADD A,(IX)
		op = ADD;
		sprintf(dd->ops,"A,(IX)");
		break;
	case 0x07:			// ADD A,(IY)
		op = ADD;
		sprintf(dd->ops,"A,(IY)");
		break;

	case 0x08:			// ADC A,A
		op = ADC;
		sprintf(dd->ops,"A,A");
		break;
	case 0x09:			// ADC A,B
		op = ADC;
		sprintf(dd->ops,"A,B");
		break;
	case 0x0b:			// ADC A,(HL)
		op = ADC;
		sprintf(dd->ops,"A,(HL)");
		break;
	case 0x0e:			// ADC A,(IX)
		op = ADC;
		sprintf(dd->ops,"A,(IX)");
		break;
	case 0x0f:			// ADC A,(IY)
		op = ADC;
		sprintf(dd->ops,"A,(IY)");
		break;

	case 0x10:			// SUB A,A
		op = SUB;
		sprintf(dd->ops,"A,A");
		break;
	case 0x11:			// SUB A,B
		op = SUB;
		sprintf(dd->ops,"A,B");
		break;
	case 0x13:			// SUB A,(HL)
		op = SUB;
		sprintf(dd->ops,"A,(HL)");
		break;
	case 0x16:			// SUB A,(IX)
		op = SUB;
		sprintf(dd->ops,"A,(IX)");
		break;
	case 0x17:			// SUB A,(IY)
		op = SUB;
		sprintf(dd->ops,"A,(IY)");
		break;

	case 0x18:			// SBC A,A
		op = SBC;
		sprintf(dd->ops,"A,A");
		break;
	case 0x19:			// SBC A,B
		op = SBC;
		sprintf(dd->ops,"A,B");
		break;
	case 0x1b:			// SBC A,(HL)
		op = SBC;
		sprintf(dd->ops,"A,(HL)");
		break;
	case 0x1e:			// SBC A,(IX)
		op = SBC;
		sprintf(dd->ops,"A,(IX)");
		break;
	case 0x1f:			// SBC A,(IY)
		op = SBC;
		sprintf(dd->ops,"A,(IY)");
		break;




	case 0x20:	// AND A,A
		op = AND;
		sprintf(dd->ops,"A,A");
		break;
	case 0x21:	// AND A,B
		op = AND;
		sprintf(dd->ops,"A,B");
		break;
	case 0x23:	// AND A,(HL)
		op = AND;
		sprintf(dd->ops,"A,(HL)");
		break;
	case 0x26:	// AND A,(IX)
		op = AND;
		sprintf(dd->ops,"A,(IX)");
		break;
	case 0x27:	// AND A,(IY)
		op = AND;
		sprintf(dd->ops,"A,(IX)");
		break;

	case 0x28:	// OR A,A
		op = OR;
		sprintf(dd->ops,"A,A");
		break;
	case 0x29:	// OR A,B
		op = OR;
		sprintf(dd->ops,"A,B");
		break; 
	case 0x2B:	// OR A,(HL)
		op = OR;
		sprintf(dd->ops,"A,(HL)");
		break; 
	case 0x2E:	// OR A,(IX)
		op = OR;
		sprintf(dd->ops,"A,(IX)");
		break; 
	case 0x2F:	// OR A,(IY)
		op = OR;
		sprintf(dd->ops,"A,(IY)");
		break; 

	case 0x30:	// CMP A,A
		op = CMP;
		sprintf(dd->ops,"A,A");
		break; 
	case 0x33:	// CMP A,B
		op = CMP;
		sprintf(dd->ops,"A,B");
		break; 
	case 0x36:	// CMP A,(IX)
		op = CMP;
		sprintf(dd->ops,"A,(IX)");
		break; 
	case 0x37:	// CMP A,(IY)
		op = CMP;
		sprintf(dd->ops,"A,(IY)");
		break; 

	case 0x38:	// XOR A,A
		op = XOR;
		sprintf(dd->ops,"A,A");
		break; 
	case 0x39:	// XOR A,B
		op = XOR;
		sprintf(dd->ops,"A,B");
		break; 
	case 0x3B:	// XOR A,(HL)
		op = XOR;
		sprintf(dd->ops,"A,(HL)");
		break; 
	case 0x3E:	// XOR A,(IX)
		op = XOR;
		sprintf(dd->ops,"A,(IX)");
		break; 
	case 0x3F:	// XOR A,(IY)
		op = XOR;
		sprintf(dd->ops,"A,(IY)");
		break; 


	case 0x65:	// LD (IX),(HL)
		op = LD;
		sprintf(dd->ops,"(IX),(HL)");
		break;
	case 0x66:	// LD (IX),(IX)
		op = LD;
		sprintf(dd->ops,"(IX),(IX)");
		break;
	case 0x67:	// LD (IX),(IY)
		op = LD;
		sprintf(dd->ops,"(IX),(IY)");
		break;
	case 0x6D:	// LD (HL),(HL)
		op = LD;
		sprintf(dd->ops,"(HL),(HL)");
		break;
	case 0x6E:	// LD (HL),(IX)
		op = LD;
		sprintf(dd->ops,"(HL),(IX)");
		break;
	case 0x6F:	// LD (HL),(IY)
		op = LD;
		sprintf(dd->ops,"(HL),(IY)");
		break;
	case 0x75:	// LD (IY),(HL)
		op = LD;
		sprintf(dd->ops,"(IY),(HL)");
		break;
	case 0x76:	// LD (IY),(IX)
		op = LD;
		sprintf(dd->ops,"(IY),(IX)");
		break;
	case 0x77:	// LD (IY),(IY)
		op = LD;
		sprintf(dd->ops,"(IY),(IY)");
		break;

	case 0x84:	// INCW NN
		op = INCW;
		sprintf(dd->ops,"NN");
		break;
	case 0x86:	// INC (HL)
		op = INC;
		sprintf(dd->ops,"(HL)");
		break;
	case 0x87:	// INCW SP
		op = INCW;
		sprintf(dd->ops,"SP");
		break;
	case 0x8C:	// DECW NN
		op = DECW;
		sprintf(dd->ops,"NN");
		break;
	case 0x8e:	// DEC (HL)
		op = DEC;
		sprintf(dd->ops,"(HL)");
		break;
	case 0x8F:	// DECW SP
		op = DECW;
		sprintf(dd->ops,"SP");
		break;


	case 0xA4: // PUSHX N
		op = PUSHX;
		sprintf(dd->ops,"N");
		break;
	case 0xA5: // PUSHX HL
		op = PUSHX;
		sprintf(dd->ops,"HL");
		break;
	case 0xA6: // PUSHXXX
		op = PUSHXXX;
		break;
	case 0xA7: // PUSH F
		op = PUSH;
		sprintf(dd->ops,"F");
		break;
	case 0xAC: // POPX N
		op = POPX;
		sprintf(dd->ops,"N");
		break;
	case 0xAD: // POPX HL
		op = POPX;
		sprintf(dd->ops,"HL");
		break;
	case 0xAE: // POPXXX
		op = POPXXX;
		break;
	case 0xAF: // POP F
		op = POP;
		sprintf(dd->ops,"F");
		break;

	case 0xC8: // EX XBA,HL
		op = EX;
		sprintf(dd->ops,"XBA,HL");
		break;
	case 0xC9: // EX XBA,IX
		op = EX;
		sprintf(dd->ops,"XBA,IX");
		break;
	case 0xCA: // EX XBA,IY
		op = EX;
		sprintf(dd->ops,"XBA,IY");
		break;
	case 0xCB: // EX XBA,XSP
		op = EX;
		sprintf(dd->ops,"XBA,SP");
		break;
	case 0xCC: // EX A,b
		op = EX;
		sprintf(dd->ops,"A,B");
		break;
	case 0xCD: // EX A,b
		op = EX;
		sprintf(dd->ops,"A,(HL)");
		break;
	case 0xDE: // BCDE
		op = BCDE;
		break;
	case 0xDF: // BCDD
		op = BCDD;
		break;
	case 0xF4: // JP (HL)
		op = JP;
		sprintf(dd->ops,"(HL)");
		break;
	case 0xF6: // BCDX
		op = BCDX;
		sprintf(dd->ops,"A");
		break;
	case 0xF7: // BCDX
		op = BCDX;
		sprintf(dd->ops,"(HL)");
		break;
	case 0xF8: // RET
		op = RET;
		break;
	case 0xF9: // RETI
		op = RETI;
		break;
	case 0xFF: // NOP
		op = NOP;
		break;
	default:
		op = INVALID;
		return 0;
	}

  dd->opf = opcode_names[op];
  return len;

}
