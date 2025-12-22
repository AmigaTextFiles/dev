/*
 * $Id: system_headers.h 1.2 1998/04/18 15:45:40 olsen Exp olsen $
 *
 * :ts=4
 *
 * Blowup -- Catches and displays task errors
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 * Public Domain
 */

#ifndef _SYSTEM_HEADERS_H
#define _SYSTEM_HEADERS_H 1

/******************************************************************************/

#include <intuition/intuition.h>

#include <exec/execbase.h>
#include <exec/memory.h>
#include <exec/libraries.h>
#include <exec/alerts.h>

#include <devices/timer.h>

#include <dos/dosextens.h>
#include <dos/dostags.h>
#include <dos/rdargs.h>

#include <clib/intuition_protos.h>
#include <clib/utility_protos.h>
#include <clib/timer_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/alib_protos.h>

#include <pragmas/exec_sysbase_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/utility_pragmas.h>
#include <pragmas/timer_pragmas.h>
#include <pragmas/dos_pragmas.h>

/******************************************************************************/

#define USE_BUILTIN_MATH
#include <string.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdlib.h>

/******************************************************************************/

#endif	/* _SYSTEM_HEADERS_H */
