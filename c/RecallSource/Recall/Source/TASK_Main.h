/*
 *	File:					TASK_Event.h
 *	Description:	Main window
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef	TASK_EVENT_H
#define	TASK_EVENT_H

/*** DEFINES *************************************************************************/
#define	NOEVENT	((struct EventNode *)-1)

/*** GLOBALS *************************************************************************/
extern struct egTask	mainTask;
extern UWORD	activeevent;

extern struct egGadget	*eventlistview,
												*eventstring;
extern struct List			*eventlist,
												*rootlist;
extern struct EventNode *eventnode,
												*eventbuffer,
												*oldeventnode;

extern UBYTE						eventname[MAXCHARS];
extern ULONG						closemsg;

/*** PROTOTYPES **********************************************************************/
__asm ULONG OpenMainTask(register __a0 struct Hook *hook,
														register __a2 APTR	      object,
														register __a1 APTR	      message);
__asm ULONG CloseMainTask(register __a0 struct Hook *hook,
														register __a2 APTR	      object,
														register __a1 APTR	      message);
__asm ULONG HandleMainTask(register __a0 struct Hook *hook,
														register __a2 APTR	      object,
														register __a1 APTR	      message);
void UpdateMainTask(void);
void ResetMainTask(void);
void CopyEvent(void);
void CutEvent(void);
void PasteEvent(void);
void NewProject(BYTE force);
void TestProject(void);

void GetSelectedEvent(struct IntuiMessage *msg);
void GetFirstEvent(void);
void AddEvent(UBYTE type, UBYTE *name);
void RenameEvent(UBYTE *name);

#endif

