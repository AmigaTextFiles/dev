/*
 * $Id: dprintf.c 1.5 1998/04/12 17:29:04 olsen Exp olsen $
 *
 * :ts=4
 *
 * Wipeout -- Traces and munges memory and detects memory trashing
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 * Public Domain
 */

#ifndef _GLOBAL_H
#include "global.h"
#endif	/* _GLOBAL_H */

/******************************************************************************/

typedef VOID (* ASM PUTCHAR)(REG(d0) UBYTE c,REG(a3) APTR putChData);

/******************************************************************************/

/* these are in rawio.asm */
extern VOID ASM SerPutChar(REG(d0) UBYTE c,REG(a3) APTR putChData);
extern VOID ASM ParPutChar(REG(d0) UBYTE c,REG(a3) APTR putChData);

/******************************************************************************/

STATIC PUTCHAR putChar = SerPutChar;

/******************************************************************************/

VOID
ChooseParallelOutput(VOID)
{
	Forbid();

	/* use the parallel port output routine. */
	putChar = ParPutChar;

	Permit();
}

/******************************************************************************/

VOID
DVPrintf(const STRPTR format,const va_list varArgs)
{
	/* printf() style text formatting and output */
	RawDoFmt((STRPTR)format,(APTR)varArgs,(void (*)())putChar,NULL);
}

VOID
DPrintf(const STRPTR format,...)
{
	va_list varArgs;

	/* printf() style text formatting and output, varargs version */

	va_start(varArgs,format);
	DVPrintf(format,varArgs);
	va_end(varArgs);
}
