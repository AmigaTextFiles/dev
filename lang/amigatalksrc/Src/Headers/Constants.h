/****h* AmigaTalk/Constants.h [2.5] *******************
*
* NAME
*    Constants.h
*******************************************************
*/

#ifndef AMIGATALKSTRUCTS_H
# include "ATStructs.h"
#endif

#ifndef  CONSTANTS_H
# define CONSTANTS_H  1

# ifndef  CONTINUE_DEBUG    // Also present in Global.c, hence the conditional statement
#  define CONTINUE_DEBUG 1
#  define IGNORE_BREAKS  0
# endif

#ifndef  BUFF_SIZE
# define BUFF_SIZE 512
#endif

#ifndef  LARGE_TOOLSPACE
# define LARGE_TOOLSPACE 256
#endif

#ifndef  NUMBR_TOOLSPACE
# define NUMBR_TOOLSPACE 32
#endif

// Our minimum Memory Space requirements: ----------------------------

# define MIN_OBJTABLE_SIZE  2000000 // ObjectTableSize
# define MIN_BYTTABLE_SIZE  2000000 // ByteArrayTableSize
# define MIN_ITPTABLE_SIZE  5000000 // InterpreterTableSize
# define MIN_INTTABLE_SIZE  1000000 // IntegerTableSize
# define MIN_SYMTABLE_SIZE   500000 // SymbolTableSize
# define MIN_CLSTABLE_SIZE   500000 // ClassTableSize

// -------------------------------------------------------------------

typedef OBJECT (*fsP)( int, OBJECT * ); // Function pointer typedef.

# define COMMAND_STRLENGTH 256 // For the Command String Gadget only!

# define PGM_ITEMLENGTH    81
# define PGM_MAXITEM       100

# define USER_COMMAND 3 // Tell line_grabber() that user entered a command.

# define PgmListView  0       // Main Gadget ID's
# define CmdStr       1
# define ParseBt      2

# define AT_CNT       3

// ATMenu constants:

# define MENU_LENGTH  80 // Maximum length of a MenuItem label

/* ------------------------- ATBrowser.c constants: */

# define ClassLV       0
# define MethodLV      1
# define SrcCodeLV     2
# define ATBStr        3

# define ATB_CNT       4

# define MAX_CLASSES   500
# define CLASS_LENGTH  50

# define MAX_METHODS   200
# define METHOD_LENGTH 50

# define MAX_METHOD    200
# define LINE_LENGTH   128

// For Lex.c & LexCmd.c:

#define MAXTOKEN 256

// For line.c: --------------------------------------

#define MAXINCLUDE  60
#define MAXBUFFER   0x8000 // was 8192, now 32768 // text buffer

// --------------------------------------------------


/* BBBBBBBBBBBBBBBBBBB From Byte.h file: BBBBBBBBBBBBBBBBBBBBBBBBBBBBB */

/* bytearrays of size less than MAXBSAVE are kept on a free list:  */

//# define MAXBSAVE 50

/*
**   in order to avoid a large number of small mallocs, especially
**   while reading the standard prelude, a fixed area of MAXBTABSIZE is
**   allocated and used for bytecodes until it is full.  Thereafter
**   bytecodes are allocated using malloc.  This area should be large
**   enough to hold at least all the bytecodes for the standard prelude.
*/

//# define MAXBTABSIZE 6000

/* 
**   for the same reason, a number of bytearrays structs are statically
**   allocated and placed on a free list
*/

//# define MAXBYINIT 500

/* BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB */

/* NNNNNNNNNNNNNNNNNN From Number.h file: NNNNNNNNNNNNNNNNNNNNNNNNNNNN */

# define float_value(x) (((SFLOAT *) x)->value )

# define int_value(x)   (((INTEGER *) x)->value )

# define char_value(x)  ((char) int_value( x ))

//# define INTINITMAX 50

// NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN

/* ----------------------------------------------------------------
** Unlike other special objects (integers, floats, etc), strings
** must keep their own super_obj pointer, since the class
** ArrayedCollection (a super class of String) contains instance
** variables, and thus each instance of String must have a unique
** super_obj.
** ----------------------------------------------------------------
*/

/* NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN */

/* OOOOOOOOOOOOOOOOOO From Object.h file: OOOOOOOOOOOOOOOOOOOOOOOOOOOO */
/*
# define CLASSSIZE        -1    // 0xFFFFFFFF
# define BYTEARRAYSIZE    -2    // 0xFFFFFFFE
# define SYMBOLSIZE       -3    // 0xFFFFFFFD
# define INTERPSIZE       -4    // 0xFFFFFFFC
# define PROCSIZE         -5    // 0xFFFFFFFB
# define BLOCKSIZE        -6    // 0xFFFFFFFA
# define FILESIZE         -7    // 0xFFFFFFF9
# define CHARSIZE         -8    // 0xFFFFFFF8
# define INTEGERSIZE      -9    // 0xFFFFFFF7
# define STRINGSIZE       -10   // 0xFFFFFFF6
# define FLOATSIZE        -11   // 0xFFFFFFF5
# define SPECIALSIZE      -12   // 0xFFFFFFF4
*/

