/*
 * $Id$
 *
 * :ts=4
 *
 * Blowup -- Catches and displays task errors
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 * Public Domain
 */

#ifndef _BLOWUPSEMAPHORE_H
#define _BLOWUPSEMAPHORE_H 1

/****************************************************************************/

#define BLOWUPSEMAPHORENAME	"« Blowup »"
#define BLOWUPSEMAPHOREVERSION 1

/****************************************************************************/

struct BlowupSemaphore
{
	struct SignalSemaphore	bs_SignalSemaphore;	/* regular semaphore */
	WORD					bs_Version;			/* semaphore version number */

	UBYTE					bs_SemaphoreName[(sizeof(BLOWUPSEMAPHORENAME)+3) & ~3];

	struct Task *			bs_Owner;			/* semaphore owner (creator) */

	BOOL *					bs_ARegCheck;		/* all options */
	BOOL *					bs_DRegCheck;
	BOOL *					bs_StackCheck;
	LONG *					bs_StackLines;
};

/****************************************************************************/

#endif /* _BLOWUPSEMAPHORE_H */
