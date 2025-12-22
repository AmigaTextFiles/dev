/*
 * $Id: system_headers.h 1.3 1998/04/12 17:30:05 olsen Exp olsen $
 *
 * :ts=4
 *
 * Wipeout -- Traces and munges memory and detects memory trashing
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 * Public Domain
 */

#ifndef _SYSTEM_HEADERS_H
#define _SYSTEM_HEADERS_H 1

/******************************************************************************/

#include <exec/execbase.h>
#include <exec/memory.h>
#include <exec/libraries.h>

#include <devices/timer.h>

#include <dos/dosextens.h>
#include <dos/dostags.h>
#include <dos/rdargs.h>

#include <clib/utility_protos.h>
#include <clib/timer_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/alib_protos.h>

#include <pragmas/exec_sysbase_pragmas.h>
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
