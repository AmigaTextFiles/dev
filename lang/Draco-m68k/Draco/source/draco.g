char
    VERSION1 = '1',
    VERSION2 = '3',
    DATE1 = '9',
    DATE2 = '1';

bool
    IS_BETA = false,		/* true -> beta test version */
    GOTCOPY = true ;		/* true -> copyright protection installed */

uint
    ALIGN = 2;			/* alignment required for non-bytes */

/*
uint
    PBSIZE = 25000,		/* size of code/symbol buffer */
    SYSIZE = 2047,		/* size of symbol table */
    CBSIZE = 10000,		/* size of constant buffer */
    CTSIZE = 1000,		/* size of constant table */
    DTSIZE = 20,		/* size of descriptor table */
    GRTSIZE = 200,		/* size of globals relocation table */
    FRTSIZE = 200,		/* size of file statics relocation table */
    LRTSIZE = 1,		/* size of static locals relocation table */
    PRTSIZE = 500,		/* size of program label relocation table */
    CASESIZE = 300,		/* size of case alternative table */
    BRANCHSIZE = 250,		/* size of branch chain table */
    TTSIZE = 1000,		/* size of type table (> 256) */
    TITSIZE = 6000,		/* size of type info table */
    RSTKSIZE = 20,		/* size of register type stack */
    OPPARSIZE = 20,		/* size of table for operator type pars */
    IBUFFSIZE = 512 * 10;	/* size of input text buffer */
*/
uint
    PBSIZE = 65500,		/* size of code/symbol buffer */
    SYSIZE = 4095,		/* size of symbol table */
    CBSIZE = 20000,		/* size of constant buffer */
    CTSIZE = 2000,		/* size of constant table */
    DTSIZE = 40,		/* size of descriptor table */
    GRTSIZE = 400,		/* size of globals relocation table */
    FRTSIZE = 400,		/* size of file statics relocation table */
    LRTSIZE = 1,		/* size of static locals relocation table */
    PRTSIZE = 1000,		/* size of program label relocation table */
    CASESIZE = 600,		/* size of case alternative table */
    BRANCHSIZE = 500,		/* size of branch chain table */
    TTSIZE = 2000,		/* size of type table (> 256) */
    TITSIZE = 12000,		/* size of type info table */
    RSTKSIZE = 40,		/* size of register type stack */
    OPPARSIZE = 40,		/* size of table for operator type pars */
    IBUFFSIZE = 512 * 10;	/* size of input text buffer */

uint
    FLOAT_DIGITS = 17,		/* number of decimal digits in float const */
    FLOAT_BYTES = 8;		/* number of bytes in float const */

