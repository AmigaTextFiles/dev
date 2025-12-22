#ifndef THIS_FILE_H
/* Sample 'C' code for parser to chew on. *
 *   ( Parentheses to confuse Forth )     *
 * Many 'C' files look like this.         */

#ifndef EXEC_EXECBASE_H
#include "exec/execbase.h"
#endif

/* Sample file for testing 'C' parser. */
struct foo {  /* Define a structure */
        struct RastPort MyRast;
	LONG gobble;   /* Something wierd. */
        LONG reserved[14];
        LONG long1, long2;
        USHORT aushort, lotsa_s[8];
        BYTE name[20];
        BYTE abyte;    /* This does something. */
        struct Window *awptr;  /* Just a pointer. */
        CHAR * mycptr;
        FLOAT beep;
        SHORT signedshort;
        SPTR  myptr;   /* Sneaky word. This will cause an error! */
        UWORD just_a_word;
};  /* That's it! */

/* Test #define of constants and expressions. */
#define NULL   0     /* NULL Pointer value */
#define BUTTON 1234  /* Comment spans multiple lines
                        Which often occurs. */
#define SHIFTED_NUMBER     (1<<15)
#define SPACEY_PLUS    BUTTON + 123
#define TIGHT_OPS	NULL+BUTTON*SHIFTED_NUMBER
#define HEXINT   0x8AF4
#define IF_MYDEF  TIGHT_OPS
#define JUST_A_NAME
#define NEG_NUMBER     (-30)
#define GOOBER (BUTTON+98)

