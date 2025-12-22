/*
 * picasm.h
 *
 * Copyright 1995-1998 Timo Rossi, <trossi@iki.fi>
 * See the file picasm.doc for more information
 * 
 * http://www.iki.fi/trossi/pic/
 * 
 */

/*
 * Version history:
 *
 * 1998-05-04   1.06   - fixed missing assembled code listing on lines
 *                       with labels
 *                     - added dollar-prefixed hex numbers
 *                     - allows invalid tokens in code skipped with if..endif
 *                     - shows macro line number in error messages
 *                     - better error handling
 *                     - reorganized device type/config handling
 *                     - lots of new device types added
 *                     - fixed ORG mode bug
 *                     - allows TRIS PORTC
 *                     - only warns about TRIS/OPTION with warnlevel 2
 *                     - added ERROR directive
 *                     - HEX_EOL #define
 *
 * 1996-09-08   1.05   added PIC16F84 (same as PIC16C84A)
 * 1996-07-01          now defines __<pic_type> symbol
 *                     symbol table listing option
 * 1996-06-25   1.04   small changes, makefile for Watcom C
 * 1996-06-06   1.03   many device table additions,
 *                     better handling of CONFIG-directive
 * 1996-05-17   1.02   local labels, device table additions
 * 1996-03-26   1.0
 * ...
 */

#define VERSION "v1.06"

#if defined(__SASC) || defined(__TURBOC__) || defined(__WATCOMC__) || defined(_MSC_VER)
#define strcasecmp stricmp
#define strncasecmp strnicmp
#endif

/* hex output end-of-line. if you need CRLFs in hex files
 * when running on a system which does not normally generate
 * them (such as Unix), change this to "\r\n"
 */
#define HEX_EOL "\n"

/* maximum number of errors before aborting assembly */
#define MAX_ERRORS 20

/* output formats */
enum {
  IHX8M,
  IHX16
};

/* org mode */
typedef enum {
  O_NONE,
  O_PROGRAM,
  O_REGFILE,
  O_EDATA
} org_mode_t ;

typedef unsigned short pic_instr_t;

#define INVALID_INSTR  0xffff
#define INVALID_DATA   0xffff
#define INVALID_CONFIG 0xffff
#define INVALID_ID     0xffff

/* list flags */
#define LIST_LOC     1
#define LIST_PROG    2
#define LIST_EDATA   4
#define LIST_FORWARD 8
#define LIST_VAL     0x10
#define LIST_PTR     0x20

/* inc_file types */
typedef enum {
  INC_FILE,
  INC_MACRO
} inctype_t;

/*
 * structure for include files/macros
 */
struct inc_file {
  struct inc_file *next;
  union {
    struct {
      FILE *fp;
      char *fname;
    } f; /* file */
    struct {
      struct symbol *sym;
      struct macro_line *ml;
      struct macro_arg *args;
      int uniq_id;
    } m; /* macro */
  } v;
  inctype_t type;
  int linenum;
  int cond_nest_count;
};

/*
 * structure to hold one macro line
 */
struct macro_line {
  struct macro_line *next;
  char text[1];
};

/* Macro argument */
struct macro_arg {
  struct macro_arg *next;
  char text[1];
};

/*
 * structure for patching forward jumps
 */
typedef enum {
  PATCH11, /* 14-bit instr. set PICs */
  PATCH9,  /* 12-bit, goto */
  PATCH8   /* 12-bit, call */
} patchtype_t;

struct patch {
  struct patch *next;
  struct symbol *label;
  int location;
  patchtype_t type;
};

#define PROGMEM_MAX 8192
#define EEPROM_MAX 256

/*
 * Definitions for different types of PIC processors
 */

#define INSTRSET_MASK 0xF
typedef enum {
  PIC12BIT=1,
  PIC14BIT
} instrset_t;

typedef enum {
  FUSE_16C5X=1,  /* most 12-bit PICs  */
  FUSE_12C5XX,   /* 12-bit 8-pin PICs 12C508, 12C509 */
  FUSE_12C6XX,   /* 14-bit 8-pin PICs 12C671, 12C672 */
  FUSE_16CXX1,   /* 16C61, 16C71, 16C84 */
  FUSE_16CXX2,   /* 16C62/64/65/73/74 */
  FUSE_16C6XA,   /* 16C62A/63/64A/65A/66/67/72/73A/74A */
  FUSE_16C55X,   /* 16C554/556/558 */
  FUSE_16F8X,    /* 16C83/16F84 */
  FUSE_16C71X,   /* 16C710/711 */
  FUSE_16C715,   /* 16C715 */
  FUSE_16C62X,   /* 16C620/621/622 */
  FUSE_14000
} fusetype_t;


struct pic_type {
  char *name;
  int progmem_size;
  short regfile_limit; /* without banking */
  short eeprom_size;
  int id_addr;
  int fuse_addr;
  fusetype_t fusetype;
  instrset_t instr_set;
};


#define TOKSIZE 256

struct symbol {
  struct symbol *next;
  union {
    long value;
    struct macro_line *text;
  } v;
  char type;
  char name[1];
};

