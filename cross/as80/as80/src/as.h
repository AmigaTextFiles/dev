/*
 *      8080 Assembler
 *
 *      Copyright (C) 1983 - Anthony McGrath
 *
 *      Modifications and ANSI C compatibility fixes
 *      Copyright (C) 2004 by Ventzislav Tzvetkov
 *
 *      @(#) as.h - Version 1.31 - 09/03/2004
 */

#include        <stdio.h>
#include        <setjmp.h>

/*
 *      Opcode Flags
 */

#define LOCAL   1               /* Local Operations */
#define ACCUM   2               /* Accumulator Operations */
#define DOUBLE  3               /* Double Register Operations */
#define SINGLE  4               /* Single Operations */
#define SPECIAL 6               /* Special Operations */
#define BYTE    7               /* Byte Operations */
#define RELOC   8               /* Relocatable 16 bit Operations */
#define RELAT   9               /* Relative Branch Operations */
#define BIT     10              /* Bit Operations */

typedef struct optab    optab;

struct optab    {
        char    *o_name;                /* opcode symbol */
        int     o_value;                /* opcode value */
        int     o_type;                 /* opcode type */
};

/*
 *      Symbols
 */

#define UNDEF   0               /* Undefined */
#define LLABEL  1               /* Local Label */
#define GLABEL  2               /* Global Label */
#define GUNDEF  3               /* Undefined Global */
#define EXPR    4               /* Expression */
#define MACRO   5               /* Macro */

typedef struct symbol   sym;
typedef struct temp     temp;

struct symbol   {
        int     s_flag;                 /* symbol flags */
        char    *s_name;                /* symbol name */
        int     s_seg;                  /* symbol segment */
        int     s_value;                /* symbol value */
        int     s_glob;                 /* global number */
        temp    *s_temp;                /* temporaries */
        int     s_ntmp;                 /* # of temporaries */
};

struct temp     {
        int     tmp_lab;                /* label value */
        int     tmp_val;                /* temp value */
};

/*
 *      Relocation Information
 */

#define ABSOLUTE        0               /* Absolute */
#define RELTEXT         1               /* Relocatable Text */
#define RELDATA         2               /* Relocatable Data */
#define ZERO            3               /* Block Zeros */
#define GLOBAL          4               /* Global Reference */
#define ORIGIN          5               /* Origin Change */

/*
 *      Constants
 */

#define NAME    'a'
#define NUM     '0'
#define TEMP    't'

#define TEXT    0
#define DATA    1

#define MAXLAB  1024            /* # of labels allowed */
#define MAXTEMP 1024            /* # of temporary labels allowed */

/*
 *      Externals
 */

extern char     symname[];              /* last NAME symbol */
extern int      cval;                   /* last NUM value */
extern int      dbase;                  /* default number base */

extern int      peekc;                  /* peeked at character */
extern int      peeksym;                /* peeked at symbol */

extern int      indxflg;                /* uses index register */
extern int      offset;                 /* offset for index */

extern int      lno;                    /* current line number */
extern int      loc;                    /* current location */
extern int      dloc;                   /* data segment location */
extern int      tloc;                   /* text segment location */
extern int      seg;                    /* current segment */
extern int      eof;                    /* eof status */
extern int      errcnt;                 /* error count */
extern int      pass;                   /* pass number */
extern int      vtype;                  /* type of value */
extern int      vseg;                   /* segment of value */

extern jmp_buf  errstart;               /* restart after error */

extern char     *file;                  /* current file name */

extern optab    opcode[];
extern optab    regist[];

extern sym      *tmpsym;                /* symbol for temporaries */

/* functions */
void pass1(register int argc, register char **argv);

void pass2(register int argc, register char **argv);

void dofile();

void error(char *s);

void dumpabs();

void outabs(register int v);

void outword(register int v,register int type);

void outzero(register int v);

void outn(register int v);

void outseg(register int type);

void outorg(register int n);

void segset();

void skipln(register int s);

void eoln(register int sym);

int symbol();

int getnum();

int getcc();

int index(register char c, register char *s);

void parse();

void accum(register int n);

void wordop(register int n);

void bytop(register int n);

void reloc(register int n);

void bitop(register int n);

void relat(register int n);

void special(register int n);

void local(register int    n);

void asciz(int z);

void byte();

void word();

void global();

sym     * hash(register char   *s);

void deflabel(register char *s, register int type);

void defexpr(register char *s);

int getvalue(register char *s);

void header();

void tmplabel();

void tmpexpr();

int expr();

int getop();

int ltype(register int type);

void comma();

int getsreg();

int getdreg();

optab * rfind(register char *s);

int lowcmp(register char *s1, register char *s2);

int macro(char *s);

void domacro(char *s);

void defmacro();