type

    /* codes for kinds of types: */

    TYPEKIND = enum {
	TY_POINTER,		/* a pointer type */
	TY_ENUM,		/* an enumeration type */
	TY_UNSIGNED,		/* an unsigned numeric type */
	TY_SIGNED,		/* a signed numeric type */
	TY_FILE,		/* a file type (buffer and counts, etc.) */
	TY_CHANNEL,		/* a channel type (text/binary/in/out) */
	TY_UNKNOWN,		/* a special unknown type (length known) */
	TY_STRUCT,		/* a structure type */
	TY_ARRAY,		/* an array type */
	TY_OP,			/* an operator type */
	TY_PROC,		/* a procedure type */
	TY_SPECIAL,		/* special type - byte, float */
	TY_UNDEFINED,		/* a type not yet defined */
	TY_NAMED		/* a named type - refers to another */
    },

    /* flags for the two types of array dimension entries: */

    ARRAYKIND = enum {
	AR_FIXED,
	AR_FLEX
    },

    /* the type of a type, as it is used in descriptors: */

    TYPENUMBER = unsigned TTSIZE,

    /* the structure of an entry in the symbol table: */

    SYMBOL = struct {
	ushort sy_kind;
	TYPENUMBER sy_type;
	*char sy_name;
	union {
	    ulong sy_ulong;
	    uint sy_uint;
	    ushort sy_reg;
	} sy_value;
    },

    /* the structure of an array dimension in the type info data: */

    ARRAYDIM = struct {
	ARRAYKIND ar_kind;
	ulong ar_dim;
    },

    /* the structure of an array in the type info data: */

    ARRAYDESC = struct {
	TYPENUMBER ar_baseType;
	ushort ar_dimCount;
	[1] ARRAYDIM ar_dims;
    },

    /* the structure of a struct/union in the type info data: */

    STRUCTDESC = struct {
	ulong st_size;
	ushort st_fieldCount;
	[1] *SYMBOL st_fields;
    },

    /* the structure of a proc type in the type info data: */

    PROCDESC = struct {
	TYPENUMBER p_resultType;
	ushort p_parCount;
	[1] TYPENUMBER p_parTypes;
    },

    /* the structure of an operator type in the type info data: */

    OPDESC = struct {
	uint op_ops;
	TYPENUMBER op_baseType;
	[2] char op_name;
    },

    /* the united type for a type info value: */

    INFOTYPE = union {
	uint i_uint;
	TYPENUMBER i_type;
	*byte i_ptr;
	*ARRAYDESC i_array;
	*STRUCTDESC i_struct;
	*PROCDESC i_proc;
	*OPDESC i_op;
	ulong i_range;
	ulong i_ulong;
	struct {
	    bool i_input;
	    bool i_text;
	} i_channel;
    },

    /* the structure of an entry in the type table: */

    TTENTRY = struct {
	TYPEKIND t_kind;
	ushort t_align;
	INFOTYPE t_info;
    },

    /* the nature of a value in a descriptor: */

    VALUEKIND = enum {
	VERROR,
	VVOID,
	VPROC,
	VAPROC,
	VNUMBER,
	VCONST,
	VRVAR,
	VDVAR,
	VGVAR,
	VFVAR,
	VLVAR,
	VAVAR,
	VPAR,
	VREG,
	VINDIR,
	VCC,
	VFLOAT,
	VEXTERN
    },

    /* the possible values for a comparison result: */

    COMPARISONKIND = enum {
	VEQ,
	VNE,
	VGT,
	VLT,
	VGE,
	VLE,
	VGTS,
	VLTS,
	VGES,
	VLES
    },

    /* the structure of an entry in the constant table: */

    CTENT = struct {
	uint ct_use;
	*byte ct_value;
	uint ct_length;
    },

    /* the united type for a descriptor value field: */

    VALUETYPE = union {
	COMPARISONKIND v_comparison;
	ulong v_ulong;
	long v_long;
	ushort v_reg;
	*uint v_proc;
	*CTENT v_const;
	struct {
	    ulong v_offset;
	    ushort v_base;
	} v_indir;
	struct {
	    ulong ve_offset;	/* only handle 16 bits, but here for cheats */
	    *uint ve_chain;
	} v_extern;
	[FLOAT_BYTES] byte v_float;
    },

    /* the structure of a value descriptor: */

    DESCRIPTOR = struct {
	TYPENUMBER v_type;
	VALUETYPE v_value;
	VALUEKIND v_kind;
	ushort v_index; 	/* NOINDEX if none */
    },

    /* the structure of a relocation table entry: */

    RELOC = struct {
	ulong r_what;
	uint r_head;
    },

    /* the structure of an entry in the case alternative table: */

    CENTRY = struct {
	ulong c_index;
	*byte c_code;
    },

    /* the structure of an entry in the branch table: */

    BRENTRY = struct {
	uint br_destination;
	uint br_chain;
    },

    /* structure of a register queue element: */

    REGQUEUE = struct {
	*REGQUEUE r_next, r_prev;	/* next and prev in queue */
	uint r_reg;			/* register number */
	DESCRIPTOR r_desc;		/* what is in it if free */
    },

    /* structure used to save a code generation state for undoing: */

    STATE = struct {
	uint s_peepTotal;
	*ushort s_nextRegStack;
	[8] uint s_ARegUse, s_DRegUse;
	uint s_ARegValidCount, s_DRegValidCount;
	[8] REGQUEUE s_ARegQueue, s_DRegQueue;
	*REGQUEUE
	    s_ARegFreeHead, s_ARegFreeTail,
	    s_DRegFreeHead, s_DRegFreeTail,
	    s_ARegBusyHead, s_ARegBusyTail,
	    s_DRegBusyHead, s_DRegBusyTail;
    },

    /* enumeration used when getting an identifier: */

    IDKIND = enum {
	ID_UNDEFINED,			/* an id with no other definition */
	ID_DUMMY,			/* any id, it's ignored (proc hdr) */
	ID_TYPE,			/* id for a new type */
	ID_PROC 			/* id for a proc being defined */
    };

