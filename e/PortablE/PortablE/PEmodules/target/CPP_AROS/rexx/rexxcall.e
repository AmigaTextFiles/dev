OPT NATIVE, INLINE
MODULE 'target/exec/types'
MODULE 'target/rexx/storage', 'target/exec/libraries'
{#include <rexx/rexxcall.h>}
NATIVE {REXX_REXXCALL_H} CONST

/* Some macro's to make ARexx portable to non-m68k platforms */
NATIVE {RexxCallQueryLibFunc} PROC
PROC RexxCallQueryLibFunc(rexxmsg:PTR TO rexxmsg, libbase:PTR TO lib, offset, retargstringptr:ARRAY OF /*STRPTR*/ ARRAY OF CHAR) IS NATIVE {RexxCallQueryLibFunc(} rexxmsg {,} libbase {,} offset {,} retargstringptr {)} ENDNATIVE !!ULONG 

NATIVE {AROS_AREXXLIBQUERYFUNC} CONST
->#can't get to work: PROC Aros_ARexxLibQueryFunc(f:PTR, m:PTR TO rexxmsg, lt, l, o, p) IS NATIVE {AROS_AREXXLIBQUERYFUNC( (void (*)(long,long))} f {,} m {,} lt {,} l {,} o {,} p {)} ENDNATIVE !!ULONG

NATIVE {AROS_AREXXLIBQUERYFUNC_END}     CONST

NATIVE {ReturnRexxQuery} PROC
->#can't get to work: PROC ReturnRexxQuery(rc, arg) IS NATIVE {ReturnRexxQuery(} rc {,} arg {)} ENDNATIVE !!VALUE
