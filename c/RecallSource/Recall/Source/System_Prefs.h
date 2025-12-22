/*
 *	File:					System_Prefs.h
 *	Description:	Includes and globals for Recall Preferences only
 *
 *	(C) 1995, Ketil Hunn
 *
 */

#ifndef	SYSTEM_PREFS_H
#define	SYSTEM_PREFS_H

/*** INCLUDES ************************************************************************/
#include "System.h"
#include "RecallModules.h"
#include "GUI_Environment.h"
#include "TASK_Main.h"
#include "TASK_Text.h"
#include "TASK_Date.h"
#include "TASK_Attrib.h"
//#include "TASK_Assign.h"
#include "TASK_About.h"
#include "TASK_Find.h"
//#include "Prefs_AREXX.h"
#include "makekey:Key.h"

/*** GLOBALS *************************************************************************/
#include <myinclude:Boopsi/dateselectorgadclass.h>
extern Class *DSGClass;

extern struct SignalSemaphore	*eventsemaphore;
extern UBYTE	prefsfile[MAXCHARS],
							activatewindow,
							usereqtools;

extern struct MsgPort *ioport;

extern BYTE keyok;
extern struct Key	key;


#endif