ushort
    NOINDEX = 255,			/* no index register in use */
    WORDINDEX = 0o10;			/* index value is 16 bit, not 32 */

uint
    RELOC_NULL = 0xffff,		/* end of a reloc chain */
    REF_NULL = 0xffff,			/* end of a reference chain */
    BRANCH_NULL = 0;			/* end of a branch chain */

/* flag bits for the operators defined for an operator type: */

uint
    OPADD = 0b0000000000000001,
    OPSUB = 0b0000000000000010,
    OPMUL = 0b0000000000000100,
    OPDIV = 0b0000000000001000,
    OPMOD = 0b0000000000010000,
    OPNEG = 0b0000000000100000,
    OPABS = 0b0000000001000000,
    OPIOR = 0b0000000010000000,
    OPAND = 0b0000000100000000,
    OPXOR = 0b0000001000000000,
    OPSHL = 0b0000010000000000,
    OPSHR = 0b0000100000000000,
    OPNOT = 0b0001000000000000,
    OPCPR = 0b0010000000000000,
    OPPUT = 0b0100000000000000,
    OPGET = 0b1000000000000000;

/* the special types known to the compiler: */

TYPENUMBER
    TYUNKNOWN = 1,		/* don't know the type - is expression */
    TYERROR = 2,		/* had previous error - don't complain */
    TYIORESULT = 3,		/* void or bool as needed */
    TYVOID = 5, 		/* statement - no result */
    TYNIL = 6,			/* special type for 'nil' */
    TYBOOL = 8, 		/* enum {false, true} */
    TYCHAR = 10,		/* enum of all chars */
    TYBYTE = 12,		/* special - 1 byte unsigned numeric */
    TYUSHORT = 14,		/* unsigned short integer */
    TYSHORT = 16,		/* signed short integer */
    TYUINT = 18,		/* unsigned integer */
    TYINT = 20, 		/* signed integer */
    TYCHARS = 21,		/* pointer to character */
    TYLONG = 23,		/* signed long integer */
    TYULONG = 25,		/* unsigned long integer */
    TYFLOAT = 27;		/* floating point number */

byte

/* codes for the types of constants in the constant table: */

    C_TABLE = 0x00,
    C_INLINE = 0x01,

/* codes for the 'kind' field in symbol table entries: */
	
/* the top two bits are used for the level of declaration: */
	
    BB = 0xc0,

    B_SYS = 0x00,			/* system symbol, e.g. 'int' */
    B_GLOBAL = 0x40,			/* global from include file */
    B_FILE = 0x80,			/* file global symbol */
    B_LOCAL = 0xc0,			/* local to a given proc */

/* the rest of the bits are used for the nature of the symbol: */
	
    MMMMMM = 0x3f,

    MFREE	= 0,
    MUNDEF	= MFREE 	+ 1,
    MKEYW	= MUNDEF	+ 1,
    MPROC	= MKEYW 	+ 1,
    MEPROC	= MPROC 	+ 1,
    MAPROC	= MEPROC	+ 1,
    MNUMBER	= MAPROC	+ 1,
    MCONST	= MNUMBER	+ 1,
    MRVAR	= MCONST	+ 1,
    MDVAR	= MRVAR 	+ 1,
    MGVAR	= MDVAR 	+ 1,
    MFVAR	= MGVAR 	+ 1,
    MLVAR	= MFVAR 	+ 1,
    MAVAR	= MLVAR 	+ 1,
    MPAR	= MAVAR 	+ 1,
    MFIELD	= MPAR		+ 1,
    MTYPE	= MFIELD	+ 1,
    MEXTERN	= MTYPE 	+ 1;

