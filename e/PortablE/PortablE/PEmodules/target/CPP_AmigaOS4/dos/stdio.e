/* $Id: stdio.h,v 1.11 2005/11/10 15:32:20 hjfrieden Exp $ */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types'
{#include <dos/stdio.h>}
NATIVE {DOS_STDIO_H} CONST

NATIVE {ReadChar} PROC	->ReadChar()             FGetC(Input())
NATIVE {WriteChar} PROC	->WriteChar(c)           FPutC(Output(),(c))
NATIVE {UnReadChar} PROC	->UnReadChar(c)          UnGetC(Input(),(c))

/* next one is inefficient */
NATIVE {ReadChars} PROC	->ReadChars(buf,num)     FRead(Input(),(buf),1,(num))
NATIVE {ReadLn} PROC	->ReadLn(buf,len)        FGets(Input(),(buf),(len))
NATIVE {WriteStr} PROC	->WriteStr(s)            FPuts(Output(),(s))


->Not supported for some reason: PROC ReadChar() IS NATIVE {IDOS->ReadChar()} ENDNATIVE !!LONG
->Not supported for some reason: PROC WriteChar( c:CHAR) IS NATIVE {IDOS->WriteChar( (long) } c {)} ENDNATIVE !!LONG
->Not supported for some reason: PROC UnReadChar(c:CHAR) IS NATIVE {IDOS->UnReadChar( (long) } c {)} ENDNATIVE !!LONG
/* next one is inefficient */
->Not supported for some reason: PROC ReadChars(buf:APTR, num:ULONG) IS NATIVE {IDOS->ReadChars(} buf {,} num {)} ENDNATIVE !!LONG
->Not supported for some reason: PROC ReadLn(   buf:ARRAY OF CHAR,  len:ULONG) IS NATIVE {IDOS->ReadLn(} buf {,} len {)} ENDNATIVE !!ARRAY OF CHAR
->Not supported for some reason: PROC WriteStr(   s:ARRAY OF CHAR) IS NATIVE {IDOS->WriteStr(} s {)} ENDNATIVE !!LONG
->PROC Vwritef(format:ARRAY OF CHAR, argv:ARRAY OF VALUE) IS NATIVE {IDOS->VWritef(} format {,} argv {)} ENDNATIVE

/****************************************************************************/

/* types for SetVBuf */
NATIVE {BUF_LINE}    CONST BUF_LINE    = 0    /* flush on \n, etc */
NATIVE {BUF_FULL}    CONST BUF_FULL    = 1    /* never flush except when needed */
NATIVE {BUF_NONE}    CONST BUF_NONE    = 2    /* no buffering */

/****************************************************************************/

/* EOF return value */
NATIVE {ENDSTREAMCH}    CONST ENDSTREAMCH    = (-1)
