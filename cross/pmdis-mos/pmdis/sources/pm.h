#ifndef _pm_h_included
#define _pm_h_included

//
//
//

#ifndef __GNUC__
#include <stdint.h>     // would require C99 compliant compiler
#else
#include <sys/types.h>    // ..but this is just fine for gcc

// Fix some C99 stuff..

#if !defined(uint8_t)
typedef u_char uint8_t;
#endif

#if !defined(uint16_t)
typedef u_int16_t uint16_t;
#endif

#if !defined(uint32_t)
typedef u_int32_t uint32_t;
#endif
#endif
//
//
//

#define PMD_VERSION "0.06"

//

#define OPS_LEN 80
#define MEM_LEN 80
#define MAX_CMD 80

struct tlcs900d {
  uint8_t *buffer;
  uint32_t pos;
  uint32_t base;
  int32_t len;
  int opt;        // Output type..
  char *opf;
  char ops[OPS_LEN];
  FILE *fh;
  int lines;
  int space;
};

/*
 *
 *
 */

uint8_t get8u( unsigned char * );
uint16_t get16u( unsigned char * );
uint32_t get24u( unsigned char * );
uint32_t get32u( unsigned char * );
int8_t get8( unsigned char * );
int16_t get16( unsigned char * );
int32_t get32( unsigned char * );

int getra( unsigned char * );
int getrb( unsigned char * );
int retr8( unsigned char *b, char *s, int mem );
int retr8_imm( unsigned char *b, char *s, int mem );
int retr16_imm( unsigned char *b, char *s, int mem );
int retr8_mem( unsigned char *b, char *s, int rb, int ra );
int retr16_mem( unsigned char *b, char *s, int rb, int ra );
int retr16( unsigned char *b, char *s, int mem );



enum opcodes {
	LD=0,	LDW,  	LDX,	PUSH,	PUSHW,  PUSHX,	PUSHXXX,	POP,	POPW,	POPX,	POPXXX,
	AND,	OR,		XOR,	ADD,	ADDW,	SUB,	SUBW,	DECW,	DEC,	INCW,	INC,
	EX,		NOP,	CMP,	CMPW,	TEST,	BCDE,	BCDD,	BCDX,	SBC,	ADC,	NOT,
	JC,		JNC,	JZ,		JNZ,	JP,		CALR,	JPL,	RET,	RETI,	DJNZ,
	PUSHA,	PUSHAX,	POPA,	POPAX,	INT,	JINT,	MUL,	DIV,	SHL,	ROR,	SHR,
	INVALID
};

enum maddressingmodes {
	ARI_XWA=0,ARI_XBC,ARI_XDE,ARI_XHL,ARI_XIX,ARI_XIY,ARI_XIZ,ARI_XSP,
	ARID_XWA,ARID_XBC,ARID_XDE,ARID_XHL,ARID_XIX,ARID_XIY,ARID_XIZ,ARID_XSP,
	ABS_B,ABS_W,ABS_L,
	ARI,
	ARI_PD,ARI_PI
};

enum output_types {
  OPT_1_0_0, OPT_1_1_0, OPT_1_1_1, OPT_1_1_2, OPT_1_2_0, OPT_1_3_0,
  OPT_2_1_2, OPT_2_0_0, OPT_1_n_1, OPT_1_n_1_1, OPT_1_n_1_2,
  OPT_1_n_2, OPT_1_n_1_4, OPT_1_4_0, OPT_1_1_1_1_1_1, OPT_2_1_0,
  OPT_2_2_0
};

//
//
//

extern char *opcode_names[];
extern const char *r8_24_names[];
extern const char *r16_24_names[];
extern const char *ld_r_mem[];

//
// Disassembly functions..
//

int decode_fixed( struct tlcs900d * );
int decode_3f( struct tlcs900d * );
int decode_40_7f( struct tlcs900d * );
int decode_80_9f( struct tlcs900d * );
int decode_a0_df( struct tlcs900d * );
int decode_ce_cf( struct tlcs900d * );
int decode_e0_ff( struct tlcs900d * );



int checkrom( struct tlcs900d *, int );
int loadrom_and_init( char *, struct tlcs900d * );

//
//
//





#endif
