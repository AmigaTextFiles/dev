#ifndef  CLIB_F1GP_PROTOS_H
#define  CLIB_F1GP_PROTOS_H

/*
**	$VER: f1gp_protos.h 36.1 (31.1.98)
**
**	C prototypes.
**
**	(C) Copyright 1995-1999 Oliver Roberts
**	    All Rights Reserved
*/

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif

 LONG f1gpDetect(VOID);
ULONG f1gpCalcChecksum(UBYTE *data, ULONG datasize);
 APTR f1gpRequestNotification(struct MsgPort *msgport, ULONG events);
 VOID f1gpStopNotification(APTR node);
struct F1GPDisplayInfo *f1gpGetDisplayInfo(VOID);

/* OBSOLETE -- Please use the new notification functions instead */

 APTR f1gpAllocQuitNotify(struct Task *task, ULONG signal);
 VOID f1gpFreeQuitNotify(APTR node);

#endif	 /* CLIB_F1GP_PROTOS_H */
