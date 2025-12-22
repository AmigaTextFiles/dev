#ifndef LIBRARIES_F1GP_H
#define LIBRARIES_F1GP_H
/*
**	$VER: f1gp.h 36.1 (31.1.98)
**
**	f1gp.library definitions
**
**	(C) Copyright 1995-1999 Oliver Roberts
**	All Rights Reserved
*/

/*------------------------------------------------------------------------*/

#ifndef  EXEC_TYPES_H
#include  <exec/types.h>
#endif /* EXEC_TYPES_H */

#ifndef  EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif /* EXEC_LIBRARIES_H */

#define F1GPNAME   "f1gp.library"

/* Constants returned by f1gpDetect()
*/
#define F1GPTYPE_STANDARD	1
#define F1GPTYPE_WC		2
#define F1GPTYPE_A600WWW	3

/* Definition of the F1GP library base structure.
** Fields MUST not be modified by user programs, but they can be read.
*/
struct F1GPBase {
	struct Library LibNode;	/* Standard library node */
	LONG    F1GPType;	/* Current F1GP type - see constants above */
	ULONG   HunkStart[4];	/* Address of each of F1GP's hunks */
	LONG    Seg1;		/* HunkStart[0] - 0x2c */
	LONG    Seg3;		/* HunkStart[2] - 0x4990c/49910/49920 */
};

/* Constants used by f1gpRequestNotification(), and in F1GPMessages */

#define F1GPEVENT_QUITGAME		0x00000001
#define F1GPEVENT_EXITCOCKPIT		0x00000002

/* Message structure used by the notification feature */

struct F1GPMessage {
	struct Message ExecMessage;
	ULONG	  EventType;	/* Type of event that has occured - see above */
};

/* DisplayInfo structure returned by f1gpGetDisplayInfo() */

#define F1GPDISP_SCANDOUBLED	0x00000001
#define F1GPDISP_AGAFETCH4X	0x00000002

struct F1GPDisplayInfo {
	UWORD diwstrt;
	UWORD diwstop;
	UWORD diwhigh;
	UWORD ddfstrt;
	UWORD ddfstop;
	UWORD bplcon1;
        ULONG flags;
        UWORD def_diwstrt;
	UBYTE cwait1;
	UBYTE cwait2;
};

#endif  /* LIBRARIES_F1GP_H */
