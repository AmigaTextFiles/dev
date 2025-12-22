#ifndef EXT_STARTUP_H
#define EXT_STARTUP_H 1
/****************************************************************************

$Source: MASTER:include/ext/startup.h,v $
$Revision: 1.0 $
$Date: 1994/12/18 12:02:57 $

Public include for the standard startup modules c_lib.o and c_task.o.

****************************************************************************/

/* Prototypes for startup code. */

void StdSetup(struct ExecBase *sysbase);                       /* libraries */
void __asm StdEntry(register __a6 struct ExecBase *sysbase);   /* tasks */


#endif
