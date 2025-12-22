/*
 *	File:					TASK_Date.h
 *	Description:	Window for calendar
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef	TASK_DATE_H
#define	TASK_DATE_H

/*** DEFINES *************************************************************************/
#define	NODATE	((struct DateNode *)-1)

/*** GLOBALS *************************************************************************/
extern struct egTask		dateTask;

extern struct DateNode	*datenode, *olddatenode;
extern struct Node			*datebuffer;
extern struct List			*datelist;

extern UBYTE						dateformat,
												dateformatsplit[2];

/*** PROTOTYPES **********************************************************************/
__asm ULONG OpenDateTask(		register __a0 struct Hook *hook,
														register __a2 APTR	      object,
														register __a1 APTR	      message);
__asm ULONG CloseDateTask(	register __a0 struct Hook *hook,
														register __a2 APTR	      object,
														register __a1 APTR	      message);
__asm ULONG HandleDateTask(	register __a0 struct Hook *hook,
														register __a2 APTR	      object,
														register __a1 APTR	      message);
void GetFirstDate(void);
void UpdateDateTask(void);
void UpdateCalendar(BYTE disable);
void UpdateWhendateLinks(BYTE flag);
void UpdateWhentimeLinks(BYTE flag);
void SetWhenString(struct DateNode *datenode, BYTE update);
ULONG datehelp(struct Hook *hook, VOID *o, VOID *m);
void GetDateNode(void);
void NewDate(void);
void CutDate(void);
void PasteDate(void);

#endif
