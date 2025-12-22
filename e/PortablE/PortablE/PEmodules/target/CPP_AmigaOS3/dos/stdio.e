/* $VER: stdio.h 36.6 (1.11.1991) */
OPT NATIVE, INLINE
MODULE 'dos/dos'
MODULE 'target/exec/types'
{#include <dos/stdio.h>}
NATIVE {DOS_STDIO_H} CONST

NATIVE {ReadChar} PROC	->ReadChar()		FGetC(Input())
NATIVE {WriteChar} PROC	->WriteChar(c)		FPutC(Output(),(c))
NATIVE {UnReadChar} PROC	->UnReadChar(c)		UnGetC(Input(),(c))
/* next one is inefficient */
NATIVE {ReadChars} PROC	->ReadChars(buf,num)	FRead(Input(),(buf),1,(num))
NATIVE {ReadLn} PROC	->ReadLn(buf,len)		FGets(Input(),(buf),(len))
NATIVE {WriteStr} PROC	->WriteStr(s)		FPuts(Output(),(s))
NATIVE {VWritef} CONST	->VWritef(format,argv)	VFWritef(Output(),(format),(argv))

->Not supported for some reason: PROC ReadChar() IS NATIVE {ReadChar()} ENDNATIVE !!LONG
->Not supported for some reason: PROC WriteChar( c:CHAR) IS NATIVE {WriteChar( (long) } c {)} ENDNATIVE !!LONG
->Not supported for some reason: PROC UnReadChar(c:CHAR) IS NATIVE {UnReadChar( (long) } c {)} ENDNATIVE !!LONG
/* next one is inefficient */
->Not supported for some reason: PROC ReadChars(buf:APTR, num:ULONG) IS NATIVE {ReadChars(} buf {,} num {)} ENDNATIVE !!LONG
->Not supported for some reason: PROC ReadLn(   buf:ARRAY OF CHAR,  len:ULONG) IS NATIVE {ReadLn(} buf {,} len {)} ENDNATIVE !!ARRAY OF CHAR
->Not supported for some reason: PROC WriteStr(   s:ARRAY OF CHAR) IS NATIVE {WriteStr(} s {)} ENDNATIVE !!LONG
->Not supported for some reason: PROC Vwritef(format:ARRAY OF CHAR, argv:ARRAY OF VALUE) IS NATIVE {VWritef(} format {,} argv {)} ENDNATIVE

/* types for SetVBuf */
NATIVE {BUF_LINE}	CONST BUF_LINE	= 0	/* flush on \n, etc */
NATIVE {BUF_FULL}	CONST BUF_FULL	= 1	/* never flush except when needed */
NATIVE {BUF_NONE}	CONST BUF_NONE	= 2	/* no buffering */

/* EOF return value */
NATIVE {ENDSTREAMCH}	CONST ENDSTREAMCH	= -1
