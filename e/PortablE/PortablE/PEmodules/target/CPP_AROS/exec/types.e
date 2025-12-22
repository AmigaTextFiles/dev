/* $Id: types.h 25077 2006-12-12 12:23:33Z falemagn $ */
OPT NATIVE
MODULE 'target/aros/system', 'target/c++/exec/types'
{#include <exec/types.h>}
NATIVE {EXEC_TYPES_H} CONST

TYPE SLONG IS NATIVE {LONG} VALUE

TYPE UBYTE IS NATIVE {UBYTE} CHAR
TYPE UINT  IS NATIVE {UWORD} INT
TYPE ULONG IS NATIVE {ULONG} VALUE
TYPE UBIGVALUE IS NATIVE {UQUAD} BIGVALUE

TYPE   CPTR IS ULONG
TYPE   APTR IS NATIVE   {APTR} ARRAY
TYPE STRPTR IS NATIVE {STRPTR} ARRAY OF CHAR
TYPE  APTR2 IS NATIVE   {APTR} PTR

TYPE CONST_APTR   IS NATIVE {CONST_APTR} ARRAY
TYPE CONST_STRPTR IS NATIVE {CONST_STRPTR} ARRAY OF CHAR

TYPE      IPTR IS NATIVE      {IPTR} VALUE
TYPE STACKIPTR IS NATIVE {STACKIPTR} VALUE
TYPE STACKLONG IS NATIVE {STACKLONG} VALUE
TYPE STACKWORD IS NATIVE {STACKWORD} INT
TYPE STACKBYTE IS NATIVE {STACKBYTE} BYTE

TYPE LONGBITS IS NATIVE {LONGBITS} VALUE

TYPE DOUBLE IS NATIVE {DOUBLE} FLOAT

/*************************************
 ***** Basic Data types          *****
 *************************************/

    NATIVE {APTR} CONST		/* memory pointer */

    NATIVE {CONST_APTR} CONST	/* const memory pointer */

/* Distinguish between 64 and 32bit systems */
    NATIVE {LONG} CONST	/* signed 32-bit value */
    NATIVE {ULONG} CONST	/* unsigned 32-bit value */

	NATIVE {QUAD} CONST	/* signed 64-bit value */
	NATIVE {UQUAD} CONST	/* unsigned 64-bit-value */

    NATIVE {WORD} CONST	/* signed 16-bit value */
    NATIVE {UWORD} CONST	/* unsigned 16-bit-value */

    NATIVE {BYTE} CONST	/* signed 8-bit value */
    NATIVE {UBYTE} CONST	/* unsigned 8-bit value */

/* An unsigned integer which can store a pointer */
    NATIVE {IPTR} CONST

/* A signed type that can store a pointer */
    NATIVE {SIPTR} CONST

/* An integer on the stack which can store a pointer */
    NATIVE {STACKIPTR} CONST

/* Distinguish between 64 and 32bit systems on the stack */
    NATIVE {STACKLONG} CONST   /* signed 32-bit value */
    NATIVE {STACKULONG} CONST  /* unsigned 32-bit value */

	NATIVE {STACKQUAD} CONST   /* signed 64-bit value */
	NATIVE {STACKUQUAD} CONST  /* unsigned 64-bit-value */

    NATIVE {STACKWORD} CONST   /* signed 16-bit value */
    NATIVE {STACKUWORD} CONST  /* unsigned 16-bit-value */

    NATIVE {STACKBYTE} CONST   /* signed 8-bit value */
    NATIVE {STACKUBYTE} CONST  /* unsigned 8-bit value */

    NATIVE {STACKFLOAT} CONST  /* signed 32-bit floating point value */

    NATIVE {STACKDOUBLE} CONST  /* signed 64-bit floating point value */

/*************************************
 ***** Other interesting types	 *****
 *************************************/
 /* C++ doesn't like strings being treated nor as signed nor as unsigned char's arrays,
    it wants them to be simply "char" arrays. This is because
    the char type has undefined sign, unless explicitely specified.  */

    NATIVE {STRPTR} CONST	/* Pointer to string (NULL terminated) */

    NATIVE {CONST_STRPTR} CONST	/* Pointer to constant string (NULL terminated) */

    NATIVE {TEXT} CONST

    NATIVE {BOOL} CONST	/* A Boolean value */

    NATIVE {FLOAT} CONST	/* 32bit IEEE floating point value */

    NATIVE {DOUBLE} CONST	/* 64bit IEEE floating point value */

    NATIVE {LONGBITS} CONST

    NATIVE {WORDBITS} CONST

    NATIVE {BYTEBITS} CONST

    TYPE RAWARG IS NATIVE {RAWARG} ARRAY     /* Type of 'datastream' of RawDoFmt */

/*************************************
 ***** Some useful definitions	 *****
 *************************************/

->   NATIVE {FALSE}   CONST FALSE   = 0

->   NATIVE {TRUE}    CONST TRUE    = 1

->   NATIVE {NULL}    CONST NULL    = 0

   NATIVE {VOID}    CONST

NATIVE {GLOBAL}	 CONST
NATIVE {IMPORT}	 CONST
NATIVE {STATIC}	 CONST
NATIVE {REGISTER} CONST

NATIVE {CONST} CONST

NATIVE {VOLATILE} CONST

NATIVE {RESTRICT} CONST

/*
    Minimum support library version. AROS doesn't have system libraries
    below V40
*/
NATIVE {LIBRARY_MINIMUM} CONST LIBRARY_MINIMUM = 40

/*
    The current version of the includes. Do not use this value in calls
    to OpenLibrary(). Some system libraries may not be at this version. */
NATIVE {INCLUDE_VERSION} CONST INCLUDE_VERSION = 40
