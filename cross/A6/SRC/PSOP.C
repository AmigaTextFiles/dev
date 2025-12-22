/* ------------------------------------------------------------------
    PSOP.C -- opcode tables and parser for A6 cross assembler
     This is free software, please see the file
     "COPYING" for copyright and licence details
   ------------------------------------------------------------------ */

#include "error.h"
#include "global.h"
#include "outf.h"
#include "psexpr.h"
#include "psop.h"
#include "pspop.h"
#include "treefind.h"
#include "ustring.h"

/*-----------------------------------------------------------------*/
/* OPCODES                                                         */
/*-----------------------------------------------------------------*/

#define OPCODECOUNT (79)

char *opcodes[] = {
	"aax",	"adc",	"alr",	"amb",	"and",	"asl",	"aso",	"axh",
	"axs",	"bcc",	"bcs",	"beq",	"bit",	"bmi",	"bne",	"bpl",
/*16*/
	"brk",	"bvc",	"bvs",	"clc",	"cld",	"cli",	"clv",	"cmp",
	"cpx",	"cpy",	"cra",	"dcm",	"dec",	"dex",	"dey",	"eor",
/*32*/
	"hxm",	"hym",	"inc",	"ins",	"inx",	"iny",	"jmp",	"jsr",
	"las",	"lax",	"lda",	"ldx",	"ldy",	"lse",	"lsr",	"nop",
/*48*/
	"npo",	"oax",	"ora",	"pha",	"php",	"pla",	"plp",	"rla",
	"rol",	"ror",	"rra",	"rti",	"rts",	"sax",	"sbc",	"sec",
/*56*/
	"sed",	"sei",	"skb",	"skw",	"sta",	"stx",	"sty",	"sub",
	"tax",	"tay",	"tsx",	"txa",	"txs",	"tya",	"xma"
};

int isundocumented[] = {
	1,	0,	1,	1,	0,	0,	1,	1,
	1,	0,	0,	0,	0,	0,	0,	0,
/*16*/
	0,	0,	0,	0,	0,	0,	0,	0,
	0,	0,	1,	1,	0,	0,	0,	0,
/*32*/
	1,	1,	0,	1,	0,	0,	0,	0,
	1,	1,	0,	0,	0,	1,	0,	0,
/*48*/
	0,	0,	0,	0,	0,	0,	0,	1,
	0,	0,	1,	0,	0,	1,	0,	0,
/*56*/
	0,	0,	1,	1,	0,	0,	0,	1,
	0,	0,	0,	0,	0,	0,	1    
};

