/* $Id: stdio.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types'
{#include <dos/stdio.h>}
NATIVE {DOS_STDIO_H} CONST

  /* Read one character from stdin. */
NATIVE {ReadChar} PROC	->ReadChar()           FGetC(Input())
  /* Write one character to stdout. */
NATIVE {WriteChar} PROC	->WriteChar(c)         FPutC(Output(),(c))
  /* Put one character back to stdin. Normally this is only guaranteed to
     work once. */
NATIVE {UnReadChar} PROC	->UnReadChar(c)        UnGetC(Input(),(c))
  /* Read a number of chars from stdin. */
NATIVE {ReadChars} PROC	->ReadChars(buf,num)   FRead(Input(), (buf), 1, (num))
  /* Read a whole line from stdin. */
NATIVE {ReadLn} PROC	->ReadLn(buf,len)      FGets(Input(), (buf), (len))
  /* Write a string to stdout. */
NATIVE {WriteStr} PROC	->WriteStr(s)          FPuts(Output(), (s))
  /* Write a formatted string to stdout. */
NATIVE {VWritef} CONST	->VWritef(format,argv) VFWritef(Output(), (format), (argv))


->Not supported for some reason: PROC ReadChar() IS NATIVE {ReadChar()} ENDNATIVE !!LONG
->Not supported for some reason: PROC WriteChar( c:CHAR) IS NATIVE {WriteChar( (long) } c {)} ENDNATIVE !!LONG
->Not supported for some reason: PROC UnReadChar(c:CHAR) IS NATIVE {UnReadChar( (long) } c {)} ENDNATIVE !!LONG
/* next one is inefficient */
->Not supported for some reason: PROC ReadChars(buf:APTR, num:ULONG) IS NATIVE {ReadChars(} buf {,} num {)} ENDNATIVE !!LONG
->Not supported for some reason: PROC ReadLn(   buf:ARRAY OF CHAR,  len:ULONG) IS NATIVE {ReadLn(} buf {,} len {)} ENDNATIVE !!ARRAY OF CHAR
->Not supported for some reason: PROC WriteStr(   s:ARRAY OF CHAR) IS NATIVE {WriteStr(} s {)} ENDNATIVE !!LONG
->Not supported for some reason: PROC Vwritef(format:ARRAY OF CHAR, argv:ARRAY OF SLONG) IS NATIVE {VWritef(} format {,} argv {)} ENDNATIVE

/* DOS functions will return this when they reach EOF. */
NATIVE {ENDSTREAMCH} CONST ENDSTREAMCH = -1

/* Buffering types for SetVBuf(). */
NATIVE {BUF_LINE} CONST BUF_LINE = 0 /* Flush at the end of lines '\n'. */
NATIVE {BUF_FULL} CONST BUF_FULL = 1 /* Flush only when buffer is full. */
NATIVE {BUF_NONE} CONST BUF_NONE = 2 /* Do not buffer, read and write immediatly. */
