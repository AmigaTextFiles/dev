/*
 *	File:					myDoubleClick.c
 *	Description:	Checks if a doubleclick has occured.
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef MYDOUBLECLICK_C
#define	MYDOUBLECLICK_C

/*** INCLUDES ************************************************************************/
#include "System.h"
#include "myDoubleClick.h"

/*** GLOBALS *************************************************************************/
struct myDoubleClick	mydoubleclick;

/*** FUNCTIONS ***********************************************************************/
BYTE CheckDoubleClick(struct IntuiMessage *msg, ULONG selected)
{
#ifdef MYDEBUG_H
	DebugOut("CheckDoubleClick");
#endif

	if(selected==mydoubleclick.selected &&
			DoubleClick(mydoubleclick.seconds, mydoubleclick.micros,
									msg->Seconds, msg->Micros))
		return TRUE;
	mydoubleclick.seconds	=msg->Seconds;
	mydoubleclick.micros	=msg->Micros;
	mydoubleclick.selected=selected;
	return FALSE;
}

#endif