/* Addressing modes */
int adrmodes[] = {
     /* imp ,imm ,()  ,()_y,(_x),zp  ,abs ,zp_y,absy,zp_x,absx,rel */
/*AAX*/ (-1),(-1),(-1),(-1),0x83,0x87,0x8F,0x97,(-1),(-1),(-1),(-1),
/*ADC*/ (-1),0x69,(-1),0x71,0x61,0x65,0x6D,(-1),0x79,0x75,0x7D,(-1),
/*ALR*/ (-1),0x4B,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*AMB*/ (-1),0x0B,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*AND*/ (-1),0x29,(-1),0x31,0x21,0x25,0x2D,(-1),0x39,0x35,0x3D,(-1),
/*ASL*/ 0x0A,(-1),(-1),(-1),(-1),0x06,0x0E,(-1),(-1),0x16,0x1E,(-1),
/*ASO*/ (-1),(-1),(-1),0x13,0x03,0x07,0x0F,(-1),0x1B,0x17,0x1F,(-1),
/*AXH*/ (-1),(-1),(-1),0x93,(-1),(-1),(-1),(-1),0x9F,(-1),(-1),(-1),

/*AXS*/ (-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),0x9B,(-1),(-1),(-1),
/*BCC*/ (-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),0x90,
/*BCS*/ (-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),0xB0,
/*BEQ*/ (-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),0xF0,
/*BIT*/ (-1),(-1),(-1),(-1),(-1),0x24,0x2C,(-1),(-1),(-1),(-1),(-1),
/*BMI*/ (-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),0x30,
/*BNE*/ (-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),0xD0,
/*BPL*/ (-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),0x10,

/*BRK*/ 0x00,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*BVC*/ (-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),0x50,
/*BVS*/ (-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),0x70,
/*CLC*/ 0x18,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*CLD*/ 0xD8,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*CLI*/ 0x58,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*CLV*/ 0xB8,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*CMP*/ (-1),0xC9,(-1),0xD1,0xC1,0xC5,0xCD,(-1),0xD9,0xD5,0xDD,(-1),

/*CPX*/ (-1),0xE0,(-1),(-1),(-1),0xE4,0xEC,(-1),(-1),(-1),(-1),(-1),
/*CPY*/ (-1),0xC0,(-1),(-1),(-1),0xC4,0xCC,(-1),(-1),(-1),(-1),(-1),
/*CRA*/ 0x02,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*DCM*/ (-1),(-1),(-1),0xD3,0xC3,0xC7,0xCF,(-1),0xDB,0xD7,0xDF,(-1),
/*DEC*/ (-1),(-1),(-1),(-1),(-1),0xC6,0xCE,(-1),(-1),0xD6,0xDE,(-1),
/*DEX*/ 0xCA,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*DEY*/ 0x88,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*EOR*/ (-1),0x49,(-1),0x51,0x41,0x45,0x4D,(-1),0x59,0x55,0x5D,(-1),

/*HXM*/ (-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),0x9E,(-1),(-1),(-1),
/*HYM*/ (-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),0x9C,(-1),
/*INC*/ (-1),(-1),(-1),(-1),(-1),0xE6,0xEE,(-1),(-1),0xF6,0xFE,(-1),
/*INS*/ (-1),(-1),(-1),0xF3,0xE3,0xE7,0xEF,(-1),0xFB,0xF7,0xFF,(-1),
/*INX*/ 0xE8,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*INY*/ 0xC8,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*JMP*/ (-1),(-1),(-1),0x6C,(-1),(-1),0x4C,(-1),(-1),(-1),(-1),(-1),
/*JSR*/ (-1),(-1),(-1),(-1),(-1),(-1),0x20,(-1),(-1),(-1),(-1),(-1),

/*LAS*/ (-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),0xBB,(-1),(-1),(-1),
/*LAX*/ (-1),(-1),(-1),0xB3,0xA3,0xA7,0xAF,(-1),0xBF,0xB7,(-1),(-1),
/*LDA*/ (-1),0xA9,(-1),0xB1,0xA1,0xA5,0xAD,(-1),0xB9,0xB5,0xBD,(-1),
/*LDX*/ (-1),0xA2,(-1),(-1),(-1),0xA6,0xAE,0xB6,0xBE,(-1),(-1),(-1),
/*LDY*/ (-1),0xA0,(-1),(-1),(-1),0xA4,0xAC,(-1),(-1),0xB4,0xBC,(-1),
/*LSE*/ (-1),(-1),(-1),0x53,0x43,0x47,0x4F,(-1),0x5B,0x57,0x5F,(-1),
/*LSR*/ 0x4A,(-1),(-1),(-1),(-1),0x46,0x4E,(-1),(-1),0x56,0x5E,(-1),
/*NOP*/ 0xEA,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),

/*NPO*/ 0x1A,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*OAX*/ (-1),0xAB,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*ORA*/ (-1),0x09,(-1),0x11,0x01,0x05,0x0D,(-1),0x19,0x15,0x1D,(-1),
/*PHA*/ 0x48,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*PHP*/ 0x08,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*PLA*/ 0x68,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*PLP*/ 0x28,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*RLA*/ (-1),(-1),(-1),0x33,0x23,0x27,0x2F,(-1),0x3B,0x37,0x3F,(-1),

/*ROL*/ 0x2a,(-1),(-1),(-1),(-1),0x26,0x2E,(-1),(-1),0x36,0x3E,(-1),
/*ROR*/ 0x6A,(-1),(-1),(-1),(-1),0x66,0x6E,(-1),(-1),0x76,0x7E,(-1),
/*RRA*/ (-1),(-1),(-1),0x73,0x63,0x67,0x6F,(-1),0x7B,0x77,0x7F,(-1),
/*RTI*/ 0x40,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*RTS*/ 0x60,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*SAX*/ (-1),0xCB,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*SBC*/ (-1),0xE9,(-1),0xF1,0xE1,0xE5,0xED,(-1),0xF9,0xF5,0xFD,(-1),
/*SEC*/ 0x38,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),

