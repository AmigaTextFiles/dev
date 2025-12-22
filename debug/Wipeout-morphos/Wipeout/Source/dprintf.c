/*
 * $Id: dprintf.c,v 1.1 2005/12/21 19:48:23 itix Exp $
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

VOID
DVPrintf(CONST_STRPTR format, va_list varArgs)
{
	/* printf() style text formatting and output */
	VNewRawDoFmt(format, (APTR)RAWFMTFUNC_SERIAL, NULL, varArgs);
}

VOID
DPrintf(CONST_STRPTR format,...)
{
	va_list varArgs;

	/* printf() style text formatting and output, varargs version */

	va_start(varArgs,format);
	DVPrintf(format,varArgs);
	va_end(varArgs);
}
