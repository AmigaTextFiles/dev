/* PE/compatibility.e 16-04-09
   The module is used by OPT AMIGAE.
*/
OPT INLINE
MODULE 'target/PE/base'
PUBLIC MODULE 'target/dos'      , 'target/PEalias/dos'
PUBLIC MODULE 'target/exec'     , 'target/PEalias/exec'
PUBLIC MODULE 'target/graphics' , 'target/PEalias/graphics', 'target/graphics/gfxmacros'
PUBLIC MODULE 'target/intuition', 'target/PEalias/intuition'

PUBLIC MODULE 'target/wb'       , 'target/PEalias/wb'

PUBLIC MODULE 'target/PEalias/CtrlC'


PROC WriteF(fmtString:ARRAY OF CHAR, arg1=0, arg2=0, arg3=0, arg4=0, arg5=0, arg6=0, arg7=0, arg8=0)
	Print(fmtString, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
	PrintFlush()
ENDPROC

PROC PrintF(fmtString:ARRAY OF CHAR, arg1=0, arg2=0, arg3=0, arg4=0, arg5=0, arg6=0, arg7=0, arg8=0) IS Print(fmtString, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)

PROC Char(ptr:PTR TO CHAR) IS GetChar(ptr)

PROC Int( ptr:PTR TO INT ) IS GetInt( ptr)

PROC Long(ptr:PTR TO LONG) IS GetLong(ptr)

PROC Eor(a, b) IS Xor(a, b)

PROC List(maxLen) IS NewList(maxLen)

PROC String(maxLen) IS NewString(maxLen)

PROC FastDisposeList(list:LIST) IS DisposeList(list)

PROC DisposeLink(eString:STRING) IS DisposeString(eString)


/* compatibility hacks */

PROC UpperStr(string:ARRAY OF CHAR) REPLACEMENT IS IF string THEN SUPER UpperStr(string) ELSE string
PROC LowerStr(string:ARRAY OF CHAR) REPLACEMENT IS IF string THEN SUPER LowerStr(string) ELSE string
