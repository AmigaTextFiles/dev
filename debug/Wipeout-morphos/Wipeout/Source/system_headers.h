/*
 * $Id: system_headers.h,v 1.1 2005/12/21 19:48:23 itix Exp $
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
#include <exec/libraries.h>
#include <exec/rawfmt.h>

#include <devices/timer.h>

#include <dos/dosextens.h>
#include <dos/dostags.h>
#include <dos/rdargs.h>

#include <proto/utility.h>
#include <proto/timer.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/alib.h>

/******************************************************************************/

#define USE_BUILTIN_MATH
#include <string.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdlib.h>

/******************************************************************************/

#endif	/* _SYSTEM_HEADERS_H */
