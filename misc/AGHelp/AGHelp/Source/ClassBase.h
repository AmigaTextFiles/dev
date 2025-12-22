#ifndef CLASSBASE_H
#define CLASSBASE_H

#include <exec/execbase.h>
#include <exec/libraries.h>
#include <exec/semaphores.h>
#include <intuition/classes.h>
#include <intuition/intuitionbase.h>
#include "rev.h"


struct ClassBase
{
	struct ClassLibrary	cb_Library;

	/* The following data is PRIVATE. Hands off! ;) */

	BPTR			cb_SegList;

	struct ExecBase		*cb_SysBase;
	struct IntuitionBase	*cb_IntuitionBase;
	struct Library		*cb_UtilityBase;

	struct SignalSemaphore	cb_Semaphore;
}; /* struct ClassBase */


typedef struct ClassBase	ClassBase;


#define SysBase		classBase->cb_SysBase
#define IntuitionBase	classBase->cb_IntuitionBase
#define UtilityBase	classBase->cb_UtilityBase


#define CB_VERSION	VERNUM
#define CB_REVISION	REVNUM
#define CB_NAME		"aghelp.class"
#define CB_ID		"aghelp.class " VERSION " (" DATE ")\r\n"


#endif /* CLASSBASE_H */
