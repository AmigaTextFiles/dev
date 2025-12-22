/*
 *	File:					TASK_FIND.h
 *	Description:	Window for find
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef	TASK_FIND_H
#define	TASK_FIND_H

/*** GLOBALS *************************************************************************/
extern struct egTask	findTask;

struct FinderStruct
{
	UBYTE findstring[MAXCHARS],
				replacestring[MAXCHARS];
	BYTE	ignorecase,
				onlywholewords,
				replacemode,
				done,
				replaceall;
};

extern struct FinderStruct finder;

/*** PROTOTYPES **********************************************************************/
__asm ULONG OpenFindTask(	register __a0 struct Hook *hook,
													register __a2 APTR	      object,
													register __a1 APTR	      message);
__asm ULONG HandleFindTask(	register __a0 struct Hook *hook,
														register __a2 APTR	      object,
														register __a1 APTR	      message);
void FindReplace(void);
void UpdateFindTask(void);
#endif
