OPT NATIVE, POINTER
MODULE 'target/aros/asmcall'
{#include <exec/rawfmt.h>}
NATIVE {EXEC_RAWFMT_H} CONST

/* Magic constants for RawDoFmt() anv VNewRawDoFmt() to be given as
   PutChProc */

NATIVE {RAWFMTFUNC_STRING} CONST RAWFMTFUNC_STRING = 0 !!VALUE!!NATIVE {VOID_FUNC} PTR /* Output to string given in PutChData	        */
NATIVE {RAWFMTFUNC_SERIAL} CONST RAWFMTFUNC_SERIAL = 1 !!VALUE!!NATIVE {VOID_FUNC} PTR /* Output to debug log (usually serial port)     */
NATIVE {RAWFMTFUNC_COUNT}  CONST RAWFMTFUNC_COUNT  = 2 !!VALUE!!NATIVE {VOID_FUNC} PTR /* Just count characters, PutChData is a pointer
					  to the counter (ULONG *)			*/
