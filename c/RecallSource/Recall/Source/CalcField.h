/*
 *	File:					CalcField.h
 *	Description:	Replaces date fields with it's true value.
 *
 *	(C) 1993,1994,1995 Ketil Hunn
 *
 */

#ifndef CALCFIELD_H
#define CALCFIELD_H

/*** PROTOTYPES **********************************************************************/
UBYTE *ParseFields(struct QuickNode *quicknode, UBYTE *newtext, UBYTE *text);
ULONG countDays(struct DateNode *node);
LONG countMins(struct DateNode *node);

#endif
