
#define TRACE_PREPRO 0
#define TRACE_LIGHT_PREPRO 0
#define TRACE_POPEXPR 0
#define TRACE_COMPUTE_EXPRESSION 0
#define TRACE_HEXBIN 0
#define TRACE_MAKEAMSDOSREAL 0
#define TRACE_STRUCT 0
#define TRACE_EDSK 0
#define TRACE_HFE 0
#define TRACE_LABEL 0
#define TRACE_ORG 0
#define TRACE_LZ 0
#define TRACE_ASSEMBLE 0

/***
Rasm (roudoudou assembler) Z80 assembler

doc & latest official release at: https://github.com/EdouardBERGE/rasm

You may send requests/bugs in the same topic

-----------------------------------------------------------------------------------------------------
This software is using MIT "expat" license

« Copyright © BERGE Edouard (roudoudou)

Permission  is  hereby  granted,  free  of charge,to any person obtaining a copy  of  this  software
and  associated  documentation/source   files   of RASM, to deal in the Software without restriction,
including without limitation the  rights  to  use, copy,   modify,   merge,   publish,    distribute,
sublicense,  and/or  sell  copies of the Software, and  to  permit  persons  to  whom the Software is
furnished  to  do  so,  subject  to  the following conditions:

The above copyright  notice  and  this  permission notice   shall   be  included  in  all  copies  or
substantial portions of the Software.
The   Software   is   provided  "as is",   without warranty   of   any   kind,  express  or  implied,
including  but  not  limited  to the warranties of merchantability,   fitness   for   a    particular
purpose  and  noninfringement.  In  no event shall the  authors  or  copyright  holders be liable for
any  claim, damages  or other  liability,  whether in  an  action  of  contract, tort  or  otherwise,
arising from,  out of  or in connection  with  the software  or  the  use  or  other  dealings in the
Software. »
-----------------------------------------------------------------------------------------------------
Linux compilation with GCC or Clang:
cc rasm.c -O2 -lm -lrt -march=native -o rasm
strip rasm

Windows compilation with Visual studio:
cl.exe rasm.c -O2 -Ob3

pure MS-DOS 32 bits compilation with Watcom without native support of AP-Ultra:
wcl386 rasm.c -6r -6s -fp6 -d0 -k4000000 -ox /bt=DOS /l=dos4g -DOS_WIN=1 -DNOAPLIB=1

MorphOS compilation (ixemul):
gcc -noixemul -O2 -c -o rasm rasm.c
strip rasm

MacOS compilation:
cc rasm.c -O2 -lm -march=native -o rasm

*/

#ifdef __WATCOMC__
#define OS_WIN 1
#endif

#ifdef _WIN32
#define OS_WIN 1
#endif

#ifdef _WIN64
#define OS_WIN 1
#endif

#ifndef RDD
	/* public lib */
	#include"minilib.h"
#else
	/* private dev lib wont be published */
	#include"../tools/library.h"
	#define TxtSplitWithChar _internal_TxtSplitWithChar
#endif

int MAX_OFFSET_ZX0=32640;

#ifndef NO_3RD_PARTIES
#define __FILENAME__ "3rd parties"
/* 3rd parties compression */
#include"zx7.h"
#include"lz4.h"
#include"exomizer.h"

void zx0_reverse(unsigned char *first, unsigned char *last) {
    unsigned char c;

    while (first < last) {
        c = *first;
        *first++ = *last;
        *last-- = c;
    }
}

typedef struct block_t {
    struct block_t *chain;
    struct block_t *ghost_chain;
    int bits;
    int index;
    int offset;
    int references;
} BLOCK;

BLOCK *allocate(int bits, int index, int offset, BLOCK *chain);

void assign(BLOCK **ptr, BLOCK *chain);

BLOCK *zx0_optimize(unsigned char *input_data, int input_size, int skip, int offset_limit);

unsigned char *zx0_compress(BLOCK *optimal, unsigned char *input_data, int input_size, int skip, int backwards_mode, int invert_mode, int *output_size, int *delta);

#endif

#undef __FILENAME__
#define __FILENAME__ "rasm.c"

#ifndef OS_WIN
#define KNORMAL  "\x1B[0m"
#define KERROR   "\x1B[31m"
#define KAYGREEN "\x1B[32m"
#define KWARNING "\x1B[33m"
#define KVERBOSE "\x1B[36m"
#define KIO      "\x1B[97m"

#define KBOLD      "\e[1m"
#define KUNDERLINE "\e[4m"
#define KRED      "\x1B[31m"
#define KGREEN    "\x1B[32m"
#define KYELLOW   "\x1B[33m"
#define KBLUE     "\x1B[34m"
#define KMAGENTA  "\x1B[35m"
#define KCYAN     "\x1B[36m"
#define KLRED     "\x1B[91m"
#define KLGREEN   "\x1B[92m"
#define KLYELLOW  "\x1B[93m"
#define KLORANGE  "\x1B[38;5;202m"
#define KLBLUE    "\x1B[94m"
#define KLMAGENTA "\x1B[95m"
#define KLCYAN    "\x1B[96m"
#define KLWHITE   "\x1B[97m"

#else
#define KNORMAL  ""
#define KERROR   "Error: "
#define KAYGREEN ""
#define KWARNING "Warning: "
#define KBLUE    ""
#define KVERBOSE ""
#define KIO      ""
#define KBOLD      ""
#define KUNDERLINE ""
#define KRED      ""
#define KGREEN    ""
#define KYELLOW   ""
#define KBLUE     ""
#define KMAGENTA  ""
#define KCYAN     ""
#define KLRED     ""
#define KLGREEN   ""
#define KLYELLOW  ""
#define KLORANGE  ""
#define KLBLUE    ""
#define KLMAGENTA ""
#define KLCYAN    ""
#define KLWHITE   ""
#endif

/*******************************************************************
         c o m m a n d    l i n e    p a r a m e t e r s 
*******************************************************************/
enum e_dependencies_type {
E_DEPENDENCIES_NO=0,
E_DEPENDENCIES_LIST,
E_DEPENDENCIES_MAKE
};

#define INSIDE_RASM
#include "rasm.h"

#ifdef __MORPHOS__
/* Add standard version string to executable */
const char ver_version[] = { "\0$VER: "PROGRAM_NAME" "PROGRAM_VERSION" ("PROGRAM_DATE") "PROGRAM_COPYRIGHT"" };
/* Expand the default stack to match rasm requirements (about 64 KiB) */
unsigned long __stack = 128 * 1024;
#endif

/*******************************************************************
 c o m p u t e   o p e r a t i o n s   f o r   c a l c u l a t o r
*******************************************************************/

enum e_compute_operation_type {
E_COMPUTE_OPERATION_PUSH_DATASTC=0,
E_COMPUTE_OPERATION_OPEN=1,
E_COMPUTE_OPERATION_CLOSE=2,
E_COMPUTE_OPERATION_ADD=3,
E_COMPUTE_OPERATION_SUB=4,
E_COMPUTE_OPERATION_DIV=5,
E_COMPUTE_OPERATION_MUL=6,
E_COMPUTE_OPERATION_AND=7,
E_COMPUTE_OPERATION_OR=8,
E_COMPUTE_OPERATION_MOD=9,
E_COMPUTE_OPERATION_XOR=10,
E_COMPUTE_OPERATION_NOT=11,
E_COMPUTE_OPERATION_SHL=12,
E_COMPUTE_OPERATION_SHR=13,
E_COMPUTE_OPERATION_BAND=14,
E_COMPUTE_OPERATION_BOR=15,
E_COMPUTE_OPERATION_LOWER=16,
E_COMPUTE_OPERATION_GREATER=17,
E_COMPUTE_OPERATION_EQUAL=18,
E_COMPUTE_OPERATION_NOTEQUAL=19,
E_COMPUTE_OPERATION_LOWEREQ=20,
E_COMPUTE_OPERATION_GREATEREQ=21,
/* math functions */
E_COMPUTE_OPERATION_SIN=22,
E_COMPUTE_OPERATION_COS=23,
E_COMPUTE_OPERATION_INT=24,
E_COMPUTE_OPERATION_FLOOR=25,
E_COMPUTE_OPERATION_ABS=26,
E_COMPUTE_OPERATION_LN=27,
E_COMPUTE_OPERATION_LOG10=28,
E_COMPUTE_OPERATION_SQRT=29,
E_COMPUTE_OPERATION_ASIN=30,
E_COMPUTE_OPERATION_ACOS=31,
E_COMPUTE_OPERATION_ATAN=32,
E_COMPUTE_OPERATION_EXP=33,
E_COMPUTE_OPERATION_LOW=34,
E_COMPUTE_OPERATION_HIGH=35,
E_COMPUTE_OPERATION_PSG=36,
E_COMPUTE_OPERATION_RND=37,
E_COMPUTE_OPERATION_FRAC=38,
E_COMPUTE_OPERATION_CEIL=39,
E_COMPUTE_OPERATION_GET_R=40,
E_COMPUTE_OPERATION_GET_V=41,
E_COMPUTE_OPERATION_GET_B=42,
E_COMPUTE_OPERATION_SET_R=43,
E_COMPUTE_OPERATION_SET_V=44,
E_COMPUTE_OPERATION_SET_B=45,
E_COMPUTE_OPERATION_SOFT2HARD=46,
E_COMPUTE_OPERATION_HARD2SOFT=47,
E_COMPUTE_OPERATION_PEEK=48,
/* string functions */
E_COMPUTE_OPERATION_GETNOP=49,
E_COMPUTE_OPERATION_GETTICK=50,
E_COMPUTE_OPERATION_DURATION=51,
E_COMPUTE_OPERATION_FILESIZE=52,
E_COMPUTE_OPERATION_GETSIZE=53,
E_COMPUTE_OPERATION_IS_REGISTER=54,
E_COMPUTE_OPERATION_END=55
};

struct s_compute_element {
enum e_compute_operation_type operator;
double value;
int priority;
char *string;
};

struct s_compute_core_data {
	/* evaluator v3 may be recursive */
	char *varbuffer;
	int maxivar;
	struct s_compute_element *tokenstack;
	int maxtokenstack;
	struct s_compute_element *operatorstack;
	int maxoperatorstack;
};

/***********************************************************
  w a v   h e a d e r    f o r    a u d i o    i m p o r t
***********************************************************/
struct s_wav_header {
char ChunkID[4];
unsigned char ChunkSize[4];
char Format[4];
char SubChunk1ID[4];
unsigned char SubChunk1Size[4];
unsigned char AudioFormat[2];
unsigned char NumChannels[2];
unsigned char SampleRate[4];
unsigned char ByteRate[4];
unsigned char BlockAlign[2];
unsigned char BitsPerSample[2];
unsigned char SubChunk2ID[4];
unsigned char SubChunk2Size[4];
};

enum e_audio_sample_type {
AUDIOSAMPLE_SMP,
AUDIOSAMPLE_SM2,
AUDIOSAMPLE_SM4,
AUDIOSAMPLE_DMAA,
AUDIOSAMPLE_DMAB,
AUDIOSAMPLE_DMAC,
AUDIOSAMPLE_END
};

/***********************************************************************
  e x p r e s s i o n   t y p e s   f o r   d e l a y e d   w r i t e
***********************************************************************/
enum e_expression {
	E_EXPRESSION_J8,     /* relative 8bits jump */
	E_EXPRESSION_0V8,    /* 8 bits value to current address */
	E_EXPRESSION_V8,     /* 8 bits value to current address+1 */
	E_EXPRESSION_J16,    /* 16 bits value to current address+1 */
	E_EXPRESSION_J16C,   /* 16 bits value to current address+1 */
	E_EXPRESSION_V16,    /* 16 bits value to current address+1 */
	//E_EXPRESSION_V16C,   /* 16 bits value to current address+1 */
	E_EXPRESSION_0V16,   /* 16 bits value to current address */
	E_EXPRESSION_0V32,   /* 32 bits value to current address */
	E_EXPRESSION_0VR,    /* AMSDOS real value (5 bytes) to current address */
	E_EXPRESSION_0VRMike,/* Microsoft IEEE-754 real value (5 bytes) to current address */
	E_EXPRESSION_IV8,    /* 8 bits value to current address+2 */
	E_EXPRESSION_IV81,   /* 8 bits value+1 to current address+2 */
	E_EXPRESSION_3V8,    /* 8 bits value to current address+3 used with LD (IX+n),n */
	E_EXPRESSION_IV16,   /* 16 bits value to current address+2 */
	E_EXPRESSION_RST,    /* the offset of RST is translated to the opcode */
	E_EXPRESSION_RSTC,   /* conditionnal RST */
	E_EXPRESSION_IM,     /* the interrupt mode is translated to the opcode */
	E_EXPRESSION_RUN,    /* delayed RUN value */
	E_EXPRESSION_ZXRUN,  /* delayed RUN value for ZX snapshot */
	E_EXPRESSION_ZXSTACK,/* delayed STACK value for ZX snapshot */
	E_EXPRESSION_BRS     /* delayed shifting for BIT, RES, SET */
};

struct s_expression {	
	char *reference;          /* backup when used inside loop (or macro?) */
	int iw;                   /* word index in the main wordlist */
	int o;                    /* offset de depart 0, 1 ou 3 selon l'opcode */
	int ptr;                  /* offset courant pour calculs relatifs */
	int wptr;                 /* where to write the result  */
	enum e_expression zetype; /* type of delayed write */
	int lz;                   /* lz zone */
	int ibank;                /* ibank of expression */
	int iorgzone;             /* org of expression */
	char *module;
};

struct s_expr_dico {
	char *name;
	int crc;
	int autorise_export;
	double v;
	int used;
	int iw;
	int external;
};

struct s_external_mapping {
	int iorgzone;
	int ptr;
	int size;
	int value; // do not relocate outside scope!
};

struct s_external {
	char *name;
	int crc;
	/* mapping info */
	struct s_external_mapping *mapping;
	int imapping,mmapping;
};

struct s_memory_localisation {
	int physical;
	int logical;
	int rom; // RAM:0 ROM:1
};

struct s_label {
	char *name;   /* is alloced for local repeat or struct OR generated global -> in this case iw=-1 */
	int localsize;
	int iw;       /* index of the word of label name */
	int crc;      /* crc of the label name */
	int ptr;      /* "physical" address */
	int lz;       /* is the label in a crunched section (or after)? */
	int iorgzone; /* org of label */
	int ibank;    /* current CPR bank / always zero in classic mode */
	int local;
	/* errmsg */
	int fileidx;
	int fileline;
	int autorise_export,backidx,local_export;
	int make_alias;
	int used;
};

struct s_alias {
	char *alias;
	char *translation;
	int crc,len,autorise_export;
	int iw,lz;
	int used,fromstruct;
	/* v1.5 */
	int ptr;
	float v;
};

struct s_ticker {
	char *varname;
	int crc;
	long nopstart;
	long tickerstart;
};

/***********************************************************************
   m e r k e l    t r e e s    f o r    l a b e l,  v a r,  a l i a s
***********************************************************************/
struct s_crclabel_tree {
	struct s_crclabel_tree *radix[256];
	struct s_label *label;
	int nlabel,mlabel;
};
struct s_crcdico_tree {
	struct s_crcdico_tree *radix[256];
	struct s_expr_dico *dico;
	int ndico,mdico;
};
struct s_crcused_tree {
	struct s_crcused_tree *radix[256];
	char **used;
	int nused,mused;
};
struct s_crcstring_tree {
	struct s_crcstring_tree *radix[256];
	char **text;
	int ntext,mtext;
	char **replace;
	int nreplace,mreplace;
};
/*************************************************
          m e m o r y    s e c t i o n
*************************************************/
struct s_lz_section {
	int iw;
	int memstart,memend;
	int lzversion; /* 0 -> NO CRUNCH but must be delayed / 4 -> LZ4 / 7 -> ZX7 / 48 -> LZ48 / 49 -> LZ49 / 8 -> Exomizer */
	int version,minmatch; /* LZSA + ZX0 */
	int iorgzone;
	int ibank;
	/* idx backup */
	int iexpr,ilabel;
	int iendexpr,iendlabel;
};

struct s_orgzone {
	int ibank,protect;
	int memstart,memend;
	int ifile,iline;
	int nocode;
	int inplace;
};

/**************************************************
         i n c b i n     s t o r a g e
**************************************************/
struct s_hexbin {
	unsigned char *data;
	int datalen,rawlen;
	char *filename;
	int crunch;
	int version,minmatch;
};

/**************************************************
            h f e    m a n a g e m e n t        
**************************************************/

#define SYNCHRO 256

enum e_hfe_action {
	E_HFE_ACTION_INIT=0,
	E_HFE_ACTION_SIDE,
	E_HFE_ACTION_SETTINGS, // extended settings like bitrate or maxtracksize
	E_HFE_ACTION_TRACK,
	E_HFE_ACTION_ADD_TRACK_HEADER,
	E_HFE_ACTION_ADD_SECTOR,
	E_HFE_ACTION_ADD_GAP,
	E_HFE_ACTION_ADD_BYTE,
	E_HFE_ACTION_START_CRC,
	E_HFE_ACTION_OUTPUT_CRC,
	E_HFE_ACTION_CLOSE,
	E_HFE_ACTION_END
};

struct s_hfe_action {
	enum e_hfe_action action;
	char *filename;
	int ibank;
	int ioffset;
	// deferred calculation info
	int iw,nbparam;
	// copie intégrale des paramètres?
	char **param;
	int iparam,mparam;
	// extended sector definition
	int idcrc_ko;
	int iddata_ko;
	int nbidsync;
	int nbidamsync;
	int gapsize,presynchrosize,synchrosize;
};

struct s_hfe_track {
	unsigned int *data;
	int idata,mdata;
};
struct s_hfe_floppy {
	struct s_hfe_track *track;
	int itrack,mtrack;
	char *filename;
};


/**************************************************
          e d s k    m a n a g e m e n t        
**************************************************/
struct s_edsk_sector_global_struct {
unsigned char track;
unsigned char side;
unsigned char id;
unsigned char size;
unsigned char st1;
unsigned char st2;
unsigned short int length;
unsigned char *data;
int fakegap; // extragap management
};

struct s_edsk_track_global_struct  {
int track,side; // easy display
int unformated;
int sectornumber;
int headersize;
/* information purpose */
int sectorsize;
int gap3length;
int fillerbyte;
int datarate;
int recordingmode;
struct s_edsk_sector_global_struct *sector;
};

struct s_edsk_global_struct {
int tracknumber;
int sidenumber;
int tracksize; /* DSK legacy */
struct s_edsk_track_global_struct *track;
};

struct s_edsk_location {
	int istrack;
	int track;
	int sectorID;
};

enum e_edsk_action {
	/* immediate */
	E_EDSK_ACTION_CREATE=0,
	E_EDSK_ACTION_READSECT,
	E_EDSK_ACTION_UPGRADE,
	E_EDSK_ACTION_MERGE,
	/* deferred */
	E_EDSK_ACTION_WRITESECT,
	E_EDSK_ACTION_MAP,
	E_EDSK_ACTION_ADD,
	E_EDSK_ACTION_DROP,
	E_EDSK_ACTION_RESIZE,
	E_EDSK_ACTION_GAPFIX,
	E_EDSK_ACTION_REORDER,
	E_EDSK_ACTION_END
};

struct s_edsk_action {
	enum e_edsk_action action;
	// save info
	int ibank;
	int ioffset;
	int isize;
	// deferred calculation info
	int iw,nbparam;
	char *filename;
	char *filename2;
	char *filename3;
};

struct s_edsk_wrapper_entry {
unsigned char user;
unsigned char filename[11];
unsigned char subcpt;
unsigned char reserved;
unsigned char extendcounter;
unsigned char rc;
unsigned char blocks[16];
};

enum e_putfile_order {
        ORDER_ID=0,
        ORDER_PHYSICAL=1
};

struct s_edsk_wrapper {
char *edsk_filename;
struct s_edsk_wrapper_entry entry[64];
int nbentry;
unsigned char blocks[178][1024]; /* DATA format */
int face;
};

struct s_save {
	int ibank;
	int ioffset;
	int isize;
	int iw,irun;
	char *filename;
	int amsdos,hobeta;
	int tape,dsk,face,iwdskname;
};


/********************
      L O O P S
********************/

enum e_loop_style {
E_LOOPSTYLE_REPEATN,
E_LOOPSTYLE_REPEATUNTIL,
E_LOOPSTYLE_WHILE
};

struct s_repeat {
	int start;
	int cpt;
	int value;
	int maxim;
	int repeat_counter;
	char *repeatvar;
	struct s_expr_dico *repeatvarstruct;
	double varincrement;
	int repeatcrc;
};

struct s_whilewend {
	int start;
	int cpt;
	int value;
	int maxim;
	int while_counter;
};

struct s_switchcase {
	int refval;
	int execute;
	int casematch;
};

struct s_repeat_index {
	int ifile;
	int ol,oidx;
	int cl,cidx;
};


enum e_ifthen_type {
E_IFTHEN_TYPE_IF=0,
E_IFTHEN_TYPE_IFNOT=1,
E_IFTHEN_TYPE_IFDEF=2,
E_IFTHEN_TYPE_IFNDEF=3,
E_IFTHEN_TYPE_ELSE=4,
E_IFTHEN_TYPE_ELSEIF=5,
E_IFTHEN_TYPE_IFUSED=6,
E_IFTHEN_TYPE_IFNUSED=7,
E_IFTHEN_TYPE_ELSEIFNOT=8,
E_IFTHEN_TYPE_END
};

struct s_ifthen {
	char *filename;
	int line,v;
	enum e_ifthen_type type;
};

/**************************************************
          w o r d    p r o c e s s i n g
**************************************************/
struct s_wordlist {
	char *w;
	int l,t,e; /* e=1 si egalite dans le mot */
	int ifile;
	int ml,mifile;
};

struct s_macro {
	char *mnemo;
	int crc;
	/* une macro concatene des chaines et des parametres */
	struct s_wordlist *wc;
	int nbword,maxword;
	/**/
	char **param;
	int nbparam;
};

struct s_macro_position {
	int start,end,value,level,pushed;
	//char *lastlocal;
	//int lastlocalen,lastlocalalloc;
};

/* preprocessing only */
struct s_macro_fast {
	char *mnemo;
	int crc;
};

struct s_math_keyword {
	char *mnemo;
	int crc;
	enum e_compute_operation_type operation;
};

struct s_expr_word {
	char *w;
	int aw;
	int op;
	int comma;
	int fct;
	double v;
};

struct s_listing {
	char *listing;
	int ifile;
	int iline;
};

enum e_tagtranslateoption {
E_TAGOPTION_NONE=0,
E_TAGOPTION_REMOVESPACE=1,
E_TAGOPTION_PRESERVE=2
};

#ifdef RASM_THREAD
struct s_rasm_thread {
	pthread_t thread;
	int lz;
	unsigned char *datain;
	int datalen;
	unsigned char *dataout;
	int lenout;
	int status;
};
#endif


/*********************************************************
            S N A P S H O T     E X P O R T
*********************************************************/
/* extension 4Mo = 256 slots + 4 slots 64K de RAM par défaut => 260 */

#define BANK_MAX_NUMBER 260

struct s_snapshot_symbol {
	unsigned char size;
	unsigned char name[256];
	unsigned char reserved[6];
	unsigned char bigendian_address[2];
};


struct s_zxsnapshot {
	
	unsigned int run;
	unsigned int stack;
};

struct s_snapshot {
	char idmark[8];
	char unused1[8];
	unsigned char version; /* 3 */
	struct {
		struct {
			unsigned char F;
			unsigned char A;
			unsigned char C;
			unsigned char B;
			unsigned char E;
			unsigned char D;
			unsigned char L;
			unsigned char H;
		}general;
		unsigned char R;
		unsigned char regI; /* I incompatible with tgmath.h */
		unsigned char IFF0;
		unsigned char IFF1;
		unsigned char LX;
		unsigned char HX;
		unsigned char LY;
		unsigned char HY;
		unsigned char LSP;
		unsigned char HSP;
		unsigned char LPC;
		unsigned char HPC;
		unsigned char IM; /* 0,1,2 */
		struct {
			unsigned char F;
			unsigned char A;
			unsigned char C;
			unsigned char B;
			unsigned char E;
			unsigned char D;
			unsigned char L;
			unsigned char H;
		}alternate;
	}registers;
		
	struct {
		unsigned char selectedpen;
		unsigned char palette[17];
		unsigned char multiconfiguration;
	}gatearray;
	unsigned char ramconfiguration;
	struct {
		unsigned char selectedregister;
		unsigned char registervalue[18];
	}crtc;
	unsigned char romselect;
	struct {
		unsigned char portA;
		unsigned char portB;
		unsigned char portC;
		unsigned char control;
	}ppi;
	struct {
		unsigned char selectedregister;
		unsigned char registervalue[16];
	}psg;
	unsigned char dumpsize[2]; /* 64 then use extended memory chunks */
	
	unsigned char CPCType; /* 0=464 / 1=664 / 2=6128 / 4=6128+ / 5=464+ / 6=GX4000 */
	unsigned char interruptnumber;
	unsigned char multimodebytes[6];
	unsigned char unused2[0x9C-0x75];
	
	/* offset #9C */
	struct {
		unsigned char motorstate;
		unsigned char physicaltrack;
	}fdd;
	unsigned char unused3[3];
	unsigned char printerstrobe;
	unsigned char unused4[2];
	struct {
		unsigned char model; /* 0->4 */
		unsigned char unused5[4];
		unsigned char HCC;
		unsigned char unused;
		unsigned char CLC;
		unsigned char RLC;
		unsigned char VTC;
		unsigned char HSC;
		unsigned char VSC;
		unsigned short int flags;
	}crtcstate;
	unsigned char vsyncdelay;
	unsigned char interruptscanlinecounter;
	unsigned char interruptrequestflag;
	unsigned char unused6[0xFF-0xB5+1];
};

struct s_snapshot_chunks {
	unsigned char chunkname[4]; /* MEM1 -> MEM8 */
	unsigned int chunksize;
};

struct s_breakpoint {
	int address;
	int bank;
};

struct s_comz {
	int idx;
	int bank;
	int address;
	char *comment;
};

/*********************************
        S T R U C T U R E S
*********************************/
enum e_rasmstructfieldtype {
E_RASMSTRUCTFIELD_BYTE,
E_RASMSTRUCTFIELD_WORD,
E_RASMSTRUCTFIELD_LONG,
E_RASMSTRUCTFIELD_REAL,
E_RASMSTRUCTFIELD_END
};
struct s_rasmstructfield {
	char *fullname;
	char *name;
	int offset;
	int size;
	int crc;
	/* filler */
	unsigned char *data;
	int idata,mdata;
	enum e_rasmstructfieldtype zetype;
};

struct s_rasmstruct {
	char *name;
	int crc;
	int size;
	int ptr;
	int nbelem;
	/* fields */
	struct s_rasmstructfield *rasmstructfield;
	int irasmstructfield,mrasmstructfield;
};

/*********************************
           D E B U G        
*********************************/



/*******************************************
              P O K E R               
*******************************************/
enum e_poker {
E_POKER_XOR8=0,
E_POKER_SUM8=1,
E_POKER_CIPHER001=2,
E_POKER_CIPHER002=3,
E_POKER_CIPHER003=4,
E_POKER_CIPHER004=5,
E_POKER_END
};

char *strpoker[]={
	"XORMEM",
	"SUMMEM",
	"CIPHER001 running XOR initialised with first value",
	"CIPHER002 running XOR initialised with memory location",
	"CIPHER003 XOR with LSB of memory location",
	"CIPHER004 XOR with key looping",
	NULL
};

struct s_poker {
	enum e_poker method;
	int istart,iend;
	int outputadr;
	int ibank;
	int istring;
	int ipoker;
};

struct s_relocation {
	int istart,iend; // word idx of the section to be relocated
	int iorgzone,outputadr,codeadr; // easy to know which mode is used
	int endoutputadr;
	int ibank;
	int ibankcopy; // code will be duplicated in another temporary bank
	int outputadrcopy;
	char *module;
	int iscomplete;
};

struct s_relocation_write {
	unsigned short int addr;
	int w16,wh,wl;
	int dest;
};

/*******************************************
        G L O B A L     S T R U C T
*******************************************/
struct s_assenv {
	/* current memory */
	int maxptr;
	/* CPR memory */
	int iwnamebank[BANK_MAX_NUMBER];
	unsigned char **mem;
	int nbbank,maxbank;
	int *memsize;
	int nbmemsize,maxmemsize;
	int forcetape,forcezx,forcecpr,forceROM,forceROMconcat,bankmode;
	int amsdos,forcesnapshot,packedbank,extendedCPR,xpr,cprinfo,cprinfo_export,dsksnapshot;
	int lastbank,activebank; // current used bank where data/code has to be written | used with outputadr (see ORG tracking)
	char *cprinfo_filename;
	struct s_snapshot snapshot;
	struct s_zxsnapshot zxsnapshot;
	int snapRAMsize;
	int bankset[BANK_MAX_NUMBER>>2]; /* 64K selected flag */
	int bankused[BANK_MAX_NUMBER];   /* 16K selected flag */
	int bankgate[BANK_MAX_NUMBER+1];
	int setgate[BANK_MAX_NUMBER+1];
	int rombank[257];
	int rundefined;
	/* parsing */
	struct s_wordlist *wl;
	int nbword;
	int idx,stage;
	char *label_filename;
	int label_line;
	char **filename;   // each name of file read
	int ifile,maxfile;
	char **rawfile; // case export
	int *rawlen;    // case export
	int nberr,flux;
#define INSTRUCTION_MAXLENGTH 14
	int fastmatch[256][INSTRUCTION_MAXLENGTH];
	unsigned char charset[256];
	int maxerr,extended_error,nowarning,erronwarn,utf8enable,freequote;
	/* ORG tracking */
	int codeadr,outputadr,nocode;      // codeadr is logical code position | outputadr is physical code position | nocode is a flag 1: no code to output 0: output code
	int codeadrbackup,outputadrbackup; // when using NOCODE, switching back to CODE will restore physical AND logical addresses
	struct s_orgzone *orgzone;         // each ORG is monitored to avoid conflicts
	int io,mo;
	int deadend;
	struct s_memory_localisation *memory_localisation;
	int imemory_localisation,mmemory_localisation;
	/* Struct */
	struct s_rasmstruct *rasmstruct;
	int irasmstruct,mrasmstruct;
	int getstruct;
	int backup_outputadr,backup_codeadr; // struct is declared like a NOCODE section so we must restore physical AND logical addresses after declaration ends
	char *backup_filename;
	int backup_line;
	struct s_rasmstruct *rasmstructalias;
	int irasmstructalias,mrasmstructalias;
	/* expressions */
	struct s_expression *expression;
	int ie,me;
	int maxam,as80,dams,pasmo;  // compatibility flags
	float rough;
	struct s_compute_core_data *computectx,ctx1,ctx2;
	struct s_crcstring_tree stringtree;
	/* label */
	struct s_label *label;
	int il,ml;
	struct s_crclabel_tree *labeltree[65536]; /* fast label access */
	char *module;
	int modulen;
	char module_separator[2];
	struct s_breakpoint *breakpoint;
	int ibreakpoint,maxbreakpoint;
	char *lastgloballabel;
	//char *lastsuperglobal;
	int lastgloballabellen, lastglobalalloc;
	char **globalstack; /* retrieve back global from previous scope */
	int igs,mgs;
	char *source_bigbuffer;   // huge buffer which will be preserved from preprocessing
	int source_bigbuffer_len; // len of this buffer which will be used to get back label case
	/* repeat */
	struct s_repeat *repeat;
	int ir,mr;
	double repeat_start;
	double repeat_increment;
	/* while/wend */
	struct s_whilewend *whilewend;
	int iw,mw;
	/* if/then/else */
	//int *ifthen;
	struct s_ifthen *ifthen;
	int ii,mi;
	/* switch/case */
	struct s_switchcase *switchcase;
	int isw,msw;
	/* expression dictionnary */
	struct s_expr_dico *dico;
	int idic,mdic;
	struct s_crcdico_tree *dicotree[65536]; /* fast dico access */
	struct s_crcused_tree *usedtree[65536]; /* fast used access */
	/* ticker */
	struct s_ticker *ticker;
	int iticker,mticker;
	long tick,nop;
	/* crunch section flag */
	struct s_lz_section *lzsection;
	int ilz,mlz;
	int lz,curlz;
	/* poker */
	struct s_poker *poker;
	int nbpoker,maxpoker;
	/* macro */
	struct s_macro *macro;
	int imacro,mmacro;
	int macrovoid;
	int macro_multi_line;
	/* labels locaux */
	int repeatcounter,whilecounter,macrocounter;
	struct s_macro_position *macropos;
	int imacropos,mmacropos;
	/* alias */
	struct s_alias *alias;
	int ialias,malias;
	/* hexbin */
	struct s_rasm_thread **rasm_thread;
	int irt,mrt;
	struct s_hexbin *hexbin;
	int ih,mh;
	char **includepath;
	int ipath,mpath;
	/* automates */
	char AutomateExpressionValidCharExtended[256];
	char AutomateExpressionValidCharFirst[256];
	char AutomateExpressionValidChar[256];
	char AutomateExpressionDecision[256];
	char AutomateValidLabelFirst[256];
	char AutomateValidLabel[256];
	char AutomateDigit[256];
	char AutomateHexa[256];
	struct s_compute_element AutomateElement[256];
	unsigned char psgtab[256];
	unsigned char dmatab[256];
	unsigned char psgfine[256];
	int noampersand;
	/* output */
	char *outputfilename;
	int export_sym,export_local,export_multisym;
	int export_var,export_equ;
	int export_sna,export_snabrk,remu;
	int export_brk,export_tape;
	int autorise_export,local_export;
	char *flexible_export;
	char *breakpoint_name;
	char *symbol_name;
	char *binary_name;
	char *cartridge_name;
	char *snapshot_name;
	char *tape_name;
	char *rom_name;
	struct s_save *save;
	int nbsave,maxsave;
	int current_run_idx;
	/* HFE */
	struct s_hfe_action *hfe_action;
	int nbhfeaction,maxhfeaction;
	int hfeside,hfetrack;
	unsigned short int hfecrc;
	struct s_hfe_floppy *hfedisk;
	int nbhfedisk,maxhfedisk;
	struct s_hfe_track *hfe; // fast ptr
	/* EDSK */
	struct s_edsk_action *edsk_action;
	int nbedskaction,maxedskaction;
	struct s_edsk_wrapper *edsk_wrapper;
	int nbedskwrapper,maxedskwrapper;
	int edskoverwrite;
	int checkmode,dependencies;
	int stop;
	int warn_unused;
	int display_stats;
	int enforce_symbol_case;
	/* debug */
	struct s_rasm_info debug;
	struct s_rasm_info **retdebug;
	int debug_total_len;
	int verbose_assembling;
	/* delayed print + comz*/
	struct s_comz *comz;
	int icomz,mcomz;
	int *dprint_idx;
	int idprint,mdprint;
	/* OBJ output */
	int buildobj;
	struct s_external *external;
	int nexternal,mexternal;
	int external_mapping_size; // when having external declared, this is where the current "pushed expression size" is given
	struct s_external_mapping *mapping;
	int imapping,mmapping;
	char **procedurename;
	int nprocedurename,mprocedurename;
	/* relocation */
	struct s_relocation *relocation;
	int irelocation,mrelocation;
};

/*************************************
         D I R E C T I V E S
*************************************/
struct s_asm_keyword {
	char *mnemo;
	int crc,length;
	void (*makemnemo)(struct s_assenv *ae);
};

struct s_math_keyword math_keyword[]={
{"SIN",0,E_COMPUTE_OPERATION_SIN},
{"COS",0,E_COMPUTE_OPERATION_COS},
{"INT",0,E_COMPUTE_OPERATION_INT},
{"ABS",0,E_COMPUTE_OPERATION_ABS},
{"LN",0,E_COMPUTE_OPERATION_LN},
{"LOG10",0,E_COMPUTE_OPERATION_LOG10},
{"SQRT",0,E_COMPUTE_OPERATION_SQRT},
{"FLOOR",0,E_COMPUTE_OPERATION_FLOOR},
{"ASIN",0,E_COMPUTE_OPERATION_ASIN},
{"ACOS",0,E_COMPUTE_OPERATION_ACOS},
{"ATAN",0,E_COMPUTE_OPERATION_ATAN},
{"EXP",0,E_COMPUTE_OPERATION_EXP},
{"LO",0,E_COMPUTE_OPERATION_LOW},
{"HI",0,E_COMPUTE_OPERATION_HIGH},
{"PSGVALUE",0,E_COMPUTE_OPERATION_PSG},
{"RND",0,E_COMPUTE_OPERATION_RND},
{"FRAC",0,E_COMPUTE_OPERATION_FRAC},
{"CEIL",0,E_COMPUTE_OPERATION_CEIL},
{"GETR",0,E_COMPUTE_OPERATION_GET_R},
{"GETV",0,E_COMPUTE_OPERATION_GET_V},
{"GETG",0,E_COMPUTE_OPERATION_GET_V},
{"GETB",0,E_COMPUTE_OPERATION_GET_B},
{"SETR",0,E_COMPUTE_OPERATION_SET_R},
{"SETV",0,E_COMPUTE_OPERATION_SET_V},
{"SETG",0,E_COMPUTE_OPERATION_SET_V},
{"SETB",0,E_COMPUTE_OPERATION_SET_B},
{"SOFT2HARD_INK",0,E_COMPUTE_OPERATION_SOFT2HARD},
{"S2H_INK",0,E_COMPUTE_OPERATION_SOFT2HARD},
{"HARD2SOFT_INK",0,E_COMPUTE_OPERATION_HARD2SOFT},
{"H2S_INK",0,E_COMPUTE_OPERATION_HARD2SOFT},
{"PEEK",0,E_COMPUTE_OPERATION_PEEK},
{"GETNOP",0,E_COMPUTE_OPERATION_GETNOP},
{"GETTICK",0,E_COMPUTE_OPERATION_GETTICK},
{"DURATION",0,E_COMPUTE_OPERATION_DURATION},
{"FILESIZE",0,E_COMPUTE_OPERATION_FILESIZE},
{"GETSIZE",0,E_COMPUTE_OPERATION_GETSIZE},
{"IS_REGISTER",0,E_COMPUTE_OPERATION_IS_REGISTER},
{"",0,-1}
};

#define CRC_SWITCH    0x01AEDE4A
#define CRC_CASE      0x0826B794
#define CRC_DEFAULT   0x9A0DAC7D
#define CRC_BREAK     0xCD364DDD
#define CRC_ENDSWITCH 0x18E9FB21

#define CRC_ELSEIFNOT 0x348E521
#define CRC_ELSEIF 0xE175E230
#define CRC_ELSE   0x3FF177A1
#define CRC_ENDIF  0xCD5265DE
#define CRC_IF     0x4BD52507
#define CRC_IFDEF  0x4CB29DD6
#define CRC_UNDEF  0xCCD2FDEA
#define CRC_IFNDEF 0xD9AD0824
#define CRC_IFNOT  0x4CCAC9F8
#define CRC_WHILE  0xBC268FF1
#define CRC_UNTIL  0xCC12A604
#define CRC_MEND   0xFFFD899C
#define CRC_ENDM   0x3FF9559C
#define CRC_MACRO  0x64AA85EA
#define CRC_IFUSED 0x91752638
#define CRC_IFNUSED 0x1B39A886

#define CRC_SIN 0xE1B71962
#define CRC_COS 0xE077C55D

#define CRC_0    0x7A98A6A8
#define CRC_1    0x7A98A6A9
#define CRC_2    0x7A98A6AA


#define CRC_NC   0x4BD52B09
#define CRC_Z    0x7A98A6D2
#define CRC_NZ   0x4BD52B20
#define CRC_P    0x7A98A6C8
#define CRC_PO   0x4BD53717
#define CRC_PE   0x4BD5370D
#define CRC_M    0x7A98A6C5

/* cut registers */
#define CRC_HL_LOW	0xF9FDE22C
#define CRC_HL_HIGH	0x2261E25A
#define CRC_DE_LOW	0x3A3CE221
#define CRC_DE_HIGH	0x23D0E04F
#define CRC_BC_LOW	0xFDFF1E1D
#define CRC_BC_HIGH	0x222BE44B
#define CRC_IX_LOW	0xB9FD0439
#define CRC_IX_HIGH	0xA3FD0667
#define CRC_IY_LOW	0xD9ED6C3A
#define CRC_IY_HIGH	0x23DD5068
#define CRC_AF_LOW	0xDDCF141F
#define CRC_AF_HIGH	0x223FEA4D

/* 8 bits registers */
#define CRC_F    0x7A98A6BE
#define CRC_I    0x7A98A6C1
#define CRC_R    0x7A98A6CA
#define CRC_A    0x7A98A6B9
#define CRC_B    0x7A98A6BA
#define CRC_C    0x7A98A6BB
#define CRC_D    0x7A98A6BC
#define CRC_E    0x7A98A6BD
#define CRC_H    0x7A98A6C0
#define CRC_L    0x7A98A6C4
/* dual naming */
#define CRC_XH   0x4BD50718
#define CRC_XL   0x4BD5071C
#define CRC_YH   0x4BD50519
#define CRC_YL   0x4BD5051D
#define CRC_HX   0x4BD52718
#define CRC_LX   0x4BD52F1C
#define CRC_HY   0x4BD52719
#define CRC_LY   0x4BD52F1D
#define CRC_IXL  0xE19F1765
#define CRC_IXH  0xE19F1761
#define CRC_IYL  0xE19F1166
#define CRC_IYH  0xE19F1162

/* 16 bits registers */
#define CRC_BC   0x4BD5D2FD
#define CRC_DE   0x4BD5DF01
#define CRC_HL   0x4BD5270C
#define CRC_IX   0x4BD52519
#define CRC_IY   0x4BD5251A
#define CRC_SP   0x4BD5311B
#define CRC_AF   0x4BD5D4FF
/* memory convention */
#define CRC_MHL  0xD0765F5D
#define CRC_MDE  0xD0467D52
#define CRC_MBC  0xD05E694E
#define CRC_MIX  0xD072B76A
#define CRC_MIY  0xD072B16B
#define CRC_MSP  0xD01A876C
#define CRC_MC   0xE018210C
/* struct parsing */
#define CRC_DEFB	0x37D15389
#define CRC_DB		0x4BD5DEFE
#define CRC_DEFW	0x37D1539E
#define CRC_DW		0x4BD5DF13
#define CRC_DEFI	0x37D15390
#define CRC_DEFS	0x37D1539A
#define CRC_DS		0x4BD5DF0F
#define CRC_DEFR	0x37D15399
#define CRC_DR		0x4BD5DF0E
#define CRC_DEFF	0x37D1538D
#define CRC_DF	        0x4BD5DF02

/* struct declaration use special instructions for defines */
int ICRC_DEFB,ICRC_DEFW,ICRC_DEFI,ICRC_DEFR,ICRC_DEFF,ICRC_DF,ICRC_DEFS,ICRC_DB,ICRC_DW,ICRC_DR,ICRC_DS;
/* need to pre-declare var */
extern struct s_asm_keyword instruction[];

/*
# base=16
% base=2
0-9 base=10
A-Z variable ou fonction (cos, sin, tan, sqr, pow, mod, and, xor, mod, ...)
+*-/&^m| operateur
*/

#define AutomateExpressionValidCharExtendedDefinition "0123456789.ABCDEFGHIJKLMNOPQRSTUVWXYZ_{}@+-*/~^$#%<=>|&" /* § */
#define AutomateExpressionValidCharFirstDefinition "#%0123456789.ABCDEFGHIJKLMNOPQRSTUVWXYZ_@${"
#define AutomateExpressionValidCharDefinition "0123456789.ABCDEFGHIJKLMNOPQRSTUVWXYZ_{}@$"
#define AutomateValidLabelFirstDefinition ".ABCDEFGHIJKLMNOPQRSTUVWXYZ_@"
#define AutomateValidLabelDefinition "0123456789.ABCDEFGHIJKLMNOPQRSTUVWXYZ_@{}"
#define AutomateDigitDefinition ".0123456789"
#define AutomateHexaDefinition "0123456789ABCDEF"

#ifndef NO_3RD_PARTIES
unsigned char *LZ4_crunch(unsigned char *data, int zelen, int *retlen){
	unsigned char *lzdest=NULL;
	lzdest=MemMalloc(65536);
	*retlen=LZ4_compress_HC((char*)data,(char*)lzdest,zelen,65536,9);
	return lzdest;
}
#ifndef NOAPULTRA
size_t apultra_compress(const unsigned char *pInputData, unsigned char *pOutBuffer, size_t nInputSize, size_t nMaxOutBufferSize,
      const unsigned int nFlags, size_t nMaxWindowSize, size_t nDictionarySize, void(*progress)(long long nOriginalSize, long long nCompressedSize), void *pStats);
size_t apultra_get_max_compressed_size(size_t nInputSize);

int do_apultra(unsigned char *datain, int lenin, unsigned char **dataout, int *lenout) {
   size_t nCompressedSize = 0L, nMaxCompressedSize;
   int nFlags = 0;
   //apultra_stats stats;
   unsigned char *pCompressedData;

   /* Allocate max compressed size */

   nMaxCompressedSize = apultra_get_max_compressed_size(lenin);
   pCompressedData = (unsigned char*)MemMalloc(nMaxCompressedSize);
   memset(pCompressedData, 0, nMaxCompressedSize);

   nCompressedSize = apultra_compress(datain, pCompressedData, lenin, nMaxCompressedSize, nFlags, 65536, 0 /* dico */, NULL /*compression_progress*/, NULL /*&stats*/);

   if (nCompressedSize == -1) {
      fprintf(stderr, "APULTRA compression error\n");
      *lenout=0;
      *dataout=NULL;
      return 100;
   }

   *lenout=nCompressedSize;
   *dataout=pCompressedData;
   return 0;
}
int APULTRA_crunch(unsigned char *data, int len, unsigned char **dataout, int *lenout) {
   return do_apultra(data, len, dataout, lenout);
}


size_t lzsa_compress_inmem(unsigned char *pInputData, unsigned char *pOutBuffer, size_t nInputSize, size_t nMaxOutBufferSize,
                             const unsigned int nFlags, const int nMinMatchSize, const int nFormatVersion);

int LZSA_crunch(unsigned char *datain, int lenin, unsigned char **dataout, int *lenout, int version, int matchsize) {
   size_t nCompressedSize = 0L, nMaxCompressedSize;
   int nFlags = 0;
   unsigned char *pCompressedData;

pCompressedData=(unsigned char *)MemMalloc(65536);
nMaxCompressedSize=65536;

/* RAW */
nFlags=1<<1; // nFlags=LZSA_FLAG_RAW_BLOCK;
/* par défaut du LZSA1-Fast */
if (version<1 || version>2) {
	version=1;
}
if (matchsize<2 || matchsize>5) {
	switch (version) {
		case 1:matchsize=5;break;
		case 2:matchsize=2;break;
		default:break;
	}
}

nCompressedSize=lzsa_compress_inmem(datain, pCompressedData, lenin, nMaxCompressedSize, nFlags, matchsize, version);

   if (nCompressedSize == -1) {
      fprintf(stderr, "LZSA compression error\n");
      *lenout=0;
      *dataout=NULL;
      return 100;
   }

   *lenout=nCompressedSize;
   *dataout=pCompressedData;
   return 0;
}

#endif
#endif

unsigned char *LZ48_encode_legacy(unsigned char *data, int length, int *retlength);
#define LZ48_crunch LZ48_encode_legacy
unsigned char *LZ49_encode_legacy(unsigned char *data, int length, int *retlength);
#define LZ49_crunch LZ49_encode_legacy

void ___new_memory_space(struct s_assenv *ae);

/*
 * optimised reading of text file in one shot
 */
unsigned char *_internal_readbinaryfile(char *filename, int *filelength)
{
        #undef FUNC
        #define FUNC "_internal_readbinaryfile"

        unsigned char *binary_data=NULL;

        *filelength=FileGetSize(filename);
        binary_data=MemMalloc((*filelength)+1);
        /* we try to read one byte more to close the file just after the read func */
        if (FileReadBinary(filename,(char*)binary_data,(*filelength)+1)!=*filelength) {
                logerr("Cannot fully read %s",filename);
                exit(INTERNAL_ERROR);
        }
        return binary_data;
}
char **_internal_readtextfile(struct s_assenv *ae,char *filename, char replacechar)
{
        #undef FUNC
        #define FUNC "_internal_readtextfile"

        char **lines_buffer=NULL;
        unsigned char *bigbuffer;
        int nb_lines=0,max_lines=0,i=0,e=0;
        int file_size;

        bigbuffer=_internal_readbinaryfile(filename,&file_size);

	// pre-allocate
	max_lines=file_size/32+10;
	lines_buffer=MemMalloc((max_lines+1)*sizeof(char **));

        while (i<file_size) {
                while (e<file_size && bigbuffer[e]!=0x0A) {
                        if (bigbuffer[e]==0x0D) bigbuffer[e]=replacechar; // windows char
                        e++;
                }
                if (e<file_size) e++;

		if (nb_lines>=max_lines) {
			max_lines=max_lines*2;
			lines_buffer=MemRealloc(lines_buffer,(max_lines+1)*sizeof(char **));
		}
		lines_buffer[nb_lines]=MemMalloc(e-i+1);
		memcpy(lines_buffer[nb_lines],bigbuffer+i,e-i);
		lines_buffer[nb_lines][e-i]=0;
		nb_lines++;
                i=e;
        }
        if (!nb_lines) {
                lines_buffer=MemMalloc(sizeof(char**));
                lines_buffer[0]=NULL;
        } else {
                lines_buffer[nb_lines]=NULL;
        }

	if (ae && ae->enforce_symbol_case && replacechar==':') {
		ae->source_bigbuffer=bigbuffer;
		ae->source_bigbuffer_len=file_size;
	}
        //MemFree(bigbuffer);
        return lines_buffer;
}

#define FileReadLines(ae,filename) _internal_readtextfile(ae,filename,':')
#define FileReadLinesRAW(ae,filename) _internal_readtextfile(ae,filename,0x0D)
#define FileReadContent(filename,filesize) _internal_readbinaryfile(filename,filesize)


/***
	TxtReplace
	
	input:
	in_str:     string where replace will occur
	in_substr:  substring to look for
	out_substr: replace substring
	recurse:    loop until no in_substr is found
	
	note: in_str MUST BE previously mallocated if out_substr is bigger than in_substr
*/
#ifndef RDD
char *TxtReplace(char *in_str, char *in_substr, char *out_substr, int recurse)
{
	#undef FUNC
	#define FUNC "TxtReplace"
	
	char *str_look,*m1,*m2;
	char *out_str;
	int sl,l1,l2,dif,cpt;

	if (in_str==NULL)
		return NULL;
		
	sl=strlen(in_str);
	l1=strlen(in_substr);
	/* empty string, nothing to do except return empty string */
	if (!sl || !l1)
		return in_str;
		
	l2=strlen(out_substr);
	dif=l2-l1;
		
	/* replace string is small or equal in size, we dont realloc */
	if (dif<=0)
	{
		/* we loop while there is a replace to do */
		str_look=strstr(in_str,in_substr);
		while (str_look!=NULL)
		{
			/* we copy the new string if his len is not null */
			if (l2)
				memcpy(str_look,out_substr,l2);
			/* only if len are different */
			if (l1!=l2)
			{
				/* we move the end of the string byte per byte
				   because memory locations overlap. This is
				   faster than memmove */
				m1=str_look+l1;
				m2=str_look+l2;
				while (*m1!=0)
				{
					*m2=*m1;
					m1++;m2++;
				}
				/* we must copy the EOL */
				*m2=*m1;
			}
			/* look for next replace */
			if (!recurse)
				str_look=strstr(str_look+l2,in_substr);
			else
				str_look=strstr(in_str,in_substr);
		}
		out_str=in_str;
	}
	else
	{
		/* we need to count each replace */
		cpt=0;
		str_look=strstr(in_str,in_substr);
		while (str_look!=NULL)
		{
			cpt++;
			str_look=strstr(str_look+l1,in_substr);
		}
		/* is there anything to do? */
		if (cpt)
		{
			/* we realloc to a size that will fit all replaces */
			out_str=MemRealloc(in_str,sl+1+dif*cpt);
			str_look=strstr(out_str,in_substr);
			while (str_look!=NULL && cpt)
			{
				/* as the replace string is bigger we
				   have to move memory first from the end */
				m1=out_str+sl;
				m2=m1+dif;
				sl+=dif;
				while (m1!=str_look+l1-dif)
				{
					*m2=*m1;
					m1--;m2--;
				}
				/* then we copy the replace string (can't be NULL in this case) */
				memcpy(str_look,out_substr,l2);
				
				/* look for next replace */
				if (!recurse)
					str_look=strstr(str_look+l2,in_substr);
				else
					str_look=strstr(in_str,in_substr);
					
				/* to prevent from naughty overlap */
				cpt--;
			}
			if (str_look!=NULL)
			{
				printf("INTERNAL ERROR - overlapping replace string (%s/%s), you can't use this one!\n",in_substr,out_substr);
				exit(ABORT_ERROR);
			}
		}
		else
			out_str=in_str;
	}
	return out_str;
}
#endif

#ifndef min
#define min(a,b) \
   ({ __typeof__ (a) _a = (a); \
       __typeof__ (b) _b = (b); \
     _a < _b ? _a : _b; })
#endif

/* Levenshtein implementation by TheRayTracer https://gist.github.com/TheRayTracer/2644387 */
int _internal_LevenshteinDistance(char *s,  char *t)
{
	int i,j,n,m,*d;
	int im,jn;
	int r;
	
   n=strlen(s)+1;
   m=strlen(t)+1;
   d=malloc(n*m*sizeof(int));
   memset(d, 0, sizeof(int) * n * m);

   for (i = 1, im = 0; i < m; i++, im++)
   {
      for (j = 1, jn = 0; j < n; j++, jn++)
      {
         if (s[jn] == t[im])
         {
            d[(i * n) + j] = d[((i - 1) * n) + (j - 1)];
         }
         else
         {
            d[(i * n) + j] = min(d[(i - 1) * n + j] + 1, /* A deletion. */
                                 min(d[i * n + (j - 1)] + 1, /* An insertion. */
                                     d[(i - 1) * n + (j - 1)] + 1)); /* A substitution. */
         }
      }
   }
   r = d[n * m - 1];
   free(d);
   return r;
}

unsigned int FastRand()
{
        #undef FUNC
        #define FUNC "FastRand"
	static unsigned int zeseed=0x12345678;
        zeseed=214013*zeseed+2531011;
        return (zeseed>>16)&0x7FFF;
}


#ifdef RASM_THREAD
/*
 threads used for crunching
*/
void _internal_ExecuteThreads(struct s_assenv *ae,struct s_rasm_thread *rasm_thread, void *(*fct)(void *))
{
	#undef FUNC
	#define FUNC "_internal_ExecuteThreads"

	pthread_attr_t attr;
	void *status;
	int rc;
	/* launch threads */
	pthread_attr_init(&attr);
	pthread_attr_setdetachstate(&attr,PTHREAD_CREATE_JOINABLE);
	pthread_attr_setstacksize(&attr,65536);

	if ((rc=pthread_create(&image_threads[i].thread,&attr,fct,(void *)rasm_thread))) {
		rasm_printf(ae,"FATAL ERROR - Cannot create thread!\n");
		exit(INTERNAL_ERROR);
	}
}
void _internal_WaitForThreads(struct s_assenv *ae,struct s_rasm_thread *rasm_thread)
{
	#undef FUNC
	#define FUNC "_internal_WaitForThreads"
	int rc;
	
	if ((rc=pthread_join(rasm_thread->thread,&status))) {
		rasm_printf(ae,"FATAL ERROR - Cannot wait for thread\n");
		exit(INTERNAL_ERROR);
	}
}
void PushCrunchedFile(struct s_assenv *ae, unsigned char *datain, int datalen, int lz)
{
	#undef FUNC
	#define FUNC "PushCrunchedFile"
	
	struct s_rasm_thread *rasm_thread;
	
	rasm_thread=MemMalloc(sizeof(struct s_rasm_thread));
	memset(rasm_thread,0,sizeof(struct s_rasm_thread));
	rasm_thread->datain=datain;
	rasm_thread->datalen=datalen;
	rasm_thread->lz=lz;
	_internal_ExecuteThreads(ae,rasm_thread, void *(*fct)(void *));
	ObjectArrayAddDynamicValueConcat((void**)&ae->rasm_thread,&ae->irt,&ae->mrt,&rasm_thread,sizeof(struct s_rasm_thread *));
}
void PopAllCrunchedFiles(struct s_assenv *ae)
{
	#undef FUNC
	#define FUNC "PopAllCrunchedFiles"
	
	int i;
	for (i=0;i<ae->irt;i++) {
		_internal_WaitForThreads(ae,ae->rasm_thread[i]);
	}
}
#endif

void MaxError(struct s_assenv *ae);

void rasm_printf(struct s_assenv *ae, ...) {
	#undef FUNC
	#define FUNC "(internal) rasm_printf"
	
	char *format;
	va_list argptr;

	if (!ae->flux && !ae->dependencies) {
		va_start(argptr,ae);
		format=va_arg(argptr,char *);
		vfprintf(stdout,format,argptr);	
		va_end(argptr);
		fprintf(stdout,KNORMAL);
	}
}
/***
	build the string of current line for error messages
*/
char *rasm_getline(struct s_assenv *ae, int offset) {
	#undef FUNC
	#define FUNC "rasm_getline"
	
	static char myline[40]={0};
	int idx=0,icopy,first=1;

	while (!ae->wl[ae->idx+offset].t && idx<32) {
		for (icopy=0;idx<32 && ae->wl[ae->idx+offset].w[icopy];icopy++) {
			myline[idx++]=ae->wl[ae->idx+offset].w[icopy];
		}
		if (!first) myline[idx++]=','; else first=0;
		offset++;
	}
	if (idx>=32) {
		strcpy(myline+29,"...");
	} else {
		myline[idx++]=0;
	}
	
	return myline;
}

char *SimplifyPath(char *filename) {
	#undef FUNC
	#define FUNC "SimplifyPath"

	return filename;
#if 0	
	char *pos,*repos;
	int i,len;

	char *rpath;

	rpath=realpath(filename,NULL);
	if (!rpath) {
		printf("rpath error!\n");
		switch (errno) {
			case EACCES:printf("read permission failure\n");break;
			case EINVAL:printf("wrong argument\n");break;
			case EIO:printf("I/O error\n");break;
			case ELOOP:printf("too many symbolic links\n");break;
			case ENAMETOOLONG:printf("names too long\n");break;
			case ENOENT:printf("names does not exists\n");break;
			case ENOMEM:printf("out of memory\n");break;
			case ENOTDIR:printf("a component of the path is not a directory\n");break;
			default:printf("unknown error\n");break;
		}
		exit(1);
	}
	if (strlen(rpath)<strlen(filename)) {
		strcpy(filename,rpath);
	}
	free(rpath);
	return filename;
	
#ifdef OS_WIN
	while ((pos=strstr(filename,"\\..\\"))!=NULL) {
		repos=pos-1;
		/* sequence found, looking back for '\' */
		while (repos>=filename) {
			if (*repos=='\\') {
				break;
			}
			repos--;
		}
		repos++;
		if (repos>=filename && repos!=pos) {
			len=strlen(pos)-4+1;
			pos+=4;
			for (i=0;i<len;i++) {
				*repos=*pos;
				repos++;
				pos++;
			}
		}
		if (strncmp(filename,".\\..\\",5)==0) {
			repos=filename;
			pos=repos+2;
			for (;*repos;pos++,repos++) {
				*repos=*pos;
			}
			*repos=0;
		}
	}
#else
printf("*************\nfilename=[%s]\n",filename);
	while ((pos=strstr(filename,"/../"))!=NULL) {
		repos=pos-1;
		while (repos>=filename) {
			if (*repos=='/') {
				break;
			}
			repos--;
		}
		repos++;
		if (repos>=filename && repos!=pos) {
			len=strlen(pos)-4+1;
			pos+=4;
			for (i=0;i<len;i++) {
				*repos=*pos;
				repos++;
				pos++;
			}
		}
printf("filename=[%s]\n",filename);
		if (strncmp(filename,"./../",5)==0) {
			repos=filename;
			pos=repos+2;
			for (;*repos;pos++,repos++) {
				*repos=*pos;
			}
			*repos=0;
		}
printf("filename=[%s]\n",filename);
	}
#endif
	return NULL;
#endif

}

char *rasm_GetPath(char *filename) {
	#undef FUNC
	#define FUNC "rasm_GetPath"

	static char curpath[PATH_MAX];
	int zelen,idx;

	zelen=strlen(filename);

#ifdef OS_WIN
	#define CURRENT_DIR ".\\"

	TxtReplace(filename,"/","\\",1);
	idx=zelen-1;
	while (idx>=0 && filename[idx]!='\\') idx--;
	if (idx<0) {
		/* pas de chemin */
		strcpy(curpath,".\\");
	} else {
		/* chemin trouve */
		strcpy(curpath,filename);
		curpath[idx+1]=0;
	}
#else
#ifdef __MORPHOS__
	#define CURRENT_DIR ""
#else
	#define CURRENT_DIR "./"
#endif
	idx=zelen-1;
	while (idx>=0 && filename[idx]!='/') idx--;
	if (idx<0) {
		/* pas de chemin */
		strcpy(curpath,CURRENT_DIR);
	} else {
		/* chemin trouve */
		strcpy(curpath,filename);
		curpath[idx+1]=0;
	}
#endif

	return curpath;
}
char *MergePath(struct s_assenv *ae,char *dadfilename, char *filename) {
	#undef FUNC
	#define FUNC "MergePath"

	static char curpath[PATH_MAX];


#ifdef OS_WIN
	TxtReplace(filename,"/","\\",1);

	if (filename[0] && filename[1]==':' && filename[2]=='\\') {
		/* chemin absolu */
		strcpy(curpath,filename);
	} else if (filename[0] && filename[1]==':') {
		rasm_printf(ae,KERROR"unsupported path style [%s]\n",filename);
		exit(-111);
	} else {
		if (filename[0]=='.' && filename[1]=='\\') {
			strcpy(curpath,rasm_GetPath(dadfilename));
			strcat(curpath,filename+2);
		} else {
			strcpy(curpath,rasm_GetPath(dadfilename));
			strcat(curpath,filename);
		}
	}
#else
	if (filename[0]=='/') {
		/* chemin absolu */
		strcpy(curpath,filename);
	} else if (filename[0]=='.' && filename[1]=='/') {
		strcpy(curpath,rasm_GetPath(dadfilename));
		strcat(curpath,filename+2);
	} else {
		strcpy(curpath,rasm_GetPath(dadfilename));
		strcat(curpath,filename);
	}
#endif

	return curpath;
}


void InitAutomate(char *autotab, const unsigned char *def)
{
	#undef FUNC
	#define FUNC "InitAutomate"

	int i;

	memset(autotab,0,256);
	for (i=0;def[i];i++) {
		autotab[(unsigned int)def[i]]=1;
	}
}
void StateMachineResizeBuffer(char **ABuf, int idx, int *ASize) {
	#undef FUNC
	#define FUNC "StateMachineResizeBuffer"

	if (idx>=*ASize) {
		if (*ASize<16384) {
			*ASize=(*ASize)*2;
		} else {
			*ASize=(*ASize)+16384;
		}
		*ABuf=MemRealloc(*ABuf,(*ASize)+2);
	}
}

int GetCRC(char *label) {
	#undef FUNC
	#define FUNC "GetCRC"
	int crc=0x12345678;
	int i=0;

	while (label[i]!=0) {
		crc=(crc<<9)^(crc+label[i++]);
	}
	return crc;
}
int GetCRCandLength(char *label, int *ilength) {
	#undef FUNC
	#define FUNC "GetCRC"
	int crc=0x12345678;
	int i=0;

	while (label[i]!=0) {
		crc=(crc<<9)^(crc+label[i++]);
	}
	*ilength=i;
	return crc;
}

int IsDirective(char *expr);

int IsRegister(char *zeexpression)
{
	#undef FUNC
	#define FUNC "IsRegister"

	switch (GetCRC(zeexpression)) {
		case CRC_F:if (strcmp(zeexpression,"F")==0) return 1; else return 0;
		case CRC_I:if (strcmp(zeexpression,"I")==0) return 1; else return 0;
		case CRC_R:if (strcmp(zeexpression,"R")==0) return 1; else return 0;
		case CRC_A:if (strcmp(zeexpression,"A")==0) return 1; else return 0;
		case CRC_B:if (strcmp(zeexpression,"B")==0) return 1; else return 0;
		case CRC_C:if (strcmp(zeexpression,"C")==0) return 1; else return 0;
		case CRC_D:if (strcmp(zeexpression,"D")==0) return 1; else return 0;
		case CRC_E:if (strcmp(zeexpression,"E")==0) return 1; else return 0;
		case CRC_H:if (strcmp(zeexpression,"H")==0) return 1; else return 0;
		case CRC_L:if (strcmp(zeexpression,"L")==0) return 1; else return 0;
		case CRC_BC:if (strcmp(zeexpression,"BC")==0) return 1; else return 0;
		case CRC_DE:if (strcmp(zeexpression,"DE")==0) return 1; else return 0;
		case CRC_HL:if (strcmp(zeexpression,"HL")==0) return 1; else return 0;
		case CRC_IX:if (strcmp(zeexpression,"IX")==0) return 1; else return 0;
		case CRC_IY:if (strcmp(zeexpression,"IY")==0) return 1; else return 0;
		case CRC_SP:if (strcmp(zeexpression,"SP")==0) return 1; else return 0;
		case CRC_AF:if (strcmp(zeexpression,"AF")==0) return 1; else return 0;
		case CRC_XH:if (strcmp(zeexpression,"XH")==0) return 1; else return 0;
		case CRC_XL:if (strcmp(zeexpression,"XL")==0) return 1; else return 0;
		case CRC_YH:if (strcmp(zeexpression,"YH")==0) return 1; else return 0;
		case CRC_YL:if (strcmp(zeexpression,"YL")==0) return 1; else return 0;
		case CRC_HX:if (strcmp(zeexpression,"HX")==0) return 1; else return 0;
		case CRC_LX:if (strcmp(zeexpression,"LX")==0) return 1; else return 0;
		case CRC_HY:if (strcmp(zeexpression,"HY")==0) return 1; else return 0;
		case CRC_LY:if (strcmp(zeexpression,"LY")==0) return 1; else return 0;
		case CRC_IXL:if (strcmp(zeexpression,"IXL")==0) return 1; else return 0;
		case CRC_IXH:if (strcmp(zeexpression,"IXH")==0) return 1; else return 0;
		case CRC_IYL:if (strcmp(zeexpression,"IYL")==0) return 1; else return 0;
		case CRC_IYH:if (strcmp(zeexpression,"IYH")==0) return 1; else return 0;
		default:break;
	}
	return 0;
}

int StringIsMem(char *w)
{
	#undef FUNC
	#define FUNC "StringIsMem"

	int p=1,idx=1;

	if (w[0]=='(') {
		while (w[idx]) {
			switch (w[idx]) {
				case '\\':if (w[idx+1]) idx++;
					break;
				case '\'':if (w[idx+1] && w[idx+1]!='\\') idx++;
					break;
				case '(':p++;break;
				case ')':p--;
					/* si on sort de la première parenthèse */
					if (!p && w[idx+1]) return 0;
					break;
				default:break;
			}
			idx++;
		}
		/* si on ne termine pas par une parenthèse */
		if (w[idx-1]!=')') return 0;
	} else {
		return 0;
	}
	return 1;

}


int StringIsQuote(const char *w)
{
	#undef FUNC
	#define FUNC "StringIsQuote"

	int i,tquote,lens;

	if (w[0]=='\'' || w[0]=='"') {
		tquote=w[0];
		lens=strlen(w);
		
		/* est-ce bien une chaine et uniquement une chaine? */
		i=1;
		while (w[i] && w[i]!=tquote) {
			if (w[i]=='\\') i++;
			i++;
		}
		if (i==lens-1) {
			return tquote;
		}
	}
	return 0;
}

char *StringRemoveQuotes(struct s_assenv *ae,const char *w) {
	char *newstr;
	static char *dummy="NULL";
	if (StringIsQuote(w)) {
		newstr=TxtStrDup(w+1);
		newstr[strlen(newstr)-1]=0;
	} else {
		newstr=TxtStrDup(dummy); // alloc to avoid side effect on error...
	}
	return newstr;
}
char *StringLooksLikeDicoRecurse(struct s_crcdico_tree *lt, int *score, char *str)
{
	#undef FUNC
	#define FUNC "StringLooksLikeDicoRecurse"

	char *retstr=NULL,*tmpstr;
	int i,curs;

	for (i=0;i<256;i++) {
		if (lt->radix[i]) {
			tmpstr=StringLooksLikeDicoRecurse(lt->radix[i],score,str);
			if (tmpstr!=NULL) retstr=tmpstr;
		}
	}
	if (lt->mdico) {
		for (i=0;i<lt->ndico;i++) {
			if (strlen(lt->dico[i].name)>4) {
				curs=_internal_LevenshteinDistance(str,lt->dico[i].name);
				if (curs<*score) {
					*score=curs;
					retstr=lt->dico[i].name;
				}
			}
		}
	}
	return retstr;
}
char *StringLooksLikeDico(struct s_assenv *ae, int *score, char *str)
{
	#undef FUNC
	#define FUNC "StringLooksLikeDico"

	char *retstr=NULL,*tmpstr;
	int i;

	for (i=0;i<65536;i++) {
		if (ae->dicotree[i]) {
			tmpstr=StringLooksLikeDicoRecurse(ae->dicotree[i],score,str);
			if (tmpstr!=NULL) retstr=tmpstr;
		}
	}
	return retstr;
}
char *StringLooksLikeMacro(struct s_assenv *ae, char *str, int *retscore)
{
	#undef FUNC
	#define FUNC "StringLooksLikeMacro"
	
	char *ret=NULL;
	int i,curs,score=3;
	/* search in macros */
	for (i=0;i<ae->imacro;i++) {
		curs=_internal_LevenshteinDistance(ae->macro[i].mnemo,str);
		if (curs<score) {
			score=curs;
			ret=ae->macro[i].mnemo;
		}
	}
	if (retscore) *retscore=score;
	return ret;
}	

char *StringLooksLike(struct s_assenv *ae, char *str)
{
	#undef FUNC
	#define FUNC "StringLooksLike"

	char *ret=NULL,*tmpret;
	int i,curs,score=4;

	/* search in variables */
	ret=StringLooksLikeDico(ae,&score,str);

	/* search in labels */
	for (i=0;i<ae->il;i++) {
		if (!ae->label[i].name && strlen(ae->wl[ae->label[i].iw].w)>4) {
			curs=_internal_LevenshteinDistance(ae->wl[ae->label[i].iw].w,str);
			if (curs<score) {
				score=curs;
				ret=ae->wl[ae->label[i].iw].w;
			}
		}
	}
	
	/* search in alias */
	for (i=0;i<ae->ialias;i++) {
		if (strlen(ae->alias[i].alias)>4) {
			curs=_internal_LevenshteinDistance(ae->alias[i].alias,str);
			if (curs<score) {
				score=curs;
				ret=ae->alias[i].alias;
			}
		}
	}
	
	tmpret=StringLooksLikeMacro(ae,str,&curs);
	if (curs<score) {
		score=curs;
		ret=tmpret;
	}
	return ret;
}

int RoundComputeExpression(struct s_assenv *ae,char *expr, int ptr, int didx, int expression_expected);
int RoundComputeExpressionCore(struct s_assenv *ae,char *zeexpression,int ptr,int didx);
double ComputeExpressionCore(struct s_assenv *ae,char *original_zeexpression,int ptr, int didx);
char *GetExpFile(struct s_assenv *ae,int didx);
void __STOP(struct s_assenv *ae);

/****************************************************************************************
 *       this function is used to display error from almost anywhere is RASM
 *       except from command line processing because first arg "ae" need to
 *       be allocated and this is done in the very beginning of "PreProcessing"
 *
 *       idx: if not zero, a check will be performed to display macro informations, if any
 *       filename: if not NULL, the source where the error occurs
 *       line: if not zero, the line in the source where the error occurs
 *
 *       there is 3 major ways to call "MakeError"
 *       1/ when using expression engine because we do not know if the calculations are postponed or not
 *          MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),...);
 *
 *       2/ when using any directive because we are in the unique pass of the assembling
 *          MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),...);
 *
 *       3/ during preprocessing because there is no wordlist yet containing debug information
 *          MakeError(ae,0,ae->filename[listing[l].ifile],listing[l].iline,...);
 *
 *       this will need some rewrite for harmonisation in the future...
 *
****************************************************************************************/
void MakeError(struct s_assenv *ae, int idx, char *filename, int line, char *format, ...)
{
	#undef FUNC
	#define FUNC "MakeError"

	va_list argptr;

	MaxError(ae);
	if (ae->flux) {
		/* in embedded Rasm all errors are stored in a debug struct */
		struct s_debug_error curerror;
		char toosmalltotakeitall[2]={0};
		int myalloc;
		char *errstr;
		
		va_start(argptr,format);
		myalloc=vsnprintf(toosmalltotakeitall,1,format,argptr);
		va_end(argptr);

		#if defined(_MSC_VER) && _MSC_VER < 1900
		/* visual studio before 2015 does not fully support C99 */
		if (myalloc<1 && strlen(format)) {
			va_start(argptr,format);
			myalloc=_vscprintf(format,argptr);
			va_end(argptr);
		}
		#endif
		if (myalloc<1) {
			/* does not crash */
			return;
		}

		va_start(argptr,format);
		errstr=MemMalloc(myalloc+1);
		vsnprintf(errstr,myalloc,format,argptr);
		curerror.msg=errstr;
		curerror.lenmsg=myalloc;
		curerror.line=line;
		if (filename) curerror.filename=TxtStrDupLen(filename,&curerror.lenfilename); else curerror.filename=TxtStrDupLen("<internal>",&curerror.lenfilename);
		ObjectArrayAddDynamicValueConcat((void **)&ae->debug.error,&ae->debug.nberror,&ae->debug.maxerror,&curerror,sizeof(struct s_debug_error));
		va_end(argptr);
	} else {
		fprintf(stdout,KERROR);
		if (filename && line) {
			printf("[%s:%d] ",filename,line);
			if (idx && ae->wl[idx].ml) {
				printf("inside macro => [%s:%d] ",ae->filename[ae->wl[idx].mifile],ae->wl[idx].ml);
			}
		} else if (filename) {
			printf("[%s] ",filename);
		}
		va_start(argptr,format);
		vfprintf(stdout,format,argptr);	
		va_end(argptr);
		fprintf(stdout,KNORMAL);
	}
}

/* convert v double value to Microsoft REAL 
 *
 * https://en.wikipedia.org/wiki/Microsoft_Binary_Format
 *
 * exponent:8
 * sign:1
 * mantiss:23
 *
 * /!\ this function is called ONLY from expression calculation so you need to have a proper index of expression (or allocate at least one expression and fake expression usage)
 * */
unsigned char *__internal_MakeRosoftREAL(struct s_assenv *ae, double v, int iexpression)
{
	#undef FUNC
	#define FUNC "__internal_MakeRosoftREAL"
	
	static unsigned char orc[5]={0};
	unsigned char rc[5]={0};
	int j,ib,ibb;
	int fracmax=0;
	int mesbits[32];
	int ibit=0,exp=0;
	// v2
	unsigned long mantissa;
	unsigned long deci;
	unsigned long mask;
	int isneg;

	if (v<0.0) {isneg=1;v=-v;} else isneg=0;

	memset(rc,0,sizeof(rc));

	// decimal hack
	deci=v;
#if TRACE_MAKEAMSDOSREAL
printf("AmstradREAL decimal part is %s\n",doubletext);
#endif
	/*******************************************************************
			     values >= 1.0
	*******************************************************************/
	if (deci) {
		mask=0x80000000;
		// find first significant bit of decimal part in order to get exponent value
		while (!(deci & mask)) mask=mask/2;
		while (mask) {
			exp++;
			mask=mask/2;
		}
		mantissa=v*pow(2.0,32-exp)+0.5; // 32 bits unsigned is the maximum value allowed
		if (mantissa & 0xFF00000000L) mantissa=0xFFFFFFFF;
#if TRACE_MAKEAMSDOSREAL
printf("decimal part has %d bits\n",exp);
printf("32 bits mantissa is %lu\n",mantissa);
#endif
		mask=0x80000000;
		while (mask) {
			mesbits[ibit]=!!(mantissa & mask);
			ibit++;
			mask=mask/2;
		}
	} else {
		/*******************************************************************
		                     negative exponent or zero
		*******************************************************************/
		/* handling zero special case */
		if (v==0.0) {
			exp=-128;
			ibit=0;
		} else {
			mantissa=(v*4294967296.0+0.5); // as v is ALWAYS <1.0 we never reach the 32 bits maximum
			if (mantissa & 0xFF00000000L) mantissa=0xFFFFFFFF;
			mask=0x80000000;
#if TRACE_MAKEAMSDOSREAL
printf("32 bits mantissa for fraction is %lu\n",mantissa);
#endif
			// find first significant bit of fraction part
			while (!(mantissa & mask)) {
				mask=mask/2;
				exp--;
			}

			mantissa=(v*pow(2.0,32-exp)+0.5); // as v is ALWAYS <1.0 we never reach the 32 bits maximum
			if (mantissa & 0xFF00000000L) mantissa=0xFFFFFFFF;
			mask=0x80000000;

			while (mask && ibit<32) {
				mesbits[ibit]=!!(mantissa & mask);
				ibit++;
				mask=mask/2;
			}
		}
#if TRACE_MAKEAMSDOSREAL
printf("\n%d bits used for mantissa\n",ibit);
#endif
	}

	/* pack bits */
	ib=3;ibb=0x80;
	for (j=0;j<ibit;j++) {
		if (mesbits[j])	rc[ib]|=ibb;
		ibb>>=1;
		if (ibb==0) {
			ibb=0x80;
			ib--;
		}
	}
	/* exponent */
	exp+=128;
	if (exp<0 || exp>255) {
		if (iexpression) MakeError(ae,ae->expression[iexpression].iw,GetExpFile(ae,iexpression),ae->wl[ae->expression[iexpression].iw].l,"Exponent overflow\n");
		else MakeError(ae,ae->idx,GetExpFile(ae,0),ae->wl[ae->idx].l,"Exponent overflow\n");
		exp=128;
	}
	rc[4]=exp;

	/* Microsoft REAL sign */
	if (!isneg) {
		rc[3]&=0x7F;
	} else {
		rc[3]|=0x80;
	}

	/* switch byte order */
	orc[0]=rc[4];
	orc[1]=rc[3];
	orc[2]=rc[2];
	orc[3]=rc[1];
	orc[4]=rc[0];

#if TRACE_MAKEAMSDOSREAL
	for (j=0;j<5;j++) printf("%02X ",orc[j]);
	printf("\n");
#endif

	return orc;
}


/* convert v double value to Amstrad REAL 
 *
 * http://www.cpcwiki.eu/index.php?title=Technical_information_about_Locomotive_BASIC&mobileaction=toggle_view_desktop#Floating_Point_data_definition
 *
 * exponent:8
 * sign:1
 * mantiss:23
 *
 * /!\ this function is called ONLY from expression calculation so you need to have a proper index of expression (or allocate at least one expression and fake expression usage)
 * */
unsigned char *__internal_MakeAmsdosREAL(struct s_assenv *ae, double v, int iexpression)
{
	#undef FUNC
	#define FUNC "__internal_MakeAmsdosREAL"
	
	static unsigned char rc[5];
	int mesbits[32]={0}; // must be reseted!
	int j,ib,ibb;
	int ibit=0,exp=0;
	// v2
	unsigned long mantissa;
	unsigned long deci;
	unsigned long mask;
	int isneg;

	memset(rc,0,sizeof(rc));

	if (v<0.0) {isneg=1;v=-v;} else isneg=0;

	// decimal hack
	deci=v;
#if TRACE_MAKEAMSDOSREAL
printf("AmstradREAL decimal part is %s\n",doubletext);
#endif
	/*******************************************************************
			     values >= 1.0
	*******************************************************************/
	if (deci) {
		mask=0x80000000;
		// find first significant bit of decimal part in order to get exponent value
		while (!(deci & mask)) mask=mask/2;
		while (mask) {
			exp++;
			mask=mask/2;
		}
		mantissa=v*pow(2.0,32-exp)+0.5; // 32 bits unsigned is the maximum value allowed
		if (mantissa & 0xFF00000000L) mantissa=0xFFFFFFFF;
#if TRACE_MAKEAMSDOSREAL
printf("decimal part has %d bits\n",exp);
printf("32 bits mantissa is %lu\n",mantissa);
#endif
		mask=0x80000000;
		while (mask) {
			mesbits[ibit]=!!(mantissa & mask);
			ibit++;
			mask=mask/2;
		}
	} else {
		/*******************************************************************
		                     negative exponent or zero
		*******************************************************************/
		/* handling zero special case */
		if (v==0.0) {
			exp=-128;
		} else {
			mantissa=(v*4294967296.0+0.5); // as v is ALWAYS <1.0 we never reach the 32 bits maximum
			if (mantissa & 0xFF00000000L) mantissa=0xFFFFFFFF;
			mask=0x80000000;
#if TRACE_MAKEAMSDOSREAL
printf("32 bits mantissa for fraction is %lu\n",mantissa);
#endif
			// find first significant bit of fraction part
			while (!(mantissa & mask)) {
				mask=mask/2;
				exp--;
			}

			mantissa=(v*pow(2.0,32-exp)+0.5); // as v is ALWAYS <1.0 we never reach the 32 bits maximum
			if (mantissa & 0xFF00000000L) mantissa=0xFFFFFFFF;
			mask=0x80000000;

			while (mask) {
				mesbits[ibit]=!!(mantissa & mask);
				ibit++;
				mask=mask/2;
			}
		}
#if TRACE_MAKEAMSDOSREAL
printf("\n%d bits used for mantissa\n",ibit);
#endif
	}

	/* pack bits */
	ib=3;ibb=0x80;
	for (j=0;j<ibit;j++) {
		if (mesbits[j])	rc[ib]|=ibb;
		ibb/=2;
		if (ibb==0) {
			ibb=0x80;
			ib--;
		}
	}
	/* exponent */
	exp+=128;
	if (exp<0 || exp>255) {
		if (iexpression) MakeError(ae,ae->expression[iexpression].iw,GetExpFile(ae,iexpression),ae->wl[ae->expression[iexpression].iw].l,"Exponent overflow\n");
		else MakeError(ae,ae->idx,GetExpFile(ae,0),ae->wl[ae->idx].l,"Exponent overflow\n");
		exp=128;
	}
	rc[4]=exp;

	/* REAL sign replace the most significant implied bit */
	if (!isneg) {
		rc[3]&=0x7F;
	} else {
		rc[3]|=0x80;
	}

#if TRACE_MAKEAMSDOSREAL
	for (j=0;j<5;j++) printf("%02X ",rc[j]);
	printf("\n------------------\n");
#endif

	return rc;
}




struct s_label *SearchLabel(struct s_assenv *ae, char *label, int crc);
char *GetExpFile(struct s_assenv *ae,int didx){
	#undef FUNC
	#define FUNC "GetExpFile"
	
	if (ae->label_filename) {
		return ae->label_filename;
	}
	if (didx<0) {
		return ae->filename[ae->wl[-didx].ifile];
	} else if (!didx) {
		return ae->filename[ae->wl[ae->idx].ifile];
	} else if (ae->expression && didx<ae->ie) {
			return ae->filename[ae->wl[ae->expression[didx].iw].ifile];
	} else {
		//return ae->filename[ae->wl[ae->idx].ifile];
		return 0;
	}
}

int GetExpLine(struct s_assenv *ae,int didx){
	#undef FUNC
	#define FUNC "GetExpLine"

	if (ae->label_line) return ae->label_line;

	if (didx<0) {
		return ae->wl[-didx].l;
	} else if (!didx) {
		return ae->wl[ae->idx].l;
	} else if (didx<ae->ie) {
		return ae->wl[ae->expression[didx].iw].l;
	} else return 0;
}
int GetExpIdx(struct s_assenv *ae,int didx) {
	if (ae->label_line) return ae->label_line;

	if (didx<0) {
		return -didx;
	} else if (!didx) {
		return ae->idx;
	} else if (didx<ae->ie) {
		return ae->expression[didx].iw;
	} else return 0;
}

char *GetCurrentFile(struct s_assenv *ae)
{
	return GetExpFile(ae,0);
}


/*******************************************************************************************
			    M E M O R Y       C L E A N U P 
*******************************************************************************************/
void FreeLabelTree(struct s_assenv *ae);
void FreeDicoTree(struct s_assenv *ae);
void FreeUsedTree(struct s_assenv *ae);
void ExpressionFastTranslate(struct s_assenv *ae, char **ptr_expr, int fullreplace);
char *TradExpression(char *zexp);


void _internal_RasmFreeInfoStruct(struct s_rasm_info *debug)
{
	#undef FUNC
	#define FUNC "RasmFreeInfoStruct"

	int i;
	if (debug->maxerror) {
		for (i=0;i<debug->nberror;i++) {
			MemFree(debug->error[i].filename);
			MemFree(debug->error[i].msg);
		}
		MemFree(debug->error);
	}
	if (debug->maxsymbol) {
		for (i=0;i<debug->nbsymbol;i++) {
			MemFree(debug->symbol[i].name);
		}
		MemFree(debug->symbol);
	}
	memset(debug,0,sizeof(debug));
}

void RasmFreeInfoStruct(struct s_rasm_info *debug)
{
	_internal_RasmFreeInfoStruct(debug);
	MemFree(debug);
}

void FreeAssenv(struct s_assenv *ae)
{
	#undef FUNC
	#define FUNC "FreeAssenv"
	int i,j;

#ifndef RDD
	/* let the system free the memory in command line except when debug/dev */
	#ifndef __MORPHOS__
	/* MorphOS does not like when memory is not freed before exit */
	if (!ae->flux) return;
	#endif
#endif
	/*** debug info ***/	
	if (!ae->retdebug) {
		_internal_RasmFreeInfoStruct(&ae->debug);
	} else {
		/* symbols */
		struct s_debug_symbol debug_symbol={0};

		for (i=0;i<ae->il;i++) {
			/* on exporte tout */
			if (!ae->label[i].name) {
				/* les labels entiers */
				debug_symbol.name=TxtStrDup(ae->wl[ae->label[i].iw].w);
				debug_symbol.v=ae->label[i].ptr;
				ObjectArrayAddDynamicValueConcat((void**)&ae->debug.symbol,&ae->debug.nbsymbol,&ae->debug.maxsymbol,&debug_symbol,sizeof(struct s_debug_symbol));
			} else {
				/* les labels locaux et générés */
				debug_symbol.name=TxtStrDup(ae->label[i].name);
				if (ae->label[i].localsize) debug_symbol.name[ae->label[i].localsize]=0;
				debug_symbol.v=ae->label[i].ptr;
				ObjectArrayAddDynamicValueConcat((void**)&ae->debug.symbol,&ae->debug.nbsymbol,&ae->debug.maxsymbol,&debug_symbol,sizeof(struct s_debug_symbol));
			}
		}
		for (i=0;i<ae->ialias;i++) {
			if (strcmp(ae->alias[i].alias,"IX") && strcmp(ae->alias[i].alias,"IY")) {
				debug_symbol.name=TxtStrDup(ae->alias[i].alias);
				debug_symbol.v=RoundComputeExpression(ae,ae->alias[i].translation,0,0,0);
				ObjectArrayAddDynamicValueConcat((void**)&ae->debug.symbol,&ae->debug.nbsymbol,&ae->debug.maxsymbol,&debug_symbol,sizeof(struct s_debug_symbol));
			}
		}

		/* export struct */
		*ae->retdebug=MemMalloc(sizeof(struct s_rasm_info));
		memcpy(*ae->retdebug,&ae->debug,sizeof(struct s_rasm_info));
	}
	/*** end debug ***/

	if (ae->enforce_symbol_case) {
		for (i=0;i<ae->ifile;i++) {
			if (ae->rawlen[i]) MemFree(ae->rawfile[i]);
		}
	}

	for (i=0;i<ae->nbbank;i++) {
		MemFree(ae->mem[i]);
	}
	MemFree(ae->mem);
	
	/* expression core buffer free */
	ComputeExpressionCore(NULL,NULL,0,0);
	ExpressionFastTranslate(NULL,NULL,0);
	/* free labels, expression, orgzone, repeat, ... */
	if (ae->mo) MemFree(ae->orgzone);
	if (ae->me) {
		for (i=0;i<ae->ie;i++) {
			if (ae->expression[i].reference) MemFree(ae->expression[i].reference);
			if (ae->expression[i].module) MemFree(ae->expression[i].module);
		}
		MemFree(ae->expression);
	}
	if (ae->nbsave) {
		for (i=0;i<ae->nbsave;i++) {
			if (ae->save[i].filename) MemFree(ae->save[i].filename);
		}
		MemFree(ae->save);
	}
	if (ae->mh) {
		for (i=0;i<ae->ih;i++) {
			//MemFree(ae->hexbin[i].data);
			MemFree(ae->hexbin[i].filename);
		}
		MemFree(ae->hexbin);
	}
	for (i=0;i<ae->il;i++) {
		if (ae->label[i].name && ae->label[i].iw==-1) MemFree(ae->label[i].name);
	}
	/* structures */
	for (i=0;i<ae->irasmstructalias;i++) {
		MemFree(ae->rasmstructalias[i].name);
	}
	if (ae->mrasmstructalias) MemFree(ae->rasmstructalias);
	
	for (i=0;i<ae->irasmstruct;i++) {
		for (j=0;j<ae->rasmstruct[i].irasmstructfield;j++) {
			MemFree(ae->rasmstruct[i].rasmstructfield[j].fullname);
			MemFree(ae->rasmstruct[i].rasmstructfield[j].name);
			if (ae->rasmstruct[i].rasmstructfield[j].mdata) MemFree(ae->rasmstruct[i].rasmstructfield[j].data);
		}
		if (ae->rasmstruct[i].mrasmstructfield) MemFree(ae->rasmstruct[i].rasmstructfield);
		MemFree(ae->rasmstruct[i].name);
	}
	if (ae->mrasmstruct) MemFree(ae->rasmstruct);
	
	/* other */
	if (ae->maxbreakpoint) MemFree(ae->breakpoint);
	if (ae->ml) MemFree(ae->label);
	if (ae->mr) MemFree(ae->repeat);
	if (ae->mi) MemFree(ae->ifthen);
	if (ae->msw) MemFree(ae->switchcase);
	if (ae->mw) MemFree(ae->whilewend);
	if (ae->modulen || ae->module) {
		MemFree(ae->module);
	}
	/* deprecated
	for (i=0;i<ae->idic;i++) {
		MemFree(ae->dico[i].name);
	}
	if (ae->mdic) MemFree(ae->dico);
	*/
	if (ae->mlz) MemFree(ae->lzsection);

	for (i=0;i<ae->ifile;i++) {
		MemFree(ae->filename[i]);
	}
	MemFree(ae->filename);

	for (i=0;i<ae->imacro;i++) {
		if (ae->macro[i].maxword) MemFree(ae->macro[i].wc);
		for (j=0;j<ae->macro[i].nbparam;j++) MemFree(ae->macro[i].param[j]);
		if (ae->macro[i].nbparam) MemFree(ae->macro[i].param);
	}

	
	if (ae->mmacro) MemFree(ae->macro);

	for (i=0;i<ae->igs;i++) {
		if (ae->globalstack[i]) MemFree(ae->globalstack[i]);
	}
	if (ae->mgs) MemFree(ae->globalstack);
	if (ae->lastglobalalloc) {
		MemFree(ae->lastgloballabel);
		ae->lastglobalalloc=0;
		ae->lastgloballabel=NULL;
	}
	/* EDSK + HFE */
	for (i=0;i<ae->nbedskaction;i++) {
		if (ae->edsk_action[i].filename) MemFree(ae->edsk_action[i].filename);
		if (ae->edsk_action[i].filename2) MemFree(ae->edsk_action[i].filename2);
		if (ae->edsk_action[i].filename3) MemFree(ae->edsk_action[i].filename3);
	}
	if (ae->nbedskaction) MemFree(ae->edsk_action);
	for (i=0;i<ae->nbhfeaction;i++) {
		if (ae->hfe_action[i].filename) MemFree(ae->hfe_action[i].filename);
		for (j=0;j<ae->hfe_action[i].iparam;j++) MemFree(ae->hfe_action[i].param[j]);
		if (ae->hfe_action[i].param) MemFree(ae->hfe_action[i].param);
	}
	if (ae->nbhfeaction) MemFree(ae->hfe_action);

	/* external + mapping */
	for (i=0;i<ae->nexternal;i++) {
		if (ae->external[i].mmapping) MemFree(ae->external[i].mapping);
	}
	if (ae->mexternal) MemFree(ae->external);

	for (i=0;i<ae->ialias;i++) {
		MemFree(ae->alias[i].alias);
		MemFree(ae->alias[i].translation);
	}
	if (ae->malias) MemFree(ae->alias);

	for (i=0;ae->wl[i].t!=2;i++) {
		MemFree(ae->wl[i].w);
	}
	MemFree(ae->wl);

	if (ae->ctx1.varbuffer) {
		MemFree(ae->ctx1.varbuffer);
	}
	if (ae->ctx1.maxtokenstack) {
		MemFree(ae->ctx1.tokenstack);
	}
	if (ae->ctx1.maxoperatorstack) {
		MemFree(ae->ctx1.operatorstack);
	}
	if (ae->ctx2.varbuffer) {
		MemFree(ae->ctx2.varbuffer);
	}
	if (ae->ctx2.maxtokenstack) {
		MemFree(ae->ctx2.tokenstack);
	}
	if (ae->ctx2.maxoperatorstack) {
		MemFree(ae->ctx2.operatorstack);
	}

	for (i=0;i<ae->iticker;i++) {
		MemFree(ae->ticker[i].varname);
	}
	if (ae->mticker) MemFree(ae->ticker);

	MemFree(ae->outputfilename);
	FreeLabelTree(ae);
	FreeDicoTree(ae);
	FreeUsedTree(ae);
	if (ae->mmacropos) MemFree(ae->macropos);
	TradExpression(NULL);
	MemFree(ae);
}


/******************************************************************
 * simple function to count errors
 * display source error if requested (@@TODO check for postponed execution)
 * strong exit of Rasm if max error is reached!
******************************************************************/
void MaxError(struct s_assenv *ae)
{
	#undef FUNC
	#define FUNC "MaxError"

	char **source_lines=NULL;
	int zeline;


	/* extended error is useful with generated code we do not want to edit */
	if (ae->extended_error && ae->wl) {
		/* super dupper slow but anyway, there is an error... */
		if (ae->wl[ae->idx].l) {
			source_lines=FileReadLinesRAW(ae,GetCurrentFile(ae));
			zeline=0;
			while (zeline<ae->wl[ae->idx].l-1 && source_lines[zeline]) zeline++;
			if (zeline==ae->wl[ae->idx].l-1 && source_lines[zeline]) {
				rasm_printf(ae,KAYGREEN"-> %s",source_lines[zeline]);
			} else {
				rasm_printf(ae,KERROR"cannot read line %d of file [%s]\n",ae->wl[ae->idx].l,GetCurrentFile(ae));
			}
			FreeArrayDynamicValue(&source_lines);
		}
	}

	ae->nberr++;
	if (ae->nberr==ae->maxerr) {
		rasm_printf(ae,KERROR"Too many errors!\n");
		FreeAssenv(ae);
		exit(ae->nberr);
	}
}

void (*___output)(struct s_assenv *ae, unsigned char v);

void ___internal_output_disabled(struct s_assenv *ae,unsigned char v)
{
	#undef FUNC
	#define FUNC "fake ___output"
}

void ___internal_output_extend(struct s_assenv *ae,unsigned char v)
{
	/* limit exceededn, second chance if crunched section */
	int requested_block;
	int iscrunched=0;
	int i;

	// limit exceed, are we using crunched sections?
	for (i=ae->ilz-1;i>=0;i--) {
		if (ae->lzsection[i].ibank==ae->activebank) {
			iscrunched=1;
			break;
		}
	}

	if (!iscrunched) {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"output exceed limit %04X\n",ae->maxptr);
		ae->stop=1;
		___output=___internal_output_disabled;
		return;
	}

	if (ae->maxptr&0xFFFF) {
		rasm_printf(ae,KWARNING"Warning: Specific limits are not applied  when using crunched sections, cause memory blocks are moved unpredictably\n");
		if (ae->erronwarn) MaxError(ae);
	}

#if TRACE_LZ
	printf("**output exceed limit** extending memory space\n");
#endif
	requested_block=ae->outputadr>>16;
	ae->mem[ae->activebank]=MemRealloc(ae->mem[ae->activebank],(requested_block+1)*65536);
	ae->maxptr=(requested_block+1)*65536;
	// eventually write byte ^_^
	ae->mem[ae->activebank][ae->outputadr++]=v;
	ae->codeadr++;

}
void ___internal_output(struct s_assenv *ae,unsigned char v)
{
	#undef FUNC
	#define FUNC "___output"

	if (ae->outputadr<ae->maxptr) {
		ae->mem[ae->activebank][ae->outputadr++]=v;
		ae->codeadr++;
	} else {
		___internal_output_extend(ae,v);
	}
}
void ___internal_output_nocode(struct s_assenv *ae,unsigned char v)
{
	#undef FUNC
	#define FUNC "___output (nocode)"
	
	if (ae->outputadr<ae->maxptr) {
		/* struct definition always in NOCODE */
		if (ae->getstruct) {
			int irs,irsf;
			irs=ae->irasmstruct-1;
			irsf=ae->rasmstruct[irs].irasmstructfield-1;
			if (irsf>=0) {
#if TRACE_STRUCT
	printf("output_nocode irs=%d irsf=%d idata=%d\n",irs,irsf,ae->rasmstruct[irs].rasmstructfield[irsf].idata);
#endif
				/* ajouter les data du flux au champ de la structure */			
				ObjectArrayAddDynamicValueConcat((void**)&ae->rasmstruct[irs].rasmstructfield[irsf].data,
					&ae->rasmstruct[irs].rasmstructfield[irsf].idata,
					&ae->rasmstruct[irs].rasmstructfield[irsf].mdata,
					&v,sizeof(unsigned char));
			} else {
				rasm_printf(ae,KWARNING"[%s:%d] Warning: Structure field has no reference, did you forget a label?\n",GetCurrentFile(ae),ae->wl[ae->idx].l);
				if (ae->erronwarn) MaxError(ae);
			}
		}
		
		ae->outputadr++;
		ae->codeadr++;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"output exceed limit %04X\n",ae->maxptr);
		ae->stop=1;
		___output=___internal_output_disabled;
	}
}


void ___output_set_limit(struct s_assenv *ae,int zelimit)
{
	#undef FUNC
	#define FUNC "___output_set_limit"

	int limit=65536;
	
	if (zelimit<=limit) {
		/* apply limit */
		limit=zelimit;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"limit exceed hardware limitation!");
		ae->stop=1;
	}
	if (ae->outputadr>=0 && ae->outputadr>=limit) {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"limit too high for current output!");
		ae->stop=1;
	}
	ae->maxptr=limit;
}

unsigned char *MakeAMSDOSHeader(int run, int minmem, int maxmem, char *amsdos_name, int amsdos_user) {
	#undef FUNC
	#define FUNC "MakeAMSDOSHeader"
	
	static unsigned char AmsdosHeader[128];
	int checksum,i=0;
	/***  cpcwiki			
	Byte 00: User number
	Byte 01 to 08: filename
	Byte 09 bis 11: Extension
	Byte 18: type-byte
	Byte 21 and 22: loading address
	Byte 24 and 25: file length
	Byte 26 and 27: execution address for machine code programs
	Byte 64 and 65: (file length)
	Byte 67 and 68: checksum for byte 00 to byte 66
	To calculate the checksum, just add byte 00 to byte 66 to each other.
	*/
	memset(AmsdosHeader,0,sizeof(AmsdosHeader));
	AmsdosHeader[0]=amsdos_user;
	memcpy(AmsdosHeader+1,amsdos_name,11);

	AmsdosHeader[18]=2; /* 0 basic 1 basic protege 2 binaire */
	AmsdosHeader[19]=(maxmem-minmem)&0xFF;
	AmsdosHeader[20]=(maxmem-minmem)>>8;
	AmsdosHeader[21]=minmem&0xFF;
	AmsdosHeader[22]=minmem>>8;
	AmsdosHeader[24]=AmsdosHeader[19];
	AmsdosHeader[25]=AmsdosHeader[20];
	AmsdosHeader[26]=run&0xFF;
	AmsdosHeader[27]=run>>8;
	AmsdosHeader[64]=AmsdosHeader[19];
	AmsdosHeader[65]=AmsdosHeader[20];
	AmsdosHeader[66]=0;
	
	for (i=checksum=0;i<=66;i++) {
		checksum+=AmsdosHeader[i];
	}
	AmsdosHeader[67]=checksum&0xFF;
	AmsdosHeader[68]=checksum>>8;

	/* garbage / shadow values from sector buffer? */
	memcpy(AmsdosHeader+0x47,amsdos_name,8);
	AmsdosHeader[0x4F]=0x24;
	AmsdosHeader[0x50]=0x24;
	AmsdosHeader[0x51]=0x24;
	AmsdosHeader[0x52]=0xFF;
	AmsdosHeader[0x54]=0xFF;
	AmsdosHeader[0x57]=0x02;
	AmsdosHeader[0x5A]=AmsdosHeader[21];
	AmsdosHeader[0x5B]=AmsdosHeader[22];
	AmsdosHeader[0x5D]=AmsdosHeader[24];
	AmsdosHeader[0x5E]=AmsdosHeader[25];

	sprintf((char *)AmsdosHeader+0x47+17," created by %-9.9s ",RASM_SNAP_VERSION);

	return AmsdosHeader;
}

unsigned char *MakeHobetaHeader(int minmem, int maxmem, char *trdos_name) {
	#undef FUNC
	#define FUNC "MakeHobetaHeader"
	
	static unsigned char HobetaHeader[17];
	int i,checksum=0;
	/***  http://rk.nvg.ntnu.no/sinclair/faq/fileform.html#HOBETA			
   0x00     FileName     0x08      TR-DOS file name
   0x08     FileType     0x01      TR-DOS file type
   0x09     StartAdr     0x02      start address of file
   0x0A     FlLength     0x02      length of file (in bytes)  -> /!\ wrong offset!!!
   0x0C     FileSize     0x02      size of file (in sectors) 
   0x0E     HdrCRC16     0x02      Control checksum of the 15 byte
                                   header (not sector data!)
   */
	memset(HobetaHeader,0,sizeof(HobetaHeader));

	strncpy((char*)&HobetaHeader[0],trdos_name,8);
	HobetaHeader[8]='C';
	HobetaHeader[0x9]=(maxmem-minmem)&0xFF;
	HobetaHeader[0xA]=(maxmem-minmem)>>8;
	
	HobetaHeader[0xB]=(maxmem-minmem)&0xFF;
	HobetaHeader[0xC]=(maxmem-minmem)>>8;
	
	HobetaHeader[0xD]=((maxmem-minmem)+255)>>8;
	HobetaHeader[0xE]=0;
	
	for (i=0;i<0xF;i++) checksum+=HobetaHeader[i]*257+i;
	
	HobetaHeader[0xF]=checksum&0xFF;
	HobetaHeader[0x10]=(checksum>>8)&0xFF;

	return HobetaHeader;
}


int cmpAmsdosentry(const void * a, const void * b)
{
	return memcmp(a,b,32);
}

int cmprelocation(const void * a, const void * b)
{
	struct s_external_mapping *sa,*sb;
	sa=(struct s_external_mapping *)a;
	sb=(struct s_external_mapping *)b;
	if (sa->ptr<sb->ptr) return -1; else return 1;
}
int cmpmacros(const void * a, const void * b)
{
	struct s_macro *sa,*sb;
	sa=(struct s_macro *)a;
	sb=(struct s_macro *)b;
	if (sa->crc<sb->crc) return -1; else return 1;
}
int SearchAlias(struct s_assenv *ae, int crc, char *zemot)
{
    int dw,dm,du,i;

	dw=0;
	du=ae->ialias-1;
	while (dw<=du) {
		dm=(dw+du)>>1;
		if (ae->alias[dm].crc==crc) {
			/* chercher le premier de la liste */
			while (dm>0 && ae->alias[dm-1].crc==crc) dm--;
			/* controle sur le texte entier */
			while (ae->alias[dm].crc==crc && strcmp(ae->alias[dm].alias,zemot)) dm++;
			if (ae->alias[dm].crc==crc && strcmp(ae->alias[dm].alias,zemot)==0) {
				ae->alias[dm].used++;
//printf("[%s] found => [%s]\n",zemot,ae->alias[dm].translation);
				return dm;
			} else return -1;
		} else if (ae->alias[dm].crc>crc) {
			du=dm-1;
		} else if (ae->alias[dm].crc<crc) {
			dw=dm+1;
		}
	}
//printf("not found\n");
	return -1;
}
int SearchMacro(struct s_assenv *ae, int crc, char *zemot)
{
	int dw,dm,du,i;

	dw=0;
	du=ae->imacro-1;
	while (dw<=du) {
		dm=(dw+du)>>1;
		if (ae->macro[dm].crc==crc) {
			/* chercher le premier de la liste */
			while (dm>0 && ae->macro[dm-1].crc==crc) dm--;
			/* controle sur le texte entier */
			while (ae->macro[dm].crc==crc && strcmp(ae->macro[dm].mnemo,zemot)) dm++;
			if (ae->macro[dm].crc==crc && strcmp(ae->macro[dm].mnemo,zemot)==0) return dm; else return -1;
		} else if (ae->macro[dm].crc>crc) {
			du=dm-1;
		} else if (ae->macro[dm].crc<crc) {
			dw=dm+1;
		}
	}
	return -1;
}

void CheckAndSortAliases(struct s_assenv *ae)
{
	#undef FUNC
	#define FUNC "CheckAndSortAliases"

	struct s_alias tmpalias;
	int i,dw,dm=0,du,crc;
	for (i=0;i<ae->ialias-1;i++) {
		/* is there previous aliases in the new alias? */
		if (strstr(ae->alias[ae->ialias-1].translation,ae->alias[i].alias)) {
			/* there is a match, apply alias translation */
			ExpressionFastTranslate(ae,&ae->alias[ae->ialias-1].translation,2);
			/* need to compute again len */
			ae->alias[ae->ialias-1].len=strlen(ae->alias[ae->ialias-1].translation);
			break;
		}
	}
	
	/* cas particuliers pour insertion en début ou fin de liste */
	if (ae->ialias-1) {
		if (ae->alias[ae->ialias-1].crc>ae->alias[ae->ialias-2].crc) {
			/* pas de tri il est déjà au bon endroit */
		} else if (ae->alias[ae->ialias-1].crc<ae->alias[0].crc) {
			/* insertion tout en bas de liste */
			tmpalias=ae->alias[ae->ialias-1];
			MemMove(&ae->alias[1],&ae->alias[0],sizeof(struct s_alias)*(ae->ialias-1));
			ae->alias[0]=tmpalias;
		} else {
			/* on cherche ou inserer */
			crc=ae->alias[ae->ialias-1].crc;
			dw=0;
			du=ae->ialias-1;
			while (dw<=du) {
				dm=(dw+du)/2;
				if (ae->alias[dm].crc==crc) {
					break;
				} else if (ae->alias[dm].crc>crc) {
					du=dm-1;
				} else if (ae->alias[dm].crc<crc) {
					dw=dm+1;
				}
			}
			/* ajustement */
			if (ae->alias[dm].crc<crc) dm++;
			/* insertion */
			tmpalias=ae->alias[ae->ialias-1];
			MemMove(&ae->alias[dm+1],&ae->alias[dm],sizeof(struct s_alias)*(ae->ialias-1-dm));
			ae->alias[dm]=tmpalias;
		}
	} else {
		/* one alias need no sort */
	}
}

void InsertDicoToTree(struct s_assenv *ae, struct s_expr_dico *dico)
{
	#undef FUNC
	#define FUNC "InsertDicoToTree"

	struct s_crcdico_tree *curdicotree;
	int radix,dek=16;
 
	if ((curdicotree=ae->dicotree[(dico->crc>>16)&0xFFFF])==NULL) { //@@FAST
		curdicotree=MemMalloc(sizeof(struct s_crcdico_tree));
		memset(curdicotree,0,sizeof(struct s_crcdico_tree));
		ae->dicotree[(dico->crc>>16)&0xFFFF]=curdicotree;
	}
	while (dek) {
		dek=dek-8;
		radix=(dico->crc>>dek)&0xFF;
		if (curdicotree->radix[radix]) {
			curdicotree=curdicotree->radix[radix];
		} else {
			curdicotree->radix[radix]=MemMalloc(sizeof(struct s_crcdico_tree));
			curdicotree=curdicotree->radix[radix];
			memset(curdicotree,0,sizeof(struct s_crcdico_tree));
		}
	}
	ObjectArrayAddDynamicValueConcat((void**)&curdicotree->dico,&curdicotree->ndico,&curdicotree->mdico,dico,sizeof(struct s_expr_dico));
}

unsigned char *SnapshotDicoInsert(char *symbol_name, int ptr, int *retidx)
{
	static unsigned char *subchunk=NULL;
	static int subchunksize=0;
	static int idx=0;
	int symbol_len;
	
	if (retidx) {
		if (symbol_name && strcmp(symbol_name,"FREE")==0) {
			subchunksize=0;
			idx=0;
			MemFree(subchunk);
			subchunk=NULL;
		}
		*retidx=idx;
		return subchunk;
	}
	
	if (idx+65536>subchunksize) {
		subchunksize=subchunksize+65536;
		subchunk=MemRealloc(subchunk,subchunksize);
	}
	
	symbol_len=strlen(symbol_name);
	if (symbol_len>255) symbol_len=255;
	subchunk[idx++]=symbol_len;
	memcpy(subchunk+idx,symbol_name,symbol_len);
	idx+=symbol_len;
	memset(subchunk+idx,0,6);
	idx+=6;
	subchunk[idx++]=(ptr&0xFF00)/256;
	subchunk[idx++]=ptr&0xFF;
	return NULL;
}

void SnapshotDicoTreeRecurse(struct s_crcdico_tree *lt)
{
	#undef FUNC
	#define FUNC "SnapshottDicoTreeRecurse"

	int i;

	for (i=0;i<256;i++) {
		if (lt->radix[i]) {
			SnapshotDicoTreeRecurse(lt->radix[i]);
		}
	}
	if (lt->mdico) {
		for (i=0;i<lt->ndico;i++) {
			if (strcmp(lt->dico[i].name,"IX") && strcmp(lt->dico[i].name,"IY") && strcmp(lt->dico[i].name,"PI") && strcmp(lt->dico[i].name,"ASSEMBLER_RASM")) {
				SnapshotDicoInsert(lt->dico[i].name,(int)floor(lt->dico[i].v+0.5),NULL);
			}
		}
	}
}
unsigned char *SnapshotDicoTree(struct s_assenv *ae, int *retidx)
{
	#undef FUNC
	#define FUNC "SnapshotDicoTree"

	unsigned char *sc;
	int idx;
	int i;

	for (i=0;i<65536;i++) {
		if (ae->dicotree[i]) {
			SnapshotDicoTreeRecurse(ae->dicotree[i]);
		}
	}
	
	sc=SnapshotDicoInsert(NULL,0,&idx);
	*retidx=idx;
	return sc;
}

void WarnLabelTreeRecurse(struct s_assenv *ae, struct s_crclabel_tree *lt)
{
	#undef FUNC
	#define FUNC "WarnLabelTreeRecurse"

	int i;

	for (i=0;i<256;i++) {
		if (lt->radix[i]) {
			WarnLabelTreeRecurse(ae,lt->radix[i]);
		}
	}
	for (i=0;i<lt->nlabel;i++) {
		if (!lt->label[i].used) {
			if (!lt->label[i].name) {
				rasm_printf(ae,KWARNING"[%s:%d] Warning: label %s declared but not used\n",ae->filename[lt->label[i].fileidx],lt->label[i].fileline,ae->wl[lt->label[i].iw].w);
				if (ae->erronwarn) MaxError(ae);
			} else {
				rasm_printf(ae,KWARNING"[%s:%d] Warning: label %s declared but not used\n",ae->filename[lt->label[i].fileidx],lt->label[i].fileline,lt->label[i].name);
				if (ae->erronwarn) MaxError(ae);
			}
		}
	}
}
void WarnLabelTree(struct s_assenv *ae)
{
	#undef FUNC
	#define FUNC "WarnLabelTree"

	int i;

	for (i=0;i<65536;i++) {
		if (ae->labeltree[i]) {
			WarnLabelTreeRecurse(ae,ae->labeltree[i]);
		}
	}
}
void WarnDicoTreeRecurse(struct s_assenv *ae, struct s_crcdico_tree *lt)
{
	#undef FUNC
	#define FUNC "WarnDicoTreeRecurse"

	int i;


	for (i=0;i<256;i++) {
		if (lt->radix[i]) {
			WarnDicoTreeRecurse(ae,lt->radix[i]);
		}
	}
	for (i=0;i<lt->ndico;i++) {
		if (strcmp(lt->dico[i].name,"IX") && strcmp(lt->dico[i].name,"IY") && strcmp(lt->dico[i].name,"PI") && strcmp(lt->dico[i].name,"ASSEMBLER_RASM") && !lt->dico[i].used) {
			rasm_printf(ae,KWARNING"[%s:%d] Warning: variable %s declared but not used\n",ae->filename[ae->wl[lt->dico[i].iw].ifile],ae->wl[lt->dico[i].iw].l,lt->dico[i].name);
				if (ae->erronwarn) MaxError(ae);
		}
	}
}
void WarnDicoTree(struct s_assenv *ae)
{
	#undef FUNC
	#define FUNC "ExportDicoTree"

	int i;

	for (i=0;i<65536;i++) {
		if (ae->dicotree[i]) {
			WarnDicoTreeRecurse(ae,ae->dicotree[i]);
		}
	}
}
void ExportDicoTreeRecurse(struct s_crcdico_tree *lt, char *zefile, char *zeformat)
{
	#undef FUNC
	#define FUNC "ExportDicoTreeRecurse"

	char symbol_line[1024];
	int i;

	for (i=0;i<256;i++) {
		if (lt->radix[i]) {
			ExportDicoTreeRecurse(lt->radix[i],zefile,zeformat);
		}
	}
	if (lt->mdico) {
		for (i=0;i<lt->ndico;i++) {
			if (strcmp(lt->dico[i].name,"IX") && strcmp(lt->dico[i].name,"IY") && strcmp(lt->dico[i].name,"PI") && strcmp(lt->dico[i].name,"ASSEMBLER_RASM") && lt->dico[i].autorise_export) {
				snprintf(symbol_line,sizeof(symbol_line)-1,zeformat,lt->dico[i].name,(int)floor(lt->dico[i].v+0.5));
				symbol_line[sizeof(symbol_line)-1]=0xD;
				FileWriteLine(zefile,symbol_line);
			}
		}
	}
}
void ExportDicoTreeRecurseCase(struct s_assenv *ae,struct s_crcdico_tree *lt, char *zefile, char *zeformat)
{
	#undef FUNC
	#define FUNC "ExportDicoTreeRecurseCase"

	char symbol_line[512];
	char symbol_name[512];
	int i;

	for (i=0;i<256;i++) {
		if (lt->radix[i]) {
			ExportDicoTreeRecurseCase(ae,lt->radix[i],zefile,zeformat);
		}
	}
	if (lt->mdico) {
		for (i=0;i<lt->ndico;i++) {
			if (strcmp(lt->dico[i].name,"IX") && strcmp(lt->dico[i].name,"IY") && strcmp(lt->dico[i].name,"PI") && strcmp(lt->dico[i].name,"ASSEMBLER_RASM") && lt->dico[i].autorise_export) {
				// case search
				char *casefound;
				int namelen;

				if ((casefound=_internal_stristr(ae->rawfile[ae->wl[lt->dico[i].iw].ifile],ae->rawlen[ae->wl[lt->dico[i].iw].ifile],lt->dico[i].name))!=NULL) {
					namelen=strlen(lt->dico[i].name);
					if (namelen>511) namelen=511;
					memcpy(symbol_name,casefound,namelen);
					symbol_name[namelen]=0;
					snprintf(symbol_line,sizeof(symbol_line)-1,zeformat,symbol_name,(int)floor(lt->dico[i].v+0.5));
				} else {
					snprintf(symbol_line,sizeof(symbol_line)-1,zeformat,lt->dico[i].name,(int)floor(lt->dico[i].v+0.5));
				}
				symbol_line[sizeof(symbol_line)-1]=0xD;
				FileWriteLine(zefile,symbol_line);
			}
		}
	}
}
void ExportDicoTree(struct s_assenv *ae, char *zefile, char *zeformat)
{
	#undef FUNC
	#define FUNC "ExportDicoTree"

	int i;

	if (!ae->enforce_symbol_case) {
		for (i=0;i<65536;i++) {
			if (ae->dicotree[i]) {
				ExportDicoTreeRecurse(ae->dicotree[i],zefile,zeformat);
			}
		}
	} else {
		for (i=0;i<65536;i++) {
			if (ae->dicotree[i]) {
				ExportDicoTreeRecurseCase(ae,ae->dicotree[i],zefile,zeformat);
			}
		}
	}
}
void FreeDicoTreeRecurse(struct s_crcdico_tree *lt)
{
	#undef FUNC
	#define FUNC "FreeDicoTreeRecurse"

	int i;

	for (i=0;i<256;i++) {
		if (lt->radix[i]) {
			FreeDicoTreeRecurse(lt->radix[i]);
		}
	}
	if (lt->mdico) {
		for (i=0;i<lt->ndico;i++) {
			MemFree(lt->dico[i].name);
		}
		MemFree(lt->dico);
	}
	MemFree(lt);
}
void FreeDicoTree(struct s_assenv *ae)
{
	#undef FUNC
	#define FUNC "FreeDicoTree"

	int i;

	for (i=0;i<65536;i++) {
		if (ae->dicotree[i]) {
			FreeDicoTreeRecurse(ae->dicotree[i]);
		}
	}
}
struct s_expr_dico *SearchDico(struct s_assenv *ae, char *dico, int crc)
{
	#undef FUNC
	#define FUNC "SearchDico"

	struct s_crcdico_tree *curdicotree;
	int i,radix,dek=16;

	if ((curdicotree=ae->dicotree[(crc>>16)&0xFFFF])==NULL) return NULL; //@@FAST

	while (dek) {
		dek=dek-8;
		radix=(crc>>dek)&0xFF;
		if (curdicotree->radix[radix]) {
			curdicotree=curdicotree->radix[radix];
		} else {
			/* radix not found, dico is not in index */
			return NULL;
		}
	}
	for (i=0;i<curdicotree->ndico;i++) {
		if (strcmp(curdicotree->dico[i].name,dico)==0) {
			curdicotree->dico[i].used++;

			if (curdicotree->dico[i].external) {
				if (ae->external_mapping_size) {
					/* outside crunched section of in intermediate section */
					if (ae->lz<1 || ae->lzsection[ae->ilz-1].lzversion==0) {
						// add mapping
						struct s_external_mapping mapping;
						int iex;
						mapping.iorgzone=ae->io-1;
						mapping.ptr=ae->outputadr;
						mapping.size=ae->external_mapping_size;
						for (iex=0;iex<ae->nexternal;iex++) {
							if (ae->external[iex].crc==crc && strcmp(ae->external[iex].name,dico)==0) {
	//printf("add mapping for [%s] ptr=%d size=%d\n",dico,mapping.ptr,mapping.size);
								ObjectArrayAddDynamicValueConcat((void **)&ae->external[iex].mapping,&ae->external[iex].imapping,&ae->external[iex].mmapping,&mapping,sizeof(mapping));
								break;
							}
						}
					} else {
						MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"cannot use external variable [%s] inside a crunched section!\n",dico);
					}
				} else {
					MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"invalid usage of external variable [%s]\n",dico);
				}
			}

			return &curdicotree->dico[i];
		}
	}
	return NULL;
}
int DelDico(struct s_assenv *ae, char *dico, int crc)
{
	#undef FUNC
	#define FUNC "DelDico"

	struct s_crcdico_tree *curdicotree;
	int i,radix,dek=16;

	if ((curdicotree=ae->dicotree[(crc>>16)&0xFFFF])==NULL) return 0; //@@FAST

	while (dek) {
		dek=dek-8;
		radix=(crc>>dek)&0xFF;
		if (curdicotree->radix[radix]) {
			curdicotree=curdicotree->radix[radix];
		} else {
			/* radix not found, dico is not in index */
			return 0;
		}
	}
	for (i=0;i<curdicotree->ndico;i++) {
		if (strcmp(curdicotree->dico[i].name,dico)==0) {
			/* must free memory */
			MemFree(curdicotree->dico[i].name);
			if (i<curdicotree->ndico-1) {
				MemMove(&curdicotree->dico[i],&curdicotree->dico[i+1],(curdicotree->ndico-i-1)*sizeof(struct s_expr_dico));
			}
			curdicotree->ndico--;
			return 1;
		}
	}
	return 0;
}


void InsertUsedToTree(struct s_assenv *ae, char *used, int crc)
{
	#undef FUNC
	#define FUNC "InsertUsedToTree"

	struct s_crcused_tree *curusedtree;
	int radix,dek=16,i;
	
	if ((curusedtree=ae->usedtree[(crc>>16)&0xFFFF])==NULL) { //@@FAST
		curusedtree=MemMalloc(sizeof(struct s_crcused_tree));
		memset(curusedtree,0,sizeof(struct s_crcused_tree));
		ae->usedtree[(crc>>16)&0xFFFF]=curusedtree;
	}

	while (dek) {
		dek=dek-8;
		radix=(crc>>dek)&0xFF;
		if (curusedtree->radix[radix]) {
			curusedtree=curusedtree->radix[radix];
		} else {
			curusedtree->radix[radix]=MemMalloc(sizeof(struct s_crcused_tree));
			curusedtree=curusedtree->radix[radix];
			memset(curusedtree,0,sizeof(struct s_crcused_tree));
		}
	}
	for (i=0;i<curusedtree->nused;i++) if (strcmp(used,curusedtree->used[i])==0) break;
	/* no double */
	if (i==curusedtree->nused) {
		FieldArrayAddDynamicValueConcat(&curusedtree->used,&curusedtree->nused,&curusedtree->mused,used);
	}
}

void FreeUsedTreeRecurse(struct s_crcused_tree *lt)
{
	#undef FUNC
	#define FUNC "FreeUsedTreeRecurse"

	int i;

	for (i=0;i<256;i++) {
		if (lt->radix[i]) {
			FreeUsedTreeRecurse(lt->radix[i]);
		}
	}
	if (lt->mused) {
		for (i=0;i<lt->nused;i++) MemFree(lt->used[i]);
		MemFree(lt->used);
	}
	MemFree(lt);
}
void FreeUsedTree(struct s_assenv *ae)
{
	#undef FUNC
	#define FUNC "FreeUsedTree"

	int i;

	for (i=0;i<65536;i++) {
		if (ae->usedtree[i]) {
			FreeUsedTreeRecurse(ae->usedtree[i]);
		}
	}
}
int SearchUsed(struct s_assenv *ae, char *used, int crc)
{
	#undef FUNC
	#define FUNC "SearchUsed"

	struct s_crcused_tree *curusedtree;
	int i,radix,dek=16;

	if ((curusedtree=ae->usedtree[(crc>>16)&0xFFFF])==NULL) return 0; //@@FAST

	while (dek) {
		dek=dek-8;
		radix=(crc>>dek)&0xFF;
		if (curusedtree->radix[radix]) {
			curusedtree=curusedtree->radix[radix];
		} else {
			/* radix not found, used is not in index */
			return 0;
		}
	}
	for (i=0;i<curusedtree->nused;i++) {
		if (strcmp(curusedtree->used[i],used)==0) {
			return 1;
		}
	}
	return 0;
}



void InsertTextToTree(struct s_assenv *ae, char *text, char *replace, int crc)
{
	#undef FUNC
	#define FUNC "InsertTextToTree"

	struct s_crcstring_tree *curstringtree;
	int radix,dek=32,i;
	
	curstringtree=&ae->stringtree;
	while (dek) {
		dek=dek-8;
		radix=(crc>>dek)&0xFF;
		if (curstringtree->radix[radix]) {
			curstringtree=curstringtree->radix[radix];
		} else {
			curstringtree->radix[radix]=MemMalloc(sizeof(struct s_crcused_tree));
			curstringtree=curstringtree->radix[radix];
			memset(curstringtree,0,sizeof(struct s_crcused_tree));
		}
	}
	for (i=0;i<curstringtree->ntext;i++) if (strcmp(text,curstringtree->text[i])==0) break;
	/* no double */
	if (i==curstringtree->ntext) {
		text=TxtStrDup(text);
		replace=TxtStrDup(replace);
		FieldArrayAddDynamicValueConcat(&curstringtree->text,&curstringtree->ntext,&curstringtree->mtext,text);
		FieldArrayAddDynamicValueConcat(&curstringtree->replace,&curstringtree->nreplace,&curstringtree->mreplace,replace);
	}
}

void FreeTextTreeRecurse(struct s_crcstring_tree *lt)
{
	#undef FUNC
	#define FUNC "FreeTextTreeRecurse"

	int i;

	for (i=0;i<256;i++) {
		if (lt->radix[i]) {
			FreeTextTreeRecurse(lt->radix[i]);
		}
	}
	if (lt->mtext) {
		for (i=0;i<lt->ntext;i++) MemFree(lt->text[i]);
		MemFree(lt->text);
	}
	MemFree(lt);
}
void FreeTextTree(struct s_assenv *ae)
{
	#undef FUNC
	#define FUNC "FreeTextTree"

	int i;

	for (i=0;i<256;i++) {
		if (ae->stringtree.radix[i]) {
			FreeTextTreeRecurse(ae->stringtree.radix[i]);
		}
	}
	if (ae->stringtree.mtext) MemFree(ae->stringtree.text);
}
int SearchText(struct s_assenv *ae, char *text, int crc)
{
	#undef FUNC
	#define FUNC "SearchText"

	struct s_crcstring_tree *curstringtree;
	int i,radix,dek=32;

	curstringtree=&ae->stringtree;
	while (dek) {
		dek=dek-8;
		radix=(crc>>dek)&0xFF;
		if (curstringtree->radix[radix]) {
			curstringtree=curstringtree->radix[radix];
		} else {
			/* radix not found, used is not in index */
			return 0;
		}
	}
	for (i=0;i<curstringtree->ntext;i++) {
		if (strcmp(curstringtree->text[i],text)==0) {
			return 1;
		}
	}
	return 0;
}



void FreeLabelTreeRecurse(struct s_crclabel_tree *lt)
{
	#undef FUNC
	#define FUNC "FreeLabelTreeRecurse"

	int i;

	for (i=0;i<256;i++) {
		if (lt->radix[i]) {
			FreeLabelTreeRecurse(lt->radix[i]);
		}
	}
	/* label.name already freed elsewhere as this one is a copy */
	if (lt->mlabel) MemFree(lt->label);
	MemFree(lt);
}
void FreeLabelTree(struct s_assenv *ae)
{
	#undef FUNC
	#define FUNC "FreeLabelTree"

	int i;

	for (i=0;i<65536;i++) {
		if (ae->labeltree[i]) {
			FreeLabelTreeRecurse(ae->labeltree[i]);
		}
	}
	//if (ae->labeltree.mlabel) MemFree(ae->labeltree.label);
}

struct s_label *SearchLabel(struct s_assenv *ae, char *label, int crc)
{
	#undef FUNC
	#define FUNC "SearchLabel"

	struct s_crclabel_tree *curlabeltree;
	int i,radix,dek=16;

	if ((curlabeltree=ae->labeltree[(crc>>16)&0xFFFF])==NULL) return NULL; //@@FAST

	while (dek) {
		dek=dek-8;
		radix=(crc>>dek)&0xFF;
		if (curlabeltree->radix[radix]) {
			curlabeltree=curlabeltree->radix[radix];
		} else {
			/* radix not found, label is not in index */
			return NULL;
		}
	}

#define PUSH_LABEL_OBJ		/* outside crunched section of in intermediate section */ \
				if (ae->buildobj && ae->external_mapping_size==2) \
				if (ae->lz<1 || ae->lzsection[ae->ilz-1].lzversion==0) { \
					/* add mapping */ \
					struct s_external_mapping mapping; \
					mapping.iorgzone=ae->io-1; mapping.ptr=ae->outputadr; mapping.size=2; mapping.value=curlabeltree->label[i].ptr; \
					printf("add mapping for label [%s] ptr=%d size=%d value=%d\n",label,mapping.ptr,mapping.size,mapping.value); \
					ObjectArrayAddDynamicValueConcat((void**)&ae->relocation,&ae->imapping,&ae->mmapping,&mapping,sizeof(mapping)); }

	for (i=0;i<curlabeltree->nlabel;i++) {
		if (!curlabeltree->label[i].name && strcmp(ae->wl[curlabeltree->label[i].iw].w,label)==0) {
			//PUSH_LABEL_OBJ;
			curlabeltree->label[i].used++;
			return &curlabeltree->label[i];
		} else if (curlabeltree->label[i].name && strcmp(curlabeltree->label[i].name,label)==0) {
			//PUSH_LABEL_OBJ;
			curlabeltree->label[i].used++;
			return &curlabeltree->label[i];
		}
	}
	return NULL;
}

char *MakeLocalLabel(struct s_assenv *ae,char *varbuffer, int *retdek)
{
	#undef FUNC
	#define FUNC "MakeLocalLabel"
	
	char *locallabel;
	char hexdigit[32];
	int lenbuf=0,dek,i,im;
	char *zepoint;

	lenbuf=strlen(varbuffer);
	
	/* not so local labels */
	if (varbuffer[0]=='.') {
		/* create reference */
		if (ae->lastgloballabel) {
			locallabel=MemMalloc(strlen(varbuffer)+1+ae->lastgloballabellen);
			sprintf(locallabel,"%s%s",ae->lastgloballabel,varbuffer);
			if (retdek) *retdek=0;
			return locallabel;
		} else {
			if (retdek) *retdek=0;
			return TxtStrDup(varbuffer);
		}
	}

	/***************************************************
	without retdek -> build a local label
	with    retdek -> build the hash string
	***************************************************/	
	if (!retdek) {
		locallabel=MemMalloc(lenbuf+(ae->ir+ae->iw+3)*8+8);
		zepoint=strchr(varbuffer,'.');
		if (zepoint) {
			*zepoint=0;
		}
		strcpy(locallabel,varbuffer);
	} else {
		locallabel=MemMalloc((ae->ir+ae->iw+3)*8+4);
		locallabel[0]=0;
	}	
//printf("locallabel=[%s] (draft)\n",locallabel);

	dek=0;
	dek+=strappend(locallabel,"R");
	for (i=0;i<ae->ir;i++) {
		sprintf(hexdigit,"%04X",ae->repeat[i].cpt);
		dek+=strappend(locallabel,hexdigit);
	}
	if (ae->ir) {
		sprintf(hexdigit,"%04X",ae->repeat[ae->ir-1].value);
		dek+=strappend(locallabel+dek,hexdigit);
	}
	
	dek+=strappend(locallabel,"W");
	for (i=0;i<ae->iw;i++) {
		sprintf(hexdigit,"%04X",ae->whilewend[i].cpt);
		dek+=strappend(locallabel+dek,hexdigit);
	}
	if (ae->iw) {
		sprintf(hexdigit,"%04X",ae->whilewend[ae->iw-1].value);
		dek+=strappend(locallabel+dek,hexdigit);
	}
	/* where are we? */
	if (ae->imacropos) {
		for (im=ae->imacropos-1;im>=0;im--) {
			if (ae->idx>=ae->macropos[im].start && ae->idx<ae->macropos[im].end) break;
		}
		if (im>=0) {
			/* si on n'est pas dans une macro, on n'indique rien */
			sprintf(hexdigit,"M%04X",ae->macropos[im].value);
			dek+=strappend(locallabel+dek,hexdigit);
		}
	}
	if (!retdek) {
		if (zepoint) {
			*zepoint='.';
			strcat(locallabel+dek,zepoint);
		}
	} else {
		*retdek=dek;
	}
//printf("locallabel=[%s] (end)\n",locallabel);
	return locallabel;
}

char *TradExpression(char *zexp)
{
	#undef FUNC
	#define FUNC "TradExpression"
	
	static char *last_expression=NULL;
	char *wstr;
	
	if (last_expression) {MemFree(last_expression);last_expression=NULL;}
	if (!zexp) return NULL;
	
	wstr=TxtStrDup(zexp);
	wstr=TxtReplace(wstr,"[","<<",0);
	wstr=TxtReplace(wstr,"]",">>",0);
	wstr=TxtReplace(wstr,"m","%",0);

	last_expression=wstr;
	return wstr;
}

int TrimFloatingPointString(char *fps) {
	int i=0,pflag,zflag=0;
	
	while (fps[i]) {
		if (fps[i]=='.') {
			pflag=i;
			zflag=1;
		} else if (fps[i]!='0') {
			zflag=0;
		}
		i++;
	}
	/* truncate floating fract */
	if (zflag) {
		fps[pflag]=0;
	} else {
		pflag=i;
	}
	return pflag;
}



/*
	translate tag or formula between curly brackets
	used in label declaration
	used in print directive
*/
char *TranslateTag(struct s_assenv *ae, char *varbuffer, int *touched, int enablefast, int tagoption) {
	/*******************************************************
	       v a r i a b l e s     i n    s t r i n g s
	*******************************************************/
	char *starttag,*endtag,*tagcheck,*expr;
	int newlen,lenw,taglen,tagidx,tagcount,validx;
	char curvalstr[256]={0};


//printf("TranslateTag [%s]\n",varbuffer);

	if (tagoption & E_TAGOPTION_PRESERVE) {
		if (ae->iw || ae->ir) {
			/* inside a loop we must care about variables */
//printf("TranslateTag [%s] with PRESERVE inside a loop!\n",varbuffer);
			return varbuffer;
		}
	}

	*touched=0;
	while ((starttag=strchr(varbuffer+1,'{'))!=NULL) {
		if ((endtag=strchr(starttag,'}'))==NULL) {
			MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"invalid tag in string [%s]\n",varbuffer);
			return NULL;
		}
		/* allow inception */
		tagcount=1;
		tagcheck=starttag+1;
		while (*tagcheck && tagcount) {
			if (*tagcheck=='}') tagcount--; else if (*tagcheck=='{') tagcount++;
			tagcheck++;			
		}
		if (tagcount) {
			MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"invalid brackets combination in string [%s]\n",varbuffer);
			return NULL;
		} else {
			endtag=tagcheck-1;
		}
		*touched=1;
		taglen=endtag-starttag+1;
		tagidx=starttag-varbuffer;
		lenw=strlen(varbuffer); // before the EOF write
		*endtag=0;
		/*** c o m p u t e    e x p r e s s i o n ***/
		expr=TxtStrDup(starttag+1);
		if (tagoption & E_TAGOPTION_REMOVESPACE) expr=TxtReplace(expr," ","",0);
		if (enablefast) ExpressionFastTranslate(ae,&expr,0);
		validx=(int)RoundComputeExpressionCore(ae,expr,ae->codeadr,0);
		if (validx<0) {
			strcpy(curvalstr,"");
			MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"indexed tag must NOT be a negative value [%s]\n",varbuffer);
			MemFree(expr);
			return NULL;
		} else {
			#ifdef OS_WIN
			snprintf(curvalstr,sizeof(curvalstr)-1,"%d",validx);
			newlen=strlen(curvalstr);
			#else
			newlen=snprintf(curvalstr,sizeof(curvalstr)-1,"%d",validx);
			#endif
		}
		MemFree(expr);
		if (newlen>taglen) {
			/* realloc */
			varbuffer=MemRealloc(varbuffer,lenw+newlen-taglen+1);
		}
		if (newlen!=taglen ) {
			MemMove(varbuffer+tagidx+newlen,varbuffer+tagidx+taglen,lenw-taglen-tagidx+1);
		}
		strncpy(varbuffer+tagidx,curvalstr,newlen); /* copy without zero terminator */
	}

	return varbuffer;
}

#define CRC_HALT	0xD7D1BFA1
#define CRC_NOP		0xE1830165
#define CRC_LDI		0xE18B3F51
#define CRC_LDD		0xE18B3F4C
#define CRC_DEC		0xE06BDD44
#define CRC_INC		0xE19F3B52
#define CRC_CPI		0xE077C754
#define CRC_CPD		0xE077C74F
#define CRC_BIT		0xE073D557
#define CRC_RES		0xE1B32D62
#define CRC_SET		0xE1B71164
#define CRC_CCF		0xE0742D44
#define CRC_IND		0xE19F3B53
#define CRC_INI		0xE19F3B58
#define CRC_DAA		0xE068253E
#define CRC_CPL		0xE077C757
#define CRC_EI		0x4BD5DD06
#define CRC_DI		0x4BD5DF05
#define CRC_IM		0x4BD5250E
#define CRC_SCF		0xE1B72D54
#define CRC_NEG		0xE1833D52
#define CRC_OUTI	0xEFA5F1B9
#define CRC_OUTD	0xEFA5F1B4
#define CRC_OUT		0xE1871170
#define CRC_IN		0x4BD5250F

#define CRC_RLA		0xE1B31F57
#define CRC_RLCA	0x878DAD9A
#define CRC_RRCA	0x87A5B5A0
#define CRC_RRA		0xE1B30B5D
#define CRC_RLD		0xE1B31F5A
#define CRC_RRD		0xE1B30B60
#define CRC_RST		0xE1B30971
#define CRC_RR		0x4BD5331C
#define CRC_RL		0x4BD53316
#define CRC_RRC		0xE1B30B5F
#define CRC_RLC		0xE1B31F59
#define CRC_SLA		0xE1B71F58
#define CRC_SLL		0xE1B71F63
#define CRC_SRA		0xE1B70B5E
#define CRC_SRL		0xE1B70B69

#define CRC_ADD		0xE07C2F41
#define CRC_ADC		0xE07C2F40
#define CRC_SBC		0xE1B72B50
#define CRC_SUB		0xE1B77162
#define CRC_XOR		0xE1DB3971
#define CRC_AND		0xE07FDB4B
#define CRC_OR		0x4BD52919
#define CRC_CP		0x4BD5D10B

#define CRC_PUSH	0x97A1EDB8
#define CRC_POP		0xE1BB1967

#define CRC_CALL	0x826B994
#define CRC_JR		0x4BD52314
#define CRC_JP		0x4BD52312
#define CRC_DJNZ	0x37CD7BAE
#define CRC_RET		0xE1B32D63
#define CRC_RETN	0x87E9EBB1
#define CRC_RETI	0x87E9EBAC

#define CRC_LD		0x4BD52F08

#define CRC_EX		0x4BD5DD15
#define CRC_EXX		0xE06FF76D
#define CRC_LDIR	0xF7F59DA3
#define CRC_LDDR	0xF7F5A79E
#define CRC_INIR	0xDFE98BAA
#define CRC_INDR	0xDFE99DA5
#define CRC_OTIR	0xEFB9D7B6
#define CRC_OTDR	0xEFB9A1B1
#define CRC_CPIR	0xFF96FA6
#define CRC_CPDR	0xFF959A1



int __GETNOP(struct s_assenv *ae,char *oplist, int didx)
{
	#undef FUNC
	#define FUNC "__GETNOP"

	int idx=0,crc,tick=0;
	char **opcode=NULL;
	char *opref;

	/* upper case */
	while (oplist[idx]) {
		oplist[idx]=toupper(oplist[idx]);
		idx++;
	}
	/* duplicata */
	opref=TxtStrDup(oplist);
	/* clean-up */
	TxtReplace(opref,"\t"," ",0);
	TxtReplace(opref,"  "," ",1);
	TxtReplace(opref,": ",":",1);
	/* simplify extended registers to XL or IX */
	TxtReplace(opref,"IY","IX",0);
	TxtReplace(opref,"IXL","XL",0);
	TxtReplace(opref,"IXH","XL",0);
	TxtReplace(opref,"LX","XL",0);
	TxtReplace(opref,"HX","XL",0);
	TxtReplace(opref,"LY","XL",0);
	TxtReplace(opref,"HY","XL",0);
	TxtReplace(opref,"YL","XL",0);
	TxtReplace(opref,"XH","XL",0);
	TxtReplace(opref,"YH","XL",0);

	/* count opcodes */
	opcode=TxtSplitWithChar(opref,':');

	idx=0;
	while (opcode[idx]) {
		char *zeopcode,*terminator,*zearg=NULL;
		char **listarg;

		zeopcode=opcode[idx];
		/* trim */
		while (*zeopcode==' ') zeopcode++;
		terminator=zeopcode;
		while (*terminator!=0 && *terminator!=' ') terminator++;
		if (*terminator) {
			zearg=terminator+1;
			*terminator=0;
			/* no space in args */
			TxtReplace(zearg," ","",1);
		}
		if (!zeopcode[0]) {idx++;continue;}
		crc=GetCRC(zeopcode);

		/*************************************
		* very simple and simplified parsing *
		*************************************/
		switch (crc) {
			case CRC_RLA:
			case CRC_RLCA:
			case CRC_RRCA:
			case CRC_RRA:
			case CRC_NOP:
			case CRC_CCF:
			case CRC_DAA:
			case CRC_SCF:
			case CRC_CPL:
			case CRC_EXX:
			case CRC_EI:
			case CRC_DI:tick+=1;break;

			case CRC_IM:
			case CRC_NEG:tick+=2;break;

			case CRC_RST:
			case CRC_RETN:
			case CRC_RETI:
			case CRC_CPDR:
			case CRC_CPIR:
			case CRC_CPD:
			case CRC_CPI:tick+=4;break;

			case CRC_RLD:
			case CRC_RRD:
			case CRC_LDD:
			case CRC_LDI:
			case CRC_OUTI:
			case CRC_OUTD:
			case CRC_LDIR:
			case CRC_LDDR:
			case CRC_INIR:
			case CRC_INDR:
			case CRC_OTIR:
			case CRC_OTDR:
			case CRC_IND:
			case CRC_INI:tick+=5;break;

			case CRC_EX:
				if (zearg) {
					if (strstr(zearg,"AF") || strstr(zearg,"DE")) tick+=1; else
					if (strstr(zearg,"(SP)") && strstr(zearg,"HL")) tick+=6; else
					if (strstr(zearg,"(SP)") && strstr(zearg,"IX")) tick+=7;
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETNOP, see documentation about this directive\n",opcode[idx]);
				}
				break;

			case CRC_PUSH:
				if (zearg) {
					if (strcmp(zearg,"IX")==0) tick+=5; else tick+=4;
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETNOP, see documentation about this directive\n",opcode[idx]);
				}
				break;

			case CRC_POP:
				if (zearg) {
					if (strcmp(zearg,"IX")==0) tick+=4; else tick+=3;
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETNOP, see documentation about this directive\n",opcode[idx]);
				}
				break;

			case CRC_SLA:
			case CRC_SLL:
			case CRC_SRA:
			case CRC_SRL:
			case CRC_RL:
			case CRC_RLC:
			case CRC_RR:
			case CRC_RRC:
				if (zearg) {
					if (strstr(zearg,"(HL)")) tick+=4; else
					if (strstr(zearg,"(IX")) tick+=7; else
						tick+=2;
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETNOP, see documentation about this directive\n",opcode[idx]);
				}
				break;

			case CRC_OUT:
			case CRC_IN:
				if (zearg) {
					if (strstr(zearg,"(C)")) tick+=4; else tick+=3;
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETNOP, see documentation about this directive\n",opcode[idx]);
				}
				break;

			case CRC_ADD:
			     if (zearg) {
					/* simplify deprecated notation */
					TxtReplace(zearg,"A,","",0);
					if (strcmp(zearg,"IX,BC")==0 || strcmp(zearg,"IX,DE")==0 || strcmp(zearg,"IX,IX")==0 || strcmp(zearg,"IX,SP")==0) tick+=4; else
					if (strcmp(zearg,"HL,BC")==0 || strcmp(zearg,"HL,DE")==0 || strcmp(zearg,"HL,HL")==0 || strcmp(zearg,"HL,SP")==0) tick+=3; else
					if (strstr(zearg,"(HL)") || strcmp(zearg,"XL")==0) tick+=2; else
					if (strstr(zearg,"(IX")) tick+=5; else
					if ((*zearg>='A' && *zearg<='E') || *zearg=='H' || *zearg=='L') tick+=1; else tick+=2;
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETNOP, see documentation about this directive\n",opcode[idx]);
				}
				break;

			/* ADC/SBC/SUB/XOR/AND/OR */
			case CRC_ADC:
			case CRC_SBC:
				if (zearg) {
					/* simplify deprecated notation */
					TxtReplace(zearg,"A,","",0);
					if (strcmp(zearg,"HL,BC")==0 || strcmp(zearg,"HL,DE")==0 ||strcmp(zearg,"HL,HL")==0 ||strcmp(zearg,"HL,SP")==0) {tick+=4;break;}
				}
			case CRC_SUB:
				/* simplify deprecated notation */
				TxtReplace(zearg,"A,","",0);
			case CRC_XOR:
			case CRC_AND:
			case CRC_OR:
			case CRC_CP:
			     if (zearg) {
					if (strstr(zearg,"(HL)") || strcmp(zearg,"XL")==0) tick+=2; else
					if (strstr(zearg,"(IX")) tick+=5; else
					if ((*zearg>='A' && *zearg<='E') || *zearg=='H' || *zearg=='L') tick+=1; else tick+=2;
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETNOP, see documentation about this directive\n",opcode[idx]);
				}
				break;

			/* BIT/RES/SET */
			case CRC_BIT:
				if (strstr(zearg,"(HL)")) tick+=3; else
				if (strstr(zearg,"(IX")) tick+=6; else tick+=2;
				break;
			case CRC_RES:
			case CRC_SET:
				if (strstr(zearg,"(HL)")) tick+=4; else
				if (strstr(zearg,"(IX")) tick+=7; else tick+=2;
				break;
			case CRC_DEC:
			case CRC_INC:
				if (strcmp(zearg,"XL")==0 || strcmp(zearg,"SP")==0 || strcmp(zearg,"BC")==0
				     || strcmp(zearg,"DE")==0 || strcmp(zearg,"HL")==0)
					     tick+=2;
				else if (strcmp(zearg,"IX")==0 || strcmp(zearg,"(HL)")==0)
						tick+=3;
				else if (strncmp(zearg,"(IX",3)==0)
						tick+=6;
				else tick++;
				break;
			case CRC_JP:
				// JP is supposed to loop!
				if (zearg) {
					if (strstr(zearg,"IX"))
						tick+=2;
					else if (strstr(zearg,"HL"))
						tick+=1;
					else tick+=3;
				} else tick+=3;
				break;
			case CRC_DJNZ:
				// DJNZ is supposed to loop!
				tick+=4;
				break;
			case CRC_CALL:
				// CALL is supposed to skip! (or not...) @@TODO les conditioooooooons
			case CRC_JR:
				// JR is supposed to loop!
				tick+=3;
				break;
			case CRC_RET:
				// conditionnal RET shorter because it's supposed to be the exit!
				if (!zearg) tick+=3; else tick+=2;
				break;

			case CRC_LD:
				/* big cake! */
				if (zearg && strchr(zearg,',')) {
					int crc1,crc2;

					/* split args */
					listarg=TxtSplitWithChar(zearg,',');
					crc1=GetCRC(listarg[0]);
					crc2=GetCRC(listarg[1]);

					switch (crc1) {
						case CRC_I:
						case CRC_R:
							switch (crc2) {
								case CRC_A:
									tick+=3;
									break;
								default:
									MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported LD %s,%s for GETNOP, see documentation\n",listarg[0],listarg[1]);
							}
							break;
						case CRC_A:
						case CRC_B:
						case CRC_C:
						case CRC_D:
						case CRC_E:
						case CRC_H:
						case CRC_L:
							switch (crc2) {
								case CRC_A:
								case CRC_B:
								case CRC_C:
								case CRC_D:
								case CRC_E:
								case CRC_H:
								case CRC_L:
									tick++;
									break;
								case CRC_I:
								case CRC_R:
									if (crc1==CRC_A) tick+=3; else
									MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported LD %s,%s for GETNOP, see documentation\n",listarg[0],listarg[1]);
									break;
								case CRC_MBC:
								case CRC_MDE:
									if (crc1!=CRC_A) {
										MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported LD %s,%s for GETNOP, see documentation\n",listarg[0],listarg[1]);
										break;
									}
								case CRC_XL:
								case CRC_MHL:
									tick+=2;
									break;
								default:
									/* MIX + memory + value */
									if (strncmp(listarg[1],"(IX",3)==0) {
										tick+=5;
									} else if (listarg[1][0]=='(' && listarg[1][strlen(listarg[1])-1]==')') {
										/* memory */
										if (crc1==CRC_A) {
										tick+=4;
										} else {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported LD %s,%s for GETNOP, see documentation\n",listarg[0],listarg[1]);
										}
									} else {
										/* numeric value as default */
										tick+=2;
									}
							}
							break;

						case CRC_XL:
							switch (crc2) {
								case CRC_A:
								case CRC_B:
								case CRC_C:
								case CRC_D:
								case CRC_E:
								case CRC_H:
								case CRC_L:
									tick+=2;
									break;
								case CRC_XL:
									tick+=2;
									break;
								default:
									/* value */
									tick+=3;
							}
							break;

						case CRC_BC:
						case CRC_DE:
							/* memory / value */
							if (listarg[1][0]=='(' && listarg[1][strlen(listarg[1])-1]==')') tick+=6; else tick+=3;
							break;
						case CRC_HL:
							/* memory / value */
							if (listarg[1][0]=='(' && listarg[1][strlen(listarg[1])-1]==')') tick+=5; else tick+=3;
							break;
						case CRC_SP:
							if (crc2==CRC_HL) {
								tick+=2;
							} else if (crc2==CRC_IX) {
								/* IX */
								tick+=3;
							} else if (listarg[1][0]=='(' && listarg[1][strlen(listarg[1])-1]==')') {
								/* memory */
								tick+=6;
							} else tick+=3;
							break;
						case CRC_IX:
							/* memory / value */
							if (listarg[1][0]=='(' && listarg[1][strlen(listarg[1])-1]==')') tick+=6; else tick+=4;
							break;

						case CRC_MBC:
						case CRC_MDE:
							if (crc2==CRC_A) {
								tick+=2;
							} else {
								MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported LD %s,%s for GETNOP, see documentation\n",listarg[0],listarg[1]);
							}
							break;
						case CRC_MHL:
							switch (crc2) {
								case CRC_A:
								case CRC_B:
								case CRC_C:
								case CRC_D:
								case CRC_E:
								case CRC_H:
								case CRC_L:
									tick+=2;
									break;
								default:
									tick+=3;
									break;
							}
							break;
						default:
							if (strncmp(listarg[0],"(IX",3)==0) {
								/* MIX */
								switch (crc2) {
									case CRC_A:
									case CRC_B:
									case CRC_C:
									case CRC_D:
									case CRC_E:
									case CRC_H:
									case CRC_L:tick+=5;break;
									default:tick+=6;
								}
							} else if (listarg[0][0]=='(' && listarg[0][strlen(listarg[0])-1]==')') {
								/* memory */
								switch (crc2) {
									case CRC_A:tick+=4;break;
									case CRC_HL:tick+=5;break;
									case CRC_BC:
									case CRC_DE:
									case CRC_SP:
									case CRC_IX:tick+=6;break;
									default:
										MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported LD %s,%s for GETNOP, see documentation\n",listarg[0],listarg[1]);
								}
							} else {
								MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported LD %s,%s for GETNOP, see documentation\n",listarg[0],listarg[1]);
							}
					}
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode LD for GETNOP, need 2 arguments [%s]\n",zearg);
				}
				break;

			default: 
				MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETNOP, see documentation about this directive\n",opcode[idx]);
		}
		idx++;
	}
	MemFree(opref);
	if (opcode) MemFree(opcode);
	return tick;
}
int __GETTICK(struct s_assenv *ae,char *oplist, int didx)
{
	#undef FUNC
	#define FUNC "__GETTICK"

	int idx=0,crc,tick=0;
	char **opcode=NULL;
	char *opref;

	/* upper case */
	while (oplist[idx]) {
		oplist[idx]=toupper(oplist[idx]);
		idx++;
	}
	/* duplicata */
	opref=TxtStrDup(oplist);
	/* clean-up */
	TxtReplace(opref,"\t"," ",0);
	TxtReplace(opref,"  "," ",1);
	TxtReplace(opref,": ",":",1);
	/* simplify extended registers to XL or IX */
	TxtReplace(opref,"IY","IX",0);
	TxtReplace(opref,"IXL","XL",0);
	TxtReplace(opref,"IXH","XL",0);
	TxtReplace(opref,"LX","XL",0);
	TxtReplace(opref,"HX","XL",0);
	TxtReplace(opref,"LY","XL",0);
	TxtReplace(opref,"HY","XL",0);
	TxtReplace(opref,"YL","XL",0);
	TxtReplace(opref,"XH","XL",0);
	TxtReplace(opref,"YH","XL",0);

	/* count opcodes */
	opcode=TxtSplitWithChar(opref,':');

	idx=0;
	while (opcode[idx]) {
		char *zeopcode,*terminator,*zearg=NULL;
		char **listarg;

		zeopcode=opcode[idx];
		/* trim */
		while (*zeopcode==' ') zeopcode++;
		terminator=zeopcode;
		while (*terminator!=0 && *terminator!=' ') terminator++;
		if (*terminator) {
			zearg=terminator+1;
			*terminator=0;
			/* no space in args */
			TxtReplace(zearg," ","",1);
		}
		if (!zeopcode[0]) {idx++;continue;}
		crc=GetCRC(zeopcode);

		/*************************************
		* very simple and simplified parsing *
		*************************************/
		switch (crc) {
			case CRC_RLA:
			case CRC_RLCA:
			case CRC_RRCA:
			case CRC_RRA:
			case CRC_NOP:
			case CRC_CCF:
			case CRC_DAA:
			case CRC_SCF:
			case CRC_CPL:
			case CRC_EXX:
			case CRC_EI:
			case CRC_DI:tick+=4;break;

			case CRC_IM:
			case CRC_NEG:tick+=8;break;

			case CRC_RST:tick+=11;break;

			case CRC_RETN:
			case CRC_RETI:tick+=14;break;

			case CRC_CPIR:
			case CRC_CPDR:
			case CRC_CPD:
			case CRC_CPI:
			case CRC_OUTI:
			case CRC_OUTD:
			case CRC_LDD:
			case CRC_LDI:
			case CRC_LDIR:
			case CRC_LDDR:
			case CRC_INIR:
			case CRC_INDR:
			case CRC_OTIR:
			case CRC_OTDR:
			case CRC_IND:
			case CRC_INI:tick+=16;break;

			case CRC_RLD:
			case CRC_RRD:tick+=18;break;

			case CRC_EX:
				if (zearg) {
					if (strstr(zearg,"AF") || strstr(zearg,"DE")) tick+=4; else
					if (strstr(zearg,"(SP)") && strstr(zearg,"HL")) tick+=19; else
					if (strstr(zearg,"(SP)") && strstr(zearg,"IX")) tick+=23;
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETTICK, see documentation about this directive\n",opcode[idx]);
				}
				break;

			case CRC_PUSH:
				if (zearg) {
					if (strcmp(zearg,"IX")==0) tick+=15; else tick+=11;
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETTICK, see documentation about this directive\n",opcode[idx]);
				}
				break;

			case CRC_POP:
				if (zearg) {
					if (strcmp(zearg,"IX")==0) tick+=14; else tick+=10;
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETTICK, see documentation about this directive\n",opcode[idx]);
				}
				break;

			case CRC_SLA:
			case CRC_SLL:
			case CRC_SRA:
			case CRC_SRL:
			case CRC_RL:
			case CRC_RLC:
			case CRC_RR:
			case CRC_RRC:
				if (zearg) {
					if (strstr(zearg,"(HL)")) tick+=15; else
					if (strstr(zearg,"(IX")) tick+=23; else
						tick+=8;
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETTICK, see documentation about this directive\n",opcode[idx]);
				}
				break;

			case CRC_OUT:
				if (zearg) {
					if (strstr(zearg,"(C),")) tick+=12; else tick+=11;
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETTICK, see documentation about this directive\n",opcode[idx]);
				}
				break;
			case CRC_IN:
				if (zearg) {
					if (strstr(zearg,"(C)")) tick+=12; else tick+=11;
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETTICK, see documentation about this directive\n",opcode[idx]);
				}
				break;

			case CRC_ADD:
			     if (zearg) {
					/* simplify deprecated notation */
					TxtReplace(zearg,"A,","",0);
					if (strcmp(zearg,"IX,BC")==0 || strcmp(zearg,"IX,DE")==0 || strcmp(zearg,"IX,IX")==0 || strcmp(zearg,"IX,SP")==0) tick+=15; else
					if (strcmp(zearg,"HL,BC")==0 || strcmp(zearg,"HL,DE")==0 || strcmp(zearg,"HL,HL")==0 || strcmp(zearg,"HL,SP")==0) tick+=11; else
					if (strstr(zearg,"(HL)")) tick+=7; else
					if (strstr(zearg,"(IX")) tick+=19; else
					if (strstr(zearg,"XL")) tick+=8; else
					if ((*zearg>='A' && *zearg<='E') || *zearg=='H' || *zearg=='L') tick+=4; else tick+=7;
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETTICK, see documentation about this directive\n",opcode[idx]);
				}
				break;

			/* ADC/SBC/SUB/XOR/AND/OR */
			case CRC_ADC:
			case CRC_SBC:
				if (zearg) {
					/* simplify deprecated notation */
					TxtReplace(zearg,"A,","",0);
					if (strcmp(zearg,"HL,BC")==0 || strcmp(zearg,"HL,DE")==0 ||strcmp(zearg,"HL,HL")==0 ||strcmp(zearg,"HL,SP")==0) {tick+=15;break;}
				}
			case CRC_SUB:
			     if (zearg) {
					/* simplify deprecated notation */
					TxtReplace(zearg,"A,","",0);
				}
			case CRC_XOR:
			case CRC_AND:
			case CRC_OR:
			case CRC_CP:
			     if (zearg) {
					if (strstr(zearg,"(HL)")) tick+=7; else
					if (strstr(zearg,"(IX")) tick+=19; else
					if (strstr(zearg,"XL")) tick+=8; else
					if ((*zearg>='A' && *zearg<='E') || *zearg=='H' || *zearg=='L') tick+=4; else tick+=7;
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETTICK, see documentation about this directive\n",opcode[idx]);
				}
				break;

			/* BIT/RES/SET */
			case CRC_BIT:
				if (strstr(zearg,"(HL)")) tick+=12; else
				if (strstr(zearg,"(IX")) tick+=20; else tick+=8;
				break;
			case CRC_RES:
			case CRC_SET:
				if (strstr(zearg,"(HL)")) tick+=15; else
				if (strstr(zearg,"(IX")) tick+=23; else tick+=8;
				break;
			case CRC_DEC:
			case CRC_INC:
				if (strcmp(zearg,"XL")==0) tick+=8;
				else if (strcmp(zearg,"SP")==0 || strcmp(zearg,"BC")==0 || strcmp(zearg,"DE")==0 || strcmp(zearg,"HL")==0) tick+=6;
				else if (strcmp(zearg,"IX")==0) tick+=10;
				else if (strcmp(zearg,"(HL)")==0) tick+=11;
				else if (strncmp(zearg,"(IX",3)==0) tick+=23;
				else tick+=4;
				break;
			case CRC_JP:
				// JP is supposed to loop!
				if (zearg) {
					if (strstr(zearg,"IX"))
						tick+=8;
					else if (strstr(zearg,"HL"))
						tick+=4;
					else tick+=10;
				} else tick+=10;
				break;
			case CRC_DJNZ:
				// DJNZ is supposed to loop!
				tick+=13;
				break;
			case CRC_CALL:
				// CALL is supposed to skip!
				tick+=10;
				break;
			case CRC_JR:
				// JR is supposed to loop!
				tick+=12;
				break;
			case CRC_RET:
				// conditionnal RET shorter because it's supposed to be the exit!
				if (!zearg) tick+=10; else tick+=5;
				break;

			case CRC_LD:
				/* big cake! */
				if (zearg && strchr(zearg,',')) {
					int crc1,crc2;

					/* split args */
					listarg=TxtSplitWithChar(zearg,',');
					crc1=GetCRC(listarg[0]);
					crc2=GetCRC(listarg[1]);

					switch (crc1) {
						case CRC_I:
						case CRC_R:
							switch (crc2) {
								case CRC_A:
									tick+=9;
									break;
								default:
									MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported LD %s,%s for GETTICK, see documentation\n",listarg[0],listarg[1]);
							}
							break;
						case CRC_A:
						case CRC_B:
						case CRC_C:
						case CRC_D:
						case CRC_E:
						case CRC_H:
						case CRC_L:
							switch (crc2) {
								case CRC_A:
								case CRC_B:
								case CRC_C:
								case CRC_D:
								case CRC_E:
								case CRC_H:
								case CRC_L:
									tick+=4;
									break;
								case CRC_I:
								case CRC_R:
									if (crc1==CRC_A) tick+=9; else
									MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported LD %s,%s for GETTICK, see documentation\n",listarg[0],listarg[1]);
									break;
								case CRC_MBC:
								case CRC_MDE:
									if (crc1!=CRC_A) {
										MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported LD %s,%s for GETTICK, see documentation\n",listarg[0],listarg[1]);
										break;
									}
								case CRC_MHL:
									tick+=7;
									break;
								case CRC_XL:
									tick+=8;
									break;
								default:
									/* MIX + memory + value */
									if (strncmp(listarg[1],"(IX",3)==0) {
										tick+=19;
									} else if (listarg[1][0]=='(' && listarg[1][strlen(listarg[1])-1]==')') {
										/* memory */
										if (crc1==CRC_A) {
										tick+=13;
										} else {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported LD %s,%s for GETTICK, see documentation\n",listarg[0],listarg[1]);
										}
									} else {
										/* numeric value as default */
										tick+=7;
									}
							}
							break;

						case CRC_XL:
							switch (crc2) {
								case CRC_A:
								case CRC_B:
								case CRC_C:
								case CRC_D:
								case CRC_E:
								case CRC_H:
								case CRC_L:
								case CRC_XL:
									tick+=8;
									break;
								default:
									/* value */
									tick+=11;
							}
							break;

						case CRC_BC:
						case CRC_DE:
							/* memory / value */
							if (listarg[1][0]=='(' && listarg[1][strlen(listarg[1])-1]==')') tick+=20; else tick+=10;
							break;
						case CRC_HL:
							/* memory / value */
							if (listarg[1][0]=='(' && listarg[1][strlen(listarg[1])-1]==')') tick+=16; else tick+=10;
							break;
						case CRC_SP:
							if (crc2==CRC_HL) {
								tick+=6;
							} else if (crc2==CRC_IX) {
								/* IX */
								tick+=10;
							} else if (listarg[1][0]=='(' && listarg[1][strlen(listarg[1])-1]==')') {
								/* memory */
								tick+=20;
							} else tick+=10;
							break;
						case CRC_IX:
							/* memory / value */
							if (listarg[1][0]=='(' && listarg[1][strlen(listarg[1])-1]==')') tick+=20; else tick+=14;
							break;

						case CRC_MBC:
						case CRC_MDE:
							if (crc2==CRC_A) {
								tick+=7;
							} else {
								MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported LD %s,%s for GETTICK, see documentation\n",listarg[0],listarg[1]);
							}
							break;
						case CRC_MHL:
							switch (crc2) {
								case CRC_A:
								case CRC_B:
								case CRC_C:
								case CRC_D:
								case CRC_E:
								case CRC_H:
								case CRC_L:
									tick+=7;
									break;
								default:
									tick+=10;
									break;
							}
							break;
						default:
							if (strncmp(listarg[0],"(IX",3)==0) {
								/* MIX */
								switch (crc2) {
									case CRC_A:
									case CRC_B:
									case CRC_C:
									case CRC_D:
									case CRC_E:
									case CRC_H:
									case CRC_L:tick+=19;break;
									default:tick+=23;
								}
							} else if (listarg[0][0]=='(' && listarg[0][strlen(listarg[0])-1]==')') {
								/* memory */
								switch (crc2) {
									case CRC_A:tick+=13;break;
									case CRC_HL:tick+=16;break;
									case CRC_BC:
									case CRC_DE:
									case CRC_SP:
									case CRC_IX:tick+=20;break;
									default:
										MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported LD %s,%s for GETTICK, see documentation\n",listarg[0],listarg[1]);
								}
							} else {
								MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported LD %s,%s for GETTICK, see documentation\n",listarg[0],listarg[1]);
							}
					}
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode LD for GETTICK, need 2 arguments [%s]\n",zearg);
				}
				break;

			default: 
				MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETTICK, see documentation about this directive\n",opcode[idx]);
		}
		idx++;
	}
	MemFree(opref);
	if (opcode) MemFree(opcode);
	return tick;
}
int __IS_REGISTER(struct s_assenv *ae,char *argstr)
{
	#undef FUNC
	#define FUNC "__IS_REGISTER"

	int idx=0;

	/* upper case */
	while (argstr[idx]) {
		argstr[idx]=toupper(argstr[idx]);
		idx++;
	}

	return IsRegister(argstr);
}
int __GETSIZE(struct s_assenv *ae,char *oplist, int didx)
{
	#undef FUNC
	#define FUNC "__GETSIZE"

	int idx=0,crc,osize=0;
	char **opcode=NULL;
	char *opref;

	/* upper case */
	while (oplist[idx]) {
		oplist[idx]=toupper(oplist[idx]);
		idx++;
	}
	/* duplicata */
	opref=TxtStrDup(oplist);
	/* clean-up */
	TxtReplace(opref,"\t"," ",0);
	TxtReplace(opref,"  "," ",1);
	TxtReplace(opref,": ",":",1);
	/* simplify extended registers to XL or IX */
	TxtReplace(opref,"IY","IX",0);
	TxtReplace(opref,"IXL","XL",0);
	TxtReplace(opref,"IXH","XL",0);
	TxtReplace(opref,"LX","XL",0);
	TxtReplace(opref,"HX","XL",0);
	TxtReplace(opref,"LY","XL",0);
	TxtReplace(opref,"HY","XL",0);
	TxtReplace(opref,"YL","XL",0);
	TxtReplace(opref,"XH","XL",0);
	TxtReplace(opref,"YH","XL",0);

	/* count opcodes */
	opcode=TxtSplitWithChar(opref,':');

	idx=0;
	while (opcode[idx]) {
		char *zeopcode,*terminator,*zearg=NULL;
		char **listarg;

		zeopcode=opcode[idx];
		/* trim */
		while (*zeopcode==' ') zeopcode++;
		terminator=zeopcode;
		while (*terminator!=0 && *terminator!=' ') terminator++;
		if (*terminator) {
			zearg=terminator+1;
			*terminator=0;
			/* no space in args */
			TxtReplace(zearg," ","",1);
		}
		if (!zeopcode[0]) {idx++;continue;}
		crc=GetCRC(zeopcode);

		/*************************************
		* very simple and simplified parsing *
		*************************************/
		switch (crc) {
			case CRC_HALT:
			case CRC_RLA:
			case CRC_RLCA:
			case CRC_RRCA:
			case CRC_RRA:
			case CRC_NOP:
			case CRC_CCF:
			case CRC_DAA:
			case CRC_SCF:
			case CRC_CPL:
			case CRC_EXX:
			case CRC_EI:
			case CRC_RST:
			case CRC_RET:
			case CRC_DI:osize+=1;break;

			case CRC_OUT:
			case CRC_IN:
			case CRC_LDD:
			case CRC_LDI:
			case CRC_LDIR:
			case CRC_LDDR:
			case CRC_CPDR:
			case CRC_CPIR:
			case CRC_CPD:
			case CRC_CPI:
			case CRC_RETN:
			case CRC_RETI:
			case CRC_OUTI:
			case CRC_OUTD:
			case CRC_INIR:
			case CRC_INDR:
			case CRC_OTIR:
			case CRC_OTDR:
			case CRC_IND:
			case CRC_INI:
			case CRC_RLD:
			case CRC_RRD:
			case CRC_IM:
			case CRC_DJNZ:
			case CRC_JR:
			case CRC_NEG:osize+=2;break;

			case CRC_CALL:osize+=3;break;

			case CRC_EX:
				if (zearg) {
					if (strstr(zearg,"AF") || strstr(zearg,"DE")) osize+=1; else
					if (strstr(zearg,"(SP)") && strstr(zearg,"HL")) osize+=1; else
					if (strstr(zearg,"(SP)") && strstr(zearg,"IX")) osize+=2;
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETSIZE, see documentation about this directive\n",opcode[idx]);
				}
				break;

			case CRC_PUSH:
				if (zearg) {
					if (strcmp(zearg,"IX")==0) osize+=2; else osize+=1;
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETSIZE, see documentation about this directive\n",opcode[idx]);
				}
				break;

			case CRC_POP:
				if (zearg) {
					if (strcmp(zearg,"IX")==0) osize+=2; else osize+=1;
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETSIZE, see documentation about this directive\n",opcode[idx]);
				}
				break;

			case CRC_SLA:
			case CRC_SLL:
			case CRC_SRA:
			case CRC_SRL:
			case CRC_RL:
			case CRC_RLC:
			case CRC_RR:
			case CRC_RRC:
				if (zearg) {
					if (strstr(zearg,"(HL)")) osize+=2; else
					if (strstr(zearg,"(IX")) osize+=4; else
						osize+=2;
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETSIZE, see documentation about this directive\n",opcode[idx]);
				}
				break;


			case CRC_ADD:
			     if (zearg) {
					/* simplify deprecated notation */
					TxtReplace(zearg,"A,","",0);
					if (strcmp(zearg,"IX,")==0 || strcmp(zearg,"XL")==0) osize+=2; else
					if (strstr(zearg,"(IX")) osize+=3; else
					if (strstr(zearg,"HL") || (*zearg>='A' && *zearg<='E') || *zearg=='H' || *zearg=='L') osize+=1; else osize+=2;
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETSIZE, see documentation about this directive\n",opcode[idx]);
				}
				break;

			/* ADC/SBC/SUB/XOR/AND/OR */
			case CRC_ADC:
			case CRC_SBC:
				if (zearg) {
					/* simplify deprecated notation */
					TxtReplace(zearg,"A,","",0);
					if (strcmp(zearg,"HL,BC")==0 || strcmp(zearg,"HL,DE")==0 || strcmp(zearg,"HL,HL")==0 || strcmp(zearg,"HL,SP")==0) {osize+=2;break;}
				}
			case CRC_SUB:
				/* simplify deprecated notation */
				TxtReplace(zearg,"A,","",0);
			case CRC_XOR:
			case CRC_AND:
			case CRC_OR:
			case CRC_CP:
			     if (zearg) {
					if (strstr(zearg,"(IX")) osize+=3; else
					if (strcmp(zearg,"XL")==0) osize+=2; else
					if (strcmp(zearg,"(HL)")==0 || (*zearg>='A' && *zearg<='E') || *zearg=='H' || *zearg=='L') osize+=1; else osize+=2;
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETSIZE, see documentation about this directive\n",opcode[idx]);
				}
				break;

			/* BIT/RES/SET */
			case CRC_BIT:
			case CRC_RES:
			case CRC_SET:
				if (strstr(zearg,"(IX")) osize+=4; else osize+=2;
				break;
			case CRC_DEC:
			case CRC_INC:
				if (strcmp(zearg,"(HL)")==0 || strcmp(zearg,"SP")==0 || strcmp(zearg,"BC")==0
				     || strcmp(zearg,"DE")==0 || strcmp(zearg,"HL")==0)
					     osize+=1;
				else if (strcmp(zearg,"IX")==0 || strcmp(zearg,"XL")==0)
						osize+=2;
				else if (strncmp(zearg,"(IX",3)==0)
						osize+=3;
				else osize++;
				break;
			case CRC_JP:
				// JP is supposed to loop!
				if (zearg) {
					if (strstr(zearg,"IX"))
						osize+=2;
					else if (strstr(zearg,"HL"))
						osize+=1;
					else osize+=3;
				} else osize+=3;
				break;

			case CRC_LD:
				/* big cake! */
				if (zearg && strchr(zearg,',')) {
					int crc1,crc2;

					/* split args */
					listarg=TxtSplitWithChar(zearg,',');
					crc1=GetCRC(listarg[0]);
					crc2=GetCRC(listarg[1]);

					switch (crc1) {
						case CRC_I:
						case CRC_R:
							switch (crc2) {
								case CRC_A:
									osize+=2;
									break;
								default:
									MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported LD %s,%s for GETSIZE, see documentation\n",listarg[0],listarg[1]);
							}
							break;
						case CRC_A:
						case CRC_B:
						case CRC_C:
						case CRC_D:
						case CRC_E:
						case CRC_H:
						case CRC_L:
							switch (crc2) {
								// heading +1
								case CRC_MBC:
								case CRC_MDE:
									if (crc1!=CRC_A) {
										MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported LD %s,%s for GETSIZE, see documentation\n",listarg[0],listarg[1]);
										break;
									}
								case CRC_A:
								case CRC_B:
								case CRC_C:
								case CRC_D:
								case CRC_E:
								case CRC_H:
								case CRC_L:
								case CRC_MHL:
									osize++;
									break;
								case CRC_I:
								case CRC_R:
									if (crc1==CRC_A) osize+=2; else
									MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported LD %s,%s for GETSIZE, see documentation\n",listarg[0],listarg[1]);
									break;
								case CRC_XL:
									osize+=2;
									break;
								default:
									/* MIX + memory + value */
									if (strncmp(listarg[1],"(IX",3)==0) {
										osize+=3;
									} else if (listarg[1][0]=='(' && listarg[1][strlen(listarg[1])-1]==')') {
										/* absolute memory address */
										if (crc1==CRC_A) {
											osize+=3;
										} else {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported LD %s,%s for GETSIZE, see documentation\n",listarg[0],listarg[1]);
										}
									} else {
										/* numeric value as default */
										osize+=2;
									}
							}
							break;

						case CRC_XL:
							switch (crc2) {
								case CRC_A:
								case CRC_B:
								case CRC_C:
								case CRC_D:
								case CRC_E:
								case CRC_H:
								case CRC_L://legal???
								case CRC_XL:
									osize+=2;
									break;
								default:
									/* value */
									osize+=3;
							}
							break;

						case CRC_BC:
						case CRC_DE:
							/* memory / value */
							if (listarg[1][0]=='(' && listarg[1][strlen(listarg[1])-1]==')') osize+=4; else osize+=3;
							break;
						case CRC_HL:
							/* memory / value */
							osize+=3;
							break;
						case CRC_SP:
							if (crc2==CRC_HL) {
								osize+=1;
							} else if (crc2==CRC_IX) {
								/* IX */
								osize+=2;
							} else if (listarg[1][0]=='(' && listarg[1][strlen(listarg[1])-1]==')') {
								/* memory */
								osize+=4;
							} else osize+=3; /* value */
							break;
						case CRC_IX:
							/* memory / value */
							osize+=4;
							break;

						case CRC_MBC:
						case CRC_MDE:
							if (crc2==CRC_A) {
								osize+=1;
							} else {
								MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported LD %s,%s for GETSIZE, see documentation\n",listarg[0],listarg[1]);
							}
							break;
						case CRC_MHL:
							switch (crc2) {
								case CRC_A:
								case CRC_B:
								case CRC_C:
								case CRC_D:
								case CRC_E:
								case CRC_H:
								case CRC_L:
									osize+=1;
									break;
								default:
									osize+=2; /* value */
									break;
							}
							break;
						default:
							if (strncmp(listarg[0],"(IX",3)==0) {
								/* MIX */
								switch (crc2) {
									case CRC_A:
									case CRC_B:
									case CRC_C:
									case CRC_D:
									case CRC_E:
									case CRC_H:
									case CRC_L:osize+=3;break;
									default:osize+=4; /* value */
								}
							} else if (listarg[0][0]=='(' && listarg[0][strlen(listarg[0])-1]==')') {
								/* memory */
								switch (crc2) {
									case CRC_A:
									case CRC_HL:osize+=3;break;
									case CRC_BC:
									case CRC_DE:
									case CRC_SP:
									case CRC_IX:osize+=4;break;
									default:
										MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported LD %s,%s for GETSIZE, see documentation\n",listarg[0],listarg[1]);
								}
							} else {
								MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported LD %s,%s for GETSIZE, see documentation\n",listarg[0],listarg[1]);
							}
					}
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode LD for GETSIZE, need 2 arguments [%s]\n",zearg);
				}
				break;

			default: 
				MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"unsupported opcode [%s] for GETSIZE, see documentation about this directive\n",opcode[idx]);
		}
		idx++;
	}
	MemFree(opref);
	if (opcode) MemFree(opcode);
	return osize;
}
/*
	default returned value of Duration is NOP
	but BUILDZX usage change this to ticks!
*/
int __DURATION(struct s_assenv *ae,char *opcode, int didx)
{
	#undef FUNC
	#define FUNC "__DURATION"

	if (!ae->forcezx) return __GETNOP(ae,opcode,didx);
	return __GETTICK(ae,opcode,didx);
}
int __FILESIZE(struct s_assenv *ae,char *zefile, int didx)
{
	#undef FUNC
	#define FUNC "__DURATION"

	FILE *f;
	int zesize;

	f=fopen(zefile,"rb");
	if (!f) {
		MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"cannot retrieve filesize of [%s] file\n",zefile);
		return 0;
	}
	fseek(f,0,SEEK_END);
	zesize=ftell(f);
	fclose(f);
	return zesize;
}

int __Soft2HardInk(struct s_assenv *ae,int soft, int didx) {
	switch (soft) {
		case 0:return 64+20;break;
		case 1:return 64+4 ;break;
		case 2:return 64+21 ;break;
		case 3:return 64+28 ;break;
		case 4:return 64+24 ;break;
		case 5:return 64+29 ;break;
		case 6:return 64+12 ;break;
		case 7:return 64+5 ;break;
		case 8:return 64+13 ;break;
		case 9:return 64+22 ;break;
		case 10:return 64+6 ;break;
		case 11:return 64+23 ;break;
		case 12:return 64+30 ;break;
		case 13:return 64+0 ;break;
		case 14:return 64+31 ;break;
		case 15:return 64+14 ;break;
		case 16:return 64+7 ;break;
		case 17:return 64+15 ;break;
		case 18:return 64+18 ;break;
		case 19:return 64+2 ;break;
		case 20:return 64+19 ;break;
		case 21:return 64+26 ;break;
		case 22:return 64+25 ;break;
		case 23:return 64+27 ;break;
		case 24:return 64+10 ;break;
		case 25:return 64+3 ;break;
		case 26:return 64+11 ;break;
		default:
			MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"SOFT2HARD_INK needs 0-26 color index");
	}
	return 0;
}
int __Hard2SoftInk(struct s_assenv *ae,int hard, int didx) {
	hard&=31;
	switch (hard) {
		case 0:return 13;break;
		case 1:return 13;break;
		case 2:return 19;break;
		case 3:return 25;break;
		case 4:return 1;break;
		case 5:return 7;break;
		case 6:return 10;break;
		case 7:return 16;break;
		case 8:return 7;break;
		case 9:return 25;break;
		case 10:return 24;break;
		case 11:return 26;break;
		case 12:return 6;break;
		case 13:return 8;break;
		case 14:return 15;break;
		case 15:return 17;break;
		case 16:return 1;break;
		case 17:return 19;break;
		case 18:return 18;break;
		case 19:return 20;break;
		case 20:return 0;break;
		case 21:return 2;break;
		case 22:return 9;break;
		case 23:return 11;break;
		case 24:return 4;break;
		case 25:return 22;break;
		case 26:return 21;break;
		case 27:return 23;break;
		case 28:return 3;break;
		case 29:return 5;break;
		case 30:return 12;break;
		case 31:return 14;break;
		default:/*warning remover*/
			MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"SOFT2HARD_INK warning remover");
	}
	return 0;
}

double ComputeExpressionCore(struct s_assenv *ae,char *original_zeexpression,int ptr, int didx)
{
	#undef FUNC
	#define FUNC "ComputeExpressionCore"

	/* static execution buffers */
	static double *accu=NULL;
	static int maccu=0;
	static struct s_compute_element *computestack=NULL;
	static int maxcomputestack=0;
	int i,j,paccu=0;
	int nbtokenstack=0;
	int nbcomputestack=0;
	int nboperatorstack=0;

	struct s_compute_element stackelement;
	int o2,okclose,itoken;
	
	int idx=0,crc,icheck,is_binary,ivar=0;
	char asciivalue[11];
	unsigned char c;
	int accu_err=0;
	int parenth=0;
	/* backup alias replace */
	char *zeexpression,*expr;
	int original=1;
	int ialias,startvar=0;
	int newlen,lenw;
	/* dictionnary */
	struct s_expr_dico *curdic;
	struct s_label *curlabel;
	int minusptr,imkey,bank,page;
	double curval;
	int is_string=0;
	/* negative value */
	int allow_minus_as_sign=0;
	/* extended replace in labels */
	int curly=0,curlyflag=0;
	char *Automate;
	double dummint;

	/* memory cleanup */
	if (!ae) {
		if (maccu) MemFree(accu);
		accu=NULL;maccu=0;
		if (maxcomputestack) MemFree(computestack);
		computestack=NULL;maxcomputestack=0;
		return 0.0;
	}

	/* be sure to have at least some bytes allocated */
	StateMachineResizeBuffer(&ae->computectx->varbuffer,128,&ae->computectx->maxivar);


#if TRACE_COMPUTE_EXPRESSION
	printf("expression=[%s]\n",original_zeexpression);
#endif
	zeexpression=original_zeexpression;
	if (!zeexpression[0]) {
		return 0;
	}
	/* double hack if the first value is negative */
	if (zeexpression[0]=='-') {
		if (ae->AutomateExpressionValidCharFirst[(int)zeexpression[1]&0xFF]) {
			allow_minus_as_sign=1;
		} else {
			memset(&stackelement,0,sizeof(stackelement));
			ObjectArrayAddDynamicValueConcat((void **)&ae->computectx->tokenstack,&nbtokenstack,&ae->computectx->maxtokenstack,&stackelement,sizeof(stackelement));
		}
	}

	/* is there ascii char? */
	while ((c=zeexpression[idx])!=0) {
		if (c=='\'' || c=='"') {
			/* echappement */
			if (zeexpression[idx+1]=='\\') {
				if (zeexpression[idx+2] && zeexpression[idx+3]==c) {
					sprintf(asciivalue,"#%03X",zeexpression[idx+2]);
					memcpy(zeexpression+idx,asciivalue,4);
					idx+=3;
				} else {
					//MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"Only single escaped char may be quoted [%s]\n",TradExpression(zeexpression));
					//zeexpression[0]=0;
					//return 0;
					idx++;
					while (zeexpression[idx] && zeexpression[idx]!=c) idx++; // no escape code management
				}
			} else if (zeexpression[idx+1] && zeexpression[idx+2]==c) {
				// without escaped char, we convert it to value EXCEPT if we are looking for a register!
				if (idx>=12 && strncmp(&zeexpression[idx-12],"IS_REGISTER(",12)==0) {
					// skip conversion for register test
					idx+=2;
				} else {
					sprintf(asciivalue,"#%02X",zeexpression[idx+1]);
					memcpy(zeexpression+idx,asciivalue,3);
					idx+=2;
				}
			} else {
				//printf("Expression with => moar than one char in quotes\n");
				//MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"Only single char may be quoted [%s]\n",TradExpression(zeexpression));
				//zeexpression[0]=0;
				//return 0;
				idx++;
				while (zeexpression[idx] && zeexpression[idx]!=c) idx++; // no escape code management

			}
		}
		
		idx++;
	}
#if TRACE_COMPUTE_EXPRESSION
	printf("apres conversion des chars [%s]\n",zeexpression);
#endif
	/***********************************************************
	    P A T C H    F O R    P O S I T I V E     V A L U E    
	***********************************************************/
	if (zeexpression[0]=='+') idx=1; else idx=0;
	/***********************************************************
	  C O M P U T E   E X P R E S S I O N   M A I N    L O O P
	***********************************************************/
	while ((c=zeexpression[idx])!=0) {
		switch (c) {
			case '"':
			case '\'':
				//printf("COMPUTE => string detected!\n");
				ivar=0;
				idx++;
				while (zeexpression[idx] && zeexpression[idx]!=c) {
					ae->computectx->varbuffer[ivar++]=zeexpression[idx];
					StateMachineResizeBuffer(&ae->computectx->varbuffer,ivar,&ae->computectx->maxivar);
					idx++;
				}
				if (zeexpression[idx]) idx++; else MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"ComputeExpression [%s] quote bug!\n",TradExpression(zeexpression));
				ae->computectx->varbuffer[ivar]=0;
				is_string=1; // donc on ira jamais utiliser startvar derriere
				break;

			/* parenthesis */
			case ')':
				/* next to a closing parenthesis, a minus is an operator */
				allow_minus_as_sign=0;
				parenth--;
				break;
			case '(':
				parenth++;
			/* operator detection */
			case '*':
			case '/':
			case '^':
			case '[':
			case 'm':
			case '+':
			case ']':
				allow_minus_as_sign=1;
				break;
			case '&':
				allow_minus_as_sign=1;
				if (c=='&' && zeexpression[idx+1]=='&') {
					idx++;
					c='a'; // boolean AND
				}
				break;
			case '|':
				allow_minus_as_sign=1;
				if (c=='|' && zeexpression[idx+1]=='|') {
					idx++;
					c='o'; // boolean OR
				}
				break;
			/* testing */
			case '<':
				allow_minus_as_sign=1;
				if (zeexpression[idx+1]=='=') {
					idx++;
					c='k'; // boolean LOWEREQ
				} else if (zeexpression[idx+1]=='>') {
					idx++;
					c='n'; // boolean NOTEQUAL
				} else {
					c='l';
				}
				break;
			case '>':
				allow_minus_as_sign=1;
				if (zeexpression[idx+1]=='=') {
					idx++;
					c='h'; // boolean GREATEREQ
				} else {
					c='g';
				}
				break;
			case '!':
				allow_minus_as_sign=1;
				if (zeexpression[idx+1]=='=') {
					idx++;
					c='n'; // boolean NOTEQUAL
				} else {
					c='b';
				}
				break;
			case '=':
				allow_minus_as_sign=1;
				/* expecting == */
				if (zeexpression[idx+1]=='=') {
					idx++;
					c='e'; // boolean EQUAL
				/* except in maxam mode with a single = */
				} else if (ae->maxam) {
					c='e'; // boolean EQUAL
				/* cannot affect data inside an expression */
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] cannot set variable inside an expression\n",TradExpression(zeexpression));
					return 0;
				}
				break;
			case '-':
				if (allow_minus_as_sign) {
					/* previous char was an opening parenthesis or an operator */
					ivar=0;
					ae->computectx->varbuffer[ivar++]='-';
					StateMachineResizeBuffer(&ae->computectx->varbuffer,ivar,&ae->computectx->maxivar);
					c=zeexpression[++idx];
					if (ae->AutomateExpressionValidCharFirst[(int)c&0xFF]) {
						ae->computectx->varbuffer[ivar++]=c;
						StateMachineResizeBuffer(&ae->computectx->varbuffer,ivar,&ae->computectx->maxivar);
						c=zeexpression[++idx];
						while (ae->AutomateExpressionValidChar[(int)c&0xFF]) {
							ae->computectx->varbuffer[ivar++]=c;
							StateMachineResizeBuffer(&ae->computectx->varbuffer,ivar,&ae->computectx->maxivar);
							c=zeexpression[++idx];
						}
					}
					ae->computectx->varbuffer[ivar]=0;
					if (ivar<2) {
						MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] invalid minus sign\n",TradExpression(zeexpression));
						if (!original) {
							MemFree(zeexpression);
						}
						return 0;
					}
					break;
				}
				allow_minus_as_sign=1;
				break;
				
			/* operator OR binary value */
			case '%':
				/* % symbol may be a modulo or a binary literal value */
				is_binary=0;
				for (icheck=1;zeexpression[idx+icheck];icheck++) {
					switch (zeexpression[idx+icheck]) {
						case '1':
						case '0':/* still binary */
							is_binary=1;
							break;
						case '+':
						case '-':
						case '/':
						case '*':
						case '|':
						case 'm':
						case '%':
						case '^':
						case '&':
						case '(':
						case ')':
						case '=':
						case '<':
						case '>':
						case '!':
						case '[':
						case ']':
							if (is_binary) is_binary=2; else is_binary=-1;
							break;
						default:
							is_binary=-1;
					}
					if (is_binary==2) {
						break;
					}
					if (is_binary==-1) {
						is_binary=0;
						break;
					}
				}
				if (!is_binary) {
					allow_minus_as_sign=1;
					c='m';
					break;
				}
			default:
				allow_minus_as_sign=0;
				/* semantic analysis */
				startvar=idx;
				ivar=0;
				/* first char does not allow same chars as next chars */
				if (ae->AutomateExpressionValidCharFirst[((int)c)&0xFF]) {
					ae->computectx->varbuffer[ivar++]=c;
					if (c=='{') {
						/* not a formula but only a prefix tag */
						curly++;
					}
					StateMachineResizeBuffer(&ae->computectx->varbuffer,ivar,&ae->computectx->maxivar);
					idx++;
					c=zeexpression[idx];
					Automate=ae->AutomateExpressionValidChar;
					while (Automate[((int)c)&0xFF]) {
						if (c=='{') {
							curly++;
							curlyflag=1;
							Automate=ae->AutomateExpressionValidCharExtended;
						} else if (c=='}') {
							curly--;
							if (!curly) {
								Automate=ae->AutomateExpressionValidChar;
							}
						}
						ae->computectx->varbuffer[ivar++]=c;
						StateMachineResizeBuffer(&ae->computectx->varbuffer,ivar,&ae->computectx->maxivar);
						idx++;
						c=zeexpression[idx];
					}
				}
				ae->computectx->varbuffer[ivar]=0;
				if (!ivar) {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"ComputeExpression invalid char (%d=%c) expression [%s]\n",c,c>31?c:' ',TradExpression(zeexpression));
					if (!original) {
						MemFree(zeexpression);
					}
					return 0;
				} else if (curly) {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"ComputeExpression wrong curly brackets in expression [%s]\n",TradExpression(zeexpression));
					if (!original) {
						MemFree(zeexpression);
					}
					return 0;
				}
		}
		if (c && !ivar) idx++;
	
		/************************************
		   S T A C K   D I S P A T C H E R
		************************************/
		/* push operator or stack value */
		if (!ivar) {
#if TRACE_COMPUTE_EXPRESSION
	printf("pushoperator [%c]\n",c);
#endif
			/************************************
			          O P E R A T O R 
			************************************/
			stackelement=ae->AutomateElement[c];
			if (stackelement.operator>E_COMPUTE_OPERATION_GREATEREQ) {
				MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] has unknown operator %c (%d)\n",TradExpression(zeexpression),c>31?c:'.',c);
			}
			/* stackelement.value isn't used */
			stackelement.string=NULL;
		} else if (is_string) {
#if TRACE_COMPUTE_EXPRESSION
	printf("pushstring [%s]\n",ae->computectx->varbuffer);
#endif
			stackelement.operator=E_COMPUTE_OPERATION_PUSH_DATASTC;
			/* priority & value isn't used */
			stackelement.string=TxtStrDup(ae->computectx->varbuffer);
			allow_minus_as_sign=0;
			ivar=is_string=0;
		} else {
			/************************************
			              V A L U E
			************************************/
#if TRACE_COMPUTE_EXPRESSION
	printf("pushvalue [%s]\n",ae->computectx->varbuffer);
#endif
			if (ae->computectx->varbuffer[0]=='-') minusptr=1; else minusptr=0;
			/* constantes ou variables/labels */
			switch (ae->computectx->varbuffer[minusptr]) {
				case '0':
					/* 0x hexa value hack */
					if (ae->computectx->varbuffer[minusptr+1]=='X' && ae->AutomateHexa[(int)ae->computectx->varbuffer[minusptr+2]&0xFF]) {
						for (icheck=minusptr+3;ae->computectx->varbuffer[icheck];icheck++) {
							if (ae->AutomateHexa[(int)ae->computectx->varbuffer[icheck]&0xFF]) continue;
							MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] - %s is not a valid hex number\n",TradExpression(zeexpression),ae->computectx->varbuffer);
							break;
						}
						curval=strtol(ae->computectx->varbuffer+minusptr+2,NULL,16);
						break;
					} else
					/* 0b binary value hack */
					if (ae->computectx->varbuffer[minusptr+1]=='B' && (ae->computectx->varbuffer[minusptr+2]>='0' && ae->computectx->varbuffer[minusptr+2]<='1')) {
						for (icheck=minusptr+3;ae->computectx->varbuffer[icheck];icheck++) {
							if (ae->computectx->varbuffer[icheck]>='0' && ae->computectx->varbuffer[icheck]<='1') continue;
							MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] - %s is not a valid binary number\n",TradExpression(zeexpression),ae->computectx->varbuffer);
							break;
						}
						curval=strtol(ae->computectx->varbuffer+minusptr+2,NULL,2);
						break;
					}
					/* 0o octal value hack */
					if (ae->computectx->varbuffer[minusptr+1]=='O' && (ae->computectx->varbuffer[minusptr+2]>='0' && ae->computectx->varbuffer[minusptr+2]<='5')) {
						for (icheck=minusptr+3;ae->computectx->varbuffer[icheck];icheck++) {
							if (ae->computectx->varbuffer[icheck]>='0' && ae->computectx->varbuffer[icheck]<='5') continue;
							MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] - %s is not a valid octal number\n",TradExpression(zeexpression),ae->computectx->varbuffer);
							break;
						}
						curval=strtol(ae->computectx->varbuffer+minusptr+2,NULL,2);
						break;
					}
				case '1':
				case '2':
				case '3':
				case '4':
				case '5':
				case '6':
				case '7':
				case '8':
				case '9':
					/* check number */
					for (icheck=minusptr;ae->computectx->varbuffer[icheck];icheck++) {
						if (ae->AutomateDigit[(int)ae->computectx->varbuffer[icheck]&0xFF]) continue;
						/* Intel hexa & binary style */
						switch (ae->computectx->varbuffer[strlen(ae->computectx->varbuffer)-1]) {
							case 'H':
								for (icheck=minusptr;ae->computectx->varbuffer[icheck+1];icheck++) {
									if (ae->AutomateHexa[(int)ae->computectx->varbuffer[icheck]&0xFF]) continue;
									MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] - %s is not a valid hex number\n",TradExpression(zeexpression),ae->computectx->varbuffer);
								}
								curval=strtol(ae->computectx->varbuffer+minusptr,NULL,16);
								break;
							case 'B':
								for (icheck=minusptr;ae->computectx->varbuffer[icheck+1];icheck++) {
									if (ae->computectx->varbuffer[icheck]=='0' || ae->computectx->varbuffer[icheck]=='1') continue;
									MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] - %s is not a valid binary number\n",TradExpression(zeexpression),ae->computectx->varbuffer);
								}
								curval=strtol(ae->computectx->varbuffer+minusptr,NULL,2);
								break;
							default:
								MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] - %s is not a valid number\n",TradExpression(zeexpression),ae->computectx->varbuffer);
						}
						icheck=0;
						break;
					}
					if (!ae->computectx->varbuffer[icheck]) curval=atof(ae->computectx->varbuffer+minusptr);
					break;
				case '%':
					/* check number */
					if (!ae->computectx->varbuffer[minusptr+1]) {
						MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] - %s is an empty binary number\n",TradExpression(zeexpression),ae->computectx->varbuffer);
					}
					for (icheck=minusptr+1;ae->computectx->varbuffer[icheck];icheck++) {
						if (ae->computectx->varbuffer[icheck]=='0' || ae->computectx->varbuffer[icheck]=='1') continue;
						MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] - %s is not a valid binary number\n",TradExpression(zeexpression),ae->computectx->varbuffer);
						break;
					}
					curval=strtol(ae->computectx->varbuffer+minusptr+1,NULL,2);
					break;
				case '#':
					/* check number */
					if (!ae->computectx->varbuffer[minusptr+1]) {
						MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] - %s is an empty hex number\n",TradExpression(zeexpression),ae->computectx->varbuffer);
					}
					for (icheck=minusptr+1;ae->computectx->varbuffer[icheck];icheck++) {
						if (ae->AutomateHexa[(int)ae->computectx->varbuffer[icheck]&0xFF]) continue;
						MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] - %s is not a valid hex number\n",TradExpression(zeexpression),ae->computectx->varbuffer);
						break;
					}
					curval=strtol(ae->computectx->varbuffer+minusptr+1,NULL,16);
					break;
				default:
					if (1 || !curlyflag) {
						/* $ hex value hack */
						if (ae->computectx->varbuffer[minusptr+0]=='$' && ae->AutomateHexa[(int)ae->computectx->varbuffer[minusptr+1]&0xFF]) {
							for (icheck=minusptr+2;ae->computectx->varbuffer[icheck];icheck++) {
								if (ae->AutomateHexa[(int)ae->computectx->varbuffer[icheck]&0xFF]) continue;
								MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] - %s is not a valid hex number\n",TradExpression(zeexpression),ae->computectx->varbuffer);
								break;
							}
							curval=strtol(ae->computectx->varbuffer+minusptr+1,NULL,16);
							break;
						}
						/* @ octal value hack */
						if (ae->computectx->varbuffer[minusptr+0]=='@' &&  ((ae->computectx->varbuffer[minusptr+1]>='0' && ae->computectx->varbuffer[minusptr+1]<='7'))) {
							for (icheck=minusptr+2;ae->computectx->varbuffer[icheck];icheck++) {
								if (ae->computectx->varbuffer[icheck]>='0' && ae->computectx->varbuffer[icheck]<='7') continue;
								MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] - %s is not a valid octal number\n",TradExpression(zeexpression),ae->computectx->varbuffer);
								break;
							}
							curval=strtol(ae->computectx->varbuffer+minusptr+1,NULL,8);
							break;
						}
						/* Intel hexa value hack */
						if (ae->AutomateHexa[(int)ae->computectx->varbuffer[minusptr+0]&0xFF]) {
							if (ae->computectx->varbuffer[strlen(ae->computectx->varbuffer)-1]=='H') {
								for (icheck=minusptr;ae->computectx->varbuffer[icheck+1];icheck++) {
									if (!ae->AutomateHexa[(int)ae->computectx->varbuffer[icheck]&0xFF]) break;
								}
								if (!ae->computectx->varbuffer[icheck+1]) {
									curval=strtol(ae->computectx->varbuffer+minusptr,NULL,16);
									break;
								}
							}
						}
					}
					
					
					if (curlyflag) {
						char *minivarbuffer;
						int touched;

						/* besoin d'un sous-contexte */
						minivarbuffer=TxtStrDup(ae->computectx->varbuffer+minusptr);
						ae->computectx=&ae->ctx2;
#if TRACE_COMPUTE_EXPRESSION
	printf("curly [%s]\n",minivarbuffer);
#endif
						minivarbuffer=TranslateTag(ae,minivarbuffer, &touched,0,E_TAGOPTION_NONE);
#if TRACE_COMPUTE_EXPRESSION
	printf("après curly [%s]\n",minivarbuffer);
#endif
						ae->computectx=&ae->ctx1;
						if (!touched) {
							strcpy(ae->computectx->varbuffer+minusptr,minivarbuffer);
						} else {
							StateMachineResizeBuffer(&ae->computectx->varbuffer,strlen(minivarbuffer)+2,&ae->computectx->maxivar);
							strcpy(ae->computectx->varbuffer+minusptr,minivarbuffer);
						}
						MemFree(minivarbuffer);
						curlyflag=0;
					}

					crc=GetCRC(ae->computectx->varbuffer+minusptr);
					/***************************************************
					     L O O K I N G   F O R   A   F U N C T I O N
					***************************************************/
					for (imkey=0;math_keyword[imkey].mnemo[0];imkey++) {
						if (crc==math_keyword[imkey].crc && strcmp(ae->computectx->varbuffer+minusptr,math_keyword[imkey].mnemo)==0) {
							if (c=='(') {
								/* push function as operator! */
								stackelement.operator=math_keyword[imkey].operation;
								stackelement.string=NULL;
								/************************************************
								      C R E A T E    E X T R A     T O K E N
								************************************************/
								ObjectArrayAddDynamicValueConcat((void **)&ae->computectx->tokenstack,&nbtokenstack,&ae->computectx->maxtokenstack,&stackelement,sizeof(stackelement));
								stackelement.operator=E_COMPUTE_OPERATION_OPEN;
								ObjectArrayAddDynamicValueConcat((void **)&ae->computectx->tokenstack,&nbtokenstack,&ae->computectx->maxtokenstack,&stackelement,sizeof(stackelement));
								allow_minus_as_sign=1;
								idx++;
								parenth++;
							} else {
								MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] - %s is a reserved keyword!\n",TradExpression(zeexpression),math_keyword[imkey].mnemo);
								curval=0;
								idx++;
							}
							ivar=0;
							break;
						}
					}
					if (math_keyword[imkey].mnemo[0]) continue;
					
					if (ae->computectx->varbuffer[minusptr+0]=='$' && ae->computectx->varbuffer[minusptr+1]==0) {
						curval=ptr;
					} else {
#if TRACE_COMPUTE_EXPRESSION
	printf("search dico [%s]\n",ae->computectx->varbuffer+minusptr);
#endif
						curdic=SearchDico(ae,ae->computectx->varbuffer+minusptr,crc);
						if (curdic) {
#if TRACE_COMPUTE_EXPRESSION
	printf("trouvé valeur=%.2lf\n",curdic->v);
#endif
							curval=curdic->v;
							break;
						} else {
							/* getbank hack */
							if (ae->computectx->varbuffer[minusptr]!='{') {
								bank=0;
								page=0;
							} else if (strncmp(ae->computectx->varbuffer+minusptr,"{BANK}",6)==0) {
								bank=6;
								page=0;
								/* obligé de recalculer le CRC */
								crc=GetCRC(ae->computectx->varbuffer+minusptr+bank);
							} else if (strncmp(ae->computectx->varbuffer+minusptr,"{PAGE}",6)==0) {
								bank=6;
								page=1;
								/* obligé de recalculer le CRC */
								crc=GetCRC(ae->computectx->varbuffer+minusptr+bank);
							} else if (strncmp(ae->computectx->varbuffer+minusptr,"{PAGESET}",9)==0) {
								bank=9;
								page=2;
								/* obligé de recalculer le CRC */
								crc=GetCRC(ae->computectx->varbuffer+minusptr+bank);
							} else if (strncmp(ae->computectx->varbuffer+minusptr,"{SIZEOF}",8)==0) {
								bank=8;
								page=3;
								/* obligé de recalculer le CRC */
								crc=GetCRC(ae->computectx->varbuffer+minusptr+bank);
								curval=-1;
								/* search in structures aliases */
								for (i=0;i<ae->irasmstructalias;i++) {
									if (ae->rasmstructalias[i].crc==crc && strcmp(ae->rasmstructalias[i].name,ae->computectx->varbuffer+minusptr+bank)==0) {
										curval=ae->rasmstructalias[i].size;
										break;
									}
								}
								/* search in structures prototypes and subfields */
								if (curval==-1) for (i=0;i<ae->irasmstruct;i++) {
									if (ae->rasmstruct[i].crc==crc && strcmp(ae->rasmstruct[i].name,ae->computectx->varbuffer+minusptr+bank)==0) {
										curval=ae->rasmstruct[i].size;
										break;
									}

									for (j=0;j<ae->rasmstruct[i].irasmstructfield;j++) {
										if (ae->rasmstruct[i].rasmstructfield[j].crc==crc && strcmp(ae->rasmstruct[i].rasmstructfield[j].fullname,ae->computectx->varbuffer+minusptr+bank)==0) {
											curval=ae->rasmstruct[i].rasmstructfield[j].size;
											i=ae->irasmstruct+1;
											break;
										}
									}
								}

								if (curval==-1) {
									if (i==ae->irasmstructalias) {
										MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"cannot SIZEOF unknown structure [%s]!\n",ae->computectx->varbuffer+minusptr+bank);
										curval=0;
									}
								}
							} else {
								MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] - %s is an unknown prefix!\n",TradExpression(zeexpression),ae->computectx->varbuffer);
								bank=0; // on pourrait sauter le tag pour eviter la merde a suivre
								page=0;
							}
							/* limited label translation while processing crunched blocks
							   ae->curlz == current crunched block processed
							   expression->crunch_block=0 -> oui
							   expression->crunch_block=1 -> oui si même block
							   expression->crunch_block=2 -> non car sera relogée
							*/
							if (page!=3) {



if (didx>0 && didx<ae->ie) {
	if (ae->expression[didx].module) {
		char *dblvarbuffer;
#if TRACE_LABEL || TRACE_COMPUTE_EXPRESSION
		printf("search label [%s] in an expression / module=[%s]\n",ae->computectx->varbuffer+minusptr+bank,ae->expression[didx].module);
#endif
		dblvarbuffer=MemMalloc(strlen(ae->computectx->varbuffer)+strlen(ae->expression[didx].module)+2);

		strcpy(dblvarbuffer,ae->expression[didx].module);
		strcat(dblvarbuffer,ae->module_separator);
		strcat(dblvarbuffer,ae->computectx->varbuffer+minusptr+bank);

		/* always try to find label from current module */	
		curlabel=SearchLabel(ae,dblvarbuffer,GetCRC(dblvarbuffer));
		MemFree(dblvarbuffer);
	} else {
#if TRACE_LABEL || TRACE_COMPUTE_EXPRESSION
		printf("search label [%s] in an expression without module\n",ae->computectx->varbuffer+minusptr+bank);
#endif
		curlabel=NULL;
	}

	/* pas trouvé on cherche LEGACY */
	if (!curlabel) {
		curlabel=SearchLabel(ae,ae->computectx->varbuffer+minusptr+bank,crc);
#if TRACE_LABEL || TRACE_COMPUTE_EXPRESSION
		if (curlabel) printf("label LEGACY trouve! ptr=%d\n",curlabel->ptr); else printf("label non trouve!\n");
#endif
	}
#if TRACE_LABEL || TRACE_COMPUTE_EXPRESSION
	else printf("label trouve via ajout du MODULE\n");
#endif

} else {
#if TRACE_LABEL || TRACE_COMPUTE_EXPRESSION
	printf("search label [%s] outside an expression taking current module!\n",ae->computectx->varbuffer+minusptr+bank);
#endif
	if (ae->module) {
		char *dblvarbuffer;
		dblvarbuffer=MemMalloc(strlen(ae->computectx->varbuffer)+strlen(ae->module)+2);
		strcpy(dblvarbuffer,ae->module);
		strcat(dblvarbuffer,ae->module_separator);
		strcat(dblvarbuffer,ae->computectx->varbuffer+minusptr+bank);

		/* on essaie toujours de trouver le label du module courant */	
		curlabel=SearchLabel(ae,dblvarbuffer,GetCRC(dblvarbuffer));
		/* pas trouvé on cherche LEGACY */
		if (!curlabel) curlabel=SearchLabel(ae,ae->computectx->varbuffer+minusptr+bank,crc);
#if TRACE_LABEL || TRACE_COMPUTE_EXPRESSION
		else printf("label trouve via ajout du MODULE\n");
#endif

		MemFree(dblvarbuffer);
	} else {
		curlabel=SearchLabel(ae,ae->computectx->varbuffer+minusptr+bank,crc);
#if TRACE_LABEL || TRACE_COMPUTE_EXPRESSION
		if (curlabel) printf("label trouve sans avoir ajouté de MODULE\n");
#endif
	}
}



								if (curlabel) {
									if (ae->stage<2) {
										if (curlabel->lz==-1) {
											if (!bank) {
												curval=curlabel->ptr;
											} else {
#if TRACE_COMPUTE_EXPRESSION
printf("page=%d | ptr=%X ibank=%d\n",page,curlabel->ptr,curlabel->ibank);
#endif
												switch (page) {
													case 2: /* PAGESET */
														if (curlabel->ibank<BANK_MAX_NUMBER) {
															curval=ae->setgate[curlabel->ibank];
														} else {
															MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] cannot use PAGESET - label [%s] is in a temporary space!\n",TradExpression(zeexpression),ae->computectx->varbuffer);
															curval=curlabel->ibank;
														}
														break;
													case 1:/* PAGE */
														if (curlabel->ibank<BANK_MAX_NUMBER) {
															/* 4M expansion compliant */
															if (ae->bankset[curlabel->ibank>>2]) {
																curval=ae->bankgate[(curlabel->ibank&0x1FC)+(curlabel->ptr>>14)];
															} else {
																curval=ae->bankgate[curlabel->ibank];
															}
														} else {
															MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] cannot use PAGE - label [%s] is in a temporary space!\n",TradExpression(zeexpression),ae->computectx->varbuffer);
															curval=curlabel->ibank;
														}
														break;
													case 0:
														if (ae->forcesnapshot && curlabel->ibank>260) {
															int isr;
															for (isr=0;isr<256;isr++) {
																if (ae->rombank[isr]==curlabel->ibank) {
																	curval=isr;
																	break;
																}
															}
															if (isr==256) {
																MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] cannot use BANK - label [%s] is in a temporary space!\n",TradExpression(zeexpression),ae->computectx->varbuffer);
															}
														} else {
															curval=curlabel->ibank;
														}
														break;
													default:MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"INTERNAL ERROR (unknown paging)\n",GetExpFile(ae,didx),GetExpLine(ae,didx));FreeAssenv(ae);exit(-664);
												}
											}
										} else {
											int process_label=1;

											// si on est dans une section crunchée, on doit faire un contrôle étendu du scope du label
											if (ae->lzsection[curlabel->lz].lzversion) {
												/* label MUST be intermediate OR in the crunched block */
												//if (curlabel->iorgzone==ae->expression[didx].iorgzone) {
												if (curlabel->lz<=ae->expression[didx].lz || ae->orgzone[curlabel->iorgzone].inplace==0) {
													// we can process the label because it's in a previous or the same crunched section
													// we can process the label because it's in a relocated org section
												} else {
													process_label=0;
												}
											}
											if (process_label) {
												if (!bank) {
													curval=curlabel->ptr;
												} else {
													if (page) {
														switch (page) {
															case 2:  /* PAGESET */
																if (curlabel->ibank<BANK_MAX_NUMBER) {
																	/* 4M expansion compliant */
																	curval=ae->setgate[curlabel->ibank];
																} else {
																	MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] cannot use PAGESET - label [%s] is in a temporary space!\n",TradExpression(zeexpression),ae->computectx->varbuffer);
																	curval=curlabel->ibank;
																}
																break;
															case 1: /* PAGE */
																if (curlabel->ibank<BANK_MAX_NUMBER) {
																	/* 4M expansion compliant */
																	if (ae->bankset[curlabel->ibank>>2]) {
																		curval=ae->bankgate[(curlabel->ibank&0x1FC)+(curlabel->ptr>>14)];
																	} else {																		
																		curval=ae->bankgate[curlabel->ibank];
																	}
																} else {
																	MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] cannot use PAGE - label [%s] is in a temporary space!\n",TradExpression(zeexpression),ae->computectx->varbuffer);
																	curval=curlabel->ibank;
																}
																break;
															case 0:
																if (ae->forcesnapshot && curlabel->ibank>260) {
																	int isr;
																	for (isr=0;isr<256;isr++) {
																		if (ae->rombank[isr]==curlabel->ibank) {
																			curval=isr;
																			break;
																		}
																	}
																	if (isr==256) {
																		MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] cannot use BANK - label [%s] is in a temporary space!\n",TradExpression(zeexpression),ae->computectx->varbuffer);
																	}
																} else {
																	curval=curlabel->ibank;
																}
																break;
															default:MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"INTERNAL ERROR (unknown paging)\n");FreeAssenv(ae);exit(-664);
														}
													}
												}
											} else {
												MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"Label [%s] evaluation error!\n%s",ae->computectx->varbuffer,
														!ae->flux?" => the label is located after the crunched section of the expression where it's used\n => the ORG section where the label is defined is 'in place' which means the section may change logical addresses\n":"");
												curval=0;
											}
										}
									} else {
#if TRACE_COMPUTE_EXPRESSION
printf("stage 2 | page=%d | ptr=%X ibank=%d\n",page,curlabel->ptr,curlabel->ibank);
#endif
										if (bank) {
											//curval=curlabel->ibank;
											switch (page) {
												case 2: /* PAGESET */
													if (curlabel->ibank<BANK_MAX_NUMBER) {
														curval=ae->setgate[curlabel->ibank];
													} else {
														MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] cannot use PAGESET - label [%s] is in a temporary space!\n",TradExpression(zeexpression),ae->computectx->varbuffer);
														curval=curlabel->ibank;
													}
													break;
												case 1:/* PAGE */
													if (curlabel->ibank<BANK_MAX_NUMBER) {
														/* 4M expansion compliant */
														if (ae->bankset[curlabel->ibank>>2]) {
															curval=ae->bankgate[(curlabel->ibank&0x1FC)+(curlabel->ptr>>14)];
														} else {
															curval=ae->bankgate[curlabel->ibank];
														}
													} else {
														MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] cannot use PAGE - label [%s] is in a temporary space!\n",TradExpression(zeexpression),ae->computectx->varbuffer);
														curval=curlabel->ibank;
													}
													break;
												case 0:
													// patch to get real ROM number + error message
													if (ae->forcesnapshot && curlabel->ibank>260) {
														int isr;
														for (isr=0;isr<256;isr++) {
															if (ae->rombank[isr]==curlabel->ibank) {
																curval=isr;
																break;
															}
														}
														if (isr==256) {
															MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] cannot use BANK - label [%s] is in a temporary space!\n",TradExpression(zeexpression),ae->computectx->varbuffer);
														}
													} else {
														curval=curlabel->ibank;
													}
													break;
												default:MakeError(ae,GetExpIdx(ae,didx),GetCurrentFile(ae),ae->wl[ae->idx].l,"INTERNAL ERROR (unknown paging)\n",GetExpFile(ae,didx),GetExpLine(ae,didx));FreeAssenv(ae);exit(-664);
											}
										} else {
											curval=curlabel->ptr;
										}
									}
								} else {
									/***********************************************
										to allow aliases declared after use
									***********************************************/
									ialias=-1;
									if (didx>0 && didx<ae->ie) {
										if (ae->expression[didx].module) {
											// build module+alias
											char *dblvarbuffer;
											dblvarbuffer=MemMalloc(strlen(ae->computectx->varbuffer)+strlen(ae->expression[didx].module)+2);
                									strcpy(dblvarbuffer,ae->expression[didx].module);
											strcat(dblvarbuffer,ae->module_separator);
											strcat(dblvarbuffer,ae->computectx->varbuffer+minusptr);
											ialias=SearchAlias(ae,GetCRC(dblvarbuffer),dblvarbuffer);
											MemFree(dblvarbuffer);
										}
										if (ialias==-1) {
											ialias=SearchAlias(ae,crc,ae->computectx->varbuffer+minusptr);
										}
									} else {
										if (ae->module) {
											char *dblvarbuffer;
											dblvarbuffer=MemMalloc(strlen(ae->computectx->varbuffer)+strlen(ae->module)+2);
											strcpy(dblvarbuffer,ae->module);
											strcat(dblvarbuffer,ae->module_separator);
											strcat(dblvarbuffer,ae->computectx->varbuffer+minusptr);
											ialias=SearchAlias(ae,GetCRC(dblvarbuffer),dblvarbuffer);
											MemFree(dblvarbuffer);
										}
										if (ialias==-1) {
											ialias=SearchAlias(ae,crc,ae->computectx->varbuffer+minusptr);
										}
									}

									if (ialias>=0) { // IX alias is always declared in the very beginning so ialias cannot be zero
										newlen=ae->alias[ialias].len;
										lenw=strlen(zeexpression);
										if (newlen>ivar) {
											/* realloc bigger */
											if (original) {
												expr=MemMalloc(lenw+newlen-ivar+1);
												memcpy(expr,zeexpression,lenw+1);
												zeexpression=expr;
												original=0;
											} else {
												zeexpression=MemRealloc(zeexpression,lenw+newlen-ivar+1);
											}
										}
										/* startvar? */
										if (newlen!=ivar) {
											MemMove(zeexpression+startvar+newlen,zeexpression+startvar+ivar,lenw-startvar-ivar+1);
										}
										strncpy(zeexpression+startvar,ae->alias[ialias].translation,newlen); /* copy without zero terminator */
										idx=startvar;
										ivar=0;
										continue;
									} else {
										/* index possible sur une struct? */
										int reverse_idx,validx=-1;
										char *structlabel;

										reverse_idx=strlen(ae->computectx->varbuffer)-1;
										if (ae->computectx->varbuffer[reverse_idx]>='0' && ae->computectx->varbuffer[reverse_idx]<='9') {
											/* vu que ça ne PEUT PAS être une valeur litérale, on ne fait pas de test de débordement */
											reverse_idx--;
											while (ae->computectx->varbuffer[reverse_idx]>='0' && ae->computectx->varbuffer[reverse_idx]<='9') {
												reverse_idx--;
											}
											reverse_idx++;
											validx=atoi(ae->computectx->varbuffer+reverse_idx);
											structlabel=TxtStrDup(ae->computectx->varbuffer+minusptr);
											structlabel[reverse_idx-minusptr]=0;
#if TRACE_STRUCT
			printf("EVOL 119 -> looking for struct %s IDX=%d\n",structlabel,validx);
#endif
											/* unoptimized search in structures aliases */
											crc=GetCRC(structlabel);
											for (i=0;i<ae->irasmstructalias;i++) {
												if (ae->rasmstructalias[i].crc==crc && strcmp(ae->rasmstructalias[i].name,structlabel)==0) {
#if TRACE_STRUCT
							printf("EVOL 119 -> found! ptr=%d size=%d\n",ae->rasmstructalias[i].ptr,ae->rasmstructalias[i].size);
#endif
													curval=ae->rasmstructalias[i].size*validx+ae->rasmstructalias[i].ptr;
													if (validx>=ae->rasmstructalias[i].nbelem) {
														if (!ae->nowarning) {
															rasm_printf(ae,KWARNING"[%s:%d] Warning: index out of array size!\n",GetExpFile(ae,didx),GetExpLine(ae,didx));
															if (ae->erronwarn) MaxError(ae);
														}
													}
													break;
												}
											}
											if (i==ae->irasmstructalias) {
												/* not found */
												validx=-1;
											}
											MemFree(structlabel);
										}
										if (validx<0) {
											/* last chance to get a keyword */
											if (strcmp(ae->computectx->varbuffer+minusptr,"REPEAT_COUNTER")==0) {
												if (ae->ir) {
													curval=ae->repeat[ae->ir-1].repeat_counter;
												} else {
													MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"cannot use REPEAT_COUNTER keyword outside a repeat loop\n");
													curval=0;
												}
											} else if (strcmp(ae->computectx->varbuffer+minusptr,"WHILE_COUNTER")==0) {
												if (ae->iw) {
													curval=ae->whilewend[ae->iw-1].while_counter;
												} else {
													MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"cannot use WHILE_COUNTER keyword outside a while loop\n");
													curval=0;
												}
											} else {
												/* in case the expression is a register */
												if (IsRegister(ae->computectx->varbuffer+minusptr)) {
													MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"cannot use register %s in this context\n",TradExpression(zeexpression));
												} else {
													if (IsDirective(ae->computectx->varbuffer+minusptr)) {
														MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"cannot use directive %s in this context\n",TradExpression(zeexpression));
													} else {

														MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"expression [%s] keyword [%s] not found in variables, labels or aliases\n",TradExpression(zeexpression),ae->computectx->varbuffer+minusptr);

#if TRACE_LABEL || TRACE_COMPUTE_EXPRESSION
if (!ae->extended_error) {
	char *lookstr;
	lookstr=StringLooksLike(ae,ae->computectx->varbuffer+minusptr);
	if (lookstr) {
		printf("LooksLike: did you mean [%s] ?\n",lookstr);
	}
}
printf("DUMP des labels\n");
	for (i=0;i<ae->il;i++) {
		if (!ae->label[i].name) {
			printf("%d:%04X %s\n",ae->label[i].ibank,ae->label[i].ptr,ae->wl[ae->label[i].iw].w);
		} else {
			printf("%d:%04X %s\n",ae->label[i].ibank,ae->label[i].ptr,ae->label[i].name);
		}
	}
#endif

														if (ae->extended_error) {
															char *lookstr;
															lookstr=StringLooksLike(ae,ae->computectx->varbuffer+minusptr);
															if (lookstr) {
																rasm_printf(ae,KERROR" did you mean [%s] ?\n",lookstr);
															}
														}
													}
												}
												
												curval=0;
											}
										}
									}
								}
							}
						}
					}
			}
			if (minusptr) curval=-curval;
			stackelement.operator=E_COMPUTE_OPERATION_PUSH_DATASTC;
			stackelement.value=curval;
			/* priority isn't used */
			stackelement.string=NULL;
			
			allow_minus_as_sign=0;
			ivar=0;
		}
		/************************************
		      C R E A T E    T O K E N
		************************************/
		ObjectArrayAddDynamicValueConcat((void **)&ae->computectx->tokenstack,&nbtokenstack,&ae->computectx->maxtokenstack,&stackelement,sizeof(stackelement));
	}
	/*******************************************************
	      C R E A T E    E X E C U T I O N    S T A C K
	*******************************************************/
#define DEBUG_STACK 0
#if DEBUG_STACK
	for (itoken=0;itoken<nbtokenstack;itoken++) {
		switch (ae->computectx->tokenstack[itoken].operator) {
			case E_COMPUTE_OPERATION_PUSH_DATASTC:printf("%lf %s",ae->computectx->tokenstack[itoken].value,ae->computectx->tokenstack[itoken].string?ae->computectx->tokenstack[itoken].string:"(null)");break;
			case E_COMPUTE_OPERATION_OPEN:printf("(");break;
			case E_COMPUTE_OPERATION_CLOSE:printf(")");break;
			case E_COMPUTE_OPERATION_ADD:printf("+ ");break;
			case E_COMPUTE_OPERATION_SUB:printf("- ");break;
			case E_COMPUTE_OPERATION_DIV:printf("/ ");break;
			case E_COMPUTE_OPERATION_MUL:printf("* ");break;
			case E_COMPUTE_OPERATION_AND:printf("and ");break;
			case E_COMPUTE_OPERATION_OR:printf("or ");break;
			case E_COMPUTE_OPERATION_MOD:printf("mod ");break;
			case E_COMPUTE_OPERATION_XOR:printf("xor ");break;
			case E_COMPUTE_OPERATION_NOT:printf("! ");break;
			case E_COMPUTE_OPERATION_SHL:printf("<< ");break;
			case E_COMPUTE_OPERATION_SHR:printf(">> ");break;
			case E_COMPUTE_OPERATION_BAND:printf("&& ");break;
			case E_COMPUTE_OPERATION_BOR:printf("|| ");break;
			case E_COMPUTE_OPERATION_LOWER:printf("< ");break;
			case E_COMPUTE_OPERATION_GREATER:printf("> ");break;
			case E_COMPUTE_OPERATION_EQUAL:printf("== ");break;
			case E_COMPUTE_OPERATION_NOTEQUAL:printf("!= ");break;
			case E_COMPUTE_OPERATION_LOWEREQ:printf("<= ");break;
			case E_COMPUTE_OPERATION_GREATEREQ:printf(">= ");break;
			case E_COMPUTE_OPERATION_SIN:printf("sin ");break;
			case E_COMPUTE_OPERATION_COS:printf("cos ");break;
			case E_COMPUTE_OPERATION_INT:printf("int ");break;
			case E_COMPUTE_OPERATION_FLOOR:printf("floor ");break;
			case E_COMPUTE_OPERATION_ABS:printf("abs ");break;
			case E_COMPUTE_OPERATION_LN:printf("ln ");break;
			case E_COMPUTE_OPERATION_LOG10:printf("log10 ");break;
			case E_COMPUTE_OPERATION_SQRT:printf("sqrt ");break;
			case E_COMPUTE_OPERATION_ASIN:printf("asin ");break;
			case E_COMPUTE_OPERATION_ACOS:printf("acos ");break;
			case E_COMPUTE_OPERATION_ATAN:printf("atan ");break;
			case E_COMPUTE_OPERATION_EXP:printf("exp ");break;
			case E_COMPUTE_OPERATION_LOW:printf("low ");break;
			case E_COMPUTE_OPERATION_HIGH:printf("high ");break;
			case E_COMPUTE_OPERATION_PSG:printf("psg ");break;
			case E_COMPUTE_OPERATION_RND:printf("rnd ");break;
			case E_COMPUTE_OPERATION_FRAC:printf("frac ");break;
			case E_COMPUTE_OPERATION_CEIL:printf("ceil ");break;
			case E_COMPUTE_OPERATION_GET_R:printf("get_r ");break;
			case E_COMPUTE_OPERATION_GET_V:printf("get_v ");break;
			case E_COMPUTE_OPERATION_GET_B:printf("get_b ");break;
			case E_COMPUTE_OPERATION_SET_R:printf("set_r ");break;
			case E_COMPUTE_OPERATION_SET_V:printf("set_v ");break;
			case E_COMPUTE_OPERATION_SET_B:printf("set_b ");break;
			case E_COMPUTE_OPERATION_SOFT2HARD:printf("soft2hard ");break;
			case E_COMPUTE_OPERATION_HARD2SOFT:printf("hard2soft ");break;
			case E_COMPUTE_OPERATION_PEEK:printf("peek ");break;
			case E_COMPUTE_OPERATION_GETNOP:printf("getnop ");break;
			case E_COMPUTE_OPERATION_GETTICK:printf("gettick ");break;
			case E_COMPUTE_OPERATION_DURATION:printf("duration ");break;
			case E_COMPUTE_OPERATION_FILESIZE:printf("filesize ");break;
			case E_COMPUTE_OPERATION_GETSIZE:printf("getsize ");break;
			case E_COMPUTE_OPERATION_IS_REGISTER:printf("is_register ");break;
			default:printf("bug\n");break;
		}
		
	}
	printf("\n");
#endif

	for (itoken=0;itoken<nbtokenstack;itoken++) {
		switch (ae->computectx->tokenstack[itoken].operator) {
			case E_COMPUTE_OPERATION_PUSH_DATASTC:
#if DEBUG_STACK
printf("data string=%X\n",ae->computectx->tokenstack[itoken].string);
#endif
				ObjectArrayAddDynamicValueConcat((void **)&computestack,&nbcomputestack,&maxcomputestack,&ae->computectx->tokenstack[itoken],sizeof(stackelement));
				break;
			case E_COMPUTE_OPERATION_OPEN:
				ObjectArrayAddDynamicValueConcat((void **)&ae->computectx->operatorstack,&nboperatorstack,&ae->computectx->maxoperatorstack,&ae->computectx->tokenstack[itoken],sizeof(stackelement));
#if DEBUG_STACK
printf("ajout ( string=%X\n",ae->computectx->tokenstack[itoken].string);
#endif
				break;
			case E_COMPUTE_OPERATION_CLOSE:
#if DEBUG_STACK
printf("close\n");
#endif
				/* pop out token until the opened parenthesis is reached */
				o2=nboperatorstack-1;
				okclose=0;
				while (o2>=0) {
					if (ae->computectx->operatorstack[o2].operator!=E_COMPUTE_OPERATION_OPEN) {
						ObjectArrayAddDynamicValueConcat((void **)&computestack,&nbcomputestack,&maxcomputestack,&ae->computectx->operatorstack[o2],sizeof(stackelement));
						nboperatorstack--;
#if DEBUG_STACK
printf("op-- string=%X\n",ae->computectx->operatorstack[o2].string);
#endif
						o2--;
					} else {
						/* discard opening parenthesis as operator */
#if DEBUG_STACK
printf("discard )\n");
#endif
						nboperatorstack--;
						okclose=1;
						o2--;
						break;
					}
				}
				if (!okclose) {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"missing parenthesis [%s]\n",TradExpression(zeexpression));
					if (!original) {
						MemFree(zeexpression);
					}
					return 0;
				}
				/* if upper token is a function then pop from the stack */
				if (o2>=0 && ae->computectx->operatorstack[o2].operator>=E_COMPUTE_OPERATION_SIN) {
					ObjectArrayAddDynamicValueConcat((void **)&computestack,&nbcomputestack,&maxcomputestack,&ae->computectx->operatorstack[o2],sizeof(stackelement));
					nboperatorstack--;
#if DEBUG_STACK
printf("pop function string=%X\n",ae->computectx->operatorstack[o2].string);
#endif
				}
				break;
			case E_COMPUTE_OPERATION_ADD:
			case E_COMPUTE_OPERATION_SUB:
			case E_COMPUTE_OPERATION_DIV:
			case E_COMPUTE_OPERATION_MUL:
			case E_COMPUTE_OPERATION_AND:
			case E_COMPUTE_OPERATION_OR:
			case E_COMPUTE_OPERATION_MOD:
			case E_COMPUTE_OPERATION_XOR:
			case E_COMPUTE_OPERATION_NOT:
			case E_COMPUTE_OPERATION_SHL:
			case E_COMPUTE_OPERATION_SHR:
			case E_COMPUTE_OPERATION_BAND:
			case E_COMPUTE_OPERATION_BOR:
			case E_COMPUTE_OPERATION_LOWER:
			case E_COMPUTE_OPERATION_GREATER:
			case E_COMPUTE_OPERATION_EQUAL:
			case E_COMPUTE_OPERATION_NOTEQUAL:
			case E_COMPUTE_OPERATION_LOWEREQ:
			case E_COMPUTE_OPERATION_GREATEREQ:
				o2=nboperatorstack-1;
				while (o2>=0 && ae->computectx->operatorstack[o2].operator!=E_COMPUTE_OPERATION_OPEN) {
					if (ae->computectx->tokenstack[itoken].priority>=ae->computectx->operatorstack[o2].priority || ae->computectx->operatorstack[o2].operator>=E_COMPUTE_OPERATION_SIN) {
						ObjectArrayAddDynamicValueConcat((void **)&computestack,&nbcomputestack,&maxcomputestack,&ae->computectx->operatorstack[o2],sizeof(stackelement));
#if DEBUG_STACK
printf("operator string=%X\n",ae->computectx->operatorstack[o2].string);
#endif
						nboperatorstack--;
						o2--;
					} else {
						break;
					}
				}
				ObjectArrayAddDynamicValueConcat((void **)&ae->computectx->operatorstack,&nboperatorstack,&ae->computectx->maxoperatorstack,&ae->computectx->tokenstack[itoken],sizeof(stackelement));
				break;
			case E_COMPUTE_OPERATION_SIN:
			case E_COMPUTE_OPERATION_COS:
			case E_COMPUTE_OPERATION_INT:
			case E_COMPUTE_OPERATION_FLOOR:
			case E_COMPUTE_OPERATION_ABS:
			case E_COMPUTE_OPERATION_LN:
			case E_COMPUTE_OPERATION_LOG10:
			case E_COMPUTE_OPERATION_SQRT:
			case E_COMPUTE_OPERATION_ASIN:
			case E_COMPUTE_OPERATION_ACOS:
			case E_COMPUTE_OPERATION_ATAN:
			case E_COMPUTE_OPERATION_EXP:
			case E_COMPUTE_OPERATION_LOW:
			case E_COMPUTE_OPERATION_HIGH:
			case E_COMPUTE_OPERATION_PSG:
			case E_COMPUTE_OPERATION_RND:
			case E_COMPUTE_OPERATION_FRAC:
			case E_COMPUTE_OPERATION_CEIL:
			case E_COMPUTE_OPERATION_GET_R:
			case E_COMPUTE_OPERATION_GET_V:
			case E_COMPUTE_OPERATION_GET_B:
			case E_COMPUTE_OPERATION_SET_R:
			case E_COMPUTE_OPERATION_SET_V:
			case E_COMPUTE_OPERATION_SET_B:
			case E_COMPUTE_OPERATION_SOFT2HARD:
			case E_COMPUTE_OPERATION_HARD2SOFT:
			case E_COMPUTE_OPERATION_PEEK:
			case E_COMPUTE_OPERATION_GETNOP:
			case E_COMPUTE_OPERATION_GETTICK:
			case E_COMPUTE_OPERATION_DURATION:
			case E_COMPUTE_OPERATION_FILESIZE:
			case E_COMPUTE_OPERATION_GETSIZE:
			case E_COMPUTE_OPERATION_IS_REGISTER:
#if DEBUG_STACK
printf("ajout de la fonction\n");
#endif
				ObjectArrayAddDynamicValueConcat((void **)&ae->computectx->operatorstack,&nboperatorstack,&ae->computectx->maxoperatorstack,&ae->computectx->tokenstack[itoken],sizeof(stackelement));
				break;
			default:break;
		}
	}
	/* pop remaining operators */
	while (nboperatorstack>0) {
		ObjectArrayAddDynamicValueConcat((void **)&computestack,&nbcomputestack,&maxcomputestack,&ae->computectx->operatorstack[--nboperatorstack],sizeof(stackelement));
#if DEBUG_STACK
printf("final POP string=%X\n",ae->computectx->operatorstack[nboperatorstack+1].string);
#endif
	}
	
	/********************************************
	        E X E C U T E        S T A C K
	********************************************/
	if (ae->maxam || ae->as80) {
		int workinterval;
		if (ae->as80) workinterval=0xFFFFFFFF; else workinterval=0xFFFF;
		for (i=0;i<nbcomputestack;i++) {
			switch (computestack[i].operator) {
				/************************************************
				  c a s e s   s h o u l d    b e    s o r t e d
				************************************************/
				case E_COMPUTE_OPERATION_PUSH_DATASTC:
					if (maccu<=paccu) {
						maccu=16+paccu;
						accu=MemRealloc(accu,sizeof(double)*maccu);
					}
					if (computestack[i].string) {
						/* string hack */
						accu[paccu]=i+0.1;
					} else {
						accu[paccu]=computestack[i].value;
					}
					paccu++;
					break;
				case E_COMPUTE_OPERATION_OPEN:
				case E_COMPUTE_OPERATION_CLOSE:/* cannot happend */ break;
				case E_COMPUTE_OPERATION_ADD:if (paccu>1) accu[paccu-2]=((int)accu[paccu-2]+(int)accu[paccu-1])&workinterval;paccu--;break;
				case E_COMPUTE_OPERATION_SUB:if (paccu>1) accu[paccu-2]=((int)accu[paccu-2]-(int)accu[paccu-1])&workinterval;paccu--;break;
				case E_COMPUTE_OPERATION_MUL:if (paccu>1) accu[paccu-2]=((int)accu[paccu-2]*(int)accu[paccu-1])&workinterval;paccu--;break;
				case E_COMPUTE_OPERATION_DIV:if (paccu>1) accu[paccu-2]=((int)accu[paccu-2]/(int)accu[paccu-1])&workinterval;paccu--;break;
				case E_COMPUTE_OPERATION_AND:if (paccu>1) accu[paccu-2]=((int)accu[paccu-2]&(int)accu[paccu-1])&workinterval;paccu--;break;
				case E_COMPUTE_OPERATION_OR:if (paccu>1) accu[paccu-2]=((int)accu[paccu-2]|(int)accu[paccu-1])&workinterval;paccu--;break;
				case E_COMPUTE_OPERATION_XOR:if (paccu>1) accu[paccu-2]=((int)accu[paccu-2]^(int)accu[paccu-1])&workinterval;paccu--;break;
				case E_COMPUTE_OPERATION_MOD:if (paccu>1) accu[paccu-2]=((int)accu[paccu-2]%(int)accu[paccu-1])&workinterval;paccu--;break;
				case E_COMPUTE_OPERATION_SHL:if (paccu>1) accu[paccu-2]=((int)accu[paccu-2])<<((int)accu[paccu-1]);
								if (((int)accu[paccu-1])>31 || ((int)accu[paccu-1])<-31) {
									if (!ae->nowarning) {
										rasm_printf(ae,KWARNING"[%s:%d] Warning - shifting %d is architecture dependant, result forced to ZERO\n",GetExpFile(ae,didx),GetExpLine(ae,didx),(int)accu[paccu-1]);
										if (ae->erronwarn) MaxError(ae);
									}
									accu[paccu-2]=0;
								}
								paccu--;break;
				case E_COMPUTE_OPERATION_SHR:if (paccu>1) accu[paccu-2]=((int)accu[paccu-2])>>((int)accu[paccu-1]);
								if (((int)accu[paccu-1])>31 || ((int)accu[paccu-1])<-31) {
									if (!ae->nowarning) {
										rasm_printf(ae,KWARNING"[%s:%d] Warning - shifting %d is architecture dependant, result forced to ZERO\n",GetExpFile(ae,didx),GetExpLine(ae,didx),(int)accu[paccu-1]);
										if (ae->erronwarn) MaxError(ae);
									}
									accu[paccu-2]=0;
								}
								paccu--;break;
				case E_COMPUTE_OPERATION_BAND:if (paccu>1) accu[paccu-2]=((int)accu[paccu-2]&&(int)accu[paccu-1])&workinterval;paccu--;break;
				case E_COMPUTE_OPERATION_BOR:if (paccu>1) accu[paccu-2]=((int)accu[paccu-2]||(int)accu[paccu-1])&workinterval;paccu--;break;
				/* comparison */
				case E_COMPUTE_OPERATION_LOWER:if (paccu>1) accu[paccu-2]=((int)accu[paccu-2]&workinterval)<((int)accu[paccu-1]&workinterval);paccu--;break;
				case E_COMPUTE_OPERATION_LOWEREQ:if (paccu>1) accu[paccu-2]=((int)accu[paccu-2]&workinterval)<=((int)accu[paccu-1]&workinterval);paccu--;break;
				case E_COMPUTE_OPERATION_EQUAL:if (paccu>1) accu[paccu-2]=((int)accu[paccu-2]&workinterval)==((int)accu[paccu-1]&workinterval);paccu--;break;
				case E_COMPUTE_OPERATION_NOTEQUAL:if (paccu>1) accu[paccu-2]=((int)accu[paccu-2]&workinterval)!=((int)accu[paccu-1]&workinterval);paccu--;break;
				case E_COMPUTE_OPERATION_GREATER:if (paccu>1) accu[paccu-2]=((int)accu[paccu-2]&workinterval)>((int)accu[paccu-1]&workinterval);paccu--;break;
				case E_COMPUTE_OPERATION_GREATEREQ:if (paccu>1) accu[paccu-2]=((int)accu[paccu-2]&workinterval)>=((int)accu[paccu-1]&workinterval);paccu--;break;
				/* functions */
				case E_COMPUTE_OPERATION_SIN:if (paccu>0) accu[paccu-1]=(int)sin(accu[paccu-1]*3.1415926545/180.0);break;
				case E_COMPUTE_OPERATION_COS:if (paccu>0) accu[paccu-1]=(int)cos(accu[paccu-1]*3.1415926545/180.0);break;
				case E_COMPUTE_OPERATION_ASIN:if (paccu>0) accu[paccu-1]=(int)asin(accu[paccu-1])*180.0/3.1415926545;break;
				case E_COMPUTE_OPERATION_ACOS:if (paccu>0) accu[paccu-1]=(int)acos(accu[paccu-1])*180.0/3.1415926545;break;
				case E_COMPUTE_OPERATION_ATAN:if (paccu>0) accu[paccu-1]=(int)atan(accu[paccu-1])*180.0/3.1415926545;break;
				case E_COMPUTE_OPERATION_INT:break;
				case E_COMPUTE_OPERATION_FLOOR:if (paccu>0) accu[paccu-1]=(int)floor(accu[paccu-1])&workinterval;break;
				case E_COMPUTE_OPERATION_ABS:if (paccu>0) accu[paccu-1]=(int)fabs(accu[paccu-1])&workinterval;break;
				case E_COMPUTE_OPERATION_EXP:if (paccu>0) accu[paccu-1]=(int)exp(accu[paccu-1])&workinterval;break;
				case E_COMPUTE_OPERATION_LN:if (paccu>0) accu[paccu-1]=(int)log(accu[paccu-1])&workinterval;break;
				case E_COMPUTE_OPERATION_LOG10:if (paccu>0) accu[paccu-1]=(int)log10(accu[paccu-1])&workinterval;break;
				case E_COMPUTE_OPERATION_SQRT:if (paccu>0) accu[paccu-1]=(int)sqrt(accu[paccu-1])&workinterval;break;
				case E_COMPUTE_OPERATION_LOW:if (paccu>0) accu[paccu-1]=((int)accu[paccu-1])&0xFF;break;
				case E_COMPUTE_OPERATION_HIGH:if (paccu>0) accu[paccu-1]=(((int)accu[paccu-1])&0xFF00)>>8;break;
				case E_COMPUTE_OPERATION_PSG:if (paccu>0) accu[paccu-1]=ae->psgfine[((int)accu[paccu-1])&0xFF];break;
				case E_COMPUTE_OPERATION_RND:if (paccu>0) {
								     int zemod;
								     zemod=(int)floor(accu[paccu-1]+0.5);
								     if (zemod>0) {
									     accu[paccu-1]=FastRand()%zemod;
								     } else {
									MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"RND function needs a value greater than zero to perform a random value\n");
								        accu[paccu-1]=0;
								     }
							     }
							     break;
				case E_COMPUTE_OPERATION_FRAC:if (paccu>0) accu[paccu-1]=((int)(accu[paccu-1]-(int)accu[paccu-1]));break;
				case E_COMPUTE_OPERATION_CEIL:if (paccu>0) accu[paccu-1]=(int)ceil(accu[paccu-1])&workinterval;break;
				case E_COMPUTE_OPERATION_GET_R:if (paccu>0) accu[paccu-1]=((((int)accu[paccu-1])&0xF0)>>4);break;
				case E_COMPUTE_OPERATION_GET_V:if (paccu>0) accu[paccu-1]=((((int)accu[paccu-1])&0xF00)>>8);break;
				case E_COMPUTE_OPERATION_GET_B:if (paccu>0) accu[paccu-1]=(((int)accu[paccu-1])&0xF);break;
				case E_COMPUTE_OPERATION_SET_R:if (paccu>0) accu[paccu-1]=MinMaxInt(accu[paccu-1],0,15)<<4;break;
				case E_COMPUTE_OPERATION_SET_V:if (paccu>0) accu[paccu-1]=MinMaxInt(accu[paccu-1],0,15)<<8;break;
				case E_COMPUTE_OPERATION_SET_B:if (paccu>0) accu[paccu-1]=MinMaxInt(accu[paccu-1],0,15);break;
				case E_COMPUTE_OPERATION_SOFT2HARD:if (paccu>0) accu[paccu-1]=__Soft2HardInk(ae,accu[paccu-1],didx);break;
				case E_COMPUTE_OPERATION_HARD2SOFT:if (paccu>0) accu[paccu-1]=__Hard2SoftInk(ae,accu[paccu-1],didx);break;
				case E_COMPUTE_OPERATION_PEEK:if (paccu>0) accu[paccu-1]=ae->mem[ae->activebank][(unsigned short int)accu[paccu-1]];break;
				/* functions with strings */
				case E_COMPUTE_OPERATION_GETNOP:if (paccu>0) {
								      int integeridx;
								      integeridx=floor(accu[paccu-1]);

								      if (integeridx>=0 && integeridx<nbcomputestack && computestack[integeridx].string) {
									      accu[paccu-1]=__GETNOP(ae,computestack[integeridx].string,didx);
									      MemFree(computestack[integeridx].string);
									      computestack[integeridx].string=NULL;
								      } else {
									      if (integeridx>=0 && integeridx<nbcomputestack) {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"GETNOP function needs a proper string\n");
										} else {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"GETNOP internal error (wrong string index)\n");
										}
									}
								} else {
									MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"GETNOP is empty\n");
								}
							       break;
							       /* CC GETNOP */
				case E_COMPUTE_OPERATION_GETTICK:if (paccu>0) {
								      int integeridx;
								      integeridx=floor(accu[paccu-1]);

								      if (integeridx>=0 && integeridx<nbcomputestack && computestack[integeridx].string) {
									      accu[paccu-1]=__GETTICK(ae,computestack[integeridx].string,didx);
									      MemFree(computestack[integeridx].string);
									      computestack[integeridx].string=NULL;
								      } else {
									      if (integeridx>=0 && integeridx<nbcomputestack) {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"GETTICK function needs a proper string\n");
										} else {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"GETTICK internal error (wrong string index)\n");
										}
									}
								} else {
									MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"GETTICK is empty\n");
								}
							       break;
							       /* CC GETNOP */
				case E_COMPUTE_OPERATION_DURATION:if (paccu>0) {
								      int integeridx;
								      integeridx=floor(accu[paccu-1]);

								      if (integeridx>=0 && integeridx<nbcomputestack && computestack[integeridx].string) {
									      accu[paccu-1]=__DURATION(ae,computestack[integeridx].string,didx);
									      MemFree(computestack[integeridx].string);
									      computestack[integeridx].string=NULL;
								      } else {
									      if (integeridx>=0 && integeridx<nbcomputestack) {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"DURATION function needs a proper string\n");
										} else {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"DURATION internal error (wrong string index)\n");
										}
									}
								} else {
									MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"DURATION is empty\n");
								}
							       break;
				case E_COMPUTE_OPERATION_FILESIZE:if (paccu>0) {
								      int integeridx;
								      integeridx=floor(accu[paccu-1]);

								      if (integeridx>=0 && integeridx<nbcomputestack && computestack[integeridx].string) {
									      accu[paccu-1]=__FILESIZE(ae,computestack[integeridx].string,didx);
									      MemFree(computestack[integeridx].string);
									      computestack[integeridx].string=NULL;
								      } else {
									      if (integeridx>=0 && integeridx<nbcomputestack) {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"FILESIZE function needs a proper string\n");
										} else {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"FILESIZE internal error (wrong string index)\n");
										}
									}
								} else {
									MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"DURATION is empty\n");
								}
							       break;
							       /* CC GETNOP */
				case E_COMPUTE_OPERATION_GETSIZE:if (paccu>0) {
								      int integeridx;
								      integeridx=floor(accu[paccu-1]);

								      if (integeridx>=0 && integeridx<nbcomputestack && computestack[integeridx].string) {
									      accu[paccu-1]=__GETSIZE(ae,computestack[integeridx].string,didx);
									      MemFree(computestack[integeridx].string);
									      computestack[integeridx].string=NULL;
								      } else {
									      if (integeridx>=0 && integeridx<nbcomputestack) {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"GETSIZE function needs a proper string\n");
										} else {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"GETSIZE internal error (wrong string index)\n");
										}
									}
								} else {
									MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"GETSIZE is empty\n");
								}
							       break;
							       /* CC GETNOP */
				case E_COMPUTE_OPERATION_IS_REGISTER:if (paccu>0) {
								      int integeridx;
								      integeridx=floor(accu[paccu-1]);

								      if (integeridx>=0 && integeridx<nbcomputestack && computestack[integeridx].string) {
									      accu[paccu-1]=__IS_REGISTER(ae,computestack[integeridx].string);
									      MemFree(computestack[integeridx].string);
									      computestack[integeridx].string=NULL;
								      } else {
									      if (integeridx>=0 && integeridx<nbcomputestack) {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"IS_REGISTER function needs a proper string\n");
										} else {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"IS_REGISTER internal error (wrong string index)\n");
										}
									}
								} else {
									MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"IS_REGISTERGETTICK is empty\n");
								}
							       break;
							       /* CC GETNOP */
				default:MakeError(ae,GetExpIdx(ae,didx),GetCurrentFile(ae),GetExpLine(ae,didx),"invalid computing state! (%d)\n",computestack[i].operator);paccu=0;
			}
			if (!paccu) {
				if (zeexpression[0]=='&') {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"Missing operand for calculation [%s] Did you use & for an hexadecimal value?\n",TradExpression(zeexpression));
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"Missing operand for calculation [%s]\n",TradExpression(zeexpression));
				}
				accu_err=1;
				break;
			}
		}
	} else {
		for (i=0;i<nbcomputestack;i++) {
#if 0
			int kk;
			for (kk=0;kk<paccu;kk++) printf("stack[%d]=%lf\n",kk,accu[kk]);
			if (computestack[i].operator==E_COMPUTE_OPERATION_PUSH_DATASTC) {
				printf("pacc=%d push %.1lf or %s\n",paccu,computestack[i].value,computestack[i].string?computestack[i].string:"null");
			} else {
				printf("pacc=%d operation %s p=%d\n",paccu,computestack[i].operator==E_COMPUTE_OPERATION_MUL?"*":
								computestack[i].operator==E_COMPUTE_OPERATION_ADD?"+":
								computestack[i].operator==E_COMPUTE_OPERATION_DIV?"/":
								computestack[i].operator==E_COMPUTE_OPERATION_SUB?"-":
								computestack[i].operator==E_COMPUTE_OPERATION_BAND?"&&":
								computestack[i].operator==E_COMPUTE_OPERATION_BOR?"||":
								computestack[i].operator==E_COMPUTE_OPERATION_SHL?"<<":
								computestack[i].operator==E_COMPUTE_OPERATION_SHR?">>":
								computestack[i].operator==E_COMPUTE_OPERATION_LOWER?"<":
								computestack[i].operator==E_COMPUTE_OPERATION_GREATER?">":
								computestack[i].operator==E_COMPUTE_OPERATION_EQUAL?"==":
								computestack[i].operator==E_COMPUTE_OPERATION_INT?"INT":
								computestack[i].operator==E_COMPUTE_OPERATION_LOWEREQ?"<=":
								computestack[i].operator==E_COMPUTE_OPERATION_GREATEREQ?">=":
								computestack[i].operator==E_COMPUTE_OPERATION_OPEN?"(":
								computestack[i].operator==E_COMPUTE_OPERATION_CLOSE?")":
								computestack[i].operator==E_COMPUTE_OPERATION_GETNOP?"getnpo":
								"<autre>",computestack[i].priority);
			}
#endif
			switch (computestack[i].operator) {
				case E_COMPUTE_OPERATION_PUSH_DATASTC:
					if (maccu<=paccu) {
						maccu=16+paccu;
						accu=MemRealloc(accu,sizeof(double)*maccu);
					}
					if (computestack[i].string) {
						/* string hack */
						accu[paccu]=i+0.1;
					} else {
						accu[paccu]=computestack[i].value;
					}
					paccu++;
					break;
				case E_COMPUTE_OPERATION_OPEN:
				case E_COMPUTE_OPERATION_CLOSE: /* cannot happend */ break;
				case E_COMPUTE_OPERATION_ADD:if (paccu>1) accu[paccu-2]+=accu[paccu-1];paccu--;break;
				case E_COMPUTE_OPERATION_SUB:if (paccu>1) accu[paccu-2]-=accu[paccu-1];paccu--;break;
				case E_COMPUTE_OPERATION_MUL:if (paccu>1) accu[paccu-2]*=accu[paccu-1];paccu--;break;
				case E_COMPUTE_OPERATION_DIV:if (paccu>1) accu[paccu-2]/=accu[paccu-1];paccu--;break;
				case E_COMPUTE_OPERATION_AND:if (paccu>1) accu[paccu-2]=((int)floor(accu[paccu-2]+0.5))&((int)floor(accu[paccu-1]+0.5));paccu--;break;
				case E_COMPUTE_OPERATION_OR:if (paccu>1) accu[paccu-2]=((int)floor(accu[paccu-2]+0.5))|((int)floor(accu[paccu-1]+0.5));paccu--;break;
				case E_COMPUTE_OPERATION_XOR:if (paccu>1) accu[paccu-2]=((int)floor(accu[paccu-2]+0.5))^((int)floor(accu[paccu-1]+0.5));paccu--;break;
				case E_COMPUTE_OPERATION_NOT:/* half operator, half function */ if (paccu>0) accu[paccu-1]=!((int)floor(accu[paccu-1]+0.5));break;
				case E_COMPUTE_OPERATION_MOD:if (paccu>1) accu[paccu-2]=((int)floor(accu[paccu-2]+0.5))%((int)floor(accu[paccu-1]+0.5));paccu--;break;
				case E_COMPUTE_OPERATION_SHL:if (paccu>1) accu[paccu-2]=((int)floor(accu[paccu-2]+0.5))<<((int)floor(accu[paccu-1]+0.5));
								if (((int)accu[paccu-1])>31 || ((int)accu[paccu-1])<-31) {
									if (!ae->nowarning) {
										rasm_printf(ae,KWARNING"[%s:%d] Warning - shifting %d is architecture dependant, result forced to ZERO\n",GetExpFile(ae,didx),GetExpLine(ae,didx),(int)accu[paccu-1]);
										if (ae->erronwarn) MaxError(ae);
									}
									accu[paccu-2]=0;
								}
								paccu--;break;
				case E_COMPUTE_OPERATION_SHR:if (paccu>1) accu[paccu-2]=((int)floor(accu[paccu-2]+0.5))>>((int)floor(accu[paccu-1]+0.5));
								if (((int)accu[paccu-1])>31 || ((int)accu[paccu-1])<-31) {
									if (!ae->nowarning) {
										rasm_printf(ae,KWARNING"[%s:%d] Warning - shifting %d is architecture dependant, result forced to ZERO\n",GetExpFile(ae,didx),GetExpLine(ae,didx),(int)accu[paccu-1]);
										if (ae->erronwarn) MaxError(ae);
									}
									accu[paccu-2]=0;
								}
								paccu--;break;
				case E_COMPUTE_OPERATION_BAND:if (paccu>1) accu[paccu-2]=((int)floor(accu[paccu-2]+0.5))&&((int)floor(accu[paccu-1]+0.5));paccu--;break;
				case E_COMPUTE_OPERATION_BOR:if (paccu>1) accu[paccu-2]=((int)floor(accu[paccu-2]+0.5))||((int)floor(accu[paccu-1]+0.5));paccu--;break;
				/* comparison */
				case E_COMPUTE_OPERATION_LOWER:if (paccu>1) accu[paccu-2]=accu[paccu-2]<accu[paccu-1];paccu--;break;
				case E_COMPUTE_OPERATION_LOWEREQ:if (paccu>1) accu[paccu-2]=accu[paccu-2]<=accu[paccu-1];paccu--;break;
				case E_COMPUTE_OPERATION_EQUAL:if (paccu>1) accu[paccu-2]=fabs(accu[paccu-2]-accu[paccu-1])<0.000001;paccu--;break;
				case E_COMPUTE_OPERATION_NOTEQUAL:if (paccu>1) accu[paccu-2]=accu[paccu-2]!=accu[paccu-1];paccu--;break;
				case E_COMPUTE_OPERATION_GREATER:if (paccu>1) accu[paccu-2]=accu[paccu-2]>accu[paccu-1];paccu--;break;
				case E_COMPUTE_OPERATION_GREATEREQ:if (paccu>1) accu[paccu-2]=accu[paccu-2]>=accu[paccu-1];paccu--;break;
				/* functions */
				case E_COMPUTE_OPERATION_SIN:if (paccu>0) accu[paccu-1]=sin(accu[paccu-1]*3.1415926545/180.0);break;
				case E_COMPUTE_OPERATION_COS:if (paccu>0) accu[paccu-1]=cos(accu[paccu-1]*3.1415926545/180.0);break;
				case E_COMPUTE_OPERATION_ASIN:if (paccu>0) accu[paccu-1]=asin(accu[paccu-1])*180.0/3.1415926545;break;
				case E_COMPUTE_OPERATION_ACOS:if (paccu>0) accu[paccu-1]=acos(accu[paccu-1])*180.0/3.1415926545;break;
				case E_COMPUTE_OPERATION_ATAN:if (paccu>0) accu[paccu-1]=atan(accu[paccu-1])*180.0/3.1415926545;break;
				case E_COMPUTE_OPERATION_INT:if (paccu>0) accu[paccu-1]=floor(accu[paccu-1]+0.5);break;
				case E_COMPUTE_OPERATION_FLOOR:if (paccu>0) accu[paccu-1]=floor(accu[paccu-1]);break;
				case E_COMPUTE_OPERATION_ABS:if (paccu>0) accu[paccu-1]=fabs(accu[paccu-1]);break;
				case E_COMPUTE_OPERATION_EXP:if (paccu>0) accu[paccu-1]=exp(accu[paccu-1]);break;
				case E_COMPUTE_OPERATION_LN:if (paccu>0) accu[paccu-1]=log(accu[paccu-1]);break;
				case E_COMPUTE_OPERATION_LOG10:if (paccu>0) accu[paccu-1]=log10(accu[paccu-1]);break;
				case E_COMPUTE_OPERATION_SQRT:if (paccu>0) accu[paccu-1]=sqrt(accu[paccu-1]);break;
				case E_COMPUTE_OPERATION_LOW:if (paccu>0) accu[paccu-1]=((int)floor(accu[paccu-1]+0.5))&0xFF;break;
				case E_COMPUTE_OPERATION_HIGH:if (paccu>0) accu[paccu-1]=(((int)floor(accu[paccu-1]+0.5))&0xFF00)>>8;break;
				case E_COMPUTE_OPERATION_PSG:if (paccu>0) accu[paccu-1]=ae->psgfine[((int)floor(accu[paccu-1]+0.5))&0xFF];break;
				case E_COMPUTE_OPERATION_RND:if (paccu>0) {
								     int zemod;
								     zemod=(int)floor(accu[paccu-1]+0.5);
								     if (zemod>0) {
									     accu[paccu-1]=FastRand()%zemod;
								     } else {
									MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"RND function needs a value greater than zero to perform a random value\n");
								        accu[paccu-1]=0;
								     }
							     }
							     break;
				case E_COMPUTE_OPERATION_FRAC:if (paccu>0) accu[paccu-1]=modf(accu[paccu-1],&dummint);break;
				case E_COMPUTE_OPERATION_CEIL:if (paccu>0) accu[paccu-1]=ceil(accu[paccu-1]);break;
				case E_COMPUTE_OPERATION_GET_R:if (paccu>0) accu[paccu-1]=((((int)accu[paccu-1])&0xF0)>>4);break;
				case E_COMPUTE_OPERATION_GET_V:if (paccu>0) accu[paccu-1]=((((int)accu[paccu-1])&0xF00)>>8);break;
				case E_COMPUTE_OPERATION_GET_B:if (paccu>0) accu[paccu-1]=(((int)accu[paccu-1])&0xF);break;
				case E_COMPUTE_OPERATION_SET_R:if (paccu>0) accu[paccu-1]=MinMaxInt(accu[paccu-1],0,15)<<4;break;
				case E_COMPUTE_OPERATION_SET_V:if (paccu>0) accu[paccu-1]=MinMaxInt(accu[paccu-1],0,15)<<8;break;
				case E_COMPUTE_OPERATION_SET_B:if (paccu>0) accu[paccu-1]=MinMaxInt(accu[paccu-1],0,15);break;
				case E_COMPUTE_OPERATION_SOFT2HARD:if (paccu>0) accu[paccu-1]=__Soft2HardInk(ae,accu[paccu-1],didx);break;
				case E_COMPUTE_OPERATION_HARD2SOFT:if (paccu>0) accu[paccu-1]=__Hard2SoftInk(ae,accu[paccu-1],didx);break;
				case E_COMPUTE_OPERATION_PEEK:if (paccu>0) accu[paccu-1]=ae->mem[ae->activebank][(unsigned short int)accu[paccu-1]];break;
				/* functions with strings */
				case E_COMPUTE_OPERATION_GETNOP:if (paccu>0) {
								      int integeridx;
								      integeridx=floor(accu[paccu-1]);

								      if (integeridx>=0 && integeridx<nbcomputestack && computestack[integeridx].string) {
									      accu[paccu-1]=__GETNOP(ae,computestack[integeridx].string,didx);
									      MemFree(computestack[integeridx].string);
									      computestack[integeridx].string=NULL;
								      } else {
									      if (integeridx>=0 && integeridx<nbcomputestack) {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"GETNOP function needs a proper string\n");
										} else {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"GETNOP internal error (wrong string index)\n");
										}
									}
								} else {
									MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"GETNOP is empty\n");
								}
							       break;
							       /* CC GETNOP */
				case E_COMPUTE_OPERATION_GETTICK:if (paccu>0) {
								      int integeridx;
								      integeridx=floor(accu[paccu-1]);

								      if (integeridx>=0 && integeridx<nbcomputestack && computestack[integeridx].string) {
									      accu[paccu-1]=__GETTICK(ae,computestack[integeridx].string,didx);
									      MemFree(computestack[integeridx].string);
									      computestack[integeridx].string=NULL;
								      } else {
									      if (integeridx>=0 && integeridx<nbcomputestack) {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"GETTICK function needs a proper string\n");
										} else {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"GETTICK internal error (wrong string index)\n");
										}
									}
								} else {
									MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"GETTICK is empty\n");
								}
							       break;
							       /* CC GETNOP */
				case E_COMPUTE_OPERATION_DURATION:if (paccu>0) {
								      int integeridx;
								      integeridx=floor(accu[paccu-1]);

								      if (integeridx>=0 && integeridx<nbcomputestack && computestack[integeridx].string) {
									      accu[paccu-1]=__DURATION(ae,computestack[integeridx].string,didx);
									      MemFree(computestack[integeridx].string);
									      computestack[integeridx].string=NULL;
								      } else {
									      if (integeridx>=0 && integeridx<nbcomputestack) {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"DURATION function needs a proper string\n");
										} else {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"DURATION internal error (wrong string index)\n");
										}
									}
								} else {
									MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"DURATION is empty\n");
								}
							       break;
				case E_COMPUTE_OPERATION_FILESIZE:if (paccu>0) {
								      int integeridx;
								      integeridx=floor(accu[paccu-1]);

								      if (integeridx>=0 && integeridx<nbcomputestack && computestack[integeridx].string) {
									      accu[paccu-1]=__FILESIZE(ae,computestack[integeridx].string,didx);
									      MemFree(computestack[integeridx].string);
									      computestack[integeridx].string=NULL;
								      } else {
									      if (integeridx>=0 && integeridx<nbcomputestack) {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"FILESIZE function needs a proper string\n");
										} else {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"FILESIZE internal error (wrong string index)\n");
										}
									}
								} else {
									MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"DURATION is empty\n");
								}
							       break;
							       /* CC GETNOP */
				case E_COMPUTE_OPERATION_GETSIZE:if (paccu>0) {
								      int integeridx;
								      integeridx=floor(accu[paccu-1]);

								      if (integeridx>=0 && integeridx<nbcomputestack && computestack[integeridx].string) {
									      accu[paccu-1]=__GETSIZE(ae,computestack[integeridx].string,didx);
									      MemFree(computestack[integeridx].string);
									      computestack[integeridx].string=NULL;
								      } else {
									      if (integeridx>=0 && integeridx<nbcomputestack) {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"GETSIZE function needs a proper string\n");
										} else {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"GETSIZE internal error (wrong string index)\n");
										}
									}
								} else {
									MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"GETTICK is empty\n");
								}
							       break;
							       /* CC GETNOP */
				case E_COMPUTE_OPERATION_IS_REGISTER:if (paccu>0) {
								      int integeridx;
								      integeridx=floor(accu[paccu-1]);

								      if (integeridx>=0 && integeridx<nbcomputestack && computestack[integeridx].string) {
									      accu[paccu-1]=__IS_REGISTER(ae,computestack[integeridx].string);
									      MemFree(computestack[integeridx].string);
									      computestack[integeridx].string=NULL;
								      } else {
									      if (integeridx>=0 && integeridx<nbcomputestack) {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"IS_REGISTER function needs a proper string\n");
										} else {
											MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"IS_REGISTER internal error (wrong string index)\n");
										}
									}
								} else {
									MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"IS_REGISTERGETTICK is empty\n");
								}
							       break;
							       /* CC GETNOP */
				default:MakeError(ae,GetExpIdx(ae,didx),GetCurrentFile(ae),GetExpLine(ae,didx),"invalid computing state! (%d)\n",computestack[i].operator);paccu=0;
			}
			if (!paccu) {
				if (zeexpression[0]=='&') {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"Missing operand for calculation [%s] Did you use & for an hexadecimal value?\n",TradExpression(zeexpression));
				} else {
					MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"Missing operand for calculation [%s]\n",TradExpression(zeexpression));
				}
				accu_err=1;
				break;
			}
		}
	}
	if (!original) {
		MemFree(zeexpression);
	}
	if (parenth) {
		MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"missing parenthesis in expression\n");
	}
	if (paccu==1) {
		return accu[0];
	} else if (!accu_err) {
		if (paccu) {
			MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"Missing operator\n");
		} else {
			MakeError(ae,GetExpIdx(ae,didx),GetExpFile(ae,didx),GetExpLine(ae,didx),"Missing operand for calculation\n");
		}
		return 0;
	} else {
		return 0;
	}
}
int RoundComputeExpressionCore(struct s_assenv *ae,char *zeexpression,int ptr,int didx) {
	return floor(ComputeExpressionCore(ae,zeexpression,ptr,didx)+ae->rough);
}

void ExpressionSetDicoVar(struct s_assenv *ae,char *name, double v, int var_external)
{
	#undef FUNC
	#define FUNC "ExpressionSetDicoVar"

	struct s_expr_dico curdic;
	curdic.name=TxtStrDup(name);
	curdic.crc=GetCRC(name);
	curdic.v=v;
	curdic.iw=ae->idx;
	curdic.autorise_export=ae->autorise_export;
	curdic.external=var_external;
	//ObjectArrayAddDynamicValueConcat((void**)&ae->dico,&ae->idic,&ae->mdic,&curdic,sizeof(curdic));
	if (SearchLabel(ae,curdic.name,curdic.crc)) {
		MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"cannot create variable [%s] as there is already a label with the same name\n",name);
		MemFree(curdic.name);
		return;
	}
	InsertDicoToTree(ae,&curdic);
}

double ComputeExpression(struct s_assenv *ae,char *expr, int ptr, int didx, int expected_eval)
{
	#undef FUNC
	#define FUNC "ComputeExpression"

	char *ptr_exp,*ptr_exp2;
	int crc,idx=0,ialias,touched;
	double v;
	struct s_alias curalias;
	struct s_expr_dico *curdic;


	while (!ae->AutomateExpressionDecision[((int)expr[idx])&0xFF]) idx++;

	switch (ae->AutomateExpressionDecision[((int)expr[idx])&0xFF]) {
		/*****************************************
		          M A K E     A L I A S
		*****************************************/
		case '~':
			memset(&curalias,0,sizeof(curalias));
			ptr_exp=expr+idx;
			*ptr_exp=0; // on scinde l'alias de son texte
			ptr_exp2=ptr_exp+1;
#if TRACE_COMPUTE_EXPRESSION
printf("MakeAlias (1) EXPR=[%s EQU %s]\n",expr,ptr_exp2);
#endif
			
			/* alias locaux ou de proximité */
			if (strchr("@.",expr[0])) {
#if TRACE_COMPUTE_EXPRESSION
printf("WARNING! alias is local! [%s]\n",expr);
#endif
				/* local label creation does not handle formula in tags */
				curalias.alias=TranslateTag(ae,TxtStrDup(expr),&touched,0,E_TAGOPTION_NONE);
				curalias.alias=MakeLocalLabel(ae,curalias.alias,NULL);
			} else if (strchr(expr,'{')) {
#if TRACE_COMPUTE_EXPRESSION
printf("WARNING! alias has tag! [%s]\n",expr);
#endif
				/* alias name contains formula */
				curalias.alias=TranslateTag(ae,TxtStrDup(expr),&touched,0,E_TAGOPTION_NONE);
#if TRACE_COMPUTE_EXPRESSION
printf("MakeAlias (2) EXPR=[%s EQU %s]\n",expr,ptr_exp2);
#endif
			} else {
				curalias.alias=TxtStrDup(expr);
			}

			/* handle module prefix */
                        if (curalias.alias[0]!='@' && ae->module && ae->modulen) {
                                char *newaliasname;

                                newaliasname=MemMalloc(strlen(curalias.alias)+ae->modulen+2);
                                strcpy(newaliasname,ae->module);
                                strcat(newaliasname,ae->module_separator);
                                strcat(newaliasname,curalias.alias);
                                MemFree(curalias.alias);
                                curalias.alias=newaliasname;
                        }
			curalias.crc=GetCRC(curalias.alias);
			curalias.ptr=ae->codeadr;
			curalias.lz=ae->ilz;

			if ((ialias=SearchAlias(ae,curalias.crc,curalias.alias))>=0) {
				MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"Duplicate alias [%s]\n",expr);
				MemFree(curalias.alias);
			} else if (SearchLabel(ae,curalias.alias,curalias.crc)) {
				MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"Alias cannot override existing label [%s]\n",expr);
				MemFree(curalias.alias);
			} else if (SearchDico(ae,curalias.alias,curalias.crc)) {
				MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"Alias cannot override existing variable [%s]\n",expr);
				MemFree(curalias.alias);
			} else {
				curalias.translation=MemMalloc(strlen(ptr_exp2)+1+2);
				sprintf(curalias.translation,"(%s)",ptr_exp2);
#if TRACE_COMPUTE_EXPRESSION
printf("MakeAlias (3) EXPR=[%s EQU %s]\n",expr,ptr_exp2);
printf("alias translation [%s] -> ",curalias.translation);fflush(stdout);
#endif
				ExpressionFastTranslate(ae,&curalias.translation,2); // FAST type 2 replace at least $ value
#if TRACE_COMPUTE_EXPRESSION
printf("%s\n",curalias.translation);
#endif
				curalias.len=strlen(curalias.translation);
				curalias.autorise_export=ae->autorise_export;
				curalias.iw=ae->idx;
				ObjectArrayAddDynamicValueConcat((void**)&ae->alias,&ae->ialias,&ae->malias,&curalias,sizeof(curalias));
				CheckAndSortAliases(ae);
			}
			*ptr_exp='~'; // on remet l'alias en place
#if TRACE_COMPUTE_EXPRESSION
printf("MakeAlias end with alias=[%s]=[%s]\n",curalias.alias,curalias.translation);
printf("***********\n");
#endif
			return 0;
		/*****************************************
		               S E T     V A R
		*****************************************/
		case '=':
#if TRACE_COMPUTE_EXPRESSION
			printf("SETVAR\n");
#endif
			/* patch NOT 
			 this is a variable assign if there is no other comparison operator after '='
			 BUT we may have ! which stand for NOT but is also a comparison operator...
			*/
			if (ae->AutomateExpressionDecision[((int)expr[idx+1])&0xFF]==0 || expr[idx+1]=='!') {
				if (expected_eval) {
					if (ae->maxam) {
						/* maxam mode AND expected a value -> force comparison */
					} else {
						/* use of a single '=' but expected a comparison anyway */
						MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"meaningless use of an expression [%s]\n",expr);
						return 0;
					}
				} else {
					/* ASSIGN */
					if ((expr[0]<'A' || expr[0]>'Z') && expr[0]!='_') {
						MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"variable name must begin by a letter or '_' [%s]\n",expr);
						return 0;
					} else {
						char *dblexp;
						char operatorassignment;

						ptr_exp=expr+idx;
						dblexp=TxtStrDup(ptr_exp+1);
						// assign need to fasttranslate proximity labels
						v=ComputeExpressionCore(ae,dblexp,ptr,didx);
						*ptr_exp=0;
						/* patch operator+assign value */
						switch (ptr_exp[-1]) {
							case '+':
							case '-':
							case '*':
							case '/':
							case '^':
							case '&':
							case '|':
							case '%':
							case ']':
							case '[':
								operatorassignment=ptr_exp[-1];ptr_exp[-1]=0;break;
							default:operatorassignment=0;break;
						}

						crc=GetCRC(expr);
						if ((ialias=SearchAlias(ae,crc,expr))>=0) {
							MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"Variable cannot override existing alias [%s]\n",expr);
							return 0;
						}
						curdic=SearchDico(ae,expr,crc);
						if (curdic) {
							switch (operatorassignment) {
								default:printf("warning remover\n");break;
								case 0:curdic->v=v;break;
								case '+':curdic->v+=v;ptr_exp[-1]='+';break;
								case '-':curdic->v-=v;ptr_exp[-1]='-';break;
								case '*':curdic->v*=v;ptr_exp[-1]='*';break;
								case '/':curdic->v/=v;ptr_exp[-1]='/';break;
								/* bit operations */
								case '|':curdic->v=((int)curdic->v)|((int)v);ptr_exp[-1]='|';break;
								case '&':curdic->v=((int)curdic->v)&((int)v);ptr_exp[-1]='&';break;
								case '^':curdic->v=((int)curdic->v)^((int)v);ptr_exp[-1]='^';break;
								case '%':curdic->v=((int)curdic->v)%((int)v);ptr_exp[-1]='%';break;
								case ']':curdic->v=((int)curdic->v)>>((int)v);ptr_exp[-1]=']';
									 if (v>31 || v<-31) {
										if (!ae->nowarning) {
                                                                			rasm_printf(ae,KWARNING"Warning - shifting %d is architecture dependant, result forced to ZERO\n",(int)v);
															if (ae->erronwarn) MaxError(ae);
										}
										curdic->v=0;
									 }
									 break;
								case '[':curdic->v=((int)curdic->v)<<((int)v);ptr_exp[-1]='[';
									 if (v>31 || v<-31) {
										if (!ae->nowarning) {
                                                                			rasm_printf(ae,KWARNING"Warning - shifting %d is architecture dependant, result forced to ZERO\n",(int)v);
															if (ae->erronwarn) MaxError(ae);
										}
										curdic->v=0;
									 }
									 break;
							}
						} else {
							switch (operatorassignment) {
								default: /* cannot do operator on non existing variable */
									MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"Cannot do an operator assignment on non existing variable [%s]\n",expr);
									return 0;
								case 0: /* assign a new variable */
									ExpressionSetDicoVar(ae,expr,v,0);
									break;
							}
						}
						*ptr_exp='=';
						return v;
					}
				}
			}
			break;
		/*****************************************
		     P U R E    E X P R E S S I O N
		*****************************************/
		default:break;
	}
	return ComputeExpressionCore(ae,expr,ptr,didx);
}
int RoundComputeExpression(struct s_assenv *ae,char *expr, int ptr, int didx, int expression_expected) {
	return floor(ComputeExpression(ae,expr,ptr,didx,expression_expected)+ae->rough);
}

/*
	ExpressionFastTranslate
	
	purpose: translate all known symbols in an expression (especially variables acting like counters)

0:
1:
2: (equ declaration)
*/
void ExpressionFastTranslate(struct s_assenv *ae, char **ptr_expr, int fullreplace)
{
	#undef FUNC
	#define FUNC "ExpressionFastTranslate"

	struct s_label *curlabel;
	struct s_expr_dico *curdic;
	static char *varbuffer=NULL;
	static int ivar,maxivar=1;
	char curval[256]={0};
	int c,lenw=0,idx=0,crc,startvar=0,newlen,ialias,found_replace,yves,dek,reidx,lenbuf,rlen,tagoffset;
	double v;
	char tmpuchar[16];
	char *expr,*locallabel;
	int curly=0,curlyflag=0;
	char *Automate;
	int recurse=-1,recursecount=0;

	if (!ae || !ptr_expr) {
		if (varbuffer) MemFree(varbuffer);
		varbuffer=NULL;
		maxivar=1;
		ivar=0;
		return;
	}
	/* be sure to have at least some bytes allocated */
	StateMachineResizeBuffer(&varbuffer,128,&maxivar);
	expr=*ptr_expr;

	ivar=0;

#if TRACE_COMPUTE_EXPRESSION
printf("fast [%s]\n",expr);
#endif

	while (!ae->AutomateExpressionDecision[((int)expr[idx])&0xFF]) idx++;

	switch (ae->maxam) {
		default:
		case 0: /* full check */
			if (expr[idx]=='~' || (expr[idx]=='=' && expr[idx+1]!='=')) {reidx=idx+1;break;}
			reidx=0;
			break;
		case 1: /* partial check with maxam */
			if (expr[idx]=='~') {reidx=idx+1;break;}
			reidx=0;
			break;
	}

	idx=0;
	/* is there ascii char? */
	while ((c=expr[idx])!=0) {
		if (c=='\'' || c=='"') {
			/* one char escape code */
			if (expr[idx+1]=='\\') {
				if (expr[idx+2] && expr[idx+3]==c) {
					/* no charset conversion for escaped chars */
					c=expr[idx+2];
					switch (c) {
						case 'b':c='\b';break;
						case 'v':c='\v';break;
						case 'f':c='\f';break;
						case '0':c='\0';break;
						case 'r':c='\r';break;
						case 'n':c='\n';break;
						case 't':c='\t';break;
						default:break;
					}
					sprintf(tmpuchar,"#%03X",c);
					memcpy(expr+idx,tmpuchar,4);
					idx+=3;
				} else {
					//MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"expression [%s] - Only single escaped char may be quoted\n",expr);
					//expr[0]=0;
					//return;
					idx++;
					while (expr[idx] && expr[idx]!=c) idx++;
				}
			} else if (expr[idx+1] && expr[idx+2]==c) {
				if (idx>=12 && strncmp("IS_REGISTER(",&expr[idx-12],12)==0) {
					// do not convert simple char with this function!
				} else {
					sprintf(tmpuchar,"#%02X",ae->charset[((unsigned int)expr[idx+1])&0xFF]);
					memcpy(expr+idx,tmpuchar,3);
				}
				idx+=2;
			} else {
				//printf("FAST => moar than one quoted char\n");
				//MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"expression [%s] - Only single char may be quoted\n",expr);
				//expr[0]=0;
				//return;
				idx++;
				while (expr[idx] && expr[idx]!=c) idx++;
			}
		}
		idx++;
	}
	
	idx=reidx;
	while ((c=expr[idx])!=0) {
		switch (c) {
			/* string in expression */
			case '"':
			case '\'':
				//printf("FAST => skip string [%s]\n",expr);
				idx++;
				while (expr[idx] && expr[idx]!=c) idx++;
				if (expr[idx]) idx++;
				ivar=0;
				break;
			/* operator / parenthesis */
			case '!':
			case '=':
			case '>':
			case '<':
			case '(':
			case ')':
			case ']':
			case '[':
			case '*':
			case '/':
			case '+':
			case '~':
			case '-':
			case '^':
			case 'm':
			case '|':
			case '&':
				idx++;
				break;
			default:
				startvar=idx;
				if (ae->AutomateExpressionValidCharFirst[((int)c)&0xFF]) {
					varbuffer[ivar++]=c;
					if (c=='{') {
						/* this is only tag and not a formula */
						curly++;
					}
					StateMachineResizeBuffer(&varbuffer,ivar,&maxivar);
					idx++;
					c=expr[idx];

					Automate=ae->AutomateExpressionValidChar;
					while (Automate[((int)c)&0xFF]) {
						if (c=='{') {
							curly++;
							curlyflag=1;					
							Automate=ae->AutomateExpressionValidCharExtended;
						} else if (c=='}') {
							curly--;
							if (!curly) {
								Automate=ae->AutomateExpressionValidChar;
							}
						}
						varbuffer[ivar++]=c;
						StateMachineResizeBuffer(&varbuffer,ivar,&maxivar);
						idx++;
						c=expr[idx];
					}
				}
				varbuffer[ivar]=0;
				if (!ivar) {
					MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"invalid expression [%s] c=[%c] idx=%d\n",expr,c,idx);
					return;
				} else if (curly) {
					MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"wrong curly brackets in expression [%s]\n",expr);
					return;
				}
		}
		if (ivar && (varbuffer[0]<'0' || varbuffer[0]>'9')) {
			/* numbering var or label */
			if (curlyflag) {
				char *minivarbuffer;
				int touched;
				minivarbuffer=TranslateTag(ae,TxtStrDup(varbuffer), &touched,0,E_TAGOPTION_NONE|(fullreplace?0:E_TAGOPTION_PRESERVE));
				StateMachineResizeBuffer(&varbuffer,strlen(minivarbuffer)+1,&maxivar);
				strcpy(varbuffer,minivarbuffer);
				newlen=strlen(varbuffer);
				lenw=strlen(expr);
				/* must update source */
				if (newlen>ivar) {
					/* realloc bigger */
					expr=*ptr_expr=MemRealloc(expr,lenw+newlen-ivar+1);
				}
				if (newlen!=ivar ) {
					lenw=strlen(expr);
					MemMove(expr+startvar+newlen,expr+startvar+ivar,lenw-startvar-ivar+1);
				}
				strncpy(expr+startvar,minivarbuffer,newlen); /* copy without zero terminator */
				idx=startvar+newlen;
				/***/
				MemFree(minivarbuffer);
				curlyflag=0;
				/******* ivar must be updated in case of label or alias following ***********/
				ivar=newlen;
			}

			/* recherche dans dictionnaire et remplacement */
			crc=GetCRC(varbuffer);
			found_replace=0;
			/* pour les affectations ou les tests conditionnels on ne remplace pas le dico (pour le Push oui par contre!) */
			if (fullreplace) {
#if TRACE_COMPUTE_EXPRESSION
printf("ExpressionFastTranslate (full) => varbuffer=[%s] lz=%d\n",varbuffer,ae->lz);
#endif
				if (varbuffer[0]=='$' && !varbuffer[1]) {
					if (ae->lz==-1) {
						#ifdef OS_WIN
						snprintf(curval,sizeof(curval)-1,"%d",ae->codeadr);
						newlen=strlen(curval);
						#else
						newlen=snprintf(curval,sizeof(curval)-1,"%d",ae->codeadr);
						#endif
						lenw=strlen(expr);
						if (newlen>ivar) {
							/* realloc bigger */
							expr=*ptr_expr=MemRealloc(expr,lenw+newlen-ivar+1);
						}
						if (newlen!=ivar ) {
							MemMove(expr+startvar+newlen,expr+startvar+ivar,lenw-startvar-ivar+1);
							found_replace=1;
						}
						strncpy(expr+startvar,curval,newlen); /* copy without zero terminator */
						idx=startvar+newlen;
						ivar=0;
					}
					/* qu'on le remplace ou pas on passe a la suite */
					found_replace=1;
				} else {
					curdic=SearchDico(ae,varbuffer,crc);
					if (curdic) {
						v=curdic->v;
#if TRACE_COMPUTE_EXPRESSION
printf("ExpressionFastTranslate (full) -> replace var (%s=%0.1lf)\n",varbuffer,v);
#endif

						#ifdef OS_WIN
						snprintf(curval,sizeof(curval)-1,"%lf",v);
						newlen=TrimFloatingPointString(curval);
						#else
						snprintf(curval,sizeof(curval)-1,"%lf",v);
						newlen=TrimFloatingPointString(curval);
						#endif
						lenw=strlen(expr);
						if (newlen>ivar) {
							/* realloc bigger */
							expr=*ptr_expr=MemRealloc(expr,lenw+newlen-ivar+1);
						}
						if (newlen!=ivar ) {
							MemMove(expr+startvar+newlen,expr+startvar+ivar,lenw-startvar-ivar+1);
						}
						strncpy(expr+startvar,curval,newlen); /* copy without zero terminator */
						idx=startvar+newlen;
						ivar=0;
						found_replace=1;
					}
				}
			}
			/* on cherche aussi dans les labels existants => priorité aux modules!!! */   // modulmodif => pas utile?
			if (!found_replace) {
				curlabel=SearchLabel(ae,varbuffer,crc);
				if (curlabel) {
					if (!curlabel->lz || ae->stage>1) {
						yves=curlabel->ptr;

						#ifdef OS_WIN
						snprintf(curval,sizeof(curval)-1,"%d",yves);
						newlen=strlen(curval);
						#else
						newlen=snprintf(curval,sizeof(curval)-1,"%d",yves);
						#endif
						lenw=strlen(expr);
						if (newlen>ivar) {
							/* realloc bigger */
							expr=*ptr_expr=MemRealloc(expr,lenw+newlen-ivar+1);
						}
						if (newlen!=ivar ) {
							MemMove(expr+startvar+newlen,expr+startvar+ivar,lenw-startvar-ivar+1);
						}
						strncpy(expr+startvar,curval,newlen); /* copy without zero terminator */
						found_replace=1;
						idx=startvar+newlen;
						ivar=0;
					}
				}		
			}
			/* non trouve on cherche dans les alias */
			if (!found_replace) {

				if (ae->module) {
					char *dblvarbuffer;
// handle module!!!
#if TRACE_COMPUTE_EXPRESSION
printf("ExpressionFastTranslate SearchAlias inside module => varbuffer=[%s]\n",varbuffer);
#endif

					dblvarbuffer=MemMalloc(strlen(varbuffer)+strlen(ae->module)+2);
					strcpy(dblvarbuffer,ae->module);
					strcat(dblvarbuffer,ae->module_separator);
					strcat(dblvarbuffer,varbuffer);
					ialias=SearchAlias(ae,GetCRC(dblvarbuffer),dblvarbuffer);
					MemFree(dblvarbuffer);
				} else {
					ialias=-1;
				}

				if (ialias>=0 || (ialias=SearchAlias(ae,crc,varbuffer))>=0) {
					newlen=ae->alias[ialias].len;
					lenw=strlen(expr);
					/* infinite replacement check */
					if (recurse<=startvar) {
						/* recurse maximum count is a mix of alias len and alias number */
						if (recursecount>ae->ialias+ae->alias[ialias].len) {
							if (strchr(expr,'~')!=NULL) *strchr(expr,'~')=0;
							MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"alias definition of %s has infinite recursivity\n",expr);
							expr[0]=0; /* avoid some errors due to shitty definition */
							return;
						} else {
							recursecount++;
						}
					}
					if (newlen>ivar) {
						/* realloc bigger */
						expr=*ptr_expr=MemRealloc(expr,lenw+newlen-ivar+1);
					}
					if (newlen!=ivar) {
						MemMove(expr+startvar+newlen,expr+startvar+ivar,lenw-startvar-ivar+1);
					}
					strncpy(expr+startvar,ae->alias[ialias].translation,newlen); /* copy without zero terminator */
					found_replace=1;
					/* need to parse again alias because of delayed declarations */
					recurse=startvar;
					idx=startvar;
					ivar=0;
				} else {
				}
			}
			if (!found_replace) {
	//printf("fasttranslate test local label\n");
				/* non trouve c'est peut-etre un label local - mais pas de l'octal */
				if (varbuffer[0]=='@' && (varbuffer[1]<'0' || varbuffer[1]>'9')) {
					char *zepoint;
					lenbuf=strlen(varbuffer);
#if TRACE_COMPUTE_EXPRESSION
printf("MakeLocalLabel(ae,varbuffer,&dek); (1)\n");
#endif
					locallabel=MakeLocalLabel(ae,varbuffer,&dek);
//printf("exprin =[%s]   rlen=%d dek-lenbuf=%d\n",expr,rlen,dek-lenbuf);
					/*** le grand remplacement ***/
					/* local to macro or loop */
					rlen=strlen(expr+startvar+lenbuf)+1;
					expr=*ptr_expr=MemRealloc(expr,strlen(expr)+dek+1);
					/* move end of expression in order to insert local ID */
					zepoint=strchr(varbuffer,'.');
					if (zepoint) {
						/* far proximity access */
						int suffixlen,dotpos;
						dotpos=(zepoint-varbuffer);
						suffixlen=lenbuf-dotpos;

						MemMove(expr+startvar+dotpos+dek,expr+startvar+dotpos,rlen+suffixlen);
						strncpy(expr+startvar+dotpos,locallabel,dek);
					} else {
						/* legacy */
						MemMove(expr+startvar+lenbuf+dek,expr+startvar+lenbuf,rlen);
						strncpy(expr+startvar+lenbuf,locallabel,dek);
					}
					idx+=dek;
					MemFree(locallabel);
					found_replace=1;
//printf("exprout=[%s]\n",expr);
				} else if (varbuffer[0]=='.' && (varbuffer[1]<'0' || varbuffer[1]>'9')) {
					/* proximity label */
					lenbuf=strlen(varbuffer);
//printf("MakeLocalLabel(ae,varbuffer,&dek); (2)\n");
					locallabel=MakeLocalLabel(ae,varbuffer,&dek);
					/*** le grand remplacement ***/
					rlen=strlen(expr+startvar+lenbuf)+1;
					dek=strlen(locallabel);
//printf("exprin =[%s]   rlen=%d dek-lenbuf=%d\n",expr,rlen,dek-lenbuf);
					expr=*ptr_expr=MemRealloc(expr,strlen(expr)+dek-lenbuf+1);
					MemMove(expr+startvar+dek,expr+startvar+lenbuf,rlen);
					strncpy(expr+startvar,locallabel,dek);
					idx+=dek-lenbuf;
					MemFree(locallabel);
#if TRACE_COMPUTE_EXPRESSION
printf("exprout=[%s]\n",expr);
#endif

//@@TODO ajouter une recherche d'alias?

				} else if (varbuffer[0]=='{') {
					if (strncmp(varbuffer,"{BANK}",6)==0 || strncmp(varbuffer,"{PAGE}",6)==0) tagoffset=6; else
					if (strncmp(varbuffer,"{PAGESET}",9)==0) tagoffset=9; else
					if (strncmp(varbuffer,"{SIZEOF}",8)==0) tagoffset=8; else
					{
						tagoffset=0;
						MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"Unknown prefix tag\n");
					}
				
					if (varbuffer[tagoffset]=='.') {
						int lenadd;
						startvar+=tagoffset;
						lenbuf=strlen(varbuffer+tagoffset);
						locallabel=MakeLocalLabel(ae,varbuffer+tagoffset,NULL);
						/*** le grand remplacement meriterait une modif pour DEK dans MakeLocalLabel ***/
						rlen=strlen(expr+startvar+lenbuf)+1;
						lenadd=strlen(locallabel)-strlen(varbuffer+tagoffset);
						expr=*ptr_expr=MemRealloc(expr,strlen(expr)+lenadd+1);

//printf("expr[%s] move to %d from %d len=%d\n",expr,startvar+lenadd,startvar,rlen+lenbuf);
						MemMove(expr+startvar+lenadd,expr+startvar,rlen+lenbuf);
						strncpy(expr+startvar,locallabel,lenadd);

						MemFree(locallabel);
						found_replace=1;
						idx+=lenadd;
					} else	if (varbuffer[tagoffset]=='@') {
						char *zepoint;
						startvar+=tagoffset;
						lenbuf=strlen(varbuffer+tagoffset);
//printf("MakeLocalLabel(ae,varbuffer,&dek); (3)\n");
						locallabel=MakeLocalLabel(ae,varbuffer+tagoffset,&dek);
//printf("local [%s] =>",locallabel);
						/*** le grand remplacement ***/
						rlen=strlen(expr+startvar+lenbuf)+1;
						expr=*ptr_expr=MemRealloc(expr,strlen(expr)+dek+1);
						/* move end of expression in order to insert local ID */
						zepoint=strchr(varbuffer+tagoffset,'.'); // +tagoffset
						if (zepoint) {
							/* far proximity access */
							int suffixlen,dotpos;
							dotpos=(zepoint-varbuffer);
							suffixlen=lenbuf-dotpos;
		//printf("prox [%s] => ",expr);
							MemMove(expr+startvar+dotpos+dek,expr+startvar+dotpos,rlen+suffixlen);
							strncpy(expr+startvar+dotpos,locallabel,dek);
						} else {
							/* legacy */
		//printf("legacy [%s] => ",expr);
							MemMove(expr+startvar+lenbuf+dek,expr+startvar+lenbuf,rlen);
							strncpy(expr+startvar+lenbuf,locallabel,dek);
						}
						idx+=dek;
						MemFree(locallabel);
						found_replace=1;
	//printf("exprout=[%s]\n",expr);
					} else if (varbuffer[tagoffset]=='$') {
						int tagvalue=-1;
						/*
						 * There is no {SLOT}$ support...
						 */
						if (strcmp(varbuffer,"{BANK}$")==0) {
							if (ae->forcecpr) {
								if (ae->activebank<32) {
									tagvalue=ae->activebank;
								} else {
									MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"expression [%s] cannot use BANK $ in a temporary space!\n",TradExpression(expr));
									tagvalue=0;
								}
							} else if (ae->forcesnapshot) {
								if (ae->activebank<BANK_MAX_NUMBER) {
									/* on autorise le préfixe BANK en snapshot avec une subtilité */
								if (ae->bankset[ae->activebank>>2]) {
									tagvalue=ae->activebank+(ae->codeadr>>14); /* dans un bankset on tient compte de l'adresse */
								} else {
									tagvalue=ae->activebank;
								}
									
								} else {
									MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"expression [%s] cannot use BANK $ in a temporary space!\n",TradExpression(expr));
									tagvalue=0;
								}
							}
						} else if (strcmp(varbuffer,"{PAGE}$")==0) {
							if (ae->activebank<BANK_MAX_NUMBER) {
								if (ae->bankset[ae->activebank>>2]) {
									tagvalue=ae->bankgate[(ae->activebank&0x1FC)+(ae->codeadr>>14)];
								} else {
									tagvalue=ae->bankgate[ae->activebank];
								}
							} else {
								MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"expression [%s] cannot use PAGE $ in a temporary space!\n",TradExpression(expr));
								tagvalue=ae->activebank;
							}
						} else if (strcmp(varbuffer,"{PAGESET}$")==0) {
							if (ae->activebank<BANK_MAX_NUMBER) {
								tagvalue=ae->setgate[ae->activebank];
								//if (ae->activebank>3) tagvalue=((ae->activebank>>2)-1)*8+0xC2; else tagvalue=0xC0;
							} else {
								MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"expression [%s] cannot use PAGESET $ in a temporary space!\n",TradExpression(expr));
								tagvalue=ae->activebank;
							}
						}
						/* replace */
						#ifdef OS_WIN
						snprintf(curval,sizeof(curval)-1,"%d",tagvalue);
						newlen=strlen(curval);
						#else
						newlen=snprintf(curval,sizeof(curval)-1,"%d",tagvalue);
						#endif
						lenw=strlen(expr);
						if (newlen>ivar) {
							/* realloc bigger */
							expr=*ptr_expr=MemRealloc(expr,lenw+newlen-ivar+1);
						}
						if (newlen!=ivar ) {
							MemMove(expr+startvar+newlen,expr+startvar+ivar,lenw-startvar-ivar+1);
							found_replace=1;
						}
						strncpy(expr+startvar,curval,newlen); /* copy without zero terminator */
						idx=startvar+newlen;
						ivar=0;
						found_replace=1;
					}
				}
			}
			
			
			
			
			
			
			if (!found_replace && strcmp(varbuffer,"REPEAT_COUNTER")==0) {
				if (ae->ir) {
					yves=ae->repeat[ae->ir-1].repeat_counter;
					#ifdef OS_WIN
					snprintf(curval,sizeof(curval)-1,"%d",yves);
					newlen=strlen(curval);
					#else
					newlen=snprintf(curval,sizeof(curval)-1,"%d",yves);
					#endif
					lenw=strlen(expr);
					if (newlen>ivar) {
						/* realloc bigger */
						expr=*ptr_expr=MemRealloc(expr,lenw+newlen-ivar+1);
					}
					if (newlen!=ivar ) {
						MemMove(expr+startvar+newlen,expr+startvar+ivar,lenw-startvar-ivar+1);
						found_replace=1;
					}
					strncpy(expr+startvar,curval,newlen); /* copy without zero terminator */
					found_replace=1;
					idx=startvar+newlen;
					ivar=0;
				} else {
					MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"cannot use REPEAT_COUNTER outside repeat loop\n");
				}
			}
			if (!found_replace && strcmp(varbuffer,"WHILE_COUNTER")==0) {
				if (ae->iw) {
					yves=ae->whilewend[ae->iw-1].while_counter;
					#ifdef OS_WIN
					snprintf(curval,sizeof(curval)-1,"%d",yves);
					newlen=strlen(curval);
					#else
					newlen=snprintf(curval,sizeof(curval)-1,"%d",yves);
					#endif
					lenw=strlen(expr);
					if (newlen>ivar) {
						/* realloc bigger */
						expr=*ptr_expr=MemRealloc(expr,lenw+newlen-ivar+1);
					}
					if (newlen!=ivar ) {
						MemMove(expr+startvar+newlen,expr+startvar+ivar,lenw-startvar-ivar+1);
						found_replace=1;
					}
					strncpy(expr+startvar,curval,newlen); /* copy without zero terminator */
					found_replace=1;
					idx=startvar+newlen;
					ivar=0;
				} else {
					MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"cannot use WHILE_COUNTER outside repeat loop\n");
				}
			}
			/* unknown symbol -> add to used symbol pool */
			if (!found_replace && ae->AutomateValidLabelFirst[varbuffer[0]&0xFF]) {
				InsertUsedToTree(ae,varbuffer,crc);
			}
		}
		ivar=0;
	}
}

void PushExpression(struct s_assenv *ae,int iw,enum e_expression zetype)
{
	#undef FUNC
	#define FUNC "PushExpression"
	
	struct s_expression curexp={0};
	int startptr=0;

	if (!ae->nocode) {
		curexp.iw=iw;
		curexp.wptr=ae->outputadr;
		curexp.zetype=zetype;
		curexp.ibank=ae->activebank;
		curexp.iorgzone=ae->io-1;
		curexp.lz=ae->lz;
		/* need the module to know where we are */
		if (ae->module) curexp.module=TxtStrDup(ae->module); else curexp.module=NULL;
		/* on traduit de suite les variables du dictionnaire pour les boucles et increments
			SAUF si c'est une affectation 
		*/
		if (!ae->wl[iw].e) {
			switch (zetype) {
				case E_EXPRESSION_J16C:
 					/* check non register usage */
					switch (GetCRC(ae->wl[iw].w)) {
						case CRC_IX:
						case CRC_IY:
						case CRC_MIX:
						case CRC_MIY:
							MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"invalid register usage\n",ae->maxptr);
						default:break;
					}
				case E_EXPRESSION_J8:
				case E_EXPRESSION_V8:
				case E_EXPRESSION_J16:
				case E_EXPRESSION_V16:
				case E_EXPRESSION_IM:startptr=-1;
							break;
				case E_EXPRESSION_IV8:
				case E_EXPRESSION_IV81:
				case E_EXPRESSION_IV16:startptr=-2;
							break;
				case E_EXPRESSION_3V8:startptr=-3;
							break;
				case E_EXPRESSION_RUN:
				case E_EXPRESSION_ZXRUN:
				case E_EXPRESSION_ZXSTACK:
				case E_EXPRESSION_BRS:break;
				default:break;
			}
			/* hack pourri pour gérer le $ */
			ae->codeadr+=startptr;
			/* ok mais les labels locaux des macros? */

			/* if external declared then fill some informations */
			if (ae->buildobj) {
				switch (zetype) {
					case E_EXPRESSION_0V8:
					case E_EXPRESSION_V8:
					case E_EXPRESSION_IV81:
					case E_EXPRESSION_IV8:
					case E_EXPRESSION_3V8:
						ae->external_mapping_size=1;
						break;
					case E_EXPRESSION_J16C:
					case E_EXPRESSION_J16:
					case E_EXPRESSION_V16:
					case E_EXPRESSION_0V16:
					case E_EXPRESSION_IV16:
						ae->external_mapping_size=2;
						break;
					case E_EXPRESSION_0V32:
						ae->external_mapping_size=4;
						break;
					case E_EXPRESSION_0VR:
					case E_EXPRESSION_0VRMike:
						ae->external_mapping_size=5;
						break;
					default:
						ae->external_mapping_size=0;
						break;
				}
			}
			if (ae->ir || ae->iw || ae->imacro) {
				curexp.reference=TxtStrDup(ae->wl[iw].w);
				ExpressionFastTranslate(ae,&curexp.reference,1);
			} else {
				ExpressionFastTranslate(ae,&ae->wl[iw].w,1);
			}
			ae->codeadr-=startptr;
		}
		/* calcul adresse de reference et post-incrementation pour sauter les data */
//printf("output=%X\n",ae->outputadr);
		switch (zetype) {
			case E_EXPRESSION_J8:curexp.ptr=ae->codeadr-1;ae->outputadr++;ae->codeadr++;break;
			case E_EXPRESSION_0V8:curexp.ptr=ae->codeadr;ae->outputadr++;ae->codeadr++;break;
			case E_EXPRESSION_V8:curexp.ptr=ae->codeadr-1;ae->outputadr++;ae->codeadr++;break;
			case E_EXPRESSION_0V16:curexp.ptr=ae->codeadr;ae->outputadr+=2;ae->codeadr+=2;break;
			case E_EXPRESSION_0V32:curexp.ptr=ae->codeadr;ae->outputadr+=4;ae->codeadr+=4;break;
			case E_EXPRESSION_0VR:curexp.ptr=ae->codeadr;ae->outputadr+=5;ae->codeadr+=5;break;
			case E_EXPRESSION_0VRMike:curexp.ptr=ae->codeadr;ae->outputadr+=5;ae->codeadr+=5;break;
			case E_EXPRESSION_J16C:
			case E_EXPRESSION_J16:
			case E_EXPRESSION_V16:curexp.ptr=ae->codeadr-1;ae->outputadr+=2;ae->codeadr+=2;break;
			case E_EXPRESSION_IV81:curexp.ptr=ae->codeadr-2;ae->outputadr++;ae->codeadr++;break;
			case E_EXPRESSION_IV8:curexp.ptr=ae->codeadr-2;ae->outputadr++;ae->codeadr++;break;
			case E_EXPRESSION_3V8:curexp.ptr=ae->codeadr-3;ae->outputadr++;ae->codeadr++;break;
			case E_EXPRESSION_IV16:curexp.ptr=ae->codeadr-2;ae->outputadr+=2;ae->codeadr+=2;break;
			case E_EXPRESSION_RST:curexp.ptr=ae->codeadr;ae->outputadr++;ae->codeadr++;break;
			case E_EXPRESSION_RSTC:curexp.ptr=ae->codeadr;ae->outputadr++;ae->codeadr++;break;
			case E_EXPRESSION_IM:curexp.ptr=ae->codeadr-1;ae->outputadr++;ae->codeadr++;break;
			case E_EXPRESSION_RUN:break;
			case E_EXPRESSION_ZXRUN:break;
			case E_EXPRESSION_ZXSTACK:break;
			case E_EXPRESSION_BRS:curexp.ptr=ae->codeadr;break; // minimum syndical
			default:break;
		}
//printf("output=%X maxptr=%X\n",ae->outputadr,ae->maxptr);
		if (ae->outputadr<=ae->maxptr) {  // = compare because done AFTER simili value assignment
			ObjectArrayAddDynamicValueConcat((void **)&ae->expression,&ae->ie,&ae->me,&curexp,sizeof(curexp));
		} else {
			int requested_block;
			int i,iscrunched;
			iscrunched=0;
			for (i=ae->ilz-1;i>=0;i--) {
				if (ae->lzsection[i].ibank==ae->activebank) {
					iscrunched=1;
					break;
				}
			}
			if (!iscrunched) {
				/* to avoid double error message */
				if (!ae->stop) MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"(PushExpr) output exceed limit %04X\n",ae->maxptr); else MaxError(ae);
				ae->stop=1;
				return;
			} else {
				// who cares!
			}
			if (ae->maxptr&0xFFFF) {
				rasm_printf(ae,KWARNING"Warning: Specific limits are not applied when using crunched sections, cause memory blocks are moved unpredictably\n");
				if (ae->erronwarn) MaxError(ae);
			}
#if TRACE_LZ
	printf("**output exceed limit** (PushExpr) extending memory space\n");
#endif
			requested_block=ae->outputadr>>16;
			ae->mem[ae->activebank]=MemRealloc(ae->mem[ae->activebank],(requested_block+1)*65536);
			ae->maxptr=(requested_block+1)*65536;
			// eventually write expression ^_^
			ObjectArrayAddDynamicValueConcat((void **)&ae->expression,&ae->ie,&ae->me,&curexp,sizeof(curexp));
		}
	} else {
		switch (zetype) {
			case E_EXPRESSION_J8:ae->outputadr++;ae->codeadr++;break;
			case E_EXPRESSION_0V8:ae->outputadr++;ae->codeadr++;break;
			case E_EXPRESSION_V8:ae->outputadr++;ae->codeadr++;break;
			case E_EXPRESSION_0V16:ae->outputadr+=2;ae->codeadr+=2;break;
			case E_EXPRESSION_0V32:ae->outputadr+=4;ae->codeadr+=4;break;
			case E_EXPRESSION_0VR:ae->outputadr+=5;ae->codeadr+=5;break;
			case E_EXPRESSION_0VRMike:ae->outputadr+=5;ae->codeadr+=5;break;
			case E_EXPRESSION_J16C:
			case E_EXPRESSION_J16:
			case E_EXPRESSION_V16:ae->outputadr+=2;ae->codeadr+=2;break;
			case E_EXPRESSION_IV81:ae->outputadr++;ae->codeadr++;break;
			case E_EXPRESSION_IV8:ae->outputadr++;ae->codeadr++;break;
			case E_EXPRESSION_3V8:ae->outputadr++;ae->codeadr++;break;
			case E_EXPRESSION_IV16:ae->outputadr+=2;ae->codeadr+=2;break;
			case E_EXPRESSION_RST:ae->outputadr++;ae->codeadr++;break;
			case E_EXPRESSION_RSTC:ae->outputadr++;ae->codeadr++;break;
			case E_EXPRESSION_IM:ae->outputadr++;ae->codeadr++;break;
			case E_EXPRESSION_RUN:break;
			case E_EXPRESSION_ZXRUN:break;
			case E_EXPRESSION_ZXSTACK:break;
			case E_EXPRESSION_BRS:break;
		}
		if (ae->outputadr<=ae->maxptr) { // = compare because done AFTER simili value assignment
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"(PushExpr) NOCODE output exceed limit %04X\n",ae->maxptr);
			FreeAssenv(ae);exit(3);
		}
	}
}

/*
The CP/M 2.2 directory has only one type of entry:

UU F1 F2 F3 F4 F5 F6 F7 F8 T1 T2 T3 EX S1 S2 RC   .FILENAMETYP....
AL AL AL AL AL AL AL AL AL AL AL AL AL AL AL AL   ................

UU = User number. 0-15 (on some systems, 0-31). The user number allows multiple
    files of the same name to coexist on the disc. 
     User number = 0E5h => File deleted
Fn - filename
Tn - filetype. The characters used for these are 7-bit ASCII.
       The top bit of T1 (often referred to as T1') is set if the file is 
     read-only.
       T2' is set if the file is a system file (this corresponds to "hidden" on 
     other systems). 
EX = Extent counter, low byte - takes values from 0-31
S2 = Extent counter, high byte.

      An extent is the portion of a file controlled by one directory entry.
    If a file takes up more blocks than can be listed in one directory entry,
    it is given multiple entries, distinguished by their EX and S2 bytes. The
    formula is: Entry number = ((32*S2)+EX) / (exm+1) where exm is the 
    extent mask value from the Disc Parameter Block.

S1 - reserved, set to 0.
RC - Number of records (1 record=128 bytes) used in this extent, low byte.
    The total number of records used in this extent is

    (EX & exm) * 128 + RC

    If RC is 80h, this extent is full and there may be another one on the disc.
    File lengths are only saved to the nearest 128 bytes.

AL - Allocation. Each AL is the number of a block on the disc. If an AL
    number is zero, that section of the file has no storage allocated to it
    (ie it does not exist). For example, a 3k file might have allocation 
    5,6,8,0,0.... - the first 1k is in block 5, the second in block 6, the 
    third in block 8.
     AL numbers can either be 8-bit (if there are fewer than 256 blocks on the
    disc) or 16-bit (stored low byte first). 
*/
int EDSK_getblockid(int *fb) {
	#undef FUNC
	#define FUNC "EDSK_getblockid"
	
	int i;
	for (i=0;i<180;i++) {
		if (fb[i]) {
			return i;
		}
	}
	return -1;
}
int EDSK_getdirid(struct s_edsk_wrapper *curwrap) {
	#undef FUNC
	#define FUNC "EDSK_getdirid"
	
	int ie;
	for (ie=0;ie<64;ie++) {
		if (curwrap->entry[ie].user==0xE5) {
#if TRACE_EDSK
	printf("getdirid returns %d\n",ie);
#endif
			return ie;
		}
	}
	return -1;
}
char *MakeAMSDOS_name(struct s_assenv *ae, char *reference_filename, int *amsdos_user)
{
	#undef FUNC
	#define FUNC "MakeAMSDOS_name"

	static char amsdos_name[12];
	char *filename,*jo;
	int i,ia;
	char *pp;

	filename=reference_filename;
	if ((jo=strchr(filename,':'))!=NULL) {
		*jo=0;
		*amsdos_user=atoi(reference_filename);
		filename=jo+1;
	} else {
		*amsdos_user=0;
	}

	/* remove path */
	while ((jo=strchr(filename,'/'))!=NULL) filename=jo+1;
	while ((jo=strchr(filename,'\\'))!=NULL) filename=jo+1;

	/* warning */
	if (strlen(filename)>12) {
		if (!ae->nowarning) {
			rasm_printf(ae,KWARNING"Warning - filename [%s] too long for AMSDOS, will be truncated\n",filename);
			if (ae->erronwarn) MaxError(ae);
		}
	} else if ((pp=strchr(filename,'.'))!=NULL) {
		if (pp-filename>8) {
			if (!ae->nowarning) {
				rasm_printf(ae,KWARNING"Warning - filename [%s] too long for AMSDOS, will be truncated\n",filename);
			if (ae->erronwarn) MaxError(ae);
			}
		}
	}
	/* copy filename */
	for (i=0;filename[i]!=0 && filename[i]!='.' && i<8;i++) {
		amsdos_name[i]=toupper(filename[i]);
	}
	/* fill with spaces */
	for (ia=i;ia<11;ia++) {
		amsdos_name[ia]=0x20;
	}
	/* looking for extension */
	for (;filename[i]!=0 && filename[i]!='.';i++);
	/* then copy it if any */
	if (filename[i]=='.') {
		i++;
		for (ia=0;filename[i]!=0 && ia<3;ia++) {
			amsdos_name[8+ia]=toupper(filename[i++]);
		}
	}
	amsdos_name[11]=0;
#if TRACE_EDSK
	printf("MakeAMSDOS_name [%s] -> [%s]\n",filename,amsdos_name);
#endif
	return amsdos_name;
}


void EDSK_load(struct s_assenv *ae,struct s_edsk_wrapper *curwrap, char *edskfilename, int face)
{
	#undef FUNC
	#define FUNC "EDSK_load"

	unsigned char header[256];
	unsigned char *data;
	int tracknumber,sidenumber,tracksize,disksize;
	int i,b,s,f,t,curtrack,sectornumber,sectorsize,sectorid,reallength;
	int currenttrackposition=0,currentsectorposition,tmpcurrentsectorposition;
	unsigned char checksectorid[9];
	int curblock=0,curoffset=0;
#if TRACE_EDSK
	printf("EDSK_Load('%s',%d);",edskfilename,face);
#endif
	if (FileReadBinary(edskfilename,(char*)&header,0x100)!=0x100) {
		rasm_printf(ae,KERROR"Cannot read EDSK header of [%s]!\n",edskfilename);
		FreeAssenv(ae);exit(ABORT_ERROR);
	}
	if (strncmp((char *)header,"MV - CPC",8)==0) {
		rasm_printf(ae,KAYGREEN"updating DSK to EDSK [%s] / creator: %s",edskfilename,header+34);
		
		tracknumber=header[34+14];
		sidenumber=header[34+14+1];
		tracksize=header[34+14+1+1]+header[34+14+1+1+1]*256;
		rasm_printf(ae,"tracks: %d  sides:%d   track size:%d",tracknumber,sidenumber,tracksize);
		if (tracknumber>40 || sidenumber>2) {
			rasm_printf(ae,KERROR"[%s] DSK format is not supported in update mode (ntrack=%d nside=%d)\n",edskfilename,tracknumber,sidenumber);
			FreeAssenv(ae);exit(ABORT_ERROR);
		}
		if (face>=sidenumber) {
			rasm_printf(ae,KWARNING"[%s] Warning - DSK has no face %d - DSK updated\n",edskfilename,face);
			if (ae->erronwarn) MaxError(ae);
			return;
		}

		data=MemMalloc(tracksize*tracknumber*sidenumber);
		memset(data,0,tracksize*tracknumber*sidenumber);
		if (FileReadBinary(edskfilename,(char *)data,tracksize*tracknumber*sidenumber)!=tracksize*tracknumber*sidenumber) {
			rasm_printf(ae,"Cannot read DSK tracks!");
			FreeAssenv(ae);exit(ABORT_ERROR);
		}
		//loginfo("track data read (%dkb)",tracksize*tracknumber*sidenumber/1024);
		f=face;
		for (t=0;t<tracknumber;t++) {
			curtrack=t*sidenumber+f;

			i=(t*sidenumber+f)*tracksize;
			if (strncmp((char *)data+i,"Track-Info\r\n",12)) {
				rasm_printf(ae,"Invalid track information block side %d track %d",f,t);
				FreeAssenv(ae);exit(ABORT_ERROR);
			}
			sectornumber=data[i+21];
			sectorsize=data[i+20];
			if (sectornumber!=9 || sectorsize!=2) {
				rasm_printf(ae,"Cannot read [%s] Invalid DATA format",edskfilename);
				FreeAssenv(ae);exit(ABORT_ERROR);
			}
			memset(checksectorid,0,sizeof(checksectorid));			
			/* we want DATA format */
			for (s=0;s<sectornumber;s++) {
				if (t!=data[i+24+8*s]) {
					rasm_printf(ae,"Invalid track number in sector %02X track %d",data[i+24+8*s+2],t);
					FreeAssenv(ae);exit(ABORT_ERROR);
				}
				if (f!=data[i+24+8*s+1]) {
					rasm_printf(ae,"Invalid side number in sector %02X track %d",data[i+24+8*s+2],t);
					FreeAssenv(ae);exit(ABORT_ERROR);
				}
				if (data[i+24+8*s+2]<0xC1 || data[i+24+8*s+2]>0xC9) {
					rasm_printf(ae,"Invalid sector ID in sector %02X track %d",data[i+24+8*s+2],t);
					FreeAssenv(ae);exit(ABORT_ERROR);
				} else {
					checksectorid[data[i+24+8*s+2]-0xC1]=1;
				}				
				if (data[i+24+8*s+3]!=2) {
					rasm_printf(ae,"Invalid sector size in sector %02X track %d",data[i+24+8*s+2],t);
					FreeAssenv(ae);exit(ABORT_ERROR);
				}
			}
			for (s=0;s<sectornumber;s++) {
				if (!checksectorid[s]) {
					rasm_printf(ae,"Missing sector %02X track %d",s+0xC1,t);
					FreeAssenv(ae);exit(ABORT_ERROR);
				}
			}
			/* piste à piste on lit les blocs DANS L'ORDRE LOGIQUE!!! */
			for (b=0xC1;b<=0xC9;b++)
			for (s=0;s<sectornumber;s++) {
				if (data[i+24+8*s+2]==b) {
					memcpy(&curwrap->blocks[curblock][curoffset],&data[i+0x100+s*512],512);
					curoffset+=512;
					if (curoffset>=1024) {
						curoffset=0;
						curblock++;
					}
				}
			}
		}
	} else if (strncmp((char *)header,"EXTENDED",8)==0) {
		rasm_printf(ae,KAYGREEN"updating EDSK [%s] / creator: %-14.14s\n",edskfilename,header+34);
		tracknumber=header[34+14];
		sidenumber=header[34+14+1];
		// not in EDSK tracksize=header[34+14+1+1]+header[34+14+1+1+1]*256;
#if TRACE_EDSK
		loginfo("tracks: %d  sides:%d",tracknumber,sidenumber);
#endif

		if (sidenumber>2) {
			rasm_printf(ae,KERROR"[%s] EDSK format is not supported in update mode (ntrack=%d nside=%d)\n",edskfilename,tracknumber,sidenumber);
			FreeAssenv(ae);exit(ABORT_ERROR);
		}
		if (face>=sidenumber) {
			rasm_printf(ae,KWARNING"[%s] EDSK has no face %d - DSK updated\n",edskfilename,face);
			if (ae->erronwarn) MaxError(ae);
			return;
		}

		for (i=disksize=0;i<tracknumber*sidenumber;i++) disksize+=header[0x34+i]*256;
#if TRACE_EDSK
	loginfo("total track size: %dkb",disksize/1024);
#endif

		data=MemMalloc(disksize);
		memset(data,0,disksize);
		if (FileReadBinary(edskfilename,(char *)data,disksize)!=disksize) {
			rasm_printf(ae,KERROR"Cannot read DSK tracks!\n");
			FreeAssenv(ae);exit(ABORT_ERROR);
		}

		f=face;
		for (t=0;t<tracknumber && t<40;t++) {
			int track_sectorsize;

			curtrack=t*sidenumber+f;
			i=currenttrackposition;
			currentsectorposition=i+0x100;

			if (!header[0x34+curtrack] && t<40) {
				rasm_printf(ae,KERROR"Unexpected unformated track Side %d Track %02d\n",f,t);
			} else {
				currenttrackposition+=header[0x34+curtrack]*256;

				if (strncmp((char *)data+i,"Track-Info\r\n",12)) {
					rasm_printf(ae,KERROR"Invalid track information block side %d track %d\n",f,t);
					FreeAssenv(ae);exit(ABORT_ERROR);
				}
				sectornumber=data[i+21];
				track_sectorsize=data[i+20];
				if (sectornumber!=9) {
					rasm_printf(ae,KERROR"Unsupported track %d (sectornumber=%d sectorsize=%d)\n",t,sectornumber,sectorsize);
					FreeAssenv(ae);exit(ABORT_ERROR);
				}
				memset(checksectorid,0,sizeof(checksectorid));			
				/* we want DATA format */
				for (s=0;s<sectornumber;s++) {
					sectorid=data[i+24+8*s+2];
					if (sectorid>=0xC1 && sectorid<=0xC9) checksectorid[sectorid-0xC1]=1; else {
						rasm_printf(ae,KERROR"invalid sector id %02X for DATA track %d\n",sectorid,t);
						return;
					}
					sectorsize=data[i+24+8*s+3];
					if (sectorsize!=2) {
						rasm_printf(ae,KERROR"invalid sector size track %d\n",t);
						return;
					}
					reallength=data[i+24+8*s+6]+data[i+24+8*s+7]*256; /* real length stored */
					if (reallength!=512) {
						rasm_printf(ae,KERROR"invalid sector length %d for track %d\n",reallength,t);
						return;
					}
#if TRACE_EDSK
	printf("%02X ",sectorid);
#endif
				}
				if (track_sectorsize!=2) {
					rasm_printf(ae,KWARNING"track %02d has invalid sector size but sectors are OK\n",t);
			if (ae->erronwarn) MaxError(ae);
				}
#if TRACE_EDSK
	printf("\n");
#endif

				/* piste à piste on lit les blocs DANS L'ORDRE LOGIQUE!!! */
				for (b=0xC1;b<=0xC9;b++) {
					tmpcurrentsectorposition=currentsectorposition;
					for (s=0;s<sectornumber;s++) {
						if (b==data[i+24+8*s+2]) {
							memcpy(&curwrap->blocks[curblock][curoffset],&data[tmpcurrentsectorposition],512);
							curoffset+=512;
							if (curoffset>=1024) {
								curoffset=0;
								curblock++;
							}
						}
						reallength=data[i+24+8*s+6]+data[i+24+8*s+7]*256;
						tmpcurrentsectorposition+=reallength;
					}
				}
			}
		}
		
		
	} else {
		rasm_printf(ae,KERROR"file [%s] is not a valid (E)DSK floppy image\n",edskfilename);
		FreeAssenv(ae);exit(-923);
	}
	FileReadBinaryClose(edskfilename);
	
	/* Rasm management of (e)DSK files is AMSDOS compatible, just need to copy CATalog blocks but sort them... */
	memcpy(&curwrap->entry[0],curwrap->blocks[0],1024);
	memcpy(&curwrap->entry[32],curwrap->blocks[1],1024);
	/* tri des entrées selon le user */
	qsort(curwrap->entry,64,sizeof(struct s_edsk_wrapper_entry),cmpAmsdosentry);
	curwrap->nbentry=64;
	for (i=0;i<64;i++) {
		if (curwrap->entry[i].user==0xE5) {
			curwrap->nbentry=i;
			break;
		}
	}
#if TRACE_EDSK
	printf("%d entr%s found\n",curwrap->nbentry,curwrap->nbentry>1?"ies":"y");
	for (i=0;i<curwrap->nbentry;i++) {
		printf("[%02d] - ",i);
		if (curwrap->entry[i].user<16) {
			printf("U%02d [%-8.8s.%c%c%c] %c%c subcpt=#%02X rc=#%02X blocks=",curwrap->entry[i].user,curwrap->entry[i].filename,
			curwrap->entry[i].filename[8]&0x7F,curwrap->entry[i].filename[9]&0x7F,curwrap->entry[i].filename[10],
			curwrap->entry[i].filename[8]&0x80?'P':'-',curwrap->entry[i].filename[9]&0x80?'H':'-',
			curwrap->entry[i].subcpt,curwrap->entry[i].rc);
			for (b=0;b<16;b++) if (curwrap->entry[i].blocks[b]) printf("%s%02X",b>0?" ":"",curwrap->entry[i].blocks[b]); else printf("%s  ",b>0?" ":"");
			if (i&1) printf("\n"); else printf(" | ");
		} else {
			printf("free entry                  =    rc=    blocks=                                               ");
			if (i&1) printf("\n"); else printf(" | ");
		}
	}
	if (i&1) printf("\n");
#endif
}

struct s_edsk_wrapper *EDSK_select(struct s_assenv *ae,char *edskfilename, int facenumber)
{
	#undef FUNC
	#define FUNC "EDSK_select"
	
	struct s_edsk_wrapper newwrap={0},*curwrap=NULL;
	int i;
#if TRACE_EDSK
	printf("EDSK_select('%s',%d);\n",edskfilename,facenumber);
#endif
	/* check if there is a DSK in memory */
	for (i=0;i<ae->nbedskwrapper;i++) {
		if (!strcmp(ae->edsk_wrapper[i].edsk_filename,edskfilename)) {
#if TRACE_EDSK
	printf("Found! return %d\n",i);
#endif
			return &ae->edsk_wrapper[i];
		}
	}
	/* not in memory, create an empty struct */
	newwrap.edsk_filename=TxtStrDup(edskfilename);
	memset(newwrap.entry,0xE5,sizeof(struct s_edsk_wrapper_entry)*64);
	memset(newwrap.blocks[0],0xE5,1024);
	memset(newwrap.blocks[1],0xE5,1024);
#if TRACE_EDSK
	printf("Not found! create empty struct\n");
#endif
	newwrap.face=facenumber;
	ObjectArrayAddDynamicValueConcat((void**)&ae->edsk_wrapper,&ae->nbedskwrapper,&ae->maxedskwrapper,&newwrap,sizeof(struct s_edsk_wrapper));
	/* and load files if the DSK exists on disk */
	curwrap=&ae->edsk_wrapper[ae->nbedskwrapper-1];
	if (FileExists(edskfilename)) {
		EDSK_load(ae,curwrap,edskfilename,facenumber);
	}
	return curwrap;
}

int EDSK_addfile(struct s_assenv *ae,char *edskfilename,int facenumber, char *filename,unsigned char *indata,int insize, int offset, int run)
{
	#undef FUNC
	#define FUNC "EDSK_addfile"

	struct s_edsk_wrapper *curwrap=NULL;
	char amsdos_name[12]={0};
	int j,i,ia,mia,ib,ie,filesize,idxdata;
	int fb[180],rc,idxb;
	unsigned char *data=NULL;
	int size=0;
	int firstblock,amsdos_user;

	curwrap=EDSK_select(ae,edskfilename,facenumber);
	/* update struct */
	size=insize+128;
	data=MemMalloc(size);
	strcpy(amsdos_name,MakeAMSDOS_name(ae,filename,&amsdos_user));
	memcpy(data,MakeAMSDOSHeader(run,offset,offset+insize,amsdos_name,amsdos_user),128);
	memcpy(data+128,indata,insize);
	/* overwrite check */
#if TRACE_EDSK
	printf("EDSK_addfile will checks %d entr%s for [%s]\n",curwrap->nbentry,curwrap->nbentry>1?"ies":"y",amsdos_name);
#endif
	for (i=0;i<curwrap->nbentry;i++) {
		if (!strncmp((char *)curwrap->entry[i].filename,amsdos_name,11)) {
			if (!ae->edskoverwrite) {
				MakeError(ae,0,NULL,0,"Error - Cannot save [%s] in edsk [%s] with overwrite disabled as the file already exists (use -eo command line option)\n",amsdos_name,edskfilename);
				MemFree(data);
				return 0;
			} else {
				/* overwriting previous file */
#if TRACE_EDSK
	printf(" -> reset previous entry %d with 0xE5\n",i);
#endif
				memset(&curwrap->entry[i],0xE5,sizeof(struct s_edsk_wrapper_entry));
			}
		}
	}
	/* find free blocks */
#if TRACE_EDSK
	printf("EDSK_addfile find free blocks\n");
#endif
	fb[0]=fb[1]=0;
	for (i=2;i<180;i++) fb[i]=1;
	for (i=0;i<curwrap->nbentry;i++) {
		if (curwrap->entry[i].rc!=0xE5 && curwrap->entry[i].rc!=0) {
			/* entry found, compute number of blocks to read */
			rc=curwrap->entry[i].rc>>3; // no rounding!
			if (curwrap->entry[i].rc%8) rc++; /* adjust value */
			/* mark as used */
			for (j=0;j<rc;j++) {
				fb[curwrap->entry[i].blocks[j]]=0;
			}
		}
	}
	/* set directory, blocks and data in blocks */
	firstblock=-1;
	filesize=size;
	idxdata=0;
	ia=mia=0;

#if TRACE_EDSK
	printf("Writing [%s] size=%d\n",amsdos_name,size);
#endif

	while (filesize>0) {
		if (filesize>16384) {
			/* extended entry */
#if TRACE_EDSK
	printf("extended entry for file (filesize=%d)\nblocklist: ",filesize);
#endif
			if ((ie=EDSK_getdirid(curwrap))==-1)  {
				MakeError(ae,0,NULL,0,"Error - edsk [%s] DIRECTORY FULL\n",edskfilename);
				MemFree(data);
				return 0;
			}
			if (curwrap->nbentry<=ie) curwrap->nbentry=ie+1;
			idxb=0;
			for (i=0;i<16;i++) {
				if ((ib=EDSK_getblockid(fb))==-1) {
					MakeError(ae,0,NULL,0,"Error - edsk [%s] DISK FULL\n",edskfilename);
					MemFree(data);
					return 0;
				} else {
					if (firstblock==-1) firstblock=ib;

#if TRACE_EDSK
	printf("%02X ",ib);
#endif
					memcpy(curwrap->blocks[ib],data+idxdata,1024);
					idxdata+=1024;
					filesize-=1024;
					fb[ib]=0;
					curwrap->entry[ie].blocks[idxb++]=ib;
				}
			}
#if TRACE_EDSK
	printf("\n");
#endif
			memcpy(curwrap->entry[ie].filename,amsdos_name,11);
			curwrap->entry[ie].subcpt=ia;
			curwrap->entry[ie].extendcounter=mia;
			curwrap->entry[ie].rc=0x80;
			curwrap->entry[ie].user=amsdos_user;
			ia++;if (ia>31) {ia=0;mia++;}
			idxb=0;
		} else {
			/* last entry */
#if TRACE_EDSK
	printf("last entry for file (filesize=%d)\nblocklist: ",filesize);
#endif
			if ((ie=EDSK_getdirid(curwrap))==-1)  {
				MakeError(ae,0,NULL,0,"Error - edsk [%s] DIRECTORY FULL\n",edskfilename);
				MemFree(data);
				return 0;
			}
			if (curwrap->nbentry<=ie) curwrap->nbentry=ie+1;
			/* calcul du nombre de sous blocs de 128 octets */
			curwrap->entry[ie].rc=filesize/128;
			if (filesize%128) {
				curwrap->entry[ie].rc+=1;
			}
			idxb=0;
			for (i=0;i<16 && filesize>0;i++) {
				if ((ib=EDSK_getblockid(fb))==-1) {
					MakeError(ae,0,NULL,0,"Error - edsk [%s] DISK FULL\n",edskfilename);
					MemFree(data);
					return 0;
				} else {
					if (firstblock==-1) firstblock=ib;
#if TRACE_EDSK
	printf("%02X ",ib);
#endif

					memcpy(curwrap->blocks[ib],&data[idxdata],filesize>1024?1024:filesize);
					idxdata+=1024;
					filesize-=1024;
					fb[ib]=0;
					curwrap->entry[ie].blocks[idxb++]=ib;
				}
			}
#if TRACE_EDSK
	printf("\n");
#endif
			filesize=0;
			memcpy(curwrap->entry[ie].filename,amsdos_name,11);
			curwrap->entry[ie].subcpt=ia;
			curwrap->entry[ie].extendcounter=mia;
			curwrap->entry[ie].user=amsdos_user;
		}
	}

	MemFree(data);
	return 1;
}

// http://manpages.ubuntu.com/manpages/jammy/en/man5/cpm.5.html  => need to check for FULL support?
void EDSK_build_amsdos_directory(struct s_edsk_wrapper *face)
{
	#undef FUNC
	#define FUNC "EDSK_build_amsdos_directory"
	
	unsigned char amsdosdir[2048]={0};
	int i,idx=0,b;

	if (!face) return;
	
#if TRACE_EDSK	
printf("build amsdos dir with %d entries\n",face->nbentry);	
#endif
	for (i=0;i<face->nbentry;i++) {
		if (face->entry[i].rc && face->entry[i].rc!=0xE5) {
			amsdosdir[idx]=face->entry[i].user;
			memcpy(amsdosdir+idx+1,face->entry[i].filename,11);
			amsdosdir[idx+12]=face->entry[i].subcpt;
			amsdosdir[idx+13]=0;
			amsdosdir[idx+14]=0;
			amsdosdir[idx+15]=face->entry[i].rc;
#if TRACE_EDSK	
printf("%-11.11s [%02X.%02X] blocks:",amsdosdir+idx+1,amsdosdir[idx+12],amsdosdir[idx+15]);
#endif
			for (b=0;b<16;b++) {
				if (face->entry[i].blocks[b]!=0xE5) {
					amsdosdir[idx+16+b]=face->entry[i].blocks[b];
#if TRACE_EDSK	
					printf("%s%02X",b>0?".":"",amsdosdir[idx+16+b]);
#endif
				} else {
					amsdosdir[idx+16+b]=0;
				}
			}
#if TRACE_EDSK	
printf("\n");
#endif
		}
		idx+=32;
	}
#if TRACE_EDSK	
printf("filling amsdos remaining entries (%d) with #E5\n",64-face->nbentry);
#endif
	memset(amsdosdir+idx,0xE5,32*(64-face->nbentry));

	/* AMSDOS directory copy to blocks! */
	memcpy(face->blocks[0],amsdosdir,1024);
	memcpy(face->blocks[1],amsdosdir+1024,1024);
}
void EDSK_write_file(struct s_assenv *ae,struct s_edsk_wrapper *faceA,struct s_edsk_wrapper *faceB)
{
	#undef FUNC
	#define FUNC "EDSK_write_file"

	struct s_edsk_wrapper emptyface={0};
	unsigned char header[256]={0};
	unsigned char trackblock[256]={0};
	unsigned char headertag[25];
	int idblock,blockoffset;
	int i,t;
	
	if (!faceA && !faceB) return;
	
	/* création des deux blocs du directory par face */
	EDSK_build_amsdos_directory(faceA);
	EDSK_build_amsdos_directory(faceB);
	/* écriture header */
	strcpy((char *)header,"EXTENDED CPC DSK File\r\nDisk-Info\r\n");
	sprintf(headertag,"%-9.9s",RASM_SNAP_VERSION);
	strcpy((char *)header+0x22,headertag);
	header[0x30]=40;
	if (!faceA) {
		faceA=&emptyface;
		faceA->edsk_filename=TxtStrDup(faceB->edsk_filename);
	}
#if TRACE_EDSK
	printf("deleting [%s]\n",faceA->edsk_filename);
#endif
	FileRemoveIfExists(faceA->edsk_filename);

	if (faceB!=NULL) header[0x31]=2; else header[0x31]=1;
	for (i=0;i<header[0x30]*header[0x31];i++) header[0x34+i]=19; /* tracksize=(9*512+256)/256 */
#if TRACE_EDSK
	printf("writing EDSK header (256b)\n");
#endif
	FileWriteBinary(faceA->edsk_filename,(char *)header,256);
	
	/* écriture des pistes */
	for (t=0;t<40;t++) {
		strcpy((char *)trackblock,"Track-Info\r\n");
		trackblock[0x10]=t;
		trackblock[0x11]=0;
		trackblock[0x14]=2;
		trackblock[0x15]=9;
		trackblock[0x16]=0x4E;
		trackblock[0x17]=0xE5;
		i=0;
		while (1) {
			trackblock[0x18+i*8+0]=trackblock[0x10];
			trackblock[0x18+i*8+1]=trackblock[0x11];
			trackblock[0x18+i*8+2]=(i>>1)+0xC1;
#if TRACE_EDSK
	if (t<3) printf("%02X ",trackblock[0x18+i*8+2]);
#endif
			trackblock[0x18+i*8+3]=2;
			trackblock[0x18+i*8+4]=0;
			trackblock[0x18+i*8+5]=0;
			trackblock[0x18+i*8+6]=0;
			trackblock[0x18+i*8+7]=2;
			i++;
			if (i==9) break;
			/* interleave */
			trackblock[0x18+i*8+0]=trackblock[0x10];
			trackblock[0x18+i*8+1]=trackblock[0x11];
			trackblock[0x18+i*8+2]=(i>>1)+0xC6; /* start at C6 */
#if TRACE_EDSK
	if (t<3) printf("%02X ",trackblock[0x18+i*8+2]);
#endif
			trackblock[0x18+i*8+3]=2;
			trackblock[0x18+i*8+4]=0;
			trackblock[0x18+i*8+5]=0;
			trackblock[0x18+i*8+6]=0;
			trackblock[0x18+i*8+7]=2;
			i++;
		}
#if TRACE_EDSK
	if (t<3) printf("\n"); else if (t==3) printf("...\n");
#endif
		/* écriture du track info */
		FileWriteBinary(faceA->edsk_filename,(char *)trackblock,256);


		/* il faut convertir les blocs logiques en secteurs physiques ET entrelacés */
		idblock=t*9/2;
		blockoffset=((t*9)%2)*512;

		/* le premier secteur de la piste est à cheval sur le bloc logique une fois sur deux */
		FileWriteBinary(faceA->edsk_filename,(char *)&faceA->blocks[idblock][0]+blockoffset,512); /* C1 */
		if (!blockoffset) {
			FileWriteBinary(faceA->edsk_filename,(char *)&faceA->blocks[idblock+2][0]+512,512); /* C6 */
			FileWriteBinary(faceA->edsk_filename,(char *)&faceA->blocks[idblock+0][0]+512,512); /* C2 */
			FileWriteBinary(faceA->edsk_filename,(char *)&faceA->blocks[idblock+3][0]+0,512);   /* C7 */
			FileWriteBinary(faceA->edsk_filename,(char *)&faceA->blocks[idblock+1][0]+0,512);   /* C3 */
			FileWriteBinary(faceA->edsk_filename,(char *)&faceA->blocks[idblock+3][0]+512,512); /* C8 */
			FileWriteBinary(faceA->edsk_filename,(char *)&faceA->blocks[idblock+1][0]+512,512); /* C4 */
			FileWriteBinary(faceA->edsk_filename,(char *)&faceA->blocks[idblock+4][0]+0,512);   /* C9 */
			FileWriteBinary(faceA->edsk_filename,(char *)&faceA->blocks[idblock+2][0]+0,512);   /* C5 */
		} else {
			FileWriteBinary(faceA->edsk_filename,(char *)&faceA->blocks[idblock+3][0]+0,512);   /* C6 */
			FileWriteBinary(faceA->edsk_filename,(char *)&faceA->blocks[idblock+1][0]+0,512);   /* C2 */
			FileWriteBinary(faceA->edsk_filename,(char *)&faceA->blocks[idblock+3][0]+512,512); /* C7 */
			FileWriteBinary(faceA->edsk_filename,(char *)&faceA->blocks[idblock+1][0]+512,512); /* C3 */
			FileWriteBinary(faceA->edsk_filename,(char *)&faceA->blocks[idblock+4][0]+0,512);   /* C8 */
			FileWriteBinary(faceA->edsk_filename,(char *)&faceA->blocks[idblock+2][0]+0,512);   /* C4 */
			FileWriteBinary(faceA->edsk_filename,(char *)&faceA->blocks[idblock+4][0]+512,512); /* C9 */
			FileWriteBinary(faceA->edsk_filename,(char *)&faceA->blocks[idblock+2][0]+512,512); /* C5 */
		}

		/* @@TODO ça semble un peu foireux comme procédé */	
		if (faceB) {
#if TRACE_EDSK
	printf("writing EDSK face B /!\\  probably NOT WORKING !!!\n");
#endif
			trackblock[0x11]=1;
			for (i=0;i<9;i++) {
				trackblock[0x18+i*8+0]=trackblock[0x10];
				trackblock[0x18+i*8+1]=trackblock[0x11];
			}
			/* écriture du track info */
			FileWriteBinary(faceB->edsk_filename,(char *)trackblock,256);
			/* écriture des secteurs */
			idblock=t*9/2;
			blockoffset=((t*9)%2)*512;
			FileWriteBinary(faceB->edsk_filename,(char *)&faceB->blocks[idblock][0]+blockoffset,512);
			if (!blockoffset) {
				FileWriteBinary(faceB->edsk_filename,(char *)&faceB->blocks[idblock+2][0]+512,512); /* C6 */
				FileWriteBinary(faceB->edsk_filename,(char *)&faceB->blocks[idblock+0][0]+512,512); /* C2 */
				FileWriteBinary(faceB->edsk_filename,(char *)&faceB->blocks[idblock+3][0]+0,512);   /* C7 */
				FileWriteBinary(faceB->edsk_filename,(char *)&faceB->blocks[idblock+1][0]+0,512);   /* C3 */
				FileWriteBinary(faceB->edsk_filename,(char *)&faceB->blocks[idblock+3][0]+512,512); /* C8 */
				FileWriteBinary(faceB->edsk_filename,(char *)&faceB->blocks[idblock+1][0]+512,512); /* C4 */
				FileWriteBinary(faceB->edsk_filename,(char *)&faceB->blocks[idblock+4][0]+0,512);   /* C9 */
				FileWriteBinary(faceB->edsk_filename,(char *)&faceB->blocks[idblock+2][0]+0,512);   /* C5 */
			} else {
				FileWriteBinary(faceB->edsk_filename,(char *)&faceB->blocks[idblock+3][0]+0,512);   /* C6 */
				FileWriteBinary(faceB->edsk_filename,(char *)&faceB->blocks[idblock+1][0]+0,512);   /* C2 */
				FileWriteBinary(faceB->edsk_filename,(char *)&faceB->blocks[idblock+3][0]+512,512); /* C7 */
				FileWriteBinary(faceB->edsk_filename,(char *)&faceB->blocks[idblock+1][0]+512,512); /* C3 */
				FileWriteBinary(faceB->edsk_filename,(char *)&faceB->blocks[idblock+4][0]+0,512);   /* C8 */
				FileWriteBinary(faceB->edsk_filename,(char *)&faceB->blocks[idblock+2][0]+0,512);   /* C4 */
				FileWriteBinary(faceB->edsk_filename,(char *)&faceB->blocks[idblock+4][0]+512,512); /* C9 */
				FileWriteBinary(faceB->edsk_filename,(char *)&faceB->blocks[idblock+2][0]+512,512); /* C5 */
			}
		}
	}
	FileWriteBinaryClose(faceA->edsk_filename);
	rasm_printf(ae,KIO"Write edsk file %s\n",faceA->edsk_filename);
}
void EDSK_write(struct s_assenv *ae)
{
	#undef FUNC
	#define FUNC "EDSK_write"

	struct s_edsk_wrapper *faceA,*faceB;
	int i,j;

	
	/* on passe en revue toutes les structs */
	for (i=0;i<ae->nbedskwrapper;i++) {
		/* already done */
		if (ae->edsk_wrapper[i].face==-1) continue;
		
		switch (ae->edsk_wrapper[i].face) {
			default:
			case 0:faceA=&ae->edsk_wrapper[i];faceB=NULL;break;
			case 1:faceA=NULL;faceB=&ae->edsk_wrapper[i];break;
		}
		/* doit-on fusionner avec une autre face? */
		for (j=i+1;j<ae->nbedskwrapper;j++) {
			if (!strcmp(ae->edsk_wrapper[i].edsk_filename,ae->edsk_wrapper[j].edsk_filename)) {
				/* found another face for the floppy */
				switch (ae->edsk_wrapper[j].face) {
					default:
					case 0:faceA=&ae->edsk_wrapper[j];break;
					case 1:faceB=&ae->edsk_wrapper[j];break;
				}
			}
		}
		EDSK_write_file(ae,faceA,faceB);
	}
}

/* CDT output code / courtesy of CNG */
void update11(unsigned char *head,int n,int is1st,int islast,int l, int fileload)
{
        head[0x10]=n;
        head[0x11]=islast?-1:0;
        head[0x13]=l;
        head[0x14]=l>>8;
        head[0x15]=fileload;
        head[0x16]=fileload>>8;
        head[0x17]=is1st?-1:0;
}
#define fputcc(x,y) { fputc((x),y); fputc((x)>>8,y); }
#define fputccc(x,y) { fputc((x),y); fputc((x)>>8,y); fputc((x)>>16,y); }
void record11(char *filename,unsigned char *t,int first,int l,int p, int flag_bb, int flag_b)
{
	FILE *fo;
	#ifdef OS_WIN
	fo=FileOpen(filename,"w");
	#else
	fo=FileOpen(filename,"a+");
	#endif

	/* almost legacy */
        fputc(0x11,fo);
        fputcc(flag_bb,fo);
        fputcc(flag_b,fo);
        fputcc(flag_b,fo);
        fputcc(flag_b,fo);
        fputcc(flag_bb,fo);
        //fputcc(flag_o,fo);
        fputcc(4096,fo); // 4K block
        fputc(8,fo);
        fputcc(p,fo);
        p=1+(((l+255)/256)*258)+4; //flag_z;
        fputccc(p,fo);
        fputc(first,fo);
        p=0;
        while (l>0)
        {
		int crc16=0xFFFF;
                fwrite(t+p,1,256,fo);
                first=256;
		while (first--) {
			// early CRC-16-CCITT as used by Amstrad
                        int xor8=(t[p++]<<8)+1;
                        while (xor8&0xFF)
                        {
                                if ((xor8^crc16)&0x8000)
                                        crc16=((crc16^0x0810)<<1)+1;
                                else
                                        crc16<<=1;
                                xor8<<=1;
                        }
                }
                crc16=~crc16;
                fputc(crc16>>8,fo); // HI FIRST,
                fputc(crc16,fo); // AND LO NEXT!
                l-=256;
        }
        l=4; //flag_z;
        while (l--)
                fputc(255,fo);
}

void __output_CDT(struct s_assenv *ae, char *tapefilename,char *filename,char *mydata,int size, int offset, int run)
{
	unsigned char *AmsdosHeader;
	unsigned char head[256];
	char TZX_header[14];
	int wrksize,fileload,nbblock=0,dummy_user=0;
	unsigned char body[65536+128];
	int flag_h=2560, flag_p=10240, flag_bb, flag_b=1000,i,j,k;

	FileRemoveIfExists(tapefilename); // pas de append pour le moment

	memcpy(TZX_header,"ZXTape!\032\001\000\040\000\012",13);
	FileWriteBinary(tapefilename,(char *)TZX_header,13);

	AmsdosHeader=MakeAMSDOSHeader(run,offset,offset+size,MakeAMSDOS_name(ae,filename,&dummy_user),dummy_user);
	memcpy(body,AmsdosHeader,128);
	wrksize=size;

	memset(head,0,16);
	strcpy(head,MakeAMSDOS_name(ae,filename,&dummy_user));
	head[0x12]=body[0x12];
	head[0x18]=body[0x40];
	head[0x19]=body[0x41];
	head[0x1A]=body[0x1A];
	head[0x1B]=body[0x1B];
	fileload=body[0x15]+body[0x16]*256;
	flag_b=(3500000/3+flag_b/2)/flag_b;
	flag_bb=flag_b*2;
	memcpy(body,mydata,size);

	if (wrksize>0x800) {
		update11(head,j=1,1,0,0x800,fileload); // FIRST BLOCK
		record11(tapefilename,head,44,28,16,flag_bb,flag_b);
		record11(tapefilename,body,22,0x800,flag_h,flag_bb,flag_b);
		k=wrksize-0x800;
		i=0x800;
		nbblock=1;
		while (k>0x800) {
			fileload+=0x800;
			update11(head,++j,0,0,0x800,fileload); // MID BLOCK
			record11(tapefilename,head,44,28,16,flag_bb,flag_b);
			record11(tapefilename,body+i,22,0x800,flag_h,flag_bb,flag_b);
			k-=0x800;
			i+=0x800;
			nbblock++;
		}
		nbblock++;
		fileload+=0x800;
		update11(head,++j,0,1,k,fileload); // LAST BLOCK
		record11(tapefilename,head,44,28,16,flag_bb,flag_b);
		record11(tapefilename,body+i,22,k,flag_p,flag_bb,flag_b);
	} else {
		update11(head,1,1,1,wrksize,fileload); // SINGLE BLOCK
		record11(tapefilename,head,44,28,16,flag_bb,flag_b);
		record11(tapefilename,body,22,wrksize,flag_p,flag_bb,flag_b);
		nbblock=1;
	}
	FileWriteBinaryClose(tapefilename);
	rasm_printf(ae,KIO"Write tape file %s (%d block%s) run=#%04X\n",tapefilename,nbblock,nbblock>1?"s":"",run);
}



void PopAllSave(struct s_assenv *ae)
{
	#undef FUNC
	#define FUNC "PopAllSave"
	
	unsigned char *AmsdosHeader;
	char *dskfilename;
	char *filename;
	int offset,size,run;
	int i,is,erreur=0,touched,dummy_user;
	
	for (is=0;is<ae->nbsave;is++) {
		/* avoid quotes */
		if (!ae->save[is].iw) filename=ae->save[is].filename; else {
			filename=ae->wl[ae->save[is].iw].w;
			filename[strlen(filename)-1]=0;
			filename=TxtStrDup(filename+1);
			/* crappy POST translate tags! => deprecated!
			filename=TranslateTag(ae,filename,&touched,1,E_TAGOPTION_REMOVESPACE); */
		}

#if TRACE_EDSK
	printf("woff=[%s](%d) wsize=[%s](%d)\n",ae->wl[ae->save[is].ioffset].w,ae->save[is].ioffset,ae->wl[ae->save[is].isize].w,ae->save[is].isize);
#endif

		ae->idx=ae->save[is].ioffset; /* exp hack */
		//ExpressionFastTranslate(ae,&ae->wl[ae->idx].w,0);
		offset=RoundComputeExpression(ae,ae->wl[ae->idx].w,0,0,0);

		ae->idx=ae->save[is].isize; /* exp hack */
		//ExpressionFastTranslate(ae,&ae->wl[ae->idx].w,0);
		size=RoundComputeExpression(ae,ae->wl[ae->idx].w,0,0,0);

		ae->idx=ae->save[is].irun; /* exp hack */
		if (ae->idx) {
			//ExpressionFastTranslate(ae,&ae->wl[ae->idx].w,0);
			run=RoundComputeExpression(ae,ae->wl[ae->idx].w,0,0,0);
		} else {
			run=offset;
		}

		if (size<1 || size>65536) {
			MakeError(ae,0,NULL,0,"cannot save [%s] as the size is invalid!\n",filename);
			MemFree(filename);
			continue;
		}
		if (offset<0 || offset>65535) {
			MakeError(ae,0,NULL,0,"cannot save [%s] as the offset is invalid!\n",filename);
			MemFree(filename);
			continue;
		}
		if (offset+size>65536) {
			MakeError(ae,0,NULL,0,"cannot save [%s] as the offset+size will be out of bounds!\n",filename);
			MemFree(filename);
			continue;
		}
		/* DSK management */
		if (ae->save[is].dsk) {
			if (ae->save[is].iwdskname!=-1) {
				/* obligé de dupliquer à cause du reuse */
				dskfilename=TxtStrDup(ae->wl[ae->save[is].iwdskname].w);
				dskfilename[strlen(dskfilename)-1]=0;
				if (!EDSK_addfile(ae,dskfilename+1,ae->save[is].face,filename,ae->mem[ae->save[is].ibank]+offset,size,offset,run)) {
					erreur++;
					//break;
				}
				MemFree(dskfilename);
			}
		} else if (ae->save[is].tape) {
			char *tapefilename;

			if (ae->save[is].iwdskname>0) {
				tapefilename=ae->wl[ae->save[is].iwdskname].w;
				tapefilename[strlen(tapefilename)-1]=0;
				tapefilename=TxtStrDup(tapefilename+1);
			} else {
				tapefilename=TxtStrDup("rasmoutput.cdt");
			}

			__output_CDT(ae,tapefilename,filename,(char*)ae->mem[ae->save[is].ibank]+offset,size,offset,run);
		} else {
			/* output file on filesystem */
			rasm_printf(ae,KIO"Write binary file %s (%d byte%s)\n",filename,size,size>1?"s":"");
			FileRemoveIfExists(filename);
			if (ae->save[is].amsdos) {
				AmsdosHeader=MakeAMSDOSHeader(run,offset,offset+size,MakeAMSDOS_name(ae,filename,&dummy_user),dummy_user);
				FileWriteBinary(filename,(char *)AmsdosHeader,128);
			} else if (ae->save[is].hobeta) {
				// HOBETA header is 17 bytes long so i reuse Amsdos buffer and name cleaning
				AmsdosHeader=MakeHobetaHeader(offset,offset+size,MakeAMSDOS_name(ae,filename,&dummy_user));
				FileWriteBinary(filename,(char *)AmsdosHeader,17);
			}		
			FileWriteBinary(filename,(char*)ae->mem[ae->save[is].ibank]+offset,size);
			FileWriteBinaryClose(filename);
		}
		MemFree(filename);
	}
	if (!erreur) EDSK_write(ae);
	
	for (i=0;i<ae->nbedskwrapper;i++) {
		MemFree(ae->edsk_wrapper[i].edsk_filename);
	}
	if (ae->maxedskwrapper) MemFree(ae->edsk_wrapper);
}

void PopAllExpression(struct s_assenv *ae, int crunched_zone)
{
	#undef FUNC
	#define FUNC "PopAllExpression"
	
	static int first=1;
	static int lastlz=0;
	double v;
	long r;
	int i,mapflag=0;
	unsigned char *mem;
	char *expr;
	
	/* pop all expressions BUT thoses who where already computed (in crunched blocks) */

	/* calcul des labels et expressions en zone crunch (et locale?)
	   les labels doivent pointer:
	   - une valeur absolue (numerique ou variable calculee) -> completement transparent
	   - un label dans la meme zone de crunch -> label->lz=1 && verif de la zone crunch
	   - un label hors zone crunch MAIS avant toute zone de crunch de la bank destination (!label->lz)

	   idealement on doit tolerer les adresses situees apres le crunch dans une autre ORG zone!

	   on utilise ae->stage pour créer un état intermédiaire dans le ComputeExpressionCore
	*/
	if (crunched_zone>=0) {
		ae->stage=1;
		/* start at the very beginning of the crunched zone */
		first=ae->lzsection[crunched_zone].iexpr;
	} else {
		/* on rescanne tout pour combler les trous */
		ae->stage=2;
		first=1;
	}
	
	for (i=first;i<ae->ie;i++) {
		/* first compute only crunched expression (0,1,2,3,...) then intermediates and (-1) at the end */
		if (crunched_zone>=0) {
			/* stop right after the current crunched zone */
			if (ae->expression[i].lz!=crunched_zone) {
#if TRACE_LZ
				printf("*break* at %d expression [%s] lz=%d\n",i,ae->expression[i].reference?ae->expression[i].reference:ae->wl[ae->expression[i].iw].w,ae->expression[i].lz);
#endif
				break;
			}
		} else {
			/* eventually we must skip previous computed expression */
			if (ae->expression[i].lz>=0) continue;
		}

		mem=ae->mem[ae->expression[i].ibank];
		
		if (ae->expression[i].reference) {
			expr=ae->expression[i].reference;
		} else {
			expr=ae->wl[ae->expression[i].iw].w;
		}

#if TRACE_POPEXPR
	printf("PopAll (%d) expr=[%s] ptr=%X outputadr=%X\n",crunched_zone,expr,ae->expression[i].ptr,ae->expression[i].wptr);
#endif
		if (ae->nexternal) {
			int iex,jex;
			mapflag=0;
			for (iex=0;iex<ae->nexternal;iex++) {
				for (jex=0;jex<ae->external[iex].imapping;jex++) {
					if (ae->expression[i].wptr==ae->external[iex].mapping[jex].ptr) {
#if TRACE_POPEXPR
						printf("MAPPING [%s] adr=%d size=%d\n",ae->external[iex].name,ae->expression[i].wptr,ae->external[iex].mapping[jex].size);
#endif
						mapflag=1;
						break;
					}
				}
			}
		}
		v=ComputeExpressionCore(ae,expr,ae->expression[i].ptr,i);
		r=(long)floor(v+ae->rough);
#if TRACE_POPEXPR
		printf("resultat du compute=>%ld (%lf + rough=%lf)\n",r,v,ae->rough);
#endif

		switch (ae->expression[i].zetype) {
			case E_EXPRESSION_J8:
				r=r-ae->expression[i].ptr-2;
				if (r<-128 || r>127) {
					MakeError(ae,ae->expression[i].iw,GetExpFile(ae,i),ae->wl[ae->expression[i].iw].l,"relative offset %d too far [%s]\n",r,ae->wl[ae->expression[i].iw].w);
				}
				mem[ae->expression[i].wptr]=(unsigned char)r;
				break;
			case E_EXPRESSION_IV81:
				/* for enhanced 16bits instructions */
				r++;
			case E_EXPRESSION_0V8:
			case E_EXPRESSION_IV8:
			case E_EXPRESSION_3V8:
			case E_EXPRESSION_V8:
				if (r>255 || r<-128) {
					if (!ae->nowarning) {
						rasm_printf(ae,KWARNING"[%s:%d] Warning: truncating value #%X to #%X\n",GetExpFile(ae,i),ae->wl[ae->expression[i].iw].l,r,r&0xFF);
						if (ae->erronwarn) MaxError(ae);
					}
				}
				mem[ae->expression[i].wptr]=(unsigned char)r;
				break;
			case E_EXPRESSION_J16:
			case E_EXPRESSION_J16C:
				/* buildobj */
				if (ae->buildobj && !mapflag) {
					struct s_external_mapping mapping;
					//printf("RELOCATION %04X\n",ae->expression[i].wptr);
					mapping.iorgzone=ae->expression[i].ibank; // bank hack
					mapping.ptr=ae->expression[i].wptr;
					mapping.size=2;
					mapping.value=r&0xFFFF;
					ObjectArrayAddDynamicValueConcat((void**)&ae->mapping,&ae->imapping,&ae->mmapping,&mapping,sizeof(mapping));
				}
			case E_EXPRESSION_IV16:
			case E_EXPRESSION_V16:
			case E_EXPRESSION_0V16:
				if (r>65535 || r<-32768) {
					if (!ae->nowarning) {
						rasm_printf(ae,KWARNING"[%s:%d] Warning: truncating value #%X to #%X\n",GetExpFile(ae,i),ae->wl[ae->expression[i].iw].l,r,r&0xFFFF);
						if (ae->erronwarn) MaxError(ae);
					}
				}
				mem[ae->expression[i].wptr]=(unsigned char)r&0xFF;
				mem[ae->expression[i].wptr+1]=(unsigned char)((r&0xFF00)>>8);
				break;
			case E_EXPRESSION_0V32:
				/* meaningless in 32 bits architecture... */
				if (v>4294967295 || v<-2147483648) {
					if (!ae->nowarning) {
						rasm_printf(ae,KWARNING"[%s:%d] Warning: truncating value\n",GetExpFile(ae,i),ae->wl[ae->expression[i].iw].l);
						if (ae->erronwarn) MaxError(ae);
					}
				}
				mem[ae->expression[i].wptr]=(unsigned char)r&0xFF;
				mem[ae->expression[i].wptr+1]=(unsigned char)((r>>8)&0xFF);
				mem[ae->expression[i].wptr+2]=(unsigned char)((r>>16)&0xFF);
				mem[ae->expression[i].wptr+3]=(unsigned char)((r>>24)&0xFF);
				break;
			case E_EXPRESSION_0VR:
				/* convert v double value to Amstrad REAL */
				memcpy(&mem[ae->expression[i].wptr],__internal_MakeAmsdosREAL(ae,v,i),5);
				break;
			case E_EXPRESSION_0VRMike:
				/* convert v double value to Microsoft 40bits REAL */
				memcpy(&mem[ae->expression[i].wptr],__internal_MakeRosoftREAL(ae,v,i),5);
				break;
			case E_EXPRESSION_IM:
				switch (r) {
					case 0x00:mem[ae->expression[i].wptr]=0x46;break;
					case 0x01:mem[ae->expression[i].wptr]=0x56;break;
					case 0x02:mem[ae->expression[i].wptr]=0x5E;break;
					default:
						MakeError(ae,ae->expression[i].iw,GetExpFile(ae,i),ae->wl[ae->expression[i].iw].l,"IM 0,1 or 2 only\n");
						mem[ae->expression[i].wptr]=0;
				}
				break;
			case E_EXPRESSION_RSTC:
				if (r==0x38) {
					mem[ae->expression[i].wptr]=0xFF; // +1 sur le saut relatif
				} else {
					MakeError(ae,ae->expression[i].iw,GetExpFile(ae,i),ae->wl[ae->expression[i].iw].l,"RST condition,#38 only\n");
				}
				break;
			case E_EXPRESSION_RST:
				switch (r) {
					case 0x00:mem[ae->expression[i].wptr]=0xC7;break;
					case 0x08:mem[ae->expression[i].wptr]=0xCF;break;
					case 0x10:mem[ae->expression[i].wptr]=0xD7;break;
					case 0x18:mem[ae->expression[i].wptr]=0xDF;break;
					case 0x20:mem[ae->expression[i].wptr]=0xE7;break;
					case 0x28:mem[ae->expression[i].wptr]=0xEF;break;
					case 0x30:mem[ae->expression[i].wptr]=0xF7;break;
					case 0x38:mem[ae->expression[i].wptr]=0xFF;break;
					default:
						MakeError(ae,ae->expression[i].iw,GetExpFile(ae,i),ae->wl[ae->expression[i].iw].l,"RST #0,#8,#10,#18,#20,#28,#30,#38 only\n");
						mem[ae->expression[i].wptr]=0;
				}
				break;
			case E_EXPRESSION_RUN:
				if (r<0 || r>65535) {
					if (!ae->nowarning) {
						rasm_printf(ae,KWARNING"[%s:%d] Warning: run address truncated from %X to %X\n",GetExpFile(ae,i),ae->wl[ae->expression[i].iw].l,r,r&0xFFFF);
						if (ae->erronwarn) MaxError(ae);
					}
				}
				ae->snapshot.registers.LPC=r&0xFF;
				ae->snapshot.registers.HPC=(r>>8)&0xFF;
				break;			
			case E_EXPRESSION_ZXRUN:
				if (r<0 || r>65535) {
					if (!ae->nowarning) {
						rasm_printf(ae,KWARNING"[%s:%d] Warning: run address truncated from %X to %X\n",GetExpFile(ae,i),ae->wl[ae->expression[i].iw].l,r,r&0xFFFF);
						if (ae->erronwarn) MaxError(ae);
					}
				}
				ae->zxsnapshot.run=r&0xFFFF;
				break;			
			case E_EXPRESSION_ZXSTACK:
				if (r<0 || r>65535) {
					if (!ae->nowarning) {
						rasm_printf(ae,KWARNING"[%s:%d] Warning: stack address truncated from %X to %X\n",GetExpFile(ae,i),ae->wl[ae->expression[i].iw].l,r,r&0xFFFF);
						if (ae->erronwarn) MaxError(ae);
					}
				}
				ae->zxsnapshot.stack=r&0xFFFF;
				break;
			case E_EXPRESSION_BRS:
				if (r>=0 && r<8) {
					mem[ae->expression[i].wptr]+=r*8;
				} else {
					MakeError(ae,ae->expression[i].iw,GetExpFile(ae,i),ae->wl[ae->expression[i].iw].l,"SET,RES,BIT shift value from 0 to 7 only\n");
				}
				break;
			default:
				MakeError(ae,ae->expression[i].iw,GetExpFile(ae,i),ae->wl[ae->expression[i].iw].l,"FATAL - unknown expression type\n");
				FreeAssenv(ae);exit(-8);
		}	
	}
#if TRACE_LZ
	printf("PopAllExpression crunched_zone=%d first=%d end=%d\n",crunched_zone,first,i);
#endif
}
void InsertLabelToTree(struct s_assenv *ae, struct s_label *label)
{
	#undef FUNC
	#define FUNC "InsertLabelToTree"

	struct s_crclabel_tree *curlabeltree;
	int radix,dek=16;

	if ((curlabeltree=ae->labeltree[(label->crc>>16)&0xFFFF])==NULL) { //@@FAST
		curlabeltree=MemMalloc(sizeof(struct s_crclabel_tree));
		memset(curlabeltree,0,sizeof(struct s_crclabel_tree));
		ae->labeltree[(label->crc>>16)&0xFFFF]=curlabeltree;
	}
	while (dek) {
		dek=dek-8;
		radix=(label->crc>>dek)&0xFF;
		if (curlabeltree->radix[radix]) {
			curlabeltree=curlabeltree->radix[radix];
		} else {
			curlabeltree->radix[radix]=MemMalloc(sizeof(struct s_crclabel_tree));
			curlabeltree=curlabeltree->radix[radix];
			memset(curlabeltree,0,sizeof(struct s_crclabel_tree));
		}
	}
	ObjectArrayAddDynamicValueConcat((void**)&curlabeltree->label,&curlabeltree->nlabel,&curlabeltree->mlabel,&label[0],sizeof(struct s_label));
}

/* use by structure mechanism and label import to add fake labels */
void PushLabelLight(struct s_assenv *ae, struct s_label *curlabel) {
	#undef FUNC
	#define FUNC "PushLabelLight"
	
	struct s_label *searched_label;
	
	/* PushLabel light */
	if ((searched_label=SearchLabel(ae,curlabel->name,curlabel->crc))!=NULL) {
		MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"%s caused duplicate label [%s]\n",ae->idx?"Structure insertion":"Label import",curlabel->name);
		MemFree(curlabel->name);
	} else {
		curlabel->backidx=ae->il;
		curlabel->local_export=ae->local_export;
		curlabel->autorise_export=ae->autorise_export&(!ae->getstruct); // do not export label in struct declaration!
		curlabel->make_alias=ae->getstruct;
		ObjectArrayAddDynamicValueConcat((void **)&ae->label,&ae->il,&ae->ml,curlabel,sizeof(struct s_label));
		InsertLabelToTree(ae,curlabel);
	}				
}
void PushLabel(struct s_assenv *ae)
{
	#undef FUNC
	#define FUNC "PushLabel"
	
	struct s_label curlabel={0},*searched_label;
	int i;
	/* label with counters */
	char *varbuffer;
	int tagcount=0;
	int touched;

#if TRACE_LABEL
	printf("check label [%s]\n",ae->wl[ae->idx].w);
#endif

	ae->deadend=0;

	if (ae->AutomateValidLabelFirst[(int)ae->wl[ae->idx].w[0]&0xFF]) {
		for (i=1;ae->wl[ae->idx].w[i];i++) {
			if (ae->wl[ae->idx].w[i]=='{') tagcount++; else if (ae->wl[ae->idx].w[i]=='}') tagcount--;
			if (!tagcount) {
				if (!ae->AutomateValidLabel[(int)ae->wl[ae->idx].w[i]&0xFF]) {
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Invalid char in label declaration (%c)\n",ae->wl[ae->idx].w[i]);
					return;
				}
			}
		}
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Invalid first char in label declaration (%c)\n",ae->wl[ae->idx].w[0]);
		return;
	}
	
	switch (i) {
		case 1:
			switch (ae->wl[ae->idx].w[0]) {
				case 'A':
				case 'B':
				case 'C':
				case 'D':
				case 'E':
				case 'F':
				case 'H':
				case 'L':
				case 'I':
				case 'R':
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Cannot use reserved word [%s] for label\n",ae->wl[ae->idx].w);
					return;
				default:break;
			}
			break;
		case 2:
			if (strcmp(ae->wl[ae->idx].w,"AF")==0 || strcmp(ae->wl[ae->idx].w,"BC")==0 || strcmp(ae->wl[ae->idx].w,"DE")==0 || strcmp(ae->wl[ae->idx].w,"HL")==0 || 
				strcmp(ae->wl[ae->idx].w,"IX")==0 || strcmp(ae->wl[ae->idx].w,"IY")==0 || strcmp(ae->wl[ae->idx].w,"SP")==0 ||
				strcmp(ae->wl[ae->idx].w,"LX")==0 || strcmp(ae->wl[ae->idx].w,"HX")==0 || strcmp(ae->wl[ae->idx].w,"XL")==0 || strcmp(ae->wl[ae->idx].w,"XH")==0 ||
				strcmp(ae->wl[ae->idx].w,"LY")==0 || strcmp(ae->wl[ae->idx].w,"HY")==0 || strcmp(ae->wl[ae->idx].w,"YL")==0 || strcmp(ae->wl[ae->idx].w,"YH")==0) {
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Cannot use reserved word [%s] for label\n",ae->wl[ae->idx].w);
				return;
			}
			break;
		case 3:
			if (strcmp(ae->wl[ae->idx].w,"IXL")==0 || strcmp(ae->wl[ae->idx].w,"IYL")==0 || strcmp(ae->wl[ae->idx].w,"IXH")==0 || strcmp(ae->wl[ae->idx].w,"IYH")==0) {
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Cannot use reserved word [%s] for label\n",ae->wl[ae->idx].w);
				return;
			}			
			break;
		case 4:
			if (strcmp(ae->wl[ae->idx].w,"VOID")==0) {
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Cannot use reserved word [%s] for label\n",ae->wl[ae->idx].w);
				return;
			}
		default:break;
	}

	/*******************************************************
	   v a r i a b l e s     i n    l a b e l    n a m e

	           -- varbuffer is always allocated --
	*******************************************************/
	varbuffer=TranslateTag(ae,TxtStrDup(ae->wl[ae->idx].w),&touched,1,E_TAGOPTION_NONE); // on se moque du touched ici => varbuffer toujours "new"
#if TRACE_LABEL
	printf("label after translation [%s]\n",varbuffer);
#endif
	/**************************************************
	   s t r u c t u r e     d e c l a r a t i o n
	**************************************************/
	if (ae->getstruct) {
		struct s_rasmstructfield rasmstructfield={0};
#if TRACE_LABEL
	printf("label used for structs! [%s]\n",varbuffer);
#endif
		if (varbuffer[0]=='@') {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Please no local label in a struct [%s]\n",ae->wl[ae->idx].w);
			MemFree(varbuffer);
			return;
		}
		/* copy label+offset in the structure */
		rasmstructfield.name=varbuffer;
		rasmstructfield.offset=ae->codeadr;
		ObjectArrayAddDynamicValueConcat((void **)&ae->rasmstruct[ae->irasmstruct-1].rasmstructfield,
				&ae->rasmstruct[ae->irasmstruct-1].irasmstructfield,&ae->rasmstruct[ae->irasmstruct-1].mrasmstructfield,
				&rasmstructfield,sizeof(rasmstructfield));
		/* label is structname+field */
		curlabel.name=MemMalloc(strlen(ae->rasmstruct[ae->irasmstruct-1].name)+strlen(varbuffer)+2);
		sprintf(curlabel.name,"%s.%s",ae->rasmstruct[ae->irasmstruct-1].name,varbuffer);
		curlabel.iw=-1;
		/* legacy */
		curlabel.crc=GetCRC(curlabel.name);
		curlabel.ptr=ae->codeadr;
		curlabel.make_alias=1;
#if TRACE_STRUCT
	printf("pushLabel (struct) [%X] [%s]   irstructfield=%d / cur idata=%d\n",curlabel.ptr,curlabel.name,ae->rasmstruct[ae->irasmstruct-1].irasmstructfield,ae->rasmstruct[ae->irasmstruct-1].rasmstructfield[ae->rasmstruct[ae->irasmstruct-1].irasmstructfield-1].idata);
#endif
	} else {
		/**************************************************
		   l a b e l s
		**************************************************/
		/* labels locaux */
		if (varbuffer[0]=='@' && (ae->ir || ae->iw || ae->imacro)) {
#if TRACE_LABEL
	printf("PUSH LOCAL\n");
#endif
			curlabel.iw=-1;
			curlabel.local=1;
			curlabel.localsize=strlen(varbuffer);
			curlabel.name=MakeLocalLabel(ae,varbuffer,NULL);  MemFree(varbuffer);
			curlabel.crc=GetCRC(curlabel.name);

			/* local labels ALSO set new reference */
			if (ae->lastglobalalloc) {
//printf("push LOCAL is freeing lastgloballabel\n");
				MemFree(ae->lastgloballabel);
			}
			ae->lastgloballabel=TxtStrDup(curlabel.name);
			ae->lastgloballabellen=strlen(ae->lastgloballabel);
			ae->lastglobalalloc=1;
//printf("push LOCAL as reference [%d] for proximity label -> [%s]\n",im, ae->lastgloballabel);

		} else {
#if TRACE_LABEL
	printf("PUSH GLOBAL or PROXIMITY\n");
#endif
			switch (varbuffer[0]) {
				case '.':
					if (ae->dams) {
						/* old Dams style declaration (remove the dot) */
						i=0;
						do {
							varbuffer[i]=varbuffer[i+1];
							i++;
						} while (varbuffer[i]!=0);

						curlabel.iw=-1;
						curlabel.name=varbuffer;
						curlabel.crc=GetCRC(curlabel.name);
					} else {
						/* proximity labels */
						if (ae->lastgloballabel) {
							curlabel.name=MemMalloc(strlen(varbuffer)+1+ae->lastgloballabellen);
							sprintf(curlabel.name,"%s%s",ae->lastgloballabel,varbuffer);
							MemFree(varbuffer);
							curlabel.iw=-1;
							curlabel.crc=GetCRC(curlabel.name);
#if TRACE_LABEL
printf("PUSH PROXIMITY label that may be exported [%s]->[%s]\n",ae->wl[ae->idx].w,curlabel.name);
#endif
						} else {
#if TRACE_LABEL
printf("PUSH Orphan PROXIMITY label that cannot be exported [%s]->[%s]\n",ae->wl[ae->idx].w,curlabel.name);
#endif

							curlabel.iw=-1;
							curlabel.name=varbuffer;
							curlabel.crc=GetCRC(varbuffer);
						}
					}
					break;
				default:
#if TRACE_LABEL
	printf("PUSH => GLOBAL [%s]\n",varbuffer);
#endif
					curlabel.iw=-1;
					curlabel.name=varbuffer; 
					curlabel.crc=GetCRC(varbuffer);

					/* global labels set new reference */
					if (ae->lastglobalalloc) MemFree(ae->lastgloballabel);
					ae->lastgloballabel=TxtStrDup(curlabel.name);
					ae->lastgloballabellen=strlen(curlabel.name);
					ae->lastglobalalloc=1;
					break;
			}


			/* this stage varbuffer maybe already freed or used */
			if (curlabel.name[0]!='@' && ae->module && ae->modulen) {
				char *newlabelname;

				newlabelname=MemMalloc(strlen(curlabel.name)+ae->modulen+2);
				strcpy(newlabelname,ae->module);
				strcat(newlabelname,ae->module_separator);
				strcat(newlabelname,curlabel.name);
				MemFree(curlabel.name);
				curlabel.name=newlabelname;
				curlabel.crc=GetCRC(curlabel.name);
				//curlabel.iw=-1; => deja mis depuis longtemps
			}
#if TRACE_LABEL
	if (curlabel.name[0]!='@') printf("PUSH => ADD MODULE [%s] => [%s]\n",ae->module?ae->module:"(null)",curlabel.name);
	else printf("PUSH => NO MODULE for local label\n");
#endif

			/* contrôle dico uniquement avec des labels non locaux */
			if (SearchDico(ae,curlabel.name,curlabel.crc)) {
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"cannot create label [%s] as there is already a variable with the same name\n",curlabel.name);
				return;
			}
			if(SearchAlias(ae,curlabel.crc,curlabel.name)!=-1) {
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"cannot create label [%s] as there is already an alias with the same name\n",curlabel.name);
				return;
			}
		}
		curlabel.ptr=ae->codeadr;
		curlabel.ibank=ae->activebank;
		curlabel.iorgzone=ae->io-1;
		curlabel.lz=ae->lz;
	}

	if ((searched_label=SearchLabel(ae,curlabel.name,curlabel.crc))!=NULL) {
		MakeError(ae,ae->idx,GetCurrentFile(ae),GetExpLine(ae,0),"Duplicate label [%s] - previously defined in [%s:%d]\n",curlabel.name,ae->filename[searched_label->fileidx],searched_label->fileline);
		MemFree(curlabel.name);
	} else {
//printf("PushLabel(%s) name=%s crc=%X lz=%d\n",curlabel.name,curlabel.name?curlabel.name:"null",curlabel.crc,curlabel.lz);
		curlabel.fileidx=ae->wl[ae->idx].ifile;
		curlabel.fileline=ae->wl[ae->idx].l;
		curlabel.local_export=ae->local_export;
		curlabel.autorise_export=ae->autorise_export&(!ae->getstruct);
		curlabel.backidx=ae->il;
		ObjectArrayAddDynamicValueConcat((void **)&ae->label,&ae->il,&ae->ml,&curlabel,sizeof(curlabel));
		InsertLabelToTree(ae,&curlabel);
	}

}


unsigned char *EncodeSnapshotRLE(unsigned char *memin, int *lenout, int sizetoencode) {
	#undef FUNC
	#define FUNC "EncodeSnapshotRLE"
	
	int i,cpt,idx=0;
	unsigned char *memout;
	
	memout=MemMalloc(sizetoencode*2);
	
	for (i=0;i<sizetoencode;) {

		for (cpt=1;cpt<255 && i+cpt<sizetoencode;cpt++) if (memin[i]!=memin[i+cpt]) break;

		if (cpt>=3 || memin[i]==0xE5) {
			memout[idx++]=0xE5;
			memout[idx++]=cpt;
			memout[idx++]=memin[i];
			i+=cpt;
		} else {
			memout[idx++]=memin[i++];
		}
	}
	if (lenout) *lenout=idx;
        if (idx<sizetoencode) return memout;
        
        MemFree(memout);
	*lenout=sizetoencode; // means cannot pack
        return NULL;

}



#undef FUNC
#define FUNC "Instruction CORE"
						
#define EnforceNoAddressingMode(zidx) if (StringIsMem(ae->wl[zidx].w)) MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Ambiguous and potentially erroneous mnemonic entry. Expecting immediate value instead of immediate addressing value\n");

void _IN(struct s_assenv *ae) {
	if (!ae->wl[ae->idx].t && !ae->wl[ae->idx+1].t && ae->wl[ae->idx+2].t==1) {
		if (strcmp(ae->wl[ae->idx+2].w,"(C)")==0) {
			switch (GetCRC(ae->wl[ae->idx+1].w)) {
				case CRC_0:
				case CRC_F:___output(ae,0xED);___output(ae,0x70);ae->nop+=4;ae->tick+=12;break;
				case CRC_A:___output(ae,0xED);___output(ae,0x78);ae->nop+=4;ae->tick+=12;break;
				case CRC_B:___output(ae,0xED);___output(ae,0x40);ae->nop+=4;ae->tick+=12;break;
				case CRC_C:___output(ae,0xED);___output(ae,0x48);ae->nop+=4;ae->tick+=12;break;
				case CRC_D:___output(ae,0xED);___output(ae,0x50);ae->nop+=4;ae->tick+=12;break;
				case CRC_E:___output(ae,0xED);___output(ae,0x58);ae->nop+=4;ae->tick+=12;break;
				case CRC_H:___output(ae,0xED);___output(ae,0x60);ae->nop+=4;ae->tick+=12;break;
				case CRC_L:___output(ae,0xED);___output(ae,0x68);ae->nop+=4;ae->tick+=12;break;
				default:
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is IN [0,F,A,B,C,D,E,H,L],(C)\n");
			}
		} else if (strcmp(ae->wl[ae->idx+1].w,"A")==0 && StringIsMem(ae->wl[ae->idx+2].w)) {
			___output(ae,0xDB);
			PushExpression(ae,ae->idx+2,E_EXPRESSION_V8);
			ae->nop+=3;
			ae->tick+=11;
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"IN [0,F,A,B,C,D,E,H,L],(C) or IN A,(n) only\n");
		}
		ae->idx+=2;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"IN [0,F,A,B,C,D,E,H,L],(C) or IN A,(n) only\n");
	}
}

void _OUT(struct s_assenv *ae) {
	if (!ae->wl[ae->idx].t && !ae->wl[ae->idx+1].t && ae->wl[ae->idx+2].t==1) {
		if (strcmp(ae->wl[ae->idx+1].w,"(C)")==0) {
			switch (GetCRC(ae->wl[ae->idx+2].w)) {
				case CRC_0:___output(ae,0xED);___output(ae,0x71);ae->nop+=4;ae->tick+=12;break;
				case CRC_A:___output(ae,0xED);___output(ae,0x79);ae->nop+=4;ae->tick+=12;break;
				case CRC_B:___output(ae,0xED);___output(ae,0x41);ae->nop+=4;ae->tick+=12;break;
				case CRC_C:___output(ae,0xED);___output(ae,0x49);ae->nop+=4;ae->tick+=12;break;
				case CRC_D:___output(ae,0xED);___output(ae,0x51);ae->nop+=4;ae->tick+=12;break;
				case CRC_E:___output(ae,0xED);___output(ae,0x59);ae->nop+=4;ae->tick+=12;break;
				case CRC_H:___output(ae,0xED);___output(ae,0x61);ae->nop+=4;ae->tick+=12;break;
				case CRC_L:___output(ae,0xED);___output(ae,0x69);ae->nop+=4;ae->tick+=12;break;
				default:
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is OUT (C),[0,A,B,C,D,E,H,L]\n");
			}
		} else if (strcmp(ae->wl[ae->idx+2].w,"A")==0 && StringIsMem(ae->wl[ae->idx+1].w)) {
			___output(ae,0xD3);
			PushExpression(ae,ae->idx+1,E_EXPRESSION_V8);
			ae->nop+=3;
			ae->tick+=11;
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"OUT (C),[0,A,B,C,D,E,H,L] or OUT (n),A only\n");
		}
		ae->idx+=2;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"OUT (C),[0,A,B,C,D,E,H,L] or OUT (n),A only\n");
	}
}

void _EX(struct s_assenv *ae) {
	if (!ae->wl[ae->idx].t && !ae->wl[ae->idx+1].t && ae->wl[ae->idx+2].t==1) {
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_HL:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_DE:___output(ae,0xEB);ae->nop+=1;ae->tick+=4;break;
					case CRC_MSP:___output(ae,0xE3);ae->nop+=6;ae->tick+=19;break;
					default:
						MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is EX HL,[(SP),DE]\n");
				}
				break;
			case CRC_AF:
				if (strcmp(ae->wl[ae->idx+2].w,"AF'")==0) {
					___output(ae,0x08);ae->nop+=1;ae->tick+=4;
				} else {
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is EX AF,AF'\n");
				}
				break;
			case CRC_MSP:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_HL:___output(ae,0xE3);ae->nop+=6;ae->tick+=19;break;
					case CRC_IX:___output(ae,0xDD);___output(ae,0xE3);ae->nop+=7;ae->tick+=23;break;
					case CRC_IY:___output(ae,0xFD);___output(ae,0xE3);ae->nop+=7;ae->tick+=23;break;
					default:
						MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is EX (SP),[HL,IX,IY]\n");
				}
				break;
			case CRC_DE:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_HL:___output(ae,0xEB);ae->nop+=1;ae->tick+=4;break;
					default:
						MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is EX DE,HL\n");
				}
				break;
			case CRC_IX:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_MSP:___output(ae,0xDD);___output(ae,0xE3);ae->nop+=7;ae->tick+=23;break;
					default:
						MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is EX IX,(SP)\n");
				}
				break;
			case CRC_IY:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_MSP:___output(ae,0xFD);___output(ae,0xE3);ae->nop+=7;ae->tick+=23;break;
					default:
						MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is EX IY,(SP)\n");
				}
				break;
			default:
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is EX [AF,DE,HL,(SP),IX,IY],reg16\n");
		}
		ae->idx+=2;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Use EX reg16,[DE|(SP)]\n");
	}
}

void _SBC(struct s_assenv *ae) {
	if ((!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) || ((!ae->wl[ae->idx].t && !ae->wl[ae->idx+1].t && ae->wl[ae->idx+2].t==1) && strcmp(ae->wl[ae->idx+1].w,"A")==0)) {
		if (!ae->wl[ae->idx+1].t) ae->idx++;
		/* do implicit A */
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_A:___output(ae,0x9F);ae->nop+=1;ae->tick+=4;break;
			case CRC_MHL:___output(ae,0x9E);ae->nop+=2;ae->tick+=7;break;
			case CRC_B:___output(ae,0x98);ae->nop+=1;ae->tick+=4;break;
			case CRC_C:___output(ae,0x99);ae->nop+=1;ae->tick+=4;break;
			case CRC_D:___output(ae,0x9A);ae->nop+=1;ae->tick+=4;break;
			case CRC_E:___output(ae,0x9B);ae->nop+=1;ae->tick+=4;break;
			case CRC_H:___output(ae,0x9C);ae->nop+=1;ae->tick+=4;break;
			case CRC_L:___output(ae,0x9D);ae->nop+=1;ae->tick+=4;break;
			case CRC_IXH:case CRC_HX:case CRC_XH:___output(ae,0xDD);___output(ae,0x9C);ae->nop+=2;ae->tick+=8;break;
			case CRC_IXL:case CRC_LX:case CRC_XL:___output(ae,0xDD);___output(ae,0x9D);ae->nop+=2;ae->tick+=8;break;
			case CRC_IYH:case CRC_HY:case CRC_YH:___output(ae,0xFD);___output(ae,0x9C);ae->nop+=2;ae->tick+=8;break;
			case CRC_IYL:case CRC_LY:case CRC_YL:___output(ae,0xFD);___output(ae,0x9D);ae->nop+=2;ae->tick+=8;break;
			case CRC_IX:case CRC_IY:
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Use SBC with A,B,C,D,E,H,L,XH,XL,YH,YL,(HL),(IX),(IY)\n");
				ae->idx++;
				return;
			default:
				if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
					___output(ae,0xDD);___output(ae,0x9E);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					ae->nop+=5;ae->tick+=19;
				} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
					___output(ae,0xFD);___output(ae,0x9E);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					ae->nop+=5;ae->tick+=19;
				} else {
					___output(ae,0xDE);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_V8);
					ae->nop+=2;ae->tick+=7;
				}
		}
		ae->idx++;
	} else if (!ae->wl[ae->idx].t && !ae->wl[ae->idx+1].t && ae->wl[ae->idx+2].t==1) {
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_HL:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_BC:___output(ae,0xED);___output(ae,0x42);ae->nop+=4;ae->tick+=15;break;
					case CRC_DE:___output(ae,0xED);___output(ae,0x52);ae->nop+=4;ae->tick+=15;break;
					case CRC_HL:___output(ae,0xED);___output(ae,0x62);ae->nop+=4;ae->tick+=15;break;
					case CRC_SP:___output(ae,0xED);___output(ae,0x72);ae->nop+=4;ae->tick+=15;break;
					default:
						MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SBC HL,[BC,DE,HL,SP]\n");
				}
				break;
			default:
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SBC HL,[BC,DE,HL,SP]\n");
		}
		ae->idx+=2;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Invalid syntax for SBC\n");
	}
}

void _ADC(struct s_assenv *ae) {
	if ((!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) || ((!ae->wl[ae->idx].t && !ae->wl[ae->idx+1].t && ae->wl[ae->idx+2].t==1) && strcmp(ae->wl[ae->idx+1].w,"A")==0)) {
		if (!ae->wl[ae->idx+1].t) ae->idx++;
		/* also implicit A */
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_A:___output(ae,0x8F);ae->nop+=1;ae->tick+=4;break;
			case CRC_MHL:___output(ae,0x8E);ae->nop+=2;ae->tick+=7;break;
			case CRC_B:___output(ae,0x88);ae->nop+=1;ae->tick+=4;break;
			case CRC_C:___output(ae,0x89);ae->nop+=1;ae->tick+=4;break;
			case CRC_D:___output(ae,0x8A);ae->nop+=1;ae->tick+=4;break;
			case CRC_E:___output(ae,0x8B);ae->nop+=1;ae->tick+=4;break;
			case CRC_H:___output(ae,0x8C);ae->nop+=1;ae->tick+=4;break;
			case CRC_L:___output(ae,0x8D);ae->nop+=1;ae->tick+=4;break;
			case CRC_IXH:case CRC_HX:case CRC_XH:___output(ae,0xDD);___output(ae,0x8C);ae->nop+=2;ae->tick+=8;break;
			case CRC_IXL:case CRC_LX:case CRC_XL:___output(ae,0xDD);___output(ae,0x8D);ae->nop+=2;ae->tick+=8;break;
			case CRC_IYH:case CRC_HY:case CRC_YH:___output(ae,0xFD);___output(ae,0x8C);ae->nop+=2;ae->tick+=8;break;
			case CRC_IYL:case CRC_LY:case CRC_YL:___output(ae,0xFD);___output(ae,0x8D);ae->nop+=2;ae->tick+=8;break;
			case CRC_IX:case CRC_IY:
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Use ADC with A,B,C,D,E,H,L,XH,XL,YH,YL,(HL),(IX),(IY)\n");
				ae->idx++;
				return;
			default:
				if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
					___output(ae,0xDD);___output(ae,0x8E);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					ae->nop+=5;ae->tick+=19;
				} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
					___output(ae,0xFD);___output(ae,0x8E);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					ae->nop+=5;ae->tick+=19;
				} else {
					___output(ae,0xCE);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_V8);
					ae->nop+=2;ae->tick+=7;
				}
		}
		ae->idx++;
	} else if (!ae->wl[ae->idx].t && !ae->wl[ae->idx+1].t && ae->wl[ae->idx+2].t==1) {
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_HL:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_BC:___output(ae,0xED);___output(ae,0x4A);ae->nop+=4;ae->tick+=15;break;
					case CRC_DE:___output(ae,0xED);___output(ae,0x5A);ae->nop+=4;ae->tick+=15;break;
					case CRC_HL:___output(ae,0xED);___output(ae,0x6A);ae->nop+=4;ae->tick+=15;break;
					case CRC_SP:___output(ae,0xED);___output(ae,0x7A);ae->nop+=4;ae->tick+=15;break;
					default:
						MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is ADC HL,[BC,DE,HL,SP]\n");
				}
				break;
			default:
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is ADC HL,[BC,DE,HL,SP]\n");
		}
		ae->idx+=2;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Invalid syntax for ADC\n");
	}
}

void _ADD(struct s_assenv *ae) {
	if ((!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) || ((!ae->wl[ae->idx].t && !ae->wl[ae->idx+1].t && ae->wl[ae->idx+2].t==1) && strcmp(ae->wl[ae->idx+1].w,"A")==0)) {
		if (!ae->wl[ae->idx+1].t) ae->idx++;
		/* also implicit A */
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_A:___output(ae,0x87);ae->nop+=1;ae->tick+=4;break;
			case CRC_MHL:___output(ae,0x86);ae->nop+=2;ae->tick+=7;break;
			case CRC_B:___output(ae,0x80);ae->nop+=1;ae->tick+=4;break;
			case CRC_C:___output(ae,0x81);ae->nop+=1;ae->tick+=4;break;
			case CRC_D:___output(ae,0x82);ae->nop+=1;ae->tick+=4;break;
			case CRC_E:___output(ae,0x83);ae->nop+=1;ae->tick+=4;break;
			case CRC_H:___output(ae,0x84);ae->nop+=1;ae->tick+=4;break;
			case CRC_L:___output(ae,0x85);ae->nop+=1;ae->tick+=4;break;
			case CRC_IXH:case CRC_HX:case CRC_XH:___output(ae,0xDD);___output(ae,0x84);ae->nop+=2;ae->tick+=8;break;
			case CRC_IXL:case CRC_LX:case CRC_XL:___output(ae,0xDD);___output(ae,0x85);ae->nop+=2;ae->tick+=8;break;
			case CRC_IYH:case CRC_HY:case CRC_YH:___output(ae,0xFD);___output(ae,0x84);ae->nop+=2;ae->tick+=8;break;
			case CRC_IYL:case CRC_LY:case CRC_YL:___output(ae,0xFD);___output(ae,0x85);ae->nop+=2;ae->tick+=8;break;
			case CRC_IX:case CRC_IY:
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Use ADD with A,B,C,D,E,H,L,XH,XL,YH,YL,(HL),(IX),(IY)\n");
				ae->idx++;
				return;
			default:
				if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
					___output(ae,0xDD);___output(ae,0x86);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					ae->nop+=5;ae->tick+=19;
				} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
					___output(ae,0xFD);___output(ae,0x86);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					ae->nop+=5;ae->tick+=19;
				} else {
					___output(ae,0xC6);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_V8);
					ae->nop+=2;ae->tick+=7;
				}
		}
		ae->idx++;
	} else if (!ae->wl[ae->idx].t && !ae->wl[ae->idx+1].t && ae->wl[ae->idx+2].t==1) {
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_HL:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_BC:___output(ae,0x09);ae->nop+=3;ae->tick+=11;break;
					case CRC_DE:___output(ae,0x19);ae->nop+=3;ae->tick+=11;break;
					case CRC_HL:___output(ae,0x29);ae->nop+=3;ae->tick+=11;break;
					case CRC_SP:___output(ae,0x39);ae->nop+=3;ae->tick+=11;break;
					default:
						MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is ADD HL,[BC,DE,HL,SP]\n");
				}
				break;
			case CRC_IX:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_BC:___output(ae,0xDD);___output(ae,0x09);ae->nop+=4;ae->tick+=15;break;
					case CRC_DE:___output(ae,0xDD);___output(ae,0x19);ae->nop+=4;ae->tick+=15;break;
					case CRC_IX:___output(ae,0xDD);___output(ae,0x29);ae->nop+=4;ae->tick+=15;break;
					case CRC_SP:___output(ae,0xDD);___output(ae,0x39);ae->nop+=4;ae->tick+=15;break;
					default:
						MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is ADD IX,[BC,DE,IX,SP]\n");
				}
				break;
			case CRC_IY:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_BC:___output(ae,0xFD);___output(ae,0x09);ae->nop+=4;ae->tick+=15;break;
					case CRC_DE:___output(ae,0xFD);___output(ae,0x19);ae->nop+=4;ae->tick+=15;break;
					case CRC_IY:___output(ae,0xFD);___output(ae,0x29);ae->nop+=4;ae->tick+=15;break;
					case CRC_SP:___output(ae,0xFD);___output(ae,0x39);ae->nop+=4;ae->tick+=15;break;
					default:
						MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is ADD IY,[BC,DE,IY,SP]\n");
				}
				break;
			default:
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is ADD [HL,IX,IY],reg16\n");
		}
		ae->idx+=2;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Invalid syntax for ADD\n");
	}
}

void _CP(struct s_assenv *ae) {
	if ((!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) || ((!ae->wl[ae->idx].t && !ae->wl[ae->idx+1].t && ae->wl[ae->idx+2].t==1) && strcmp(ae->wl[ae->idx+1].w,"A")==0)) {
		if (!ae->wl[ae->idx+1].t) ae->idx++;
		/* also implicit A */
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_A:___output(ae,0xBF);ae->nop+=1;ae->tick+=4;break;
			case CRC_MHL:___output(ae,0xBE);ae->nop+=2;ae->tick+=7;break;
			case CRC_B:___output(ae,0xB8);ae->nop+=1;ae->tick+=4;break;
			case CRC_C:___output(ae,0xB9);ae->nop+=1;ae->tick+=4;break;
			case CRC_D:___output(ae,0xBA);ae->nop+=1;ae->tick+=4;break;
			case CRC_E:___output(ae,0xBB);ae->nop+=1;ae->tick+=4;break;
			case CRC_H:___output(ae,0xBC);ae->nop+=1;ae->tick+=4;break;
			case CRC_L:___output(ae,0xBD);ae->nop+=1;ae->tick+=4;break;
			case CRC_IXH:case CRC_HX:case CRC_XH:___output(ae,0xDD);___output(ae,0xBC);ae->nop+=2;ae->tick+=8;break;
			case CRC_IXL:case CRC_LX:case CRC_XL:___output(ae,0xDD);___output(ae,0xBD);ae->nop+=2;ae->tick+=8;break;
			case CRC_IYH:case CRC_HY:case CRC_YH:___output(ae,0xFD);___output(ae,0xBC);ae->nop+=2;ae->tick+=8;break;
			case CRC_IYL:case CRC_LY:case CRC_YL:___output(ae,0xFD);___output(ae,0xBD);ae->nop+=2;ae->tick+=8;break;
			default:
				if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
					___output(ae,0xDD);___output(ae,0xBE);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					ae->nop+=5;ae->tick+=19;
				} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
					___output(ae,0xFD);___output(ae,0xBE);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					ae->nop+=5;ae->tick+=19;
				} else {
					___output(ae,0xFE);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_V8);
					ae->nop+=2;ae->tick+=7;
				}
		}
		ae->idx++;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Syntax is CP reg8/(reg16)\n");
	}
}

void _RET(struct s_assenv *ae) {
	if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) {
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_NZ:___output(ae,0xC0);ae->nop+=2;ae->tick+=5;break;
			case CRC_Z:___output(ae,0xC8);ae->nop+=2;ae->tick+=5;break;
			case CRC_C:___output(ae,0xD8);ae->nop+=2;ae->tick+=5;break;
			case CRC_NC:___output(ae,0xD0);ae->nop+=2;ae->tick+=5;break;
			case CRC_PE:___output(ae,0xE8);ae->nop+=2;ae->tick+=5;break;
			case CRC_PO:___output(ae,0xE0);ae->nop+=2;ae->tick+=5;break;
			case CRC_P:___output(ae,0xF0);ae->nop+=2;ae->tick+=5;break;
			case CRC_M:___output(ae,0xF8);ae->nop+=2;ae->tick+=5;break;
			default:
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Available flags for RET are C,NC,Z,NZ,PE,PO,P,M\n");
		}
		ae->idx++;
	} else if (ae->wl[ae->idx].t==1) {
		___output(ae,0xC9);
		ae->nop+=3;ae->tick+=10;
		ae->deadend=1;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Invalid RET syntax\n");
	}
}

void _CALL(struct s_assenv *ae) {
	if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==0 && ae->wl[ae->idx+2].t==1) {
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_C:___output(ae,0xDC);ae->nop+=3;ae->tick+=10;break;
			case CRC_Z:___output(ae,0xCC);ae->nop+=3;ae->tick+=10;break;
			case CRC_NZ:___output(ae,0xC4);ae->nop+=3;ae->tick+=10;break;
			case CRC_NC:___output(ae,0xD4);ae->nop+=3;ae->tick+=10;break;
			case CRC_PE:___output(ae,0xEC);ae->nop+=3;ae->tick+=10;break;
			case CRC_PO:___output(ae,0xE4);ae->nop+=3;ae->tick+=10;break;
			case CRC_P:___output(ae,0xF4);ae->nop+=3;ae->tick+=10;break;
			case CRC_M:___output(ae,0xFC);ae->nop+=3;ae->tick+=10;break;
			default:
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Available flags for CALL are C,NC,Z,NZ,PE,PO,P,M\n");
		}
		PushExpression(ae,ae->idx+2,E_EXPRESSION_J16C);
		ae->idx+=2;
	} else if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) {
		___output(ae,0xCD);
		PushExpression(ae,ae->idx+1,E_EXPRESSION_J16C);
		ae->idx++;
		ae->nop+=5;ae->tick+=17;
		ae->deadend=1;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Invalid CALL syntax\n");
	}
}

void _JR(struct s_assenv *ae) {
	if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==0 && ae->wl[ae->idx+2].t==1) {
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_NZ:___output(ae,0x20);ae->nop+=2;ae->tick+=7;break;
			case CRC_C:___output(ae,0x38);ae->nop+=2;ae->tick+=7;break;
			case CRC_Z:___output(ae,0x28);ae->nop+=2;ae->tick+=7;break;
			case CRC_NC:___output(ae,0x30);ae->nop+=2;ae->tick+=7;break;
			default:
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Available flags for JR are C,NC,Z,NZ\n");
		}
		PushExpression(ae,ae->idx+2,E_EXPRESSION_J8);
		ae->idx+=2;
	} else if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) {
		___output(ae,0x18);
		PushExpression(ae,ae->idx+1,E_EXPRESSION_J8);
		ae->idx++;
		ae->nop+=3;ae->tick+=12;
		ae->deadend=1;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Invalid JR syntax\n");
	}
}

void _JP(struct s_assenv *ae) {
	if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==0 && ae->wl[ae->idx+2].t==1) {
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_C:___output(ae,0xDA);ae->nop+=3;ae->tick+=10;break;
			case CRC_Z:___output(ae,0xCA);ae->nop+=3;ae->tick+=10;break;
			case CRC_NZ:___output(ae,0xC2);ae->nop+=3;ae->tick+=10;break;
			case CRC_NC:___output(ae,0xD2);ae->nop+=3;ae->tick+=10;break;
			case CRC_PE:___output(ae,0xEA);ae->nop+=3;ae->tick+=10;break;
			case CRC_PO:___output(ae,0xE2);ae->nop+=3;ae->tick+=10;break;
			case CRC_P:___output(ae,0xF2);ae->nop+=3;ae->tick+=10;break;
			case CRC_M:___output(ae,0xFA);ae->nop+=3;ae->tick+=10;break;
			default:
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Available flags for JP are C,NC,Z,NZ,PE,PO,P,M\n");
		}
		if (!strcmp(ae->wl[ae->idx+2].w,"(IX)") || !strcmp(ae->wl[ae->idx+2].w,"(IY)")) {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"conditionnal JP cannot use register addressing\n");
		} else {
			PushExpression(ae,ae->idx+2,E_EXPRESSION_J16);
		}
		ae->idx+=2;
	} else if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) {
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_HL:case CRC_MHL:___output(ae,0xE9);ae->nop+=1;ae->tick+=4;break;
			case CRC_IX:case CRC_MIX:___output(ae,0xDD);___output(ae,0xE9);ae->nop+=2;ae->tick+=8;break;
			case CRC_IY:case CRC_MIY:___output(ae,0xFD);___output(ae,0xE9);ae->nop+=2;ae->tick+=8;break;
			default:
				if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0 || strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"JP (IX) or JP (IY) only\n");
				} else {
					___output(ae,0xC3);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_J16);
					ae->tick+=10;
					ae->nop+=3;
				}
		}
		ae->idx++;
		ae->deadend=1;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Invalid JP syntax\n");
	}
}


void _DEC(struct s_assenv *ae) {
	if (!ae->wl[ae->idx].t) {
		do {
			switch (GetCRC(ae->wl[ae->idx+1].w)) {
				case CRC_A:___output(ae,0x3D);ae->nop+=1;ae->tick+=4;break;
				case CRC_B:___output(ae,0x05);ae->nop+=1;ae->tick+=4;break;
				case CRC_C:___output(ae,0x0D);ae->nop+=1;ae->tick+=4;break;
				case CRC_D:___output(ae,0x15);ae->nop+=1;ae->tick+=4;break;
				case CRC_E:___output(ae,0x1D);ae->nop+=1;ae->tick+=4;break;
				case CRC_H:___output(ae,0x25);ae->nop+=1;ae->tick+=4;break;
				case CRC_L:___output(ae,0x2D);ae->nop+=1;ae->tick+=4;break;
				case CRC_IXH:case CRC_HX:case CRC_XH:___output(ae,0xDD);___output(ae,0x25);ae->nop+=2;ae->tick+=8;break;
				case CRC_IXL:case CRC_LX:case CRC_XL:___output(ae,0xDD);___output(ae,0x2D);ae->nop+=2;ae->tick+=8;break;
				case CRC_IYH:case CRC_HY:case CRC_YH:___output(ae,0xFD);___output(ae,0x25);ae->nop+=2;ae->tick+=8;break;
				case CRC_IYL:case CRC_LY:case CRC_YL:___output(ae,0xFD);___output(ae,0x2D);ae->nop+=2;ae->tick+=8;break;
				case CRC_BC:___output(ae,0x0B);ae->nop+=2;ae->tick+=6;break;
				case CRC_DE:___output(ae,0x1B);ae->nop+=2;ae->tick+=6;break;
				case CRC_HL:___output(ae,0x2B);ae->nop+=2;ae->tick+=6;break;
				case CRC_IX:___output(ae,0xDD);___output(ae,0x2B);ae->nop+=3;ae->tick+=10;break;
				case CRC_IY:___output(ae,0xFD);___output(ae,0x2B);ae->nop+=3;ae->tick+=10;break;
				case CRC_SP:___output(ae,0x3B);ae->nop+=2;ae->tick+=6;break;
				case CRC_MHL:___output(ae,0x35);ae->nop+=3;ae->tick+=11;break;
				default:
					if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
						___output(ae,0xDD);___output(ae,0x35);
						PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
						ae->nop+=6;ae->tick+=23;
					} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
						___output(ae,0xFD);___output(ae,0x35);
						PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
						ae->nop+=6;ae->tick+=23;
					} else {
						MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Use DEC with A,B,C,D,E,H,L,XH,XL,YH,YL,BC,DE,HL,SP,(HL),(IX),(IY)\n");
					}
			}
			ae->idx++;
		} while (ae->wl[ae->idx].t==0);
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Use DEC with A,B,C,D,E,H,L,XH,XL,YH,YL,BC,DE,HL,SP,(HL),(IX),(IY)\n");
	}
}
void _INC(struct s_assenv *ae) {
	if (!ae->wl[ae->idx].t) {
		do {
			switch (GetCRC(ae->wl[ae->idx+1].w)) {
				case CRC_A:___output(ae,0x3C);ae->nop+=1;ae->tick+=4;break;
				case CRC_B:___output(ae,0x04);ae->nop+=1;ae->tick+=4;break;
				case CRC_C:___output(ae,0x0C);ae->nop+=1;ae->tick+=4;break;
				case CRC_D:___output(ae,0x14);ae->nop+=1;ae->tick+=4;break;
				case CRC_E:___output(ae,0x1C);ae->nop+=1;ae->tick+=4;break;
				case CRC_H:___output(ae,0x24);ae->nop+=1;ae->tick+=4;break;
				case CRC_L:___output(ae,0x2C);ae->nop+=1;ae->tick+=4;break;
				case CRC_IXH:case CRC_HX:case CRC_XH:___output(ae,0xDD);___output(ae,0x24);ae->nop+=2;ae->tick+=8;break;
				case CRC_IXL:case CRC_LX:case CRC_XL:___output(ae,0xDD);___output(ae,0x2C);ae->nop+=2;ae->tick+=8;break;
				case CRC_IYH:case CRC_HY:case CRC_YH:___output(ae,0xFD);___output(ae,0x24);ae->nop+=2;ae->tick+=8;break;
				case CRC_IYL:case CRC_LY:case CRC_YL:___output(ae,0xFD);___output(ae,0x2C);ae->nop+=2;ae->tick+=8;break;
				case CRC_BC:___output(ae,0x03);ae->nop+=2;ae->tick+=6;break;
				case CRC_DE:___output(ae,0x13);ae->nop+=2;ae->tick+=6;break;
				case CRC_HL:___output(ae,0x23);ae->nop+=2;ae->tick+=6;break;
				case CRC_IX:___output(ae,0xDD);___output(ae,0x23);ae->nop+=3;ae->tick+=10;break;
				case CRC_IY:___output(ae,0xFD);___output(ae,0x23);ae->nop+=3;ae->tick+=10;break;
				case CRC_SP:___output(ae,0x33);ae->nop+=2;ae->tick+=6;break;
				case CRC_MHL:___output(ae,0x34);ae->nop+=3;ae->tick+=11;break;
				default:
					if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
						___output(ae,0xDD);___output(ae,0x34);
						PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
						ae->nop+=6;ae->tick+=23;
					} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
						___output(ae,0xFD);___output(ae,0x34);
						PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
						ae->nop+=6;ae->tick+=23;
					} else {
						MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Use INC with A,B,C,D,E,H,L,XH,XL,YH,YL,BC,DE,HL,SP,(HL),(IX),(IY)\n");
					}
			}
			ae->idx++;
		} while (ae->wl[ae->idx].t==0);
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Use INC with A,B,C,D,E,H,L,XH,XL,YH,YL,BC,DE,HL,SP,(HL),(IX),(IY)\n");
	}
}

void _SUB(struct s_assenv *ae) {
	#ifdef OPCODE
	#undef OPCODE
	#endif
	#define OPCODE 0x90
	
	if ((!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1)  || ((!ae->wl[ae->idx].t && !ae->wl[ae->idx+1].t && ae->wl[ae->idx+2].t==1) && strcmp(ae->wl[ae->idx+1].w,"A")==0)) {
		if (!ae->wl[ae->idx+1].t) ae->idx++;
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_A:___output(ae,OPCODE+7);ae->nop+=1;ae->tick+=4;break;
			case CRC_MHL:___output(ae,OPCODE+6);ae->nop+=2;ae->tick+=7;break;
			case CRC_B:___output(ae,OPCODE);ae->nop+=1;ae->tick+=4;break;
			case CRC_C:___output(ae,OPCODE+1);ae->nop+=1;ae->tick+=4;break;
			case CRC_D:___output(ae,OPCODE+2);ae->nop+=1;ae->tick+=4;break;
			case CRC_E:___output(ae,OPCODE+3);ae->nop+=1;ae->tick+=4;break;
			case CRC_H:___output(ae,OPCODE+4);ae->nop+=1;ae->tick+=4;break;
			case CRC_L:___output(ae,OPCODE+5);ae->nop+=1;ae->tick+=4;break;
			case CRC_IXH:case CRC_HX:case CRC_XH:___output(ae,0xDD);___output(ae,OPCODE+4);ae->nop+=2;ae->tick+=8;break;
			case CRC_IXL:case CRC_LX:case CRC_XL:___output(ae,0xDD);___output(ae,OPCODE+5);ae->nop+=2;ae->tick+=8;break;
			case CRC_IYH:case CRC_HY:case CRC_YH:___output(ae,0xFD);___output(ae,OPCODE+4);ae->nop+=2;ae->tick+=8;break;
			case CRC_IYL:case CRC_LY:case CRC_YL:___output(ae,0xFD);___output(ae,OPCODE+5);ae->nop+=2;ae->tick+=8;break;
			case CRC_IX:case CRC_IY:
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Use SUB with A,B,C,D,E,H,L,XH,XL,YH,YL,(HL),(IX),(IY)\n");
				ae->idx++;
				return;
			default:
				if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
					___output(ae,0xDD);___output(ae,OPCODE+6);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					ae->nop+=5;ae->tick+=19;
				} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
					___output(ae,0xFD);___output(ae,OPCODE+6);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					ae->nop+=5;ae->tick+=19;
				} else {
					___output(ae,0xD6);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_V8);
					ae->nop+=2;ae->tick+=7;
				}
		}
		ae->idx++;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Use SUB with A,B,C,D,E,H,L,XH,XL,YH,YL,(HL),(IX),(IY)\n");
	}
}
void _AND(struct s_assenv *ae) {
	#ifdef OPCODE
	#undef OPCODE
	#endif
	#define OPCODE 0xA0
	
	if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) {
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_A:___output(ae,OPCODE+7);ae->nop+=1;ae->tick+=4;break;
			case CRC_MHL:___output(ae,OPCODE+6);ae->nop+=2;ae->tick+=7;break;
			case CRC_B:___output(ae,OPCODE);ae->nop+=1;ae->tick+=4;break;
			case CRC_C:___output(ae,OPCODE+1);ae->nop+=1;ae->tick+=4;break;
			case CRC_D:___output(ae,OPCODE+2);ae->nop+=1;ae->tick+=4;break;
			case CRC_E:___output(ae,OPCODE+3);ae->nop+=1;ae->tick+=4;break;
			case CRC_H:___output(ae,OPCODE+4);ae->nop+=1;ae->tick+=4;break;
			case CRC_L:___output(ae,OPCODE+5);ae->nop+=1;ae->tick+=4;break;
			case CRC_IXH:case CRC_HX:case CRC_XH:___output(ae,0xDD);___output(ae,OPCODE+4);ae->nop+=2;ae->tick+=8;break;
			case CRC_IXL:case CRC_LX:case CRC_XL:___output(ae,0xDD);___output(ae,OPCODE+5);ae->nop+=2;ae->tick+=8;break;
			case CRC_IYH:case CRC_HY:case CRC_YH:___output(ae,0xFD);___output(ae,OPCODE+4);ae->nop+=2;ae->tick+=8;break;
			case CRC_IYL:case CRC_LY:case CRC_YL:___output(ae,0xFD);___output(ae,OPCODE+5);ae->nop+=2;ae->tick+=8;break;
			default:
				if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
					___output(ae,0xDD);___output(ae,OPCODE+6);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					ae->nop+=5;ae->tick+=19;
				} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
					___output(ae,0xFD);___output(ae,OPCODE+6);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					ae->nop+=5;ae->tick+=19;
				} else {
					___output(ae,0xE6);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_V8);
					ae->nop+=2;ae->tick+=7;
				}
		}
		ae->idx++;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Use AND with A,B,C,D,E,H,L,XH,XL,YH,YL,(HL),(IX),(IY)\n");
	}
}
void _OR(struct s_assenv *ae) {
	#ifdef OPCODE
	#undef OPCODE
	#endif
	#define OPCODE 0xB0
	
	if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) {
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_A:___output(ae,OPCODE+7);ae->nop+=1;ae->tick+=4;break;
			case CRC_MHL:___output(ae,OPCODE+6);ae->nop+=2;ae->tick+=7;break;
			case CRC_B:___output(ae,OPCODE);ae->nop+=1;ae->tick+=4;break;
			case CRC_C:___output(ae,OPCODE+1);ae->nop+=1;ae->tick+=4;break;
			case CRC_D:___output(ae,OPCODE+2);ae->nop+=1;ae->tick+=4;break;
			case CRC_E:___output(ae,OPCODE+3);ae->nop+=1;ae->tick+=4;break;
			case CRC_H:___output(ae,OPCODE+4);ae->nop+=1;ae->tick+=4;break;
			case CRC_L:___output(ae,OPCODE+5);ae->nop+=1;ae->tick+=4;break;
			case CRC_IXH:case CRC_HX:case CRC_XH:___output(ae,0xDD);___output(ae,OPCODE+4);ae->nop+=2;ae->tick+=8;break;
			case CRC_IXL:case CRC_LX:case CRC_XL:___output(ae,0xDD);___output(ae,OPCODE+5);ae->nop+=2;ae->tick+=8;break;
			case CRC_IYH:case CRC_HY:case CRC_YH:___output(ae,0xFD);___output(ae,OPCODE+4);ae->nop+=2;ae->tick+=8;break;
			case CRC_IYL:case CRC_LY:case CRC_YL:___output(ae,0xFD);___output(ae,OPCODE+5);ae->nop+=2;ae->tick+=8;break;
			default:
				if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
					___output(ae,0xDD);___output(ae,OPCODE+6);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					ae->nop+=5;ae->tick+=19;
				} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
					___output(ae,0xFD);___output(ae,OPCODE+6);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					ae->nop+=5;ae->tick+=19;
				} else {
					___output(ae,0xF6);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_V8);
					ae->nop+=2;ae->tick+=7;
				}
		}
		ae->idx++;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Use OR with A,B,C,D,E,H,L,XH,XL,YH,YL,(HL),(IX),(IY)\n");
	}
}
void _XOR(struct s_assenv *ae) {
	#ifdef OPCODE
	#undef OPCODE
	#endif
	#define OPCODE 0xA8
	
	if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) {
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_A:___output(ae,OPCODE+7);ae->nop+=1;ae->tick+=4;break;
			case CRC_MHL:___output(ae,OPCODE+6);ae->nop+=2;ae->tick+=7;break;
			case CRC_B:___output(ae,OPCODE);ae->nop+=1;ae->tick+=4;break;
			case CRC_C:___output(ae,OPCODE+1);ae->nop+=1;ae->tick+=4;break;
			case CRC_D:___output(ae,OPCODE+2);ae->nop+=1;ae->tick+=4;break;
			case CRC_E:___output(ae,OPCODE+3);ae->nop+=1;ae->tick+=4;break;
			case CRC_H:___output(ae,OPCODE+4);ae->nop+=1;ae->tick+=4;break;
			case CRC_L:___output(ae,OPCODE+5);ae->nop+=1;ae->tick+=4;break;
			case CRC_IXH:case CRC_HX:case CRC_XH:___output(ae,0xDD);___output(ae,OPCODE+4);ae->nop+=2;ae->tick+=8;break;
			case CRC_IXL:case CRC_LX:case CRC_XL:___output(ae,0xDD);___output(ae,OPCODE+5);ae->nop+=2;ae->tick+=8;break;
			case CRC_IYH:case CRC_HY:case CRC_YH:___output(ae,0xFD);___output(ae,OPCODE+4);ae->nop+=2;ae->tick+=8;break;
			case CRC_IYL:case CRC_LY:case CRC_YL:___output(ae,0xFD);___output(ae,OPCODE+5);ae->nop+=2;ae->tick+=8;break;
			default:
				if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
					___output(ae,0xDD);___output(ae,OPCODE+6);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					ae->nop+=5;ae->tick+=19;
				} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
					___output(ae,0xFD);___output(ae,OPCODE+6);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					ae->nop+=5;ae->tick+=19;
				} else {
					___output(ae,0xEE);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_V8);
					ae->nop+=2;ae->tick+=7;
				}
		}
		ae->idx++;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Use XOR with A,B,C,D,E,H,L,XH,XL,YH,YL,(HL),(IX),(IY)\n");
	}
}


void _POP(struct s_assenv *ae) {
	if (!ae->wl[ae->idx].t) {
		do {
			ae->idx++;
			switch (GetCRC(ae->wl[ae->idx].w)) {
				case CRC_AF:___output(ae,0xF1);ae->nop+=3;ae->tick+=10;break;
				case CRC_BC:___output(ae,0xC1);ae->nop+=3;ae->tick+=10;break;
				case CRC_DE:___output(ae,0xD1);ae->nop+=3;ae->tick+=10;break;
				case CRC_HL:___output(ae,0xE1);ae->nop+=3;ae->tick+=10;break;
				case CRC_IX:___output(ae,0xDD);___output(ae,0xE1);ae->nop+=4;ae->tick+=14;break;
				case CRC_IY:___output(ae,0xFD);___output(ae,0xE1);ae->nop+=4;ae->tick+=14;break;
				default:
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Use POP with AF,BC,DE,HL,IX,IY\n");
			}
		} while (ae->wl[ae->idx].t!=1);
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"POP need at least one parameter\n");
	}
}
void _PUSH(struct s_assenv *ae) {
	if (!ae->wl[ae->idx].t) {
		do {
			ae->idx++;
			switch (GetCRC(ae->wl[ae->idx].w)) {
				case CRC_AF:___output(ae,0xF5);ae->nop+=4;ae->tick+=11;break;
				case CRC_BC:___output(ae,0xC5);ae->nop+=4;ae->tick+=11;break;
				case CRC_DE:___output(ae,0xD5);ae->nop+=4;ae->tick+=11;break;
				case CRC_HL:___output(ae,0xE5);ae->nop+=4;ae->tick+=11;break;
				case CRC_IX:___output(ae,0xDD);___output(ae,0xE5);ae->nop+=5;ae->tick+=15;break;
				case CRC_IY:___output(ae,0xFD);___output(ae,0xE5);ae->nop+=5;ae->tick+=15;break;
				default:
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Use PUSH with AF,BC,DE,HL,IX,IY\n");
			}
		} while (ae->wl[ae->idx].t!=1);
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"PUSH need at least one parameter\n");
	}
}

void _IM(struct s_assenv *ae) {
	if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) {
		/* la valeur du parametre va definir l'opcode du IM */
		___output(ae,0xED);
		PushExpression(ae,ae->idx+1,E_EXPRESSION_IM);
		ae->idx++;
		ae->nop+=2;
		ae->tick+=8;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"IM need one parameter\n");
	}
}

void _RLCA(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0x7);
		ae->nop+=1;
		ae->tick+=4;
	} else if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) {
		int o;
		//ExpressionFastTranslate(ae,&ae->wl[ae->idx+1].w,0);
		o=RoundComputeExpressionCore(ae,ae->wl[ae->idx+1].w,ae->codeadr,0);
		if (o>0) {
			while (o>0) {
				___output(ae,0x7);
				ae->nop+=1;
				ae->tick+=4;
				o--;
			}
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"RLCA <repetition> allows only non zero positive values\n");
		}
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"RLCA does not need parameter except if you want repetition\n");
	}
}
void _RRCA(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0xF);
		ae->nop+=1;
		ae->tick+=4;
	} else if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) {
		int o;
		//ExpressionFastTranslate(ae,&ae->wl[ae->idx+1].w,0);
		o=RoundComputeExpressionCore(ae,ae->wl[ae->idx+1].w,ae->codeadr,0);
		if (o>=0) {
			while (o>0) {
				___output(ae,0xF);
				ae->nop+=1;
				ae->tick+=4;
				o--;
			}
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"RLCA <repetition> allows only non zero positive values\n");
		}
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"RRCA does not need parameter except if you want repetition\n");
	}
}
void _NEG(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0xED);
		___output(ae,0x44);
		ae->nop+=2;
		ae->tick+=8;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"NEG does not need parameter\n");
	}
}
void _DAA(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0x27);
		ae->nop+=1;
		ae->tick+=4;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"DAA does not need parameter\n");
	}
}
void _CPL(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0x2F);
		ae->nop+=1;
		ae->tick+=4;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"CPL does not need parameter\n");
	}
}
void _RETI(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0xED);
		___output(ae,0x4D);
		ae->nop+=4;
		ae->tick+=14;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"RETI does not need parameter\n");
	}
}
void _SCF(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0x37);
		ae->nop+=1;
		ae->tick+=4;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"SCF does not need parameter\n");
	}
}
void _LDD(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0xED);
		___output(ae,0xA8);
		ae->nop+=5;
		ae->tick+=16;
	} else if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) {
		int o;
		//ExpressionFastTranslate(ae,&ae->wl[ae->idx+1].w,0);
		o=RoundComputeExpressionCore(ae,ae->wl[ae->idx+1].w,ae->codeadr,0);
		if (o>0) {
			while (o>0) {
				___output(ae,0xED);
				___output(ae,0xA8);
				ae->nop+=5;
				ae->tick+=16;
				o--;
			}
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"LDD minimum count is 1\n");
		}
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"LDD does not need parameter except if you want repetition\n");
	}
}
void _LDDR(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0xED);
		___output(ae,0xB8);
		ae->nop+=5;
		ae->tick+=16;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"LDDR does not need parameter\n");
	}
}
void _LDI(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0xED);
		___output(ae,0xA0);
		ae->nop+=5;
		ae->tick+=16;
	} else if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) {
		int o;
		//ExpressionFastTranslate(ae,&ae->wl[ae->idx+1].w,0);
		o=RoundComputeExpressionCore(ae,ae->wl[ae->idx+1].w,ae->codeadr,0);
		if (o>0) {
			while (o>0) {
				___output(ae,0xED);
				___output(ae,0xA0);
				ae->nop+=5;
				ae->tick+=16;
				o--;
			}
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"LDI minimum count is 1\n");
		}
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"LDI does not need parameter except if you want repetition\n");
	}
}
void _LDIR(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0xED);
		___output(ae,0xB0);
		ae->nop+=5;
		ae->tick+=16;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"LDIR does not need parameter\n");
	}
}
void _CCF(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0x3F);
		ae->nop+=1;
		ae->tick+=4;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"CCF does not need parameter\n");
	}
}
void _CPD(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0xED);
		___output(ae,0xA9);
		ae->nop+=4;
		ae->tick+=16;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"CPD does not need parameter\n");
	}
}
void _CPDR(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0xED);
		___output(ae,0xB9);
		ae->nop+=4;
		ae->tick+=16;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"CPDR does not need parameter\n");
	}
}
void _CPI(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0xED);
		___output(ae,0xA1);
		ae->nop+=4;
		ae->tick+=16;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"CPI does not need parameter\n");
	}
}
void _CPIR(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0xED);
		___output(ae,0xB1);
		ae->nop+=4;
		ae->tick+=16;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"CPIR does not need parameter\n");
	}
}
void _OUTD(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0xED);
		___output(ae,0xAB);
		ae->nop+=5;
		ae->tick+=16;
	} else if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) {
		int o;
		//ExpressionFastTranslate(ae,&ae->wl[ae->idx+1].w,0);
		o=RoundComputeExpressionCore(ae,ae->wl[ae->idx+1].w,ae->codeadr,0);
		if (o>0) {
			while (o>0) {
				___output(ae,0xED);
				___output(ae,0xAB);
				ae->nop+=5;
				ae->tick+=16;
				o--;
			}
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"OUTD minimum count is 1\n");
		}
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"OUTD does not need parameter except if you want repetition\n");
	}
}
void _OTDR(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0xED);
		___output(ae,0xBB);
		ae->nop+=5;
		ae->tick+=16;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"OTDR does not need parameter\n");
	}
}
void _OUTI(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0xED);
		___output(ae,0xA3);
		ae->nop+=5;
		ae->tick+=16;
	} else if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) {
		int o;
		//ExpressionFastTranslate(ae,&ae->wl[ae->idx+1].w,0);
		o=RoundComputeExpressionCore(ae,ae->wl[ae->idx+1].w,ae->codeadr,0);
		if (o>0) {
			while (o>0) {
				___output(ae,0xED);
				___output(ae,0xA3);
				ae->nop+=5;
				ae->tick+=16;
				o--;
			}
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"OUTI minimum count is 1\n");
		}
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"OUTI does not need parameter except if you want repetition\n");
	}
}
void _OTIR(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0xED);
		___output(ae,0xB3);
		ae->nop+=5;
		ae->tick+=16;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"OTIR does not need parameter\n");
	}
}
void _RETN(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0xED);
		___output(ae,0x45);
		ae->nop+=4;
		ae->tick+=14;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"RETN does not need parameter\n");
	}
}
void _IND(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0xED);
		___output(ae,0xAA);
		ae->nop+=5;
		ae->tick+=16;
	} else if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) {
		int o;
		//ExpressionFastTranslate(ae,&ae->wl[ae->idx+1].w,0);
		o=RoundComputeExpressionCore(ae,ae->wl[ae->idx+1].w,ae->codeadr,0);
		if (o>0) {
			while (o>0) {
				___output(ae,0xED);
				___output(ae,0xAA);
				ae->nop+=5;
				ae->tick+=16;
				o--;
			}
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"IND minimum count is 1\n");
		}
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"IND does not need parameter except if you want repetition\n");
	}
}
void _INDR(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0xED);
		___output(ae,0xBA);
		ae->nop+=5;
		ae->tick+=16;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"INDR does not need parameter\n");
	}
}
void _INI(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0xED);
		___output(ae,0xA2);
		ae->nop+=5;
		ae->tick+=16;
	} else if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) {
		int o;
		//ExpressionFastTranslate(ae,&ae->wl[ae->idx+1].w,0);
		o=RoundComputeExpressionCore(ae,ae->wl[ae->idx+1].w,ae->codeadr,0);
		if (o>0) {
			while (o>0) {
				___output(ae,0xED);
				___output(ae,0xA2);
				ae->nop+=5;
				ae->tick+=16;
				o--;
			}
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"INI minimum count is 1\n");
		}
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"INI does not need parameter except if you want repetition\n");
	}
}
void _INIR(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t==1) {
		___output(ae,0xED);
		___output(ae,0xB2);
		ae->nop+=5;
		ae->tick+=16;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"INIR does not need parameter\n");
	}
}
void _EXX(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t==1) {
		___output(ae,0xD9);
		ae->nop+=1;
		ae->tick+=4;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"EXX does not need parameter\n");
	}
}
void _HALT(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t==1) {
		___output(ae,0x76);
		ae->nop+=1;
		ae->tick+=4;
	} else if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) {
		int o;
		//ExpressionFastTranslate(ae,&ae->wl[ae->idx+1].w,0);
		o=RoundComputeExpressionCore(ae,ae->wl[ae->idx+1].w,ae->codeadr,0);
		if (o>=0) {
			while (o>0) {
				___output(ae,0x76);
				ae->nop+=1;
				ae->tick+=4;
				o--;
			}
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"HALT <repetition> must use posivite value\n");
		}
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"HALT does not need parameter (except if you want repetition)\n");
	}
}

void _RLA(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t==1) {
		___output(ae,0x17);
		ae->nop+=1;
		ae->tick+=4;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"RLA does not need parameter\n");
	}
}
void _RRA(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t==1) {
		___output(ae,0x1F);
		ae->nop+=1;
		ae->tick+=4;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"RRA does not need parameter\n");
	}
}
void _RLD(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t==1) {
		___output(ae,0xED);
		___output(ae,0x6F);
		ae->nop+=5;
		ae->tick+=18;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"RLD does not need parameter\n");
	}
}
void _RRD(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t==1) {
		___output(ae,0xED);
		___output(ae,0x67);
		ae->nop+=5;
		ae->tick+=18;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"RRD does not need parameter\n");
	}
}


void _EXA(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t==1) {
		___output(ae,0x08);ae->nop+=1;
		ae->tick+=4;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"EXA alias does not need parameter\n");
	}
}

void _NOP(struct s_assenv *ae) {
	int o;

	if (ae->wl[ae->idx].t) {
		___output(ae,0x00);
		ae->nop+=1;
		ae->tick+=4;
	} else if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) {
		//ExpressionFastTranslate(ae,&ae->wl[ae->idx+1].w,0);
		o=RoundComputeExpressionCore(ae,ae->wl[ae->idx+1].w,ae->codeadr,0);
		if (o>=0) {
			while (o>0) {
				___output(ae,0x00);
				ae->nop+=1;
				ae->tick+=4;
				o--;
			}
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"NOP <repetition> must use positive value\n");
		}
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"NOP is supposed to be used without parameter or with one optional parameter\n");
	}
}
void _DI(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
	___output(ae,0xF3);
	ae->nop+=1;
	ae->tick+=4;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"DI does not need parameter\n");
	}
}
void _EI(struct s_assenv *ae) {
	if (ae->wl[ae->idx].t) {
		___output(ae,0xFB);
		ae->nop+=1;
		ae->tick+=4;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"EI does not need parameter\n");
	}
}

void _RST(struct s_assenv *ae) {
	if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t!=2) {
		if (!ae->wl[ae->idx+1].t && ae->wl[ae->idx+2].t==1) { // alias mode
			switch (GetCRC(ae->wl[ae->idx+1].w)) {
				case CRC_NZ:___output(ae,0x20);ae->nop+=2;ae->tick+=7;break;
				case CRC_C:___output(ae,0x38);ae->nop+=2;ae->tick+=7;break;
				case CRC_Z:___output(ae,0x28);ae->nop+=2;ae->tick+=7;break;
				case CRC_NC:___output(ae,0x30);ae->nop+=2;ae->tick+=7;break;
				default:
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Available flags for RST condition,#38 are C,NC,Z,NZ\n");
			}
			PushExpression(ae,ae->idx+2,E_EXPRESSION_RSTC);
			ae->idx+=2;
		} else if (ae->wl[ae->idx+1].t) {
			if (!strcmp(ae->wl[ae->idx+1].w,"(IY)") || !strcmp(ae->wl[ae->idx+1].w,"(IX)")) {
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"RST cannot use IX or IY\n");
			} else {
				/* la valeur du parametre va definir l'opcode du RST */
				PushExpression(ae,ae->idx+1,E_EXPRESSION_RST);
			}
			ae->idx++;
			ae->nop+=4;
			ae->tick+=11;
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"usage is RST address or RST condition,#38\n");
		}
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"RST need at least one parameter\n");
	}
}

void _DJNZ(struct s_assenv *ae) {
	if (!ae->wl[ae->idx].t && ae->wl[ae->idx+1].t==1) {
		if (IsRegister(ae->wl[ae->idx+1].w)) {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"DJNZ cannot use register\n");
		} else if (strcmp("(IX)",ae->wl[ae->idx+1].w)==0 || strcmp("(IY)",ae->wl[ae->idx+1].w)==0) {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"DJNZ cannot use register\n");
		} else {
			___output(ae,0x10);
			PushExpression(ae,ae->idx+1,E_EXPRESSION_J8);
			ae->nop+=4;
			ae->tick+=13;
		}
		ae->idx++;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"DJNZ need one parameter\n");
	}
}

void _LD(struct s_assenv *ae) {
	/* on check qu'il y a au moins deux parametres */
	if (!ae->wl[ae->idx+1].t && ae->wl[ae->idx+2].t==1) {
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_A:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_I:___output(ae,0xED);___output(ae,0x57);ae->nop+=3;ae->tick+=9;break;
					case CRC_R:___output(ae,0xED);___output(ae,0x5F);ae->nop+=3;ae->tick+=9;break;
					case CRC_B:___output(ae,0x78);ae->nop+=1;ae->tick+=4;break;
					case CRC_C:___output(ae,0x79);ae->nop+=1;ae->tick+=4;break;
					case CRC_D:___output(ae,0x7A);ae->nop+=1;ae->tick+=4;break;
					case CRC_E:___output(ae,0x7B);ae->nop+=1;ae->tick+=4;break;
					case CRC_H:___output(ae,0x7C);ae->nop+=1;ae->tick+=4;break;
					case CRC_L:___output(ae,0x7D);ae->nop+=1;ae->tick+=4;break;
					case CRC_IXH:case CRC_HX:case CRC_XH:___output(ae,0xDD);___output(ae,0x7C);ae->nop+=2;ae->tick+=8;break;
					case CRC_IXL:case CRC_LX:case CRC_XL:___output(ae,0xDD);___output(ae,0x7D);ae->nop+=2;ae->tick+=8;break;
					case CRC_IYH:case CRC_HY:case CRC_YH:___output(ae,0xFD);___output(ae,0x7C);ae->nop+=2;ae->tick+=8;break;
					case CRC_IYL:case CRC_LY:case CRC_YL:___output(ae,0xFD);___output(ae,0x7D);ae->nop+=2;ae->tick+=8;break;
					case CRC_MHL:___output(ae,0x7E);ae->nop+=2;ae->tick+=7;break;
					case CRC_A:___output(ae,0x7F);ae->nop+=1;ae->tick+=4;break;
					case CRC_MBC:___output(ae,0x0A);ae->nop+=2;ae->tick+=7;break;
					case CRC_MDE:___output(ae,0x1A);ae->nop+=2;ae->tick+=7;break;
					default:
					/* (ix+expression) (iy+expression) (expression) expression */
					if (strncmp(ae->wl[ae->idx+2].w,"(IX",3)==0) {
						___output(ae,0xDD);___output(ae,0x7E);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						ae->nop+=5;ae->tick+=19;
					} else if (strncmp(ae->wl[ae->idx+2].w,"(IY",3)==0) {
						___output(ae,0xFD);___output(ae,0x7E);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						ae->nop+=5;ae->tick+=19;
					} else if (StringIsMem(ae->wl[ae->idx+2].w)) {
						___output(ae,0x3A);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_V16);
						ae->nop+=4;ae->tick+=13;
					} else {
						___output(ae,0x3E);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_V8);
						ae->nop+=2;ae->tick+=7;
					}
				}
				break;
			case CRC_I:
				if (GetCRC(ae->wl[ae->idx+2].w)==CRC_A) {
					___output(ae,0xED);___output(ae,0x47);
					ae->nop+=3;ae->tick+=9;
				} else {
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"LD I,A only\n");
				}
				break;
			case CRC_R:
				if (GetCRC(ae->wl[ae->idx+2].w)==CRC_A) {
					___output(ae,0xED);___output(ae,0x4F);
					ae->nop+=3;ae->tick+=9;
				} else {
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"LD R,A only\n");
				}
				break;
			case CRC_B:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_B:___output(ae,0x40);ae->nop+=1;ae->tick+=4;break;
					case CRC_C:___output(ae,0x41);ae->nop+=1;ae->tick+=4;break;
					case CRC_D:___output(ae,0x42);ae->nop+=1;ae->tick+=4;break;
					case CRC_E:___output(ae,0x43);ae->nop+=1;ae->tick+=4;break;
					case CRC_H:___output(ae,0x44);ae->nop+=1;ae->tick+=4;break;
					case CRC_L:___output(ae,0x45);ae->nop+=1;ae->tick+=4;break;
					case CRC_IXH:case CRC_HX:case CRC_XH:___output(ae,0xDD);___output(ae,0x44);ae->nop+=2;ae->tick+=8;break;
					case CRC_IXL:case CRC_LX:case CRC_XL:___output(ae,0xDD);___output(ae,0x45);ae->nop+=2;ae->tick+=8;break;
					case CRC_IYH:case CRC_HY:case CRC_YH:___output(ae,0xFD);___output(ae,0x44);ae->nop+=2;ae->tick+=8;break;
					case CRC_IYL:case CRC_LY:case CRC_YL:___output(ae,0xFD);___output(ae,0x45);ae->nop+=2;ae->tick+=8;break;
					case CRC_MHL:___output(ae,0x46);ae->nop+=2;ae->tick+=7;break;
					case CRC_A:___output(ae,0x47);ae->nop+=1;ae->tick+=4;break;
					default:
					/* (ix+expression) (iy+expression) expression */
					if (strncmp(ae->wl[ae->idx+2].w,"(IX",3)==0) {
						___output(ae,0xDD);___output(ae,0x46);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						ae->nop+=5;ae->tick+=19;
					} else if (strncmp(ae->wl[ae->idx+2].w,"(IY",3)==0) {
						___output(ae,0xFD);___output(ae,0x46);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						ae->nop+=5;ae->tick+=19;
					} else {
						___output(ae,0x06);
						EnforceNoAddressingMode(ae->idx+2);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_V8);
						ae->nop+=2;ae->tick+=7;
					}
				}
				break;
			case CRC_C:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_B:___output(ae,0x48);ae->nop+=1;ae->tick+=4;break;
					case CRC_C:___output(ae,0x49);ae->nop+=1;ae->tick+=4;break;
					case CRC_D:___output(ae,0x4A);ae->nop+=1;ae->tick+=4;break;
					case CRC_E:___output(ae,0x4B);ae->nop+=1;ae->tick+=4;break;
					case CRC_H:___output(ae,0x4C);ae->nop+=1;ae->tick+=4;break;
					case CRC_L:___output(ae,0x4D);ae->nop+=1;ae->tick+=4;break;
					case CRC_IXH:case CRC_HX:case CRC_XH:___output(ae,0xDD);___output(ae,0x4C);ae->nop+=2;ae->tick+=8;break;
					case CRC_IXL:case CRC_LX:case CRC_XL:___output(ae,0xDD);___output(ae,0x4D);ae->nop+=2;ae->tick+=8;break;
					case CRC_IYH:case CRC_HY:case CRC_YH:___output(ae,0xFD);___output(ae,0x4C);ae->nop+=2;ae->tick+=8;break;
					case CRC_IYL:case CRC_LY:case CRC_YL:___output(ae,0xFD);___output(ae,0x4D);ae->nop+=2;ae->tick+=8;break;
					case CRC_MHL:___output(ae,0x4E);ae->nop+=2;ae->tick+=7;break;
					case CRC_A:___output(ae,0x4F);ae->nop+=1;ae->tick+=4;break;
					default:
					/* (ix+expression) (iy+expression) expression */
					if (strncmp(ae->wl[ae->idx+2].w,"(IX",3)==0) {
						___output(ae,0xDD);___output(ae,0x4E);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						ae->nop+=5;ae->tick+=19;
					} else if (strncmp(ae->wl[ae->idx+2].w,"(IY",3)==0) {
						___output(ae,0xFD);___output(ae,0x4E);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						ae->nop+=5;ae->tick+=19;
					} else {
						___output(ae,0x0E);
						EnforceNoAddressingMode(ae->idx+2);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_V8);
						ae->nop+=2;ae->tick+=7;
					}
				}
				break;
			case CRC_D:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_B:___output(ae,0x50);ae->nop+=1;ae->tick+=4;break;
					case CRC_C:___output(ae,0x51);ae->nop+=1;ae->tick+=4;break;
					case CRC_D:___output(ae,0x52);ae->nop+=1;ae->tick+=4;break;
					case CRC_E:___output(ae,0x53);ae->nop+=1;ae->tick+=4;break;
					case CRC_H:___output(ae,0x54);ae->nop+=1;ae->tick+=4;break;
					case CRC_L:___output(ae,0x55);ae->nop+=1;ae->tick+=4;break;
					case CRC_IXH:case CRC_HX:case CRC_XH:___output(ae,0xDD);___output(ae,0x54);ae->nop+=2;ae->tick+=8;break;
					case CRC_IXL:case CRC_LX:case CRC_XL:___output(ae,0xDD);___output(ae,0x55);ae->nop+=2;ae->tick+=8;break;
					case CRC_IYH:case CRC_HY:case CRC_YH:___output(ae,0xFD);___output(ae,0x54);ae->nop+=2;ae->tick+=8;break;
					case CRC_IYL:case CRC_LY:case CRC_YL:___output(ae,0xFD);___output(ae,0x55);ae->nop+=2;ae->tick+=8;break;
					case CRC_MHL:___output(ae,0x56);ae->nop+=2;ae->tick+=7;break;
					case CRC_A:___output(ae,0x57);ae->nop+=1;ae->tick+=4;break;
					default:
					/* (ix+expression) (iy+expression) expression */
					if (strncmp(ae->wl[ae->idx+2].w,"(IX",3)==0) {
						___output(ae,0xDD);___output(ae,0x56);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						ae->nop+=5;ae->tick+=19;
					} else if (strncmp(ae->wl[ae->idx+2].w,"(IY",3)==0) {
						___output(ae,0xFD);___output(ae,0x56);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						ae->nop+=5;ae->tick+=19;
					} else {
						___output(ae,0x16);
						EnforceNoAddressingMode(ae->idx+2);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_V8);
						ae->nop+=2;ae->tick+=7;
					}
				}
				break;
			case CRC_E:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_B:___output(ae,0x58);ae->nop+=1;ae->tick+=4;break;
					case CRC_C:___output(ae,0x59);ae->nop+=1;ae->tick+=4;break;
					case CRC_D:___output(ae,0x5A);ae->nop+=1;ae->tick+=4;break;
					case CRC_E:___output(ae,0x5B);ae->nop+=1;ae->tick+=4;break;
					case CRC_H:___output(ae,0x5C);ae->nop+=1;ae->tick+=4;break;
					case CRC_L:___output(ae,0x5D);ae->nop+=1;ae->tick+=4;break;
					case CRC_IXH:case CRC_HX:case CRC_XH:___output(ae,0xDD);___output(ae,0x5C);ae->nop+=2;ae->tick+=8;break;
					case CRC_IXL:case CRC_LX:case CRC_XL:___output(ae,0xDD);___output(ae,0x5D);ae->nop+=2;ae->tick+=8;break;
					case CRC_IYH:case CRC_HY:case CRC_YH:___output(ae,0xFD);___output(ae,0x5C);ae->nop+=2;ae->tick+=8;break;
					case CRC_IYL:case CRC_LY:case CRC_YL:___output(ae,0xFD);___output(ae,0x5D);ae->nop+=2;ae->tick+=8;break;
					case CRC_MHL:___output(ae,0x5E);ae->nop+=2;ae->tick+=7;break;
					case CRC_A:___output(ae,0x5F);ae->nop+=1;ae->tick+=4;break;
					default:
					/* (ix+expression) (iy+expression) expression */
					if (strncmp(ae->wl[ae->idx+2].w,"(IX",3)==0) {
						___output(ae,0xDD);___output(ae,0x5E);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						ae->nop+=5;ae->tick+=19;
					} else if (strncmp(ae->wl[ae->idx+2].w,"(IY",3)==0) {
						___output(ae,0xFD);___output(ae,0x5E);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						ae->nop+=5;ae->tick+=19;
					} else {
						___output(ae,0x1E);
						EnforceNoAddressingMode(ae->idx+2);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_V8);
						ae->nop+=2;ae->tick+=7;
					}
				}
				break;
			case CRC_IYH:case CRC_HY:case CRC_YH:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_B:___output(ae,0xFD);___output(ae,0x60);ae->nop+=2;ae->tick+=8;break;
					case CRC_C:___output(ae,0xFD);___output(ae,0x61);ae->nop+=2;ae->tick+=8;break;
					case CRC_D:___output(ae,0xFD);___output(ae,0x62);ae->nop+=2;ae->tick+=8;break;
					case CRC_E:___output(ae,0xFD);___output(ae,0x63);ae->nop+=2;ae->tick+=8;break;
					case CRC_IYH:case CRC_HY:case CRC_YH:___output(ae,0xFD);___output(ae,0x64);ae->nop+=2;ae->tick+=8;break;
					case CRC_IYL:case CRC_LY:case CRC_YL:___output(ae,0xFD);___output(ae,0x65);ae->nop+=2;ae->tick+=8;break;
					case CRC_A:___output(ae,0xFD);___output(ae,0x67);ae->nop+=2;ae->tick+=8;break;
					default:
						if (strncmp(ae->wl[ae->idx+2].w,"(IX",3) && strncmp(ae->wl[ae->idx+2].w,"(IY",3)) {
							___output(ae,0xFD);___output(ae,0x26);
							EnforceNoAddressingMode(ae->idx+2);
							PushExpression(ae,ae->idx+2,E_EXPRESSION_V8);
							ae->nop+=3;ae->tick+=11;
						} else {
							MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"LD iyh,n/r only\n");
						}
				}
				break;
			case CRC_IYL:case CRC_LY:case CRC_YL:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_B:___output(ae,0xFD);___output(ae,0x68);ae->nop+=2;ae->tick+=8;break;
					case CRC_C:___output(ae,0xFD);___output(ae,0x69);ae->nop+=2;ae->tick+=8;break;
					case CRC_D:___output(ae,0xFD);___output(ae,0x6A);ae->nop+=2;ae->tick+=8;break;
					case CRC_E:___output(ae,0xFD);___output(ae,0x6B);ae->nop+=2;ae->tick+=8;break;
					case CRC_IYH:case CRC_HY:case CRC_YH:___output(ae,0xFD);___output(ae,0x6C);ae->nop+=2;ae->tick+=8;break;
					case CRC_IYL:case CRC_LY:case CRC_YL:___output(ae,0xFD);___output(ae,0x6D);ae->nop+=2;ae->tick+=8;break;
					case CRC_A:___output(ae,0xFD);___output(ae,0x6F);ae->nop+=2;ae->tick+=8;break;
					default:
						if (strncmp(ae->wl[ae->idx+2].w,"(IX",3) && strncmp(ae->wl[ae->idx+2].w,"(IY",3)) {
							___output(ae,0xFD);___output(ae,0x2E);
							EnforceNoAddressingMode(ae->idx+2);
							PushExpression(ae,ae->idx+2,E_EXPRESSION_V8);
							ae->nop+=3;ae->tick+=11;
						} else {
							MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"LD iyl,n/r only\n");
						}
				}
				break;
			case CRC_IXH:case CRC_HX:case CRC_XH:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_B:___output(ae,0xDD);___output(ae,0x60);ae->nop+=2;ae->tick+=8;break;
					case CRC_C:___output(ae,0xDD);___output(ae,0x61);ae->nop+=2;ae->tick+=8;break;
					case CRC_D:___output(ae,0xDD);___output(ae,0x62);ae->nop+=2;ae->tick+=8;break;
					case CRC_E:___output(ae,0xDD);___output(ae,0x63);ae->nop+=2;ae->tick+=8;break;
					case CRC_IXH:case CRC_HX:case CRC_XH:___output(ae,0xDD);___output(ae,0x64);ae->nop+=2;ae->tick+=8;break;
					case CRC_IXL:case CRC_LX:case CRC_XL:___output(ae,0xDD);___output(ae,0x65);ae->nop+=2;ae->tick+=8;break;
					case CRC_A:___output(ae,0xDD);___output(ae,0x67);ae->nop+=2;ae->tick+=8;break;
					default:
						if (strncmp(ae->wl[ae->idx+2].w,"(IX",3) && strncmp(ae->wl[ae->idx+2].w,"(IY",3)) {
							___output(ae,0xDD);___output(ae,0x26);
							EnforceNoAddressingMode(ae->idx+2);
							PushExpression(ae,ae->idx+2,E_EXPRESSION_V8);
							ae->nop+=3;ae->tick+=11;
						} else {
							MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"LD ixh,n/r only\n");
						}
				}
				break;
			case CRC_IXL:case CRC_LX:case CRC_XL:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_B:___output(ae,0xDD);___output(ae,0x68);ae->nop+=2;ae->tick+=8;break;
					case CRC_C:___output(ae,0xDD);___output(ae,0x69);ae->nop+=2;ae->tick+=8;break;
					case CRC_D:___output(ae,0xDD);___output(ae,0x6A);ae->nop+=2;ae->tick+=8;break;
					case CRC_E:___output(ae,0xDD);___output(ae,0x6B);ae->nop+=2;ae->tick+=8;break;
					case CRC_IXH:case CRC_HX:case CRC_XH:___output(ae,0xDD);___output(ae,0x6C);ae->nop+=2;ae->tick+=8;break;
					case CRC_IXL:case CRC_LX:case CRC_XL:___output(ae,0xDD);___output(ae,0x6D);ae->nop+=2;ae->tick+=8;break;
					case CRC_A:___output(ae,0xDD);___output(ae,0x6F);ae->nop+=2;ae->tick+=8;break;
					default:
						if (strncmp(ae->wl[ae->idx+2].w,"(IX",3) && strncmp(ae->wl[ae->idx+2].w,"(IY",3)) {
							___output(ae,0xDD);___output(ae,0x2E);
							EnforceNoAddressingMode(ae->idx+2);
							PushExpression(ae,ae->idx+2,E_EXPRESSION_V8);
							ae->nop+=3;ae->tick+=11;
						} else {
							MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"LD ixl,n/r only\n");
						}
				}
				break;
			case CRC_H:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_B:___output(ae,0x60);ae->nop+=1;ae->tick+=4;break;
					case CRC_C:___output(ae,0x61);ae->nop+=1;ae->tick+=4;break;
					case CRC_D:___output(ae,0x62);ae->nop+=1;ae->tick+=4;break;
					case CRC_E:___output(ae,0x63);ae->nop+=1;ae->tick+=4;break;
					case CRC_H:___output(ae,0x64);ae->nop+=1;ae->tick+=4;break;
					case CRC_L:___output(ae,0x65);ae->nop+=1;ae->tick+=4;break;
					case CRC_MHL:___output(ae,0x66);ae->nop+=2;ae->tick+=7;break;
					case CRC_A:___output(ae,0x67);ae->nop+=1;ae->tick+=4;break;
					default:
					/* (ix+expression) (iy+expression) expression */
					if (strncmp(ae->wl[ae->idx+2].w,"(IX",3)==0) {
						___output(ae,0xDD);___output(ae,0x66);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						ae->nop+=5;ae->tick+=19;
					} else if (strncmp(ae->wl[ae->idx+2].w,"(IY",3)==0) {
						___output(ae,0xFD);___output(ae,0x66);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						ae->nop+=5;ae->tick+=19;
					} else {
						___output(ae,0x26);
						EnforceNoAddressingMode(ae->idx+2);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_V8);
						ae->nop+=2;ae->tick+=7;
					}
				}
				break;
			case CRC_L:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_B:___output(ae,0x68);ae->nop+=1;ae->tick+=4;break;
					case CRC_C:___output(ae,0x69);ae->nop+=1;ae->tick+=4;break;
					case CRC_D:___output(ae,0x6A);ae->nop+=1;ae->tick+=4;break;
					case CRC_E:___output(ae,0x6B);ae->nop+=1;ae->tick+=4;break;
					case CRC_H:___output(ae,0x6C);ae->nop+=1;ae->tick+=4;break;
					case CRC_L:___output(ae,0x6D);ae->nop+=1;ae->tick+=4;break;
					case CRC_MHL:___output(ae,0x6E);ae->nop+=2;ae->tick+=7;break;
					case CRC_A:___output(ae,0x6F);ae->nop+=1;ae->tick+=4;break;
					default:
					/* (ix+expression) (iy+expression) expression */
					if (strncmp(ae->wl[ae->idx+2].w,"(IX",3)==0) {
						___output(ae,0xDD);___output(ae,0x6E);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						ae->nop+=5;ae->tick+=19;
					} else if (strncmp(ae->wl[ae->idx+2].w,"(IY",3)==0) {
						___output(ae,0xFD);___output(ae,0x6E);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						ae->nop+=5;ae->tick+=19;
					} else {
						___output(ae,0x2E);
						EnforceNoAddressingMode(ae->idx+2);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_V8);
						ae->nop+=2;ae->tick+=7;
					}
				}
				break;
			case CRC_MHL:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_B:___output(ae,0x70);ae->nop+=2;ae->tick+=7;break;
					case CRC_C:___output(ae,0x71);ae->nop+=2;ae->tick+=7;break;
					case CRC_D:___output(ae,0x72);ae->nop+=2;ae->tick+=7;break;
					case CRC_E:___output(ae,0x73);ae->nop+=2;ae->tick+=7;break;
					case CRC_H:___output(ae,0x74);ae->nop+=2;ae->tick+=7;break;
					case CRC_L:___output(ae,0x75);ae->nop+=2;ae->tick+=7;break;
					case CRC_A:___output(ae,0x77);ae->nop+=2;ae->tick+=7;break;
					default:
					/* expression */
					if (!StringIsMem(ae->wl[ae->idx+2].w)) {
						___output(ae,0x36);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_V8);
						ae->nop+=3;ae->tick+=10;
					} else {
						MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"LD (HL),n/r only\n");
					}
				}
				break;
			case CRC_MBC:
				if (GetCRC(ae->wl[ae->idx+2].w)==CRC_A)  {
					___output(ae,0x02);
					ae->nop+=2;ae->tick+=7;
				} else {
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"LD (BC),A only\n");
				}
				break;
			case CRC_MDE:
				if (GetCRC(ae->wl[ae->idx+2].w)==CRC_A)  {
					___output(ae,0x12);
					ae->nop+=2;ae->tick+=7;
				} else {
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"LD (DE),A only\n");
				}
				break;
			case CRC_HL:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_BC:___output(ae,0x60);___output(ae,0x69);ae->nop+=2;ae->tick+=8;break;
					case CRC_DE:___output(ae,0x62);___output(ae,0x6B);ae->nop+=2;ae->tick+=8;break;
					case CRC_HL:___output(ae,0x64);___output(ae,0x6D);ae->nop+=2;ae->tick+=8;break;
					case CRC_SP:___output(ae,0x21);___output(ae,0x00);___output(ae,0x00); // LD HL,0
						    ___output(ae,0x39);                                       // ADD HL,SP
						    ae->nop+=6;ae->tick+=21;break;
					default:
					if (strncmp(ae->wl[ae->idx+2].w,"(IX",3)==0 && (ae->wl[ae->idx+2].w[3]=='+' || ae->wl[ae->idx+2].w[3]=='-')) {
						/* enhanced LD HL,(IX+nn) */
						___output(ae,0xDD);___output(ae,0x66);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV81);
						___output(ae,0xDD);___output(ae,0x6E);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						ae->nop+=10;ae->tick+=19;ae->tick+=19;
					} else if (strncmp(ae->wl[ae->idx+2].w,"(IY",3)==0 && (ae->wl[ae->idx+2].w[3]=='+' || ae->wl[ae->idx+2].w[3]=='-')) {
						/* enhanced LD HL,(IY+nn) */
						___output(ae,0xFD);___output(ae,0x66);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV81);
						___output(ae,0xFD);___output(ae,0x6E);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						ae->nop+=10;ae->tick+=19;ae->tick+=19;
					} else if (StringIsMem(ae->wl[ae->idx+2].w)) {
						___output(ae,0x2A);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_V16);
						ae->nop+=5;ae->tick+=16;
					} else {
						___output(ae,0x21);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_V16);
						ae->nop+=3;ae->tick+=10;
					}
				}
				break;
			case CRC_BC:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_BC:___output(ae,0x40);___output(ae,0x49);ae->nop+=2;ae->tick+=8;break;
					case CRC_DE:___output(ae,0x42);___output(ae,0x4B);ae->nop+=2;ae->tick+=8;break;
					case CRC_HL:___output(ae,0x44);___output(ae,0x4D);ae->nop+=2;ae->tick+=8;break;
					/* enhanced LD BC,IX / LD BC,IY */
					case CRC_IX:___output(ae,0xDD);___output(ae,0x44);ae->nop+=4;
						    ___output(ae,0xDD);___output(ae,0x4D);ae->tick+=16;break;
					case CRC_IY:___output(ae,0xFD);___output(ae,0x44);ae->nop+=4;
						    ___output(ae,0xFD);___output(ae,0x4D);ae->tick+=16;break;
					default:
					if (strncmp(ae->wl[ae->idx+2].w,"(IX",3)==0 && (ae->wl[ae->idx+2].w[3]=='+' || ae->wl[ae->idx+2].w[3]=='-')) {
						/* enhanced LD BC,(IX+nn) */
						___output(ae,0xDD);___output(ae,0x46);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV81);
						___output(ae,0xDD);___output(ae,0x4E);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						ae->nop+=10;ae->tick+=19;ae->tick+=19;
					} else if (strncmp(ae->wl[ae->idx+2].w,"(IY",3)==0 && (ae->wl[ae->idx+2].w[3]=='+' || ae->wl[ae->idx+2].w[3]=='-')) {
						/* enhanced LD BC,(IY+nn) */
						___output(ae,0xFD);___output(ae,0x46);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV81);
						___output(ae,0xFD);___output(ae,0x4E);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						ae->nop+=10;ae->tick+=19;ae->tick+=19;
					} else if (StringIsMem(ae->wl[ae->idx+2].w)) {
						___output(ae,0xED);___output(ae,0x4B);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV16);
						ae->nop+=6;ae->tick+=20;
					} else {
						___output(ae,0x01);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_V16);
						ae->nop+=3;ae->tick+=10;
					}
				}
				break;
			case CRC_DE:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_BC:___output(ae,0x50);___output(ae,0x59);ae->nop+=2;ae->tick+=8;break;
					case CRC_DE:___output(ae,0x52);___output(ae,0x5B);ae->nop+=2;ae->tick+=8;break;
					case CRC_HL:___output(ae,0x54);___output(ae,0x5D);ae->nop+=2;ae->tick+=8;break;
					/* enhanced LD DE,IX / LD DE,IY */
					case CRC_IX:___output(ae,0xDD);___output(ae,0x54);ae->nop+=4;
						    ___output(ae,0xDD);___output(ae,0x5D);ae->tick+=16;break;
					case CRC_IY:___output(ae,0xFD);___output(ae,0x54);ae->nop+=4;
						    ___output(ae,0xFD);___output(ae,0x5D);ae->tick+=16;break;
					default:
					if (strncmp(ae->wl[ae->idx+2].w,"(IX",3)==0 && (ae->wl[ae->idx+2].w[3]=='+' || ae->wl[ae->idx+2].w[3]=='-')) {
						/* enhanced LD DE,(IX+nn) */
						___output(ae,0xDD);___output(ae,0x56);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV81);
						___output(ae,0xDD);___output(ae,0x5E);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						ae->nop+=10;ae->tick+=19;ae->tick+=19;
					} else if (strncmp(ae->wl[ae->idx+2].w,"(IY",3)==0 && (ae->wl[ae->idx+2].w[3]=='+' || ae->wl[ae->idx+2].w[3]=='-')) {
						/* enhanced LD DE,(IY+nn) */
						___output(ae,0xFD);___output(ae,0x56);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV81);
						___output(ae,0xFD);___output(ae,0x5E);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						ae->nop+=10;ae->tick+=19;ae->tick+=19;
					} else if (StringIsMem(ae->wl[ae->idx+2].w)) {
						___output(ae,0xED);___output(ae,0x5B);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV16);
						ae->nop+=6;ae->tick+=20;
					} else {
						___output(ae,0x11);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_V16);
						ae->nop+=3;ae->tick+=10;
					}
				}
				break;
			case CRC_IX:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					/* enhanced LD IX,BC / LD IX,DE */
					case CRC_BC:___output(ae,0xDD);___output(ae,0x60);
						    ___output(ae,0xDD);___output(ae,0x69);ae->nop+=4;ae->tick+=16;break;
					case CRC_DE:___output(ae,0xDD);___output(ae,0x62);
						    ___output(ae,0xDD);___output(ae,0x6B);ae->nop+=4;ae->tick+=16;break;
					default:
						if (strncmp(ae->wl[ae->idx+2].w,"(IX",3) && strncmp(ae->wl[ae->idx+2].w,"(IY",3)) {
							if (StringIsMem(ae->wl[ae->idx+2].w)) {
								___output(ae,0xDD);___output(ae,0x2A);
								PushExpression(ae,ae->idx+2,E_EXPRESSION_IV16);
								ae->nop+=6;ae->tick+=20;
							} else {
								___output(ae,0xDD);___output(ae,0x21);
								PushExpression(ae,ae->idx+2,E_EXPRESSION_IV16);
								ae->nop+=4;ae->tick+=14;
							}
						} else {
							MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"LD IX,(nn)/BC/DE/nn only\n");
						}
				}
				break;
			case CRC_IY:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					/* enhanced LD IY,BC / LD IY,DE */
					case CRC_BC:___output(ae,0xFD);___output(ae,0x60);
						    ___output(ae,0xFD);___output(ae,0x69);ae->nop+=4;ae->tick+=16;break;
					case CRC_DE:___output(ae,0xFD);___output(ae,0x62);
						    ___output(ae,0xFD);___output(ae,0x6B);ae->nop+=4;ae->tick+=16;break;
					default:
						if (strncmp(ae->wl[ae->idx+2].w,"(IX",3) && strncmp(ae->wl[ae->idx+2].w,"(IY",3)) {
							if (StringIsMem(ae->wl[ae->idx+2].w)) {
								___output(ae,0xFD);___output(ae,0x2A);
								PushExpression(ae,ae->idx+2,E_EXPRESSION_IV16);
								ae->nop+=6;ae->tick+=20;
							} else {
								___output(ae,0xFD);___output(ae,0x21);
								PushExpression(ae,ae->idx+2,E_EXPRESSION_IV16);
								ae->nop+=4;ae->tick+=14;
							}
						} else {
							MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"LD IY,(nn)/BC/DE/nn only\n");
						}
				}
				break;
			case CRC_SP:
				switch (GetCRC(ae->wl[ae->idx+2].w)) {
					case CRC_HL:___output(ae,0xF9);ae->nop+=2;ae->tick+=6;break;
					case CRC_IX:___output(ae,0xDD);___output(ae,0xF9);ae->nop+=3;ae->tick+=10;break;
					case CRC_IY:___output(ae,0xFD);___output(ae,0xF9);ae->nop+=3;ae->tick+=10;break;
					default:
						if (strncmp(ae->wl[ae->idx+2].w,"(IX",3) && strncmp(ae->wl[ae->idx+2].w,"(IY",3)) {
							if (StringIsMem(ae->wl[ae->idx+2].w)) {
								___output(ae,0xED);___output(ae,0x7B);
								PushExpression(ae,ae->idx+2,E_EXPRESSION_IV16);
								ae->nop+=6;ae->tick+=20;
							} else {
								___output(ae,0x31);
								PushExpression(ae,ae->idx+2,E_EXPRESSION_V16);
								ae->nop+=3;ae->tick+=10;
							}
						} else {
							MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"LD SP,(nn)/HL/IX/IY only\n");
						}
				}
				break;
			default:
				/* (ix+expression) (iy+expression) (expression) expression */
				if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
					switch (GetCRC(ae->wl[ae->idx+2].w)) {
						case CRC_B:___output(ae,0xDD);___output(ae,0x70);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);ae->nop+=5;ae->tick+=19;break;
						case CRC_C:___output(ae,0xDD);___output(ae,0x71);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);ae->nop+=5;ae->tick+=19;break;
						case CRC_D:___output(ae,0xDD);___output(ae,0x72);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);ae->nop+=5;ae->tick+=19;break;
						case CRC_E:___output(ae,0xDD);___output(ae,0x73);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);ae->nop+=5;ae->tick+=19;break;
						case CRC_H:___output(ae,0xDD);___output(ae,0x74);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);ae->nop+=5;ae->tick+=19;break;
						case CRC_L:___output(ae,0xDD);___output(ae,0x75);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);ae->nop+=5;ae->tick+=19;break;
						case CRC_A:___output(ae,0xDD);___output(ae,0x77);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);ae->nop+=5;ae->tick+=19;break;
						case CRC_HL:___output(ae,0xDD);___output(ae,0x74);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV81);___output(ae,0xDD);___output(ae,0x75);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);ae->nop+=10;ae->tick+=38;break;
						case CRC_DE:___output(ae,0xDD);___output(ae,0x72);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV81);___output(ae,0xDD);___output(ae,0x73);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);ae->nop+=10;ae->tick+=38;break;
						case CRC_BC:___output(ae,0xDD);___output(ae,0x70);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV81);___output(ae,0xDD);___output(ae,0x71);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);ae->nop+=10;ae->tick+=38;break;
						default:
							if (!StringIsMem(ae->wl[ae->idx+2].w)) {
								___output(ae,0xDD);___output(ae,0x36);
								PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
								PushExpression(ae,ae->idx+2,E_EXPRESSION_3V8);
								ae->nop+=6;ae->tick+=23;
							} else {
								MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"LD (IX+n),n/r only\n");
							}
					}
				} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
					switch (GetCRC(ae->wl[ae->idx+2].w)) {
						case CRC_B:___output(ae,0xFD);___output(ae,0x70);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);ae->nop+=5;ae->tick+=19;break;
						case CRC_C:___output(ae,0xFD);___output(ae,0x71);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);ae->nop+=5;ae->tick+=19;break;
						case CRC_D:___output(ae,0xFD);___output(ae,0x72);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);ae->nop+=5;ae->tick+=19;break;
						case CRC_E:___output(ae,0xFD);___output(ae,0x73);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);ae->nop+=5;ae->tick+=19;break;
						case CRC_H:___output(ae,0xFD);___output(ae,0x74);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);ae->nop+=5;ae->tick+=19;break;
						case CRC_L:___output(ae,0xFD);___output(ae,0x75);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);ae->nop+=5;ae->tick+=19;break;
						case CRC_A:___output(ae,0xFD);___output(ae,0x77);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);ae->nop+=5;ae->tick+=19;break;
						case CRC_HL:___output(ae,0xFD);___output(ae,0x74);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV81);___output(ae,0xFD);___output(ae,0x75);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);ae->nop+=10;ae->tick+=38;break;
						case CRC_DE:___output(ae,0xFD);___output(ae,0x72);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV81);___output(ae,0xFD);___output(ae,0x73);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);ae->nop+=10;ae->tick+=38;break;
						case CRC_BC:___output(ae,0xFD);___output(ae,0x70);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV81);___output(ae,0xFD);___output(ae,0x71);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);ae->nop+=10;ae->tick+=38;break;
						default:
							if (!StringIsMem(ae->wl[ae->idx+2].w)) {
							    ___output(ae,0xFD);___output(ae,0x36);
								PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
								PushExpression(ae,ae->idx+2,E_EXPRESSION_3V8);
								ae->nop+=6;ae->tick+=23;
							} else {
								MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"LD (IX+n),n/r only\n");
							}
					}
				} else if (StringIsMem(ae->wl[ae->idx+1].w)) {
					switch (GetCRC(ae->wl[ae->idx+2].w)) {
						case CRC_A:___output(ae,0x32);PushExpression(ae,ae->idx+1,E_EXPRESSION_V16);ae->nop+=4;ae->tick+=13;break;
						case CRC_BC:___output(ae,0xED);___output(ae,0x43);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV16);ae->nop+=6;ae->tick+=20;break;
						case CRC_DE:___output(ae,0xED);___output(ae,0x53);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV16);ae->nop+=6;ae->tick+=20;break;
						case CRC_HL:___output(ae,0x22);PushExpression(ae,ae->idx+1,E_EXPRESSION_V16);ae->nop+=5;ae->tick+=16;break;
						case CRC_IX:___output(ae,0xDD);___output(ae,0x22);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV16);ae->nop+=6;ae->tick+=20;break;
						case CRC_IY:___output(ae,0xFD);___output(ae,0x22);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV16);ae->nop+=6;ae->tick+=20;break;
						case CRC_SP:___output(ae,0xED);___output(ae,0x73);PushExpression(ae,ae->idx+1,E_EXPRESSION_IV16);ae->nop+=6;ae->tick+=20;break;
						default:
							MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"LD (#nnnn),[A,BC,DE,HL,SP,IX,IY] only\n");
					}
				} else {
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Unknown LD format\n");
				}
				break;
		}
		ae->idx+=2;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"LD needs two parameters\n");
	}
}


void _RLC(struct s_assenv *ae) {
	/* on check qu'il y a un ou deux parametres */
	if (ae->wl[ae->idx+1].t==1) {
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_BC: // SLA B : RL C : RR B : RLC B
				   ___output(ae,0xCB);___output(ae,0x20);
				   ___output(ae,0xCB);___output(ae,0x11);
				   ___output(ae,0xCB);___output(ae,0x18);
				   ___output(ae,0xCB);___output(ae,0x00);
				    ae->nop+=8;ae->tick+=32;break;
			case CRC_B:___output(ae,0xCB);___output(ae,0x0);ae->nop+=2;ae->tick+=8;break;
			case CRC_C:___output(ae,0xCB);___output(ae,0x1);ae->nop+=2;ae->tick+=8;break;
			case CRC_DE: // SLA D : RL E : RR D : RLC D
				   ___output(ae,0xCB);___output(ae,0x22);
				   ___output(ae,0xCB);___output(ae,0x13);
				   ___output(ae,0xCB);___output(ae,0x1A);
				   ___output(ae,0xCB);___output(ae,0x02);
				    ae->nop+=8;ae->tick+=32;break;
			case CRC_D:___output(ae,0xCB);___output(ae,0x2);ae->nop+=2;ae->tick+=8;break;
			case CRC_E:___output(ae,0xCB);___output(ae,0x3);ae->nop+=2;ae->tick+=8;break;
			case CRC_H:___output(ae,0xCB);___output(ae,0x4);ae->nop+=2;ae->tick+=8;break;
			case CRC_HL: // SLA H : RL L : RR H : RLC H
				   ___output(ae,0xCB);___output(ae,0x24);
				   ___output(ae,0xCB);___output(ae,0x15);
				   ___output(ae,0xCB);___output(ae,0x1C);
				   ___output(ae,0xCB);___output(ae,0x04);
				    ae->nop+=8;ae->tick+=32;break;
			case CRC_L:___output(ae,0xCB);___output(ae,0x5);ae->nop+=2;ae->tick+=8;break;
			case CRC_MHL:___output(ae,0xCB);___output(ae,0x6);ae->nop+=4;ae->tick+=15;break;
			case CRC_A:___output(ae,0xCB);___output(ae,0x7);ae->nop+=2;ae->tick+=8;break;
			default:
				if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
					___output(ae,0xDD);___output(ae,0xCB);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					___output(ae,0x6);
					ae->nop+=7;ae->tick+=23;
				} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
					___output(ae,0xFD);___output(ae,0xCB);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					___output(ae,0x6);
					ae->nop+=7;ae->tick+=23;
				} else {
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is RLC reg8/(HL)/(IX+n)/(IY+n)\n");
				}
		}
		ae->idx++;
	} else if (!ae->wl[ae->idx+1].t && ae->wl[ae->idx+2].t!=2) {
		if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
			___output(ae,0xDD);
		} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
			___output(ae,0xFD);
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is RLC (IX+n),reg8\n");
		}
		___output(ae,0xCB);
		switch (GetCRC(ae->wl[ae->idx+2].w)) {
			case CRC_B:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x0);ae->nop+=7;ae->tick+=23;break;
			case CRC_C:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x1);ae->nop+=7;ae->tick+=23;break;
			case CRC_D:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x2);ae->nop+=7;ae->tick+=23;break;
			case CRC_E:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x3);ae->nop+=7;ae->tick+=23;break;
			case CRC_H:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x4);ae->nop+=7;ae->tick+=23;break;
			case CRC_L:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x5);ae->nop+=7;ae->tick+=23;break;
			case CRC_A:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x7);ae->nop+=7;ae->tick+=23;break;
			default:			
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is RLC (IX+n),reg8\n");
		}
		ae->idx++;
		ae->idx++;
	}
}

void _RRC(struct s_assenv *ae) {
	/* on check qu'il y a un ou deux parametres */
	if (ae->wl[ae->idx+1].t==1) {
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_BC: // SRL B : RR C : RL B : RRC B
				   ___output(ae,0xCB);___output(ae,0x38);
				   ___output(ae,0xCB);___output(ae,0x19);
				   ___output(ae,0xCB);___output(ae,0x10);
				   ___output(ae,0xCB);___output(ae,0x08);
				   ae->nop+=8;ae->tick+=32;break;
			case CRC_B:___output(ae,0xCB);___output(ae,0x8);ae->nop+=2;ae->tick+=8;break;
			case CRC_C:___output(ae,0xCB);___output(ae,0x9);ae->nop+=2;ae->tick+=8;break;
			case CRC_DE: // SRL D : RR E : RL D : RRC D
				   ___output(ae,0xCB);___output(ae,0x3A);
				   ___output(ae,0xCB);___output(ae,0x1B);
				   ___output(ae,0xCB);___output(ae,0x12);
				   ___output(ae,0xCB);___output(ae,0x0A);
				   ae->nop+=8;ae->tick+=32;break;
			case CRC_D:___output(ae,0xCB);___output(ae,0xA);ae->nop+=2;ae->tick+=8;break;
			case CRC_E:___output(ae,0xCB);___output(ae,0xB);ae->nop+=2;ae->tick+=8;break;
			case CRC_HL: // SRL H : RR L : RL H : RRC H
				   ___output(ae,0xCB);___output(ae,0x3C);
				   ___output(ae,0xCB);___output(ae,0x1D);
				   ___output(ae,0xCB);___output(ae,0x14);
				   ___output(ae,0xCB);___output(ae,0x0C);
				   ae->nop+=8;ae->tick+=32;break;
			case CRC_H:___output(ae,0xCB);___output(ae,0xC);ae->nop+=2;ae->tick+=8;break;
			case CRC_L:___output(ae,0xCB);___output(ae,0xD);ae->nop+=2;ae->tick+=8;break;
			case CRC_MHL:___output(ae,0xCB);___output(ae,0xE);ae->nop+=4;ae->tick+=15;break;
			case CRC_A:___output(ae,0xCB);___output(ae,0xF);ae->nop+=2;ae->tick+=8;break;
			default:
				if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
					___output(ae,0xDD);___output(ae,0xCB);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					___output(ae,0xE);
					ae->nop+=7;ae->tick+=23;
				} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
					___output(ae,0xFD);___output(ae,0xCB);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					___output(ae,0xE);ae->tick+=23;
					ae->nop+=7;
				} else {
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is RRC reg8/(HL)/(IX+n)/(IY+n)\n");
				}
		}
		ae->idx++;
	} else if (!ae->wl[ae->idx+1].t && ae->wl[ae->idx+2].t!=2) {
		if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
			___output(ae,0xDD);
		} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
			___output(ae,0xFD);
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is RRC (IX+n),reg8\n");
		}
		___output(ae,0xCB);
		switch (GetCRC(ae->wl[ae->idx+2].w)) {
			case CRC_B:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x8);ae->nop+=7;ae->tick+=23;break;
			case CRC_C:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x9);ae->nop+=7;ae->tick+=23;break;
			case CRC_D:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0xA);ae->nop+=7;ae->tick+=23;break;
			case CRC_E:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0xB);ae->nop+=7;ae->tick+=23;break;
			case CRC_H:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0xC);ae->nop+=7;ae->tick+=23;break;
			case CRC_L:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0xD);ae->nop+=7;ae->tick+=23;break;
			case CRC_A:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0xF);ae->nop+=7;ae->tick+=23;break;
			default:			
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is RRC (IX+n),reg8\n");
		}
		ae->idx++;
		ae->idx++;
	}
}


void _RL(struct s_assenv *ae) {
	/* on check qu'il y a un ou deux parametres */
	if (ae->wl[ae->idx+1].t==1) {
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_BC:___output(ae,0xCB);___output(ae,0x11);___output(ae,0xCB);___output(ae,0x10);ae->nop+=4;ae->tick+=16;break;
			case CRC_B:___output(ae,0xCB);___output(ae,0x10);ae->nop+=2;ae->tick+=8;break;
			case CRC_C:___output(ae,0xCB);___output(ae,0x11);ae->nop+=2;ae->tick+=8;break;
			case CRC_DE:___output(ae,0xCB);___output(ae,0x13);___output(ae,0xCB);___output(ae,0x12);ae->nop+=4;ae->tick+=16;break;
			case CRC_D:___output(ae,0xCB);___output(ae,0x12);ae->nop+=2;ae->tick+=8;break;
			case CRC_E:___output(ae,0xCB);___output(ae,0x13);ae->nop+=2;ae->tick+=8;break;
			case CRC_HL:___output(ae,0xCB);___output(ae,0x15);___output(ae,0xCB);___output(ae,0x14);ae->nop+=4;ae->tick+=16;break;
			case CRC_H:___output(ae,0xCB);___output(ae,0x14);ae->nop+=2;ae->tick+=8;break;
			case CRC_L:___output(ae,0xCB);___output(ae,0x15);ae->nop+=2;ae->tick+=8;break;
			case CRC_MHL:___output(ae,0xCB);___output(ae,0x16);ae->nop+=4;ae->tick+=15;break;
			case CRC_A:___output(ae,0xCB);___output(ae,0x17);ae->nop+=2;ae->tick+=8;break;
			default:
				if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
					___output(ae,0xDD);___output(ae,0xCB);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					___output(ae,0x16);
					ae->nop+=7;ae->tick+=23;
				} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
					___output(ae,0xFD);___output(ae,0xCB);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					___output(ae,0x16);
					ae->nop+=7;ae->tick+=23;
				} else {
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is RL reg8/(HL)/(IX+n)/(IY+n)\n");
				}
		}
		ae->idx++;
	} else if (!ae->wl[ae->idx+1].t && ae->wl[ae->idx+2].t!=2) {
		if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
			___output(ae,0xDD);
		} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
			___output(ae,0xFD);
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is RL (IX+n),reg8\n");
		}
		___output(ae,0xCB);
		switch (GetCRC(ae->wl[ae->idx+2].w)) {
			case CRC_B:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x10);ae->nop+=7;ae->tick+=23;break;
			case CRC_C:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x11);ae->nop+=7;ae->tick+=23;break;
			case CRC_D:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x12);ae->nop+=7;ae->tick+=23;break;
			case CRC_E:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x13);ae->nop+=7;ae->tick+=23;break;
			case CRC_H:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x14);ae->nop+=7;ae->tick+=23;break;
			case CRC_L:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x15);ae->nop+=7;ae->tick+=23;break;
			case CRC_A:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x17);ae->nop+=7;ae->tick+=23;break;
			default:			
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is RL (IX+n),reg8\n");
		}
		ae->idx++;
		ae->idx++;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is RL (IX+n),reg8 or RL reg8/(HL)/(IX+n)/(IY+n)\n");
	}
}

void _RR(struct s_assenv *ae) {
	/* on check qu'il y a un ou deux parametres */
	if (ae->wl[ae->idx+1].t==1) {
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_BC:___output(ae,0xCB);___output(ae,0x18);___output(ae,0xCB);___output(ae,0x19);ae->nop+=4;ae->tick+=16;break;
			case CRC_B:___output(ae,0xCB);___output(ae,0x18);ae->nop+=2;ae->tick+=8;break;
			case CRC_C:___output(ae,0xCB);___output(ae,0x19);ae->nop+=2;ae->tick+=8;break;
			case CRC_DE:___output(ae,0xCB);___output(ae,0x1A);___output(ae,0xCB);___output(ae,0x1B);ae->nop+=4;ae->tick+=16;break;
			case CRC_D:___output(ae,0xCB);___output(ae,0x1A);ae->nop+=2;ae->tick+=8;break;
			case CRC_E:___output(ae,0xCB);___output(ae,0x1B);ae->nop+=2;ae->tick+=8;break;
			case CRC_HL:___output(ae,0xCB);___output(ae,0x1C);___output(ae,0xCB);___output(ae,0x1D);ae->nop+=4;ae->tick+=16;break;
			case CRC_H:___output(ae,0xCB);___output(ae,0x1C);ae->nop+=2;ae->tick+=8;break;
			case CRC_L:___output(ae,0xCB);___output(ae,0x1D);ae->nop+=2;ae->tick+=8;break;
			case CRC_MHL:___output(ae,0xCB);___output(ae,0x1E);ae->nop+=4;ae->tick+=15;break;
			case CRC_A:___output(ae,0xCB);___output(ae,0x1F);ae->nop+=2;ae->tick+=8;break;
			default:
				if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
					___output(ae,0xDD);___output(ae,0xCB);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					___output(ae,0x1E);
					ae->nop+=7;ae->tick+=23;
				} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
					___output(ae,0xFD);___output(ae,0xCB);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					___output(ae,0x1E);
					ae->nop+=7;ae->tick+=23;
				} else {
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is RR reg8/(HL)/(IX+n)/(IY+n)\n");
				}
		}
		ae->idx++;
	} else if (!ae->wl[ae->idx+1].t && ae->wl[ae->idx+2].t!=2) {
		if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
			___output(ae,0xDD);
		} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
			___output(ae,0xFD);
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is RR (IX+n),reg8\n");
		}
		___output(ae,0xCB);
		switch (GetCRC(ae->wl[ae->idx+2].w)) {
			case CRC_B:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x18);ae->nop+=7;ae->tick+=23;break;
			case CRC_C:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x19);ae->nop+=7;ae->tick+=23;break;
			case CRC_D:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x1A);ae->nop+=7;ae->tick+=23;break;
			case CRC_E:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x1B);ae->nop+=7;ae->tick+=23;break;
			case CRC_H:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x1C);ae->nop+=7;ae->tick+=23;break;
			case CRC_L:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x1D);ae->nop+=7;ae->tick+=23;break;
			case CRC_A:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x1F);ae->nop+=7;ae->tick+=23;break;
			default:			
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is RR (IX+n),reg8\n");
		}
		ae->idx++;
		ae->idx++;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is RR (IX+n),reg8 or RR reg8/(HL)/(IX+n)/(IY+n)\n");
	}
}

void _SLA(struct s_assenv *ae) {
	/* on check qu'il y a un ou deux parametres */
	if (ae->wl[ae->idx+1].t==1) {
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_BC:___output(ae,0xCB);___output(ae,0x21);___output(ae,0xCB);___output(ae,0x10);ae->nop+=4;ae->tick+=16;break; /* SLA C : RL B */
			case CRC_B:___output(ae,0xCB);___output(ae,0x20);ae->nop+=2;ae->tick+=8;break;
			case CRC_C:___output(ae,0xCB);___output(ae,0x21);ae->nop+=2;ae->tick+=8;break;
			case CRC_DE:___output(ae,0xCB);___output(ae,0x23);___output(ae,0xCB);___output(ae,0x12);ae->nop+=4;ae->tick+=16;break; /* SLA E : RL D */
			case CRC_D:___output(ae,0xCB);___output(ae,0x22);ae->nop+=2;ae->tick+=8;break;
			case CRC_E:___output(ae,0xCB);___output(ae,0x23);ae->nop+=2;ae->tick+=8;break;
			case CRC_HL:___output(ae,0xCB);___output(ae,0x25);___output(ae,0xCB);___output(ae,0x14);ae->nop+=4;ae->tick+=16;break; /* SLA L : RL H */
			case CRC_H:___output(ae,0xCB);___output(ae,0x24);ae->nop+=2;ae->tick+=8;break;
			case CRC_L:___output(ae,0xCB);___output(ae,0x25);ae->nop+=2;ae->tick+=8;break;
			case CRC_MHL:___output(ae,0xCB);___output(ae,0x26);ae->nop+=4;ae->tick+=15;break;
			case CRC_A:___output(ae,0xCB);___output(ae,0x27);ae->nop+=2;ae->tick+=8;break;
			default:
				if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
					___output(ae,0xDD);___output(ae,0xCB);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					___output(ae,0x26);
					ae->nop+=7;ae->tick+=23;
				} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
					___output(ae,0xFD);___output(ae,0xCB);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					___output(ae,0x26);
					ae->nop+=7;ae->tick+=23;
				} else {
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SLA reg8/(HL)/(IX+n)/(IY+n)\n");
				}
		}
		ae->idx++;
	} else if (!ae->wl[ae->idx+1].t && ae->wl[ae->idx+2].t!=2) {
		if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
			___output(ae,0xDD);
		} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
			___output(ae,0xFD);
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SLA (IX+n),reg8\n");
		}
		___output(ae,0xCB);
		switch (GetCRC(ae->wl[ae->idx+2].w)) {
			case CRC_B:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x20);ae->nop+=7;ae->tick+=23;break;
			case CRC_C:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x21);ae->nop+=7;ae->tick+=23;break;
			case CRC_D:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x22);ae->nop+=7;ae->tick+=23;break;
			case CRC_E:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x23);ae->nop+=7;ae->tick+=23;break;
			case CRC_H:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x24);ae->nop+=7;ae->tick+=23;break;
			case CRC_L:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x25);ae->nop+=7;ae->tick+=23;break;
			case CRC_A:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x27);ae->nop+=7;ae->tick+=23;break;
			default:			
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SLA (IX+n),reg8\n");
		}
		ae->idx++;
		ae->idx++;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SLA reg8/(HL)/(IX+n)/(IY+n) or SLA (IX+n),reg8\n");
	}
}

void _SRA(struct s_assenv *ae) {
	/* on check qu'il y a un ou deux parametres */
	if (ae->wl[ae->idx+1].t==1) {
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_BC:___output(ae,0xCB);___output(ae,0x28);___output(ae,0xCB);___output(ae,0x19);ae->nop+=4;ae->tick+=16;break; /* SRA B : RR C */
			case CRC_B:___output(ae,0xCB);___output(ae,0x28);ae->nop+=2;ae->tick+=8;break;
			case CRC_C:___output(ae,0xCB);___output(ae,0x29);ae->nop+=2;ae->tick+=8;break;
			case CRC_DE:___output(ae,0xCB);___output(ae,0x2A);___output(ae,0xCB);___output(ae,0x1B);ae->nop+=4;ae->tick+=16;break; /* SRA D : RR E */
			case CRC_D:___output(ae,0xCB);___output(ae,0x2A);ae->nop+=2;ae->tick+=8;break;
			case CRC_E:___output(ae,0xCB);___output(ae,0x2B);ae->nop+=2;ae->tick+=8;break;
			case CRC_HL:___output(ae,0xCB);___output(ae,0x2C);___output(ae,0xCB);___output(ae,0x1D);ae->nop+=4;ae->tick+=16;break; /* SRA H : RR L */
			case CRC_H:___output(ae,0xCB);___output(ae,0x2C);ae->nop+=2;ae->tick+=8;break;
			case CRC_L:___output(ae,0xCB);___output(ae,0x2D);ae->nop+=2;ae->tick+=8;break;
			case CRC_MHL:___output(ae,0xCB);___output(ae,0x2E);ae->nop+=4;ae->tick+=15;break;
			case CRC_A:___output(ae,0xCB);___output(ae,0x2F);ae->nop+=2;ae->tick+=8;break;
			default:
				if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
					___output(ae,0xDD);___output(ae,0xCB);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					___output(ae,0x2E);
					ae->nop+=7;ae->tick+=23;
				} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
					___output(ae,0xFD);___output(ae,0xCB);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					___output(ae,0x2E);
					ae->nop+=7;ae->tick+=23;
				} else {
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SRA reg8/(HL)/(IX+n)/(IY+n)\n");
				}
		}
		ae->idx++;
	} else if (!ae->wl[ae->idx+1].t && ae->wl[ae->idx+2].t!=2) {
		if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
			___output(ae,0xDD);
		} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
			___output(ae,0xFD);
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SRA (IX+n),reg8\n");
		}
		___output(ae,0xCB);
		switch (GetCRC(ae->wl[ae->idx+2].w)) {
			case CRC_B:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x28);ae->nop+=7;ae->tick+=23;break;
			case CRC_C:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x29);ae->nop+=7;ae->tick+=23;break;
			case CRC_D:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x2A);ae->nop+=7;ae->tick+=23;break;
			case CRC_E:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x2B);ae->nop+=7;ae->tick+=23;break;
			case CRC_H:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x2C);ae->nop+=7;ae->tick+=23;break;
			case CRC_L:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x2D);ae->nop+=7;ae->tick+=23;break;
			case CRC_A:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x2F);ae->nop+=7;ae->tick+=23;break;
			default:			
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SRA (IX+n),reg8\n");
		}
		ae->idx++;
		ae->idx++;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SRA reg8/(HL)/(IX+n)/(IY+n) or SRA (IX+n),reg8\n");
	}
}


void _SLL(struct s_assenv *ae) {
	/* on check qu'il y a un ou deux parametres */
	if (ae->wl[ae->idx+1].t==1) {
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_BC:___output(ae,0xCB);___output(ae,0x31);___output(ae,0xCB);___output(ae,0x10);ae->nop+=4;ae->tick+=16;break; /* SLL C : RL B */
			case CRC_B:___output(ae,0xCB);___output(ae,0x30);ae->nop+=2;ae->tick+=8;break;
			case CRC_C:___output(ae,0xCB);___output(ae,0x31);ae->nop+=2;ae->tick+=8;break;
			case CRC_DE:___output(ae,0xCB);___output(ae,0x33);___output(ae,0xCB);___output(ae,0x12);ae->nop+=4;ae->tick+=16;break; /* SLL E : RL D */
			case CRC_D:___output(ae,0xCB);___output(ae,0x32);ae->nop+=2;ae->tick+=8;break;
			case CRC_E:___output(ae,0xCB);___output(ae,0x33);ae->nop+=2;ae->tick+=8;break;
			case CRC_HL:___output(ae,0xCB);___output(ae,0x35);___output(ae,0xCB);___output(ae,0x14);ae->nop+=4;ae->tick+=16;break; /* SLL L : RL H */
			case CRC_H:___output(ae,0xCB);___output(ae,0x34);ae->nop+=2;ae->tick+=8;break;
			case CRC_L:___output(ae,0xCB);___output(ae,0x35);ae->nop+=2;ae->tick+=8;break;
			case CRC_MHL:___output(ae,0xCB);___output(ae,0x36);ae->nop+=4;ae->tick+=15;break;
			case CRC_A:___output(ae,0xCB);___output(ae,0x37);ae->nop+=2;ae->tick+=8;break;
			default:
				if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
					___output(ae,0xDD);___output(ae,0xCB);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					___output(ae,0x36);
					ae->nop+=7;ae->tick+=23;
				} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
					___output(ae,0xFD);___output(ae,0xCB);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					___output(ae,0x36);
					ae->nop+=7;ae->tick+=23;
				} else {
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SLL reg8/(HL)/(IX+n)/(IY+n)\n");
				}
		}
		ae->idx++;
	} else if (!ae->wl[ae->idx+1].t && ae->wl[ae->idx+2].t!=2) {
		if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
			___output(ae,0xDD);
		} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
			___output(ae,0xFD);
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SLL (IX+n),reg8\n");
		}
		___output(ae,0xCB);
		switch (GetCRC(ae->wl[ae->idx+2].w)) {
			case CRC_B:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x30);ae->nop+=7;ae->tick+=23;break;
			case CRC_C:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x31);ae->nop+=7;ae->tick+=23;break;
			case CRC_D:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x32);ae->nop+=7;ae->tick+=23;break;
			case CRC_E:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x33);ae->nop+=7;ae->tick+=23;break;
			case CRC_H:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x34);ae->nop+=7;ae->tick+=23;break;
			case CRC_L:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x35);ae->nop+=7;ae->tick+=23;break;
			case CRC_A:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x37);ae->nop+=7;ae->tick+=23;break;
			default:			
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SLL (IX+n),reg8\n");
		}
		ae->idx+=2;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SLL reg8/(HL)/(IX+n)/(IY+n) or SLL (IX+n),reg8\n");
	}
}

void _SRL8(struct s_assenv *ae) {
	/* on check qu'il y a un ou deux parametres */
	if (ae->wl[ae->idx+1].t==1) {
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_BC:___output(ae,0x48);___output(ae,0x06);___output(ae,0x00);ae->nop+=3;ae->tick+=11;break; /* LD C,B : LD B,0 */
			case CRC_DE:___output(ae,0x5A);___output(ae,0x16);___output(ae,0x00);ae->nop+=3;ae->tick+=11;break; /* LD E,D : LD D,0 */
			case CRC_HL:___output(ae,0x6C);___output(ae,0x26);___output(ae,0x00);ae->nop+=3;ae->tick+=11;break; /* LD L,H : LD H,0 */
			case CRC_IX:___output(ae,0xDD);___output(ae,0x6C);___output(ae,0xDD);___output(ae,0x26);___output(ae,0x00);ae->nop+=5;ae->tick+=19;break; /* LD XL,XH : LD XH,0 */
			case CRC_IY:___output(ae,0xFD);___output(ae,0x6C);___output(ae,0xFD);___output(ae,0x26);___output(ae,0x00);ae->nop+=5;ae->tick+=19;break; /* LD YL,YH : LD YH,0 */
			default:MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SRL8 BC/DE/HL/IX/IY\n");
		}
	}
}
void _SRL(struct s_assenv *ae) {
	/* on check qu'il y a un ou deux parametres */
	if (ae->wl[ae->idx+1].t==1) {
		switch (GetCRC(ae->wl[ae->idx+1].w)) {
			case CRC_BC:___output(ae,0xCB);___output(ae,0x38);___output(ae,0xCB);___output(ae,0x19);ae->nop+=4;ae->tick+=16;break; /* SRL B : RR C */
			case CRC_B:___output(ae,0xCB);___output(ae,0x38);ae->nop+=2;ae->tick+=8;break;
			case CRC_C:___output(ae,0xCB);___output(ae,0x39);ae->nop+=2;ae->tick+=8;break;
			case CRC_DE:___output(ae,0xCB);___output(ae,0x3A);___output(ae,0xCB);___output(ae,0x1B);ae->nop+=4;ae->tick+=16;break; /* SRL D : RR E */
			case CRC_D:___output(ae,0xCB);___output(ae,0x3A);ae->nop+=2;ae->tick+=8;break;
			case CRC_E:___output(ae,0xCB);___output(ae,0x3B);ae->nop+=2;ae->tick+=8;break;
			case CRC_HL:___output(ae,0xCB);___output(ae,0x3C);___output(ae,0xCB);___output(ae,0x1D);ae->nop+=4;ae->tick+=16;break; /* SRL H : RR L */
			case CRC_H:___output(ae,0xCB);___output(ae,0x3C);ae->nop+=2;ae->tick+=8;break;
			case CRC_L:___output(ae,0xCB);___output(ae,0x3D);ae->nop+=2;ae->tick+=8;break;
			case CRC_MHL:___output(ae,0xCB);___output(ae,0x3E);ae->nop+=4;ae->tick+=15;break;
			case CRC_A:___output(ae,0xCB);___output(ae,0x3F);ae->nop+=2;ae->tick+=8;break;
			default:
				if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
					___output(ae,0xDD);___output(ae,0xCB);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					___output(ae,0x3E);
					ae->nop+=7;ae->tick+=23;
				} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
					___output(ae,0xFD);___output(ae,0xCB);
					PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);
					___output(ae,0x3E);
					ae->nop+=7;ae->tick+=23;
				} else {
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SRL reg8/(HL)/(IX+n)/(IY+n)\n");
				}
		}
		ae->idx++;
	} else if (!ae->wl[ae->idx+1].t && ae->wl[ae->idx+2].t!=2) {
		if (strncmp(ae->wl[ae->idx+1].w,"(IX",3)==0) {
			___output(ae,0xDD);
		} else if (strncmp(ae->wl[ae->idx+1].w,"(IY",3)==0) {
			___output(ae,0xFD);
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SRL (IX+n),reg8\n");
		}
		___output(ae,0xCB);
		switch (GetCRC(ae->wl[ae->idx+2].w)) {
			case CRC_B:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x38);ae->nop+=7;ae->tick+=23;break;
			case CRC_C:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x39);ae->nop+=7;ae->tick+=23;break;
			case CRC_D:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x3A);ae->nop+=7;ae->tick+=23;break;
			case CRC_E:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x3B);ae->nop+=7;ae->tick+=23;break;
			case CRC_H:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x3C);ae->nop+=7;ae->tick+=23;break;
			case CRC_L:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x3D);ae->nop+=7;ae->tick+=23;break;
			case CRC_A:PushExpression(ae,ae->idx+1,E_EXPRESSION_IV8);___output(ae,0x3F);ae->nop+=7;ae->tick+=23;break;
			default:			
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SRL (IX+n),reg8\n");
		}
		ae->idx++;
		ae->idx++;
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SRL reg8/(HL)/(IX+n)/(IY+n) or SRL (IX+n),reg8\n");
	}
}


void _BIT(struct s_assenv *ae) {
	int o;
	/* on check qu'il y a deux ou trois parametres 
	ExpressionFastTranslate(ae,&ae->wl[ae->idx+1].w,0);
	o=RoundComputeExpressionCore(ae,ae->wl[ae->idx+1].w,ae->codeadr,0);*/

	o=0;
	if (o<0 || o>7) {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is BIT <value from 0 to 7>,... (%d)\n",o);
	} else {
		o=0x40+o*8;
		if (ae->wl[ae->idx+1].t==0 && ae->wl[ae->idx+2].t==1) {
			switch (GetCRC(ae->wl[ae->idx+2].w)) {
				case CRC_B:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x0+o);ae->nop+=2;ae->tick+=8;break;
				case CRC_C:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x1+o);ae->nop+=2;ae->tick+=8;break;
				case CRC_D:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x2+o);ae->nop+=2;ae->tick+=8;break;
				case CRC_E:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x3+o);ae->nop+=2;ae->tick+=8;break;
				case CRC_H:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x4+o);ae->nop+=2;ae->tick+=8;break;
				case CRC_L:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x5+o);ae->nop+=2;ae->tick+=8;break;
				case CRC_MHL:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x6+o);ae->nop+=3;ae->tick+=12;break;
				case CRC_A:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x7+o);ae->nop+=2;ae->tick+=8;break;
				default:
					if (strncmp(ae->wl[ae->idx+2].w,"(IX",3)==0) {
						___output(ae,0xDD);___output(ae,0xCB);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x6+o);
						ae->nop+=6;ae->tick+=20;
					} else if (strncmp(ae->wl[ae->idx+2].w,"(IY",3)==0) {
						___output(ae,0xFD);___output(ae,0xCB);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x6+o);
						ae->nop+=6;ae->tick+=20;
					} else {
						MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is BIT n,reg8/(HL)/(IX+n)/(IY+n)\n");
					}
			}
			ae->idx+=2;
		} else if (!ae->wl[ae->idx+1].t && !ae->wl[ae->idx+2].t && ae->wl[ae->idx+3].t==1) {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"there is no syntax BIT (IX+n),reg8\n");
			ae->idx+=3;
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is BIT n,reg8/(HL)/(IX+n)[,reg8]/(IY+n)\n");
		}
	}
}

void _RES(struct s_assenv *ae) {
	int o;
	/* on check qu'il y a deux ou trois parametres 
	ExpressionFastTranslate(ae,&ae->wl[ae->idx+1].w,0);
	o=RoundComputeExpressionCore(ae,ae->wl[ae->idx+1].w,ae->codeadr,0); */
	o=0;
	if (o<0 || o>7) {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is RES <value from 0 to 7>,... (%d)\n",o);
	} else {
		o=0x80+o*8;
		if (ae->wl[ae->idx+1].t==0 && ae->wl[ae->idx+2].t==1) {
			switch (GetCRC(ae->wl[ae->idx+2].w)) {
				case CRC_B:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x0+o);ae->nop+=2;ae->tick+=8;break;
				case CRC_C:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x1+o);ae->nop+=2;ae->tick+=8;break;
				case CRC_D:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x2+o);ae->nop+=2;ae->tick+=8;break;
				case CRC_E:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x3+o);ae->nop+=2;ae->tick+=8;break;
				case CRC_H:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x4+o);ae->nop+=2;ae->tick+=8;break;
				case CRC_L:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x5+o);ae->nop+=2;ae->tick+=8;break;
				case CRC_MHL:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x6+o);ae->nop+=4;ae->tick+=15;break;
				case CRC_A:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x7+o);ae->nop+=2;ae->tick+=8;break;
				default:
					if (strncmp(ae->wl[ae->idx+2].w,"(IX",3)==0) {
						___output(ae,0xDD);___output(ae,0xCB);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x6+o);
						ae->nop+=7;ae->tick+=23;
					} else if (strncmp(ae->wl[ae->idx+2].w,"(IY",3)==0) {
						___output(ae,0xFD);___output(ae,0xCB);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x6+o);
						ae->nop+=7;ae->tick+=23;
					} else {
						MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is RES n,reg8/(HL)/(IX+n)/(IY+n)\n");
					}
			}
			ae->idx+=2;
		} else if (!ae->wl[ae->idx+1].t && !ae->wl[ae->idx+2].t && ae->wl[ae->idx+3].t==1) {
			if (strncmp(ae->wl[ae->idx+2].w,"(IX",3)==0) {
				___output(ae,0xDD);
			} else if (strncmp(ae->wl[ae->idx+2].w,"(IY",3)==0) {
				___output(ae,0xFD);
			} else {
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is RES n,(IX+n),reg8\n");
			}
			___output(ae,0xCB);
			switch (GetCRC(ae->wl[ae->idx+3].w)) {
				case CRC_B:PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x0+o);ae->nop+=7;ae->tick+=23;break;
				case CRC_C:PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x1+o);ae->nop+=7;ae->tick+=23;break;
				case CRC_D:PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x2+o);ae->nop+=7;ae->tick+=23;break;
				case CRC_E:PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x3+o);ae->nop+=7;ae->tick+=23;break;
				case CRC_H:PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x4+o);ae->nop+=7;ae->tick+=23;break;
				case CRC_L:PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x5+o);ae->nop+=7;ae->tick+=23;break;
				case CRC_A:PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x7+o);ae->nop+=7;ae->tick+=23;break;
				default:			
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is RES n,(IX+n),reg8\n");
			}
			ae->idx+=3;
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is RES n,reg8/(HL)/(IX+n)[,reg8]/(IY+n)[,reg8]\n");
		}
	}
}

void _SET(struct s_assenv *ae) {
	int o;
	/* on check qu'il y a deux ou trois parametres 
	ExpressionFastTranslate(ae,&ae->wl[ae->idx+1].w,0);
	o=RoundComputeExpressionCore(ae,ae->wl[ae->idx+1].w,ae->codeadr,0); */
	o=0;
	if (o<0 || o>7) {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SET <value from 0 to 7>,... (%d)\n",o);
	} else {
		o=0xC0+o*8;
		if (ae->wl[ae->idx+1].t==0 && ae->wl[ae->idx+2].t==1) {
			switch (GetCRC(ae->wl[ae->idx+2].w)) {
				case CRC_B:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x0+o);ae->nop+=2;ae->tick+=8;break;
				case CRC_C:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x1+o);ae->nop+=2;ae->tick+=8;break;
				case CRC_D:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x2+o);ae->nop+=2;ae->tick+=8;break;
				case CRC_E:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x3+o);ae->nop+=2;ae->tick+=8;break;
				case CRC_H:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x4+o);ae->nop+=2;ae->tick+=8;break;
				case CRC_L:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x5+o);ae->nop+=2;ae->tick+=8;break;
				case CRC_MHL:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x6+o);ae->nop+=4;ae->tick+=15;break;
				case CRC_A:___output(ae,0xCB);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x7+o);ae->nop+=2;ae->tick+=8;break;
				default:
					if (strncmp(ae->wl[ae->idx+2].w,"(IX",3)==0) {
						___output(ae,0xDD);___output(ae,0xCB);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x6+o);
						ae->nop+=7;ae->tick+=23;
					} else if (strncmp(ae->wl[ae->idx+2].w,"(IY",3)==0) {
						___output(ae,0xFD);___output(ae,0xCB);
						PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);
						PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x6+o);
						ae->nop+=7;ae->tick+=23;
					} else {
						MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SET n,reg8/(HL)/(IX+n)/(IY+n)\n");
					}
			}
			ae->idx+=2;
		} else if (!ae->wl[ae->idx+1].t && !ae->wl[ae->idx+2].t && ae->wl[ae->idx+3].t==1) {
			if (strncmp(ae->wl[ae->idx+2].w,"(IX",3)==0) {
				___output(ae,0xDD);
			} else if (strncmp(ae->wl[ae->idx+2].w,"(IY",3)==0) {
				___output(ae,0xFD);
			} else {
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SET n,(IX+n),reg8\n");
			}
			___output(ae,0xCB);
			switch (GetCRC(ae->wl[ae->idx+3].w)) {
				case CRC_B:PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x0+o);ae->nop+=7;ae->tick+=23;break;
				case CRC_C:PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x1+o);ae->nop+=7;ae->tick+=23;break;
				case CRC_D:PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x2+o);ae->nop+=7;ae->tick+=23;break;
				case CRC_E:PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x3+o);ae->nop+=7;ae->tick+=23;break;
				case CRC_H:PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x4+o);ae->nop+=7;ae->tick+=23;break;
				case CRC_L:PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x5+o);ae->nop+=7;ae->tick+=23;break;
				case CRC_A:PushExpression(ae,ae->idx+2,E_EXPRESSION_IV8);PushExpression(ae,ae->idx+1,E_EXPRESSION_BRS);___output(ae,0x7+o);ae->nop+=7;ae->tick+=23;break;
				default:			
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SET n,(IX+n),reg8\n");
			}
			ae->idx+=3;
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is SET n,reg8/(HL)/(IX+n)[,reg8]/(IY+n)[,reg8]\n");
		}
	}
}

void _DEFS(struct s_assenv *ae) {
	int i,r,v;
	if (ae->wl[ae->idx].t) {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Syntax is DEFS repeat,value or DEFS repeat\n");
	} else do {
		ae->idx++;
		if (!ae->wl[ae->idx].t) {
			ExpressionFastTranslate(ae,&ae->wl[ae->idx].w,0);
			ExpressionFastTranslate(ae,&ae->wl[ae->idx+1].w,0); /* doing FastTranslate but not a complete evaluation */
			r=RoundComputeExpressionCore(ae,ae->wl[ae->idx].w,ae->codeadr,0);
			if (r<0) {
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"DEFS size must be greater or equal to zero\n");
			}
			for (i=0;i<r;i++) {
				/* keep flexibility */
				PushExpression(ae,ae->idx+1,E_EXPRESSION_0V8);
				ae->nop+=1;
			}
			ae->idx++;
		} else if (ae->wl[ae->idx].t==1) {
			ExpressionFastTranslate(ae,&ae->wl[ae->idx].w,0);
			r=RoundComputeExpressionCore(ae,ae->wl[ae->idx].w,ae->codeadr,0);
			v=0;
			if (r<0) {
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"DEFS size must be greater or equal to zero\n");
			}
			for (i=0;i<r;i++) {
				___output(ae,v);
				ae->nop+=1;
			}
		}
	} while (!ae->wl[ae->idx].t);
}

void _DEFS_struct(struct s_assenv *ae) {
	int i,r,v;
	if (ae->wl[ae->idx].t) {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Syntax is DEFS repeat,value or DEFS repeat\n");
	} else do {
		ae->idx++;
		if (!ae->wl[ae->idx].t) {
			ExpressionFastTranslate(ae,&ae->wl[ae->idx].w,0);
			ExpressionFastTranslate(ae,&ae->wl[ae->idx+1].w,0);
			r=RoundComputeExpressionCore(ae,ae->wl[ae->idx].w,ae->codeadr,0);
			v=RoundComputeExpressionCore(ae,ae->wl[ae->idx+1].w,ae->codeadr,0);
			if (r<0) {
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"DEFS size must be greater or equal to zero\n");
			}
			for (i=0;i<r;i++) {
				___output(ae,v);
				ae->nop+=1;
			}
			ae->idx++;
		} else if (ae->wl[ae->idx].t==1) {
			ExpressionFastTranslate(ae,&ae->wl[ae->idx].w,0);
			r=RoundComputeExpressionCore(ae,ae->wl[ae->idx].w,ae->codeadr,0);
			v=0;
			if (r<0) {
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"DEFS size must be greater or equal to zero\n");
			}
			for (i=0;i<r;i++) {
				___output(ae,v);
				ae->nop+=1;
			}
		}
	} while (!ae->wl[ae->idx].t);
}

void _STR(struct s_assenv *ae) {
	unsigned char c;
	int i,tquote;

	if (!ae->wl[ae->idx].t) {
		do {
			ae->idx++;
			if ((tquote=StringIsQuote(ae->wl[ae->idx].w))!=0) {
				i=1;
				while (ae->wl[ae->idx].w[i] && ae->wl[ae->idx].w[i]!=tquote) {
					if (ae->wl[ae->idx].w[i]=='\\') {
						i++;
						/* no conversion on escaped chars */
						c=ae->wl[ae->idx].w[i];
						switch (c) {
							case 'b':c='\b';break;
							case 'v':c='\v';break;
							case 'f':c='\f';break;
							case '0':c='\0';break;
							case 'r':c='\r';break;
							case 'n':c='\n';break;
							case 't':c='\t';break;
							default:break;
						}						
						if (ae->wl[ae->idx].w[i+1]!=tquote) {
							___output(ae,c);
						} else {
							___output(ae,c|0x80);
						}
					} else {
						/* charset conversion on the fly */
						if (ae->wl[ae->idx].w[i+1]!=tquote) {
							___output(ae,ae->charset[((unsigned int)ae->wl[ae->idx].w[i])&0xFF]);
						} else {
							___output(ae,ae->charset[((unsigned int)ae->wl[ae->idx].w[i])&0xFF]|0x80);
						}
					}

					i++;
				}
			} else {
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"STR handle only quoted strings!\n");
			}
		} while (ae->wl[ae->idx].t==0);
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"STR needs one or more quotes parameters\n");
	}
}

/* Microsoft IEEE-754 40bits float value */
void _DEFF(struct s_assenv *ae) {
	if (!ae->wl[ae->idx].t) {
		do {
			ae->idx++;
			PushExpression(ae,ae->idx,E_EXPRESSION_0VRMike);
		} while (ae->wl[ae->idx].t==0);
	} else {
		if (ae->getstruct) {
			___output(ae,0);___output(ae,0);___output(ae,0);___output(ae,0);___output(ae,0);
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"DEFF needs one or more parameters\n");
		}
	}
}
void _DEFF_struct(struct s_assenv *ae) {
	unsigned char *rc;
	double v;
	if (!ae->wl[ae->idx].t) {
		do {
			ae->idx++;
			/* conversion des symboles connus */
			ExpressionFastTranslate(ae,&ae->wl[ae->idx].w,0);
			/* calcul de la valeur définitive de l'expression */
			v=ComputeExpressionCore(ae,ae->wl[ae->idx].w,ae->outputadr,0);
			/* conversion en réel Amsdos */
			rc=__internal_MakeRosoftREAL(ae,v,0);
			___output(ae,rc[0]);___output(ae,rc[1]);___output(ae,rc[2]);___output(ae,rc[3]);___output(ae,rc[4]);			
		} while (ae->wl[ae->idx].t==0);
	} else {
		if (ae->getstruct) {
			___output(ae,0);___output(ae,0);___output(ae,0);___output(ae,0);___output(ae,0);
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"DEFF needs one or more parameters\n");
		}
	}
}


void _DEFR(struct s_assenv *ae) {
	if (!ae->wl[ae->idx].t) {
		do {
			ae->idx++;
			PushExpression(ae,ae->idx,E_EXPRESSION_0VR);
		} while (ae->wl[ae->idx].t==0);
	} else {
		if (ae->getstruct) {
			___output(ae,0);___output(ae,0);___output(ae,0);___output(ae,0);___output(ae,0);
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"DEFR needs one or more parameters\n");
		}
	}
}
void _DEFR_struct(struct s_assenv *ae) {
	unsigned char *rc;
	double v;
	if (!ae->wl[ae->idx].t) {
		do {
			ae->idx++;
			/* conversion des symboles connus */
			ExpressionFastTranslate(ae,&ae->wl[ae->idx].w,0);
			/* calcul de la valeur définitive de l'expression */
			v=ComputeExpressionCore(ae,ae->wl[ae->idx].w,ae->outputadr,0);
			/* conversion en réel Amsdos */
			rc=__internal_MakeAmsdosREAL(ae,v,0);
			___output(ae,rc[0]);___output(ae,rc[1]);___output(ae,rc[2]);___output(ae,rc[3]);___output(ae,rc[4]);			
		} while (ae->wl[ae->idx].t==0);
	} else {
		if (ae->getstruct) {
			___output(ae,0);___output(ae,0);___output(ae,0);___output(ae,0);___output(ae,0);
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"DEFR needs one or more parameters\n");
		}
	}
}

void _DEFB(struct s_assenv *ae) {
	int i,tquote;
	unsigned char c;
	if (!ae->wl[ae->idx].t) {
		do {
			ae->idx++;
			if ((tquote=StringIsQuote(ae->wl[ae->idx].w))!=0) {
				i=1;
				while (ae->wl[ae->idx].w[i] && ae->wl[ae->idx].w[i]!=tquote) {
					if (ae->wl[ae->idx].w[i]=='\\') {
						i++;
						if (ae->wl[ae->idx].w[i]!='\\') {
							/* no conversion on escaped chars EXCEPT escape char ^_^ */
							c=ae->wl[ae->idx].w[i];
							switch (c) {
								case 'e':___output(ae,0x1B);break;
								case 'a':___output(ae,0x07);break; // alarm
								case 'b':___output(ae,'\b');break;
								case 'v':___output(ae,'\v');break; // v-tab
								case 'f':___output(ae,'\f');break; // feed
								case '0':___output(ae,'\0');break;
								case 'r':___output(ae,'\r');break; // return
								case 'n':___output(ae,'\n');break; // carriage-return
								case 't':___output(ae,'\t');break; // tab
								default:
								___output(ae,c);
							}
						} else {
							___output(ae,ae->charset[(unsigned int)(ae->wl[ae->idx].w[i]&0xFF)]);
						}
						ae->nop+=1;
					} else {
						/* charset conversion on the fly */
						___output(ae,ae->charset[(unsigned int)(ae->wl[ae->idx].w[i]&0xFF)]);
						ae->nop+=1;
					}
					i++;
				}
			} else {
				PushExpression(ae,ae->idx,E_EXPRESSION_0V8);
				ae->nop+=1;
			}
		} while (ae->wl[ae->idx].t==0);
	} else {
		if (ae->getstruct) {
			___output(ae,0);
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"DEFB needs one or more parameters\n");
		}
	}
}
void _DEFB_struct(struct s_assenv *ae) {
	int i,tquote;
	unsigned char c;
	if (!ae->wl[ae->idx].t) {
		do {
			ae->idx++;
			if ((tquote=StringIsQuote(ae->wl[ae->idx].w))!=0) {
				i=1;
				while (ae->wl[ae->idx].w[i] && ae->wl[ae->idx].w[i]!=tquote) {
					if (ae->wl[ae->idx].w[i]=='\\') {
						i++;
						if (ae->wl[ae->idx].w[i]!='\\') {
							/* no conversion on escaped chars EXCEPT escape char ^_^ */
							c=ae->wl[ae->idx].w[i];
							switch (c) {
								case 'b':___output(ae,'\b');break;
								case 'v':___output(ae,'\v');break;
								case 'f':___output(ae,'\f');break;
								case '0':___output(ae,'\0');break;
								case 'r':___output(ae,'\r');break;
								case 'n':___output(ae,'\n');break;
								case 't':___output(ae,'\t');break;
								default:
								___output(ae,c);
							}
						} else {
							___output(ae,ae->charset[(unsigned int)ae->wl[ae->idx].w[i]&0xFF]);
						}
						ae->nop+=1;
					} else {
						/* charset conversion on the fly */
						___output(ae,ae->charset[(unsigned int)ae->wl[ae->idx].w[i]&0xFF]);
						ae->nop+=1;
					}
					i++;
				}
			} else {
				int v;
				ExpressionFastTranslate(ae,&ae->wl[ae->idx].w,0);
				v=RoundComputeExpressionCore(ae,ae->wl[ae->idx].w,ae->outputadr,0);
				___output(ae,v);
				ae->nop+=1;
			}
		} while (ae->wl[ae->idx].t==0);
	} else {
		if (ae->getstruct) {
			___output(ae,0);
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"DEFB needs one or more parameters\n");
		}
	}
}

void _DEFW(struct s_assenv *ae) {
	if (!ae->wl[ae->idx].t) {
		do {
			ae->idx++;
			PushExpression(ae,ae->idx,E_EXPRESSION_0V16);
		} while (ae->wl[ae->idx].t==0);
	} else {
		if (ae->getstruct) {
			___output(ae,0);___output(ae,0);
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"DEFW needs one or more parameters\n");
		}
	}
}

void _DEFW_struct(struct s_assenv *ae) {
	int v;
	if (!ae->wl[ae->idx].t) {
		do {
			ae->idx++;
			ExpressionFastTranslate(ae,&ae->wl[ae->idx].w,0);
			v=RoundComputeExpressionCore(ae,ae->wl[ae->idx].w,ae->outputadr,0);
			___output(ae,v&0xFF);___output(ae,(v>>8)&0xFF);
		} while (ae->wl[ae->idx].t==0);
	} else {
		if (ae->getstruct) {
			___output(ae,0);___output(ae,0);
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"DEFW needs one or more parameters\n");
		}
	}
}

void _DEFI(struct s_assenv *ae) {
	if (!ae->wl[ae->idx].t) {
		do {
			ae->idx++;
			PushExpression(ae,ae->idx,E_EXPRESSION_0V32);
		} while (ae->wl[ae->idx].t==0);
	} else {
		if (ae->getstruct) {
			___output(ae,0);___output(ae,0);___output(ae,0);___output(ae,0);
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"DEFI needs one or more parameters\n");
		}
	}
}

void _DEFI_struct(struct s_assenv *ae) {
	int v;
	if (!ae->wl[ae->idx].t) {
		do {
			ae->idx++;
			ExpressionFastTranslate(ae,&ae->wl[ae->idx].w,0);
			v=RoundComputeExpressionCore(ae,ae->wl[ae->idx].w,ae->outputadr,0);
			___output(ae,v&0xFF);___output(ae,(v>>8)&0xFF);___output(ae,(v>>16)&0xFF);___output(ae,(v>>24)&0xFF);
		} while (ae->wl[ae->idx].t==0);
	} else {
		if (ae->getstruct) {
			___output(ae,0);___output(ae,0);___output(ae,0);___output(ae,0);
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"DEFI needs one or more parameters\n");
		}
	}
}

void _DEFB_as80(struct s_assenv *ae) {
	int i,tquote;
	int modadr=0;

	if (!ae->wl[ae->idx].t) {
		do {
			ae->idx++;
			if ((tquote=StringIsQuote(ae->wl[ae->idx].w))!=0) {
				i=1;
				while (ae->wl[ae->idx].w[i] && ae->wl[ae->idx].w[i]!=tquote) {
					if (ae->wl[ae->idx].w[i]=='\\') i++;
					/* charset conversion on the fly */
					___output(ae,ae->charset[(unsigned int)ae->wl[ae->idx].w[i]&0xFF]);
					ae->nop+=1;
					ae->codeadr--;modadr++;
					i++;
				}
			} else {
				PushExpression(ae,ae->idx,E_EXPRESSION_0V8);
				ae->codeadr--;modadr++;
				ae->nop+=1;
			}
		} while (ae->wl[ae->idx].t==0);
		ae->codeadr+=modadr;
	} else {
		if (ae->getstruct) {
			___output(ae,0);
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"DEFB needs one or more parameters\n");
		}
	}
}

void _DEFW_as80(struct s_assenv *ae) {
	int modadr=0;
	if (!ae->wl[ae->idx].t) {
		do {
			ae->idx++;
			PushExpression(ae,ae->idx,E_EXPRESSION_0V16);
			ae->codeadr-=2;modadr+=2;
		} while (ae->wl[ae->idx].t==0);
		ae->codeadr+=modadr;
	} else {
		if (ae->getstruct) {
			___output(ae,0);___output(ae,0);
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"DEFW needs one or more parameters\n");
		}
	}
}

void _DEFI_as80(struct s_assenv *ae) {
	int modadr=0;
	if (!ae->wl[ae->idx].t) {
		do {
			ae->idx++;
			PushExpression(ae,ae->idx,E_EXPRESSION_0V32);
			ae->codeadr-=4;modadr+=4;
		} while (ae->wl[ae->idx].t==0);
		ae->codeadr+=modadr;
	} else {
		if (ae->getstruct) {
			___output(ae,0);___output(ae,0);___output(ae,0);___output(ae,0);
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"DEFI needs one or more parameters\n");
		}
	}
}
#if 0
void _DEFSTR(struct s_assenv *ae) {
	int i,tquote;
	unsigned char c;
	if (!ae->wl[ae->idx].t && !ae->wl[ae->idx+1].t && ae->wl[ae->idx+2].t==1) {
		if (StringIsQuote(ae->wl[ae->idx+1].w) && StringIsQuote(ae->wl[ae->idx+2].w)) {
				i=1;
				while (ae->wl[ae->idx].w[i] && ae->wl[ae->idx].w[i]!=tquote) {
					if (ae->wl[ae->idx].w[i]=='\\') {
						i++;
						/* no conversion on escaped chars */
						c=ae->wl[ae->idx].w[i];
						switch (c) {
							case 'b':___output(ae,'\b');break;
							case 'v':___output(ae,'\v');break;
							case 'f':___output(ae,'\f');break;
							case '0':___output(ae,'\0');break;
							case 'r':___output(ae,'\r');break;
							case 'n':___output(ae,'\n');break;
							case 't':___output(ae,'\t');break;
							default:
							___output(ae,c);
						}						
					} else {
						/* charset conversion on the fly */
						___output(ae,ae->charset[(int)ae->wl[ae->idx].w[i]]);
					}
					i++;
				}
		}
		ae->idx+=2;
	} else {
		//MakeError(ae,GetCurrentFile(ae),ae->wl[ae->idx].l,"DEFSTR needs two parameters\n");
	}
}
#endif

//************************************************************************************************************************************
//************************************************************************************************************************************
							#undef FUNC
						#define FUNC "HFEcreator CORE"
//************************************************************************************************************************************
//************************************************************************************************************************************

unsigned short int __internal_CRC16CCITT(unsigned short int zecrc,unsigned char zeval)
{
        int i;

    for (i=0; i<8; i++)
    {
        if (((zecrc>>8) ^ zeval) & 0x80)
        {
                zecrc*=2;
                zecrc^=0x1021;
        } else {
                zecrc*=2;
        }
        zeval*=2;
    }
        return zecrc;
}

unsigned char *__internal_make_HFE_header(int ntrack,int nside) {
	static unsigned char hfe[0x200];
	int i;

	for (i=0;i<0x200;i++) hfe[i]=0xFF;

	strcpy(hfe,"HXCPICFE");

	hfe[8]=0;  // revision
	hfe[9]=ntrack;
	hfe[10]=nside;
	hfe[11]=0; // track encoding 
	hfe[12]=0xFA; // bitrate
	hfe[13]=0x00; // bitrate
	hfe[14]=0x29; // RPM => 297   => using always regular 300?
	hfe[15]=0x01; // RPM
	hfe[16]=6; // CPC interface mode
	hfe[17]=1; // step...
	hfe[18]=1;
	hfe[19]=0; // tracklist offset => 0x200
	hfe[20]=1; // write protected
	hfe[21]=0xFF; // single step
	hfe[22]=0xFF;
	//
	hfe[24]=0xFF; // no alternate encoding for track 0
	//
	memcpy(hfe+0x1F0," rasm v2+ ",10); // TAG version
	return hfe;
}

// HFE is very similar to MFM
unsigned char *__internal_track_to_HFE(unsigned int *track, int lng) {
        unsigned char *data;
        int previous=0,idx,v;
        int i;

        if (!lng) return NULL;

        data=MemMalloc(2*lng);

        for (i=idx=0;i<lng;i++) {
                if (track[i]&SYNCHRO) {
                        switch (track[i]&0xFF) {
                                // push synchro byte
                                case 0xC2:data[idx++]=0x4A; data[idx++]=0x24;break; // C2
                                case 0xA1:data[idx++]=0x22; data[idx++]=0x91;break; // A1
                                default:printf("unknown synchro byte %02X\n",track[i]);break;
                        }
                } else {
                        v=track[i];

                        // push regular byte
                        data[idx]=0;
                        if (v&128) {data[idx]|=2;previous=1;}   else if (previous) {previous=0;} else {data[idx]|=1;}
                        if (v&64)  {data[idx]|=8;previous=1;}   else if (previous) {previous=0;} else {data[idx]|=4;}
                        if (v&32)  {data[idx]|=32;previous=1;}  else if (previous) {previous=0;} else {data[idx]|=16;}
                        if (v&16)  {data[idx]|=128;previous=1;} else if (previous) {previous=0;} else {data[idx]|=64;}
                        idx++;

                        data[idx]=0;
                        if (v&8) {data[idx]|=2;previous=1;}   else if (previous) {previous=0;} else {data[idx]|=1;}
                        if (v&4) {data[idx]|=8;previous=1;}   else if (previous) {previous=0;} else {data[idx]|=4;}
                        if (v&2) {data[idx]|=32;previous=1;}  else if (previous) {previous=0;} else {data[idx]|=16;}
                        if (v&1) {data[idx]|=128;previous=1;} else if (previous) {previous=0;} else {data[idx]|=64;}
                        idx++;
                }
        }
        return data;
}

void __internal_hfe_resize_track(struct s_assenv *ae) {
#if TRACE_HFE
	printf("resize track up to %d\n",ae->hfetrack);
#endif
	if (ae->hfetrack*2>=ae->hfedisk[ae->nbhfedisk-1].itrack) {
		struct s_hfe_track hfetrack={0};
		int i;
		while (ae->hfedisk[ae->nbhfedisk-1].itrack<2*(ae->hfetrack+1)) {
			// alloc
			ObjectArrayAddDynamicValueConcat((void **)&ae->hfedisk[ae->nbhfedisk-1],&ae->hfedisk[ae->nbhfedisk-1].itrack,&ae->hfedisk[ae->nbhfedisk-1].mtrack,&hfetrack,sizeof(hfetrack));
		}
		ae->hfe=&ae->hfedisk[ae->nbhfedisk-1].track[ae->hfetrack*2+ae->hfeside]; // update fast ptr
	}
}
void __hfe_init(struct s_assenv *ae, struct s_hfe_action *hfe_action) {
	struct s_hfe_floppy hfeflop={0};
	ae->hfeside=0;
	ae->hfetrack=0;
	// remplir une struct HFE par défaut
	ObjectArrayAddDynamicValueConcat((void **)&ae->hfedisk,&ae->nbhfedisk,&ae->maxhfedisk,&hfeflop,sizeof(hfeflop));
	ae->hfedisk[ae->nbhfedisk-1].filename=hfe_action->filename;
	// current pointer
	__internal_hfe_resize_track(ae);
}
void __hfe_side(struct s_assenv *ae, struct s_hfe_action *hfe_action) {
	ae->hfeside=RoundComputeExpression(ae,hfe_action->param[0],hfe_action->ioffset,0,0);
#if TRACE_HFE
	printf("switch HFE current side to %d\n",ae->hfeside);
#endif
	if (ae->hfeside<0 || ae->hfeside>1) {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is : HFE SIDE,[0|1]\n");
		ae->hfeside=0;
	}
	ae->hfe=&ae->hfedisk[ae->nbhfedisk-1].track[ae->hfetrack*2+ae->hfeside]; // update fast ptr
}
void __hfe_track(struct s_assenv *ae, struct s_hfe_action *hfe_action) {
	ae->hfetrack=RoundComputeExpression(ae,hfe_action->param[0],hfe_action->ioffset,0,0);
	if (ae->hfetrack<0 || ae->hfetrack>82) {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is : HFE TRACK,[0 to 82]\n");
		ae->hfetrack=0;
	}
	__internal_hfe_resize_track(ae);
	ae->hfe=&ae->hfedisk[ae->nbhfedisk-1].track[ae->hfetrack*2+ae->hfeside]; // update fast ptr
}

void __hfe_close(struct s_assenv *ae, struct s_hfe_action *hfe_action) {
	unsigned short int tracklist[256]={0};
	unsigned int zebyte=0x4E;
	unsigned char *hfe_header;
	unsigned char filler[0x100]={0};
	unsigned char *oname;
	unsigned char *data0,*data1;
	int i,j,k,l,blocktrack,tracklen;
	int first=0;

	oname=ae->hfedisk[ae->nbhfedisk-1].filename;
	FileRemoveIfExists(oname);

	// we assume the longest track is the reference for all tracks
	for (i=tracklen=0;i<ae->hfedisk[ae->nbhfedisk-1].itrack;i++) {
		if (tracklen<ae->hfedisk[ae->nbhfedisk-1].track[i].idata) tracklen=ae->hfedisk[ae->nbhfedisk-1].track[i].idata;
	}
	if (tracklen<6125) {
		rasm_printf(ae,KWARNING"[%s:%d] Warning: HFE tracklen is too short, adjusting to 6125 bytes which is still below optimal size of 6250 bytes\n",GetCurrentFile(ae),ae->wl[ae->idx].l);
		if (ae->erronwarn) MaxError(ae);
		tracklen=6125;
	}
	if (tracklen>6400) {
		if (tracklen>6500) {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"HFE tracklen is above FDC tolerance for a 300RPM drive! (tracklen=%d)\n",tracklen);
			return;
		} else {
			rasm_printf(ae,KWARNING"[%s:%d] Warning: HFE tracklen is very highi (%d)\n",GetCurrentFile(ae),ae->wl[ae->idx].l,tracklen);
			if (ae->erronwarn) MaxError(ae);
		}
	}
#if TRACE_HFE
	printf("max tracklen is %d\nfilling shortest tracks",tracklen);fflush(stdout);
#endif
	// fill shortest track with proper GAP
	zebyte=0x4E;
	for (i=0;i<(ae->hfedisk[ae->nbhfedisk-1].itrack>>1);i++) {
		int maxlen;
		maxlen=ae->hfedisk[ae->nbhfedisk-1].track[i*2].idata;
		if (ae->hfedisk[ae->nbhfedisk-1].track[i*2+1].idata>maxlen) maxlen=ae->hfedisk[ae->nbhfedisk-1].track[i*2+1].idata;

		// upgrade shortest track to the longest
		ae->hfe=&ae->hfedisk[ae->nbhfedisk-1].track[i*2]; // update fast ptr for convenience
		while (ae->hfedisk[ae->nbhfedisk-1].track[i*2].idata<maxlen) {
			ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
		}
		ae->hfe=&ae->hfedisk[ae->nbhfedisk-1].track[i*2+1]; // update fast ptr for convenience
		while (ae->hfedisk[ae->nbhfedisk-1].track[i*2+1].idata<maxlen) {
			ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
		}
		// blocktrack list
		blocktrack=(tracklen*4)>>9; if ((tracklen*4)&0x1F) blocktrack++;
		tracklist[i*2]=blocktrack*i+2;
		tracklist[i*2+1]=tracklen*4;
	}

	hfe_header=__internal_make_HFE_header(ae->hfedisk[ae->nbhfedisk-1].itrack>>1,2); // HFE side isn't used by emulators
	FileWriteBinary(oname,(char*)hfe_header,0x200);

#if TRACE_HFE
	printf("HFE blocks per track=%d\n",blocktrack);
#endif

	FileWriteBinary(oname,(char*)tracklist,0x200);

#if TRACE_HFE
	printf("nbtrack=%d\n",ae->hfedisk[ae->nbhfedisk-1].itrack>>1);
#endif

	for (j=0;j<ae->hfedisk[ae->nbhfedisk-1].itrack;j+=2) {
		int lng;

		ae->hfe=&ae->hfedisk[ae->nbhfedisk-1].track[j]; // update fast ptr for convenience
		tracklen=ae->hfe->idata;

		data0=__internal_track_to_HFE(ae->hfedisk[ae->nbhfedisk-1].track[j+0].data,tracklen);
		data1=__internal_track_to_HFE(ae->hfedisk[ae->nbhfedisk-1].track[j+1].data,tracklen);

		lng=tracklen*2;
		i=0;
		while (lng>=256) {
			FileWriteBinary(oname,(char*)data0+i,256);
			FileWriteBinary(oname,(char*)data1+i,256); i+=256;
			lng-=256;
		}
		if (lng) {
			FileWriteBinary(oname,(char*)data0+i,lng);
			FileWriteBinary(oname,(char*)filler,256-lng);
			FileWriteBinary(oname,(char*)data1+i,lng);
			FileWriteBinary(oname,(char*)filler,256-lng);
		}
		MemFree(data0);
		MemFree(data1);
	}
	FileWriteBinaryClose(oname);
	rasm_printf(ae,KIO"Write floppy image file %s\n"KNORMAL,oname);
}
void __hfe_output_crc(struct s_assenv *ae, struct s_hfe_action *hfe_action) {
	unsigned int zebyte;
	zebyte=ae->hfecrc>>8;
	ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
	zebyte=ae->hfecrc&0xFF;
	ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
}
void __hfe_start_crc(struct s_assenv *ae, struct s_hfe_action *hfe_action) {
	ae->hfecrc=0xFFFF;
}
void __hfe_add_byte(struct s_assenv *ae, struct s_hfe_action *hfe_action) {
	unsigned int zebyte;
	int i;
	for (i=1;i<hfe_action->nbparam;i++) {
		zebyte=RoundComputeExpression(ae,hfe_action->param[0+i],hfe_action->ioffset,0,0);
		__internal_CRC16CCITT(ae->hfecrc,zebyte&0xFF);
		ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
	}
}
void __hfe_add_track_header(struct s_assenv *ae, struct s_hfe_action *hfe_action) {
	unsigned int zebyte;
	int i;

#if TRACE_HFE
	printf("add HFE track header\n");
#endif
	zebyte=0x4E; // GAP4a
	for (i=0;i<80;i++) ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
	zebyte=0x00; // VCO SYNC
	for (i=0;i<12;i++) ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
	zebyte=0xC2|SYNCHRO; // IAM
	for (i=0;i<3;i++) ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
	zebyte=0xFC;
	ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
	zebyte=0x4E; // GAP1
	for (i=0;i<50;i++) ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
}
void __hfe_add_sector(struct s_assenv *ae, struct s_hfe_action *hfe_action) {
	unsigned int zebyte;
	unsigned short int crc;
	unsigned char sectorsize;
	int i,curlen,offset;

#if TRACE_HFE
	printf("add HFE sector (tracksize=%d)\n",ae->hfe->idata);
#endif

	zebyte=0x00; // VCO SYNC
	for (i=0;i<12;i++) ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
	zebyte=0xA1|SYNCHRO; // IDAM
	for (i=0;i<3;i++) ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
	zebyte=0xFE;
	ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));

	crc=__internal_CRC16CCITT(0xFFFF,0xA1);
	crc=__internal_CRC16CCITT(crc,0xA1);
	crc=__internal_CRC16CCITT(crc,0xA1);
	crc=__internal_CRC16CCITT(crc,0xFE);

	zebyte=RoundComputeExpression(ae,hfe_action->param[0],hfe_action->ioffset,0,0); // track
	crc=__internal_CRC16CCITT(crc,zebyte);
	ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
	zebyte=RoundComputeExpression(ae,hfe_action->param[1],hfe_action->ioffset,0,0); // side
	crc=__internal_CRC16CCITT(crc,zebyte);
	ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
	zebyte=RoundComputeExpression(ae,hfe_action->param[2],hfe_action->ioffset,0,0); // ID
	crc=__internal_CRC16CCITT(crc,zebyte);
	ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
	sectorsize=zebyte=RoundComputeExpression(ae,hfe_action->param[3],hfe_action->ioffset,0,0); // sector size
	crc=__internal_CRC16CCITT(crc,zebyte);
	ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
	zebyte=(crc>>8)&0xFF; // CRC high weight
	ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
	zebyte=crc&0xFF; // CRC low weight
	ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));

	// gestion des longueurs à la con
	switch (sectorsize) {
		case 0:curlen=128;break;
		case 1:curlen=256;break;
		case 2:curlen=512;break;
		case 3:curlen=1024;break;
		case 4:curlen=2048;break;
		case 5:curlen=4096;break;
		default:MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is : HFE ADD_SECTOR support only sector size lower than 6\n");
			return;
	}

	offset=RoundComputeExpression(ae,hfe_action->param[4],hfe_action->ioffset,0,0);
	if (offset<0 || offset+curlen>65536) {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is : HFE ADD_SECTOR, sector data is out of memory offset=%d offset+curlen=%d\n",offset,offset+curlen);
		return;
	}

	zebyte=0x4E; // GAP 2
	for (i=0;i<22;i++) ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
	zebyte=0x00; // VCO SYNC
	for (i=0;i<12;i++) ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
	zebyte=0xA1|SYNCHRO; // DAM
	for (i=0;i<3;i++) ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
	zebyte=0xFB; // regular DAM
	ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
	crc=__internal_CRC16CCITT(0xFFFF,0xA1);
	crc=__internal_CRC16CCITT(crc,0xA1);
	crc=__internal_CRC16CCITT(crc,0xA1);
	crc=__internal_CRC16CCITT(crc,0xFB);

	for (i=0;i<curlen;i++) {
		zebyte=ae->mem[hfe_action->ibank][offset+i];
		crc=__internal_CRC16CCITT(crc,zebyte);
		ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
	}

	zebyte=(crc>>8)&0xFF; // CRC high weight
	ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
	zebyte=crc&0xFF; // CRC low weight
	ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
}
void __hfe_add_gap(struct s_assenv *ae, struct s_hfe_action *hfe_action) {
	unsigned short int zebyte;
	int i,bytenumber;

	bytenumber=RoundComputeExpression(ae,hfe_action->param[0],hfe_action->ioffset,0,0);
	if (bytenumber<1) {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"GAP size must be greater than zero\n");
		return;
	}
	switch (hfe_action->nbparam) {
		case 2: // number of bytes for GAP
			zebyte=0x4E;
			break;
		case 3: // number of bytes for GAP | GAP filler
			zebyte=RoundComputeExpression(ae,hfe_action->param[1],hfe_action->ioffset,0,0);
			break;
		default:
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"syntax is : HFE ADD_GAP,<gap size>[,<gap filler>]\n");
			return;
	}
	for (i=0;i<bytenumber;i++) {
		__internal_CRC16CCITT(ae->hfecrc,zebyte&0xFF);
		ObjectArrayAddDynamicValueConcat((void **)&ae->hfe->data,&ae->hfe->idata,&ae->hfe->mdata,&zebyte,sizeof(zebyte));
	}
}

void __HFE(struct s_assenv *ae) {
	if (!ae->wl[ae->idx].t) {
		struct s_hfe_action curaction={0};
		int cmderr=0,backidx,nbparam=1,touched;
		char *filename[3]={0},*tmpfilename;
		int i,j,lm;

		// which action?
		switch (ae->wl[ae->idx+1].w[0]) {
			case 'A':
				if (strcmp(ae->wl[ae->idx+1].w,"ADD_BYTE")==0)		curaction.action=E_HFE_ACTION_ADD_BYTE; else
				if (strcmp(ae->wl[ae->idx+1].w,"ADD_SECTOR")==0)	curaction.action=E_HFE_ACTION_ADD_SECTOR; else
				if (strcmp(ae->wl[ae->idx+1].w,"ADD_GAP")==0)		curaction.action=E_HFE_ACTION_ADD_GAP; else
				if (strcmp(ae->wl[ae->idx+1].w,"ADD_TRACK_HEADER")==0)	curaction.action=E_HFE_ACTION_ADD_TRACK_HEADER; else cmderr=1;
				break;
			case 'C':if (strcmp(ae->wl[ae->idx+1].w,"CLOSE")==0)	curaction.action=E_HFE_ACTION_CLOSE; else cmderr=1;break;
			case 'I':if (strcmp(ae->wl[ae->idx+1].w,"INIT")==0)		curaction.action=E_HFE_ACTION_INIT; else cmderr=1;break;
			case 'O':if (strcmp(ae->wl[ae->idx+1].w,"OUTPUT_CRC")==0)	curaction.action=E_HFE_ACTION_OUTPUT_CRC; else cmderr=1;break;
			case 'S':
				if (strcmp(ae->wl[ae->idx+1].w,"START_CRC")==0)	curaction.action=E_HFE_ACTION_START_CRC; else
				if (strcmp(ae->wl[ae->idx+1].w,"SIDE")==0)		curaction.action=E_HFE_ACTION_SIDE; else cmderr=1;
				break;
			case 'T':if (strcmp(ae->wl[ae->idx+1].w,"TRACK")==0)	curaction.action=E_HFE_ACTION_TRACK; else cmderr=1;break;
			default:cmderr=1;
		}
		// some action need more than one filename
		switch (curaction.action) {
			case E_HFE_ACTION_ADD_TRACK_HEADER: case E_HFE_ACTION_OUTPUT_CRC:case E_HFE_ACTION_START_CRC:case E_HFE_ACTION_CLOSE:
				nbparam=1;break;
			case E_HFE_ACTION_INIT:case E_HFE_ACTION_SIDE:case E_HFE_ACTION_TRACK:case E_HFE_ACTION_ADD_BYTE:
				nbparam=2;break;
			case E_HFE_ACTION_ADD_GAP:
				nbparam=2;break; // filler optional
			case E_HFE_ACTION_ADD_SECTOR:
				nbparam=6;break; // track,side,id,sectorsize,offset (current bank is set)
			default:MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Internal Error on HFE action management (1)\n");break;
		}
		// default struct
		curaction.iw=ae->idx;
		curaction.ibank=ae->activebank;
		curaction.ioffset=ae->outputadr;
		while (!ae->wl[ae->idx+curaction.nbparam].t) {
			curaction.nbparam++;
		}
		if (curaction.nbparam<nbparam) {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"not enough parameters for HFE %s! A minimum of %d is requested\n",ae->wl[ae->idx+1].w,nbparam);
			return;
		}

		switch (curaction.action) {
			case E_HFE_ACTION_INIT:
				// enforce filename is a string!
				if (!StringIsQuote(ae->wl[ae->idx+2].w)) {
					MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"HFE syntax is : HFE INIT,'filename'\n");
					return;
				}
				tmpfilename=TxtStrDup(ae->wl[ae->idx+2].w);
				/* need to upper case tags */
				for (lm=touched=0;tmpfilename[lm];lm++) {
					if (tmpfilename[lm]=='{') touched++; else if (tmpfilename[lm]=='}') touched--; else if (touched) tmpfilename[lm]=toupper(tmpfilename[lm]);
				}
				tmpfilename=TranslateTag(ae,tmpfilename,&touched,1,E_TAGOPTION_REMOVESPACE);
				curaction.filename=StringRemoveQuotes(ae,tmpfilename); // alloc a new string
			printf("new HFE will be [%s]\n",curaction.filename);
				MemFree(tmpfilename);
				break;
			default:
				// translate all params except first one because they must be numeric!
				for (i=1;i<curaction.nbparam;i++) {
					char *param;
					param=TxtStrDup(ae->wl[ae->idx+i+1].w);
					ExpressionFastTranslate(ae,&param,1);
					ObjectArrayAddDynamicValueConcat((void**)&curaction.param,&curaction.iparam,&curaction.mparam,&param,sizeof(char *));
				}
				break;
		}
		ObjectArrayAddDynamicValueConcat((void**)&ae->hfe_action,&ae->nbhfeaction,&ae->maxhfeaction,&curaction,sizeof(curaction));
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"HFE syntax is : HFE <COMMAND>[,<parameters>] (see documentation)\n");
	}
}
void PopAllHFE(struct s_assenv *ae) {
	int i;
	for (i=0;i<ae->nbhfeaction;i++) {
		ae->idx=ae->hfe_action[i].iw; // MakeError hack
		switch (ae->hfe_action[i].action) {
			case E_HFE_ACTION_ADD_TRACK_HEADER:	__hfe_add_track_header(ae,&ae->hfe_action[i]);break;
			case E_HFE_ACTION_OUTPUT_CRC:	__hfe_output_crc(ae,&ae->hfe_action[i]);break;
			case E_HFE_ACTION_START_CRC:	__hfe_start_crc(ae,&ae->hfe_action[i]);break;
			case E_HFE_ACTION_CLOSE: 		__hfe_close(ae,&ae->hfe_action[i]);break;
			case E_HFE_ACTION_INIT:			__hfe_init(ae,&ae->hfe_action[i]);break;
			case E_HFE_ACTION_SIDE:			__hfe_side(ae,&ae->hfe_action[i]);break;
			case E_HFE_ACTION_TRACK:		__hfe_track(ae,&ae->hfe_action[i]);break;
			case E_HFE_ACTION_ADD_GAP:		__hfe_add_gap(ae,&ae->hfe_action[i]);break;
			case E_HFE_ACTION_ADD_BYTE:		__hfe_add_byte(ae,&ae->hfe_action[i]);break;
			case E_HFE_ACTION_ADD_SECTOR:	__hfe_add_sector(ae,&ae->hfe_action[i]);break;
			default:MakeError(ae,0,"(PopAllHFE)",0,"internal error during HFE deferred execution, please report\n");
				break;
		}
	}
}

//************************************************************************************************************************************
//************************************************************************************************************************************
							#undef FUNC
						#define FUNC "EdskTool CORE"
//************************************************************************************************************************************
//************************************************************************************************************************************

void edsktool_MAPTrack(struct s_edsk_track_global_struct *track) {
        int rlen,gaplen,i,curlen;
        int s,weak=0,gap=0;

        if (track->unformated) {
                printf("S%dT%02d : Unformated\n",track->side,track->track);
        } else {
                printf("S%dT%02d G%02XF%02XS%02d: ",track->side,track->track,track->gap3length,track->fillerbyte,track->sectornumber);

                if (track->gap3length<32) gaplen=0; else
                if (track->gap3length<96) gaplen=1; else
                if (track->gap3length<160) gaplen=2; else gaplen=3;

                printf("||"); // track info
                for (s=0;s<track->sectornumber;s++) {
                        switch (gaplen) {
                                case 3:printf("|");
                                case 2:printf("|");
                                case 1:printf("|");
                                default:break;
                        }
                        printf("#"); // header

                        switch (track->sector[s].size) {
                                case 0:curlen=128;break;
                                case 1:curlen=256;break;
                                case 2:curlen=512;break;
                                case 3:curlen=1024;break;
                                case 4:curlen=2048;break;
                                case 5:curlen=4096;break;
                                case 6:curlen=6144;break;
                                default:curlen=0;break;
                        }
                        if (curlen>track->sector[s].length) {
                                curlen=track->sector[s].length;
                        }

                        rlen=(curlen+31)/64;
                        rlen-=2;

                        if (rlen<0) rlen=0;
                        printf("%02X",track->sector[s].id);
                        if (rlen>3) {
                                if (curlen==track->sector[s].length) {
                                        printf(".s%d.",track->sector[s].size);
                                } else if (curlen*3<=track->sector[s].length) {
                                        printf("."KLORANGE"W"KNORMAL"%d.",track->sector[s].size);
                                        weak=1;
                                } else {
                                        printf("."KLBLUE"G"KNORMAL"%d.",track->sector[s].size);
                                        gap=1;
                                }
                                rlen-=4;
                        }
                        for (i=0;i<rlen;i++) printf(".");
                }
                if (weak && gap) printf(" gap+weak"); else
                if (weak) printf(" weak"); else
                if (gap) printf(" gap");
                printf("\n");
                weak=gap=0;
        }
}
void edsktool_MAPEDSK(struct s_edsk_global_struct *edsk) {
        int s,t;

	printf("map EDSK : %d side%s %d track%s\n",edsk->sidenumber,edsk->sidenumber==2?"s":"",edsk->tracknumber,edsk->tracknumber>1?"s":"");
	for (s=0;s<edsk->sidenumber;s++) {
		for (t=0;t<edsk->tracknumber;t++) {
			edsktool_MAPTrack(&edsk->track[t*edsk->sidenumber+s]);
		}
	}
}
struct s_edsk_global_struct *edsktool_NewEDSK(char *format) {
        struct s_edsk_global_struct *edsk;
        int i,t,s;

        edsk=MemMalloc(sizeof(struct s_edsk_global_struct));
        memset(edsk,0,sizeof(struct s_edsk_global_struct));
        if (!format) {
                // empty EDSK
                return edsk;
        }

        if (strcmp(format,"DATA")==0 || strcmp(format,"VENDOR")==0) {
                edsk->tracknumber=42;
                edsk->sidenumber=1;
                edsk->track=MemMalloc(sizeof(struct s_edsk_track_global_struct)*edsk->tracknumber*edsk->sidenumber);
                memset(edsk->track,0,sizeof(struct s_edsk_track_global_struct)*edsk->tracknumber*edsk->sidenumber);
                for (t=0;t<=39;t++) {
                        edsk->track[t].track=t;
                        edsk->track[t].side=0;
                        edsk->track[t].sectornumber=9;
                        edsk->track[t].sectorsize=2;
                        edsk->track[t].gap3length=0x50;
                        edsk->track[t].fillerbyte=0xE5;
                        edsk->track[t].sector=MemMalloc(edsk->track[t].sectornumber*sizeof(struct s_edsk_sector_global_struct));
                        for (s=0;s<9;s++) {
                                edsk->track[t].sector[s].track=t;
                                edsk->track[t].sector[s].side=0;
                                if (strcmp(format,"DATA")==0) edsk->track[t].sector[s].id=0xC1+s; else
                                if (strcmp(format,"VENDOR")==0) edsk->track[t].sector[s].id=0x41+s;
                                edsk->track[t].sector[s].size=2;
                                edsk->track[t].sector[s].st1=0;
                                edsk->track[t].sector[s].st2=0;
                                edsk->track[t].sector[s].length=512;
                                edsk->track[t].sector[s].data=MemMalloc(edsk->track[t].sector[s].length);
                                for (i=0;i<edsk->track[t].sector[s].length;i++) edsk->track[t].sector[s].data[i]=edsk->track[t].fillerbyte;
                        }
                }
                for (t=40;t<=41;t++) {
                        edsk->track[t].unformated=1;
                }
        } else if (strcmp(format,"DIX")==0) {
                edsk->tracknumber=42;
                edsk->sidenumber=1;
                edsk->track=MemMalloc(sizeof(struct s_edsk_track_global_struct)*edsk->tracknumber*edsk->sidenumber);
                memset(edsk->track,0,sizeof(struct s_edsk_track_global_struct)*edsk->tracknumber*edsk->sidenumber);
                for (t=0;t<=39;t++) {
                        edsk->track[t].track=t;
                        edsk->track[t].side=0;
                        edsk->track[t].sectornumber=10;
                        edsk->track[t].sectorsize=2;
                        edsk->track[t].gap3length=50;
                        edsk->track[t].fillerbyte=0xE5;
                        edsk->track[t].sector=MemMalloc(edsk->track[t].sectornumber*sizeof(struct s_edsk_sector_global_struct));
                        for (s=0;s<10;s++) {
                                edsk->track[t].sector[s].track=t;
                                edsk->track[t].sector[s].side=0;
                                edsk->track[t].sector[s].id=0xC1+s;
                                edsk->track[t].sector[s].size=2;
                                edsk->track[t].sector[s].st1=0;
                                edsk->track[t].sector[s].st2=0;
                                edsk->track[t].sector[s].length=512;
                                edsk->track[t].sector[s].data=MemMalloc(edsk->track[t].sector[s].length);
                                for (i=0;i<edsk->track[t].sector[s].length;i++) edsk->track[t].sector[s].data[i]=edsk->track[t].fillerbyte;
                        }
                }
                for (t=40;t<=41;t++) {
                        edsk->track[t].unformated=1;
                }
        }

        return edsk;
}

struct s_edsk_global_struct *edsktool_EDSK_load(char *edskfilename) //@@TODO faire un mécanisme de cache
{
        #undef FUNC
        #define FUNC "EDSK_load"

        unsigned char header[256];
        unsigned char *data;
        int tracknumber,sidenumber,tracksize,disksize;
        int i,b,s,t,face,curtrack,sectornumber,sectorsize,sectorid,reallength,gap3,filler,ST1,ST2;
        int currenttrackposition=0,currentsectorposition,tmpcurrentsectorposition;
        int curblock=0,curoffset=0;
        int special,is_data,is_vendor,spelocal,ctrlsize;
        FILE *f;
        struct s_edsk_global_struct *edsk;

        edsk=edsktool_NewEDSK(NULL);

        f=fopen(edskfilename,"rb");
        if (!f) {
                printf(KERROR"Cannot read EDSK header of [%s]!\n",edskfilename);
                exit(ABORT_ERROR);
        }

        if (fread((char*)&header,1,0x100,f)!=0x100) {
                printf(KERROR"Cannot read EDSK header of [%s]!\n",edskfilename);
                exit(ABORT_ERROR);
        }
        if (strncmp((char *)header,"EXTENDED",8)==0) {
#if TRACE_EDSK
                printf(KIO"opening EDSK [%s] / creator: %-14.14s\n"KNORMAL,edskfilename,header+34);
#endif
                tracknumber=header[34+14];
                sidenumber=header[34+14+1];

                if (sidenumber<1 || sidenumber>2) {
                        printf(KERROR"[%s] EDSK format is not supported in update mode (ntrack=%d nside=%d)\n",edskfilename,tracknumber,sidenumber);
                        exit(ABORT_ERROR);
                }

                edsk->tracknumber=tracknumber;
                edsk->sidenumber=sidenumber;
                edsk->track=MemMalloc(sizeof(struct s_edsk_track_global_struct)*tracknumber*sidenumber);
                memset(edsk->track,0,sizeof(struct s_edsk_track_global_struct)*tracknumber*sidenumber);

                for (i=disksize=0;i<tracknumber*sidenumber;i++) {
                        disksize+=header[0x34+i]*256;
                        edsk->track[i].headersize=header[0x34+i]*256;
                }

#if TRACE_EDSK
                printf("total track size: %dkb\n",disksize/1024);
#endif
                data=MemMalloc(disksize);
                memset(data,0,disksize);
                if ((ctrlsize=fread((char *)data,1,disksize,f))!=disksize) {
                        printf(KERROR"Cannot read EDSK tracks! expecting %d bytes but read %d bytes\n"KNORMAL,disksize,ctrlsize);
                        // This is not a fatal Error anymore to allow further analysis
                }

                for (t=0;t<tracknumber;t++)
                for (face=0;face<sidenumber;face++) {
                        int track_sectorsize;

                        curtrack=t*sidenumber+face;
                        i=currenttrackposition;
                        currentsectorposition=i+0x100;

                        special=0;
                        edsk->track[curtrack].track=t;
                        edsk->track[curtrack].side=face;

                        if (!header[0x34+curtrack]) {
                                edsk->track[curtrack].unformated=1;
                        } else {
                                currenttrackposition+=header[0x34+curtrack]*256;
                                if (currenttrackposition>ctrlsize) {
                                        printf(KERROR"Track %d side %d is declared as %04X bytes long but there is only %04X remaining\n"KNORMAL,t,face,header[0x34+curtrack]*256,ctrlsize-(currenttrackposition-header[0x34+curtrack]*256));
                                }

                                if (strncmp((char *)data+i,"Track-Info\r\n",12)) {
                                        printf(KERROR"Invalid track information block side %d track %d => Header offset=%d\n",face,t,header[0x34+curtrack]*256);
                                        exit(ABORT_ERROR);
                                }
                                sectornumber=data[i+21];
                                track_sectorsize=data[i+20];
                                gap3=data[i+22];
                                filler=data[i+23];

                                // track info
                                edsk->track[curtrack].sectornumber=sectornumber;
                                edsk->track[curtrack].sectorsize=track_sectorsize;
                                edsk->track[curtrack].gap3length=gap3;
                                edsk->track[curtrack].fillerbyte=filler;
                                edsk->track[curtrack].datarate=data[i+18];
                                edsk->track[curtrack].recordingmode=data[i+19];
                                // sector structs
                                edsk->track[curtrack].sector=MemMalloc(sizeof(struct s_edsk_sector_global_struct)*sectornumber);
                                memset(edsk->track[curtrack].sector,0,sizeof(struct s_edsk_sector_global_struct)*sectornumber);

                                if (track_sectorsize!=2 || sectornumber!=9) {
                                        special=1;
                                }

                                //printf("G%02X F%02X NBS=%02d : ",gap3,filler,sectornumber);

                                is_data=is_vendor=0;
                                for (s=0;s<sectornumber;s++) {

                                        sectorid=data[i+24+8*s+2];
                                        sectorsize=data[i+24+8*s+3];
                                        // ST1 & ST2 indicates wrong checksum, ...
                                        ST1=data[i+24+8*s+4];
                                        ST2=data[i+24+8*s+5];
                                        reallength=data[i+24+8*s+6]+data[i+24+8*s+7]*256; /* real length stored */

                                        edsk->track[curtrack].sector[s].track=data[i+24+8*s+0];
                                        edsk->track[curtrack].sector[s].side=data[i+24+8*s+1];
                                        edsk->track[curtrack].sector[s].id=sectorid;
                                        edsk->track[curtrack].sector[s].size=sectorsize;
                                        edsk->track[curtrack].sector[s].st1=ST1;
                                        edsk->track[curtrack].sector[s].st2=ST2;
                                        edsk->track[curtrack].sector[s].length=reallength;
                                        edsk->track[curtrack].sector[s].data=MemMalloc(reallength);

                                        if (currentsectorposition+reallength>ctrlsize) {
                                                printf(KERROR"Invalid side %d track %d => sector data of ID %02X outside EDSK!\n",face,t,sectorid);
                                                exit(ABORT_ERROR);
                                        } else {
                                                memcpy(edsk->track[curtrack].sector[s].data,&data[currentsectorposition],reallength);
                                        }
                                        currentsectorposition+=reallength;
                                }
                        }
                }
        } else if (strncmp(header,"MV - CPC",8)==0) {
                printf("opening legacy DSK [%s] / creator: %-14.14s\n",edskfilename,header+34);

                tracknumber=header[34+14];
                sidenumber=header[34+14+1];
                edsk->tracknumber=tracknumber;
                edsk->sidenumber=sidenumber;
                tracksize=header[34+14+1+1]+header[34+14+1+1+1]*256;

                printf("tracks: %d sides: %d ",edsk->tracknumber,edsk->sidenumber);
                printf("track size: %dkb disk size: %dkb\n",tracksize/1024,tracksize*edsk->tracknumber*edsk->sidenumber/1024);

                data=MemMalloc(tracksize*edsk->tracknumber*edsk->sidenumber);
                if (fread(data,1,tracksize*edsk->tracknumber*edsk->sidenumber,f)!=tracksize*edsk->tracknumber*edsk->sidenumber) {
                        printf("Cannot read DSK tracks!");
                        return NULL;
                }

                edsk->track=MemMalloc(sizeof(struct s_edsk_track_global_struct)*tracknumber*sidenumber);
                memset(edsk->track,0,sizeof(struct s_edsk_track_global_struct)*tracknumber*sidenumber);
                for (t=0;t<edsk->tracknumber;t++) {
                        for (face=0;face<edsk->sidenumber;face++) {
                                int maxsectorsize;
                                curtrack=t*edsk->sidenumber+face;

                                i=(t*edsk->sidenumber+face)*tracksize;
                                if (strncmp(data+i,"Track-Info\r\n",12)) {
                                        printf("Invalid track information block side %d track %d",face,t);
                                        return NULL;
                                }
                                edsk->track[curtrack].sectornumber=sectornumber=data[i+21];
                                edsk->track[curtrack].sectorsize=data[i+20];
                                edsk->track[curtrack].gap3length=data[i+22];
                                edsk->track[curtrack].fillerbyte=data[i+23];
                                edsk->track[curtrack].datarate=0;
                                edsk->track[curtrack].recordingmode=0;
                                reallength=0;
                                for (s=0;s<edsk->track[curtrack].sectornumber;s++) {
                                        switch (data[i+24+8*s+3]) {
                                                default:
                                                case 0:if (reallength<128) reallength=128;break;
                                                case 1:if (reallength<256) reallength=256;break;
                                                case 2:if (reallength<512) reallength=512;break;
                                                case 3:if (reallength<1024) reallength=1024;break;
                                                case 4:if (reallength<2048) reallength=2048;break;
                                                case 5:if (reallength<4096) reallength=4096;break;
                                                case 6:if (reallength<0x1800) reallength=0x1800;break;
                                        }
                                }
                                maxsectorsize=reallength;
				edsk->track[curtrack].sector=MemMalloc(sizeof(struct s_edsk_sector_global_struct)*edsk->track[curtrack].sectornumber);
                                memset(edsk->track[curtrack].sector,0,sizeof(struct s_edsk_sector_global_struct)*sectornumber);
                                for (s=0;s<edsk->track[curtrack].sectornumber;s++) {
                                        edsk->track[curtrack].sector[s].track=data[i+24+8*s];
                                        edsk->track[curtrack].sector[s].side=data[i+24+8*s+1];
                                        edsk->track[curtrack].sector[s].id=data[i+24+8*s+2];
                                        edsk->track[curtrack].sector[s].size=data[i+24+8*s+3];
                                        edsk->track[curtrack].sector[s].st1=data[i+24+8*s+4];
                                        edsk->track[curtrack].sector[s].st2=data[i+24+8*s+5];

                                        switch (edsk->track[curtrack].sector[s].size) {
                                                default:
                                                case 0:reallength=128;break;
                                                case 1:reallength=256;break;
                                                case 2:reallength=512;break;
                                                case 3:reallength=1024;break;
                                                case 4:reallength=2048;break;
                                                case 5:reallength=4096;break;
                                                case 6:reallength=0x1800;break;
                                        }
                                        edsk->track[curtrack].sector[s].length=reallength;
                                        edsk->track[curtrack].sector[s].data=MemMalloc(reallength);
                                        memcpy(edsk->track[curtrack].sector[s].data,&data[i+0x100+s*maxsectorsize],reallength);
                                }
                        }
                }

        } else {
                printf(KERROR"file [%s] is not a valid EDSK floppy image\n",edskfilename);
                exit(ABORT_ERROR);
        }
        fclose(f);
        return edsk;
}

void edsktool_EDSK_write_file(struct s_edsk_global_struct *edsk, char *output_filename)
{
        unsigned char header[256]={0};
        unsigned char trackblock[256]={0};
        unsigned char headertag[25];
        int tracksize,curtrack;
        int idblock,blockoffset;
        int i,t,s,face;

        if (!edsk) return;

	FileRemoveIfExists(output_filename);

        /* écriture header */
        strcpy((char *)header,"EXTENDED CPC DSK File\r\nDisk-Info\r\n");
        sprintf(headertag,"%-9.9s","edskt");
        strcpy((char *)header+0x22,headertag);
        header[0x30]=edsk->tracknumber;
        header[0x31]=edsk->sidenumber;

        for (t=0;t<edsk->tracknumber;t++)
        for (face=0;face<edsk->sidenumber;face++) {
                curtrack=t*edsk->sidenumber+face;
                if (edsk->track[curtrack].unformated) {
                        tracksize=0;
                } else {
                        tracksize=256;
                        for (s=0;s<edsk->track[curtrack].sectornumber;s++) {
                                tracksize+=edsk->track[curtrack].sector[s].length;
                        }
                        if (tracksize&0xFF) tracksize+=256; // adjust high byte value
                }
                header[0x34+curtrack]=tracksize>>8;
        }

	FileWriteBinary(output_filename,(char*)header,256);

        /* écriture des pistes */
        for (t=0;t<edsk->tracknumber;t++)
        for (face=0;face<edsk->sidenumber;face++) {
                curtrack=t*edsk->sidenumber+face;

                if (edsk->track[curtrack].unformated) continue; // no physical information for unformated track
                strcpy((char *)trackblock,"Track-Info\r\n");
                trackblock[0x10]=t;
                trackblock[0x11]=face;
                trackblock[0x12]=edsk->track[curtrack].datarate;
                trackblock[0x13]=edsk->track[curtrack].recordingmode;
                trackblock[0x14]=edsk->track[curtrack].sectorsize;
                trackblock[0x15]=edsk->track[curtrack].sectornumber;
                trackblock[0x16]=edsk->track[curtrack].gap3length;
                trackblock[0x17]=edsk->track[curtrack].fillerbyte;

                for (s=0;s<edsk->track[curtrack].sectornumber;s++) {
                        trackblock[0x18+s*8+0]=edsk->track[curtrack].sector[s].track;
                        trackblock[0x18+s*8+1]=edsk->track[curtrack].sector[s].side;
                        trackblock[0x18+s*8+2]=edsk->track[curtrack].sector[s].id;
                        trackblock[0x18+s*8+3]=edsk->track[curtrack].sector[s].size;
                        trackblock[0x18+s*8+4]=edsk->track[curtrack].sector[s].st1;
                        trackblock[0x18+s*8+5]=edsk->track[curtrack].sector[s].st2;
                        trackblock[0x18+s*8+6]=edsk->track[curtrack].sector[s].length&0xFF;
                        trackblock[0x18+s*8+7]=(edsk->track[curtrack].sector[s].length>>8)&0xFF;
                }
		FileWriteBinary(output_filename,(char*)trackblock,256);

                tracksize=0;
                for (s=0;s<edsk->track[curtrack].sectornumber;s++) {
			FileWriteBinary(output_filename,(char*)edsk->track[curtrack].sector[s].data,edsk->track[curtrack].sector[s].length);
                        tracksize+=edsk->track[curtrack].sector[s].length;
                }
                // filler
                if (tracksize&0xFF) {
                        char filler[256]={0};
                        tracksize=((tracksize+256)&0xFF00)-tracksize;
			FileWriteBinary(output_filename,(char*)filler,tracksize);
                }
        }
#if TRACE_EDSK
        printf(KIO"Write edsk file %s\n",output_filename);
#endif
	FileWriteBinaryClose(output_filename);
}

int __edsk_get_side_from_name(char *w) {
	int l;
	l=strlen(w)-2;
	if (l<1) return 0;
	if (w[l]!=':') return 0;
	switch (w[l+1]) {
		case 'a':case 'A':case '0':w[l]=0;return 0;break;
		case 'b':case 'B':case '1':w[l]=0;return 1;break;
		default:break;
	}
	return 0;
}
// side if freed but EDSK is NOT reorganised!!!! _internal use for Merging or global free!
void __internal_edsk_free_side(struct s_assenv *ae,struct s_edsk_global_struct *edsk, int side) {
	int i,j;

	if (side && edsk->sidenumber<2) {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Invalid EDSK side!\n");
		return;
	}

	for (i=0;i<edsk->tracknumber;i++) {
		if (edsk->track[i*edsk->sidenumber+side].unformated) {
			// nothing to free
		} else {
			for (j=0;j<edsk->track[i*edsk->sidenumber+side].sectornumber;j++) {
				// free sector data
				MemFree(edsk->track[i*edsk->sidenumber+side].sector[j].data);
			}
			// free sector list
			MemFree(edsk->track[i*edsk->sidenumber+side].sector);
		}
	}
}
void __edsk_free(struct s_assenv *ae,struct s_edsk_global_struct *edsk) {
	if (edsk->sidenumber>1) __internal_edsk_free_side(ae,edsk,1);
	__internal_edsk_free_side(ae,edsk,0);
	MemFree(edsk->track);
	MemFree(edsk);
}

/*********************************************************************************
 * location is a string defining one or more tracks/sectors
 * split each location with a space
 * split track from sectors with a :
 * interval definition is possible with a dash
*********************************************************************************/
struct s_edsk_location *__edsk_get_location(struct s_assenv *ae,char *location, int *ret_nblocation) {
	struct s_edsk_location *locations=NULL;
	struct s_edsk_location curlocation;
	char *duploc;
	int nblocation=0,maxlocation=0;
	int strack,etrack,ssect,esect,lidx,retidx;
	// parsing
	char **split_location;
	char *split_interval;
	char *sectorlist;
	int idxl=0;
	int i,itr,isc;

	if (!ret_nblocation) return NULL;

	if (location && location[0] && location[1] && StringIsQuote(location)) duploc=TxtStrDup(location+1); else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Internal error edsk_get_location, please contact me\n");
		*ret_nblocation=0;
		return NULL;
	}
	duploc[strlen(duploc)-1]=0;
	for (i=0;duploc[i];i++) if (duploc[i]>='a' && duploc[i]<='z') duploc[i]+='A'-'a'; // toupper!
	split_location=TxtSplitWithChar(duploc,' '); // split each locations

	while (split_location[idxl]) {
//printf("parsing [%s]\n",split_location[idxl]);

		memset(&curlocation,0,sizeof(curlocation));
		// split track from sectors
		sectorlist=strchr(split_location[idxl],':');
		if (sectorlist) {
			*sectorlist=0;
//printf("tracklist [%s] sectorlist [%s]\n",split_location[idxl],sectorlist+1);
		}
		// process track interval
		if ((split_interval=strchr(split_location[idxl],'-'))!=NULL) {
			*split_interval=0;
			strack=RoundComputeExpression(ae,split_location[idxl],0,0,0);
			*split_interval='-'; // get back to original string
			etrack=RoundComputeExpression(ae,split_interval+1,0,0,0);
		} else {
			strack=RoundComputeExpression(ae,split_location[idxl],0,0,0);
			etrack=strack;
		}
		// check
		if (etrack<strack) {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Location [%s] interval definition error (see documentation)\n",split_location[idxl]);
			*ret_nblocation=0;
			return NULL;
		}
		if (sectorlist) {
			*sectorlist=':'; // get back to original string
			sectorlist++;
		}
		// process sectors if declared
		if (sectorlist && *sectorlist) {
			if ((split_interval=strchr(sectorlist,'-'))!=NULL) {
				*split_interval=0;
				ssect=RoundComputeExpression(ae,sectorlist,0,0,0);
				*split_interval='-'; // get back to original string
				esect=RoundComputeExpression(ae,split_interval+1,0,0,0);
			} else {
				ssect=RoundComputeExpression(ae,sectorlist,0,0,0);
				esect=ssect;
			}
			// check
			if (esect<ssect) {
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Location [%s] interval definition error (see documentation)\n",split_location[idxl]);
				*ret_nblocation=0;
				return NULL;
			}
		} else {
			// full range!
			ssect=-1;
			esect=256;
		}

		// add locations
		for (itr=strack;itr<=etrack;itr++) {
			curlocation.track=itr;
			if (ssect>=0 && ssect<256 && esect>=0 && esect<256) {
				curlocation.istrack=0;
				for (isc=ssect;isc<=esect;isc++) {
					curlocation.sectorID=isc;
					ObjectArrayAddDynamicValueConcat((void**)&locations,&nblocation,&maxlocation,&curlocation,sizeof(curlocation));
				}
			} else {
				curlocation.istrack=1;
				curlocation.sectorID=-1;
				ObjectArrayAddDynamicValueConcat((void**)&locations,&nblocation,&maxlocation,&curlocation,sizeof(curlocation));
			}
		}
		idxl++;
	}
#if TRACE_EDSK
	for (idxl=0;idxl<nblocation;idxl++) {
		printf("location[%d] istrack=%d track=%d sectorid=#%02X\n",idxl,locations[idxl].istrack,locations[idxl].track,locations[idxl].sectorID);
	}
#endif
	*ret_nblocation=nblocation;
	return locations;
}


/********************************************************************************************************
 *                immediate EDSK actions
********************************************************************************************************/

void __edsk_readsect(struct s_assenv *ae, struct s_edsk_action *action) {
	struct s_edsk_global_struct *edsk;
	struct s_edsk_location *location;
	int side,sizetoread,nblocation;
	int i,curtrack,s,j;

	side=__edsk_get_side_from_name(action->filename);

	if (action->nbparam!=4) {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Usage is : EDSK READSECT,'edskfilename:side',<location>,<sizetoread>   param=%d\n",action->nbparam);
		return;
	}
	// param 3 is location
	location=__edsk_get_location(ae,ae->wl[ae->idx+3].w,&nblocation);
	if (!location) {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"EDSK READSECT error, invalid location!\n");
		return;
	}
	// param 4 is exactsize
	sizetoread=RoundComputeExpression(ae,ae->wl[ae->idx+4].w,ae->outputadr,0,0);
	if (sizetoread<1) {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"EDSK READSECT error, invalid size to read!\n");
		return;
	}

	// now we can read the EDSK
	edsk=edsktool_EDSK_load(action->filename);
	if (!edsk) {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"EDSK READSECT error, invalid floppy image!\n");
		return;
	}

	if (side+1>edsk->sidenumber) {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"EDSK READSECT error, cannot read side B as the floppy image does not contain two sides!\n");
		return;
	}

	// then read the data!
	for (i=0;i<nblocation;i++) {
		if (location[i].track<edsk->tracknumber) {
			curtrack=location[i].track*edsk->sidenumber+side;
			// check
			if (edsk->track[curtrack].unformated) {
				MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"EDSK READSECT error, cannot read track %d because it's not formated!\n",location[i].track);
				return;
			}

			if (location[i].istrack) {
				// output every data of the track!
				for (s=0;s<edsk->track[curtrack].sectornumber;s++) {
					for (j=0;j<edsk->track[curtrack].sector[s].length && sizetoread;j++) {
						___output(ae,edsk->track[curtrack].sector[s].data[j]);
						sizetoread--;
					}
				}
			} else {
				int sector_was_found=0;
				for (s=0;s<edsk->track[curtrack].sectornumber;s++) {
					if (edsk->track[curtrack].sector[s].id==location[i].sectorID) {
						// output sector data
						for (j=0;j<edsk->track[curtrack].sector[s].length && sizetoread;j++) {
							___output(ae,edsk->track[curtrack].sector[s].data[j]);
							sizetoread--;
						}
						// if we break, we wont be able to read multiple sectors with the same ID
						sector_was_found=1;
					}
				}
				// warn if sector was not found
				if (!sector_was_found) {
					rasm_printf(ae,KWARNING"[%s:%d] Warning: EDSK READSECT sector #%02X was not found on track %d\n",GetCurrentFile(ae),ae->wl[ae->idx].l,location[i].sectorID,location[i].track);
					if (ae->erronwarn) MaxError(ae);
				}
			}
		} else {
			MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"EDSK READSECT error, cannot read track %d as the floppy image contains only %d track(s)!\n",location[i].track,edsk->tracknumber);
			return;
		}
	}
	// release edsk
	__edsk_free(ae,edsk);
}

void __edsk_create(struct s_assenv *ae, struct s_edsk_action *action) {
	struct s_edsk_global_struct *edsk;
	char *format;
	int nbtrack=42;
	int nbside,interlaced=0,overwrite=0;
	int i,t,s,sect;

	nbside=__edsk_get_side_from_name(action->filename);
#if TRACE_EDSK
	printf("edsk [%s] side %d\n",action->filename,nbside);
#endif
	switch (nbside) {
		default:
		case 0:nbside=1;break;
		case 1:break;
		case 2:break;
	}

	if (action->nbparam<3) {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Usage is : EDSK CREATE,'edskfilename:nbside',DATA|VENDOR|UNFORMATED[,<nbtrack>|INTERLACED|OVERWRITE,...\n");
		return;
	}
	// get extra param
	for (i=4;i<=action->nbparam;i++) {
		if (strcmp(ae->wl[ae->idx+i].w,"INTERLACED")==0) interlaced=1; else 
		if (strcmp(ae->wl[ae->idx+i].w,"OVERWRITE")==0) overwrite=1; else 
			nbtrack=RoundComputeExpression(ae,ae->wl[ae->idx+i].w,ae->outputadr,0,0);
	}
	format=ae->wl[ae->idx+3].w;

#if TRACE_EDSK
	printf("edsk [%s] side=%d nbtrack=%d format=%s\n",action->filename,nbside,nbtrack,format);
#endif

        if (strcmp(format,"DATA")==0 || strcmp(format,"VENDOR")==0 || strcmp(format,"UNFORMATED")==0) {
		edsk=MemMalloc(sizeof(struct s_edsk_global_struct));
		memset(edsk,0,sizeof(struct s_edsk_global_struct));

                edsk->tracknumber=nbtrack;
                edsk->sidenumber=nbside;
                edsk->track=MemMalloc(sizeof(struct s_edsk_track_global_struct)*edsk->tracknumber*edsk->sidenumber);
                memset(edsk->track,0,sizeof(struct s_edsk_track_global_struct)*edsk->tracknumber*edsk->sidenumber);

		if (strcmp(format,"UNFORMATED")==0) {
			for (s=0;s<nbside;s++)
			for (t=0;t<nbtrack;t++) {
				edsk->track[t*nbside+s].unformated=1;
			}
		} else {
			unsigned char data_inline[9]={0xC1,0xC2,0xC3,0xC4,0xC5,0xC6,0xC7,0xC8,0xC9};
			unsigned char data_inter[9]={0xC1,0xC6,0xC2,0xC7,0xC3,0xC8,0xC4,0xC9,0xC5};
			unsigned char vendor_inline[9]={0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49};
			unsigned char vendor_inter[9]={0x41,0x46,0x42,0x47,0x43,0x48,0x44,0x49,0x45};
			unsigned char *sectid;

			if (strcmp(format,"DATA")==0)   if (interlaced) sectid=data_inter; else sectid=data_inline;
			if (strcmp(format,"VENDOR")==0) if (interlaced) sectid=vendor_inter; else sectid=vendor_inline;

                	for (s=0;s<nbside;s++)
			for (t=0;t<nbtrack;t++) {
				edsk->track[t*nbside+s].track=t;
				edsk->track[t*nbside+s].side=0;
				edsk->track[t*nbside+s].sectornumber=9;
				edsk->track[t*nbside+s].sectorsize=2;
				edsk->track[t*nbside+s].gap3length=0x50;
				edsk->track[t*nbside+s].fillerbyte=0xE5;
				edsk->track[t*nbside+s].sector=MemMalloc(edsk->track[t*nbside+s].sectornumber*sizeof(struct s_edsk_sector_global_struct));
				for (sect=0;sect<9;sect++) {
					edsk->track[t*nbside+s].sector[sect].track=t;
					edsk->track[t*nbside+s].sector[sect].side=0;
					edsk->track[t*nbside+s].sector[sect].id=sectid[sect];
					edsk->track[t*nbside+s].sector[sect].size=2;
					edsk->track[t*nbside+s].sector[sect].st1=0;
					edsk->track[t*nbside+s].sector[sect].st2=0;
					edsk->track[t*nbside+s].sector[sect].length=512;
					edsk->track[t*nbside+s].sector[sect].data=MemMalloc(edsk->track[t*nbside+s].sector[sect].length);
					for (i=0;i<edsk->track[t*nbside+s].sector[sect].length;i++) edsk->track[t*nbside+s].sector[sect].data[i]=edsk->track[t*nbside+s].fillerbyte;
				}
			}
		}
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Usage is : EDSK CREATE,'edskfilename',DATA|VENDOR|UNFORMATED,nbtrack|INTERLACED|OVERWRITE,...\n");
		return;
	}

	if (FileExists(action->filename) && !overwrite) {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Cannot create [%s] as it already exists (you may use OVERWRITE tag)\n",action->filename);
		return;
	}
	edsktool_EDSK_write_file(edsk,action->filename);
	rasm_printf(ae,KIO"New EDSK [%s] created\n",action->filename);
	__edsk_free(ae,edsk);
}

void __edsk_upgrade(struct s_assenv *ae, struct s_edsk_action *action) {
	struct s_edsk_global_struct *edsk;
	// load and save, in case of DSK, you will get a fresh EDSK
	edsk=edsktool_EDSK_load(action->filename);
	if (edsk) {
		edsktool_EDSK_write_file(edsk,action->filename2);
		__edsk_free(ae,edsk);
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Error loading [%s]\n",action->filename);
	}
}


/********************************************************************************************************
 *                deferred EDSK actions
********************************************************************************************************/

void __edsk_map(struct s_assenv *ae, struct s_edsk_action *action) {
	struct s_edsk_global_struct *edsk;
	edsk=edsktool_EDSK_load(action->filename);
	if (edsk) {
		if (!ae->flux) edsktool_MAPEDSK(edsk);
		__edsk_free(ae,edsk);
	} else {
		MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Error loading [%s]\n",action->filename);
	}
}

void __edsk_merge(struct s_assenv *ae, struct s_edsk_action *action) {
	struct s_edsk_global_struct *edsk1,*edsk2;
	char *floppy1,*floppy2,*floppyres;
	int side1,side2,i,j;
	// merge data
	struct s_edsk_track_global_struct *newtracks;
	int maxtrack;

	floppy1=action->filename;
	floppy2=action->filename2;
	floppyres=action->filename3;
	side1=__edsk_get_side_from_name(floppy1);
	side2=__edsk_get_side_from_name(floppy2);

	edsk1=edsktool_EDSK_load(floppy1);
	edsk2=edsktool_EDSK_load(floppy2);
	if (side1 && edsk1->sidenumber<2) { MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Cannot merge EDSK because floppy image [%s] does not have 2 sides\n",floppy1); return; }
	if (side2 && edsk2->sidenumber<2) { MakeError(ae,ae->idx,GetCurrentFile(ae),ae->wl[ae->idx].l,"Cannot merge EDSK because floppy image [%s] does not have 2 sides\n",floppy2); return; }

	// merged DSK will get the maximum track number
	if (edsk1->tracknumber>edsk2->tracknumber) maxtrack=edsk1->tracknumber; else maxtrack=edsk2->tracknumber;
	newtracks=MemMalloc(sizeof(struct s_edsk_track_global_struct)*maxtrack*2);
	memset(newtracks,0,sizeof(struct s_edsk_track_global_struct)*maxtrack*2);
	// copy track from requested sides
	for (i=0;i<edsk1->tracknumber;i++) newtracks[i*2]=edsk1->track[i*edsk1->sidenumber+side1];
	for (i=0;i<edsk2->tracknumber;i++) newtracks[i*2+1]=edsk2->track[i*edsk2->sidenumber+side2];
	// new tracks are unformated
	for (i=edsk1->tracknumber;i<maxtrack;i++) newtracks[i*2].unformated=1;
	for (i=edsk2->tracknumber;i<maxtrack;i++) newtracks[i*2+1].unformated=1;
	// free unused sides
	if (edsk1->sidenumber) __inte