/* symbol types */
enum {
  SYM_MACRO,
  SYM_FORWARD,
  SYM_SET,
  SYM_DEFINED
};

#define SYMTAB_GLOBAL 0
#define SYMTAB_LOCAL  1

/*
 * token codes
 */
/**/
enum {
  TOK_INVALID,
  TOK_EOF,
  TOK_NEWLINE,
  TOK_COLON,
  TOK_PERIOD,
  TOK_DOLLAR,
  TOK_COMMA,
  TOK_LEFTPAR,
  TOK_RIGHTPAR,
  TOK_LEFTBRAK,
  TOK_RIGHTBRAK,
  TOK_EQUAL,
  TOK_EQ,
  TOK_NOT_EQ,
  TOK_LESS,
  TOK_LESS_EQ,
  TOK_GREATER,
  TOK_GT_EQ,
  TOK_PLUS,
  TOK_MINUS,
  TOK_ASTERISK,
  TOK_SLASH,
  TOK_PERCENT,
  TOK_BITAND,
  TOK_BITOR,
  TOK_BITXOR,
  TOK_BITNOT,
  TOK_LSHIFT,
  TOK_RSHIFT,
  TOK_BACKSLASH,
  TOK_IDENTIFIER,
  TOK_LOCAL_ID,
  TOK_INTCONST,
  TOK_STRCONST, /* used as file name with include, and in EDATA */

  KW_INCLUDE,
  KW_MACRO,
  KW_ENDM,
  KW_EXITM,
  KW_IF,
  KW_ELSE,
  KW_ENDIF,
  KW_EQU,
  KW_SET,
  KW_END,
  KW_ORG,
  KW_DS,
  KW_EDATA,
  KW_CONFIG,
  KW_PICID,
  KW_DEVICE,
  KW_DEFINED,
  KW_STREQ,
  KW_ISSTR,
  KW_CHRVAL,
  KW_OPT,
  KW_LOCAL,
  KW_ENDLOCAL,
  KW_ERROR,

  KW_ADDLW,
  KW_ADDWF,
  KW_ANDLW,
  KW_ANDWF,
  KW_BCF,
  KW_BSF,
  KW_BTFSC,
  KW_BTFSS,
  KW_CALL,
  KW_CLRF,
  KW_CLRW,
  KW_CLRWDT,
  KW_COMF,
  KW_DECF,
  KW_DECFSZ,
  KW_GOTO,
  KW_INCF,
  KW_INCFSZ,
  KW_IORLW,
  KW_IORWF,
  KW_MOVLW,
  KW_MOVF,
  KW_MOVWF,
  KW_NOP,
  KW_OPTION,
  KW_RETFIE,
  KW_RETLW,
  KW_RETURN,
  KW_RLF,
  KW_RRF,
  KW_SLEEP,  
  KW_SUBLW,
  KW_SUBWF,
  KW_SWAPF,
  KW_TRIS,
  KW_XORLW,
  KW_XORWF,

  KW_END_POS /* end marker */
};

#define FIRST_KW KW_INCLUDE
#define NUM_KEYWORDS (KW_END_POS-FIRST_KW)

/*
 * truth values for boolean functions
 */
#define EXPR_FALSE (0)
#define EXPR_TRUE (~0)

/* number of bits in an expression value */
#define EXPR_NBITS 32

/*
 * Success/failure return codes for functions
 */
#define OK   (0)
#define FAIL (-1)

/*
 * variable declarations
 */

/* picasm.c */
extern struct inc_file *current_file;
extern char *line_buf_ptr;
extern char line_buffer[256];
extern int unique_id_count;
extern int cond_nest_count;
extern org_mode_t O_Mode;
extern int prog_location, reg_location, edata_location, org_val;
extern int warnlevel;
extern struct patch **local_patch_list_ptr;
extern int prog_mem_size;
extern unsigned short list_flags;
extern struct pic_type *pic_type;
extern pic_instr_t config_fuses;
extern int local_level;

/* token.c */
extern int token_type, line_buf_off;
extern char token_string[TOKSIZE];
extern long token_int_val;
extern int tok_char;
extern int ifskip_mode;

/* expr.c */
extern int expr_error;

/*
 * function prototypes
 */

/* picasm.c */
void *mem_alloc(int size);
#define mem_free(p) free(p)
void fatal_error(char *, ...), error(int, char *, ...), warning(char *, ...);
void write_listing_line(int cond_flag);
void gen_code(int val);
void add_patch(int tab, struct symbol *sym, patchtype_t type);
int gen_byte_c(int instr_code);

/* config.c */
void parse_config(void);

/* token.c */
void get_token(void), skip_eol(void);
void expand_macro(struct symbol *sym);
void begin_include(char *fname), end_include(void);
void read_src_char(void);

/* symtab.c */
void init_symtab(void);
void add_local_symtab(void);
void remove_local_symtab(void);
struct symbol *add_symbol(char *name, int tab);
struct symbol *lookup_symbol(char *name, int tab);
void dump_symtab(FILE *);

/* expr.c */
long get_expression(void);

/* pic12bit.c */
int assemble_12bit_mnemonic(int op);

/* pic14bit.c */
int assemble_14bit_mnemonic(int op);

