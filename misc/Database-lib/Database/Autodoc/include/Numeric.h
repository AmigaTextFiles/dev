@DATABASE "Numeric.h"
@MASTER   "include:joinOS/database/Numeric.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-May-04 21:40:31
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "Numeric.h"

@{"Numeric.h" LINK File}


@{b}Structures@{ub}

@{"fixedPointNumeric" LINK "Numeric.h/File" 43}


@{b}Typedefs@{ub}

@{"NUMERIC" LINK "Numeric.h/File" 43}

@ENDNODE
@NODE File "Numeric.h"
#ifndef _DATABASE_NUMERIC_H_
#define _DATABASE_NUMERIC_H_ 1
/* Numeric.h
 *
 * This module defines a new datatype, the fixed point numeric value "NUMERIC".
 * This kind of datatype is stored in the DataColumns of DataServers with the
 * type @{"DC_NUMERIC" LINK "DataServer.h/File" 140}.
 *
 * A NUMERIC has at least one integer digit (the part before the comma) and
 * no decimal value (the part behind the comme). A NUMERIC is stored in the
 * according structure, containing a byte buffer for the digits, the length
 * and the number of decimal digits.
 * The digits in the buffer are written as follows:
 *    The first character is the sign , either '+' (ASCII 59) or '-' (ASCII 61)
 *    any other character is not allowed.
 *    The digits of the NUMERIC are written right aligned into the following
 *    'NUMERIC.Length' - 1 bytes. All decimal digits needs to be stored and
 *    at least one digit of the integer part. The comma is not written into
 *    this buffer. Unused bytes in the buffer are cleared (i.e. '\\0' is written
 *    into these bytes).
 *
 * Examples:
 *    The value "-123.45" will be written as follows into the buffer of a
 *    NUMERIC with a 'Length' of 10 and 3 'Decimals':
 *       "-###123450"   (where '#' stands for zero '\\0')
 *    The value "65536" written to the same NUMERIC results in:
 *       "+#65536000"
 *
 * Usually the user or even application programmer needs not to know the
 * internal structure of a NUMERIC. All functions required to handle these
 * values are contained in this module.
 */
#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

/***************************************************************************/
/*                                                                         */
/*                         structure definition                            */
/*                                                                         */
/***************************************************************************/

typedef struct fixedPointNumeric
{
   UBYTE *Value;
   UWORD Length;
   UWORD Decimals;
} NUMERIC;

#endif      /* DATABASE_NUMERIC_H_ */
@ENDNODE
