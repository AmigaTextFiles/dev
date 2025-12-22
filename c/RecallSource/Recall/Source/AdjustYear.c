/*
 *	File:					AdjustYear.c
 *	Description:	
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef ADJUSTYEAR_C
#define ADJUSTYEAR_C

/*** PRIVATE INCLUDES ****************************************************************/
#include "System.h"
#include "AdjustYear.h"

/*** FUNCTIONS ***********************************************************************/
int AdjustYear(int year)
{
#ifdef MYDEBUG_H
	DebugOut("AdjustYear");
#endif
	if(year<10)
		year+=1990;
	else if(year<100)
		year+=1900;
	else if(year<1000)
		year+=1000;

	return year;
}

#endif
