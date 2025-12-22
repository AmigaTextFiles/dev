/*
 *	File:					TASK_Attrib.h
 *	Description:	Window for attributes
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef	TASK_ATTRIB_H
#define	TASK_ATTRIB_H

/*** DEFINES *************************************************************************/
#define IsShow(s)					(eventnode==NULL ? TRUE:eventnode->show==s)
#define IsType(t)					(eventnode==NULL ? TRUE:eventnode->type==t)

/*** GLOBALS *************************************************************************/
extern struct egTask	attribTask;

/*** PROTOTYPES **********************************************************************/
__asm ULONG OpenAttribTask(	register __a0 struct Hook *hook,
														register __a2 APTR	      object,
														register __a1 APTR	      message);
__asm ULONG HandleAttribTask(	register __a0 struct Hook *hook,
															register __a2 APTR	      object,
															register __a1 APTR	      message);
void UpdateAttribTask(void);
BYTE SelectPubScreen(char **pubname);
#endif