/*SED*/ 0xF8,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*SEI*/ 0x78,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*SKB*/ (-1),(-1),(-1),(-1),(-1),0x04,(-1),(-1),(-1),(-1),(-1),(-1),
/*SKW*/ (-1),(-1),(-1),(-1),(-1),(-1),0x0C,(-1),(-1),(-1),(-1),(-1),
/*STA*/ (-1),(-1),(-1),0x91,0x81,0x85,0x8D,(-1),0x99,0x95,0x9D,(-1),
/*STX*/ (-1),(-1),(-1),(-1),(-1),0x86,0x8E,0x96,(-1),(-1),(-1),(-1),
/*STY*/ (-1),(-1),(-1),(-1),(-1),0x84,0x8C,(-1),(-1),0x94,(-1),(-1),
/*SUB*/ (-1),0xEB,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),

/*TAX*/ 0xAA,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*TAY*/ 0xA8,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*TSX*/ 0xBA,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*TXA*/ 0x8A,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*TXS*/ 0x9A,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*TYA*/ 0x98,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
/*XMA*/ (-1),0x8B,(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),(-1),
     /* imp ,imm ,()  ,()_y,(_x),zp  ,abs ,zp_y,absy,zp_x,absx,rel */
};

/*-----------------------------------------------------------------*/
/* Write results to output stream                                  */
/*-----------------------------------------------------------------*/
void writeout(int opbyte,int adrmode,unsigned int value) {
	int i;

#ifdef DEBUG
	printf("writeout: opbyte=%i, adrmode=%i, value=%u\n",opbyte,adrmode,value);
#endif

	outf_wbyte(opbyte);

	switch(adrmode) {
		case IMPLIED:
			break;

		case IMMEDIATE: case INDIRECT_X: case INDIRECT_Y:
		case ZEROPAGE_X: case ZEROPAGE_Y: case ZEROPAGE:
			if(value > 256)
				error("value of expression exceeds $00FF",ERR_PASS2);
			outf_wbyte(value);
			break;

		case ABSOLUTE: case ABSOLUTE_X: case ABSOLUTE_Y:
		case INDIRECT:
			if(value > 65535)
				error("value of expression exceeds $FFFF",ERR_PASS2);
			outf_wword(value);
			break;
       
		case RELATIVE:
			i=value - (outf_getpc() + 1);

#ifdef DEBUG
			printf("relative: i=%i\n",i);
#endif

			if((i > 0x7f) || (i < -0x80))
				error("branch out of range",ERR_PASS2);

			outf_wbyte(i & 0xFF);
			break;
	}
}

/*-----------------------------------------------------------------*/
/* Debugging print-out                                             */
/*-----------------------------------------------------------------*/
#ifdef DEBUG
void psop(char *msg,char *opcode,char *expr,int adrmode)
{
	char *s="???";
	switch(adrmode) {
		case IMPLIED: s="implied"; break;
		case IMMEDIATE: s="immediate"; break;
		case ZEROPAGE: s="zeropage"; break;
		case ZEROPAGE_X: s="zeropage,x"; break;
		case ZEROPAGE_Y: s="zeropage,y"; break;
		case RELATIVE: s="relative"; break;
		case INDIRECT: s="indirect"; break;
		case INDIRECT_X: s="indirect,x"; break;
		case INDIRECT_Y: s="indirect,y"; break;
		case ABSOLUTE: s="absolute"; break;
		case ABSOLUTE_X: s="absolute,x"; break;
		case ABSOLUTE_Y: s="absolute,y"; break;
	}
	printf(" >%s< [%s] opcode=%s adrmode=%i (%s)\n",expr,msg,opcode,adrmode,s);
}
#endif

