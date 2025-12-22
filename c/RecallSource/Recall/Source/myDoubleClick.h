/*
 *	File:					myDoubleClick.h
 *	Description:	Checks if a doubleclick has occured.
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef MYDOUBLECLICK_H
#define	MYDOUBLECLICK_H

/*** DEFINES *************************************************************************/
#define	ClearDoubleClick()	(mydoubleclick.selected=-9)

/*** GLOBALS *************************************************************************/
struct myDoubleClick
{
	ULONG seconds,
				micros,
				selected;
};

extern struct myDoubleClick	mydoubleclick;

/*** PROTOTYPES **********************************************************************/
BYTE CheckDoubleClick(struct IntuiMessage *msg, ULONG selected);
#endif