/* the various special values for tokens: */

ushort
    TEOF	= 0,
    TOKERR	= TEOF		+ 1,
    TNUMBER	= TOKERR	+ 1,
    TCHAR	= TNUMBER	+ 1,
    TCHARS	= TCHAR 	+ 1,
    TLNUM	= TCHARS	+ 1,
    TFNUM	= TLNUM 	+ 1,
    TID 	= TFNUM 	+ 1,

    TNE 	= TID		+ 1,
    TLE 	= TNE		+ 1,
    TGE 	= TLE		+ 1,
    TASS	= TGE		+ 1,
    TSHL	= TASS		+ 1,
    TSHR	= TSHL		+ 1,
    TXOR	= TSHR		+ 1,
    TDOTDOT	= TXOR		+ 1,

    TSIGNED	= 128,
    TUNSIGNED	= TSIGNED	+ 1,
    TENUM	= TUNSIGNED	+ 1,
    TSTRUCT	= TENUM 	+ 1,
    TUNION	= TSTRUCT	+ 1,
    TUNKNOWN	= TUNION	+ 1,
    TFILE	= TUNKNOWN	+ 1,
    TCHANNEL	= TFILE 	+ 1,

    TTEXT	= TCHANNEL	+ 1,
    TBINARY	= TTEXT 	+ 1,
    TTYPE	= TBINARY	+ 1,
    TEXTERN	= TTYPE 	+ 1,
    TPUBLIC	= TEXTERN	+ 1,
    TPRIVATE	= TPUBLIC	+ 1,
    TREGISTER	= TPRIVATE	+ 1,

    TAND	= TREGISTER	+ 1,
    TOR 	= TAND		+ 1,
    TTHEN	= TOR		+ 1,
    TFROM	= TTHEN 	+ 1,
    TUPTO	= TFROM 	+ 1,
    TDOWNTO	= TUPTO 	+ 1,
    TBY 	= TDOWNTO	+ 1,

    TNIL	= TBY		+ 1,
    TDIM	= TNIL		+ 1,
    TSIZEOF	= TDIM		+ 1,
    TRANGE	= TSIZEOF	+ 1,
    TMAKE	= TRANGE	+ 1,
    TINPUT	= TMAKE 	+ 1,
    TNEW	= TINPUT	+ 1,
    TIOERROR	= TNEW		+ 1,
    TNOT	= TIOERROR	+ 1,

    TIF 	= TNOT		+ 1,
    TCASE	= TIF		+ 1,
    TPRETEND	= TCASE 	+ 1,
    TOPEN	= TPRETEND	+ 1,
    TCLOSE	= TOPEN 	+ 1,
    TREAD	= TCLOSE	+ 1,
    TREADLN	= TREAD 	+ 1,
    TWRITE	= TREADLN	+ 1,
    TWRITELN	= TWRITE	+ 1,

    TPROC	= TWRITELN	+ 1,
    TCORP	= TPROC 	+ 1,
    TELIF	= TCORP 	+ 1,
    TELSE	= TELIF 	+ 1,
    TFI 	= TELSE 	+ 1,
    TDO 	= TFI		+ 1,
    TOD 	= TDO		+ 1,
    TINCASE	= TOD		+ 1,
    TDEFAULT	= TINCASE	+ 1,
    TFALLTHROUGH= TDEFAULT	+ 1,
    TESAC	= TFALLTHROUGH	+ 1,

    TWHILE	= TESAC 	+ 1,
    TFOR	= TWHILE	+ 1,
    TFREE	= TFOR		+ 1,
    TCODE	= TFREE 	+ 1,
    TIGNORE	= TCODE 	+ 1,
    TRETURN	= TIGNORE	+ 1,
    TERROR	= TRETURN	+ 1,

    TOUTPUT	= TERROR	+ 1,
    TMODULE	= TOUTPUT	+ 1,
    TIMPORT	= TMODULE	+ 1,
    TEXPORT	= TIMPORT	+ 1,
    TBOID	= TEXPORT	+ 1,
    TFIX	= TBOID 	+ 1,
    TFLT	= TFIX		+ 1,
    TCHIP	= TFLT		+ 1;

