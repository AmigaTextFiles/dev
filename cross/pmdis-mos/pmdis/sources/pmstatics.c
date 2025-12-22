//
//
//

const char *opcode_names[] = {
	"LD",	"LD",	"LDX",	"PUSH",	"PUSHW","PUSHX","PUSHXXX","POP",	"POPW",	"POPX",	"POPXXX",
	"AND",	"OR",	"XOR",	"ADD",	"ADDW",	"SUB",	"SUBW",	"DECW",	"DEC",	"INCW",	"INC",
	"EX",	"NOP",	"CMP",	"CMPW",	"TEST",	"BCDE",	"BCDD",	"BCDX",	"SBC",	"ADC",	"NOT",
	"JC",	"JNC",	"JZ",	"JNZ",	"JP",	"CALR",	"JP",	"RET",	"RETI",	"DJNZ",
	"PUSHA","PUSHAX","POPA","POPAX","INT",	"JINT",	"MUL",	"DIV",	"SHL",	"ROR",	"SHR",
	"INVALID"
};

const char *r8_24_names[] = {
	"A","B","H","L",
	"BA","HL","IX","IY"
};

const char *r16_24_names[] = {
	"BA","HL","IX","IY",
	"BA","HL","IX","IY"
};

const char *ld_r_mem[] = {
	"(IX),A","(IX),B","(IX),H","(IX),L",
	"(IX),(NN+%02XH","??","??","??",
	"(HL),A","(HL),B","(HL),H","(HL),L",
	"(HL),(NN+%02XH","??","??","??",
	"(IY),A","(IY),B","(IY),H","(IY),L",
	"(IY),(NN+%02XH)","??","??","??",
	"(NN+%02XH),A","(NN+%02XH),B","(NN+%02XH),H","(NN+%02XH),L",
	"??","(NN+%02XH),(HL)","(NN+%02XH),(IX)","(NN+%02XH),(IY)",
};



const char *cc_names[] = {
    "F",    "LT",
    "LE",   "ULE",
    "PE",   "MI",
    "EQ/Z", "C/ULT",
    "",      "GE",
    "GT",   "UGT",
    "PO",   "PL",
    "NE/NZ","NC/UGE"
};