// Number of long words in each structure:

# define BASIC_OVERHEAD   6

# define OBJECT_SIZE      sizeof( OBJECT )
# define CLASS_SPEC_SIZE  sizeof( CLASS_SPEC )
# define CLASS_SIZE       sizeof( CLASS )
# define STRING_SIZE      sizeof( STRING )
# define BYTEARRAY_SIZE   sizeof( BYTEARRAY )
# define SYMBOL_SIZE      sizeof( SYMBOL )
# define INTERPRETER_SIZE sizeof( INTERPRETER )
# define PROCESS_SIZE     sizeof( PROCESS )
# define BLOCK_SIZE       sizeof( BLOCK )
# define FILE_SIZE        sizeof( AT_FILE )
# define INTEGER_SIZE     sizeof( INTEGER )
# define CHARACTER_SIZE   sizeof( CHARACTER )
# define FLOAT_SIZE       sizeof( SFLOAT )
# define CLASS_ENTRY_SIZE sizeof( CLASS_ENTRY )
# define ADDRESS_SIZE     sizeof( AT_ADDRESS )
 
# define MMF_INUSE_MASK   0x80000000

# define MMF_MAX_OBJSIZE  0x00FFFFFF

# define MMF_BUILTIN_MASK 0x0F000000

# define MMF_CLASS        0x01000000
# define MMF_BYTEARRAY    0x02000000
# define MMF_SYMBOL       0x03000000
# define MMF_INTERPRETER  0x04000000
# define MMF_PROCESS      0x05000000
# define MMF_BLOCK        0x06000000
# define MMF_FILE         0x07000000
# define MMF_CHARACTER    0x08000000
# define MMF_INTEGER      0x09000000
# define MMF_STRING       0x0A000000
# define MMF_FLOAT        0x0B000000
# define MMF_CLASS_SPEC   0x0C000000
# define MMF_CLASS_ENTRY  0x0D000000
# define MMF_RESERVED1    0x0E000000 // System Dictionary
# define MMF_RESERVED2    0x0F000000 // AmigaOS addresses (AT_ADDRESS) 

# define MMF_SDICT        MMF_RESERVED1
# define MMF_ADDRESS      MMF_RESERVED2
 
/* OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO */

/* PPPPPPPPPPPPPPPPPP From Primitive.h file: PPPPPPPPPPPPPPPPPPPPPPPPP */

# define EQTEST         7    // Primitive Numbers: 
# define GAMMAFUN       77
# define SYMEQTEST      91
# define SYMPRINT       94
# define FINDCLASS      99
# define GROW           113
# define RAWPRINT       120
# define PRINT          121
# define ERRPRINT       123
# define BLKRETERROR    127
# define REFCOUNTERROR  128
# define NORESPONDERROR 129
# define BLOCKEXECUTE   140
# define DOPERFORM      143

/* PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP */

/* ------------------ From Symbol.h file: ---------------------------- */

# define SYMTABMAX 15000  /* Changed to 15000 from 5000 on 25-Dec-2001 jts. */

/* SYMINITSIZE symbol entries are allocated at the start of execution,
** which prevents malloc from being called too many times 
*/

# define SYMINITSIZE  60

/* ---------------------------------------------------------------- */

//# define CLASSINITMAX   100     /* From Class.c,  originally only 30 */
//# define CDICTINIT      100     /* From ClDict.c, originally only 30 */

# define CODEMAX        1024    /* Increased from 512 on 25-Dec-2001 From Drive.c  */
# define LITMAX         1024    /* Increased from 100 on 25-Dec-2001 From Drive.c  */
# define BUFLENGTH      256     /* From File.c   */

//# define MAXLOW         100     /* maximum low numbers kept (Number.c) */
//# define MAXOBJLIST     100     /* From Object.c  */
//# define PROCINITMAX    6       /* From Process.c */

# define WORDTABMAX     1000    /* From Sstr.c    */
# define STRTABMAX      10000   /* From Sstr.c    */

//# define WALLOCINITSIZE 1000    /* From String.c  */
//# define STRINITSIZE    50      /* From String.c  */
//# define STRLISTMAX     100     /* From String.c  */

/* -------------------- From Process.h file: ---------------------- */

# define  ACTIVE        0

# define  SUSPENDED     1
# define  READY         ~SUSPENDED

# define  BLOCKED       2
# define  UNBLOCKED     ~BLOCKED

# define  TERMINATED    4

# define  CUR_STATE     10 //???

/* ---------------------------------------------------------------- */

#endif

/* ----------------- END of Constants.h file! --------------------- */