byte

    TMASK = 0x96;

/* hardware specifics - machine registers, op-codes, etc.: */

type OPTYPE = enum {
    OPT_SINGLE,
    OPT_REGISTER,
    OPT_SPECIAL,
    OPT_LOAD,
    OPT_STORE,
    OPT_QUICK,
    OPT_BRANCH,
    OPT_MODED,
    OPT_IMM,
    OPT_EA
};

ushort

    /* special registers and register limits */

    ARBOTTOM	= 0,			/* lowest physical A reg */
    ARLIMIT	= 1,			/* lowest allocatable A reg */
    ARTOP	= 5,			/* highest non-reserved A reg */
    RFP 	= 6,			/* the frame pointer */
    RSP 	= 7,			/* the stack pointer */
    DRBOTTOM	= 0,			/* lowest physical D reg */
    DRLIMIT	= 2,			/* lowest allocatable D reg */
    DRTOP	= 7;			/* highest non-reserved D reg */

byte

    /* addressing modes */

    M_DDIR	= 0o0,
    M_ADIR	= 0o1,
    M_INDIR	= 0o2,
    M_INC	= 0o3,
    M_DEC	= 0o4,
    M_DISP	= 0o5,
    M_INDEX	= 0o6,
    M_SPECIAL	= 0o7,

    /* "register" codes when mode = M_SPECIAL */

    M_ABSSHORT	= 0o0,
    M_ABSLONG	= 0o1,
    M_PCDISP	= 0o2,
    M_PCINDEX	= 0o3,
    M_IMM	= 0o4,
    M_SR	= 0o4;

byte

    /* op-mode values for binary ops */

    OM_REG	= 0b0 << 2,		/* dest is reg */
    OM_EA	= 0b1 << 2,		/* dest is EA */

    /* size values */

    S_BYTE	= 0b00,
    S_WORD	= 0b01,
    S_LONG	= 0b10,

    S_SADDR	= 0b011,
    S_LADDR	= 0b111;

    /* condition code values */

uint

    CC_T	= 0x0,
    CC_F	= 0x1,
    CC_HI	= 0x2,
    CC_LS	= 0x3,
    CC_HS	= 0x4,
    CC_CC	= 0x4,
    CC_LO	= 0x5,
    CC_CS	= 0x5,
    CC_NE	= 0x6,
    CC_EQ	= 0x7,
    CC_VC	= 0x8,
    CC_VS	= 0x9,
    CC_PL	= 0xa,
    CC_MI	= 0xb,
    CC_GE	= 0xc,
    CC_LT	= 0xd,
    CC_GT	= 0xe,
    CC_LE	= 0xf;

    /* opcodes */

uint

    OP_ORI	= 0x0000,		/* opSingle */
    OP_ANDI	= 0x0200,		/* opSingle */
    OP_SUBI	= 0x0400,		/* opSingle */
    OP_ADDI	= 0x0600,		/* opSingle */
    OP_BCHG	= 0x0840,		/* opSingle */
    OP_BCLR	= 0x0880,		/* opSingle */
    OP_BSET	= 0x08c0,		/* opSingle */
    OP_EORI	= 0x0a00,		/* opSingle */
    OP_CMPI	= 0x0c00,		/* opSingle */
    OP_MOVEB	= 0x1000,		/* opMove */
    OP_MOVEL	= 0x2000,		/* opMove */
    OP_MOVEW	= 0x3000,		/* opMove */
    OP_CLR	= 0x4200,		/* opSingle */
    OP_NEG	= 0x4400,		/* opSingle */
    OP_NOT	= 0x4600,		/* opSingle */
    OP_TST	= 0x4a00,		/* opSingle */
    OP_ADDQ	= 0x5000,		/* opQuick */
    OP_SUBQ	= 0x5100,		/* opQuick */
    OP_MOVEQ	= 0x7000,		/* opImm */
    OP_OR	= 0x8000,		/* opModed */
    OP_SUB	= 0x9000,		/* opModed */
    OP_CMP	= 0xb000,		/* opModed */
    OP_EOR	= 0xb100,		/* opModed, with limitations */
    OP_AND	= 0xc000,		/* opModed */
    OP_ADD	= 0xd000,		/* opModed */
    OP_SHIFT	= 0xe000;		/* opSpecial */

