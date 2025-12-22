/*
 * $Id: tools.c 1.3 1998/04/18 15:45:46 olsen Exp olsen $
 *
 * :ts=4
 *
 * Blowup -- Catches and displays task errors
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 * Public Domain
 */

#ifndef _GLOBAL_H
#include "global.h"
#endif	/* _GLOBAL_H */

/******************************************************************************/

VOID
StrcpyN(LONG MaxLen,STRPTR To,const STRPTR From)
{
	ASSERT(To != NULL && From != NULL);

	/* copy a string, but only up to MaxLen characters */

	if(MaxLen > 0)
	{
		LONG Len = strlen(From);

		if(Len >= MaxLen)
			Len = MaxLen - 1;

		strncpy(To,From,Len);
		To[Len] = '\0';
	}
}

/******************************************************************************/

struct FormatContext
{
	STRPTR	Index;
	LONG	Size;
	BOOL	Overflow;
};

STATIC VOID ASM
StuffChar(
	REG(a3)	struct FormatContext *	Context,
	REG(d0) UBYTE					Char)
{
	/* Is there still room? */
	if(Context->Size > 0)
	{
		(*Context->Index) = Char;

		Context->Index++;
		Context->Size--;

		/* Is there only a single character left? */
		if(Context->Size == 1)
		{
			/* Provide null-termination. */
			(*Context->Index) = '\0';

			/* Don't store any further characters. */
			Context->Size = 0;
		}
	}
	else
	{
		Context->Overflow = TRUE;
	}
}

BOOL
VSPrintfN(
	LONG			MaxLen,
	STRPTR			Buffer,
	const STRPTR	FormatString,
	const va_list	VarArgs)
{
	BOOL result = FAILURE;

	/* format a text, but place only up to MaxLen
	 * characters in the output buffer (including
	 * the terminating NUL)
	 */

	ASSERT(Buffer != NULL && FormatString != NULL);

	if(MaxLen > 1)
	{
		struct FormatContext Context;

		Context.Index		= Buffer;
		Context.Size		= MaxLen;
		Context.Overflow	= FALSE;

		RawDoFmt(FormatString,(APTR)VarArgs,(VOID (*)())StuffChar,(APTR)&Context);

		if(NO Context.Overflow)
			result = SUCCESS;
	}

	return(result);
}

BOOL
SPrintfN(
	LONG			MaxLen,
	STRPTR			Buffer,
	const STRPTR	FormatString,
					...)
{
	va_list VarArgs;
	BOOL result;

	/* format a text, varargs version */

	ASSERT(Buffer != NULL && FormatString != NULL);

	va_start(VarArgs,FormatString);
	result = VSPrintfN(MaxLen,Buffer,FormatString,VarArgs);
	va_end(VarArgs);

	return(result);
}

/******************************************************************************/

STATIC VOID
TimeValToDateStamp(
	const struct timeval *	tv,
	struct DateStamp *		ds)
{
	/* convert a timeval to a DateStamp */

	ds->ds_Days		= tv->tv_secs / (24 * 60 * 60);
	ds->ds_Minute	= (tv->tv_secs % (24 * 60 * 60)) / 60;
	ds->ds_Tick		= (tv->tv_secs % 60) * TICKS_PER_SECOND + (tv->tv_micro * TICKS_PER_SECOND) / 1000000;
}

/******************************************************************************/

VOID
ConvertTimeAndDate(
	const struct timeval *		tv,
	STRPTR						dateTimeBuffer)
{
	UBYTE dateBuffer[LEN_DATSTRING];
	UBYTE timeBuffer[LEN_DATSTRING];
	struct DateTime dat;

	/* convert a timeval into a human-readable date and time text */

	ASSERT(tv != NULL);

	memset(&dat,0,sizeof(dat));

	TimeValToDateStamp(tv,&dat.dat_Stamp);

	dat.dat_Format	= FORMAT_DOS;
	dat.dat_StrDate	= dateBuffer;
	dat.dat_StrTime	= timeBuffer;

	DateToStr(&dat);

	strcpy(dateTimeBuffer,dateBuffer);
	strcat(dateTimeBuffer,timeBuffer);
}
