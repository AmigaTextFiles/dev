#ifndef _NUMERIC_PROTOS_H_
#define _NUMERIC_PROTOS_H_ 1

/* NumericProto.h
 *
 * The prototypes of the function processing the NUMERIC datatype, that are
 * located in the database.library.
 * These functions are only required, if you use the DC_NUMERIC datacolumn
 * type in your DataTables and wish to implement an according algebra using
 * 64-bit math-routines.
 */
#ifndef _DATABASE_NUMERIC_H_
#include <joinOS/database/Numeric.h>
#endif

#ifdef _AMIGA
#include <joinOS/pragmas/DatabasePragma.h>
#endif

/***************************************************************************/
/*																									*/
/*									convertion functions										*/
/*																									*/
/***************************************************************************/

UWORD NumericIntDigits (UBYTE *num, UWORD length, UWORD decimals);
BOOL Numeric2DOUBLELONG (UBYTE *num, UWORD length, UWORD decimals,
												UWORD exponent, DOUBLELONG *val);
BOOL DOUBLELONG2Numeric (DOUBLELONG *val, UBYTE *num, UWORD length,
												UWORD decimals, UWORD exponent);
BOOL Str2Numeric (STRPTR str, UBYTE *num, UWORD length, UWORD decimals);
BOOL Numeric2Str (UBYTE *num, UWORD length, UWORD decimals, STRPTR str);

/***************************************************************************/
/*																									*/
/*							macros as wrapper-functions									*/
/*																									*/
/***************************************************************************/

#define NUMERICIntDigits(num) \
			NumericIntDigits(((num)->Value,(num)->Length,(num)->Decimals)
#define NUMERIC2DOUBLELONG(num,exp,val) \
			Numeric2DOUBLELONG((num)->Value,(num)->Length,(num)->Decimals,exp,val)
#define DOUBLELONG2NUMERIC(val,num,exp) \
			DOUBLELONG2Numeric(val,(num)->Value,(num)->Length,(num)->Decimals,exp)
#define Str2NUMERIC(str,num) \
			Str2Numeric(str,(num)->Value,(num)->Length,(num)->Decimals)
#define NUMERIC2Str(num,str) \
			Numeric2Str((num)->Value,(num)->Length,(num)->Decimals,str)

#endif 		/* _NUMERIC_PROTOS_H_ */