uint

    OP_EXT	= 0x4800,		/* opSpecial */
    OP_PEA	= 0x4840,		/* opEA */
    OP_SWAP	= 0x4840,		/* opSpecial */
    OP_SAVEM	= 0x48c0,		/* opSpecial */
    OP_RESTM	= 0x4cc0,		/* opSpecial */
    OP_LINK	= 0x4e50,		/* opSpecial */
    OP_UNLK	= 0x4e58,		/* opSpecial */
    OP_NOP	= 0x4e71,		/* opSpecial */
    OP_STOP	= 0x4e72,		/* opSpecial */
    OP_RTS	= 0x4e75,		/* opSpecial */
    OP_JSR	= 0x4e80,		/* opEA */
    OP_JMP	= 0x4ec0,		/* opEA */
    OP_LEA	= 0x41c0,		/* opRegister */
    OP_Scc	= 0x50c0,
    OP_DBcc	= 0x50c8,
    OP_Bcc	= 0x6000,
    OP_BSR	= 0x6100,
    OP_DIVU	= 0x80c0,		/* opRegister */
    OP_DIVS	= 0x81c0,		/* opRegister */
    OP_MULU	= 0xc0c0,		/* opRegister */
    OP_MULS	= 0xc1c0,		/* opRegister */
    OP_ILLEGAL	= 0x4afc;		/* opSpecial */

/* function offsets in IEEE floating point library */

int
    LVO_IEEEDP_FIX = -30,
    LVO_IEEEDP_FLT = -36,
    LVO_IEEEDP_CMP = -42,
    LVO_IEEEDP_ABS = -54,
    LVO_IEEEDP_NEG = -60,
    LVO_IEEEDP_ADD = -66,
    LVO_IEEEDP_SUB = -72,
    LVO_IEEEDP_MUL = -78,
    LVO_IEEEDP_DIV = -84;

/* variables */

[IBUFFSIZE] char
    MainBuff,				/* input buffer for normal mode */
    IncludeBuff;			/* input buffer during globals */
*[IBUFFSIZE] char SourceBuff;		/* pointer to current input buffer */

unsigned IBUFFSIZE
    SourcePos,				/* pos in current input buffer */
    SourceMax;				/* max pos in current input buffer */

*char
    Trap;				/* guess what this is for! */

/* keep here to keep aligned */
[FLOAT_BYTES] byte FloatValue;		/* floating point constant value */

ushort
    GlobARTop,				/* last free AFTER global regs */
    GlobDRTop,				/* last free AFTER global regs */
    ARTop,				/* last free address register */
    DRTop;				/* last free data register */

long
    DeclOffset, 			/* offset during declarations */
    ParSize;				/* size of proc parameters */

ulong
    IntValue,				/* numeric value from scanner */
    GlobalSize; 			/* size of global variables */

uint
    Line,				/* current Line in input file */
    OLine,				/* line for previous char */
    OOLine,				/* line for 2nd previous char */
    OldLine,				/* Line for previous token */
    PeepNext,				/* number of entries in peephole */
    PeepTotal,				/* number of instructions gen'd */
    OptCount,				/* number of optimizations done */
    RememberCount,			/* number loads saved */
    ShortenCount,			/* number of branches shortened */
    ConstLength;			/* length so far of constant */

[8] uint DRegUse, ARegUse;		/* use counts for registers */
[8] REGQUEUE DRegQueue, ARegQueue;	/* register queue elements */
*REGQUEUE
    DRegFreeHead, DRegFreeTail, 	/* queue of free data regs */
    ARegFreeHead, ARegFreeTail, 	/* queue of free address regs */
    DRegBusyHead, DRegBusyTail, 	/* queue of busy data regs */
    ARegBusyHead, ARegBusyTail; 	/* queue of busy address regs */
