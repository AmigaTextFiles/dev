/*
 *	File:					cursorHook.h
 *	Description:	Cursor controlment from stringgadgets.
 *
 *	(C) 1995, Ketil Hunn
 *
 */

#ifndef CURSORHOOK_H
#define CURSORHOOK_H

/*** INCLUDES ************************************************************************/
#ifndef INTUITION_SGHOOKS_H
#include <intuition/sghooks.h>
#endif

/*** DEFINES *************************************************************************/
#define	IDCMP_LISTVIEWCURSOR	~0

/*** GLOBALS *************************************************************************/
extern struct Hook cursorHook;

/*** PROTOTYPES **********************************************************************/
void initCursorHook(void);
__asm __saveds ULONG cursorHookFunc(register __a0 struct Hook		*hook,
																		register __a2 struct SGWork	*sgw,
																		register __a1 ULONG					*msg);

#endif
