/*
 *	File:					System_Recall.h
 *	Description:	Includes and globals for Recall Checker only
 *
 *	(C) 1995, Ketil Hunn
 *
 */

#ifndef	SYSTEM_RECALL_H
#define	SYSTEM_RECALL_H

/*** INCLUDES ************************************************************************/
#include "System.h"
#include "Recall_locale.h"
#include "RecallModules.h"

/*** DEFINES *************************************************************************/
#define DEFAULTWAIT			60
#define	DEFAULTBUFFER		3000

#define CATALOG					"Recall/Recall.catalog"

#define GROUP_STAMP			-1
#define POSTPONE_STAMP	-2


/*** GLOBALS *************************************************************************/
extern struct LocaleInfo	li;
extern struct Locale			*locale;	
extern LONG								datenow, timenow;

extern ULONG							buffersize;

extern UBYTE							title[40],
													usereqtools;

struct QuickNode
{
	struct Node	nn_Node;
	ULONG date,
				time;
	struct EventNode	*eventnode;
	struct DateNode		*datenode;
};

#endif