uint DRegValidCount, ARegValidCount;	/* counts of valid busy regs */
[RSTKSIZE] ushort RegStack;		/* stacked register number stack */
*ushort NextRegStack;			/* next slot in reg type stack */

[PBSIZE / sizeof(uint)] uint ProgramBuffWord;
[PBSIZE] byte ProgramBuff @ ProgramBuffWord;
					/* program and symbol table buffer */

*byte ProgramNext;			/* code pointer */
*char SymNext;				/* next char for symbol names */
*uint ProgramNextWord @ ProgramNext;	/* code pointer for chaining */
uint
    TrueChain,				/* true branch chain */
    FalseChain, 			/* false branch chain */
    ReturnChain,			/* chain of 'return's */
    HereChain;				/* chain of branches to come 'here' */

[SYSIZE] SYMBOL SymbolTable;		/* the symbol table */
SYMBOL DummyId; 			/* dummy symbol entry */
*SYMBOL CurrentId;			/* currently scanned identifier */

[CTSIZE] CTENT ConstTable;		/* constant table (CTENT's) */
*CTENT
    ConstNext,				/* pointer to next constant slot */
    String;				/* string returned from scanner */

[DTSIZE] DESCRIPTOR DescTable;		/* descriptor table (DESCRIPTOR's) */
*DESCRIPTOR DescNext;			/* pointer to next descriptor slot */

[GRTSIZE] RELOC GlobalRelocTable;	/* globals relocation table*/
[FRTSIZE] RELOC FileRelocTable; 	/* file statics reloc table*/
[LRTSIZE] RELOC LocalRelocTable;	/* locals relocation table */
[PRTSIZE] RELOC ProgramRelocTable;	/* prog labels reloc table */
*RELOC
    GlobalRelocNext,			/* pointer to next gr slot */
    FileRelocNext,			/* pointer to next fr slot */
    LocalRelocNext,			/* pointer to next lr slot */
    ProgramRelocNext;			/* pointer to next pr slot */

[CBSIZE] byte ByteBuff; 		/* constant byte buffer */
*byte ByteNext; 			/* pointer into byte buffer */

[CASESIZE] CENTRY CaseTable;		/* table for cases */
*CENTRY CaseTableNext;			/* next slot in case table */

VALUEKIND CCKind;			/* CC currently represents this */
VALUETYPE CCValue;
bool CCIsReg;				/* true => is CC of temp reg. */
ushort CCReg;				/* which reg it is (D reg only) */

[BRANCHSIZE] BRENTRY BranchTable;	/* table for branch chains */
*BRENTRY BranchTableNext;		/* next slot in branch table */

[TTSIZE] TTENTRY TypeTable;		/* the type table */
TYPENUMBER NextType;			/* next available type slot */
TYPENUMBER ResultType;			/* type of this proc (for return) */

uint __Pad;				/* force next to word boundary */
[TITSIZE] byte TypeInfoTable;		/* type information table */
*byte NextTypeInfo;			/* next slot in type info table */

char
    Char,				/* current input character */
    NextChar;				/* next input character */

byte
    DeclLevel;				/* current declaration level */

ushort
    Token,				/* code for current token */
    Eof,				/* true if have hit eof */
    Column,				/* current column in source file */
    OColumn,				/* column for previous char */
    OOColumn,				/* column for 2nd previous char */
    OldColumn;				/* column for previous token */

bool
    InitData,				/* true if building init data */
    IgnoreConst,			/* ignoring a bad constant */
    Ignore,				/* true if ignoring code */
    InConst,				/* true when building constant */
    CStyleCall, 			/* next call will be C style */
    ExtraAReg,
    ActualProc, 			/* true if actual proc header */
    DebugFlag,				/* generate debuggable code */
    VerboseFlag,			/* print proc stats */
    FloatBusy,				/* D0/D1 busy with a float value */
    OptKludgeFlag1,			/* doAssignment & moveDone */
    OptKludgeFlag2;			/* doAbsNeg & opSingle */
