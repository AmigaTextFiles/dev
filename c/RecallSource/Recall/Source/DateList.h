/*
 *	File:					DateList.h
 *	Description:	Makes the computing of dates a lot faster
 *
 *	(C) 1994,1995, Ketil Hunn
 *
 */

#ifndef	DATELIST_H
#define	DATELIST_H

/*** INCLUDES ************************************************************************/
#include "RecallModules.h"

/*** GLOBALS *************************************************************************/
extern LONG	datenow, olddatenow, timenow;

/*** PROTOTYPES **********************************************************************/
struct QuickNode *AddQuickNode(	struct List				*list,
																struct EventNode	*eventnode,
																struct DateNode		*datenode);
void CreateQuickList(struct List *quicklist, struct List *list);
BYTE MarkDisplay(struct List *list, BYTE startup);
void ExecuteNode(struct EventNode *eventnode);
BYTE CheckProject(struct List *list, BYTE startup);
char *CatSingleEventTexts(struct QuickNode *quicknode, char *text);
char *CatGroupEventsTexts(struct Node *innode, short type, char *text);
LONG ShowRequest(	UBYTE *screenname,
									UBYTE *text,
									UBYTE *buttons,
									BYTE	centre,
									UBYTE *params);
void SendTimeIO(struct timerequest *timerIO, ULONG secs, ULONG micros);

#endif
