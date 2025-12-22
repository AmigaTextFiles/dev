/*
 *	File:					System.h
 *	Description:	
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef SYSTEM_H
#define	SYSTEM_H

/*** DEFINES *************************************************************************/
#define INTUI_V36_NAMES_ONLY
#define __USE_SYSBASE
#define USE_BUILTIN_MATH

/*** GLOBAL SYSTEM INCLUDES **********************************************************/
#include <exec/memory.h>
#include <libraries/gadtools.h>
#include <intuition/intuition.h>
#include <exec/ports.h>
#include <workbench/workbench.h>
#include <workbench/startup.h>

#include <string.h>
#include <stdlib.h>

/*** SYSTEM PROTOTYPES **************************************************************/
#include <clib/intuition_protos.h>
#include <clib/macros.h>
#include <clib/alib_stdio_protos.h>
#include <clib/alib_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/dos_protos.h>
#include <clib/diskfont_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>
#include <clib/exec_protos.h>
#include <clib/diskfont_protos.h>
#include <clib/wb_protos.h>
#include <clib/icon_protos.h>

#include <libraries/reqtools.h>
#include <proto/reqtools.h>

/*** LOCALE LANGUAGE CATALOGS HANDLING **********************************************/
#include <libraries/locale.h>
#include <pragmas/locale_pragmas.h>
#include <clib/locale_protos.h>

#define	CATCOMP_NUMBERS

/*** PRIVATE INCLUDES ****************************************************************/
#include <libraries/easygadgets.h>
#include <clib/easygadgets_protos.h>

#include <libraries/morereq.h>
#include <clib/morereq_protos.h>

#include <libraries/EasyRexx.h>
#include <clib/EasyRexx_protos.h>

#include "myinclude:mydebug.h"

#include "Myinclude:BitMacros.h"
#include "Recall_REV.h"
#include "eg:macros.h"
#include "list.h"

#endif
