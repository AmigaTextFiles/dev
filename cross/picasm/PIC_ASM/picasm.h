/*
 * picasm.h
 */

#define VERSION "v1.0"

#if defined(__SASC) || defined(__TURBOC__)
#define strcasecmp stricmp
#endif

/* output formats */
enum {
  IHX8M,
  IHX16
};

/* org mode */
enum {
  O_NONE,
  O_PROGRAM,
  O_REGFILE,
  O_EDATA
};

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
  int type;
  int linenum;
  int cond_nest_count;
};

/* inc_file types */
enum {
  INC_FILE,
  INC_MACRO
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
struct patch {
  struct patch *next;
  struct symbol *label;
  int location;
  int type;
};

enum {
  PATCH11, /* 14-bit instr. set PICs */
  PATCH9,  /* 12-bit, goto */
  PATCH8   /* 12-bit, call */
};

#define PROGMEM_MAX 4096
#define DATAMEM_MAX 64

/*
 * Definitions for different types of PIC processors
 */

#define INSTRSET_MASK 3
#define PIC12BIT 1
#define PIC14BIT 2

#define PIC_ID   8

struct pic_type {
  char *name;
  int progmem_size;
  int datamem_size;
  int regfile_size; /* without banking */
  short instr_flags;
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
extern int O_Mode;
extern int prog_location, reg_location, edata_location, org_val;
extern int warnmode;
extern struct patch *patch_list;
extern int prog_mem_size;
extern unsigned short list_flags;
extern struct pic_type *pic_type;

/* token.c */
extern int token_type, line_buf_flag;
extern char token_string[TOKSIZE];
extern long token_int_val;
extern int tok_char;

/* expr.c */
extern int expr_error;

/*
 * function prototypes
 */

/* picasm.c */
void *mem_alloc(int size);
void fatal_error(char *, ...), error(int, char *, ...), warning(char *, ...);
void write_listing_line(int cond_flag);
void gen_code(int val);
void add_patch(struct symbol *sym, int type);
int gen_byte_c(int instr_code);

/* token.c */
void get_token(void), skip_eol(void);
void expand_macro(struct symbol *sym);
void begin_include(char *fname), end_include(void);
void read_src_char(void);

/* symtab.c */
void init_symtab(void);
struct symbol *add_symbol(char *name);
struct symbol *lookup_symbol(char *name);

/* expr.c */
long get_expression(void);

/* pic12bit.c */
int assemble_12bit_mnemonic(int op);

/* pic14bit.c */
int assemble_14bit_mnemonic(int op);

