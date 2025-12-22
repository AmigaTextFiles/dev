/* $Id: types.h,v 45.2 2001/03/12 17:51:53 heinz Exp $ */
OPT NATIVE
{MODULE 'exec/types'}

TYPE SLONG IS VALUE

TYPE UBYTE IS NATIVE {UBYTE} CHAR
TYPE UINT  IS NATIVE {UINT}  INT
TYPE ULONG IS NATIVE {ULONG} VALUE
TYPE UBIGVALUE IS BIGVALUE

TYPE   CPTR IS ULONG
TYPE   APTR IS ARRAY
TYPE STRPTR IS ARRAY OF CHAR
TYPE  APTR2 IS PTR

TYPE CONST_APTR   IS ARRAY
TYPE CONST_STRPTR IS ARRAY OF CHAR

TYPE LONGBITS IS VALUE


NATIVE {INCLUDE_VERSION}	CONST INCLUDE_VERSION	= 45 /* Version of the include files in use. (Do not
													      use this label for OpenLibrary() calls!) */

NATIVE {BYTEMASK}        CONST BYTEMASK        = $FF

 /* #define LIBRARY_VERSION is now obsolete.  Please use LIBRARY_MINIMUM */
/* or code the specific minimum library version you require.		*/
NATIVE {LIBRARY_MINIMUM}	CONST LIBRARY_MINIMUM	= 40 /* Lowest version supported by Amiga, Inc. */
