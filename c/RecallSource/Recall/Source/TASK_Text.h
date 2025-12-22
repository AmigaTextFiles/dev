/*
 *	File:					TextWindow.h
 *	Description:	Window for texts
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef	TASK_TEXT_H
#define	TASK_TEXT_H

/*** DEFINES *************************************************************************/
#define	NOTEXT	((struct Node *)-1)

/*** GLOBALS *************************************************************************/
extern struct egTask		textTask;
extern struct Node			*textnode,
												*oldtextnode;
extern struct List			*textlist;
extern UBYTE						textname[MAXCHARS],
												forceenable;
extern UWORD						activetext;
extern ULONG						textdisabled;

extern struct egGadget	*getfile,
												*textlistview;

/*** PROTOTYPES **********************************************************************/
__asm __saveds ULONG OpenTextTask(register __a0 struct Hook *hook,
																	register __a2 APTR	      object,
																	register __a1 APTR	      message);
__asm __saveds ULONG HandleTextTask(register __a0 struct Hook *hook,
																	register __a2 APTR	      object,
																	register __a1 APTR	      message);
void UpdateTextTask(void);
void ResetTextTask(void);
void GetFirstText(void);
void AddText(UBYTE *name);
void CopyText(void);
void CutText(void);
void PasteText(void);
void GetFileName(void);
void GetField(void);
void GetSelectedText(UWORD code);

#endif
