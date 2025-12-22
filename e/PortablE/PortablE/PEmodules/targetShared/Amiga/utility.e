/* Portable implementations of certain functions in the 'utility' module.
*/
OPT NATIVE, POINTER
MODULE 'target/utility', 'target/exec/types'

PROC SdivMod32(dividend:VALUE, divisor:VALUE)
	DEF rem:VALUE, quot:VALUE
	quot := dividend / divisor
	rem  := dividend - (quot * divisor)
ENDPROC quot, rem

PROC UdivMod32(dividend:ULONG, divisor:ULONG)
	DEF rem:ULONG, quot:ULONG
	quot := dividend / divisor
	rem  := dividend - (quot * divisor)
ENDPROC quot, rem


->these two functions return one big value, rather than using two return values as in AmigaE

PROC Smult64(arg1:VALUE, arg2:VALUE) IS arg1 !!BIGVALUE * arg2 /*!!BIGVALUE*/

PROC Umult64(arg1:ULONG, arg2:ULONG) IS arg1 !!UBIGVALUE * arg2 /*!!UBIGVALUE*/
