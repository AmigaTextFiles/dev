/*
 *	File:					Clipboard.h
 *	Description:	
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef CLIPBOARD_H
#define CLIPBOARD_H

/*** PROTOTYPES **********************************************************************/
int StringToClipboard(ULONG unit, STRPTR string);
struct Node *ClipboardToList(ULONG unit, struct List *list, struct Node *pnode);
#endif
