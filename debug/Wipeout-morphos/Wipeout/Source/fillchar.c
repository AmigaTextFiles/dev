/*
 * $Id: fillchar.c,v 1.1 2005/12/21 19:48:23 itix Exp $
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

STATIC UBYTE FillChar = 0x81;		/* our memory wall fill character */
STATIC BOOL FillCharRolling = TRUE;	/* if TRUE, fill character will change with every allocation */

/******************************************************************************/

VOID
SetFillChar(UBYTE newFillChar)
{
	Forbid();

	/* use the new fill character and stop it from changing */
	FillChar = newFillChar;
	FillCharRolling = FALSE;

	Permit();
}

/******************************************************************************/

UBYTE
NewFillChar(VOID)
{
	UBYTE result;

	/* return the next fill character; keep returning a
	 * constant fill character if this is what the
	 * user wanted.
	 */

	Forbid();

	/* change the fill character? */
	if(FillCharRolling)
	{
		if(FillChar == 0xFF)
		{
			/* roll over when it has reached its
			 * maximum value
			 */
			FillChar = 0x81;
		}
		else
		{
			/* use the next odd number */
			FillChar = FillChar + 2;
		}
	}

	result = FillChar;

	Permit();

	return(result);
}

/******************************************************************************/

BOOL
WasStompedUpon(
	UBYTE *		mem,
	LONG		memSize,
	UBYTE		fillChar,
	UBYTE **	stompPtr,
	LONG *		stompSize)
{
	UBYTE * first = NULL;
	UBYTE * last = NULL;
	BOOL stomped = FALSE;
	LONG i;

	/* check if the given memory area was partly or entirely
	 * overwritten; we compare its contents against the given
	 * fill character and remember the smallest interval whose
	 * contents do not match the character
	 */
	for(i = 0 ; i < memSize ; i++)
	{
		if(mem[i] != fillChar)
		{
			if(first == NULL)
			{
				first = &mem[i];
			}

			last = &mem[i];
		}
	}

	/* if some memory was changed, remember where the first
	 * and where the last modified byte was and return that
	 * information
	 */
	if(first != NULL && last != NULL)
	{
		(*stompPtr)		= first;
		(*stompSize)	= (ULONG)last - (ULONG)first + 1;

		stomped = TRUE;
	}

	return(stomped);
}