/*-----------------------------------------------------------------*/
/* parseopcode                                                     */
/*-----------------------------------------------------------------*/
void parseopcode(char *opcode,char *expr)
{
	int adrmode=ABSOLUTE;
	char *e=(trim(expr));	/* Used to be newstring */
	int z=strlen(e)-1, opnum=-1;
	long value=0,opptr;

#ifdef DEBUG
	psop("entry",opcode,expr,adrmode);
#endif

	/* Find the opcode */
	opnum=treefind((char **)opcodes,opcode,OPCODECOUNT);

#ifdef DEBUG
	if(opnum!=-1)
		printf(">%s< opcode=%s (%i) adrmode=%i\n",e,opcodes[opnum],opnum,adrmode);
#endif

	if(opnum==-1) {
		if(g_dotflag) {
			parsepop(opcode,e);
			return;
		} else {
			errors("unknown opcode `%s'",opcode,ERR_PASS2);
		return;		/* No more processing after unknown opcode */
		}
	}

	/* Check for undocumented */
	if(!g_undocopsflag && isundocumented[opnum]) {
		error("undocumented opcodes are switched off",ERR_PASS2);
		return;
	}


#ifdef DEBUG
	psop("opcode found",opcode,e,adrmode);
#endif

	/* z always points to last valid char (not to \0) */
	if(e) {
		/* Find requested addressing mode */
		if(*e=='(') {
			e++; z--;

			/* Indirect or indirect,x */
			if(e[z]==')') {
				adrmode=INDIRECT;
				e[z--]=0;
				if(e[z]=='x' || e[z]=='X') {
					if(e[z-1]==',') {
						z--;
						e[z--]=0;
						adrmode=INDIRECT_X;
					}
				}
			}

#ifdef DEBUG
			psop("(ind,x)",opcode,e,adrmode);
#endif

			/* or indirect,y */
			if(e[z]=='y' || e[z]=='Y') {
				/* Not comma - could be end of a label */
				if(e[z-1]==',' || e[z-2]==')') {
					z-=3;
					e[z+1]=0;
					adrmode=INDIRECT_Y;
				}
			}
#ifdef DEBUG
		psop("(ind),y",opcode,e,adrmode);
#endif
		}

		/* Absolute,x */
		if(e[z]=='x' || e[z]=='X') {
			/* Not comma - could be end of a label */
			if(e[z-1]==',') {
				z--;
				e[z--]=0;
				adrmode=ABSOLUTE_X;
			}
		}

#ifdef DEBUG
		psop("abs,x",opcode,e,adrmode);
#endif

		/* Absolute,y */
		if(e[z]=='y' || e[z]=='Y') {
			/* Not comma - could be end of a label */
			if(e[z-1]==',') {
				z--;
				e[z--]=0;
				adrmode=ABSOLUTE_Y;
			}
		}

#ifdef DEBUG
		psop("abs,y",opcode,e,adrmode);
#endif

		/* Immediate */
		if(*e=='#') {
			e++;
			adrmode=IMMEDIATE;
		}

#ifdef DEBUG
		psop("#imm",opcode,e,adrmode);
#endif

		/* Accumulator */
		if(e[1]==0 && (e[0]=='a' || e[0]=='A')) {
			adrmode=IMPLIED; value=0; e[0]=0;
		}

		/* Parse what's left for a value */
		if(*e==0) {
			adrmode=IMPLIED; value=0;
		} else
			value=parseexpr(e);

#ifdef DEBUG
		psop("(implied)",opcode,e,adrmode);
#endif

		/* Check resulting address mode */
		if(value < 256) {
			switch(adrmode) {
				case ABSOLUTE_X:
					adrmode=ZEROPAGE_X; break;
				case ABSOLUTE_Y:
					adrmode=ZEROPAGE_Y; break;
				case ABSOLUTE:
					adrmode=ZEROPAGE; break;
			}
		}

#ifdef DEBUG
		psop("value < 256?",opcode,e,adrmode);
#endif

	} else /* No expression */
		adrmode=IMPLIED;

	/* Check addressing mode */
	opptr=opnum*12;

	value&=0xffff;

	/* First, check for small value */
	if(value < 256) {
		switch(adrmode) {
			case ABSOLUTE_X: adrmode=ZEROPAGE_X; break;
			case ABSOLUTE_Y: adrmode=ZEROPAGE_Y; break;
			case ABSOLUTE: adrmode=ZEROPAGE; break;
		}
	}

	/* Is this a relative-only instruction? */
	if(adrmodes[opptr+RELATIVE]!=-1) {
		writeout(adrmodes[opptr+RELATIVE],RELATIVE,value);
		return;
	}

#ifdef DEBUG
	psop("relative",opcode,e,adrmode);
#endif

	/* Success first try? */
	if(adrmodes[opptr+adrmode]!=-1) {
		writeout(adrmodes[opptr+adrmode],adrmode,value);
		return;
	}

#ifdef DEBUG
	psop("worked first time",opcode,e,adrmode);
#endif

	/* No?  Hmm... try extending data size */
	switch(adrmode) {
		case ZEROPAGE_X: adrmode=ABSOLUTE_X; break;
		case ZEROPAGE_Y: adrmode=ABSOLUTE_Y; break;
		case ZEROPAGE: adrmode=ABSOLUTE; break;
	}

#ifdef DEBUG
	psop("extend data size",opcode,e,adrmode);
#endif

	if(adrmodes[opptr+adrmode]!=-1) {
		writeout(adrmodes[opptr+adrmode],adrmode,value);
		return;
	}

#ifdef DEBUG
	psop("fail",opcode,e,adrmode);
#endif

	/* Okay - failed */
	error("invalid addressing mode",ERR_PASS2);
	return;
}
