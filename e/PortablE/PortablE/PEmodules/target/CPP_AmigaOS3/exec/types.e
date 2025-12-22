/* $Id: types.h,v 45.2 2001/03/12 17:51:53 heinz Exp $ */
OPT NATIVE
{#include <exec/types.h>}
NATIVE {EXEC_TYPES_H} CONST

TYPE SLONG IS VALUE

TYPE UBYTE IS NATIVE {UBYTE} CHAR
TYPE UINT  IS NATIVE {UWORD} INT
TYPE ULONG IS NATIVE {ULONG} VALUE
TYPE UBIGVALUE IS NATIVE {unsigned long long} BIGVALUE

TYPE   CPTR IS NATIVE   {CPTR} ULONG
TYPE   APTR IS NATIVE   {APTR} ARRAY
TYPE STRPTR IS NATIVE {STRPTR} ARRAY OF CHAR
TYPE  APTR2 IS NATIVE   {APTR} PTR

TYPE CONST_APTR   IS NATIVE {CONST_APTR} ARRAY
TYPE CONST_STRPTR IS NATIVE {CONST_STRPTR} ARRAY OF CHAR

TYPE LONGBITS IS NATIVE {LONGBITS} VALUE


NATIVE {INCLUDE_VERSION}	CONST INCLUDE_VERSION	= 45 /* Version of the include files in use. (Do not
													      use this label for OpenLibrary() calls!) */


NATIVE {GLOBAL}  CONST      /* the declaratory use of an external */
NATIVE {IMPORT}  CONST      /* reference to an external */
NATIVE {STATIC}  CONST      /* a local static variable */
NATIVE {REGISTER} CONST   /* a (hopefully) register variable */


NATIVE {VOID}            CONST

/* General const support */
NATIVE {CONST} CONST

NATIVE {VOLATILE} CONST

  /*  WARNING: APTR was redefined for the V36 Includes!  APTR is a   */
 /*  32-Bit Absolute Memory Pointer.  C pointer math will not       */
/*  operate on APTR --  use "ULONG *" instead.                     */
NATIVE {APTR_TYPEDEF} CONST
NATIVE {APTR} CONST	    /* 32-bit untyped pointer */
NATIVE {LONG} CONST       /* signed 32-bit quantity */
NATIVE {ULONG} CONST      /* unsigned 32-bit quantity */
NATIVE {LONGBITS} CONST   /* 32 bits manipulated individually */
NATIVE {WORD} CONST       /* signed 16-bit quantity */
NATIVE {UWORD} CONST      /* unsigned 16-bit quantity */
NATIVE {WORDBITS} CONST   /* 16 bits manipulated individually */
NATIVE {BYTE} CONST	    /* signed 8-bit quantity */
NATIVE {UBYTE} CONST      /* unsigned 8-bit quantity */
NATIVE {BYTEBITS} CONST   /* 8 bits manipulated individually */
NATIVE {RPTR} CONST	    /* signed relative pointer */

NATIVE {STRPTR} CONST     /* string pointer (NULL terminated) */

/* const support for pointer types */
NATIVE {CONST_APTR} CONST     /* 32-bit untyped const pointer */
NATIVE {CONST_STRPTR} CONST /* STRPTR to const data */

/* For compatibility only: (don't use in new code) */
NATIVE {SHORT} CONST      /* signed 16-bit quantity (use WORD) */
NATIVE {USHORT} CONST     /* unsigned 16-bit quantity (use UWORD) */
NATIVE {COUNT} CONST
NATIVE {UCOUNT} CONST
NATIVE {CPTR} CONST


/* Types with specific semantics */
NATIVE {FLOAT} CONST
NATIVE {DOUBLE} CONST
NATIVE {BOOL} CONST
NATIVE {TEXT} CONST

->NATIVE {TRUE}            CONST TRUE            = 1
->NATIVE {FALSE}           CONST FALSE           = 0
->NATIVE {NULL}            CONST NULL            = 0


NATIVE {BYTEMASK}        CONST BYTEMASK        = $FF


 /* #define LIBRARY_VERSION is now obsolete.  Please use LIBRARY_MINIMUM */
/* or code the specific minimum library version you require.		*/
NATIVE {LIBRARY_MINIMUM}	CONST LIBRARY_MINIMUM	= 40 /* Lowest version supported by Amiga, Inc. */

/* Some structure definitions include prototypes for function pointers.
 * This may not work with `C' compilers that do not comply to the ANSI
 * standard, which we will have to work around. 
 */
