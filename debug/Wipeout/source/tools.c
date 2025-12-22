/*
 * $Id: tools.c 1.10 1998/05/31 10:21:08 olsen Exp olsen $
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

BOOL
DecodeNumber(
	const STRPTR	number,
	LONG *			valuePtr)
{
	BOOL decoded = FALSE;
	LONG value = 0;

	/* is this a hexadecimal number? */
	if(Strnicmp(number,"0x",2) == SAME || number[0] == '$')
	{
		STRPTR string;
		UBYTE c;

		/* skip the format identifier */
		if(number[0] == '$')
			string = (STRPTR)number + 1;
		else
			string = (STRPTR)number + 2;

		decoded = TRUE;

		/* decode the number character by character */
		while((c = ToLower(*string++)) != '\0')
		{
			if('0' <= c && c <= '9')
			{
				value = (value * 16) + (c - '0');
			}
			else if ('a' <= c && c <= 'f')
			{
				value = (value * 16) + 10 + (c - 'a');
			}
			else
			{
				/* not in the range 0..9/a..f */
				decoded = FALSE;
				break;
			}
		}
	}
	else
	{
		/* decode the decimal number */
		if(StrToLong((STRPTR)number,&value))
		{
			decoded = TRUE;
		}
	}

	if(decoded)
	{
		(*valuePtr) = value;
	}

	return(decoded);
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

STATIC VOID
StripSpaces(STRPTR s)
{
	STRPTR start,t;

	start = t = s;

	/* skip leading spaces */
	while((*s) == ' ')
		s++;

	/* move the entire string */
	while((*s) != '\0')
	{
		(*t++) = (*s++);
	}

	/* skip trailing spaces */
	while(t > start && t[-1] == ' ')
		t--;

	(*t) = '\0';
}

VOID
ConvertTimeAndDate(
	const struct timeval *		tv,
	STRPTR						dateTime)
{
	STATIC UBYTE date[LEN_DATSTRING];
	STATIC UBYTE time[LEN_DATSTRING];

	struct DateTime dat;

	/* convert a timeval into a human-readable date and time text */

	ASSERT(tv != NULL);

	memset(&dat,0,sizeof(dat));

	TimeValToDateStamp(tv,&dat.dat_Stamp);

	dat.dat_Format	= FORMAT_DOS;
	dat.dat_StrDate	= date;
	dat.dat_StrTime	= time;

	/* do the conversion under Forbid() since we are going to
	 * modify static, local data
	 */
	Forbid();

	DateToStr(&dat);

	StripSpaces(date);
	StripSpaces(time);

	strcpy(dateTime,date);
	strcat(dateTime," ");
	strcat(dateTime,time);

	Permit();
}

/******************************************************************************/

struct Node *
FindIName(const struct List * list,const STRPTR name)
{
	struct Node * result = NULL;
	struct Node * node;

	/* find a name in a list, ignoring case */

	for(node = (struct Node *)list->lh_Head ;
	    node->ln_Succ != NULL ;
	    node = node->ln_Succ)
	{
		if(Stricmp(node->ln_Name,name) == SAME)
		{
			result = node;
			break;
		}
	}

	return(result);
}

/******************************************************************************/

BOOL
IsTaskStillAround(const struct Task * whichTask)
{
	struct Node * node;
	BOOL found;

	/* check whether the given task is still active and
	 * has not yet exited
	 */

	Forbid();

	found = FALSE;

	/* Looking for myself? */
	if(whichTask == FindTask(NULL))
	{
		found = TRUE;
	}

	/* Check the list of running tasks. */
	if(NOT found)
	{
		for(node = SysBase->TaskReady.lh_Head ;
		    node->ln_Succ != NULL ;
		    node = node->ln_Succ)
		{
			if(node == (struct Node *)whichTask)
			{
				found = TRUE;
				break;
			}
		}
	}

	/* Check the list of waiting tasks. */
	if(NOT found)
	{
		for(node = SysBase->TaskWait.lh_Head ;
		    node->ln_Succ != NULL ;
		    node = node->ln_Succ)
		{
			if(node == (struct Node *)whichTask)
			{
				found = TRUE;
				break;
			}
		}
	}

	Permit();

	return(found);
}
