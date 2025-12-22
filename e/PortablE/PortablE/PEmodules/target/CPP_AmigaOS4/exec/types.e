/* $Id: types.h,v 1.27 2005/11/10 15:33:07 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/amiga_compiler'
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

->TYPE TEXT IS NATIVE {TEXT} CHAR


NATIVE {INCLUDE_VERSION} CONST INCLUDE_VERSION = 51  /* Version of the include files in use. (Do not
                               use this label for OpenLibrary() calls!) */

/****************************************************************************/

NATIVE {GLOBAL}   CONST /* the declaratory use of an external */
NATIVE {IMPORT}   CONST /* reference to an external */
NATIVE {STATIC}   CONST /* a local static variable */
NATIVE {REGISTER} CONST /* a (hopefully) register variable */

/****************************************************************************/

NATIVE {VOID} CONST

/****************************************************************************/

/* General const support */
NATIVE {CONST} CONST

/****************************************************************************/

NATIVE {VOLATILE} CONST

/****************************************************************************/

  /*  WARNING: APTR was redefined for the V36 Includes!  APTR is a   */
 /*  32-Bit Absolute Memory Pointer.  C pointer math will not       */
/*  operate on APTR --  use "ULONG *" instead.                     */
NATIVE {APTR_TYPEDEF} CONST
NATIVE {APTR} CONST /* 32-bit untyped pointer */

/****************************************************************************/

/* Whenever possible, use these typesdefs instead of the traditional
 * BYTE/WORD/LONG. These are absolutely unambigious when it comes to
 * datatype and number of bits
 */

NATIVE {uint8} OBJECT
NATIVE {int8} OBJECT

NATIVE {uint16} OBJECT
NATIVE {int16} OBJECT

NATIVE {uint32} OBJECT
NATIVE {int32} OBJECT

->NATIVE {long} OBJECT

NATIVE {uint64} OBJECT /* Not exactly scalar data
                        * types, but the right size.
                        */
NATIVE {int64} OBJECT

NATIVE {UBYTE} CONST
NATIVE {BYTE} CONST
NATIVE {BYTEBITS} CONST
NATIVE {UWORD} CONST
NATIVE {WORD} CONST
NATIVE {WORDBITS} CONST
NATIVE {ULONG} CONST
NATIVE {LONG} CONST
NATIVE {LONGBITS} CONST
NATIVE {RPTR} CONST

/****************************************************************************/

/* Pointer to TEXT which has non-negative characters */

NATIVE {STRPTR} CONST /* string pointer (NULL terminated) */

/****************************************************************************/

/* const support for pointer types */
/*
 *             APTR is a non-constant pointer to non-constant data
 *       CONST APTR is a     constant pointer to non-constant data
 *       CONST_APTR is a non-constant pointer to     constant data
 * CONST CONST_APTR is a     constant pointer to     constant data
 */
NATIVE {CONST_APTR} CONST /* 32-bit untyped pointer to const data */

/*
 *             STRPTR is a non-constant pointer to non-constant TEXT 
 *       CONST STRPTR is a     constant pointer to non-constant TEXT
 *       CONST_STRPTR is a non-constant pointer to     constant TEXT
 * CONST CONST_STRPTR is a     constant pointer to     constant TEXT
 */
NATIVE {CONST_STRPTR} CONST /* STRPTR to const TEXT */

/****************************************************************************/

/* For compatibility only: (don't use in new code) */
NATIVE {SHORT} CONST  /* signed 16-bit quantity (use WORD) */
NATIVE {USHORT} CONST /* unsigned 16-bit quantity (use UWORD) */
NATIVE {COUNT} CONST
NATIVE {UCOUNT} CONST
NATIVE {CPTR} CONST

/****************************************************************************/

/* Types with specific semantics */

/****************************************************************************/

NATIVE {float32} OBJECT
NATIVE {float64} OBJECT

NATIVE {FLOAT}  CONST
NATIVE {DOUBLE} CONST

/****************************************************************************/

NATIVE {BOOL} CONST

NATIVE {TEXT} CONST /* Non-negative character */

/****************************************************************************/

->NATIVE {TRUE} CONST TRUE = 1

->NATIVE {FALSE} CONST FALSE = 0

/****************************************************************************/

->NATIVE {NULL} CONST NULL = 0

/****************************************************************************/

NATIVE {BYTEMASK} CONST BYTEMASK = $FF

/****************************************************************************/

/* #define LIBRARY_VERSION is now obsolete.  Please use LIBRARY_MINIMUM */
/* or code the specific minimum library version you require.            */
NATIVE {LIBRARY_MINIMUM} CONST LIBRARY_MINIMUM = 40 /* Lowest version supported by Amiga, Inc.   */

/****************************************************************************/

/* Helper macros to define an AmigaOS type in a public header file without
 * the need to distinguish between defined and undefined namespace
 */
NATIVE {AMIGAOS_TYPE} CONST
NATIVE {AMIGAOS_STRUCT} CONST
